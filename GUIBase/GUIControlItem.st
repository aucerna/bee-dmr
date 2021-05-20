"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GUIControlItem,
	#superclass : #Object,
	#instVars : [
		'object',
		'label',
		'owner',
		'bitmaps'
	],
	#category : #GUIbase
}

{ #category : #'instance creation' }
GUIControlItem class >> from: anObject [
	(anObject isKindOf: GUIControlItem) ifTrue: [^anObject].
	^self new object: anObject]

{ #category : #'instance creation' }
GUIControlItem class >> from: anObject owner: aChildWindow [
	^(self from: anObject) owner: aChildWindow]

{ #category : #'instance creation' }
GUIControlItem class >> new [
	^super new initialize]

{ #category : #'instance creation' }
GUIControlItem class >> separatorNamed: aString [
	^self new string: aString]

{ #category : #comparing }
GUIControlItem >> = aListItem [
	self class == aListItem class ifFalse: [^false].
	object = aListItem object ifFalse: [^false].
	bitmaps isNil ifTrue: [^aListItem hasImage not].
	bitmaps = aListItem image ifFalse: [^false].
	^true]

{ #category : #private }
GUIControlItem >> bitmapAt: aSymbol [
	bitmaps isDictionary ifFalse: [^bitmaps].
	^bitmaps at: aSymbol ifAbsent: nil]

{ #category : #private }
GUIControlItem >> bitmapAt: aSymbol put: aBitmap [
	| bmp |
	bitmaps isDictionary ifFalse: [
		aSymbol == #default ifTrue: [
			bitmaps := aBitmap.
			^aBitmap].
		bmp := bitmaps.
		bitmaps := Dictionary new.
		bmp notNil ifTrue: [bitmaps at: #default put: bmp]].
	^bitmaps at: aSymbol put: aBitmap]

{ #category : #copying }
GUIControlItem >> copyFrom: aListItem [
	object := aListItem object.
	label := aListItem label.
	bitmaps := aListItem image]

{ #category : #accessing }
GUIControlItem >> font [
	^owner notNil ifTrue: [owner font] ifFalse: [GDIFont defaultTextFont]]

{ #category : #comparing }
GUIControlItem >> hash [
	^label hashWith: object with: bitmaps]

{ #category : #testing }
GUIControlItem >> hasImage [
	^bitmaps isEmptyOrNil not]

{ #category : #testing }
GUIControlItem >> hasLabel [
	^self label notNil]

{ #category : #accessing }
GUIControlItem >> image [
	^self bitmapAt: #default]

{ #category : #accessing }
GUIControlItem >> image: aBitmap [
	^self bitmapAt: #default put: aBitmap]

{ #category : #testing }
GUIControlItem >> isSeparator [
	^object isNil]

{ #category : #accessing }
GUIControlItem >> label [
	^label ifNil: [object asString]]

{ #category : #accessing }
GUIControlItem >> label: aString [
	label := aString]

{ #category : #accessing }
GUIControlItem >> object [
	^object]

{ #category : #accessing }
GUIControlItem >> object: anObject [
	object := anObject]

{ #category : #accessing }
GUIControlItem >> owner [
	^owner]

{ #category : #accessing }
GUIControlItem >> owner: aWindow [
	owner := aWindow]

{ #category : #printing }
GUIControlItem >> printOn: aStream [
	aStream nextPutAll: self class name; space.
	object printOn: aStream]

{ #category : #services }
GUIControlItem >> text [
	^self label]

