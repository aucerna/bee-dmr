Class {
	#name : #PEBuilder64Test,
	#superclass : #PEBuilderTest,
	#category : #Tests
}

{ #category : #private }
PEBuilder64Test >> assemble: assemblerBlock [
	| assembler |
	assembler := JITAssembler64 on: #[] writeStream.
	assembler wordSize: 8.
	assemblerBlock value: assembler.
	^assembler applyFixups; bytes
]

{ #category : #private }
PEBuilder64Test >> newPEBuilder [
	^PEBuilder newForPE32Plus
]

{ #category : #testing }
PEBuilder64Test >> test_040_importLoadLibrary [
	| bytes builder code pointer |
	bytes := self assemble: [:assembler | 
		pointer := assembler loadAwithImmediate: 0; lastEmittedPointer.
		assembler
			loadTwithImmediate: 0;
			callIndirectA;
			loadAwithImmediate: 0;
			compareRwithImmediate: 16r400000;
			jumpIfNotEqualTo: 'end';
			loadAwithImmediate: 42;
			@ 'end';
			loadRwithA;
			return: 0].
	builder := self newPEBuilder.
	code := builder addCodeSection.
	code bytes: bytes.
	builder
		entrypoint: code @ 0;
		import: 'GetModuleHandleA'
		from: 'kernel32.dll'
		at: code firstSegment @ pointer.
	self generate: builder andAssertExecutionReturns: 42
]

{ #category : #testing }
PEBuilder64Test >> test_050_exportAddresses [
	"
	64-bit libraries can only be opened from 64-bit exes
	"
	#knownIssue
]

