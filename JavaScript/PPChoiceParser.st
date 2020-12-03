"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #PPChoiceParser }

{ #category : '*JavaScript' }
PPChoiceParser >> jseIsLeftRecursiveProduction: leftParser [

	^ self children anySatisfy: [ : p | p jseIsLeftRecursiveProduction: leftParser ]]

