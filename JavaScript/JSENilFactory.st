"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSENilFactory,
	#superclass : #JSEParsedNodesFactory,
	#category : #JavaScript
}

{ #category : #expressions }
JSENilFactory >> createAdditiveExpression: expression1 with: expression2 operator: operatorString [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createArguments: arguments [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createArray: elements padBefore: head after: tail [
	^nil]

{ #category : #expressions }
JSENilFactory >> createAssignmentExpression: leftHandSideExpression to: assignedExpression operator: operatorString [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createBitwiseExpression: expression1 with: expression2 operator: operatorString [

	^ nil]

{ #category : #statements }
JSENilFactory >> createBlock: statementList [

	^ nil]

{ #category : #statements }
JSENilFactory >> createBreak: identifierOrNil [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createCall: memberExpression arguments: arguments [

	^ nil]

{ #category : #statements }
JSENilFactory >> createCatch: identifier block: catchBlock [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createCommaSeparatedExpression: expression1 with: expression2 [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createConditionalExpression: textExpression trueExpression: trueExpression falseExpression: falseExpression [
	
	^ nil]

{ #category : #statements }
JSENilFactory >> createConstStatement: variableDeclarations [
	^nil]

{ #category : #statements }
JSENilFactory >> createContinue: identifierOrNil [
	
	^ nil]

{ #category : #statements }
JSENilFactory >> createDebugger [

	^ nil]

{ #category : #statements }
JSENilFactory >> createDo: statement whileExpression: whileExpression [

	^ nil]

{ #category : #statements }
JSENilFactory >> createEmptyStatement [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createEqualityExpression: expression1 with: expression2 operator: operatorString [

	^ nil]

{ #category : #statements }
JSENilFactory >> createExpressionStatement: expression [

	^ nil]

{ #category : #statements }
JSENilFactory >> createFinally: finallyBlock [

	^ nil]

{ #category : #statements }
JSENilFactory >> createFor: initializationExpression condition: conditionExpression update: updateExpression do: statement [

	^ nil]

{ #category : #statements }
JSENilFactory >> createFor: enumerableExpression in: collectionExpression do: statement [

	^ nil]

{ #category : #statements }
JSENilFactory >> createForLet: variableDeclaration in: collectionExpression do: statement [
	^nil]

{ #category : #statements }
JSENilFactory >> createForLetList: variableDeclarationList
condition: conditionExpression
update: updateExpression
do: statement [
	^nil]

{ #category : #statements }
JSENilFactory >> createForVariable: variableDeclaration in: collectionExpression do: statement [
	^nil]

{ #category : #statements }
JSENilFactory >> createForVariables: variableDeclarationList
condition: conditionExpression
update: updateExpression
do: statement [
	^nil]

{ #category : #'functions and programs' }
JSENilFactory >> createFunctionBody: sourceElements [
	
	^ nil]

{ #category : #'functions and programs' }
JSENilFactory >> createFunctionDeclaration: identifier parameters: formalParameters body: functionBody [

	^ nil]

{ #category : #'functions and programs' }
JSENilFactory >> createFunctionExpression: identifierOrNil parameters: formalParameters body: functionBody [
	
	^ nil]

{ #category : #expressions }
JSENilFactory >> createGroupedExpression: expression [

	^ nil]

{ #category : #'lexical elements' }
JSENilFactory >> createIdentifier: token [

	^ nil]

{ #category : #'lexical elements' }
JSENilFactory >> createIdentifierName: token [

	^ nil]

{ #category : #statements }
JSENilFactory >> createIf: textExpression trueExpression: trueExpression falseExpression: falseExpressionOrNil [

	^ nil]

{ #category : #statements }
JSENilFactory >> createLabel: labelIdentifier statement: statement [

	^ nil]

{ #category : #statements }
JSENilFactory >> createLetDeclaration: identifier initializer: initializerOrNil [
	^nil]

{ #category : #statements }
JSENilFactory >> createLetStatement: variableDeclarations [
	^nil]

{ #category : #'lexical elements' }
JSENilFactory >> createLiteralBoolean: token [
	^nil]

{ #category : #'lexical elements' }
JSENilFactory >> createLiteralNull: token [
	^nil]

{ #category : #'lexical elements' }
JSENilFactory >> createLiteralNumeric: token [
	^nil]

{ #category : #'lexical elements' }
JSENilFactory >> createLiteralString: token [
	^nil]

{ #category : #expressions }
JSENilFactory >> createLogicalExpression: expression1 with: expression2 operator: operatorString [

	^ nil]

{ #category : #'lexical elements' }
JSENilFactory >> createMacro: token [
	^nil]

{ #category : #expressions }
JSENilFactory >> createMemberOf: baseExpression bracket: bracketExpression [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createMemberOf: baseExpression dot: dotExpression [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createMultiplicativeExpression: expression1 with: expression2 operator: operatorString [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createNew: newExpression arguments: argumentsOrNil [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createObject: propertyAssignmentList [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createPostfixExpression: expression operator: postfixOperatorString [
	
	^ nil]

{ #category : #'functions and programs' }
JSENilFactory >> createProgram: sourceElements [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createPropertyAssignment: propertyName expression: assignedExpression [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createPropertyGetAssignment: propertyName functionBody: functionBody [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createPropertySetAssignment: propertyName parameter: parameter functionBody: functionBody [

	^ nil]

{ #category : #'lexical elements' }
JSENilFactory >> createRegularExpression: regexToken [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createRelationalExpression: expression1 with: expression2 operator: operatorString [

	^ nil]

{ #category : #statements }
JSENilFactory >> createReturn: returnExpressionOrNil [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createShiftExpression: expression1 with: expression2 operator: operatorString [

	^ nil]

{ #category : #statements }
JSENilFactory >> createSwitch: switchExpression clauses: clauses [

	^ nil]

{ #category : #statements }
JSENilFactory >> createSwitchClause: clauseExpression statements: statements [

	^ nil]

{ #category : #statements }
JSENilFactory >> createSwitchDefaultClause: statements [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createThisExpression [

	^ nil]

{ #category : #statements }
JSENilFactory >> createThrow: throwExpression [
	
	^ nil]

{ #category : #statements }
JSENilFactory >> createTry: tryBlock catch: catchStatementOrNil finally: finallyStatementOrNil [

	^ nil]

{ #category : #expressions }
JSENilFactory >> createUnaryExpression: expression operator: unaryOperatorString [

	^ nil]

{ #category : #statements }
JSENilFactory >> createVariableDeclaration: identifier initializer: initializerOrNil [
	^nil]

{ #category : #statements }
JSENilFactory >> createVariableStatement: variableDeclarations [
	^nil]

{ #category : #statements }
JSENilFactory >> createWhile: expression statement: statement [
	
	^ nil]

{ #category : #statements }
JSENilFactory >> createWith: withExpression statement: statement [

	^ nil]

