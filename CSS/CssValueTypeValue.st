"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssValueTypeValue,
	#superclass : #CssValueType,
	#instVars : [
		'valueClass'
	],
	#category : #CSS
}

{ #category : #'instance creation' }
CssValueTypeValue class >> readFrom: in [

	| str vt val |

	in peek = $< ifFalse: [self error: 'CssValueType must begin with ''<'''].

	str := (in upTo: $>),'>'.
	vt := CssValue forType: str.
	val := vt notNil 
		ifTrue: [self new valueClass: vt] 
		ifFalse: [self error: ('Unknown CSS value type ',str)].
	in skipSeparators.
	(CssValueTypeConstraint allTypes includes: in peek) ifTrue:
	[
		val := (CssValueTypeConstraint readFrom: in) type: val.
	].
	^val]

{ #category : #accessing }
CssValueTypeValue >> addValues: aCollection fromStream: in [
	| pos val |
	pos := in position.
	val := self valueClass readFrom: in.
	^(val notNil and: [val isValid])
		ifTrue: [
			aCollection add: val.
			true]
		ifFalse: [
			in position: pos.
			false]]

{ #category : #testing }
CssValueTypeValue >> isValueValid: anObject [
	^(self valueClass new string: anObject asString) isValid]

{ #category : #printing }
CssValueTypeValue >> printOn: aStream [
	aStream nextPutAll: self valueClass type]

{ #category : #accessing }
CssValueTypeValue >> valueClass [
	^valueClass]

{ #category : #accessing }
CssValueTypeValue >> valueClass: anObject [
	valueClass := anObject]

