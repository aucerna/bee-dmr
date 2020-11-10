"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlFactorizationAlgorithm,
	#superclass : #Object,
	#instVars : [
		'expression',
		'terms',
		'factors',
		'ranking',
		'output'
	],
	#category : #FML
}

{ #category : #'instance creation' }
FmlFactorizationAlgorithm class >> on: anFmlExpression [
	^self new on: anFmlExpression]

{ #category : #computing }
FmlFactorizationAlgorithm >> canBeGrouped: node [
	^node isBinaryExpression
		and: [node terms conform: [:t | terms anySatisfy: [:u | u isLike: t]]]]

{ #category : #computing }
FmlFactorizationAlgorithm >> canGroupTerms [
	^self grouppingCandidates notEmpty]

{ #category : #testing }
FmlFactorizationAlgorithm >> canNormalizeSigns [
	^terms anySatisfy: [:t | self canNormalizeSignsOf: t]]

{ #category : #testing }
FmlFactorizationAlgorithm >> canNormalizeSignsOf: term [
	| e |
	e := term term.
	^e isBinaryExpression
		and: [e operator == #'*']
		and: [e arguments anySatisfy: [:a | self isNegative: a]]]

{ #category : #testing }
FmlFactorizationAlgorithm >> canRefactor [
	^ranking first value > 1]

{ #category : #testing }
FmlFactorizationAlgorithm >> canRemoveParens [
	output isBinaryExpression ifFalse: [^false].
	output operator == #'*' ifFalse: [^false].
	output right isBinaryExpression ifFalse: [^false].
	^output right operator == #'*']

{ #category : #testing }
FmlFactorizationAlgorithm >> canSimplify [
	^self canRefactor
		or: [self canRemoveParens]
		or: [self canNormalizeSigns]
		or: [self canGroupTerms]]

{ #category : #computing }
FmlFactorizationAlgorithm >> compute [
	output := expression.
	[
		self updateRanking.
		self canRefactor ifTrue: [self refactor].
		[self canRemoveParens] whileTrue: [self removeParens].
		self canNormalizeSigns ifTrue: [self normalizeSigns].
		self groupTerms] whileTrue.
	self recoverDivisions]

{ #category : #computing }
FmlFactorizationAlgorithm >> grouppingCandidates [
	^factors gather: [:array | array select: [:node | self canBeGrouped: node]]]

{ #category : #computing }
FmlFactorizationAlgorithm >> groupTerms [
	| candidates node term copy |
	candidates := self grouppingCandidates.
	candidates isEmpty ifTrue: [^false].
	node := candidates anyone.
	copy := terms asOrderedCollection.
	node terms do: [:t | | u |
		u := copy detect: [:v | v isLike: t].
		copy remove: u].
	node := FmlBinaryExpression left: 1 operator: #'*' right: node.
	term := FmlSummationTerm with: node.
	copy add: term.
	terms := copy asArray.
	factors := terms collect: #factors.
	^true]

{ #category : #accessing }
FmlFactorizationAlgorithm >> hasDivisions [
	expression do: [:node | (self isDivision: node) ifTrue: [^true]].
	^false]

{ #category : #testing }
FmlFactorizationAlgorithm >> isDivision: anFmlExpression [
	^anFmlExpression isBinaryExpression and: [anFmlExpression operator == #'/']]

{ #category : #testing }
FmlFactorizationAlgorithm >> isNegative: anFmlExpression [
	^anFmlExpression isLiteral
		and: [anFmlExpression value isNumber]
		and: [anFmlExpression value < 0]]

{ #category : #testing }
FmlFactorizationAlgorithm >> isReciprocal: anFmlExpression [
	^anFmlExpression isFunctionCall
		and: [anFmlExpression functionDefinition isReciprocalFunction]]

{ #category : #testing }
FmlFactorizationAlgorithm >> normalizeSigns [
	| neg |
	terms
		select: [:t | self canNormalizeSignsOf: t]
		thenDo: [:t | self normalizeSignsOf: t].
	neg := terms conform: [:t | t sign = #'-'].
	neg ifTrue: [terms do: [:t | t negated]].
	output := self sumAll: terms.
	neg
		ifTrue: [output := FmlBinaryExpression
			left: -1
			operator: #'*'
			right: output]]

{ #category : #testing }
FmlFactorizationAlgorithm >> normalizeSignsOf: anFmlSummationTerm [
	| e left right sign |
	e := anFmlSummationTerm term.
	left := e left.
	right := e right.
	sign := 1.
	(self isNegative: left) ifTrue: [
		left := left value negated.
		sign := sign * -1].
	(self isNegative: right) ifTrue: [
		right := right value negated.
		sign := sign * -1].
	left = 1 ifTrue: [e := right].
	right = 1 ifTrue: [e := left].
	(left != 1 and: [right != 1])
		ifTrue: [e := FmlBinaryExpression
			left: left
			operator: e operator
			right: right].
	anFmlSummationTerm term: e.
	sign = -1 ifTrue: [anFmlSummationTerm negated]]

{ #category : #accessing }
FmlFactorizationAlgorithm >> on: anFmlBinaryExpression [
	expression := output := anFmlBinaryExpression.
	self replaceDivisions.
	terms := output terms.
	factors := terms collect: #factors]

{ #category : #accessing }
FmlFactorizationAlgorithm >> output [
	^output]

{ #category : #computing }
FmlFactorizationAlgorithm >> recoverDivisions [
	self hasDivisions ifFalse: [^self].
	output do: [:node | | op numerator denominator |
		(node isBinaryExpression and: [#(#* #/) includes: node operator])
			ifTrue: [
				op := node operator == #'/' ifTrue: [#'*'] ifFalse: [#'/'].
				(self isReciprocal: node right)
					ifTrue: [node operator: op; right: node right arguments first].
				(self isReciprocal: node left) ifTrue: [
					node operator == #'/'
						ifTrue: [
							numerator := 1 asFmlValue.
							denominator := node left arguments first dividedBy: node right]
						ifFalse: [
							numerator := node right.
							denominator := node left arguments first].
					node
						left: numerator;
						operator: #'/';
						right: denominator]]
			ifFalse: [
				node nodes
					select: [:n | self isReciprocal: n]
					thenDo: [:n | node
						replaceNode: n
						with: (1 asFmlValue dividedBy: n arguments first)]]]]

{ #category : #private }
FmlFactorizationAlgorithm >> refactor [
	| factor quo factorization rem |
	factor := ranking first key.
	quo := terms
		select: [:term | term hasFactor: factor]
		thenCollect: [:term | term removeFactor: factor].
	quo := self sumAll: quo.
	factorization := FmlBinaryExpression left: factor operator: #'*' right: quo.
	rem := terms reject: [:term | term hasFactor: factor].
	output := rem isEmpty ifTrue: [factorization] ifFalse: [
		rem := self sumAll: rem.
		FmlBinaryExpression left: factorization operator: #'+' right: rem]]

{ #category : #computing }
FmlFactorizationAlgorithm >> removeParens [
	| left |
	left := FmlBinaryExpression
		left: output left
		operator: #'*'
		right: output right left.
	output := FmlBinaryExpression
		left: left
		operator: #'*'
		right: output right right]

{ #category : #accessing }
FmlFactorizationAlgorithm >> replaceDivisions [
	self hasDivisions ifFalse: [^self].
	output := expression normalizedString asFmlExpression.
	output
		select: [:node | self isDivision: node]
		thenDo: [:node | node operator: #'*'; right: node right reciprocal]]

{ #category : #private }
FmlFactorizationAlgorithm >> sumAll: aCollection [
	| sum index |
	aCollection isEmpty ifTrue: [^0 asFmlValue].
	aCollection first sign == #'-' ifTrue: [
		index := aCollection findFirst: [:t | t sign == #'+'] ifAbsent: 0.
		index > 0 ifTrue: [aCollection swap: 1 with: index]].
	sum := aCollection first asFmlExpression.
	aCollection allButFirst
		do: [:t | sum := FmlBinaryExpression
			left: sum
			operator: t sign
			right: t term].
	^sum]

{ #category : #accessing }
FmlFactorizationAlgorithm >> updateRanking [
	| set |
	set := factors gather: #yourself in: Set new.
	ranking := OrderedCollection new.
	set do: [:f | | count |
		count := factors count: [:t | t includes: f].
		ranking add: f -> count].
	ranking sortBy: [:a :b | a value > b value]]

