Class {
	#name : #Rectangle,
	#superclass : #Object,
	#instVars : [
		'#origin',
		'#corner'
	],
	#category : #Kernel
}

{ #category : #inspecting }
Rectangle class >> aspects [
	^#(#width #height)
]

{ #category : #'instance creation' }
Rectangle class >> leftBottom: leftBottomPoint extent: extentPoint [
	^self new leftBottom: leftBottomPoint extent: extentPoint
]

{ #category : #'instance creation' }
Rectangle class >> leftBottom: leftBottomPoint rightTop: rightTopPoint [
	^self new leftBottom: leftBottomPoint rightTop: rightTopPoint
]

{ #category : #'instance creation' }
Rectangle class >> leftTop: leftTopPoint extent: extentPoint [
	^self new leftTop: leftTopPoint extent: extentPoint
]

{ #category : #'instance creation' }
Rectangle class >> leftTop: leftTopPoint rightBottom: rightBottomPoint [
	^self new leftTop: leftTopPoint rightBottom: rightBottomPoint
]

{ #category : #'instance creation' }
Rectangle class >> origin: originPoint corner: cornerPoint [
	^self new origin: originPoint corner: cornerPoint
]

{ #category : #'instance creation' }
Rectangle class >> origin: originPoint extent: extentPoint [
	^self new origin: originPoint extent: extentPoint
]

{ #category : #'instance creation' }
Rectangle class >> rightBottom: rightBottomPoint extent: extentPoint [
	^self new rightBottom: rightBottomPoint extent: extentPoint
]

{ #category : #comparing }
Rectangle >> = aRectangle [
	^aRectangle isRectangle
]

{ #category : #inquiries }
Rectangle >> area [
	^self height * self width
]

{ #category : #inquiries }
Rectangle >> areasOutside: aRectangle [
	| areas y0 y1 area |
]

{ #category : #converting }
Rectangle >> asRectangle [
	^self
]

{ #category : #accessing }
Rectangle >> bottom [
	^corner y
]

{ #category : #accessing }
Rectangle >> bottom: aNumber [
	corner := corner x @ aNumber
]

{ #category : #inquiries }
Rectangle >> bottomCenter [
	^self center x @ self bottom
]

{ #category : #accessing }
Rectangle >> bottomLeft [
	^self left @ self bottom
]

{ #category : #accessing }
Rectangle >> bottomLeft: aPoint [
	self
]

{ #category : #accessing }
Rectangle >> bottomRight [
	^corner
]

{ #category : #accessing }
Rectangle >> bottomRight: aPoint [
	corner := aPoint
]

{ #category : #accessing }
Rectangle >> center [
	^origin + corner // 2
]

{ #category : #inquiries }
Rectangle >> containsPoint: aPoint [
	^origin <= aPoint and: [aPoint < corner]
]

{ #category : #inquiries }
Rectangle >> containsRect: aRectangle [
	^origin <= aRectangle origin and: [aRectangle corner <= corner]
]

{ #category : #accessing }
Rectangle >> corner [
	^corner
]

{ #category : #accessing }
Rectangle >> corner: aPoint [
	corner := aPoint
]

{ #category : #services }
Rectangle >> corners [
	^{origin. corner. origin x @ corner y. corner x @ origin y}
]

{ #category : #movements }
Rectangle >> down: delta [
	origin := origin down: delta.
]

{ #category : #operations }
Rectangle >> expandBy: delta [
	delta isRectangle
]

{ #category : #accessing }
Rectangle >> extent [
	^self width @ self height
]

{ #category : #accessing }
Rectangle >> extent: aPoint [
	corner := origin + aPoint
]

{ #category : #comparing }
Rectangle >> hash [
	^origin hashWith: corner
]

{ #category : #accessing }
Rectangle >> height [
	^(origin y - corner y) abs
]

{ #category : #accessing }
Rectangle >> height: aNumber [
	corner y: origin y + aNumber
]

{ #category : #operations }
Rectangle >> insetBy: delta [
	| o c |
]

{ #category : #operations }
Rectangle >> intersect: aRectangle [
	| o c |
]

{ #category : #testing }
Rectangle >> intersects: aRectangle [
	^origin < aRectangle rightBottom and: [aRectangle leftTop < corner]
]

{ #category : #testing }
Rectangle >> isRectangle [
	^true
]

{ #category : #accessing }
Rectangle >> left [
	^origin x
]

{ #category : #accessing }
Rectangle >> left: aNumber [
	origin := aNumber @ origin y
]

{ #category : #accessing }
Rectangle >> leftBottom [
	^self left @ self bottom
]

{ #category : #accessing }
Rectangle >> leftBottom: aPoint [
	origin := aPoint x @ self top.
]

{ #category : #accessing }
Rectangle >> leftBottom: point extent: extent [
	origin := point up: extent y.
]

{ #category : #accessing }
Rectangle >> leftBottom: point1 rightTop: point2 [
	origin := point1 x @ point2 y.
]

{ #category : #accessing }
Rectangle >> leftCenter [
	^self left @ self center y
]

{ #category : #accessing }
Rectangle >> leftTop [
	^origin
]

{ #category : #accessing }
Rectangle >> leftTop: aPoint [
	origin := aPoint
]

{ #category : #accessing }
Rectangle >> leftTop: originPoint extent: extent [
	corner := originPoint + extent.
]

{ #category : #accessing }
Rectangle >> leftTop: oPoint rightBottom: cPoint [
	origin := oPoint.
]

{ #category : #operations }
Rectangle >> merge: aRectangle [
	| o c |
]

{ #category : #operations }
Rectangle >> mergeWith: aRectangle [
	origin := origin min: aRectangle origin.
]

{ #category : #accessing }
Rectangle >> moveBy: aPoint [
	origin := origin + aPoint.
]

{ #category : #operations }
Rectangle >> moveTo: aPoint [
	self moveBy: aPoint - origin
]

{ #category : #accessing }
Rectangle >> origin [
	^origin
]

{ #category : #accessing }
Rectangle >> origin: aPoint [
	self topLeft: aPoint
]

{ #category : #accessing }
Rectangle >> origin: originPoint corner: cornerPoint [
	self leftTop: originPoint rightBottom: cornerPoint
]

{ #category : #accessing }
Rectangle >> origin: oPoint extent: ePoint [
	self origin: oPoint corner: oPoint + ePoint
]

{ #category : #printing }
Rectangle >> printOn: aStream [
	origin printOn: aStream.
]

{ #category : #operations }
Rectangle >> relativeTo: aRectangle [
	| extent |
]

{ #category : #accessing }
Rectangle >> right [
	^corner x
]

{ #category : #accessing }
Rectangle >> right: aNumber [
	corner := aNumber @ corner y
]

{ #category : #accessing }
Rectangle >> rightBottom [
	^corner
]

{ #category : #accessing }
Rectangle >> rightBottom: aPoint [
	corner := aPoint
]

{ #category : #accessing }
Rectangle >> rightBottom: point extent: extent [
	origin := (point up: extent y) left: extent x.
]

{ #category : #accessing }
Rectangle >> rightCenter [
	^self right @ self center y
]

{ #category : #accessing }
Rectangle >> rightTop [
	^self right @ self top
]

{ #category : #accessing }
Rectangle >> rightTop: aPoint [
	origin := self left @ aPoint y.
]

{ #category : #accessing }
Rectangle >> round [
	origin := origin rounded.
]

{ #category : #accessing }
Rectangle >> rounded [
	origin := origin rounded.
]

{ #category : #operations }
Rectangle >> scaleBy: delta [
	^origin * delta rightBottom: corner * delta
]

{ #category : #operations }
Rectangle >> scaleTo: aRectangle [
	| scaled |
]

{ #category : #accessing }
Rectangle >> signedHeight [
	^corner y - origin y
]

{ #category : #accessing }
Rectangle >> signedWidth [
	^corner x - origin x
]

{ #category : #accessing }
Rectangle >> top [
	^origin y
]

{ #category : #accessing }
Rectangle >> top: aNumber [
	origin := origin x @ aNumber
]

{ #category : #accessing }
Rectangle >> topCenter [
	^self center x @ self top
]

{ #category : #accessing }
Rectangle >> topLeft [
	^origin
]

{ #category : #accessing }
Rectangle >> topLeft: aPoint [
	origin := aPoint
]

{ #category : #accessing }
Rectangle >> topRight [
	^self right @ self top
]

{ #category : #accessing }
Rectangle >> topRight: aPoint [
	self
]

{ #category : #operations }
Rectangle >> translateBy: delta [
	^origin + delta rightBottom: corner + delta
]

{ #category : #movements }
Rectangle >> translatedBy: delta [
	^origin + delta rightBottom: corner + delta
]

{ #category : #accessing }
Rectangle >> truncate [
	origin := origin truncated.
]

{ #category : #accessing }
Rectangle >> truncated [
	^origin truncated corner: corner truncated
]

{ #category : #accessing }
Rectangle >> width [
	^(corner x - origin x) abs
]

{ #category : #accessing }
Rectangle >> width: anInteger [
	corner x: origin x + anInteger
]
