"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #BGTreeNode,
	#superclass : #Object,
	#instVars : [
		'left',
		'right',
		'item'
	],
	#category : #Game
}

{ #category : #accessing }
BGTreeNode >> itemCheck [
   ^left isNil 
      ifTrue: [item] ifFalse: [item + (left itemCheck - right itemCheck)]
]

{ #category : #'initialize-release' }
BGTreeNode >> left: leftChild right: rightChild item: anItem [
   left := leftChild.
   right := rightChild.
   item := anItem
]

