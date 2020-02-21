Class {
	#name : #PEBuilderTest,
	#superclass : #TestCase,
	#category : #Tests
}

{ #category : #private }
PEBuilderTest >> assemble: assemblerBlock [
	| assembler |
	assembler := JITAssembler64 on: #[] writeStream.
	assembler wordSize: 4.
	assemblerBlock value: assembler.
	^assembler applyFixups; bytes
]

{ #category : #private }
PEBuilderTest >> generate: file andAssertExecutionReturns: anInteger [
	| filename executor |
	filename := Directory scratchDir \ 'writtenpe.exe'.
	[
		file saveAs: filename.
		executor := OSProcessExecutor executeAndWait: filename]
		ensure: [filename removeFile].
	self assert: executor exitCode = anInteger
]

{ #category : #private }
PEBuilderTest >> generate: file then: aBlock [
	| filename |
	filename := Directory scratchDir \ 'writtenpe.exe'.
	[
		file saveAs: filename.
		aBlock value: filename]
		ensure: [filename removeFile]
]

{ #category : #private }
PEBuilderTest >> newPEBuilder [
	^PEBuilder newForPE32
]

{ #category : #testing }
PEBuilderTest >> test_010_verySimpleExe [
	| bytes builder code |
	bytes := self
		assemble: [:assembler | assembler loadRwithImmediate: 42; return: 0].
	builder := self newPEBuilder.
	code := builder addCodeSection.
	code bytes: bytes.
	builder entrypoint: code @ 0.
	self generate: builder andAssertExecutionReturns: 42
]

{ #category : #testing }
PEBuilderTest >> test_030_exeWithData [
	| bytes builder code data |
	bytes := self
		assemble: [:assembler | assembler loadRwithIndirect: 16r402000; return: 0].
	builder := self newPEBuilder.
	code := builder addCodeSection.
	code bytes: bytes.
	data := builder addInitializedDataSection.
	data baseVirtualAddress: 16r2000; bytes: #[42 0 0 0].
	builder entrypoint: code @ 0.
	self generate: builder andAssertExecutionReturns: 42
]

{ #category : #'testing-32bits' }
PEBuilderTest >> test_040_importLoadLibrary [
	| bytes builder code pointer |
	bytes := self assemble: [:assembler | 
		pointer := assembler loadAwithImmediate: 0; lastEmittedPointer.
		assembler
			pushImmediate: 0;
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
PEBuilderTest >> test_050_exportAddresses [
	| bytes builder code offset1 offset2 offset3 |
	bytes := self assemble: [:assembler | 
		offset1 := assembler loadRwithImmediate: 42; lastEmittedPointer.
		offset2 := assembler nop; lastEmittedPointer.
		offset3 := assembler nop; lastEmittedPointer.
		assembler return: 0].
	builder := self newPEBuilder.
	code := builder addCodeSection.
	code bytes: bytes.
	builder
		entrypoint: code @ 0;
		export: code firstSegment @ offset1 as: 'foo1';
		export: code firstSegment @ offset2 as: 'foo2';
		export: code firstSegment @ offset3 as: 'foo3'.
	self generate: builder then: [:filename | | library address |
		library := ExternalLibrary open: filename.
		[| base |
			self assert: library notNil.
			base := library asInteger.
			address := (library getProcAddress: 'foo1') asInteger.
			self assert: address - base = (code firstSegment @ offset1) rva.
			address := (library getProcAddress: 'foo2') asInteger.
			self assert: address - base = (code firstSegment @ offset2) rva.
			address := (library getProcAddress: 'foo3') asInteger.
			self assert: address - base = (code firstSegment @ offset3) rva]
			ensure: [library close]]
]

