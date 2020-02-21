Class {
	#name : #PESection,
	#superclass : #LogicalSection,
	#instVars : [
		'#pebuilder',
		'#header',
		'#segments'
	],
	#category : #PE
}

{ #category : #'instance creation' }
PESection class >> new [
	^super new initialize
]

{ #category : #'adding / removing' }
PESection >> addNewSegment [
	| segment |
	segment := LogicalSegment in: self.
	^segments add: segment
]

{ #category : #'adding / removing' }
PESection >> addNewSegmentNamed: name [
	| segment |
	segment := LogicalSegment in: self.
	segment name: name.
	^segments add: segment
]

{ #category : #assigning }
PESection >> assignAddresses [
	self
		baseVirtualAddress: self assignVirtualAddress;
		baseFileAddress: self assignFileAddress;
		updateSize
]

{ #category : #assigning }
PESection >> assignFileAddress [
	| base |
	(self hasPreferredFileAddress and: [
		base := self baseFileAddress.
		self fitsWithin: base])
		ifFalse: [
			base := pebuilder startOfSectionContents.
			[
				base := base alignedTo: pebuilder fileAlignment.
				self fitsInFileWithin: base]
				whileFalse: [base := pebuilder nextFreeFileChunkAfter: base]].
	^base
]

{ #category : #assigning }
PESection >> assignSegmentOffsets [
	| offset |
	offset := 0.
	segments do: [:segment | 
		segment offset ifNil: [segment offset: offset].
		offset := segment offset + segment size]
]

{ #category : #assigning }
PESection >> assignVirtualAddress [
	| base |
	(self hasPreferredRva and: [
		base := self baseVirtualAddress.
		self fitsWithin: base])
		ifFalse: [
			base := pebuilder startOfSectionContents.
			[
				base := base alignedTo: pebuilder sectionAlignment.
				self fitsWithin: base]
				whileFalse: [base := pebuilder nextFreeVirtualChunkAfter: base]].
	^base
]

{ #category : #accessing }
PESection >> baseFileAddress [
	^header PointerToRawData
]

{ #category : #accessing }
PESection >> baseFileAddress: anInteger [
	^header PointerToRawData: anInteger
]

{ #category : #accessing }
PESection >> baseVirtualAddress [
	^header VirtualAddress
]

{ #category : #accessing }
PESection >> baseVirtualAddress: anInteger [
	header VirtualAddress: anInteger
]

{ #category : #accessing }
PESection >> beInitializedData [
	header beInitializedData
]

{ #category : #accessing }
PESection >> beReadWrite [
	header beReadable; beWritable
]

{ #category : #accessing }
PESection >> beWritableCode [
	header
		beCode;
		beExecutable;
		beReadable;
		beWritable
]

{ #category : #accessing }
PESection >> builder: aPEBuilder [
	pebuilder := aPEBuilder
]

{ #category : #accessing }
PESection >> bytes: aByteArray [
	| segment |
	segment := segments isEmpty
		ifTrue: [self addNewSegment]
		ifFalse: [segments first].
	segment bytes: aByteArray
]

{ #category : #private }
PESection >> endFileAddress [
	^self baseFileAddress + self highestUsedOffset
]

{ #category : #private }
PESection >> endVirtualAddress [
	^self baseVirtualAddress + self highestUsedOffset
]

{ #category : #accessing }
PESection >> firstSegment [
	^segments first
]

{ #category : #testing }
PESection >> fitsInFileWithin: address [
	^(pebuilder anySectionOverlapsInFile: self at: address) not
]

{ #category : #testing }
PESection >> fitsWithin: address [
	^(pebuilder anySectionOverlaps: self at: address) not
]

{ #category : #parsing }
PESection >> fromStream: aStream [
	| saved bytes |
	header := IMAGE_SECTION_HEADER fromStream: aStream.
	saved := aStream position.
	aStream position: header PointerToRawData.
	bytes := ByteArray new: header SizeOfRawData.
	aStream getBytesFor: bytes.
	aStream position: saved.
	self bytes: bytes
]

{ #category : #testing }
PESection >> hasPreferredFileAddress [
	^self baseFileAddress != 0
]

{ #category : #testing }
PESection >> hasPreferredRva [
	^self baseVirtualAddress != 0
]

{ #category : #accessing }
PESection >> header [
	^header
]

{ #category : #accessing }
PESection >> header: anIMAGE_SECTION_HEADER [
	header := anIMAGE_SECTION_HEADER
]

{ #category : #accessing }
PESection >> highestUsedOffset [
	^segments
		inject: 0
		into: [:result :segment | result max: segment endOffset]
]

{ #category : #testing }
PESection >> includesFileAddress: address [
	| base |
	base := self baseFileAddress.
	^base <= address and: [address <= (base + self highestUsedOffset)]
]

{ #category : #testing }
PESection >> includesVirtualAddress: address [
	| base |
	base := self baseVirtualAddress.
	^base <= address and: [address <= (base + self highestUsedOffset)]
]

{ #category : #accessing }
PESection >> initialize [
	segments := OrderedCollection new
]

{ #category : #accessing }
PESection >> name [
	^header name
]

{ #category : #accessing }
PESection >> name: aString [
	header name: aString
]

{ #category : #accessing }
PESection >> offsetOf: aSegment [
	| next offset |
	offset := next := 0.
	segments detect: [:segment | 
		offset := segment offset ifNil: [next].
		next := next + segment size.
		segment = aSegment].
	^offset
]

{ #category : #testing }
PESection >> overlapsInFileWith: aPESection at: address [
	self = aPESection ifTrue: [^false].
	self hasPreferredFileAddress ifFalse: [^false].
	^segments
		anySatisfy: [:segment | segment
			overlapsInFileWithSection: aPESection
			at: address]
]

{ #category : #testing }
PESection >> overlapsWith: aPESection at: address [
	self = aPESection ifTrue: [^false].
	self hasPreferredRva ifFalse: [^false].
	^segments
		anySatisfy: [:segment | segment
			overlapsWithSection: aPESection
			at: address]
]

{ #category : #accessing }
PESection >> pebuilder [
	^pebuilder
]

{ #category : #accessing }
PESection >> pefile [
	^pebuilder pefile
]

{ #category : #printing }
PESection >> printOn: aStream [
	aStream nextPutAll: self name , ' PESection'
]

{ #category : #accessing }
PESection >> rawSectionSize [
	^header SizeOfRawData
]

{ #category : #services }
PESection >> rvaOf: offset [
	^self baseVirtualAddress + offset
]

{ #category : #accessing }
PESection >> sectionAlignment [
	^pebuilder sectionAlignment
]

{ #category : #accessing }
PESection >> segments [
	^segments
]

{ #category : #accessing }
PESection >> size: anInteger [
	| aligned |
	aligned := anInteger alignedTo: pebuilder fileAlignment.
	header VirtualSize: anInteger; SizeOfRawData: aligned
]

{ #category : #accessing }
PESection >> storeContentsOn: aStream [
	| last end base start |
	segments do: [:segment | segment storeContentsOn: aStream].
	last := self highestUsedOffset.
	base := self baseFileAddress.
	start := base + last + 1.
	end := base + self rawSectionSize.
	aStream position: base + last + 1.
	end - start timesRepeat: [aStream nextPut: 0]
]

{ #category : #private }
PESection >> updateSize [
	self size: self highestUsedOffset + 1
]

{ #category : #services }
PESection >> vaOf: offset [
	^pebuilder imageBase + self baseVirtualAddress + offset
]

{ #category : #accessing }
PESection >> wordSize [
	^pebuilder wordSize
]

