"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassVariableAddition,
	#superclass : #ClassVariableChange,
	#category : #ProjectChanges
}

{ #category : #private }
ClassVariableAddition >> basicPerform [
	| class |
	class := self resolveClass.
	(class allClassVarNames includes: variable) ifTrue: [^nil].
	class addClassVarNamed: variable]

{ #category : #testing }
ClassVariableAddition >> changesSomething [
	^self resolveClass isNil
		orNot: [self resolveClass classVarNames includes: variable]]

{ #category : #accessing }
ClassVariableAddition >> sourceCode [
	^className , ' addClassVariable: ' , variable storeString]

{ #category : #undo }
ClassVariableAddition >> tip [
	^self resolveClass , ' add cvar ' , variable]

{ #category : #undo }
ClassVariableAddition >> undo [
	^self projectChanges removeClassVar: variable from: self resolveClass]

