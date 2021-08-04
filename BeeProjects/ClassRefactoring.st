"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #ClassRefactoring}

{#category : '*BeeProjects'}
ClassRefactoring >> mutateMethodsOf: aClass satisfying: aBlock [
	aClass methodDictionary do: [:method | | selector projects |
		selector := method selector.
		projects := BeeModule projectsIncluding: method.
		projects do: [:p | | cm source |
			cm := p compiledMethodFor: selector in: aClass.
			(aBlock evaluateWith: cm) ifTrue: [
				source := self sourceMutating: cm.
				source notNil ifTrue: [
					cm isCurrentVersion
						ifTrue: [p changes compile: source in: aClass]
						ifFalse: [p updateOverriddenMethod: cm withSource: source]]]]]]

