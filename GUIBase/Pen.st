"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Pen,
	#superclass : #Object,
	#instVars : [
		'color',
		'alignment',
		'font'
	],
	#category : #GUIbase
}

{ #category : #'instance creation' }
Pen class >> new [
	^super new initialize]

{ #category : #accessing }
Pen >> alignment [
	^alignment]

{ #category : #accessing }
Pen >> alignment: aSymbol [
	alignment := aSymbol]

{ #category : #accessing }
Pen >> color [
	^color]

{ #category : #accessing }
Pen >> color: aColor [
	color := aColor]

{ #category : #accessing }
Pen >> font [
	^font]

{ #category : #accessing }
Pen >> font: aFont [
	font := aFont]

{ #category : #initialization }
Pen >> initialize [
	super initialize.
	alignment := #left.
	font := GDIFont defaultTextFont]

{ #category : #accessing }
Pen >> verticalAlignment [
	alignment == #topLeft ifTrue: [^#top].
	alignment == #center ifTrue: [^#center].
	^#baseline]

