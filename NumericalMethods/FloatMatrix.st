"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #FloatMatrix }

{ #category : '*NumericalMethods' }
FloatMatrix >> cholesky [
	^CholeskyDecompositionAlgorithm on: self]

