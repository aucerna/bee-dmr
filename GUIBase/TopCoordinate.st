"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TopCoordinate,
	#superclass : #VerticalCoordinate,
	#category : #GUIbase
}

{ #category : #accessing }
TopCoordinate >> name [
	^#top]

{ #category : #accessing }
TopCoordinate >> ratioSelector [
	^#topRatio]

{ #category : #updating }
TopCoordinate >> updateFrom: aRectangle to: newRectangle parent: anotherRectangle [
	| reference |
	self isProportional
		ifTrue: [
			reference := self referenceSegmentFrom: anotherRectangle.
			ratio := newRectangle top - reference x - self insetInPixels
				/ (reference y - reference x)]
		ifFalse: [
			pixels := self insetInPixels + newRectangle top
				- (self relativeTo: anotherRectangle).
			self updateInset]]

