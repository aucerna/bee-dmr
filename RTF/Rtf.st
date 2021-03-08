"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Rtf,
	#superclass : #Object,
	#instVars : [
		'writer',
		'colors',
		'fonts',
		'raw',
		'emphasis',
		'color',
		'font',
		'reader',
		'ansi'
	],
	#classVars : [
		'Mapping'
	],
	#category : #RTF
}

{ #category : #services }
Rtf class >> encode: aString [
	^self new append: aString; privateContents]

{ #category : #private }
Rtf class >> initializeMapping [
	"
	Rtf initializeMapping
	"
	Mapping := Dictionary
		with: $\ -> '\\'
		with: ${ -> '\{'
		with: $} -> '\}'
		with: 13 asCharacter -> '\par '
		with: 10 asCharacter -> '']

{ #category : #private }
Rtf class >> mapping [
	Mapping isNil ifTrue: [self initializeMapping].
	^Mapping]

{ #category : #'instance creation' }
Rtf class >> new [
	^super new initialize]

{ #category : #services }
Rtf class >> on: aString [
	self ASSERT: aString isRTFString.
	^self new output: aString trimBlanks appendStream]

{ #category : #services }
Rtf class >> on: aString raw: anotherString [
	self ASSERT: (aString isEmpty or: [aString isRTFString]).
	^self new output: aString trimBlanks appendStream raw: anotherString]

{ #category : #'instance creation' }
Rtf class >> streamContents: aBlock [
	| text |
	text := self new.
	aBlock value: text.
	^text]

{ #category : #'instance creation' }
Rtf class >> with: aString [
	^self new nextPutAll: aString]

{ #category : #accessing }
Rtf >> , text [
	^self copy append: text]

{ #category : #comparing }
Rtf >> << anObject [
	| string |
	string := anObject isString
		ifTrue: [anObject]
		ifFalse: [anObject printString].
	self nextPutAll: string]

{ #category : #comparing }
Rtf >> = anRtf [
	self class == anRtf class ifFalse: [^false].
	self == anRtf ifTrue: [^true].
	^self formattedContents = anRtf formattedContents]

{ #category : #services }
Rtf >> allStringsUnder: cmd [
	^RtfFormattedTextFinder allStringsUnder: cmd in: self]

{ #category : #accessing }
Rtf >> append: text [
	| copy formatted |
	text isNil ifTrue: [
		self ASSERT: false.
		^self].
	text isString ifTrue: [^self nextPutAll: text].
	copy := text copy shiftFonts: fonts; shiftColors: colors.
	formatted := copy privateContents.
	(formatted beginsWith: self plainCommand)
		ifTrue: [formatted := formatted allButFirst: self plainCommand size].
	writer nextPutAll: formatted.
	self rawNextPutAll: copy rawContents.
	self disableCode: [self emphasis: copy emphasis copy]]

{ #category : #services }
Rtf >> appendTo: aStream [
	| code |
	aStream size = 0
		ifTrue: [aStream nextPutAll: self formattedContents]
		ifFalse: [
			code := self privateContents.
			(code beginsWith: '\plain')
				ifTrue: [code := code allButFirst: '\plain' size].
			aStream
				skip: -1;
				nextPutAll: code;
				nextPutAll: ' }']]

{ #category : #emphasis }
Rtf >> apply: command [
	self emphasize: command.
	writer space]

{ #category : #emphasis }
Rtf >> apply: command to: aString [
	self apply: command while: [self append: aString]]

{ #category : #private }
Rtf >> apply: command while: aBlock [
	self apply: command.
	aBlock ensure: [self apply: (self offCommandFor: command)]]

{ #category : #writing }
Rtf >> arrow [
	"
	'x' asText arrow; append: 'y'
	"
	self
		useFontFace: 'Arial Unicode MS'
		while: [self space; nextPut: $→; space]]

{ #category : #converting }
Rtf >> asParameter [
	^self asString asParameter]

{ #category : #converting }
Rtf >> asString [
	^self rawContents]

{ #category : #converting }
Rtf >> asText [
	^self]

{ #category : #accessing }
Rtf >> beAnsi [
	ansi := true]

{ #category : #accessing }
Rtf >> beSmalltalkCompatible [
	raw lineDelimiters: String cr]

{ #category : #configuration }
Rtf >> beUnicode [
	raw beUnicode]

{ #category : #emphasis }
Rtf >> bold [
	self apply: self boldCommand]

{ #category : #emphasis }
Rtf >> bold: aString [
	self apply: self boldCommand to: aString]

{ #category : #emphasis }
Rtf >> bold: aString color: aColor [
	| save |
	save := self color.
	self
		setCharColor: aColor;
		bold: aString;
		setCharColor: save]

{ #category : #commands }
Rtf >> boldCommand [
	^'\b']

{ #category : #emphasis }
Rtf >> boldOff [
	| off |
	off := self offCommandFor: self boldCommand.
	self apply: off]

{ #category : #'math symbols' }
Rtf >> capitalABar [
	"
	'' asText capitalABar
	"
	self useFontFace: 'Arial Unicode MS' while: [self nextPut: $Ā]]

{ #category : #writing }
Rtf >> cdot [
	"
	'x' asText cdot; append: 'y'
	"
	self useFontFace: 'Arial Unicode MS' while: [self bold: '·']]

{ #category : #emphasis }
Rtf >> center: aString [
	self apply: self centerCommand to: aString]

{ #category : #commands }
Rtf >> centerCommand [
	^'\qc']

{ #category : #writing }
Rtf >> checkMark [
	"
	'' asText checkMark
	"
	self useFontFace: 'Arial Unicode MS' while: [self nextPut: $✓]]

{ #category : #'private services' }
Rtf >> codeFor: aCharacter [
	| cp bytes code1 code2 |
	cp := aCharacter codePoint.
	cp < 128 ifTrue: [^Mapping at: aCharacter ifAbsent: [aCharacter]].
	ansi ifFalse: [^aCharacter].
	cp < 16r8000 ifTrue: [^'\u' , cp asString , '?'].
	cp < 16r10000 ifTrue: [^'\u' , (16r10000 - cp) asString , '?'].
	bytes := UTF16 current encode: aCharacter asString.
	cp := bytes shortAtOffset: 0.
	code1 := cp < 16r8000
		ifTrue: ['\u' , cp asString , '?']
		ifFalse: ['\u' , (16r10000 - cp) asString , '?'].
	cp := bytes shortAtOffset: 2.
	code2 := cp < 16r8000
		ifTrue: ['\u' , cp asString , '?']
		ifFalse: ['\u' , (16r10000 - cp) asString , '?'].
	^code1 , code2]

{ #category : #accessing }
Rtf >> color [
	^color]

{ #category : #private }
Rtf >> color: aColor [
	color := aColor asRGBColor]

{ #category : #private }
Rtf >> commandsDo: aBlock [
	RtfCommandIterator new block: aBlock; parse: writer contents]

{ #category : #accessing }
Rtf >> contents [
	| token1 token2 result n head |
	token1 := '{\urtf'.
	token2 := '{\rtf1'.
	self ASSERT: token1 size = token2 size.
	result := '' writeStream.
	n := token1 size min: self size.
	head := writer readStream next: n.
	(head = token1
		or: [head allButLast = token2 allButLast and: [head last isDigit]])
		ifTrue: [result nextPutAll: writer contents]
		ifFalse: [
			self writeHeaderOn: result.
			result nextPutAll: writer contents; nextPutAll: '\par}'].
	^result position: 0]

{ #category : #writing }
Rtf >> cr [
	raw cr.
	writer nextPutAll: '\par ']

{ #category : #writing }
Rtf >> crtab [
	self cr; tab]

{ #category : #writing }
Rtf >> crtab: n [
	self cr; tab: n]

{ #category : #writing }
Rtf >> cubic [
	self super: '3']

{ #category : #writing }
Rtf >> degree [
	"
	'' asText degree; append: 'C'
	"
	self useFontFace: 'Arial Unicode MS' while: [self nextPut: $º]]

{ #category : #emphasis }
Rtf >> dotUnderline: aString [
	self apply: self dotUnderlineCommand to: aString]

{ #category : #commands }
Rtf >> dotUnderlineCommand [
	^'\uld']

{ #category : #emphasis }
Rtf >> doubleUnderline: aString [
	self apply: self doubleUnderlineCommand; append: aString; underlineOff]

{ #category : #commands }
Rtf >> doubleUnderlineCommand [
	^'\uldb']

{ #category : #'private services' }
Rtf >> dumpCommandOn: aStream [
	| char cmd digit |
	aStream nextPut: reader next.
	char := reader next.
	aStream nextPut: char.
	cmd := aStream contents.
	cmd = '\*' ifTrue: [
		reader upTo: $}.
		^self].
	cmd = '\\' ifTrue: [^self].
	(cmd = '\u' and: [reader peek isDigit or: [reader peek = $-]])
		ifTrue: [^self dumpUnicodeCommandOn: aStream].
	(char isAlphanumeric or: [self isCodeMark: char]) ifFalse: [^self].
	digit := false.
	[| loop |
		reader atEnd ifTrue: [^self].
		char := reader peek.
		char isDigit ifTrue: [digit := true].
		loop := digit ifTrue: [char isDigit] ifFalse: [char isAlphanumeric].
		loop and: [(self isPrintable: aStream contents) not]]
		whileTrue: [aStream nextPut: reader next].
	reader peek = $  ifTrue: [reader next].
	(aStream contents endsWith: '\par')
		ifTrue: [reader peekFor: Character cr; peekFor: Character lf]]

{ #category : #'private services' }
Rtf >> dumpUnicodeCommandOn: aStream [
	| negative cmd |
	negative := reader peekFor: $-.
	cmd := reader untilAnySatisfying: [:c | c isDigit not].
	negative ifTrue: [aStream nextPut: $-].
	aStream nextPutAll: cmd.
	(reader peekFor: $?) ifTrue: [aStream nextPut: $?].
	^self]

{ #category : #writing }
Rtf >> emdash [
	self nextPut: Emdash]

{ #category : #accessing }
Rtf >> emphasis [
	^emphasis copy]

{ #category : #emphasis }
Rtf >> emphasis: aCollection [
	emphasis notEmpty ifTrue: [
		emphasis do: [:cmd | 
			(aCollection includes: cmd)
				ifFalse: [self emphasize: (self offCommandFor: cmd)]].
		writer space].
	aCollection notEmpty ifTrue: [
		aCollection
			do: [:cmd | (emphasis includes: cmd) ifFalse: [self emphasize: cmd]].
		writer space]]

{ #category : #emphasis }
Rtf >> emphasize: command [
	| cmd |
	cmd := command trimBlanks.
	writer nextPutAll: cmd.
	(self resetsEmphasis: command) ifTrue: [
		emphasis removeAll.
		self color: self defaultColor].
	cmd = self plainCommand ifTrue: [^self].
	(self isOffCommand: cmd)
		ifTrue: [(self onCommandsFor: cmd)
			do: [:c | emphasis remove: c ifAbsent: nil]]
		ifFalse: [emphasis add: cmd]]

{ #category : #writing }
Rtf >> endash [
	self nextPut: Endash]

{ #category : #writing }
Rtf >> endLinesOf: aString withLineFeeds: aBoolean [
	| crlf cr |
	(aString includes: Character cr) ifFalse: [^aString].
	aBoolean = (aString includes: Lf) ifTrue: [^aString].
	crlf := String with: Cr with: Lf.
	cr := String with: Cr.
	^aBoolean
		ifTrue: [aString replaceAllChar: Cr with: crlf]
		ifFalse: [aString replaceAll: crlf with: cr]]

{ #category : #accessing }
Rtf >> eol [
	^raw eol]

{ #category : #private }
Rtf >> escapeCharacter [
	^$\]

{ #category : #'math symbols' }
Rtf >> euro [
	"
	'' asText euro
	"
	self nextPut: Character euro]

{ #category : #accessing }
Rtf >> font [
	^font]

{ #category : #accessing }
Rtf >> fontSize: aNumber [
	font isNil ifTrue: [^self].
	font := font resizedTo: aNumber.
	self setCharFont: font]

{ #category : #emphasis }
Rtf >> fontSize: anInteger while: aBlock [
	| prevFont |
	prevFont := font.
	self fontSize: anInteger.
	aBlock ensure: [self setCharFont: prevFont]]

{ #category : #accessing }
Rtf >> formattedContents [
	^self contents contents]

{ #category : #writing }
Rtf >> ge [
	"
	'' asText ge
	"
	self useFontFace: 'Arial Unicode MS' while: [self nextPut: $≥]]

{ #category : #inquiries }
Rtf >> hasEmphasis: command [
	^emphasis includes: command]

{ #category : #services }
Rtf >> headerSize [
	| dummy |
	dummy := '' writeStream.
	self writeHeaderOn: dummy.
	^dummy position]

{ #category : #commands }
Rtf >> highlightCommand [
	^'\highlight']

{ #category : #emphasis }
Rtf >> highlightOff [
	| off |
	off := self offCommandFor: self highlightCommand.
	self apply: off]

{ #category : #writing }
Rtf >> horizontalLine [
	raw nextPutAll: '-----'; cr.
	writer nextPutAll: '\par \brdrt '.
	800 timesRepeat: [writer space].
	writer nextPutAll: '\par \par']

{ #category : #initialization }
Rtf >> includesHeader [
	| c |
	c := writer contents.
	^(c beginsWith: '{\rtf') or: [c beginsWith: '{\urtf']]

{ #category : #services }
Rtf >> indentAt: index [
	^raw contents indentAt: index]

{ #category : #services }
Rtf >> indentEnd [
	^raw contents indentAt: raw size]

{ #category : #initialization }
Rtf >> initialize [
	colors := OrderedCollection new.
	fonts := OrderedCollection new.
	writer := '' writeStream.
	reader := writer readStream.
	raw := '' writeStream.
	emphasis := Set new.
	font := GDIFont defaultTextFont.
	self setCharColor: self defaultColor.
	ansi := false]

{ #category : #initialization }
Rtf >> insert: aString at: position [
	self replace: '' at: position with: aString]

{ #category : #testing }
Rtf >> isBold [
	^self hasEmphasis: self boldCommand]

{ #category : #testing }
Rtf >> isCodeMark: aCharacter [
	aCharacter = $' ifTrue: [^true].
	^Mapping anySatisfy: [:cmd | cmd size >= 2 and: [aCharacter = (cmd at: 2)]]]

{ #category : #testing }
Rtf >> isEmpty [
	^raw position = 0]

{ #category : #testing }
Rtf >> isItalic [
	^self hasEmphasis: self italicCommand]

{ #category : #testing }
Rtf >> isOffCommand: command [
	^command last = $0
		or: [self specialCommandList anySatisfy: [:pair | pair second = command]]]

{ #category : #testing }
Rtf >> isPlain [
	^emphasis isEmpty]

{ #category : #inquiries }
Rtf >> isPrintable: command [
	((command beginsWith: '\u')
		and: [command size > 3]
		and: [| s |
			s := (command at: 3) = $- ifTrue: [4] ifFalse: [3].
			(s to: command size - 1) conform: [:i | (command at: i) isDigit]]
		and: [command last isDigit or: [command last = $?]])
		ifTrue: [^true].
	^Mapping includes: command]

{ #category : #testing }
Rtf >> isStrikedOut [
	^self hasEmphasis: self strikeCommand]

{ #category : #testing }
Rtf >> isSub [
	^self hasEmphasis: self subCommand]

{ #category : #testing }
Rtf >> isSuper [
	^self hasEmphasis: self superCommand]

{ #category : #testing }
Rtf >> isText [
	^true]

{ #category : #testing }
Rtf >> isUnderlined [
	^self hasEmphasis: self underlineCommand]

{ #category : #testing }
Rtf >> isUnicode [
	^raw isUnicode]

{ #category : #emphasis }
Rtf >> italic [
	self apply: self italicCommand]

{ #category : #emphasis }
Rtf >> italic: aString [
	self apply: self italicCommand to: aString]

{ #category : #commands }
Rtf >> italicCommand [
	^'\i']

{ #category : #services }
Rtf >> italicLink: aString [
	self
		apply: self italicCommand;
		link: aString;
		apply: (self offCommandFor: self italicCommand)]

{ #category : #emphasis }
Rtf >> italicOff [
	| off |
	off := self offCommandFor: self italicCommand.
	self apply: off]

{ #category : #writing }
Rtf >> le [
	"
	'' asText le
	"
	self useFontFace: 'Arial Unicode MS' while: [self nextPut: $≤]]

{ #category : #initialization }
Rtf >> limittedTo: anInteger [
	^self shallowCopy
		instVarNamed: 'raw' put: (raw limittedTo: anInteger);
		yourself]

{ #category : #emphasis }
Rtf >> link: aString [
	self apply: self underlineCommand.
	self apply: '\link' to: aString asString.
	self apply: (self offCommandFor: self underlineCommand)]

{ #category : #services }
Rtf >> moveToNextChar [
	| command special |
	reader peek = self escapeCharacter
		ifTrue: [
			command := '' writeStream.
			self dumpCommandOn: command.
			special := self printableFormOf: command contents.
			self ASSERT: special notNil.
			raw position: raw position + special asString size]
		ifFalse: [
			reader atEnd ifFalse: [
				reader next.
				raw position: raw position + 1]]]

{ #category : #services }
Rtf >> nextCommand [
	| command char |
	reader atEnd ifTrue: [^''].
	char := reader peek.
	(#(${ $}) includes: char) ifTrue: [^reader next asString].
	char = self escapeCharacter ifFalse: [^''].
	command := '' writeStream.
	self dumpCommandOn: command.
	^command contents]

{ #category : #writing }
Rtf >> nextPut: aCharacter [
	| code |
	self rawNextPut: aCharacter.
	code := self codeFor: aCharacter.
	writer nextPutAll: code asString]

{ #category : #writing }
Rtf >> nextPutAll: aString [
	self rawNextPutAll: aString.
	aString do: [:char | | code |
		code := self codeFor: char.
		code isCharacter
			ifTrue: [writer nextPut: code]
			ifFalse: [writer nextPutAll: code asString]]]

{ #category : #testing }
Rtf >> notEmpty [
	^self isEmpty not]

{ #category : #commands }
Rtf >> offCommandFor: command [
	^(self specialCommandList
		detect: [:pair | pair first = command]
		ifNone: [^command , '0']) second]

{ #category : #commands }
Rtf >> offMacroFor: macro [
	^(macro collect: [:cmd | self offCommandFor: cmd]) reversed]

{ #category : #'math symbols' }
Rtf >> omega [
	"
	'' asText omega
	"
	self useFontFace: 'Arial Unicode MS' while: [self nextPut: $Ω]]

{ #category : #commands }
Rtf >> onCommandsFor: offCommand [
	| answer |
	answer := self specialCommandList
		select: [:pair | pair second = offCommand]
		thenCollect: [:pair | pair first].
	answer isEmpty ifTrue: [
		self ASSERT: offCommand last = $0.
		answer := {offCommand allButLast}].
	^answer]

{ #category : #'math symbols' }
Rtf >> oplus [
	"
	'' asText oplus
	"
	self useFontFace: 'Arial Unicode MS' while: [self nextPut: $⊕]]

{ #category : #accessing }
Rtf >> output: aStream [
	writer := aStream.
	reader := writer readStream.
	raw reset.
	raw := self plainContents appendStream]

{ #category : #accessing }
Rtf >> output: aStream raw: aString [
	writer := aStream.
	reader := writer readStream.
	fonts notEmpty ifTrue: [self writeHeaderOn: writer].
	raw := aString appendStream]

{ #category : #emphasis }
Rtf >> plain [
	self apply: self plainCommand]

{ #category : #commands }
Rtf >> plainCommand [
	^'\plain']

{ #category : #converting }
Rtf >> plainContents [
	raw isEmpty ifFalse: [^self rawContents].
	reader := writer readStream.
	^RtfStringExtractor new parse: writer contents]

{ #category : #accessing }
Rtf >> position [
	^raw position]

{ #category : #copying }
Rtf >> postCopy [
	super postCopy.
	colors := colors copy.
	emphasis := emphasis copy.
	fonts := fonts copy.
	raw := raw deepCopy.
	writer := writer deepCopy.
	reader := reader deepCopy]

{ #category : #accessing }
Rtf >> print: anObject [
	anObject printOn: self]

{ #category : #'private services' }
Rtf >> printableCharFor: cmd [
	(self isPrintable: cmd) ifFalse: [^nil].
	^Mapping keyAtValue: cmd ifAbsent: [| code |
		code := cmd allButFirst: 2.
		code := code asInteger.
		code < 0 ifTrue: [code := code + 16r10000].
		code asCharacter]]

{ #category : #'private services' }
Rtf >> printableFormOf: command [
	command isEmpty ifTrue: [^nil].
	command = '\tab' ifTrue: [^Character tab].
	command = '\par' ifTrue: [^raw eol].
	^self printableCharFor: command]

{ #category : #printing }
Rtf >> printOn: aStream [
	aStream nextPutAll: self rawContents]

{ #category : #printing }
Rtf >> printTextOn: aStream [
	self enableCode: [aStream append: self copy].
	self disableCode: [writer printTextOn: aStream]]

{ #category : #private }
Rtf >> privateContents [
	^writer contents]

{ #category : #writing }
Rtf >> raisedTo: aNumber [
	self super: aNumber printString]

{ #category : #accessing }
Rtf >> rawContents [
	^raw contents]

{ #category : #writing }
Rtf >> rawNextPut: aCharacter [
	| character |
	(self isUnicode not and: [aCharacter isUnicode]) ifTrue: [self beUnicode].
	character := self isUnicode
		ifTrue: [aCharacter asUnicode]
		ifFalse: [aCharacter].
	raw nextPut: character]

{ #category : #writing }
Rtf >> rawNextPutAll: aString [
	| string |
	(self isUnicode not and: [aString isUnicode]) ifTrue: [self beUnicode].
	string := self endLinesOf: aString withLineFeeds: self usesCrLf.
	raw nextPutAll: string]

{ #category : #accessing }
Rtf >> rawPosition [
	^raw position]

{ #category : #accessing }
Rtf >> readStream [
	^self formattedContents readStream]

{ #category : #references }
Rtf >> reference1 [
	'http://www.biblioscape.com/rtf15_spec.htm' asURL browse]

{ #category : #references }
Rtf >> reference2 [
	'http://www.pindari.com/rtf1.html' asURL browse]

{ #category : #services }
Rtf >> removeCommand: cmd [
	self replaceCommand: cmd with: '']

{ #category : #services }
Rtf >> removeLinks [
	self removeMacro: {self underlineCommand. '\link'}]

{ #category : #services }
Rtf >> removeMacro: aCollection [
	self replaceMacro: aCollection with: '']

{ #category : #initialization }
Rtf >> replace: aString at: position with: anotherString [
	RtfStringReplacer
		replace: aString
		at: position
		with: anotherString
		in: self]

{ #category : #services }
Rtf >> replaceCommand: cmd1 with: cmd2 [
	| macro1 macro2 |
	macro1 := {cmd1}.
	macro2 := {cmd2}.
	self replaceMacro: macro1 with: macro2]

{ #category : #services }
Rtf >> replaceLinksWithItalics [
	| link italics |
	link := {self underlineCommand. '\link'}.
	italics := {self italicCommand}.
	self replaceMacro: link with: italics]

{ #category : #services }
Rtf >> replaceMacro: macro with: anotherMacro [
	RtfFormattingReplacer replaceFormatting: macro with: anotherMacro in: self]

{ #category : #inquiries }
Rtf >> resetsEmphasis: command [
	command = self plainCommand ifTrue: [^true].
	^(self offCommandFor: command) last ~= $0]

{ #category : #'math symbols' }
Rtf >> root [
	"
	'' asText root
	"
	self useFontFace: 'Arial Unicode MS' while: [self nextPut: $√]]

{ #category : #emphasis }
Rtf >> scapsCommand [
	^'\scaps']

{ #category : #emphasis }
Rtf >> setCharColor: aColor [
	| index rgb |
	rgb := aColor asRGBColor.
	index := colors indexOf: rgb ifAbsent: [colors add: rgb; size].
	writer nextPutAll: '\cf'; nextPutAll: index asString; space.
	color := rgb]

{ #category : #emphasis }
Rtf >> setCharFont: aFont [
	self setFont: aFont]

{ #category : #emphasis }
Rtf >> setCharFont: aFont color: aColor [
	self setFont: aFont.
	self setCharColor: aColor]

{ #category : #emphasis }
Rtf >> setFont: aFont [
	| index commands face |
	font := aFont.
	face := aFont face.
	index := fonts findFirst: [:f | f face = face] ifAbsent: [
		fonts add: aFont.
		fonts size].
	commands := Set new.
	aFont italic ifTrue: [commands add: self italicCommand].
	aFont bold ifTrue: [commands add: self boldCommand].
	aFont underline ifTrue: [commands add: self underlineCommand].
	aFont strikeout ifTrue: [commands add: self strikeCommand].
	self emphasis: commands.
	writer
		nextPutAll: '\f';
		nextPutAll: index asString;
		nextPutAll: '\fs';
		nextPutAll: (aFont pointSize * 2) rounded asString;
		space]

{ #category : #emphasis }
Rtf >> setHighlightColor: aColor [
	| colorIndex rgb |
	rgb := aColor asRGBColor.
	colorIndex := (colors indexOf: rgb ifAbsent: [
		colors add: rgb.
		colors size]).
	writer nextPutAll: '\highlight'; nextPutAll: colorIndex asString; space.
	self color: rgb]

{ #category : #settings }
Rtf >> setParagraphAlignment: aSymbol
leftIndent: lInteger
firstLine: fInteger
rightIndent: rInteger [
	writer
		nextPutAll: '\pard\li' , lInteger asString , '\ri' , rInteger asString
			, '\fi'
			, fInteger asString
			, '\q'
			, aSymbol first asString
			, ' ']

{ #category : #settings }
Rtf >> setTabStops: anIntegerCollection [
	self setTabStops: anIntegerCollection alignments: #()]

{ #category : #settings }
Rtf >> setTabStops: integerCollection alignments: symbolCollection [
	| commands |
	commands := symbolCollection collect: [:s | self tabCommandFor: s].
	writer nextPutAll: '\pard '.
	commands := commands readStream.
	integerCollection do: [:stop | 
		commands atEnd ifFalse: [writer nextPutAll: commands next].
		writer nextPutAll: '\tx' , stop printString].
	writer space]

{ #category : #private }
Rtf >> shiftColors: colorCollection [
	| string i0 write dye index |
	string := writer contents.
	i0 := 0.
	write := '' writeStream.
	self commandsDo: [:cmd :arg :i | 
		write
			nextPutAll: (string copyFrom: i0 + 1 to: i);
			nextPutAll: cmd.
		index := arg asInteger.
		(cmd = 'cf' and: [index > 0]) ifTrue: [
			dye := colors at: arg asInteger ifAbsent: [].
			dye notNil
				ifTrue: [index := colorCollection
					indexOf: dye
					ifAbsent: [colorCollection add: dye; size]]].
		arg notEmpty ifTrue: [write nextPutAll: index printString].
		i0 := i + cmd size + arg size].
	write nextPutAll: (string copyFrom: i0 + 1).
	writer reset nextPutAll: write contents; truncate.
	colors := colorCollection copy]

{ #category : #private }
Rtf >> shiftFonts: fontCollection [
	| string i0 write index fnt |
	string := writer contents.
	i0 := 0.
	write := '' writeStream.
	self commandsDo: [:cmd :arg :i | 
		write
			nextPutAll: (string copyFrom: i0 + 1 to: i);
			nextPutAll: cmd.
		index := arg asInteger.
		(cmd = 'f' and: [index > 0]) ifTrue: [
			fnt := fonts at: index.
			index := fontCollection
				indexOf: fnt
				ifAbsent: [fontCollection add: fnt; size]].
		arg notEmpty ifTrue: [write nextPutAll: index printString].
		i0 := i + cmd size + arg size].
	write nextPutAll: (string copyFrom: i0 + 1).
	writer reset nextPutAll: write contents; truncate.
	fonts := fontCollection copy]

{ #category : #private }
Rtf >> showURL: url as: aString [
	writer
		nextPutAll: '{\field{\*\fldinst{HYPERLINK "' , url , '"}}{\fldrslt{'
			, aString
			, '}}}'.
	self rawNextPutAll: url]

{ #category : #accessing }
Rtf >> size [
	^writer size]

{ #category : #emphasis }
Rtf >> smallCaps [
	self apply: self scapsCommand]

{ #category : #emphasis }
Rtf >> smallCaps: aString [
	self apply: self scapsCommand to: aString]

{ #category : #writing }
Rtf >> space [
	raw space.
	writer space]

{ #category : #writing }
Rtf >> spaceEmdash [
	self space; emdash; space]

{ #category : #private }
Rtf >> specialCommandList [
	^#(
	#('\super' '\nosupersub') 
	#('\sub' '\nosupersub') 
	#('\uld' '\ul0') 
	#('\ulw' '\ulnone') 
	#('\scaps' '\scaps'))]

{ #category : #writing }
Rtf >> squared [
	self super: '2']

{ #category : #printing }
Rtf >> storeOn: aStream [
	aStream nextPutAll: self formattedContents]

{ #category : #emphasis }
Rtf >> strike: aString [
	self apply: self strikeCommand to: aString]

{ #category : #commands }
Rtf >> strikeCommand [
	^'\strike']

{ #category : #emphasis }
Rtf >> strikeout [
	self apply: self strikeCommand]

{ #category : #emphasis }
Rtf >> strikeOutOff [
	self apply: (self offCommandFor: self strikeCommand)]

{ #category : #emphasis }
Rtf >> sub [
	self apply: self subCommand]

{ #category : #emphasis }
Rtf >> sub: aString [
	self apply: self subCommand to: aString]

{ #category : #commands }
Rtf >> subCommand [
	^'\sub']

{ #category : #emphasis }
Rtf >> super [
	self apply: self superCommand]

{ #category : #emphasis }
Rtf >> super: aString [
	self apply: self superCommand to: aString]

{ #category : #commands }
Rtf >> superCommand [
	^'\super']

{ #category : #writing }
Rtf >> tab [
	raw tab.
	writer nextPutAll: '\tab ']

{ #category : #writing }
Rtf >> tab: anInteger [
	anInteger timesRepeat: [self tab]]

{ #category : #commands }
Rtf >> tabCommandFor: symbol [
	symbol == #left ifTrue: [^''].
	symbol == #right ifTrue: [^'\tqr'].
	symbol == #center ifTrue: [^'\tqc'].
	symbol == #decimal ifTrue: [^'\tqdec'].
	self ASSERT: false.
	^'']

{ #category : #'math symbols' }
Rtf >> tensor [
	"
	'' asText tensor
	"
	self useFontFace: 'Arial Unicode MS' while: [self nextPut: $⊗]]

{ #category : #emphasis }
Rtf >> thickUnderline: aString [
	self apply: self thickUnderlineCommand to: aString]

{ #category : #commands }
Rtf >> thickUnderlineCommand [
	^'\ulth']

{ #category : #emphasis }
Rtf >> underline [
	self apply: self underlineCommand]

{ #category : #emphasis }
Rtf >> underline: aString [
	self apply: self underlineCommand to: aString]

{ #category : #commands }
Rtf >> underlineCommand [
	^'\ul']

{ #category : #emphasis }
Rtf >> underlineOff [
	self apply: (self offCommandFor: self underlineCommand)]

{ #category : #accessing }
Rtf >> unformatted [
	^self plainContents]

{ #category : #writing }
Rtf >> upArrow [
	"
	'' asText upArrow
	"
	self useFontFace: 'Arial Unicode MS' while: [self nextPut: $↑]]

{ #category : #emphasis }
Rtf >> useBoldWhile: aBlock [
	self apply: self boldCommand while: aBlock]

{ #category : #accessing }
Rtf >> useColor: aColor fontSize: anInteger while: aBlock [
	| c prevFont |
	c := color.
	prevFont := font.
	[
		self fontSize: anInteger.
		color := aColor.
		self setCharColor: aColor.
		aBlock value]
		ensure: [
			color := c.
			self setCharColor: c.
			self setCharFont: prevFont]]

{ #category : #accessing }
Rtf >> useColor: aColor while: aBlock [
	| current |
	current := color.
	[
		self setCharColor: aColor.
		aBlock value]
		ensure: [self setCharColor: current]]

{ #category : #accessing }
Rtf >> useCrLf [
	| cr |
	cr := String with: Cr with: Lf.
	raw lineDelimiters: cr]

{ #category : #accessing }
Rtf >> useCrOnly [
	| cr |
	cr := String with: Cr.
	raw lineDelimiters: cr]

{ #category : #private }
Rtf >> useFont: aFont while: aBlock [
	| f |
	f := font.
	[
		font := aFont.
		self setCharFont: aFont.
		aBlock value]
		ensure: [
			font := f.
			self setCharFont: f]]

{ #category : #private }
Rtf >> useFontFace: aString while: aBlock [
	| typeface f |
	typeface := font ifNil: [GDIFont defaultTextFont].
	f := GDIFont face: aString size: typeface pointSize.
	self useFont: f while: aBlock]

{ #category : #emphasis }
Rtf >> useHighlight: aColor while: aBlock [
	[
		self setHighlightColor: aColor.
		aBlock value]
		ensure: [self highlightOff]]

{ #category : #emphasis }
Rtf >> useItalicWhile: aBlock [
	self apply: self italicCommand while: aBlock]

{ #category : #testing }
Rtf >> usesCrLf [
	^raw isNil or: [raw eol = String crlf]]

{ #category : #emphasis }
Rtf >> waveUnderline: aString [
	"
	'' asText waveUnderline: 'Smalltalk'
	"
	self apply: self waveUnderlineCommand to: aString]

{ #category : #commands }
Rtf >> waveUnderlineCommand [
	^'\ulwave']

{ #category : #emphasis }
Rtf >> wordUnderline: aString [
	self apply: self wordUnderlineCommand to: aString]

{ #category : #commands }
Rtf >> wordUnderlineCommand [
	^'\ulw']

{ #category : #private }
Rtf >> writeColorTableOn: aStream [
	aStream nextPutAll: '{\colortbl ;'.
	colors do: [:each | 
		aStream
			nextPutAll: '\red' , each red asString , '\green' , each green asString
				, '\blue'
				, each blue asString
				, ';'].
	aStream nextPutAll: '}'; cr]

{ #category : #private }
Rtf >> writeFontTableOn: aStream [
	aStream nextPutAll: '{\fonttbl'.
	fonts withIndexDo: [:f :index | 
		aStream
			nextPutAll: '{\f';
			nextPutAll: index asString;
			nextPutAll: '\fnil\fcharset';
			nextPutAll: f charset printString;
			space;
			nextPutAll: f face;
			nextPutAll: ';}'].
	aStream nextPutAll: '}'; cr]

{ #category : #private }
Rtf >> writeHeaderOn: aStream [
	| head |
	head := ansi
		ifTrue: ['{\rtf1\ansi\deff0\nouicompat\viewkind4\uc1']
		ifFalse: ['{\urtf1\ansi\deff0\nouicompat\viewkind4\uc1'].
	aStream nextPutAll: head.
	self writeFontTableOn: aStream; writeColorTableOn: aStream.
	aStream nextPutAll: '\pard ']

