"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #VariableChange,
	#superclass : #ClassChange,
	#instVars : [
		'variable'
	],
	#category : #ProjectChanges
}

{ #category : #'filein/out' }
VariableChange >> readFrom: aStream [
	| ast |
	ast := self parse: aStream nextChunk.
	variable := ast statements first arguments first value]

{ #category : #accessing }
VariableChange >> refersTo [
	^{self class. className. variable}]

{ #category : #accessing }
VariableChange >> targetClassOf: name [
	^(projectChanges isNil ifTrue: [BeeModule] ifFalse: [self project])
		resolveClass: name]

{ #category : #accessing }
VariableChange >> variable: aString [
	variable := aString]

{ #category : #accessing }
VariableChange >> varName: aString [
	variable := aString]

