"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #MethodFilterRule, 
	#superclass : #TransliterationRule, 
	#instVars : [
		'block'
	], 
	#category : #Porting
}

{#category : #'instance creation'}
MethodFilterRule class >> on: aClosure [
	^self new block: aClosure]

{#category : #private}
MethodFilterRule >> basicApplyTo: aModuleSpec [
	aModuleSpec allClassesDo: [:c | | candidates |
		(scope includesClass: c name) ifTrue: [
			candidates := c methods & c metaclass methods select: block.
			candidates do: #removeFromClass]]]

{#category : #accessing}
MethodFilterRule >> block: aClosure [
	block := aClosure]

