"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Pencil,
	#superclass : #Object,
	#instVars : [
		'color',
		'width',
		'style',
		'startCap',
		'endCap',
		'join'
	],
	#category : #GUIbase
}

{ #category : #'instance creation' }
Pencil class >> new [
	^super new initialize]

{ #category : #accessing }
Pencil >> bevelLineJoin [
	join := #bevel]

{ #category : #accessing }
Pencil >> color [
	^color]

{ #category : #accessing }
Pencil >> color: aColor [
	color := aColor]

{ #category : #accessing }
Pencil >> dashStyle [
	^style]

{ #category : #accessing }
Pencil >> dashStyle: aSymbol [
	style := aSymbol]

{ #category : #initialization }
Pencil >> initialize [
	width := 1.
	color := Color black.
	style := #solid]

{ #category : #accessing }
Pencil >> lineStyle [
	^style]

{ #category : #accessing }
Pencil >> lineWidth [
	^width]

{ #category : #accessing }
Pencil >> miterLineJoin [
	join := #miter]

{ #category : #accessing }
Pencil >> roundLineJoin [
	join := #round]

{ #category : #accessing }
Pencil >> width [
	^width]

{ #category : #accessing }
Pencil >> width: anInteger [
	self ASSERT: anInteger isSmallInteger.
	width := anInteger]

