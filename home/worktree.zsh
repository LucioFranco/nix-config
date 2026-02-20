# Helper: strip user prefix from branch name for worktree folder
# e.g. "lucio/eng-2109-fix" -> "eng-2109-fix", "eng-2109-fix" -> "eng-2109-fix"
_wt_folder() {
  local branch="$1"
  if [[ "$branch" == */* ]]; then
    echo "${branch#*/}"
  else
    echo "$branch"
  fi
}

# Helper: track branch with Graphite if gt is available
_wt_graphite_track() {
  if command -v gt >/dev/null 2>&1; then
    gt track --force 2>/dev/null
  fi
}

# Helper: set up direnv with nix flake support
_wt_direnv_setup() {
  if [[ ! -f .envrc ]]; then
    echo "use flake" > .envrc
  fi
  direnv allow
}

# Helper: setup a newly created worktree (graphite + direnv)
_wt_setup() {
  _wt_graphite_track
  _wt_direnv_setup
}

cdw() {
  if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    cat <<'HELP'
Usage: cdw [subcommand] [options] [query]

Git worktree manager. All worktrees live under work/ in the repo root.
Branch prefixes (e.g. "lucio/") are stripped from the folder name.
New worktrees get a .envrc with "use flake" and direnv is auto-allowed.
If Graphite (gt) is installed, new branches are automatically tracked.

Subcommands:
  cdw                        Interactive fzf picker (TREE/LOCAL/REMOTE)
  cdw <query>                Fzf picker pre-filtered by query
  cdw new <branch>           Create worktree with a new branch
  cdw new -l <id|url> <br>   Create worktree, open Claude with Linear context
  cdw rm [query]             Remove a worktree (fzf picker or by name)
  cdw ls                     List all active worktrees

The -l flag accepts a Linear issue ID (e.g. ENG-2109) or a full Linear URL.
When provided, Claude Code opens with the issue pulled in for context.

Picker entry types:
  TREE    Existing worktree — cd into it
  LOCAL   Local branch without a worktree — create one and cd into it
  REMOTE  Remote-only branch — create tracking branch + worktree

Requires: fzf, git, direnv
HELP
    return 0
  fi

  local repo_root
  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "Not in a git repo"; return 1; }
  cd "$repo_root" || return 1

  case "$1" in
    new)    _cdw_new "${@:2}" ;;
    rm)     _cdw_rm "${@:2}" ;;
    ls)     _cdw_ls ;;
    *)      _cdw_pick "$@" ;;
  esac
}

_cdw_new() {
  local linear_ref=""

  # Parse -l flag
  if [[ "$1" == "-l" ]]; then
    linear_ref="$2"
    if [[ -z "$linear_ref" ]]; then
      echo "Usage: cdw new -l <issue-id|url> <branch>"
      return 1
    fi
    shift 2
  fi

  local branch="$1"
  if [[ -z "$branch" ]]; then
    echo "Usage: cdw new [-l <issue-id|url>] <branch>"
    return 1
  fi

  local folder=$(_wt_folder "$branch")
  git worktree add "work/$folder" -b "$branch" || return 1
  cd "work/$folder" || return 1
  _wt_setup

  if [[ -n "$linear_ref" ]]; then
    local issue_context
    issue_context="$(linear issue get "$linear_ref" 2>&1)" || {
      echo "Failed to fetch Linear issue: $linear_ref"
      return 1
    }
    claude "Here is the Linear issue for context:

$issue_context

Summarize the issue and begin working on it."
  fi
}

_cdw_rm() {
  local query="$*"
  local -a worktrees
  local wt_branch wt_path

  while IFS=$'\t' read -r wt_branch wt_path; do
    worktrees+=("$wt_branch"$'\t'"$wt_path")
  done < <(
    git worktree list --porcelain | awk '
      /^worktree / { wt=$2; next }
      /^branch refs\/heads\// {
        br=$2; sub(/^refs\/heads\//, "", br)
        printf "%s\t%s\n", br, wt
      }'
  )

  # Skip the main worktree (first entry is the repo root itself)
  if [[ ${#worktrees[@]} -eq 0 ]]; then
    echo "No worktrees to remove"
    return 1
  fi

  local selection
  selection="$(printf '%s\n' "${worktrees[@]}" \
    | fzf --delimiter=$'\t' --with-nth=1 \
           --height=80% --layout=reverse --prompt='cdw rm > ' \
           --query="$query")" || return 1

  IFS=$'\t' read -r wt_branch wt_path <<< "$selection"
  echo "Removing worktree: $wt_branch ($wt_path)"
  git worktree remove "$wt_path" || return 1
}

_cdw_ls() {
  git worktree list
}

_cdw_pick() {
  if ! command -v fzf >/dev/null 2>&1; then
    echo "cdw requires fzf"
    return 1
  fi

  local query="$*"
  local -a used_branches entries
  local b

  # Collect branches already in use by worktrees
  used_branches=("${(@f)$(git worktree list --porcelain \
    | awk '/^branch /{sub(/^refs\/heads\//, "", $2); print $2}')}")

  typeset -A used_map local_map

  for b in "${used_branches[@]}"; do used_map["$b"]=1; done

  # Existing worktrees
  local wt_branch wt_path
  while IFS=$'\t' read -r wt_branch wt_path; do
    entries+=("TREE"$'\t'"$wt_branch"$'\t'"$wt_path")
  done < <(
    git worktree list --porcelain | awk '
      /^worktree / { wt=$2; next }
      /^branch refs\/heads\// {
        br=$2; sub(/^refs\/heads\//, "", br)
        printf "%s\t%s\n", br, wt
      }'
  )

  # Local branches not already in a worktree
  local -a local_branches
  local_branches=("${(@f)$(git for-each-ref --format='%(refname:short)' refs/heads)}")
  for b in "${local_branches[@]}"; do local_map["$b"]=1; done

  for b in "${local_branches[@]}"; do
    [[ -n "${used_map[$b]}" ]] && continue
    local folder=$(_wt_folder "$b")
    entries+=("LOCAL"$'\t'"$b"$'\t'"work/$folder")
  done

  # Remote branches without a local branch
  local -a remote_branches
  remote_branches=("${(@f)$(git for-each-ref --format='%(refname:short)' refs/remotes/origin \
    | sed '/^origin\/HEAD$/d; /^origin$/d; s#^origin/##')}")

  for b in "${remote_branches[@]}"; do
    [[ -n "${local_map[$b]}" ]] && continue
    local folder=$(_wt_folder "$b")
    entries+=("REMOTE"$'\t'"$b"$'\t'"work/$folder")
  done

  if [[ ${#entries[@]} -eq 0 ]]; then
    echo "No worktrees or branches found"
    return 1
  fi

  # Build display lines with aligned columns
  local entry row_kind row_branch row_target display_target branch_width=0
  for entry in "${entries[@]}"; do
    IFS=$'\t' read -r row_kind row_branch row_target <<< "$entry"
    (( ${#row_branch} > branch_width )) && branch_width=${#row_branch}
  done
  (( branch_width < 24 )) && branch_width=24

  local -a display_entries
  for entry in "${entries[@]}"; do
    IFS=$'\t' read -r row_kind row_branch row_target <<< "$entry"
    if [[ "$row_kind" == "TREE" ]]; then
      display_target="${row_target/#$HOME\//~/}"
    else
      display_target="create -> $row_target"
    fi
    local display_line="$(printf '%-6s  %-*s  %s' "$row_kind" "$branch_width" "$row_branch" "$display_target")"
    display_entries+=("$row_kind"$'\t'"$row_branch"$'\t'"$row_target"$'\t'"$display_line")
  done

  local selection kind branch target
  selection="$(printf '%s\n' "${display_entries[@]}" \
    | fzf --delimiter=$'\t' --with-nth=4 --nth=4 \
           --height=80% --layout=reverse --prompt='cdw > ' \
           --query="$query")" || return 1

  IFS=$'\t' read -r kind branch target _ <<< "$selection"

  case "$kind" in
    TREE)
      cd "$target" || return 1
      ;;
    LOCAL)
      local folder=$(_wt_folder "$branch")
      git worktree add "work/$folder" "$branch" || return 1
      cd "work/$folder" || return 1
      _wt_setup
      ;;
    REMOTE)
      local folder=$(_wt_folder "$branch")
      git worktree add --track -b "$branch" "work/$folder" "origin/$branch" || return 1
      cd "work/$folder" || return 1
      _wt_setup
      ;;
    *)
      echo "Invalid selection"
      return 1
      ;;
  esac
}
