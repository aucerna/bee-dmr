"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlCdataElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #validation }
HtmlCdataElement >> checkForUnescapedCharacters [
	| str special |
	self parent isComment ifTrue: [^self].
	str := self innerContents.
	special := HtmlUnescapedSpecialCharacterError specialCharacters.
	str withIndexDo: [:ch :i | | error |
		(special includes: ch) ifTrue: [
			ch = $&
				ifFalse: [
					error := HtmlUnescapedSpecialCharacterError new
						position: self start + i.
					self addError: error]
				ifTrue: [
					(str size > i and: [(str at: i + 1) = $#]) ifFalse: [| s |
						s := str readStream position: i; upTo: $;.
						((s includes: $ ) or: [s size > 6] or: [s size < 3]) ifTrue: [
							(s = 'lt' or: [s = 'gt']) ifFalse: [
								error := HtmlUnescapedSpecialCharacterError new
									position: self start + i.
								self addError: error]]]]]]]

{ #category : #testing }
HtmlCdataElement >> isCDATA [
	^true]

