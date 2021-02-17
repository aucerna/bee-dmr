"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIBitmapTest,
	#superclass : #TestCase,
	#category : #GDI
}

{ #category : #all }
GDIBitmapTest >> testAsDisable [
	| bitmap i disabled |
	VirtualScreen current bitsPerPixel < 24 ifTrue: [^self].
	bitmap := GDIBitmap extent: 7 @ 8.
	i := 0.
	bitmap colorsReplace: [:color | 
		i := i + 3.
		Color red: i green: i + 1 blue: i + 2].
	disabled := bitmap asDisabled.
	disabled bitmap pointsDo: [:point | | original modified |
		original := bitmap colorAt: point.
		modified := disabled colorAt: point.
		self assert: original blendWithButtonFace = modified]]

{ #category : #'bitmap pool' }
GDIBitmapTest >> testBitmapPool [
	| filename pool rectangle copy |
	filename := Directory scratchDir filename \ 'test'.
	pool := BitmapPool fromFilename: filename.
	rectangle := 100 @ 100 extent: 32.
	copy := GDIBitmap fromScreen: rectangle.
	copy useAlphaChannel.
	copy name: 'screen'.
	pool add: copy.
	pool fileOut.
	[| pool2 copy2 |
		self assert: pool filename fileExists.
		pool2 := BitmapPool fromFilename: filename.
		pool2 fileIn.
		copy2 := pool2 bitmapNamed: 'screen'.
		self
			assert: copy2 hasAlphaChannel;
			assert: copy2 extent = copy extent]
		ensure: [pool filename asFile remove]]

{ #category : #all }
GDIBitmapTest >> testColorAt [
	| bmp24 i color bmp32 color1 color2 bmp |
	VirtualScreen current bitsPerPixel < 24 ifTrue: [^self].
	bmp24 := GDIBitmap width: 7 height: 8 bitCount: 24.
	i := 0.
	bmp24 usePrivateDC.
	bmp24 bitmap pointsDo: [:point | 
		color := Color red: i green: i + 1 blue: i + 2.
		bmp24 deviceContext setPixel: point color: color.
		i := i + 3].
	bmp := bmp24 bitmap.
	i := 0.
	bmp pointsDo: [:point | 
		color := Color red: i green: i + 1 blue: i + 2.
		color1 := bmp colorAt: point.
		color2 := bmp24 colorAt: point.
		self assert: color = color1.
		self assert: color = color2.
		self assert: color red = i.
		self assert: color green = (i + 1).
		self assert: color blue = (i + 2).
		i := i + 3].
	"			
"
	bmp32 := GDIBitmap width: 7 height: 8 bitCount: 32.
	bmp32 usePrivateDC.
	i := 0.
	bmp32 bitmap pointsDo: [:point | 
		color := Color red: i green: i + 1 blue: i + 2.
		bmp32 deviceContext setPixel: point color: color.
		i := i + 3].
	bmp := bmp32 bitmap.
	i := 0.
	bmp pointsDo: [:point | 
		color := Color red: i green: i + 1 blue: i + 2.
		color1 := bmp colorAt: point.
		color2 := bmp24 colorAt: point.
		self assert: color = color1.
		self assert: color = color2.
		self assert: color red = i.
		self assert: color green = (i + 1).
		self assert: color blue = (i + 2).
		i := i + 3]]

{ #category : #all }
GDIBitmapTest >> testColorAtPut [
	| bmp24 i color colorGeting bmp32 |
	VirtualScreen current bitsPerPixel < 24 ifTrue: [^self].
	bmp24 := GDIBitmap width: 7 height: 8 bitCount: 24.
	i := 0.
	bmp24 apply: [:bmp | 
		bmp pointsDo: [:point | 
			color := Color red: i green: i + 1 blue: i + 2.
			bmp colorAt: point put: color.
			colorGeting := bmp colorAt: point.
			self assert: color = colorGeting.
			self assert: color red = i.
			self assert: color green = (i + 1).
			self assert: color blue = (i + 2)]].
	"			
"
	bmp32 := GDIBitmap width: 7 height: 8 bitCount: 32.
	i := 0.
	bmp32 apply: [:bmp | 
		bmp pointsDo: [:point | 
			color := Color red: i green: i + 1 blue: i + 2.
			bmp colorAt: point put: color.
			colorGeting := bmp colorAt: point.
			self assert: color = colorGeting.
			self assert: color red = i.
			self assert: color green = (i + 1).
			self assert: color blue = (i + 2).
			i := i + 3]]]

{ #category : #all }
GDIBitmapTest >> testFlippedHorizontallyAndVertical [
	| bmp i color flipHorizontalBmp width colorFlipped flipVerticalBmp height |
	VirtualScreen current bitsPerPixel < 24 ifTrue: [^self].
	bmp := GDIBitmap extent: 7 @ 8.
	bmp apply: [:map | 
		i := 0.
		map pointsDo: [:point | 
			color := Color red: i green: i + 1 blue: i + 2.
			map colorAt: point put: color.
			i := i + 3]].
	"
"
	flipHorizontalBmp := bmp clone flipHorizontally.
	width := bmp width.
	flipHorizontalBmp xyDo: [:x :y | 
		colorFlipped := flipHorizontalBmp colorAt: x @ y.
		color := bmp colorAt: width - x - 1 @ y.
		self assert: color = colorFlipped].
	"
"
	flipVerticalBmp := bmp clone flipVertically.
	height := bmp height.
	flipVerticalBmp xyDo: [:x :y | 
		colorFlipped := flipVerticalBmp colorAt: x @ y.
		color := bmp colorAt: x @ (height - 1 - y).
		self assert: color = colorFlipped]]

{ #category : #all }
GDIBitmapTest >> testSetPixelColor [
	| bmp i color colorGeting |
	VirtualScreen current bitsPerPixel < 24 ifTrue: [^self].
	bmp := (GDIBitmap extent: 7 @ 8) bitmap.
	i := 0.
	bmp pointsDo: [:point | 
		color := Color red: i green: i + 1 blue: i + 2.
		bmp colorAt: point put: color.
		colorGeting := bmp colorAt: point.
		self assert: color = colorGeting.
		self assert: color red = i.
		self assert: color green = (i + 1).
		self assert: color blue = (i + 2).
		i := i + 3]]

{ #category : #all }
GDIBitmapTest >> testTP35996 [
	| string bitmap |
	string := '00160016A
000000000000000000000000000000000000000000000000000000000000000000000000041041239076000000164255000000164255041041239129000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041041239076000000164255041041239255041041239255000000164255041041239076000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041041239076000000164255041041239255074076123255088090136255041041239255000000164255041041239076000000000000000000000000000000000000000000000000000000000000000000000000000000000000041041239076000000164255041041239255091093153255130133132255154155155255138138192255041041239255000000164255041041239076000000000000000000000000000000000000000000000000000000000000041041239076000000164255041041239255115117157255141144143255184185184255193194194255185186186255161161196255041041239255000000164255041041239076000000000000000000000000000000000000041041239076000000164255041041239255139141163255158160159255190191191255221222222255221222222255221221221255215215215255181181201255041041239255000000164255041041239076000000000000041041239076000000164255041041239255157159167255162163163255218218218255234234234255234234234255234234234255233233233255233233233255231231231255208208220255041041239255000000164255041041239076000000164255041041239255177179179255161163162255216216216255230230230255231231231255231231231255231231231255230230230255228228228255228228228255227227227255228228231255041041239255000000164255000000164103041041239255226227226255083087085255083087085255083087085255083087085255231231231255122120119255125121118255117117117255125121118255118118117255245245245255041041239255000000164086000000000000083087085255241241241255083087085255123128126255124129127255125130128255231231231255124121118255195153121255117117117255194152119255124120117255244244244255083087085255000000000000000000000000083087085255240240240255083087085255129134132255129134132255129134132255231231231255123120117255183134095255117117117255174118074255122117114255243243243255083087085255000000000000000000000000083087085255239239239255083087085255131136134255131136134255101136138255231231231255129120113255164101052255117117117255164101052255129118110255243243243255083087085255000000000000000000000000083087085255239239239255083087085255132137135255132137135255126137136255231231231255182179177255193188184255188187186255193189185255164164164255242242242255083087085255000000000000000000000000083087085255238238238255083087085255133138136255133138136255133138136255231231231255162162162255163163163255163163163255163163163255163163163255242242242255083087085255000000000000000000000000083087085255245245245255099103101255148153151255150153152255150154153255242242242255245245245255245245245255245245245255245245245255245245245255251251251255083087085255000000000000000000000000083087085172083087085255083087085255083087085255083087085255083087085255083087085255083087085255083087085255083087085255083087085255083087085255083087085255083087085151000000000000'.
	bitmap := GDIBitmap fromString: string.
	self
		assert: 'Bitmap fromString: ' , string storeString = bitmap storeString]

{ #category : #clone }
GDIBitmapTest >> testTP36986 [
	| alpha image clone |
	alpha := (Bitmap named: 'Copy') asGDIBitmap.
	self precondition: alpha colors size > 1.
	image := GDIBitmap extent: alpha extent + 6 bitCount: 32.
	image beTransparent.
	alpha drawAt: 3 @ 3 on: image.
	clone := image clone.
	self assert: clone colors size > 1]

