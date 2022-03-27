"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Class,
	#superclass : #Species,
	#instVars : [
		'name',
		'subclasses',
		'classVariables',
		'sharedPools',
		'module'
	],
	#category : #Kernel
}


{ #category : #lookup }
Class >> _lookupName: aSymbol [
	| current vars result |
	current := self.
	[ 
		vars := current classVariables.
		vars == nil ifFalse: [
			result := vars _namespaceLookup: aSymbol.
			result == nil ifFalse: [^result].
		].
		current := current superclass.
		current == nil] whileFalse.
	^module _namespaceLookup: aSymbol.
]


{ #category : #services }
Class >> beDeleted [
	| behavior md |
	self behavior: DeletedClass instanceBehavior.
	name := ('Deleted ' , self symbol) asSymbol.
	behavior := self instanceBehavior.
	md := MethodDictionary new.
	self withAllSuperclasses reverseDo: [:c | 
		c selectors do: [:s | | cm |
			cm := c >> s.
			cm notNil ifTrue: [md at: s put: cm]]].
	behavior methods: md; next: nil.
	instanceVariables := self allInstVarNames.
	superclass := ProtoObject
]

{ #category : #private }
Class >> beNamed: aSymbol in: aSmalltalkSystem [
	| symbol assoc |
	symbol := aSymbol asSymbol.
	assoc := aSmalltalkSystem associationClass key: symbol value: self.
	aSmalltalkSystem basicAdd: assoc.
	name := symbol
]

{ #category : #services }
Class >> beSubclassOf: aClass [
	self installer superclass: aClass; install
]

{ #category : #testing }
Class >> canBeDeleted [
	^self !== Class
]

{ #category : #accessing }
Class >> classVariables [
	classVariables isNil ifTrue: [^Dictionary new].
	^classVariables
]

{ #category : #accessing }
Class >> classVarNamed: aString put: anObject [
	^classVariables at: aString put: anObject
]

{ #category : #accessing }
Class >> classVarNames [
	^classVariables isNil ifTrue: [Set new] ifFalse: [classVariables keys]
]

{ #category : #accessing }
Class >> classVarNames: aCollection [
	| cvars |
	cvars := Dictionary new.
	classVariables ifNil: [classVariables := cvars].
	aCollection do: [:k | | assoc |
		assoc := classVariables associationAt: k ifAbsent: [k -> nil].
		cvars add: assoc].
	classVariables := cvars isEmpty ifFalse: [cvars]
]

{ #category : #accessing }
Class >> comment [
	^self organization isNil ifTrue: [''] ifFalse: [self organization comment]
]

{ #category : #accessing }
Class >> comment: aString [
	self organization comment: aString
]

{ #category : #removing }
Class >> delete [
	self canBeDeleted
		ifFalse: [self error: 'System Classes cannot be removed.'].
	Smalltalk removeClass: self
]

{ #category : #services }
Class >> duplicate [
	| copy meta md |
	copy := self objectShallowCopy buildBehavior.
	md := copy methodDictionary.
	md keysAndValuesDo: [:selector :method | md at: selector put: method copy].
	meta := self class objectShallowCopy instanceClass: copy; buildBehavior.
	md := meta methodDictionary.
	md keysAndValuesDo: [:selector :method | md at: selector put: method copy].
	copy behavior: meta instanceBehavior; subclasses: #().
	^copy
]

{ #category : #services }
Class >> duplicateHierarchy [
	| copy |
	copy := self duplicate.
	self subspecies do: [:s | | child |
		child := s duplicateHierarchyFrom: self with: copy.
		child basicBeSubclassOf: copy].
	^copy
]

{ #category : #services }
Class >> duplicateHierarchyFrom: aClass with: aClassCopy [
	| copy |
	self == aClass ifTrue: [^aClassCopy].
	copy := self duplicate.
	self subspecies do: [:s | | child |
		child := s duplicateHierarchyFrom: aClass with: aClassCopy.
		child basicBeSubclassOf: copy].
	^copy
]

{ #category : #accessing }
Class >> fillFrom: aClass [
	| cvars pools |
	super fillFrom: aClass.
	self == aClass ifTrue: [^self].
	cvars := aClass classVariables.
	classVariables := cvars notEmpty ifTrue: [cvars].
	pools := aClass sharedPools.
	sharedPools := pools notEmpty ifTrue: [pools].
	self class fillFrom: aClass class
]

{ #category : #testing }
Class >> hasSubclasses [
	^self subclasses size > 0
]

{ #category : #initialization }
Class >> initializeFrom: aSpecies [
	| md |
	superclass := aSpecies.
	md := MethodDictionary new.
	instanceBehavior := Behavior with: md.
	instanceBehavior classBinding: self.
	format := Object format.
	superclass notNil ifTrue: [
		instanceBehavior next: superclass instanceBehavior.
		format := superclass format]
]

{ #category : #accessing }
Class >> instanceClass [
	^self
]

{ #category : #testing }
Class >> isClass [
	^true
]

{ #category : #testing }
Class >> isDeleted [
	^false
]

{ #category : #accessing }
Class >> name [
	^name asString
]

{ #category : #accessing }
Class >> name: aSymbol [
	name := aSymbol asSymbol
]

{ #category : #testing }
Class >> needsReinstallation [
	self hasClassBehavior ifFalse: [^true].
	superclass isNil ifTrue: [^false].
	self instSize - self instVarNames size = superclass instSize
		ifFalse: [^true].
	self class instSize - self class instVarNames size
		= self class superclass instSize
		ifFalse: [^true].
	^self installer shouldRecomputeBehavior
]

{ #category : #accessing }
Class >> pointer: pointers variable: variable [
	| flags bits |
	flags := 0.
	variable ifTrue: [flags := flags | Variable].
	format := pointers
		ifTrue: [
			flags := flags | Pointers.
			flags | self instSize]
		ifFalse: [flags].
	variable ifTrue: [
		bits := Variable | Pointers.
		flags := flags & bits.
		self allSubclasses
			do: [:cls | cls format: cls format & bits bitInvert | flags]]
]

{ #category : #removing }
Class >> removeFromSystem [
	self allInstances notEmpty
		ifTrue: [^self error: 'There are instances of this class'].
	self delete
]

{ #category : #'add/remove' }
Class >> removeSubclass: aClass [
	subclasses isNil ifTrue: [^self].
	subclasses := subclasses copyWithout: aClass
]

{ #category : #accessing }
Class >> sharedPools [
	sharedPools isNil ifTrue: [^Array new].
	^sharedPools
]

{ #category : #accessing }
Class >> sharedPools: aCollection [
	sharedPools := aCollection isEmpty
		ifFalse: [aCollection asSet asArray collect: #asSymbol]
]

{ #category : #accessing }
Class >> subclasses [
	subclasses isNil ifTrue: [^#()].
	^name == #Class
		ifTrue: [subclasses reject: [:s | s isMetaclass]]
		ifFalse: [subclasses]
]

{ #category : #accessing }
Class >> subclasses: aCollection [
	subclasses := aCollection isEmpty ifFalse: [aCollection asArray]
]

{ #category : #queries }
Class >> subclassesDo: aBlock [
	subclasses isNil ifTrue: [^self].
	subclasses
		select: [:cls | cls notNil]
		thenDo: [:c | aBlock evaluateWith: c]
]

{ #category : #accessing }
Class >> subspecies [
	subclasses isNil ifTrue: [^#()].
	^subclasses
]

{ #category : #queries }
Class >> subspeciesDo: aBlock [
	subclasses isNil ifTrue: [^self].
	self subspecies do: aBlock
]

{ #category : #accessing }
Class >> symbol [
	^name
]

