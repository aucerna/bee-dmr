"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ActionDefinition,
	#superclass : #ProjectChange,
	#instVars : [
		'action'
	],
	#category : #ProjectChanges
}

{ #category : #accessing }
ActionDefinition >> action [
	^action isString
		ifTrue: [(Compiler silentlyEvaluate: action) ifNil: [action]]
		ifFalse: [action]]

{ #category : #accessing }
ActionDefinition >> action: aMessage [
	action := aMessage]

{ #category : #private }
ActionDefinition >> actionTypeSelector [
	^#loadAction]

{ #category : #accessing }
ActionDefinition >> classBinding [
	^self class]

{ #category : #'filein/out' }
ActionDefinition >> readFrom: aStream [
	| expression |
	expression := Compiler parse: aStream nextChunk.
	action := expression statements first arguments first format.
	action = 'nil' ifTrue: [action := nil]]

{ #category : #accessing }
ActionDefinition >> resolveClass [
	^nil]

{ #category : #'filein/out' }
ActionDefinition >> sourceCode [
	^String streamContents: [:strm | 
		strm
			nextPutAll: '(BeeModule getProject: ';
			nextPutAll: self projectName storeString;
			nextPutAll: ') ';
			nextPutAll: self actionTypeSelector;
			nextPutAll: ': '.
		action isNil ifTrue: [strm nextPutAll: 'nil'] ifFalse: [
			action isString ifTrue: [strm nextPutAll: '(' , action , ')'] ifFalse: [
				strm
					nextPutAll: '(Message receiver: ';
					nextPutAll: action receiver printString;
					nextPutAll: ' selector: ';
					nextPutAll: action selector storeString;
					nextPut: $)]]]]

