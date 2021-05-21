"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ProjectChanges,
	#superclass : #Changeset,
	#instVars : [
		'project'
	],
	#category : #ProjectChanges
}

{ #category : #constants }
ProjectChanges class >> fileExtension [
	^'.ch']

{ #category : #'instance creation' }
ProjectChanges class >> fileInFrom: aStream for: aBeeModule [
	| changes |
	changes := self new project: aBeeModule.
	[aStream atEnd or: [aStream peek asInteger > 32]]
		whileFalse: [aStream next].
	[aStream atEnd] whileFalse: [| chunk change |
		chunk := aStream nextChunk.
		chunk isEmpty
			ifTrue: [
				change := Compiler evaluate: aStream nextChunk.
				change notNil
					ifTrue: [change projectChanges: changes; fileInFrom: aStream]]
			ifFalse: [Compiler evaluate: chunk]].
	^changes]

{ #category : #'instance creation' }
ProjectChanges class >> withId: guidString [
	| p |
	p := (BeeProject withId: guidString)
		ifNil: [BeeModule findProjectWithId: guidString].
	^p notNil ifTrue: [p changes]]

{ #category : #inquiries }
ProjectChanges >> acceptsInHistory: aChangeRecord [
	^aChangeRecord projectChanges == self
		or: [aChangeRecord class !== MethodAddition]]

{ #category : #updating }
ProjectChanges >> addCategory: categorySymbol to: aClass [
	| change |
	change := self newChange: CategoryAddition.
	change className: aClass name; category: categorySymbol; perform]

{ #category : #updating }
ProjectChanges >> addChange: aChangeRecord [
	aChangeRecord projectChanges: self.
	super addChange: aChangeRecord]

{ #category : #updating }
ProjectChanges >> addClass: aClass [
	| change |
	change := self newChange: ClassAddition.
	change
		className: aClass name;
		definition: aClass definitionString;
		perform]

{ #category : #updating }
ProjectChanges >> addClassVar: aString to: aClass [
	| change |
	change := self newChange: ClassVariableAddition.
	change className: aClass name; variable: aString; perform]

{ #category : #updating }
ProjectChanges >> addGlobal: aGlobalSymbol [
	| change |
	change := self newChange: GlobalAddition.
	change globalName: aGlobalSymbol; perform]

{ #category : #updating }
ProjectChanges >> addInstVar: aString to: aClass [
	| change |
	change := self newChange: InstanceVariableAddition.
	change className: aClass name; variable: aString; perform]

{ #category : #updating }
ProjectChanges >> addMethod: aCompiledMethod [
	^(self newChange: MethodAddition)
		compiledMethod: aCompiledMethod;
		projectChanges: self;
		perform]

{ #category : #updating }
ProjectChanges >> addPoolDictionary: aSymbol [
	| change |
	change := self newChange: PoolDictionaryAddition.
	^change globalName: aSymbol; perform]

{ #category : #updating }
ProjectChanges >> addProject: aBeeModule [
	self addProject: aBeeModule before: nil]

{ #category : #updating }
ProjectChanges >> addProject: aSmalltalkProject before: nextSmalltalkProject [
	| change |
	change := self newChange: ProjectAddition.
	change childProject: aSmalltalkProject name.
	nextSmalltalkProject notNil
		ifTrue: [change nextProjectName: nextSmalltalkProject name].
	^change perform]

{ #category : #inquiries }
ProjectChanges >> addSavedInLibraryVersionOf: aCompiledMethod to: aCollection [
	| lib org i ts |
	lib := CodeImageSegment named: project name.
	lib isNil ifTrue: [^self].
	org := lib originalVersionOf: aCompiledMethod.
	org isNil ifTrue: [^self].
	aCollection do: [:change | 
		(org timestamp = change timestamp
			and: [org sourceCode = change sourceCode])
			ifTrue: [
				change informationAt: #savedInLibrary put: true.
				^self]].
	org := MethodDefinition fromCompiledMethod: org.
	org informationAt: #savedInLibrary put: true.
	ts := org timestamp.
	i := aCollection findFirst: [:ch | ch lastPerformance < ts] ifAbsent: [
		aCollection add: org.
		^self].
	aCollection add: org at: i]

{ #category : #updating }
ProjectChanges >> addSharedPool: poolName to: aClass [
	| change |
	change := self newChange: SharedPoolAddition.
	change className: aClass name; poolName: poolName; perform]

{ #category : #updating }
ProjectChanges >> addVariableNamed: aString inPoolNamed: aGlobalSymbol [
	^self addVariableNamed: aString value: nil inPoolNamed: aGlobalSymbol]

{ #category : #updating }
ProjectChanges >> addVariableNamed: aString value: value inPoolNamed: aGlobalSymbol [
	| change |
	change := self newChange: PoolVariableAddition.
	change
		globalName: aGlobalSymbol;
		variableName: aString;
		value: value;
		perform]

{ #category : #accessing }
ProjectChanges >> allChanges [
	^self readChanges, changes]

{ #category : #enumeration }
ProjectChanges >> allChangesDo: aBlock [
	self savedChangesDo: aBlock.
	changes do: aBlock]

{ #category : #utils }
ProjectChanges >> changeAt: link [
	| position |
	link isNil ifTrue: [^nil].
	(link isKindOf: ChangeRecord) ifTrue: [^link].
	position := link.
	(link isArray and: [
		position := link last.
		link first != project id asString])
		ifTrue: [
			^(ProjectChanges withId: link first)
				ifNotNil: [:pc | pc changeAtPosition: position]].
	^self changeAtPosition: position]

{ #category : #utils }
ProjectChanges >> changeAtPosition: anInteger [
	| file prev |
	file := self filename asFilename asFile.
	file exists ifFalse: [^nil].
	file size < anInteger ifTrue: [^nil].
	file := file readStream.
	[
		file position: anInteger; prevChunk.
		prev := Compiler evaluate: file prevChunk in: self class ifFail: [^nil].
		file position: anInteger.
		prev isNil ifFalse: [
			[prev projectChanges: self; readFrom: file] on: Error do: [:e | 
				e print.
				^nil]]]
		ensure: [file close].
	^prev]

{ #category : #updating }
ProjectChanges >> changeCompile: sourceCode in: aClass [
	| change result |
	change := self methodDefinitionClass: aClass sourceCode: sourceCode.
	result := change perform.
	^result isNil ifFalse: [change]]

{ #category : #inquiries }
ProjectChanges >> changesOfClass: aClass [
	| changeset name meta |
	name := aClass name.
	meta := aClass class name.
	changeset := self
		readChangesSelecting: [:ch | ch className = name or: [ch className = meta]].
	changes
		select: [:ch | ch className = name or: [ch className = meta]]
		thenDo: [:ch | changeset addChange: ch].
	^changeset]

{ #category : #accessing }
ProjectChanges >> changesStartingAt: aDate [
	| previous |
	previous := self readChangesStartingAt: aDate.
	previous addAll: changes.
	^previous]

{ #category : #private }
ProjectChanges >> checkHistoryLinks [
	| errors firstVersions bad |
	errors := OrderedCollection new.
	firstVersions := Bag new.
	self allChangesDo: [:ch | 
		ch tracksHistory ifTrue: [| link |
			link := ch prev.
			link isNil
				ifTrue: [firstVersions add: ch refersTo]
				ifFalse: [(self changeAt: link) isNil ifTrue: [errors add: ch]]]].
	bad := firstVersions frequencies associations select: [:a | a value > 1].
	self ASSERT: bad isEmpty; ASSERT: errors isEmpty]

{ #category : #updating }
ProjectChanges >> class: aClass comment: aString [
	| change |
	change := self newChange: ClassCommentDefinition.
	change className: aClass name; comment: aString; perform]

{ #category : #updating }
ProjectChanges >> classify: selector in: aClass under: aSymbol [
	| change |
	change := self newChange: SelectorClassification.
	change
		selector: selector;
		className: aClass name;
		category: aSymbol.
	^change perform]

{ #category : #private }
ProjectChanges >> close [
	"ignored"]

{ #category : #accessing }
ProjectChanges >> compilationErrorHandler [
	^self propertyAt: #compilationErrorHandler]

{ #category : #updating }
ProjectChanges >> compile: sourceCode in: aClass [
	^self compile: sourceCode in: aClass category: nil]

{ #category : #updating }
ProjectChanges >> compile: sourceCode in: aClass category: aSymbol [
	| change result |
	change := self methodDefinitionClass: aClass sourceCode: sourceCode.
	change category: aSymbol.
	result := change perform.
	^result]

{ #category : #updating }
ProjectChanges >> compile: sourceCode notifying: textPane in: aClass [
	^self
		compile: sourceCode
		notifying: textPane
		in: aClass
		category: nil]

{ #category : #updating }
ProjectChanges >> compile: sourceCode
notifying: textPane
in: aClass
category: aSymbol [
	| change result |
	change := self methodDefinitionClass: aClass sourceCode: sourceCode.
	change category: aSymbol.
	self notifyCompilationErrorsTo: textPane while: [result := change perform].
	^result]

{ #category : #updating }
ProjectChanges >> defineClass: aString [
	^self defineClass: aString notifying: nil]

{ #category : #updating }
ProjectChanges >> defineClass: aString notifying: anObject [
	| ast msg keywords index name change |
	ast := SmalltalkParser new parseExpression: aString.
	msg := ast statements first.
	keywords := msg selector keywords collect: #value.
	index := keywords indexOf: 'subclass:' ifAbsent: [
		keywords
			indexOf: 'variableByteSubclass:'
			ifAbsent: [keywords indexOf: 'variableSubclass:']].
	name := msg arguments at: index.
	self
		notifyCompilationErrorsTo: anObject
		while: [change := self newChange: ClassDefinition].
	^change className: name value asString; definition: aString; perform]

{ #category : #updating }
ProjectChanges >> defineClassWithInstaller: classInstaller [
	| change |
	change := self newChange: ClassDefinition.
	change
		className: classInstaller className asString;
		performWithBuilder: classInstaller]

{ #category : #updating }
ProjectChanges >> defineCompiledMethod: method sourceCode: sourceCode [
	| change |
	method classBinding isNil ifTrue: [^self].
	change := MethodDefinition fromCompiledMethod: method.
	change sourceCode: sourceCode.
	self addChange: change.
	change logOnSmalltalkChanges: method; addToProject: project]

{ #category : #updating }
ProjectChanges >> defineMetaClass: definitionString [
	| name change |
	name := definitionString readStream nextSubstring.
	change := self newChange: ClassDefinition.
	^change
		className: name , ' class';
		definition: definitionString;
		perform]

{ #category : #updating }
ProjectChanges >> defineMetaClass: definitionString notifying: anObject [
	| name change |
	name := definitionString readStream
		upToAnySatisfying: [:ch | ch isSeparator].
	self
		notifyCompilationErrorsTo: anObject
		while: [change := self newChange: ClassDefinition].
	^change
		className: name , ' class';
		definition: definitionString;
		perform]

{ #category : #updating }
ProjectChanges >> description: aString [
	| change |
	change := self newChange: ProjectDescriptionDefinition.
	change description: aString; perform]

{ #category : #updating }
ProjectChanges >> developmentOnly: aBoolean [
	| change |
	change := self newChange: ProjectSettingDefinition.
	change setting: 'developmentOnly' value: aBoolean; perform]

{ #category : #updating }
ProjectChanges >> duplicateClass: aClass withName: aString [
	| change |
	change := self newChange: ClassDuplicate.
	change className: aClass name; duplicateAs: aString.
	^change perform]

{ #category : #'filein/out' }
ProjectChanges >> fileInChange: changeRecord from: aStream [
	changeRecord projectChanges: self.
	^super fileInChange: changeRecord from: aStream]

{ #category : #'filein/out' }
ProjectChanges >> fileInFrom: aStream [
	[aStream atEnd or: [aStream peek asInteger > $  asInteger]]
		whileFalse: [aStream next].
	[aStream atEnd] whileFalse: [| chunk change class category result |
		chunk := aStream nextChunk.
		chunk isEmpty
			ifTrue: [
				chunk := aStream nextChunk.
				change := Compiler evaluate: chunk.
				change isNil ifTrue: [^self].
				(change isKindOf: ChangeRecord)
					ifTrue: [change projectChanges: self; fileInFrom: aStream]
					ifFalse: [
						class := change classBinding.
						category := change category.
						[(chunk := aStream nextChunk) isEmpty] whileFalse: [
							change := MethodDefinition new
								projectChanges: self;
								className: class name;
								category: category;
								sourceCode: chunk;
								yourself.
							change perform]]]
			ifFalse: [
				result := Compiler evaluate: chunk.
				result isSpecies ifTrue: [
					change := ClassDefinition new
						projectChanges: self;
						className: result name;
						definition: chunk trimComments trimBlanks;
						yourself.
					self addChange: change]]]]

{ #category : #accessing }
ProjectChanges >> filename [
	^filename
		ifNil: [filename := project filename
			withExtension: self class fileExtension]]

{ #category : #'filein/out' }
ProjectChanges >> fileOutFrom: aTimestamp on: aStream compress: compressBool [
	| changeList |
	changeList := self allChanges.
	aTimestamp notNil
		ifTrue: [changeList := changeList
			select: [:ch | ch timestamp >= aTimestamp]].
	compressBool ifTrue: [changeList := self compressChanges: changeList].
	changeList do: [:changeRecord | 
		changeRecord fileOutOn: aStream.
		aStream cr; cr]]

{ #category : #'filein/out' }
ProjectChanges >> fileOutOn: aStream [
	self fileOutFrom: nil on: aStream compress: true]

{ #category : #squeakSupport }
ProjectChanges >> fileStream [
	^self filename asFile writeStream eol: String cr]

{ #category : #updating }
ProjectChanges >> forgetClass: aClass [
	| change |
	change := self newChange: ClassForget.
	change className: aClass name; perform]

{ #category : #updating }
ProjectChanges >> forgetGlobal: aGlobalSymbol [
	| change |
	change := self newChange: GlobalForget.
	change globalName: aGlobalSymbol asSymbol; perform]

{ #category : #updating }
ProjectChanges >> forgetMethod: aCompiledMethod [
	| change |
	change := self newChange: MethodForget.
	change
		className: aCompiledMethod classBinding name;
		selector: aCompiledMethod selector;
		perform]

{ #category : #updating }
ProjectChanges >> forgetProject: aSmalltalkProject [
	| change |
	change := self newChange: ProjectForget.
	change childProject: aSmalltalkProject name; perform]

{ #category : #testing }
ProjectChanges >> hasModifiedSelectorsIn: aClass [
	^changes
		anySatisfy: [:ch | ch isMethodChange and: [ch refersToClass: aClass]]]

{ #category : #testing }
ProjectChanges >> hasModifiedSelectorsInAnyOf: classCollection [
	| names |
	names := classCollection collect: #name.
	^changes
		anySatisfy: [:ch | ch isMethodChange and: [names includes: ch className]]]

{ #category : #inquiries }
ProjectChanges >> historyOf: method [
	| history change cls m |
	change := method isCompiledMethod
		ifTrue: [
			m := self project
				compiledMethodFor: method selector
				in: method classBinding.
			MethodDefinition fromCompiledMethod: m in: self project]
		ifFalse: [m := method].
	history := (changes select: [:ch | ch acceptsAsPrev: change]) reversed.
	change := history isEmpty
		ifTrue: [self changeAt: m sourceReference changeLink]
		ifFalse: [history last prevChange].
	cls := method classBinding name.
	[change notNil] whileTrue: [
		change isBroken ifFalse: [change className: cls].
		(self acceptsInHistory: change) ifTrue: [history add: change].
		change := change prevChange].
	self addSavedInLibraryVersionOf: m to: history.
	^history]

{ #category : #inquiries }
ProjectChanges >> historyOfClass: aClass [
	| history change |
	change := aClass changeLink
		ifNil: [ClassDefinition fromClass: aClass]
		ifNotNil: [:link | self changeAt: link].
	history := OrderedCollection new.
	[change notNil] whileTrue: [
		history add: change.
		change := change prevChange].
	^history]

{ #category : #testing }
ProjectChanges >> includesIdentical: aChangeRecord [
	^changes includesIdentical: aChangeRecord]

{ #category : #updating }
ProjectChanges >> insertInstVar: ivar1 to: aClass before: ivar2 [
	| change |
	change := self newChange: InstanceVariableInsertion.
	change
		className: aClass name;
		next: ivar2;
		variable: ivar1;
		perform]

{ #category : #updating }
ProjectChanges >> installMethod: method [
	| change |
	change := self newChange: MethodInstallation.
	^change fromCompiledMethod: method; perform]

{ #category : #testing }
ProjectChanges >> isCurrentProjectChanges [
	^true]

{ #category : #accessing }
ProjectChanges >> label [
	| label |
	label := 'Bee Project'.
	project notNil ifTrue: [label := label , ' ' , project name].
	^label]

{ #category : #updating }
ProjectChanges >> loadAction: aMessage [
	| change |
	change := self newChange: BindActionDefinition.
	change action: aMessage; perform]

{ #category : #updating }
ProjectChanges >> methodDefinitionClass: aClass sourceCode: sourceCode [
	| change |
	change := self newChange: MethodDefinition.
	^change className: aClass name; sourceCode: sourceCode]

{ #category : #updating }
ProjectChanges >> methodRecompilationClass: aClass sourceCode: sourceCode [
	| change |
	change := self newChange: MethodRecompilation.
	^change className: aClass name; sourceCode: sourceCode]

{ #category : #inquiries }
ProjectChanges >> modifiedSelectorsIn: aClass [
	^self modifiedSelectorsInAnyOf: {aClass}]

{ #category : #inquiries }
ProjectChanges >> modifiedSelectorsInAnyOf: classCollection [
	| names |
	names := classCollection collect: #name.
	^changes
		select: [:ch | ch isMethodChange and: [names includes: ch className]]
		thenCollect: [:ch | ch selector]]

{ #category : #updating }
ProjectChanges >> moveCategory: category inClass: aClass to: category2 [
	| change |
	change := self newChange: CategoryMove.
	change
		className: aClass name;
		category: category;
		destination: category2;
		perform]

{ #category : #updating }
ProjectChanges >> moveDownClassVar: varName of: aClass to: targetClass [
	| change |
	change := self newChange: ClassVariableMoveDown.
	change
		className: aClass name;
		varName: varName;
		target: targetClass name;
		perform]

{ #category : #updating }
ProjectChanges >> moveDownInstVar: varName of: aClass to: targetClass [
	| change |
	change := self newChange: InstanceVariableMoveDown.
	change
		className: aClass name;
		varName: varName;
		target: targetClass name;
		perform]

{ #category : #updating }
ProjectChanges >> moveDownInstVar: varName of: aClass toAll: aCollection [
	| change |
	change := self newChange: InstanceVariableMoveDown.
	change
		className: aClass name;
		varName: varName;
		target: (aCollection collect: #name);
		perform]

{ #category : #updating }
ProjectChanges >> moveUpClassVar: varName of: aClass [
	| change |
	change := self newChange: ClassVariableMoveUp.
	change className: aClass name; varName: varName; perform]

{ #category : #updating }
ProjectChanges >> moveUpInstVar: varName of: aClass [
	| change |
	change := self newChange: InstanceVariableMoveUp.
	change className: aClass name; varName: varName; perform]

{ #category : #accessing }
ProjectChanges >> name [
	^project name]

{ #category : #private }
ProjectChanges >> newChange: aClass [
	| change |
	change := super newChange: aClass.
	^change projectChanges: self]

{ #category : #updating }
ProjectChanges >> newCluster: aString [
	| change |
	change := self newChange: ClusterDefinition.
	^change childProject: aString asString; perform]

{ #category : #updating }
ProjectChanges >> newProject: aString [
	| change |
	change := self newChange: ProjectDefinition.
	^change childProject: aString; perform]

{ #category : #'filein/out' }
ProjectChanges >> nextChangeFrom: aStream [
	| prev chunk |
	prev := aStream position.
	chunk := aStream nextChunk.
	^[
		chunk isEmpty ifFalse: [^nil].
		chunk := aStream nextChunk.
		(self compileSilently: chunk)
			ifNil: [BrokenChange on: chunk , '!
	' , aStream nextChunk]
			ifNotNil: [:change | change projectChanges: self; readFrom: aStream]]
		on: Error
		do: [| n broken |
			('Error parsing: <' , chunk , '>') print.
			n := aStream position - prev + 1.
			aStream position: prev.
			broken := aStream next: n.
			BrokenChange on: broken]]

{ #category : #notifications }
ProjectChanges >> notifyCompilationErrorsTo: anObject [
	self
		propertyAt: #compilationErrorHandler
		put: (ModalCompilationErrorHandler on: anObject)]

{ #category : #notifications }
ProjectChanges >> notifyCompilationErrorsTo: anObject while: aBlock [
	self notifyCompilationErrorsTo: anObject.
	aBlock ensure: [self removeProperty: #compilationErrorHandler]]

{ #category : #updating }
ProjectChanges >> prerequisites: aCollection [
	| change |
	change := self newChange: PrerequisitesDefinition.
	change prerequisites: aCollection; perform]

{ #category : #initialization }
ProjectChanges >> printOn: aStream [
	project printOn: aStream.
	aStream nextPutAll: ' project changes']

{ #category : #accessing }
ProjectChanges >> project [
	^project]

{ #category : #accessing }
ProjectChanges >> project: aSmalltalkProject [
	project := aSmalltalkProject.
	changes do: [:ch | ch projectChanges: self].
	filename := project filename withExtension: self class fileExtension]

{ #category : #updating }
ProjectChanges >> project: smalltalkProject renamedTo: aString [
	| change |
	change := self newChange: ProjectRenamed.
	change childProject: smalltalkProject name; newName: aString; perform]

{ #category : #'filein/out' }
ProjectChanges >> readChanges [
	| answer |
	answer := OrderedCollection new.
	self savedChangesDo: [:ch | answer add: ch].
	^answer]

{ #category : #private }
ProjectChanges >> readChangesSelecting: aBlock [
	| changeset file compiler |
	changeset := Changeset new.
	file := self filename asFilename asFile.
	file exists ifFalse: [^changeset].
	file := file readStream.
	compiler := Compiler forClass: self class.
	compiler onErrorUse: UnattendedCompilationErrorHandler new.
	[| size progress |
		size := file size // 100.
		progress := self
			progressIndicatorSize: size
			message: 'Reading Project Changes…'.
		[
			[file atEnd or: [file peek asInteger > $  asInteger]]
				whileFalse: [file next].
			[
				file atEnd or: [
					Smalltalk processAllMessages.
					progress wasCanceled]]
				whileFalse: [| chunk change |
					chunk := file nextChunk.
					chunk isEmpty ifTrue: [
						chunk := file nextChunk.
						change := compiler evaluate: chunk.
						change notNil ifTrue: [
							(aBlock value: change)
								ifTrue: [
									change projectChanges: self; readFrom: file.
									changeset addChange: change]
								ifFalse: [file nextChunk]]].
					progress percent: file position // size]]
			ensure: [progress closeWindow]]
		ensure: [file close].
	^changeset]

{ #category : #private }
ProjectChanges >> readChangesStartingAt: aDate [
	| changeset file compiler |
	changeset := Changeset new.
	file := self filename asFilename asFile.
	file exists ifFalse: [^changeset].
	file := file readStream.
	file setToEnd.
	compiler := Compiler forClass: self class.
	compiler onErrorUse: ModalCompilationErrorHandler new.
	[| size progress |
		size := file size // 100.
		progress := self
			progressIndicatorSize: size
			message: 'Reading Project Changes…'.
		[
			[file position = 0 or: [file prev asInteger > $  asInteger]]
				whileFalse: [].
			file position = 0 ifFalse: [file next].
			[
				file position = 0 or: [
					Smalltalk processAllMessages.
					progress wasCanceled]]
				whileFalse: [| chunk change header |
					chunk := file prevChunk.
					chunk isEmpty ifTrue: [
						chunk := file prevChunk.
						header := file prevChunk.
						change := compiler evaluate: header.
						change notNil ifTrue: [
							change timestamp date >= aDate ifFalse: [^changeset].
							change projectChanges: self; readFrom: chunk readStream.
							changeset addChange: change]].
					progress percent: size - file position // size]]
			ensure: [progress closeWindow]]
		ensure: [file close].
	^changeset]

{ #category : #updating }
ProjectChanges >> recompile: aCompiledMethod with: sourceCode [
	| change result |
	change := self
		methodRecompilationClass: aCompiledMethod classBinding
		sourceCode: sourceCode.
	change category: aCompiledMethod category.
	result := change perform.
	change prev: aCompiledMethod sourceReference changeLink.
	^result]

{ #category : #updating }
ProjectChanges >> recompileOverriddenMethod: overwrittenMethod withSource: aString [
	| change cm |
	change := self newChange: OverriddenMethodDefinition.
	change fromCompiledMethod: overwrittenMethod.
	change sourceCode: aString.
	cm := change perform.
	cm selector == overwrittenMethod selector
		ifFalse: [self project addMethodDefinition: change].
	^cm]

{ #category : #updating }
ProjectChanges >> redefinedClass: aClass [
	| change |
	change := self newChange: ClassRedefinition.
	change class: aClass; perform]

{ #category : #accessing }
ProjectChanges >> referenceString [
	^project referenceString, ' changes ']

{ #category : #updating }
ProjectChanges >> reinstallClass: aClass [
	| change |
	change := self newChange: ClassReinstall.
	change
		className: aClass name;
		definition: aClass definitionString;
		perform]

{ #category : #updating }
ProjectChanges >> removeCategory: categorySymbol in: aClass [
	| change |
	change := self newChange: CategoryRemoval.
	change className: aClass name; category: categorySymbol; perform]

{ #category : #updating }
ProjectChanges >> removeClass: aClass [
	| change |
	change := self newChange: ClassRemoval.
	change className: aClass name; perform]

{ #category : #updating }
ProjectChanges >> removeClassVar: aString from: aClass [
	| change |
	change := self newChange: ClassVariableRemoval.
	change className: aClass name; variable: aString; perform]

{ #category : #updating }
ProjectChanges >> removeInstVar: aString from: aClass [
	| change |
	change := self newChange: InstanceVariableRemoval.
	change className: aClass name; variable: aString; perform]

{ #category : #updating }
ProjectChanges >> removeSelector: selector from: aClass [
	| change |
	change := self newChange: MethodRemoval.
	change className: aClass name; selector: selector; perform]

{ #category : #updating }
ProjectChanges >> removeSharedPool: poolName from: aClass [
	| change |
	change := self newChange: SharedPoolRemoval.
	change className: aClass name; poolName: poolName; perform]

{ #category : #updating }
ProjectChanges >> renameCategory: category inClass: aClass to: aString [
	| change |
	change := self newChange: CategoryRename.
	change
		className: aClass name;
		category: category;
		newName: aString;
		perform]

{ #category : #updating }
ProjectChanges >> renameClass: aClass to: newName [
	self renameClass: aClass to: newName renameReferences: false]

{ #category : #updating }
ProjectChanges >> renameClass: aClass to: aString renameReferences: aBoolean [
	| change |
	change := self newChange: ClassRename.
	change
		className: aClass name;
		newName: aString;
		renameReferences: aBoolean;
		perform]

{ #category : #updating }
ProjectChanges >> renameClassVar: aString of: aClass to: anotherString [
	| change |
	change := self newChange: ClassVariableRename.
	change
		className: aClass name;
		varName: aString;
		newName: anotherString;
		perform]

{ #category : #updating }
ProjectChanges >> renameGlobal: aSymbol to: aString [
	| change |
	change := self newChange: GlobalRename.
	change globalName: aSymbol; newName: aString asSymbol; perform]

{ #category : #updating }
ProjectChanges >> renameInstVar: varName of: aClass to: aString [
	| change |
	change := self newChange: InstanceVariableRename.
	change
		className: aClass name;
		varName: varName;
		newName: aString;
		perform]

{ #category : #updating }
ProjectChanges >> renameProject: smalltalkProject to: aString [
	| change |
	self ASSERT: smalltalkProject = self project.
	change := self newChange: ProjectRename.
	change newName: aString; perform]

{ #category : #updating }
ProjectChanges >> renameSelector: aSymbol as: anotherSymbol [
	| change |
	change := self newChange: SelectorRename.
	change selector: aSymbol; newSelector: anotherSymbol; perform]

{ #category : #updating }
ProjectChanges >> reorganize: aClass with: categoryCollection [
	| change |
	change := self newChange: CategoryReorganization.
	change className: aClass name; categories: categoryCollection; perform]

{ #category : #utils }
ProjectChanges >> repairHistory [
	| bak file |
	changes := self allChanges.
	bak := self filename appendExtension: '.bak'.
	self filename copyFileAs: bak.
	changes do: [:ch | ch prev: nil].
	file := self fileStream truncate.
	[self saveOn: file] ensure: [file close].
	changes := OrderedCollection new]

{ #category : #enumeration }
ProjectChanges >> savedChangesDo: aBlock [
	| file size progress |
	file := self filename asFilename asFile.
	file exists ifFalse: [^self].
	file := file readStream.
	size := file size // 100.
	progress := self
		progressIndicatorSize: size
		message: 'Reading Project Changes…'.
	[
		[file atEnd or: [file peek asInteger > $  asInteger]]
			whileFalse: [file next].
		[file atEnd or: [progress wasCanceled]] whileFalse: [
			(self nextChangeFrom: file)
				ifNotNil: [:change | aBlock evaluateWith: change].
			progress percent: file position // size]]
		ensure: [
			progress closeWindow.
			file close]]

{ #category : #squeakSupport }
ProjectChanges >> saveOn: aStream [
	aStream eol: String cr.
	super saveOn: aStream]

{ #category : #updating }
ProjectChanges >> storeNativeCode: aBoolean [
	| change |
	change := self newChange: ProjectSettingDefinition.
	change setting: #storeNativeCode value: aBoolean; perform]

{ #category : #updating }
ProjectChanges >> unloadAction: aMessage [
	| change |
	change := self newChange: UnbindActionDefinition.
	change action: aMessage; perform]

{ #category : #testing }
ProjectChanges >> wasModifiedCategory: category in: aClass [
	aClass isNil ifTrue: [^false].
	^((aClass selectorsInCategory: category) ifNil: [^false])
		anySatisfy: [:s | self wasModifiedSelector: s in: aClass]]

{ #category : #testing }
ProjectChanges >> wasModifiedClass: aClass [
	| class classname meta |
	class := aClass instanceClass.
	classname := class name.
	meta := classname , ' class'.
	^changes anySatisfy: [:ch | 
		ch className = classname
			or: [ch className = meta]
			or: [ch refersTo includes: classname]
			or: [
				ch class == SelectorRename and: [
					(class includesSelector: ch newSelector)
						and: [(class >> ch newSelector) timestamp >= ch timestamp]]]]]

{ #category : #testing }
ProjectChanges >> wasModifiedSelector: aSymbol in: aClass [
	| classname prev selector combinations |
	classname := aClass isString ifTrue: [aClass] ifFalse: [aClass name].
	changes
		select: [:ch | 
			(ch class == ClassRename and: [ch newName = classname])
				ifTrue: [prev := ch className].
			ch class == SelectorRename ifTrue: [
				(ch changesSelector: aSymbol in: aClass) ifTrue: [^true].
				ch newSelector == aSymbol ifTrue: [selector := ch selector]].
			ch isMethodChange
				and: [classname = ch className]
				and: [aSymbol == ch selector]]
		thenDo: [:ch | ^true].
	(prev isNil and: [selector isNil]) ifTrue: [^false].
	combinations := OrderedCollection new.
	prev notNil ifTrue: [
		combinations add: prev -> aSymbol.
		selector notNil ifTrue: [combinations add: prev -> selector]].
	selector notNil ifTrue: [combinations add: classname -> selector].
	^combinations anySatisfy: [:assoc | 
		assoc value !== aSymbol
			or: [assoc key != aClass]
			or: [self wasModifiedSelector: assoc value in: assoc key]]]

{ #category : #testing }
ProjectChanges >> wasProjectRenamed [
	^changes anySatisfy: [:ch | ch isKindOf: ProjectRename]]

