use std::process::Command;

use regex::Regex;

fn main() {
    let arg = std::env::args()
        .skip(1)
        .next()
        .expect("expected one argmuent");

    let re_file_or_url = Regex::new(r"^(https?|zotero):.*").unwrap();

    // Check if its a link
    if re_file_or_url.is_match(&arg) {
        // Open via web browser
        Command::new("cmd.exe")
            .arg("/c")
            .arg("start")
            .arg(&arg)
            .output()
            .unwrap();
        return;
    }

    let winfn = convert_filename_to_windows(&arg);

    Command::new("explorer.exe").arg(winfn).output().unwrap();
}

fn convert_filename_to_windows(file: &str) -> String {
    let mut file = file;

    static FILE_PREFIX: &str = "file://";
    if file.starts_with(FILE_PREFIX) {
        file = &file[FILE_PREFIX.len()..];
    }

    let out = Command::new("wslpath")
        .arg("-aw")
        .arg(file)
        .output()
        .unwrap();

    let s = String::from_utf8(out.stdout).unwrap();
    s.trim().to_string()
}
