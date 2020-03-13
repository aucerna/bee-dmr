"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #TypedefParserTest,
	#superclass : #TestCase,
	#category : #C
}

{ #category : #asserting }
TypedefParserTest >> parse: definition [
	^self parse32: definition
]

{ #category : #asserting }
TypedefParserTest >> parse32: definition [
	| struct |
	struct := TypedefParser
		parseTypedef: definition
		using: CTranslationUnit windows32.
	self deny: struct isPetitFailure.
	^struct
]

{ #category : #asserting }
TypedefParserTest >> parse64: definition [
	| struct |
	struct := TypedefParser
		parseTypedef: definition
		using: CTranslationUnit windows64.
	self deny: struct isPetitFailure.
	^struct
]

{ #category : #asserting }
TypedefParserTest >> parseStatements32: definition [
	| statements |
	statements := TypedefParser
		parse: definition
		using: CTranslationUnit windows32.
	self deny: statements isPetitFailure.
	^statements
]

{ #category : #asserting }
TypedefParserTest >> test05ParseSimpleVariable [
	| statements a |
	statements := self parseStatements32: 'int a;'.
	a := statements first.
	self
		assert: a name = 'a';
		assert: a sizeInBytes = 4;
		assert: a alignment = 4
]

{ #category : #asserting }
TypedefParserTest >> test07ParseSimpleEnum [
	| statements enum |
	statements := self parseStatements32: '
enum stuff {
	foo,
	bar,
};'.
	enum := statements first.
	self
		assert: enum name = 'stuff';
		assert: enum keys asArray = #('foo' 'bar');
		assert: (enum at: 'foo') = 0;
		assert: (enum at: 'bar') = 1;
		assert: enum sizeInBytes = 4;
		assert: enum naturalAlignment = 4
]

{ #category : #asserting }
TypedefParserTest >> test08ParseComplexEnum [
	| statements enum |
	statements := self
		parseStatements32: '
enum foo {
	A = 1,
	B = 0,
	C,
	D = -0,
	E = -1,
	F,
	G=0x20,
	H=-0x20,
};'.
	enum := statements first.
	self
		assert: enum name = 'foo';
		assert: enum keys asArray = #('A' 'B' 'C' 'D' 'E' 'F' 'G' 'H');
		assert: (enum at: 'A') = 1;
		assert: (enum at: 'B') = 0;
		assert: (enum at: 'C') = 1;
		assert: (enum at: 'D') = 0;
		assert: (enum at: 'E') = -1;
		assert: (enum at: 'F') = 0;
		assert: (enum at: 'G') = 0x20;
		assert: (enum at: 'H') = -0x20;
		assert: enum sizeInBytes = 4;
		assert: enum naturalAlignment = 4
]

{ #category : #asserting }
TypedefParserTest >> test10ParseSimpleStruct [
	| statements struct a |
	statements := self parseStatements32: '
struct s_t {
	int a;
} s;'.
	struct := statements first type.
	a := struct loadFields fields first.
	self
		assert: a name = 'a';
		assert: a offset = 0;
		assert: a sizeInBytes = 4;
		assert: a alignment = 4;
		assert: struct sizeInBytes = 4
]

{ #category : #asserting }
TypedefParserTest >> test12ParseSimpleTypedef [
	| struct a |
	struct := self parse: '
typedef struct t {
	int a;
} t;'.
	a := struct fields first.
	self
		assert: a name = 'a';
		assert: a offset = 0;
		assert: a sizeInBytes = 4;
		assert: a alignment = 4;
		assert: struct sizeInBytes = 4
]

{ #category : #asserting }
TypedefParserTest >> test15ParseStructBasicTypes [
	| struct a b c d |
	struct := self
		parse: '
typedef struct t {
	unsigned int a;
	unsigned short b;
	unsigned long long c;
  	signed int d;
 } t;'.
	a := struct fields first.
	b := struct fields second.
	c := struct fields third.
	d := struct fields fourth.
	self
		assert: a name = 'a';
		assert: a offset = 0;
		assert: a sizeInBytes = 4;
		assert: a alignment = 4;
		assert: b name = 'b';
		assert: b offset = 4;
		assert: b sizeInBytes = 2;
		assert: b alignment = 2;
		assert: c name = 'c';
		assert: c offset = 8;
		assert: c sizeInBytes = 8;
		assert: c alignment = 8;
		assert: d name = 'd';
		assert: d offset = 16;
		assert: d sizeInBytes = 4;
		assert: d alignment = 4;
		assert: struct sizeInBytes = 24
]

{ #category : #asserting }
TypedefParserTest >> test20ParsePaddedStruct [
	| struct a b |
	struct := self parse: '
typedef struct t {
	char a;
	int b;
} t;'.
	a := struct fields first.
	b := struct fields second.
	self
		assert: a name = 'a';
		assert: a offset = 0;
		assert: a sizeInBytes = 1;
		assert: a alignment = 1;
		assert: b name = 'b';
		assert: b offset = 4;
		assert: b sizeInBytes = 4;
		assert: b alignment = 4;
		assert: struct sizeInBytes = 8
]

{ #category : #asserting }
TypedefParserTest >> test25ParseStructWithBitFields [
	| struct a b c d e |
	struct := self
		parse: '
typedef struct t {
	char a;
	int b: 3;
	int c: 2;
	int d;
	int e: 14;
} t;'.
	a := struct fields first.
	b := struct fields second.
	c := struct fields third.
	d := struct fields fourth.
	e := struct fields fifth.
	self
		assert: a name = 'a';
		assert: a offset = 0;
		assert: a sizeInBytes = 1;
		assert: a alignment = 1;
		assert: b name = 'b';
		assert: b offset = 1;
		assert: b sizeInBytes = (3 / 8);
		assert: c name = 'c';
		assert: c offset = (1 + (3 / 8));
		assert: c sizeInBytes = (2 / 8);
		assert: d name = 'd';
		assert: d offset = 4;
		assert: d sizeInBytes = 4;
		assert: d alignment = 4;
		assert: e name = 'e';
		assert: e offset = 8;
		assert: e sizeInBytes = (14 / 8);
		assert: struct sizeInBytes = 12
]

{ #category : #asserting }
TypedefParserTest >> test30ParseStructWithPointers32 [
	| struct a |
	struct := self parse32: '
typedef struct t {
	char *a;
} t;'.
	a := struct fields first.
	self
		assert: a name = 'a';
		assert: a offset = 0;
		assert: a sizeInBytes = 4;
		assert: a alignment = 4;
		assert: struct sizeInBytes = 4
]

{ #category : #asserting }
TypedefParserTest >> test31ParseStructWithPointers64 [
	| struct a |
	struct := self parse64: '
typedef struct t {
	char *a;
} t;'.
	a := struct fields first.
	self
		assert: a name = 'a';
		assert: a offset = 0;
		assert: a sizeInBytes = 8;
		assert: a alignment = 8;
		assert: struct sizeInBytes = 8
]

{ #category : #asserting }
TypedefParserTest >> test40ParseStructWithNestedStruct [
	| struct b |
	struct := self parse32: '
typedef struct t {
	char a;
	POINT b;
} t;'.
	b := struct fields second.
	self
		assert: b name = 'b';
		assert: b offset = 4;
		assert: b sizeInBytes = 8;
		assert: b alignment = 4;
		assert: struct sizeInBytes = 12
]

{ #category : #asserting }
TypedefParserTest >> test41ParseStructWithNestedUnnamedStruct [
	| struct b |
	struct := self
		parse32: '
typedef struct t {
	char a;
	struct {
		int x;
		int y;
	} b;
} t;'.
	b := struct fields second.
	self
		assert: b name = 'b';
		assert: b offset = 4;
		assert: b sizeInBytes = 8;
		assert: b alignment = 4;
		assert: struct sizeInBytes = 12
]

{ #category : #asserting }
TypedefParserTest >> test42ParseStructWithNestedNamedStruct [
	| struct b |
	struct := self
		parse32: '
typedef struct t {
	char a;
	struct foo{
		int x;
		int y;
	} b;
} t;'.
	b := struct fields second.
	self
		assert: b name = 'b';
		assert: b offset = 4;
		assert: b sizeInBytes = 8;
		assert: b alignment = 4;
		assert: struct sizeInBytes = 12
]

{ #category : #asserting }
TypedefParserTest >> test43ParseStructWithNestedUnnamedStruct [
	| struct bar |
	struct := self
		parse32: '
	typedef struct foo {
		union {
			ushort a;
			uint b;
		} bar;
	} foo;'.
	bar := struct fields first.
	self
		assert: bar name = 'bar';
		assert: bar offset = 0;
		assert: bar sizeInBytes = 4;
		assert: bar alignment = 4;
		assert: struct sizeInBytes = 4
]

{ #category : #asserting }
TypedefParserTest >> test50ParseStructWithArray [
	| struct a b |
	struct := self parse32: '
typedef struct t {
	char a[10];
	int b;
} t;'.
	a := struct fields first.
	b := struct fields second.
	self
		assert: a name = 'a';
		assert: a offset = 0;
		assert: a sizeInBytes = 10;
		assert: a alignment = 1;
		assert: b name = 'b';
		assert: b offset = 12;
		assert: b sizeInBytes = 4;
		assert: b alignment = 4;
		assert: struct sizeInBytes = 16
]

{ #category : #asserting }
TypedefParserTest >> test55ParseStructWithArrayExpression [
	| struct rgstate cchildren_scrollbar |
	struct := self parse32: SCROLLBARINFO def.
	rgstate := struct fields at: 7.
	cchildren_scrollbar := 5.
	self
		assert: rgstate name = 'rgstate';
		assert: rgstate offset = 36;
		assert: rgstate sizeInBytes = (cchildren_scrollbar + 1 * 4);
		assert: rgstate alignment = 4;
		assert: struct sizeInBytes = (rgstate offset + rgstate sizeInBytes)
]

{ #category : #asserting }
TypedefParserTest >> test60ParseStructWithCustomAlignment [
	| struct bfSize |
	struct := BITMAPFILEHEADER typedef.
	bfSize := struct fields second.
	self
		assert: struct alignment = 2;
		assert: bfSize name = 'bfSize';
		assert: bfSize offset = 2;
		assert: bfSize sizeInBytes = 4;
		assert: bfSize alignment = 2;
		assert: struct sizeInBytes = 14
]

{ #category : #asserting }
TypedefParserTest >> test70ParseManyStatements [
	| u16 u32 u64 list |
	list := self
		parseStatements32: '
		typedef ushort __u16;
		typedef uint __u32;
		typedef ularge __u64;
'.
	self assert: list statements size = 3.
	u16 := list statements first.
	u32 := list statements second.
	u64 := list statements third.
	self
		assert: u16 printString = 'typedef ushort __u16;';
		assert: u32 printString = 'typedef uint __u32;';
		assert: u64 printString = 'typedef ularge __u64;'
]

{ #category : #asserting }
TypedefParserTest >> testAllDefs [
	| exceptions count |
	exceptions := #(#CONFIG #VARIANT #VARIANTARG #VENDORCODE #KNOWNFOLDERID #IID #CLSID #FOLDERTYPEID).
	count := 0.
	WindowsStructure allSubclasses
		select: [:c | | def |
			(exceptions includes: c symbol) not and: [
				def := c class >> #def.
				def size >= 1
					and: [def
						anySatisfy: [:s | s isString and: [s trimBlanks beginsWith: 'typedef']]]]]
		thenDo: [:c | 
			c typedef.
			count := count + 1]
]

{ #category : #asserting }
TypedefParserTest >> testAllResolved [
	| exceptions |
	exceptions := {BitmapHeaderStructure. CONFIG. VARIANT. VARIANTARG.
		VENDORCODE. KNOWNFOLDERID. IID. CLSID. FOLDERTYPEID. FLEX_VERSION.
		LM_BORROW_STAT. LM_VENDORCODE_PUBKEYINFO}.
	WindowsStructure allSubclasses
		select: [:c | (exceptions includes: c) not andNot: [(c class >> #def) isNil]]
		thenDo: [:c | self
			deny: (c typedef asText asString includesString: 'UNRESOLVED')]
]

{ #category : #asserting }
TypedefParserTest >> testDynamicMultiplier [
	| exceptions wrong |
	exceptions := #(#CONFIG #VENDORCODE #VARIANT #VARIANTARG #DATE_STRUCT #LARGE_INTEGER).
	wrong := OrderedCollection new.
	WindowsStructure allSubclasses
		select: [:c | | def |
			(exceptions includes: c symbol) not and: [
				def := c class >> #def.
				def size = 1 and: [def anyone trimBlanks beginsWith: 'typedef']]]
		thenDo: [:c | | typedef |
			typedef := c typedef.
			typedef refersToStruct ifTrue: [
				typedef allFieldNamesDo: [:f :fullname | | getter setter |
					getter := f getterSourceNamed: fullname.
					setter := f setterSourceNamed: fullname]]].
	self assert: wrong isEmpty
]

{ #category : #asserting }
TypedefParserTest >> testEnum [
	| statements enum |
	statements := self parseStatements32: '
enum stuff {
	foo,
};'.
	enum := statements first.
	self
		assert: enum name = 'stuff';
		assert: enum keys asArray = #('foo');
		assert: (enum at: 'foo') = 0;
		assert: enum sizeInBytes = 4;
		assert: enum naturalAlignment = 4
]

{ #category : #asserting }
TypedefParserTest >> testNonStruct [
	| struct |
	struct := self
		parse32: 'typedef union tagBINDPTR {
			FUNCDESC *lpfuncdesc;
		} BINDPTR;'.
	self deny: struct isPetitFailure
]

{ #category : #asserting }
TypedefParserTest >> testOffsets [
	| exceptions wrong |
	exceptions := #(#CONFIG #VENDORCODE #VARIANT #VARIANTARG #DATE_STRUCT #SOCKADDR CERT_NAME_BLOB CRYPT_INTEGER_BLOB CRYPT_OBJID_BLOB MENUBARINFO).
	wrong := OrderedCollection new.
	WindowsStructure allSubclasses
		select: [:c | | def |
			(exceptions includes: c symbol) not and: [
				def := c class >> #def.
				def size = 1 and: [def anyone trimBlanks beginsWith: 'typedef']]]
		thenDo: [:c | | new current |
			new := PoolDictionary new.
			c typedef writeOffsetsOn: new.
			new = c offsets ifFalse: [
				wrong add: c.
				new := new associations sortBy: #value.
				current := c offsets associations sortBy: #value.
				current halt]].
	self assert: wrong isEmpty
]

{ #category : #asserting }
TypedefParserTest >> testPointerPointer [
	| struct |
	struct := self
		parse32: '
typedef struct t {
	union {
		union {
			WORD **s;
		};
	};
} T;'.
	self deny: struct isPetitFailure
]

{ #category : #asserting }
TypedefParserTest >> testTP53796 [
	| ast |
	ast := TypedefParser
		parse: '
    typedef union _LARGE_INTEGER {
            struct  {
                DWORD LowPart;
            } u ;
        } LARGE_INTEGER ;'
		using: CTranslationUnit windows32.
	self deny: ast isPetitFailure
]

{ #category : #asserting }
TypedefParserTest >> testUnion [
	| struct |
	struct := self
		parse32: '
typedef struct t {
	union {
		union {
			WORD s;
		};
	};
} T;'.
	self deny: struct isPetitFailure
]

