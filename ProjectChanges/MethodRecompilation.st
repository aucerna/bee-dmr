"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MethodRecompilation,
	#superclass : #MethodDefinition,
	#category : #ProjectChanges
}

{ #category : #testing }
MethodRecompilation >> isUserChange [
	^false]

