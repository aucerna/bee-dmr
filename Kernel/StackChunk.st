"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #StackChunk,
	#superclass : #Object,
	#instVars : [
		'sp',
		'bp',
		'base',
		'prev'
	],
	#category : #Kernel
}

{ #category : #queries }
StackChunk class >> after: aCallbackStackLink [
	^self new prev: aCallbackStackLink
]

{ #category : #accessing }
StackChunk >> base [
	^base
]

{ #category : #accessing }
StackChunk >> base: anInteger [
	base := anInteger
]

{ #category : #accessing }
StackChunk >> bp [
	^bp
]

{ #category : #accessing }
StackChunk >> bp: anInteger [
	(sp <= anInteger and: [anInteger <= base]) ifFalse: [self _halt].
	bp := anInteger
]

{ #category : #initialization }
StackChunk >> callbacksDo: aBlock [
	| chunk |
	chunk := self.
	[chunk isForCallback] whileTrue: [
		aBlock value: chunk.
		chunk := chunk prev]
]

{ #category : #accessing }
StackChunk >> cursor [
	^StackFrameCursor new current: bp previous: sp
]

{ #category : #testing }
StackChunk >> isForCallback [
	^prev notNil
]

{ #category : #accessing }
StackChunk >> prev [
	^prev
]

{ #category : #accessing }
StackChunk >> prev: aCallbackStackLink [
	prev := aCallbackStackLink
]

{ #category : #initialization }
StackChunk >> recordStackPointers [
	"
	Not sent for performance reasons, see _recordStackPointers.
	Unlike the underprimitive version, we subtract 2 slots because
	the current stack has been pushed previous BP and retaddr
	"
	| frame dropped |
	frame := StackFrameCursor top.
	dropped := 1.
	dropped timesRepeat: [frame moveNext].
	sp := frame previous + 8 _asPointer - 8 _asPointer.
	self bp: frame current
]

{ #category : #actions }
StackChunk >> relocate: anInteger [
	sp := sp + anInteger.
	bp := bp + anInteger.
	base := base + anInteger
]

{ #category : #accessing }
StackChunk >> sp [
	^sp
]

{ #category : #accessing }
StackChunk >> sp: anInteger [
	sp := anInteger
]

