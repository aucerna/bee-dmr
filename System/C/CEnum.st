Class {
	#name : #CEnum,
	#superclass : #CType,
	#instVars : [
		'name',
		'enumerators'
	],
	#category : #C
}

{ #category : #accessing }
CEnum >> addAll: definitions [
	| current |
	current := 0.
	definitions do: [:assoc | | value |
		value := assoc value ifNil: current.
		self at: assoc key put: value.
		current := value + 1]
]

{ #category : #accessing }
CEnum >> associations [
	^enumerators associations
]

{ #category : #accessing }
CEnum >> at: aString [
	^enumerators at: aString
]

{ #category : #accessing }
CEnum >> at: aString put: anInteger [
	enumerators at: aString put: anInteger
]

{ #category : #accessing }
CEnum >> generate: aClass [
	| pool constants source |
	pool := (aClass respondsTo: #constantsPoolName)
		ifTrue: [aClass constantsPoolName]
		ifFalse: [aClass name , 'Constants'].
	(aClass classVariables includesKey: pool)
		ifFalse: [aClass addClassVarNamed: pool].
	constants := aClass classVarNamed: pool.
	constants isNil
		ifTrue: [constants := aClass classVariables
			at: pool
			put: PoolDictionary new].
	source := self initializeConstantsSource: pool.
	aClass class compile: source.
	aClass perform: self initializerName asSymbol
]

{ #category : #accessing }
CEnum >> initialize [
	super initialize.
	enumerators := OrderedDictionary new.
	name := ''
]

{ #category : #accessing }
CEnum >> initializeConstantsSource: poolname [
	^String streamContents: [:strm | 
		strm nextPutAll: self initializerName; crtab; nextPutAll: poolname.
		enumerators keysAndValuesDo: [:k :v | 
			strm
				crtab: 2;
				nextPutAll: 'at: ';
				nextPutAll: k storeString;
				nextPutAll: ' put: ';
				nextPutAll: v storeString;
				nextPut: $;].
		strm crtab: 2; nextPutAll: 'yourself']
]

{ #category : #accessing }
CEnum >> initializerName [
	^'initialize' , self name , 'Constants'
]

{ #category : #accessing }
CEnum >> keys [
	^enumerators keys
]

{ #category : #accessing }
CEnum >> name [
	^name
]

{ #category : #accessing }
CEnum >> name: aString [
	name := aString
]

{ #category : #accessing }
CEnum >> printOn: aStream [
	aStream nextPutAll: self class name; space; nextPutAll: name
]

{ #category : #accessing }
CEnum >> printTextOn: rtf [
	self printTextOn: rtf indent: 0
]

{ #category : #accessing }
CEnum >> printTextOn: rtf indent: n [
	| painter |
	painter := PaintingVisitor new.
	rtf
		tab: n;
		nextPutAll: 'enum ';
		useColor: painter instVarColor while: [rtf nextPutAll: name];
		nextPutAll: ' {';
		crtab: n + 1.
	self associations
		do: [:assoc | | prefix |
			prefix := assoc value < 0 ifTrue: ['-0x'] ifFalse: ['0x'].
			rtf
				useColor: painter sharedVarColor while: [rtf nextPutAll: assoc key];
				nextPutAll: ' = ';
				nextPutAll: prefix;
				nextPutAll: (assoc value hex: 1)]
		separatedBy: [
			rtf
				nextPut: $,;
				crtab: n + 1].
	rtf crtab: n; nextPutAll: '};'
]

{ #category : #accessing }
CEnum >> sizeInBytes [
	^4
]

{ #category : #accessing }
CEnum >> values [
	^enumerators values asArray
]

