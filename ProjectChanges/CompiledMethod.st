"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #CompiledMethod }

{ #category : '*ProjectChanges' }
CompiledMethod >> asChange [
	| change |
	change := [
		self sourceReference changeLink
			ifNotNil: [:position | self project changes changeAt: position]]
		on: Error
		do: [].
	^(change notNil and: [change signature = self signature])
		ifTrue: [change]
		ifFalse: [MethodDefinition fromCompiledMethod: self]]

{ #category : '*ProjectChanges' }
CompiledMethod >> asChangeIn: aBeeProject [
	^MethodDefinition fromCompiledMethod: self in: aBeeProject]

{ #category : '*ProjectChanges' }
CompiledMethod >> changesSomething [
	^self currentVersion ~~ self]

{ #category : '*ProjectChanges' }
CompiledMethod >> fileOutOn: aStream [
	self asChange fileOutOn: aStream]

{ #category : '*ProjectChanges' }
CompiledMethod >> isModified [
	^self imageSegment isNil and: [
		self projects
			anySatisfy: [:prj | prj changes
				wasModifiedSelector: self selector
				in: self classBinding]]]

{ #category : '*ProjectChanges' }
CompiledMethod >> refersTo [
	^{MethodDefinition. self project name. class name. selector}]

