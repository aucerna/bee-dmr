"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RGBColor,
	#superclass : #Color,
	#instVars : [
		'red',
		'green',
		'blue'
	],
	#category : #GUIbase
}

{ #category : #'instance creation' }
RGBColor class >> black [
	^self red: 0 green: 0 blue: 0]

{ #category : #'instance creation' }
RGBColor class >> fromInteger: anInteger [
	| colorref |
	colorref := COLORREF fromInteger: anInteger.
	^colorref asColor]

{ #category : #'instance creation' }
RGBColor class >> fromPalette: aLOGPALETTE index: anInteger [
	| entry result |
	entry := PALETTEENTRY external.
	result := GDILibrary
		getPaletteEntries: aLOGPALETTE asParameter
		iStartIndex: anInteger
		nEntries: 1
		lppe: entry asParameter.
	result = 0 ifTrue: [^self winError].
	^entry makeLocal asColor]

{ #category : #'instance creation' }
RGBColor class >> fromPaletteIndex: anInteger [
	| hPalette |
	hPalette := GDIPalette stockObject: DEFAULT_PALETTE.
	^self fromPalette: hPalette index: anInteger]

{ #category : #'instance creation' }
RGBColor class >> red: r green: g blue: b [
	| m |
	m := (r max: g) max: b.
	(0 < m and: [m <= 1] and: [m isFloat]) ifTrue: [self ASSERT: false].
	^self new
		red: ((r asInteger min: 255) max: 0);
		green: ((g asInteger min: 255) max: 0);
		blue: ((b asInteger min: 255) max: 0)]

{ #category : #'instance creation' }
RGBColor class >> relativeR: r G: g B: b [
	| rr gg bb |
	rr := ((r max: 0.0) min: 1.0) * 255.0.
	gg := ((g max: 0.0) min: 1.0) * 255.0.
	bb := ((b max: 0.0) min: 1.0) * 255.0.
	^self new
		red: rr asInteger;
		green: gg asInteger;
		blue: bb asInteger]

{ #category : #comparing }
RGBColor >> = aColor [
	aColor class == self class ifFalse: [^false].
	^red = aColor red and: [green = aColor green] and: [blue = aColor blue]]

{ #category : #converting }
RGBColor >> asInteger [
	^((blue bitShift: 16) bitOr: (green bitShift: 8)) bitOr: red]

{ #category : #converting }
RGBColor >> asParameter [
	^(COLORREF fromColor: self) asParameter]

{ #category : #converting }
RGBColor >> asRGBColor [
	^self]

{ #category : #accessing }
RGBColor >> blue [
	^blue]

{ #category : #accessing }
RGBColor >> blue: value [
	blue := value]

{ #category : #inquiries }
RGBColor >> brightness [
	^((red max: green) max: blue) / 255.0]

{ #category : #accessing }
RGBColor >> green [
	^green]

{ #category : #accessing }
RGBColor >> green: value [
	green := value]

{ #category : #comparing }
RGBColor >> hash [
	^red hashWith: green with: blue]

{ #category : #initialization }
RGBColor >> initialize [
	super initialize.
	red := green := blue := 0]

{ #category : #testing }
RGBColor >> isRGBColor [
	^true]

{ #category : #accessing }
RGBColor >> red [
	^red]

{ #category : #accessing }
RGBColor >> red: value [
	red := value]

{ #category : #printing }
RGBColor >> storeOn: aStream [
	aStream
		nextPut: $(;
		nextPutAll: self class name;
		nextPutAll: ' red: ';
		nextPutAll: red printString;
		nextPutAll: ' green: ';
		nextPutAll: green printString;
		nextPutAll: ' blue: ';
		nextPutAll: blue printString;
		nextPut: $)]

