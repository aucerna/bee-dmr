"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RightCoordinate,
	#superclass : #HorizontalCoordinate,
	#category : #GUIbase
}

{ #category : #testing }
RightCoordinate >> canTieToOpposite [
	^true]

{ #category : #private }
RightCoordinate >> defaultRatio [
	^1]

{ #category : #accessing }
RightCoordinate >> name [
	^#right]

{ #category : #accessing }
RightCoordinate >> ratioSelector [
	^#rightRatio]

{ #category : #services }
RightCoordinate >> tieToOpposite: aLeftCoordinate in: aRectangle [
	| offset1 offset2 segment |
	segment := aRectangle left @ aRectangle right.
	offset1 := self offsetIn: segment.
	offset2 := aLeftCoordinate offsetIn: segment.
	ratio := aLeftCoordinate ratio.
	pixels := aLeftCoordinate insetInPixels + (offset1 - offset2)]

{ #category : #updating }
RightCoordinate >> updateFrom: aRectangle to: newRectangle parent: anotherRectangle [
	| reference |
	self isProportional
		ifTrue: [
			reference := self referenceSegmentFrom: anotherRectangle.
			ratio := newRectangle right - reference x - self insetInPixels
				/ (reference y - reference x)]
		ifFalse: [
			pixels := self insetInPixels + newRectangle right
				- (self relativeTo: anotherRectangle).
			self updateInset]]

