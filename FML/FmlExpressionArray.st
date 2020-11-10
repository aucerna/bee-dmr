"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlExpressionArray,
	#superclass : #Array,
	#type : #variable,
	#category : #FML
}

{ #category : #accessing }
FmlExpressionArray >> at: index [
	^(super at: index) value]

{ #category : #accessing }
FmlExpressionArray >> at: index ifAbsent: aBlock [
	^(super at: index ifAbsent: [^aBlock value]) value]

{ #category : #evaluation }
FmlExpressionArray >> evaluated [
	^self value asFmlValue]

{ #category : #constants }
FmlExpressionArray >> species [
	^Array]

{ #category : #evaluation }
FmlExpressionArray >> value [
	^self collect: [:each | each]]

