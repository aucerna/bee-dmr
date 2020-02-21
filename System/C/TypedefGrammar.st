Class {
	#name : #TypedefGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'#struct',
		'#union',
		'#blanks'
	],
	#category : #C
}

{ #category : #accessing }
TypedefGrammar >> arrayField [
	^self plainField token , $[ asParser
		, (self identifier / self number) token
		, ($+ asParser trim , self number) optional
		, $] asParser
		signature: TypedefGrammar -> #arrayField
]

{ #category : #accessing }
TypedefGrammar >> basicType [
	^(self signedness , (#blank asParser plus , self integerType) optional
		/ self integerType
		/ self floatingPointType)
		flatten
		signature: TypedefGrammar -> #basicType
]

{ #category : #accessing }
TypedefGrammar >> bitField [
	^self identifier , blanks , $: asParser , blanks , self number
		signature: TypedefGrammar -> #bitField
]

{ #category : #accessing }
TypedefGrammar >> blanks [
	^#blank asParser star
]

{ #category : #accessing }
TypedefGrammar >> body [
	^#space asParser star , ${ asParser
		, (#space asParser star , self field , #space asParser star , $; asParser) star
		, #space asParser star
		, $} asParser
		signature: TypedefGrammar -> #body
]

{ #category : #accessing }
TypedefGrammar >> decimalNumber [
	^($- asParser optional , #digit asParser plus) flatten
		signature: TypedefGrammar -> #decimalNumber
]

{ #category : #accessing }
TypedefGrammar >> enum [
	^'enum' asParser , #space asParser star , self identifier optional
		, #space asParser star
		, ${ asParser
		, self enumItems
		, #space asParser star
		, $} asParser
		signature: TypedefGrammar -> #enum
]

{ #category : #accessing }
TypedefGrammar >> enumItem [
	^#space asParser star , self identifier , #space asParser star
		, ($= asParser , #space asParser star , self integerNumber) optional
		, #space asParser star
		signature: TypedefGrammar -> #enumItem
]

{ #category : #accessing }
TypedefGrammar >> enumItems [
	^(self enumItem , $, asParser , #space asParser star) star
		, self enumItem optional
		signature: TypedefGrammar -> #enumItems
]

{ #category : #accessing }
TypedefGrammar >> field [
	^self type , blanks , (self arrayField / self bitField / self singleField)
		signature: TypedefGrammar -> #field
]

{ #category : #accessing }
TypedefGrammar >> floatingPointType [
	^'float' asParser / 'double' asParser / 'long double' asParser
		signature: TypedefGrammar -> #floatingPointType
]

{ #category : #accessing }
TypedefGrammar >> floatNumber [
	^(self decimalNumber , $. asParser , #digit asParser plus) flatten
		signature: TypedefGrammar -> #floatNumber
]

{ #category : #accessing }
TypedefGrammar >> hexNumber [
	^($- asParser optional , '0x' asParser , #hex asParser plus) flatten
		signature: TypedefGrammar -> #hexNumber
]

{ #category : #accessing }
TypedefGrammar >> identifier [
	^(#letter asParser , #identifier asParser star) flatten
		signature: TypedefGrammar -> #identifier
]

{ #category : #accessing }
TypedefGrammar >> integerNumber [
	^self hexNumber / self decimalNumber
		signature: TypedefGrammar -> #integerNumber
]

{ #category : #accessing }
TypedefGrammar >> integerType [
	^'char' asParser / 'long long int' asParser / 'long long' asParser
		/ 'long int' asParser
		/ 'long' asParser
		/ 'short int' asParser
		/ 'short' asParser
		/ 'int' asParser
		signature: TypedefGrammar -> #integerType
]

{ #category : #accessing }
TypedefGrammar >> number [
	^self floatNumber / self integerNumber signature: TypedefGrammar -> #number
]

{ #category : #accessing }
TypedefGrammar >> plainField [
	^self identifier / self pointer / blanks
		signature: TypedefGrammar -> #plainField
]

{ #category : #accessing }
TypedefGrammar >> pointer [
	^($* asParser max: 2) flatten , blanks , self identifier
		signature: TypedefGrammar -> #pointer
]

{ #category : #accessing }
TypedefGrammar >> qualifier [
	^'const' asParser / 'volatile' asParser
		signature: TypedefGrammar -> #qualifier
]

{ #category : #accessing }
TypedefGrammar >> signedness [
	^'signed' asParser / 'unsigned' asParser
		signature: TypedefGrammar -> #signedness
]

{ #category : #accessing }
TypedefGrammar >> singleField [
	^self plainField signature: TypedefGrammar -> #singleField
]

{ #category : #accessing }
TypedefGrammar >> start [
	^self statement star , blanks end signature: TypedefGrammar -> #start
]

{ #category : #accessing }
TypedefGrammar >> statement [
	^blanks , (self typedef / self enum / self field) , blanks , $; asParser
		, blanks
		signature: TypedefGrammar -> #statement
]

{ #category : #accessing }
TypedefGrammar >> struct [
	^blanks , 'struct' asParser flatten
		, (#space asParser plus , self identifier) optional
		, blanks
		, self body
		signature: TypedefGrammar -> #struct
]

{ #category : #accessing }
TypedefGrammar >> type [
	^self basicType / struct / union / self typedefType
		signature: TypedefGrammar -> #type
]

{ #category : #accessing }
TypedefGrammar >> typedef [
	^'typedef' asParser , #space asParser plus , self type
		, #space asParser star
		, self identifier
		, self typedefExtra
		signature: TypedefGrammar -> #typedef
]

{ #category : #accessing }
TypedefGrammar >> typedefExtra [
	^(blanks , $, asParser , blanks , (self qualifier / self identifier) star
		, blanks
		, $* asParser star
		, blanks
		, self identifier star)
		star
		token
		signature: TypedefGrammar -> #typedefExtra
]

{ #category : #accessing }
TypedefGrammar >> typedefType [
	^(('struct' asParser / 'union' asParser , blanks) optional , self identifier) token
		signature: TypedefGrammar -> #typedefType
]

{ #category : #accessing }
TypedefGrammar >> union [
	^blanks , 'union' asParser flatten
		, (#space asParser plus , self identifier) optional
		, blanks
		, self body
		signature: TypedefGrammar -> #union
]

