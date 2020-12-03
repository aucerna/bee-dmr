"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #PPParser }

{ #category : '*JavaScript\Tests' }
PPParser >> jseIsLeftRecursiveProduction [

	^ self children anySatisfy: [ : p | p jseIsLeftRecursiveProduction: self ]]

{ #category : '*JavaScript\Tests' }
PPParser >> jseIsLeftRecursiveProduction: leftParser [

	^ false]

