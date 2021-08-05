"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #TransliterationScope, 
	#superclass : #Object, 
	#instVars : [
		'module', 
		'class', 
		'method'
	], 
	#category : #Porting
}

{#category : #accessing}
TransliterationScope >> class: aString [
	class := aString]

{#category : #testing}
TransliterationScope >> includesClass: aString [
	^class isNil or: [class = aString]]

{#category : #testing}
TransliterationScope >> includesMethod: aSymbol [
	^method isNil or: [method = aSymbol]]

{#category : #testing}
TransliterationScope >> includesModule: aString [
	^module isNil or: [module = aString]]

{#category : #accessing}
TransliterationScope >> method: aSymbol [
	method := aSymbol]

{#category : #accessing}
TransliterationScope >> module: aString [
	module := aString]

