"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MethodAddition,
	#superclass : #MethodDefinition,
	#category : #ProjectChanges
}

{ #category : #perform }
MethodAddition >> basicPerform [
	| cm |
	cm := self method.
	cm notNil
		ifTrue: [cm sourceReference changeLink ifNotNil: [:link | prev := link]].
	^self changesCode ifTrue: [super basicPerform] ifFalse: [cm copy]]

{ #category : #testing }
MethodAddition >> changesSomething [
	self isProjectLoaded ifFalse: [^true].
	super changesSomething ifTrue: [^true].
	^(self project includesSelector: selector class: self resolveClass) not]

{ #category : #initialization }
MethodAddition >> compiledMethod: aCompiledMethod [
	self fromCompiledMethod: aCompiledMethod]

{ #category : #undo }
MethodAddition >> tip [
	^'Forget ' , className , '>>' , self selector , ' from '
		, self project name]

{ #category : #undo }
MethodAddition >> undo [
	^self projectChanges forgetMethod: self method]

