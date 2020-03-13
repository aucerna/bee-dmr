"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #CStatementList,
	#superclass : #Object,
	#instVars : [
		'statements'
	],
	#category : #C
}

{ #category : #'instance creation' }
CStatementList class >> on: aCollection [
	^self new statements: aCollection
]

{ #category : #accessing }
CStatementList >> first [
	^statements first
]

{ #category : #accessing }
CStatementList >> format [
	^String streamContents: [:strm | 
		statements
			do: [:statement | strm nextPutAll: statement format]
			separatedBy: [strm cr; cr]]
]

{ #category : #services }
CStatementList >> literals [
	^statements gather: #literals
]

{ #category : #printing }
CStatementList >> printOn: aStream indent: n [
	statements
		do: [:statement | statement printOn: aStream indent: n]
		separatedBy: [aStream cr; cr]
]

{ #category : #printing }
CStatementList >> printTextOn: rtf indent: n [
	statements
		do: [:statement | statement printTextOn: rtf indent: n]
		separatedBy: [rtf cr; cr]
]

{ #category : #accessing }
CStatementList >> selectors [
	^statements gather: #selectors
]

{ #category : #accessing }
CStatementList >> statements [
	^statements
]

{ #category : #accessing }
CStatementList >> statements: aCollection [
	statements := aCollection
]

