"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #NullText,
	#superclass : #Object,
	#category : #RTF
}

{ #category : #all }
NullText >> , dummy [
	]

{ #category : #all }
NullText >> append: dummy [
	]

{ #category : #converting }
NullText >> asText [
	^self]

{ #category : #converting }
NullText >> beginsWith: aString [
	^false]

{ #category : #all }
NullText >> bold: dummy [
	]

{ #category : #all }
NullText >> contents [
	^'']

{ #category : #all }
NullText >> cr [
	]

{ #category : #all }
NullText >> crtab [
	]

{ #category : #all }
NullText >> crtab: dummy [
	]

{ #category : #all }
NullText >> doesNotUnderstand: aMessage [
	(Rtf canUnderstand: aMessage selector)
		ifFalse: [super doesNotUnderstand: aMessage]]

{ #category : #all }
NullText >> externalCopy [
	^'' externalCopy]

{ #category : #all }
NullText >> fontSize: dummy [
	]

{ #category : #testing }
NullText >> isUnicode [
	^false]

{ #category : #all }
NullText >> italic: dummy [
	]

{ #category : #all }
NullText >> nextPut: dummy [
	]

{ #category : #all }
NullText >> nextPutAll: dummy [
	]

{ #category : #all }
NullText >> space [
	]

{ #category : #all }
NullText >> tab [
	]

{ #category : #all }
NullText >> tab: dummy [
	]

{ #category : #all }
NullText >> underline: dummy [
	]

{ #category : #all }
NullText >> useColor: aColor fontSize: anInteger while: aBlock [
	aBlock value]

{ #category : #all }
NullText >> useColor: aColor while: aBlock [
	aBlock value]

{ #category : #all }
NullText >> useFont: aFont while: aBlock [
	aBlock value]

