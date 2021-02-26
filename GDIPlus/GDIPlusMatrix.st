"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusMatrix,
	#superclass : #GDIPlusObject,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusMatrix class >> fromArray: anArray [
	^self
		m11: anArray first
		m12: anArray second
		m21: anArray third
		m22: anArray fourth
		dx: (anArray at: 5)
		dy: (anArray at: 6)]

{ #category : #'instance creation' }
GDIPlusMatrix class >> m11: m11
m12: m12
m21: m21
m22: m22
dx: dx
dy: dy [
	| pointer status a11 a12 a21 a22 x y |
	pointer := ExternalPointer external.
	a11 := ExternalFloat from: m11.
	a12 := ExternalFloat from: m12.
	a21 := ExternalFloat from: m21.
	a22 := ExternalFloat from: m22.
	x := ExternalFloat from: dx.
	y := ExternalFloat from: dy.
	status := self dll
		GdipCreateMatrix2: a11 asParameter
		m12: a12 asParameter
		m21: a21 asParameter
		m22: a22 asParameter
		dx: x asParameter
		dy: y asParameter
		matrix: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusMatrix class >> new [
	| pointer status matrix |
	pointer := ExternalPointer external.
	status := self dll GdipCreateMatrix: pointer asParameter.
	self checkStatus: status.
	matrix := self fromHandle: pointer makeLocal.
	matrix requireFinalization.
	^matrix]

{ #category : #'instance creation' }
GDIPlusMatrix class >> rect: aRectangle dstplg: aPoint [
	| pointer status rect point |
	pointer := ExternalPointer external.
	rect := RECT external from: aRectangle.
	point := PointF external from: aPoint.
	status := self dll
		GdipCreateMatrix3: rect asParameter
		dstplg: point asParameter
		matrix: pointer asParameter.
	self checkStatus: status.
	rect free.
	point free.
	^self fromHandle: pointer makeLocal]

{ #category : #private }
GDIPlusMatrix >> basicRelease [
	status := self dll GdipDeleteMatrix: self asParameter.
	self checkStatus]

{ #category : #copying }
GDIPlusMatrix >> clone [
	| pointer |
	pointer := ExternalPointer external.
	status := self dll
		GdipCloneMatrix: self asParameter
		cloneMatrix: pointer asParameter.
	self checkStatus.
	^self class fromHandle: pointer makeLocal]

{ #category : #accessing }
GDIPlusMatrix >> elements [
	| elements |
	elements := BufferArray externalNew: 6 of: ExternalFloat.
	status := self dll
		GdipGetMatrixElements: self asParameter
		matrixOut: elements asParameter.
	self checkStatus.
	^elements makeLocal asArray collect: #asFloat]

{ #category : #accessing }
GDIPlusMatrix >> elements: anArray [
	^self
		elements: anArray first
		m12: anArray second
		m21: anArray third
		m22: anArray fourth
		dx: anArray fifth
		dy: anArray sixth]

{ #category : #accessing }
GDIPlusMatrix >> elements: m11
m12: m12
m21: m21
m22: m22
dx: dx
dy: dy [
	| r11 r12 r21 r22 x y |
	r11 := ExternalFloat from: m11.
	r12 := ExternalFloat from: m12.
	r21 := ExternalFloat from: m21.
	r22 := ExternalFloat from: m22.
	x := ExternalFloat from: dx.
	y := ExternalFloat from: dy.
	status := self dll
		GdipSetMatrixElements: self asParameter
		m11: r11 asParameter
		m12: r12 asParameter
		m21: r21 asParameter
		m22: r22 asParameter
		dx: x asParameter
		dy: y asParameter.
	self checkStatus]

{ #category : #comparing }
GDIPlusMatrix >> equals: aMatrix [
	| result |
	result := ExternalInt32 external.
	status := self dll
		GdipIsMatrixEqual: self asParameter
		matrix2: aMatrix asParameter
		result: result asParameter.
	self checkStatus.
	^result makeLocal asBoolean]

{ #category : #operations }
GDIPlusMatrix >> invert [
	status := self dll GdipInvertMatrix: self asParameter.
	self checkStatus]

{ #category : #testing }
GDIPlusMatrix >> isIdentity [
	| result |
	result := ExternalInt32 external.
	status := self dll
		GdipIsMatrixIdentity: self asParameter
		result: result asParameter.
	self checkStatus.
	^result makeLocal asBoolean]

{ #category : #testing }
GDIPlusMatrix >> isInvertible [
	| result |
	result := ExternalInt32 external.
	status := self dll
		GdipIsMatrixInvertible: self asParameter
		result: result asParameter.
	self checkStatus.
	^result makeLocal asBoolean]

{ #category : #operations }
GDIPlusMatrix >> multiply: aMatrix order: matrixOrder [
	status := self dll
		GdipMultiplyMatrix: self asParameter
		matrix2: aMatrix asParameter
		order: matrixOrder asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusMatrix >> offsetX [
	^self elements fifth]

{ #category : #accessing }
GDIPlusMatrix >> offsetY [
	^self elements sixth]

{ #category : #accessing }
GDIPlusMatrix >> reset [
	self elements: #( 1 0 0 1 0 0 )]

{ #category : #operations }
GDIPlusMatrix >> rotate: angle [
	self rotate: angle order: MatrixOrderPrepend]

{ #category : #accessing }
GDIPlusMatrix >> rotate: angle order: matrixOrder [
	| real |
	real := ExternalFloat from: angle.
	status := self dll
		GdipRotateMatrix: self asParameter
		angle: real asParameter
		order: matrixOrder asParameter.
	self checkStatus]

{ #category : #operations }
GDIPlusMatrix >> rotateAt: angle center: aPoint order: matrixOrder [
	matrixOrder = MatrixOrderPrepend
		ifTrue: [
			self
				translate: aPoint x y: aPoint y order: matrixOrder;
				rotate: angle order: matrixOrder;
				translate: aPoint x negated y: aPoint y negated order: matrixOrder]
		ifFalse: [
			self
				translate: aPoint x negated y: aPoint y negated order: matrixOrder;
				rotate: angle order: matrixOrder;
				translate: aPoint x y: aPoint y order: matrixOrder]]

{ #category : #operations }
GDIPlusMatrix >> scale: aPoint [
	self scale: aPoint x y: aPoint y order: MatrixOrderPrepend]

{ #category : #operations }
GDIPlusMatrix >> scale: sx y: sy order: matrixOrder [
	| x y |
	x := ExternalFloat from: sx.
	y := ExternalFloat from: sy.
	status := self dll
		GdipScaleMatrix: self asParameter
		scaleX: x asParameter
		scaleY: y asParameter
		order: matrixOrder asParameter.
	self checkStatus]

{ #category : #operations }
GDIPlusMatrix >> shear: aPoint [
	self shear: aPoint x y: aPoint y order: MatrixOrderPrepend]

{ #category : #operations }
GDIPlusMatrix >> shear: x y: y order: order [
	| rx ry |
	rx := ExternalFloat from: x.
	ry := ExternalFloat from: y.
	status := self dll
		GdipShearMatrix: self asParameter
		shearX: rx asParameter
		shearY: ry asParameter
		order: order.
	self checkStatus]

{ #category : #operations }
GDIPlusMatrix >> transformPoints: points [
	| buffer |
	buffer := BufferArray externalOn: points type: PointF.
	status := self dll
		GdipTransformMatrixPoints: self asParameter
		pts: buffer asParameter
		count: points size.
	self checkStatus.
	buffer free.
	^points asArray]

{ #category : #operations }
GDIPlusMatrix >> transformVectors: pointsCollection [
	| points |
	points := BufferArray externalOn: pointsCollection type: PointF.
	status := self dll
		GdipVectorTransformMatrixPoints: self asParameter
		pts: points asParameter
		count: pointsCollection size.
	self checkStatus.
	^points makeLocal asArray]

{ #category : #operations }
GDIPlusMatrix >> translate: aPoint [
	self translate: aPoint x y: aPoint y order: MatrixOrderPrepend]

{ #category : #operations }
GDIPlusMatrix >> translate: offsetX y: offsetY order: order [
	| rx ry |
	rx := ExternalFloat from: offsetX.
	ry := ExternalFloat from: offsetY.
	status := self dll
		GdipTranslateMatrix: self asParameter
		offsetX: rx asParameter
		offsetY: ry asParameter
		order: order.
	self checkStatus]

