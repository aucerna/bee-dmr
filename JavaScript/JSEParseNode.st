"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEParseNode,
	#superclass : #Object,
	#instVars : [
		'position',
		'end'
	],
	#category : #JavaScript
}

{ #category : #'instance creation' }
JSEParseNode class >> fromToken: aToken [
	^self new fromToken: aToken]

{ #category : #comparing }
JSEParseNode >> = aJSEParseNode [
	^self class = aJSEParseNode class and: [self format = aJSEParseNode format]]

{ #category : #visitor }
JSEParseNode >> acceptVisitor: aVisitor [
]

{ #category : #enumerating }
JSEParseNode >> allChildrenDo: aBlock [
	self childrenDo: [:n | 
		aBlock evaluateWith: n.
		n allChildrenDo: aBlock]]

{ #category : #accessing }
JSEParseNode >> bytecodes [
	^self]

{ #category : #accessing }
JSEParseNode >> children [
	| children |
	children := OrderedCollection new.
	self childrenDo: [:node | children add: node].
	^children]

{ #category : #enumerating }
JSEParseNode >> childrenDo: aBlock [
	1 to: self class instSize do: [:i | 
		(self instVarAt: i) ifNotNil: [:o | 
			(o isKindOf: JSEParseNode)
				ifTrue: [aBlock value: o]
				ifFalse: [(o isCollection and: [o isString not]) ifTrue: [o do: aBlock]]]]]

{ #category : #accessing }
JSEParseNode >> end [
	^end]

{ #category : #services }
JSEParseNode >> externalVariables [
	| variables |
	variables := Set new.
	self allChildrenDo: [:node | 
		node isMacroNode ifTrue: [variables add: node name] ifFalse: [
			(node isLiteral
				and: [node isRGBColor not]
				and: [node literalValue isString]
				and: [node literalValue beginsWith: '#'])
				ifTrue: [variables add: node literalValue allButFirst]]].
	^variables]

{ #category : #services }
JSEParseNode >> findLiteral: anObject [
	self
		allChildrenDo: [:n | (n isLiteral and: [n literalValue = anObject])
			ifTrue: [^n stretch]].
	^nil]

{ #category : #accessing }
JSEParseNode >> format [
	^self asString]

{ #category : #accessing }
JSEParseNode >> fromToken: aToken [
	position := aToken start.
	end := aToken stop]

{ #category : #testing }
JSEParseNode >> isEmptyNode [
	^false]

{ #category : #testing }
JSEParseNode >> isIdentifier [
	^false]

{ #category : #testing }
JSEParseNode >> isLiteral [
	^false]

{ #category : #testing }
JSEParseNode >> isMacroNode [
	^false]

{ #category : #testing }
JSEParseNode >> isVariable [
	^false]

{ #category : #services }
JSEParseNode >> literals [
	^JSEEncodingVisitor new visit: self; literals]

{ #category : #accessing }
JSEParseNode >> position [
	^position]

{ #category : #printing }
JSEParseNode >> printOn: aStream [
	self printOn: aStream indent: 0]

{ #category : #printing }
JSEParseNode >> printOn: aStream indent: anInteger [
	| visitor |
	visitor := JSEPrintSourceVisitor on: aStream.
	visitor
		indent: anInteger;
		appendSemicolon: false;
		visit: self]

{ #category : #printing }
JSEParseNode >> printTextOn: rtf [
	self printTextOn: rtf indent: 0]

{ #category : #printing }
JSEParseNode >> printTextOn: rtf indent: anInteger [
	| visitor |
	visitor := JSEColorPrinterVisitor on: rtf.
	visitor
		appendSemicolon: false;
		indent: anInteger;
		visit: self]

{ #category : #printing }
JSEParseNode >> printTextOn: rtf indented: n appendSemicolon: aBoolean [
	| visitor |
	visitor := JSEColorPrinterVisitor on: rtf.
	visitor
		appendSemicolon: aBoolean;
		indent: n;
		visit: self]

{ #category : #services }
JSEParseNode >> selectors [
	^JSEEncodingVisitor new visit: self; selectors]

{ #category : #accessing }
JSEParseNode >> sourceInterval [
	^self stretch]

{ #category : #inquiries }
JSEParseNode >> stretch [
	^position thru: end]

{ #category : #services }
JSEParseNode >> variableNodeAt: index [
	self
		childrenDo: [:node | (node isIdentifier
			and: [node stretch includes: index])
			ifTrue: [^node]].
	^nil]

