"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassReinstall,
	#superclass : #ClassDefinition,
	#category : #ProjectChanges
}

{ #category : #perform }
ClassReinstall >> basicPerform [
	^self resolveClass installer install]

{ #category : #testing }
ClassReinstall >> changesSomething [
	^true]

