"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #VerticalCoordinate,
	#superclass : #FrameCoordinate,
	#category : #GUIbase
}

{ #category : #accessing }
VerticalCoordinate >> displayUnit [
	| screen |
	screen := owner notNil ifTrue: [owner screen] ifFalse: [Screen current].
	^screen yDU]

{ #category : #services }
VerticalCoordinate >> keepProportion: aNumber in: aRectangle [
	| offset segment |
	segment := aRectangle top @ aRectangle bottom.
	offset := self offsetIn: segment.
	pixels := offset - (segment y - segment x * aNumber).
	ratio := aNumber]

{ #category : #services }
VerticalCoordinate >> keepProportionWith: aRectangle [
	| offset segment |
	segment := aRectangle top @ aRectangle bottom.
	offset := self offsetIn: segment.
	inset := pixels := 0.
	ratio := offset / (segment y - segment x)]

{ #category : #inquiries }
VerticalCoordinate >> linkSymbol [
	ratio = 0 ifTrue: [^#top].
	ratio = 1 ifTrue: [^#bottom].
	^super linkSymbol]

{ #category : #services }
VerticalCoordinate >> moveTo: offset in: rectangle [
	pixels := offset - (rectangle height * ratio)]

{ #category : #accessing }
VerticalCoordinate >> pointConnection [
	ratio = 1 ifTrue: [^#bottom].
	ratio = 0 ifTrue: [^#top].
	^#%]

{ #category : #inquiries }
VerticalCoordinate >> ratioFor: aSymbol [
	aSymbol == #top ifTrue: [^0].
	aSymbol == #bottom ifTrue: [^1].
	^super ratioFor: aSymbol]

{ #category : #utility }
VerticalCoordinate >> referenceSegmentFrom: aRectangle [
	^pane isNil
		ifTrue: [aRectangle top @ aRectangle bottom]
		ifFalse: [pane verticalFramingFor: aRectangle]]

{ #category : #inquiries }
VerticalCoordinate >> referenceSymbol [
	ratio = 0 ifTrue: [^#top].
	ratio = 1 ifTrue: [^#bottom].
	^super referenceSymbol]

