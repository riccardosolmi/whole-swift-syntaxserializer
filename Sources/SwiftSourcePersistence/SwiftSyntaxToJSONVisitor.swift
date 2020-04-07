import Foundation
import SwiftSyntax

public struct SwiftSyntaxToJSONVisitor: SyntaxVisitor {
    let languageUri = "whole:org.whole.lang.swiftsyntax:SwiftSyntaxModel"
    let resolver: [String: Any] = [ "@type": "http://lang.whole.org/Commons#Resolver" ]

    var nodeDictionary: [String: Any]?

    public mutating func data(withSyntaxNode node: Syntax, options: JSONSerialization.WritingOptions = []) throws -> Data {
        node.walk(&self)
        return try JSONSerialization.data(withJSONObject: nodeDictionary as Any, options: options)
    }

    mutating func visitOptionalSyntax(_ node: Syntax?) {
        if let child = node {
            child.walk(&self)
        } else {
            self.nodeDictionary = resolver
        }
    }

    mutating func visitListSyntax(_ node: Syntax, entityType: String) {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#" + entityType
        var array = [Any]()
        for child in node.children {
            child.walk(&self)
            array.append(nodeDictionary as Any)
        }
        dictionary["@list"] = array
        self.nodeDictionary = dictionary
    }

    mutating func visitText(_ text: String) {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#Text"
        dictionary["@value"] = text
        self.nodeDictionary = dictionary
    }
    
    mutating func visitSourcePresence(_ present: Bool) {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#SourcePresence"
        dictionary["@value"] = present ? "present" : "missing"
        self.nodeDictionary = dictionary
    }

    mutating func visitTokenKind(_ kind: TokenKind) {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#TokenKind"
        switch kind {
        case .eof:
            dictionary["@value"] = "eof"
        case .associatedtypeKeyword:
            dictionary["@value"] = "associatedtypeKeyword"
        case .classKeyword:
            dictionary["@value"] = "classKeyword"
        case .deinitKeyword:
            dictionary["@value"] = "deinitKeyword"
        case .enumKeyword:
            dictionary["@value"] = "enumKeyword"
        case .extensionKeyword:
            dictionary["@value"] = "extensionKeyword"
        case .funcKeyword:
            dictionary["@value"] = "funcKeyword"
        case .importKeyword:
            dictionary["@value"] = "importKeyword"
        case .initKeyword:
            dictionary["@value"] = "initKeyword"
        case .inoutKeyword:
            dictionary["@value"] = "inoutKeyword"
        case .letKeyword:
            dictionary["@value"] = "letKeyword"
        case .operatorKeyword:
            dictionary["@value"] = "operatorKeyword"
        case .precedencegroupKeyword:
            dictionary["@value"] = "precedencegroupKeyword"
        case .protocolKeyword:
            dictionary["@value"] = "protocolKeyword"
        case .structKeyword:
            dictionary["@value"] = "structKeyword"
        case .subscriptKeyword:
            dictionary["@value"] = "subscriptKeyword"
        case .typealiasKeyword:
            dictionary["@value"] = "typealiasKeyword"
        case .varKeyword:
            dictionary["@value"] = "varKeyword"
        case .fileprivateKeyword:
            dictionary["@value"] = "fileprivateKeyword"
        case .internalKeyword:
            dictionary["@value"] = "internalKeyword"
        case .privateKeyword:
            dictionary["@value"] = "privateKeyword"
        case .publicKeyword:
            dictionary["@value"] = "publicKeyword"
        case .staticKeyword:
            dictionary["@value"] = "staticKeyword"
        case .deferKeyword:
            dictionary["@value"] = "deferKeyword"
        case .ifKeyword:
            dictionary["@value"] = "ifKeyword"
        case .guardKeyword:
            dictionary["@value"] = "guardKeyword"
        case .doKeyword:
            dictionary["@value"] = "doKeyword"
        case .repeatKeyword:
            dictionary["@value"] = "repeatKeyword"
        case .elseKeyword:
            dictionary["@value"] = "elseKeyword"
        case .forKeyword:
            dictionary["@value"] = "forKeyword"
        case .inKeyword:
            dictionary["@value"] = "inKeyword"
        case .whileKeyword:
            dictionary["@value"] = "whileKeyword"
        case .returnKeyword:
            dictionary["@value"] = "returnKeyword"
        case .breakKeyword:
            dictionary["@value"] = "breakKeyword"
        case .continueKeyword:
            dictionary["@value"] = "continueKeyword"
        case .fallthroughKeyword:
            dictionary["@value"] = "fallthroughKeyword"
        case .switchKeyword:
            dictionary["@value"] = "switchKeyword"
        case .caseKeyword:
            dictionary["@value"] = "caseKeyword"
        case .defaultKeyword:
            dictionary["@value"] = "defaultKeyword"
        case .whereKeyword:
            dictionary["@value"] = "whereKeyword"
        case .catchKeyword:
            dictionary["@value"] = "catchKeyword"
        case .throwKeyword:
            dictionary["@value"] = "throwKeyword"
        case .asKeyword:
            dictionary["@value"] = "asKeyword"
        case .anyKeyword:
            dictionary["@value"] = "anyKeyword"
        case .falseKeyword:
            dictionary["@value"] = "falseKeyword"
        case .isKeyword:
            dictionary["@value"] = "isKeyword"
        case .nilKeyword:
            dictionary["@value"] = "nilKeyword"
        case .rethrowsKeyword:
            dictionary["@value"] = "rethrowsKeyword"
        case .superKeyword:
            dictionary["@value"] = "superKeyword"
        case .selfKeyword:
            dictionary["@value"] = "selfKeyword"
        case .capitalSelfKeyword:
            dictionary["@value"] = "capitalSelfKeyword"
        case .trueKeyword:
            dictionary["@value"] = "trueKeyword"
        case .tryKeyword:
            dictionary["@value"] = "tryKeyword"
        case .throwsKeyword:
            dictionary["@value"] = "throwsKeyword"
        case .__file__Keyword:
            dictionary["@value"] = "__file__Keyword"
        case .__line__Keyword:
            dictionary["@value"] = "__line__Keyword"
        case .__column__Keyword:
            dictionary["@value"] = "__column__Keyword"
        case .__function__Keyword:
            dictionary["@value"] = "__function__Keyword"
        case .__dso_handle__Keyword:
            dictionary["@value"] = "__dso_handle__Keyword"
        case .wildcardKeyword:
            dictionary["@value"] = "wildcardKeyword"
        case .leftParen:
            dictionary["@value"] = "leftParen"
        case .rightParen:
            dictionary["@value"] = "rightParen"
        case .leftBrace:
            dictionary["@value"] = "leftBrace"
        case .rightBrace:
            dictionary["@value"] = "rightBrace"
        case .leftSquareBracket:
            dictionary["@value"] = "leftSquareBracket"
        case .rightSquareBracket:
            dictionary["@value"] = "rightSquareBracket"
        case .leftAngle:
            dictionary["@value"] = "leftAngle"
        case .rightAngle:
            dictionary["@value"] = "rightAngle"
        case .period:
            dictionary["@value"] = "period"
        case .prefixPeriod:
            dictionary["@value"] = "prefixPeriod"
        case .comma:
            dictionary["@value"] = "comma"
        case .ellipsis:
            dictionary["@value"] = "ellipsis"
        case .colon:
            dictionary["@value"] = "colon"
        case .semicolon:
            dictionary["@value"] = "semicolon"
        case .equal:
            dictionary["@value"] = "equal"
        case .atSign:
            dictionary["@value"] = "atSign"
        case .pound:
            dictionary["@value"] = "pound"
        case .prefixAmpersand:
            dictionary["@value"] = "prefixAmpersand"
        case .arrow:
            dictionary["@value"] = "arrow"
        case .backtick:
            dictionary["@value"] = "backtick"
        case .backslash:
            dictionary["@value"] = "backslash"
        case .exclamationMark:
            dictionary["@value"] = "exclamationMark"
        case .postfixQuestionMark:
            dictionary["@value"] = "postfixQuestionMark"
        case .infixQuestionMark:
            dictionary["@value"] = "infixQuestionMark"
        case .stringQuote:
            dictionary["@value"] = "stringQuote"
        case .singleQuote:
            dictionary["@value"] = "singleQuote"
        case .multilineStringQuote:
            dictionary["@value"] = "multilineStringQuote"
        case .poundKeyPathKeyword:
            dictionary["@value"] = "poundKeyPathKeyword"
        case .poundLineKeyword:
            dictionary["@value"] = "poundLineKeyword"
        case .poundSelectorKeyword:
            dictionary["@value"] = "poundSelectorKeyword"
        case .poundFileKeyword:
            dictionary["@value"] = "poundFileKeyword"
        case .poundColumnKeyword:
            dictionary["@value"] = "poundColumnKeyword"
        case .poundFunctionKeyword:
            dictionary["@value"] = "poundFunctionKeyword"
        case .poundDsohandleKeyword:
            dictionary["@value"] = "poundDsohandleKeyword"
        case .poundAssertKeyword:
            dictionary["@value"] = "poundAssertKeyword"
        case .poundSourceLocationKeyword:
            dictionary["@value"] = "poundSourceLocationKeyword"
        case .poundWarningKeyword:
            dictionary["@value"] = "poundWarningKeyword"
        case .poundErrorKeyword:
            dictionary["@value"] = "poundErrorKeyword"
        case .poundIfKeyword:
            dictionary["@value"] = "poundIfKeyword"
        case .poundElseKeyword:
            dictionary["@value"] = "poundElseKeyword"
        case .poundElseifKeyword:
            dictionary["@value"] = "poundElseifKeyword"
        case .poundEndifKeyword:
            dictionary["@value"] = "poundEndifKeyword"
        case .poundAvailableKeyword:
            dictionary["@value"] = "poundAvailableKeyword"
        case .poundFileLiteralKeyword:
            dictionary["@value"] = "poundFileLiteralKeyword"
        case .poundImageLiteralKeyword:
            dictionary["@value"] = "poundImageLiteralKeyword"
        case .poundColorLiteralKeyword:
            dictionary["@value"] = "poundColorLiteralKeyword"
        case .integerLiteral:
            dictionary["@value"] = "integerLiteral"
        case .floatingLiteral:
            dictionary["@value"] = "floatingLiteral"
        case .stringLiteral:
            dictionary["@value"] = "stringLiteral"
        case .unknown:
            dictionary["@value"] = "unknown"
        case .identifier:
            dictionary["@value"] = "identifier"
        case .unspacedBinaryOperator:
            dictionary["@value"] = "unspacedBinaryOperator"
        case .spacedBinaryOperator:
            dictionary["@value"] = "spacedBinaryOperator"
        case .postfixOperator:
            dictionary["@value"] = "postfixOperator"
        case .prefixOperator:
            dictionary["@value"] = "prefixOperator"
        case .dollarIdentifier:
            dictionary["@value"] = "dollarIdentifier"
        case .contextualKeyword:
            dictionary["@value"] = "contextualKeyword"
        case .rawStringDelimiter:
            dictionary["@value"] = "rawStringDelimiter"
        case .stringSegment:
            dictionary["@value"] = "stringSegment"
        case .stringInterpolationAnchor:
            dictionary["@value"] = "stringInterpolationAnchor"
        case .yield:
            dictionary["@value"] = "yield"
        }
        self.nodeDictionary = dictionary
    }

    mutating func visitTrivia(_ trivia: Trivia) {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#Trivia"
        var array = [Any]()
        for child in trivia {
            visitTriviaPiece(child)
            array.append(nodeDictionary as Any)
        }
        dictionary["@list"] = array
        self.nodeDictionary = dictionary
    }
    
    mutating func visitTriviaPiece(_ piece: TriviaPiece) {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#TriviaPiece"
        switch piece {
        case .blockComment(let comment),
             .lineComment(let comment),
             .docBlockComment(let comment),
             .docLineComment(let comment):
            dictionary["@value"] = comment
        case .garbageText(let text):
            dictionary["@value"] = "\(text)"
        case .formfeeds(let count):
            dictionary["@value"] = String(repeating: "\u{000c}", count: count)
        case .backticks(let count):
            dictionary["@value"] = String(repeating: "`", count: count)
        case .newlines(let count):
            dictionary["@value"] = String(repeating: "\n", count: count)
        case .carriageReturns(let count):
            dictionary["@value"] = String(repeating: "\r", count: count)
        case .carriageReturnLineFeeds(let count):
            dictionary["@value"] = String(repeating: "\r\n", count: count)
        case .spaces(let count):
            dictionary["@value"] = String(repeating: " ", count: count)
        case .tabs(let count):
            dictionary["@value"] = String(repeating: "\t", count: count)
        case .verticalTabs(let count):
            dictionary["@value"] = String(repeating: "\u{000b}", count: count)
        }
        self.nodeDictionary = dictionary
    }

    @discardableResult
    public mutating func visit(_ node: UnknownDeclSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "UnknownDecl")
        return .skipChildren 
    }
    @discardableResult
    public mutating func visit(_ node: UnknownExprSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "UnknownExpr")
        return .skipChildren 
    }
    @discardableResult
    public mutating func visit(_ node: UnknownPatternSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "UnknownPattern")
        return .skipChildren 
    }
    @discardableResult
    public mutating func visit(_ node: UnknownStmtSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "UnknownStmt")
        return .skipChildren 
    }
    @discardableResult
    public mutating func visit(_ node: UnknownTypeSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "UnknowType")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TokenSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#Token"
        visitTokenKind(node.tokenKind)
        dictionary["kind"] = nodeDictionary
        visitSourcePresence(node.isPresent)
        dictionary["presence"] = nodeDictionary
        visitTrivia(node.leadingTrivia)
        dictionary["leadingTrivia"] = nodeDictionary
        visitTrivia(node.trailingTrivia)
        dictionary["trailingTrivia"] = nodeDictionary
        visitText(node.text)
        dictionary["text"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: CodeBlockItemSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#CodeBlockItem"
        node.item.walk(&self)
        dictionary["item"] = nodeDictionary
        visitOptionalSyntax(node.semicolon)
        dictionary["semicolon"] = nodeDictionary
        visitOptionalSyntax(node.errorTokens)
        dictionary["errorTokens"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: CodeBlockItemListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "CodeBlockItemList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: CodeBlockSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#CodeBlock"
        node.leftBrace.walk(&self)
        dictionary["leftBrace"] = nodeDictionary
        node.statements.walk(&self)
        dictionary["statements"] = nodeDictionary
        node.rightBrace.walk(&self)
        dictionary["rightBrace"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: InOutExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#InOutExpr"
        node.ampersand.walk(&self)
        dictionary["ampersand"] = nodeDictionary
        node.expression.walk(&self)
        dictionary["expression"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PoundColumnExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PoundColumnExpr"
        node.poundColumn.walk(&self)
        dictionary["poundColumn"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: FunctionCallArgumentListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "FunctionCallArgumentList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TupleElementListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "TupleElementList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ArrayElementListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "ArrayElementList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: DictionaryElementListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "DictionaryElementList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: StringLiteralSegmentsSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "StringLiteralSegments")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TryExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#TryExpr"
        node.tryKeyword.walk(&self)
        dictionary["tryKeyword"] = nodeDictionary
        visitOptionalSyntax(node.questionOrExclamationMark)
        dictionary["questionOrExclamationMark"] = nodeDictionary
        node.expression.walk(&self)
        dictionary["expression"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: DeclNameArgumentSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#DeclNameArgument"
        node.name.walk(&self)
        dictionary["name"] = nodeDictionary
        node.colon.walk(&self)
        dictionary["colon"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: DeclNameArgumentListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "DeclNameArgumentList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: DeclNameArgumentsSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#DeclNameArguments"
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        node.arguments.walk(&self)
        dictionary["arguments"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: IdentifierExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#IdentifierExpr"
        node.identifier.walk(&self)
        dictionary["identifier"] = nodeDictionary
        visitOptionalSyntax(node.declNameArguments)
        dictionary["declNameArguments"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SuperRefExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#SuperRefExpr"
        node.superKeyword.walk(&self)
        dictionary["superKeyword"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: NilLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#NilLiteralExpr"
        node.nilKeyword.walk(&self)
        dictionary["nilKeyword"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: DiscardAssignmentExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#DiscardAssignmentExpr"
        node.wildcard.walk(&self)
        dictionary["wildcard"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AssignmentExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#AssignmentExpr"
        node.assignToken.walk(&self)
        dictionary["assignToken"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#SequenceExpr"
        node.elements.walk(&self)
        dictionary["elements"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ExprListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "ExprList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PoundLineExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PoundLineExpr"
        node.poundLine.walk(&self)
        dictionary["poundLine"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PoundFileExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PoundFileExpr"
        node.poundFile.walk(&self)
        dictionary["poundFile"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PoundFunctionExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PoundFunctionExpr"
        node.poundFunction.walk(&self)
        dictionary["poundFunction"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PoundDsohandleExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PoundDsohandleExpr"
        node.poundDsohandle.walk(&self)
        dictionary["poundDsohandle"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SymbolicReferenceExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#SymbolicReferenceExpr"
        node.identifier.walk(&self)
        dictionary["identifier"] = nodeDictionary
        visitOptionalSyntax(node.genericArgumentClause)
        dictionary["genericArgumentClause"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PrefixOperatorExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PrefixOperatorExpr"
        visitOptionalSyntax(node.operatorToken)
        dictionary["operatorToken"] = nodeDictionary
        node.postfixExpression.walk(&self)
        dictionary["postfixExpression"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: BinaryOperatorExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#BinaryOperatorExpr"
        node.operatorToken.walk(&self)
        dictionary["operatorToken"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ArrowExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ArrowExpr"
        visitOptionalSyntax(node.throwsToken)
        dictionary["throwsToken"] = nodeDictionary
        node.arrowToken.walk(&self)
        dictionary["arrowToken"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: FloatLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#FloatLiteralExpr"
        node.floatingDigits.walk(&self)
        dictionary["floatingDigits"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TupleExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#TupleExpr"
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        node.elementList.walk(&self)
        dictionary["elementList"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ArrayExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ArrayExpr"
        node.leftSquare.walk(&self)
        dictionary["leftSquare"] = nodeDictionary
        node.elements.walk(&self)
        dictionary["elements"] = nodeDictionary
        node.rightSquare.walk(&self)
        dictionary["rightSquare"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: DictionaryExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#DictionaryExpr"
        node.leftSquare.walk(&self)
        dictionary["leftSquare"] = nodeDictionary
        node.content.walk(&self)
        dictionary["content"] = nodeDictionary
        node.rightSquare.walk(&self)
        dictionary["rightSquare"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: FunctionCallArgumentSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#FunctionCallArgument"
        visitOptionalSyntax(node.label)
        dictionary["label"] = nodeDictionary
        visitOptionalSyntax(node.colon)
        dictionary["colon"] = nodeDictionary
        node.expression.walk(&self)
        dictionary["expression"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TupleElementSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#TupleElement"
        visitOptionalSyntax(node.label)
        dictionary["label"] = nodeDictionary
        visitOptionalSyntax(node.colon)
        dictionary["colon"] = nodeDictionary
        node.expression.walk(&self)
        dictionary["expression"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ArrayElementSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ArrayElement"
        node.expression.walk(&self)
        dictionary["expression"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: DictionaryElementSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#DictionaryElement"
        node.keyExpression.walk(&self)
        dictionary["keyExpression"] = nodeDictionary
        node.colon.walk(&self)
        dictionary["colon"] = nodeDictionary
        node.valueExpression.walk(&self)
        dictionary["valueExpression"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: IntegerLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#IntegerLiteralExpr"
        node.digits.walk(&self)
        dictionary["digits"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: BooleanLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#BooleanLiteralExpr"
        node.booleanLiteral.walk(&self)
        dictionary["booleanLiteral"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TernaryExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#TernaryExpr"
        node.conditionExpression.walk(&self)
        dictionary["conditionExpression"] = nodeDictionary
        node.questionMark.walk(&self)
        dictionary["questionMark"] = nodeDictionary
        node.firstChoice.walk(&self)
        dictionary["firstChoice"] = nodeDictionary
        node.colonMark.walk(&self)
        dictionary["colonMark"] = nodeDictionary
        node.secondChoice.walk(&self)
        dictionary["secondChoice"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#MemberAccessExpr"
        visitOptionalSyntax(node.base)
        dictionary["base"] = nodeDictionary
        node.dot.walk(&self)
        dictionary["dot"] = nodeDictionary
        node.name.walk(&self)
        dictionary["name"] = nodeDictionary
        visitOptionalSyntax(node.declNameArguments)
        dictionary["declNameArguments"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: IsExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#IsExpr"
        node.isTok.walk(&self)
        dictionary["isTok"] = nodeDictionary
        node.typeName.walk(&self)
        dictionary["typeName"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AsExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#AsExpr"
        node.asTok.walk(&self)
        dictionary["asTok"] = nodeDictionary
        visitOptionalSyntax(node.questionOrExclamationMark)
        dictionary["questionOrExclamationMark"] = nodeDictionary
        node.typeName.walk(&self)
        dictionary["typeName"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TypeExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#TypeExpr"
        node.type.walk(&self)
        dictionary["type"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ClosureCaptureItemSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ClosureCaptureItem"
        visitOptionalSyntax(node.specifier)
        dictionary["specifier"] = nodeDictionary
        visitOptionalSyntax(node.name)
        dictionary["name"] = nodeDictionary
        visitOptionalSyntax(node.assignToken)
        dictionary["assignToken"] = nodeDictionary
        node.expression.walk(&self)
        dictionary["expression"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ClosureCaptureItemListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "ClosureCaptureItemList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ClosureCaptureSignatureSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ClosureCaptureSignature"
        node.leftSquare.walk(&self)
        dictionary["leftSquare"] = nodeDictionary
        visitOptionalSyntax(node.items)
        dictionary["items"] = nodeDictionary
        node.rightSquare.walk(&self)
        dictionary["rightSquare"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ClosureParamSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ClosureParam"
        node.name.walk(&self)
        dictionary["name"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ClosureParamListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "ClosureParamList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ClosureSignatureSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ClosureSignature"
        visitOptionalSyntax(node.capture)
        dictionary["capture"] = nodeDictionary
        visitOptionalSyntax(node.input)
        dictionary["input"] = nodeDictionary
        visitOptionalSyntax(node.throwsTok)
        dictionary["throwsTok"] = nodeDictionary
        visitOptionalSyntax(node.output)
        dictionary["output"] = nodeDictionary
        node.inTok.walk(&self)
        dictionary["inTok"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ClosureExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ClosureExpr"
        node.leftBrace.walk(&self)
        dictionary["leftBrace"] = nodeDictionary
        visitOptionalSyntax(node.signature)
        dictionary["signature"] = nodeDictionary
        node.statements.walk(&self)
        dictionary["statements"] = nodeDictionary
        node.rightBrace.walk(&self)
        dictionary["rightBrace"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: UnresolvedPatternExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#UnresolvedPatternExpr"
        node.pattern.walk(&self)
        dictionary["pattern"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#FunctionCallExpr"
        node.calledExpression.walk(&self)
        dictionary["calledExpression"] = nodeDictionary
        visitOptionalSyntax(node.leftParen)
        dictionary["leftParen"] = nodeDictionary
        node.argumentList.walk(&self)
        dictionary["argumentList"] = nodeDictionary
        visitOptionalSyntax(node.rightParen)
        dictionary["rightParen"] = nodeDictionary
        visitOptionalSyntax(node.trailingClosure)
        dictionary["trailingClosure"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SubscriptExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#SubscriptExpr"
        node.calledExpression.walk(&self)
        dictionary["calledExpression"] = nodeDictionary
        node.leftBracket.walk(&self)
        dictionary["leftBracket"] = nodeDictionary
        node.argumentList.walk(&self)
        dictionary["argumentList"] = nodeDictionary
        node.rightBracket.walk(&self)
        dictionary["rightBracket"] = nodeDictionary
        visitOptionalSyntax(node.trailingClosure)
        dictionary["trailingClosure"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: OptionalChainingExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#OptionalChainingExpr"
        node.expression.walk(&self)
        dictionary["expression"] = nodeDictionary
        node.questionMark.walk(&self)
        dictionary["questionMark"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ForcedValueExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ForcedValueExpr"
        node.expression.walk(&self)
        dictionary["expression"] = nodeDictionary
        node.exclamationMark.walk(&self)
        dictionary["exclamationMark"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PostfixUnaryExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PostfixUnaryExpr"
        node.expression.walk(&self)
        dictionary["expression"] = nodeDictionary
        node.operatorToken.walk(&self)
        dictionary["operatorToken"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SpecializeExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#SpecializeExpr"
        node.expression.walk(&self)
        dictionary["expression"] = nodeDictionary
        node.genericArgumentClause.walk(&self)
        dictionary["genericArgumentClause"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: StringSegmentSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#StringSegment"
        node.content.walk(&self)
        dictionary["content"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ExpressionSegmentSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ExpressionSegment"
        node.backslash.walk(&self)
        dictionary["backslash"] = nodeDictionary
        visitOptionalSyntax(node.delimiter)
        dictionary["delimiter"] = nodeDictionary
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        node.expressions.walk(&self)
        dictionary["expressions"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: StringLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#StringLiteralExpr"
        visitOptionalSyntax(node.openDelimiter)
        dictionary["openDelimiter"] = nodeDictionary
        node.openQuote.walk(&self)
        dictionary["openQuote"] = nodeDictionary
        node.segments.walk(&self)
        dictionary["segments"] = nodeDictionary
        node.closeQuote.walk(&self)
        dictionary["closeQuote"] = nodeDictionary
        visitOptionalSyntax(node.closeDelimiter)
        dictionary["closeDelimiter"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: KeyPathExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#KeyPathExpr"
        node.backslash.walk(&self)
        dictionary["backslash"] = nodeDictionary
        visitOptionalSyntax(node.rootExpr)
        dictionary["rootExpr"] = nodeDictionary
        node.expression.walk(&self)
        dictionary["expression"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: KeyPathBaseExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#KeyPathBaseExpr"
        node.period.walk(&self)
        dictionary["period"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ObjcNamePieceSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ObjcNamePiece"
        node.name.walk(&self)
        dictionary["name"] = nodeDictionary
        visitOptionalSyntax(node.dot)
        dictionary["dot"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ObjcNameSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "ObjcName")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ObjcKeyPathExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ObjcKeyPathExpr"
        node.keyPath.walk(&self)
        dictionary["keyPath"] = nodeDictionary
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        node.name.walk(&self)
        dictionary["name"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ObjcSelectorExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ObjcSelectorExpr"
        node.poundSelector.walk(&self)
        dictionary["poundSelector"] = nodeDictionary
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        visitOptionalSyntax(node.kind)
        dictionary["kind"] = nodeDictionary
        visitOptionalSyntax(node.colon)
        dictionary["colon"] = nodeDictionary
        node.name.walk(&self)
        dictionary["name"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: EditorPlaceholderExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#EditorPlaceholderExpr"
        node.identifier.walk(&self)
        dictionary["identifier"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ObjectLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ObjectLiteralExpr"
        node.identifier.walk(&self)
        dictionary["identifier"] = nodeDictionary
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        node.arguments.walk(&self)
        dictionary["arguments"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TypeInitializerClauseSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#TypeInitializerClause"
        node.equal.walk(&self)
        dictionary["equal"] = nodeDictionary
        node.value.walk(&self)
        dictionary["value"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TypealiasDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#TypealiasDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.typealiasKeyword.walk(&self)
        dictionary["typealiasKeyword"] = nodeDictionary
        node.identifier.walk(&self)
        dictionary["identifier"] = nodeDictionary
        visitOptionalSyntax(node.genericParameterClause)
        dictionary["genericParameterClause"] = nodeDictionary
        visitOptionalSyntax(node.initializer)
        dictionary["initializer"] = nodeDictionary
        visitOptionalSyntax(node.genericWhereClause)
        dictionary["genericWhereClause"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AssociatedtypeDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#AssociatedtypeDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.associatedtypeKeyword.walk(&self)
        dictionary["associatedtypeKeyword"] = nodeDictionary
        node.identifier.walk(&self)
        dictionary["identifier"] = nodeDictionary
        visitOptionalSyntax(node.inheritanceClause)
        dictionary["inheritanceClause"] = nodeDictionary
        visitOptionalSyntax(node.initializer)
        dictionary["initializer"] = nodeDictionary
        visitOptionalSyntax(node.genericWhereClause)
        dictionary["genericWhereClause"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: FunctionParameterListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "FunctionParameterList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ParameterClauseSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ParameterClause"
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        node.parameterList.walk(&self)
        dictionary["parameterList"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ReturnClauseSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ReturnClause"
        node.arrow.walk(&self)
        dictionary["arrow"] = nodeDictionary
        node.returnType.walk(&self)
        dictionary["returnType"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: FunctionSignatureSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#FunctionSignature"
        node.input.walk(&self)
        dictionary["input"] = nodeDictionary
        visitOptionalSyntax(node.throwsOrRethrowsKeyword)
        dictionary["throwsOrRethrowsKeyword"] = nodeDictionary
        visitOptionalSyntax(node.output)
        dictionary["output"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: IfConfigClauseSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#IfConfigClause"
        node.poundKeyword.walk(&self)
        dictionary["poundKeyword"] = nodeDictionary
        visitOptionalSyntax(node.condition)
        dictionary["condition"] = nodeDictionary
        node.elements.walk(&self)
        dictionary["elements"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: IfConfigClauseListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "IfConfigClauseList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: IfConfigDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#IfConfigDecl"
        node.clauses.walk(&self)
        dictionary["clauses"] = nodeDictionary
        node.poundEndif.walk(&self)
        dictionary["poundEndif"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PoundErrorDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PoundErrorDecl"
        node.poundError.walk(&self)
        dictionary["poundError"] = nodeDictionary
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        node.message.walk(&self)
        dictionary["message"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PoundWarningDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PoundWarningDecl"
        node.poundWarning.walk(&self)
        dictionary["poundWarning"] = nodeDictionary
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        node.message.walk(&self)
        dictionary["message"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PoundSourceLocationSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PoundSourceLocation"
        node.poundSourceLocation.walk(&self)
        dictionary["poundSourceLocation"] = nodeDictionary
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        visitOptionalSyntax(node.args)
        dictionary["args"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PoundSourceLocationArgsSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PoundSourceLocationArgs"
        node.fileArgLabel.walk(&self)
        dictionary["fileArgLabel"] = nodeDictionary
        node.fileArgColon.walk(&self)
        dictionary["fileArgColon"] = nodeDictionary
        node.fileName.walk(&self)
        dictionary["fileName"] = nodeDictionary
        node.comma.walk(&self)
        dictionary["comma"] = nodeDictionary
        node.lineArgLabel.walk(&self)
        dictionary["lineArgLabel"] = nodeDictionary
        node.lineArgColon.walk(&self)
        dictionary["lineArgColon"] = nodeDictionary
        node.lineNumber.walk(&self)
        dictionary["lineNumber"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: DeclModifierSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#DeclModifier"
        node.name.walk(&self)
        dictionary["name"] = nodeDictionary
        visitOptionalSyntax(node.detailLeftParen)
        dictionary["detailLeftParen"] = nodeDictionary
        visitOptionalSyntax(node.detail)
        dictionary["detail"] = nodeDictionary
        visitOptionalSyntax(node.detailRightParen)
        dictionary["detailRightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: InheritedTypeSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#InheritedType"
        node.typeName.walk(&self)
        dictionary["typeName"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: InheritedTypeListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "InheritedTypeList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TypeInheritanceClauseSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#TypeInheritanceClause"
        node.colon.walk(&self)
        dictionary["colon"] = nodeDictionary
        node.inheritedTypeCollection.walk(&self)
        dictionary["inheritedTypeCollection"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ClassDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.classKeyword.walk(&self)
        dictionary["classKeyword"] = nodeDictionary
        node.identifier.walk(&self)
        dictionary["identifier"] = nodeDictionary
        visitOptionalSyntax(node.genericParameterClause)
        dictionary["genericParameterClause"] = nodeDictionary
        visitOptionalSyntax(node.inheritanceClause)
        dictionary["inheritanceClause"] = nodeDictionary
        visitOptionalSyntax(node.genericWhereClause)
        dictionary["genericWhereClause"] = nodeDictionary
        node.members.walk(&self)
        dictionary["members"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#StructDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.structKeyword.walk(&self)
        dictionary["structKeyword"] = nodeDictionary
        node.identifier.walk(&self)
        dictionary["identifier"] = nodeDictionary
        visitOptionalSyntax(node.genericParameterClause)
        dictionary["genericParameterClause"] = nodeDictionary
        visitOptionalSyntax(node.inheritanceClause)
        dictionary["inheritanceClause"] = nodeDictionary
        visitOptionalSyntax(node.genericWhereClause)
        dictionary["genericWhereClause"] = nodeDictionary
        node.members.walk(&self)
        dictionary["members"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ProtocolDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.protocolKeyword.walk(&self)
        dictionary["protocolKeyword"] = nodeDictionary
        node.identifier.walk(&self)
        dictionary["identifier"] = nodeDictionary
        visitOptionalSyntax(node.inheritanceClause)
        dictionary["inheritanceClause"] = nodeDictionary
        visitOptionalSyntax(node.genericWhereClause)
        dictionary["genericWhereClause"] = nodeDictionary
        node.members.walk(&self)
        dictionary["members"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ExtensionDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.extensionKeyword.walk(&self)
        dictionary["extensionKeyword"] = nodeDictionary
        node.extendedType.walk(&self)
        dictionary["extendedType"] = nodeDictionary
        visitOptionalSyntax(node.inheritanceClause)
        dictionary["inheritanceClause"] = nodeDictionary
        visitOptionalSyntax(node.genericWhereClause)
        dictionary["genericWhereClause"] = nodeDictionary
        node.members.walk(&self)
        dictionary["members"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: MemberDeclBlockSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#MemberDeclBlock"
        node.leftBrace.walk(&self)
        dictionary["leftBrace"] = nodeDictionary
        node.members.walk(&self)
        dictionary["members"] = nodeDictionary
        node.rightBrace.walk(&self)
        dictionary["rightBrace"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: MemberDeclListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "MemberDeclList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: MemberDeclListItemSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#MemberDeclListItem"
        node.decl.walk(&self)
        dictionary["decl"] = nodeDictionary
        visitOptionalSyntax(node.semicolon)
        dictionary["semicolon"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SourceFileSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#SourceFile"
        node.statements.walk(&self)
        dictionary["statements"] = nodeDictionary
        node.eofToken.walk(&self)
        dictionary["eofToken"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: InitializerClauseSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#InitializerClause"
        node.equal.walk(&self)
        dictionary["equal"] = nodeDictionary
        node.value.walk(&self)
        dictionary["value"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: FunctionParameterSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#FunctionParameter"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.firstName)
        dictionary["firstName"] = nodeDictionary
        visitOptionalSyntax(node.secondName)
        dictionary["secondName"] = nodeDictionary
        visitOptionalSyntax(node.colon)
        dictionary["colon"] = nodeDictionary
        visitOptionalSyntax(node.type)
        dictionary["type"] = nodeDictionary
        visitOptionalSyntax(node.ellipsis)
        dictionary["ellipsis"] = nodeDictionary
        visitOptionalSyntax(node.defaultArgument)
        dictionary["defaultArgument"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ModifierListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "ModifierList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#FunctionDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.funcKeyword.walk(&self)
        dictionary["funcKeyword"] = nodeDictionary
        node.identifier.walk(&self)
        dictionary["identifier"] = nodeDictionary
        visitOptionalSyntax(node.genericParameterClause)
        dictionary["genericParameterClause"] = nodeDictionary
        node.signature.walk(&self)
        dictionary["signature"] = nodeDictionary
        visitOptionalSyntax(node.genericWhereClause)
        dictionary["genericWhereClause"] = nodeDictionary
        visitOptionalSyntax(node.body)
        dictionary["body"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#InitializerDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.initKeyword.walk(&self)
        dictionary["initKeyword"] = nodeDictionary
        visitOptionalSyntax(node.optionalMark)
        dictionary["optionalMark"] = nodeDictionary
        visitOptionalSyntax(node.genericParameterClause)
        dictionary["genericParameterClause"] = nodeDictionary
        node.parameters.walk(&self)
        dictionary["parameters"] = nodeDictionary
        visitOptionalSyntax(node.throwsOrRethrowsKeyword)
        dictionary["throwsOrRethrowsKeyword"] = nodeDictionary
        visitOptionalSyntax(node.genericWhereClause)
        dictionary["genericWhereClause"] = nodeDictionary
        visitOptionalSyntax(node.body)
        dictionary["body"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: DeinitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#DeinitializerDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.deinitKeyword.walk(&self)
        dictionary["deinitKeyword"] = nodeDictionary
        node.body.walk(&self)
        dictionary["body"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SubscriptDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#SubscriptDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.subscriptKeyword.walk(&self)
        dictionary["subscriptKeyword"] = nodeDictionary
        visitOptionalSyntax(node.genericParameterClause)
        dictionary["genericParameterClause"] = nodeDictionary
        node.indices.walk(&self)
        dictionary["indices"] = nodeDictionary
        node.result.walk(&self)
        dictionary["result"] = nodeDictionary
        visitOptionalSyntax(node.genericWhereClause)
        dictionary["genericWhereClause"] = nodeDictionary
        visitOptionalSyntax(node.accessor)
        dictionary["accessor"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AccessLevelModifierSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#AccessLevelModifier"
        node.name.walk(&self)
        dictionary["name"] = nodeDictionary
        visitOptionalSyntax(node.leftParen)
        dictionary["leftParen"] = nodeDictionary
        visitOptionalSyntax(node.modifier)
        dictionary["modifier"] = nodeDictionary
        visitOptionalSyntax(node.rightParen)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AccessPathComponentSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#AccessPathComponent"
        node.name.walk(&self)
        dictionary["name"] = nodeDictionary
        visitOptionalSyntax(node.trailingDot)
        dictionary["trailingDot"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AccessPathSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "AccessPath")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ImportDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ImportDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.importTok.walk(&self)
        dictionary["importTok"] = nodeDictionary
        visitOptionalSyntax(node.importKind)
        dictionary["importKind"] = nodeDictionary
        node.path.walk(&self)
        dictionary["path"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AccessorParameterSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#AccessorParameter"
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        node.name.walk(&self)
        dictionary["name"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AccessorDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#AccessorDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifier)
        dictionary["modifier"] = nodeDictionary
        node.accessorKind.walk(&self)
        dictionary["accessorKind"] = nodeDictionary
        visitOptionalSyntax(node.parameter)
        dictionary["parameter"] = nodeDictionary
        visitOptionalSyntax(node.body)
        dictionary["body"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AccessorListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "AccessorList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AccessorBlockSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#AccessorBlock"
        node.leftBrace.walk(&self)
        dictionary["leftBrace"] = nodeDictionary
        node.accessors.walk(&self)
        dictionary["accessors"] = nodeDictionary
        node.rightBrace.walk(&self)
        dictionary["rightBrace"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PatternBindingSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PatternBinding"
        node.pattern.walk(&self)
        dictionary["pattern"] = nodeDictionary
        visitOptionalSyntax(node.typeAnnotation)
        dictionary["typeAnnotation"] = nodeDictionary
        visitOptionalSyntax(node.initializer)
        dictionary["initializer"] = nodeDictionary
        visitOptionalSyntax(node.accessor)
        dictionary["accessor"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PatternBindingListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "PatternBindingList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#VariableDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.letOrVarKeyword.walk(&self)
        dictionary["letOrVarKeyword"] = nodeDictionary
        node.bindings.walk(&self)
        dictionary["bindings"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: EnumCaseElementSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#EnumCaseElement"
        node.identifier.walk(&self)
        dictionary["identifier"] = nodeDictionary
        visitOptionalSyntax(node.associatedValue)
        dictionary["associatedValue"] = nodeDictionary
        visitOptionalSyntax(node.rawValue)
        dictionary["rawValue"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: EnumCaseElementListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "EnumCaseElementList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: EnumCaseDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#EnumCaseDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.caseKeyword.walk(&self)
        dictionary["caseKeyword"] = nodeDictionary
        node.elements.walk(&self)
        dictionary["elements"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#EnumDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.enumKeyword.walk(&self)
        dictionary["enumKeyword"] = nodeDictionary
        node.identifier.walk(&self)
        dictionary["identifier"] = nodeDictionary
        visitOptionalSyntax(node.genericParameters)
        dictionary["genericParameters"] = nodeDictionary
        visitOptionalSyntax(node.inheritanceClause)
        dictionary["inheritanceClause"] = nodeDictionary
        visitOptionalSyntax(node.genericWhereClause)
        dictionary["genericWhereClause"] = nodeDictionary
        node.members.walk(&self)
        dictionary["members"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: OperatorDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#OperatorDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.operatorKeyword.walk(&self)
        dictionary["operatorKeyword"] = nodeDictionary
        node.identifier.walk(&self)
        dictionary["identifier"] = nodeDictionary
        visitOptionalSyntax(node.operatorPrecedenceAndTypes)
        dictionary["operatorPrecedenceAndTypes"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: IdentifierListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "IdentifierList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: OperatorPrecedenceAndTypesSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#OperatorPrecedenceAndTypes"
        node.colon.walk(&self)
        dictionary["colon"] = nodeDictionary
        node.precedenceGroupAndDesignatedTypes.walk(&self)
        dictionary["precedenceGroupAndDesignatedTypes"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PrecedenceGroupDeclSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PrecedenceGroupDecl"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        visitOptionalSyntax(node.modifiers)
        dictionary["modifiers"] = nodeDictionary
        node.precedencegroupKeyword.walk(&self)
        dictionary["precedencegroupKeyword"] = nodeDictionary
        node.identifier.walk(&self)
        dictionary["identifier"] = nodeDictionary
        node.leftBrace.walk(&self)
        dictionary["leftBrace"] = nodeDictionary
        node.groupAttributes.walk(&self)
        dictionary["groupAttributes"] = nodeDictionary
        node.rightBrace.walk(&self)
        dictionary["rightBrace"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PrecedenceGroupAttributeListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "PrecedenceGroupAttributeList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PrecedenceGroupRelationSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PrecedenceGroupRelation"
        node.higherThanOrLowerThan.walk(&self)
        dictionary["higherThanOrLowerThan"] = nodeDictionary
        node.colon.walk(&self)
        dictionary["colon"] = nodeDictionary
        node.otherNames.walk(&self)
        dictionary["otherNames"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PrecedenceGroupNameListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "PrecedenceGroupNameList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PrecedenceGroupNameElementSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PrecedenceGroupNameElement"
        node.name.walk(&self)
        dictionary["name"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PrecedenceGroupAssignmentSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PrecedenceGroupAssignment"
        node.assignmentKeyword.walk(&self)
        dictionary["assignmentKeyword"] = nodeDictionary
        node.colon.walk(&self)
        dictionary["colon"] = nodeDictionary
        node.flag.walk(&self)
        dictionary["flag"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PrecedenceGroupAssociativitySyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PrecedenceGroupAssociativity"
        node.associativityKeyword.walk(&self)
        dictionary["associativityKeyword"] = nodeDictionary
        node.colon.walk(&self)
        dictionary["colon"] = nodeDictionary
        node.value.walk(&self)
        dictionary["value"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TokenListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "TokenList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: CustomAttributeSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#CustomAttribute"
        node.atSignToken.walk(&self)
        dictionary["atSignToken"] = nodeDictionary
        node.attributeName.walk(&self)
        dictionary["attributeName"] = nodeDictionary
        visitOptionalSyntax(node.leftParen)
        dictionary["leftParen"] = nodeDictionary
        visitOptionalSyntax(node.argumentList)
        dictionary["argumentList"] = nodeDictionary
        visitOptionalSyntax(node.rightParen)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AttributeSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#Attribute"
        node.atSignToken.walk(&self)
        dictionary["atSignToken"] = nodeDictionary
        node.attributeName.walk(&self)
        dictionary["attributeName"] = nodeDictionary
        visitOptionalSyntax(node.leftParen)
        dictionary["leftParen"] = nodeDictionary
        visitOptionalSyntax(node.argument)
        dictionary["argument"] = nodeDictionary
        visitOptionalSyntax(node.rightParen)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AttributeListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "AttributeList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SpecializeAttributeSpecListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "SpecializeAttributeSpecList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: LabeledSpecializeEntrySyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#LabeledSpecializeEntry"
        node.label.walk(&self)
        dictionary["label"] = nodeDictionary
        node.colon.walk(&self)
        dictionary["colon"] = nodeDictionary
        node.value.walk(&self)
        dictionary["value"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: NamedAttributeStringArgumentSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#NamedAttributeStringArgument"
        node.nameTok.walk(&self)
        dictionary["nameTok"] = nodeDictionary
        node.colon.walk(&self)
        dictionary["colon"] = nodeDictionary
        node.stringOrDeclname.walk(&self)
        dictionary["stringOrDeclname"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: DeclNameSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#DeclName"
        node.declBaseName.walk(&self)
        dictionary["declBaseName"] = nodeDictionary
        visitOptionalSyntax(node.declNameArguments)
        dictionary["declNameArguments"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ImplementsAttributeArgumentsSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ImplementsAttributeArguments"
        node.type.walk(&self)
        dictionary["type"] = nodeDictionary
        node.comma.walk(&self)
        dictionary["comma"] = nodeDictionary
        node.declBaseName.walk(&self)
        dictionary["declBaseName"] = nodeDictionary
        visitOptionalSyntax(node.declNameArguments)
        dictionary["declNameArguments"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ObjCSelectorPieceSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ObjCSelectorPiece"
        visitOptionalSyntax(node.name)
        dictionary["name"] = nodeDictionary
        visitOptionalSyntax(node.colon)
        dictionary["colon"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ObjCSelectorSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "ObjCSelector")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ContinueStmtSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ContinueStmt"
        node.continueKeyword.walk(&self)
        dictionary["continueKeyword"] = nodeDictionary
        visitOptionalSyntax(node.label)
        dictionary["label"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: WhileStmtSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#WhileStmt"
        visitOptionalSyntax(node.labelName)
        dictionary["labelName"] = nodeDictionary
        visitOptionalSyntax(node.labelColon)
        dictionary["labelColon"] = nodeDictionary
        node.whileKeyword.walk(&self)
        dictionary["whileKeyword"] = nodeDictionary
        node.conditions.walk(&self)
        dictionary["conditions"] = nodeDictionary
        node.body.walk(&self)
        dictionary["body"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: DeferStmtSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#DeferStmt"
        node.deferKeyword.walk(&self)
        dictionary["deferKeyword"] = nodeDictionary
        node.body.walk(&self)
        dictionary["body"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SwitchCaseListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "SwitchCaseList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: RepeatWhileStmtSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#RepeatWhileStmt"
        visitOptionalSyntax(node.labelName)
        dictionary["labelName"] = nodeDictionary
        visitOptionalSyntax(node.labelColon)
        dictionary["labelColon"] = nodeDictionary
        node.repeatKeyword.walk(&self)
        dictionary["repeatKeyword"] = nodeDictionary
        node.body.walk(&self)
        dictionary["body"] = nodeDictionary
        node.whileKeyword.walk(&self)
        dictionary["whileKeyword"] = nodeDictionary
        node.condition.walk(&self)
        dictionary["condition"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: GuardStmtSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#GuardStmt"
        node.guardKeyword.walk(&self)
        dictionary["guardKeyword"] = nodeDictionary
        node.conditions.walk(&self)
        dictionary["conditions"] = nodeDictionary
        node.elseKeyword.walk(&self)
        dictionary["elseKeyword"] = nodeDictionary
        node.body.walk(&self)
        dictionary["body"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: WhereClauseSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#WhereClause"
        node.whereKeyword.walk(&self)
        dictionary["whereKeyword"] = nodeDictionary
        node.guardResult.walk(&self)
        dictionary["guardResult"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ForInStmtSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ForInStmt"
        visitOptionalSyntax(node.labelName)
        dictionary["labelName"] = nodeDictionary
        visitOptionalSyntax(node.labelColon)
        dictionary["labelColon"] = nodeDictionary
        node.forKeyword.walk(&self)
        dictionary["forKeyword"] = nodeDictionary
        visitOptionalSyntax(node.caseKeyword)
        dictionary["caseKeyword"] = nodeDictionary
        node.pattern.walk(&self)
        dictionary["pattern"] = nodeDictionary
        visitOptionalSyntax(node.typeAnnotation)
        dictionary["typeAnnotation"] = nodeDictionary
        node.inKeyword.walk(&self)
        dictionary["inKeyword"] = nodeDictionary
        node.sequenceExpr.walk(&self)
        dictionary["sequenceExpr"] = nodeDictionary
        visitOptionalSyntax(node.whereClause)
        dictionary["whereClause"] = nodeDictionary
        node.body.walk(&self)
        dictionary["body"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SwitchStmtSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#SwitchStmt"
        visitOptionalSyntax(node.labelName)
        dictionary["labelName"] = nodeDictionary
        visitOptionalSyntax(node.labelColon)
        dictionary["labelColon"] = nodeDictionary
        node.switchKeyword.walk(&self)
        dictionary["switchKeyword"] = nodeDictionary
        node.expression.walk(&self)
        dictionary["expression"] = nodeDictionary
        node.leftBrace.walk(&self)
        dictionary["leftBrace"] = nodeDictionary
        node.cases.walk(&self)
        dictionary["cases"] = nodeDictionary
        node.rightBrace.walk(&self)
        dictionary["rightBrace"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: CatchClauseListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "CatchClauseList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: DoStmtSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#DoStmt"
        visitOptionalSyntax(node.labelName)
        dictionary["labelName"] = nodeDictionary
        visitOptionalSyntax(node.labelColon)
        dictionary["labelColon"] = nodeDictionary
        node.doKeyword.walk(&self)
        dictionary["doKeyword"] = nodeDictionary
        node.body.walk(&self)
        dictionary["body"] = nodeDictionary
        visitOptionalSyntax(node.catchClauses)
        dictionary["catchClauses"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ReturnStmtSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ReturnStmt"
        node.returnKeyword.walk(&self)
        dictionary["returnKeyword"] = nodeDictionary
        visitOptionalSyntax(node.expression)
        dictionary["expression"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: YieldStmtSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#YieldStmt"
        node.yieldKeyword.walk(&self)
        dictionary["yieldKeyword"] = nodeDictionary
        node.yields.walk(&self)
        dictionary["yields"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: YieldListSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#YieldList"
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        node.elementList.walk(&self)
        dictionary["elementList"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: FallthroughStmtSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#FallthroughStmt"
        node.fallthroughKeyword.walk(&self)
        dictionary["fallthroughKeyword"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: BreakStmtSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#BreakStmt"
        node.breakKeyword.walk(&self)
        dictionary["breakKeyword"] = nodeDictionary
        visitOptionalSyntax(node.label)
        dictionary["label"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: CaseItemListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "CaseItemList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ConditionElementSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ConditionElement"
        node.condition.walk(&self)
        dictionary["condition"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AvailabilityConditionSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#AvailabilityCondition"
        node.poundAvailableKeyword.walk(&self)
        dictionary["poundAvailableKeyword"] = nodeDictionary
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        node.availabilitySpec.walk(&self)
        dictionary["availabilitySpec"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: MatchingPatternConditionSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#MatchingPatternCondition"
        node.caseKeyword.walk(&self)
        dictionary["caseKeyword"] = nodeDictionary
        node.pattern.walk(&self)
        dictionary["pattern"] = nodeDictionary
        visitOptionalSyntax(node.typeAnnotation)
        dictionary["typeAnnotation"] = nodeDictionary
        node.initializer.walk(&self)
        dictionary["initializer"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: OptionalBindingConditionSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#OptionalBindingCondition"
        node.letOrVarKeyword.walk(&self)
        dictionary["letOrVarKeyword"] = nodeDictionary
        node.pattern.walk(&self)
        dictionary["pattern"] = nodeDictionary
        visitOptionalSyntax(node.typeAnnotation)
        dictionary["typeAnnotation"] = nodeDictionary
        node.initializer.walk(&self)
        dictionary["initializer"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ConditionElementListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "ConditionElementList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ThrowStmtSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ThrowStmt"
        node.throwKeyword.walk(&self)
        dictionary["throwKeyword"] = nodeDictionary
        node.expression.walk(&self)
        dictionary["expression"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: IfStmtSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#IfStmt"
        visitOptionalSyntax(node.labelName)
        dictionary["labelName"] = nodeDictionary
        visitOptionalSyntax(node.labelColon)
        dictionary["labelColon"] = nodeDictionary
        node.ifKeyword.walk(&self)
        dictionary["ifKeyword"] = nodeDictionary
        node.conditions.walk(&self)
        dictionary["conditions"] = nodeDictionary
        node.body.walk(&self)
        dictionary["body"] = nodeDictionary
        visitOptionalSyntax(node.elseKeyword)
        dictionary["elseKeyword"] = nodeDictionary
        visitOptionalSyntax(node.elseBody)
        dictionary["elseBody"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SwitchCaseSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#SwitchCase"
        visitOptionalSyntax(node.unknownAttr)
        dictionary["unknownAttr"] = nodeDictionary
        node.label.walk(&self)
        dictionary["label"] = nodeDictionary
        node.statements.walk(&self)
        dictionary["statements"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SwitchDefaultLabelSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#SwitchDefaultLabel"
        node.defaultKeyword.walk(&self)
        dictionary["defaultKeyword"] = nodeDictionary
        node.colon.walk(&self)
        dictionary["colon"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: CaseItemSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#CaseItem"
        node.pattern.walk(&self)
        dictionary["pattern"] = nodeDictionary
        visitOptionalSyntax(node.whereClause)
        dictionary["whereClause"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SwitchCaseLabelSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#SwitchCaseLabel"
        node.caseKeyword.walk(&self)
        dictionary["caseKeyword"] = nodeDictionary
        node.caseItems.walk(&self)
        dictionary["caseItems"] = nodeDictionary
        node.colon.walk(&self)
        dictionary["colon"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: CatchClauseSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#CatchClause"
        node.catchKeyword.walk(&self)
        dictionary["catchKeyword"] = nodeDictionary
        visitOptionalSyntax(node.pattern)
        dictionary["pattern"] = nodeDictionary
        visitOptionalSyntax(node.whereClause)
        dictionary["whereClause"] = nodeDictionary
        node.body.walk(&self)
        dictionary["body"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: PoundAssertStmtSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#PoundAssertStmt"
        node.poundAssert.walk(&self)
        dictionary["poundAssert"] = nodeDictionary
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        node.condition.walk(&self)
        dictionary["condition"] = nodeDictionary
        visitOptionalSyntax(node.comma)
        dictionary["comma"] = nodeDictionary
        visitOptionalSyntax(node.message)
        dictionary["message"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: GenericWhereClauseSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#GenericWhereClause"
        node.whereKeyword.walk(&self)
        dictionary["whereKeyword"] = nodeDictionary
        node.requirementList.walk(&self)
        dictionary["requirementList"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: GenericRequirementListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "GenericRequirementList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SameTypeRequirementSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#SameTypeRequirement"
        node.leftTypeIdentifier.walk(&self)
        dictionary["leftTypeIdentifier"] = nodeDictionary
        node.equalityToken.walk(&self)
        dictionary["equalityToken"] = nodeDictionary
        node.rightTypeIdentifier.walk(&self)
        dictionary["rightTypeIdentifier"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: GenericParameterListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "GenericParameterList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: GenericParameterSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#GenericParameter"
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        node.name.walk(&self)
        dictionary["name"] = nodeDictionary
        visitOptionalSyntax(node.colon)
        dictionary["colon"] = nodeDictionary
        visitOptionalSyntax(node.inheritedType)
        dictionary["inheritedType"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: GenericParameterClauseSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#GenericParameterClause"
        node.leftAngleBracket.walk(&self)
        dictionary["leftAngleBracket"] = nodeDictionary
        node.genericParameterList.walk(&self)
        dictionary["genericParameterList"] = nodeDictionary
        node.rightAngleBracket.walk(&self)
        dictionary["rightAngleBracket"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ConformanceRequirementSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ConformanceRequirement"
        node.leftTypeIdentifier.walk(&self)
        dictionary["leftTypeIdentifier"] = nodeDictionary
        node.colon.walk(&self)
        dictionary["colon"] = nodeDictionary
        node.rightTypeIdentifier.walk(&self)
        dictionary["rightTypeIdentifier"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SimpleTypeIdentifierSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#SimpleTypeIdentifier"
        node.name.walk(&self)
        dictionary["name"] = nodeDictionary
        visitOptionalSyntax(node.genericArgumentClause)
        dictionary["genericArgumentClause"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: MemberTypeIdentifierSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#MemberTypeIdentifier"
        node.baseType.walk(&self)
        dictionary["baseType"] = nodeDictionary
        node.period.walk(&self)
        dictionary["period"] = nodeDictionary
        node.name.walk(&self)
        dictionary["name"] = nodeDictionary
        visitOptionalSyntax(node.genericArgumentClause)
        dictionary["genericArgumentClause"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ClassRestrictionTypeSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ClassRestrictionType"
        node.classKeyword.walk(&self)
        dictionary["classKeyword"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ArrayTypeSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ArrayType"
        node.leftSquareBracket.walk(&self)
        dictionary["leftSquareBracket"] = nodeDictionary
        node.elementType.walk(&self)
        dictionary["elementType"] = nodeDictionary
        node.rightSquareBracket.walk(&self)
        dictionary["rightSquareBracket"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: DictionaryTypeSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#DictionaryType"
        node.leftSquareBracket.walk(&self)
        dictionary["leftSquareBracket"] = nodeDictionary
        node.keyType.walk(&self)
        dictionary["keyType"] = nodeDictionary
        node.colon.walk(&self)
        dictionary["colon"] = nodeDictionary
        node.valueType.walk(&self)
        dictionary["valueType"] = nodeDictionary
        node.rightSquareBracket.walk(&self)
        dictionary["rightSquareBracket"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: MetatypeTypeSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#MetatypeType"
        node.baseType.walk(&self)
        dictionary["baseType"] = nodeDictionary
        node.period.walk(&self)
        dictionary["period"] = nodeDictionary
        node.typeOrProtocol.walk(&self)
        dictionary["typeOrProtocol"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: OptionalTypeSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#OptionalType"
        node.wrappedType.walk(&self)
        dictionary["wrappedType"] = nodeDictionary
        node.questionMark.walk(&self)
        dictionary["questionMark"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: SomeTypeSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#SomeType"
        node.someSpecifier.walk(&self)
        dictionary["someSpecifier"] = nodeDictionary
        node.baseType.walk(&self)
        dictionary["baseType"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ImplicitlyUnwrappedOptionalTypeSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ImplicitlyUnwrappedOptionalType"
        node.wrappedType.walk(&self)
        dictionary["wrappedType"] = nodeDictionary
        node.exclamationMark.walk(&self)
        dictionary["exclamationMark"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: CompositionTypeElementSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#CompositionTypeElement"
        node.type.walk(&self)
        dictionary["type"] = nodeDictionary
        visitOptionalSyntax(node.ampersand)
        dictionary["ampersand"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: CompositionTypeElementListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "CompositionTypeElementList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: CompositionTypeSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#CompositionType"
        node.elements.walk(&self)
        dictionary["elements"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TupleTypeElementSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#TupleTypeElement"
        visitOptionalSyntax(node.inOut)
        dictionary["inOut"] = nodeDictionary
        visitOptionalSyntax(node.name)
        dictionary["name"] = nodeDictionary
        visitOptionalSyntax(node.secondName)
        dictionary["secondName"] = nodeDictionary
        visitOptionalSyntax(node.colon)
        dictionary["colon"] = nodeDictionary
        node.type.walk(&self)
        dictionary["type"] = nodeDictionary
        visitOptionalSyntax(node.ellipsis)
        dictionary["ellipsis"] = nodeDictionary
        visitOptionalSyntax(node.initializer)
        dictionary["initializer"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TupleTypeElementListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "TupleTypeElementList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TupleTypeSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#TupleType"
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        node.elements.walk(&self)
        dictionary["elements"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: FunctionTypeSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#FunctionType"
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        node.arguments.walk(&self)
        dictionary["arguments"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        visitOptionalSyntax(node.throwsOrRethrowsKeyword)
        dictionary["throwsOrRethrowsKeyword"] = nodeDictionary
        node.arrow.walk(&self)
        dictionary["arrow"] = nodeDictionary
        node.returnType.walk(&self)
        dictionary["returnType"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AttributedTypeSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#AttributedType"
        visitOptionalSyntax(node.specifier)
        dictionary["specifier"] = nodeDictionary
        visitOptionalSyntax(node.attributes)
        dictionary["attributes"] = nodeDictionary
        node.baseType.walk(&self)
        dictionary["baseType"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: GenericArgumentListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "GenericArgumentList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: GenericArgumentSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#GenericArgument"
        node.argumentType.walk(&self)
        dictionary["argumentType"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: GenericArgumentClauseSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#GenericArgumentClause"
        node.leftAngleBracket.walk(&self)
        dictionary["leftAngleBracket"] = nodeDictionary
        node.arguments.walk(&self)
        dictionary["arguments"] = nodeDictionary
        node.rightAngleBracket.walk(&self)
        dictionary["rightAngleBracket"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TypeAnnotationSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#TypeAnnotation"
        node.colon.walk(&self)
        dictionary["colon"] = nodeDictionary
        node.type.walk(&self)
        dictionary["type"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: EnumCasePatternSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#EnumCasePattern"
        visitOptionalSyntax(node.type)
        dictionary["type"] = nodeDictionary
        node.period.walk(&self)
        dictionary["period"] = nodeDictionary
        node.caseName.walk(&self)
        dictionary["caseName"] = nodeDictionary
        visitOptionalSyntax(node.associatedTuple)
        dictionary["associatedTuple"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: IsTypePatternSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#IsTypePattern"
        node.isKeyword.walk(&self)
        dictionary["isKeyword"] = nodeDictionary
        node.type.walk(&self)
        dictionary["type"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: OptionalPatternSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#OptionalPattern"
        node.subPattern.walk(&self)
        dictionary["subPattern"] = nodeDictionary
        node.questionMark.walk(&self)
        dictionary["questionMark"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: IdentifierPatternSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#IdentifierPattern"
        node.identifier.walk(&self)
        dictionary["identifier"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AsTypePatternSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#AsTypePattern"
        node.pattern.walk(&self)
        dictionary["pattern"] = nodeDictionary
        node.asKeyword.walk(&self)
        dictionary["asKeyword"] = nodeDictionary
        node.type.walk(&self)
        dictionary["type"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TuplePatternSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#TuplePattern"
        node.leftParen.walk(&self)
        dictionary["leftParen"] = nodeDictionary
        node.elements.walk(&self)
        dictionary["elements"] = nodeDictionary
        node.rightParen.walk(&self)
        dictionary["rightParen"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: WildcardPatternSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#WildcardPattern"
        node.wildcard.walk(&self)
        dictionary["wildcard"] = nodeDictionary
        visitOptionalSyntax(node.typeAnnotation)
        dictionary["typeAnnotation"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TuplePatternElementSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#TuplePatternElement"
        visitOptionalSyntax(node.labelName)
        dictionary["labelName"] = nodeDictionary
        visitOptionalSyntax(node.labelColon)
        dictionary["labelColon"] = nodeDictionary
        node.pattern.walk(&self)
        dictionary["pattern"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ExpressionPatternSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ExpressionPattern"
        node.expression.walk(&self)
        dictionary["expression"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: TuplePatternElementListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "TuplePatternElementList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: ValueBindingPatternSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#ValueBindingPattern"
        node.letOrVarKeyword.walk(&self)
        dictionary["letOrVarKeyword"] = nodeDictionary
        node.valuePattern.walk(&self)
        dictionary["valuePattern"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AvailabilitySpecListSyntax) -> SyntaxVisitorContinueKind {
        visitListSyntax(node, entityType: "AvailabilitySpecList")
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AvailabilityArgumentSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#AvailabilityArgument"
        node.entry.walk(&self)
        dictionary["entry"] = nodeDictionary
        visitOptionalSyntax(node.trailingComma)
        dictionary["trailingComma"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AvailabilityLabeledArgumentSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#AvailabilityLabeledArgument"
        node.label.walk(&self)
        dictionary["label"] = nodeDictionary
        node.colon.walk(&self)
        dictionary["colon"] = nodeDictionary
        node.value.walk(&self)
        dictionary["value"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: AvailabilityVersionRestrictionSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#AvailabilityVersionRestriction"
        node.platform.walk(&self)
        dictionary["platform"] = nodeDictionary
        node.version.walk(&self)
        dictionary["version"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }

    @discardableResult
    public mutating func visit(_ node: VersionTupleSyntax) -> SyntaxVisitorContinueKind {
        var dictionary = [String: Any]()
        dictionary["@type"] = languageUri + "#VersionTuple"
        node.majorMinor.walk(&self)
        dictionary["majorMinor"] = nodeDictionary
        visitOptionalSyntax(node.patchPeriod)
        dictionary["patchPeriod"] = nodeDictionary
        visitOptionalSyntax(node.patchVersion)
        dictionary["patchVersion"] = nodeDictionary
        self.nodeDictionary = dictionary
        return .skipChildren 
    }
}
