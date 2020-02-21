Class {
	#name : #BGBinaryTrees,
	#superclass : #Object,
	#instVars : [
		'#left',
		'#right',
		'#item',
		'#btFactory'
	],
	#category : #Game
}

{ #category : #defaults }
BGBinaryTrees class >> defaultProblemSize [
	^ 9
]

{ #category : #defaults }
BGBinaryTrees class >> new [
	^self basicNew initialize
]

{ #category : #benchmarking }
BGBinaryTrees >> binarytrees: n to: output [
   | minDepth maxDepth stretchDepth check longLivedTree iterations |
   minDepth := 4.
   maxDepth := minDepth + 2 max: n.
   stretchDepth := maxDepth + 1.

   check := (btFactory bottomUpTree: 0 depth: stretchDepth) itemCheck.
   output
      nextPutAll: 'stretch tree of depth '; print: stretchDepth; tab;
      nextPutAll: ' check: '; print: check; cr.

   longLivedTree := btFactory bottomUpTree: 0 depth: maxDepth
.
	self buildTreesFrom: minDepth to: maxDepth reportTo: output.   

	check := longLivedTree itemCheck.

   output
      nextPutAll: 'long lived tree of depth '; print: maxDepth; tab;
      nextPutAll: ' check: '; print: check; cr.
	
	^ check.
]

{ #category : #benchmarking }
BGBinaryTrees >> buildTreesFrom: minDepth to: maxDepth reportTo: output [
	| iterations check |
   minDepth to: maxDepth by: 2 do: [:depth|
      iterations := 1 bitShift: maxDepth - depth + minDepth.

      check := 0.
      1 to: iterations do: [:i|
         check := check + (btFactory bottomUpTree: i depth: depth) itemCheck.
         check := check + (btFactory bottomUpTree: -1*i depth: depth) itemCheck
         ].
      output
         print:  (2*iterations); tab;
         nextPutAll: ' trees of depth '; print: depth; tab;
         nextPutAll: ' check: '; print: check; cr
      ].
]

{ #category : #initialization }
BGBinaryTrees >> initialize [
	"Set the default binaryTree class used for the benchmark"
	btFactory := BGTreeFactory new.
]

