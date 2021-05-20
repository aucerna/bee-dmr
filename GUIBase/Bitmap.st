"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Bitmap,
	#superclass : #Object,
	#instVars : [
		'width',
		'height',
		'bits',
		'bitCount'
	],
	#category : #GUIbase
}

{ #category : #private }
Bitmap class >> cache [
	^BitmapPool currentPool]

{ #category : #private }
Bitmap class >> cacheAt: key ifAbsentPut: newBitmapBlock [
	^BitmapPool cacheAt: key ifAbsentPut: newBitmapBlock]

{ #category : #'instance creation' }
Bitmap class >> fromBitmap: aBitmap [
	^self new fromBitmap: aBitmap]

{ #category : #'instance creation' }
Bitmap class >> fromStream: aStream [
	| info bitmap bits |
	aStream skip: BITMAPFILEHEADER sizeInBytes.
	info := BITMAPINFO fromStream: aStream.
	bitmap := self new.
	bits := ByteArray new: info imageSize.
	aStream getBytesFor: bits.
	^bitmap bitmapInfo: info; createBitmapFromBits: bits]

{ #category : #'instance creation' }
Bitmap class >> fromString: aString [
	^self new fromString: aString]

{ #category : #services }
Bitmap class >> named: aString [
	^BitmapPool bitmapNamed: aString]

{ #category : #services }
Bitmap class >> named: aString ifAbsent: aBlock [
	^BitmapPool bitmapNamed: aString ifAbsent: aBlock]

{ #category : #services }
Bitmap class >> named: aString ifAbsentPut: aBlock [
	^BitmapPool bitmapNamed: aString ifAbsentPut: aBlock]

{ #category : #'instance accessing' }
Bitmap class >> named: aString mergeWith: anotherString [
	^BitmapPool bitmapNamed: aString mergeWith: anotherString]

{ #category : #'alpha blending' }
Bitmap class >> transparentNamed: aString [
	^BitmapPool transparentNamed: aString]

{ #category : #'alpha blending' }
Bitmap class >> transparentNamed: aString ifAbsentPut: aBlock [
	^BitmapPool transparentNamed: aString ifAbsentPut: aBlock]

{ #category : #'alpha blending' }
Bitmap class >> transparentNamed: aString mergeWith: anotherString [
	^BitmapPool bitmapNamed: aString mergeWith: anotherString]

{ #category : #services }
Bitmap >> addHalo [
	| opacity factor halo border corners h w |
	opacity := 64.
	factor := opacity / 255.0 * 0.8.
	halo := ByteArray
		with: opacity
		with: (192 * factor) rounded
		with: (122 * factor) rounded
		with: (250 * factor) rounded.
	opacity := 192.
	factor := opacity / 255.0 * 0.8.
	border := ByteArray
		with: opacity
		with: (192 * factor) rounded
		with: (122 * factor) rounded
		with: (250 * factor) rounded.
	corners := (self boundingRectangle moveBy: -0.5) corners.
	h := height - 3.
	w := width - 3.
	self xyDo: [:x :y | | corner color |
		(self opacityAt: x @ y) = 0 ifTrue: [
			corner := corners
				detect: [:point | (point distanceTo: x @ y) < 4]
				ifNone: nil.
			corner notNil
				ifTrue: [(x @ y distanceTo: corner) > 2
					ifTrue: [self atX: x y: y putArgb: border]]
				ifFalse: [
					color := x < 2 | (w < x) | (y < 2) | (h < y) ifTrue: [border] ifFalse: [halo].
					self atX: x y: y putArgb: color]]]]

{ #category : #services }
Bitmap >> addShadow [
	self addShadowLength: 8 sunPosition: 135]

{ #category : #services }
Bitmap >> addShadowLength: length sunPosition: degrees [
	| cos sin |
	cos := degrees degreesToRadians cos.
	sin := degrees degreesToRadians sin.
	self xyDo: [:x :y | | argb opacity |
		argb := self argbAtX: x y: y.
		opacity := argb first.
		opacity = 0 ifTrue: [
			length to: 1 by: -1 do: [:i | 
				(self opacityAt: x + (cos * i) rounded @ (y - (sin * i) rounded)) = 255
					ifTrue: [opacity := length - i + 1 * 96 // length]].
			opacity > 0 ifTrue: [
				argb at: 1 put: opacity.
				self atX: x - 2 y: y - 2 putArgb: argb]]]]

{ #category : #private }
Bitmap >> applyAlphaChannel [
	self xyDo: [:x :y | | argb a |
		argb := self argbAtX: x y: y.
		a := argb first.
		argb
			at: 2 put: argb second * a // 255;
			at: 3 put: argb third * a // 255;
			at: 4 put: argb fourth * a // 255.
		self atX: x y: y putArgb: argb]]

{ #category : #private }
Bitmap >> applyTransparency: byte [
	self
		xyDo: [:x :y | | opacity alpha |
			opacity := self opacityAtX: x y: y.
			alpha := opacity min: byte.
			self atX: x y: y putAlpha: alpha];
		applyAlphaChannel]

{ #category : #'pixel accessing' }
Bitmap >> argbAtX: x y: y [
	| i |
	^((y between: 0 and: height - 1) and: [x between: 0 and: width - 1])
		ifTrue: [
			i := height - 1 - y * width + x * 4.
			ByteArray
				with: (bits at: i + 4)
				with: (bits at: i + 3)
				with: (bits at: i + 2)
				with: (bits at: i + 1)]
		ifFalse: [
			ByteArray
				with: 0
				with: 0
				with: 0
				with: 0]]

{ #category : #converting }
Bitmap >> asCursorPointer [
	^self asGDIBitmap asCursorPointer]

{ #category : #services }
Bitmap >> asGDIBitmap [
	^GDIBitmap fromBitmap: self]

{ #category : #converting }
Bitmap >> asTransparentBitmap [
	^self asGDIBitmap asTransparentBitmap]

{ #category : #'pixel accessing' }
Bitmap >> at: aPoint putAlpha: alpha [
	self atX: aPoint x y: aPoint y putAlpha: alpha]

{ #category : #'pixel accessing' }
Bitmap >> atX: x y: y putAlpha: alpha [
	| i |
	self
		ASSERT: (alpha between: 0 and: 255);
		ASSERT: (x between: 0 and: width - 1);
		ASSERT: (y between: 0 and: height - 1).
	i := height - 1 - y * width + x * 4.
	bits at: i + 4 put: alpha]

{ #category : #'pixel accessing' }
Bitmap >> atX: x
y: y
putAlpha: alpha
r: red
g: green
b: blue [
	| i |
	self
		ASSERT: (x between: 0 and: width - 1);
		ASSERT: (y between: 0 and: height - 1).
	i := height - 1 - y * width + x * 4.
	bits
		at: i + 4 put: alpha;
		at: i + 3 put: red;
		at: i + 2 put: green;
		at: i + 1 put: blue]

{ #category : #'pixel accessing' }
Bitmap >> atX: x y: y putArgb: aByteArray [
	| i |
	self
		ASSERT: (x between: 0 and: width - 1);
		ASSERT: (y between: 0 and: height - 1).
	i := height - 1 - y * width + x * 4.
	bits
		at: i + 4 put: aByteArray first;
		at: i + 3 put: aByteArray second;
		at: i + 2 put: aByteArray third;
		at: i + 1 put: aByteArray fourth]

{ #category : #'pixel accessing' }
Bitmap >> atX: x
y: y
putColor: aColor
alpha: alpha [
	self
		atX: x
		y: y
		putAlpha: alpha
		r: aColor red
		g: aColor green
		b: aColor blue]

{ #category : #services }
Bitmap >> beTransparent [
	self
		xyDo: [:x :y | self atX: x y: y putAlpha: 0];
		applyAlphaChannel]

{ #category : #accessing }
Bitmap >> bitCount [
	^bitCount]

{ #category : #accessing }
Bitmap >> bitmap [
	^self]

{ #category : #private }
Bitmap >> bitmapInfo: aBITMAPINFO [
	width := aBITMAPINFO width.
	height := aBITMAPINFO height.
	bitCount := aBITMAPINFO bitCount]

{ #category : #accessing }
Bitmap >> bits [
	^bits]

{ #category : #accessing }
Bitmap >> boundingRectangle [
	^0 @ 0 extent: self extent]

{ #category : #'pixel accessing' }
Bitmap >> colorAt: aPoint [
	^self colorAtX: aPoint x y: aPoint y]

{ #category : #'pixel accessing' }
Bitmap >> colorAt: aPoint put: aColor [
	self colorAtX: aPoint x y: aPoint y put: aColor]

{ #category : #'pixel accessing' }
Bitmap >> colorAt: aPoint
putRed: red
green: green
blue: blue [
	self
		colorAtX: aPoint x
		y: aPoint y
		putRed: red
		green: green
		blue: blue]

{ #category : #'pixel accessing' }
Bitmap >> colorAtX: x y: y [
	| index |
	index := self indexAtX: x y: y.
	^bitCount = 16
		ifTrue: [
			Color
				red: ((bits at: index + 2) bitAnd: 16rF)
				green: ((bits at: index + 2) bitShift: -4)
				blue: ((bits at: index + 1) bitAnd: 16rF)]
		ifFalse: [
			Color
				red: (bits at: index + 3)
				green: (bits at: index + 2)
				blue: (bits at: index + 1)]]

{ #category : #'pixel accessing' }
Bitmap >> colorAtX: x y: y put: color [
	self
		colorAtX: x
		y: y
		putRed: color red
		green: color green
		blue: color blue]

{ #category : #'pixel accessing' }
Bitmap >> colorAtX: x
y: y
putRed: red
green: green
blue: blue [
	| index |
	index := self indexAtX: x y: y.
	bitCount = 16
		ifTrue: [
			bits
				at: index + 1 put: (blue max: 15);
				at: index + 2 put: (red max: 15) + ((green max: 15) bitShift: 4)]
		ifFalse: [
			bits
				at: index + 3 put: red;
				at: index + 2 put: green;
				at: index + 1 put: blue]]

{ #category : #accessing }
Bitmap >> colors [
	| colors |
	colors := Set new.
	self xyDo: [:x :y | colors add: (self colorAtX: x y: y)].
	^colors]

{ #category : #accessing }
Bitmap >> colorsIn: aRectangle [
	| colors |
	colors := Set new.
	aRectangle top to: aRectangle bottom - 1 do: [:y | 
		aRectangle left to: aRectangle right - 1 do: [:x | | color |
			color := self colorAtX: x y: y.
			colors add: color]].
	^colors]

{ #category : #services }
Bitmap >> colorsReplace: aBlock [
	self xyDo: [:x :y | | c d |
		c := self colorAtX: x y: y.
		d := aBlock value: c.
		d notNil ifTrue: [self colorAtX: x y: y put: d]]]

{ #category : #accessing }
Bitmap >> extent [
	^width @ height]

{ #category : #private }
Bitmap >> fromBitmap: aGDIBitmap [
	width := aGDIBitmap width.
	height := aGDIBitmap height.
	bitCount := aGDIBitmap bitCount.
	bits := aGDIBitmap getDIBits: true]

{ #category : #'instance creation' }
Bitmap >> fromString: aString [
	| read type count alpha |
	read := aString readStream.
	width := read next: 4.
	height := read next: 4.
	type := read nextLine.
	self ASSERT: (type = 'A' or: [type = 'B']).
	count := 3.
	alpha := type = 'A'.
	alpha ifTrue: [count := 4].
	width := width asInteger.
	height := height asInteger.
	bitCount := 32.
	bits := ByteArray new: width * height * bitCount // 8.
	self xyDo: [:x :y | | index |
		index := self indexAtX: x y: y.
		1 to: count do: [:i | | byte |
			byte := read next: 3.
			bits at: index + i put: byte asInteger]]]

{ #category : #accessing }
Bitmap >> height [
	^height]

{ #category : #private }
Bitmap >> indexAt: aPoint [
	^self indexAtX: aPoint x y: aPoint y]

{ #category : #private }
Bitmap >> indexAtX: x y: y [
	| dwords bytes |
	bytes := bitCount // 8.
	dwords := width * bytes + 3 // 4 * 4.
	^height - 1 - y * dwords + (x * bytes)]

{ #category : #testing }
Bitmap >> isBitmap [
	^true]

{ #category : #testing }
Bitmap >> isTransparentAt: aPoint [
	^(self opacityAt: aPoint) < 240]

{ #category : #services }
Bitmap >> opacity: aNumber [
	self
		xyDo: [:x :y | | i |
			i := height - 1 - y * width + x * 4.
			bits at: i + 4 put: aNumber];
		applyAlphaChannel]

{ #category : #'pixel accessing' }
Bitmap >> opacityAt: aPoint [
	^self opacityAtX: aPoint x y: aPoint y]

{ #category : #'pixel accessing' }
Bitmap >> opacityAtX: x y: y [
	^(self argbAtX: x y: y) first]

{ #category : #enumerating }
Bitmap >> pointsDo: aBlock [
	self xyDo: [:x :y | aBlock value: x @ y]]

{ #category : #accessing }
Bitmap >> storeOn: aStream alpha: aBoolean [
	| n |
	aStream
		nextPutAll: 'Bitmap fromString: ';
		nextPut: $';
		nextPutAll: (self width printPaddedWith: $0 to: 4);
		nextPutAll: (self height printPaddedWith: $0 to: 4);
		nextPutAll: (aBoolean ifTrue: ['A'] ifFalse: ['B']);
		cr.
	n := aBoolean ifTrue: [4] ifFalse: [3].
	self xyDo: [:x :y | | index |
		index := self indexAtX: x y: y.
		1 to: n do: [:i | | bit |
			bit := bits at: index + i.
			bit := bit printPaddedWith: $0 to: 3.
			aStream nextPutAll: bit]].
	aStream nextPut: $']

{ #category : #'filein/out' }
Bitmap >> stub [
	^ObjectStub for: self selector: #asGDIBitmap]

{ #category : #services }
Bitmap >> transparentColor: aColor [
	| black |
	black := Color black.
	self xyDo: [:x :y | | color |
		color := self colorAtX: x y: y.
		color = aColor
			ifTrue: [
				self
					atX: x
					y: y
					putColor: black
					alpha: 0]
			ifFalse: [self atX: x y: y putAlpha: 255]]]

{ #category : #private }
Bitmap >> typeFrom: aString [
	^aString at: 9]

{ #category : #accessing }
Bitmap >> width [
	^width]

{ #category : #enumerating }
Bitmap >> xyDo: aBlock [
	0
		to: height - 1
		do: [:y | 0 to: width - 1 do: [:x | aBlock value: x value: y]]]

