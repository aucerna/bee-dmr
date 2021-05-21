"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MethodInstallation,
	#superclass : #MethodDefinition,
	#instVars : [
		'project'
	],
	#category : #ProjectChanges
}

{ #category : #perform }
MethodInstallation >> aboutToOverwrite: aCompiledMethod with: aMethodDefinition [
	self
		aboutToOverwrite: aCompiledMethod
		with: aMethodDefinition
		from: self methodProject]

{ #category : #accessing }
MethodInstallation >> addToProject: aBeeModule [
	"
	no here
	"
	]

{ #category : #perform }
MethodInstallation >> basicPerform [
	^self changesCode
		ifTrue: [super basicPerform]
		ifFalse: [self updateSystemWith: self currentProjectVersion]]

{ #category : #testing }
MethodInstallation >> changesCode [
	| current |
	(current := self currentProjectVersion) isNil ifTrue: [^true].
	current sourceCode isNil ifTrue: [^true].
	^current sourceCode trimBlanks != self sourceCode trimBlanks]

{ #category : #testing }
MethodInstallation >> changesSomething [
	| current |
	current := self currentVersion ifNil: [^true].
	current sourceCode isNil ifTrue: [^true].
	^current sourceCode trimBlanks != self sourceCode trimBlanks]

{ #category : #testing }
MethodInstallation >> currentProjectVersion [
	| cls |
	cls := self resolveClass.
	cls isNil ifTrue: [^true].
	^self methodProject compiledMethodFor: self selector in: cls]

{ #category : #initialization }
MethodInstallation >> fromCompiledMethod: aCompiledMethod [
	super fromCompiledMethod: aCompiledMethod.
	project := aCompiledMethod project]

{ #category : #accessing }
MethodInstallation >> headerSpec [
	| spec |
	spec := super headerSpec.
	spec add: #methodProject.
	^spec]

{ #category : #testing }
MethodInstallation >> isOverridden [
	^false]

{ #category : #private }
MethodInstallation >> methodProject [
	project isString ifFalse: [^project].
	^(BeeProject named: project)
		ifNil: [BeeCluster systemCluster]
		ifNotNil: [:p | project := p]]

{ #category : #private }
MethodInstallation >> methodProject: aString [
	project := aString]

{ #category : #testing }
MethodInstallation >> tracksHistory [
	^false]

