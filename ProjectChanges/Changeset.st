"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Changeset,
	#superclass : #Object,
	#instVars : [
		'changes',
		'filename'
	],
	#classVars : [
		'ObsoleteChangeClasses'
	],
	#category : #ProjectChanges
}

{ #category : #accessing }
Changeset class >> changesDirectory [
	| directory |
	directory := SmalltalkSession current workingDirectory
		directoryNamed: 'Changes'.
	directory exists ifFalse: [directory create].
	^directory]

{ #category : #services }
Changeset class >> checkSentChanges [
	"
	Changeset checkSentChanges
	"
	self checkSentChangesFrom: self sentDirectory]

{ #category : #services }
Changeset class >> checkSentChangesFrom: aDirectory [
	| filename pattern filenames target |
	target := self changesDirectory.
	filename := aDirectory path.
	pattern := '*.ch'.
	filenames := aDirectory fileNamesMatching: pattern.
	filenames := filenames
		collect: [:fn | fn -> (aDirectory lastWriteTimeFor: fn)].
	filenames sortBy: [:a :b | a value > b value].
	filenames collect: [:a | filename \ a key] thenDo: [:fn | | cs |
		cs := Changeset fromPath: fn.
		cs wasIntegrated
			ifTrue: [
				cs moveIntegratedTo: target.
				cs isFullyLoaded ifFalse: [cs browse]]
			ifFalse: [('"' , fn withoutExtension entityName , '" not integrated yet') print]]]

{ #category : #'progress indicator compatibility' }
Changeset class >> closeWindow [
	"
	ignored
	"
	]

{ #category : #'instance creation' }
Changeset class >> fromPath: filename [
	^self new readFromPath: filename]

{ #category : #'instance creation' }
Changeset class >> fromStream: aStream [
	| changes |
	changes := self new.
	changes readFrom: aStream.
	^changes]

{ #category : #services }
Changeset class >> initialize [
	ObsoleteChangeClasses := PoolDictionary new]

{ #category : #accessing }
Changeset class >> integratorEmail [
	^'bee.integrator@gmail.com']

{ #category : #utils }
Changeset class >> integrators [
	| string default list |
	default := self integratorEmail.
	string := SmalltalkSession current getIniInfo: 'Code' key: 'integrators'.
	string ifNil: [^{default}].
	list := ($, split: string) asOrderedCollection.
	list copyWithout: default; addFirst: default.
	^list]

{ #category : #services }
Changeset class >> mapObsoleteClassname: aString to: aClass [
	ObsoleteChangeClasses at: aString put: aClass]

{ #category : #services }
Changeset class >> move: filename under: folder version: version [
	| index release iteration dir file |
	index := version indexOf: $..
	release := version copyFrom: 1 to: index + 1.
	iteration := version allButFirst: index + 1.
	iteration isEmpty ifTrue: [iteration := '01'].
	dir := (folder asFilename \ 'Integrated' \ release \ version) asDirectory.
	dir exists ifFalse: [dir createPath].
	file := filename asFile ifNil: [^self].
	(dir \ filename entityName) fileExists
		ifTrue: [file remove]
		ifFalse: [file moveTo: dir]]

{ #category : #'instance creation' }
Changeset class >> new [
	^super new initialize]

{ #category : #'instance creation' }
Changeset class >> on: changesCollection [
	^self new addAll: changesCollection]

{ #category : #'progress indicator compatibility' }
Changeset class >> percent: number [
	"ignored"]

{ #category : #accessing }
Changeset class >> progressIndicatorSize: anInteger message: aString name: nameString [
	^self]

{ #category : #reading }
Changeset class >> readFromSqueakFile [
	"
	ProjectChanges halt readFromSqueakFile
	"
	| filename file changeset |
	filename := FileDialog new
		title: 'Open Project changes';
		fileSpec: '*.cs';
		hideReadonly;
		shareAware;
		addFilter: '*.cs' description: 'Squeak Changes';
		open;
		file.
	filename isNil ifTrue: [^nil].
	file := filename asFile readStream.
	changeset := self new.
	[changeset readFromSqueak: file] ensure: [file close].
	^changeset]

{ #category : #accessing }
Changeset class >> sentDirectory [
	| directory |
	directory := (self changesDirectory \ 'Sent') asDirectory.
	directory exists ifFalse: [directory create].
	^directory]

{ #category : #'progress indicator compatibility' }
Changeset class >> wasCanceled [
	^false]

{ #category : #'instance creation' }
Changeset class >> withAll: aCollection [
	^self new changes: aCollection]

{ #category : #updating }
Changeset >> addAll: changesCollection [
	changesCollection do: [:c | self addChange: c]]

{ #category : #updating }
Changeset >> addChange: aChangeRecord [
	self addChange: aChangeRecord after: nil]

{ #category : #updating }
Changeset >> addChange: aChangeRecord after: existingChange [
	aChangeRecord isCompiledMethod ifFalse: [aChangeRecord owner: self].
	aChangeRecord author isNil ifTrue: [aChangeRecord author: self currentUser].
	existingChange isNil
		ifTrue: [changes add: aChangeRecord]
		ifFalse: [changes add: aChangeRecord after: existingChange]]

{ #category : #updating }
Changeset >> addEvaluationOf: aString after: existingChange [
	| change |
	change := (self newChange: ExpressionEvaluation)
		expression: aString;
		yourself.
	self addChange: change after: existingChange.
	^change]

{ #category : #private }
Changeset >> affectedProjects [
	^changes collect: [:ch | ch project] in: Set new]

{ #category : #accessing }
Changeset >> allChanges [
	^changes]

{ #category : #services }
Changeset >> annotateLibrary: aCodeImageSegment [
	]

{ #category : #'file in/out' }
Changeset >> authorFromNode: node [
	| stream author |
	^node selector value == #methodsFor:stamp: ifTrue: [
		stream := node arguments second value readStream.
		author := stream upTo: $ .
		author = 'VM' ifTrue: [author := 'V Murgia'].
		author = 'LC' ifTrue: [author := 'L Caniglia'].
		author]]

{ #category : #actions }
Changeset >> browse [
	SystemDecorator current browseChanges: self label: filename entityName]

{ #category : #services }
Changeset >> buildLibrary: aFilename [
	| fname bsl evaluation action |
	fname := aFilename asFilename.
	fname := fname isRelative
		ifTrue: [BeeModule defaultDirectory \ aFilename]
		ifFalse: [fname].
	bsl := CodeSegmentBuilder newNamed: fname.
	self do: [:ch | | cv |
		cv := ch currentVersion.
		cv notNil ifTrue: [bsl add: cv]].
	evaluation := changes detect: #isEvaluation ifNone: nil.
	evaluation notNil ifTrue: [
		action := bsl actionFromString: evaluation expression.
		bsl loadAction: action asActionSequence].
	self annotateLibrary: bsl.
	^bsl]

{ #category : #services }
Changeset >> buildUpdateNamed: aFilename [
	| selection set evaluation |
	aFilename isNil ifTrue: [^nil].
	self validateForUpdate ifFalse: [^nil].
	selection := changes
		select: [:each | each isClassDefinition and: [each definesNewClass]].
	evaluation := changes detect: #isEvaluation ifNone: nil.
	selection := selection
		& (changes
			select: [:each | each isMethodDefinition
				andNot: [each classBinding isTestClass]]).
	evaluation notNil ifTrue: [selection := selection && evaluation].
	set := self class on: selection.
	^set buildLibrary: aFilename]

{ #category : #'file in/out' }
Changeset >> changeFromParseNode: node chunk: aString [
	(self removesMethod: node) ifTrue: [^self methodRemovalFrom: node].
	(self definesClass: node)
		ifTrue: [^self classDefinitionFrom: node chunk: aString].
	(self isClassComment: node) ifTrue: [^self classCommentFrom: node].
	(self isClassRename: node) ifTrue: [^self classRenameFrom: node].
	(self isClassRemove: node) ifTrue: [^self classRemoveFrom: node].
	(self isClassInitialization: node)
		ifTrue: [^self classInitializationFrom: node].
	^nil]

{ #category : #accessing }
Changeset >> changes: aCollection [
	changes := aCollection asOrderedCollection]

{ #category : #'file in/out' }
Changeset >> classCommentFrom: node [
	| change class |
	change := ClassCommentDefinition new.
	class := node receiver value.
	change className: class; comment: node arguments anyone value.
	Smalltalk at: class asSymbol ifPresent: [:cls | change prev: cls comment].
	^change]

{ #category : #'file in/out' }
Changeset >> classDefinitionFrom: node chunk: aString [
	| change class idx category project |
	change := ClassDefinition new.
	class := self classNameFrom: node.
	change className: class; definition: aString trimComments trimBlanks.
	idx := node selector value keywords indexOf: 'category:'.
	idx > 0 ifTrue: [
		category := (node arguments at: idx) value.
		project := BeeModule withName: category.
		change project: project].
	^change]

{ #category : #'file in/out' }
Changeset >> classInitializationFrom: node [
	| change |
	change := ExpressionEvaluation new.
	change expression: node source.
	^change]

{ #category : #private }
Changeset >> classNameFrom: aMessageNode [
	| selector |
	selector := aMessageNode selector value.
	(selector includesString: 'ubclass:')
		ifTrue: [^aMessageNode arguments first value asString].
	(selector includesString: 'instanceVariableNames:')
		ifTrue: [^aMessageNode receiver receiver value asString , ' class'].
	self ASSERT: false]

{ #category : #'file in/out' }
Changeset >> classRemoveFrom: node [
	| change class |
	change := ClassRemoval new.
	class := node receiver value.
	change className: class.
	^change]

{ #category : #'file in/out' }
Changeset >> classRenameFrom: node [
	| change class |
	change := ClassRename new.
	class := node receiver value.
	change className: class; newName: node arguments anyone value.
	Smalltalk at: class asSymbol ifPresent: [:cls | change prev: cls name].
	^change]

{ #category : #enumeration }
Changeset >> collect: aBlock [
	^changes collect: aBlock]

{ #category : #private }
Changeset >> compileSilently: aString [
	| compiler |
	compiler := Compiler silentForClass: self class.
	^compiler evaluate: aString]

{ #category : #utils }
Changeset >> compressChanges [
	changes := self compressChanges: self allChanges.
	self saveChanges]

{ #category : #utils }
Changeset >> compressChanges: aCollection [
	| compressed progress size |
	compressed := OrderedCollection new.
	size := aCollection size.
	progress := self class
		progressIndicatorSize: size
		message: 'Compressing Project Changes…'
		name: self label.
	[
		aCollection withIndexDo: [:ch :i | 
			compressed := ch compress: compressed.
			progress percent: i * 100 // size.
			progress wasCanceled ifTrue: [^compressed]]]
		ensure: [progress closeWindow].
	^compressed]

{ #category : #utils }
Changeset >> compressChangesUntil: aDate [
	| older newer backup file |
	older := OrderedCollection new.
	newer := OrderedCollection new.
	self allChanges
		do: [:ch | ch timestamp date <= aDate
			ifTrue: [older add: ch]
			ifFalse: [newer add: ch]].
	changes := (self compressChanges: older) , newer.
	backup := self filename , '.bak'.
	self filename copyFileAs: backup.
	file := self fileStream truncate.
	[self saveOn: file] ensure: [file close].
	changes := OrderedCollection new]

{ #category : #utils }
Changeset >> compressCurrentChanges [
	changes := self compressChanges: changes.]

{ #category : #accessing }
Changeset >> currentChanges [
	^changes]

{ #category : #accessing }
Changeset >> currentUser [
	| answer |
	answer := SmalltalkSession current userName.
	answer ifNil: [
		SmalltalkSession current
			userName: (answer := Prompter
				prompt: 'Current User Name'
				default: 'unknown')].
	^answer]

{ #category : #accessing }
Changeset >> defaultChangesetName [
	^String streamContents: [:strm | 
		strm nextPutAll: 'changes-'.
		Date today printOn: strm format: 'yyyy-MM-dd'.
		strm nextPutAll: '.ch']]

{ #category : #testing }
Changeset >> definesChangeRecord: aParseNode [
	| receiver class symbol |
	aParseNode hasSends ifFalse: [^false].
	((aParseNode selector value asLowercase beginsWith: 'timestamp')
		or: [aParseNode selector value asLowercase beginsWith: 'project:'])
		ifFalse: [^false].
	receiver := aParseNode receiver.
	class := receiver isImmediate
		ifTrue: [receiver]
		ifFalse: [receiver receiver].
	symbol := class value asString asSymbol.
	^(Smalltalk includesKey: symbol)
		and: [(Smalltalk at: symbol) inheritsFrom: ChangeRecord]]

{ #category : #testing }
Changeset >> definesClass: aParseNode [
	| selector |
	aParseNode class == MessageNode ifFalse: [^false].
	selector := aParseNode selector value.
	^(selector includesString: 'ubclass:')
		or: [selector includesString: 'instanceVariableNames:']]

{ #category : #enumeration }
Changeset >> detect: aBlock ifNone: absentBlock [
	^changes detect: aBlock ifNone: absentBlock]

{ #category : #enumeration }
Changeset >> do: aBlock [
	changes do: aBlock]

{ #category : #utils }
Changeset >> emailChangesetTo: email [
	| dir |
	dir := self class sentDirectory.
	filename := dir \ filename asFilename entityName withExtension: '.ch'.
	self emailTo: email; logSent]

{ #category : #private }
Changeset >> emailTemplateFor: path [
	| file template fn |
	fn := 'emailTemplate.txt' asFilename.
	fn fileExists ifFalse: [^'Changes file: ' , path].
	file := fn asFile readStream.
	[
		template := String
			streamContents: [:strm | [file atEnd]
				whileFalse: [strm nextPut: file next]]]
		ensure: [file close].
	^template replaceAll: '@path@' with: path]

{ #category : #utils }
Changeset >> emailTo: mailAddress [
	| file class mail body |
	self validate.
	class := Smalltalk at: #SimpleMailMessage ifAbsent: [
		self error: 'No email support loaded'.
		^self].
	mail := class new.
	filename isNil ifTrue: [filename := self defaultChangesetName asFilename].
	body := self emailTemplateFor: filename fileNameOnly.
	file := filename newFile.
	[self fileOutOn: file] ensure: [file close].
	mail
		subject: filename fileNameOnly;
		to: mailAddress;
		body: body;
		attach: file absolutePath asString;
		send]

{ #category : #utils }
Changeset >> emailToIntegrator [
	self emailChangesetTo: self class integratorEmail]

{ #category : #updating }
Changeset >> evaluate: aString [
	| change |
	change := (self newChange: ExpressionEvaluation)
		expression: aString;
		yourself.
	^change perform]

{ #category : #'file in/out' }
Changeset >> fileInChange: changeRecord from: aStream [
	^changeRecord owner: self; fileInFrom: aStream]

{ #category : #'file in/out' }
Changeset >> fileInFrom: aStream [
	[aStream atEnd or: [aStream peek asInteger > $  asInteger]]
		whileFalse: [aStream next].
	[aStream atEnd] whileFalse: [| chunk change class category result |
		chunk := aStream nextChunk.
		chunk isEmpty
			ifTrue: [
				aStream atEnd ifTrue: [^self].
				chunk := aStream nextChunk.
				change := Compiler evaluate: chunk.
				(change isKindOf: ChangeRecord)
					ifTrue: [self fileInChange: change from: aStream]
					ifFalse: [
						class := change classBinding.
						category := change category.
						[(chunk := aStream nextChunk) isEmpty] whileFalse: [
							change := (self newChange: MethodDefinition)
								className: class name;
								category: category;
								sourceCode: chunk;
								yourself.
							change perform]]]
			ifFalse: [
				result := Compiler evaluate: chunk.
				result isSpecies ifTrue: [
					change := (self newChange: ClassDefinition)
						className: result name;
						definition: chunk trimComments trimBlanks;
						yourself.
					self addChange: change]]]]

{ #category : #'squeak support' }
Changeset >> fileInFromSqueak: aStream [
	| answer size progress chunk change |
	answer := OrderedCollection new.
	size := aStream size // 100.
	progress := self
		progressIndicatorSize: size
		message: 'Reading Squeak Changes'.
	[
		[aStream atEnd or: [aStream peek asInteger > $  asInteger]]
			whileFalse: [aStream next].
		[aStream atEnd or: [progress wasCanceled]] whileFalse: [
			aStream peekFor: $!.
			chunk := aStream nextSqueakChunk.
			change := Compiler evaluate: chunk.
			(change isKindOf: Species) ifTrue: [self addClass: change].
			(change isKindOf: ChangeRecord) ifTrue: [
				change readFromSqueak: aStream.
				change perform.
				answer add: change].
			progress percent: aStream position // size]]
		ensure: [progress closeWindow].
	^answer]

{ #category : #accessing }
Changeset >> filename [
	^filename]

{ #category : #accessing }
Changeset >> filename: aFilename [
	filename := aFilename asFilename]

{ #category : #services }
Changeset >> fileOutAll [
	| file |
	file := filename asFilename newFile.
	[self fileOutOn: file] ensure: [file close]]

{ #category : #'file in/out' }
Changeset >> fileOutOn: aStream [
	changes do: [:change | 
		change notNil ifTrue: [
			change fileOutOn: aStream.
			aStream cr; cr]]]

{ #category : #'file in/out' }
Changeset >> fileStream [
	^self filename asFile writeStream]

{ #category : #testing }
Changeset >> hasBrokenChanges [
	^changes anySatisfy: #isBroken]

{ #category : #services }
Changeset >> ignoreLoggingWhile: aBlock [
	^self
		answerTo: #(#shouldLogOnSmalltalkChanges #shouldAddToChanges)
		with: false
		while: aBlock]

{ #category : #testing }
Changeset >> includes: aChangeRecord [
	^changes includes: aChangeRecord]

{ #category : #testing }
Changeset >> includesChange: aChangeRecord [
	^changes includes: aChangeRecord]

{ #category : #initialization }
Changeset >> initialize [
	changes := OrderedCollection new]

{ #category : #testing }
Changeset >> integrationVersion [
	| name change |
	name := filename asFilename withoutExtension entityName.
	change := changes
		detect: [:ch | | cm reference |
			ch isMethodDefinition
				and: [(cm := ch currentVersion) notNil]
				and: [(reference := cm sourceReference) hasInformation]
				and: [(reference informationAt: #changesFileName) = name]]
		ifNone: nil.
	^change notNil
		ifTrue: [change currentVersion sourceReference
			informationAt: #applicationVersion]]

{ #category : #accessing }
Changeset >> integratorEmail [
	^self class integratorEmail]

{ #category : #accessing }
Changeset >> integrators [
	^self class integrators]

{ #category : #testing }
Changeset >> isClassComment: node [
	| receiver |
	node class == MessageNode ifFalse: [^false].
	node selector value == #comment: ifFalse: [^false].
	receiver := node receiver.
	^receiver isIdentifier and: [receiver name first isUppercase]]

{ #category : #testing }
Changeset >> isClassInitialization: node [
	| receiver |
	node class == MessageNode ifFalse: [^false].
	node selector value == #initialize ifFalse: [^false].
	receiver := node receiver.
	^receiver isIdentifier and: [receiver name first isUppercase]]

{ #category : #testing }
Changeset >> isClassRemove: node [
	| receiver |
	node class == MessageNode ifFalse: [^false].
	node selector value == #removeFromSystem ifFalse: [^false].
	receiver := node receiver.
	^receiver isIdentifier and: [receiver name first isUppercase]]

{ #category : #testing }
Changeset >> isClassRename: node [
	| receiver |
	node class == MessageNode ifFalse: [^false].
	node selector value == #rename: ifFalse: [^false].
	receiver := node receiver.
	^receiver isIdentifier and: [receiver name first isUppercase]]

{ #category : #testing }
Changeset >> isCurrentProjectChanges [
	^false]

{ #category : #testing }
Changeset >> isEmpty [
	^changes isEmpty]

{ #category : #testing }
Changeset >> isFullyLoaded [
	^changes
		conform: [:ch | ch changesSomething not or: [ch changesOnlyFormat]]]

{ #category : #accessing }
Changeset >> label [
	^String streamContents: [:strm | 
		strm nextPutAll: 'Changes'.
		self filename notNil
			ifTrue: [strm nextPutAll: ' from '; nextPutAll: self filename asString]]]

{ #category : #utils }
Changeset >> logSent [
	| file |
	file := 'sent.txt' asFilename asFile appendStream.
	[
		file
			nextPutAll: Timestamp now ddmmyyyyhhmmss;
			tab;
			nextPutAll: filename entityName;
			cr]
		ensure: [file close]]

{ #category : #utils }
Changeset >> mergeWith: otherChanges [
	| newChanges |
	newChanges := OrderedCollection new.
	otherChanges do: [:change | 
		changes
			detect: [:ch | ch refersTo = change refersTo
				and: [ch timestamp > change timestamp]]
			ifNone: [newChanges add: change]].
	changes addAll: newChanges]

{ #category : #private }
Changeset >> methodCategoryFrom: aMessageNode [
	^(aMessageNode selector value beginsWith: #methodsFor:)
		ifTrue: [aMessageNode arguments first value]]

{ #category : #'file in/out' }
Changeset >> methodRemovalFrom: node [
	| change class receiver selector cm |
	change := MethodRemoval new.
	receiver := node receiver.
	class := receiver isIdentifier
		ifTrue: [receiver name asSymbol]
		ifFalse: [receiver receiver value , ' class'].
	selector := node arguments anyone value.
	change className: class; selector: selector.
	cm := CompiledMethod fromSignature: class , '>>' , selector.
	cm notNil ifTrue: [change prev: cm source].
	^change]

{ #category : #utils }
Changeset >> moveClassDefinitionsToTop [
	| classes |
	classes := changes select: [:c | c isClassDefinition].
	changes removeAll: classes.
	classes reverseDo: [:c | changes addFirst: c]]

{ #category : #services }
Changeset >> moveIntegratedTo: dirPath [
	| version |
	version := self integrationVersion ifNil: [Smalltalk version].
	version := version printDecimals: 4 separatedBy: $..
	self class move: filename asFilename under: dirPath version: version.
	self triggerEvent: #integratedIn: with: version.
	^version]

{ #category : #services }
Changeset >> moveToIntegrated [
	^self moveIntegratedTo: self class changesDirectory]

{ #category : #accessing }
Changeset >> name [
	^self filename notNil ifTrue: [self filename fileNameOnly]]

{ #category : #private }
Changeset >> newChange: aClass [
	^aClass new owner: self; author: self currentUser]

{ #category : #testing }
Changeset >> notEmpty [
	^changes notEmpty]

{ #category : #copying }
Changeset >> postCopy [
	super postCopy.
	changes := changes copy]

{ #category : #accessing }
Changeset >> preamble [
	| candidate |
	candidate := changes notEmpty ifTrue: [changes first].
	^candidate isPreamble ifTrue: [candidate]]

{ #category : #accessing }
Changeset >> preamble: aString [
	| preamble |
	preamble := self preamble.
	preamble isNil ifTrue: [
		preamble := self newChange: ChangeLogPreamble.
		changes addFirst: preamble].
	preamble contents: aString]

{ #category : #private }
Changeset >> prevTo: aChangeRecord [
	| answer |
	answer := nil.
	changes do: [:change | 
		change == aChangeRecord ifTrue: [^answer].
		(change isLoggable and: [aChangeRecord acceptsAsPrev: change])
			ifTrue: [answer := change]].
	^answer]

{ #category : #private }
Changeset >> prevTo: aChangeRecord index: anInteger [
	| pc |
	pc := aChangeRecord prev.
	(pc isKindOf: ChangeRecord) ifTrue: [^pc].
	anInteger - 1 to: 1 by: -1 do: [:i | | change |
		change := changes at: i.
		(change isLoggable and: [aChangeRecord acceptsAsPrev: change])
			ifTrue: [^change]].
	^nil]

{ #category : #private }
Changeset >> progressIndicatorSize: anInteger message: aString [
	^self class
		progressIndicatorSize: anInteger
		message: aString
		name: self label]

{ #category : #utils }
Changeset >> promoteClass: aString [
	| promoted |
	promoted := OrderedCollection new.
	changes removeAllSuchThat: [:ch | | class found |
		class := ch className.
		found := class notNil and: [(class upTo: $ ) = aString].
		found ifTrue: [promoted add: ch].
		found].
	changes := promoted , changes]

{ #category : #'file in/out' }
Changeset >> readChangeRecordsFrom: aStream lastChunk: aString [
	| chunk root node change |
	chunk := aString trimBlanks.
	chunk isEmpty ifTrue: [chunk := aStream nextChunk].
	root := Compiler parse: chunk.
	root isNil ifTrue: [^self].
	root statements isEmpty ifTrue: [^self].
	node := root statements first.
	(self definesChangeRecord: node)
		ifTrue: [
			change := self compileSilently: chunk.
			self ASSERT: change notNil.
			change notNil ifTrue: [
				change readFrom: aStream.
				self addChange: change]]
		ifFalse: [
			(self refersToClassComment: node)
				ifTrue: [^self readClassCommentFrom: aStream node: node].
			(self refersToMethodDefinition: node)
				ifTrue: [^self readMethodsFrom: aStream node: node].
			(self refersToDolphinClassification: node)
				ifTrue: [^self readDolphinClassificationFrom: aStream node: node].
			(self refersToDophinClassCategory: node)
				ifTrue: [^self readDolphinClassCategoryFrom: aStream node: node].
			change := self changeFromParseNode: node chunk: chunk.
			change notNil ifTrue: [^self addChange: change].
			root := Compiler parse: chunk.
			root isNil
				ifTrue: [self addChange: (BrokenChange on: chunk)]
				ifFalse: [self addChange: (ExpressionEvaluation on: chunk)]]]

{ #category : #'file in/out' }
Changeset >> readClassCommentFrom: aStream node: node [
	| class comment change |
	class := node receiver value.
	comment := aStream nextChunk.
	change := ClassCommentDefinition new.
	change className: class; comment: comment.
	Smalltalk at: class asSymbol ifPresent: [:cls | change prev: cls comment].
	self addChange: change]

{ #category : #'file in/out' }
Changeset >> readDolphinClassCategoryFrom: aStream node: node [
	| class category project destination author ts change |
	class := Smalltalk at: node receiver value asSymbol ifAbsent: [^self].
	category := aStream nextChunk.
	project := BeeModule named: category.
	destination := project isNil ifTrue: [self] ifFalse: [project changes].
	author := self authorFromNode: node.
	ts := self timestampFromNode: node.
	change := ClassAddition new
		className: class name;
		definition: class definitionString.
	author notNil ifTrue: [change author: author].
	ts notNil ifTrue: [change timestamp: ts].
	destination addChange: change]

{ #category : #'file in/out' }
Changeset >> readDolphinClassificationFrom: aStream node: node [
	| class selector category author ts change |
	class := node receiver isImmediate
		ifTrue: [node receiver value asString]
		ifFalse: [node receiver receiver value asString , ' class'].
	selector := node arguments first value.
	category := aStream nextLine readStream nextChunk.
	author := self authorFromNode: node.
	ts := self timestampFromNode: node.
	change := SelectorClassification new
		className: class;
		selector: selector;
		category: category.
	author notNil ifTrue: [change author: author].
	ts notNil ifTrue: [change timestamp: ts].
	self addChange: change]

{ #category : #'file in/out' }
Changeset >> readFrom: aStream [
	| bom size progress |
	aStream size - aStream position >= 3 ifTrue: [
		bom := aStream next: 3.
		bom asByteArray = UTF8 prefix ifFalse: [aStream skip: -3]].
	size := (aStream size max: 1) / 100.0.
	progress := self progressIndicatorSize: size message: 'Reading Changeset…'.
	[
		[aStream atEnd or: [aStream peek asInteger > $  asInteger]]
			whileFalse: [aStream next].
		[aStream atEnd or: [progress wasCanceled]] whileFalse: [| chunk prev |
			prev := aStream position.
			chunk := aStream nextChunk.
			[
				chunk isEmpty
					ifTrue: [self readChangeRecordsFrom: aStream lastChunk: chunk]
					ifFalse: [self readStEvaluationFrom: aStream lastChunk: chunk]]
				on: Error
				do: [:error | | broken n |
					error halt.
					('Error parsing: <' , chunk , '>') print.
					n := aStream position - prev + 1.
					aStream position: prev.
					broken := aStream next: n.
					self addChange: (BrokenChange on: broken)].
			progress percent: (aStream position / size) truncated]]
		ensure: [progress closeWindow]]

{ #category : #'file in/out' }
Changeset >> readFromPath: aFilename [
	| file |
	filename := aFilename asFilename.
	file := filename asFile readStream.
	[self readFrom: file] ensure: [file close]]

{ #category : #'squeak support' }
Changeset >> readFromSqueak: aStream [
	| answer size progress toBeFiledIn chunk change |
	answer := OrderedCollection new.
	size := aStream size // 100.
	progress := self
		progressIndicatorSize: size
		message: 'Reading Project Changes…'.
	[
		[aStream atEnd or: [aStream peek asInteger > $  asInteger]]
			whileFalse: [aStream next].
		[aStream atEnd or: [progress wasCanceled]] whileFalse: [
			toBeFiledIn := aStream peekFor: $!.
			chunk := aStream nextSqueakChunk.
			change := Compiler evaluate: chunk.
			toBeFiledIn ifTrue: [
				change notNil ifTrue: [
					change readFromSqueak: aStream.
					answer add: change]].
			progress percent: aStream position // size]]
		ensure: [progress closeWindow].
	^answer]

{ #category : #'file in/out' }
Changeset >> readStEvaluationFrom: aStream lastChunk: aString [
	| chunk root node change |
	chunk := aString trimBlanks.
	chunk isEmpty ifTrue: [chunk := aStream nextChunk].
	root := Compiler parse: chunk.
	root isNil ifTrue: [^self].
	root statements isEmpty ifTrue: [
		(aString first = $" and: [aString last = $"])
			ifTrue: [self addChange: (CommentRecord on: aString)].
		^self].
	node := root statements first.
	change := self changeFromParseNode: node chunk: chunk.
	change notNil ifTrue: [
		self addChange: change.
		^self].
	(self refersToMethodDefinition: node) ifTrue: [
		self readMethodsFrom: aStream node: node.
		^self].
	self addChange: (ExpressionEvaluation on: node source)]

{ #category : #'file in/out' }
Changeset >> refersToClassComment: node [
	^node hasSends and: [node selector value == #commentStamp:prior:]]

{ #category : #'file in/out' }
Changeset >> refersToDolphinClassification: node [
	^node class == MessageNode and: [node selector value = #categoriesFor:]]

{ #category : #'file in/out' }
Changeset >> refersToDophinClassCategory: node [
	^node class == MessageNode and: [node selector value = #categoriesForClass]]

{ #category : #'file in/out' }
Changeset >> refersToMethodDefinition: node [
	^node class == MessageNode and: [
		(node selector value beginsWith: 'methodsFor')
			or: [node selector value == #methods]]]

{ #category : #'file in/out' }
Changeset >> rejectUpToDate [
	self selectChanges: #changesSomething]

{ #category : #accessing }
Changeset >> removeChange: aChangeRecord [
	changes remove: aChangeRecord]

{ #category : #testing }
Changeset >> removesMethod: aParseNode [
	| receiver |
	aParseNode class == MessageNode ifFalse: [^false].
	aParseNode selector value == #removeSelector: ifFalse: [^false].
	receiver := aParseNode receiver.
	^receiver class == MessageNode
		ifTrue: [receiver selector value == #class]
		ifFalse: [receiver isIdentifier and: [receiver name first isUppercase]]]

{ #category : #services }
Changeset >> saveAsSegment: aString [
	| segment builder |
	CursorPointer showBusyWhile: [
		segment := CodeImageSegment named: aString.
		segment notNil ifTrue: [
			segment prepareForEdit.
			CodeImageSegment removeNames: segment].
		[
			builder := self buildLibrary: aString.
			builder writeFile]
			ensure: [segment isNil ifFalse: [CodeImageSegment addNames: segment]].
		SourceManager current
			evaluateLogging: '"*** saved image segment ' , aString , ' on: '
				, Timestamp now iso8601
				, ' ***"'].
	^builder]

{ #category : #'file in/out' }
Changeset >> saveChanges [
	| bak file |
	changes isEmpty ifTrue: [^self].
	bak := self filename appendExtension: '.bak'.
	self filename copyFileAs: bak.
	file := self fileStream setToEnd.
	[self saveOn: file] ensure: [file close].
	changes := OrderedCollection new]

{ #category : #'file in/out' }
Changeset >> saveOn: aStream [
	| progress size |
	changes isEmpty ifTrue: [^self].
	size := changes size.
	progress := self class
		progressIndicatorSize: size
		message: 'Saving Project Changes…'
		name: self label.
	[
		changes withIndexDo: [:ch :i | 
			ch saveOn: aStream index: i.
			aStream cr; cr.
			progress percent: i * 100 // size.
			progress wasCanceled ifTrue: [^self]]]
		ensure: [progress closeWindow]]

{ #category : #utils }
Changeset >> selectChanges: selectionBlock [
	changes := changes select: selectionBlock]

{ #category : #accessing }
Changeset >> selection: dummy [
	"
	ignored here
	"
	]

{ #category : #testing }
Changeset >> shouldAddToChanges [
	^true]

{ #category : #testing }
Changeset >> shouldLogOnSmalltalkChanges [
	^true]

{ #category : #'squeak support' }
Changeset >> size [
	^changes size]

{ #category : #'file in/out' }
Changeset >> squeakFileOutOn: aStream [
	changes do: [:change | 
		change notNil ifTrue: [
			change squeakFileOutOn: aStream.
			aStream cr; cr]]]

{ #category : #'file in/out' }
Changeset >> timestampFromNode: node [
	| stream ts |
	^node selector value == #methodsFor:stamp: ifTrue: [
		stream := node arguments second value readStream.
		stream upTo: $ .
		ts := stream upToEnd.
		ts notEmpty ifTrue: [Timestamp mmddyyyyhhmmss: ts]]]

{ #category : #private }
Changeset >> unloadedProjectNames [
	^Set new
		select: [:ch | ch isProjectLoaded not]
		thenCollect: [:ch | ch projectName]
		from: changes]

{ #category : #utils }
Changeset >> validate [
	self hasBrokenChanges
		ifTrue: [self error: 'You should not send a changeset with broken changes']]

{ #category : #utils }
Changeset >> validateForUpdate [
	(changes count: #isEvaluation) > 1 ifTrue: [
		Notification
			signal: 'Only one evaluation is allowed when building a library.'.
		^false].
	(changes conform: [:each | 
		each isOrganizationChange
			or: [each isEvaluation]
			or: [each isMethodDefinition]
			or: [each isClassDefinition and: [each definesNewClass]]])
		ifFalse: [
			Notification
				signal: 'Only method definitions are allowed when building a library.'.
			^false].
	(changes
		anySatisfy: [:each | each isEvaluation not and: [each changesSomething]])
		ifTrue: [
			Notification signal: 'All methods must be loaded into the image.'.
			^false].
	^true]

{ #category : #testing }
Changeset >> wasIntegrated [
	| name |
	name := filename asFilename withoutExtension entityName.
	^self isFullyLoaded or: [
		changes anySatisfy: [:ch | | cm reference |
			ch isMethodDefinition
				and: [(cm := ch currentVersion) notNil]
				and: [(reference := cm sourceReference) hasInformation]
				and: [(reference informationAt: #changesFileName) = name]]]]

