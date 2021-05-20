"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LeftCoordinate,
	#superclass : #HorizontalCoordinate,
	#category : #GUIbase
}

{ #category : #accessing }
LeftCoordinate >> name [
	^#left]

{ #category : #accessing }
LeftCoordinate >> ratioSelector [
	^#leftRatio]

{ #category : #updating }
LeftCoordinate >> updateFrom: aRectangle to: newRectangle parent: anotherRectangle [
	| reference |
	self isProportional
		ifTrue: [
			reference := self referenceSegmentFrom: anotherRectangle.
			ratio := newRectangle left - reference x - self insetInPixels
				/ (reference y - reference x)]
		ifFalse: [
			pixels := self insetInPixels + newRectangle left
				- (self relativeTo: anotherRectangle).
			self updateInset]]

