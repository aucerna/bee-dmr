"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #NormalizedIncompleteBetaFunction,
	#superclass : #Object,
	#instVars : [
		'epsilon',
		'iterations',
		'a',
		'b'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
NormalizedIncompleteBetaFunction class >> a: a b: b [
	^self new a: a b: b]

{ #category : #'instance creation' }
NormalizedIncompleteBetaFunction class >> new [
	^super new initialize]

{ #category : #accessing }
NormalizedIncompleteBetaFunction >> a: aNumber b: anotherNumber [
	a := aNumber.
	b := anotherNumber]

{ #category : #'computational methods' }
NormalizedIncompleteBetaFunction >> arcSinDistributionAt: x [
	^x sqrt arcSin / (Float pi / 2.0)]

{ #category : #private }
NormalizedIncompleteBetaFunction >> argumentsFor: x [
	| args |
	args := IncompleteBetaArguments a: a b: b x: x.
	^args epsilon: epsilon; iterations: iterations]

{ #category : #private }
NormalizedIncompleteBetaFunction >> at: x complementary: aBoolean [
	| args |
	args := self argumentsFor: x.
	args
		invert: aBoolean;
		epsilon: epsilon;
		iterations: iterations.
	^args valueFor: self]

{ #category : #evaluating }
NormalizedIncompleteBetaFunction >> complementaryAt: x [
	^self at: x complementary: true]

{ #category : #'computational methods' }
NormalizedIncompleteBetaFunction >> complementaryBinomial: n k: k x: x [
	| result term y max |
	result := x raisedTo: n.
	term := result.
	y := 1 - x.
	max := n - 1.
	max to: k + 1 by: -1 do: [:i | 
		term := i + 1 * y / (n - i * x) * term.
		result := result + term].
	^result]

{ #category : #'probability functions' }
NormalizedIncompleteBetaFunction >> density: x [
	| args |
	args := self argumentsFor: x.
	^args density]

{ #category : #accessing }
NormalizedIncompleteBetaFunction >> epsilon: aNumber [
	epsilon := aNumber asFloat]

{ #category : #evaluating }
NormalizedIncompleteBetaFunction >> evaluateWith: x [
	^self valueAt: x]

{ #category : #'computational methods' }
NormalizedIncompleteBetaFunction >> extremeDistributionAt: x [
	^x]

{ #category : #'computational methods' }
NormalizedIncompleteBetaFunction >> fraction: args [
	| terms fraction |
	terms := args powerTerms.
	fraction := IncompleteBetaContinuedFraction args: args.
	fraction epsilon: epsilon; iterations: iterations.
	^terms / fraction value]

{ #category : #initialization }
NormalizedIncompleteBetaFunction >> initialize [
	super initialize.
	epsilon := 1.0e-10.
	iterations := 1000]

{ #category : #accessing }
NormalizedIncompleteBetaFunction >> iterations: anInteger [
	iterations := anInteger asInteger]

{ #category : #'computational methods' }
NormalizedIncompleteBetaFunction >> smallB: args steps: n [
	| fract copy computed |
	fract := args steps: n.
	args invert ifTrue: [fract := fract - 1].
	copy := args copy a: args a + n.
	computed := self smallBSeries: copy prefix: 1 fract: fract.
	^args invert
		ifTrue: [
			args invert: false.
			computed negated]
		ifFalse: [computed]]

{ #category : #'computational methods' }
NormalizedIncompleteBetaFunction >> smallBLargeA: args [
	| n copy fract |
	n := args b floor.
	n = args b ifTrue: [n := n - 1].
	copy := args copy b: args b - n.
	fract := copy copy swap steps: n.
	^self smallBSeries: copy prefix: 1 fract: fract]

{ #category : #'computational methods' }
NormalizedIncompleteBetaFunction >> smallBSeries: args prefix: mult fract: s0 [
	| series |
	series := IncompleteBetaSeriesSmallB
		epsilon: epsilon
		iterations: iterations.
	series
		args: args;
		mult: mult;
		s0: s0.
	^series value]

{ #category : #'computational methods' }
NormalizedIncompleteBetaFunction >> uniformDistributionAt: x [
	^x]

{ #category : #'computational methods' }
NormalizedIncompleteBetaFunction >> usingBinomial: args [
	"
	NormalizedIncompleteBetaFunction new usingBinomial: (IncompleteBetaArguments a: 20 b: 30 x: 2/5 asFloat)
	0.50770019965765
	"
	| k n |
	k := args a - 1.
	n := args b + k.
	^self complementaryBinomial: n k: k x: args x]

{ #category : #evaluating }
NormalizedIncompleteBetaFunction >> valueAt: x [
	^self at: x complementary: false]

