Class {
	#name : #RichIdleTaskDataRecord,
	#superclass : #RichObject,
	#instVars : [
		'#control',
		'#count'
	],
	#category : #SMRichards
}

{ #category : #'instance creation' }
RichIdleTaskDataRecord class >> create [
	^ super basicNew create
]

{ #category : #accessing }
RichIdleTaskDataRecord >> control [
	^ control
]

{ #category : #accessing }
RichIdleTaskDataRecord >> control: aNumber [
	control := aNumber
]

{ #category : #accessing }
RichIdleTaskDataRecord >> count [
	^ count
]

{ #category : #accessing }
RichIdleTaskDataRecord >> count: aCount [
	count := aCount
]

{ #category : #initialize }
RichIdleTaskDataRecord >> create [
    control := 1.
    count := 10000
]

