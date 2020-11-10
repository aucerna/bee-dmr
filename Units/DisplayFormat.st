"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DisplayFormat,
	#superclass : #ModelObject,
	#instVars : [
		'decimals',
		'showSignificant',
		'showThousands'
	],
	#classVars : [
		'default'
	],
	#category : #Units
}

{ #category : #'instance creation' }
DisplayFormat class >> decimals: anInteger [
	^self new decimals: anInteger]

{ #category : #'instance creation' }
DisplayFormat class >> default [
	^default == nil ifTrue: [default := self new] ifFalse: [default]]

{ #category : #'instance creation' }
DisplayFormat class >> fromExcelFormat: aString [
	| string index n |
	aString = 'General' ifTrue: [^nil].
	string := (aString upTo: $;) select: [:c | #($# $. $0) includes: c].
	index := string indexOf: $..
	n := string findLast: [:c | c = $0] ifAbsent: [^nil].
	^self decimals: n - index]

{ #category : #comparing }
DisplayFormat >> = aDisplayFormat [
	self class == aDisplayFormat class ifFalse: [^false].
	^decimals = aDisplayFormat decimals]

{ #category : #accessing }
DisplayFormat >> decimals [
	^decimals]

{ #category : #accessing }
DisplayFormat >> decimals: anInteger [
	decimals = anInteger ifTrue: [^self].
	decimals := anInteger asInteger max: 0]

{ #category : #printing }
DisplayFormat >> displayString: anObject [
	anObject isDate ifTrue: [^self displayStringDate: anObject].
	anObject isNumber ifTrue: [^self displayStringNumber: anObject].
	anObject isArrayValued ifTrue: [^self displayStringArray: anObject].
	anObject isNil ifTrue: [^Unit undefinedValue displayString].
	^anObject asString]

{ #category : #printing }
DisplayFormat >> displayStringArray: array [
	| value string |
	value := array first.
	string := Unit undefinedValue displayString.
	value isNumber ifTrue: [string := self displayStringNumber: value].
	value isDate ifTrue: [string := self displayStringDate: value].
	^string , '...']

{ #category : #printing }
DisplayFormat >> displayStringDate: aDate [
	^String streamContents: [:s | aDate printOn: s format: self dateFormat]]

{ #category : #printing }
DisplayFormat >> displayStringNumber: aNumber [
	| float d display dot |
	aNumber isInfinite ifTrue: [^aNumber asString].
	aNumber isNaN ifTrue: [^Unit undefinedValue displayString].
	float := aNumber asFloat.
	d := decimals.
	display := float printFraction: d.
	float ~ 0.0 ifTrue: [^display].
	dot := Locale current decimalSeparator anyone.
	(display conform: [:ch | ch = $0 or: [ch = dot]]) ifTrue: [
		d := float abs log floor abs min: 7.
		display := float printFraction: d].
	(display conform: [:ch | ch = $0 or: [ch = dot]])
		ifTrue: [display := float printFraction: decimals].
	^display]

{ #category : #comparing }
DisplayFormat >> hash [
	^decimals
	]

{ #category : #initialization }
DisplayFormat >> initialize [
	decimals := 1.
	showSignificant := false.
	showThousands := true]

{ #category : #arithmetic }
DisplayFormat >> max: aDisplayFormat [
	| max |
	max := decimals max: aDisplayFormat decimals.
	^self copy decimals: max]

