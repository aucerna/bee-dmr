"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassAddition,
	#superclass : #ClassDefinition,
	#category : #ProjectChanges
}

{ #category : #perform }
ClassAddition >> basicPerform [
	^self changesDefinition ifTrue: [super basicPerform] ifFalse: [| cls |
		cls := self resolveClass.
		prev := cls changeLink.
		cls]]

{ #category : #testing }
ClassAddition >> changesSomething [
	self isProjectLoaded ifFalse: [^true].
	super changesSomething ifTrue: [^true].
	^(self project includesClass: self resolveClass) not]

{ #category : #undo }
ClassAddition >> undo [
	^self projectChanges forgetClass: self resolveClass]

