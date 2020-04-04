import Foundation
import ArgumentParser
import SwiftSyntax
import SwiftFormat
import SwiftFormatConfiguration


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

    @Argument(help: "parse - Parse Swift to JSON; unparse - Unparse JSON to Swift; format - Format JSON to Swift")
    var mode: Mode

    func run() throws {
        var data: Data
        var input: String = ""
        repeat {
            data = FileHandle.standardInput.availableData
            input += String(data: data, encoding: .utf8)!
        } while (data.count > 0)

        switch (mode) {
        case .parse:
            let syntax = try SyntaxParser.parse(source: input)
            var visitor = SwiftSyntaxToJSONVisitor()
            let jsonData = try visitor.data(withSyntaxNode: syntax, options: [.prettyPrinted])
            print(String(bytes: jsonData, encoding: .utf8)!)

        case .unparse:
            let factory = JSONToSwiftSyntaxFactory()
            let syntax = try factory.jsonObject(with: input.data(using: .utf8)!)
            print(syntax!)

        case .format:
            let factory = JSONToSwiftSyntaxFactory()
            let syntax = try factory.jsonObject(with: input.data(using: .utf8)!)
            let formatter = SwiftFormatter(configuration: Configuration())
            var standardOutput = FileHandle.standardOutput
            try formatter.format(syntax: syntax as! SourceFileSyntax, assumingFileURL: nil, to: &standardOutput)
        }
    }
}

SwiftSyntaxSerializer.main()
