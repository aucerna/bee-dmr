"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #RejectMethodRule, 
	#superclass : #Object, 
	#instVars : [
		'scope'
	], 
	#category : #Porting
}

{#category : #accessing}
RejectMethodRule >> scope: aBlock [
	scope := aBlock]

