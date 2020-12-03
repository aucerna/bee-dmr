"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSETryNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'tryBlock',
		'catch',
		'finally'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSETryNode >> acceptVisitor: aVisitor [
	^aVisitor acceptTry: self]

{ #category : #accessing }
JSETryNode >> catch [
	^catch]

{ #category : #accessing }
JSETryNode >> catch: aCatch [
	catch := aCatch]

{ #category : #accessing }
JSETryNode >> finally [
	^finally]

{ #category : #accessing }
JSETryNode >> finally: aFinally [
	finally := aFinally]

{ #category : #accessing }
JSETryNode >> tryBlock [
	^tryBlock]

{ #category : #accessing }
JSETryNode >> tryBlock: aBlock [
	tryBlock := aBlock]

