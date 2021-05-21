"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CategoryAddition,
	#superclass : #CategoryChange,
	#category : #ProjectChanges
}

{ #category : #perform }
CategoryAddition >> basicPerform [
	self resolveClass organization addCategory: category]

{ #category : #testing }
CategoryAddition >> changesSomething [
	| class |
	class := self resolveClass ifNil: [^true].
	^(class categories includes: category) not]

{ #category : #accessing }
CategoryAddition >> sourceCode [
	^className , ' organization addCategory: ' , category storeString]

{ #category : #undo }
CategoryAddition >> tip [
	^self resolveClass , ' add category ' , category storeString]

{ #category : #undo }
CategoryAddition >> undo [
	^self projectChanges removeCategory: category in: self resolveClass]

