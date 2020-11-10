"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlSummationTerm,
	#superclass : #Object,
	#instVars : [
		'sign',
		'term'
	],
	#category : #FML
}

{ #category : #'instance creation' }
FmlSummationTerm class >> with: anFmlExpression [
	^self new sign: #'+'; term: anFmlExpression]

{ #category : #accessing }
FmlSummationTerm >> , aCollection [
	^aCollection class == self
		ifTrue: [{self. aCollection}]
		ifFalse: [Array with: self withAll: aCollection]]

{ #category : #converting }
FmlSummationTerm >> asFmlExpression [
	^sign = #'-'
		ifTrue: [FmlBinaryExpression left: -1 operator: #'*' right: term]
		ifFalse: [term]]

{ #category : #grammar }
FmlSummationTerm >> factors [
	^term factors]

{ #category : #private }
FmlSummationTerm >> from: anFmlBinaryExpression [
	]

{ #category : #testing }
FmlSummationTerm >> hasFactor: anFmlExpression [
	^self factors includes: anFmlExpression]

{ #category : #testing }
FmlSummationTerm >> isLike: anFmlSummationTerm [
	self class == anFmlSummationTerm class ifFalse: [^false].
	sign = anFmlSummationTerm sign ifFalse: [^false].
	^term isLike: anFmlSummationTerm term]

{ #category : #arithmetic }
FmlSummationTerm >> multiplyAll: aCollection [
	| product |
	aCollection isEmpty ifTrue: [^1 asFmlValue].
	product := aCollection first.
	aCollection allButFirst
		do: [:f | product := FmlBinaryExpression
			left: product
			operator: #'*'
			right: f].
	^product]

{ #category : #arithmetic }
FmlSummationTerm >> negated [
	sign := sign == #'-' ifTrue: [#'+'] ifFalse: [#'-']]

{ #category : #printing }
FmlSummationTerm >> printOn: aStream [
	aStream
		nextPutAll: sign asString;
		nextPut: $(;
		nextPutAll: term asString;
		nextPut: $)]

{ #category : #printing }
FmlSummationTerm >> printTextOn: rtf [
	rtf nextPutAll: sign asString; nextPut: $(.
	term printTextOn: rtf.
	rtf nextPut: $)]

{ #category : #accessing }
FmlSummationTerm >> removeFactor: anFmlExpression [
	| factors product |
	factors := self factors asOrderedCollection.
	factors remove: anFmlExpression.
	product := self multiplyAll: factors.
	^self class new sign: sign; term: product]

{ #category : #accessing }
FmlSummationTerm >> sign [
	^sign]

{ #category : #accessing }
FmlSummationTerm >> sign: aSymbol [
	sign := aSymbol]

{ #category : #arithmetic }
FmlSummationTerm >> sumWith: anFmlExpression [
	| t s |
	t := term.
	s := sign.
	t isBinaryExpression ifTrue: [
		t left = -1 asFmlValue
			ifTrue: [
				t := t right.
				s := s == #'+' ifTrue: [#'-'] ifFalse: [#'+']]
			ifFalse: [
				term right = -1 asFmlValue ifTrue: [
					t := t left.
					s := s == #'+' ifTrue: [#'-'] ifFalse: [#'+']]]].
	^FmlBinaryExpression left: anFmlExpression operator: s right: t]

{ #category : #accessing }
FmlSummationTerm >> term [
	^term]

{ #category : #accessing }
FmlSummationTerm >> term: anFmlExpression [
	term := anFmlExpression]

