"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #TransliterationRule, 
	#superclass : #Object, 
	#instVars : [
		'scope'
	], 
	#category : #Porting
}

{#category : #'instance creation'}
TransliterationRule class >> new [
	^super new initialize]

{#category : #testing}
TransliterationRule >> appliesTo: aModuleSpec [
	^scope includesModule: aModuleSpec name]

{#category : #actions}
TransliterationRule >> applyTo: aModuleSpec [
	(self appliesTo: aModuleSpec) ifFalse: [^self].
	self basicApplyTo: aModuleSpec]

{#category : #private}
TransliterationRule >> basicApplyTo: aModuleSpec [
	]

{#category : #accessing}
TransliterationRule >> class: aString [
	scope class: aString]

{#category : #initialization}
TransliterationRule >> initialize [
	scope := TransliterationScope new]

{#category : #accessing}
TransliterationRule >> module: aString [
	scope module: aString]

{#category : #accessing}
TransliterationRule >> scope [
	^scope]

