"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ConversionRule, 
	#superclass : #RefactoringRule, 
	#instVars : [
		'original', 
		'new'
	], 
	#category : #Porting
}

{#category : #'instance creation'}
ConversionRule class >> from: old to: new [
	^self new original: old; new: new]

{#category : #accessing}
ConversionRule >> new [
	^new]

{#category : #accessing}
ConversionRule >> new: aString [
	new := aString]

{#category : #accessing}
ConversionRule >> original [
	^original]

{#category : #accessing}
ConversionRule >> original: anObject [
	original := anObject]

