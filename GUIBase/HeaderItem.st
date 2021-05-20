"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HeaderItem,
	#superclass : #GUIControlItem,
	#instVars : [
		'width',
		'alignment',
		'getter'
	],
	#category : #GUIbase
}

{ #category : #comparing }
HeaderItem >> = anHeaderItem [
	super = anHeaderItem ifFalse: [^false].
	alignment = anHeaderItem alignment ifFalse: [^false].
	(owner notNil and: [owner autosizesColumns])
		ifFalse: [width = anHeaderItem width ifFalse: [^false]].
	^true]

{ #category : #accessing }
HeaderItem >> alignment [
	^alignment]

{ #category : #accessing }
HeaderItem >> alignment: aSymbol [
	alignment := aSymbol]

{ #category : #accessing }
HeaderItem >> centered [
	alignment := #center]

{ #category : #copying }
HeaderItem >> copyFrom: aHeaderItem [
	super copyFrom: aHeaderItem.
	width := aHeaderItem width.
	alignment := aHeaderItem alignment]

{ #category : #private }
HeaderItem >> extraWidth [
	^20]

{ #category : #accessing }
HeaderItem >> fieldValueGetter [
	^getter]

{ #category : #accessing }
HeaderItem >> fieldValueGetter: evaluable [
	getter := evaluable]

{ #category : #comparing }
HeaderItem >> hash [
	^super hash hashWith: width]

{ #category : #accessing }
HeaderItem >> hold: aString font: aFont [
	width := (aFont widthOfString: aString) + self extraWidth]

{ #category : #accessing }
HeaderItem >> index [
	^owner notNil ifTrue: [owner indexOfColumn: self]]

{ #category : #initialization }
HeaderItem >> initialize [
	super initialize.
	self setWidthFromFont: self font]

{ #category : #accessing }
HeaderItem >> leftAligned [
	alignment := #left]

{ #category : #accessing }
HeaderItem >> object: anObject width: anInteger alignment: aSymbol [
	self
		object: anObject;
		width: anInteger;
		alignment: aSymbol]

{ #category : #accessing }
HeaderItem >> rightAligned [
	alignment := #right]

{ #category : #services }
HeaderItem >> setWidthFromFont: aFont [
	width := (aFont widthOfString: self label) + self extraWidth]

{ #category : #printing }
HeaderItem >> storeOn: aStream [
	aStream
		nextPut: $(;
		nextPutAll: self class name;
		space;
		nextPutAll: 'new';
		cr;
		nextPutAll: ' object: ';
		nextPutAll: object storeString;
		nextPutAll: ' width: ';
		nextPutAll: width storeString;
		nextPutAll: ' alignment: ';
		nextPutAll: alignment storeString;
		nextPut: $)]

{ #category : #accessing }
HeaderItem >> stringFor: anObject [
	| value |
	value := getter evaluateWith: anObject.
	^value isNil ifTrue: [''] ifFalse: [value asString]]

{ #category : #accessing }
HeaderItem >> width [
	^width]

{ #category : #accessing }
HeaderItem >> width: pixels [
	width := pixels]

