Class {
	#name : #TemplateAssembler64,
	#superclass : #JITAssembler64,
	#category : #JIT
}

{ #category : #arithmetic }
TemplateAssembler64 >> addAtoR [
	self assembleBytes: #[0x48 0x1 0xD0].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> addDoubleX1toX0 [
	self assembleBytes: #[0xF2 0xF 0x58 0xC1].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> addSPtoT [
	self assembleBytes: #[0x48 0x1 0xE1].
	
]

{ #category : #logic }
TemplateAssembler64 >> addSPwithImmediate: imm [
	(-128 <= imm and: [imm < 128])
		ifTrue: [^self assembleBytes: #[0x48 0x83 0xC4]; assembleByte: imm].
	
	(-0x80000000 <= imm and: [imm < 0x80000000])
		ifTrue: [
			^self
				assembleBytes: #[0x48 0x81 0xC4];
				assembleBytes: imm count: 4].
	self 
		assembleBytes: #[0x49 0xBB];
		assembleBytes: imm count: 8;
		saveLastEmittedPointer;
		assembleBytes: #[0x4C 0x1 0xDC]
]

{ #category : #arithmetic }
TemplateAssembler64 >> addSslotsToSP [
	self assembleBytes: #[0x48 0x8D 0x24 0xF4].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> addTslotsToSP [
	self assembleBytes: #[0x48 0x8D 0x24 0xCC].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> addTtoR [
	self assembleBytes: #[0x48 0x1 0xC8].
	
]

{ #category : #logic }
TemplateAssembler64 >> andRwithA [
	self assembleBytes: #[0x48 0x21 0xD0].
	
]

{ #category : #logic }
TemplateAssembler64 >> andRwithImmediate: imm [
	(-128 <= imm and: [imm < 128])
		ifTrue: [^self assembleBytes: #[0x48 0x83 0xE0]; assembleByte: imm].
	
	(-0x80000000 <= imm and: [imm < 0x80000000])
		ifTrue: [
			^self
				assembleBytes: #[0x48 0x25];
				assembleBytes: imm count: 4].
	self 
		assembleBytes: #[0x49 0xBB];
		assembleBytes: imm count: 8;
		saveLastEmittedPointer;
		assembleBytes: #[0x4C 0x21 0xD8]
]

{ #category : #logic }
TemplateAssembler64 >> andTosWithImmediate: imm [
	(-128 <= imm and: [imm < 128])
		ifTrue: [^self assembleBytes: #[0x48 0x83 0x24 0x24]; assembleByte: imm].
	
	(-0x80000000 <= imm and: [imm < 0x80000000])
		ifTrue: [
			^self
				assembleBytes: #[0x48 0x81 0x24 0x24];
				assembleBytes: imm count: 4].
	self 
		assembleBytes: #[0x49 0xBB];
		assembleBytes: imm count: 8;
		saveLastEmittedPointer;
		assembleBytes: #[0x4C 0x21 0x1C 0x24]
]

{ #category : #private }
TemplateAssembler64 >> buildFrame [
	self assembleBytes: #[0x55 0x48 0x89 0xE5].
	
]

{ #category : #private }
TemplateAssembler64 >> callA [
	self assembleBytes: #[0xFF 0xD2].
	
]

{ #category : #private }
TemplateAssembler64 >> callIndirectA [
	self assembleBytes: #[0xFF 0x12].
	
]

{ #category : #private }
TemplateAssembler64 >> callR [
	self assembleBytes: #[0xFF 0xD0].
	
]

{ #category : #integers }
TemplateAssembler64 >> clearAintegerBit [
	self assembleBytes: #[0x48 0xFF 0xCA].
	
]

{ #category : #loading }
TemplateAssembler64 >> clearFPUFlags [
	self assembleBytes: #[0xDB 0xE2].
	
]

{ #category : #integers }
TemplateAssembler64 >> clearRhighHalf [
	self assembleBytes: #[0x89 0xC0].
	
]

{ #category : #integers }
TemplateAssembler64 >> clearRintegerBit [
	self assembleBytes: #[0x48 0xFF 0xC8].
	
]

{ #category : #integers }
TemplateAssembler64 >> clearSafeRintegerBit [
	self assembleBytes: #[0x24 0xFE].
	
]

{ #category : #comparing }
TemplateAssembler64 >> compareAwithImmediate: imm [
	(-128 <= imm and: [imm < 128])
		ifTrue: [^self assembleBytes: #[0x48 0x83 0xFA]; assembleByte: imm].
	
	(-0x80000000 <= imm and: [imm < 0x80000000])
		ifTrue: [
			^self
				assembleBytes: #[0x48 0x81 0xFA];
				assembleBytes: imm count: 4].
	self 
		assembleBytes: #[0x49 0xBB];
		assembleBytes: imm count: 8;
		saveLastEmittedPointer;
		assembleBytes: #[0x4C 0x39 0xDA]
]

{ #category : #loading }
TemplateAssembler64 >> compareEqualLargeX0withAindirect [
	self assembleBytes: #[0xF2 0xF 0xC2 0x2 0x0].
	
]

{ #category : #loading }
TemplateAssembler64 >> compareLessThanLargeX0withAindirect [
	self assembleBytes: #[0xF2 0xF 0xC2 0x2 0x1].
	
]

{ #category : #comparing }
TemplateAssembler64 >> compareRwithA [
	self assembleBytes: #[0x48 0x39 0xD0].
	
]

{ #category : #loading }
TemplateAssembler64 >> compareRwithEindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x3B 0x7]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x3B 0x47];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x3B 0x87];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> compareRwithFPindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x3B 0x45 0x0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x3B 0x45];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x3B 0x85];
				assembleBytes: offset count: 4]
]

{ #category : #comparing }
TemplateAssembler64 >> compareRwithImmediate: imm [
	(-128 <= imm and: [imm < 128])
		ifTrue: [^self assembleBytes: #[0x48 0x83 0xF8]; assembleByte: imm].
	
	(-0x80000000 <= imm and: [imm < 0x80000000])
		ifTrue: [
			^self
				assembleBytes: #[0x48 0x3D];
				assembleBytes: imm count: 4].
	self 
		assembleBytes: #[0x49 0xBB];
		assembleBytes: imm count: 8;
		saveLastEmittedPointer;
		assembleBytes: #[0x4C 0x39 0xD8]
]

{ #category : #comparing }
TemplateAssembler64 >> compareRwithS [
	self assembleBytes: #[0x48 0x39 0xF0].
	
]

{ #category : #loading }
TemplateAssembler64 >> compareRwithSindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x3B 0x6]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x3B 0x46];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x3B 0x86];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> compareRwithVindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x49 0x3B 0x3]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x49 0x3B 0x43];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x49 0x3B 0x83];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> compareSwithTindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x3B 0x31]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x3B 0x71];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x3B 0xB1];
				assembleBytes: offset count: 4]
]

{ #category : #comparing }
TemplateAssembler64 >> compareTwithImmediate: imm [
	(-128 <= imm and: [imm < 128])
		ifTrue: [^self assembleBytes: #[0x48 0x83 0xF9]; assembleByte: imm].
	
	(-0x80000000 <= imm and: [imm < 0x80000000])
		ifTrue: [
			^self
				assembleBytes: #[0x48 0x81 0xF9];
				assembleBytes: imm count: 4].
	self 
		assembleBytes: #[0x49 0xBB];
		assembleBytes: imm count: 8;
		saveLastEmittedPointer;
		assembleBytes: #[0x4C 0x39 0xD9]
]

{ #category : #integers }
TemplateAssembler64 >> convertAtoNativeInteger [
	self assembleBytes: #[0x48 0xD1 0xFA].
	
]

{ #category : #integers }
TemplateAssembler64 >> convertAtoSmallInteger [
	self assembleBytes: #[0x48 0xD1 0xE2 0x48 0xFF 0xC2].
	
]

{ #category : #integers }
TemplateAssembler64 >> convertRtoNativeInteger [
	self assembleBytes: #[0x48 0xD1 0xF8].
	
]

{ #category : #integers }
TemplateAssembler64 >> convertRtoSmallInteger [
	self assembleBytes: #[0x48 0xD1 0xE0 0x48 0xFF 0xC0].
	
]

{ #category : #integers }
TemplateAssembler64 >> convertTosToSmallInteger [
	self assembleBytes: #[0x48 0xD1 0x24 0x24 0x48 0xFF 0x4 0x24].
	
]

{ #category : #integers }
TemplateAssembler64 >> convertTToNativeInteger [
	self assembleBytes: #[0x48 0xD1 0xF9].
	
]

{ #category : #integers }
TemplateAssembler64 >> convertTtoNativeInteger [
	self assembleBytes: #[0x48 0xD1 0xF9].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> decR [
	self assembleBytes: #[0x48 0xFF 0xC8].
	
]

{ #category : #private }
TemplateAssembler64 >> decRindirect [
	self assembleBytes: #[0x48 0xFF 0x8].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> divideDoubleX0byX1 [
	self assembleBytes: #[0xF2 0xF 0x5E 0xC1].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> divideRbyT [
	self assembleBytes: #[0x48 0x99 0x48 0xF7 0xF9].
	
]

{ #category : #loading }
TemplateAssembler64 >> dropTopOfFPU [
	self assembleBytes: #[0xDD 0xD8].
	
]

{ #category : #loading }
TemplateAssembler64 >> dummyPointer [
	^0x1BADADD01BADADD0
]

{ #category : #integers }
TemplateAssembler64 >> ensureRintegerBit [
	self assembleBytes: #[0xC 0x1].
	
]

{ #category : #integers }
TemplateAssembler64 >> ensureSafeRintegerBit [
	self assembleBytes: #[0xC 0x1].
	
]

{ #category : #loading }
TemplateAssembler64 >> exchangeRindirectWithT [
	self assembleBytes: #[0x48 0x87 0x8].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> incA [
	self assembleBytes: #[0x48 0xFF 0xC2].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> incC [
	self assembleBytes: #[0x48 0xFF 0xC3].
	
]

{ #category : #private }
TemplateAssembler64 >> initializeS [
	self assembleBytes: #[0x48 0x89 0xC6].
	
]

{ #category : #private }
TemplateAssembler64 >> jumpIndirectA [
	self assembleBytes: #[0xFF 0x22].
	
]

{ #category : #comparing }
TemplateAssembler64 >> jumpToA [
	self assembleBytes: #[0xFF 0xE2].
	
]

{ #category : #comparing }
TemplateAssembler64 >> jumpToS [
	self assembleBytes: #[0xFF 0xE6].
	
]

{ #category : #loading }
TemplateAssembler64 >> jumpToTindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0xFF 0x21]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0xFF 0x61];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0xFF 0xA1];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadAwithAindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x12]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x52];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0x92];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadAwithEindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x17]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x57];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0x97];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadAwithFPindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x55 0x0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x55];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0x95];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadAwithImmediate: imm [
	
	(-0x80000000 <= imm and: [imm < 0x80000000])
		ifTrue: [
			^self
				assembleBytes: #[0x48 0xC7 0xC2];
				assembleBytes: imm count: 4].
	self 
		assembleBytes: #[0x48 0xBA];
		assembleBytes: imm count: 8;
		saveLastEmittedPointer
]

{ #category : #loading }
TemplateAssembler64 >> loadAwithR [
	self assembleBytes: #[0x48 0x89 0xC2].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadAwithRindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x10]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x50];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0x90];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadAwithRoffsetAtA [
	self assembleBytes: #[0x48 0x8B 0x14 0x10].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadAwithS [
	self assembleBytes: #[0x48 0x89 0xF2].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadAwithSindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x16]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x56];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0x96];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadAwithT [
	self assembleBytes: #[0x48 0x89 0xCA].
	
]

{ #category : #integers }
TemplateAssembler64 >> loadEwithAddressOfRatA [
	self assembleBytes: #[0x48 0x8D 0x7C 0xD0 0xF8].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadEwithFPindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x7D 0x0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x7D];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0xBD];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadEwithImmediate: imm [
	
	(-0x80000000 <= imm and: [imm < 0x80000000])
		ifTrue: [
			^self
				assembleBytes: #[0x48 0xC7 0xC7];
				assembleBytes: imm count: 4].
	self 
		assembleBytes: #[0x48 0xBF];
		assembleBytes: imm count: 8;
		saveLastEmittedPointer
]

{ #category : #loading }
TemplateAssembler64 >> loadEwithR [
	self assembleBytes: #[0x48 0x89 0xC7].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadFPwithR [
	self assembleBytes: #[0x48 0x89 0xC5].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadFPwithSP [
	self assembleBytes: #[0x48 0x89 0xE5].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadLargeX0withRindirect [
	self assembleBytes: #[0x66 0x48 0xF 0x6E 0x0].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadLargeX1withAindirect [
	self assembleBytes: #[0x66 0x48 0xF 0x6E 0xA].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadLongRWithRAtOffsetA [
	self assembleBytes: #[0x8B 0x4 0x10].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadLongRwithRatOffsetA [
	self assembleBytes: #[0x8B 0x4 0x10].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadMXCSRfromA [
	self assembleBytes: #[0xF 0xAE 0x12].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadRconvertingDoublePointedByR [
	self assembleBytes: #[0xF2 0x48 0xF 0x2C 0x0].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadRConvertingDoubleRindirect [
	self assembleBytes: #[0xF2 0x48 0xF 0x2C 0x0].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithA [
	self assembleBytes: #[0x48 0x89 0xD0].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithArgPointer [
	self assembleBytes: #[0x48 0x8D 0x45 0x10].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithE [
	self assembleBytes: #[0x48 0x89 0xF8].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithEindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x7]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x47];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0x87];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithFP [
	self assembleBytes: #[0x48 0x89 0xE8].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithFPindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x45 0x0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x45];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0x85];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithImmediate: imm [
	
	(-0x80000000 <= imm and: [imm < 0x80000000])
		ifTrue: [
			^self
				assembleBytes: #[0x48 0xC7 0xC0];
				assembleBytes: imm count: 4].
	self 
		assembleBytes: #[0x48 0xB8];
		assembleBytes: imm count: 8;
		saveLastEmittedPointer
]

{ #category : #integers }
TemplateAssembler64 >> loadRwithRatA [
	self assembleBytes: #[0x48 0x8B 0x44 0xD0 0xF8].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithRatOffsetA [
	self assembleBytes: #[0x48 0x8B 0x4 0x10].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithRindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x40];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0x80];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithS [
	self assembleBytes: #[0x48 0x89 0xF0].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithSindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x6]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x46];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0x86];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithSPindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x4 0x24]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x44 0x24];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0x84 0x24];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithT [
	self assembleBytes: #[0x48 0x89 0xC8].
	
]

{ #category : #storing }
TemplateAssembler64 >> loadRwithThreadVariableAtIndexR [
	self assembleBytes: #[0x65 0x48 0x8B 0x4 0xC5 0x80 0x14 0x0 0x0].
	
]

{ #category : #storing }
TemplateAssembler64 >> loadRwithTIBatIndexR [
	self assembleBytes: #[0x65 0x48 0x8B 0x4 0xC5 0x0 0x0 0x0 0x0].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithTindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x1]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x41];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0x81];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithTos [
	self assembleBytes: #[0x48 0x8B 0x4 0x24].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadRwithX0 [
	self assembleBytes: #[0x66 0x48 0xF 0x7E 0xC0].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadSPwithFP [
	self assembleBytes: #[0x48 0x89 0xEC].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadSPwithT [
	self assembleBytes: #[0x48 0x89 0xCC].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadSwithA [
	self assembleBytes: #[0x48 0x89 0xD6].
	
]

{ #category : #integers }
TemplateAssembler64 >> loadSwithAddressOfSatA [
	self assembleBytes: #[0x48 0x8D 0x74 0xD6 0xF8].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadSwithFPindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x75 0x0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x75];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0xB5];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadSwithImmediate: imm [
	
	(-0x80000000 <= imm and: [imm < 0x80000000])
		ifTrue: [
			^self
				assembleBytes: #[0x48 0xC7 0xC6];
				assembleBytes: imm count: 4].
	self 
		assembleBytes: #[0x48 0xBE];
		assembleBytes: imm count: 8;
		saveLastEmittedPointer
]

{ #category : #loading }
TemplateAssembler64 >> loadSwithRindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x30]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x70];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0xB0];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadSwithT [
	self assembleBytes: #[0x48 0x89 0xCE].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadTwithA [
	self assembleBytes: #[0x48 0x89 0xD1].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadTwithAindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0xA]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x4A];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0x8A];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadTwithEindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0xF]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x4F];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0x8F];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadTwithFPindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x4D 0x0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x4D];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0x8D];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadTwithImmediate: imm [
	
	(-0x80000000 <= imm and: [imm < 0x80000000])
		ifTrue: [
			^self
				assembleBytes: #[0x48 0xC7 0xC1];
				assembleBytes: imm count: 4].
	self 
		assembleBytes: #[0x48 0xB9];
		assembleBytes: imm count: 8;
		saveLastEmittedPointer
]

{ #category : #loading }
TemplateAssembler64 >> loadTwithR [
	self assembleBytes: #[0x48 0x89 0xC1].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadTwithTindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x8B 0x9]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x8B 0x49];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x8B 0x89];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> loadVwithImmediate: imm [
	
	(-0x80000000 <= imm and: [imm < 0x80000000])
		ifTrue: [
			^self
				assembleBytes: #[0x49 0xC7 0xC3];
				assembleBytes: imm count: 4].
	self 
		assembleBytes: #[0x49 0xBB];
		assembleBytes: imm count: 8;
		saveLastEmittedPointer
]

{ #category : #loading }
TemplateAssembler64 >> loadX0withRasDouble [
	self assembleBytes: #[0xF2 0x48 0xF 0x2A 0xC0].
	
]

{ #category : #loading }
TemplateAssembler64 >> loadX1roundingX0 [
	self assembleBytes: #[0x66 0xF 0x3A 0xB 0xC8 0x3].
	
]

{ #category : #integers }
TemplateAssembler64 >> loadZeroExtendByteRwithRatA [
	self assembleBytes: #[0x48 0xF 0xB6 0x44 0x10 0xFF].
	
]

{ #category : #integers }
TemplateAssembler64 >> loadZeroExtendByteRwithSPatA [
	self assembleBytes: #[0x48 0xF 0xB6 0x44 0x14 0xFF].
	
]

{ #category : #integers }
TemplateAssembler64 >> loadZeroExtendLongRwithRatA [
	self assembleBytes: #[0x8B 0x44 0x90 0xFC].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> lock [
	self assembleBytes: #[0xF0].
	
]

{ #category : #'opcodes - integer related' }
TemplateAssembler64 >> moveTslots [
	self assembleBytes: #[0xF3 0x48 0xA5].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> multiplyDoubleX0byX1 [
	self assembleBytes: #[0xF2 0xF 0x59 0xC1].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> multiplyRbyA [
	self assembleBytes: #[0x48 0xF7 0xEA].
	
]

{ #category : #logic }
TemplateAssembler64 >> orRwithA [
	self assembleBytes: #[0x48 0x9 0xD0].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> popA [
	self assembleBytes: #[0x5A].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> popB [
	self assembleBytes: #[0x5B].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> popE [
	self assembleBytes: #[0x5F].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> popFP [
	self assembleBytes: #[0x5D].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> popR [
	self assembleBytes: #[0x58].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> popS [
	self assembleBytes: #[0x5E].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> popSP [
	self assembleBytes: #[0x5C].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> popSPindirect [
	self assembleBytes: #[0x8F 0x4 0x24].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> popT [
	self assembleBytes: #[0x59].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> pushA [
	self assembleBytes: #[0x52].
	
]

{ #category : #loading }
TemplateAssembler64 >> pushAOnFPUStack [
	self assembleBytes: #[0xDD 0x2].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> pushB [
	self assembleBytes: #[0x53].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> pushE [
	self assembleBytes: #[0x57].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> pushEindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0xFF 0x37]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0xFF 0x77];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0xFF 0xB7];
				assembleBytes: offset count: 4]
]

{ #category : #'push/pop' }
TemplateAssembler64 >> pushFP [
	self assembleBytes: #[0x55].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> pushFPindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0xFF 0x75 0x0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0xFF 0x75];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0xFF 0xB5];
				assembleBytes: offset count: 4]
]

{ #category : #'push/pop' }
TemplateAssembler64 >> pushImmediate: imm [
	(-128 <= imm and: [imm < 128])
		ifTrue: [^self assembleBytes: #[0x6A]; assembleByte: imm].
	
	(-0x80000000 <= imm and: [imm < 0x80000000])
		ifTrue: [
			^self
				assembleBytes: #[0x68];
				assembleBytes: imm count: 4].
	self 
		assembleBytes: #[0x49 0xBB];
		assembleBytes: imm count: 8;
		saveLastEmittedPointer;
		assembleBytes: #[0x41 0x53]
]

{ #category : #'push/pop' }
TemplateAssembler64 >> pushIndirectR [
	self assembleBytes: #[0xFF 0x30].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> pushR [
	self assembleBytes: #[0x50].
	
]

{ #category : #loading }
TemplateAssembler64 >> pushROnFPUStack [
	self assembleBytes: #[0xDD 0x0].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> pushS [
	self assembleBytes: #[0x56].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> pushSindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0xFF 0x36]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0xFF 0x76];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0xFF 0xB6];
				assembleBytes: offset count: 4]
]

{ #category : #'push/pop' }
TemplateAssembler64 >> pushSP [
	self assembleBytes: #[0x54].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> pushT [
	self assembleBytes: #[0x51].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> pushTindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0xFF 0x31]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0xFF 0x71];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0xFF 0xB1];
				assembleBytes: offset count: 4]
]

{ #category : #'push/pop' }
TemplateAssembler64 >> pushVindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x41 0xFF 0x33]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x41 0xFF 0x73];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x41 0xFF 0xB3];
				assembleBytes: offset count: 4]
]

{ #category : #epilogue }
TemplateAssembler64 >> restoreCallerEnvironment [
	self assembleBytes: #[0x48 0x8B 0x7D 0xE8].
	
]

{ #category : #epilogue }
TemplateAssembler64 >> restoreCallerFrame [
	self assembleBytes: #[0x48 0x89 0xEC 0x5D].
	
]

{ #category : #epilogue }
TemplateAssembler64 >> restoreCallerSelf [
	self assembleBytes: #[0x48 0x8B 0x75 0xF8].
	
]

{ #category : #integers }
TemplateAssembler64 >> restoreRSmallInteger [
	self assembleBytes: #[0x48 0xD1 0xD0].
	
]

{ #category : #integers }
TemplateAssembler64 >> restoreRsmallInteger [
	self assembleBytes: #[0x48 0xD1 0xD0].
	
]

{ #category : #loading }
TemplateAssembler64 >> saveCallerFrame [
	self assembleBytes: #[0x55 0x48 0x89 0xE5].
	
]

{ #category : #loading }
TemplateAssembler64 >> scaleFloatOnRWithA [
	self assembleBytes: #[0xDD 0x2 0xDD 0x0 0xD9 0xFD 0xDD 0x18 0xDD 0xD8].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> shiftLeftRwithT [
	self assembleBytes: #[0x48 0xD3 0xE0].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> shiftRightRwithT [
	self assembleBytes: #[0x48 0xD3 0xF8].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> sqrtDoubleX0 [
	self assembleBytes: #[0xF2 0xF 0x51 0xC0].
	
]

{ #category : #storing }
TemplateAssembler64 >> storeAinSPatT [
	self assembleBytes: #[0x48 0x89 0x54 0xCC 0xF8].
	
]

{ #category : #storing }
TemplateAssembler64 >> storeAinThreadVariableAtIndexR [
	self assembleBytes: #[0x65 0x48 0x89 0x14 0xC5 0x80 0x14 0x0 0x0].
	
]

{ #category : #storing }
TemplateAssembler64 >> storeAinTindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x89 0x11]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x89 0x51];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x89 0x91];
				assembleBytes: offset count: 4]
]

{ #category : #integers }
TemplateAssembler64 >> storeArgumentsInStack [
	self assembleBytes: #[0x48 0x89 0x4D 0x10 0x48 0x89 0x55 0x18 0x4C 0x89 0x45 0x20 0x4C 0x89 0x4D 0x28].
	
]

{ #category : #storing }
TemplateAssembler64 >> storeByteTinRatA [
	self assembleBytes: #[0x88 0x4C 0x10 0xFF].
	
]

{ #category : #'push/pop' }
TemplateAssembler64 >> storeDoubleResultInRindirect [
	self assembleBytes: #[0x66 0x48 0xF 0x7E 0x0].
	
]

{ #category : #storing }
TemplateAssembler64 >> storeEinAindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x89 0x3A]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x89 0x7A];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x89 0xBA];
				assembleBytes: offset count: 4]
]

{ #category : #storing }
TemplateAssembler64 >> storeEinRindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x89 0x38]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x89 0x78];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x89 0xB8];
				assembleBytes: offset count: 4]
]

{ #category : #loading }
TemplateAssembler64 >> storeLargeX0inA [
	self assembleBytes: #[0x66 0x48 0xF 0x7E 0x2].
	
]

{ #category : #loading }
TemplateAssembler64 >> storeLargeX0inR [
	self assembleBytes: #[0x66 0x48 0xF 0x7E 0x0].
	
]

{ #category : #loading }
TemplateAssembler64 >> storeLargeX0inT [
	self assembleBytes: #[0x66 0x48 0xF 0x7E 0x1].
	
]

{ #category : #storing }
TemplateAssembler64 >> storeLongTinRatA [
	self assembleBytes: #[0x89 0x4C 0x90 0xFC].
	
]

{ #category : #storing }
TemplateAssembler64 >> storeLongTInRAtA [
	self assembleBytes: #[0x89 0x4C 0x90 0xFC].
	
]

{ #category : #storing }
TemplateAssembler64 >> storeLongTinRatOffsetA [
	self assembleBytes: #[0x89 0xC 0x10].
	
]

{ #category : #loading }
TemplateAssembler64 >> storeMXCSRintoA [
	self assembleBytes: #[0xF 0xAE 0x1A].
	
]

{ #category : #storing }
TemplateAssembler64 >> storeRinAindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x89 0x2]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x89 0x42];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x89 0x82];
				assembleBytes: offset count: 4]
]

{ #category : #storing }
TemplateAssembler64 >> storeRinEindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x89 0x7]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x89 0x47];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x89 0x87];
				assembleBytes: offset count: 4]
]

{ #category : #storing }
TemplateAssembler64 >> storeRinFPindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x89 0x45 0x0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x89 0x45];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x89 0x85];
				assembleBytes: offset count: 4]
]

{ #category : #storing }
TemplateAssembler64 >> storeRinSindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x89 0x6]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x89 0x46];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x89 0x86];
				assembleBytes: offset count: 4]
]

{ #category : #storing }
TemplateAssembler64 >> storeRinTindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x89 0x1]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x89 0x41];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x89 0x81];
				assembleBytes: offset count: 4]
]

{ #category : #storing }
TemplateAssembler64 >> storeShortTinRatOffsetA [
	self assembleBytes: #[0x66 0x89 0xC 0x10].
	
]

{ #category : #storing }
TemplateAssembler64 >> storeSinAindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x89 0x32]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x89 0x72];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x89 0xB2];
				assembleBytes: offset count: 4]
]

{ #category : #storing }
TemplateAssembler64 >> storeSinRindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x89 0x30]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x89 0x70];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x89 0xB0];
				assembleBytes: offset count: 4]
]

{ #category : #storing }
TemplateAssembler64 >> storeTIBwithAatIndexR [
	self assembleBytes: #[0x65 0x48 0x89 0x14 0xC5 0x0 0x0 0x0 0x0].
	
]

{ #category : #storing }
TemplateAssembler64 >> storeTinAindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x89 0xA]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x89 0x4A];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x89 0x8A];
				assembleBytes: offset count: 4]
]

{ #category : #storing }
TemplateAssembler64 >> storeTInRAtA [
	self assembleBytes: #[0x48 0x89 0x4C 0xD0 0xF8].
	
]

{ #category : #storing }
TemplateAssembler64 >> storeTinRatA [
	self assembleBytes: #[0x48 0x89 0x4C 0xD0 0xF8].
	
]

{ #category : #storing }
TemplateAssembler64 >> storeTinRatOffsetA [
	self assembleBytes: #[0x48 0x89 0xC 0x10].
	
]

{ #category : #storing }
TemplateAssembler64 >> storeTinRindex: index [
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[0x48 0x89 0x8]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[0x48 0x89 0x48];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[0x48 0x89 0x88];
				assembleBytes: offset count: 4]
]

{ #category : #arithmetic }
TemplateAssembler64 >> subAfromR [
	self assembleBytes: #[0x48 0x29 0xD0].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> subAfromT [
	self assembleBytes: #[0x48 0x29 0xD1].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> subDoubleX1fromX0 [
	self assembleBytes: #[0xF2 0xF 0x5C 0xC1].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> subTslotsToSP [
	self assembleBytes: #[0x48 0xF7 0xD9 0x48 0x8D 0x24 0xCC 0x48 0xF7 0xD9].
	
]

{ #category : #integers }
TemplateAssembler64 >> testAintegerBit [
	self assembleBytes: #[0xF6 0xC2 0x1].
	
]

{ #category : #integers }
TemplateAssembler64 >> testRintegerBit [
	self assembleBytes: #[0xA8 0x1].
	
]

{ #category : #loading }
TemplateAssembler64 >> testRwithR [
	self assembleBytes: #[0x48 0x85 0xC0].
	
]

{ #category : #integers }
TemplateAssembler64 >> testTIntegerBit [
	self assembleBytes: #[0xF6 0xC1 0x1].
	
]

{ #category : #integers }
TemplateAssembler64 >> testTintegerBit [
	self assembleBytes: #[0xF6 0xC1 0x1].
	
]

{ #category : #arithmetic }
TemplateAssembler64 >> wordSize: anInteger [
	self ASSERT: anInteger = 8.
	super wordSize: anInteger
]

{ #category : #'opcodes - integer related' }
TemplateAssembler64 >> writeTslots [
	self assembleBytes: #[0xF3 0x48 0xAB].
	
]

{ #category : #logic }
TemplateAssembler64 >> xorAwithR [
	self assembleBytes: #[0x48 0x31 0xC2].
	
]

{ #category : #logic }
TemplateAssembler64 >> xorFPwithFP [
	self assembleBytes: #[0x48 0x31 0xED].
	
]

{ #category : #logic }
TemplateAssembler64 >> xorRwithA [
	self assembleBytes: #[0x48 0x31 0xD0].
	
]

