"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FramingLayoutTest,
	#superclass : #TestCase,
	#category : #GUIbase
}

{ #category : #all }
FramingLayoutTest >> testFixedSizeLayoutFrame [
	| window button r fixedSizeFraming |
	fixedSizeFraming := FramingLayout new
		leftRatio: 0;
		leftInset: 2;
		topRatio: 0;
		topInset: 2;
		rightRatio: 0;
		rightInset: -100;
		bottomRatio: 0;
		bottomInset: -100.
	button := Button new layout: fixedSizeFraming.
	window := MainWindow new.
	window rectangle: (0 @ 0 extent: 200).
	window addChild: button.
	window open.
	r := button rectangle.
	button layout: fixedSizeFraming.
	button resize.
	self assert: r = button rectangle.
	window rectangle: (0 @ 0 extent: 300).
	self assert: r = button rectangle.
	window close]

{ #category : #maximums }
FramingLayoutTest >> testMaximums [
	| framing |
	framing := FramingLayout new
		leftRatio: 0 inset: 0;
		topRatio: 0 inset: 0;
		rightRatio: 1 inset: 0;
		bottomRatio: 1 inset: 0.
	self testMaximumsOf: framing.
	framing := FramingLayout new
		leftRatio: 0 inset: 0;
		topRatio: 0 inset: 0;
		rightRatio: 1 inset: 0;
		bottomRatio: 1 inset: 0.
	self testMaximumsOf: framing]

{ #category : #maximums }
FramingLayoutTest >> testMaximumsOf: framing [
	| reference extent |
	reference := 0 @ 0 extent: 100.
	extent := (framing relativeTo: reference) extent.
	self assert: extent = (100 @ 100).
	framing maxHeight: 50; maxWidth: 70.
	extent := (framing relativeTo: reference) extent.
	self assert: extent = (70 @ 50).
	extent := (framing relativeTo: (10 @ 10 extent: 10 @ 20)) extent.
	self assert: extent = (10 @ 20)]

{ #category : #asserting }
FramingLayoutTest >> testTP35828A [
	| layout reference |
	layout := FramingLayout new
		leftRatio: 0 inset: 10;
		topRatio: 0 inset: 10;
		rightRatio: 1 inset: -20;
		bottomRatio: 1 inset: -20.
	reference := 0 @ 0 corner: 100 @ 100.
	layout top keepProportionWith: reference.
	self
		assert: layout top ratio = 0.1;
		assert: layout top inset = 0.
	layout left keepProportionWith: reference.
	self
		assert: layout left ratio = 0.1;
		assert: layout left inset = 0.
	layout bottom keepProportionWith: reference.
	self
		assert: layout bottom ratio = 0.8;
		assert: layout bottom inset = 0.
	layout right keepProportionWith: reference.
	self
		assert: layout right ratio = 0.8;
		assert: layout right inset = 0]

{ #category : #asserting }
FramingLayoutTest >> testTP35828B [
	| layout reference |
	layout := FramingLayout new
		leftRatio: 1 inset: -90;
		topRatio: 1 inset: -90;
		rightRatio: 0 inset: 80;
		bottomRatio: 0 inset: 80.
	reference := 0 @ 0 corner: 100 @ 100.
	layout top keepProportionWith: reference.
	self
		assert: layout top ratio = 0.1;
		assert: layout top inset = 0.
	layout left keepProportionWith: reference.
	self
		assert: layout left ratio = 0.1;
		assert: layout left inset = 0.
	layout bottom keepProportionWith: reference.
	self
		assert: layout bottom ratio = 0.8;
		assert: layout bottom inset = 0.
	layout right keepProportionWith: reference.
	self
		assert: layout right ratio = 0.8;
		assert: layout right inset = 0]

{ #category : #asserting }
FramingLayoutTest >> testTP35828C [
	| layout reference |
	layout := FramingLayout new
		leftRatio: 0.2 inset: -10;
		topRatio: 0.2 inset: -10;
		rightRatio: 0.9 inset: -10;
		bottomRatio: 0.9 inset: -10.
	reference := 0 @ 0 corner: 100 @ 100.
	layout top keepProportionWith: reference.
	self
		assert: layout top ratio = 0.1;
		assert: layout top inset = 0.
	layout left keepProportionWith: reference.
	self
		assert: layout left ratio = 0.1;
		assert: layout left inset = 0.
	layout bottom keepProportionWith: reference.
	self
		assert: layout bottom ratio = 0.8;
		assert: layout bottom inset = 0.
	layout right keepProportionWith: reference.
	self
		assert: layout right ratio = 0.8;
		assert: layout right inset = 0]

{ #category : #asserting }
FramingLayoutTest >> testTP35828D [
	| layout reference |
	layout := FramingLayout new
		leftRatio: 0 inset: 10;
		topRatio: 0 inset: 10;
		rightRatio: 1 inset: -20;
		bottomRatio: 1 inset: -20.
	reference := 0 @ 0 corner: 100 @ 100.
	layout top keepProportion: 1 in: reference.
	self
		assert: layout top ratio = 1;
		assert: layout top inset = -90.
	layout left keepProportion: 1 in: reference.
	self
		assert: layout left ratio = 1;
		assert: layout left inset = -90.
	layout bottom keepProportion: 0 in: reference.
	self
		assert: layout bottom ratio = 0;
		assert: layout bottom inset = 80.
	layout right keepProportion: 0 in: reference.
	self
		assert: layout right ratio = 0;
		assert: layout right inset = 80]

{ #category : #asserting }
FramingLayoutTest >> testTP35828E [
	| layout reference |
	layout := FramingLayout new
		leftRatio: 0 inset: 10;
		topRatio: 0 inset: 10;
		rightRatio: 1 inset: -20;
		bottomRatio: 1 inset: -20.
	reference := 0 @ 0 corner: 100 @ 100.
	layout top keepProportion: 0.5 in: reference.
	self
		assert: layout top ratio = 0.5;
		assert: layout top inset = -40.
	layout left keepProportion: 0.5 in: reference.
	self
		assert: layout left ratio = 0.5;
		assert: layout left inset = -40.
	layout bottom keepProportion: 0.5 in: reference.
	self
		assert: layout bottom ratio = 0.5;
		assert: layout bottom inset = 30.
	layout right keepProportion: 0.5 in: reference.
	self
		assert: layout right ratio = 0.5;
		assert: layout right inset = 30]

{ #category : #all }
FramingLayoutTest >> testTP36317 [
	| layout box result |
	layout := FramingLayout new
		leftRatio: 0 inset: 1;
		topRatio: 0 inset: 1;
		rightRatio: 1 inset: 1;
		bottomRatio: 1 inset: 1.
	box := 0 @ 0 corner: 100 @ 200.
	result := layout evaluateWith: box.
	self assert: result = (1 @ 1 corner: 101 @ 201)]

{ #category : #all }
FramingLayoutTest >> testWBNewFramerFromNewRect [
	| frame newFrame expected |
	frame := FramingLayout new
		leftRatio: 0 inset: 0;
		topRatio: 0 inset: 0;
		rightRatio: 1 inset: 0;
		bottomRatio: 1 inset: 0.
	newFrame := frame
		copyToGetRectangle: (1 @ 1 extent: 100)
		in: (0 @ 0 extent: 100).
	self
		assert: (newFrame relativeTo: (0 @ 0 extent: 100)) = (1 @ 1 extent: 100).
	expected := FramingLayout new
		leftRatio: 0 inset: 1;
		topRatio: 0 inset: 1;
		rightRatio: 1 inset: 1;
		bottomRatio: 1 inset: 1.
	self assert: (newFrame equals: expected)]

{ #category : #all }
FramingLayoutTest >> testWBNewFramerFromNewRectInWindow [
	| w rect staticFraming child buttonFraming button staticRect buttonRect framers movRect newFramer newRect delta |
	w := MainWindow new.
	rect := 0 @ 0 extent: 200.
	w rectangle: rect.
	staticFraming := FramingLayout new
		leftRatio: 0 inset: 10;
		topRatio: 0 inset: 10;
		rightRatio: 1 inset: -10;
		bottomRatio: 1 / 2 inset: -10.
	(child := ChildWindow new) layout: staticFraming.
	w addChild: child.
	"
"
	buttonFraming := FramingLayout new
		leftRatio: 0 inset: 0 linkTo: child;
		topRatio: 0 inset: 0 linkTo: child;
		rightRatio: 1 inset: 0 linkTo: child;
		bottomRatio: 1 inset: 0 linkTo: child.
	(button := ChildWindow new) layout: buttonFraming.
	w addChild: button.
	w open.
	"
"
	self
		assert: w width <= rect width
		description: 'Window rectangle falla si por ejemplo el initial rectangulo width es 100'.
	"
"
	staticRect := child relativeRectangle.
	buttonRect := button relativeRectangle.
	self assert: staticRect = buttonRect.
	"
"
	delta := -5 @ 5.
	(framers := OrderedCollection new)
		add: (FramingLayout new
			leftRatio: 0 inset: 10 linkTo: child;
			topRatio: 0 inset: 10 linkTo: child;
			rightRatio: 0 inset: 10 linkTo: child;
			bottomRatio: 0 inset: 10 linkTo: child);
		add: (FramingLayout new
			leftRatio: 1 inset: -10 linkTo: child;
			topRatio: 1 inset: -10 linkTo: child;
			rightRatio: 1 inset: 0 linkTo: child;
			bottomRatio: 1 inset: 0 linkTo: child);
		add: (FramingLayout new
			leftRatio: 1 / 2 inset: -10 linkTo: child;
			topRatio: 1 / 2 inset: -10 linkTo: child;
			rightRatio: 1 / 2 inset: 10 linkTo: child;
			bottomRatio: 1 / 2 inset: 10 linkTo: child).
	"
"
	framers do: [:framer | 
		button layout: framer; resize.
		rect := framer relativeTo: w rectangle.
		movRect := rect origin + delta extent: rect extent.
		newFramer := framer copyToGetRectangle: movRect in: w rectangle.
		newRect := newFramer relativeTo: w rectangle.
		self assert: movRect = newRect].
	w close]

{ #category : #all }
FramingLayoutTest >> testWBNewFramerFromNewRectProportional [
	| frame newFrame expected |
	frame := FramingLayout new
		leftRatio: 1 / 2 inset: 0;
		topRatio: 1 / 2 inset: 0;
		rightRatio: 1 / 2 inset: 10;
		bottomRatio: 1 / 2 inset: 10.
	newFrame := frame
		copyToGetRectangle: (10 @ 10 extent: 20)
		in: (0 @ 0 extent: 100).
	self
		assert: (newFrame relativeTo: (0 @ 0 extent: 100)) = (10 @ 10 extent: 20).
	self assert: frame leftInset = newFrame leftInset.
	self assert: frame topInset = newFrame topInset.
	self assert: frame rightInset = newFrame rightInset.
	self assert: frame bottomInset = newFrame bottomInset.
	expected := FramingLayout new
		leftRatio: 1 / 10 inset: 0;
		topRatio: 1 / 10 inset: 0;
		rightRatio: 1 / 5 inset: 10;
		bottomRatio: 1 / 5 inset: 10.
	self assert: (newFrame equals: expected)]

