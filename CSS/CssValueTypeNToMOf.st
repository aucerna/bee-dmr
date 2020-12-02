"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssValueTypeNToMOf,
	#superclass : #CssValueTypeConstraint,
	#instVars : [
		'n',
		'm'
	],
	#category : #CSS
}

{ #category : #accessing }
CssValueTypeNToMOf class >> isSimple [

	^false]

{ #category : #'instance creation' }
CssValueTypeNToMOf class >> readFrom: in [
	in peek = ${ ifTrue: [| s n m |
		in next.
		s := ', ' split: (in upToClosing: ${ with: $}).
		n := s first asNumber.
		m := s last asNumber.
		^(CssValueTypeNToMOf new n: n) m: m].
	^nil]

{ #category : #accessing }
CssValueTypeNToMOf class >> type [

	^${]

{ #category : #accessing }
CssValueTypeNToMOf >> addValues: aCollection fromStream: in [
	| pos |
	"At least n"
	n timesRepeat: [
		pos := in position.
		(self type addValues: aCollection fromStream: in) ifFalse: [
			in position: pos.
			^false]].
	"Fulfilled the minimum - read up to m elements - result is success"
	m - n timesRepeat: [
		pos := in position.
		(self type addValues: aCollection fromStream: in) ifFalse: [
			in position: pos.
			^true]].
	^true]

{ #category : #accessing }
CssValueTypeNToMOf >> m [
	^m]

{ #category : #accessing }
CssValueTypeNToMOf >> m: anObject [
	m := anObject]

{ #category : #accessing }
CssValueTypeNToMOf >> n [
	^n]

{ #category : #accessing }
CssValueTypeNToMOf >> n: anObject [
	n := anObject]

{ #category : #printing }
CssValueTypeNToMOf >> printOn: aStream [
	type printOn: aStream.
	aStream
		nextPut: ${;
		nextPutAll: self n asString;
		nextPut: $,;
		nextPutAll: self m asString;
		nextPut: $}]

