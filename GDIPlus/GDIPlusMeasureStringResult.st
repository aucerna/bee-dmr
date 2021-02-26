"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusMeasureStringResult,
	#superclass : #Object,
	#instVars : [
		'boundingBox',
		'codepoints',
		'lines'
	],
	#category : #GDIPlus
}

{ #category : #'as yet unclassified' }
GDIPlusMeasureStringResult class >> boundingBox: bb codepoints: cp lines: ls [
	^self new
		boundingBox: bb codepoints: cp lines: ls;
		yourself]

{ #category : #dimensions }
GDIPlusMeasureStringResult >> boundingBox [
	^boundingBox]

{ #category : #'as yet unclassified' }
GDIPlusMeasureStringResult >> boundingBox: bb codepoints: cp lines: ls [
	boundingBox := bb.
	codepoints := cp.
	lines := ls]

{ #category : #'as yet unclassified' }
GDIPlusMeasureStringResult >> codepoints [
	^codepoints]

{ #category : #'as yet unclassified' }
GDIPlusMeasureStringResult >> lines [
	^lines]

