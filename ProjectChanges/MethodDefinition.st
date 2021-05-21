"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MethodDefinition,
	#superclass : #MethodChange,
	#instVars : [
		'sourceCode',
		'category',
		'prev',
		'information'
	],
	#category : #ProjectChanges
}

{ #category : #'instance creation' }
MethodDefinition class >> fromCompiledMethod: aCompiledMethod [
	^self fromCompiledMethod: aCompiledMethod in: aCompiledMethod project]

{ #category : #'instance creation' }
MethodDefinition class >> fromCompiledMethod: aCompiledMethod in: aSmalltalkProject [
	^(self new fromCompiledMethod: aCompiledMethod) project: aSmalltalkProject]

{ #category : #utils }
MethodDefinition class >> referenceFor: aCompiledMethod in: aSmalltalkProject [
	^{self. aSmalltalkProject name. aCompiledMethod classBinding name.
		aCompiledMethod selector}]

{ #category : #perform }
MethodDefinition >> aboutToOverwrite: aCompiledMethod with: aMethodDefinition [
	self
		aboutToOverwrite: aCompiledMethod
		with: aMethodDefinition
		from: self project]

{ #category : #perform }
MethodDefinition >> aboutToOverwrite: aCompiledMethod with: aMethodDefinition from: aBeeModule [
	aCompiledMethod projects
		do: [:p | p
			aboutToOverwrite: aCompiledMethod
			with: aMethodDefinition
			from: aBeeModule]]

{ #category : #testing }
MethodDefinition >> acceptsAsPrev: aChangeRecord [
	^className = aChangeRecord className
		and: [selector == aChangeRecord selector]
		and: [aChangeRecord isKindOf: MethodDefinition]]

{ #category : #accessing }
MethodDefinition >> addToProject: aBeeModule [
	aBeeModule addMethodDefinition: self]

{ #category : #perform }
MethodDefinition >> annotations [
	^String streamContents: [:strm | | v filename |
		strm nextPutAll: super annotations.
		v := self informationAt: #applicationVersion.
		v notNil ifTrue: [
			strm
				space;
				nextPut: $(;
				nextPutAll: v printString;
				nextPut: $)].
		filename := self informationAt: #changesFileName.
		filename notNil
			ifTrue: [strm nextPutAll: ' from file '; nextPutAll: filename]]]

{ #category : #printing }
MethodDefinition >> asString [
	^self sourceCode]

{ #category : #perform }
MethodDefinition >> basicPerform [
	| class cm |
	class := self resolveClass ifNil: [^nil].
	cm := self compile: self sourceCode.
	cm notNil ifFalse: [^nil].
	sourceCode := cm sourceCode.
	selector := cm selector.
	cm classBinding: class.
	^self updateSystemWith: cm]

{ #category : #testing }
MethodDefinition >> canOverride: aChangeRecord [
	^aChangeRecord isMethodChange and: [aChangeRecord canBeOverriddenBy: self]]

{ #category : #perform }
MethodDefinition >> categorize [
	| cls |
	cls := self resolveClass.
	category notNil
		ifTrue: [| old |
			old := cls categoryFor: self selector.
			old != category ifTrue: [
				cls organization move: self selector to: category.
				(cls selectorsInCategory: old) isEmptyOrNil
					ifTrue: [cls organization removeCategory: old]]]
		ifFalse: [category := cls organization categoryFor: self selector]]

{ #category : #accessing }
MethodDefinition >> category [
	^category]

{ #category : #accessing }
MethodDefinition >> category: aSymbol [
	category := aSymbol isNil ifFalse: [aSymbol asSymbol].
	category == ClassOrganizer default ifTrue: [category := nil]]

{ #category : #accessing }
MethodDefinition >> changeForCurrentVersion [
	| mth |
	mth := self currentVersion.
	^mth isNil
		ifTrue: [
			MethodRemoval new
				projectChanges: self projectChanges;
				author: SmalltalkSession current userName;
				className: self className;
				selector: self selector;
				yourself]
		ifFalse: [self class fromCompiledMethod: mth]]

{ #category : #accessing }
MethodDefinition >> changeLink [
	^self currentVersionInProject prev]

{ #category : #metaprogramming }
MethodDefinition >> changePosition [
	^self wasSaved ifTrue: [sourceCode]]

{ #category : #testing }
MethodDefinition >> changesCode [
	| current |
	(current := self currentVersion) isNil ifTrue: [^true].
	current sourceCode isNil ifTrue: [^true].
	^current sourceCode trimBlanks zapLfs != self sourceCode trimBlanks zapLfs]

{ #category : #testing }
MethodDefinition >> changesOnlyFormat [
	| cm compiler m |
	self changesSomething ifFalse: [^false].
	(cm := self currentProjectVersion) isNil ifTrue: [^false].
	compiler := Compiler silentForClass: self classBinding.
	m := compiler compileMethod: self sourceCode.
	^m notNil and: [m equals: cm]]

{ #category : #testing }
MethodDefinition >> changesSomething [
	| current |
	(current := self currentProjectVersion) isNil ifTrue: [^true].
	current sourceCode isNil ifTrue: [^true].
	^current sourceCode trimBlanks zapLfs != self sourceCode trimBlanks zapLfs]

{ #category : #'file in/out' }
MethodDefinition >> completeHeaderSpec [
	| spec |
	spec := super completeHeaderSpec.
	spec add: #prev; addInformation.
	^spec]

{ #category : #accessing }
MethodDefinition >> currentProjectVersion [
	| cls |
	cls := self resolveClass.
	cls isNil ifTrue: [^nil].
	^self project compiledMethodFor: self selector in: cls]

{ #category : #accessing }
MethodDefinition >> currentVersion [
	| result |
	result := className notNil ifTrue: [Compiler silentlyEvaluate: className].
	result isSpecies ifFalse: [^nil].
	^result >> self selector]

{ #category : #metaprogramming }
MethodDefinition >> currentVersionInProject [
	| cm cls |
	cls := self resolveClass.
	cm := cls notNil ifTrue: [self project compiledMethodFor: selector in: cls].
	cm isNil ifTrue: [
		cm := self currentVersion.
		cm isNil ifTrue: [^self changeForCurrentVersion]].
	^self class fromCompiledMethod: cm]

{ #category : #metaprogramming }
MethodDefinition >> doesNotUnderstand: aMessage [
	| s value |
	s := aMessage selector.
	(information notNil and: [
		value := information at: s ifAbsent: nil.
		value notNil])
		ifTrue: [^value].
	s arity = 1 ifFalse: [^super doesNotUnderstand: aMessage].
	information isNil ifTrue: [self initializeInformation].
	information at: s allButLast asSymbol put: aMessage arguments first]

{ #category : #testing }
MethodDefinition >> evaluate [
	| ast snippet |
	ast := SmalltalkParser new parse: sourceCode.
	snippet := sourceCode allButFirst: ast selectorNode stretch end.
	^Compiler evaluate: snippet]

{ #category : #initialization }
MethodDefinition >> fromCompiledMethod: aCompiledMethod [
	| class |
	class := aCompiledMethod classBinding.
	class notNil ifTrue: [class := class name].
	self
		selector: aCompiledMethod selector;
		className: class;
		category: aCompiledMethod category;
		sourceCode: aCompiledMethod sourceCode.
	aCompiledMethod sourceReference setAnnotationsTo: self]

{ #category : #accessing }
MethodDefinition >> information [
	^information]

{ #category : #accessing }
MethodDefinition >> informationAt: aSymbol [
	^information notNil ifTrue: [information at: aSymbol ifAbsent: nil]]

{ #category : #perform }
MethodDefinition >> informationAt: aSymbol put: anObject [
	information isNil ifTrue: [self initializeInformation].
	anObject isNil ifFalse: [information at: aSymbol put: anObject]]

{ #category : #initialization }
MethodDefinition >> initializeInformation [
	information := IdentityDictionary new]

{ #category : #perform }
MethodDefinition >> installMethod: method [
	| cm current |
	current := self currentVersion.
	(current notNil and: [current equals: method])
		ifTrue: [current author ifNotNil: [self author: current author]].
	cm := self currentProjectVersion.
	(cm notNil and: [cm !== method]) ifTrue: [
		prev := cm project == self project
			ifTrue: [cm sourceReference changeLink]
			ifFalse: [self projectChanges prevTo: self].
		self prevChange isNil
			ifTrue: [prev := MethodDefinition fromCompiledMethod: cm]].
	current notNil ifTrue: [self aboutToOverwrite: current with: self].
	method install.
	self categorize]

{ #category : #testing }
MethodDefinition >> isDefinition [
	^true]

{ #category : #testing }
MethodDefinition >> isEvaluable [
	^(className endsWith: ' class') and: [selector arity = 0]]

{ #category : #testing }
MethodDefinition >> isExpression [
	^false]

{ #category : #testing }
MethodDefinition >> isMethodDefinition [
	^true]

{ #category : #testing }
MethodDefinition >> isOverridden [
	| cm method |
	cm := self currentVersion.
	cm isNil ifTrue: [^false].
	method := self project compiledMethodFor: selector in: self resolveClass.
	method isNil ifTrue: [^false].
	^cm !== method]

{ #category : #testing }
MethodDefinition >> isTest [
	| class |
	class := self resolveClass.
	class isNil ifTrue: [^false].
	class := class instanceClass.
	^class isTestClass and: [class isTestSelector: selector]]

{ #category : #perform }
MethodDefinition >> logOnSmalltalkChanges: method [
	| position source |
	self setAnnotations.
	position := self logOnSmalltalkChanges.
	source := MethodSourceCode
		sourceReader: SourceCodeReader changelogReader
		position: position.
	self setAnnotationsTo: source.
	source changeLink: self.
	method sourceReference: source]

{ #category : #accessing }
MethodDefinition >> messages [
	^self parseTree messages]

{ #category : #accessing }
MethodDefinition >> methodForHistory [
	^self]

{ #category : #perform }
MethodDefinition >> perform [
	| cm source |
	(self projectChanges includesIdentical: self) ifTrue: [^self copy perform].
	cm := super perform.
	(cm notNil and: [cm sourceCode isNil]) ifTrue: [
		source := MethodSourceCode fromMethodDefinition: self.
		cm sourceReference: source].
	(cm notNil andNot: [cm canBeInstalled])
		ifTrue: [self project addOverridden: cm].
	^cm]

{ #category : #accessing }
MethodDefinition >> prev [
	^prev]

{ #category : #accessing }
MethodDefinition >> prev: ref [
	prev := ref]

{ #category : #'file in/out' }
MethodDefinition >> readFrom: aStream [
	self sourceCode: aStream nextChunk]

{ #category : #accessing }
MethodDefinition >> refersTo [
	^{self class. self projectName. className. self selector}]

{ #category : #'file in/out' }
MethodDefinition >> saveOn: aStream [
	| cm |
	sourceCode := self logChangeOn: aStream.
	cm := self currentProjectVersion.
	cm isNil
		ifFalse: [cm sourceReference changeLink: {self project id. sourceCode}]]

{ #category : #accessing }
MethodDefinition >> selector [
	| string |
	selector notNil ifTrue: [^selector].
	sourceCode isNil ifTrue: [^nil].
	(SmalltalkParser parseSelector: sourceCode) ifNotNil: [:s | ^s].
	string := (sourceCode includes: $|)
		ifTrue: [sourceCode upTo: $|]
		ifFalse: [sourceCode upTo: 13 asCharacter].
	selector := string trimBlanks asSymbol.
	^selector]

{ #category : #perform }
MethodDefinition >> setAnnotations [
	(owner notNil andNot: [owner isCurrentProjectChanges])
		ifTrue: [self informationAt: #changesFileName put: owner name].
	self project setAnnotationsTo: self]

{ #category : #perform }
MethodDefinition >> setAnnotationsTo: aMethodSourceCode [
	aMethodSourceCode timestamp: timestamp; author: author.
	information isEmptyOrNil ifFalse: [
		information
			keysAndValuesDo: [:k :v | aMethodSourceCode informationAt: k put: v]]]

{ #category : #perform }
MethodDefinition >> shouldInstall: aCompiledMethod [
	^aCompiledMethod canBeInstalled andNot: [self isOverridden]]

{ #category : #accessing }
MethodDefinition >> sourceCode [
	| file |
	sourceCode isString ifTrue: [^sourceCode].
	^sourceCode isInteger
		ifTrue: [
			sourceCode isSmallInteger
				ifFalse: [^self method sourceObject == sourceCode
					ifTrue: [self method sourceCode]].
			file := projectChanges filename asFilename asFile.
			file isNil ifTrue: [^nil].
			file := file readStream.
			[
				file position: sourceCode.
				file nextChunk]
				ensure: [file close]]
		ifFalse: [sourceCode asString]]

{ #category : #accessing }
MethodDefinition >> sourceCode: aString [
	sourceCode := aString.
	selector isNil ifTrue: [selector := self selector]]

{ #category : #accessing }
MethodDefinition >> sourcePosition [
	self wasSaved ifFalse: [self error: 'sourceCode must be an integer'].
	^sourceCode]

{ #category : #'file in/out' }
MethodDefinition >> squeakFileOutHeader [
	| classification signature |
	classification := category.
	classification isNil ifTrue: [classification := 'as yet unclassified'].
	^String streamContents: [:strm | 
		signature := author replaceAll: ' ' with: ''.
		strm
			nextPut: $!;
			nextPutAll: className;
			nextPutAll: ' methodsFor: ';
			nextPutAll: classification asString storeString;
			nextPutAll: ' stamp: ';
			nextPut: $';
			nextPutAll: signature;
			space;
			nextPutAll: timestamp mmddyyyyhhmmss;
			nextPut: $';
			nextPut: $!]]

{ #category : #'file in/out' }
MethodDefinition >> squeakFileOutOn: aStream [
	super squeakFileOutOn: aStream.
	aStream nextChunkPut: '']

{ #category : #'file in/out' }
MethodDefinition >> standardFileOutHeader [
	^category isNil
		ifTrue: ['!', className, ' methods', '!']
		ifFalse: ['!', className, ' methodsFor: ', category storeString, '!']]

{ #category : #'file in/out' }
MethodDefinition >> standardFileOutOn: aStream [
	super standardFileOutOn: aStream.
	aStream nextChunkPut: '']

{ #category : #undo }
MethodDefinition >> tip [
	^'Definition of ' , className , '>>' , self selector]

{ #category : #testing }
MethodDefinition >> tracksHistory [
	^true]

{ #category : #undo }
MethodDefinition >> undo [
	self prevChange
		ifNil: [
			prev notNil ifTrue: [self ASSERT: false].
			self projectChanges removeSelector: selector from: self resolveClass]
		ifNotNil: [:change | self projectChanges
			compile: change sourceCode
			in: self resolveClass]]

{ #category : #perform }
MethodDefinition >> updateProject: aBeeModule [
	self addToProject: aBeeModule]

{ #category : #perform }
MethodDefinition >> updateSystemWith: method [
	self isOverridden ifTrue: [self project storeOverriddenMethod: method].
	(self shouldInstall: method)
		ifTrue: [self installMethod: method]
		ifFalse: [| cm |
			cm := self currentProjectVersion.
			cm notNil ifTrue: [Smalltalk updateWithoutMethod: cm].
			Smalltalk updateWithMethod: method].
	^method]

{ #category : #testing }
MethodDefinition >> wasSaved [
	^sourceCode isInteger]

