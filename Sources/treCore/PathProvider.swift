import Pathos
import Foundation

public func paths(inDirectory root: String, includeHiddenFiles: Bool) throws -> [String] {
    var remains = [root]
    var results = [String]()

    func ignoreHidden(_ path: String) -> Bool {
        return includeHiddenFiles || !split(path: path).1.hasPrefix(".")
    }

    while !remains.isEmpty {
        let path = remains.removeFirst()
        let childDirectories = try directories(inPath: path).filter(ignoreHidden)
        let childFiles = try files(inPath: path).filter(ignoreHidden)
        let childSymbols = try symbolicLinks(inPath: path).filter(ignoreHidden)

        results += childDirectories + childFiles + childSymbols
        remains += childDirectories
    }

    return results.sorted()
}

public func gitFiles(inDirectory root: String, gitArguments: [String]) -> [String]? {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = ["git", "ls-files", root] + gitArguments

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    task.waitUntilExit()

    if task.terminationStatus == 0 {
        let output = String(data: data, encoding: .utf8)
        return output?.split(separator: "\n").map(String.init) ?? []
    } else {
        return nil
    }
}