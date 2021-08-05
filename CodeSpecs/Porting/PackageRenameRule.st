"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #PackageRenameRule, 
	#superclass : #ConversionRule, 
	#category : #Porting
}

{#category : #private}
PackageRenameRule >> basicApplyTo: aModuleSpec [
	| deps references |
	aModuleSpec name = original ifTrue: [aModuleSpec name: new].
	deps := aModuleSpec dependencies.
	references := deps at: original ifAbsent: [^self].
	deps
		removeKey: original;
		at: new put: references]

