"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MethodChange,
	#superclass : #ClassChange,
	#instVars : [
		'selector'
	],
	#category : #ProjectChanges
}

{ #category : #comparing }
MethodChange >> = changeRecord [
	super = changeRecord ifFalse: [^false].
	selector = changeRecord selector ifFalse: [^false].
	^self sourceCode = changeRecord sourceCode]

{ #category : #testing }
MethodChange >> canBeOverriddenBy: aChangeRecord [
	^className = aChangeRecord className
		and: [selector = aChangeRecord selector]
		and: [self projectName = aChangeRecord projectName]]

{ #category : #accessing }
MethodChange >> category [
	^nil]

{ #category : #accessing }
MethodChange >> changeForCurrentVersion [
	| ch |
	ch := self currentVersion.
	^ch ifNil: [
		MethodRemoval new
			projectChanges: self projectChanges;
			author: self projectChanges currentUser;
			className: className;
			selector: selector;
			yourself]]

{ #category : #comparing }
MethodChange >> hash [
	^super hash hashWith: selector]

{ #category : #accessing }
MethodChange >> headerSpec [
	| spec |
	spec := super headerSpec.
	spec add: #selector.
	spec add: #category.
	^spec]

{ #category : #testing }
MethodChange >> isMethodChange [
	^true]

{ #category : #accessing }
MethodChange >> method [
	| cls |
	cls := self resolveClass.
	^cls notNil ifTrue: [cls >> self selector]]

{ #category : #accessing }
MethodChange >> refersTo [
	^{self class. className. selector}]

{ #category : #accessing }
MethodChange >> selector [
	^selector]

{ #category : #accessing }
MethodChange >> selector: aSymbol [
	selector := aSymbol]

{ #category : #printing }
MethodChange >> shortLabel [
	| ts gg |
	ts := Character thinSpace.
	gg := WideString with: ts with: 16r226B asCharacter with: ts.
	^className asString , gg , selector asString]

{ #category : #printing }
MethodChange >> shortPrintStringOn: aStream [
	| s |
	super shortPrintStringOn: aStream.
	self selector notNil ifTrue: [
		s := self selector asString.
		s last = $: ifTrue: [s := s copyFrom: 1 to: s size - 1].
		aStream
			nextPut: $_;
			nextPutAll: (s replaceAllChar: $: withChar: $_)]]

{ #category : #accessing }
MethodChange >> signature [
	^self resolveClass -> self selector]

{ #category : #accessing }
MethodChange >> sourceReference [
	^self]

