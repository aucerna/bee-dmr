"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GlobalAddition,
	#superclass : #GlobalChange,
	#category : #ProjectChanges
}

{ #category : #perform }
GlobalAddition >> addToProject: aBeeModule [
	self project addGlobal: globalName]

{ #category : #perform }
GlobalAddition >> basicPerform [
	self defineGlobal.
	^Smalltalk associationAt: globalName]

{ #category : #testing }
GlobalAddition >> changesSomething [
	self resolveGlobal isNil ifTrue: [^true].
	^(self project globals includes: globalName) not]

{ #category : #perform }
GlobalAddition >> defineGlobal [
	Smalltalk at: globalName ifAbsentPut: [].]

{ #category : #accessing }
GlobalAddition >> sourceCode [
	^'(BeeModule getProject: ' , self projectName storeString , ')'
		, ' addGlobal: '
		, globalName storeString]

{ #category : #undo }
GlobalAddition >> tip [
	^'Forget ' , globalName , ' from ' , self project name]

{ #category : #undo }
GlobalAddition >> undo [
	^self projectChanges forgetGlobal: globalName]

