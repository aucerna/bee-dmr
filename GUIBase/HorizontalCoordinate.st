"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HorizontalCoordinate,
	#superclass : #FrameCoordinate,
	#category : #GUIbase
}

{ #category : #accessing }
HorizontalCoordinate >> displayUnit [
	| screen |
	screen := owner notNil ifTrue: [owner screen] ifFalse: [Screen current].
	^screen xDU]

{ #category : #testing }
HorizontalCoordinate >> isHorizontal [
	^true]

{ #category : #testing }
HorizontalCoordinate >> isRightAligned [
	^ratio = 1 andNot: [self hasLinkedPanes]]

{ #category : #services }
HorizontalCoordinate >> keepProportion: aNumber in: aRectangle [
	| offset segment |
	segment := aRectangle left @ aRectangle right.
	offset := self offsetIn: segment.
	pixels := offset - (segment y - segment x * aNumber).
	ratio := aNumber]

{ #category : #services }
HorizontalCoordinate >> keepProportionWith: aRectangle [
	| offset segment |
	segment := aRectangle left @ aRectangle right.
	offset := self offsetIn: segment.
	inset := pixels := 0.
	ratio := offset / (segment y - segment x)]

{ #category : #inquiries }
HorizontalCoordinate >> linkSymbol [
	ratio = 0 ifTrue: [^#left].
	ratio = 1 ifTrue: [^#right].
	^super linkSymbol]

{ #category : #services }
HorizontalCoordinate >> moveTo: offset in: rectangle [
	pixels := offset - (rectangle width * ratio)]

{ #category : #accessing }
HorizontalCoordinate >> pointConnection [
	ratio = 1 ifTrue: [^#right].
	ratio = 0 ifTrue: [^#left].
	^#%]

{ #category : #inquiries }
HorizontalCoordinate >> ratioFor: aSymbol [
	aSymbol == #left ifTrue: [^0].
	aSymbol == #right ifTrue: [^1].
	^super ratioFor: aSymbol]

{ #category : #accessing }
HorizontalCoordinate >> referenceSegmentFrom: aRectangle [
	^pane isNil
		ifTrue: [aRectangle left @ aRectangle right]
		ifFalse: [pane horizontalFramingFor: aRectangle]]

{ #category : #inquiries }
HorizontalCoordinate >> referenceSymbol [
	ratio = 0 ifTrue: [^#left].
	ratio = 1 ifTrue: [^#right].
	^super referenceSymbol]

{ #category : #utility }
HorizontalCoordinate >> removePane: aChildWindow [
	pane == aChildWindow ifFalse: [^self].
	pane := aChildWindow framingLayout paneFromConnection: self.
	(pane isNil and: [ratio = 1]) ifTrue: [ratio := 0]]

{ #category : #accessing }
HorizontalCoordinate >> valueAt: aRectangle [
	| segment width |
	segment := self referenceSegmentFrom: aRectangle.
	width := segment y - segment x.
	^segment x + (width * ratio + self insetInPixels)]

