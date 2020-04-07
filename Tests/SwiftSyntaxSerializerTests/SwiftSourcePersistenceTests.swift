@testable import SwiftSourcePersistence
import XCTest
import class Foundation.Bundle

var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }


final class SwiftSourcePersistenceTests: XCTestCase {
    func testParseUnparseInvariant() throws {
        let source = #"""
        var optionalName: String? = "John Appleseed"
        var greeting = "Hello!"
        """#

        //TODO test
//        let sourceFixture = try String(contentsOf: productsDirectory.appendingPathComponent("SwiftPersistence.swift"), encoding: .utf8)
//        print(sourceFixture)

        XCTAssertEqual(try jsonToSwift(try swiftToJSON(source)), source)
    }

    func testParseCodeWithErrors() throws {
        let source = #"""
        The SwiftSyntax parser parse every text"
        """#

        XCTAssertNoThrow(try swiftToJSON(source))
    }

    func testUnsupportedParseUnparseCycleWithErrors() throws {
        let source = #"""
        The SwiftSyntax parser parse every text"
        """#

        XCTAssertThrowsError(try jsonToSwift(try swiftToJSON(source)), source)
    }

    static var allTests = [
        ("testParseUnparseInvariant", testParseUnparseInvariant),
        ("testParseCodeWithErrors", testParseCodeWithErrors),
        ("testUnsupportedParseUnparseCycleWithErrors", testUnsupportedParseUnparseCycleWithErrors),
    ]
}
