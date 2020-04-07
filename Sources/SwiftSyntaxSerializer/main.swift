import Foundation
import ArgumentParser
import SwiftSourcePersistence


extension FileHandle : TextOutputStream {
    public func write(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.write(data)
    }
}

enum Mode: String, ExpressibleByArgument {
    case parse, unparse, format
}

struct SwiftSyntaxSerializer: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Parse/unparse Swift source code to Whole JSON-LD",
        discussion: """

            """)

    @Flag(name: .shortAndLong, help: "Print version information and exit")
    var version: Bool
    
    @Argument(default: .parse, help: "Select the transformation to apply: parse, unparse, or format")
    var mode: Mode

    func run() throws {
        if (version) {
            print("SwiftSyntaxSerializer version 1.1.0")
            throw ExitCode.success
        }

        var data: Data
        var input: String = ""
        repeat {
            data = FileHandle.standardInput.availableData
            input += String(data: data, encoding: .utf8)!
        } while (data.count > 0)

        var standardOutput = FileHandle.standardOutput

        switch (mode) {
        case .parse:
            try swiftToJSON(input, to: &standardOutput)

        case .unparse:
            try jsonToSwift(input, to: &standardOutput)

        case .format:
            try jsonToFormattedSwift(input, to: &standardOutput)
        }
    }
}

SwiftSyntaxSerializer.main()
