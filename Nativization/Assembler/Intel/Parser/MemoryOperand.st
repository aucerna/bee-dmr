Extension { #name : #MemoryOperand }

{ #category : '*Parser' }
MemoryOperand class >> fromStream: aStream [
	| memory |
	memory := AssemblerParser new memory parse: aStream.
	memory isPetitFailure
		ifTrue: [self error: 'invalid operand: ' , memory message].
	^memory
]

