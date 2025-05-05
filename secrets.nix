let
  systems = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILLyybh9wu68bFAWE2N2Q0MVa/q38T08de0fzgDqan3Q"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMlNhZ2sZv0tgGXJ73vC9r7TvlSzFLPmnn5NMbEkoQlB"
  ];
in
{
  "home/atuin/key.age".publicKeys = systems;
}
