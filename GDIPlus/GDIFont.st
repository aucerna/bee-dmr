"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #GDIFont }

{ #category : '*GDIPlus' }
GDIFont >> asGDIPlusFont [
	^[GDIPlusFont fromHDC: Display deviceContext logFont: logical]
		on: Error
		do: [
			[GDIPlusFont fromFamilyName: self face pointSize: size]
				on: Error
				do: [GDIPlusFont fromFamilyName: 'Arial' pointSize: size]]]

