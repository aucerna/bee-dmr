"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_DATA_CHUNK,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #accessing }
HTTP_DATA_CHUNK class >> def [
	^<def>
		typedef struct _HTTP_DATA_CHUNK {
			HTTP_DATA_CHUNK_TYPE DataChunkType; // 0
			union  {
				struct  {
					PVOID pBuffer; // 0
					ULONG BufferLength; // 4
				} FromMemory; // 0
				struct  {
					HTTP_BYTE_RANGE ByteRange; // 0
					HANDLE FileHandle; // 16
				} FromFileHandle; // 0
				struct  {
					USHORT FragmentNameLength; // 0
					PCWSTR pFragmentName; // 4
				} FromFragmentCache; // 0
				struct  {
					HTTP_BYTE_RANGE ByteRange; // 0
					PCWSTR pFragmentName; // 16
				} FromFragmentCacheEx; // 0
			} ; // 8
		} HTTP_DATA_CHUNK, *PHTTP_DATA_CHUNK; // sizeInBytes = 32
	</def>]

{ #category : #'instance creation' }
HTTP_DATA_CHUNK class >> fromData: data maxBytes: n [
	| count index buffer stream |
	count := data sizeInBytes + n - 1 // n.
	index := 1.
	buffer := BufferArray externalNew: count of: self.
	stream := data readStream.
	[stream atEnd] whileFalse: [| fragment chunk |
		fragment := stream peek: n.
		stream skip: fragment sizeInBytes.
		chunk := self new buffer: fragment.
		buffer at: index putStruct: chunk.
		index := index + 1].
	^buffer]

{ #category : #initialization }
HTTP_DATA_CHUNK class >> initializeConstants [
	"
	HTTP_DATA_CHUNK initializeConstants
	"
	self initializeDataChunkTypeConstants]

{ #category : #initialization }
HTTP_DATA_CHUNK class >> initializeDataChunkTypeConstants [
	WinConstants
		at: 'HttpDataChunkFromMemory'
		put: 0 "The data source is a memory data block. The union should be interpreted as a FromMemory structure.";
		at: 'HttpDataChunkFromFileHandle'
		put: 1 "The data source is a file handle data block. The union should be interpreted as a FromFileHandle structure.";
		at: 'HttpDataChunkFromFragmentCache'
		put: 2 "The data source is a fragment cache data block. The union should be interpreted as a FromFragmentCache structure.";
		at: 'HttpDataChunkFromFragmentCacheEx'
		put: -1 "The data source is a fragment cache data block. The union should be interpreted as a FromFragmentCacheEx structure.";
		at: 'HttpDataChunkMaximum'
		put: 3 "The data source is a fragment cache data block. The union should be interpreted as a FromFragmentCacheEx structure."]

{ #category : #accessing }
HTTP_DATA_CHUNK class >> offsets64 [
^PoolDictionary new
		at: 'BufferLength' put: 16;
		at: 'FromFragmentCache_pFragmentName' put: 16;
		at: 'pBuffer' put: 8;
		at: 'sizeInBytes' put: 32;
		at: 'FileHandle' put: 24;
		at: 'FragmentNameLength' put: 8;
		at: 'DataChunkType' put: 0;
		at: 'FromFileHandle_ByteRange' put: 8;
		at: 'FromFragmentCacheEx_pFragmentName' put: 24;
		at: 'FromFragmentCacheEx_ByteRange' put: 8;
		yourself]

{ #category : #accessing }
HTTP_DATA_CHUNK class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
HTTP_DATA_CHUNK class >> typedefTable [
	^HttpApiDLL typedefTable]

{ #category : #output }
HTTP_DATA_CHUNK >> buffer [
	^String fromMemory: self pBuffer length: self BufferLength]

{ #category : #input }
HTTP_DATA_CHUNK >> buffer: aString [
	self
		fromMemory;
		pBuffer: aString externalCopy;
		BufferLength: aString sizeInBytes]

{ #category : #accessing }
HTTP_DATA_CHUNK >> BufferLength [
	^self uLongAtOffset: BufferLength]

{ #category : #accessing }
HTTP_DATA_CHUNK >> BufferLength: anInteger [
	self uLongAtOffset: BufferLength put: anInteger]

{ #category : #accessing }
HTTP_DATA_CHUNK >> DataChunkType [
	^self uLongAtOffset: DataChunkType]

{ #category : #accessing }
HTTP_DATA_CHUNK >> DataChunkType: anInteger [
	self uLongAtOffset: DataChunkType put: anInteger]

{ #category : #accessing }
HTTP_DATA_CHUNK >> FileHandle [
	^self pointerAtOffset: FileHandle]

{ #category : #accessing }
HTTP_DATA_CHUNK >> FileHandle: anInteger [
	self pointerAtOffset: FileHandle put: anInteger]

{ #category : #output }
HTTP_DATA_CHUNK >> fragmentName [
	| string |
	string := self DataChunkType = HttpDataChunkFromFragmentCache
		ifTrue: [
			WideString
				fromMemory: self FromFragmentCache_pFragmentName
				length: self FragmentNameLength]
		ifFalse: [WideString fromMemory: self FromFragmentCacheEx_pFragmentName].
	^string asString]

{ #category : #accessing }
HTTP_DATA_CHUNK >> FragmentNameLength [
	^self uShortAtOffset: FragmentNameLength]

{ #category : #accessing }
HTTP_DATA_CHUNK >> FragmentNameLength: anInteger [
	self uShortAtOffset: FragmentNameLength put: anInteger]

{ #category : #services }
HTTP_DATA_CHUNK >> fromFile [
	self DataChunkType: HttpDataChunkFromFileHandle]

{ #category : #accessing }
HTTP_DATA_CHUNK >> FromFileHandle_ByteRange [
	^self structureAtOffset: FromFileHandle_ByteRange ofClass: HTTP_BYTE_RANGE]

{ #category : #accessing }
HTTP_DATA_CHUNK >> FromFileHandle_ByteRange: anInteger [
	self structureAtOffset: FromFileHandle_ByteRange put: anInteger]

{ #category : #services }
HTTP_DATA_CHUNK >> fromFragmentCache [
	self DataChunkType: HttpDataChunkFromFragmentCache]

{ #category : #accessing }
HTTP_DATA_CHUNK >> FromFragmentCache_pFragmentName [
	^self pointerAtOffset: FromFragmentCache_pFragmentName]

{ #category : #accessing }
HTTP_DATA_CHUNK >> FromFragmentCache_pFragmentName: anInteger [
	self pointerAtOffset: FromFragmentCache_pFragmentName put: anInteger]

{ #category : #accessing }
HTTP_DATA_CHUNK >> FromFragmentCacheEx_ByteRange [
	^self structureAtOffset: FromFragmentCacheEx_ByteRange ofClass: HTTP_BYTE_RANGE]

{ #category : #accessing }
HTTP_DATA_CHUNK >> FromFragmentCacheEx_ByteRange: anInteger [
	self structureAtOffset: FromFragmentCacheEx_ByteRange put: anInteger]

{ #category : #accessing }
HTTP_DATA_CHUNK >> FromFragmentCacheEx_pFragmentName [
	^self pointerAtOffset: FromFragmentCacheEx_pFragmentName]

{ #category : #accessing }
HTTP_DATA_CHUNK >> FromFragmentCacheEx_pFragmentName: anInteger [
	self pointerAtOffset: FromFragmentCacheEx_pFragmentName put: anInteger]

{ #category : #services }
HTTP_DATA_CHUNK >> fromMemory [
	self DataChunkType: HttpDataChunkFromMemory]

{ #category : #accessing }
HTTP_DATA_CHUNK >> pBuffer [
	^self pointerAtOffset: pBuffer]

{ #category : #accessing }
HTTP_DATA_CHUNK >> pBuffer: anExternalMemory [
	self addressAtOffset: pBuffer register: anExternalMemory]

