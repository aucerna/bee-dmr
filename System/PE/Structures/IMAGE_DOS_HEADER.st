Class {
	#name : #IMAGE_DOS_HEADER,
	#superclass : #PEFileStructure,
	#classVars : [
		'#Offsets'
	],
	#category : #PE
}

{ #category : #accessing }
IMAGE_DOS_HEADER class >> def [
	^<def>
		typedef struct IMAGE_DOS_HEADER {
			WORD e_magic; // 0
			WORD e_cblp; // 2
			WORD e_cp; // 4
			WORD e_crlc; // 6
			WORD e_cparhdr; // 8
			WORD e_minalloc; // 10
			WORD e_maxalloc; // 12
			WORD e_ss; // 14
			WORD e_sp; // 16
			WORD e_csum; // 18
			WORD e_ip; // 20
			WORD e_cs; // 22
			WORD e_lfarlc; // 24
			WORD e_ovno; // 26
			WORD e_res[4]; // 28
			WORD e_oemid; // 36
			WORD e_oeminfo; // 38
			WORD e_res2[10]; // 40
			LONG e_lfanew; // 60
		} IMAGE_DOS_HEADER; // sizeInBytes = 64
	</def>
]

{ #category : #accessing }
IMAGE_DOS_HEADER class >> magicDOS [
	"
	ascii for MZ
	"
	^16r5A4D
]

{ #category : #accessing }
IMAGE_DOS_HEADER class >> sizeInBytes [
	^sizeInBytes
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_cblp [
	^self uShortAtOffset: e_cblp
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_cblp: anInteger [
	self uShortAtOffset: e_cblp put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_cp [
	^self uShortAtOffset: e_cp
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_cp: anInteger [
	self uShortAtOffset: e_cp put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_cparhdr [
	^self uShortAtOffset: e_cparhdr
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_cparhdr: anInteger [
	self uShortAtOffset: e_cparhdr put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_crlc [
	^self uShortAtOffset: e_crlc
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_crlc: anInteger [
	self uShortAtOffset: e_crlc put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_cs [
	^self uShortAtOffset: e_cs
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_cs: anInteger [
	self uShortAtOffset: e_cs put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_csum [
	^self uShortAtOffset: e_csum
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_csum: anInteger [
	self uShortAtOffset: e_csum put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_ip [
	^self uShortAtOffset: e_ip
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_ip: anInteger [
	self uShortAtOffset: e_ip put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_lfanew [
	^self longAtOffset: e_lfanew
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_lfanew: anInteger [
	self longAtOffset: e_lfanew put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_lfarlc [
	^self uShortAtOffset: e_lfarlc
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_lfarlc: anInteger [
	self uShortAtOffset: e_lfarlc put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_magic [
	^self uShortAtOffset: e_magic
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_magic: anInteger [
	self uShortAtOffset: e_magic put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_maxalloc [
	^self uShortAtOffset: e_maxalloc
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_maxalloc: anInteger [
	self uShortAtOffset: e_maxalloc put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_minalloc [
	^self uShortAtOffset: e_minalloc
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_minalloc: anInteger [
	self uShortAtOffset: e_minalloc put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_oemid [
	^self uShortAtOffset: e_oemid
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_oemid: anInteger [
	self uShortAtOffset: e_oemid put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_oeminfo [
	^self uShortAtOffset: e_oeminfo
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_oeminfo: anInteger [
	self uShortAtOffset: e_oeminfo put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_ovno [
	^self uShortAtOffset: e_ovno
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_ovno: anInteger [
	self uShortAtOffset: e_ovno put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_res [
	^self uShortAtOffset: e_res
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_res: anInteger [
	self uShortAtOffset: e_res put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_res2 [
	^self uShortAtOffset: e_res2
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_res2: anInteger [
	self uShortAtOffset: e_res2 put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_sp [
	^self uShortAtOffset: e_sp
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_sp: anInteger [
	self uShortAtOffset: e_sp put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_ss [
	^self uShortAtOffset: e_ss
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> e_ss: anInteger [
	self uShortAtOffset: e_ss put: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> headerFixedSize [
	^self sizeInBytes alignedTo: self paragraphSize
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> initializeDefault [
	self e_magic: self class magicDOS
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> lastPageBytes: anInteger [
	self e_cblp: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> pageSize [
	^512
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> paragraphs: anInteger [
	self e_cparhdr: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> paragraphSize [
	"
	by definition of MZ files, a paragraph means 16 bytes
	"
	^16
]

{ #category : #printing }
IMAGE_DOS_HEADER >> printTextOn: rtf [
	rtf
		bold: 'DOS Header';
		crtab;
		italic: 'e_magic (magic): ';
		append: self e_magic;
		crtab;
		italic: 'e_cblp (last page bytes): ';
		append: self e_cblp asText;
		crtab;
		italic: 'e_cp (total pages): ';
		append: self e_cp asText;
		crtab;
		italic: 'e_crlc (relocation count): ';
		append: self e_crlc asText;
		crtab;
		italic: 'e_cparhdr (paragraphs): ';
		append: self e_cparhdr asText;
		crtab;
		italic: 'e_minalloc (min memory paragraphs): ';
		append: (self e_minalloc radix: 16);
		crtab;
		italic: 'e_maxalloc (max memory paragraphs): ';
		append: (self e_maxalloc radix: 16);
		crtab;
		italic: 'e_ss (initial ss): ';
		append: (self e_ss radix: 16);
		crtab;
		italic: 'e_sp (initial sp): ';
		append: (self e_sp radix: 16);
		crtab;
		italic: 'e_csum (checksum): ';
		append: (self e_csum radix: 16);
		crtab;
		italic: 'e_ip (initial ip): ';
		append: (self e_ip radix: 16);
		crtab;
		italic: 'e_cs (initial cs): ';
		append: (self e_cs radix: 16);
		crtab;
		italic: 'e_lfarlc (relocation table): ';
		append: (self e_lfarlc radix: 16);
		crtab;
		italic: 'e_ovno (overlay): ';
		append: self e_ovno asText;
		crtab;
		italic: 'e_res (reserved): ';
		append: self e_res asText;
		crtab;
		italic: 'e_oemid (oem id): ';
		append: (self e_oemid radix: 16);
		crtab;
		italic: 'e_oeminfo (oem info): ';
		append: (self e_oeminfo radix: 16);
		crtab;
		italic: 'e_res2 (reserved 2): ';
		cr;
		append: self e_res2 asText;
		crtab;
		italic: 'e_lfanew (new header offset): ';
		append: (self e_lfanew radix: 16)
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> setupSizeForHeaderSized: headerSize stubSized: stubSize [
	| bytes pages total aligned |
	self paragraphs: headerSize // self paragraphSize.
	total := headerSize + stubSize.
	aligned := total alignedTo: 4.
	bytes := total \\ self pageSize.
	pages := bytes = 0
		ifTrue: [total // self pageSize]
		ifFalse: [total // self pageSize + 1].
	self
		lastPageBytes: bytes;
		totalPages: pages;
		e_lfanew: aligned
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> setupSizeForStubSized: size [
	self setupSizeForHeaderSized: self headerFixedSize stubSized: size
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> setupStackAt: position [
	| sp |
	sp := position \\ 16r10000.
	self
		e_sp: sp;
		e_ss: position - sp // self paragraphSize
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> totalPages: anInteger [
	self e_cp: anInteger
]

{ #category : #accessing }
IMAGE_DOS_HEADER >> totalSize [
	| bytes |
	bytes := self lastPageBytes.
	^bytes = 0
		ifTrue: [self totalPages * self pageSize]
		ifFalse: [self totalPages - 1 * self pageSize + bytes]
]

