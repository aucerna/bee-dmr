"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #ReadStream }

{ #category : '*ProjectChanges' }
ReadStream >> nextSqueakChunk [
	| chunk read write prevChar inComment inString c |
	chunk := self nextChunk.
	(chunk indexOf: $_) = 0 ifTrue: [^chunk].
	read := chunk readStream.
	write := (String new: chunk size + 20) writeStream.
	prevChar := nil.
	inString := inComment := false.
	[read atEnd] whileFalse: [
		c := read next.
		c = $_ & (prevChar ~= $$) & inString not & inComment not
			ifTrue: [write nextPutAll: ':=']
			ifFalse: [write nextPut: c].
		c = $" ifTrue: [
			inComment
				ifTrue: [inComment := false]
				ifFalse: [inString not & (prevChar ~= $$) ifTrue: [inComment := true]]].
		c = $' ifTrue: [
			inString
				ifTrue: [inString := false]
				ifFalse: [inComment not & (prevChar ~= $$) ifTrue: [inString := true]]].
		prevChar := c].
	^write contents]

