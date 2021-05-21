"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MethodForget,
	#superclass : #MethodChange,
	#category : #ProjectChanges
}

{ #category : #perform }
MethodForget >> basicPerform [
	self project removeMethod: self signature]

{ #category : #testing }
MethodForget >> canOverride: aChange [
	^(super canOverride: aChange) or: [| reference |
		reference := self refersTo.
		reference at: 1 put: MethodAddition.
		reference = aChange refersTo]]

{ #category : #accessing }
MethodForget >> changeForCurrentVersion [
	| cm cls |
	cls := self resolveClass.
	^(cls notNil
		and: [self project includesSelector: selector class: cls]
		and: [
			cm := cls >> selector.
			cm notNil])
		ifTrue: [MethodAddition fromCompiledMethod: cm]
		ifFalse: [self]]

{ #category : #testing }
MethodForget >> changesSomething [
	| class |
	self isProjectLoaded ifFalse: [^false].
	class := self resolveClass ifNil: [^true].
	^self project includesSelector: selector class: class]

{ #category : #private }
MethodForget >> defaultProject [
	| p |
	p := projectChanges isString ifTrue: [BeeModule named: projectChanges].
	p notNil ifTrue: [projectChanges := p changes].
	^p ifNil: [BeeModule default]]

{ #category : #accessing }
MethodForget >> method [
	| cls |
	cls := self classBinding.
	^cls notNil ifTrue: [cls >> selector]]

{ #category : #perform }
MethodForget >> perform [
	self isProjectLoaded ifFalse: [^nil].
	^super perform]

{ #category : #'filein/out' }
MethodForget >> readFrom: aStream [
	aStream nextChunk.]

{ #category : #accessing }
MethodForget >> refersTo [
	^{self class. self projectName. className. selector}]

{ #category : #accessing }
MethodForget >> sourceCode [
	^self project referenceString , ' removeMethod: ' , className , ' -> '
		, selector storeString]

{ #category : #undo }
MethodForget >> tip [
	^'Forget ' , className , '>>' , self selector , ' from '
		, self project name]

{ #category : #undo }
MethodForget >> undo [
	self projectChanges addMethod: self resolveClass >> selector]

