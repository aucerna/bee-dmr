"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Drawer }

{ #category : '*GDIPlus' }
Drawer class >> defaultSelectionGradient [
	| darker |
	darker := Color focusedSelectionBackground.
	^LinearGradientFillType new
		startColor: ((darker blendWith: Color paleGray) changeLuminanceBy: 0.1);
		endColor: darker;
		style: #vertical]

{ #category : '*GDIPlus' }
Drawer class >> gradientBorderColor [
	^Color highlight blendWith: Color gray]

