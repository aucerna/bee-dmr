Extension { #name : #MemoryBuffer }

{ #category : '*C' }
MemoryBuffer class >> addDeclarationsTo: aCTranslationUnit [
	aCTranslationUnit addTypedefsFrom: self typedefTable
]

{ #category : '*C' }
MemoryBuffer class >> configureCompiler: aCompiler [
	aCompiler optionAt: #classBinding put: self
]

{ #category : '*C' }
MemoryBuffer class >> hasArbitraryAlignment [
	^(self class >> #alignment) notNil
]

{ #category : '*C' }
MemoryBuffer class >> typedef [
	| typedef |
	typedef := self typedefUsing: CTranslationUnit windows.
	typedef registerConflicts.
	^typedef
]

{ #category : '*C' }
MemoryBuffer class >> typedef64 [
	| typedef |
	typedef := self typedefUsing: CTranslationUnit windows64.
	typedef registerConflicts.
	^typedef
]

{ #category : '*C' }
MemoryBuffer class >> typedefTable [
	^#()
]

{ #category : '*C' }
MemoryBuffer class >> typedefUsing: aCTranslationUnit [
	| def |
	(self respondsTo: #def) ifFalse: [
		self halt
			error: 'cannot parse ' , self name
				, ' because I don''t have the definition'].
	self addDeclarationsTo: aCTranslationUnit.
	def := self def.
	def = '' ifTrue: [^aCTranslationUnit addUnresolved: self name].
	^TypedefParser parseTypedef: def using: aCTranslationUnit
]

