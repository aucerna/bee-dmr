"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ListItem,
	#superclass : #GUIControlItem,
	#instVars : [
		'columns'
	],
	#category : #GUIbase
}

{ #category : #accessing }
ListItem >> backColor [
	^self propertyAt: #backColor ifAbsent: nil]

{ #category : #accessing }
ListItem >> backColor: aColor [
	self propertyAt: #backColor put: aColor]

{ #category : #accessing }
ListItem >> clear [
	columns := bitmaps := label := nil.
	self
		removeProperty: #foreColor ifAbsent: nil;
		removeProperty: #backColor ifAbsent: nil]

{ #category : #accessing }
ListItem >> columns [
	(columns isNil and: [owner notNil])
		ifTrue: [self columns: (owner columnsFor: self)].
	^columns]

{ #category : #accessing }
ListItem >> columns: aCollection [
	columns := aCollection notNil
		ifTrue: [aCollection collect: [:s | s ifNil: '']]]

{ #category : #copying }
ListItem >> copyFrom: aListViewItem [
	super copyFrom: aListViewItem.
	columns := aListViewItem columns.
	bitmaps := aListViewItem image.
	self
		backColor: aListViewItem backColor;
		foreColor: aListViewItem foreColor]

{ #category : #accessing }
ListItem >> foreColor [
	^self propertyAt: #foreColor ifAbsent: nil]

{ #category : #accessing }
ListItem >> foreColor: aColor [
	self propertyAt: #foreColor put: aColor]

{ #category : #accessing }
ListItem >> image [
	bitmaps isNil
		ifTrue: [bitmaps := owner notNil ifTrue: [owner imageFor: self]].
	^bitmaps]

{ #category : #accessing }
ListItem >> image: anImage [
	bitmaps := anImage]

{ #category : #inquiries }
ListItem >> imageIndex [
	^self image notNil ifTrue: [owner indexOfImage: self image]]

{ #category : #inquiries }
ListItem >> index [
	^owner notNil ifTrue: [owner indexOfItem: self]]

{ #category : #testing }
ListItem >> isSelected [
	^owner notNil and: [owner isSelected: self]]

{ #category : #accessing }
ListItem >> label [
	label isNil ifTrue: [
		label := owner notNil ifTrue: [owner stringFor: self].
		label isNil ifTrue: [label := object asString]].
	^super label]

{ #category : #printing }
ListItem >> printOn: aStream [
	aStream nextPutAll: self class name; nextPutAll: ' : '.
	object printOn: aStream]

{ #category : #accessing }
ListItem >> stringAtColumn: index [
	| c |
	c := self columns at: index ifAbsent: nil.
	^c notNil ifTrue: [c asString]]

