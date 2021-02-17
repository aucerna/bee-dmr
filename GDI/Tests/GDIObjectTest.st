"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIObjectTest,
	#superclass : #TestCase,
	#category : #GDI
}

{ #category : #all }
GDIObjectTest >> test3398 [
	| brush |
	self
		assert: (GDILogicalObject >> #finalize) notNil
		description: 'GDILogicalObject must implement #finalize'.
	brush := GDIBrush withStyle: nil color: (RGBColor
		red: 55
		green: 66
		blue: 77).
	self
		assert: brush requiresFinalization
		description: 'GDILogicalObject need finalization'.
	self
		assert: brush handle notNil
		description: 'GDILogicalObject must have a proper handle'.
	brush finalize.
	self
		assert: (brush instVarNamed: 'handle') isNil
		description: 'Finalized GDILogicalObject must not have handle']

