Extension { #name : #LargePositiveInteger }

{ #category : '*Game' }
LargePositiveInteger >> bitCount [
	"
	Count the number of bits set to 1 in self
	"
	| bitCount |
	true ifTrue: [
		bitCount := 0.
		1
			to: self sizeInBytes
			do: [:i | bitCount := bitCount + (self at: i) bitCount].
		^bitCount].
	^super bitCount
]

{ #category : '*Game' }
LargePositiveInteger >> bitsDo: aBlock [
	| mask offset |
	1 to: self sizeInBytes do: [:iByte | 
		offset := iByte - 1 bitShift: 3.
		mask := self at: iByte.
		[mask = 0] whileFalse: [
			aBlock value: mask lowBit + offset.
			mask := mask bitAnd: mask - 1]]
]

