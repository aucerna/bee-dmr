"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIDLLTest,
	#superclass : #TestCase,
	#category : #GDI
}

{ #category : #all }
GDIDLLTest >> testCharABCWidths [
	| hdc first last buffer success |
	self precondition: GDIFont defaultTextFont isTrueType.
	hdc := GDIFont defaultTextFont deviceContext asParameter.
	first := $h.
	last := $i.
	buffer := BufferArray
		externalNew: last asInteger - first asInteger + 1
		of: ABC.
	success := GDIDLL current
		selectObject: GDIFont defaultTextFont handle
		into: GDIFont defaultTextFont deviceContext
		while: [
			GDIDLL current
				GetCharABCWidths: hdc
				uFirstChar: first asParameter
				uLastChar: last asParameter
				lpabc: buffer asParameter].
	self assert: success.
	buffer := buffer makeLocal asArray.
	self
		assert: buffer first bSpacing ~= 0;
		assert: buffer second bSpacing >= 1;
		assert: buffer first total > buffer second total]

{ #category : #all }
GDIDLLTest >> testCharWidth32 [
	| first last buffer success font |
	font := GDIFont defaultTextFont.
	first := $h.
	last := $i.
	buffer := BufferArray
		externalNew: last asInteger - first asInteger + 1
		of: ExternalInt32.
	success := GDIDLL current
		selectObject: font
		into: font deviceContext
		while: [
			GDIDLL current
				getCharWidth32: font deviceContext asParameter
				iFirstChar: first asParameter
				iLastChar: last asParameter
				lpBuffer: buffer asParameter].
	self assert: success.
	buffer := buffer makeLocal asArray.
	self
		assert: buffer first asInteger > buffer second asInteger;
		assert: buffer second asInteger > 0]

{ #category : #all }
GDIDLLTest >> testFontIndexOfAt [
	| string font width widths index dc |
	string := 'hello'.
	font := GDIFont defaultTextFont.
	width := font widthOfString: string.
	widths := OrderedCollection new.
	index := 0.
	dc := VirtualScreen current deviceContext.
	1 to: width do: [:w | | i |
		i := font indexOf: string at: w dc: dc.
		i > index ifTrue: [
			widths add: w.
			index := i]].
	widths add: width + 1.
	string
		with: widths increments
		do: [:char :w | self assert: (font widthOfCharacter: char) = w]]

{ #category : #font }
GDIDLLTest >> testGetTextFace [
	| dc face tfont |
	tfont := GDIFont defaultTextFont.
	dc := tfont deviceContext.
	face := GDIDLL current
		selectObject: tfont handle
		into: dc
		while: [GDIDLL current getTextFace: dc].
	self assert: tfont face = face]

