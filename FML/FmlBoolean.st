"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlBoolean,
	#superclass : #FmlValue,
	#instVars : [
		'bool'
	],
	#category : #FML
}

{ #category : #testing }
FmlBoolean class >> supportsLogicalOperations [
	^true]

{ #category : #constants }
FmlBoolean class >> typeName [
	^'Boolean']

{ #category : #comparing }
FmlBoolean >> <= aFmlValue [
	^self = aFmlValue]

{ #category : #visiting }
FmlBoolean >> acceptVisitor: fmlVisitor [
	fmlVisitor visitFmlBoolean: self]

{ #category : #'logical operations' }
FmlBoolean >> and: aFmlValue [
	bool == false ifTrue: [^false asFmlValue].
	^(aFmlValue performOperation: #and: receiverValue: bool) asBoolean]

{ #category : #converting }
FmlBoolean >> asBoolean [
	^self]

{ #category : #converting }
FmlBoolean >> asInteger [
	^bool ifTrue: [1] ifFalse: [0]]

{ #category : #'gui support' }
FmlBoolean >> displayValue [
	^bool asString]

{ #category : #comparing }
FmlBoolean >> equals: anFmlValue [
	^anFmlValue performOperation: #'=' receiverValue: bool]

{ #category : #functions }
FmlBoolean >> if: trueExp with: falseExp [
	trueExp isTableValued = falseExp isTableValued ifFalse: [
		^InvalidArgumentType
			signal: 'Arguments ""ifTrue"" and ""ifFalse"" in ""if"" should be both (or none) tables'].
	^bool ifTrue: [trueExp] ifFalse: [falseExp]]

{ #category : #accessing }
FmlBoolean >> inferredUnit [
	^BooleanUnit defaultInstance]

{ #category : #private }
FmlBoolean >> invalidOperations [
	^#(#'-' #'*' #'/' #'//' #'+' #min: #max:)]

{ #category : #testing }
FmlBoolean >> isBoolean [
	^true]

{ #category : #testing }
FmlBoolean >> isLogical [
	^true]

{ #category : #testing }
FmlBoolean >> isMagicConstant [
	^false]

{ #category : #arithmetic }
FmlBoolean >> max: aFmlValue [
	^self cannotEvaluate: #max]

{ #category : #comparing }
FmlBoolean >> min: aFmlValue [
	^self cannotEvaluate: #min]

{ #category : #testing }
FmlBoolean >> negates: anFmlExpression [
	^anFmlExpression isBoolean andNot: [self = anFmlExpression]]

{ #category : #'logical operations' }
FmlBoolean >> not [
	"
	false asFmlValue not
	"
	^bool not asFmlValue]

{ #category : #'logical operations' }
FmlBoolean >> or: anFmlValue [
	bool == true ifTrue: [^true asFmlValue].
	^(anFmlValue performOperation: #or: receiverValue: bool) asBoolean]

{ #category : #private }
FmlBoolean >> performOperation: aSymbol receiverValue: aBoolean [
	(self invalidOperations includes: aSymbol)
		ifTrue: [^self invalidOperation: aSymbol].
	^super performOperation: aSymbol receiverValue: aBoolean]

{ #category : #accessing }
FmlBoolean >> value [
	^bool]

{ #category : #accessing }
FmlBoolean >> value: aBoolean [
	bool := aBoolean]

