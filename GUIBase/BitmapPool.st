"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BitmapPool,
	#superclass : #Object,
	#instVars : [
		'filename',
		'bitmaps'
	],
	#classVars : [
		'Pools'
	],
	#category : #GUIbase
}

{ #category : #accessing }
BitmapPool class >> addPoolNamed: aString [
	| pool |
	pool := self new name: aString.
	Pools at: pool name put: pool.
	^pool]

{ #category : #accessing }
BitmapPool class >> bitmapNamed: aString [
	^self bitmapNamed: aString ifAbsent: nil]

{ #category : #accessing }
BitmapPool class >> bitmapNamed: aString ifAbsent: aBlock [
	| bmp |
	Pools do: [:pool | 
		bmp := pool bitmapNamed: aString ifAbsent: nil.
		bmp notNil ifTrue: [^bmp]].
	^aBlock value]

{ #category : #accessing }
BitmapPool class >> bitmapNamed: key ifAbsentPut: aBlock [
	| bmp |
	bmp := self bitmapNamed: key ifAbsent: nil.
	bmp notNil ifTrue: [^bmp].
	bmp := aBlock value.
	bmp isBitmap ifTrue: [self currentPool at: key put: bmp asGDIBitmap].
	^bmp]

{ #category : #accessing }
BitmapPool class >> bitmapNamed: aString mergeWith: anotherString [
	| key original bmp |
	key := aString , ' with: ' , anotherString.
	^self bitmapNamed: key ifAbsentPut: [
		original := self bitmapNamed: aString.
		bmp := original asTransparentBitmap.
		original == bmp ifTrue: [bmp := bmp clone].
		bmp mergeWith: anotherString]]

{ #category : #accessing }
BitmapPool class >> boxOfColor: aColor [
	^self
		cacheAt: aColor printString
		ifAbsentPut: [GDIBitmap createBoxOfColor: aColor]]

{ #category : #accessing }
BitmapPool class >> cacheAt: key ifAbsentPut: aBlock [
	^self bitmapNamed: key ifAbsentPut: aBlock]

{ #category : #accessing }
BitmapPool class >> cacheAt: key put: aBitmap [
	self currentPool at: key put: aBitmap]

{ #category : #accessing }
BitmapPool class >> circleOfColor: aColor [
	^self
		cacheAt: aColor printString , 'Circle'
		ifAbsentPut: [GDIBitmap createCircleOfColor: aColor]]

{ #category : #accessing }
BitmapPool class >> currentPool [
	^Pools at: 'Current']

{ #category : #accessing }
BitmapPool class >> currentPools [
	^Pools]

{ #category : #services }
BitmapPool class >> defaultDirectory [
	| dir |
	dir := '.\Images' asFilename asDirectory.
	dir exists ifFalse: [dir create].
	^dir]

{ #category : #'instance creation' }
BitmapPool class >> fromFilename: aFilename [
	"
	BitmapPool fromFilename: 'dev.bpool'.
	"
	^self new filename: aFilename]

{ #category : #initialization }
BitmapPool class >> initialize [
	self initializePools]

{ #category : #initialization }
BitmapPool class >> initializePools [
	Pools := Dictionary new.
	self addPoolNamed: 'Current']

{ #category : #services }
BitmapPool class >> invalidateCache [
	self currentPool removeAll]

{ #category : #accessing }
BitmapPool class >> loadPoolFromFilenamed: aFilename [
	| pool |
	pool := self fromFilename: aFilename.
	Pools at: pool name put: pool.
	^pool]

{ #category : #accessing }
BitmapPool class >> loadPoolNamed: aString [
	| fn |
	fn := aString asFilename.
	fn fileExists ifFalse: [fn := self defaultDirectory \ aString].
	fn fileExists ifFalse: [fn := Directory default \ aString].
	^self loadPoolFromFilenamed: fn]

{ #category : #'instance creation' }
BitmapPool class >> new [
	^super new initialize]

{ #category : #services }
BitmapPool class >> poolNamed: aString [
	^Pools at: aString ifAbsent: nil]

{ #category : #accessing }
BitmapPool class >> pools [
	^Pools]

{ #category : #services }
BitmapPool class >> readPools [
	self savedPools do: [:pool | Pools at: pool name put: pool]]

{ #category : #services }
BitmapPool class >> savedPools [
	^(self savedPoolsIn: self defaultDirectory)
		& (self savedPoolsIn: Directory default)]

{ #category : #services }
BitmapPool class >> savedPoolsIn: aDirectory [
	| filenames |
	filenames := aDirectory fileNamesMatching: '*.bpool'.
	^filenames sort collect: [:fn | 
		Pools
			at: fn asFilename withoutExtension entityName
			ifAbsent: [self fromFilename: aDirectory \ fn]]]

{ #category : #accessing }
BitmapPool class >> transparentNamed: aString [
	| bmp |
	bmp := self bitmapNamed: aString ifAbsent: nil.
	bmp isNil ifTrue: [^nil].
	bmp hasAlphaChannel ifFalse: [
		bmp := bmp asTransparentBitmap.
		self cacheAt: bmp name put: bmp].
	^bmp]

{ #category : #accessing }
BitmapPool class >> transparentNamed: aString ifAbsentPut: aBlock [
	| bmp |
	bmp := self bitmapNamed: aString ifAbsent: nil.
	(bmp notNil and: [bmp hasAlphaChannel]) ifTrue: [^bmp].
	bmp isNil ifTrue: [bmp := aBlock value].
	bmp := bmp asTransparentBitmap.
	self cacheAt: aString put: bmp.
	^bmp]

{ #category : #adding }
BitmapPool >> add: aBitmap [
	self at: aBitmap name put: aBitmap]

{ #category : #accessing }
BitmapPool >> at: aString put: aBitmap [
	self ASSERT: aString notNil.
	aBitmap name: aString.
	^bitmaps at: aString put: aBitmap]

{ #category : #accessing }
BitmapPool >> bitmapNamed: aString [
	| bitmap |
	bitmap := self bitmapNamed: aString ifAbsent: [^nil].
	bitmap name: aString.
	^bitmap]

{ #category : #accessing }
BitmapPool >> bitmapNamed: aString ifAbsent: aBlock [
	^bitmaps at: aString ifAbsent: aBlock]

{ #category : #accessing }
BitmapPool >> bitmaps [
	^bitmaps asOrderedCollection sortBy: #name]

{ #category : #accessing }
BitmapPool >> bitmapsDictionary [
	^bitmaps]

{ #category : #'filein/out' }
BitmapPool >> fileIn [
	| file bmp |
	file := filename asFile binaryReadStream.
	[| n |
		file nextString.
		n := file nextULong.
		bitmaps := Dictionary new: n.
		n timesRepeat: [| key |
			key := file nextString.
			bmp := GDIBitmap fromStream: file.
			bmp name: key.
			bitmaps at: key put: bmp]]
		ensure: [file close]]

{ #category : #accessing }
BitmapPool >> filename [
	^filename]

{ #category : #accessing }
BitmapPool >> filename: aFilename [
	filename := aFilename asFilename withExtension: 'bpool'.
	filename exists ifTrue: [self fileIn]]

{ #category : #'filein/out' }
BitmapPool >> fileOut [
	| file |
	file := filename newFile beBinary.
	[
		file nextStringPut: filename asString; nextULongPut: bitmaps size.
		bitmaps do: [:bmp | 
			file nextStringPut: bmp name.
			bmp dumpOn: file]]
		ensure: [file close]]

{ #category : #initialization }
BitmapPool >> initialize [
	super initialize.
	bitmaps := Dictionary new]

{ #category : #accessing }
BitmapPool >> keys [
	^bitmaps keys]

{ #category : #accessing }
BitmapPool >> name [
	^filename withoutExtension entityName]

{ #category : #accessing }
BitmapPool >> name: aString [
	self filename: self class defaultDirectory \ aString]

{ #category : #printing }
BitmapPool >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		space;
		nextPutAll: self name doubleQuoted]

{ #category : #'adding/removing' }
BitmapPool >> removeAll [
	bitmaps removeAll]

{ #category : #adding }
BitmapPool >> removeKey: aString [
	bitmaps removeKey: aString ifAbsent: nil]

{ #category : #accessing }
BitmapPool >> size [
	^bitmaps size]

