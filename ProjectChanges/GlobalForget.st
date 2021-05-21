"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GlobalForget,
	#superclass : #GlobalChange,
	#category : #ProjectChanges
}

{ #category : #perform }
GlobalForget >> basicPerform [
	self project removeGlobal: globalName.]

{ #category : #testing }
GlobalForget >> changesSomething [
	self resolveGlobal isNil ifTrue: [^true].
	^self project globals includes: globalName]

{ #category : #accessing }
GlobalForget >> sourceCode [
	^self project referenceString, ' removeGlobal: ', globalName storeString]

{ #category : #undo }
GlobalForget >> tip [
	^'Forget global ' , globalName , ' from ' , self project name]

{ #category : #undo }
GlobalForget >> undo [
	^self projectChanges addGlobal: globalName]

