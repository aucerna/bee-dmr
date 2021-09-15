"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #AllocationZone,
	#superclass : #Object,
	#instVars : [
		'memory',
		'base',
		'nextFree',
		'limit',
		'spaces',
		'current',
		'emptySpaces',
		'occupancy',
		'spaceSize',
		'spaceSizeShift'
	],
	#category : #Kernel
}

{ #category : #services }
AllocationZone >> allocate: size [
	| oop |
	oop := self allocateIfPossible: size.
	oop _isSmallInteger ifTrue: [^oop].
	self error: 'not enough space'
]

{ #category : #services }
AllocationZone >> allocateIfPossible: size [
	| oop |
	oop := current allocateIfPossible: size.
	oop _isSmallInteger ifTrue: [^oop].
	self bumpSpace.
	oop := current allocateIfPossible: size.
	oop _isSmallInteger ifTrue: [^oop]
]

{ #category : #private }
AllocationZone >> assureEmptySpace [
	"
	the invariant to maintain is that always at the end of the empty
	space list there is a space ready to be used (committed). Anyone
	who takes or adds a space to the list has to send this message
	"
	| space |
	emptySpaces isEmpty ifTrue: [self createEmptySpace].
	space := emptySpaces last.
	space commitedLimit == space reservedLimit
		ifFalse: [space commit: space reservedSize * 2]
]

{ #category : #services }
AllocationZone >> assureFree: anInteger [
	current availableBytes < anInteger ifTrue: [self bumpSpace]
]

{ #category : #accessing }
AllocationZone >> base [
	^base
]

{ #category : #accessing }
AllocationZone >> base: anInteger [
	base := anInteger.
	nextFree := anInteger
]

{ #category : #private }
AllocationZone >> build [
	| max |
	max := self indexOfPointer: limit - 1.
	occupancy := Array new: max withAll: 0.
	spaces := CriticalArray new usePinnedAllocation; growTo: 1000.
	emptySpaces := CriticalArray new usePinnedAllocation; growTo: 20.
	current := memory eden.
	self assureEmptySpace; bumpSpace
]

{ #category : #private }
AllocationZone >> bumpSpace [
	"
	We first assign a new space, so that we don't get out of memory,
	then we assure leaving another empty one for the next call
	"
	current := self takeEmptySpace.
	self assureEmptySpace
]

{ #category : #private }
AllocationZone >> createEmptySpace [
	"
	Because we might be in GC, the space could be created in GC work space,
	which would cause the space to be released after GC is done. To assure it
	survives, we deep copy it it to our own zone. This method must only be
	called after assuring there is enough free space in our current space.
	"
	| start s end |
	nextFree == limit ifTrue: [self error: 'out of space'].
	start := nextFree.
	end := nextFree + spaceSize.
	nextFree := end + spaceSize.
	s := memory newSpace
		base: start;
		reservedLimit: end;
		name: 'Old'.
	spaces add: s.
	emptySpaces add: s.
	memory addSpace: s.
	^s
]

{ #category : #accessing }
AllocationZone >> currentSpace [
	^current
]

{ #category : #inquiries }
AllocationZone >> indexOfPointer: anInteger [
	^(anInteger - base _bitShiftRight: spaceSizeShift) + 1
]

{ #category : #private }
AllocationZone >> indexOfSpace: aGCSpace [
	^self indexOfPointer: aGCSpace base
]

{ #category : #initialization }
AllocationZone >> initialize [
	spaceSize := 256 kbytes // 2.
	spaceSizeShift := spaceSize highBit
]

{ #category : #accessing }
AllocationZone >> limit [
	^limit
]

{ #category : #accessing }
AllocationZone >> limit: anInteger [
	limit := anInteger
]

{ #category : #private }
AllocationZone >> markAsFull: aGCSpace [
	"
	We mark spaces as fully occupied so that
	the GC doesn't see them as ready to be freed.
	"
	| index |
	index := self indexOfSpace: aGCSpace.
	occupancy at: index put: spaceSize * 2
]

{ #category : #services }
AllocationZone >> markedDo: aBlock [
	spaces do: [:s | s markedDo: aBlock]
]

{ #category : #accessing }
AllocationZone >> memory: aMemory [
	memory := aMemory
]

{ #category : #services }
AllocationZone >> objectsDo: aBlock [
	spaces do: [:s | s objectsDo: aBlock]
]

{ #category : #private }
AllocationZone >> occupancy [
	^occupancy
]

{ #category : #private }
AllocationZone >> recycleSpace: aGCSpace [
	emptySpaces add: aGCSpace
]

{ #category : #private }
AllocationZone >> regionCount [
	^self indexOfPointer: nextFree - 1
]

{ #category : #updating }
AllocationZone >> regionIndexOf: object [
	| pointer |
	pointer := object _asPointer.
	pointer < base ifTrue: [^nil].
	pointer >= limit ifTrue: [^nil].
	^self indexOfPointer: pointer
]

{ #category : #initialization }
AllocationZone >> regionSize [
	^spaceSize
]

{ #category : #private }
AllocationZone >> releaseEvacuated: evacuated [
	emptySpaces do: [:s | self markAsFull: s].
	1 to: spaces size do: [:i | | space used recycle base size |
		space := spaces at: i.
		used := occupancy at: i.
		recycle := (evacuated at: i) > 0
			or: [used == 0 and: [space commitedSize > 0]].
		recycle ifTrue: [
			base := space base.
			size := space reservedSize.
			space
				nextFree: base;
				commitedLimit: base;
				softLimit: base.
			OS decommit: base * 2 size: size * 2 * 2.
			self recycleSpace: space]].
	self assureEmptySpace
]

{ #category : #services }
AllocationZone >> relocate: anInteger [
	base := base + anInteger.
	nextFree := nextFree + anInteger.
	limit := limit + anInteger
]

{ #category : #private }
AllocationZone >> resetOccupancy [
	occupancy atAllPut: 0.
	self markAsFull: current
]

{ #category : #services }
AllocationZone >> shallowCopyCommiting: object [
	| copy size space |
	copy := current shallowCopyCommiting: object.
	copy == nil ifFalse: [^copy].
	size := object _sizeInBytes.
	size > 100000 ifTrue: [
		space := memory createLargeSpace: size.
		^space shallowCopyCommiting: object].
	self bumpSpace.
	^current shallowCopyCommiting: object
]

{ #category : #inquiries }
AllocationZone >> size [
	^limit - base
]

{ #category : #initialization }
AllocationZone >> spaces [
	^spaces
]

{ #category : #private }
AllocationZone >> takeEmptySpace [
	| space |
	space := emptySpaces pop.
	self markAsFull: space.
	^space
]

{ #category : #services }
AllocationZone >> unmarkedDo: aBlock [
	spaces do: [:s | s unmarkedDo: aBlock]
]

{ #category : #updating }
AllocationZone >> updateRegionOccupancy: object [
	| index bytes |
	index := self regionIndexOf: object.
	index ifNil: [^self].
	bytes := occupancy at: index.
	occupancy at: index put: bytes + object _sizeInBytes
]

{ #category : #inquiries }
AllocationZone >> usedBytes [
	| count |
	count := 0.
	spaces do: [:s | count := count + s usedBytes].
	^count
]

