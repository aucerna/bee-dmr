"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ColorMatrix,
	#superclass : #GdiPlusStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDIPlus
}

{ #category : #accessing }
ColorMatrix class >> def [
	^<def>
	typedef struct {
		REAL r1[5];
		REAL r2[5];
		REAL r3[5];
		REAL r4[5];
		REAL r5[5];
	} ColorMatrix;
	</def>]

{ #category : #accessing }
ColorMatrix class >> sizeInBytes [
	^sizeInBytes]

{ #category : #initialization }
ColorMatrix >> initialize: anInteger [
	super initialize: anInteger.
	self valueAt: 4 at: 4 put: 1]

{ #category : #accessing }
ColorMatrix >> r1 [
	| count data |
	count := 5.
	data := self bytesAtOffset: r1 count: 4 * count.
	^BufferArray new
		type: ExternalInt32;
		count: count;
		contents: data]

{ #category : #accessing }
ColorMatrix >> r1: aREALCollection [
	| offset delta |
	offset := r1.
	delta := 4.
	1 to: 5 do: [:i | | elem |
		elem := aREALCollection at: i.
		self realAtOffset: offset put: elem asParameter.
		offset := offset + delta]]

{ #category : #accessing }
ColorMatrix >> r1c1: aNumber [
	self valueAt: 0 at: 0 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r1c2: aNumber [
	self valueAt: 1 at: 0 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r1c3: aNumber [
	self valueAt: 2 at: 0 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r1c4: aNumber [
	self valueAt: 3 at: 0 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r2 [
	| count data |
	count := 5.
	data := self bytesAtOffset: r2 count: 4 * count.
	^BufferArray new
		type: ExternalInt32;
		count: count;
		contents: data]

{ #category : #accessing }
ColorMatrix >> r2: aREALCollection [
	| offset delta |
	offset := r2.
	delta := 4.
	1 to: 5 do: [:i | | elem |
		elem := aREALCollection at: i.
		self realAtOffset: offset put: elem asParameter.
		offset := offset + delta]]

{ #category : #accessing }
ColorMatrix >> r2c1: aNumber [
	self valueAt: 0 at: 1 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r2c2: aNumber [
	self valueAt: 1 at: 1 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r2c3: aNumber [
	self valueAt: 2 at: 1 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r2c4: aNumber [
	self valueAt: 3 at: 1 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r3 [
	| count data |
	count := 5.
	data := self bytesAtOffset: r3 count: 4 * count.
	^BufferArray new
		type: ExternalInt32;
		count: count;
		contents: data]

{ #category : #accessing }
ColorMatrix >> r3: aREALCollection [
	| offset delta |
	offset := r3.
	delta := 4.
	1 to: 5 do: [:i | | elem |
		elem := aREALCollection at: i.
		self realAtOffset: offset put: elem asParameter.
		offset := offset + delta]]

{ #category : #accessing }
ColorMatrix >> r3c1: aNumber [
	self valueAt: 0 at: 2 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r3c2: aNumber [
	self valueAt: 1 at: 2 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r3c3: aNumber [
	self valueAt: 2 at: 2 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r3c4: aNumber [
	self valueAt: 3 at: 2 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r4 [
	| count data |
	count := 5.
	data := self bytesAtOffset: r4 count: 4 * count.
	^BufferArray new
		type: ExternalInt32;
		count: count;
		contents: data]

{ #category : #accessing }
ColorMatrix >> r4: aREALCollection [
	| offset delta |
	offset := r4.
	delta := 4.
	1 to: 5 do: [:i | | elem |
		elem := aREALCollection at: i.
		self realAtOffset: offset put: elem asParameter.
		offset := offset + delta]]

{ #category : #accessing }
ColorMatrix >> r4c1: aNumber [
	self valueAt: 0 at: 3 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r4c2: aNumber [
	self valueAt: 1 at: 3 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r4c3: aNumber [
	self valueAt: 2 at: 3 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r4c4: aNumber [
	self valueAt: 3 at: 3 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r5 [
	| count data |
	count := 5.
	data := self bytesAtOffset: r5 count: 4 * count.
	^BufferArray new
		type: ExternalInt32;
		count: count;
		contents: data]

{ #category : #accessing }
ColorMatrix >> r5: aREALCollection [
	| offset delta |
	offset := r5.
	delta := 4.
	1 to: 5 do: [:i | | elem |
		elem := aREALCollection at: i.
		self realAtOffset: offset put: elem asParameter.
		offset := offset + delta]]

{ #category : #accessing }
ColorMatrix >> r5c1: aNumber [
	self valueAt: 0 at: 4 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r5c2: aNumber [
	self valueAt: 1 at: 4 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r5c3: aNumber [
	self valueAt: 2 at: 4 put: aNumber]

{ #category : #accessing }
ColorMatrix >> r5c4: aNumber [
	self valueAt: 3 at: 4 put: aNumber]

{ #category : #accessing }
ColorMatrix >> valueAt: x at: y [
	^(self realAtOffset: x * 5 + y * 4) asFloat]

{ #category : #accessing }
ColorMatrix >> valueAt: x at: y put: aNumber [
	self ASSERT: y < 5.
	^self realAtOffset: x * 5 + y * 4 put: aNumber]

