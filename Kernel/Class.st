Class {
	#name : #Class,
	#superclass : #Species,
	#instVars : [
		'#name',
		'#subclasses',
		'#classVariables',
		'#sharedPools'
	],
	#category : #Kernel
}

{ #category : #services }
Class >> beDeleted [
	| behavior md |
]

{ #category : #private }
Class >> beNamed: aSymbol in: aSmalltalkSystem [
	| symbol assoc |
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
]

{ #category : #services }
Class >> duplicate [
	| copy meta md |
]

{ #category : #services }
Class >> duplicateHierarchy [
	| copy |
]

{ #category : #services }
Class >> duplicateHierarchyFrom: aClass with: aClassCopy [
	| copy |
]

{ #category : #accessing }
Class >> fillFrom: aClass [
	| cvars pools |
]

{ #category : #testing }
Class >> hasSubclasses [
	^self subclasses size > 0
]

{ #category : #initialization }
Class >> initializeFrom: aSpecies [
	| md |
	format := Object format.
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
]

{ #category : #accessing }
Class >> pointer: pointers variable: variable [
	| flags bits |
]

{ #category : #removing }
Class >> removeFromSystem [
	self allInstances notEmpty
]

{ #category : #'add/remove' }
Class >> removeSubclass: aClass [
	subclasses isNil ifTrue: [^self].
]

{ #category : #accessing }
Class >> sharedPools [
	sharedPools isNil ifTrue: [^Array new].
]

{ #category : #accessing }
Class >> sharedPools: aCollection [
	sharedPools := aCollection isEmpty
]

{ #category : #accessing }
Class >> subclasses [
	subclasses isNil ifTrue: [^#()].
]

{ #category : #accessing }
Class >> subclasses: aCollection [
	subclasses := aCollection isEmpty ifFalse: [aCollection asArray]
]

{ #category : #queries }
Class >> subclassesDo: aBlock [
	subclasses isNil ifTrue: [^self].
]

{ #category : #accessing }
Class >> subspecies [
	subclasses isNil ifTrue: [^#()].
]

{ #category : #queries }
Class >> subspeciesDo: aBlock [
	subclasses isNil ifTrue: [^self].
]

{ #category : #accessing }
Class >> symbol [
	^name
]
