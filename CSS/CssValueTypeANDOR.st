"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssValueTypeANDOR,
	#superclass : #CssValueTypeRelation,
	#category : #CSS
}

{ #category : #accessing }
CssValueTypeANDOR >> addValues: aCollection fromStream: in [
	| oneWorked gotOne |
	oneWorked := false.
	gotOne := false.
	[
		self types do: [:ea | 
			(ea addValues: aCollection fromStream: in)
				ifTrue: [gotOne := oneWorked := true]].
		gotOne and: [in atEnd not]]
		whileTrue: [gotOne := false].
	^oneWorked]

{ #category : #testing }
CssValueTypeANDOR >> isTypeANDOR [
	^true]

{ #category : #testing }
CssValueTypeANDOR >> operator [
	^'||']

{ #category : #printing }
CssValueTypeANDOR >> printOn: aStream [
	aStream nextPut: $[.
	self types do: [:ea | 
		ea printOn: aStream.
		ea == types last ifFalse: [aStream nextPutAll: ' || ']].
	aStream nextPut: $]]

