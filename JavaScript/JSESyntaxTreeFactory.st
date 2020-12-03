"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSESyntaxTreeFactory,
	#superclass : #JSEParsedNodesFactory,
	#category : #JavaScript
}

{ #category : #expressions }
JSESyntaxTreeFactory >> createAdditiveExpression: expression1 with: expression2 operator: operatorString [
	" 11.6 Additive Operators "

	^ JSEBinaryOperatorNode new
		leftExpression: expression1;
		rightExpression: expression2;
		operator: operatorString asSymbol;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createArguments: arguments [
	" 11.2 Left-Hand-Side Expressions "

	^ arguments]

{ #category : #expressions }
JSESyntaxTreeFactory >> createArray: elements padBefore: head after: tail [
	^JSEArrayNode new
		array: elements;
		padBefore: head;
		padAfter: tail;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createAssignmentExpression: leftHandSideExpression to: assignedExpression operator: operatorString [
	"
	11.13 Assignment Operators
	"
	^JSEAssignmentNode new
		assignee: leftHandSideExpression;
		operator: operatorString asSymbol;
		expression: assignedExpression;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createBitwiseExpression: expression1 with: expression2 operator: operatorString [
	" 11.10 Binary Bitwise Operators "

	^ JSEBinaryOperatorNode new
		leftExpression: expression1;
		rightExpression: expression2;
		operator: operatorString asSymbol;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createBlock: aCollection [
	^JSEBlockNode new statements: aCollection]

{ #category : #statements }
JSESyntaxTreeFactory >> createBreak: identifierOrNil [
	" 12.8 The break Statement "

	^ JSEBreakNode new identifier: identifierOrNil;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createCall: memberExpression arguments: arguments [
	" 11.2 Left-Hand-Side Expressions "

	^ JSEFunctionCallNode new
		member: memberExpression;
		arguments: arguments;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createCatch: identifier block: catchBlock [
	" 12.14 The try Statement "

	^ JSECatchNode new identifier: identifier;
		block: catchBlock;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createCommaSeparatedExpression: expression1 with: expression2 [
	" 11.14 Comma Operator "

	^ JSECommaSeparatedExpressionsNode new
		leftExpression: expression1;
		rightExpression: expression2;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createConditionalExpression: textExpression trueExpression: trueExpression falseExpression: falseExpression [
	" 11.12 Conditional Operator "

	^ JSEConditionalExpressionNode new
		condition: textExpression;
		trueExpression: trueExpression;
		falseExpression: falseExpression;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createConstStatement: variableDeclarations [
	^JSEConstStatementNode new
		variableDeclarations: variableDeclarations;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createContinue: identifierOrNil [
	" 12.7 The continue Statement "

	^ JSEContinueNode new identifier: identifierOrNil;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createDebugger [
	" 12.15 The debugger statement "

	^ JSEDebuggerNode new]

{ #category : #statements }
JSESyntaxTreeFactory >> createDo: statement whileExpression: whileExpression [
	" 12.6.1 The do-while Statement "

	^ JSEDoWhileNode new
		condition: whileExpression;
		statement: statement;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createEmptyStatement [
	" 12.3 Empty Statement "

	^ JSEEmptyStatementNode new]

{ #category : #expressions }
JSESyntaxTreeFactory >> createEqualityExpression: expression1 with: expression2 operator: operatorString [
	" 11.9 Equality Operators "

	^ JSEBinaryOperatorNode new
		leftExpression: expression1;
		rightExpression: expression2;
		operator: operatorString asSymbol;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createExpressionStatement: expression [
	" 12.4 Expression Statement "

	^ JSEExpressionStatementNode new expression: expression;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createFinally: finallyBlock [
	" 12.14 The try Statement "

	^ JSEFinallyNode new block: finallyBlock; yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createFor: initializationExpression condition: conditionExpression update: updateExpression do: statement [
	" 12.6.3 The for Statement "

	^ JSEForWithInitializerNode new
		initializer: initializationExpression;
		condition: conditionExpression;
		updateExpression: updateExpression;
		statement: statement;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createFor: enumerableExpression in: collectionExpression do: statement [
	"
	12.6.3 The for Statement
	"
	^JSEForEnumerateElementsNode new
		enumerable: enumerableExpression;
		collection: collectionExpression;
		statement: statement;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createForLet: variableDeclaration in: collectionExpression do: statement [
	^JSEForEnumerateLetNode new
		variableDeclaration: variableDeclaration;
		collection: collectionExpression;
		statement: statement;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createForLetList: variableDeclarations
condition: conditionExpression
update: updateExpression
do: statement [
	^JSEForWithLetListNode new
		variableDeclarations: variableDeclarations;
		condition: conditionExpression;
		updateExpression: updateExpression;
		statement: statement;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createForVariable: variableDeclaration in: collectionExpression do: statement [
	^JSEForEnumerateVariableNode new
		variableDeclaration: variableDeclaration;
		collection: collectionExpression;
		statement: statement;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createForVariables: variableDeclarations
condition: conditionExpression
update: updateExpression
do: statement [
	^JSEForWithVariableListNode new
		variableDeclarations: variableDeclarations;
		condition: conditionExpression;
		updateExpression: updateExpression;
		statement: statement;
		yourself]

{ #category : #'functions and programs' }
JSESyntaxTreeFactory >> createFunctionBody: sourceElements [
	" 13 Function Definition "

	^ JSEFunctionBodyNode new 
		sourceElements: sourceElements;
		yourself]

{ #category : #'functions and programs' }
JSESyntaxTreeFactory >> createFunctionDeclaration: identifier parameters: formalParameters body: functionBody [
	" 13 Function Definition "

	^ JSEFunctionDeclarationNode new 
		identifier: identifier;
		formalParameters: formalParameters;
		functionBody: functionBody;
		yourself]

{ #category : #'functions and programs' }
JSESyntaxTreeFactory >> createFunctionExpression: identifierOrNil parameters: formalParameters body: functionBody [
	" 13 Function Definition "

	^ JSEFunctionExpressionNode new 
		identifier: identifierOrNil;
		formalParameters: formalParameters;
		functionBody: functionBody;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createGroupedExpression: expression [
	" 11.1.6 The Grouping Operator "

	^ JSEGroupedExpressionNode new
		expression: expression;
		yourself]

{ #category : #'lexical elements' }
JSESyntaxTreeFactory >> createIdentifier: token [
	" 7.5 Tokens "

	^ JSEIdentifierNode fromToken: token]

{ #category : #'lexical elements' }
JSESyntaxTreeFactory >> createIdentifierName: token [
	" 7.5 Tokens "

	^ JSEIdentifierNameNode fromToken: token]

{ #category : #statements }
JSESyntaxTreeFactory >> createIf: textExpression trueExpression: trueExpression falseExpression: falseExpressionOrNil [
	" 12.5 The if Statement "

	^ JSEIfNode new
		condition: textExpression;
		trueExpression: trueExpression;
		falseExpression: falseExpressionOrNil;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createLabel: labelIdentifier statement: statement [
	" 12.12 Labelled Statements "

	^ JSELabelledStatementNode new
		label: labelIdentifier;
		statement: statement;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createLetDeclaration: identifier initializer: initializerOrNil [
	^JSELetDeclarationNode new
		identifier: identifier;
		initializer: initializerOrNil;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createLetStatement: variableDeclarations [
	^JSELetStatementNode new
		variableDeclarations: variableDeclarations;
		yourself]

{ #category : #'lexical elements' }
JSESyntaxTreeFactory >> createLiteralBoolean: token [
	"
	7.8 Literals
	"
	^JSEBooleanNode fromToken: token]

{ #category : #'lexical elements' }
JSESyntaxTreeFactory >> createLiteralNull: token [
	"
	7.8 Literals
	"
	^JSENullNode fromToken: token]

{ #category : #'lexical elements' }
JSESyntaxTreeFactory >> createLiteralNumeric: token [
	"
	7.8 Literals
	"
	^JSENumericNode fromToken: token]

{ #category : #'lexical elements' }
JSESyntaxTreeFactory >> createLiteralString: token [
	"
	7.8 Literals
	"
	^JSEStringNode fromToken: token]

{ #category : #expressions }
JSESyntaxTreeFactory >> createLogicalExpression: expression1 with: expression2 operator: operatorString [
	" 11.11 Binary Logical Operators "

	^ JSEBinaryOperatorNode new
		leftExpression: expression1;
		rightExpression: expression2;
		operator: operatorString asSymbol;
		yourself]

{ #category : #'lexical elements' }
JSESyntaxTreeFactory >> createMacro: token [
	^JSEMacroNode fromToken: token]

{ #category : #expressions }
JSESyntaxTreeFactory >> createMemberOf: baseExpression bracket: bracketExpression [
	" 11.2 Left-Hand-Side Expressions "

	^JSEBracketMemberNode new
		base: baseExpression;
		member: bracketExpression;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createMemberOf: baseExpression dot: dotExpression [
	"
	11.2 Left-Hand-Side Expressions
	"
	^JSEDotMemberNode new
		base: baseExpression;
		member: dotExpression;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createMultiplicativeExpression: expression1 with: expression2 operator: operatorString [
	" 11.5 Multiplicative Operators "

	^ JSEBinaryOperatorNode new
		leftExpression: expression1;
		rightExpression: expression2;
		operator: operatorString asSymbol;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createNew: newExpression arguments: argumentsOrNil [
	" 11.2 Left-Hand-Side Expressions "

	^ JSENewNode new
		member: newExpression;
		arguments: argumentsOrNil;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createObject: propertyAssignmentList [
	"
	11.1.5 Object Initialiser
	"
	^JSEObjectNode new propertyAssignments: propertyAssignmentList; yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createPostfixExpression: expression operator: postfixOperatorString [
	" 11.3 Postfix Expressions "

	^ JSEPostfixOperatorNode new
		expression: expression;
		operator: postfixOperatorString asSymbol;
		yourself]

{ #category : #'functions and programs' }
JSESyntaxTreeFactory >> createProgram: sourceElements [
	"
	14 Program
	"
	| p |
	p := JSEProgramNode new.
	sourceElements notNil ifTrue: [p sourceElements: sourceElements].
	^p]

{ #category : #expressions }
JSESyntaxTreeFactory >> createPropertyAssignment: propertyName expression: assignedExpression [
	"
	11.1.5 Object Initialiser
	"
	^JSEPropertyAssignmentNode new
		propertyName: propertyName;
		expression: assignedExpression;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createPropertyGetAssignment: propertyName functionBody: functionBody [
	" 11.1.5 Object Initialiser "

	^ JSEGetPropertyAssignmentNode new
		propertyName: propertyName;
		functionBody: functionBody;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createPropertySetAssignment: propertyName parameter: parameter functionBody: functionBody [
	" 11.1.5 Object Initialiser "

	^ JSESetPropertyAssignmentNode new
		propertyName: propertyName;
		parameter: parameter;
		functionBody: functionBody;
		yourself]

{ #category : #'lexical elements' }
JSESyntaxTreeFactory >> createRegularExpression: regexToken [
	"
	15.10 RegExp (Regular Expression) Objects
	"
	^JSERegularExpressionNode new
		regularExpression: regexToken literalValue;
		flags: regexToken flags;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createRelationalExpression: expression1 with: expression2 operator: operatorString [
	" 11.8 Relational Operators "

	^ JSEBinaryOperatorNode new
		leftExpression: expression1;
		rightExpression: expression2;
		operator: operatorString asSymbol;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createReturn: returnExpressionOrNil [
	" 12.9 The return Statement "

	^ JSEReturnNode new
		return: returnExpressionOrNil;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createShiftExpression: expression1 with: expression2 operator: operatorString [
	" 11.7 Bitwise Shift Operators "

	^ JSEBinaryOperatorNode new
		leftExpression: expression1;
		rightExpression: expression2;
		operator: operatorString asSymbol;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createSwitch: switchExpression clauses: clauses [
	" 12.11 The switch Statement "

	^ JSESwitchNode new
		switch: switchExpression;
		clauses: clauses;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createSwitchClause: clauseExpression statements: statements [
	" 12.11 The switch Statement "

	^ JSESwitchClause new
		clause: clauseExpression;
		statements: statements;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createSwitchDefaultClause: statements [
	" 12.11 The switch Statement "

	^ JSESwitchDefaultClause new
		statements: statements;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createThisExpression [
	" 11.1.1 The this Keyword "

	^ JSEThisNode new]

{ #category : #statements }
JSESyntaxTreeFactory >> createThrow: throwExpression [
	" 12.13 The throw Statement "

	^ JSEThrowNode new
		throwExpression: throwExpression
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createTry: tryBlock catch: catchStatementOrNil finally: finallyStatementOrNil [
	" 12.14 The try Statement "

	^ JSETryNode new
		tryBlock: tryBlock;
		catch: catchStatementOrNil;
		finally: finallyStatementOrNil;
		yourself]

{ #category : #expressions }
JSESyntaxTreeFactory >> createUnaryExpression: expression operator: unaryOperatorString [
	" 11.4 Unary Operators "

	^ JSEUnaryOperatorNode new
		expression: expression;
		operator: unaryOperatorString asSymbol;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createVariableDeclaration: identifier initializer: initializerOrNil [
	^JSEVariableDeclarationNode new
		identifier: identifier;
		initializer: initializerOrNil;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createVariableStatement: variableDeclarations [
	^JSEVariableStatementNode new
		variableDeclarations: variableDeclarations;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createWhile: expression statement: statement [
	" 12.6.2 The while Statement "

	^ JSEWhileNode new
		condition: expression;
		statement: statement;
		yourself]

{ #category : #statements }
JSESyntaxTreeFactory >> createWith: withExpression statement: statement [
	" 12.10 The with Statement "

	^JSEWithNode new
		withExpression: withExpression; 
		statement: statement;
		yourself]

