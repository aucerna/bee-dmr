"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSETestFactory,
	#superclass : #JSEParsedNodesFactory,
	#category : #'JavaScript\Tests'
}

{ #category : #expressions }
JSETestFactory >> createAdditiveExpression: expression1 with: expression2 operator: operatorString [
	^{expression1. operatorString asSymbol. expression2}]

{ #category : #expressions }
JSETestFactory >> createArguments: arguments [
	" 11.2 Left-Hand-Side Expressions "

	^ arguments]

{ #category : #expressions }
JSETestFactory >> createArray: elements padBefore: head after: tail [
	| h t e array |
	h := head ifNil: 0.
	t := tail ifNil: 0.
	e := elements ifNil: [Array new].
	^(h > 0 or: [t > 0])
		ifTrue: [
			array := Array new: h + e size + t.
			array replaceFrom: h + 1 to: h + e size with: e]
		ifFalse: [e]]

{ #category : #expressions }
JSETestFactory >> createAssignmentExpression: leftHandSideExpression to: assignedExpression operator: operatorString [
	" 11.13 Assignment Operators "

	^ Array with: leftHandSideExpression with: operatorString asSymbol with: assignedExpression]

{ #category : #expressions }
JSETestFactory >> createBitwiseExpression: expression1 with: expression2 operator: operatorString [
	" 11.10 Binary Bitwise Operators "

	^ Array with: expression1 with: operatorString asSymbol with: expression2]

{ #category : #statements }
JSETestFactory >> createBlock: statementList [
	" 12.1 Block "

	^ statementList]

{ #category : #statements }
JSETestFactory >> createBreak: identifierOrNil [
	^identifierOrNil notNil
		ifTrue: [{#break. identifierOrNil}]
		ifFalse: [#break]]

{ #category : #expressions }
JSETestFactory >> createCall: memberExpression arguments: arguments [
	^{memberExpression. arguments}]

{ #category : #statements }
JSETestFactory >> createCatch: identifier block: catchBlock [
	" 12.14 The try Statement "

	^ Array with: #catch with: identifier with: catchBlock]

{ #category : #expressions }
JSETestFactory >> createCommaSeparatedExpression: expression1 with: expression2 [
	^{expression1. expression2}]

{ #category : #expressions }
JSETestFactory >> createConditionalExpression: textExpression trueExpression: trueExpression falseExpression: falseExpression [
	" 11.12 Conditional Operator "

	^ Array with: textExpression with: $? with: trueExpression with: $: with: falseExpression]

{ #category : #statements }
JSETestFactory >> createConstStatement: variableDeclarations [
	^{#const. variableDeclarations}]

{ #category : #statements }
JSETestFactory >> createContinue: identifierOrNil [
	^identifierOrNil notNil
		ifTrue: [{#continue. identifierOrNil}]
		ifFalse: [#continue]]

{ #category : #statements }
JSETestFactory >> createDebugger [
	" 12.15 The debugger statement "

	^ #debugger]

{ #category : #statements }
JSETestFactory >> createDo: statement whileExpression: whileExpression [
	" 12.6.1 The do-while Statement "

	^ Array with: #do with: statement with: #while with: whileExpression]

{ #category : #statements }
JSETestFactory >> createEmptyStatement [
	" 12.3 Empty Statement "

	^ #()]

{ #category : #expressions }
JSETestFactory >> createEqualityExpression: expression1 with: expression2 operator: operatorString [
	" 11.9 Equality Operators "

	^ Array with: expression1 with: operatorString asSymbol with: expression2]

{ #category : #statements }
JSETestFactory >> createExpressionStatement: expression [
	" 12.4 Expression Statement "

	^ expression]

{ #category : #statements }
JSETestFactory >> createFinally: finallyBlock [
	^{#finally. finallyBlock}]

{ #category : #statements }
JSETestFactory >> createFor: initializationExpression condition: conditionExpression update: updateExpression do: statement [
	" 12.6.3 The for Statement "

	^ Array with: #for with: (Array with: initializationExpression with: conditionExpression with: updateExpression) with: statement]

{ #category : #statements }
JSETestFactory >> createFor: enumerableExpression in: collectionExpression do: statement [
	" 12.6.3 The for Statement "

	^ Array with: #for with: (Array with: enumerableExpression with: #in with: collectionExpression) with: statement]

{ #category : #statements }
JSETestFactory >> createForLet: variableDeclaration in: collectionExpression do: statement [
	^{#for. {#let. variableDeclaration. #in. collectionExpression}. statement}]

{ #category : #statements }
JSETestFactory >> createForLetList: variableDeclarationList
condition: conditionExpression
update: updateExpression
do: statement [
	^{#for.
		{#let. variableDeclarationList. conditionExpression. updateExpression}.
		statement}]

{ #category : #statements }
JSETestFactory >> createForVariable: variableDeclaration in: collectionExpression do: statement [
	^{#for. {#var. variableDeclaration. #in. collectionExpression}. statement}]

{ #category : #statements }
JSETestFactory >> createForVariables: variableDeclarationList
condition: conditionExpression
update: updateExpression
do: statement [
	^{#for.
		{#var. variableDeclarationList. conditionExpression. updateExpression}.
		statement}]

{ #category : #'functions and programs' }
JSETestFactory >> createFunctionBody: sourceElements [
	" 13 Function Definition "

	^ sourceElements]

{ #category : #'functions and programs' }
JSETestFactory >> createFunctionDeclaration: identifier parameters: formalParameters body: functionBody [
	" 13 Function Definition "

	^ Array with: #function with: identifier with: formalParameters with: functionBody]

{ #category : #'functions and programs' }
JSETestFactory >> createFunctionExpression: identifierOrNil parameters: formalParameters body: functionBody [
	" 13 Function Definition "

	^ identifierOrNil notNil 
		ifTrue: [ Array with: #function with: identifierOrNil with: formalParameters with: functionBody ]
		ifFalse: [ Array with: #function with: formalParameters with: functionBody ]]

{ #category : #expressions }
JSETestFactory >> createGroupedExpression: expression [
	^{expression}]

{ #category : #'lexical elements' }
JSETestFactory >> createIdentifier: token [
	" 7.5 Tokens "

	^ token literalValue asSymbol]

{ #category : #'lexical elements' }
JSETestFactory >> createIdentifierName: token [
	" 7.5 Tokens "

	^ token literalValue asSymbol]

{ #category : #statements }
JSETestFactory >> createIf: textExpression trueExpression: trueExpression falseExpression: falseExpressionOrNil [
	" 12.5 The if Statement "

	^ falseExpressionOrNil notNil
		ifTrue: [ Array with: #if with: textExpression with: trueExpression with: falseExpressionOrNil ]
		ifFalse: [ Array with: #if with: textExpression with: trueExpression  ]]

{ #category : #statements }
JSETestFactory >> createLabel: labelIdentifier statement: statement [
	" 12.12 Labelled Statements "

	^ Array with: labelIdentifier with: #':'  with: statement]

{ #category : #statements }
JSETestFactory >> createLetDeclaration: identifier initializer: initializerOrNil [
	^self createVariableDeclaration: identifier initializer: initializerOrNil]

{ #category : #statements }
JSETestFactory >> createLetStatement: variableDeclarations [
	^{#let. variableDeclarations}]

{ #category : #'lexical elements' }
JSETestFactory >> createLiteralBoolean: token [
	"
	7.8 Literals
	"
	^token literalValue]

{ #category : #'lexical elements' }
JSETestFactory >> createLiteralNull: token [
	"
	7.8 Literals
	"
	^token literalValue]

{ #category : #'lexical elements' }
JSETestFactory >> createLiteralNumeric: token [
	"
	7.8 Literals
	"
	^token literalValue]

{ #category : #'lexical elements' }
JSETestFactory >> createLiteralString: token [
	"
	7.8 Literals
	"
	^token literalValue]

{ #category : #expressions }
JSETestFactory >> createLogicalExpression: expression1 with: expression2 operator: operatorString [
	" 11.11 Binary Logical Operators "

	^ Array with: expression1 with: operatorString asSymbol with: expression2]

{ #category : #'lexical elements' }
JSETestFactory >> createMacro: token [
	^token literalValue asSymbol]

{ #category : #expressions }
JSETestFactory >> createMemberOf: baseExpression bracket: bracketExpression [
	" 11.2 Left-Hand-Side Expressions "

	^ Array with: baseExpression with: $[ with: bracketExpression with: $]]

{ #category : #expressions }
JSETestFactory >> createMemberOf: baseExpression dot: dotExpression [
	" 11.2 Left-Hand-Side Expressions "

	^ Array with: baseExpression with: $. with: dotExpression]

{ #category : #expressions }
JSETestFactory >> createMultiplicativeExpression: expression1 with: expression2 operator: operatorString [
	" 11.5 Multiplicative Operators "

	^ Array with: expression1 with: operatorString asSymbol with: expression2]

{ #category : #expressions }
JSETestFactory >> createNew: newExpression arguments: argumentsOrNil [
	^argumentsOrNil notNil
		ifTrue: [{#new. newExpression. argumentsOrNil}]
		ifFalse: [{#new. newExpression}]]

{ #category : #expressions }
JSETestFactory >> createObject: propertyAssignmentList [
	" 11.1.5 Object Initialiser "

	| object |
	object := Dictionary new:  propertyAssignmentList size.
	propertyAssignmentList do: [ : assoc |
			object at: assoc key put: assoc value.
	].
	^ object]

{ #category : #expressions }
JSETestFactory >> createPostfixExpression: expression operator: postfixOperatorString [
	^{expression. postfixOperatorString asSymbol}]

{ #category : #'functions and programs' }
JSETestFactory >> createProgram: sourceElements [
	" 14 Program "

	^ sourceElements]

{ #category : #expressions }
JSETestFactory >> createPropertyAssignment: propertyName expression: assignedExpression [
	" 11.1.5 Object Initialiser "

	^ propertyName -> assignedExpression]

{ #category : #expressions }
JSETestFactory >> createPropertyGetAssignment: propertyName functionBody: functionBody [
	^{#get. propertyName} -> functionBody]

{ #category : #expressions }
JSETestFactory >> createPropertySetAssignment: propertyName parameter: parameter functionBody: functionBody [
	" 11.1.5 Object Initialiser "

	^ (Array with: #set with: propertyName with: parameter) ->  functionBody]

{ #category : #'lexical elements' }
JSETestFactory >> createRegularExpression: regexToken [
	^{#regex. regexToken literalValue}]

{ #category : #expressions }
JSETestFactory >> createRelationalExpression: expression1 with: expression2 operator: operatorString [
	" 11.8 Relational Operators "

	^ Array with: expression1 with: operatorString asSymbol with: expression2]

{ #category : #statements }
JSETestFactory >> createReturn: returnExpressionOrNil [
	^returnExpressionOrNil notNil
		ifTrue: [{#return. returnExpressionOrNil}]
		ifFalse: [#return]]

{ #category : #expressions }
JSETestFactory >> createShiftExpression: expression1 with: expression2 operator: operatorString [
	" 11.7 Bitwise Shift Operators "

	^ Array with: expression1 with: operatorString asSymbol with: expression2]

{ #category : #statements }
JSETestFactory >> createSwitch: switchExpression clauses: clauses [
	" 12.11 The switch Statement "

	^ Array with: #switch with: switchExpression with: clauses]

{ #category : #statements }
JSETestFactory >> createSwitchClause: clauseExpression statements: statements [
	" 12.11 The switch Statement "

	^ Array with: #case with: clauseExpression with: statements]

{ #category : #statements }
JSETestFactory >> createSwitchDefaultClause: statements [
	^{#default. statements}]

{ #category : #expressions }
JSETestFactory >> createThisExpression [
	" 11.1.1 The this Keyword "

	^ #this]

{ #category : #statements }
JSETestFactory >> createThrow: throwExpression [
	^{#throw. throwExpression}]

{ #category : #statements }
JSETestFactory >> createTry: tryBlock catch: catchStatementOrNil finally: finallyStatementOrNil [
	"
	12.14 The try Statement
	"
	| try |
	try := {#try. tryBlock}.
	catchStatementOrNil notNil
		ifTrue: [try := try copyWith: catchStatementOrNil].
	finallyStatementOrNil notNil
		ifTrue: [try := try copyWith: finallyStatementOrNil].
	^try]

{ #category : #expressions }
JSETestFactory >> createUnaryExpression: expression operator: unaryOperatorString [
	^{unaryOperatorString asSymbol. expression}]

{ #category : #statements }
JSETestFactory >> createVariableDeclaration: identifier initializer: initializerOrNil [
	^initializerOrNil notNil
		ifTrue: [{identifier. #'='. initializerOrNil}]
		ifFalse: [identifier]]

{ #category : #statements }
JSETestFactory >> createVariableStatement: variableDeclarations [
	^{#var. variableDeclarations}]

{ #category : #statements }
JSETestFactory >> createWhile: expression statement: statement [
	" 12.6.2 The while Statement "

	^ Array with: #while with: expression with: statement]

{ #category : #statements }
JSETestFactory >> createWith: withExpression statement: statement [
	" 12.10 The with Statement "

	^ Array with: #with with: withExpression with: statement]

{ #category : #'initialize-release' }
JSETestFactory >> initialize [
]

