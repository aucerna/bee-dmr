"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SmallIncompleteBetaArguments,
	#superclass : #IncompleteBetaArguments,
	#category : #NumericalMethods
}

{ #category : #evaluating }
SmallIncompleteBetaArguments >> computedValueFor: aNormalizedIncompleteBetaFunction [
	x > 0.5 ifTrue: [self swap].
	(0.2 min: b) <= a ifTrue: [^self series].
	(x raisedTo: a) <= 0.9 ifTrue: [^self series].
	self swap.
	y >= 0.3 ifTrue: [^self series].
	^aNormalizedIncompleteBetaFunction smallB: self steps: 20]

