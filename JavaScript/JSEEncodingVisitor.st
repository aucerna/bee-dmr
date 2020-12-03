"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEEncodingVisitor,
	#superclass : #JSESyntaxTreeVisitor,
	#instVars : [
		'literals',
		'selectors'
	],
	#category : #JavaScript
}

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptBinaryOperator: aBinaryOperatorNode [
	self acceptOperator: aBinaryOperatorNode.
	super acceptBinaryOperator: aBinaryOperatorNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptBreak: aBreakNode [
	self addLiteral: #break.
	super acceptBreak: aBreakNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptConditionalExpression: aConditionalExpressionNode [
	self addLiteral: #'?'.
	super acceptConditionalExpression: aConditionalExpressionNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptContinue: aContinueNode [
	self addLiteral: #continue.
	super acceptContinue: aContinueNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptDotMember: aDotMemberNode [
	self acceptMember: aDotMemberNode.
	super acceptDotMember: aDotMemberNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptDoWhile: aDoWhileNode [
	self addLiteral: #do; addLiteral: #while.
	super acceptDoWhile: aDoWhileNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptEnumeratingForNode: aJSEEnumeratingForNode [
	self addLiteral: #for; addLiteral: #in]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptForEnumerateElements: aForEnumerateElementsNode [
	self acceptEnumeratingForNode: aForEnumerateElementsNode.
	super acceptForEnumerateElements: aForEnumerateElementsNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptForEnumerateLet: aForEnumerateLetNode [
	self acceptEnumeratingForNode: aForEnumerateLetNode.
	self addLiteral: #let.
	super acceptForEnumerateLet: aForEnumerateLetNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptForEnumerateVariable: aForEnumerateVariableNode [
	self acceptEnumeratingForNode: aForEnumerateVariableNode.
	self addLiteral: #var.
	super acceptForEnumerateVariable: aForEnumerateVariableNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptForWithInitializer: anInitializedForNode [
	self addLiteral: #for.
	super acceptForWithInitializer: anInitializedForNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptForWithLetList: aForWithLetListNode [
	self addLiteral: #for; addLiteral: #let.
	super acceptForWithLetList: aForWithLetListNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptForWithVariableList: aJSEForWithVariableListNode [
	self addLiteral: #for; addLiteral: #var.
	super acceptForWithVariableList: aJSEForWithVariableListNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptFunctionDeclaration: aFunctionDeclarationNode [
	self addLiteral: aFunctionDeclarationNode identifier name asSymbol.
	super acceptFunctionDeclaration: aFunctionDeclarationNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptGetPropertyAssignment: aGetPropertyAssignmentNode [
	self addLiteral: #get.
	super acceptGetPropertyAssignment: aGetPropertyAssignmentNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptIf: anIfNode [
	self addLiteral: #if.
	anIfNode falseExpression notNil ifTrue: [self addLiteral: #else].
	super acceptIf: anIfNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptLiteralNumeric: anNumericLiteralNode [
	self addLiteral: anNumericLiteralNode literalValue.
	super acceptLiteralNumeric: anNumericLiteralNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptLiteralString: anStringLiteralNode [
	self addLiteral: anStringLiteralNode literalValue.
	super acceptLiteralString: anStringLiteralNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptMember: aJSEMemberNode [
	| member |
	member := aJSEMemberNode member.
	member isLiteral
		ifTrue: [self addLiteral: member literalValue]
		ifFalse: [self addSelector: member name asSymbol].
	self acceptNode: aJSEMemberNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptNew: aNewNode [
	self addLiteral: #new.
	super acceptNew: aNewNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptOperator: aJSEOperatorNode [
	self addLiteral: aJSEOperatorNode operator]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptPostfixOperator: anPostfixOperatorNode [
	self acceptOperator: anPostfixOperatorNode.
	super acceptPostfixOperator: anPostfixOperatorNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptRegularExpression: anRegularExpressionNode [
	self addLiteral: '/' , anRegularExpressionNode regularExpression , '/'.
	super acceptRegularExpression: anRegularExpressionNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptReturn: aReturnNode [
	self addLiteral: #return.
	super acceptReturn: aReturnNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptSetPropertyAssignment: aSetPropertyAssignmentNode [
	self addLiteral: #set.
	super acceptSetPropertyAssignment: aSetPropertyAssignmentNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptSwitch: aSwitchNode [
	self addLiteral: #switch.
	super acceptSwitch: aSwitchNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptSwitchDefaultClause: aSwitchDefaultClauseNode [
	self addLiteral: 'default'.
	super acceptSwitchDefaultClause: aSwitchDefaultClauseNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptThis: aThisNode [
	self addLiteral: #this.
	super acceptThis: aThisNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptThrow: aThrowNode [
	self addLiteral: #throw.
	super acceptThrow: aThrowNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptTry: aTryNode [
	self addLiteral: #try.
	super acceptTry: aTryNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptUnaryOperator: anUnaryOperatorNode [
	self acceptOperator: anUnaryOperatorNode.
	super acceptUnaryOperator: anUnaryOperatorNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptWhile: aWhileNode [
	self addLiteral: #while.
	super acceptWhile: aWhileNode]

{ #category : #'double dispatch' }
JSEEncodingVisitor >> acceptWith: aWithNode [
	self addLiteral: #with.
	super acceptWith: aWithNode]

{ #category : #'adding / removing' }
JSEEncodingVisitor >> addLiteral: aSymbol [
	literals add: aSymbol]

{ #category : #'adding / removing' }
JSEEncodingVisitor >> addSelector: aSymbol [
	selectors add: aSymbol]

{ #category : #initialization }
JSEEncodingVisitor >> initialize [
	super initialize.
	literals := OrderedSet new.
	selectors := OrderedSet new]

{ #category : #accessing }
JSEEncodingVisitor >> literals [
	^literals]

{ #category : #accessing }
JSEEncodingVisitor >> selectors [
	^selectors]

