"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RtfParser,
	#superclass : #Object,
	#instVars : [
		'input',
		'characters',
		'interval',
		'stack',
		'skipping',
		'fontTable',
		'eol',
		'start'
	],
	#category : #RTF
}

{ #category : #'instance creation' }
RtfParser class >> new [
	^super new initialize]

{ #category : #private }
RtfParser >> endInterval [
	interval at: 2 put: input position]

{ #category : #private }
RtfParser >> font [
	^stack top font]

{ #category : #private }
RtfParser >> font: anRtfFont [
	| current |
	current := stack top font.
	current != anRtfFont ifTrue: [self handleCharacters].
	^stack top font: anRtfFont]

{ #category : #private }
RtfParser >> handleCharacter: aCharacter [
	skipping ifTrue: [^self].
	(aCharacter = Cr or: [aCharacter = Lf]) ifTrue: [^self].
	characters isNil ifTrue: [
		characters := String new writeStream.
		self startInterval].
	characters nextPutChar: aCharacter.
	self endInterval]

{ #category : #private }
RtfParser >> handleCharacters [
	| raw font decoded |
	characters isNil ifTrue: [^self].
	raw := characters contents.
	font := self font.
	decoded := font notNil ifTrue: [font decode: raw] ifFalse: [raw].
	self processor characters: decoded from: interval first to: interval last.
	characters := nil.
	self resetInterval]

{ #category : #private }
RtfParser >> handleControlSymbol: aCharacter [
	skipping ifTrue: [^self].
	aCharacter = $~ ifTrue: [^self handleCharacter: 16rA0 asCharacter].
	('{}\' includes: aCharacter) ifTrue: [^self handleCharacter: aCharacter].
	self handleCharacters.
	aCharacter = $* ifTrue: [self ignorable: true]]

{ #category : #private }
RtfParser >> handleControlWord: word withArgument: arg [
	| font |
	skipping ifTrue: [^self].
	word = 'uc' ifTrue: [^self uskip: arg].
	word = 'ud' ifTrue: [^self ignorable: false].
	word = 'fonttbl' ifTrue: [| builder |
		builder := RtfFontTable new
			processor: self processor;
			fontTable: fontTable.
		self processor: builder].
	self handleCharacters.
	self processor
		controlWord: word
		with: arg
		from: start
		to: input position.
	(self isDestination: word) ifTrue: [self ignorable: true].
	word = 'f' ifTrue: [
		font := fontTable at: arg + 1 ifAbsent: nil.
		self font: font]]

{ #category : #private }
RtfParser >> handleEndGroup [
	| ignore |
	self handleCharacters.
	stack size = 1 ifTrue: [self parseError: 'Too many }'].
	ignore := self ignorable.
	stack pop.
	ignore := ignore and: [self ignorable].
	self processor endGroupAt: start.
	ignore ifFalse: [self processor endIgnorable]]

{ #category : #private }
RtfParser >> handleStartGroup [
	self handleCharacters.
	stack push: stack top copy.
	self processor startGroupAt: start]

{ #category : #private }
RtfParser >> ignorable [
	^stack top ignorable]

{ #category : #private }
RtfParser >> ignorable: aBoolean [
	| ignoring |
	ignoring := stack top ignorable.
	stack top ignorable: aBoolean.
	aBoolean != ignoring ifTrue: [
		aBoolean
			ifTrue: [self processor startIgnorable]
			ifFalse: [self processor endIgnorable]]]

{ #category : #initialization }
RtfParser >> initialize [
	stack := Stack new push: RtfParserState new.
	skipping := false.
	fontTable := OrderedCollection new.
	start := 0.
	interval := {start. start}]

{ #category : #testing }
RtfParser >> isDestination: aString [
	^#('aftncn' 'aftnsep' 'aftnsepc' 'annotation' 'atnauthor' 'atndate' 'atnicn' 'atnid' 'atnparent' 'atnref' 'atntime' 'atrfend' 'atrfstart' 'author' 'background' 'bkmkend' 'bkmkstart' 'blipuid' 'buptim' 'category' 'colorschememapping' 'colortbl' 'comment' 'company' 'creatim' 'datafield' 'datastore' 'defchp' 'defpap' 'do' 'doccomm' 'docvar' 'dptxbxtext' 'ebcend' 'ebcstart' 'factoidname' 'falt' 'fchars' 'ffdeftext' 'ffentrymcr' 'ffexitmcr' 'ffformat' 'ffhelptext' 'ffl' 'ffname' 'ffstattext' 'field' 'file' 'filetbl' 'fldinst' 'fldrslt' 'fldtype' 'fname' 'fontemb' 'fontfile' 'fonttbl' 'footer' 'footerf' 'footerl' 'footerr' 'footnote' 'formfield' 'ftncn' 'ftnsep' 'ftnsepc' 'g' 'generator' 'gridtbl' 'header' 'headerf' 'headerl' 'headerr' 'hl' 'hlfr' 'hlinkbase' 'hlloc' 'hlsrc' 'hsv' 'htmltag' 'info' 'keycode' 'keywords' 'latentstyles' 'lchars' 'levelnumbers' 'leveltext' 'lfolevel' 'linkval' 'list' 'listlevel' 'listname' 'listoverride' 'listoverridetable' 'listpicture' 'liststylename' 'listtable' 'listtext' 'lsdlockedexcept' 'macc' 'maccPr' 'mailmerge' 'maln' 'malnScr' 'manager' 'margPr' 'mbar' 'mbarPr' 'mbaseJc' 'mbegChr' 'mborderBox' 'mborderBoxPr' 'mbox' 'mboxPr' 'mchr' 'mcount' 'mctrlPr' 'md' 'mdeg' 'mdegHide' 'mden' 'mdiff' 'mdPr' 'me' 'mendChr' 'meqArr' 'meqArrPr' 'mf' 'mfName' 'mfPr' 'mfunc' 'mfuncPr' 'mgroupChr' 'mgroupChrPr' 'mgrow' 'mhideBot' 'mhideLeft' 'mhideRight' 'mhideTop' 'mhtmltag' 'mlim' 'mlimloc' 'mlimlow' 'mlimlowPr' 'mlimupp' 'mlimuppPr' 'mm' 'mmaddfieldname' 'mmath' 'mmathPict' 'mmathPr' 'mmaxdist' 'mmc' 'mmcJc' 'mmconnectstr' 'mmconnectstrdata' 'mmcPr' 'mmcs' 'mmdatasource' 'mmheadersource' 'mmmailsubject' 'mmodso' 'mmodsofilter' 'mmodsofldmpdata' 'mmodsomappedname' 'mmodsoname' 'mmodsorecipdata' 'mmodsosort' 'mmodsosrc' 'mmodsotable' 'mmodsoudl' 'mmodsoudldata' 'mmodsouniquetag' 'mmPr' 'mmquery' 'mmr' 'mnary' 'mnaryPr' 'mnoBreak' 'mnum' 'mobjDist' 'moMath' 'moMathPara' 'moMathParaPr' 'mopEmu' 'mphant' 'mphantPr' 'mplcHide' 'mpos' 'mr' 'mrad' 'mradPr' 'mrPr' 'msepChr' 'mshow' 'mshp' 'msPre' 'msPrePr' 'msSub' 'msSubPr' 'msSubSup' 'msSubSupPr' 'msSup' 'msSupPr' 'mstrikeBLTR' 'mstrikeH' 'mstrikeTLBR' 'mstrikeV' 'msub' 'msubHide' 'msup' 'msupHide' 'mtransp' 'mtype' 'mvertJc' 'mvfmf' 'mvfml' 'mvtof' 'mvtol' 'mzeroAsc' 'mzeroDesc' 'mzeroWid' 'nesttableprops' 'nextfile' 'nonesttables' 'objalias' 'objclass' 'objdata' 'object' 'objname' 'objsect' 'objtime' 'oldcprops' 'oldpprops' 'oldsprops' 'oldtprops' 'oleclsid' 'operator' 'panose' 'password' 'passwordhash' 'pgp' 'pgptbl' 'picprop' 'pict' 'pn' 'pnseclvl' 'pntext' 'pntxta' 'pntxtb' 'printim' 'private' 'propname' 'protend' 'protstart' 'protusertbl' 'pxe' 'result' 'revtbl' 'revtim' 'rsidtbl' 'rxe' 'shp' 'shpgrp' 'shpinst' 'shppict' 'shprslt' 'shptxt' 'sn' 'sp' 'staticval' 'stylesheet' 'subject' 'sv' 'svb' 'tc' 'template' 'themedata' 'title' 'txe' 'upr' 'userprops' 'wgrffmtfilter' 'windowcaption' 'writereservation' 'writereservhash' 'xe' 'xform' 'xmlattrname' 'xmlattrvalue' 'xmlclose' 'xmlname' 'xmlnstbl' 'xmlopen')
		includes: aString]

{ #category : #testing }
RtfParser >> isHex: aCharacter [
	^aCharacter isHexDigit]

{ #category : #accessing }
RtfParser >> lineDelimiters: aString [
	eol := aString]

{ #category : #parsing }
RtfParser >> parse: stringOrStream [
	input := stringOrStream readStream.
	eol isNil ifTrue: [eol := input eol].
	self processor lineDelimiters: eol.
	[input atEnd] whileFalse: [self step].
	stack size != 1 ifTrue: [self parseError: 'Missing right }'].
	self handleCharacters]

{ #category : #parsing }
RtfParser >> parseError: aString [
	self parseError: aString at: input position]

{ #category : #parsing }
RtfParser >> parseError: aString at: anInteger [
	RtfParseError signal: aString at: anInteger]

{ #category : #accessing }
RtfParser >> processor [
	^stack top processor]

{ #category : #accessing }
RtfParser >> processor: anRtfProcessor [
	stack top processor: anRtfProcessor]

{ #category : #private }
RtfParser >> resetInterval [
	interval
		at: 1 put: 0;
		at: 2 put: 0]

{ #category : #parsing }
RtfParser >> scanControl [
	| c |
	c := input peek.
	c = $u ifTrue: [^self scanUnicodeChar].
	c = $' ifTrue: [| high low code |
		input next.
		(input atEnd not and: [self isHex: input peek])
			ifFalse: [self parseError: '2 digit hex number expected after \'''].
		high := input next digitValue bitShift: 4.
		(input atEnd not and: [self isHex: input peek])
			ifFalse: [self parseError: '2 digit hex number expected after \'''].
		low := input next digitValue.
		code := high bitOr: low.
		self handleCharacter: code asCharacter.
		^self].
	(c between: $a and: $z) ifTrue: [^self scanControlWord].
	^self scanControlSymbol]

{ #category : #parsing }
RtfParser >> scanControlSymbol [
	self handleControlSymbol: input next]

{ #category : #parsing }
RtfParser >> scanControlWord [
	^self scanControlWord: '']

{ #category : #parsing }
RtfParser >> scanControlWord: aString [
	| word c |
	word := input nextWhile: [:char | char between: $a and: $z].
	word := aString , word.
	c := input peek.
	c = Space ifTrue: [
		input next.
		^self handleControlWord: word withArgument: nil].
	c = $- ifTrue: [
		input next.
		^self handleControlWord: word withArgument: self scanNumber negated].
	(c notNil and: [c isDigit])
		ifTrue: [^self handleControlWord: word withArgument: self scanNumber].
	self handleControlWord: word withArgument: nil]

{ #category : #parsing }
RtfParser >> scanEndGroup [
	self handleEndGroup]

{ #category : #parsing }
RtfParser >> scanNumber [
	| c n |
	n := 0.
	c := input peek.
	[input atEnd not and: [c isDigit]] whileTrue: [
		n := n * 10 + (c codePoint - $0 codePoint).
		input next.
		c := input peek].
	input peekFor: Character space.
	^n]

{ #category : #parsing }
RtfParser >> scanStartGroup [
	self handleStartGroup]

{ #category : #parsing }
RtfParser >> scanUnicodeChar [
	| char codePoint |
	input next.
	input atEnd ifTrue: [^self scanControlWord: 'u'].
	char := input peek.
	(char isDigit or: [char = $-]) ifFalse: [^self scanControlWord: 'u'].
	codePoint := char = $-
		ifTrue: [
			input next.
			16r10000 - self scanNumber]
		ifFalse: [self scanNumber].
	self ASSERT: (codePoint between: 0 and: 16rFFFF).
	self handleCharacter: codePoint asCharacter.
	input peek == Space ifTrue: [input next].
	skipping := true.
	self uskip timesRepeat: [
		('{}' includes: input peek) ifTrue: [^self].
		self step].
	skipping := false]

{ #category : #private }
RtfParser >> startInterval [
	interval at: 1 put: start]

{ #category : #parsing }
RtfParser >> step [
	| c |
	c := input next.
	start := input position.
	c = ${ ifTrue: [^self scanStartGroup].
	c = $} ifTrue: [^self scanEndGroup].
	c = $\ ifTrue: [^self scanControl].
	self handleCharacter: c]

{ #category : #private }
RtfParser >> uskip [
	^stack top uskip]

{ #category : #private }
RtfParser >> uskip: anInteger [
	stack top uskip: anInteger]

