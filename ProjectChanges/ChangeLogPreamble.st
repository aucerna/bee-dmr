"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ChangeLogPreamble,
	#superclass : #ExpressionEvaluation,
	#instVars : [
		'contents'
	],
	#category : #ProjectChanges
}

{ #category : #accessing }
ChangeLogPreamble >> contents: aString [
	self expression: aString]

{ #category : #testing }
ChangeLogPreamble >> isPreamble [
	^true]

{ #category : #accessing }
ChangeLogPreamble >> project [
	^nil]

{ #category : #accessing }
ChangeLogPreamble >> resolveClass [
	^nil]

