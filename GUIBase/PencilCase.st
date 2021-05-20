"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PencilCase,
	#superclass : #Object,
	#instVars : [
		'pencils',
		'brushes',
		'pencilClass',
		'brushClass'
	],
	#category : #GUIbase
}

{ #category : #'instance creation' }
PencilCase class >> for: aDrawer [
	^self new initalizeFrom: aDrawer]

{ #category : #'instance creation' }
PencilCase class >> new [
	^super new initialize]

{ #category : #accessing }
PencilCase >> brushWithAttributes: anArray [
	^brushes at: anArray ifAbsentPut: [
		brushClass
			withStyle: anArray first
			color: anArray second
			hatch: anArray third]]

{ #category : #initialization }
PencilCase >> initalizeFrom: aDrawer [
	pencilClass := aDrawer class pencilClass.
	brushClass := aDrawer class brushClass]

{ #category : #initialization }
PencilCase >> initialize [
	super initialize.
	pencils := Dictionary new.
	brushes := Dictionary new]

{ #category : #accessing }
PencilCase >> pencilWithAttributes: anArray [
	^pencils at: anArray ifAbsentPut: [
		pencilClass
			withStyle: anArray first
			color: anArray second
			width: anArray third]]

{ #category : #'adding / removing' }
PencilCase >> removeAll [
	pencils removeAll.
	brushes removeAll]

