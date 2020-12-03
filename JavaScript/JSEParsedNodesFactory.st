"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEParsedNodesFactory,
	#superclass : #Object,
	#category : #JavaScript
}

{ #category : #'instance creation' }
JSEParsedNodesFactory class >> new [

	^ super new initialize]

{ #category : #expressions }
JSEParsedNodesFactory >> createAdditiveExpression: expression1 with: expression2 operator: operatorString [
	" 11.6 Additive Operators "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createArguments: arguments [
	" 11.2 Left-Hand-Side Expressions "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createArray: elements padBefore: head after: tail [
	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createAssignmentExpression: leftHandSideExpression to: assignedExpression operator: operatorString [
	" 11.13 Assignment Operators "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createBitwiseExpression: expression1 with: expression2 operator: operatorString [
	" 11.10 Binary Bitwise Operators "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createBlock: statementList [
	" 12.1 Block "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createBreak: identifierOrNil [
	" 12.8 The break Statement "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createCall: memberExpression arguments: arguments [
	" 11.2 Left-Hand-Side Expressions "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createCatch: identifier block: catchBlock [
	" 12.14 The try Statement "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createCommaSeparatedExpression: expression1 with: expression2 [
	" 11.14 Comma Operator "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createConditionalExpression: textExpression trueExpression: trueExpression falseExpression: falseExpression [
	" 11.12 Conditional Operator "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createContinue: identifierOrNil [
	" 12.7 The continue Statement "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createDebugger [
	" 12.15 The debugger statement "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createDo: statement whileExpression: whileExpression [
	" 12.6.1 The do-while Statement "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createEmptyStatement [
	" 12.3 Empty Statement "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createEqualityExpression: expression1 with: expression2 operator: operatorString [
	" 11.9 Equality Operators "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createExpressionStatement: expression [
	" 12.4 Expression Statement "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createFinally: finallyBlock [
	" 12.14 The try Statement "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createFor: initializationExpression condition: conditionExpression update: updateExpression do: statement [
	" 12.6.3 The for Statement "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createFor: enumerableExpression in: collectionExpression do: statement [
	" 12.6.3 The for Statement "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createForLet: variableDeclaration in: collectionExpression do: statement [
	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createForLetList: variableDeclarationList
condition: conditionExpression
update: updateExpression
do: statement [
	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createForVariable: variableDeclaration in: collectionExpression do: statement [
	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createForVariables: variableDeclarationList
condition: conditionExpression
update: updateExpression
do: statement [
	self subclassResponsibility]

{ #category : #'functions and programs' }
JSEParsedNodesFactory >> createFunctionBody: sourceElements [
	" 13 Function Definition "

	self subclassResponsibility]

{ #category : #'functions and programs' }
JSEParsedNodesFactory >> createFunctionDeclaration: identifier parameters: formalParameters body: functionBody [
	" 13 Function Definition "

	self subclassResponsibility]

{ #category : #'functions and programs' }
JSEParsedNodesFactory >> createFunctionExpression: identifierOrNil parameters: formalParameters body: functionBody [
	" 13 Function Definition "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createGroupedExpression: expression [
	" 11.1.6 The Grouping Operator "

	self subclassResponsibility]

{ #category : #'lexical elements' }
JSEParsedNodesFactory >> createIdentifier: token [
	" 7.5 Tokens "

	self subclassResponsibility]

{ #category : #'lexical elements' }
JSEParsedNodesFactory >> createIdentifierName: token [
	" 7.5 Tokens "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createIf: textExpression trueExpression: trueExpression falseExpression: falseExpressionOrNil [
	" 12.5 The if Statement "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createLabel: labelIdentifier statement: statement [
	" 12.12 Labelled Statements "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createLetDeclaration: identifier initializer: initializerOrNil [
	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createLetStatement: variableDeclarations [
	self subclassResponsibility]

{ #category : #'lexical elements' }
JSEParsedNodesFactory >> createLiteralBoolean: token [
	"
	7.8 Literals
	"
	self subclassResponsibility]

{ #category : #'lexical elements' }
JSEParsedNodesFactory >> createLiteralNull: token [
	"
	7.8 Literals
	"
	self subclassResponsibility]

{ #category : #'lexical elements' }
JSEParsedNodesFactory >> createLiteralNumeric: token [
	"
	7.8 Literals
	"
	self subclassResponsibility]

{ #category : #'lexical elements' }
JSEParsedNodesFactory >> createLiteralString: token [
	"
	7.8 Literals
	"
	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createLogicalExpression: expression1 with: expression2 operator: operatorString [
	" 11.11 Binary Logical Operators "

	self subclassResponsibility]

{ #category : #'lexical elements' }
JSEParsedNodesFactory >> createMacro: token [
	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createMemberOf: baseExpression bracket: bracketExpression [
	" 11.2 Left-Hand-Side Expressions "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createMemberOf: baseExpression dot: dotExpression [
	" 11.2 Left-Hand-Side Expressions "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createMultiplicativeExpression: expression1 with: expression2 operator: operatorString [
	" 11.5 Multiplicative Operators "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createNew: newExpression arguments: argumentsOrNil [
	" 11.2 Left-Hand-Side Expressions "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createObject: propertyAssignmentList [
	" 11.1.5 Object Initialiser "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createPostfixExpression: expression operator: postfixOperatorString [
	" 11.3 Postfix Expressions "

	self subclassResponsibility]

{ #category : #'functions and programs' }
JSEParsedNodesFactory >> createProgram: sourceElements [
	" 14 Program "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createPropertyAssignment: propertyName expression: assignedExpression [
	" 11.1.5 Object Initialiser "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createPropertyGetAssignment: propertyName functionBody: functionBody [
	" 11.1.5 Object Initialiser "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createPropertySetAssignment: propertyName parameter: parameter functionBody: functionBody [
	" 11.1.5 Object Initialiser "

	self subclassResponsibility]

{ #category : #'lexical elements' }
JSEParsedNodesFactory >> createRegularExpression: regexToken [
	" 15.10 RegExp (Regular Expression) Objects "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createRelationalExpression: expression1 with: expression2 operator: operatorString [
	" 11.8 Relational Operators "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createReturn: returnExpressionOrNil [
	" 12.9 The return Statement "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createShiftExpression: expression1 with: expression2 operator: operatorString [
	" 11.7 Bitwise Shift Operators "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createSwitch: switchExpression clauses: clauses [
	" 12.11 The switch Statement "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createSwitchClause: clauseExpression statements: statements [
	" 12.11 The switch Statement "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createSwitchDefaultClause: statements [
	" 12.11 The switch Statement "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createThisExpression [
	" 11.1.1 The this Keyword "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createThrow: throwExpression [
	" 12.13 The throw Statement "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createTry: tryBlock catch: catchStatementOrNil finally: finallyStatementOrNil [
	" 12.14 The try Statement "

	self subclassResponsibility]

{ #category : #expressions }
JSEParsedNodesFactory >> createUnaryExpression: expression operator: unaryOperatorString [
	" 11.4 Unary Operators "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createVariableDeclaration: identifier initializer: initializerOrNil [
	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createVariableStatement: variableDeclarations [
	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createWhile: expression statement: statement [
	" 12.6.2 The while Statement "

	self subclassResponsibility]

{ #category : #statements }
JSEParsedNodesFactory >> createWith: withExpression statement: statement [
	" 12.10 The with Statement "

	self subclassResponsibility]

{ #category : #'initialize-release' }
JSEParsedNodesFactory >> initialize [
]

