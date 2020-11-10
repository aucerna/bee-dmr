"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlRecursionTypeCalculator,
	#superclass : #FmlVisitor,
	#instVars : [
		'prefix',
		'root',
		'type',
		'trace',
		'visited'
	],
	#category : #FML
}

{ #category : #'instance creation' }
FmlRecursionTypeCalculator class >> new [
	^super new initialize]

{ #category : #testing }
FmlRecursionTypeCalculator >> goesInsideVariables [
	^type ~~ #recursive]

{ #category : #initialization }
FmlRecursionTypeCalculator >> initialize [
	super initialize.
	prefix := ''.
	trace := Stack new.
	visited := IdentityDictionary new]

{ #category : #testing }
FmlRecursionTypeCalculator >> needsNext [
	^prefix beginsWith: 'next']

{ #category : #testing }
FmlRecursionTypeCalculator >> needsPrev [
	^prefix beginsWith: 'prev']

{ #category : #private }
FmlRecursionTypeCalculator >> recursionType [
	(self needsNext and: [type isNil or: [type == #rightToLeftColumn]])
		ifTrue: [^#rightToLeftColumn].
	(self needsPrev and: [type isNil or: [type == #leftToRightColumn]])
		ifTrue: [^#leftToRightColumn].
	^#recursive]

{ #category : #accessing }
FmlRecursionTypeCalculator >> root: variable [
	root := variable.
	trace push: '(' , variable fullModelName , ')'.
	self visit: root fmlExpression]

{ #category : #accessing }
FmlRecursionTypeCalculator >> type [
	^type]

{ #category : #visiting }
FmlRecursionTypeCalculator >> visit: fmlNode [
	type == #recursive ifTrue: [^self].
	super visit: fmlNode]

{ #category : #visiting }
FmlRecursionTypeCalculator >> visitFunctionCall: anFmlFunctionCall [
	| name count current arg old opposite |
	name := anFmlFunctionCall name.
	count := 0.
	anFmlFunctionCall functionDefinition enforcesSingleResultType
		ifTrue: [current := 'all'].
	name = 'shiftLeft' ifTrue: [
		count := 1.
		current := 'next'].
	name = 'positionsLeft' ifTrue: [
		arg := anFmlFunctionCall arguments last.
		count := arg isNumber ifTrue: [arg value] ifFalse: [2].
		current := 'next'].
	(name = 'shiftRight' or: [name = 'previousValue']) ifTrue: [
		count := 1.
		current := 'prev'].
	name = 'positionsRight' ifTrue: [
		arg := anFmlFunctionCall arguments last.
		count := arg isNumber ifTrue: [arg value] ifFalse: [2].
		current := 'prev'].
	old := prefix.
	[
		current = 'all' ifTrue: [prefix := current] ifFalse: [
			opposite := current = 'next' ifTrue: ['prev'] ifFalse: ['next'].
			count timesRepeat: [
				prefix := (prefix endsWith: opposite)
					ifTrue: [prefix allButLast: opposite size]
					ifFalse: [prefix , current]]].
		super visitFunctionCall: anFmlFunctionCall]
		ensure: [prefix := old]]

{ #category : #visiting }
FmlRecursionTypeCalculator >> visitVariable: csrVariable [
	| prefixes key |
	trace push: prefix , '(' , csrVariable fullModelName , ')'.
	csrVariable definition == root definition
		ifTrue: [type := self recursionType].
	prefixes := visited at: csrVariable ifAbsentPut: [OrderedCollection new].
	key := prefix copyFrom: 1 to: (4 min: prefix size).
	(key beginsWith: 'all') ifTrue: [key := 'all'].
	(prefixes includes: key) ifFalse: [
		prefixes add: key.
		super visitVariable: csrVariable.
		(csrVariable hasFmlFunction or: [csrVariable isBindingVariable])
			ifFalse: [csrVariable allNeededVariables do: [:v | self visit: v]]].
	type == #recursive ifFalse: [trace pop]]

