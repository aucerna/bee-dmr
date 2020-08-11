"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #IntegerTest }

{ #category : '*NumericalMethods\Tests' }
IntegerTest >> testIsPrime [
	| primes divisible |
	primes := #(2 3 5 7 11 101 103 107 251 257 263 269 10000019).
	divisible := #(4 8 128 255 256 10000001 ).
	primes do: [:p | self assert: p isPrime].
	divisible do: [:d | self deny: d isPrime]]

