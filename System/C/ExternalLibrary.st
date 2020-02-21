Extension { #name : #ExternalLibrary }

{ #category : '*C' }
ExternalLibrary class >> generate [
	| code |
	code := self parseHeadersUsing: CTranslationUnit windows.
	code statements do: [:statement | statement generate: self]
]

{ #category : '*C' }
ExternalLibrary class >> headers [
	^<C></C>
]

{ #category : '*C' }
ExternalLibrary class >> parseHeadersUsing: aCTranslationUnit [
	(self respondsTo: #headers) ifFalse: [
		self
			error: 'cannot generate ' , self name
				, ' because I don''t have any headers to parse'].
	aCTranslationUnit addTypedefsFrom: self typedefTable.
	^TypedefParser parse: self headers using: aCTranslationUnit
]

{ #category : '*C' }
ExternalLibrary class >> typedefTable [
	^#()
]

