"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #PackageRemoveRule, 
	#superclass : #RefactoringRule, 
	#instVars : [
		'name'
	], 
	#category : #Porting
}

{#category : #accessing}
PackageRemoveRule class >> name: aString [
	^self new name: aString]

{#category : #private}
PackageRemoveRule >> basicApplyTo: aModuleSpec [
	| dict |
	dict := aModuleSpec dependencies at: name ifAbsent: [^self].
	dict do: [:refs | 
		refs do: [:ref | 
			ref class == MethodSpec ifTrue: [aModuleSpec removeMethod: ref].
			ref class == ClassSpec ifTrue: [aModuleSpec removeClass: ref]]].
	aModuleSpec dependencies removeKey: name]

{#category : #accessing}
PackageRemoveRule >> name: aString [
	name := aString]

