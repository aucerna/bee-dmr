Class {
	#name : #CStruct,
	#superclass : #CType,
	#instVars : [
		'name',
		'fields',
		'size',
		'type',
		'alignment'
	],
	#category : #C
}

{ #category : #accessing }
CStruct class >> forWordSize: anInteger [
	^self new wordSize: anInteger
]

{ #category : #accessing }
CStruct >> alignment [
	^alignment
]

{ #category : #enumeration }
CStruct >> allFieldNamesDo: aBlock [
	self allFields with: self allFieldOffsets do: [:field :assoc | | identifier |
		identifier := field isConflictive
			ifTrue: [assoc key second]
			ifFalse: [assoc key first].
		aBlock value: field value: identifier]
]

{ #category : #enumeration }
CStruct >> allFieldOffsets [
	^fields gather: [:child | child allFieldOffsets]
]

{ #category : #enumeration }
CStruct >> allFields [
	^fields gather: [:field | field allFields]
]

{ #category : #converting }
CStruct >> asField [
	^SingleStructField new name: ''; type: self
]

{ #category : #metaprograming }
CStruct >> compileAccessors [
	| class |
	class := self classBinding.
	self allFieldNamesDo: [:f :fullname | | getter setter |
		(class >> fullname asSymbol) isNil ifTrue: [
			getter := f getterSourceNamed: fullname.
			class project changes compile: getter in: class category: #accessing].
		(class >> (fullname , ':') asSymbol) isNil ifTrue: [
			setter := f setterSourceNamed: fullname.
			class project changes compile: setter in: class category: #accessing]]
]

{ #category : #metaprograming }
CStruct >> compileSizeInBytes [
	| class |
	class := self classBinding.
	class project changes
		compile: 'sizeInBytes
	^sizeInBytes'
		in: class class
		category: #accessing
]

{ #category : #offsets }
CStruct >> computeLayout [
	| position |
	position := 0.
	fields do: [:f | 
		f alignAfter: position.
		position := f offset + f sizeInBytes].
	size := position ceiling alignedTo: alignment
]

{ #category : #private }
CStruct >> conflictiveFields [
	| groups |
	groups := self allFields groupBy: #name.
	^groups gather: [:group | group size > 1 ifTrue: [group] ifFalse: [#()]]
]

{ #category : #accessing }
CStruct >> fields [
	^fields
]

{ #category : #accessing }
CStruct >> fields: aCollection [
	fields := aCollection
]

{ #category : #metaprograming }
CStruct >> generate [
	self writeOffsets; compileAccessors; compileSizeInBytes
]

{ #category : #testing }
CStruct >> isPacked [
	^binding notNil and: [binding hasArbitraryAlignment]
]

{ #category : #printing }
CStruct >> isStruct [
	^true
]

{ #category : #printing }
CStruct >> isUnnamed [
	^name = ''
]

{ #category : #testing }
CStruct >> isUnnamedStruct [
	^self isUnnamed
]

{ #category : #testing }
CStruct >> isUnresolved [
	^fields anySatisfy: [:field | 
		self haltWhen: field type = true.
		field type isUnresolved]
]

{ #category : #accessing }
CStruct >> keyword [
	^'structureAtOffset:'
]

{ #category : #accessing }
CStruct >> literals [
	^Array
		streamContents: [:strm | self allFields
			do: [:f | strm nextPut: f type name]]
]

{ #category : #accessing }
CStruct >> loadFields [
	fields do: [:field | field loadIn: self].
	self isPacked
		ifTrue: [
			alignment := binding alignment.
			fields do: [:field | field pack: alignment]]
		ifFalse: [alignment := self naturalAlignment].
	self computeLayout
]

{ #category : #accessing }
CStruct >> name [
	^name
]

{ #category : #accessing }
CStruct >> name: aString [
	name := aString.
	binding := Smalltalk at: name asSymbol ifAbsent: [| prefix classname |
		prefix := #('_' 'tag') detect: [:h | name beginsWith: h] ifNone: [^self].
		classname := name allButFirst: prefix size.
		Smalltalk at: classname asSymbol ifAbsent: [
			(classname endsWith: 'W')
				ifTrue: [Smalltalk at: classname allButLast asSymbol ifAbsent: nil]]]
]

{ #category : #enumeration }
CStruct >> namesAndOffsets [
	^fields gather: [:child | child namesAndOffsets]
]

{ #category : #offsets }
CStruct >> naturalAlignment [
	^fields isEmpty ifTrue: [1] ifFalse: [fields maxValue: [:f | f alignment]]
]

{ #category : #metaprograming }
CStruct >> offsets [
	| dict |
	dict := PoolDictionary new.
	self writeOffsetsOn: dict.
	^String streamContents: [:strm | 
		strm nextPutAll: 'offsets64'; crtab; nextPutAll: '^PoolDictionary new'.
		dict keysAndValuesDo: [:k :v | 
			strm
				crtab: 2;
				nextPutAll: 'at: ';
				nextPutAll: k printString;
				nextPutAll: ' put: ';
				nextPutAll: v asString;
				nextPut: $;].
		strm crtab: 2; nextPutAll: 'yourself']
]

{ #category : #metaprograming }
CStruct >> offsets64 [
	self ASSERT: translator wordSize = 8.
	^self offsets
]

{ #category : #metaprograming }
CStruct >> offsets64Source [
	| dict |
	dict := PoolDictionary new.
	self writeOffsetsOn: dict.
	^String streamContents: [:strm | 
		strm nextPutAll: '^PoolDictionary new'.
		dict keysAndValuesDo: [:k :v | 
			strm
				crtab: 2;
				nextPutAll: 'at: ';
				nextPutAll: k storeString;
				nextPutAll: ' put: ';
				nextPutAll: v storeString;
				nextPut: $;].
		strm crtab: 2; nextPutAll: 'yourself']
]

{ #category : #offsets }
CStruct >> pack: anInteger [
	alignment := alignment min: anInteger
]

{ #category : #printing }
CStruct >> printMainOn: aStream indent: n [
	aStream nextPutAll: self typeTitle.
	name notNil ifTrue: [aStream space; nextPutAll: name].
	aStream nextPutAll: ' {'; cr.
	fields do: [:field | 
		aStream tab: n + 1.
		field printOn: aStream indent: n + 1.
		aStream cr].
	aStream tab: n; nextPut: $}
]

{ #category : #printing }
CStruct >> printMainTextOn: rtf indent: n [
	rtf useColor: Color blue while: [rtf append: self typeTitle].
	name notNil ifTrue: [rtf space; append: name].
	rtf nextPutAll: ' {'.
	fields do: [:field | 
		rtf crtab: n + 1.
		field printTextOn: rtf indent: n + 1].
	rtf crtab: n; nextPut: $}
]

{ #category : #printing }
CStruct >> printOn: aStream [
	self printOn: aStream indent: 0
]

{ #category : #printing }
CStruct >> printOn: aStream indent: n [
	self printMainOn: aStream indent: n
]

{ #category : #printing }
CStruct >> printSizeOn: aStream [
	aStream nextPutAll: ' // sizeInBytes = '
]

{ #category : #printing }
CStruct >> printSizeTextOn: rtf [
	| painter |
	painter := PaintingVisitor new.
	rtf
		useColor: painter commentColor
		while: [rtf append: ' // sizeInBytes = '; append: size printString]
]

{ #category : #printing }
CStruct >> printTextOn: rtf [
	self printTextOn: rtf indent: 0
]

{ #category : #printing }
CStruct >> printTextOn: rtf indent: n [
	self printMainTextOn: rtf indent: n
]

{ #category : #inspecting }
CStruct >> refersToStruct [
	^true
]

{ #category : #metaprograming }
CStruct >> registerConflicts [
	self conflictiveFields do: #beConflictive
]

{ #category : #accessing }
CStruct >> selectors [
	^Array
		streamContents: [:strm | self allFields
			do: [:f | strm nextPut: f name asSymbol]]
]

{ #category : #accessing }
CStruct >> sizeExpression [
	^'sizeInBytes'
]

{ #category : #accessing }
CStruct >> sizeInBytes [
	^size
]

{ #category : #printing }
CStruct >> typeTitle [
	^'struct'
]

{ #category : #metaprograming }
CStruct >> writeOffsets [
	| class offsets dict original |
	class := self classBinding.
	(class classVariables includesKey: 'Offsets')
		ifFalse: [class addClassVarNamed: 'Offsets'].
	offsets := class classVariables at: 'Offsets'.
	original := offsets copy.
	offsets isNil
		ifTrue: [offsets := class classVariables
			at: 'Offsets'
			put: PoolDictionary new].
	dict := PoolDictionary new.
	self writeOffsetsOn: dict.
	offsets addAll: dict associations.
	offsets keys
		reject: [:k | dict includesKey: k]
		thenDo: [:k | offsets removeKey: k].
	offsets = original ifFalse: [
		class project changes
			evaluate: class name , ' typedef baseType writeOffsets']
]

{ #category : #metaprograming }
CStruct >> writeOffsets64 [
	| class source offsets |
	class := self classBinding.
	source := self offsets64Source.
	offsets := Compiler evaluate: source.
	class offsets != offsets ifTrue: [
		class project changes
			compile: 'offsets64
' , source
			in: class class
			category: #accessing]
]

{ #category : #offsets }
CStruct >> writeOffsetsOn: aPoolDictionary [
	self allFields with: self allFieldOffsets do: [:f :assoc | | identifier |
		identifier := f isConflictive
			ifTrue: [assoc key second]
			ifFalse: [assoc key first].
		aPoolDictionary at: identifier put: assoc value].
	aPoolDictionary at: 'sizeInBytes' put: self sizeInBytes
]

