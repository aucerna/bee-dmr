"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PoolVariableAddition,
	#superclass : #GlobalAddition,
	#instVars : [
		'variableName',
		'value'
	],
	#category : #ProjectChanges
}

{ #category : #perform }
PoolVariableAddition >> basicPerform [
	self project addVariableNamed: variableName inPoolNamed: globalName]

{ #category : #testing }
PoolVariableAddition >> changesSomething [
	| g |
	(g := self resolveGlobal) isNil ifTrue: [^true].
	(g includesKey: variableName) ifFalse: [^true].
	^(self project poolVariables includes: {globalName. variableName}) not]

{ #category : #perform }
PoolVariableAddition >> defineGlobal [
	| pool |
	pool := Smalltalk at: globalName ifAbsentPut: [PoolDictionary new].
	pool at: variableName ifAbsentPut: value]

{ #category : #accessing }
PoolVariableAddition >> poolName: aSymbol [
	self globalName: aSymbol]

{ #category : #'filein/out' }
PoolVariableAddition >> readFrom: aStream [
	| ast arguments |
	ast := self parse: aStream nextChunk.
	arguments := ast statements first arguments.
	variableName := arguments first value.
	value := arguments second value.
	globalName := arguments third value]

{ #category : #accessing }
PoolVariableAddition >> refersTo [
	^{self class. globalName. variableName}]

{ #category : #accessing }
PoolVariableAddition >> sourceCode [
	^self project referenceString , ' addVariableNamed: '
		, variableName storeString
		, ' value: '
		, value storeString
		, ' inPoolNamed: '
		, globalName storeString]

{ #category : #accessing }
PoolVariableAddition >> value: anObject [
	value := anObject]

{ #category : #accessing }
PoolVariableAddition >> variableName [
	^variableName]

{ #category : #accessing }
PoolVariableAddition >> variableName: aString [
	variableName := aString]

