"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TestCollector,
	#superclass : #Object,
	#instVars : [
		'changes',
		'classes',
		'methods',
		'tests'
	],
	#category : #ProjectChanges
}

{ #category : #initialization }
TestCollector class >> availableEvents [
	^super availableEvents add: #progress:; yourself]

{ #category : #'instance creation' }
TestCollector class >> on: aChangeset [
	^self new on: aChangeset]

{ #category : #private }
TestCollector >> addTest: cm [
	| exceptions |
	cm selector arity > 0 ifTrue: [^self].
	(cm selector beginsWith: 'test') ifFalse: [^self].
	exceptions := #('PaneClassValidatorTest' 'GUIProgrammingStyleTest').
	(exceptions includes: cm classBinding name) ifTrue: [^self].
	(cm classBinding inheritsFrom: TestCase) ifFalse: [^self].
	tests add: cm]

{ #category : #accessing }
TestCollector >> excludedSelectors [
	^#('add:' 'at:put:' 'new' 'yourself' 'new:' 'newNamed:') asSet]

{ #category : #running }
TestCollector >> find [
	| total n |
	total := classes size + methods size.
	classes asArray withIndexDo: [:class :i | | references ok |
		references := Smalltalk methodsReferencing: class name.
		references do: [:cm | self addTest: cm].
		ok := self proccessed: (i / total * 100) truncated.
		ok ifFalse: [^self]].
	n := classes size.
	methods withIndexDo: [:ch :i | | test senders ok |
		test := self testMethodFrom: ch.
		test isNil
			ifTrue: [
				senders := Smalltalk sendersOf: ch selector.
				senders size > 100 ifFalse: [senders do: [:cm | self addTest: cm]]]
			ifFalse: [self addTest: test].
		ok := self proccessed: (i + n / total * 100) truncated.
		ok ifFalse: [^self]]]

{ #category : #accessing }
TestCollector >> on: aChangeset [
	changes := aChangeset allChanges.
	tests := IdentitySet new.
	self updateClasses; updateMethods]

{ #category : #private }
TestCollector >> proccessed: percent [
	^self triggerEvent: #progress: with: percent defaultHandler: true]

{ #category : #private }
TestCollector >> testMethodFrom: change [
	| class selector |
	change isMethodDefinition ifFalse: [^nil].
	change className isNil ifTrue: [^nil].
	class := Smalltalk at: change className asSymbol ifAbsent: [^nil].
	(class inheritsFrom: TestCase) ifFalse: [^nil].
	selector := change selector.
	selector arity > 0 ifTrue: [^nil].
	(selector beginsWith: 'test') ifFalse: [^nil].
	^class >> selector]

{ #category : #output }
TestCollector >> tests [
	^tests asArray]

{ #category : #accessing }
TestCollector >> testsFound [
	^tests size]

{ #category : #accessing }
TestCollector >> updateClasses [
	classes := IdentitySet new
		select: [:ch | (ch classBinding isKindOf: ChangeRecord) not]
		thenCollect: [:ch | ch classBinding ifNotNil: [:cls | cls instanceClass]]
		from: changes.
	classes remove: nil ifAbsent: []]

{ #category : #accessing }
TestCollector >> updateMethods [
	| exclusions |
	exclusions := self excludedSelectors.
	methods := changes select: [:ch | | s |
		s := ch selector.
		s notNil andNot: [exclusions includes: s]]]

