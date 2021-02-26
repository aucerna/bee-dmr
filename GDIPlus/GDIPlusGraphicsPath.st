"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusGraphicsPath,
	#superclass : #GDIPlusObject,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusGraphicsPath class >> fillMode: mode [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreatePath: mode asParameter
		path: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #private }
GDIPlusGraphicsPath class >> fromIntPoints: points type: typesBuffer fillMode: mode [
	| pointer buffer types status |
	pointer := ExternalPointer new.
	buffer := BufferArray externalOn: points type: POINT.
	types := typesBuffer asByteArray externalCopy.
	status := self dll
		GdipCreatePath2I: buffer asParameter
		types: types asParameter
		count: typesBuffer size asParameter
		fillMode: mode asParameter
		path: pointer asParameter.
	self checkStatus: status.
	buffer free.
	types free.
	^self fromHandle: pointer]

{ #category : #'instance creation' }
GDIPlusGraphicsPath class >> fromPoints: pointsArray type: typesArray [
	^self fromPoints: pointsArray type: typesArray fillMode: FillModeAlternate]

{ #category : #'instance creation' }
GDIPlusGraphicsPath class >> fromPoints: aPointArray type: typeArray fillMode: mode [
	| integers |
	aPointArray size = typeArray size
		ifFalse: [self
			error: '<pointsArray> and <typesArray> do not have the same size'].
	integers := aPointArray
		conform: [:point | point x isInteger and: [point y isInteger]].
	^integers
		ifTrue: [self
			fromIntPoints: aPointArray
			type: typeArray asByteArray
			fillMode: mode]
		ifFalse: [self
			fromRealPoints: aPointArray
			type: typeArray asByteArray
			fillMode: mode]]

{ #category : #private }
GDIPlusGraphicsPath class >> fromRealPoints: points type: typeBuffer fillMode: mode [
	| buffer pointer types status |
	buffer := BufferArray externalOn: points type: PointF.
	pointer := ExternalPointer external.
	types := typeBuffer asByteArray externalCopy.
	status := self dll
		GdipCreatePath2: buffer asParameter
		types: types asParameter
		count: typeBuffer size asParameter
		fillMode: mode asParameter
		path: pointer asParameter.
	self checkStatus: status.
	buffer free.
	types free.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusGraphicsPath class >> new [
	^self fillMode: nil]

{ #category : #operations }
GDIPlusGraphicsPath >> addArc: aRectangle angles: aPoint [
	| start sweep |
	aRectangle isEmpty ifTrue: [^self halt].
	start := ExternalFloat from: aPoint x.
	sweep := ExternalFloat from: aPoint y.
	status := self dll
		GdipAddPathArcI: self asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height
		startAngle: start asParameter
		sweepAngle: sweep asParameter.
	self checkStatus.
	start free.
	sweep free]

{ #category : #operations }
GDIPlusGraphicsPath >> addCircle: radius center: aPoint [
	| rectangle |
	rectangle := Rectangle center: aPoint extent: radius * 2.
	self addEllipse: rectangle]

{ #category : #operations }
GDIPlusGraphicsPath >> addEllipse: aRectangle [
	status := self dll
		GdipAddPathEllipseI: self asParameter
		x: aRectangle left asInteger
		y: aRectangle top asInteger
		width: aRectangle width asInteger
		height: aRectangle height asInteger.
	self checkStatus]

{ #category : #operations }
GDIPlusGraphicsPath >> addLineFrom: startPoint to: endPoint [
	status := self dll
		GdipAddPathLineI: self asParameter
		x1: startPoint x
		y1: startPoint y
		x2: endPoint x
		y2: endPoint y.
	self checkStatus]

{ #category : #operations }
GDIPlusGraphicsPath >> addPolygon: points [
	| buffer |
	buffer := BufferArray externalOn: points type: POINT.
	status := self dll
		GdipAddPathPolygonI: self asParameter
		points: buffer asParameter
		count: points size.
	self checkStatus.
	buffer free]

{ #category : #operations }
GDIPlusGraphicsPath >> addRectangle: aRectangle [
	status := self dll
		GdipAddPathRectangleI: self asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height.
	self checkStatus]

{ #category : #operations }
GDIPlusGraphicsPath >> addRectangles: aCollection [
	| buffer |
	buffer := BufferArray externalOn: aCollection type: RECT.
	status := self dll
		GdipAddPathRectanglesI: self asParameter
		rects: buffer asParameter
		count: aCollection size.
	self checkStatus.
	buffer free]

{ #category : #private }
GDIPlusGraphicsPath >> basicRelease [
	status := self dll GdipDeletePath: self asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusGraphicsPath >> bounds [
	| rectangle |
	rectangle := RectF external.
	status := self dll
		GdipGetPathWorldBoundsI: self asParameter
		bounds: rectangle asParameter
		matrix: nil asParameter
		pen: nil asParameter.
	self checkStatus.
	^rectangle makeLocal asRectangle]

{ #category : #operations }
GDIPlusGraphicsPath >> closeFigure [
	status := self dll GdipClosePathFigure: self asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusGraphicsPath >> fillMode [
	| mode |
	mode := ExternalInt32 external.
	status := self dll GdipGetPathFillMode: self asParameter fillMode: mode.
	self checkStatus.
	^mode makeInteger]

{ #category : #accessing }
GDIPlusGraphicsPath >> fillMode: aFillModeConstant [
	status := self dll
		GdipSetPathFillMode: self asParameter
		fillMode: aFillModeConstant.
	self checkStatus]

{ #category : #accessing }
GDIPlusGraphicsPath >> pointCount [
	| count |
	count := ExternalInt32 external.
	status := self dll GdipGetPointCount: self asParameter count: count.
	self checkStatus.
	^count makeInteger]

