"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlPrinter,
	#superclass : #FmlVisitor,
	#instVars : [
		'units',
		'writer'
	],
	#category : #FML
}

{ #category : #private }
FmlPrinter >> dataSeparator [
	^Locale current dataSeparator , ' ']

{ #category : #accessing }
FmlPrinter >> dataSeparator: dummy [
	"
	ignore
	"
	]

{ #category : #accessing }
FmlPrinter >> decimalSeparator [
	^Locale current decimalSeparator]

{ #category : #accessing }
FmlPrinter >> decimalSeparator: dummy [
	"
	ignore
	"
	]

{ #category : #initialization }
FmlPrinter >> initialize [
	super initialize.
	units := true]

{ #category : #services }
FmlPrinter >> print: anFmlExpression on: aStream [
	writer := aStream.
	self visit: anFmlExpression]

{ #category : #accessing }
FmlPrinter >> printUnits: aBoolean [
	units := aBoolean]

