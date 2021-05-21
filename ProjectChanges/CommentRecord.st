"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CommentRecord,
	#superclass : #ChangeRecord,
	#instVars : [
		'comment'
	],
	#category : #ProjectChanges
}

{ #category : #'instance creation' }
CommentRecord class >> on: aString [
	| i ts string |
	i := aString indexOfString: ' on: '.
	ts := (i > 0 and: [(aString at: i + ' on: ' size) isDigit]) ifTrue: [
		string := aString allButFirst: i + ' on: ' size - 1.
		self ddmmyyyyhhmmss: string].
	^self new timestamp: ts; readFrom: aString readStream]

{ #category : #perform }
CommentRecord >> basicPerform [
	]

{ #category : #testing }
CommentRecord >> changesSomething [
	^false]

{ #category : #accessing }
CommentRecord >> classBinding [
	^nil]

{ #category : #testing }
CommentRecord >> isMark [
	^comment endsWith: '***"']

{ #category : #accessing }
CommentRecord >> readFrom: aStream [
	comment := aStream nextChunk]

{ #category : #accessing }
CommentRecord >> refersTo [
	^{self class. self type}]

{ #category : #accessing }
CommentRecord >> sourceCode [
	^comment isNil ifTrue: [''] ifFalse: [comment]]

{ #category : #accessing }
CommentRecord >> type [
	(comment includesString: '"*** exited image ') ifTrue: [^'End Session Mark'].
	(comment includesString: '"*** startUp image ')
		ifTrue: [^'StartUp Session Mark'].
	(comment includesString: '"*** saved image segment ')
		ifTrue: [^'Save Code Image Segment Mark'].
	(comment includesString: '"*** saved image ') ifTrue: [^'Save Image Mark'].
	(comment includesString: '"*** saved project ')
		ifTrue: [^'Save Project Mark'].
	(comment includesString: '"*** commit changes ')
		ifTrue: [^'Commit Changes Mark'].
	^'Any']

