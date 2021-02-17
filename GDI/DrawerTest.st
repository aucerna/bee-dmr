"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DrawerTest,
	#superclass : #TestCase,
	#instVars : [
		'window',
		'drawer'
	],
	#category : #GDI
}

{ #category : #testing }
DrawerTest class >> isAbstract [
	^self == DrawerTest]

{ #category : #'set up' }
DrawerTest >> drawerClass [
	self subclassResponsibility]

{ #category : #private }
DrawerTest >> extent [
	^self width @ self height]

{ #category : #private }
DrawerTest >> height [
	^400]

{ #category : #'set up' }
DrawerTest >> setUp [
	super setUp.
	window := MainWindow new.
	window
		answerTo: #usesPrivateDC with: true;
		style: window style;
		extendedStyle: 0;
		rectangle: (0 @ 0 extent: self extent);
		createWindowNamed: self class asString , ': ' , testSelector asString.
	drawer := self drawerClass onDC: window deviceContext.
	drawer clear]

{ #category : #running }
DrawerTest >> tearDown [
	super tearDown.
	drawer invalidateDC.
	window close]

{ #category : #'drawing - bitmaps' }
DrawerTest >> testDrawBitmapAt [
	| bitmap |
	bitmap := GDIBitmap fromScreen: (0 @ 0 extent: 256 @ 256).
	drawer drawBitmap: bitmap at: 100 @ 100]

{ #category : #'drawing - ellipses' }
DrawerTest >> testDrawEllipse [
	| max |
	drawer lineWidth: 2.
	max := self extent - (30 @ 30).
	1 to: 10 do: [:i | | color offset rectangle |
		color := Color choose: i from: 10.
		offset := i @ i * (8 @ 12).
		rectangle := offset extent: max - (offset * 2).
		drawer lineColor: color; drawEllipse: rectangle]]

{ #category : #'drawing - lines' }
DrawerTest >> testDrawLineFromTo [
	| max r1 r2 center |
	max := (self width min: self height) / 2.0.
	r1 := max * 0.8.
	r2 := max * 0.2.
	center := self extent * 0.9 // 2.
	drawer lineWidth: 5.
	(0 to: 360 by: 10) withIndexDo: [:angle :i | | color radians p1 p2 |
		color := Color choose: i from: 37.
		radians := angle degreesToRadians.
		p1 := (radians cos @ radians sin * r2 + center) rounded.
		p2 := (radians cos @ radians sin * r1 + center) rounded.
		drawer
			lineColor: color;
			drawLineFrom: p1 to: p2]]

{ #category : #'drawing - polygons' }
DrawerTest >> testDrawPolygon [
	| max center sweep angles |
	max := (self width min: self height) // 2.
	drawer lineWidth: 2.
	center := (self extent // 2) asPoint.
	sweep := 180.0 / 5.
	angles := (0 to: 360 by: sweep)
		collect: [:s | s + 90 \\ 360]
		in: OrderedCollection new.
	1 to: 10 do: [:i | | color outer inner points |
		color := Color choose: i from: 10.
		outer := max - (i * 20) max: 8.
		inner := outer * 0.4.
		points := angles withIndexCollect: [:a :j | | r x y |
			r := j even ifTrue: [outer] ifFalse: [inner].
			x := a degreesToRadians cos * r.
			y := a degreesToRadians sin * r.
			(x + center x) rounded @ (y + center y) rounded].
		drawer lineColor: color; drawPolygon: points]]

{ #category : #'drawing - rectangles' }
DrawerTest >> testDrawRectangle [
	| max |
	drawer lineWidth: 2.
	max := self extent - (30 @ 30).
	1 to: 10 do: [:i | | color offset rectangle |
		color := Color choose: i from: 10.
		offset := i @ i * (8 @ 12).
		rectangle := offset extent: max - (offset * 2).
		drawer lineColor: color; drawRectangle: rectangle]]

{ #category : #'drawing - strings' }
DrawerTest >> testDrawStringAt [
	| font place |
	font := GDIFont face: 'Trebuchet' size: 20.
	place := 10 @ window rectangle center y.
	drawer
		lineColor: Color black;
		drawLineFrom: place x - 5 @ place y to: place x + 5 @ place y;
		drawLineFrom: place x @ (place y - 5) to: place x @ (place y + 5);
		font: font;
		textColor: (Color red: 255 green: 128 blue: 0);
		drawString: 'Testing basic text drawing' at: place]

{ #category : #'drawing - ellipses' }
DrawerTest >> testFillEllipse [
	| max |
	drawer lineWidth: 2.
	max := self extent - (30 @ 30).
	1 to: 10 do: [:i | | color offset rectangle |
		color := Color choose: i from: 10.
		offset := i @ i * (8 @ 12).
		rectangle := offset extent: max - (offset * 2).
		drawer solidBrush: color; fillEllipse: rectangle]]

{ #category : #'drawing - polygons' }
DrawerTest >> testFillPolygon [
	| max center sweep angles |
	max := (self width min: self height) // 2.
	drawer lineWidth: 2.
	center := (self extent // 2) asPoint.
	sweep := 180.0 / 5.
	angles := (0 to: 360 by: sweep)
		collect: [:s | s + 90 \\ 360]
		in: OrderedCollection new.
	1 to: 10 do: [:i | | color outer inner points |
		color := Color choose: i from: 10.
		outer := max - (i * 20) max: 8.
		inner := outer * 0.4.
		points := angles withIndexCollect: [:a :j | | r x y |
			r := j even ifTrue: [outer] ifFalse: [inner].
			x := a degreesToRadians cos * r.
			y := a degreesToRadians sin * r.
			(x + center x) rounded @ (y + center y) rounded].
		drawer solidBrush: color; fillPolygon: points]]

{ #category : #'drawing - rectangles' }
DrawerTest >> testFillRectangle [
	| max |
	drawer lineWidth: 2.
	max := self extent - (30 @ 30).
	1 to: 10 do: [:i | | color offset rectangle |
		color := Color choose: i from: 10.
		offset := i @ i * (8 @ 12).
		rectangle := offset extent: max - (offset * 2).
		drawer solidBrush: color; fillRectangle: rectangle]]

{ #category : #'drawing - rectangles' }
DrawerTest >> testRectangleCorner [
	drawer
		lineWidth: 1;
		brushColor: Color green;
		fillRectangle: (10 @ 10 extent: 50 @ 20);
		drawRectangle: (25 @ 10 extent: 50 @ 20);
		fillRectangle: (100 @ 10 extent: 50 @ 20);
		drawRectangle: (100 @ 20 extent: 50 @ 20)]

{ #category : #private }
DrawerTest >> width [
	^400]

