Class {
	#name : #RichDeviceTaskDataRecord,
	#superclass : #RichObject,
	#instVars : [
		'pending'
	],
	#category : #SMRichards
}

{ #category : #'instance creation' }
RichDeviceTaskDataRecord class >> create [
	^ super basicNew create
]

{ #category : #initialization }
RichDeviceTaskDataRecord >> create [
	pending := RichObject NoWork
]

{ #category : #accessing }
RichDeviceTaskDataRecord >> pending [
	^ pending
]

{ #category : #accessing }
RichDeviceTaskDataRecord >> pending: packet [
	pending := packet
]

