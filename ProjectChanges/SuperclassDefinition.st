"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SuperclassDefinition,
	#superclass : #ClassDefinition,
	#category : #ProjectChanges
}

{ #category : #perform }
SuperclassDefinition >> basicPerform [
	^self resolveClass]

{ #category : #testing }
SuperclassDefinition >> changesSomething [
	^false]

{ #category : #testing }
SuperclassDefinition >> isLoggable [
	^false]

{ #category : #testing }
SuperclassDefinition >> shouldLogOnSmalltalkChanges [
	^false]

