Class {
	#name : #Species,
	#superclass : #Object,
	#instVars : [
		'#superclass',
		'#instanceBehavior',
		'#format',
		'#organization',
		'#instanceVariables'
	],
	#classVars : [
		'#Flags'
	],
	#category : #Kernel
}

{ #category : #initialization }
Species class >> initialize [
	Flags
]

{ #category : #initialization }
Species class >> maxInstVarCount [
	^16r7F
]

{ #category : #testing }
Species >> _instancesAreArrayed [
	^format & Variable = Variable
]

{ #category : #testing }
Species >> _instancesAreFixed [
	^format & Variable = 0
]

{ #category : #testing }
Species >> _instancesHavePointers [
	^format & Pointers != 0
]

{ #category : #accessing }
Species >> >> aSelector [
	^self compiledMethodAt: aSelector
]

{ #category : #'add/remove' }
Species >> addSelector: aSymbol withMethod: aCompiledMethod [
	| selector |
]

{ #category : #hierarchy }
Species >> addSubclass: aClass [
	| copy |
]

{ #category : #queries }
Species >> allClassVarNames [
	^(self withAllSuperclasses reversed gather: [:cls | cls classVarNames]) asArray
]

{ #category : #private }
Species >> allExistingInstances [
	^Memory current allInstancesOf: self
]

{ #category : #instances }
Species >> allInstances [
	^[
]

{ #category : #queries }
Species >> allInstVarNames [
	^(self withAllSuperclasses reversed gather: [:class | class instVarNames]) asArray
]

{ #category : #'instance creation' }
Species >> allocate: byteSize size: size [
	| headerSize totalSize buffer object extended |
]

{ #category : #queries }
Species >> allSubclasses [
	| all |
]

{ #category : #queries }
Species >> allSubclassesDo: aBlock [
	self subclassesDo: [:class | 
]

{ #category : #queries }
Species >> allSubinstances [
	| subinstances |
]

{ #category : #queries }
Species >> allSubspecies [
	| all |
]

{ #category : #queries }
Species >> allSubspeciesDo: aBlock [
	self subspeciesDo: [:class | 
]

{ #category : #queries }
Species >> allSuperclasses [
	| superclasses |
]

{ #category : #queries }
Species >> allSuperclassesDo: aBlock [
	superclass isNil ifTrue: [^self].
]

{ #category : #'instance creation' }
Species >> basicNew [
	^self _instancesAreArrayed
]

{ #category : #'instance creation' }
Species >> basicNew: anInteger [
	^self primitiveNew: anInteger
]

{ #category : #flags }
Species >> bePointers [
	format := Pointers + self instSize
]

{ #category : #services }
Species >> browse [
	Smalltalk browsingTools browse: self
]

{ #category : #services }
Species >> buildBehavior [
	| behavior |
]

{ #category : #testing }
Species >> canUnderstand: aSymbol [
	^instanceBehavior implements: aSymbol
]

{ #category : #organization }
Species >> categories [
	^self organization notNil
]

{ #category : #organization }
Species >> categorizedSelectors [
	^self organization notNil
]

{ #category : #inquiries }
Species >> categoryFor: selector [
	| category |
]

{ #category : #inquiries }
Species >> classImplementing: aSymbol [
	(self methodDictionary includesKey: aSymbol) ifTrue: [^self].
]

{ #category : #accessing }
Species >> classVariableAssociationAt: aString [
	| c assoc |
]

{ #category : #accessing }
Species >> classVariableString [
	| stream |
]

{ #category : #accessing }
Species >> compiledMethodAt: aSymbol [
	^self methodDictionary at: aSymbol ifAbsent: nil
]

{ #category : #copying }
Species >> deepCopy [
	^self
]

{ #category : #inquiries }
Species >> depth [
	"
]

{ #category : #errors }
Species >> errorNotIndexable [
	^self error: 'Instances of ' , self name , ' are not indexable'
]

{ #category : #accessing }
Species >> fillFrom: aClass [
	| ivars |
]

{ #category : #accessing }
Species >> format [
	^format
]

{ #category : #accessing }
Species >> format: anInteger [
	format := anInteger
]

{ #category : #organization }
Species >> hasUnclassifiedSelectors [
	^self categorizedSelectors size < self methodDictionary size
]

{ #category : #testing }
Species >> includesSelector: aSymbol [
	^self methodDictionary includesKey: aSymbol
]

{ #category : #inquiries }
Species >> inheritsFrom: aClass [
	| class |
]

{ #category : #initialization }
Species >> initializeOrganization [
	self
]

{ #category : #accessing }
Species >> instanceBehavior [
	^instanceBehavior
]

{ #category : #private }
Species >> instanceBehavior: aBehavior [
	instanceBehavior := aBehavior
]

{ #category : #testing }
Species >> instancesAreArrayed [
	^self _instancesAreArrayed
]

{ #category : #testing }
Species >> instancesHavePointers [
	^self _instancesHavePointers
]

{ #category : #services }
Species >> instanceVariableString [
	^String streamContents: [:strm | 
]

{ #category : #inquiries }
Species >> instSize [
	^format & 16r7F
]

{ #category : #services }
Species >> instVarNames [
	instanceVariables isNil ifTrue: [^#()].
]

{ #category : #accessing }
Species >> instVarNames: aCollection [
	instanceVariables := aCollection isEmpty ifFalse: [aCollection asArray].
]

{ #category : #testing }
Species >> isBytes [
	^self _instancesHavePointers not
]

{ #category : #testing }
Species >> isCategorized [
	^self organization notNil
]

{ #category : #testing }
Species >> isSpecies [
	^true
]

{ #category : #testing }
Species >> isVariable [
	^self _instancesAreArrayed
]

{ #category : #services }
Species >> kindOfSubclass [
	self _instancesAreFixed ifTrue: [^'subclass:'].
]

{ #category : #private }
Species >> memory [
	^Memory current
]

{ #category : #accessing }
Species >> methodDictionary [
	^instanceBehavior methods
]

{ #category : #queries }
Species >> methodsReadingInstVar: aString [
	| methods index |
]

{ #category : #queries }
Species >> methodsReferencingClassVar: aString [
	| methods assoc |
]

{ #category : #queries }
Species >> methodsReferencingInstVar: aString [
	| methods index |
]

{ #category : #queries }
Species >> methodsWritingInstVar: aString [
	| methods index |
]

{ #category : #'instance creation' }
Species >> new [
	^self _instancesAreArrayed
]

{ #category : #'instance creation' }
Species >> new: anInteger [
	^self primitiveNew: anInteger
]

{ #category : #'instance creation' }
Species >> nil: size slotsOf: object [
	object _nilSlots: size
]

{ #category : #organization }
Species >> organization [
	organization isNil ifTrue: [self initializeOrganization].
]

{ #category : #organization }
Species >> organization: aClassOrganizer [
	organization := aClassOrganizer
]

{ #category : #unclassified }
Species >> primitiveNew [
	| size byteSize headerSize totalSize buffer object |
]

{ #category : #unclassified }
Species >> primitiveNew: size [
	size _isSmallInteger ifFalse: [self error: 'invalid size'].
]

{ #category : #unclassified }
Species >> primitiveNewBytes: size [
	| object padded |
]

{ #category : #unclassified }
Species >> primitiveNewPointers: size [
	| object |
]

{ #category : #printing }
Species >> printOn: aStream [
	aStream nextPutAll: self name
]

{ #category : #'add/remove' }
Species >> removeSelector: aSymbol [
	self methodDictionary removeKey: aSymbol ifAbsent: [].
]

{ #category : #'add/remove' }
Species >> removeSubclass: aClass [
	"
]

{ #category : #accessing }
Species >> selectors [
	^self methodDictionary keys
]

{ #category : #queries }
Species >> selectorsInCategory: aSymbol [
	^self organization selectorsFor: aSymbol
]

{ #category : #copying }
Species >> shallowCopy [
	^self
]

{ #category : #services }
Species >> sharedPoolsString [
	| stream |
]

{ #category : #inquiries }
Species >> shouldBeHidden: aSymbol [
	^false
]

{ #category : #accessing }
Species >> superclass [
	^superclass
]

{ #category : #accessing }
Species >> superclass: aClass [
	superclass := aClass
]

{ #category : #accessing }
Species >> timestamp [
	^organization notNil ifTrue: [organization timestamp]
]

{ #category : #services }
Species >> updateClassifications [
	organization notNil ifTrue: [organization updateOn: self]
]

{ #category : #private }
Species >> updateInstSize [
	| size |
]

{ #category : #queries }
Species >> withAllSubclasses [
	^OrderedCollection with: self withAll: self allSubclasses
]

{ #category : #enumerating }
Species >> withAllSubclassesDo: aBlock [
	aBlock evaluateWith: self.
]

{ #category : #queries }
Species >> withAllSubspecies [
	^OrderedCollection with: self withAll: self allSubspecies
]

{ #category : #queries }
Species >> withAllSuperclasses [
	^OrderedCollection with: self withAll: self allSuperclasses
]

{ #category : #enumerating }
Species >> withAllSuperclassesDo: aBlock [
	aBlock evaluateWith: self.
]

{ #category : #'instance creation' }
Species >> zero: size bytesOf: object [
	object _zeroSlots: (size bitShift: 0 - WordSizeShift)
]
