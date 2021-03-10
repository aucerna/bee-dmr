"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #BlockClosure }

{ #category : '*SUnit' }
BlockClosure >> sunitEnsure: terminationBlock [
	#vmOnly.
	^self ensure: terminationBlock]

{ #category : '*SUnit' }
BlockClosure >> sunitOn: exception do: handlerBlock [
	#vmOnly.
	^self on: exception do: handlerBlock]

{ #category : '*SUnit' }
BlockClosure >> sunitOn: exception1
do: handlerBlock1
on: exception2
do: handlerBlock2 [
	#vmOnly.
	^self sunitOn: exception1 , exception2 do: [:ex | 
		(ex isKindOf: exception1)
			ifTrue: [handlerBlock1 evaluateWith: ex]
			ifFalse: [handlerBlock2 evaluateWith: ex]]]

{ #category : '*SUnit' }
BlockClosure >> sunitOn: exception1
do: handlerBlock1
on: exception2
do: handlerBlock2
on: exception3
do: handlerBlock3 [
	#vmOnly.
	^self sunitOn: exception1 , exception2 , exception3 do: [:exception | 
		(exception isKindOf: exception1)
			ifTrue: [handlerBlock1 evaluateWith: exception]
			ifFalse: [
				(exception isKindOf: exception2)
					ifTrue: [handlerBlock2 evaluateWith: exception]
					ifFalse: [handlerBlock3 evaluateWith: exception]]]]

