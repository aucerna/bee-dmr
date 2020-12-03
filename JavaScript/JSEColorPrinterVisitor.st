"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEColorPrinterVisitor,
	#superclass : #JSEPrintSourceVisitor,
	#category : #JavaScript
}

{ #category : #services }
JSEColorPrinterVisitor class >> paintSource: code parseTree: method [
	^method asText]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptAssignment: anAssignmentNode [
	self
		visit: anAssignmentNode assignee;
		printWhitespace;
		bold: anAssignmentNode operator color: self operatorColor;
		printWhitespace;
		visit: anAssignmentNode expression]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptBinaryOperator: aBinaryOperatorNode [
	self
		visit: aBinaryOperatorNode leftExpression;
		printWhitespace;
		print: aBinaryOperatorNode operator color: self operatorColor;
		printWhitespace;
		visit: aBinaryOperatorNode rightExpression]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptBracketMember: aBracketMemberNode [
	self
		visit: aBracketMemberNode base;
		print: '[' color: self operatorColor;
		visit: aBracketMemberNode member;
		print: ']' color: self operatorColor]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptBreak: aBreakNode [
	self
		print: 'break' color: self keywordColor;
		printControlStatement: aBreakNode]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptCatch: anCatchNode [
	self
		print: 'catch' color: self keywordColor;
		print: ' (';
		visit: anCatchNode identifier;
		print: ')';
		printWhitespace;
		visit: anCatchNode block]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptConditionalExpression: aConditionalExpressionNode [
	self
		visit: aConditionalExpressionNode condition;
		print: ' ? ' color: self keywordColor;
		visit: aConditionalExpressionNode trueExpression.
	aConditionalExpressionNode falseExpression notNil ifTrue: [
		self
			print: ' : ' color: self keywordColor;
			visit: aConditionalExpressionNode falseExpression]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptConstStatement: aConstStatementNode [
	self print: 'const ' color: self specialColor.
	aConstStatementNode variableDeclarations
		do: [:decl | self visit: decl]
		separatedBy: [self print: ','; printWhitespace]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptContinue: aContinueNode [
	self
		print: 'continue' color: self keywordColor;
		printControlStatement: aContinueNode]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptDebugger: aDebuggerNode [
	self print: 'debugger' color: self keywordColor]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptDotMember: aDotMemberNode [
	self
		visit: aDotMemberNode base;
		bold: '.' color: self operatorColor;
		visit: aDotMemberNode member]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptDoWhile: aDoWhileNode [
	self
		print: 'do ' color: self keywordColor;
		visit: aDoWhileNode statement;
		print: ' while' color: self keywordColor;
		print: ' (';
		visit: aDoWhileNode condition;
		print: ')']

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptFinally: aFinallyNode [
	self
		print: 'finally ' color: self keywordColor;
		visit: aFinallyNode block]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptForEnumerateElements: aForEnumerateElementsNode [
	self
		print: 'for' color: self keywordColor;
		print: ' (';
		visit: aForEnumerateElementsNode enumerable;
		print: ' in ' color: self keywordColor;
		visit: aForEnumerateElementsNode collection;
		print: ')';
		indentedDo: [self visit: aForEnumerateElementsNode statement]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptForEnumerateLet: aForEnumerateLetNode [
	self
		print: 'for' color: self keywordColor;
		print: ' (';
		print: 'let ' color: self specialColor;
		visit: aForEnumerateLetNode variableDeclaration;
		print: ' in ' color: self keywordColor;
		visit: aForEnumerateLetNode collection;
		print: ')';
		indentedDo: [self visit: aForEnumerateLetNode statement]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptForEnumerateVariable: aForEnumerateVariableNode [
	self
		print: 'for' color: self keywordColor;
		print: ' (';
		print: 'var ' color: self specialColor;
		visit: aForEnumerateVariableNode variableDeclaration;
		print: ' in ' color: self keywordColor;
		visit: aForEnumerateVariableNode collection;
		print: ')';
		indentedDo: [self visit: aForEnumerateVariableNode statement]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptForWithInitializer: anInitializedForNode [
	self
		print: 'for' color: self keywordColor;
		print: ' ('.
	anInitializedForNode initializer
		ifNotNil: [:initializer | self visit: initializer];
		print: ';'.
	anInitializedForNode condition
		ifNotNil: [:condition | self visit: condition];
		print: ';'.
	anInitializedForNode updateExpression
		ifNotNil: [:update | self visit: update];
		print: ')';
		indentedDo: [self visit: anInitializedForNode statement]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptForWithLetList: aForWithLetListNode [
	| expr |
	self
		print: 'for' color: self keywordColor;
		print: ' (';
		print: 'let ' color: self specialColor.
	aForWithLetListNode variableDeclarations
		do: [:decl | self visit: decl]
		separatedBy: [self print: ','; printWhitespace].
	self print: ';'.
	aForWithLetListNode condition
		ifNotNil: [:condition | self printWhitespace; visit: condition].
	self print: ';'.
	expr := aForWithLetListNode updateExpression
		ifNotNil: [:update | self printWhitespace; visit: update].
	self print: ')'.
	expr indentedDo: [self visit: aForWithLetListNode statement]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptForWithVariableList: aForWithVariableListNode [
	| expr |
	self
		print: 'for' color: self keywordColor;
		print: ' (';
		print: 'var ' color: self specialColor.
	aForWithVariableListNode variableDeclarations
		do: [:varDeclaration | self visit: varDeclaration]
		separatedBy: [self print: ','; printWhitespace].
	self print: ';'.
	aForWithVariableListNode condition
		ifNotNil: [:condition | self printWhitespace; visit: condition].
	self print: ';'.
	expr := aForWithVariableListNode updateExpression
		ifNotNil: [:update | self printWhitespace; visit: update].
	self print: ')'.
	expr indentedDo: [self visit: aForWithVariableListNode statement]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptGetPropertyAssignment: aGetPropertyAssignmentNode [
	self
		print: 'get ' color: self keywordColor;
		print: aGetPropertyAssignmentNode propertyName;
		print: '()';
		printWhitespace;
		print: '{';
		indentedDo: [self visit: aGetPropertyAssignmentNode expression]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptIdentifierName: anIdentifierNameNode [
	self print: anIdentifierNameNode identifier color: self identifierColor]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptIf: anIfNode [
	self
		print: 'if' color: self keywordColor;
		print: ' (';
		visit: anIfNode condition;
		print: ')';
		indentedDo: [self visit: anIfNode trueExpression].
	anIfNode falseExpression notNil ifTrue: [
		self
			printNewLine;
			print: 'else' color: self keywordColor;
			indentedDo: [self visit: anIfNode falseExpression]]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptLetStatement: aLetStatementNode [
	self print: 'let ' color: self specialColor.
	aLetStatementNode variableDeclarations
		do: [:decl | self visit: decl]
		separatedBy: [self print: ','; printWhitespace]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptLiteralArray: anArrayLiteralNode [
	self print: '[' color: self operatorColor.
	anArrayLiteralNode padBefore timesRepeat: [self print: ','].
	anArrayLiteralNode array
		do: [:each | self visit: each]
		separatedBy: [self print: ', '].
	anArrayLiteralNode padAfter timesRepeat: [self print: ','].
	self print: ']' color: self operatorColor]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptLiteralBoolean: anBooleanLiteralNode [
	self
		print: anBooleanLiteralNode literalValue printString
		color: self globalColor]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptLiteralNull: anNullLiteralNode [
	self print: 'null' color: self globalColor]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptLiteralNumeric: anNumericLiteralNode [
	| number s |
	number := anNumericLiteralNode literalValue.
	s := number isFloat
		ifTrue: [number storeString]
		ifFalse: [number printString].
	s last = $d ifTrue: [s := s allButLast].
	self print: s color: self literalColor]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptMacro: aMacroNode [
	self
		print: '#' color: self specialColor;
		print: aMacroNode identifier color: self argColor]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptNew: aNewNode [
	self
		print: 'new ' color: self keywordColor;
		acceptCall: aNewNode]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptRegularExpression: anRegularExpressionNode [
	self
		print: '/';
		print: anRegularExpressionNode regularExpression color: self specialColor;
		print: '/'.
	anRegularExpressionNode flags ifNotNil: [:flags | self print: flags]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptReturn: aReturnNode [
	self print: 'return' color: self keywordColor.
	aReturnNode return
		ifNotNil: [:return | self printWhitespace; visit: return]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptSetPropertyAssignment: aSetPropertyAssignmentNode [
	self
		print: 'set ' color: self keywordColor;
		print: aSetPropertyAssignmentNode propertyName;
		print: '(';
		visit: aSetPropertyAssignmentNode parameter;
		print: ')';
		printWhitespace;
		print: '{';
		indentedDo: [self visit: aSetPropertyAssignmentNode expression]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptSwitch: aSwitchNode [
	self
		print: 'switch' color: self keywordColor;
		print: ' (';
		visit: aSwitchNode switch;
		print: ')';
		printNewLine;
		printBlockStatements: aSwitchNode clauses]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptSwitchClause: aSwitchClauseNode [
	self
		print: 'case' color: self keywordColor;
		printWhitespace;
		visit: aSwitchClauseNode clause;
		printSwitchClause: aSwitchClauseNode]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptSwitchDefaultClause: aSwitchDefaultClauseNode [
	self
		print: 'default' color: self keywordColor;
		printSwitchClause: aSwitchDefaultClauseNode]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptThis: aThisNode [
	self print: 'this' color: self literalColor]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptThrow: aThrowNode [
	self
		print: 'throw ' color: self keywordColor;
		visit: aThrowNode throwExpression]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptTry: aTryNode [
	self
		print: 'try ' color: self keywordColor;
		visit: aTryNode tryBlock.
	aTryNode catch ifNotNil: [:catch | self printNewLine; visit: catch].
	aTryNode finally ifNotNil: [:finally | self printNewLine; visit: finally]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptUnaryOperator: anUnaryOperatorNode [
	| operator |
	operator := anUnaryOperatorNode operator.
	self print: operator color: self operatorColor.
	(operator anySatisfy: [:char | char isLetter]) ifTrue: [self printWhitespace].
	self visit: anUnaryOperatorNode expression]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptVariableDeclaration: aVariableDeclarationNode [
	self visit: aVariableDeclarationNode identifier.
	aVariableDeclarationNode initializer ifNotNil: [:initializer | 
		self
			printWhitespace;
			bold: '=' color: self operatorColor;
			printWhitespace;
			visit: initializer]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptVariableStatement: aVariableStatementNode [
	self print: 'var ' color: self specialColor.
	aVariableStatementNode variableDeclarations
		do: [:decl | self visit: decl]
		separatedBy: [self print: ','; printWhitespace]]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptWhile: aWhileNode [
	self
		print: 'while' color: self keywordColor;
		print: ' (';
		visit: aWhileNode condition;
		print: ')';
		printWhitespace;
		visit: aWhileNode statement]

{ #category : #'double dispatch' }
JSEColorPrinterVisitor >> acceptWith: aWithNode [
	self
		print: 'with' color: self keywordColor;
		print: ' (';
		visit: aWithNode withExpression;
		print: ')';
		printWhitespace;
		visit: aWithNode statement]

{ #category : #colors }
JSEColorPrinterVisitor >> argColor [
	^RGBColor darkRed]

{ #category : #printing }
JSEColorPrinterVisitor >> bold: aString color: aColor [
	stream isText
		ifTrue: [stream useColor: aColor while: [stream bold: aString]]
		ifFalse: [stream nextPutAll: aString]]

{ #category : #colors }
JSEColorPrinterVisitor >> defaultColor [
	^Color black attenuate]

{ #category : #colors }
JSEColorPrinterVisitor >> functionNameColor [
	^Color darkBlue]

{ #category : #colors }
JSEColorPrinterVisitor >> functionParameterColor [
	^Color red: 220 green: 100 blue: 0]

{ #category : #colors }
JSEColorPrinterVisitor >> globalColor [
	^RGBColor darkPink muchDarker]

{ #category : #colors }
JSEColorPrinterVisitor >> identifierColor [
	^Color red: 84 green: 134 blue: 192]

{ #category : #colors }
JSEColorPrinterVisitor >> keywordColor [
	^Color red: 185 green: 86 blue: 148]

{ #category : #colors }
JSEColorPrinterVisitor >> literalColor [
	^Color red attenuate]

{ #category : #private }
JSEColorPrinterVisitor >> on: aStream [
	stream := aStream.
	indent := 1]

{ #category : #colors }
JSEColorPrinterVisitor >> operatorColor [
	^Color darkGreen darker]

{ #category : #private }
JSEColorPrinterVisitor >> print: aString [
	self print: aString color: self defaultColor]

{ #category : #printing }
JSEColorPrinterVisitor >> print: aString color: aColor [
	stream isText
		ifTrue: [stream useColor: aColor while: [stream nextPutAll: aString]]
		ifFalse: [stream nextPutAll: aString]]

{ #category : #fragments }
JSEColorPrinterVisitor >> printCall: aJSECallNode [
	self visit: aJSECallNode member.
	self print: '('.
	aJSECallNode arguments notNil ifTrue: [
		aJSECallNode arguments
			do: [:argument | self visit: argument]
			separatedBy: [self print: ', '].
		self print: ')']]

{ #category : #printing }
JSEColorPrinterVisitor >> printChar: aCharacter color: aColor [
	stream isText
		ifTrue: [stream useColor: aColor while: [stream nextPut: aCharacter]]
		ifFalse: [stream nextPut: aCharacter]]

{ #category : #private }
JSEColorPrinterVisitor >> printEscaped: aString escape: aCollection [
	| lt prev |
	lt := JSELexicalParser lineTerminatorCodeUnitValues.
	prev := nil.
	aString do: [:char | | code hex |
		code := char codePoint.
		(((aCollection includes: char) and: [prev != $\]) or: [lt includes: code])
			ifTrue: [
				hex := code printPaddedWith: $0 to: 4 base: 16.
				self
					print: '\u';
					print: hex color: Color darkGreen]
			ifFalse: [self printChar: char color: self literalColor].
		prev := char]]

{ #category : #fragments }
JSEColorPrinterVisitor >> printFunction: aJSEFunctionNode [
	| color |
	self print: 'function' color: self keywordColor.
	aJSEFunctionNode identifier ifNotNil: [:identifier | 
		self
			print: ' ';
			print: identifier name color: self functionNameColor].
	self print: '('.
	color := self functionParameterColor.
	aJSEFunctionNode formalParameters
		do: [:parameter | self print: parameter name color: color]
		separatedBy: [self print: ', '].
	self print: ') '; visit: aJSEFunctionNode functionBody]

{ #category : #colors }
JSEColorPrinterVisitor >> specialColor [
	^Color darkGray]

