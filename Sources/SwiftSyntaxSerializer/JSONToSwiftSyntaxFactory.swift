import Foundation
import SwiftSyntax

extension SyntaxFactory {
    static func makeAttribute(atSignToken: TokenSyntax, attributeName: TokenSyntax, leftParen: TokenSyntax?, argument: Syntax?, rightParen: TokenSyntax?) -> AttributeSyntax {
        return makeAttribute(atSignToken: atSignToken, attributeName: attributeName, leftParen: leftParen, argument: argument, rightParen: rightParen, tokenList: nil)
    }
}

public enum ConversionError : Error {
    case unknownLanguage(String)
    case unknownType(String)
    case unknownToken(String)
    case notImplemented(String)
}

public class JSONToSwiftSyntaxFactory {
    let languageUri = "whole:org.whole.lang.swiftsyntax:SwiftSyntaxModel"
    let resolver: [String: Any] = [ "@type": "http://lang.whole.org/Commons#Resolver" ]

    public func jsonObject(with data: Data, options: JSONSerialization.ReadingOptions = []) throws -> Syntax? {
        let dictionaryObject = try JSONSerialization.jsonObject(with: data, options: options)
        return try makeSyntax(dictionary: dictionaryObject as! [String: Any])
    }

    func ensure(dictionary: [String: Any], hasType type: String) throws -> String {
        let dictionaryType = dictionary["@type"] as! String
        if dictionaryType != languageUri+"#"+type {
            throw ConversionError.unknownType(dictionaryType)
        }
        return dictionaryType
    }
    
    public func encodeSyntax(_ object: Syntax) throws -> [String: Any] {
        let suffix = "Syntax"
        var dictionary = [String: Any]()
        
        if let token = object as? TokenSyntax {
            let encoder = JSONEncoder()
            dictionary["tokenKind"] = try JSONSerialization.jsonObject(with: try encoder.encode(token.text))
            dictionary["leadingTrivia"] = try JSONSerialization.jsonObject(with: try encoder.encode(token.leadingTrivia.reduce(into: "", { (text, piece) in piece.write(to: &text) })))
            dictionary["trailingTrivia"] = try JSONSerialization.jsonObject(with: try encoder.encode(token.trailingTrivia.reduce(into: "", { (text, piece) in piece.write(to: &text) })))
            dictionary["presence"] = token.isPresent ? "Present" : "Missing"
        } else {
            let typeName = "\(Mirror(reflecting: object).subjectType)"
            dictionary["kind"] = typeName.hasSuffix(suffix) ? typeName.prefix(typeName.count-suffix.count) : typeName
            var array = [Any]()
            for child in object.children {
                array.append(try encodeSyntax(child))
            }
            dictionary["layout"] = array
            dictionary["presence"] = object.isPresent ? "Present" : "Missing"
        }
        return dictionary
    }

    func ensure(dictionary: [String: Any], hasLanguage languageUri: String) throws -> String {
        let dictionaryType = dictionary["@type"] as! String
        if !dictionaryType.hasPrefix(languageUri+"#") {
            throw ConversionError.unknownLanguage(dictionaryType)
        }
        return dictionaryType
    }

    public func makeText(dictionary: [String: Any]?) throws -> String? {
        if let dictionary = dictionary {
            _ = try ensure(dictionary: dictionary, hasType: "Text")
            return (dictionary["@value"] as! String)
        } else {
            return nil
        }
    }

    public func makeSourcePresence(dictionary: [String: Any]) throws -> SourcePresence {
        _ = try ensure(dictionary: dictionary, hasType: "SourcePresence")
        return dictionary["@value"] as! String == "present" ? .present : .missing
    }

    public func makeTrivia(dictionary: [String: Any]) throws -> Trivia {
        var pieces = [TriviaPiece]()
        let triviaPieces = dictionary["@list"] as! [[String: Any]]
        for triviaPiece in triviaPieces {
            pieces.append(try makeTriviaPiece(dictionary: triviaPiece))
        }
        return Trivia(pieces: pieces)
    }
    
    public func makeTriviaPiece(dictionary: [String: Any]) throws -> TriviaPiece {
        _ = try ensure(dictionary: dictionary, hasType: "TriviaPiece")
        let text = dictionary["@value"] as! String
        switch text[text.startIndex] {
        case "/":
            if (text.hasPrefix("//")) {
                return text.hasPrefix("///") ? .docLineComment(text) : .lineComment(text)
            } else { // text.hasPrefix("/*")
                return text.hasPrefix("/**") ? .docBlockComment(text) : .blockComment(text)
            }
        case "\u{000c}":
            return .formfeeds(text.count)
        case "`":
            return .backticks(text.count)
        case "\n":
            return .newlines(text.count)
        case "\r":
            return text.hasPrefix("\r\n") ? .carriageReturnLineFeeds(text.count / 2) : .carriageReturns(text.count)
        case " ":
            return .spaces(text.count)
        case "\t":
            return .tabs(text.count)
        case "\u{000b}":
            return .verticalTabs(text.count)
        default:
            return .garbageText(text)
        }
    }
    
    public func makeTokenKind(dictionary: [String: Any], withText text: String?) throws -> TokenKind {
        _ = try ensure(dictionary: dictionary, hasType: "TokenKind")
        let kind = dictionary["@value"] as! String
        switch kind {
        case "eof":
            return .eof
        case "associatedtypeKeyword":
            return .associatedtypeKeyword
        case "classKeyword":
            return .classKeyword
        case "deinitKeyword":
            return .deinitKeyword
        case "enumKeyword":
            return .enumKeyword
        case "extensionKeyword":
            return .extensionKeyword
        case "funcKeyword":
            return .funcKeyword
        case "importKeyword":
            return .importKeyword
        case "initKeyword":
            return .initKeyword
        case "inoutKeyword":
            return .inoutKeyword
        case "letKeyword":
            return .letKeyword
        case "operatorKeyword":
            return .operatorKeyword
        case "precedencegroupKeyword":
            return .precedencegroupKeyword
        case "protocolKeyword":
            return .protocolKeyword
        case "structKeyword":
            return .structKeyword
        case "subscriptKeyword":
            return .subscriptKeyword
        case "typealiasKeyword":
            return .typealiasKeyword
        case "varKeyword":
            return .varKeyword
        case "fileprivateKeyword":
            return .fileprivateKeyword
        case "internalKeyword":
            return .internalKeyword
        case "privateKeyword":
            return .privateKeyword
        case "publicKeyword":
            return .publicKeyword
        case "staticKeyword":
            return .staticKeyword
        case "deferKeyword":
            return .deferKeyword
        case "ifKeyword":
            return .ifKeyword
        case "guardKeyword":
            return .guardKeyword
        case "doKeyword":
            return .doKeyword
        case "repeatKeyword":
            return .repeatKeyword
        case "elseKeyword":
            return .elseKeyword
        case "forKeyword":
            return .forKeyword
        case "inKeyword":
            return .inKeyword
        case "whileKeyword":
            return .whileKeyword
        case "returnKeyword":
            return .returnKeyword
        case "breakKeyword":
            return .breakKeyword
        case "continueKeyword":
            return .continueKeyword
        case "fallthroughKeyword":
            return .fallthroughKeyword
        case "switchKeyword":
            return .switchKeyword
        case "caseKeyword":
            return .caseKeyword
        case "defaultKeyword":
            return .defaultKeyword
        case "whereKeyword":
            return .whereKeyword
        case "catchKeyword":
            return .catchKeyword
        case "throwKeyword":
            return .throwKeyword
        case "asKeyword":
            return .asKeyword
        case "anyKeyword":
            return .anyKeyword
        case "falseKeyword":
            return .falseKeyword
        case "isKeyword":
            return .isKeyword
        case "nilKeyword":
            return .nilKeyword
        case "rethrowsKeyword":
            return .rethrowsKeyword
        case "superKeyword":
            return .superKeyword
        case "selfKeyword":
            return .selfKeyword
        case "capitalSelfKeyword":
            return .capitalSelfKeyword
        case "trueKeyword":
            return .trueKeyword
        case "tryKeyword":
            return .tryKeyword
        case "throwsKeyword":
            return .throwsKeyword
        case "__file__Keyword":
            return .__file__Keyword
        case "__line__Keyword":
            return .__line__Keyword
        case "__column__Keyword":
            return .__column__Keyword
        case "__function__Keyword":
            return .__function__Keyword
        case "__dso_handle__Keyword":
            return .__dso_handle__Keyword
        case "wildcardKeyword":
            return .wildcardKeyword
        case "leftParen":
            return .leftParen
        case "rightParen":
            return .rightParen
        case "leftBrace":
            return .leftBrace
        case "rightBrace":
            return .rightBrace
        case "leftSquareBracket":
            return .leftSquareBracket
        case "rightSquareBracket":
            return .rightSquareBracket
        case "leftAngle":
            return .leftAngle
        case "rightAngle":
            return .rightAngle
        case "period":
            return .period
        case "prefixPeriod":
            return .prefixPeriod
        case "comma":
            return .comma
        case "ellipsis":
            return .ellipsis
        case "colon":
            return .colon
        case "semicolon":
            return .semicolon
        case "equal":
            return .equal
        case "atSign":
            return .atSign
        case "pound":
            return .pound
        case "prefixAmpersand":
            return .prefixAmpersand
        case "arrow":
            return .arrow
        case "backtick":
            return .backtick
        case "backslash":
            return .backslash
        case "exclamationMark":
            return .exclamationMark
        case "postfixQuestionMark":
            return .postfixQuestionMark
        case "infixQuestionMark":
            return .infixQuestionMark
        case "stringQuote":
            return .stringQuote
        case "singleQuote":
            return .singleQuote
        case "multilineStringQuote":
            return .multilineStringQuote
        case "poundKeyPathKeyword":
            return .poundKeyPathKeyword
        case "poundLineKeyword":
            return .poundLineKeyword
        case "poundSelectorKeyword":
            return .poundSelectorKeyword
        case "poundFileKeyword":
            return .poundFileKeyword
        case "poundColumnKeyword":
            return .poundColumnKeyword
        case "poundFunctionKeyword":
            return .poundFunctionKeyword
        case "poundDsohandleKeyword":
            return .poundDsohandleKeyword
        case "poundAssertKeyword":
            return .poundAssertKeyword
        case "poundSourceLocationKeyword":
            return .poundSourceLocationKeyword
        case "poundWarningKeyword":
            return .poundWarningKeyword
        case "poundErrorKeyword":
            return .poundErrorKeyword
        case "poundIfKeyword":
            return .poundIfKeyword
        case "poundElseKeyword":
            return .poundElseKeyword
        case "poundElseifKeyword":
            return .poundElseifKeyword
        case "poundEndifKeyword":
            return .poundEndifKeyword
        case "poundAvailableKeyword":
            return .poundAvailableKeyword
        case "poundFileLiteralKeyword":
            return .poundFileLiteralKeyword
        case "poundImageLiteralKeyword":
            return .poundImageLiteralKeyword
        case "poundColorLiteralKeyword":
            return .poundColorLiteralKeyword
        case "integerLiteral":
            return .integerLiteral(text!)
        case "floatingLiteral":
            return .floatingLiteral(text!)
        case "stringLiteral":
            return .stringLiteral(text!)
        case "unknown":
            return .unknown(text!)
        case "identifier":
            return .identifier(text!)
        case "unspacedBinaryOperator":
            return .unspacedBinaryOperator(text!)
        case "spacedBinaryOperator":
            return .spacedBinaryOperator(text!)
        case "postfixOperator":
            return .postfixOperator(text!)
        case "prefixOperator":
            return .prefixOperator(text!)
        case "dollarIdentifier":
            return .dollarIdentifier(text!)
        case "contextualKeyword":
            return .contextualKeyword(text!)
        case "rawStringDelimiter":
            return .rawStringDelimiter(text!)
        case "stringSegment":
            return .stringSegment(text!)
        case "stringInterpolationAnchor":
            return .stringInterpolationAnchor
        case "yield":
            return .yield
        default:
            throw ConversionError.unknownToken(kind)
        }
    }

    public func makeSyntax<T>(dictionary: [String: Any]) throws -> T? {
        var typeName : String
        do {
            let type = try ensure(dictionary: dictionary, hasLanguage: languageUri)
            typeName = String(type.suffix(from: (type.firstIndex(of: "#")!)))
        } catch ConversionError.unknownLanguage {
            // will be catched by default switch case
            typeName = dictionary["@type"] as! String
        }

        switch typeName {
        case "http://lang.whole.org/Commons#Resolver":
            return nil
        case "#Token":
            return (try makeToken(dictionary: dictionary) as! T)
        case "#UnknownDecl":
            return (try makeUnknownDecl(dictionary: dictionary) as! T)
        case "#UnknownExpr":
            return (try makeUnknownExpr(dictionary: dictionary) as! T)
        case "#UnknownPattern":
            return (try makeUnknownPattern(dictionary: dictionary) as! T)
        case "#UnknownStmt":
            return (try makeUnknownStmt(dictionary: dictionary) as! T)
        case "#UnknownType":
            return (try makeUnknownType(dictionary: dictionary) as! T)
        case "#CodeBlockItem":
            return (try makeCodeBlockItem(dictionary: dictionary) as! T)
        case "#CodeBlockItemList":
            return (try makeCodeBlockItemList(dictionary: dictionary) as! T)
        case "#CodeBlock":
            return (try makeCodeBlock(dictionary: dictionary) as! T)
        case "#InOutExpr":
            return (try makeInOutExpr(dictionary: dictionary) as! T)
        case "#PoundColumnExpr":
            return (try makePoundColumnExpr(dictionary: dictionary) as! T)
        case "#FunctionCallArgumentList":
            return (try makeFunctionCallArgumentList(dictionary: dictionary) as! T)
        case "#TupleElementList":
            return (try makeTupleElementList(dictionary: dictionary) as! T)
        case "#ArrayElementList":
            return (try makeArrayElementList(dictionary: dictionary) as! T)
        case "#DictionaryElementList":
            return (try makeDictionaryElementList(dictionary: dictionary) as! T)
        case "#StringLiteralSegments":
            return (try makeStringLiteralSegments(dictionary: dictionary) as! T)
        case "#TryExpr":
            return (try makeTryExpr(dictionary: dictionary) as! T)
        case "#DeclNameArgument":
            return (try makeDeclNameArgument(dictionary: dictionary) as! T)
        case "#DeclNameArgumentList":
            return (try makeDeclNameArgumentList(dictionary: dictionary) as! T)
        case "#DeclNameArguments":
            return (try makeDeclNameArguments(dictionary: dictionary) as! T)
        case "#IdentifierExpr":
            return (try makeIdentifierExpr(dictionary: dictionary) as! T)
        case "#SuperRefExpr":
            return (try makeSuperRefExpr(dictionary: dictionary) as! T)
        case "#NilLiteralExpr":
            return (try makeNilLiteralExpr(dictionary: dictionary) as! T)
        case "#DiscardAssignmentExpr":
            return (try makeDiscardAssignmentExpr(dictionary: dictionary) as! T)
        case "#AssignmentExpr":
            return (try makeAssignmentExpr(dictionary: dictionary) as! T)
        case "#SequenceExpr":
            return (try makeSequenceExpr(dictionary: dictionary) as! T)
        case "#ExprList":
            return (try makeExprList(dictionary: dictionary) as! T)
        case "#PoundLineExpr":
            return (try makePoundLineExpr(dictionary: dictionary) as! T)
        case "#PoundFileExpr":
            return (try makePoundFileExpr(dictionary: dictionary) as! T)
        case "#PoundFunctionExpr":
            return (try makePoundFunctionExpr(dictionary: dictionary) as! T)
        case "#PoundDsohandleExpr":
            return (try makePoundDsohandleExpr(dictionary: dictionary) as! T)
        case "#SymbolicReferenceExpr":
            return (try makeSymbolicReferenceExpr(dictionary: dictionary) as! T)
        case "#PrefixOperatorExpr":
            return (try makePrefixOperatorExpr(dictionary: dictionary) as! T)
        case "#BinaryOperatorExpr":
            return (try makeBinaryOperatorExpr(dictionary: dictionary) as! T)
        case "#ArrowExpr":
            return (try makeArrowExpr(dictionary: dictionary) as! T)
        case "#FloatLiteralExpr":
            return (try makeFloatLiteralExpr(dictionary: dictionary) as! T)
        case "#TupleExpr":
            return (try makeTupleExpr(dictionary: dictionary) as! T)
        case "#ArrayExpr":
            return (try makeArrayExpr(dictionary: dictionary) as! T)
        case "#DictionaryExpr":
            return (try makeDictionaryExpr(dictionary: dictionary) as! T)
        case "#FunctionCallArgument":
            return (try makeFunctionCallArgument(dictionary: dictionary) as! T)
        case "#TupleElement":
            return (try makeTupleElement(dictionary: dictionary) as! T)
        case "#ArrayElement":
            return (try makeArrayElement(dictionary: dictionary) as! T)
        case "#DictionaryElement":
            return (try makeDictionaryElement(dictionary: dictionary) as! T)
        case "#IntegerLiteralExpr":
            return (try makeIntegerLiteralExpr(dictionary: dictionary) as! T)
        case "#BooleanLiteralExpr":
            return (try makeBooleanLiteralExpr(dictionary: dictionary) as! T)
        case "#TernaryExpr":
            return (try makeTernaryExpr(dictionary: dictionary) as! T)
        case "#MemberAccessExpr":
            return (try makeMemberAccessExpr(dictionary: dictionary) as! T)
        case "#IsExpr":
            return (try makeIsExpr(dictionary: dictionary) as! T)
        case "#AsExpr":
            return (try makeAsExpr(dictionary: dictionary) as! T)
        case "#TypeExpr":
            return (try makeTypeExpr(dictionary: dictionary) as! T)
        case "#ClosureCaptureItem":
            return (try makeClosureCaptureItem(dictionary: dictionary) as! T)
        case "#ClosureCaptureItemList":
            return (try makeClosureCaptureItemList(dictionary: dictionary) as! T)
        case "#ClosureCaptureSignature":
            return (try makeClosureCaptureSignature(dictionary: dictionary) as! T)
        case "#ClosureParam":
            return (try makeClosureParam(dictionary: dictionary) as! T)
        case "#ClosureParamList":
            return (try makeClosureParamList(dictionary: dictionary) as! T)
        case "#ClosureSignature":
            return (try makeClosureSignature(dictionary: dictionary) as! T)
        case "#ClosureExpr":
            return (try makeClosureExpr(dictionary: dictionary) as! T)
        case "#UnresolvedPatternExpr":
            return (try makeUnresolvedPatternExpr(dictionary: dictionary) as! T)
        case "#FunctionCallExpr":
            return (try makeFunctionCallExpr(dictionary: dictionary) as! T)
        case "#SubscriptExpr":
            return (try makeSubscriptExpr(dictionary: dictionary) as! T)
        case "#OptionalChainingExpr":
            return (try makeOptionalChainingExpr(dictionary: dictionary) as! T)
        case "#ForcedValueExpr":
            return (try makeForcedValueExpr(dictionary: dictionary) as! T)
        case "#PostfixUnaryExpr":
            return (try makePostfixUnaryExpr(dictionary: dictionary) as! T)
        case "#SpecializeExpr":
            return (try makeSpecializeExpr(dictionary: dictionary) as! T)
        case "#StringSegment":
            return (try makeStringSegment(dictionary: dictionary) as! T)
        case "#ExpressionSegment":
            return (try makeExpressionSegment(dictionary: dictionary) as! T)
        case "#StringLiteralExpr":
            return (try makeStringLiteralExpr(dictionary: dictionary) as! T)
        case "#KeyPathExpr":
            return (try makeKeyPathExpr(dictionary: dictionary) as! T)
        case "#KeyPathBaseExpr":
            return (try makeKeyPathBaseExpr(dictionary: dictionary) as! T)
        case "#ObjcNamePiece":
            return (try makeObjcNamePiece(dictionary: dictionary) as! T)
        case "#ObjcName":
            return (try makeObjcName(dictionary: dictionary) as! T)
        case "#ObjcKeyPathExpr":
            return (try makeObjcKeyPathExpr(dictionary: dictionary) as! T)
        case "#ObjcSelectorExpr":
            return (try makeObjcSelectorExpr(dictionary: dictionary) as! T)
        case "#EditorPlaceholderExpr":
            return (try makeEditorPlaceholderExpr(dictionary: dictionary) as! T)
        case "#ObjectLiteralExpr":
            return (try makeObjectLiteralExpr(dictionary: dictionary) as! T)
        case "#TypeInitializerClause":
            return (try makeTypeInitializerClause(dictionary: dictionary) as! T)
        case "#TypealiasDecl":
            return (try makeTypealiasDecl(dictionary: dictionary) as! T)
        case "#AssociatedtypeDecl":
            return (try makeAssociatedtypeDecl(dictionary: dictionary) as! T)
        case "#FunctionParameterList":
            return (try makeFunctionParameterList(dictionary: dictionary) as! T)
        case "#ParameterClause":
            return (try makeParameterClause(dictionary: dictionary) as! T)
        case "#ReturnClause":
            return (try makeReturnClause(dictionary: dictionary) as! T)
        case "#FunctionSignature":
            return (try makeFunctionSignature(dictionary: dictionary) as! T)
        case "#IfConfigClause":
            return (try makeIfConfigClause(dictionary: dictionary) as! T)
        case "#IfConfigClauseList":
            return (try makeIfConfigClauseList(dictionary: dictionary) as! T)
        case "#IfConfigDecl":
            return (try makeIfConfigDecl(dictionary: dictionary) as! T)
        case "#PoundErrorDecl":
            return (try makePoundErrorDecl(dictionary: dictionary) as! T)
        case "#PoundWarningDecl":
            return (try makePoundWarningDecl(dictionary: dictionary) as! T)
        case "#PoundSourceLocation":
            return (try makePoundSourceLocation(dictionary: dictionary) as! T)
        case "#PoundSourceLocationArgs":
            return (try makePoundSourceLocationArgs(dictionary: dictionary) as! T)
        case "#DeclModifier":
            return (try makeDeclModifier(dictionary: dictionary) as! T)
        case "#InheritedType":
            return (try makeInheritedType(dictionary: dictionary) as! T)
        case "#InheritedTypeList":
            return (try makeInheritedTypeList(dictionary: dictionary) as! T)
        case "#TypeInheritanceClause":
            return (try makeTypeInheritanceClause(dictionary: dictionary) as! T)
        case "#ClassDecl":
            return (try makeClassDecl(dictionary: dictionary) as! T)
        case "#StructDecl":
            return (try makeStructDecl(dictionary: dictionary) as! T)
        case "#ProtocolDecl":
            return (try makeProtocolDecl(dictionary: dictionary) as! T)
        case "#ExtensionDecl":
            return (try makeExtensionDecl(dictionary: dictionary) as! T)
        case "#MemberDeclBlock":
            return (try makeMemberDeclBlock(dictionary: dictionary) as! T)
        case "#MemberDeclList":
            return (try makeMemberDeclList(dictionary: dictionary) as! T)
        case "#MemberDeclListItem":
            return (try makeMemberDeclListItem(dictionary: dictionary) as! T)
        case "#SourceFile":
            return (try makeSourceFile(dictionary: dictionary) as! T)
        case "#InitializerClause":
            return (try makeInitializerClause(dictionary: dictionary) as! T)
        case "#FunctionParameter":
            return (try makeFunctionParameter(dictionary: dictionary) as! T)
        case "#ModifierList":
            return (try makeModifierList(dictionary: dictionary) as! T)
        case "#FunctionDecl":
            return (try makeFunctionDecl(dictionary: dictionary) as! T)
        case "#InitializerDecl":
            return (try makeInitializerDecl(dictionary: dictionary) as! T)
        case "#DeinitializerDecl":
            return (try makeDeinitializerDecl(dictionary: dictionary) as! T)
        case "#SubscriptDecl":
            return (try makeSubscriptDecl(dictionary: dictionary) as! T)
        case "#AccessLevelModifier":
            return (try makeAccessLevelModifier(dictionary: dictionary) as! T)
        case "#AccessPathComponent":
            return (try makeAccessPathComponent(dictionary: dictionary) as! T)
        case "#AccessPath":
            return (try makeAccessPath(dictionary: dictionary) as! T)
        case "#ImportDecl":
            return (try makeImportDecl(dictionary: dictionary) as! T)
        case "#AccessorParameter":
            return (try makeAccessorParameter(dictionary: dictionary) as! T)
        case "#AccessorDecl":
            return (try makeAccessorDecl(dictionary: dictionary) as! T)
        case "#AccessorList":
            return (try makeAccessorList(dictionary: dictionary) as! T)
        case "#AccessorBlock":
            return (try makeAccessorBlock(dictionary: dictionary) as! T)
        case "#PatternBinding":
            return (try makePatternBinding(dictionary: dictionary) as! T)
        case "#PatternBindingList":
            return (try makePatternBindingList(dictionary: dictionary) as! T)
        case "#VariableDecl":
            return (try makeVariableDecl(dictionary: dictionary) as! T)
        case "#EnumCaseElement":
            return (try makeEnumCaseElement(dictionary: dictionary) as! T)
        case "#EnumCaseElementList":
            return (try makeEnumCaseElementList(dictionary: dictionary) as! T)
        case "#EnumCaseDecl":
            return (try makeEnumCaseDecl(dictionary: dictionary) as! T)
        case "#EnumDecl":
            return (try makeEnumDecl(dictionary: dictionary) as! T)
        case "#OperatorDecl":
            return (try makeOperatorDecl(dictionary: dictionary) as! T)
        case "#IdentifierList":
            return (try makeIdentifierList(dictionary: dictionary) as! T)
        case "#OperatorPrecedenceAndTypes":
            return (try makeOperatorPrecedenceAndTypes(dictionary: dictionary) as! T)
        case "#PrecedenceGroupDecl":
            return (try makePrecedenceGroupDecl(dictionary: dictionary) as! T)
        case "#PrecedenceGroupAttributeList":
            return (try makePrecedenceGroupAttributeList(dictionary: dictionary) as! T)
        case "#PrecedenceGroupRelation":
            return (try makePrecedenceGroupRelation(dictionary: dictionary) as! T)
        case "#PrecedenceGroupNameList":
            return (try makePrecedenceGroupNameList(dictionary: dictionary) as! T)
        case "#PrecedenceGroupNameElement":
            return (try makePrecedenceGroupNameElement(dictionary: dictionary) as! T)
        case "#PrecedenceGroupAssignment":
            return (try makePrecedenceGroupAssignment(dictionary: dictionary) as! T)
        case "#PrecedenceGroupAssociativity":
            return (try makePrecedenceGroupAssociativity(dictionary: dictionary) as! T)
        case "#TokenList":
            return (try makeTokenList(dictionary: dictionary) as! T)
        case "#CustomAttribute":
            return (try makeCustomAttribute(dictionary: dictionary) as! T)
        case "#Attribute":
            return (try makeAttribute(dictionary: dictionary) as! T)
        case "#AttributeList":
            return (try makeAttributeList(dictionary: dictionary) as! T)
        case "#SpecializeAttributeSpecList":
            return (try makeSpecializeAttributeSpecList(dictionary: dictionary) as! T)
        case "#LabeledSpecializeEntry":
            return (try makeLabeledSpecializeEntry(dictionary: dictionary) as! T)
        case "#NamedAttributeStringArgument":
            return (try makeNamedAttributeStringArgument(dictionary: dictionary) as! T)
        case "#DeclName":
            return (try makeDeclName(dictionary: dictionary) as! T)
        case "#ImplementsAttributeArguments":
            return (try makeImplementsAttributeArguments(dictionary: dictionary) as! T)
        case "#ObjCSelectorPiece":
            return (try makeObjCSelectorPiece(dictionary: dictionary) as! T)
        case "#ObjCSelector":
            return (try makeObjCSelector(dictionary: dictionary) as! T)
        case "#ContinueStmt":
            return (try makeContinueStmt(dictionary: dictionary) as! T)
        case "#WhileStmt":
            return (try makeWhileStmt(dictionary: dictionary) as! T)
        case "#DeferStmt":
            return (try makeDeferStmt(dictionary: dictionary) as! T)
        case "#SwitchCaseList":
            return (try makeSwitchCaseList(dictionary: dictionary) as! T)
        case "#RepeatWhileStmt":
            return (try makeRepeatWhileStmt(dictionary: dictionary) as! T)
        case "#GuardStmt":
            return (try makeGuardStmt(dictionary: dictionary) as! T)
        case "#WhereClause":
            return (try makeWhereClause(dictionary: dictionary) as! T)
        case "#ForInStmt":
            return (try makeForInStmt(dictionary: dictionary) as! T)
        case "#SwitchStmt":
            return (try makeSwitchStmt(dictionary: dictionary) as! T)
        case "#CatchClauseList":
            return (try makeCatchClauseList(dictionary: dictionary) as! T)
        case "#DoStmt":
            return (try makeDoStmt(dictionary: dictionary) as! T)
        case "#ReturnStmt":
            return (try makeReturnStmt(dictionary: dictionary) as! T)
        case "#YieldStmt":
            return (try makeYieldStmt(dictionary: dictionary) as! T)
        case "#YieldList":
            return (try makeYieldList(dictionary: dictionary) as! T)
        case "#FallthroughStmt":
            return (try makeFallthroughStmt(dictionary: dictionary) as! T)
        case "#BreakStmt":
            return (try makeBreakStmt(dictionary: dictionary) as! T)
        case "#CaseItemList":
            return (try makeCaseItemList(dictionary: dictionary) as! T)
        case "#ConditionElement":
            return (try makeConditionElement(dictionary: dictionary) as! T)
        case "#AvailabilityCondition":
            return (try makeAvailabilityCondition(dictionary: dictionary) as! T)
        case "#MatchingPatternCondition":
            return (try makeMatchingPatternCondition(dictionary: dictionary) as! T)
        case "#OptionalBindingCondition":
            return (try makeOptionalBindingCondition(dictionary: dictionary) as! T)
        case "#ConditionElementList":
            return (try makeConditionElementList(dictionary: dictionary) as! T)
        case "#ThrowStmt":
            return (try makeThrowStmt(dictionary: dictionary) as! T)
        case "#IfStmt":
            return (try makeIfStmt(dictionary: dictionary) as! T)
        case "#SwitchCase":
            return (try makeSwitchCase(dictionary: dictionary) as! T)
        case "#SwitchDefaultLabel":
            return (try makeSwitchDefaultLabel(dictionary: dictionary) as! T)
        case "#CaseItem":
            return (try makeCaseItem(dictionary: dictionary) as! T)
        case "#SwitchCaseLabel":
            return (try makeSwitchCaseLabel(dictionary: dictionary) as! T)
        case "#CatchClause":
            return (try makeCatchClause(dictionary: dictionary) as! T)
        case "#PoundAssertStmt":
            return (try makePoundAssertStmt(dictionary: dictionary) as! T)
        case "#GenericWhereClause":
            return (try makeGenericWhereClause(dictionary: dictionary) as! T)
        case "#GenericRequirementList":
            return (try makeGenericRequirementList(dictionary: dictionary) as! T)
        case "#SameTypeRequirement":
            return (try makeSameTypeRequirement(dictionary: dictionary) as! T)
        case "#GenericParameterList":
            return (try makeGenericParameterList(dictionary: dictionary) as! T)
        case "#GenericParameter":
            return (try makeGenericParameter(dictionary: dictionary) as! T)
        case "#GenericParameterClause":
            return (try makeGenericParameterClause(dictionary: dictionary) as! T)
        case "#ConformanceRequirement":
            return (try makeConformanceRequirement(dictionary: dictionary) as! T)
        case "#SimpleTypeIdentifier":
            return (try makeSimpleTypeIdentifier(dictionary: dictionary) as! T)
        case "#MemberTypeIdentifier":
            return (try makeMemberTypeIdentifier(dictionary: dictionary) as! T)
        case "#ClassRestrictionType":
            return (try makeClassRestrictionType(dictionary: dictionary) as! T)
        case "#ArrayType":
            return (try makeArrayType(dictionary: dictionary) as! T)
        case "#DictionaryType":
            return (try makeDictionaryType(dictionary: dictionary) as! T)
        case "#MetatypeType":
            return (try makeMetatypeType(dictionary: dictionary) as! T)
        case "#OptionalType":
            return (try makeOptionalType(dictionary: dictionary) as! T)
        case "#SomeType":
            return (try makeSomeType(dictionary: dictionary) as! T)
        case "#ImplicitlyUnwrappedOptionalType":
            return (try makeImplicitlyUnwrappedOptionalType(dictionary: dictionary) as! T)
        case "#CompositionTypeElement":
            return (try makeCompositionTypeElement(dictionary: dictionary) as! T)
        case "#CompositionTypeElementList":
            return (try makeCompositionTypeElementList(dictionary: dictionary) as! T)
        case "#CompositionType":
            return (try makeCompositionType(dictionary: dictionary) as! T)
        case "#TupleTypeElement":
            return (try makeTupleTypeElement(dictionary: dictionary) as! T)
        case "#TupleTypeElementList":
            return (try makeTupleTypeElementList(dictionary: dictionary) as! T)
        case "#TupleType":
            return (try makeTupleType(dictionary: dictionary) as! T)
        case "#FunctionType":
            return (try makeFunctionType(dictionary: dictionary) as! T)
        case "#AttributedType":
            return (try makeAttributedType(dictionary: dictionary) as! T)
        case "#GenericArgumentList":
            return (try makeGenericArgumentList(dictionary: dictionary) as! T)
        case "#GenericArgument":
            return (try makeGenericArgument(dictionary: dictionary) as! T)
        case "#GenericArgumentClause":
            return (try makeGenericArgumentClause(dictionary: dictionary) as! T)
        case "#TypeAnnotation":
            return (try makeTypeAnnotation(dictionary: dictionary) as! T)
        case "#EnumCasePattern":
            return (try makeEnumCasePattern(dictionary: dictionary) as! T)
        case "#IsTypePattern":
            return (try makeIsTypePattern(dictionary: dictionary) as! T)
        case "#OptionalPattern":
            return (try makeOptionalPattern(dictionary: dictionary) as! T)
        case "#IdentifierPattern":
            return (try makeIdentifierPattern(dictionary: dictionary) as! T)
        case "#AsTypePattern":
            return (try makeAsTypePattern(dictionary: dictionary) as! T)
        case "#TuplePattern":
            return (try makeTuplePattern(dictionary: dictionary) as! T)
        case "#WildcardPattern":
            return (try makeWildcardPattern(dictionary: dictionary) as! T)
        case "#TuplePatternElement":
            return (try makeTuplePatternElement(dictionary: dictionary) as! T)
        case "#ExpressionPattern":
            return (try makeExpressionPattern(dictionary: dictionary) as! T)
        case "#TuplePatternElementList":
            return (try makeTuplePatternElementList(dictionary: dictionary) as! T)
        case "#ValueBindingPattern":
            return (try makeValueBindingPattern(dictionary: dictionary) as! T)
        case "#AvailabilitySpecList":
            return (try makeAvailabilitySpecList(dictionary: dictionary) as! T)
        case "#AvailabilityArgument":
            return (try makeAvailabilityArgument(dictionary: dictionary) as! T)
        case "#AvailabilityLabeledArgument":
            return (try makeAvailabilityLabeledArgument(dictionary: dictionary) as! T)
        case "#AvailabilityVersionRestriction":
            return (try makeAvailabilityVersionRestriction(dictionary: dictionary) as! T)
        case "#VersionTuple":
            return (try makeVersionTuple(dictionary: dictionary) as! T)
        default:
            throw ConversionError.unknownType(typeName)
        }
    }

    func makeToken(dictionary: [String: Any]) throws -> TokenSyntax {
        let text = try makeText(dictionary:  dictionary["text"] as? [String: Any])
        let kind = try makeTokenKind(dictionary: dictionary["kind"] as! [String: Any], withText: text)
        let presence = try makeSourcePresence(dictionary: dictionary["presence"] as! [String: Any])
        let leadingTrivia = try makeTrivia(dictionary: dictionary["leadingTrivia"] as! [String: Any])
        let trailingTrivia = try makeTrivia(dictionary: dictionary["trailingTrivia"] as! [String: Any])
        return SyntaxFactory.makeToken(kind,
                                       presence: presence,
                                       leadingTrivia: leadingTrivia,
                                       trailingTrivia: trailingTrivia)
    }
    func makeUnknownDecl(dictionary: [String: Any]) throws -> UnknownDeclSyntax {
        throw ConversionError.notImplemented("UnknownDeclSyntax")
    }
    func makeUnknownExpr(dictionary: [String: Any]) throws -> UnknownExprSyntax {
        throw ConversionError.notImplemented("UnknownExprSyntax")
    }
    func makeUnknownPattern(dictionary: [String: Any]) throws -> UnknownPatternSyntax {
        throw ConversionError.notImplemented("UnknownPatternSyntax")
    }
    func makeUnknownStmt(dictionary: [String: Any]) throws -> UnknownStmtSyntax {
        throw ConversionError.notImplemented("UnknownStmtSyntax")
    }
    func makeUnknownType(dictionary: [String: Any]) throws -> UnknownTypeSyntax {
        throw ConversionError.notImplemented("UnknownTypeSyntax")
    }
    func makeCodeBlockItem(dictionary: [String: Any]) throws -> CodeBlockItemSyntax {
        let item : Syntax? = try makeSyntax(dictionary: dictionary["item"] as? [String: Any] ?? resolver)
        let semicolon : TokenSyntax? = try makeSyntax(dictionary: dictionary["semicolon"] as? [String: Any] ?? resolver)
        let errorTokens : Syntax? = try makeSyntax(dictionary: dictionary["errorTokens"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeCodeBlockItem(item: item!, semicolon: semicolon, errorTokens: errorTokens)
    }
    func makeCodeBlockItemList(dictionary: [String: Any]) throws -> CodeBlockItemListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [CodeBlockItemSyntax]()
        for dictionary in array {
            let element: CodeBlockItemSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeCodeBlockItemList(elements)
    }
    func makeCodeBlock(dictionary: [String: Any]) throws -> CodeBlockSyntax {
        let leftBrace : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftBrace"] as? [String: Any] ?? resolver)
        let statements : CodeBlockItemListSyntax? = try makeSyntax(dictionary: dictionary["statements"] as? [String: Any] ?? resolver)
        let rightBrace : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightBrace"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeCodeBlock(leftBrace: leftBrace!, statements: statements!, rightBrace: rightBrace!)
    }
    func makeInOutExpr(dictionary: [String: Any]) throws -> InOutExprSyntax {
        let ampersand : TokenSyntax? = try makeSyntax(dictionary: dictionary["ampersand"] as? [String: Any] ?? resolver)
        let expression : ExprSyntax? = try makeSyntax(dictionary: dictionary["expression"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeInOutExpr(ampersand: ampersand!, expression: expression!)
    }
    func makePoundColumnExpr(dictionary: [String: Any]) throws -> PoundColumnExprSyntax {
        let poundColumn : TokenSyntax? = try makeSyntax(dictionary: dictionary["poundColumn"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePoundColumnExpr(poundColumn: poundColumn!)
    }
    func makeFunctionCallArgumentList(dictionary: [String: Any]) throws -> FunctionCallArgumentListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [FunctionCallArgumentSyntax]()
        for dictionary in array {
            let element: FunctionCallArgumentSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeFunctionCallArgumentList(elements)
    }
    func makeTupleElementList(dictionary: [String: Any]) throws -> TupleElementListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [TupleElementSyntax]()
        for dictionary in array {
            let element: TupleElementSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeTupleElementList(elements)
    }
    func makeArrayElementList(dictionary: [String: Any]) throws -> ArrayElementListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [ArrayElementSyntax]()
        for dictionary in array {
            let element: ArrayElementSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeArrayElementList(elements)
    }
    func makeDictionaryElementList(dictionary: [String: Any]) throws -> DictionaryElementListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [DictionaryElementSyntax]()
        for dictionary in array {
            let element: DictionaryElementSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeDictionaryElementList(elements)
    }
    func makeStringLiteralSegments(dictionary: [String: Any]) throws -> StringLiteralSegmentsSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [Syntax]()
        for dictionary in array {
            let element: Syntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeStringLiteralSegments(elements)
    }
    func makeTryExpr(dictionary: [String: Any]) throws -> TryExprSyntax {
        let tryKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["tryKeyword"] as? [String: Any] ?? resolver)
        let questionOrExclamationMark : TokenSyntax? = try makeSyntax(dictionary: dictionary["questionOrExclamationMark"] as? [String: Any] ?? resolver)
        let expression : ExprSyntax? = try makeSyntax(dictionary: dictionary["expression"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeTryExpr(tryKeyword: tryKeyword!, questionOrExclamationMark: questionOrExclamationMark, expression: expression!)
    }
    func makeDeclNameArgument(dictionary: [String: Any]) throws -> DeclNameArgumentSyntax {
        let name : TokenSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeDeclNameArgument(name: name!, colon: colon!)
    }
    func makeDeclNameArgumentList(dictionary: [String: Any]) throws -> DeclNameArgumentListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [DeclNameArgumentSyntax]()
        for dictionary in array {
            let element: DeclNameArgumentSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeDeclNameArgumentList(elements)
    }
    func makeDeclNameArguments(dictionary: [String: Any]) throws -> DeclNameArgumentsSyntax {
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let arguments : DeclNameArgumentListSyntax? = try makeSyntax(dictionary: dictionary["arguments"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeDeclNameArguments(leftParen: leftParen!, arguments: arguments!, rightParen: rightParen!)
    }
    func makeIdentifierExpr(dictionary: [String: Any]) throws -> IdentifierExprSyntax {
        let identifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["identifier"] as? [String: Any] ?? resolver)
        let declNameArguments : DeclNameArgumentsSyntax? = try makeSyntax(dictionary: dictionary["declNameArguments"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeIdentifierExpr(identifier: identifier!, declNameArguments: declNameArguments)
    }
    func makeSuperRefExpr(dictionary: [String: Any]) throws -> SuperRefExprSyntax {
        let superKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["superKeyword"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeSuperRefExpr(superKeyword: superKeyword!)
    }
    func makeNilLiteralExpr(dictionary: [String: Any]) throws -> NilLiteralExprSyntax {
        let nilKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["nilKeyword"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeNilLiteralExpr(nilKeyword: nilKeyword!)
    }
    func makeDiscardAssignmentExpr(dictionary: [String: Any]) throws -> DiscardAssignmentExprSyntax {
        let wildcard : TokenSyntax? = try makeSyntax(dictionary: dictionary["wildcard"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeDiscardAssignmentExpr(wildcard: wildcard!)
    }
    func makeAssignmentExpr(dictionary: [String: Any]) throws -> AssignmentExprSyntax {
        let assignToken : TokenSyntax? = try makeSyntax(dictionary: dictionary["assignToken"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeAssignmentExpr(assignToken: assignToken!)
    }
    func makeSequenceExpr(dictionary: [String: Any]) throws -> SequenceExprSyntax {
        let elements : ExprListSyntax? = try makeSyntax(dictionary: dictionary["elements"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeSequenceExpr(elements: elements!)
    }
    func makeExprList(dictionary: [String: Any]) throws -> ExprListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [ExprSyntax]()
        for dictionary in array {
            let element: ExprSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeExprList(elements)
    }
    func makePoundLineExpr(dictionary: [String: Any]) throws -> PoundLineExprSyntax {
        let poundLine : TokenSyntax? = try makeSyntax(dictionary: dictionary["poundLine"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePoundLineExpr(poundLine: poundLine!)
    }
    func makePoundFileExpr(dictionary: [String: Any]) throws -> PoundFileExprSyntax {
        let poundFile : TokenSyntax? = try makeSyntax(dictionary: dictionary["poundFile"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePoundFileExpr(poundFile: poundFile!)
    }
    func makePoundFunctionExpr(dictionary: [String: Any]) throws -> PoundFunctionExprSyntax {
        let poundFunction : TokenSyntax? = try makeSyntax(dictionary: dictionary["poundFunction"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePoundFunctionExpr(poundFunction: poundFunction!)
    }
    func makePoundDsohandleExpr(dictionary: [String: Any]) throws -> PoundDsohandleExprSyntax {
        let poundDsohandle : TokenSyntax? = try makeSyntax(dictionary: dictionary["poundDsohandle"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePoundDsohandleExpr(poundDsohandle: poundDsohandle!)
    }
    func makeSymbolicReferenceExpr(dictionary: [String: Any]) throws -> SymbolicReferenceExprSyntax {
        let identifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["identifier"] as? [String: Any] ?? resolver)
        let genericArgumentClause : GenericArgumentClauseSyntax? = try makeSyntax(dictionary: dictionary["genericArgumentClause"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeSymbolicReferenceExpr(identifier: identifier!, genericArgumentClause: genericArgumentClause)
    }
    func makePrefixOperatorExpr(dictionary: [String: Any]) throws -> PrefixOperatorExprSyntax {
        let operatorToken : TokenSyntax? = try makeSyntax(dictionary: dictionary["operatorToken"] as? [String: Any] ?? resolver)
        let postfixExpression : ExprSyntax? = try makeSyntax(dictionary: dictionary["postfixExpression"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePrefixOperatorExpr(operatorToken: operatorToken, postfixExpression: postfixExpression!)
    }
    func makeBinaryOperatorExpr(dictionary: [String: Any]) throws -> BinaryOperatorExprSyntax {
        let operatorToken : TokenSyntax? = try makeSyntax(dictionary: dictionary["operatorToken"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeBinaryOperatorExpr(operatorToken: operatorToken!)
    }
    func makeArrowExpr(dictionary: [String: Any]) throws -> ArrowExprSyntax {
        let throwsToken : TokenSyntax? = try makeSyntax(dictionary: dictionary["throwsToken"] as? [String: Any] ?? resolver)
        let arrowToken : TokenSyntax? = try makeSyntax(dictionary: dictionary["arrowToken"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeArrowExpr(throwsToken: throwsToken, arrowToken: arrowToken!)
    }
    func makeFloatLiteralExpr(dictionary: [String: Any]) throws -> FloatLiteralExprSyntax {
        let floatingDigits : TokenSyntax? = try makeSyntax(dictionary: dictionary["floatingDigits"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeFloatLiteralExpr(floatingDigits: floatingDigits!)
    }
    func makeTupleExpr(dictionary: [String: Any]) throws -> TupleExprSyntax {
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let elementList : TupleElementListSyntax? = try makeSyntax(dictionary: dictionary["elementList"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeTupleExpr(leftParen: leftParen!, elementList: elementList!, rightParen: rightParen!)
    }
    func makeArrayExpr(dictionary: [String: Any]) throws -> ArrayExprSyntax {
        let leftSquare : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftSquare"] as? [String: Any] ?? resolver)
        let elements : ArrayElementListSyntax? = try makeSyntax(dictionary: dictionary["elements"] as? [String: Any] ?? resolver)
        let rightSquare : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightSquare"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeArrayExpr(leftSquare: leftSquare!, elements: elements!, rightSquare: rightSquare!)
    }
    func makeDictionaryExpr(dictionary: [String: Any]) throws -> DictionaryExprSyntax {
        let leftSquare : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftSquare"] as? [String: Any] ?? resolver)
        let content : Syntax? = try makeSyntax(dictionary: dictionary["content"] as? [String: Any] ?? resolver)
        let rightSquare : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightSquare"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeDictionaryExpr(leftSquare: leftSquare!, content: content!, rightSquare: rightSquare!)
    }
    func makeFunctionCallArgument(dictionary: [String: Any]) throws -> FunctionCallArgumentSyntax {
        let label : TokenSyntax? = try makeSyntax(dictionary: dictionary["label"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let expression : ExprSyntax? = try makeSyntax(dictionary: dictionary["expression"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeFunctionCallArgument(label: label, colon: colon, expression: expression!, trailingComma: trailingComma)
    }
    func makeTupleElement(dictionary: [String: Any]) throws -> TupleElementSyntax {
        let label : TokenSyntax? = try makeSyntax(dictionary: dictionary["label"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let expression : ExprSyntax? = try makeSyntax(dictionary: dictionary["expression"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeTupleElement(label: label, colon: colon, expression: expression!, trailingComma: trailingComma)
    }
    func makeArrayElement(dictionary: [String: Any]) throws -> ArrayElementSyntax {
        let expression : ExprSyntax? = try makeSyntax(dictionary: dictionary["expression"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeArrayElement(expression: expression!, trailingComma: trailingComma)
    }
    func makeDictionaryElement(dictionary: [String: Any]) throws -> DictionaryElementSyntax {
        let keyExpression : ExprSyntax? = try makeSyntax(dictionary: dictionary["keyExpression"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let valueExpression : ExprSyntax? = try makeSyntax(dictionary: dictionary["valueExpression"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeDictionaryElement(keyExpression: keyExpression!, colon: colon!, valueExpression: valueExpression!, trailingComma: trailingComma)
    }
    func makeIntegerLiteralExpr(dictionary: [String: Any]) throws -> IntegerLiteralExprSyntax {
        let digits : TokenSyntax? = try makeSyntax(dictionary: dictionary["digits"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeIntegerLiteralExpr(digits: digits!)
    }
    func makeBooleanLiteralExpr(dictionary: [String: Any]) throws -> BooleanLiteralExprSyntax {
        let booleanLiteral : TokenSyntax? = try makeSyntax(dictionary: dictionary["booleanLiteral"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeBooleanLiteralExpr(booleanLiteral: booleanLiteral!)
    }
    func makeTernaryExpr(dictionary: [String: Any]) throws -> TernaryExprSyntax {
        let conditionExpression : ExprSyntax? = try makeSyntax(dictionary: dictionary["conditionExpression"] as? [String: Any] ?? resolver)
        let questionMark : TokenSyntax? = try makeSyntax(dictionary: dictionary["questionMark"] as? [String: Any] ?? resolver)
        let firstChoice : ExprSyntax? = try makeSyntax(dictionary: dictionary["firstChoice"] as? [String: Any] ?? resolver)
        let colonMark : TokenSyntax? = try makeSyntax(dictionary: dictionary["colonMark"] as? [String: Any] ?? resolver)
        let secondChoice : ExprSyntax? = try makeSyntax(dictionary: dictionary["secondChoice"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeTernaryExpr(conditionExpression: conditionExpression!, questionMark: questionMark!, firstChoice: firstChoice!, colonMark: colonMark!, secondChoice: secondChoice!)
    }
    func makeMemberAccessExpr(dictionary: [String: Any]) throws -> MemberAccessExprSyntax {
        let base : ExprSyntax? = try makeSyntax(dictionary: dictionary["base"] as? [String: Any] ?? resolver)
        let dot : TokenSyntax? = try makeSyntax(dictionary: dictionary["dot"] as? [String: Any] ?? resolver)
        let name : TokenSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let declNameArguments : DeclNameArgumentsSyntax? = try makeSyntax(dictionary: dictionary["declNameArguments"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeMemberAccessExpr(base: base, dot: dot!, name: name!, declNameArguments: declNameArguments)
    }
    func makeIsExpr(dictionary: [String: Any]) throws -> IsExprSyntax {
        let isTok : TokenSyntax? = try makeSyntax(dictionary: dictionary["isTok"] as? [String: Any] ?? resolver)
        let typeName : TypeSyntax? = try makeSyntax(dictionary: dictionary["typeName"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeIsExpr(isTok: isTok!, typeName: typeName!)
    }
    func makeAsExpr(dictionary: [String: Any]) throws -> AsExprSyntax {
        let asTok : TokenSyntax? = try makeSyntax(dictionary: dictionary["asTok"] as? [String: Any] ?? resolver)
        let questionOrExclamationMark : TokenSyntax? = try makeSyntax(dictionary: dictionary["questionOrExclamationMark"] as? [String: Any] ?? resolver)
        let typeName : TypeSyntax? = try makeSyntax(dictionary: dictionary["typeName"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeAsExpr(asTok: asTok!, questionOrExclamationMark: questionOrExclamationMark, typeName: typeName!)
    }
    func makeTypeExpr(dictionary: [String: Any]) throws -> TypeExprSyntax {
        let type : TypeSyntax? = try makeSyntax(dictionary: dictionary["type"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeTypeExpr(type: type!)
    }
    func makeClosureCaptureItem(dictionary: [String: Any]) throws -> ClosureCaptureItemSyntax {
        let specifier : TokenListSyntax? = try makeSyntax(dictionary: dictionary["specifier"] as? [String: Any] ?? resolver)
        let name : TokenSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let assignToken : TokenSyntax? = try makeSyntax(dictionary: dictionary["assignToken"] as? [String: Any] ?? resolver)
        let expression : ExprSyntax? = try makeSyntax(dictionary: dictionary["expression"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeClosureCaptureItem(specifier: specifier, name: name, assignToken: assignToken, expression: expression!, trailingComma: trailingComma)
    }
    func makeClosureCaptureItemList(dictionary: [String: Any]) throws -> ClosureCaptureItemListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [ClosureCaptureItemSyntax]()
        for dictionary in array {
            let element: ClosureCaptureItemSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeClosureCaptureItemList(elements)
    }
    func makeClosureCaptureSignature(dictionary: [String: Any]) throws -> ClosureCaptureSignatureSyntax {
        let leftSquare : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftSquare"] as? [String: Any] ?? resolver)
        let items : ClosureCaptureItemListSyntax? = try makeSyntax(dictionary: dictionary["items"] as? [String: Any] ?? resolver)
        let rightSquare : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightSquare"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeClosureCaptureSignature(leftSquare: leftSquare!, items: items, rightSquare: rightSquare!)
    }
    func makeClosureParam(dictionary: [String: Any]) throws -> ClosureParamSyntax {
        let name : TokenSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeClosureParam(name: name!, trailingComma: trailingComma)
    }
    func makeClosureParamList(dictionary: [String: Any]) throws -> ClosureParamListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [ClosureParamSyntax]()
        for dictionary in array {
            let element: ClosureParamSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeClosureParamList(elements)
    }
    func makeClosureSignature(dictionary: [String: Any]) throws -> ClosureSignatureSyntax {
        let capture : ClosureCaptureSignatureSyntax? = try makeSyntax(dictionary: dictionary["capture"] as? [String: Any] ?? resolver)
        let input : Syntax? = try makeSyntax(dictionary: dictionary["input"] as? [String: Any] ?? resolver)
        let throwsTok : TokenSyntax? = try makeSyntax(dictionary: dictionary["throwsTok"] as? [String: Any] ?? resolver)
        let output : ReturnClauseSyntax? = try makeSyntax(dictionary: dictionary["output"] as? [String: Any] ?? resolver)
        let inTok : TokenSyntax? = try makeSyntax(dictionary: dictionary["inTok"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeClosureSignature(capture: capture, input: input, throwsTok: throwsTok, output: output, inTok: inTok!)
    }
    func makeClosureExpr(dictionary: [String: Any]) throws -> ClosureExprSyntax {
        let leftBrace : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftBrace"] as? [String: Any] ?? resolver)
        let signature : ClosureSignatureSyntax? = try makeSyntax(dictionary: dictionary["signature"] as? [String: Any] ?? resolver)
        let statements : CodeBlockItemListSyntax? = try makeSyntax(dictionary: dictionary["statements"] as? [String: Any] ?? resolver)
        let rightBrace : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightBrace"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeClosureExpr(leftBrace: leftBrace!, signature: signature, statements: statements!, rightBrace: rightBrace!)
    }
    func makeUnresolvedPatternExpr(dictionary: [String: Any]) throws -> UnresolvedPatternExprSyntax {
        let pattern : PatternSyntax? = try makeSyntax(dictionary: dictionary["pattern"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeUnresolvedPatternExpr(pattern: pattern!)
    }
    func makeFunctionCallExpr(dictionary: [String: Any]) throws -> FunctionCallExprSyntax {
        let calledExpression : ExprSyntax? = try makeSyntax(dictionary: dictionary["calledExpression"] as? [String: Any] ?? resolver)
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let argumentList : FunctionCallArgumentListSyntax? = try makeSyntax(dictionary: dictionary["argumentList"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        let trailingClosure : ClosureExprSyntax? = try makeSyntax(dictionary: dictionary["trailingClosure"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeFunctionCallExpr(calledExpression: calledExpression!, leftParen: leftParen, argumentList: argumentList!, rightParen: rightParen, trailingClosure: trailingClosure)
    }
    func makeSubscriptExpr(dictionary: [String: Any]) throws -> SubscriptExprSyntax {
        let calledExpression : ExprSyntax? = try makeSyntax(dictionary: dictionary["calledExpression"] as? [String: Any] ?? resolver)
        let leftBracket : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftBracket"] as? [String: Any] ?? resolver)
        let argumentList : FunctionCallArgumentListSyntax? = try makeSyntax(dictionary: dictionary["argumentList"] as? [String: Any] ?? resolver)
        let rightBracket : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightBracket"] as? [String: Any] ?? resolver)
        let trailingClosure : ClosureExprSyntax? = try makeSyntax(dictionary: dictionary["trailingClosure"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeSubscriptExpr(calledExpression: calledExpression!, leftBracket: leftBracket!, argumentList: argumentList!, rightBracket: rightBracket!, trailingClosure: trailingClosure)
    }
    func makeOptionalChainingExpr(dictionary: [String: Any]) throws -> OptionalChainingExprSyntax {
        let expression : ExprSyntax? = try makeSyntax(dictionary: dictionary["expression"] as? [String: Any] ?? resolver)
        let questionMark : TokenSyntax? = try makeSyntax(dictionary: dictionary["questionMark"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeOptionalChainingExpr(expression: expression!, questionMark: questionMark!)
    }
    func makeForcedValueExpr(dictionary: [String: Any]) throws -> ForcedValueExprSyntax {
        let expression : ExprSyntax? = try makeSyntax(dictionary: dictionary["expression"] as? [String: Any] ?? resolver)
        let exclamationMark : TokenSyntax? = try makeSyntax(dictionary: dictionary["exclamationMark"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeForcedValueExpr(expression: expression!, exclamationMark: exclamationMark!)
    }
    func makePostfixUnaryExpr(dictionary: [String: Any]) throws -> PostfixUnaryExprSyntax {
        let expression : ExprSyntax? = try makeSyntax(dictionary: dictionary["expression"] as? [String: Any] ?? resolver)
        let operatorToken : TokenSyntax? = try makeSyntax(dictionary: dictionary["operatorToken"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePostfixUnaryExpr(expression: expression!, operatorToken: operatorToken!)
    }
    func makeSpecializeExpr(dictionary: [String: Any]) throws -> SpecializeExprSyntax {
        let expression : ExprSyntax? = try makeSyntax(dictionary: dictionary["expression"] as? [String: Any] ?? resolver)
        let genericArgumentClause : GenericArgumentClauseSyntax? = try makeSyntax(dictionary: dictionary["genericArgumentClause"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeSpecializeExpr(expression: expression!, genericArgumentClause: genericArgumentClause!)
    }
    func makeStringSegment(dictionary: [String: Any]) throws -> StringSegmentSyntax {
        let content : TokenSyntax? = try makeSyntax(dictionary: dictionary["content"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeStringSegment(content: content!)
    }
    func makeExpressionSegment(dictionary: [String: Any]) throws -> ExpressionSegmentSyntax {
        let backslash : TokenSyntax? = try makeSyntax(dictionary: dictionary["backslash"] as? [String: Any] ?? resolver)
        let delimiter : TokenSyntax? = try makeSyntax(dictionary: dictionary["delimiter"] as? [String: Any] ?? resolver)
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let expressions : FunctionCallArgumentListSyntax? = try makeSyntax(dictionary: dictionary["expressions"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeExpressionSegment(backslash: backslash!, delimiter: delimiter, leftParen: leftParen!, expressions: expressions!, rightParen: rightParen!)
    }
    func makeStringLiteralExpr(dictionary: [String: Any]) throws -> StringLiteralExprSyntax {
        let openDelimiter : TokenSyntax? = try makeSyntax(dictionary: dictionary["openDelimiter"] as? [String: Any] ?? resolver)
        let openQuote : TokenSyntax? = try makeSyntax(dictionary: dictionary["openQuote"] as? [String: Any] ?? resolver)
        let segments : StringLiteralSegmentsSyntax? = try makeSyntax(dictionary: dictionary["segments"] as? [String: Any] ?? resolver)
        let closeQuote : TokenSyntax? = try makeSyntax(dictionary: dictionary["closeQuote"] as? [String: Any] ?? resolver)
        let closeDelimiter : TokenSyntax? = try makeSyntax(dictionary: dictionary["closeDelimiter"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeStringLiteralExpr(openDelimiter: openDelimiter, openQuote: openQuote!, segments: segments!, closeQuote: closeQuote!, closeDelimiter: closeDelimiter)
    }
    func makeKeyPathExpr(dictionary: [String: Any]) throws -> KeyPathExprSyntax {
        let backslash : TokenSyntax? = try makeSyntax(dictionary: dictionary["backslash"] as? [String: Any] ?? resolver)
        let rootExpr : ExprSyntax? = try makeSyntax(dictionary: dictionary["rootExpr"] as? [String: Any] ?? resolver)
        let expression : ExprSyntax? = try makeSyntax(dictionary: dictionary["expression"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeKeyPathExpr(backslash: backslash!, rootExpr: rootExpr, expression: expression!)
    }
    func makeKeyPathBaseExpr(dictionary: [String: Any]) throws -> KeyPathBaseExprSyntax {
        let period : TokenSyntax? = try makeSyntax(dictionary: dictionary["period"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeKeyPathBaseExpr(period: period!)
    }
    func makeObjcNamePiece(dictionary: [String: Any]) throws -> ObjcNamePieceSyntax {
        let name : TokenSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let dot : TokenSyntax? = try makeSyntax(dictionary: dictionary["dot"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeObjcNamePiece(name: name!, dot: dot)
    }
    func makeObjcName(dictionary: [String: Any]) throws -> ObjcNameSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [ObjcNamePieceSyntax]()
        for dictionary in array {
            let element: ObjcNamePieceSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeObjcName(elements)
    }
    func makeObjcKeyPathExpr(dictionary: [String: Any]) throws -> ObjcKeyPathExprSyntax {
        let keyPath : TokenSyntax? = try makeSyntax(dictionary: dictionary["keyPath"] as? [String: Any] ?? resolver)
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let name : ObjcNameSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeObjcKeyPathExpr(keyPath: keyPath!, leftParen: leftParen!, name: name!, rightParen: rightParen!)
    }
    func makeObjcSelectorExpr(dictionary: [String: Any]) throws -> ObjcSelectorExprSyntax {
        let poundSelector : TokenSyntax? = try makeSyntax(dictionary: dictionary["poundSelector"] as? [String: Any] ?? resolver)
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let kind : TokenSyntax? = try makeSyntax(dictionary: dictionary["kind"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let name : ExprSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeObjcSelectorExpr(poundSelector: poundSelector!, leftParen: leftParen!, kind: kind, colon: colon, name: name!, rightParen: rightParen!)
    }
    func makeEditorPlaceholderExpr(dictionary: [String: Any]) throws -> EditorPlaceholderExprSyntax {
        let identifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["identifier"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeEditorPlaceholderExpr(identifier: identifier!)
    }
    func makeObjectLiteralExpr(dictionary: [String: Any]) throws -> ObjectLiteralExprSyntax {
        let identifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["identifier"] as? [String: Any] ?? resolver)
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let arguments : FunctionCallArgumentListSyntax? = try makeSyntax(dictionary: dictionary["arguments"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeObjectLiteralExpr(identifier: identifier!, leftParen: leftParen!, arguments: arguments!, rightParen: rightParen!)
    }
    func makeTypeInitializerClause(dictionary: [String: Any]) throws -> TypeInitializerClauseSyntax {
        let equal : TokenSyntax? = try makeSyntax(dictionary: dictionary["equal"] as? [String: Any] ?? resolver)
        let value : TypeSyntax? = try makeSyntax(dictionary: dictionary["value"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeTypeInitializerClause(equal: equal!, value: value!)
    }
    func makeTypealiasDecl(dictionary: [String: Any]) throws -> TypealiasDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let typealiasKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["typealiasKeyword"] as? [String: Any] ?? resolver)
        let identifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["identifier"] as? [String: Any] ?? resolver)
        let genericParameterClause : GenericParameterClauseSyntax? = try makeSyntax(dictionary: dictionary["genericParameterClause"] as? [String: Any] ?? resolver)
        let initializer : TypeInitializerClauseSyntax? = try makeSyntax(dictionary: dictionary["initializer"] as? [String: Any] ?? resolver)
        let genericWhereClause : GenericWhereClauseSyntax? = try makeSyntax(dictionary: dictionary["genericWhereClause"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeTypealiasDecl(attributes: attributes, modifiers: modifiers, typealiasKeyword: typealiasKeyword!, identifier: identifier!, genericParameterClause: genericParameterClause, initializer: initializer, genericWhereClause: genericWhereClause)
    }
    func makeAssociatedtypeDecl(dictionary: [String: Any]) throws -> AssociatedtypeDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let associatedtypeKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["associatedtypeKeyword"] as? [String: Any] ?? resolver)
        let identifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["identifier"] as? [String: Any] ?? resolver)
        let inheritanceClause : TypeInheritanceClauseSyntax? = try makeSyntax(dictionary: dictionary["inheritanceClause"] as? [String: Any] ?? resolver)
        let initializer : TypeInitializerClauseSyntax? = try makeSyntax(dictionary: dictionary["initializer"] as? [String: Any] ?? resolver)
        let genericWhereClause : GenericWhereClauseSyntax? = try makeSyntax(dictionary: dictionary["genericWhereClause"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeAssociatedtypeDecl(attributes: attributes, modifiers: modifiers, associatedtypeKeyword: associatedtypeKeyword!, identifier: identifier!, inheritanceClause: inheritanceClause, initializer: initializer, genericWhereClause: genericWhereClause)
    }
    func makeFunctionParameterList(dictionary: [String: Any]) throws -> FunctionParameterListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [FunctionParameterSyntax]()
        for dictionary in array {
            let element: FunctionParameterSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeFunctionParameterList(elements)
    }
    func makeParameterClause(dictionary: [String: Any]) throws -> ParameterClauseSyntax {
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let parameterList : FunctionParameterListSyntax? = try makeSyntax(dictionary: dictionary["parameterList"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeParameterClause(leftParen: leftParen!, parameterList: parameterList!, rightParen: rightParen!)
    }
    func makeReturnClause(dictionary: [String: Any]) throws -> ReturnClauseSyntax {
        let arrow : TokenSyntax? = try makeSyntax(dictionary: dictionary["arrow"] as? [String: Any] ?? resolver)
        let returnType : TypeSyntax? = try makeSyntax(dictionary: dictionary["returnType"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeReturnClause(arrow: arrow!, returnType: returnType!)
    }
    func makeFunctionSignature(dictionary: [String: Any]) throws -> FunctionSignatureSyntax {
        let input : ParameterClauseSyntax? = try makeSyntax(dictionary: dictionary["input"] as? [String: Any] ?? resolver)
        let throwsOrRethrowsKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["throwsOrRethrowsKeyword"] as? [String: Any] ?? resolver)
        let output : ReturnClauseSyntax? = try makeSyntax(dictionary: dictionary["output"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeFunctionSignature(input: input!, throwsOrRethrowsKeyword: throwsOrRethrowsKeyword, output: output)
    }
    func makeIfConfigClause(dictionary: [String: Any]) throws -> IfConfigClauseSyntax {
        let poundKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["poundKeyword"] as? [String: Any] ?? resolver)
        let condition : ExprSyntax? = try makeSyntax(dictionary: dictionary["condition"] as? [String: Any] ?? resolver)
        let elements : Syntax? = try makeSyntax(dictionary: dictionary["elements"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeIfConfigClause(poundKeyword: poundKeyword!, condition: condition, elements: elements!)
    }
    func makeIfConfigClauseList(dictionary: [String: Any]) throws -> IfConfigClauseListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [IfConfigClauseSyntax]()
        for dictionary in array {
            let element: IfConfigClauseSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeIfConfigClauseList(elements)
    }
    func makeIfConfigDecl(dictionary: [String: Any]) throws -> IfConfigDeclSyntax {
        let clauses : IfConfigClauseListSyntax? = try makeSyntax(dictionary: dictionary["clauses"] as? [String: Any] ?? resolver)
        let poundEndif : TokenSyntax? = try makeSyntax(dictionary: dictionary["poundEndif"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeIfConfigDecl(clauses: clauses!, poundEndif: poundEndif!)
    }
    func makePoundErrorDecl(dictionary: [String: Any]) throws -> PoundErrorDeclSyntax {
        let poundError : TokenSyntax? = try makeSyntax(dictionary: dictionary["poundError"] as? [String: Any] ?? resolver)
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let message : StringLiteralExprSyntax? = try makeSyntax(dictionary: dictionary["message"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePoundErrorDecl(poundError: poundError!, leftParen: leftParen!, message: message!, rightParen: rightParen!)
    }
    func makePoundWarningDecl(dictionary: [String: Any]) throws -> PoundWarningDeclSyntax {
        let poundWarning : TokenSyntax? = try makeSyntax(dictionary: dictionary["poundWarning"] as? [String: Any] ?? resolver)
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let message : StringLiteralExprSyntax? = try makeSyntax(dictionary: dictionary["message"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePoundWarningDecl(poundWarning: poundWarning!, leftParen: leftParen!, message: message!, rightParen: rightParen!)
    }
    func makePoundSourceLocation(dictionary: [String: Any]) throws -> PoundSourceLocationSyntax {
        let poundSourceLocation : TokenSyntax? = try makeSyntax(dictionary: dictionary["poundSourceLocation"] as? [String: Any] ?? resolver)
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let args : PoundSourceLocationArgsSyntax? = try makeSyntax(dictionary: dictionary["args"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePoundSourceLocation(poundSourceLocation: poundSourceLocation!, leftParen: leftParen!, args: args, rightParen: rightParen!)
    }
    func makePoundSourceLocationArgs(dictionary: [String: Any]) throws -> PoundSourceLocationArgsSyntax {
        let fileArgLabel : TokenSyntax? = try makeSyntax(dictionary: dictionary["fileArgLabel"] as? [String: Any] ?? resolver)
        let fileArgColon : TokenSyntax? = try makeSyntax(dictionary: dictionary["fileArgColon"] as? [String: Any] ?? resolver)
        let fileName : TokenSyntax? = try makeSyntax(dictionary: dictionary["fileName"] as? [String: Any] ?? resolver)
        let comma : TokenSyntax? = try makeSyntax(dictionary: dictionary["comma"] as? [String: Any] ?? resolver)
        let lineArgLabel : TokenSyntax? = try makeSyntax(dictionary: dictionary["lineArgLabel"] as? [String: Any] ?? resolver)
        let lineArgColon : TokenSyntax? = try makeSyntax(dictionary: dictionary["lineArgColon"] as? [String: Any] ?? resolver)
        let lineNumber : TokenSyntax? = try makeSyntax(dictionary: dictionary["lineNumber"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePoundSourceLocationArgs(fileArgLabel: fileArgLabel!, fileArgColon: fileArgColon!, fileName: fileName!, comma: comma!, lineArgLabel: lineArgLabel!, lineArgColon: lineArgColon!, lineNumber: lineNumber!)
    }
    func makeDeclModifier(dictionary: [String: Any]) throws -> DeclModifierSyntax {
        let name : TokenSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let detailLeftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["detailLeftParen"] as? [String: Any] ?? resolver)
        let detail : TokenSyntax? = try makeSyntax(dictionary: dictionary["detail"] as? [String: Any] ?? resolver)
        let detailRightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["detailRightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeDeclModifier(name: name!, detailLeftParen: detailLeftParen, detail: detail, detailRightParen: detailRightParen)
    }
    func makeInheritedType(dictionary: [String: Any]) throws -> InheritedTypeSyntax {
        let typeName : TypeSyntax? = try makeSyntax(dictionary: dictionary["typeName"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeInheritedType(typeName: typeName!, trailingComma: trailingComma)
    }
    func makeInheritedTypeList(dictionary: [String: Any]) throws -> InheritedTypeListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [InheritedTypeSyntax]()
        for dictionary in array {
            let element: InheritedTypeSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeInheritedTypeList(elements)
    }
    func makeTypeInheritanceClause(dictionary: [String: Any]) throws -> TypeInheritanceClauseSyntax {
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let inheritedTypeCollection : InheritedTypeListSyntax? = try makeSyntax(dictionary: dictionary["inheritedTypeCollection"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeTypeInheritanceClause(colon: colon!, inheritedTypeCollection: inheritedTypeCollection!)
    }
    func makeClassDecl(dictionary: [String: Any]) throws -> ClassDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let classKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["classKeyword"] as? [String: Any] ?? resolver)
        let identifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["identifier"] as? [String: Any] ?? resolver)
        let genericParameterClause : GenericParameterClauseSyntax? = try makeSyntax(dictionary: dictionary["genericParameterClause"] as? [String: Any] ?? resolver)
        let inheritanceClause : TypeInheritanceClauseSyntax? = try makeSyntax(dictionary: dictionary["inheritanceClause"] as? [String: Any] ?? resolver)
        let genericWhereClause : GenericWhereClauseSyntax? = try makeSyntax(dictionary: dictionary["genericWhereClause"] as? [String: Any] ?? resolver)
        let members : MemberDeclBlockSyntax? = try makeSyntax(dictionary: dictionary["members"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeClassDecl(attributes: attributes, modifiers: modifiers, classKeyword: classKeyword!, identifier: identifier!, genericParameterClause: genericParameterClause, inheritanceClause: inheritanceClause, genericWhereClause: genericWhereClause, members: members!)
    }
    func makeStructDecl(dictionary: [String: Any]) throws -> StructDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let structKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["structKeyword"] as? [String: Any] ?? resolver)
        let identifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["identifier"] as? [String: Any] ?? resolver)
        let genericParameterClause : GenericParameterClauseSyntax? = try makeSyntax(dictionary: dictionary["genericParameterClause"] as? [String: Any] ?? resolver)
        let inheritanceClause : TypeInheritanceClauseSyntax? = try makeSyntax(dictionary: dictionary["inheritanceClause"] as? [String: Any] ?? resolver)
        let genericWhereClause : GenericWhereClauseSyntax? = try makeSyntax(dictionary: dictionary["genericWhereClause"] as? [String: Any] ?? resolver)
        let members : MemberDeclBlockSyntax? = try makeSyntax(dictionary: dictionary["members"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeStructDecl(attributes: attributes, modifiers: modifiers, structKeyword: structKeyword!, identifier: identifier!, genericParameterClause: genericParameterClause, inheritanceClause: inheritanceClause, genericWhereClause: genericWhereClause, members: members!)
    }
    func makeProtocolDecl(dictionary: [String: Any]) throws -> ProtocolDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let protocolKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["protocolKeyword"] as? [String: Any] ?? resolver)
        let identifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["identifier"] as? [String: Any] ?? resolver)
        let inheritanceClause : TypeInheritanceClauseSyntax? = try makeSyntax(dictionary: dictionary["inheritanceClause"] as? [String: Any] ?? resolver)
        let genericWhereClause : GenericWhereClauseSyntax? = try makeSyntax(dictionary: dictionary["genericWhereClause"] as? [String: Any] ?? resolver)
        let members : MemberDeclBlockSyntax? = try makeSyntax(dictionary: dictionary["members"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeProtocolDecl(attributes: attributes, modifiers: modifiers, protocolKeyword: protocolKeyword!, identifier: identifier!, inheritanceClause: inheritanceClause, genericWhereClause: genericWhereClause, members: members!)
    }
    func makeExtensionDecl(dictionary: [String: Any]) throws -> ExtensionDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let extensionKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["extensionKeyword"] as? [String: Any] ?? resolver)
        let extendedType : TypeSyntax? = try makeSyntax(dictionary: dictionary["extendedType"] as? [String: Any] ?? resolver)
        let inheritanceClause : TypeInheritanceClauseSyntax? = try makeSyntax(dictionary: dictionary["inheritanceClause"] as? [String: Any] ?? resolver)
        let genericWhereClause : GenericWhereClauseSyntax? = try makeSyntax(dictionary: dictionary["genericWhereClause"] as? [String: Any] ?? resolver)
        let members : MemberDeclBlockSyntax? = try makeSyntax(dictionary: dictionary["members"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeExtensionDecl(attributes: attributes, modifiers: modifiers, extensionKeyword: extensionKeyword!, extendedType: extendedType!, inheritanceClause: inheritanceClause, genericWhereClause: genericWhereClause, members: members!)
    }
    func makeMemberDeclBlock(dictionary: [String: Any]) throws -> MemberDeclBlockSyntax {
        let leftBrace : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftBrace"] as? [String: Any] ?? resolver)
        let members : MemberDeclListSyntax? = try makeSyntax(dictionary: dictionary["members"] as? [String: Any] ?? resolver)
        let rightBrace : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightBrace"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeMemberDeclBlock(leftBrace: leftBrace!, members: members!, rightBrace: rightBrace!)
    }
    func makeMemberDeclList(dictionary: [String: Any]) throws -> MemberDeclListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [MemberDeclListItemSyntax]()
        for dictionary in array {
            let element: MemberDeclListItemSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeMemberDeclList(elements)
    }
    func makeMemberDeclListItem(dictionary: [String: Any]) throws -> MemberDeclListItemSyntax {
        let decl : DeclSyntax? = try makeSyntax(dictionary: dictionary["decl"] as? [String: Any] ?? resolver)
        let semicolon : TokenSyntax? = try makeSyntax(dictionary: dictionary["semicolon"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeMemberDeclListItem(decl: decl!, semicolon: semicolon)
    }
    func makeSourceFile(dictionary: [String: Any]) throws -> SourceFileSyntax {
        let statements : CodeBlockItemListSyntax? = try makeSyntax(dictionary: dictionary["statements"] as? [String: Any] ?? resolver)
        let eofToken : TokenSyntax? = try makeSyntax(dictionary: dictionary["eofToken"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeSourceFile(statements: statements!, eofToken: eofToken!)
    }
    func makeInitializerClause(dictionary: [String: Any]) throws -> InitializerClauseSyntax {
        let equal : TokenSyntax? = try makeSyntax(dictionary: dictionary["equal"] as? [String: Any] ?? resolver)
        let value : ExprSyntax? = try makeSyntax(dictionary: dictionary["value"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeInitializerClause(equal: equal!, value: value!)
    }
    func makeFunctionParameter(dictionary: [String: Any]) throws -> FunctionParameterSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let firstName : TokenSyntax? = try makeSyntax(dictionary: dictionary["firstName"] as? [String: Any] ?? resolver)
        let secondName : TokenSyntax? = try makeSyntax(dictionary: dictionary["secondName"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let type : TypeSyntax? = try makeSyntax(dictionary: dictionary["type"] as? [String: Any] ?? resolver)
        let ellipsis : TokenSyntax? = try makeSyntax(dictionary: dictionary["ellipsis"] as? [String: Any] ?? resolver)
        let defaultArgument : InitializerClauseSyntax? = try makeSyntax(dictionary: dictionary["defaultArgument"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeFunctionParameter(attributes: attributes, firstName: firstName, secondName: secondName, colon: colon, type: type, ellipsis: ellipsis, defaultArgument: defaultArgument, trailingComma: trailingComma)
    }
    func makeModifierList(dictionary: [String: Any]) throws -> ModifierListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [DeclModifierSyntax]()
        for dictionary in array {
            let element: DeclModifierSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeModifierList(elements)
    }
    func makeFunctionDecl(dictionary: [String: Any]) throws -> FunctionDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let funcKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["funcKeyword"] as? [String: Any] ?? resolver)
        let identifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["identifier"] as? [String: Any] ?? resolver)
        let genericParameterClause : GenericParameterClauseSyntax? = try makeSyntax(dictionary: dictionary["genericParameterClause"] as? [String: Any] ?? resolver)
        let signature : FunctionSignatureSyntax? = try makeSyntax(dictionary: dictionary["signature"] as? [String: Any] ?? resolver)
        let genericWhereClause : GenericWhereClauseSyntax? = try makeSyntax(dictionary: dictionary["genericWhereClause"] as? [String: Any] ?? resolver)
        let body : CodeBlockSyntax? = try makeSyntax(dictionary: dictionary["body"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeFunctionDecl(attributes: attributes, modifiers: modifiers, funcKeyword: funcKeyword!, identifier: identifier!, genericParameterClause: genericParameterClause, signature: signature!, genericWhereClause: genericWhereClause, body: body)
    }
    func makeInitializerDecl(dictionary: [String: Any]) throws -> InitializerDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let initKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["initKeyword"] as? [String: Any] ?? resolver)
        let optionalMark : TokenSyntax? = try makeSyntax(dictionary: dictionary["optionalMark"] as? [String: Any] ?? resolver)
        let genericParameterClause : GenericParameterClauseSyntax? = try makeSyntax(dictionary: dictionary["genericParameterClause"] as? [String: Any] ?? resolver)
        let parameters : ParameterClauseSyntax? = try makeSyntax(dictionary: dictionary["parameters"] as? [String: Any] ?? resolver)
        let throwsOrRethrowsKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["throwsOrRethrowsKeyword"] as? [String: Any] ?? resolver)
        let genericWhereClause : GenericWhereClauseSyntax? = try makeSyntax(dictionary: dictionary["genericWhereClause"] as? [String: Any] ?? resolver)
        let body : CodeBlockSyntax? = try makeSyntax(dictionary: dictionary["body"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeInitializerDecl(attributes: attributes, modifiers: modifiers, initKeyword: initKeyword!, optionalMark: optionalMark, genericParameterClause: genericParameterClause, parameters: parameters!, throwsOrRethrowsKeyword: throwsOrRethrowsKeyword, genericWhereClause: genericWhereClause, body: body)
    }
    func makeDeinitializerDecl(dictionary: [String: Any]) throws -> DeinitializerDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let deinitKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["deinitKeyword"] as? [String: Any] ?? resolver)
        let body : CodeBlockSyntax? = try makeSyntax(dictionary: dictionary["body"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeDeinitializerDecl(attributes: attributes, modifiers: modifiers, deinitKeyword: deinitKeyword!, body: body!)
    }
    func makeSubscriptDecl(dictionary: [String: Any]) throws -> SubscriptDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let subscriptKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["subscriptKeyword"] as? [String: Any] ?? resolver)
        let genericParameterClause : GenericParameterClauseSyntax? = try makeSyntax(dictionary: dictionary["genericParameterClause"] as? [String: Any] ?? resolver)
        let indices : ParameterClauseSyntax? = try makeSyntax(dictionary: dictionary["indices"] as? [String: Any] ?? resolver)
        let result : ReturnClauseSyntax? = try makeSyntax(dictionary: dictionary["result"] as? [String: Any] ?? resolver)
        let genericWhereClause : GenericWhereClauseSyntax? = try makeSyntax(dictionary: dictionary["genericWhereClause"] as? [String: Any] ?? resolver)
        let accessor : Syntax? = try makeSyntax(dictionary: dictionary["accessor"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeSubscriptDecl(attributes: attributes, modifiers: modifiers, subscriptKeyword: subscriptKeyword!, genericParameterClause: genericParameterClause, indices: indices!, result: result!, genericWhereClause: genericWhereClause, accessor: accessor)
    }
    func makeAccessLevelModifier(dictionary: [String: Any]) throws -> AccessLevelModifierSyntax {
        let name : TokenSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let modifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["modifier"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeAccessLevelModifier(name: name!, leftParen: leftParen, modifier: modifier, rightParen: rightParen)
    }
    func makeAccessPathComponent(dictionary: [String: Any]) throws -> AccessPathComponentSyntax {
        let name : TokenSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let trailingDot : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingDot"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeAccessPathComponent(name: name!, trailingDot: trailingDot)
    }
    func makeAccessPath(dictionary: [String: Any]) throws -> AccessPathSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [AccessPathComponentSyntax]()
        for dictionary in array {
            let element: AccessPathComponentSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeAccessPath(elements)
    }
    func makeImportDecl(dictionary: [String: Any]) throws -> ImportDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let importTok : TokenSyntax? = try makeSyntax(dictionary: dictionary["importTok"] as? [String: Any] ?? resolver)
        let importKind : TokenSyntax? = try makeSyntax(dictionary: dictionary["importKind"] as? [String: Any] ?? resolver)
        let path : AccessPathSyntax? = try makeSyntax(dictionary: dictionary["path"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeImportDecl(attributes: attributes, modifiers: modifiers, importTok: importTok!, importKind: importKind, path: path!)
    }
    func makeAccessorParameter(dictionary: [String: Any]) throws -> AccessorParameterSyntax {
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let name : TokenSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeAccessorParameter(leftParen: leftParen!, name: name!, rightParen: rightParen!)
    }
    func makeAccessorDecl(dictionary: [String: Any]) throws -> AccessorDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifier : DeclModifierSyntax? = try makeSyntax(dictionary: dictionary["modifier"] as? [String: Any] ?? resolver)
        let accessorKind : TokenSyntax? = try makeSyntax(dictionary: dictionary["accessorKind"] as? [String: Any] ?? resolver)
        let parameter : AccessorParameterSyntax? = try makeSyntax(dictionary: dictionary["parameter"] as? [String: Any] ?? resolver)
        let body : CodeBlockSyntax? = try makeSyntax(dictionary: dictionary["body"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeAccessorDecl(attributes: attributes, modifier: modifier, accessorKind: accessorKind!, parameter: parameter, body: body)
    }
    func makeAccessorList(dictionary: [String: Any]) throws -> AccessorListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [AccessorDeclSyntax]()
        for dictionary in array {
            let element: AccessorDeclSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeAccessorList(elements)
    }
    func makeAccessorBlock(dictionary: [String: Any]) throws -> AccessorBlockSyntax {
        let leftBrace : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftBrace"] as? [String: Any] ?? resolver)
        let accessors : AccessorListSyntax? = try makeSyntax(dictionary: dictionary["accessors"] as? [String: Any] ?? resolver)
        let rightBrace : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightBrace"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeAccessorBlock(leftBrace: leftBrace!, accessors: accessors!, rightBrace: rightBrace!)
    }
    func makePatternBinding(dictionary: [String: Any]) throws -> PatternBindingSyntax {
        let pattern : PatternSyntax? = try makeSyntax(dictionary: dictionary["pattern"] as? [String: Any] ?? resolver)
        let typeAnnotation : TypeAnnotationSyntax? = try makeSyntax(dictionary: dictionary["typeAnnotation"] as? [String: Any] ?? resolver)
        let initializer : InitializerClauseSyntax? = try makeSyntax(dictionary: dictionary["initializer"] as? [String: Any] ?? resolver)
        let accessor : Syntax? = try makeSyntax(dictionary: dictionary["accessor"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePatternBinding(pattern: pattern!, typeAnnotation: typeAnnotation, initializer: initializer, accessor: accessor, trailingComma: trailingComma)
    }
    func makePatternBindingList(dictionary: [String: Any]) throws -> PatternBindingListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [PatternBindingSyntax]()
        for dictionary in array {
            let element: PatternBindingSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makePatternBindingList(elements)
    }
    func makeVariableDecl(dictionary: [String: Any]) throws -> VariableDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let letOrVarKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["letOrVarKeyword"] as? [String: Any] ?? resolver)
        let bindings : PatternBindingListSyntax? = try makeSyntax(dictionary: dictionary["bindings"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeVariableDecl(attributes: attributes, modifiers: modifiers, letOrVarKeyword: letOrVarKeyword!, bindings: bindings!)
    }
    func makeEnumCaseElement(dictionary: [String: Any]) throws -> EnumCaseElementSyntax {
        let identifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["identifier"] as? [String: Any] ?? resolver)
        let associatedValue : ParameterClauseSyntax? = try makeSyntax(dictionary: dictionary["associatedValue"] as? [String: Any] ?? resolver)
        let rawValue : InitializerClauseSyntax? = try makeSyntax(dictionary: dictionary["rawValue"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeEnumCaseElement(identifier: identifier!, associatedValue: associatedValue, rawValue: rawValue, trailingComma: trailingComma)
    }
    func makeEnumCaseElementList(dictionary: [String: Any]) throws -> EnumCaseElementListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [EnumCaseElementSyntax]()
        for dictionary in array {
            let element: EnumCaseElementSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeEnumCaseElementList(elements)
    }
    func makeEnumCaseDecl(dictionary: [String: Any]) throws -> EnumCaseDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let caseKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["caseKeyword"] as? [String: Any] ?? resolver)
        let elements : EnumCaseElementListSyntax? = try makeSyntax(dictionary: dictionary["elements"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeEnumCaseDecl(attributes: attributes, modifiers: modifiers, caseKeyword: caseKeyword!, elements: elements!)
    }
    func makeEnumDecl(dictionary: [String: Any]) throws -> EnumDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let enumKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["enumKeyword"] as? [String: Any] ?? resolver)
        let identifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["identifier"] as? [String: Any] ?? resolver)
        let genericParameters : GenericParameterClauseSyntax? = try makeSyntax(dictionary: dictionary["genericParameters"] as? [String: Any] ?? resolver)
        let inheritanceClause : TypeInheritanceClauseSyntax? = try makeSyntax(dictionary: dictionary["inheritanceClause"] as? [String: Any] ?? resolver)
        let genericWhereClause : GenericWhereClauseSyntax? = try makeSyntax(dictionary: dictionary["genericWhereClause"] as? [String: Any] ?? resolver)
        let members : MemberDeclBlockSyntax? = try makeSyntax(dictionary: dictionary["members"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeEnumDecl(attributes: attributes, modifiers: modifiers, enumKeyword: enumKeyword!, identifier: identifier!, genericParameters: genericParameters, inheritanceClause: inheritanceClause, genericWhereClause: genericWhereClause, members: members!)
    }
    func makeOperatorDecl(dictionary: [String: Any]) throws -> OperatorDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let operatorKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["operatorKeyword"] as? [String: Any] ?? resolver)
        let identifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["identifier"] as? [String: Any] ?? resolver)
        let operatorPrecedenceAndTypes : OperatorPrecedenceAndTypesSyntax? = try makeSyntax(dictionary: dictionary["operatorPrecedenceAndTypes"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeOperatorDecl(attributes: attributes, modifiers: modifiers, operatorKeyword: operatorKeyword!, identifier: identifier!, operatorPrecedenceAndTypes: operatorPrecedenceAndTypes)
    }
    func makeIdentifierList(dictionary: [String: Any]) throws -> IdentifierListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [TokenSyntax]()
        for dictionary in array {
            let element: TokenSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeIdentifierList(elements)
    }
    func makeOperatorPrecedenceAndTypes(dictionary: [String: Any]) throws -> OperatorPrecedenceAndTypesSyntax {
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let precedenceGroupAndDesignatedTypes : IdentifierListSyntax? = try makeSyntax(dictionary: dictionary["precedenceGroupAndDesignatedTypes"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeOperatorPrecedenceAndTypes(colon: colon!, precedenceGroupAndDesignatedTypes: precedenceGroupAndDesignatedTypes!)
    }
    func makePrecedenceGroupDecl(dictionary: [String: Any]) throws -> PrecedenceGroupDeclSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let modifiers : ModifierListSyntax? = try makeSyntax(dictionary: dictionary["modifiers"] as? [String: Any] ?? resolver)
        let precedencegroupKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["precedencegroupKeyword"] as? [String: Any] ?? resolver)
        let identifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["identifier"] as? [String: Any] ?? resolver)
        let leftBrace : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftBrace"] as? [String: Any] ?? resolver)
        let groupAttributes : PrecedenceGroupAttributeListSyntax? = try makeSyntax(dictionary: dictionary["groupAttributes"] as? [String: Any] ?? resolver)
        let rightBrace : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightBrace"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePrecedenceGroupDecl(attributes: attributes, modifiers: modifiers, precedencegroupKeyword: precedencegroupKeyword!, identifier: identifier!, leftBrace: leftBrace!, groupAttributes: groupAttributes!, rightBrace: rightBrace!)
    }
    func makePrecedenceGroupAttributeList(dictionary: [String: Any]) throws -> PrecedenceGroupAttributeListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [Syntax]()
        for dictionary in array {
            let element: Syntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makePrecedenceGroupAttributeList(elements)
    }
    func makePrecedenceGroupRelation(dictionary: [String: Any]) throws -> PrecedenceGroupRelationSyntax {
        let higherThanOrLowerThan : TokenSyntax? = try makeSyntax(dictionary: dictionary["higherThanOrLowerThan"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let otherNames : PrecedenceGroupNameListSyntax? = try makeSyntax(dictionary: dictionary["otherNames"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePrecedenceGroupRelation(higherThanOrLowerThan: higherThanOrLowerThan!, colon: colon!, otherNames: otherNames!)
    }
    func makePrecedenceGroupNameList(dictionary: [String: Any]) throws -> PrecedenceGroupNameListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [PrecedenceGroupNameElementSyntax]()
        for dictionary in array {
            let element: PrecedenceGroupNameElementSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makePrecedenceGroupNameList(elements)
    }
    func makePrecedenceGroupNameElement(dictionary: [String: Any]) throws -> PrecedenceGroupNameElementSyntax {
        let name : TokenSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePrecedenceGroupNameElement(name: name!, trailingComma: trailingComma)
    }
    func makePrecedenceGroupAssignment(dictionary: [String: Any]) throws -> PrecedenceGroupAssignmentSyntax {
        let assignmentKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["assignmentKeyword"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let flag : TokenSyntax? = try makeSyntax(dictionary: dictionary["flag"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePrecedenceGroupAssignment(assignmentKeyword: assignmentKeyword!, colon: colon!, flag: flag!)
    }
    func makePrecedenceGroupAssociativity(dictionary: [String: Any]) throws -> PrecedenceGroupAssociativitySyntax {
        let associativityKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["associativityKeyword"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let value : TokenSyntax? = try makeSyntax(dictionary: dictionary["value"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePrecedenceGroupAssociativity(associativityKeyword: associativityKeyword!, colon: colon!, value: value!)
    }
    func makeTokenList(dictionary: [String: Any]) throws -> TokenListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [TokenSyntax]()
        for dictionary in array {
            let element: TokenSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeTokenList(elements)
    }
    func makeCustomAttribute(dictionary: [String: Any]) throws -> CustomAttributeSyntax {
        let atSignToken : TokenSyntax? = try makeSyntax(dictionary: dictionary["atSignToken"] as? [String: Any] ?? resolver)
        let attributeName : TypeSyntax? = try makeSyntax(dictionary: dictionary["attributeName"] as? [String: Any] ?? resolver)
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let argumentList : FunctionCallArgumentListSyntax? = try makeSyntax(dictionary: dictionary["argumentList"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeCustomAttribute(atSignToken: atSignToken!, attributeName: attributeName!, leftParen: leftParen, argumentList: argumentList, rightParen: rightParen)
    }
    func makeAttribute(dictionary: [String: Any]) throws -> AttributeSyntax {
        let atSignToken : TokenSyntax? = try makeSyntax(dictionary: dictionary["atSignToken"] as? [String: Any] ?? resolver)
        let attributeName : TokenSyntax? = try makeSyntax(dictionary: dictionary["attributeName"] as? [String: Any] ?? resolver)
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let argument : Syntax? = try makeSyntax(dictionary: dictionary["argument"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeAttribute(atSignToken: atSignToken!, attributeName: attributeName!, leftParen: leftParen, argument: argument, rightParen: rightParen)
    }
    func makeAttributeList(dictionary: [String: Any]) throws -> AttributeListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [Syntax]()
        for dictionary in array {
            let element: Syntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeAttributeList(elements)
    }
    func makeSpecializeAttributeSpecList(dictionary: [String: Any]) throws -> SpecializeAttributeSpecListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [Syntax]()
        for dictionary in array {
            let element: Syntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeSpecializeAttributeSpecList(elements)
    }
    func makeLabeledSpecializeEntry(dictionary: [String: Any]) throws -> LabeledSpecializeEntrySyntax {
        let label : TokenSyntax? = try makeSyntax(dictionary: dictionary["label"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let value : TokenSyntax? = try makeSyntax(dictionary: dictionary["value"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeLabeledSpecializeEntry(label: label!, colon: colon!, value: value!, trailingComma: trailingComma)
    }
    func makeNamedAttributeStringArgument(dictionary: [String: Any]) throws -> NamedAttributeStringArgumentSyntax {
        let nameTok : TokenSyntax? = try makeSyntax(dictionary: dictionary["nameTok"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let stringOrDeclname : Syntax? = try makeSyntax(dictionary: dictionary["stringOrDeclname"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeNamedAttributeStringArgument(nameTok: nameTok!, colon: colon!, stringOrDeclname: stringOrDeclname!)
    }
    func makeDeclName(dictionary: [String: Any]) throws -> DeclNameSyntax {
        let declBaseName : Syntax? = try makeSyntax(dictionary: dictionary["declBaseName"] as? [String: Any] ?? resolver)
        let declNameArguments : DeclNameArgumentsSyntax? = try makeSyntax(dictionary: dictionary["declNameArguments"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeDeclName(declBaseName: declBaseName!, declNameArguments: declNameArguments)
    }
    func makeImplementsAttributeArguments(dictionary: [String: Any]) throws -> ImplementsAttributeArgumentsSyntax {
        let type : SimpleTypeIdentifierSyntax? = try makeSyntax(dictionary: dictionary["type"] as? [String: Any] ?? resolver)
        let comma : TokenSyntax? = try makeSyntax(dictionary: dictionary["comma"] as? [String: Any] ?? resolver)
        let declBaseName : Syntax? = try makeSyntax(dictionary: dictionary["declBaseName"] as? [String: Any] ?? resolver)
        let declNameArguments : DeclNameArgumentsSyntax? = try makeSyntax(dictionary: dictionary["declNameArguments"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeImplementsAttributeArguments(type: type!, comma: comma!, declBaseName: declBaseName!, declNameArguments: declNameArguments)
    }
    func makeObjCSelectorPiece(dictionary: [String: Any]) throws -> ObjCSelectorPieceSyntax {
        let name : TokenSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeObjCSelectorPiece(name: name, colon: colon)
    }
    func makeObjCSelector(dictionary: [String: Any]) throws -> ObjCSelectorSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [ObjCSelectorPieceSyntax]()
        for dictionary in array {
            let element: ObjCSelectorPieceSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeObjCSelector(elements)
    }
    func makeContinueStmt(dictionary: [String: Any]) throws -> ContinueStmtSyntax {
        let continueKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["continueKeyword"] as? [String: Any] ?? resolver)
        let label : TokenSyntax? = try makeSyntax(dictionary: dictionary["label"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeContinueStmt(continueKeyword: continueKeyword!, label: label)
    }
    func makeWhileStmt(dictionary: [String: Any]) throws -> WhileStmtSyntax {
        let labelName : TokenSyntax? = try makeSyntax(dictionary: dictionary["labelName"] as? [String: Any] ?? resolver)
        let labelColon : TokenSyntax? = try makeSyntax(dictionary: dictionary["labelColon"] as? [String: Any] ?? resolver)
        let whileKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["whileKeyword"] as? [String: Any] ?? resolver)
        let conditions : ConditionElementListSyntax? = try makeSyntax(dictionary: dictionary["conditions"] as? [String: Any] ?? resolver)
        let body : CodeBlockSyntax? = try makeSyntax(dictionary: dictionary["body"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeWhileStmt(labelName: labelName, labelColon: labelColon, whileKeyword: whileKeyword!, conditions: conditions!, body: body!)
    }
    func makeDeferStmt(dictionary: [String: Any]) throws -> DeferStmtSyntax {
        let deferKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["deferKeyword"] as? [String: Any] ?? resolver)
        let body : CodeBlockSyntax? = try makeSyntax(dictionary: dictionary["body"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeDeferStmt(deferKeyword: deferKeyword!, body: body!)
    }
    func makeSwitchCaseList(dictionary: [String: Any]) throws -> SwitchCaseListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [Syntax]()
        for dictionary in array {
            let element: Syntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeSwitchCaseList(elements)
    }
    func makeRepeatWhileStmt(dictionary: [String: Any]) throws -> RepeatWhileStmtSyntax {
        let labelName : TokenSyntax? = try makeSyntax(dictionary: dictionary["labelName"] as? [String: Any] ?? resolver)
        let labelColon : TokenSyntax? = try makeSyntax(dictionary: dictionary["labelColon"] as? [String: Any] ?? resolver)
        let repeatKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["repeatKeyword"] as? [String: Any] ?? resolver)
        let body : CodeBlockSyntax? = try makeSyntax(dictionary: dictionary["body"] as? [String: Any] ?? resolver)
        let whileKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["whileKeyword"] as? [String: Any] ?? resolver)
        let condition : ExprSyntax? = try makeSyntax(dictionary: dictionary["condition"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeRepeatWhileStmt(labelName: labelName, labelColon: labelColon, repeatKeyword: repeatKeyword!, body: body!, whileKeyword: whileKeyword!, condition: condition!)
    }
    func makeGuardStmt(dictionary: [String: Any]) throws -> GuardStmtSyntax {
        let guardKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["guardKeyword"] as? [String: Any] ?? resolver)
        let conditions : ConditionElementListSyntax? = try makeSyntax(dictionary: dictionary["conditions"] as? [String: Any] ?? resolver)
        let elseKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["elseKeyword"] as? [String: Any] ?? resolver)
        let body : CodeBlockSyntax? = try makeSyntax(dictionary: dictionary["body"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeGuardStmt(guardKeyword: guardKeyword!, conditions: conditions!, elseKeyword: elseKeyword!, body: body!)
    }
    func makeWhereClause(dictionary: [String: Any]) throws -> WhereClauseSyntax {
        let whereKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["whereKeyword"] as? [String: Any] ?? resolver)
        let guardResult : ExprSyntax? = try makeSyntax(dictionary: dictionary["guardResult"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeWhereClause(whereKeyword: whereKeyword!, guardResult: guardResult!)
    }
    func makeForInStmt(dictionary: [String: Any]) throws -> ForInStmtSyntax {
        let labelName : TokenSyntax? = try makeSyntax(dictionary: dictionary["labelName"] as? [String: Any] ?? resolver)
        let labelColon : TokenSyntax? = try makeSyntax(dictionary: dictionary["labelColon"] as? [String: Any] ?? resolver)
        let forKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["forKeyword"] as? [String: Any] ?? resolver)
        let caseKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["caseKeyword"] as? [String: Any] ?? resolver)
        let pattern : PatternSyntax? = try makeSyntax(dictionary: dictionary["pattern"] as? [String: Any] ?? resolver)
        let typeAnnotation : TypeAnnotationSyntax? = try makeSyntax(dictionary: dictionary["typeAnnotation"] as? [String: Any] ?? resolver)
        let inKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["inKeyword"] as? [String: Any] ?? resolver)
        let sequenceExpr : ExprSyntax? = try makeSyntax(dictionary: dictionary["sequenceExpr"] as? [String: Any] ?? resolver)
        let whereClause : WhereClauseSyntax? = try makeSyntax(dictionary: dictionary["whereClause"] as? [String: Any] ?? resolver)
        let body : CodeBlockSyntax? = try makeSyntax(dictionary: dictionary["body"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeForInStmt(labelName: labelName, labelColon: labelColon, forKeyword: forKeyword!, caseKeyword: caseKeyword, pattern: pattern!, typeAnnotation: typeAnnotation, inKeyword: inKeyword!, sequenceExpr: sequenceExpr!, whereClause: whereClause, body: body!)
    }
    func makeSwitchStmt(dictionary: [String: Any]) throws -> SwitchStmtSyntax {
        let labelName : TokenSyntax? = try makeSyntax(dictionary: dictionary["labelName"] as? [String: Any] ?? resolver)
        let labelColon : TokenSyntax? = try makeSyntax(dictionary: dictionary["labelColon"] as? [String: Any] ?? resolver)
        let switchKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["switchKeyword"] as? [String: Any] ?? resolver)
        let expression : ExprSyntax? = try makeSyntax(dictionary: dictionary["expression"] as? [String: Any] ?? resolver)
        let leftBrace : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftBrace"] as? [String: Any] ?? resolver)
        let cases : SwitchCaseListSyntax? = try makeSyntax(dictionary: dictionary["cases"] as? [String: Any] ?? resolver)
        let rightBrace : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightBrace"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeSwitchStmt(labelName: labelName, labelColon: labelColon, switchKeyword: switchKeyword!, expression: expression!, leftBrace: leftBrace!, cases: cases!, rightBrace: rightBrace!)
    }
    func makeCatchClauseList(dictionary: [String: Any]) throws -> CatchClauseListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [CatchClauseSyntax]()
        for dictionary in array {
            let element: CatchClauseSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeCatchClauseList(elements)
    }
    func makeDoStmt(dictionary: [String: Any]) throws -> DoStmtSyntax {
        let labelName : TokenSyntax? = try makeSyntax(dictionary: dictionary["labelName"] as? [String: Any] ?? resolver)
        let labelColon : TokenSyntax? = try makeSyntax(dictionary: dictionary["labelColon"] as? [String: Any] ?? resolver)
        let doKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["doKeyword"] as? [String: Any] ?? resolver)
        let body : CodeBlockSyntax? = try makeSyntax(dictionary: dictionary["body"] as? [String: Any] ?? resolver)
        let catchClauses : CatchClauseListSyntax? = try makeSyntax(dictionary: dictionary["catchClauses"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeDoStmt(labelName: labelName, labelColon: labelColon, doKeyword: doKeyword!, body: body!, catchClauses: catchClauses)
    }
    func makeReturnStmt(dictionary: [String: Any]) throws -> ReturnStmtSyntax {
        let returnKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["returnKeyword"] as? [String: Any] ?? resolver)
        let expression : ExprSyntax? = try makeSyntax(dictionary: dictionary["expression"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeReturnStmt(returnKeyword: returnKeyword!, expression: expression)
    }
    func makeYieldStmt(dictionary: [String: Any]) throws -> YieldStmtSyntax {
        let yieldKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["yieldKeyword"] as? [String: Any] ?? resolver)
        let yields : Syntax? = try makeSyntax(dictionary: dictionary["yields"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeYieldStmt(yieldKeyword: yieldKeyword!, yields: yields!)
    }
    func makeYieldList(dictionary: [String: Any]) throws -> YieldListSyntax {
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let elementList : ExprListSyntax? = try makeSyntax(dictionary: dictionary["elementList"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeYieldList(leftParen: leftParen!, elementList: elementList!, trailingComma: trailingComma, rightParen: rightParen!)
    }
    func makeFallthroughStmt(dictionary: [String: Any]) throws -> FallthroughStmtSyntax {
        let fallthroughKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["fallthroughKeyword"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeFallthroughStmt(fallthroughKeyword: fallthroughKeyword!)
    }
    func makeBreakStmt(dictionary: [String: Any]) throws -> BreakStmtSyntax {
        let breakKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["breakKeyword"] as? [String: Any] ?? resolver)
        let label : TokenSyntax? = try makeSyntax(dictionary: dictionary["label"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeBreakStmt(breakKeyword: breakKeyword!, label: label)
    }
    func makeCaseItemList(dictionary: [String: Any]) throws -> CaseItemListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [CaseItemSyntax]()
        for dictionary in array {
            let element: CaseItemSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeCaseItemList(elements)
    }
    func makeConditionElement(dictionary: [String: Any]) throws -> ConditionElementSyntax {
        let condition : Syntax? = try makeSyntax(dictionary: dictionary["condition"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeConditionElement(condition: condition!, trailingComma: trailingComma)
    }
    func makeAvailabilityCondition(dictionary: [String: Any]) throws -> AvailabilityConditionSyntax {
        let poundAvailableKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["poundAvailableKeyword"] as? [String: Any] ?? resolver)
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let availabilitySpec : AvailabilitySpecListSyntax? = try makeSyntax(dictionary: dictionary["availabilitySpec"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeAvailabilityCondition(poundAvailableKeyword: poundAvailableKeyword!, leftParen: leftParen!, availabilitySpec: availabilitySpec!, rightParen: rightParen!)
    }
    func makeMatchingPatternCondition(dictionary: [String: Any]) throws -> MatchingPatternConditionSyntax {
        let caseKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["caseKeyword"] as? [String: Any] ?? resolver)
        let pattern : PatternSyntax? = try makeSyntax(dictionary: dictionary["pattern"] as? [String: Any] ?? resolver)
        let typeAnnotation : TypeAnnotationSyntax? = try makeSyntax(dictionary: dictionary["typeAnnotation"] as? [String: Any] ?? resolver)
        let initializer : InitializerClauseSyntax? = try makeSyntax(dictionary: dictionary["initializer"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeMatchingPatternCondition(caseKeyword: caseKeyword!, pattern: pattern!, typeAnnotation: typeAnnotation, initializer: initializer!)
    }
    func makeOptionalBindingCondition(dictionary: [String: Any]) throws -> OptionalBindingConditionSyntax {
        let letOrVarKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["letOrVarKeyword"] as? [String: Any] ?? resolver)
        let pattern : PatternSyntax? = try makeSyntax(dictionary: dictionary["pattern"] as? [String: Any] ?? resolver)
        let typeAnnotation : TypeAnnotationSyntax? = try makeSyntax(dictionary: dictionary["typeAnnotation"] as? [String: Any] ?? resolver)
        let initializer : InitializerClauseSyntax? = try makeSyntax(dictionary: dictionary["initializer"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeOptionalBindingCondition(letOrVarKeyword: letOrVarKeyword!, pattern: pattern!, typeAnnotation: typeAnnotation, initializer: initializer!)
    }
    func makeConditionElementList(dictionary: [String: Any]) throws -> ConditionElementListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [ConditionElementSyntax]()
        for dictionary in array {
            let element: ConditionElementSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeConditionElementList(elements)
    }
    func makeThrowStmt(dictionary: [String: Any]) throws -> ThrowStmtSyntax {
        let throwKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["throwKeyword"] as? [String: Any] ?? resolver)
        let expression : ExprSyntax? = try makeSyntax(dictionary: dictionary["expression"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeThrowStmt(throwKeyword: throwKeyword!, expression: expression!)
    }
    func makeIfStmt(dictionary: [String: Any]) throws -> IfStmtSyntax {
        let labelName : TokenSyntax? = try makeSyntax(dictionary: dictionary["labelName"] as? [String: Any] ?? resolver)
        let labelColon : TokenSyntax? = try makeSyntax(dictionary: dictionary["labelColon"] as? [String: Any] ?? resolver)
        let ifKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["ifKeyword"] as? [String: Any] ?? resolver)
        let conditions : ConditionElementListSyntax? = try makeSyntax(dictionary: dictionary["conditions"] as? [String: Any] ?? resolver)
        let body : CodeBlockSyntax? = try makeSyntax(dictionary: dictionary["body"] as? [String: Any] ?? resolver)
        let elseKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["elseKeyword"] as? [String: Any] ?? resolver)
        let elseBody : Syntax? = try makeSyntax(dictionary: dictionary["elseBody"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeIfStmt(labelName: labelName, labelColon: labelColon, ifKeyword: ifKeyword!, conditions: conditions!, body: body!, elseKeyword: elseKeyword, elseBody: elseBody)
    }
    func makeSwitchCase(dictionary: [String: Any]) throws -> SwitchCaseSyntax {
        let unknownAttr : AttributeSyntax? = try makeSyntax(dictionary: dictionary["unknownAttr"] as? [String: Any] ?? resolver)
        let label : Syntax? = try makeSyntax(dictionary: dictionary["label"] as? [String: Any] ?? resolver)
        let statements : CodeBlockItemListSyntax? = try makeSyntax(dictionary: dictionary["statements"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeSwitchCase(unknownAttr: unknownAttr, label: label!, statements: statements!)
    }
    func makeSwitchDefaultLabel(dictionary: [String: Any]) throws -> SwitchDefaultLabelSyntax {
        let defaultKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["defaultKeyword"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeSwitchDefaultLabel(defaultKeyword: defaultKeyword!, colon: colon!)
    }
    func makeCaseItem(dictionary: [String: Any]) throws -> CaseItemSyntax {
        let pattern : PatternSyntax? = try makeSyntax(dictionary: dictionary["pattern"] as? [String: Any] ?? resolver)
        let whereClause : WhereClauseSyntax? = try makeSyntax(dictionary: dictionary["whereClause"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeCaseItem(pattern: pattern!, whereClause: whereClause, trailingComma: trailingComma)
    }
    func makeSwitchCaseLabel(dictionary: [String: Any]) throws -> SwitchCaseLabelSyntax {
        let caseKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["caseKeyword"] as? [String: Any] ?? resolver)
        let caseItems : CaseItemListSyntax? = try makeSyntax(dictionary: dictionary["caseItems"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeSwitchCaseLabel(caseKeyword: caseKeyword!, caseItems: caseItems!, colon: colon!)
    }
    func makeCatchClause(dictionary: [String: Any]) throws -> CatchClauseSyntax {
        let catchKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["catchKeyword"] as? [String: Any] ?? resolver)
        let pattern : PatternSyntax? = try makeSyntax(dictionary: dictionary["pattern"] as? [String: Any] ?? resolver)
        let whereClause : WhereClauseSyntax? = try makeSyntax(dictionary: dictionary["whereClause"] as? [String: Any] ?? resolver)
        let body : CodeBlockSyntax? = try makeSyntax(dictionary: dictionary["body"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeCatchClause(catchKeyword: catchKeyword!, pattern: pattern, whereClause: whereClause, body: body!)
    }
    func makePoundAssertStmt(dictionary: [String: Any]) throws -> PoundAssertStmtSyntax {
        let poundAssert : TokenSyntax? = try makeSyntax(dictionary: dictionary["poundAssert"] as? [String: Any] ?? resolver)
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let condition : ExprSyntax? = try makeSyntax(dictionary: dictionary["condition"] as? [String: Any] ?? resolver)
        let comma : TokenSyntax? = try makeSyntax(dictionary: dictionary["comma"] as? [String: Any] ?? resolver)
        let message : TokenSyntax? = try makeSyntax(dictionary: dictionary["message"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makePoundAssertStmt(poundAssert: poundAssert!, leftParen: leftParen!, condition: condition!, comma: comma, message: message, rightParen: rightParen!)
    }
    func makeGenericWhereClause(dictionary: [String: Any]) throws -> GenericWhereClauseSyntax {
        let whereKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["whereKeyword"] as? [String: Any] ?? resolver)
        let requirementList : GenericRequirementListSyntax? = try makeSyntax(dictionary: dictionary["requirementList"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeGenericWhereClause(whereKeyword: whereKeyword!, requirementList: requirementList!)
    }
    func makeGenericRequirementList(dictionary: [String: Any]) throws -> GenericRequirementListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [Syntax]()
        for dictionary in array {
            let element: Syntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeGenericRequirementList(elements)
    }
    func makeSameTypeRequirement(dictionary: [String: Any]) throws -> SameTypeRequirementSyntax {
        let leftTypeIdentifier : TypeSyntax? = try makeSyntax(dictionary: dictionary["leftTypeIdentifier"] as? [String: Any] ?? resolver)
        let equalityToken : TokenSyntax? = try makeSyntax(dictionary: dictionary["equalityToken"] as? [String: Any] ?? resolver)
        let rightTypeIdentifier : TypeSyntax? = try makeSyntax(dictionary: dictionary["rightTypeIdentifier"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeSameTypeRequirement(leftTypeIdentifier: leftTypeIdentifier!, equalityToken: equalityToken!, rightTypeIdentifier: rightTypeIdentifier!, trailingComma: trailingComma)
    }
    func makeGenericParameterList(dictionary: [String: Any]) throws -> GenericParameterListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [GenericParameterSyntax]()
        for dictionary in array {
            let element: GenericParameterSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeGenericParameterList(elements)
    }
    func makeGenericParameter(dictionary: [String: Any]) throws -> GenericParameterSyntax {
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let name : TokenSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let inheritedType : TypeSyntax? = try makeSyntax(dictionary: dictionary["inheritedType"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeGenericParameter(attributes: attributes, name: name!, colon: colon, inheritedType: inheritedType, trailingComma: trailingComma)
    }
    func makeGenericParameterClause(dictionary: [String: Any]) throws -> GenericParameterClauseSyntax {
        let leftAngleBracket : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftAngleBracket"] as? [String: Any] ?? resolver)
        let genericParameterList : GenericParameterListSyntax? = try makeSyntax(dictionary: dictionary["genericParameterList"] as? [String: Any] ?? resolver)
        let rightAngleBracket : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightAngleBracket"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeGenericParameterClause(leftAngleBracket: leftAngleBracket!, genericParameterList: genericParameterList!, rightAngleBracket: rightAngleBracket!)
    }
    func makeConformanceRequirement(dictionary: [String: Any]) throws -> ConformanceRequirementSyntax {
        let leftTypeIdentifier : TypeSyntax? = try makeSyntax(dictionary: dictionary["leftTypeIdentifier"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let rightTypeIdentifier : TypeSyntax? = try makeSyntax(dictionary: dictionary["rightTypeIdentifier"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeConformanceRequirement(leftTypeIdentifier: leftTypeIdentifier!, colon: colon!, rightTypeIdentifier: rightTypeIdentifier!, trailingComma: trailingComma)
    }
    func makeSimpleTypeIdentifier(dictionary: [String: Any]) throws -> SimpleTypeIdentifierSyntax {
        let name : TokenSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let genericArgumentClause : GenericArgumentClauseSyntax? = try makeSyntax(dictionary: dictionary["genericArgumentClause"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeSimpleTypeIdentifier(name: name!, genericArgumentClause: genericArgumentClause)
    }
    func makeMemberTypeIdentifier(dictionary: [String: Any]) throws -> MemberTypeIdentifierSyntax {
        let baseType : TypeSyntax? = try makeSyntax(dictionary: dictionary["baseType"] as? [String: Any] ?? resolver)
        let period : TokenSyntax? = try makeSyntax(dictionary: dictionary["period"] as? [String: Any] ?? resolver)
        let name : TokenSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let genericArgumentClause : GenericArgumentClauseSyntax? = try makeSyntax(dictionary: dictionary["genericArgumentClause"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeMemberTypeIdentifier(baseType: baseType!, period: period!, name: name!, genericArgumentClause: genericArgumentClause)
    }
    func makeClassRestrictionType(dictionary: [String: Any]) throws -> ClassRestrictionTypeSyntax {
        let classKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["classKeyword"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeClassRestrictionType(classKeyword: classKeyword!)
    }
    func makeArrayType(dictionary: [String: Any]) throws -> ArrayTypeSyntax {
        let leftSquareBracket : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftSquareBracket"] as? [String: Any] ?? resolver)
        let elementType : TypeSyntax? = try makeSyntax(dictionary: dictionary["elementType"] as? [String: Any] ?? resolver)
        let rightSquareBracket : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightSquareBracket"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeArrayType(leftSquareBracket: leftSquareBracket!, elementType: elementType!, rightSquareBracket: rightSquareBracket!)
    }
    func makeDictionaryType(dictionary: [String: Any]) throws -> DictionaryTypeSyntax {
        let leftSquareBracket : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftSquareBracket"] as? [String: Any] ?? resolver)
        let keyType : TypeSyntax? = try makeSyntax(dictionary: dictionary["keyType"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let valueType : TypeSyntax? = try makeSyntax(dictionary: dictionary["valueType"] as? [String: Any] ?? resolver)
        let rightSquareBracket : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightSquareBracket"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeDictionaryType(leftSquareBracket: leftSquareBracket!, keyType: keyType!, colon: colon!, valueType: valueType!, rightSquareBracket: rightSquareBracket!)
    }
    func makeMetatypeType(dictionary: [String: Any]) throws -> MetatypeTypeSyntax {
        let baseType : TypeSyntax? = try makeSyntax(dictionary: dictionary["baseType"] as? [String: Any] ?? resolver)
        let period : TokenSyntax? = try makeSyntax(dictionary: dictionary["period"] as? [String: Any] ?? resolver)
        let typeOrProtocol : TokenSyntax? = try makeSyntax(dictionary: dictionary["typeOrProtocol"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeMetatypeType(baseType: baseType!, period: period!, typeOrProtocol: typeOrProtocol!)
    }
    func makeOptionalType(dictionary: [String: Any]) throws -> OptionalTypeSyntax {
        let wrappedType : TypeSyntax? = try makeSyntax(dictionary: dictionary["wrappedType"] as? [String: Any] ?? resolver)
        let questionMark : TokenSyntax? = try makeSyntax(dictionary: dictionary["questionMark"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeOptionalType(wrappedType: wrappedType!, questionMark: questionMark!)
    }
    func makeSomeType(dictionary: [String: Any]) throws -> SomeTypeSyntax {
        let someSpecifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["someSpecifier"] as? [String: Any] ?? resolver)
        let baseType : TypeSyntax? = try makeSyntax(dictionary: dictionary["baseType"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeSomeType(someSpecifier: someSpecifier!, baseType: baseType!)
    }
    func makeImplicitlyUnwrappedOptionalType(dictionary: [String: Any]) throws -> ImplicitlyUnwrappedOptionalTypeSyntax {
        let wrappedType : TypeSyntax? = try makeSyntax(dictionary: dictionary["wrappedType"] as? [String: Any] ?? resolver)
        let exclamationMark : TokenSyntax? = try makeSyntax(dictionary: dictionary["exclamationMark"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeImplicitlyUnwrappedOptionalType(wrappedType: wrappedType!, exclamationMark: exclamationMark!)
    }
    func makeCompositionTypeElement(dictionary: [String: Any]) throws -> CompositionTypeElementSyntax {
        let type : TypeSyntax? = try makeSyntax(dictionary: dictionary["type"] as? [String: Any] ?? resolver)
        let ampersand : TokenSyntax? = try makeSyntax(dictionary: dictionary["ampersand"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeCompositionTypeElement(type: type!, ampersand: ampersand)
    }
    func makeCompositionTypeElementList(dictionary: [String: Any]) throws -> CompositionTypeElementListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [CompositionTypeElementSyntax]()
        for dictionary in array {
            let element: CompositionTypeElementSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeCompositionTypeElementList(elements)
    }
    func makeCompositionType(dictionary: [String: Any]) throws -> CompositionTypeSyntax {
        let elements : CompositionTypeElementListSyntax? = try makeSyntax(dictionary: dictionary["elements"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeCompositionType(elements: elements!)
    }
    func makeTupleTypeElement(dictionary: [String: Any]) throws -> TupleTypeElementSyntax {
        let inOut : TokenSyntax? = try makeSyntax(dictionary: dictionary["inOut"] as? [String: Any] ?? resolver)
        let name : TokenSyntax? = try makeSyntax(dictionary: dictionary["name"] as? [String: Any] ?? resolver)
        let secondName : TokenSyntax? = try makeSyntax(dictionary: dictionary["secondName"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let type : TypeSyntax? = try makeSyntax(dictionary: dictionary["type"] as? [String: Any] ?? resolver)
        let ellipsis : TokenSyntax? = try makeSyntax(dictionary: dictionary["ellipsis"] as? [String: Any] ?? resolver)
        let initializer : InitializerClauseSyntax? = try makeSyntax(dictionary: dictionary["initializer"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeTupleTypeElement(inOut: inOut, name: name, secondName: secondName, colon: colon, type: type!, ellipsis: ellipsis, initializer: initializer, trailingComma: trailingComma)
    }
    func makeTupleTypeElementList(dictionary: [String: Any]) throws -> TupleTypeElementListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [TupleTypeElementSyntax]()
        for dictionary in array {
            let element: TupleTypeElementSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeTupleTypeElementList(elements)
    }
    func makeTupleType(dictionary: [String: Any]) throws -> TupleTypeSyntax {
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let elements : TupleTypeElementListSyntax? = try makeSyntax(dictionary: dictionary["elements"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeTupleType(leftParen: leftParen!, elements: elements!, rightParen: rightParen!)
    }
    func makeFunctionType(dictionary: [String: Any]) throws -> FunctionTypeSyntax {
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let arguments : TupleTypeElementListSyntax? = try makeSyntax(dictionary: dictionary["arguments"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        let throwsOrRethrowsKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["throwsOrRethrowsKeyword"] as? [String: Any] ?? resolver)
        let arrow : TokenSyntax? = try makeSyntax(dictionary: dictionary["arrow"] as? [String: Any] ?? resolver)
        let returnType : TypeSyntax? = try makeSyntax(dictionary: dictionary["returnType"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeFunctionType(leftParen: leftParen!, arguments: arguments!, rightParen: rightParen!, throwsOrRethrowsKeyword: throwsOrRethrowsKeyword, arrow: arrow!, returnType: returnType!)
    }
    func makeAttributedType(dictionary: [String: Any]) throws -> AttributedTypeSyntax {
        let specifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["specifier"] as? [String: Any] ?? resolver)
        let attributes : AttributeListSyntax? = try makeSyntax(dictionary: dictionary["attributes"] as? [String: Any] ?? resolver)
        let baseType : TypeSyntax? = try makeSyntax(dictionary: dictionary["baseType"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeAttributedType(specifier: specifier, attributes: attributes, baseType: baseType!)
    }
    func makeGenericArgumentList(dictionary: [String: Any]) throws -> GenericArgumentListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [GenericArgumentSyntax]()
        for dictionary in array {
            let element: GenericArgumentSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeGenericArgumentList(elements)
    }
    func makeGenericArgument(dictionary: [String: Any]) throws -> GenericArgumentSyntax {
        let argumentType : TypeSyntax? = try makeSyntax(dictionary: dictionary["argumentType"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeGenericArgument(argumentType: argumentType!, trailingComma: trailingComma)
    }
    func makeGenericArgumentClause(dictionary: [String: Any]) throws -> GenericArgumentClauseSyntax {
        let leftAngleBracket : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftAngleBracket"] as? [String: Any] ?? resolver)
        let arguments : GenericArgumentListSyntax? = try makeSyntax(dictionary: dictionary["arguments"] as? [String: Any] ?? resolver)
        let rightAngleBracket : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightAngleBracket"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeGenericArgumentClause(leftAngleBracket: leftAngleBracket!, arguments: arguments!, rightAngleBracket: rightAngleBracket!)
    }
    func makeTypeAnnotation(dictionary: [String: Any]) throws -> TypeAnnotationSyntax {
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let type : TypeSyntax? = try makeSyntax(dictionary: dictionary["type"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeTypeAnnotation(colon: colon!, type: type!)
    }
    func makeEnumCasePattern(dictionary: [String: Any]) throws -> EnumCasePatternSyntax {
        let type : TypeSyntax? = try makeSyntax(dictionary: dictionary["type"] as? [String: Any] ?? resolver)
        let period : TokenSyntax? = try makeSyntax(dictionary: dictionary["period"] as? [String: Any] ?? resolver)
        let caseName : TokenSyntax? = try makeSyntax(dictionary: dictionary["caseName"] as? [String: Any] ?? resolver)
        let associatedTuple : TuplePatternSyntax? = try makeSyntax(dictionary: dictionary["associatedTuple"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeEnumCasePattern(type: type, period: period!, caseName: caseName!, associatedTuple: associatedTuple)
    }
    func makeIsTypePattern(dictionary: [String: Any]) throws -> IsTypePatternSyntax {
        let isKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["isKeyword"] as? [String: Any] ?? resolver)
        let type : TypeSyntax? = try makeSyntax(dictionary: dictionary["type"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeIsTypePattern(isKeyword: isKeyword!, type: type!)
    }
    func makeOptionalPattern(dictionary: [String: Any]) throws -> OptionalPatternSyntax {
        let subPattern : PatternSyntax? = try makeSyntax(dictionary: dictionary["subPattern"] as? [String: Any] ?? resolver)
        let questionMark : TokenSyntax? = try makeSyntax(dictionary: dictionary["questionMark"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeOptionalPattern(subPattern: subPattern!, questionMark: questionMark!)
    }
    func makeIdentifierPattern(dictionary: [String: Any]) throws -> IdentifierPatternSyntax {
        let identifier : TokenSyntax? = try makeSyntax(dictionary: dictionary["identifier"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeIdentifierPattern(identifier: identifier!)
    }
    func makeAsTypePattern(dictionary: [String: Any]) throws -> AsTypePatternSyntax {
        let pattern : PatternSyntax? = try makeSyntax(dictionary: dictionary["pattern"] as? [String: Any] ?? resolver)
        let asKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["asKeyword"] as? [String: Any] ?? resolver)
        let type : TypeSyntax? = try makeSyntax(dictionary: dictionary["type"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeAsTypePattern(pattern: pattern!, asKeyword: asKeyword!, type: type!)
    }
    func makeTuplePattern(dictionary: [String: Any]) throws -> TuplePatternSyntax {
        let leftParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["leftParen"] as? [String: Any] ?? resolver)
        let elements : TuplePatternElementListSyntax? = try makeSyntax(dictionary: dictionary["elements"] as? [String: Any] ?? resolver)
        let rightParen : TokenSyntax? = try makeSyntax(dictionary: dictionary["rightParen"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeTuplePattern(leftParen: leftParen!, elements: elements!, rightParen: rightParen!)
    }
    func makeWildcardPattern(dictionary: [String: Any]) throws -> WildcardPatternSyntax {
        let wildcard : TokenSyntax? = try makeSyntax(dictionary: dictionary["wildcard"] as? [String: Any] ?? resolver)
        let typeAnnotation : TypeAnnotationSyntax? = try makeSyntax(dictionary: dictionary["typeAnnotation"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeWildcardPattern(wildcard: wildcard!, typeAnnotation: typeAnnotation)
    }
    func makeTuplePatternElement(dictionary: [String: Any]) throws -> TuplePatternElementSyntax {
        let labelName : TokenSyntax? = try makeSyntax(dictionary: dictionary["labelName"] as? [String: Any] ?? resolver)
        let labelColon : TokenSyntax? = try makeSyntax(dictionary: dictionary["labelColon"] as? [String: Any] ?? resolver)
        let pattern : PatternSyntax? = try makeSyntax(dictionary: dictionary["pattern"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeTuplePatternElement(labelName: labelName, labelColon: labelColon, pattern: pattern!, trailingComma: trailingComma)
    }
    func makeExpressionPattern(dictionary: [String: Any]) throws -> ExpressionPatternSyntax {
        let expression : ExprSyntax? = try makeSyntax(dictionary: dictionary["expression"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeExpressionPattern(expression: expression!)
    }
    func makeTuplePatternElementList(dictionary: [String: Any]) throws -> TuplePatternElementListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [TuplePatternElementSyntax]()
        for dictionary in array {
            let element: TuplePatternElementSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeTuplePatternElementList(elements)
    }
    func makeValueBindingPattern(dictionary: [String: Any]) throws -> ValueBindingPatternSyntax {
        let letOrVarKeyword : TokenSyntax? = try makeSyntax(dictionary: dictionary["letOrVarKeyword"] as? [String: Any] ?? resolver)
        let valuePattern : PatternSyntax? = try makeSyntax(dictionary: dictionary["valuePattern"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeValueBindingPattern(letOrVarKeyword: letOrVarKeyword!, valuePattern: valuePattern!)
    }
    func makeAvailabilitySpecList(dictionary: [String: Any]) throws -> AvailabilitySpecListSyntax {
        let array = dictionary["@list"] as! [[String: Any]]
        var elements = [AvailabilityArgumentSyntax]()
        for dictionary in array {
            let element: AvailabilityArgumentSyntax = try makeSyntax(dictionary: dictionary)!
            elements.append(element)
        }
        return SyntaxFactory.makeAvailabilitySpecList(elements)
    }
    func makeAvailabilityArgument(dictionary: [String: Any]) throws -> AvailabilityArgumentSyntax {
        let entry : Syntax? = try makeSyntax(dictionary: dictionary["entry"] as? [String: Any] ?? resolver)
        let trailingComma : TokenSyntax? = try makeSyntax(dictionary: dictionary["trailingComma"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeAvailabilityArgument(entry: entry!, trailingComma: trailingComma)
    }
    func makeAvailabilityLabeledArgument(dictionary: [String: Any]) throws -> AvailabilityLabeledArgumentSyntax {
        let label : TokenSyntax? = try makeSyntax(dictionary: dictionary["label"] as? [String: Any] ?? resolver)
        let colon : TokenSyntax? = try makeSyntax(dictionary: dictionary["colon"] as? [String: Any] ?? resolver)
        let value : Syntax? = try makeSyntax(dictionary: dictionary["value"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeAvailabilityLabeledArgument(label: label!, colon: colon!, value: value!)
    }
    func makeAvailabilityVersionRestriction(dictionary: [String: Any]) throws -> AvailabilityVersionRestrictionSyntax {
        let platform : TokenSyntax? = try makeSyntax(dictionary: dictionary["platform"] as? [String: Any] ?? resolver)
        let version : VersionTupleSyntax? = try makeSyntax(dictionary: dictionary["version"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeAvailabilityVersionRestriction(platform: platform!, version: version!)
    }
    func makeVersionTuple(dictionary: [String: Any]) throws -> VersionTupleSyntax {
        let majorMinor : Syntax? = try makeSyntax(dictionary: dictionary["majorMinor"] as? [String: Any] ?? resolver)
        let patchPeriod : TokenSyntax? = try makeSyntax(dictionary: dictionary["patchPeriod"] as? [String: Any] ?? resolver)
        let patchVersion : TokenSyntax? = try makeSyntax(dictionary: dictionary["patchVersion"] as? [String: Any] ?? resolver)
        return SyntaxFactory.makeVersionTuple(majorMinor: majorMinor!, patchPeriod: patchPeriod, patchVersion: patchVersion)
    }
}
