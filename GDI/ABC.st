"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ABC,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
ABC class >> def [
	^<def>
	typedef struct _ABC {
		int abcA;  
		UINT abcB;  
		int abcC;  
	} ABC;  
	</def>]

{ #category : #accessing }
ABC class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
ABC >> abcA [
	^self longAtOffset: abcA]

{ #category : #accessing }
ABC >> abcA: anInteger [
	self longAtOffset: abcA put: anInteger]

{ #category : #accessing }
ABC >> abcB [
	^self uLongAtOffset: abcB]

{ #category : #accessing }
ABC >> abcB: anInteger [
	self uLongAtOffset: abcB put: anInteger]

{ #category : #accessing }
ABC >> abcC [
	^self longAtOffset: abcC]

{ #category : #accessing }
ABC >> abcC: anInteger [
	self longAtOffset: abcC put: anInteger]

{ #category : #output }
ABC >> aSpacing [
	^self abcA]

{ #category : #output }
ABC >> bSpacing [
	^self abcB]

{ #category : #output }
ABC >> cSpacing [
	^self abcC]

{ #category : #output }
ABC >> total [
	^self abcA + self abcB + self abcC]

