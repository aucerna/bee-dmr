"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassRemoveRule, 
	#superclass : #RefactoringRule, 
	#instVars : [
		'name'
	], 
	#category : #Porting
}

{#category : #accessing}
ClassRemoveRule class >> name: aString [
	^self new name: aString]

{#category : #private}
ClassRemoveRule >> basicApplyTo: aModuleSpec [
	(aModuleSpec definesClassNamed: name) ifTrue: [aModuleSpec
		removeClass: name].
	(aModuleSpec extendsClassNamed: name)
		ifTrue: [aModuleSpec removeExtendedClass: name].
	(aModuleSpec subclassifiesClassNamed: name)
		ifTrue: [aModuleSpec
			removeSubclassesOf: name;
			removeSubclassifiedClass: name].
	aModuleSpec dependencies do: [:dict | 
		dict do: [:refs | 
			refs copy do: [:ref | 
				(ref class == MethodSpec and: [ref referencesIdentifier: name]) ifTrue: [
					ref removeFromClass.
					refs remove: ref].
				ref class == ClassSpec ifTrue: [refs remove: ref]]]].
	aModuleSpec allMethods
		select: [:m | m referencesIdentifier: name]
		thenDo: [:m | m removeFromClass]]

{#category : #accessing}
ClassRemoveRule >> name: aString [
	name := aString]

