import Foundation

let help = """
usage: tre [option] [path]

Print files, directories, and symlinks in tree form.
Hidden files and those configured to be ignored by git will be (optionally) ignored.

options:
  -a --all      Print all files and directories, including hidden ones.
  -s --simple   Use normal print despite gitignore settings. '-a' has higher priority.
  -h --help     Show this help message.
  -v --version  Show version.

Project home page: https://github.com/dduan/tre
"""

func showHelp() {
    print(help)
    exit(0)
}