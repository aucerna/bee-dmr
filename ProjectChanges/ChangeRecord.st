"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ChangeRecord,
	#superclass : #Object,
	#instVars : [
		'timestamp',
		'lastPerformance',
		'author',
		'projectChanges',
		'owner'
	],
	#category : #ProjectChanges
}

{ #category : #'instance creation' }
ChangeRecord class >> ddmmyyyyhhmmss: aString [
	^[
		((aString includes: $:) and: [aString includes: $T])
			ifTrue: [Timestamp iso8601: aString]
			ifFalse: [Timestamp ddmmyyyyhhmmss: aString]]
		on: Error
		do: [Timestamp current]]

{ #category : #'meta programming' }
ChangeRecord class >> doesNotUnderstand: aMessage [
	| selector new selectors |
	selector := aMessage selector.
	selectors := selector keywords collect: [:s | 
		selector := (s = 'project:' ifTrue: ['projectName:'] ifFalse: [s]) asSymbol.
		s asLowercase = 'timestamp:' ifTrue: [selector := #timestamp:].
		selector].
	(selectors anySatisfy: [:s | self canUnderstand: s])
		ifFalse: [^super doesNotUnderstand: aMessage halt].
	new := self new.
	selectors with: aMessage arguments collect: [:s :arg | | a |
		a := s == #timestamp: ifTrue: [self ddmmyyyyhhmmss: arg] ifFalse: [arg].
		new perform: s with: a].
	^new]

{ #category : #'instance creation' }
ChangeRecord class >> new [
	^super new initialize]

{ #category : #'filein/out' }
ChangeRecord class >> readFrom: aStream [
	| change |
	aStream nextChunk isEmpty ifFalse: [self error: 'cannot read'].
	change := Compiler evaluate: aStream nextChunk.
	^change readFrom: aStream]

{ #category : #'instance creation' }
ChangeRecord class >> timeStamp: tsString
author: author
className: className
selector: selector
category: category
prev: anInteger
applicationVersion: v
changesFileName: fname [
	^self new
		timestamp: (self ddmmyyyyhhmmss: tsString);
		author: author;
		className: className;
		selector: selector;
		category: category;
		prev: anInteger;
		applicationVersion: v;
		changesFileName: fname]

{ #category : #'instance creation' }
ChangeRecord class >> timestamp: tsString
author: author
className: className
selector: selector
category: category
prev: anInteger
applicationVersion: v
changesFileName: fname [
	^self new
		timestamp: (self ddmmyyyyhhmmss: tsString);
		author: author;
		className: className;
		selector: selector;
		category: category;
		prev: anInteger;
		applicationVersion: v;
		changesFileName: fname]

{ #category : #comparing }
ChangeRecord >> <= aChangeRecord [
	^(self lastPerformance ifNil: [timestamp])
		< (aChangeRecord lastPerformance ifNil: [aChangeRecord timestamp])]

{ #category : #comparing }
ChangeRecord >> = aChangeRecord [
	self == aChangeRecord ifTrue: [^true].
	self class == aChangeRecord class ifFalse: [^false].
	timestamp = aChangeRecord timestamp ifFalse: [^false].
	author = aChangeRecord author ifFalse: [^false].
	^true]

{ #category : #testing }
ChangeRecord >> acceptsAsPrev: aChangeRecord [
	^self refersTo = aChangeRecord refersTo]

{ #category : #perform }
ChangeRecord >> addToProject: aBeeModule [
	]

{ #category : #accessing }
ChangeRecord >> annotations [
	^(timestamp isNil
		ifTrue: [nil printString]
		ifFalse: [timestamp prettyPrint])
		, ' by '
		, author printString
		, ' - ['
		, self projectName
		, ']']

{ #category : #testing }
ChangeRecord >> ast [
	^self isExpression
		ifTrue: [Compiler parseExpression: self sourceCode in: self contextClass]
		ifFalse: [Compiler parse: self sourceCode in: self contextClass]]

{ #category : #accessing }
ChangeRecord >> author [
	^author]

{ #category : #accessing }
ChangeRecord >> author: aString [
	author := aString]

{ #category : #testing }
ChangeRecord >> canOverride: aChangeRecord [
	^aChangeRecord refersTo = self refersTo]

{ #category : #testing }
ChangeRecord >> canPerform [
	^self isBroken not]

{ #category : #testing }
ChangeRecord >> canUndo [
	^(self respondsTo: #undo) andNot: [self changesSomething]]

{ #category : #accessing }
ChangeRecord >> changeForCurrentVersion [
	^self currentVersion
		ifNil: [self class new projectChanges: self projectChanges]]

{ #category : #perform }
ChangeRecord >> changelogHeaderSpec [
	| header |
	header := self completeHeaderSpec.
	header remove: #lastPerformance; remove: #prev.
	^header]

{ #category : #accessing }
ChangeRecord >> changeset [
	^self informationAt: #changesFileName]

{ #category : #testing }
ChangeRecord >> changesOnlyFormat [
	^false]

{ #category : #testing }
ChangeRecord >> changesSomething [
	self subclassResponsibility]

{ #category : #accessing }
ChangeRecord >> classBinding [
	^nil]

{ #category : #accessing }
ChangeRecord >> className [
	^nil]

{ #category : #accessing }
ChangeRecord >> cluster [
	^self project cluster]

{ #category : #perform }
ChangeRecord >> compilationErrorHandler [
	^self projectChanges compilationErrorHandler]

{ #category : #perform }
ChangeRecord >> compile: aString [
	^self compiler compile: aString onErrorUse: self compilationErrorHandler]

{ #category : #perform }
ChangeRecord >> compiler [
	^(Compiler forClass: self classBinding) namespace: self project namespace]

{ #category : #'file in/out' }
ChangeRecord >> completeHeaderSpec [
	^self headerSpec add: #lastPerformance; yourself]

{ #category : #perform }
ChangeRecord >> compress: aChangeset [
	| list |
	list := aChangeset reject: [:ch | self canOverride: ch].
	list add: self.
	^list]

{ #category : #accessing }
ChangeRecord >> contextClass [
	^UndefinedObject]

{ #category : #accessing }
ChangeRecord >> currentVersion [
	^nil]

{ #category : #accessing }
ChangeRecord >> currentVersionInProject [
	^self changeForCurrentVersion]

{ #category : #accessing }
ChangeRecord >> date [
	^timestamp date]

{ #category : #private }
ChangeRecord >> defaultProject [
	| p |
	p := projectChanges isString ifTrue: [BeeModule named: projectChanges].
	p isNil ifTrue: [^BeeModule default].
	self projectChanges: p changes.
	^p]

{ #category : #private }
ChangeRecord >> evaluate: aString [
	^Compiler silentlyEvaluate: aString]

{ #category : #'file in/out' }
ChangeRecord >> fileInFrom: aStream [
	self readFrom: aStream.
	self perform]

{ #category : #'file in/out' }
ChangeRecord >> fileOutOn: aStream [
	self isLoggable
		ifTrue: [self fileOutOn: aStream headerSpec: self headerSpec]]

{ #category : #'file in/out' }
ChangeRecord >> fileOutOn: aStream headerSpec: aHeaderSpec [
	| header |
	header := aHeaderSpec headerFor: self.
	aStream
		nextUTF8Put: '!';
		nextChunkPut: header;
		nextStChunkPut: self sourceCode]

{ #category : #comparing }
ChangeRecord >> hash [
	^self class hashWith: author with: timestamp]

{ #category : #'file in/out' }
ChangeRecord >> headerSpec [
	| spec |
	spec := ChangeHeaderSpec new
		projectId: self project id;
		add: #timestamp;
		add: #author;
		add: #projectChanges.
	^spec]

{ #category : #accessing }
ChangeRecord >> informationAt: aSymbol [
	^nil]

{ #category : #initialization }
ChangeRecord >> initialize [
	timestamp := Timestamp current.
	author := SmalltalkSession current userName]

{ #category : #testing }
ChangeRecord >> isBroken [
	^false]

{ #category : #testing }
ChangeRecord >> isClassChange [
	^false]

{ #category : #testing }
ChangeRecord >> isClassDefinition [
	^false]

{ #category : #testing }
ChangeRecord >> isEvaluation [
	^false]

{ #category : #testing }
ChangeRecord >> isExpression [
	^true]

{ #category : #testing }
ChangeRecord >> isLoggable [
	^true]

{ #category : #testing }
ChangeRecord >> isMark [
	^false]

{ #category : #testing }
ChangeRecord >> isMethodChange [
	^false]

{ #category : #testing }
ChangeRecord >> isMethodDefinition [
	^false]

{ #category : #testing }
ChangeRecord >> isNewerThanCurrent [
	| current stamp |
	self changesSomething ifFalse: [^false].
	^(current := self currentVersion) isNil or: [
		stamp := current timestamp.
		stamp isNil or: [self timestamp > stamp]]]

{ #category : #testing }
ChangeRecord >> isOrganizationChange [
	^false]

{ #category : #testing }
ChangeRecord >> isPreamble [
	^false]

{ #category : #testing }
ChangeRecord >> isProjectLoaded [
	projectChanges isNil ifTrue: [^true].
	projectChanges isString ifFalse: [^true].
	^BeeModule isLoadedProject: projectChanges]

{ #category : #testing }
ChangeRecord >> isSelectorRename [
	^false]

{ #category : #testing }
ChangeRecord >> isUserChange [
	^true]

{ #category : #accessing }
ChangeRecord >> lastPerform: ddmmyyyyhhmmss [
	self lastPerformance: ddmmyyyyhhmmss]

{ #category : #accessing }
ChangeRecord >> lastPerformance [
	^lastPerformance]

{ #category : #accessing }
ChangeRecord >> lastPerformance: ddmmyyyyhhmmss [
	lastPerformance := self class ddmmyyyyhhmmss: ddmmyyyyhhmmss]

{ #category : #perform }
ChangeRecord >> logActionWith: result [
	self shouldLogOnSmalltalkChanges
		ifTrue: [self logOnSmalltalkChanges: result].
	self shouldAddToChanges ifTrue: [self projectChanges addChange: self].
	lastPerformance := Timestamp current]

{ #category : #perform }
ChangeRecord >> logChangeOn: aStream [
	^self logChangeOn: aStream headerSpec: self completeHeaderSpec]

{ #category : #'file in/out' }
ChangeRecord >> logChangeOn: aStream headerSpec: aHeaderSpec [
	| header position |
	header := aHeaderSpec headerFor: self.
	aStream
		setToEnd;
		cr;
		cr;
		nextPut: $!;
		nextChunkPut: header.
	position := SourceManager current
		methodPositionOn: aStream
		for: self sourceCode.
	aStream nextStChunkPut: self sourceCode.
	^position]

{ #category : #perform }
ChangeRecord >> logOnSmalltalkChanges [
	| stream pos |
	stream := SourceManager current changesWriteStream.
	pos := self logChangeOn: stream headerSpec: self changelogHeaderSpec.
	stream flush.
	^pos]

{ #category : #perform }
ChangeRecord >> logOnSmalltalkChanges: result [
	self logOnSmalltalkChanges]

{ #category : #perform }
ChangeRecord >> logsBeforePerform [
	^false]

{ #category : #accessing }
ChangeRecord >> owner [
	^owner]

{ #category : #accessing }
ChangeRecord >> owner: aChangeset [
	owner := aChangeset]

{ #category : #private }
ChangeRecord >> parse: aString [
	^SmalltalkParser new parseExpression: aString]

{ #category : #perform }
ChangeRecord >> parseTree [
	^self ast]

{ #category : #perform }
ChangeRecord >> perform [
	| result |
	self logsBeforePerform
		ifTrue: [self canPerform ifTrue: [self logActionWith: nil]].
	result := self basicPerform.
	result notNil ifTrue: [
		self logsBeforePerform ifFalse: [self logActionWith: result].
		self addToProject: self project].
	^result]

{ #category : #accessing }
ChangeRecord >> prev [
	^nil]

{ #category : #accessing }
ChangeRecord >> prev: ref [
	]

{ #category : #accessing }
ChangeRecord >> prevChange [
	| link |
	link := self prev.
	^link isNil ifFalse: [self projectChanges changeAt: link]]

{ #category : #printing }
ChangeRecord >> printOn: aStream [
	aStream
		nextPutAll: timestamp prettyPrint , ' by ' , author printString , ' '
			, self refersTo printString]

{ #category : #accessing }
ChangeRecord >> project [
	^self projectChanges project]

{ #category : #accessing }
ChangeRecord >> project: aBeeModule [
	aBeeModule notNil ifTrue: [projectChanges := aBeeModule changes]]

{ #category : #accessing }
ChangeRecord >> projectChanges [
	(projectChanges isNil and: [owner class == ProjectChanges])
		ifTrue: [^projectChanges := owner].
	^(projectChanges isNil or: [projectChanges isString])
		ifTrue: [self defaultProject changes]
		ifFalse: [projectChanges]]

{ #category : #accessing }
ChangeRecord >> projectChanges: aProjectChanges [
	projectChanges := aProjectChanges.
	]

{ #category : #accessing }
ChangeRecord >> projectName [
	projectChanges isNil ifTrue: [^self defaultProject name].
	^projectChanges isString
		ifTrue: [projectChanges]
		ifFalse: [projectChanges project name]]

{ #category : #accessing }
ChangeRecord >> projectName: aString [
	| project |
	aString isNil ifTrue: [^self].
	project := BeeModule named: aString.
	(project isNil and: [CodeImageSegment isLoaded: aString])
		ifTrue: [project := BeeModule getProject: aString].
	projectChanges := project notNil
		ifTrue: [project changes]
		ifFalse: [aString]]

{ #category : #accessing }
ChangeRecord >> projects [
	^{self project}]

{ #category : #'file in/out' }
ChangeRecord >> readFrom: aStream [
	aStream nextChunk]

{ #category : #'squeak support' }
ChangeRecord >> readFromSqueak: aStream [
	self readFrom: (aStream nextSqueakChunk, '!') readStream]

{ #category : #accessing }
ChangeRecord >> refersTo [
	^{self class}]

{ #category : #services }
ChangeRecord >> resolveClass [
	^nil]

{ #category : #'file in/out' }
ChangeRecord >> saveOn: aStream [
	self logChangeOn: aStream]

{ #category : #'file in/out' }
ChangeRecord >> saveOn: aStream index: anInteger [
	| last |
	self tracksHistory ifTrue: [
		last := self project changes prevTo: self index: anInteger.
		last notNil ifTrue: [
			last wasSaved ifFalse: [
				last project !== self project
					ifTrue: [last := last shallowCopy projectChanges: projectChanges].
				last saveOn: aStream index: anInteger].
			self prev: last sourcePosition]].
	self isLoggable ifTrue: [self saveOn: aStream]]

{ #category : #accessing }
ChangeRecord >> selector [
	^nil]

{ #category : #printing }
ChangeRecord >> shortClassName [
	^(((((((self class name
		replaceAll: 'Category' with: 'Ct')
		replaceAll: 'Method' with: 'Mt')
		replaceAll: 'Remove' with: 'Rmv')
		replaceAll: 'Rename' with: 'Ren')
		replaceAll: 'Addition' with: 'Add')
		replaceAll: 'Definition' with: 'Def')
		replaceAll: 'Class' with: 'Cl')
		replaceAll: 'Global' with: 'Gl'




		]

{ #category : #printing }
ChangeRecord >> shortLabel [
	| array string |
	array := self refersTo allButFirst.
	(array notEmpty and: [array first = self projectName] and: [array size > 1])
		ifTrue: [array := array allButFirst].
	string := array literalString.
	(string beginsWith: '#(')
		ifTrue: [string := string copyFrom: 3 to: string size - 1].
	^string]

{ #category : #printing }
ChangeRecord >> shortPrintString [
	^String streamContents: [:str | self shortPrintStringOn: str]]

{ #category : #printing }
ChangeRecord >> shortPrintStringOn: aStream [
	aStream nextPutAll: self shortClassName]

{ #category : #perform }
ChangeRecord >> shouldAddToChanges [
	^owner notNil and: [owner shouldAddToChanges]]

{ #category : #perform }
ChangeRecord >> shouldLogOnSmalltalkChanges [
	^owner notNil and: [owner shouldLogOnSmalltalkChanges]]

{ #category : #accessing }
ChangeRecord >> sourceString [
	^self sourceCode]

{ #category : #'file in/out' }
ChangeRecord >> squeakFileOutHeader [
	^'"evaluate"']

{ #category : #'file in/out' }
ChangeRecord >> squeakFileOutOn: aStream [
	aStream
		nextBytesPut: self squeakFileOutHeader utf8;
		nextChunkPut: self sourceCode]

{ #category : #'file in/out' }
ChangeRecord >> standardFileOutHeader [
	^'"evaluate"']

{ #category : #'file in/out' }
ChangeRecord >> standardFileOutOn: aStream [
	aStream
		nextBytesPut: self standardFileOutHeader utf8;
		nextChunkPut: self sourceCode]

{ #category : #accessing }
ChangeRecord >> timestamp [
	^timestamp]

{ #category : #accessing }
ChangeRecord >> timeStamp: aTimestamp [
	self timestamp: aTimestamp]

{ #category : #accessing }
ChangeRecord >> timestamp: aTimestamp [
	aTimestamp notNil ifTrue: [timestamp := aTimestamp]]

{ #category : #perform }
ChangeRecord >> tip [
	^self class name , '-' , self sourceCode readStream nextLine]

{ #category : #testing }
ChangeRecord >> tracksHistory [
	^false]

{ #category : #accessing }
ChangeRecord >> type [
	^self class]

{ #category : #perform }
ChangeRecord >> updateProject: aBeeModule [
	self basicPerform]

