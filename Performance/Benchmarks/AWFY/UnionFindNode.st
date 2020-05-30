"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #UnionFindNode,
	#superclass : #Object,
	#instVars : [
		'parent_',
		'bb_',
		'dfsNumber_',
		'loop'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
UnionFindNode class >> new [
 ^ super new initialize 
]

{ #category : #'as yet unclassified' }
UnionFindNode >> bb [
 ^ bb_ 
]

{ #category : #'as yet unclassified' }
UnionFindNode >> dfsNumber [
 ^ dfsNumber_ 
]

{ #category : #'as yet unclassified' }
UnionFindNode >> findSet [

    | nodeList node |
    nodeList := Vector new.
    
    node := self.
    
    [node ~= node parent] whileTrue: [
      ((node parent) ~= (node parent parent)) ifTrue: [
        nodeList append: node ].
      node := node parent ].
  
    nodeList forEach: [:iter | iter union: parent_ ].
    ^ node
]

{ #category : #'as yet unclassified' }
UnionFindNode >> initialize [

    dfsNumber_ := 0.
]

{ #category : #'as yet unclassified' }
UnionFindNode >> initNode: bb dfs: dfsNumber [

    parent_ := self.
    bb_ := bb.
    dfsNumber_ := dfsNumber.
]

{ #category : #'as yet unclassified' }
UnionFindNode >> loop [
 ^ loop 
]

{ #category : #'as yet unclassified' }
UnionFindNode >> loop: aLoop [
 loop := aLoop 
]

{ #category : #'as yet unclassified' }
UnionFindNode >> parent [
 ^ parent_ 
]

{ #category : #'as yet unclassified' }
UnionFindNode >> union: basicBlock [

    parent_ := basicBlock
]

