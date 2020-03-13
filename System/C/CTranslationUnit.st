"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #CTranslationUnit,
	#superclass : #Object,
	#instVars : [
		'types',
		'unresolved',
		'wordSize'
	],
	#classVars : [
		'Windows32',
		'Windows64'
	],
	#category : #C
}

{ #category : #private }
CTranslationUnit class >> baseTypesTable [
	^#( 
		#('APIENTRY' #pointer)
		#('ATOM' #word)
		#('BOOL' #int)
		#('BOOLEAN' #byte)
		#('BYTE' #byte)
		#('CALLBACK' #pointer)
		#('CCHAR' #char)
		#('CHAR' #char)
		#('DOUBLE' #double)
		#('DWORD' #ulong)
		#('DWORDLONG' #large)
		#('DWORD_PTR' #pointer)
		#('DWORD32' #ulong)
		#('DWORD64' #large)
		#('FLOAT' #float)
		#('HACCEL' #pointer)
		#('HALF_PTR' #ulong)
		#('HANDLE' #pointer)
		#('HBITMAP' #pointer)
		#('HBRUSH' #pointer)
		#('HCOLORSPACE' #pointer)
		#('HCONV' #pointer)
		#('HCONVLIST' #pointer)
		#('HCURSOR' #pointer)
		#('HDC' #pointer)
		#('HDDEDATA' #pointer)
		#('HDESK' #pointer)
		#('HDROP' #pointer)
		#('HDWP' #pointer)
		#('HENHMETAFILE' #pointer)
		#('HFILE' #pointer)
		#('HFONT' #pointer)
		#('HGDIOBJ' #pointer)
		#('HGLOBAL' #pointer)
		#('HHOOK' #pointer)
		#('HICON' #pointer)
		#('HINSTANCE' #pointer)
		#('HKEY' #pointer)
		#('HKL' #pointer)
		#('HLOCAL' #pointer)
		#('HMENU' #pointer)
		#('HMETAFILE' #pointer)
		#('HMODULE' #pointer)
		#('HMONITOR' #pointer)
		#('HPALETTE' #pointer)
		#('HPEN' #pointer)
		#('HRESULT' #ulong)
		#('HRGN' #pointer)
		#('HRSRC' #pointer)
		#('HSZ' #pointer)
		#('HWINSTA' #pointer)
		#('HWND' #pointer)
		#('INT' #int)
		#('INT_PTR' #pointer)
		#('INT8' #byte)
		#('INT16' #short)
		#('INT32' #long)
		#('INT64' #large)
		#('LANGID' #short)
		#('LCID' #ulong)
		#('LCTYPE' #ulong)
		#('LGRPID' #ulong)
		#('LONG' #int)
		#('LONGLONG' #large)
		#('LONG_PTR' #pointer)
		#('LONG32' #int)
		#('LONG64' #large)
		#('LPARAM' #pointer)
		#('LPBOOL' #pointer #ulong)
		#('LPBYTE' #pointer #byte)
		#('LPCVOID' #pointer )
		#('LPDWORD' #address #ulong)
		#('LPHANDLE' #pointer #pointer)
		#('LPINT' #pointer #long)
		#('LPLONG' #pointer #long)
		#('LPVOID' #pointer)
		#('LPWORD' #pointer #short)
		#('LRESULT' #lresult)
		#('PBOOL' #pointer #ulong)
		#('PBOOLEAN' #pointer #byte)
		#('PBYTE' #pointer #byte)
		#('PDWORD' #pointer #ulong)
		#('PDWORDLONG' #pointer #large)
		#('PDWORD_PTR' #pointer #pointer)
		#('PDWORD32' #pointer #ulong)
		#('PDWORD64' #pointer #large)
		#('PHALF_PTR' #pointer)
		#('PHANDLE' #pointer #pointer)
		#('PHKEY' #pointer #pointer)
		#('PINT' #pointer #long)
		#('PINT_PTR' #pointer #pointer)
		#('PINT8' #pointer #byte)
		#('PINT16' #pointer #short)
		#('PINT32' #pointer #long)
		#('PINT64' #pointer #large)
		#('PLCID' #pointer #ulong)
		#('PLONG' #pointer #long)
		#('PLONGLONG' #pointer #large)
		#('PLONG_PTR' #pointer #pointer)
		#('PLONG32' #pointer #long)
		#('PLONG64' #pointer #large)
		#('POINTER_32' #ulong)
		#('POINTER_64' #large)
		#('POINTER_SIGNED' #pointer)
		#('POINTER_UNSIGNED' #pointer)
		#('PSHORT' #pointer #short)
		#('PSIZE_T' #pointer #pointer)
		#('PSSIZE_T' #pointer #pointer)
		#('PTBYTE' #pointer #short)
		#('PTCHAR' #pointer #wchar)
		#('PUCHAR' #pointer #char)
		#('PUHALF_PTR' #pointer)
		#('PUINT' #pointer #ulong)
		#('PUINT_PTR' #pointer #pointer)
		#('PUINT8' #pointer #byte)
		#('PUINT16' #pointer #short)
		#('PUINT32' #pointer #long)
		#('PUINT64' #pointer #large)
		#('PULONG' #pointer #ulong)
		#('PULONGLONG' #pointer #large)
		#('PULONG_PTR' #pointer #pointer)
		#('PULONG32' #pointer #ulong)
		#('PULONG64' #pointer #large)
		#('PUSHORT' #pointer #ushort)
		#('PVOID' #pointer)
		#('PWCHAR' #pointer #wchar)
		#('PWORD' #pointer #ushort)
		#('QWORD' #large)
		#('REAL' #float)
		#('SC_HANDLE' #pointer)
		#('SC_LOCK' #pointer)
		#('SERVICE_STATUS_HANDLE' #pointer)
		#('SHORT' #short)
		#('SIZE_T' #pointer)
		#('SSIZE_T' #pointer)
		#('TBYTE' #ushort)
		#('TCHAR' #wchar)
		#('UCHAR' #byte)
		#('UHALF_PTR' #ulong)
		#('UINT' #ulong)
		#('UINT_PTR' #pointer)
		#('UINT8' #byte)
		#('UINT16' #ushort)
		#('UINT32' #ulong)
		#('UINT64' #large)
		#('ULONG' #ulong)
		#('ULONGLONG' #large)
		#('ULONG_PTR' #pointer)
		#('ULONG32' #ulong)
		#('ULONG64' #large)
		#('USHORT' #ushort)
		#('USN' #large)
		#('VOID' #ulong)
		#('WCHAR' #wchar)
		#('WORD' #ushort)
		#('WPARAM' #pointer))
]

{ #category : #private }
CTranslationUnit class >> boundTypesTable [
	^#(
		#('LPCSTR' #address #String)
		#('LPCTSTR' #address #WideString)
		#('LPCWSTR' #address #WideString)
		#('LPSTR' #pointer #String)
		#('LPTSTR' #address #WideString)
		#('LPWSTR' #address #WideString)
		#('PCHAR' #address #String)
		#('PCSTR' #address #String)
		#('PCTSTR' #address #WideString)
		#('PCWSTR' #address #WideString)
		#('PSTR' #address #String)
		#('PTSTR' #pointer #WideString)
		#('PWSTR' #address #WideString)
		#('PFLOAT' #pointer #ExternalFloat)
	)
]

{ #category : #'instance creation' }
CTranslationUnit class >> new [
	^super new initialize
]

{ #category : #private }
CTranslationUnit class >> windows [
	^self windows: WordSize
]

{ #category : #private }
CTranslationUnit class >> windows: wordSize [
	^self new
		wordSize: wordSize;
		addBasicTypes;
		addPointerTypedefs;
		addTypedefsFrom: self baseTypesTable;
		addBoundTypesFrom: self boundTypesTable
]

{ #category : #private }
CTranslationUnit class >> windows32 [
	^self windows: 32 / 8
]

{ #category : #private }
CTranslationUnit class >> windows64 [
	^self windows: 64 / 8
]

{ #category : #initialization }
CTranslationUnit >> addBasicTypes [
	| typedefs sizet |
	#(
		(('void') 0)
		(('char' 'unsigned char') 1)
		(('short' 'unsigned short') 2)
		(('int' 'long' 'signed int' 'unsigned int' 'signed' 'unsigned' 'signed long' 'unsigned long' 'boolean' 'float') 4)
		(('double' 'long long' 'signed long long' 'unsigned long long') 8)
	) do: [:pair | | size |
		size := pair second.
		pair first do: [:name | | type |
			type := CBasicType new
				translationUnit: self;
				name: name;
				size: size.
			name = 'float' ifTrue: [type classBinding: ExternalFloat].
			(#('long' 'int' 'boolean' 'signed long' 'unsigned long' 'signed int' 'unsigned int')
				includes: name)
				ifTrue: [type sizeExpression: 'ExternalInt32 sizeInBytes'].
			self addType: type]].
	typedefs := #(
		#('uchar' #'unsigned char')
		#('ushort' #'unsigned short')
		#('uint' #'unsigned int')
		#('ulong' #'unsigned long')
		#('u_char' #'unsigned char')
		#('byte' #'unsigned char')
		#('wchar' #short)
		#('u_short' #'unsigned short')
		#('word' #'unsigned short')
		#('large' #'long long')
		#('ularge' #'unsigned long long')
	).
	sizet := wordSize = 4 ifTrue: ['uint'] ifFalse: ['ularge'].
	self
		addTypedefsFrom: typedefs;
		addTypedef: (self typeNamed: sizet) as: 'size_t';
		addTypedef: (self typeNamed: 'size_t') as: 'time_t'
]

{ #category : #initialization }
CTranslationUnit >> addBoundTypesFrom: aTable [
	aTable do: [:line | | type |
		type := self typeNamed: line second.
		type classBinding: line third.
		self addTypedef: type as: line first]
]

{ #category : #initialization }
CTranslationUnit >> addPointerTypedefs [
	| voidp |
	voidp := (self typeNamed: 'void') pointer.
	#('pointer' 'lresult' 'address' 'callback')
		do: [:name | self addTypedef: voidp as: name]
]

{ #category : #'adding / removing' }
CTranslationUnit >> addType: aCType [
	| name result |
	name := aCType name.
	result := self basicAddType: aCType.
	unresolved at: name ifPresent: [:previous | 
		types
			at: previous pointer name
			ifPresent: [:pointer | pointer baseType: aCType].
		unresolved removeKey: name].
	^result
]

{ #category : #private }
CTranslationUnit >> addTypedef: aCType as: aString [
	| typedef |
	typedef := CTypedef new
		translationUnit: self;
		baseType: aCType;
		name: aString.
	self addType: typedef.
	^typedef
]

{ #category : #initialization }
CTranslationUnit >> addTypedefsFrom: aTable [
	| remaining |
	remaining := aTable asOrderedCollection.
	[remaining isEmpty] whileFalse: [| next type |
		next := remaining removeFirst.
		type := self typeNamed: next second.
		type ifNil: [remaining addLast: next] ifNotNil: [
			next size = 3 ifTrue: [type := (self typeNamed: next third) pointer].
			self addTypedef: type as: next first]]
]

{ #category : #'adding / removing' }
CTranslationUnit >> addUnionNamed: aString fields: aCollection [
	| struct |
	struct := CUnion new
		translationUnit: self;
		name: aString;
		fields: aCollection.
	^self addType: struct
]

{ #category : #'adding / removing' }
CTranslationUnit >> addUnresolved: typename [
	| type |
	type := CUnresolvedType new translationUnit: self; name: typename.
	unresolved at: typename put: type.
	^self basicAddType: type
]

{ #category : #'adding / removing' }
CTranslationUnit >> basicAddType: aCType [
	^types at: aCType name put: aCType ifPresent: [:existing | 
		self
			ASSERT: (existing isUnresolved
				or: [aCType class = existing class or: [existing isStruct]]).
		aCType]
]

{ #category : #initialization }
CTranslationUnit >> initialize [
	super initialize.
	types := Dictionary new.
	unresolved := Dictionary new
]

{ #category : #'adding / removing' }
CTranslationUnit >> lookupTypeNamed: name [
	| pointer class callback |
	pointer := self tryResolvingPointerType: name.
	pointer ifNotNil: [^pointer].
	class := self tryResolvingMemoryBufferType: name.
	class ifNotNil: [^class].
	callback := self tryResolvingCallbackType: name.
	callback ifNotNil: [^callback].
	^nil
]

{ #category : #accessing }
CTranslationUnit >> pointerSize [
	^wordSize
]

{ #category : #private }
CTranslationUnit >> tryResolvingCallbackType: aString [
	| string pointer |
	string := aString asLowercase.
	^((string includesString: 'callback') or: [string
		includesString: 'hookproc'])
		ifTrue: [
			pointer := self typeNamed: 'void*'.
			self addTypedef: pointer as: aString]
]

{ #category : #'adding / removing' }
CTranslationUnit >> tryResolvingMemoryBufferType: aString [
	| class |
	class := Smalltalk classNamed: aString.
	(class isNil
		and: [aString size > 0 and: [aString last = $W or: [aString last = $L]]])
		ifTrue: [class := Smalltalk classNamed: aString allButLast].
	(class isNil and: [aString first = $_])
		ifTrue: [class := Smalltalk classNamed: aString allButFirst].
	(class isNil orNot: [class inheritsFrom: MemoryBuffer]) ifTrue: [^nil].
	^[| type |
		type := class typedefUsing: self.
		type name = aString ifTrue: [type] ifFalse: [
			aString first = $_
				ifTrue: [type baseType]
				ifFalse: [self addTypedef: type as: aString]]]
		on: Error
		do: [:e | self halt]
]

{ #category : #private }
CTranslationUnit >> tryResolvingPointerType: aString [
	| prefix string type |
	string := (aString endsWith: '*') ifTrue: [aString allButLast] ifFalse: [
		prefix := #('P' 'LP' 'lp')
			detect: [:p | aString beginsWith: p]
			ifNone: [^nil].
		aString allButFirst: prefix size].
	type := types at: string ifAbsent: [self lookupTypeNamed: string].
	^type notNil ifTrue: [self addTypedef: type pointer as: aString]
]

{ #category : #services }
CTranslationUnit >> typeNamed: name [
	| string |
	string := name asString.
	^types at: string ifAbsent: [| type declaration |
		declaration := self addUnresolved: string.
		type := self lookupTypeNamed: string.
		type ifNil: [declaration]]
]

{ #category : #accessing }
CTranslationUnit >> wordSize: anInteger [
	wordSize := anInteger
]

