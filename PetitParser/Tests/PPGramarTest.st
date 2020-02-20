Class {
	#name : #PPGramarTest,
	#superclass : #TestCase,
	#category : #Tests
}

{ #category : #all }
PPGramarTest >> testArithmetic [
	| number term prod prim start |
	number := #digit asParser plus token trim
		==> [:token | token value asNumber].
	term := PPUnresolvedParser new.
	prod := PPUnresolvedParser new.
	prim := PPUnresolvedParser new.
	term
		def: prod , $+ asParser token trim , term
			==> [:nodes | nodes first + nodes last]
			/ prod.
	prod
		def: prim , $* asParser token trim , prod
			==> [:nodes | nodes first * nodes last]
			/ prim.
	prim
		def: $( asParser token trim , term , $) asParser token trim
			==> [:nodes | nodes second]
			/ number.
	start := term end.
	self
		assert: (start parse: '1 + 2 * 3') = 7;
		assert: (start parse: '(1 + 2) * 3') = 9
]

{ #category : #all }
PPGramarTest >> testInteger [
	| number |
	number := #digit asParser plus token trim
		==> [:token | token value asNumber].
	self assert: (number parse: '123') = 123
]

