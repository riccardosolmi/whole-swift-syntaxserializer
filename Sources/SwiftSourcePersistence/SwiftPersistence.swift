import Foundation
import SwiftSyntax
import SwiftFormat
import SwiftFormatConfiguration

public func swiftToJSON(_ input: String) throws -> String {
    let syntax = try SyntaxParser.parse(source: input)
    var visitor = SwiftSyntaxToJSONVisitor()
    let jsonData = try visitor.data(withSyntaxNode: syntax, options: [.prettyPrinted])
    return String(bytes: jsonData, encoding: .utf8)!
}

public func swiftToJSON<Output: TextOutputStream>(_ input: String, to outputStream: inout Output) throws {
    outputStream.write(try swiftToJSON(input))
}

public func jsonToSwift(_ input: String) throws -> String {
    var output = ""
    try jsonToSwift(input, to: &output)
    return output
}

public func jsonToSwift<Output: TextOutputStream>(_ input: String, to outputStream: inout Output) throws {
    let factory = JSONToSwiftSyntaxFactory()
    let syntax = try factory.jsonObject(with: input.data(using: .utf8)!)
    syntax?.write(to: &outputStream)
}

public func jsonToFormattedSwift(_ input: String) throws -> String {
    var output = ""
    try jsonToFormattedSwift(input, to: &output)
    return output
}

public func jsonToFormattedSwift<Output: TextOutputStream>(_ input: String, to outputStream: inout Output) throws {
    let factory = JSONToSwiftSyntaxFactory()
    let syntax = try factory.jsonObject(with: input.data(using: .utf8)!)
    let formatter = SwiftFormatter(configuration: Configuration())
    try formatter.format(syntax: syntax as! SourceFileSyntax, assumingFileURL: nil, to: &outputStream)
}
