"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_LOGGING_INFO,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_LOGGING_INFO class >> aspects [
	^#(#Flags
		#LoggingFlags
		#softwareName
		#directoryName
		#Format
		#Fields
		#pExtFields
		#NumOfExtFields
		#MaxRecordSize
		#RolloverType
		#RolloverSize
		#pSecurityDescriptor)]

{ #category : #private }
HTTP_LOGGING_INFO class >> def [
	^<def>
	typedef struct {
		HTTP_PROPERTY_FLAGS        Flags;
		ULONG                      LoggingFlags;
		PCWSTR                     SoftwareName;
		USHORT                     SoftwareNameLength;
		USHORT                     DirectoryNameLength;
		PCWSTR                     DirectoryName;
		HTTP_LOGGING_TYPE          Format;
		ULONG                      Fields;
		PVOID                      pExtFields;
		USHORT                     NumOfExtFields;
		USHORT                     MaxRecordSize;
		HTTP_LOGGING_ROLLOVER_TYPE RolloverType;
		ULONG                      RolloverSize;
		PSECURITY_DESCRIPTOR       pSecurityDescriptor;
	} HTTP_LOGGING_INFO, *PHTTP_LOGGING_INFO;
	</def>]

{ #category : #'instance creation' }
HTTP_LOGGING_INFO class >> fromLogging: anHttpServerLogging [
	^self new fromLogging: anHttpServerLogging]

{ #category : #'instance creation' }
HTTP_LOGGING_INFO class >> iis [
	^self new beIIS]

{ #category : #initialization }
HTTP_LOGGING_INFO class >> initializeConstants [
	self
		initializeLoggingFieldConstants;
		initializeLoggingFlagConstants;
		initializeLoggingRolloverConstants;
		initializeLoggingTypeConstants]

{ #category : #initialization }
HTTP_LOGGING_INFO class >> initializeLoggingFieldConstants [
	WinConstants
		at: 'HTTP_LOG_FIELD_DATE' put: 0x00000001;
		at: 'HTTP_LOG_FIELD_TIME' put: 0x00000002;
		at: 'HTTP_LOG_FIELD_CLIENT_IP' put: 0x00000004;
		at: 'HTTP_LOG_FIELD_USER_NAME' put: 0x00000008;
		at: 'HTTP_LOG_FIELD_SITE_NAME' put: 0x00000010;
		at: 'HTTP_LOG_FIELD_COMPUTER_NAME' put: 0x00000020;
		at: 'HTTP_LOG_FIELD_SERVER_IP' put: 0x00000040;
		at: 'HTTP_LOG_FIELD_METHOD' put: 0x00000080;
		at: 'HTTP_LOG_FIELD_URI_STEM' put: 0x00000100;
		at: 'HTTP_LOG_FIELD_URI_QUERY' put: 0x00000200;
		at: 'HTTP_LOG_FIELD_STATUS' put: 0x00000400;
		at: 'HTTP_LOG_FIELD_WIN32_STATUS' put: 0x00000800;
		at: 'HTTP_LOG_FIELD_BYTES_SENT' put: 0x00001000;
		at: 'HTTP_LOG_FIELD_BYTES_RECV' put: 0x00002000;
		at: 'HTTP_LOG_FIELD_TIME_TAKEN' put: 0x00004000;
		at: 'HTTP_LOG_FIELD_SERVER_PORT' put: 0x00008000;
		at: 'HTTP_LOG_FIELD_USER_AGENT' put: 0x00010000;
		at: 'HTTP_LOG_FIELD_COOKIE' put: 0x00020000;
		at: 'HTTP_LOG_FIELD_REFERER' put: 0x00040000;
		at: 'HTTP_LOG_FIELD_VERSION' put: 0x00080000;
		at: 'HTTP_LOG_FIELD_HOST' put: 0x00100000;
		at: 'HTTP_LOG_FIELD_SUB_STATUS' put: 0x00200000;
		at: 'HTTP_LOG_FIELD_CLIENT_PORT' put: 0x00400000;
		at: 'HTTP_LOG_FIELD_URI' put: 0x00800000;
		at: 'HTTP_LOG_FIELD_SITE_ID' put: 0x01000000;
		at: 'HTTP_LOG_FIELD_REASON' put: 0x02000000;
		at: 'HTTP_LOG_FIELD_QUEUE_NAME' put: 0x04000000]

{ #category : #initialization }
HTTP_LOGGING_INFO class >> initializeLoggingFlagConstants [
	WinConstants
		at: 'HTTP_LOGGING_FLAG_LOCAL_TIME_ROLLOVER' put: 0x00000001;
		at: 'HTTP_LOGGING_FLAG_USE_UTF8_CONVERSION' put: 0x00000002;
		at: 'HTTP_LOGGING_FLAG_LOG_ERRORS_ONLY' put: 0x00000004;
		at: 'HTTP_LOGGING_FLAG_LOG_SUCCESS_ONLY' put: 0x00000008]

{ #category : #initialization }
HTTP_LOGGING_INFO class >> initializeLoggingRolloverConstants [
	WinConstants
		at: 'HttpLoggingRolloverSize' put: 0;
		at: 'HttpLoggingRolloverDaily' put: 1;
		at: 'HttpLoggingRolloverWeekly' put: 2;
		at: 'HttpLoggingRolloverMonthly' put: 3;
		at: 'HttpLoggingRolloverHourly' put: 4]

{ #category : #initialization }
HTTP_LOGGING_INFO class >> initializeLoggingTypeConstants [
	WinConstants
		at: 'HttpLoggingTypeW3C' put: 0;
		at: 'HttpLoggingTypeIIS' put: 1;
		at: 'HttpLoggingTypeNCSA' put: 2;
		at: 'HttpLoggingTypeRaw' put: 3]

{ #category : #'instance creation' }
HTTP_LOGGING_INFO class >> ncsa [
	^self new beNCSA]

{ #category : #private }
HTTP_LOGGING_INFO class >> offsets64 [
	^PoolDictionary new
		at: 'Flags' put: 0;
		at: 'LoggingFlags' put: 4;
		at: 'SoftwareName' put: 8;
		at: 'SoftwareNameLength' put: 16;
		at: 'DirectoryNameLength' put: 18;
		at: 'DirectoryName' put: 24;
		at: 'Format' put: 32;
		at: 'Fields' put: 36;
		at: 'pExtFields' put: 40;
		at: 'NumOfExtFields' put: 48;
		at: 'MaxRecordSize' put: 50;
		at: 'RolloverType' put: 52;
		at: 'RolloverSize' put: 56;
		at: 'pSecurityDescriptor' put: 64;
		at: 'sizeInBytes' put: 72;
		yourself]

{ #category : #'instance creation' }
HTTP_LOGGING_INFO class >> raw [
	^self new beRaw]

{ #category : #accessing }
HTTP_LOGGING_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
HTTP_LOGGING_INFO class >> typedefTable [
	^HttpApiDLL typedefTable]

{ #category : #'instance creation' }
HTTP_LOGGING_INFO class >> w3c [
	^self new basicW3CLogging]

{ #category : #input }
HTTP_LOGGING_INFO >> basicW3CLogging [
	self
		beW3C;
		Fields: HTTP_LOG_FIELD_DATE | HTTP_LOG_FIELD_TIME
			| HTTP_LOG_FIELD_USER_NAME]

{ #category : #input }
HTTP_LOGGING_INFO >> beIIS [
	self
		Format: HttpLoggingTypeIIS;
		RolloverType: HttpLoggingRolloverSize;
		RolloverSize: 1024 * 1024]

{ #category : #input }
HTTP_LOGGING_INFO >> beNCSA [
	self
		Format: HttpLoggingTypeNCSA;
		RolloverType: HttpLoggingRolloverSize;
		RolloverSize: 1024 * 1024]

{ #category : #input }
HTTP_LOGGING_INFO >> beRaw [
	self Format: HttpLoggingTypeRaw]

{ #category : #input }
HTTP_LOGGING_INFO >> beW3C [
	self
		Format: HttpLoggingTypeW3C;
		RolloverType: HttpLoggingRolloverSize;
		RolloverSize: 1024 * 1024;
		Fields: HTTP_LOG_FIELD_DATE | HTTP_LOG_FIELD_TIME
			| HTTP_LOG_FIELD_CLIENT_IP
			| HTTP_LOG_FIELD_USER_NAME
			| HTTP_LOG_FIELD_SITE_NAME
			| HTTP_LOG_FIELD_COMPUTER_NAME
			| HTTP_LOG_FIELD_SERVER_IP
			| HTTP_LOG_FIELD_METHOD
			| HTTP_LOG_FIELD_URI_STEM
			| HTTP_LOG_FIELD_URI_QUERY
			| HTTP_LOG_FIELD_STATUS
			| HTTP_LOG_FIELD_WIN32_STATUS
			| HTTP_LOG_FIELD_BYTES_SENT
			| HTTP_LOG_FIELD_BYTES_RECV
			| HTTP_LOG_FIELD_TIME_TAKEN
			| HTTP_LOG_FIELD_SERVER_PORT
			| HTTP_LOG_FIELD_USER_AGENT
			| HTTP_LOG_FIELD_COOKIE
			| HTTP_LOG_FIELD_REFERER
			| HTTP_LOG_FIELD_VERSION
			| HTTP_LOG_FIELD_HOST
			| HTTP_LOG_FIELD_SUB_STATUS
			| HTTP_LOG_FIELD_CLIENT_PORT
			| HTTP_LOG_FIELD_URI
			| HTTP_LOG_FIELD_SITE_ID
			| HTTP_LOG_FIELD_REASON
			| HTTP_LOG_FIELD_QUEUE_NAME]

{ #category : #output }
HTTP_LOGGING_INFO >> directoryName [
	^UTF16
		decodeFromAddress: self DirectoryName
		length: self DirectoryNameLength // 2]

{ #category : #accessing }
HTTP_LOGGING_INFO >> DirectoryName [
	^self addressAtOffset: DirectoryName]

{ #category : #input }
HTTP_LOGGING_INFO >> directoryName: aFilename [
	| path n |
	path := aFilename absolutePath externalCopy.
	n := path length - 2.
	n > 424 ifTrue: [self error: 'directory name is too long'].
	self DirectoryName: path; DirectoryNameLength: n]

{ #category : #accessing }
HTTP_LOGGING_INFO >> DirectoryName: anExternalMemory [
	self addressAtOffset: DirectoryName register: anExternalMemory]

{ #category : #accessing }
HTTP_LOGGING_INFO >> DirectoryNameLength [
	^self uShortAtOffset: DirectoryNameLength]

{ #category : #accessing }
HTTP_LOGGING_INFO >> DirectoryNameLength: anInteger [
	self uShortAtOffset: DirectoryNameLength put: anInteger]

{ #category : #accessing }
HTTP_LOGGING_INFO >> Fields [
	^self uLongAtOffset: Fields]

{ #category : #accessing }
HTTP_LOGGING_INFO >> Fields: anInteger [
	self uLongAtOffset: Fields put: anInteger]

{ #category : #accessing }
HTTP_LOGGING_INFO >> Flags [
	^self structureAtOffset: Flags ofClass: HTTP_PROPERTY_FLAGS]

{ #category : #accessing }
HTTP_LOGGING_INFO >> Flags: aHTTP_PROPERTY_FLAGS [
	self bytesAtOffset: Flags put: aHTTP_PROPERTY_FLAGS asParameter]

{ #category : #accessing }
HTTP_LOGGING_INFO >> Format [
	^self uLongAtOffset: Format]

{ #category : #accessing }
HTTP_LOGGING_INFO >> Format: anInteger [
	self uLongAtOffset: Format put: anInteger]

{ #category : #input }
HTTP_LOGGING_INFO >> fromLogging: anHttpServerLogging [
	self
		perform: ('be' , anHttpServerLogging type) asSymbol;
		directoryName: anHttpServerLogging directory asFilename]

{ #category : #initialization }
HTTP_LOGGING_INFO >> initialize: anInteger [
	super initialize: anInteger.
	self
		Flags: HTTP_PROPERTY_FLAGS present;
		"LoggingFlags: HTTP_LOGGING_FLAG_USE_UTF8_CONVERSION;"
		softwareName: 'Bee Smalltalk']

{ #category : #accessing }
HTTP_LOGGING_INFO >> LoggingFlags [
	^self uLongAtOffset: LoggingFlags]

{ #category : #accessing }
HTTP_LOGGING_INFO >> LoggingFlags: anInteger [
	self uLongAtOffset: LoggingFlags put: anInteger]

{ #category : #accessing }
HTTP_LOGGING_INFO >> MaxRecordSize [
	^self uShortAtOffset: MaxRecordSize]

{ #category : #accessing }
HTTP_LOGGING_INFO >> MaxRecordSize: anInteger [
	self uShortAtOffset: MaxRecordSize put: anInteger]

{ #category : #accessing }
HTTP_LOGGING_INFO >> NumOfExtFields [
	^self uShortAtOffset: NumOfExtFields]

{ #category : #accessing }
HTTP_LOGGING_INFO >> NumOfExtFields: anInteger [
	self uShortAtOffset: NumOfExtFields put: anInteger]

{ #category : #accessing }
HTTP_LOGGING_INFO >> pExtFields [
	^self pointerAtOffset: pExtFields]

{ #category : #accessing }
HTTP_LOGGING_INFO >> pExtFields: anInteger [
	self pointerAtOffset: pExtFields put: anInteger]

{ #category : #accessing }
HTTP_LOGGING_INFO >> pSecurityDescriptor [
	^self pointerAtOffset: pSecurityDescriptor]

{ #category : #accessing }
HTTP_LOGGING_INFO >> pSecurityDescriptor: anInteger [
	self pointerAtOffset: pSecurityDescriptor put: anInteger]

{ #category : #accessing }
HTTP_LOGGING_INFO >> RolloverSize [
	^self uLongAtOffset: RolloverSize]

{ #category : #accessing }
HTTP_LOGGING_INFO >> RolloverSize: anInteger [
	self uLongAtOffset: RolloverSize put: anInteger]

{ #category : #accessing }
HTTP_LOGGING_INFO >> RolloverType [
	^self uLongAtOffset: RolloverType]

{ #category : #accessing }
HTTP_LOGGING_INFO >> RolloverType: anInteger [
	self uLongAtOffset: RolloverType put: anInteger]

{ #category : #output }
HTTP_LOGGING_INFO >> softwareName [
	^UTF16
		decodeFromAddress: self SoftwareName
		length: self SoftwareNameLength // 2]

{ #category : #accessing }
HTTP_LOGGING_INFO >> SoftwareName [
	^self addressAtOffset: SoftwareName]

{ #category : #input }
HTTP_LOGGING_INFO >> softwareName: aString [
	| memory |
	memory := aString externalCopy.
	self
		SoftwareNameLength: memory length - 2;
		SoftwareName: memory]

{ #category : #accessing }
HTTP_LOGGING_INFO >> SoftwareName: anInteger [
	self addressAtOffset: SoftwareName register: anInteger]

{ #category : #accessing }
HTTP_LOGGING_INFO >> SoftwareNameLength [
	^self uShortAtOffset: SoftwareNameLength]

{ #category : #accessing }
HTTP_LOGGING_INFO >> SoftwareNameLength: anInteger [
	self uShortAtOffset: SoftwareNameLength put: anInteger]

