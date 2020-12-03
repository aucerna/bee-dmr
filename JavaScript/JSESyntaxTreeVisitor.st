"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSESyntaxTreeVisitor,
	#superclass : #Object,
	#category : #JavaScript
}

{ #category : #'instance creation' }
JSESyntaxTreeVisitor class >> new [

	^ self basicNew initialize]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptAssignment: anAssignmentNode [
	^self acceptNode: anAssignmentNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptBinaryOperator: aBinaryOperatorNode [
	^self acceptNode: aBinaryOperatorNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptBlock: anBlockNode [
	^self acceptNode: anBlockNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptBracketMember: aBracketMemberNode [
	^self acceptNode: aBracketMemberNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptBreak: aBreakNode [
	^self acceptNode: aBreakNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptCall: aBreakNode [
	^self acceptNode: aBreakNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptCatch: anCatchNode [
	^self acceptNode: anCatchNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptCommaSeparatedExpressions: aCommaSeparatedExpressionsNode [
	^self acceptNode: aCommaSeparatedExpressionsNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptConditionalExpression: aConditionalExpressionNode [
	^self acceptNode: aConditionalExpressionNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptConstStatement: aConstStatementNode [
	^self acceptNode: aConstStatementNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptContinue: aContinueNode [
	^self acceptNode: aContinueNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptDebugger: aDebuggerNode [
	^self acceptNode: aDebuggerNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptDotMember: aDotMemberNode [
	^self acceptNode: aDotMemberNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptDoWhile: aDoWhileNode [
	^self acceptNode: aDoWhileNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptEmptyStatement: anEmptyStatementNode [
	^self acceptNode: anEmptyStatementNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptExpressionStatement: anExpressionStatementNode [
	^self acceptNode: anExpressionStatementNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptFinally: aFinallyNode [
	^self acceptNode: aFinallyNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptForEnumerateElements: aForEnumerateElementsNode [
	^self acceptNode: aForEnumerateElementsNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptForEnumerateLet: aForEnumerateLetNode [
	^self acceptNode: aForEnumerateLetNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptForEnumerateVariable: aForEnumerateVariableNode [
	^self acceptNode: aForEnumerateVariableNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptForWithInitializer: anInitializedForNode [
	^self acceptNode: anInitializedForNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptForWithLetList: aForWithLetListNode [
	^self acceptNode: aForWithLetListNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptForWithVariableList: aForWithVariableListNode [
	^self acceptNode: aForWithVariableListNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptFunctionBody: aFunctionBodyNode [
	^self acceptNode: aFunctionBodyNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptFunctionCall: aFunctionCallNode [
	^self acceptCall: aFunctionCallNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptFunctionDeclaration: aFunctionDeclarationNode [
	^self acceptNode: aFunctionDeclarationNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptFunctionExpression: aFunctionExpressionNode [
	^self acceptNode: aFunctionExpressionNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptGetPropertyAssignment: aGetPropertyAssignmentNode [
	^self acceptNode: aGetPropertyAssignmentNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptGroupedExpression: aGroupedExpressionNode [
	^self acceptNode: aGroupedExpressionNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptIdentifier: anIdentifierNode [
	^self acceptNode: anIdentifierNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptIdentifierName: anIdentifierNameNode [
	^self acceptNode: anIdentifierNameNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptIf: anIfNode [
	^self acceptNode: anIfNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptLabelledStatement: aLabelledStatementNode [
	^self acceptNode: aLabelledStatementNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptLetDeclaration: aVariableDeclarationNode [
	^self acceptVariableDeclaration: aVariableDeclarationNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptLetStatement: aLetStatementNode [
	^self acceptNode: aLetStatementNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptLiteralArray: anArrayLiteralNode [
	^self acceptNode: anArrayLiteralNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptLiteralBoolean: anBooleanLiteralNode [
	^self acceptNode: anBooleanLiteralNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptLiteralNull: anNullLiteralNode [
	^self acceptNode: anNullLiteralNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptLiteralNumeric: anNumericLiteralNode [
	^self acceptNode: anNumericLiteralNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptLiteralObject: anObjectLiteralNode [
	^self acceptNode: anObjectLiteralNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptLiteralString: anStringLiteralNode [
	^self acceptNode: anStringLiteralNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptMacro: aMacroNode [
	^self acceptNode: aMacroNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptNew: aNewNode [
	^self acceptNode: aNewNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptNode: aNode [
	self visitChildrenOf: aNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptPostfixOperator: anPostfixOperatorNode [
	^self acceptNode: anPostfixOperatorNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptProgram: aProgramNode [
	^self acceptNode: aProgramNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptPropertyAssignment: anPropertyAssignmentNode [
	^self acceptNode: anPropertyAssignmentNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptRegularExpression: anRegularExpressionNode [
	^self acceptNode: anRegularExpressionNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptReturn: aReturnNode [
	^self acceptNode: aReturnNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptSetPropertyAssignment: aSetPropertyAssignmentNode [
	^self acceptNode: aSetPropertyAssignmentNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptSwitch: aSwitchNode [
	^self acceptNode: aSwitchNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptSwitchClause: aSwitchClauseNode [
	^self acceptNode: aSwitchClauseNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptSwitchDefaultClause: aSwitchDefaultClauseNode [
	^self acceptNode: aSwitchDefaultClauseNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptThis: aThisNode [
	^self acceptNode: aThisNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptThrow: aThrowNode [
	^self acceptNode: aThrowNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptTry: aTryNode [
	^self acceptNode: aTryNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptUnaryOperator: anUnaryOperatorNode [
	^self acceptNode: anUnaryOperatorNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptVariableDeclaration: aVariableDeclarationNode [
	^self acceptNode: aVariableDeclarationNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptVariableStatement: aVariableStatementNode [
	^self acceptNode: aVariableStatementNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptWhile: aWhileNode [
	^self acceptNode: aWhileNode]

{ #category : #'double dispatch' }
JSESyntaxTreeVisitor >> acceptWith: aWithNode [
	^self acceptNode: aWithNode]

{ #category : #visitor }
JSESyntaxTreeVisitor >> visit: aNode [
	^aNode acceptVisitor: self]

{ #category : #visitor }
JSESyntaxTreeVisitor >> visitChildrenOf: aNode [
	aNode childrenDo: [:node | self visit: node]]

