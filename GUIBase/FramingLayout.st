"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FramingLayout,
	#superclass : #Object,
	#instVars : [
		'left',
		'top',
		'right',
		'bottom',
		'max',
		'screen'
	],
	#category : #GUIbase
}

{ #category : #'instance creation' }
FramingLayout class >> fromBlock: aBlock [
	^self fromRectangle: (aBlock value: (0 @ 0 extent: 0))]

{ #category : #'instance creation' }
FramingLayout class >> fromRectangle: aRectangle [
	^FramingLayout new
		leftRatio: 0 inset: aRectangle left;
		topRatio: 0 inset: aRectangle top;
		rightRatio: 0 inset: aRectangle right;
		bottomRatio: 0 inset: aRectangle bottom]

{ #category : #'instance creation' }
FramingLayout class >> installOn: aWindow [
	| framing |
	framing := aWindow framingLayout.
	aWindow framing: framing.
	^framing]

{ #category : #'instance creation' }
FramingLayout class >> new [
	^super new initialize]

{ #category : #comparing }
FramingLayout >> = aFramingLayout [
	self class == aFramingLayout class ifFalse: [^false].
	(left equals: aFramingLayout left) ifFalse: [^false].
	(top equals: aFramingLayout top) ifFalse: [^false].
	(right equals: aFramingLayout right) ifFalse: [^false].
	(bottom equals: aFramingLayout bottom) ifFalse: [^false].
	max = aFramingLayout maxWidth ifFalse: [^false].
	^true]

{ #category : #converting }
FramingLayout >> asFramingLayout [
	^self]

{ #category : #accessing }
FramingLayout >> bottom [
	^bottom]

{ #category : #query }
FramingLayout >> bottomInset [
	^bottom inset]

{ #category : #accessing }
FramingLayout >> bottomInset: anInteger [
	bottom ratio = 1
		ifTrue: [bottom inset: anInteger negated]
		ifFalse: [bottom inset: anInteger]]

{ #category : #accessing }
FramingLayout >> bottomInsetDU: inset [
	bottom insetDU: inset]

{ #category : #moving }
FramingLayout >> bottomMove: anInteger [
	bottom move: anInteger]

{ #category : #accessing }
FramingLayout >> bottomPane: pane [
	^bottom pane: pane]

{ #category : #query }
FramingLayout >> bottomRatio [
	^bottom ratio]

{ #category : #accessing }
FramingLayout >> bottomRatio: aFraction [
	bottom ratio: aFraction asFraction]

{ #category : #accessing }
FramingLayout >> bottomRatio: aFraction inset: anInteger [
	bottom ratio: aFraction; inset: anInteger]

{ #category : #accessing }
FramingLayout >> bottomRatio: aFraction inset: anInteger linkTo: aChildWindow [
	bottom
		ratio: aFraction;
		inset: anInteger;
		pane: aChildWindow]

{ #category : #accessing }
FramingLayout >> bottomRatio: percentage insetDU: inset [
	bottom ratio: percentage; insetDU: inset]

{ #category : #accessing }
FramingLayout >> bottomRatio: aFraction insetDU: anInteger linkTo: aChildWindow [
	bottom
		ratio: aFraction;
		insetDU: anInteger;
		pane: aChildWindow]

{ #category : #utility }
FramingLayout >> clone [
	^self copy]

{ #category : #copying }
FramingLayout >> copyToGetRectangle: newRect in: containerRect [
	| framer box w h |
	framer := self copy.
	self isCentered ifTrue: [
		w := newRect width / 2.
		h := newRect height / 2.
		^framer
			leftInset: w negated;
			rightInset: w;
			topInset: h negated;
			bottomInset: h].
	box := self relativeTo: containerRect.
	framer left updateFrom: box to: newRect parent: containerRect.
	framer top updateFrom: box to: newRect parent: containerRect.
	framer right updateFrom: box to: newRect parent: containerRect.
	framer bottom updateFrom: box to: newRect parent: containerRect.
	^framer]

{ #category : #comparing }
FramingLayout >> equals: aFramingLayout [
	^self = aFramingLayout]

{ #category : #evaluating }
FramingLayout >> evaluateWith: aRectangle [
	screen isNil ifTrue: [screen := Screen fromPoint: aRectangle center].
	^self relativeTo: aRectangle]

{ #category : #utility }
FramingLayout >> extent [
	^self relativeToScreen extent]

{ #category : #utility }
FramingLayout >> extent: aPoint [
	self width: aPoint x; height: aPoint y]

{ #category : #'measures, framing' }
FramingLayout >> fixedHeight: pixels [
	self bottomRatio: 0; height: pixels]

{ #category : #'measures, framing' }
FramingLayout >> fixedWidth: pixels [
	self rightRatio: 0; width: pixels]

{ #category : #utility }
FramingLayout >> fromLayoutRectangle: aRectangle [
	| c |
	c := aRectangle top.
	(c isFloat and: [c between: 0 and: 1])
		ifTrue: [self topRatio: c]
		ifFalse: [self topRatio: 0 inset: c].
	c := aRectangle left.
	(c isFloat and: [c between: 0 and: 1])
		ifTrue: [self leftRatio: c]
		ifFalse: [self leftRatio: 0 inset: c].
	c := aRectangle bottom.
	(c isFloat and: [c between: 0 and: 1])
		ifTrue: [self bottomRatio: c]
		ifFalse: [self bottomRatio: 0 inset: c].
	c := aRectangle right.
	(c isFloat and: [c between: 0 and: 1])
		ifTrue: [self rightRatio: c]
		ifFalse: [self rightRatio: 0 inset: c]]

{ #category : #testing }
FramingLayout >> hasFixedHeight [
	^top pane == bottom pane and: [top ratio = bottom ratio]]

{ #category : #testing }
FramingLayout >> hasFixedWidth [
	^left pane == right pane and: [left ratio = right ratio]]

{ #category : #testing }
FramingLayout >> hasLinkedPanes [
	^left hasLinkedPanes
		or: [top hasLinkedPanes
			or: [right hasLinkedPanes or: [bottom hasLinkedPanes]]]]

{ #category : #utility }
FramingLayout >> height [
	^self relativeToScreen height]

{ #category : #utility }
FramingLayout >> height: anInteger [
	self isBottomTied
		ifTrue: [
			top
				replaceFrom: bottom;
				inset: top inset + anInteger negated]
		ifFalse: [
			bottom
				replaceFrom: top;
				inset: bottom inset + anInteger]]

{ #category : #'measures, framing' }
FramingLayout >> horizontalFramingFor: aRectangle [
	| s w maxWidth |
	s := (left skippingHiddenCopy valueAt: aRectangle)
		@ (right skippingHiddenCopy valueAt: aRectangle).
	w := s y - s x.
	maxWidth := self maxWidth.
	(maxWidth notNil and: [w > maxWidth]) ifTrue: [
		right hasLinkedPanes
			ifTrue: [s x: s y - maxWidth]
			ifFalse: [s y: s x + maxWidth]].
	^s]

{ #category : #moving }
FramingLayout >> horizontalMove: anInteger [
	self moveLeft: anInteger; moveRight: anInteger]

{ #category : #initialization }
FramingLayout >> initialize [
	super initialize.
	left := LeftCoordinate for: self.
	top := TopCoordinate for: self.
	right := RightCoordinate for: self.
	bottom := BottomCoordinate for: self]

{ #category : #services }
FramingLayout >> inset: numberOrPoint [
	numberOrPoint isNumber
		ifTrue: [
			self
				bottomInset: numberOrPoint;
				topInset: numberOrPoint;
				leftInset: numberOrPoint;
				rightInset: numberOrPoint]
		ifFalse: [
			self
				bottomInset: numberOrPoint y;
				topInset: numberOrPoint y;
				leftInset: numberOrPoint x;
				rightInset: numberOrPoint x]]

{ #category : #testing }
FramingLayout >> isBottomTied [
	^bottom ratio = 1 or: [bottom hasLinkedPanes]]

{ #category : #testing }
FramingLayout >> isCentered [
	^self isHorizontallyCentered and: [self isVerticallyCentered]]

{ #category : #testing }
FramingLayout >> isHorizontallyCentered [
	^self leftRatio = (1 / 2)
		and: [self rightRatio = (1 / 2)]
		and: [self leftInset = self rightInset negated]
		and: [right pane isNil and: [left pane isNil]]]

{ #category : #testing }
FramingLayout >> isLinkedTo: aWindow [
	^(left isLinkedTo: aWindow)
		or: [top isLinkedTo: aWindow]
		or: [right isLinkedTo: aWindow]
		or: [bottom isLinkedTo: aWindow]]

{ #category : #testing }
FramingLayout >> isRightAligned [
	^left isRightAligned and: [right isRightAligned]]

{ #category : #testing }
FramingLayout >> isVerticallyCentered [
	^self topRatio = (1 / 2)
		and: [self bottomRatio = (1 / 2)]
		and: [self topInset = self bottomInset negated]
		and: [top pane isNil and: [bottom pane isNil]]]

{ #category : #services }
FramingLayout >> keep: pane above: otherPane [
	| parent current referent |
	parent := pane parentRectangle.
	current := pane rectangleFromParent: parent.
	referent := otherPane rectangleFromParent: parent.
	^self keepAbove: otherPane separation: (referent top - current bottom) abs]

{ #category : #services }
FramingLayout >> keep: pane below: otherPane [
	| parent current referent |
	parent := pane parentRectangle.
	current := pane rectangleFromParent: parent.
	referent := otherPane rectangleFromParent: parent.
	^self keepBelow: otherPane separation: (current top - referent bottom) abs]

{ #category : #services }
FramingLayout >> keep: pane leftOf: otherPane [
	| parent current referent |
	parent := pane parentRectangle.
	current := pane rectangleFromParent: parent.
	referent := otherPane rectangleFromParent: parent.
	^self
		keepToLeftOf: otherPane
		separation: (referent left - current right) abs]

{ #category : #services }
FramingLayout >> keep: pane rightOf: otherPane [
	| parent current referent |
	parent := pane parentRectangle.
	current := pane rectangleFromParent: parent.
	referent := otherPane rectangleFromParent: parent.
	^self
		keepToRightOf: otherPane
		separation: (referent right - current left) abs]

{ #category : #services }
FramingLayout >> keepAbove: aChildWindow separation: pixels [
	| h |
	h := self height.
	self hasFixedHeight
		ifTrue: [self topRatio: 0 inset: (pixels + h) negated linkTo: aChildWindow].
	self bottomRatio: 0 inset: pixels negated linkTo: aChildWindow]

{ #category : #services }
FramingLayout >> keepBelow: aChildWindow separation: pixels [
	| h |
	h := self height.
	self hasFixedHeight
		ifTrue: [self bottomRatio: 1 inset: pixels + h linkTo: aChildWindow].
	self topRatio: 1 inset: pixels linkTo: aChildWindow]

{ #category : #services }
FramingLayout >> keepToLeftOf: aChildWindow separation: pixels [
	| w |
	w := self width.
	self
		rightRatio: 0 inset: pixels negated linkTo: aChildWindow;
		leftRatio: 0 inset: (pixels + w) negated linkTo: aChildWindow]

{ #category : #services }
FramingLayout >> keepToRightOf: aChildWindow separation: pixels [
	| w |
	w := self width.
	self
		leftRatio: 1 inset: pixels linkTo: aChildWindow;
		rightRatio: 1 inset: pixels + w linkTo: aChildWindow]

{ #category : #accessing }
FramingLayout >> left [
	^left]

{ #category : #query }
FramingLayout >> leftInset [
	^left inset]

{ #category : #accessing }
FramingLayout >> leftInset: anInteger [
	left inset: anInteger]

{ #category : #accessing }
FramingLayout >> leftInsetDU: inset [
	left insetDU: inset]

{ #category : #accessing }
FramingLayout >> leftPane: pane [
	^left pane: pane]

{ #category : #query }
FramingLayout >> leftRatio [
	^left ratio]

{ #category : #accessing }
FramingLayout >> leftRatio: aFraction [
	left ratio: aFraction asFraction]

{ #category : #accessing }
FramingLayout >> leftRatio: aFraction inset: anInteger [
	left ratio: aFraction; inset: anInteger]

{ #category : #accessing }
FramingLayout >> leftRatio: aFraction inset: anInteger linkTo: aChildWindow [
	left
		ratio: aFraction;
		inset: anInteger;
		pane: aChildWindow]

{ #category : #accessing }
FramingLayout >> leftRatio: percentage insetDU: anInteger [
	left ratio: percentage; insetDU: anInteger]

{ #category : #accessing }
FramingLayout >> leftRatio: aFraction insetDU: anInteger linkTo: aChildWindow [
	left
		ratio: aFraction;
		insetDU: anInteger;
		pane: aChildWindow]

{ #category : #services }
FramingLayout >> linkAllIn: aRectangle [
	top link: #top in: aRectangle.
	left link: #left in: aRectangle.
	bottom link: #bottom in: aRectangle.
	right link: #right in: aRectangle]

{ #category : #utility }
FramingLayout >> linkBelow: aChildWindow inset: anInteger [
	self linkBottom: aChildWindow inset: anInteger]

{ #category : #utility }
FramingLayout >> linkBottom: aChildWindow inset: anInteger [
	aChildWindow isNil
		ifTrue: [
			top linkTopTo: nil.
			bottom linkTopTo: nil]
		ifFalse: [
			top linkBottomTo: aChildWindow.
			bottom linkBottomTo: aChildWindow].
	bottom inset: bottom inset - top inset + anInteger.
	top inset: anInteger]

{ #category : #utility }
FramingLayout >> linkBottomTo: aFramingLayout [
	self linkBottom: aFramingLayout inset: 0]

{ #category : #accessing }
FramingLayout >> linkedBottomPane [
	^bottom pane]

{ #category : #accessing }
FramingLayout >> linkedLeftPane [
	^left pane]

{ #category : #accessing }
FramingLayout >> linkedPanes [
	^(Set
		with: left pane
		with: top pane
		with: right pane
		with: bottom pane)
		select: #notNil]

{ #category : #accessing }
FramingLayout >> linkedRightPane [
	^right pane]

{ #category : #accessing }
FramingLayout >> linkedTopPane [
	^top pane]

{ #category : #accessing }
FramingLayout >> linkLeft: aChildWindow inset: anInteger [
	left linkLeftTo: aChildWindow.
	right linkLeftTo: aChildWindow.
	right inset: right inset - left inset + anInteger.
	left inset: anInteger]

{ #category : #services }
FramingLayout >> linkLeftBottomIn: aRectangle [
	top link: #bottom in: aRectangle.
	left link: #left in: aRectangle.
	bottom link: #bottom in: aRectangle.
	right link: #left in: aRectangle]

{ #category : #services }
FramingLayout >> linkLeftBottomRightIn: aRectangle [
	top link: #bottom in: aRectangle.
	left link: #left in: aRectangle.
	bottom link: #bottom in: aRectangle.
	right link: #right in: aRectangle]

{ #category : #accessing }
FramingLayout >> linkLeftTo: aChildWindow [
	self linkLeft: aChildWindow inset: 0]

{ #category : #services }
FramingLayout >> linkLeftTopBottomIn: aRectangle [
	top link: #top in: aRectangle.
	left link: #left in: aRectangle.
	bottom link: #bottom in: aRectangle.
	right link: #left in: aRectangle]

{ #category : #services }
FramingLayout >> linkLeftTopIn: aRectangle [
	top link: #top in: aRectangle.
	left link: #left in: aRectangle.
	bottom link: #top in: aRectangle.
	right link: #left in: aRectangle]

{ #category : #services }
FramingLayout >> linkLeftTopRightIn: aRectangle [
	top link: #top in: aRectangle.
	left link: #left in: aRectangle.
	bottom link: #top in: aRectangle.
	right link: #right in: aRectangle]

{ #category : #services }
FramingLayout >> linkProportionalAllIn: aRectangle [
	top link: #proportional in: aRectangle.
	left link: #proportional in: aRectangle.
	bottom link: #proportional in: aRectangle.
	right link: #proportional in: aRectangle]

{ #category : #services }
FramingLayout >> linkProportionalLeftBottomRighttIn: aRectangle [
	top link: #bottom in: aRectangle.
	left link: #proportional in: aRectangle.
	bottom link: #bottom in: aRectangle.
	right link: #proportional in: aRectangle]

{ #category : #services }
FramingLayout >> linkProportionalLeftTopIn: aRectangle [
	top link: #proportional in: aRectangle.
	left link: #proportional in: aRectangle.
	bottom link: #top in: aRectangle.
	right link: #left in: aRectangle]

{ #category : #services }
FramingLayout >> linkProportionalLeftTopRightIn: aRectangle [
	top link: #top in: aRectangle.
	left link: #proportional in: aRectangle.
	bottom link: #top in: aRectangle.
	right link: #proportional in: aRectangle]

{ #category : #accessing }
FramingLayout >> linkRight: aChildWindow inset: anInteger [
	right linkRightTo: aChildWindow.
	left linkRightTo: aChildWindow.
	left inset: (right inset - left inset) negated + anInteger.
	right inset: anInteger]

{ #category : #services }
FramingLayout >> linkRightBottomIn: aRectangle [
	top link: #bottom in: aRectangle.
	left link: #right in: aRectangle.
	bottom link: #bottom in: aRectangle.
	right link: #right in: aRectangle]

{ #category : #accessing }
FramingLayout >> linkRightTo: aChildWindow [
	self linkRight: aChildWindow inset: 0]

{ #category : #services }
FramingLayout >> linkRightTopBottomIn: aRectangle [
	top link: #top in: aRectangle.
	left link: #right in: aRectangle.
	bottom link: #bottom in: aRectangle.
	right link: #right in: aRectangle]

{ #category : #services }
FramingLayout >> linkRightTopIn: aRectangle [
	top link: #top in: aRectangle.
	left link: #right in: aRectangle.
	bottom link: #top in: aRectangle.
	right link: #right in: aRectangle]

{ #category : #accessing }
FramingLayout >> maxHeight [
	| h |
	^max notNil ifTrue: [
		h := max y.
		h > 0 ifTrue: [h]]]

{ #category : #accessing }
FramingLayout >> maxHeight: anInteger [
	max isNil ifTrue: [max := 0 @ anInteger] ifFalse: [max y: anInteger]]

{ #category : #accessing }
FramingLayout >> maxHeightDU: anInteger [
	self maxHeight: anInteger * VirtualScreen current yDU]

{ #category : #accessing }
FramingLayout >> maxWidth [
	| w |
	^max notNil ifTrue: [
		w := max x.
		w > 0 ifTrue: [w]]]

{ #category : #accessing }
FramingLayout >> maxWidth: anInteger [
	max isNil ifTrue: [max := anInteger @ 0] ifFalse: [max x: anInteger]]

{ #category : #accessing }
FramingLayout >> maxWidthDU: anInteger [
	self maxWidth: anInteger * VirtualScreen current xDU]

{ #category : #moving }
FramingLayout >> moveBottom: anInteger [
	bottom move: anInteger]

{ #category : #moving }
FramingLayout >> moveBy: aPoint [
	self horizontalMove: aPoint x; verticalMove: aPoint y]

{ #category : #services }
FramingLayout >> moveCornerTo: corner in: rectangle [
	right moveTo: corner x in: rectangle.
	bottom moveTo: corner y in: rectangle]

{ #category : #moving }
FramingLayout >> moveDown: anInteger [
	self verticalMove: anInteger]

{ #category : #moving }
FramingLayout >> moveLeft: anInteger [
	left move: anInteger]

{ #category : #services }
FramingLayout >> moveOriginTo: origin in: rectangle [
	| t l b r |
	t := top valueAt: rectangle.
	l := left valueAt: rectangle.
	b := bottom valueAt: rectangle.
	r := right valueAt: rectangle.
	top moveTo: origin y in: rectangle.
	left moveTo: origin x in: rectangle.
	bottom moveTo: origin y + (b - t) in: rectangle.
	right moveTo: origin x + (r - l) in: rectangle]

{ #category : #moving }
FramingLayout >> moveRight: anInteger [
	right move: anInteger]

{ #category : #moving }
FramingLayout >> moveTo: aPoint [
	self horizontalMove: aPoint x - left inset.
	self verticalMove: aPoint y - top inset]

{ #category : #moving }
FramingLayout >> moveTop: anInteger [
	top move: anInteger]

{ #category : #moving }
FramingLayout >> moveUp: anInteger [
	self verticalMove: anInteger negated]

{ #category : #accessing }
FramingLayout >> oppositeTo: aFrameCoordinate [
	aFrameCoordinate == right ifTrue: [^left].
	aFrameCoordinate == bottom ifTrue: [^top].
	^nil]

{ #category : #accessing }
FramingLayout >> owner: aWindow [
	screen := aWindow screen]

{ #category : #accessing }
FramingLayout >> paneFromConnection: aFrameCoordinate [
	| pointLink |
	pointLink := aFrameCoordinate pointConnection.
	pointLink == #left ifTrue: [^left pane].
	pointLink == #top ifTrue: [^top pane].
	pointLink == #right ifTrue: [^right pane].
	pointLink == #bottom ifTrue: [^bottom pane].
	^nil]

{ #category : #copying }
FramingLayout >> postCopy [
	left := left copy.
	top := top copy.
	right := right copy.
	bottom := bottom copy]

{ #category : #printing }
FramingLayout >> printOn: aStream [
	self class printOn: aStream.
	self maxWidth
		ifNotNil: [:m | aStream cr; nextPutAll: '   maxWidth: ' , m asString].
	self maxHeight
		ifNotNil: [:m | aStream cr; nextPutAll: '   maxHeight: ' , m asString].
	aStream cr; nextPutAll: '   '.
	left printOn: aStream.
	aStream cr; nextPutAll: '   '.
	top printOn: aStream.
	aStream cr; nextPutAll: '   '.
	right printOn: aStream.
	aStream cr; nextPutAll: '   '.
	bottom printOn: aStream]

{ #category : #utility }
FramingLayout >> relativeTo: aRectangle [
	| x1 y1 x2 y2 rectangle w |
	x1 := left relativeTo: aRectangle.
	y1 := top relativeTo: aRectangle.
	x2 := (right relativeTo: aRectangle) max: x1.
	y2 := (bottom relativeTo: aRectangle) max: y1.
	rectangle := (x1 @ y1 corner: x2 @ y2) rounded.
	w := self maxWidth.
	(w notNil and: [rectangle width > w]) ifTrue: [
		right hasLinkedPanes
			ifTrue: [rectangle left: rectangle right - w]
			ifFalse: [rectangle width: (w min: rectangle width)]].
	self maxHeight ifNotNil: [:m | rectangle height: (m min: rectangle height)].
	^rectangle]

{ #category : #utility }
FramingLayout >> relativeToScreen [
	^self relativeTo: VirtualScreen current boundingRectangle]

{ #category : #utility }
FramingLayout >> relativeWithoutMaximumTo: aRectangle [
	| x1 y1 x2 y2 |
	x1 := left relativeTo: aRectangle.
	y1 := top relativeTo: aRectangle.
	x2 := right relativeTo: aRectangle.
	y2 := bottom relativeTo: aRectangle.
	^(x1 @ y1 corner: x2 @ y2) rounded]

{ #category : #utility }
FramingLayout >> removePane: aChildWindow [
	left removePane: aChildWindow.
	top removePane: aChildWindow.
	right removePane: aChildWindow.
	bottom removePane: aChildWindow]

{ #category : #utility }
FramingLayout >> replaceFrom: aFramingLayout [
	left replaceFrom: aFramingLayout left.
	top replaceFrom: aFramingLayout top.
	right replaceFrom: aFramingLayout right.
	bottom replaceFrom: aFramingLayout bottom]

{ #category : #utility }
FramingLayout >> replaceLinkedPanes: panesMap [
	left replaceLinkedPanes: panesMap.
	top replaceLinkedPanes: panesMap.
	right replaceLinkedPanes: panesMap.
	bottom replaceLinkedPanes: panesMap]

{ #category : #utility }
FramingLayout >> replacePane: pane with: otherPane [
	left replacePane: pane with: otherPane.
	top replacePane: pane with: otherPane.
	right replacePane: pane with: otherPane.
	bottom replacePane: pane with: otherPane]

{ #category : #accessing }
FramingLayout >> right [
	^right]

{ #category : #query }
FramingLayout >> rightInset [
	^right inset]

{ #category : #accessing }
FramingLayout >> rightInset: anInteger [
	right ratio = 1
		ifTrue: [right inset: anInteger negated]
		ifFalse: [right inset: anInteger]]

{ #category : #accessing }
FramingLayout >> rightInsetDU: inset [
	right insetDU: inset]

{ #category : #accessing }
FramingLayout >> rightPane: pane [
	^right pane: pane]

{ #category : #query }
FramingLayout >> rightRatio [
	^right ratio]

{ #category : #accessing }
FramingLayout >> rightRatio: aFraction [
	right ratio: aFraction asFraction]

{ #category : #accessing }
FramingLayout >> rightRatio: aFraction inset: anInteger [
	right ratio: aFraction; inset: anInteger]

{ #category : #accessing }
FramingLayout >> rightRatio: aFraction inset: anInteger linkTo: aChildWindow [
	right
		ratio: aFraction;
		inset: anInteger;
		pane: aChildWindow]

{ #category : #accessing }
FramingLayout >> rightRatio: percentage insetDU: anInteger [
	right ratio: percentage; insetDU: anInteger]

{ #category : #accessing }
FramingLayout >> rightRatio: aFraction insetDU: anInteger linkTo: aChildWindow [
	right
		ratio: aFraction;
		insetDU: anInteger;
		pane: aChildWindow]

{ #category : #accessing }
FramingLayout >> screen [
	^screen ifNil: [Screen current]]

{ #category : #utility }
FramingLayout >> size: aPoint [
	self width: aPoint x; height: aPoint y]

{ #category : #accessing }
FramingLayout >> skipHidden [
	self skipHidden: true]

{ #category : #accessing }
FramingLayout >> skipHidden: aBoolean [
	left skipHidden: aBoolean.
	top skipHidden: aBoolean.
	right skipHidden: aBoolean.
	bottom skipHidden: aBoolean]

{ #category : #testing }
FramingLayout >> skipsHidden [
	^top skipsHidden]

{ #category : #services }
FramingLayout >> tieBottomOf: pane to: otherPane [
	| parentRectangle current referent |
	parentRectangle := pane parentRectangle.
	current := pane rectangleFromParent: parentRectangle.
	referent := otherPane rectangleFromParent: parentRectangle.
	^self tieBottomTo: otherPane separation: current bottom - referent top]

{ #category : #services }
FramingLayout >> tieBottomTo: aChildWindow separation: pixels [
	self bottomRatio: 0 inset: pixels linkTo: aChildWindow]

{ #category : #services }
FramingLayout >> tieLeftOf: pane to: otherPane [
	| parentRectangle current referent |
	parentRectangle := pane parentRectangle.
	current := pane rectangleFromParent: parentRectangle.
	referent := otherPane rectangleFromParent: parentRectangle.
	^self tieLeftTo: otherPane separation: (current left - referent right) abs]

{ #category : #services }
FramingLayout >> tieLeftTo: aChildWindow separation: pixels [
	self leftRatio: 1 inset: pixels linkTo: aChildWindow]

{ #category : #services }
FramingLayout >> tieRightOf: pane to: otherPane [
	| parentRectangle current referent |
	parentRectangle := pane parentRectangle.
	current := pane rectangleFromParent: parentRectangle.
	referent := otherPane rectangleFromParent: parentRectangle.
	^self
		tieRightTo: otherPane
		separation: (referent left - current right max: 2)]

{ #category : #services }
FramingLayout >> tieRightTo: aChildWindow separation: pixels [
	self rightRatio: 0 inset: pixels negated linkTo: aChildWindow]

{ #category : #services }
FramingLayout >> tieTopOf: pane to: otherPane [
	| parentRectangle current referent |
	parentRectangle := pane parentRectangle.
	current := pane rectangleFromParent: parentRectangle.
	referent := otherPane rectangleFromParent: parentRectangle.
	^self tieTopTo: otherPane separation: (current top - referent bottom) abs]

{ #category : #services }
FramingLayout >> tieTopTo: aPane separation: pixels [
	self topRatio: 1 inset: pixels linkTo: aPane]

{ #category : #services }
FramingLayout >> tieToRightOf: aPane separation: pixels [
	| w |
	self hasFixedWidth ifTrue: [w := self width].
	self leftRatio: 1 inset: pixels linkTo: aPane.
	w notNil ifTrue: [self rightRatio: 1 inset: pixels + w linkTo: aPane]]

{ #category : #accessing }
FramingLayout >> top [
	^top]

{ #category : #query }
FramingLayout >> topInset [
	^top inset]

{ #category : #accessing }
FramingLayout >> topInset: anInteger [
	top inset: anInteger]

{ #category : #accessing }
FramingLayout >> topInsetDU: inset [
	top insetDU: inset]

{ #category : #accessing }
FramingLayout >> topPane: pane [
	^top pane: pane]

{ #category : #query }
FramingLayout >> topRatio [
	^top ratio]

{ #category : #accessing }
FramingLayout >> topRatio: aFraction [
	top ratio: aFraction asFraction]

{ #category : #accessing }
FramingLayout >> topRatio: aFraction inset: anInteger [
	top ratio: aFraction; inset: anInteger]

{ #category : #accessing }
FramingLayout >> topRatio: aFraction inset: anInteger linkTo: aChildWindow [
	top
		ratio: aFraction;
		inset: anInteger;
		pane: aChildWindow]

{ #category : #accessing }
FramingLayout >> topRatio: percentage insetDU: inset [
	top ratio: percentage; insetDU: inset]

{ #category : #accessing }
FramingLayout >> topRatio: aFraction insetDU: anInteger linkTo: aPane [
	^top
		ratio: aFraction;
		insetDU: anInteger;
		pane: aPane]

{ #category : #testing }
FramingLayout >> updateLinkedPanesFrom: aWindow [
	left updateLinkedPanesFrom: aWindow.
	top updateLinkedPanesFrom: aWindow.
	right updateLinkedPanesFrom: aWindow.
	bottom updateLinkedPanesFrom: aWindow]

{ #category : #'measures, framing' }
FramingLayout >> verticalFramingFor: aRectangle [
	^(top skippingHiddenCopy valueAt: aRectangle)
		@ (bottom skippingHiddenCopy valueAt: aRectangle)]

{ #category : #moving }
FramingLayout >> verticalMove: anInteger [
	self moveTop: anInteger; moveBottom: anInteger]

{ #category : #services }
FramingLayout >> verticalRatio: aFraction [
	top ratio: aFraction.
	bottom ratio: aFraction]

{ #category : #utility }
FramingLayout >> width [
	^self relativeToScreen width]

{ #category : #utility }
FramingLayout >> width: anInteger [
	self isRightAligned
		ifTrue: [
			left replaceFrom: right.
			left inset: right inset - anInteger]
		ifFalse: [
			right replaceFrom: left.
			right inset: left inset + anInteger]]

