"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #String }

{ #category : '*JavaScript' }
String >> jseTokenParser [
	^PPPredicateObjectParser
		on: [:token | 
			token literalValue = self
				andNot: [JSESyntacticParser literalTokenTypes includes: token type]]
		message: self printString , ' expected']

