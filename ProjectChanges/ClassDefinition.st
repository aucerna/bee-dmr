"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassDefinition,
	#superclass : #ClassChange,
	#instVars : [
		'definition',
		'prev',
		'information'
	],
	#category : #ProjectChanges
}

{ #category : #'instance creation' }
ClassDefinition class >> className: nameString definition: definitionString [
	^ self new
		className: nameString;
		definition: definitionString]

{ #category : #'instance creation' }
ClassDefinition class >> fromClass: aClass [
	^self new class: aClass; project: aClass project]

{ #category : #'instance creation' }
ClassDefinition class >> referenceFor: aClass [
	^{self. aClass name}]

{ #category : #'behavior protocol' }
ClassDefinition >> >> selector [
	^self compiledMethodAt: selector]

{ #category : #testing }
ClassDefinition >> acceptsAsPrev: aChangeRecord [
	^className = aChangeRecord className
		and: [aChangeRecord isKindOf: ClassDefinition]]

{ #category : #'behavior protocol' }
ClassDefinition >> addSelector: selector withMethod: method [
	^self compiledMethods at: selector put: method]

{ #category : #accessing }
ClassDefinition >> addToProject: aBeeModule [
	aBeeModule addClassDefinition: self]

{ #category : #'behavior protocol' }
ClassDefinition >> allInstVarNames [
	| ivars |
	ivars := self instVarNames.
	self allSuperclasses do: [:cls | ivars := cls instVarNames , ivars].
	^ivars]

{ #category : #metaprogramming }
ClassDefinition >> allLocalPools [
	^self currentVersion ifNil: [#()] ifNotNil: [:c | c allLocalPools]]

{ #category : #'behavior protocol' }
ClassDefinition >> allSharedPools [
	^self superclass
		ifNil: [self poolDictionaries]
		ifNotNil: [:cls | cls allSharedPools & self poolDictionaries]]

{ #category : #accessing }
ClassDefinition >> allSubclasses [
	^(self resolveClass ifNil: [^#()]) allSubclasses]

{ #category : #'behavior protocol' }
ClassDefinition >> allSuperclasses [
	| superclasses |
	superclasses := OrderedCollection new.
	self superclass
		ifNotNil: [:superclass | superclasses
			add: superclass;
			addAll: superclass allSuperclasses].
	^superclasses]

{ #category : #perform }
ClassDefinition >> basicPerform [
	| answer class |
	class := Smalltalk classNamed: className.
	(class notNil and: [class isCategorized]) ifTrue: [| link |
		link := class project == self project
			ifTrue: [class changeLink]
			ifFalse: [self projectChanges prevTo: self].
		link notNil ifTrue: [prev := link].
		self prevChange isNil ifTrue: [prev := ClassDefinition fromClass: class]].
	answer := self evaluate: self definition.
	answer isNil ifTrue: [^nil].
	answer organization
		timestamp: timestamp;
		author: author;
		changeLink: self.
	^answer]

{ #category : #testing }
ClassDefinition >> canPerform [
	^true]

{ #category : #'behavior protocol' }
ClassDefinition >> categories [
	^self organization categories]

{ #category : #'behavior protocol' }
ClassDefinition >> categoryFor: selector [
	^(self organization categoryFor: selector) ifNil: [^ClassOrganizer default]]

{ #category : #testing }
ClassDefinition >> changesDefinition [
	| class ast1 ast2 args |
	class := self currentVersion.
	class isNil ifTrue: [^true].
	ast1 := (self parse: class definitionString) statements first.
	ast2 := (self parse: self definition) statements first.
	ast2 receiver source = ast1 receiver source ifFalse: [^true].
	args := ast1 arguments collect: #value.
	ast2 selector value keywords with: ast2 arguments do: [:s :arg | | idx equal |
		idx := ast1 selector value keywords indexOf: s ifAbsent: [^true].
		equal := (#('classVariableNames:' 'poolDictionaries:') includes: s)
			ifTrue: [(args at: idx) substrings asSet = arg value substrings asSet]
			ifFalse: [(args at: idx) = arg value].
		equal ifFalse: [^true]].
	^false]

{ #category : #testing }
ClassDefinition >> changesSomething [
	| class |
	class := self currentVersion ifNil: [^true].
	class project name = self projectName ifFalse: [^true].
	^self changesDefinition]

{ #category : #accessing }
ClassDefinition >> class: aClass [
	| organization |
	className := aClass name.
	(aClass isCategorized andNot: [
		organization := aClass organization.
		organization timestamp isNil])
		ifTrue: [
			timestamp := organization timestamp.
			author := organization author.
			prev := aClass changeLink].
	definition := aClass definitionString]

{ #category : #'behavior protocol' }
ClassDefinition >> classBinding [
	^self resolveClass ifNil: [self]]

{ #category : #'behavior protocol' }
ClassDefinition >> classImplementing: selector [
	^nil]

{ #category : #accessing }
ClassDefinition >> className: aString [
	className := aString]

{ #category : #'behavior protocol' }
ClassDefinition >> classVariables [
	| pool |
	pool := Dictionary new.
	self classVarNames do: [:n | pool at: n put: nil].
	^pool]

{ #category : #'behavior protocol' }
ClassDefinition >> classVarNames [
	| msg index |
	definition isNil ifTrue: [^''].
	msg := self parseTree statements first.
	index := msg selector keywords
		indexOf: 'classVariableNames:'
		ifAbsent: [^#()].
	^(msg arguments at: index) value]

{ #category : #'behavior protocol' }
ClassDefinition >> comment [
	^self organization comment]

{ #category : #'behavior protocol' }
ClassDefinition >> comment: aString [
	self organization comment: aString]

{ #category : #'behavior protocol' }
ClassDefinition >> compiledMethodAt: selector [
	^self compiledMethods at: selector ifAbsent: nil]

{ #category : #'behavior protocol' }
ClassDefinition >> compiledMethods [
	^self propertyAt: #compiledMethods ifAbsentPut: [Dictionary new]]

{ #category : #'file in/out' }
ClassDefinition >> completeHeaderSpec [
	| spec |
	spec := super completeHeaderSpec.
	spec add: #prev; addInformation.
	^spec]

{ #category : #perform }
ClassDefinition >> compress: changesList [
	(changesList notEmpty and: [changesList last refersTo = self refersTo])
		ifTrue: [changesList removeLast].
	changesList add: self.
	^changesList]

{ #category : #'behavior protocol' }
ClassDefinition >> configureCompiler: aCompiler [
	^self]

{ #category : #accessing }
ClassDefinition >> defaultNamespace [
	^self resolveClass
		ifNil: [Smalltalk]
		ifNotNil: [:cls | cls defaultNamespace]]

{ #category : #testing }
ClassDefinition >> definesNewClass [
	| cls |
	cls := self currentVersion.
	^cls isNil or: [
		cls imageSegment isNil and: [
			CodeImageSegment boundLibraries
				noneSatisfy: [:lib | lib includesClassNamed: className]]]]

{ #category : #accessing }
ClassDefinition >> definition [
	| file |
	definition isString ifTrue: [^definition].
	^definition isInteger
		ifTrue: [
			definition isSmallInteger
				ifFalse: [^self error: 'invalid change.log pointer'].
			file := projectChanges filename asFilename asFile.
			file isNil ifTrue: [^nil].
			file := file readStream.
			[
				file position: definition.
				file nextChunk]
				ensure: [file close]]
		ifFalse: [definition asString]]

{ #category : #accessing }
ClassDefinition >> definition: aString [
	definition := aString]

{ #category : #'behavior protocol' }
ClassDefinition >> definitionString [
	^self definition]

{ #category : #metaprogramming }
ClassDefinition >> doesNotUnderstand: aMessage [
	| s value |
	s := aMessage selector.
	(information notNil and: [
		value := information at: s ifAbsent: nil.
		value notNil])
		ifTrue: [^value].
	s arity = 1 ifFalse: [^super doesNotUnderstand: aMessage].
	information isNil ifTrue: [self initializeInformation].
	information at: s allButLast asSymbol put: aMessage arguments first]

{ #category : #'behavior protocol' }
ClassDefinition >> includesSelector: selector [
	^self selectors includes: selector]

{ #category : #accessing }
ClassDefinition >> information [
	^information]

{ #category : #accessing }
ClassDefinition >> informationAt: aSymbol [
	^information notNil ifTrue: [information at: aSymbol ifAbsent: nil]]

{ #category : #perform }
ClassDefinition >> informationAt: aSymbol put: anObject [
	information isNil ifTrue: [information := IdentityDictionary new].
	anObject isNil ifFalse: [information at: aSymbol put: anObject]]

{ #category : #initialization }
ClassDefinition >> initializeInformation [
	information := Dictionary new]

{ #category : #'behavior protocol' }
ClassDefinition >> instanceClass [
	^self project classDefinitionFor: (className upTo: $ )]

{ #category : #'behavior protocol' }
ClassDefinition >> instVarNames [
	| parseTree mssg index |
	definition isNil ifTrue: [^#()].
	parseTree := self parseTree.
	mssg := parseTree statements first.
	(index := mssg selector value keywords indexOf: 'instanceVariableNames:') = 0
		ifTrue: [^#()].
	^(mssg arguments at: index) value substrings]

{ #category : #testing }
ClassDefinition >> isClassDefinition [
	^true]

{ #category : #'behavior protocol' }
ClassDefinition >> isMetaclass [
	^className includesString: ' class']

{ #category : #'behavior protocol' }
ClassDefinition >> localPools [
	^#()]

{ #category : #perform }
ClassDefinition >> logActionWith: result [
	self setAnnotations.
	super logActionWith: result]

{ #category : #'behavior protocol' }
ClassDefinition >> name [
	^className]

{ #category : #'behavior protocol' }
ClassDefinition >> organization [
	^self propertyAt: #organization ifAbsentPut: [ClassOrganizer new]]

{ #category : #perform }
ClassDefinition >> perform [
	| answer |
	(self projectChanges includesIdentical: self) ifTrue: [^self copy perform].
	answer := super perform.
	answer notNil ifTrue: [self trackSubclasses].
	^answer]

{ #category : #perform }
ClassDefinition >> performWithBuilder: aClassBuilder [
	| answer cls |
	cls := Smalltalk at: className asSymbol ifAbsent: [].
	(cls notNil and: [cls isCategorized])
		ifTrue: [prev := cls organization position].
	answer := aClassBuilder install.
	answer isNil ifTrue: [^nil].
	definition := answer definitionString.
	answer organization timestamp: timestamp; author: author.
	self logChangeOn: SourceManager current changesWriteStream.
	self projectChanges addChange: self.
	self addToProject: self project.
	^answer]

{ #category : #'behavior protocol' }
ClassDefinition >> poolDictionaries [
	| parseTree mssg |
	definition isNil ifTrue: [^''].
	parseTree := self parseTree.
	mssg := parseTree statements first .
	^(mssg arguments at: (mssg selector value keywords indexOf: 'poolDictionaries:' ifAbsent: [^'']) ) value]

{ #category : #accessing }
ClassDefinition >> prev [
	^prev]

{ #category : #accessing }
ClassDefinition >> prev: ref [
	prev := ref]

{ #category : #'file in/out' }
ClassDefinition >> readFrom: aStream [
	definition := aStream nextChunk]

{ #category : #'squeak support' }
ClassDefinition >> readFromSqueak: aStream [
]

{ #category : #'behavior protocol' }
ClassDefinition >> removeFromSystem [
]

{ #category : #'behavior protocol' }
ClassDefinition >> removeSelector: selector [
	self selectors remove: selector ifAbsent: []]

{ #category : #'behavior protocol' }
ClassDefinition >> rename: newName [
	className := newName]

{ #category : #accessing }
ClassDefinition >> resolveClass [
	| class |
	^(class := super resolveClass) == self
		ifFalse: [class]]

{ #category : #'file in/out' }
ClassDefinition >> saveOn: aStream [
	| p |
	definition := self logChangeOn: aStream.
	p := self project.
	self resolveClass ifNotNil: [:cls | 
		cls project == p
			ifTrue: [cls organization changeLink: {self project id. definition}]]]

{ #category : #'behavior protocol' }
ClassDefinition >> selectors [
	^self compiledMethods keys]

{ #category : #'behavior protocol' }
ClassDefinition >> selectorsInCategory: aSymbol [
	^self organization selectorsFor: aSymbol]

{ #category : #perform }
ClassDefinition >> setAnnotations [
	(owner notNil andNot: [owner isCurrentProjectChanges])
		ifTrue: [self informationAt: #changesFileName put: owner name].
	self project setAnnotationsTo: self]

{ #category : #'behavior protocol' }
ClassDefinition >> sharedPools [
	| pools |
	pools := Set new.
	self poolDictionaries substrings do: [:n | pools add: n asSymbol].
	^pools]

{ #category : #accessing }
ClassDefinition >> sourceCode [
	^self definition]

{ #category : #accessing }
ClassDefinition >> sourcePosition [
	definition isInteger ifFalse: [self error: 'definition must be an integer'].
	^definition]

{ #category : #'file in/out' }
ClassDefinition >> squeakFileOutOn: aStream [
	aStream
		nextPutAll: self squeakFileOutHeader;
		nextChunkPut: self squeakSourceCode]

{ #category : #'file in/out' }
ClassDefinition >> squeakSourceCode [
	| project |
	^String streamContents: [:strm | 
		project := projectChanges isNil
			ifTrue: [self currentVersion
				ifNil: [BeeModule default]
				ifNotNil: [:c | c project]]
			ifFalse: [projectChanges].
		strm nextPutAll: self sourceCode trimBlanks.
		self isMetaclass
			ifFalse: [strm
				cr;
				nextPutAll: 'category: ';
				nextPutAll: project name storeString]]]

{ #category : #'behavior protocol' }
ClassDefinition >> subclasses [
	^self projectChanges currentChanges
		select: [:ch | ch class == ClassDefinition
			and: [ch superclass name = className]]]

{ #category : #'behavior protocol' }
ClassDefinition >> superclass [
	| parseTree msg |
	definition isNil ifTrue: [^nil].
	parseTree := self parseTree.
	msg := parseTree statements first.
	^self project classDefinitionFor: msg receiver value]

{ #category : #'behavior protocol' }
ClassDefinition >> symbol [
	^className asSymbol]

{ #category : #undo }
ClassDefinition >> tip [
	^'Definition of ' , className]

{ #category : #testing }
ClassDefinition >> tracksHistory [
	^true]

{ #category : #testing }
ClassDefinition >> trackSubclasses [
	self resolveClass
		allSubclassesDo: [:sc | sc project changes
			addChange: (SuperclassDefinition fromClass: sc)]]

{ #category : #undo }
ClassDefinition >> undo [
	self prevChange
		ifNotNil: [:ch | self projectChanges
			defineClass: ch definition
			notifying: nil]]

{ #category : #perform }
ClassDefinition >> updateProject: aBeeModule [
	self addToProject: aBeeModule]

{ #category : #accessing }
ClassDefinition >> wasSaved [
	^definition isInteger]

{ #category : #'behavior protocol' }
ClassDefinition >> withAllSuperclasses [
	^self allSuperclasses addFirst: self; yourself]

