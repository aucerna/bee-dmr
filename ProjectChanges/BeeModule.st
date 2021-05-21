"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #BeeModule }

{ #category : '*ProjectChanges' }
BeeModule >> fileInChangesFrom: aStream [
	^[ProjectChanges fileInFrom: aStream for: self]
		on: UndeclaredIdentifierError
		do: [:error | 
			error fullDescription print.
			error addToUnresolved proceed]]

{ #category : '*ProjectChanges' }
BeeModule >> fileOutClassDefinition: aClass on: aStream [
	| change |
	change := ClassDefinition basicNew
		class: aClass;
		project: self;
		fileOutOn: aStream.
	aStream cr; cr.
	aClass classVariables keysAndValuesDo: [:v :pool | 
		(pool class == PoolDictionary andNot: [pool == Smalltalk unresolvedNames])
			ifTrue: [
				self
					fileOutPool: pool
					named: '(' , aClass name , ' classVarNamed: ' , v printString
						, ' put: PoolDictionary new)'
					on: aStream]].
	aClass class instVarNames isEmpty ifFalse: [
		aStream cr.
		change class: aClass class; fileOutOn: aStream.
		aStream cr].
	aClass comment notEmpty ifTrue: [
		aStream cr.
		(ClassCommentDefinition basicNew className: aClass name) fileOutOn: aStream.
		aStream cr]]

{ #category : '*ProjectChanges' }
BeeModule >> fileOutGlobal: aSymbol on: aStream [
	| global change cls |
	global := Smalltalk at: aSymbol.
	cls := global class == PoolDictionary
		ifTrue: [PoolDictionaryAddition]
		ifFalse: [GlobalAddition].
	change := cls basicNew globalName: aSymbol; project: self.
	aStream cr.
	change fileOutOn: aStream.
	global class == PoolDictionary
		ifTrue: [self fileOutPool: global named: aSymbol on: aStream]]

{ #category : '*ProjectChanges' }
BeeModule >> fileOutLoadAction: action on: aStream [
	action isEmptyOrNil ifTrue: [^self].
	BindActionDefinition basicNew
		action: action;
		project: self;
		fileOutOn: aStream.
	aStream cr; cr]

{ #category : '*ProjectChanges' }
BeeModule >> fileOutLoadActionsOn: aStream [
	self fileOutLoadAction: self loadAction on: aStream]

{ #category : '*ProjectChanges' }
BeeModule >> fileOutMethodDefinition: aCompiledMethod on: aStream [
	MethodSourceCode saveSourceOf: aCompiledMethod on: aStream project: self]

{ #category : '*ProjectChanges' }
BeeModule >> fileOutPoolVariablesOn: aStream [
	| groups |
	aStream
		cr;
		nextChunkPut: '"**** Variables added to Existing Pools ****"';
		cr.
	groups := self poolVariables groupBy: #first.
	groups keys asArray sort do: [:p | | pool vars |
		pool := Smalltalk at: p asSymbol.
		vars := groups at: p.
		(vars sortBy: #last) do: [:v | | value change |
			aStream cr.
			value := pool at: v last.
			change := PoolVariableAddition basicNew
				globalName: p asSymbol;
				variableName: v last;
				value: value.
			change project: self; fileOutOn: aStream.
			aStream cr]].
	aStream cr]

{ #category : '*ProjectChanges' }
BeeModule >> fileOutPrerequisitesOn: aStream [
	| prerequisites change |
	prerequisites := self prerequisites.
	prerequisites size = 0 ifTrue: [^self].
	aStream nextChunkPut: '"**** Prerequisites ****"'; cr; cr.
	change := PrerequisitesDefinition basicNew
		prerequisites: prerequisites;
		project: self.
	change fileOutOn: aStream.
	aStream cr]

{ #category : '*ProjectChanges' }
BeeModule >> fileOutUnloadAction: action on: aStream [
	action isEmptyOrNil ifTrue: [^self].
	aStream cr.
	UnbindActionDefinition basicNew
		action: action;
		project: self;
		fileOutOn: aStream.
	aStream cr; cr]

{ #category : '*ProjectChanges' }
BeeModule >> fileOutUnloadActionsOn: aStream [
	self fileOutUnloadAction: self unloadAction on: aStream]

{ #category : '*ProjectChanges' }
BeeModule >> initializeChanges [
	changes := ProjectChanges new project: self]

{ #category : '*ProjectChanges' }
BeeModule >> lastChangesForClass: aClass [
	| instance meta |
	instance := self lastChangesForSpecies: aClass instanceClass.
	meta := self lastChangesForSpecies: aClass instanceClass class.
	(instance notEmpty
		and: [meta notEmpty]
		and: [instance first class == meta first class])
		ifTrue: [meta removeFirst].
	^instance , meta]

{ #category : '*ProjectChanges' }
BeeModule >> lastChangesForSpecies: aClass [
	| selectors modified def commands |
	selectors := aClass selectors.
	modified := Set new.
	def := false.
	self changesDo: [:ch | | references |
		references := ch refersTo.
		ch isSelectorRename ifTrue: [
			(selectors includes: ch newSelector) ifTrue: [
				modified add: ch newSelector.
				selectors remove: ch newSelector]].
		ch isMethodChange
			ifTrue: [
				(ch className = aClass name and: [selectors includes: ch selector])
					ifTrue: [
						modified add: ch selector.
						selectors remove: ch selector]]
			ifFalse: [
				ch isClassChange ifTrue: [
					def := def
						or: [aClass isClass and: [references includes: aClass symbol]]
						or: [references includes: aClass name]]]].
	commands := OrderedCollection new.
	def ifTrue: [| change |
		change := ClassDefinition fromClass: aClass.
		commands add: change].
	modified do: [:selector | | change |
		change := MethodDefinition fromCompiledMethod: aClass >> selector.
		commands add: change].
	^commands]

