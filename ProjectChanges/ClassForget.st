"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassForget,
	#superclass : #ClassChange,
	#category : #ProjectChanges
}

{ #category : #perform }
ClassForget >> basicPerform [
	self project removeClass: self resolveClass]

{ #category : #testing }
ClassForget >> changesSomething [
	| class |
	self isProjectLoaded ifFalse: [^false].
	(class := self resolveClass) isNil ifTrue: [^true].
	^self project classes includes: class]

{ #category : #private }
ClassForget >> defaultProject [
	| p |
	p := projectChanges isString ifTrue: [BeeModule named: projectChanges].
	p notNil ifTrue: [projectChanges := p changes].
	^p ifNil: [BeeModule default]]

{ #category : #perform }
ClassForget >> perform [
	self isProjectLoaded ifFalse: [^nil].
	^super perform]

{ #category : #'filein/out' }
ClassForget >> readFrom: aStream [
	aStream nextChunk.]

{ #category : #accessing }
ClassForget >> sourceCode [
	^self project referenceString, ' removeClass: ', className]

{ #category : #undo }
ClassForget >> tip [
	^'Forget ' , className , ' from ' , self project name]

{ #category : #undo }
ClassForget >> undo [
	^self projectChanges addClass: self resolveClass]

