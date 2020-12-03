"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #PPSequenceParser }

{ #category : '*JavaScript\Tests' }
PPSequenceParser >> jseIsLeftRecursiveProduction: leftParser [

	^ self children first == leftParser]

