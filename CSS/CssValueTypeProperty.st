"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssValueTypeProperty,
	#superclass : #CssValueType,
	#instVars : [
		'propertyName',
		'valueType'
	],
	#category : #CSS
}

{ #category : #'instance creation' }
CssValueTypeProperty class >> readFrom: in [

	| s val | 
	in skipSeparators.
	in peek = $' ifFalse: [self error: 'CssValueTypeProperty must begin with "''"'].
	in next.
	s := in upTo: $'.
	val := self new propertyName: s.
	(CssValueTypeConstraint allTypes includes: in peek) ifTrue:
	[
		val := (CssValueTypeConstraint readFrom: in) type: val.
	].
	^val]

{ #category : #accessing }
CssValueTypeProperty >> addValues: aCollection fromStream: in [
	| returnValue size |
	size := aCollection size.
	returnValue := self valueType addValues: aCollection fromStream: in.
	returnValue ifTrue: [| vals newSize |
		newSize := aCollection size.
		vals := aCollection tail: newSize - size.
		[aCollection size > size] whileTrue: [aCollection removeLast].
		aCollection
			add: (((CssProperty propertyNamed: self propertyName) isDerived: true)
				propertyValue: vals)].
	^returnValue]

{ #category : #testing }
CssValueTypeProperty >> isValueValid: anObject [
	^self valueType isValueValid: anObject]

{ #category : #printing }
CssValueTypeProperty >> printOn: aStream [
	self valueType printOn: aStream]

{ #category : #accessing }
CssValueTypeProperty >> propertyName [
	^propertyName]

{ #category : #accessing }
CssValueTypeProperty >> propertyName: anObject [
	propertyName := anObject]

{ #category : #accessing }
CssValueTypeProperty >> valueType [
	valueType isNil
		ifTrue: [valueType := (CssPropertyDefinition named: self propertyName) valueType].
	^valueType]

