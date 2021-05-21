"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ChangeHeaderSpec,
	#superclass : #Object,
	#instVars : [
		'aspects',
		'information',
		'projectId'
	],
	#category : #ProjectChanges
}

{ #category : #'instance creation' }
ChangeHeaderSpec class >> new [
	^super new initialize]

{ #category : #'adding / removing' }
ChangeHeaderSpec >> add: aSymbol [
	aspects at: aSymbol put: true]

{ #category : #'adding / removing' }
ChangeHeaderSpec >> addInformation [
	information := true]

{ #category : #private }
ChangeHeaderSpec >> aspectFor: aSymbol [
	aSymbol == #projectChanges ifTrue: [^#project].
	^aSymbol]

{ #category : #'file in/out' }
ChangeHeaderSpec >> dump: aSymbol of: aChangeRecord on: aStream [
	| value aspect string |
	value := aChangeRecord
		instVarNamed: aSymbol asString
		ifAbsent: [aChangeRecord perform: aSymbol].
	value isNil ifTrue: [^self].
	aspect := self aspectFor: aSymbol.
	aStream crtab; nextPutAll: aspect; nextPutAll: ': '.
	string := self stringFor: value.
	aStream nextPutAll: string]

{ #category : #'file in/out' }
ChangeHeaderSpec >> dumpInformationOf: aChangeRecord on: aStream [
	| dict |
	dict := aChangeRecord information ifNil: [^self].
	dict keysDo: [:info | | value string |
		aStream crtab; nextPutAll: info; nextPutAll: ': '.
		value := aChangeRecord informationAt: info.
		string := self stringFor: value.
		aStream nextPutAll: string]]

{ #category : #'file in/out' }
ChangeHeaderSpec >> fileOut: aChangeRecord on: aStream [
	aStream nextPutAll: aChangeRecord class name.
	aspects
		keysAndValuesDo: [:aspect :include | include
			ifTrue: [self dump: aspect of: aChangeRecord on: aStream]].
	information ifTrue: [self dumpInformationOf: aChangeRecord on: aStream]]

{ #category : #'file in/out' }
ChangeHeaderSpec >> headerFor: aChangeRecord [
	^String streamContents: [:strm | self fileOut: aChangeRecord on: strm]]

{ #category : #initialization }
ChangeHeaderSpec >> initialize [
	super initialize.
	aspects := OrderedDictionary new.
	information := false]

{ #category : #accessing }
ChangeHeaderSpec >> projectId: aString [
	projectId := aString]

{ #category : #'adding / removing' }
ChangeHeaderSpec >> remove: aSymbol [
	aspects at: aSymbol put: false]

{ #category : #private }
ChangeHeaderSpec >> stringFor: anObject [
	anObject isTimestamp ifTrue: [^anObject iso8601 printString].
	(anObject isArray and: [anObject first = projectId])
		ifTrue: [^anObject last storeString].
	(anObject isKindOf: ProjectChanges) ifTrue: [^anObject name storeString].
	(anObject isKindOf: BeeModule) ifTrue: [^anObject name storeString].
	^anObject storeString]

