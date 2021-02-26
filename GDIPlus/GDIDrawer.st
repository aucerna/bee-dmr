"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #GDIDrawer }

{ #category : '*GDIPlus' }
GDIDrawer class >> supportsGradient [
	^true]

{ #category : '*GDIPlus' }
GDIDrawer >> drawRectangleFilled: aRectangle linearGradient: aLinearGradientFillType borderColor: aColor [
	(GDIPlusDrawer onDC: dc handle)
		drawRectangleFilled: aRectangle
		linearGradient: aLinearGradientFillType
		borderColor: aColor]

