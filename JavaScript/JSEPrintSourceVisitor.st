"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEPrintSourceVisitor,
	#superclass : #JSESyntaxTreeVisitor,
	#instVars : [
		'indent',
		'stream',
		'semicolon'
	],
	#category : #JavaScript
}

{ #category : #'instance creation' }
JSEPrintSourceVisitor class >> on: aStream [
	^self new on: aStream]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptAssignment: anAssignmentNode [
	self
		visit: anAssignmentNode assignee;
		printWhitespace;
		print: anAssignmentNode operator;
		printWhitespace;
		visit: anAssignmentNode expression]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptBinaryOperator: aBinaryOperatorNode [
	self
		visit: aBinaryOperatorNode leftExpression;
		printWhitespace;
		print: aBinaryOperatorNode operator;
		printWhitespace;
		visit: aBinaryOperatorNode rightExpression]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptBlock: anBlockNode [
	self printBlockStatements: anBlockNode statements]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptBracketMember: aBracketMemberNode [
	self
		visit: aBracketMemberNode base;
		print: '[';
		visit: aBracketMemberNode member;
		print: ']']

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptBreak: aBreakNode [
	self print: 'break'; printControlStatement: aBreakNode]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptCall: aJSECallNode [
	self printCall: aJSECallNode]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptCatch: anCatchNode [
	self
		print: 'catch (';
		visit: anCatchNode identifier;
		print: ')';
		printWhitespace;
		visit: anCatchNode block]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptCommaSeparatedExpressions: aCommaSeparatedExpressionsNode [
	self
		visit: aCommaSeparatedExpressionsNode leftExpression;
		print: ',';
		printWhitespace;
		visit: aCommaSeparatedExpressionsNode rightExpression]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptConditionalExpression: aConditionalExpressionNode [
	self
		visit: aConditionalExpressionNode condition;
		print: ' ? ';
		visit: aConditionalExpressionNode trueExpression.
	aConditionalExpressionNode falseExpression notNil
		ifTrue: [self
			print: ' : ';
			visit: aConditionalExpressionNode falseExpression]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptConstStatement: aConstStatementNode [
	self print: 'const '.
	aConstStatementNode variableDeclarations
		do: [:decl | self visit: decl]
		separatedBy: [self print: ','; printWhitespace]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptContinue: aContinueNode [
	self print: 'continue'; printControlStatement: aContinueNode]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptDebugger: aDebuggerNode [
	self print: 'debugger']

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptDotMember: aDotMemberNode [
	self
		visit: aDotMemberNode base;
		print: '.';
		visit: aDotMemberNode member]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptDoWhile: aDoWhileNode [
	self
		print: 'do ';
		visit: aDoWhileNode statement;
		print: ' while (';
		visit: aDoWhileNode condition;
		print: ')']

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptEmptyStatement: anEmptyStatementNode [
	]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptExpressionStatement: anExpressionStatementNode [
	self visit: anExpressionStatementNode expression]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptFinally: aFinallyNode [
	self print: 'finally '; visit: aFinallyNode block]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptForEnumerateElements: aForEnumerateElementsNode [
	self
		print: 'for (';
		visit: aForEnumerateElementsNode enumerable;
		print: ' in ';
		visit: aForEnumerateElementsNode collection;
		print: ')';
		indentedDo: [self visit: aForEnumerateElementsNode statement]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptForEnumerateLet: aForEnumerateLetNode [
	self
		print: 'for (let ';
		visit: aForEnumerateLetNode variableDeclaration;
		print: ' in ';
		visit: aForEnumerateLetNode collection;
		print: ')';
		indentedDo: [self visit: aForEnumerateLetNode statement]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptForEnumerateVariable: aForEnumerateVariableNode [
	self
		print: 'for (var ';
		visit: aForEnumerateVariableNode variableDeclaration;
		print: ' in ';
		visit: aForEnumerateVariableNode collection;
		print: ')';
		indentedDo: [self visit: aForEnumerateVariableNode statement]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptForWithInitializer: anInitializedForNode [
	self print: 'for ('.
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
JSEPrintSourceVisitor >> acceptForWithLetList: aForWithLetListNode [
	self print: 'for (let '.
	aForWithLetListNode variableDeclarations
		do: [:decl | self visit: decl]
		separatedBy: [self print: ','; printWhitespace].
	self print: ';'.
	aForWithLetListNode condition
		ifNotNil: [:condition | self visit: condition].
	self print: ';'.
	aForWithLetListNode updateExpression
		ifNotNil: [:update | self visit: update].
	self
		print: ')';
		indentedDo: [self visit: aForWithLetListNode statement]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptForWithVariableList: aForWithVariableListNode [
	self print: 'for (var '.
	aForWithVariableListNode variableDeclarations
		do: [:varDeclaration | self visit: varDeclaration]
		separatedBy: [self print: ','; printWhitespace].
	self print: ';'.
	aForWithVariableListNode condition
		ifNotNil: [:condition | self visit: condition].
	self print: ';'.
	aForWithVariableListNode updateExpression
		ifNotNil: [:update | self visit: update].
	self
		print: ')';
		indentedDo: [self visit: aForWithVariableListNode statement]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptFunctionBody: aFunctionBodyNode [
	self printBlockStatements: aFunctionBodyNode sourceElements]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptFunctionDeclaration: aFunctionDeclarationNode [
	self printFunction: aFunctionDeclarationNode]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptFunctionExpression: aFunctionExpressionNode [
	self printFunction: aFunctionExpressionNode]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptGetPropertyAssignment: aGetPropertyAssignmentNode [
	self
		print: 'get ';
		print: aGetPropertyAssignmentNode propertyName;
		print: '()';
		printWhitespace;
		print: '{';
		indentedDo: [self visit: aGetPropertyAssignmentNode expression]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptGroupedExpression: aGroupedExpressionNode [
	self
		print: '(';
		visit: aGroupedExpressionNode expression;
		print: ')']

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptIdentifier: anIdentifierNode [
	self acceptIdentifierName: anIdentifierNode]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptIdentifierName: anIdentifierNameNode [
	self print: anIdentifierNameNode identifier]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptIf: anIfNode [
	self
		print: 'if (';
		visit: anIfNode condition;
		print: ')';
		indentedDo: [self visit: anIfNode trueExpression].
	anIfNode falseExpression notNil ifTrue: [
		self
			printNewLine;
			print: 'else';
			indentedDo: [self visit: anIfNode falseExpression]]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptLabelledStatement: aLabelledStatementNode [
	self
		visit: aLabelledStatementNode label;
		print: ':';
		printWhitespace;
		visit: aLabelledStatementNode statement]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptLetStatement: aLetStatementNode [
	self print: 'let '.
	aLetStatementNode variableDeclarations
		do: [:decl | self visit: decl]
		separatedBy: [self print: ','; printWhitespace]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptLiteralArray: anArrayLiteralNode [
	self print: '['.
	anArrayLiteralNode padBefore timesRepeat: [self print: ','].
	anArrayLiteralNode array
		do: [:each | self visit: each]
		separatedBy: [self print: ', '].
	anArrayLiteralNode padAfter timesRepeat: [self print: ','].
	self print: ']']

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptLiteralBoolean: anBooleanLiteralNode [
	self print: anBooleanLiteralNode literalValue printString]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptLiteralNull: anNullLiteralNode [
	self print: 'null']

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptLiteralNumeric: anNumericLiteralNode [
	| number s |
	number := anNumericLiteralNode literalValue.
	s := number isFloat
		ifTrue: [number storeString]
		ifFalse: [number printString].
	s last = $d ifTrue: [s := s allButLast].
	self print: s]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptLiteralObject: anObjectLiteralNode [
	self
		printBlockStatements: anObjectLiteralNode propertyAssignments
		separationBlock: [self print: ', ']]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptLiteralString: anStringLiteralNode [
	| delimiter |
	delimiter := anStringLiteralNode delimiter.
	self
		print: delimiter asString;
		printEscaped: anStringLiteralNode source escape: (String with: delimiter);
		print: delimiter asString]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptMacro: aMacroNode [
	self print: '#'; print: aMacroNode identifier]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptNew: aNewNode [
	self print: 'new '; acceptCall: aNewNode]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptNode: aNode [
	self visitChildrenOf: aNode]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptPostfixOperator: anPostfixOperatorNode [
	self
		visit: anPostfixOperatorNode expression;
		print: anPostfixOperatorNode operator]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptProgram: aProgramNode [
	self
		printIndent;
		printNodeLines: aProgramNode sourceElements
		separatedBy: [self print: ';'].
	semicolon ifTrue: [self print: ';']]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptPropertyAssignment: anPropertyAssignmentNode [
	self
		visit: anPropertyAssignmentNode propertyName;
		print: ':';
		printWhitespace;
		visit: anPropertyAssignmentNode expression]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptRegularExpression: anRegularExpressionNode [
	self
		print: '/';
		print: anRegularExpressionNode regularExpression;
		print: '/'.
	anRegularExpressionNode flags ifNotNil: [:flags | self print: flags]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptReturn: aReturnNode [
	self print: 'return'.
	aReturnNode return
		ifNotNil: [:return | self printWhitespace; visit: return]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptSetPropertyAssignment: aSetPropertyAssignmentNode [
	self
		print: 'set ';
		print: aSetPropertyAssignmentNode propertyName;
		print: '(';
		visit: aSetPropertyAssignmentNode parameter;
		print: ')';
		printWhitespace;
		print: '{';
		indentedDo: [self visit: aSetPropertyAssignmentNode expression]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptSwitch: aSwitchNode [
	self
		print: 'switch (';
		visit: aSwitchNode switch;
		print: ')';
		printNewLine;
		printBlockStatements: aSwitchNode clauses]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptSwitchClause: aSwitchClauseNode [
	self
		print: 'case';
		printWhitespace;
		visit: aSwitchClauseNode clause;
		printSwitchClause: aSwitchClauseNode]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptSwitchDefaultClause: aSwitchDefaultClauseNode [
	self print: 'default'; printSwitchClause: aSwitchDefaultClauseNode]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptThis: aThisNode [
	self print: 'this']

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptThrow: aThrowNode [
	self print: 'throw '; visit: aThrowNode throwExpression]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptTry: aTryNode [
	self print: 'try '; visit: aTryNode tryBlock.
	aTryNode catch ifNotNil: [:catch | self printNewLine; visit: catch].
	aTryNode finally ifNotNil: [:finally | self printNewLine; visit: finally]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptUnaryOperator: anUnaryOperatorNode [
	| operator |
	operator := anUnaryOperatorNode operator.
	self print: operator.
	(operator anySatisfy: [:char | char isLetter]) ifTrue: [self printWhitespace].
	self visit: anUnaryOperatorNode expression]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptVariableDeclaration: aVariableDeclarationNode [
	self visit: aVariableDeclarationNode identifier.
	aVariableDeclarationNode initializer ifNotNil: [:initializer | 
		self
			printWhitespace;
			print: '=';
			printWhitespace;
			visit: initializer]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptVariableStatement: aVariableStatementNode [
	self print: 'var '.
	aVariableStatementNode variableDeclarations
		do: [:decl | self visit: decl]
		separatedBy: [self print: ','; printWhitespace]]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptWhile: aWhileNode [
	self
		print: 'while (';
		visit: aWhileNode condition;
		print: ')';
		printWhitespace;
		visit: aWhileNode statement]

{ #category : #'double dispatch' }
JSEPrintSourceVisitor >> acceptWith: aWithNode [
	self
		print: 'with (';
		visit: aWithNode withExpression;
		print: ')';
		printWhitespace;
		visit: aWithNode statement]

{ #category : #private }
JSEPrintSourceVisitor >> appendSemicolon: aBoolean [
	semicolon := aBoolean]

{ #category : #private }
JSEPrintSourceVisitor >> indent: anInteger [
	indent := anInteger]

{ #category : #private }
JSEPrintSourceVisitor >> indentedDo: aBlock [
	stream nextPut: Cr.
	indent := indent + 1.
	self printIndent.
	^aBlock ensure: [indent := indent - 1]]

{ #category : #'initialize-release' }
JSEPrintSourceVisitor >> initialize [
	super initialize.
	semicolon := true]

{ #category : #private }
JSEPrintSourceVisitor >> on: aStream [
	stream := aStream.
	indent := 0]

{ #category : #private }
JSEPrintSourceVisitor >> print: aString [
	stream nextPutAll: aString]

{ #category : #private }
JSEPrintSourceVisitor >> printBlockStatements: statements [
	self printBlockStatements: statements separationBlock: [self print: ';']]

{ #category : #private }
JSEPrintSourceVisitor >> printBlockStatements: statements separationBlock: separationBlock [
	self print: '{'.
	(statements notNil and: [statements notEmpty]) ifTrue: [
		self
			indentedDo: [self printNodeLines: statements separatedBy: separationBlock];
			printNewLine].
	self print: '}']

{ #category : #fragments }
JSEPrintSourceVisitor >> printCall: aJSECallNode [
	self visit: aJSECallNode member.
	aJSECallNode arguments notNil ifTrue: [
		self print: '('.
		aJSECallNode arguments
			do: [:arg | self visit: arg]
			separatedBy: [self print: ','; printWhitespace].
		self print: ')']]

{ #category : #fragments }
JSEPrintSourceVisitor >> printControlStatement: aNode [
	aNode identifier
		ifNotNil: [:identifier | self printWhitespace; visit: identifier]]

{ #category : #private }
JSEPrintSourceVisitor >> printEscaped: aString [
	self printEscaped: aString escape: '']

{ #category : #private }
JSEPrintSourceVisitor >> printEscaped: aString escape: aCollection [
	| lt prev |
	lt := JSELexicalParser lineTerminatorCodeUnitValues.
	prev := nil.
	aString do: [:char | | code hex |
		code := char codePoint.
		(((aCollection includes: char) andNot: [prev = $\]) or: [lt includes: code])
			ifTrue: [
				hex := code printPaddedWith: $0 to: 4 base: 16.
				stream nextPutAll: '\u'; nextPutAll: hex]
			ifFalse: [stream nextPut: char].
		prev := char]]

{ #category : #fragments }
JSEPrintSourceVisitor >> printFunction: aJSEFunctionNode [
	self print: 'function'.
	aJSEFunctionNode identifier
		ifNotNil: [:identifier | self print: ' '; visit: identifier].
	self print: '('.
	aJSEFunctionNode formalParameters
		do: [:param | self visit: param]
		separatedBy: [self print: ', '].
	self print: ') '; visit: aJSEFunctionNode functionBody]

{ #category : #private }
JSEPrintSourceVisitor >> printIndent [
	indent timesRepeat: [stream tab]]

{ #category : #private }
JSEPrintSourceVisitor >> printNewLine [
	stream nextPut: Cr.
	self printIndent]

{ #category : #fragments }
JSEPrintSourceVisitor >> printNodeLines: aCollection separatedBy: aBlock [
	| statements |
	aCollection isNil ifTrue: [^self].
	statements := aCollection reject: [:s | s isEmptyNode].
	statements do: [:s | self visit: s] separatedBy: [
		aBlock value.
		self printNewLine]]

{ #category : #fragments }
JSEPrintSourceVisitor >> printSwitchClause: aClauseNode [
	| statements |
	self print: ':'.
	statements := aClauseNode statements.
	statements isEmpty ifTrue: [^self].
	self
		indentedDo: [self
			printNodeLines: statements
			separatedBy: [self print: ';']]]

{ #category : #private }
JSEPrintSourceVisitor >> printWhitespace [
	stream space]

