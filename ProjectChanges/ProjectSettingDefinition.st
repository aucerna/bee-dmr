"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ProjectSettingDefinition,
	#superclass : #ProjectChange,
	#instVars : [
		'setting',
		'value'
	],
	#category : #ProjectChanges
}

{ #category : #comparing }
ProjectSettingDefinition >> = aChangeRecord [
	super = aChangeRecord ifFalse: [^false].
	setting == aChangeRecord setting ifFalse: [^false].
	^value = aChangeRecord value]

{ #category : #perform }
ProjectSettingDefinition >> basicPerform [
	| prev |
	prev := self project settingAt: setting asString.
	self propertyAt: #prev put: prev.
	self project settingAt: setting asString put: value]

{ #category : #undo }
ProjectSettingDefinition >> canUndo [
	self propertyAt: #prev ifAbsent: [^false].
	^super canUndo]

{ #category : #testing }
ProjectSettingDefinition >> changesSomething [
	^(self project settingAt: setting) != value]

{ #category : #'version support' }
ProjectSettingDefinition >> currentVersion [
	| b |
	b := self project settingAt: setting.
	^self copy setting: setting value: b]

{ #category : #testing }
ProjectSettingDefinition >> isBroken [
	^value isBoolean not]

{ #category : #'filein/out' }
ProjectSettingDefinition >> readFrom: aStream [
	| ast args |
	ast := Compiler parse: aStream nextChunk.
	args := ast statements first arguments.
	setting := Compiler evaluate: args first value storeString.
	value := Compiler evaluate: args last value]

{ #category : #accessing }
ProjectSettingDefinition >> refersTo [
	^{self project name}]

{ #category : #accessing }
ProjectSettingDefinition >> setting [
	^setting]

{ #category : #accessing }
ProjectSettingDefinition >> setting: aSymbol value: aBoolean [
	setting := aSymbol.
	value := aBoolean]

{ #category : #'filein/out' }
ProjectSettingDefinition >> sourceCode [
	^String streamContents: [:strm | 
		strm
			nextPutAll: '(BeeModule getProject: ';
			nextPutAll: self projectName storeString;
			nextPutAll: ') settingAt: ';
			nextPutAll: setting storeString;
			nextPutAll: ' put: ';
			nextPutAll: value storeString]]

{ #category : #undo }
ProjectSettingDefinition >> tip [
	^'Set ' , setting asString , ' → ' , value asString]

{ #category : #undo }
ProjectSettingDefinition >> undo [
	| prev |
	prev := self propertyAt: #prev ifAbsent: [^self].
	self projectChanges perform: (setting , ':') asSymbol with: prev]

{ #category : #accessing }
ProjectSettingDefinition >> value [
	^value]

