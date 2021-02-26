"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HueSaturationLightnessParams,
	#superclass : #MemoryBuffer,
	#category : #GDIPlus
}

{ #category : #'as yet unclassified' }
HueSaturationLightnessParams class >> sizeInBytes [
	^6]

{ #category : #'as yet unclassified' }
HueSaturationLightnessParams >> hueLevel [
	^self shortAtOffset: 0]

{ #category : #'as yet unclassified' }
HueSaturationLightnessParams >> hueLevel: anInteger [
	self shortAtOffset: 0 put: anInteger]

{ #category : #'as yet unclassified' }
HueSaturationLightnessParams >> lightnessLevel [
	^self shortAtOffset: 4]

{ #category : #'as yet unclassified' }
HueSaturationLightnessParams >> lightnessLevel: anInteger [
	self shortAtOffset: 4 put: anInteger]

{ #category : #'as yet unclassified' }
HueSaturationLightnessParams >> saturationLevel [
	^self shortAtOffset: 2]

{ #category : #'as yet unclassified' }
HueSaturationLightnessParams >> saturationLevel: anInteger [
	self shortAtOffset: 2 put: anInteger]

