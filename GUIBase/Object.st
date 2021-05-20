"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Object }

{ #category : '*GUIbase' }
Object >> drawAt: aPoint using: aDrawer [
	aDrawer drawString: self printString at: aPoint]

{ #category : '*GUIbase' }
Object >> isBitmap [
	^false]

{ #category : '*GUIbase' }
Object >> isColor [
	^false]

{ #category : '*GUIbase' }
Object >> isImage [
	^false]

