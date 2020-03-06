Class {
	#name : #CStructField,
	#superclass : #Object,
	#instVars : [
		'type',
		'name',
		'alignment',
		'offset',
		'conflictive'
	],
	#classVars : [
		'Mapping'
	],
	#category : #C
}

{ #category : #'instance creation' }
CStructField class >> classFor: field [
	^self allSubclasses detect: [:cls | cls accepts: field]
]

{ #category : #initialization }
CStructField class >> initializeFromTypeTable [
	Mapping removeAll.
	self typeTable do: [:array | | type token |
		type := array second.
		(Smalltalk classNamed: type) notNil ifTrue: [type := Smalltalk at: type].
		array size = 3 ifTrue: [
			token := array third.
			token := Smalltalk at: token ifAbsent: token.
			type := type -> token].
		Mapping at: array first asLowercase put: type]
]

{ #category : #initialization }
CStructField class >> initializeMapping [
	Mapping := Dictionary new.
	self initializeFromTypeTable.
	Mapping
		at: 'double' put: #double;
		at: 'rectl' put: RECT;
		at: 'pointl' put: POINT;
		at: 'sizel' put: SIZE;
		at: 'variant_bool' put: #boolean;
		at: '_variant_bool' put: #boolean;
		at: 'date' put: #double;
		at: 'socket' put: #ulong;
		at: 'u_char' put: #byte;
		at: 'u_short' put: #ushort;
		at: 'vartype' put: #ushort;
		at: 'scode' put: #long;
		at: 'cy' put: LARGE_INTEGER
]

{ #category : #initialization }
CStructField class >> new [
	^super new initialize
]

{ #category : #private }
CStructField class >> typeTable [
	^#(#('APIENTRY' #pointer)
		#('ATOM' #word)
		#('BOOL' #boolean)
		#('BOOLEAN' #byte)
		#('BYTE' #byte)
		#('CALLBACK' #pointer)
		#('CCHAR' #char)
		#('CHAR' #char)
		#('COLORREF' #ulong)
		#('DWORD' #ulong)
		#('DWORDLONG' #large)
		#('DWORD_PTR' #pointer)
		#('DWORD32' #ulong)
		#('DWORD64' #large)
		#('FLOAT' #ExternalFloat)
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
		#('INT' #integer)
		#('INT_PTR' #pointer)
		#('INT8' #byte)
		#('INT16' #short)
		#('INT32' #long)
		#('INT64' #large)
		#('LANGID' #short)
		#('LCID' #ulong)
		#('LCTYPE' #ulong)
		#('LGRPID' #ulong)
		#('LONG' #integer)
		#('LONGLONG' #large)
		#('LONG_PTR' #pointer)
		#('LONG32' #integer)
		#('LONG64' #large)
		#('LPARAM' #pointer)
		#('LPBOOL' #pointer #ulong)
		#('LPBYTE' #pointer #byte)
		#('LPCOLORREF' #pointer #COLORREF)
		#('LPCSTR' #address #String)
		#('LPCTSTR' #address #WideString)
		#('LPCVOID' #pointer )
		#('LPCWSTR' #address #WideString)
		#('LPDWORD' #address #ulong)
		#('LPHANDLE' #pointer #pointer)
		#('LPINT' #pointer #long)
		#('LPLONG' #pointer #long)
		#('LPSTR' #pointer #String)
		#('LPTSTR' #address #WideString)
		#('LPVOID' #pointer)
		#('LPWORD' #pointer #short)
		#('LPWSTR' #address #WideString)
		#('LRESULT' #lresult)
		#('PBOOL' #pointer #ulong)
		#('PBOOLEAN' #pointer #byte)
		#('PBYTE' #pointer #byte)
		#('PCHAR' #address #String)
		#('PCSTR' #address #String)
		#('PCTSTR' #address #WideString)
		#('PCWSTR' #address #WideString)
		#('PDWORD' #pointer #ulong)
		#('PDWORDLONG' #pointer #large)
		#('PDWORD_PTR' #pointer #pointer)
		#('PDWORD32' #pointer #ulong)
		#('PDWORD64' #pointer #large)
		#('PFLOAT' #pointer #ExternalFloat)
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
		#('PSTR' #address #String)
		#('PTBYTE' #pointer #short)
		#('PTCHAR' #pointer #wchar)
		#('PTSTR' #pointer #WideString)
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
		#('PWSTR' #address #WideString)
		#('QWORD' #large)
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

{ #category : #offsets }
CStructField >> alignAfter: displacement [
	offset := displacement ceiling alignedTo: alignment
]

{ #category : #accessing }
CStructField >> alignment [
	^alignment
]

{ #category : #accessing }
CStructField >> alignment: anInteger [
	alignment := anInteger
]

{ #category : #enumeration }
CStructField >> allFieldOffsets [
	| array |
	array := self namesAndOffsets.
	array
		select: [:assoc | | pair |
			pair := assoc key.
			pair first != pair second and: [pair second beginsWith: '_']]
		thenDo: [:assoc | | pair |
			pair := assoc key.
			pair at: 2 put: pair second allButFirst].
	^array
]

{ #category : #enumeration }
CStructField >> allFields [
	^self isUnnamedStruct ifTrue: [type allFields] ifFalse: [{self}]
]

{ #category : #converting }
CStructField >> asField [
	^self
]

{ #category : #private }
CStructField >> beConflictive [
	conflictive := true
]

{ #category : #methods }
CStructField >> getterBody: varname [
	^type getterBodyFor: varname
]

{ #category : #metaprogramming }
CStructField >> getterSourceNamed: aString [
	^self subclassResponsibility
]

{ #category : #initialization }
CStructField >> initialize [
	super initialize.
	conflictive := false
]

{ #category : #private }
CStructField >> isConflictive [
	^conflictive
]

{ #category : #enumeration }
CStructField >> isUnnamed [
	^name = ''
]

{ #category : #enumeration }
CStructField >> isUnnamedStruct [
	^type isUnnamedStruct
]

{ #category : #accessing }
CStructField >> loadIn: aCStruct [
	type loadFields
]

{ #category : #accessing }
CStructField >> name [
	^name
]

{ #category : #accessing }
CStructField >> name: aString [
	name := aString
]

{ #category : #enumeration }
CStructField >> namesAndOffsets [
	^self isUnnamedStruct
		ifTrue: [
			type namesAndOffsets
				collect: [:a | {a key first. name , '_' , a key second}
					-> (a value + offset)]]
		ifFalse: [{{name. name} -> offset}]
]

{ #category : #accessing }
CStructField >> offset [
	^offset
]

{ #category : #accessing }
CStructField >> offset: anInteger [
	offset := anInteger
]

{ #category : #accessing }
CStructField >> pack: anInteger [
	alignment := alignment min: anInteger
]

{ #category : #printing }
CStructField >> printOffsetOn: aStream [
	aStream nextPutAll: '; // '; nextPutAll: offset printString
]

{ #category : #printing }
CStructField >> printOffsetTextOn: rtf [
	| painter |
	painter := PaintingVisitor new.
	rtf
		append: ';';
		useColor: painter commentColor
		while: [rtf append: ' // '; append: offset printString].
	self haltWhen: type = true.
	type isUnresolved
		ifTrue: [rtf
			useColor: painter undefinedColor
			while: [rtf append: ' <- UNRESOLVED']]
]

{ #category : #printing }
CStructField >> printOn: aStream [
	type
		ifNil: [^aStream nextPutAll: 'incomplete struct field ''' , name , ''''].
	self printOn: aStream indent: 0
]

{ #category : #printing }
CStructField >> printOn: aStream indent: n [
	self isUnnamedStruct
		ifTrue: [type printOn: aStream indent: n + 1]
		ifFalse: [aStream nextPutAll: type name].
	aStream space; nextPutAll: name
]

{ #category : #printing }
CStructField >> printTextOn: rtf [
	self printTextOn: rtf indent: 0
]

{ #category : #printing }
CStructField >> printTextOn: rtf indent: n [
	| painter |
	painter := PaintingVisitor new.
	self isUnnamedStruct
		ifTrue: [type printTextOn: rtf indent: n]
		ifFalse: [rtf
			useColor: painter sharedVarColor
			while: [rtf nextPutAll: type name]].
	rtf
		space;
		useColor: painter commentColor muchDarker while: [rtf append: name]
]

{ #category : #accessing }
CStructField >> removeIndirectionsFromName [
	"
	our parser does not distinguish * symbols from field names, so we manually split them here
	"
	| pointer |
	pointer := name select: [:ch | ch = $*].
	name := name allButFirst: pointer size.
	^pointer
]

{ #category : #accessing }
CStructField >> sizeInBytes [
	^type sizeInBytes
]

{ #category : #accessing }
CStructField >> type [
	^type
]

{ #category : #accessing }
CStructField >> type: aCType [
	type := aCType pointer: self removeIndirectionsFromName.
	alignment := type naturalAlignment
]

