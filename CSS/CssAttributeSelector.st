"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssAttributeSelector,
	#superclass : #CssSelector,
	#instVars : [
		'attribute',
		'value'
	],
	#category : #CSS
}

{ #category : #'as yet unclassified' }
CssAttributeSelector class >> readFrom: in [
	| out |
	in peek = $[ ifFalse: [self halt].
	in next.
	out := '' writeStream.
	[
		in atEnd not
			and: [in peek isLetter or: [in peek isDigit or: ['-_' includes: in peek]]]]
		whileTrue: [out nextPut: in next].
	in skipSeparators.
	in peek = $]
		ifTrue: [
			in next.
			^CssAttributeExistsSelector new attribute: out contents]
		ifFalse: [| sel val |
			sel := nil.
			in peek = $=
				ifTrue: [sel := CssAttributeEqualsSelector new attribute: out contents]
				ifFalse: [
					(in peek = $~ and: [
						in next.
						in peek = $=])
						ifTrue: [sel := CssAttributeIncludesSelector new
							attribute: out contents]
						ifFalse: [
							(in peek = $| and: [
								in next.
								in peek = $=])
								ifTrue: [sel := CssAttributeBeginsWithSelector new
									attribute: out contents]
								ifFalse: [
									(in peek = $^ and: [
										in next.
										in peek = $=])
										ifTrue: [sel := CssAttributeHasPrefixSelector new
											attribute: out contents]
										ifFalse: [
											(in peek = $$ and: [
												in next.
												in peek = $=])
												ifTrue: [sel := CssAttributeHasSuffixSelector new
													attribute: out contents]
												ifFalse: [
													(in peek = $* and: [
														in next.
														in peek = $=])
														ifTrue: [sel := CssAttributeHasSubstringSelector new
															attribute: out contents]
														ifFalse: [
															in upTo: $].
															^CssInvalidAttributeSelector new attribute: out contents]]]]]].
			in next.
			"Skip ="
		in skipSeparators.
			in peek = $"
				ifTrue: [
					in next.
					val := in upTo: $"]
				ifFalse: [
					in peek = $'
						ifTrue: [
							in next.
							val := in upTo: $']
						ifFalse: [
							out := '' writeStream.
							[in peek isLetter or: [in peek isDigit or: ['-.' includes: in peek]]]
								whileTrue: [out nextPut: in next].
							val := out contents]].
			in next.
			"Consume the last ]"
		^sel value: val]]

{ #category : #comparing }
CssAttributeSelector >> = anObject [
	^anObject class == self class
		and: [anObject attribute = self attribute]
		and: [anObject value = self value]]

{ #category : #accessing }
CssAttributeSelector >> attribute [
	^attribute]

{ #category : #accessing }
CssAttributeSelector >> attribute: aString [
	attribute := aString asLowercase asSymbol]

{ #category : #private }
CssAttributeSelector >> attributeKeyInNode: node [
	^node dtd isXML
		ifTrue: [(node attributes includesKey: attribute) ifTrue: [attribute]]
		ifFalse: [(node attributes includesKey: attribute asLowercase)
			ifTrue: [attribute]]]

{ #category : #private }
CssAttributeSelector >> attributeValueInNode: node [
	| a |
	a := self attributeKeyInNode: node.
	^a notNil ifTrue: [node attributeAt: a]]

{ #category : #comparing }
CssAttributeSelector >> hash [
	^self class hashWith: self attribute with: self value]

{ #category : #testing }
CssAttributeSelector >> isAttributeSelector [
	^true]

{ #category : #accessing }
CssAttributeSelector >> value [
	^value]

{ #category : #accessing }
CssAttributeSelector >> value: anObject [
	value := anObject]

