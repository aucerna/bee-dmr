"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BottomCoordinate,
	#superclass : #VerticalCoordinate,
	#category : #GUIbase
}

{ #category : #testing }
BottomCoordinate >> canTieToOpposite [
	^true]

{ #category : #private }
BottomCoordinate >> defaultRatio [
	^1]

{ #category : #accessing }
BottomCoordinate >> name [
	^#bottom]

{ #category : #accessing }
BottomCoordinate >> ratioSelector [
	^#bottomRatio]

{ #category : #inquiries }
BottomCoordinate >> referenceSymbol [
	ratio = 0 ifTrue: [^#bottom].
	ratio = 1 ifTrue: [^#top].
	^super referenceSymbol]

{ #category : #private }
BottomCoordinate >> skippingHiddenCopy [
	| reference copy |
	skipHidden ifFalse: [^self].
	reference := self visibleLinkedCoordinate.
	reference == self ifTrue: [^self].
	copy := self shallowCopy
		skipHidden: false;
		pane: reference pane;
		ratio: reference ratio.
	reference pane isNil ifTrue: [copy inset: reference inset].
	^copy]

{ #category : #services }
BottomCoordinate >> tieToOpposite: aTopCoordinate in: aRectangle [
	| offset1 offset2 segment |
	segment := aRectangle top @ aRectangle bottom.
	offset1 := self offsetIn: segment.
	offset2 := aTopCoordinate offsetIn: segment.
	ratio := aTopCoordinate ratio.
	pixels := aTopCoordinate insetInPixels + (offset1 - offset2)]

{ #category : #updating }
BottomCoordinate >> updateFrom: aRectangle to: newRectangle parent: anotherRectangle [
	| reference |
	self isProportional
		ifTrue: [
			reference := self referenceSegmentFrom: anotherRectangle.
			ratio := newRectangle bottom - reference x - self insetInPixels
				/ (reference y - reference x)]
		ifFalse: [
			pixels := self insetInPixels + newRectangle bottom
				- (self relativeTo: anotherRectangle).
			self updateInset]]

