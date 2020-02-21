Class {
	#name : #LogicalAddress,
	#superclass : #Object,
	#instVars : [
		'#section',
		'#offset'
	],
	#category : #PE
}

{ #category : #private }
LogicalAddress class >> in: section atOffset: offset [
	^self new section: section; offset: offset
]

{ #category : #accessing }
LogicalAddress >> offset: anInteger [
	offset := anInteger
]

{ #category : #accessing }
LogicalAddress >> rva [
	^section rvaOf: offset
]

{ #category : #accessing }
LogicalAddress >> section: aSection [
	section := aSection
]

{ #category : #accessing }
LogicalAddress >> uLongPut: value [
	section uLongAtOffset: offset put: value
]

{ #category : #accessing }
LogicalAddress >> va [
	^section vaOf: offset
]

