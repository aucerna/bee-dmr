"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RtfTest,
	#superclass : #TestCase,
	#category : #'RTF\Tests'
}

{ #category : #services }
RtfTest >> testAllStringsUnder [
	| text strings |
	text := '' asText.
	text
		append: 'normal';
		underline: 'first';
		tab;
		underline: 'second'.
	strings := text allStringsUnder: text underlineCommand.
	self
		assert: strings size = 2;
		assert: strings first = #(7 11 'first');
		assert: strings second = #(13 18 'second')]

{ #category : #services }
RtfTest >> testAllStringsUnder10 [
	| text strings |
	text := Rtf
		on: '{\urtf1\ansi\deff0\nouicompat\viewkind4\uc1{\fonttbl{\f1\fnil\fcharset0 Segoe UI;}}
{\colortbl ;\red200\green150\blue0;\red0\green0\blue0;}
normal\ul año{\ul  degü\ul0}ello\ul0 }'.
	strings := text allStringsUnder: text underlineCommand.
	self
		assert: strings size = 1;
		assert: strings first = #(7 18 'año degüello')]

{ #category : #services }
RtfTest >> testAllStringsUnder2 [
	| text strings |
	text := '' asText.
	text
		append: 'normal';
		underline: 'año';
		tab;
		underline: 'degüello'.
	strings := text allStringsUnder: text underlineCommand.
	self
		assert: strings size = 2;
		assert: strings first = #(7 9 'año');
		assert: strings second = #(11 18 'degüello')]

{ #category : #services }
RtfTest >> testAllStringsUnder3 [
	| text strings |
	text := Rtf
		on: '{\urtf1\ansi\deff0\nouicompat\viewkind4\uc1{\fonttbl{\f1\fnil\fcharset0 Segoe UI;}}
{\colortbl ;\red200\green150\blue0;\red0\green0\blue0;}
normal\ul año\tab degüello\ul0 }'.
	strings := text allStringsUnder: text underlineCommand.
	self
		assert: strings size = 1;
		assert: strings first = #(7 18 'año	degüello')]

{ #category : #services }
RtfTest >> testAllStringsUnder4 [
	| text strings |
	text := Rtf
		on: '{\urtf1\ansi\deff0\nouicompat\viewkind4\uc1{\fonttbl{\f1\fnil\fcharset0 Segoe UI;}}
{\colortbl ;\red200\green150\blue0;\red0\green0\blue0;}
normal\ul año{} degüello\ul0 }'.
	strings := text allStringsUnder: text underlineCommand.
	self
		assert: strings size = 1;
		assert: strings first = #(7 18 'año degüello')]

{ #category : #services }
RtfTest >> testAllStringsUnder5 [
	| text strings |
	text := Rtf
		on: '{\urtf1\ansi\deff0\nouicompat\viewkind4\uc1{\fonttbl{\f1\fnil\fcharset0 Segoe UI;}}
{\colortbl ;\red200\green150\blue0;\red0\green0\blue0;}
normal\ul año\link  degüello\link0\ul0 }'.
	strings := text allStringsUnder: text underlineCommand.
	self
		assert: strings size = 1;
		assert: strings first = #(7 18 'año degüello')]

{ #category : #services }
RtfTest >> testAllStringsUnder7 [
	| text strings |
	text := Rtf
		on: '{\urtf1\ansi\deff0\nouicompat\viewkind4\uc1{\fonttbl{\f1\fnil\fcharset0 Segoe UI;}}
{\colortbl ;\red200\green150\blue0;\red0\green0\blue0;}
normal\ul año\ul  degüello\ul0\ul0 }'.
	strings := text allStringsUnder: text underlineCommand.
	self
		assert: strings size = 1;
		assert: strings first = #(7 18 'año degüello')]

{ #category : #services }
RtfTest >> testAllStringsUnder8 [
	| text strings |
	text := Rtf
		on: '{\urtf1\ansi\deff0\nouicompat\viewkind4\uc1{\fonttbl{\f1\fnil\fcharset0 Segoe UI;}}
{\colortbl ;\red200\green150\blue0;\red0\green0\blue0;}
normal\ul año\ul \ul0  degüello\ul0 }'.
	strings := text allStringsUnder: text underlineCommand.
	self
		assert: strings size = 1;
		assert: strings first = #(7 18 'año degüello')]

{ #category : #services }
RtfTest >> testAllStringsUnder9 [
	| text strings |
	text := Rtf
		on: '{\urtf1\ansi\deff0\nouicompat\viewkind4\uc1{\fonttbl{\f1\fnil\fcharset0 Segoe UI;}}
{\colortbl ;\red200\green150\blue0;\red0\green0\blue0;}
normal\ul año{ degüello}\ul0 }'.
	strings := text allStringsUnder: text underlineCommand.
	self
		assert: strings size = 1;
		assert: strings first = #(7 18 'año degüello')]

{ #category : #services }
RtfTest >> testAllStringsUnderTP43061 [
	| text strings |
	text := Rtf
		on: '{\urtf1\ansi\deff0\nouicompat\viewkind4\uc1{\fonttbl{\f1\fnil\fcharset0 Segoe UI;}}
{\colortbl ;\red200\green150\blue0;\red0\green0\blue0;}
 \ul \link Facility: \u-31255?\u22269?\link0 \ul0 \i0  has this parameter deactivated and will not be cloned\par}'.
	strings := text allStringsUnder: '\link'.
	self
		assert: strings size = 1;
		assert: strings first = #(2 13 'Facility: 藩国')]

{ #category : #services }
RtfTest >> testAllStringsUnderWhenEmpty [
	| text strings |
	text := '' asText.
	text underline: ''.
	self
		shouldnt: [strings := text allStringsUnder: text underlineCommand]
		raise: MessageNotUnderstood;
		assert: strings isEmpty.
	text := '' asText.
	text underline: ' '.
	self
		shouldnt: [strings := text allStringsUnder: text underlineCommand]
		raise: MessageNotUnderstood;
		assert: strings size = 1;
		assert: strings first first = 1;
		assert: strings first second = 1;
		assert: strings first third = ' ']

{ #category : #services }
RtfTest >> testAllStringsUnderWithEnter [
	| text strings link |
	text := 'first row
	second row ' asText.
	text
		append: 'normal';
		underline: 'firstLink';
		tab;
		underline: 'secondLink'.
	strings := text allStringsUnder: text underlineCommand.
	self assert: strings size = 2.
	link := strings first.
	self
		assert: (text rawContents copyFrom: link first to: link second)
			= 'firstLink'.
	link := strings last.
	self
		assert: (text rawContents copyFrom: link first to: link second)
			= 'secondLink']

{ #category : #concatenation }
RtfTest >> testAppend [
	| default red green count sum |
	default := Rtf new instVarNamed: 'colors'.
	red := Rtf new setCharColor: Color red; nextPutAll: 'red'.
	green := Rtf new setCharColor: Color green; nextPutAll: 'green'.
	self
		assert: ((red instVarNamed: 'colors') equalsTo: (default
			copyWith: Color red)).
	self
		assert: ((green instVarNamed: 'colors')
			equalsTo: (default copyWith: Color green)).
	count := 0.
	red commandsDo: [:cmd :arg :i | 
		cmd = 'cf' ifTrue: [
			count := count + 1.
			self assert: (#('1' '2') includes: arg)]].
	self assert: count = 2.
	sum := red append: green.
	self
		assert: ((sum instVarNamed: 'colors')
			equalsTo: default , {Color red. Color green})]

{ #category : #all }
RtfTest >> testBold [
	| rtf |
	rtf := Rtf new.
	rtf bold; nextPutAll: 'Leandro'.
	self assert: rtf isBold.
	rtf bold: 'Mario'.
	self deny: rtf isBold.
	self assert: rtf emphasis isEmpty]

{ #category : #all }
RtfTest >> testEmpty [
	| text |
	text := Rtf with: ''.
	self assert: text isEmpty.
	self deny: text notEmpty.
	self assert: text rawContents = ''.
	text
		bold;
		italic;
		plain;
		strikeout;
		strikeOutOff;
		underline;
		setCharFont: GDIFont defaultTextFont;
		setCharColor: Color red;
		setTabStops: (4 to: 100 by: 5).
	self assert: text isEmpty.
	self deny: text notEmpty.
	self assert: text rawContents = ''.
	self deny: text formattedContents isEmpty.
	self assert: text isText]

{ #category : #all }
RtfTest >> testItalic [
	| rtf |
	rtf := Rtf new.
	rtf italic; nextPutAll: 'Leandro'.
	self assert: rtf isItalic.
	rtf bold.
	self assert: rtf isItalic]

{ #category : #all }
RtfTest >> testMappedCommands [
	| rtf |
	rtf := '{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 Trebuchet MS;}}
{\colortbl ;\red0\green128\blue128;}
\viewkind4\uc1\pard\cf1\lang11274\f0\fs22\u191?a
\par }'.
	self assert: rtf unformatted = '¿a']

{ #category : #services }
RtfTest >> testPlainContents [
	| text |
	text := '' asText.
	self assert: text plainContents = ''.
	text := '' asText bold: 'Hello'; append: ' World'.
	self assert: text plainContents = 'Hello World'.
	text := 'Hello
	World' asText.
	self assert: text plainContents = 'Hello
	World'.
	text := 'Hello
	World
	' asText.
	self assert: text plainContents = 'Hello
	World
	']

{ #category : #services }
RtfTest >> testRemoveLinks [
	| rtf |
	rtf := '' asText link: 'Smalltalk'.
	rtf removeLinks.
	self
		deny: (rtf formattedContents includesString: 'link');
		deny: (rtf formattedContents includesString: 'ul')]

{ #category : #services }
RtfTest >> testReplaceAtWith01 [
	| text |
	text := 'normal' asText.
	text
		italic: 'italic';
		append: ' ';
		bold: 'bold'.
	text replace: 'italic' at: 7 with: 'ITALIC'.
	self assert: text plainContents = 'normalITALIC bold'.
	text replace: 'bold' at: 14 with: 'BOLD'.
	self assert: text plainContents = 'normalITALIC BOLD'.
	self
		should: [text replace: 'ITALIC BOLD' at: 7 with: 'replaced span']
		raise: Error]

{ #category : #services }
RtfTest >> testReplaceAtWith02 [
	| text |
	text := 'normal ' asText.
	text
		italic: 'ita' , 16r2716 asCharacter asString , 'lic';
		append: ' ';
		bold: 'bold'.
	text
		replace: 'ita' , 16r2716 asCharacter asString , 'lic'
		at: 8
		with: 'ITA+LIC'.
	self assert: text plainContents = 'normal ITA+LIC bold']

{ #category : #services }
RtfTest >> testReplaceAtWith03 [
	| text |
	text := 'normal' asText.
	text
		italic: 'italic';
		append: ' ';
		bold: 'bold'.
	self should: [text replace: 'italic' at: 8 with: 'ITALIC'] raise: Error.
	self should: [text replace: 'boogus' at: 7 with: 'ITALIC'] raise: Error.
	self
		should: [text replace: 'italic bold' at: 7 with: 'replaced span']
		raise: Error]

{ #category : #services }
RtfTest >> testReplaceAtWith04 [
	| rtf plain |
	rtf := Rtf
		on: '{\urtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 DejaVu Sans Mono;}}
{\colortbl ;\red64\green64\blue64;\red0\green0\blue250;\red0\green0\blue128;\red0\green128\blue0;}
{\*\generator Msftedit 5.41.21.2510;}\viewkind4\uc1\pard\tx300\tx600\tx900\tx1200\tx1500\tx1800\tx2100\tx2400\tx2700\tx3000\tx3300\tx3600\tx3900\tx4200\tx4500\tx4800\tx5100\tx5400\tx5700\tx6000\tx6300\tx6600\tx6900\tx7200\tx7500\tx7800\tx8100\tx8400\tx8700\tx9000\tx9300\tx9600\cf1\lang1033\b\f0\fs28 test\b0\par
\tab | \cf2 var\cf1  |\par 
\tab\cf2 var\cf1  := \cf3 testSelector\cf1  , \cf4 ''XXX''\cf1 .\par
\tab ^\cf2 var\par
}'.
	plain := rtf plainContents.
	self
		assert: (plain includesString: 'var');
		deny: (plain includesString: 'varx').
	rtf replace: 'var' at: 16 with: 'varx'.
	plain := rtf plainContents.
	self assert: (plain includesString: 'varx')]

{ #category : #services }
RtfTest >> testReplaceCommand [
	| rtf |
	rtf := '' asText link: 'Smalltalk'.
	rtf replaceCommand: '\link' with: '\b'.
	self
		deny: (rtf formattedContents includesString: '\link');
		assert: (rtf formattedContents includesString: '\b ');
		assert: (rtf formattedContents includesString: '\b0')]

{ #category : #services }
RtfTest >> testReplaceLinksWithItalics [
	| rtf |
	rtf := '' asText link: 'Smalltalk'.
	rtf replaceLinksWithItalics.
	self
		deny: (rtf formattedContents includesString: '\link ');
		deny: (rtf formattedContents includesString: '\link0');
		deny: (rtf formattedContents includesString: '\ul ');
		deny: (rtf formattedContents includesString: '\ul0');
		assert: (rtf formattedContents includesString: '\i ');
		assert: (rtf formattedContents includesString: '\i0')]

{ #category : #all }
RtfTest >> testRichEditBold [
	| rtf |
	rtf := Rtf new.
	rtf bold: '='.
	self
		assert: (rtf contents contents occurrencesOf: $=) = 1
		description: 'Non-alphanumeric character duplication']

{ #category : #concatenation }
RtfTest >> testShiftColors [
	| default rtf colors copy rtf2 colors2 copy2 count |
	default := Rtf new instVarNamed: 'colors'.
	rtf := Rtf new setCharColor: Color red; nextPutAll: 'Smalltalk '.
	colors := rtf instVarNamed: 'colors'.
	copy := rtf copy shiftColors: colors.
	self assert: copy privateContents = rtf privateContents.
	rtf2 := rtf copy setCharColor: Color green; nextPutAll: 'is great'.
	colors2 := rtf2 instVarNamed: 'colors'.
	copy2 := rtf2 copy shiftColors: colors2.
	count := 0.
	copy2 commandsDo: [:cmd :arg :i | 
		cmd = 'cf' ifTrue: [
			count := count + 1.
			self assert: arg = count asString]].
	self assert: count = (default size + 2)]

{ #category : #concatenation }
RtfTest >> testShiftFonts [
	| font1 font2 rtf fonts copy rtf2 fonts2 copy2 count |
	font1 := GDIFont face: 'Arial' size: 12.
	font2 := GDIFont face: 'Courier New' size: 16.
	rtf := Rtf new setCharFont: font1; nextPutAll: 'Smalltalk '.
	fonts := rtf instVarNamed: 'fonts'.
	copy := rtf copy shiftFonts: fonts.
	self assert: copy privateContents = rtf privateContents.
	rtf2 := rtf copy setCharFont: font2; nextPutAll: 'is great'.
	fonts2 := rtf2 instVarNamed: 'fonts'.
	copy2 := rtf2 copy shiftFonts: fonts2.
	count := 0.
	copy2 commandsDo: [:cmd :arg :i | 
		cmd = 'f' ifTrue: [
			count := count + 1.
			self assert: arg = count asString]].
	self assert: count = 2]

{ #category : #all }
RtfTest >> testSub [
	| rtf |
	rtf := Rtf new.
	rtf bold; nextPutAll: 'boldText'.
	self assert: rtf isBold.
	self assert: rtf emphasis notEmpty.
	rtf nextPutAll: 'y = x'; sub: '2'.
	self deny: rtf isSub.
	self assert: rtf emphasis isEmpty.
	rtf sub.
	self assert: rtf isSub.
	self assert: rtf emphasis notEmpty]

{ #category : #all }
RtfTest >> testSuper [
	| rtf |
	rtf := Rtf new.
	rtf bold; nextPutAll: 'boldText'.
	self assert: rtf isBold.
	self assert: rtf emphasis notEmpty.
	rtf nextPutAll: 'y = x'; super: '2'.
	self deny: rtf isSuper.
	self assert: rtf emphasis isEmpty.
	rtf super.
	self assert: rtf isSuper.
	self assert: rtf emphasis notEmpty]

{ #category : #all }
RtfTest >> testSuperSub [
	| rtf |
	rtf := Rtf new.
	rtf super.
	self assert: rtf isSuper.
	self deny: rtf isSub.
	rtf sub.
	self assert: rtf isSub.
	self deny: rtf isSuper]

{ #category : #services }
RtfTest >> testTP17745 [
	| string |
	string := '{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fprq2\fcharset0 Franklin Gothic Book;}{\f1\fnil\fcharset2 Symbol;}}
\viewkind4\uc1\pard{\pntext\f1\''B7\tab}{\*\pn\pnlvlblt\pnf1\pnindent0{\pntxtb\''B7}}\qc\lang1033\f0\fs26 Hello\par
}'.
	self assert: string unformatted = 'Hello']

{ #category : #services }
RtfTest >> testTP21115 [
	| rtf strings |
	rtf := '' asText.
	rtf link: '{M'.
	strings := rtf allStringsUnder: '\link'.
	self assert: strings size = 1; assert: strings anyone last = '{M']

{ #category : #services }
RtfTest >> testTP21115B [
	| rtf strings |
	rtf := '' asText.
	rtf link: '¿M'.
	strings := rtf allStringsUnder: '\link'.
	self
		assert: strings size = 1;
		assert: strings anyone last = '¿M'.
	rtf := '' asText.
	rtf link: '¿M'.
	strings := rtf allStringsUnder: '\link'.
	self
		assert: strings size = 1;
		assert: strings anyone last = '¿M']

{ #category : #concatenation }
RtfTest >> testTP28986A [
	| source info text |
	source := 't
	^(1 \' , ' 1) m'.
	info := Compiler compile: source in: self class.
	text := info ast format.
	text formattedContents unformatted = source]

{ #category : #all }
RtfTest >> testTP43054 [
	| strings chinese urtf |
	chinese := 'Facility: 藩国'.
	urtf := '' asText link: chinese.
	strings := RtfFormattedTextFinder allStringsUnder: '\link' in: urtf.
	self assert: strings anyone third = chinese]

{ #category : #services }
RtfTest >> testUnformattedBullets [
	| string |
	string := '{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fprq2\fcharset0 Franklin Gothic Book;}{\f1\fnil\fcharset2 Symbol;}}
\viewkind4\uc1\pard{\pntext\f1\''B7\tab}{\*\pn\pnlvlblt\pnf1\pnindent0{\pntxtb\''B7}}\qc\lang1033\f0\fs26 Hello\par
}'.
	#testTP17745.
	self assert: string unformatted = 'Hello']

{ #category : #services }
RtfTest >> testUnformattedWithCRs [
	| text |
	text := '' asText.
	self assert: text formattedContents unformatted = ''.
	text := '' asText bold: 'Hello'; append: ' World'.
	self assert: text formattedContents unformatted = 'Hello World'.
	text := 'Hello
	World' asText.
	self assert: text formattedContents unformatted = 'Hello
	World'.
	text := 'Hello
	World
	' asText.
	self assert: text formattedContents unformatted = 'Hello
	World
	']

{ #category : #all }
RtfTest >> testWriteToFile [
	| rtf filename f doc word |
	#testTP16641.
	rtf := Rtf new.
	rtf italic: 'testTP16641'; cr; nextPutAll: 'second line'.
	filename := Directory scratchDir \ 'TP16641.rtf'.
	f := filename asFilename newFile.
	[f nextPutAll: rtf formattedContents] ensure: [f close].
	word := Smalltalk at: #WordApplication ifPresent: [:cls | cls current].
	word isNil ifTrue: [^self].
	doc := word documents open: filename.
	[doc range copyToClipboard] ensure: [doc close].
	self
		assert: Clipboard getString withLineBreaks trimBlanks
			= rtf plainContents withLineBreaks]

{ #category : #all }
RtfTest >> testWriting [
	| text stream |
	text := Rtf with: 'something'.
	self assert: text asString = 'something'.
	text
		cr;
		bold;
		nextPutAll: 'something more';
		plain.
	self assert: text asString lines size = 2.
	text tab; underline; nextPutAll: 'after tab'.
	stream := text asString readStream.
	self assert: stream nextLine = 'something'.
	self assert: (stream upTo: 9 asCharacter) = 'something more'.
	self assert: stream upToEnd = 'after tab']

{ #category : #all }
RtfTest >> testWriting2 [
	| text string |
	string := 8593 asCharacter asString , 'and' , 8592 asCharacter asString
		, ' {stuff}
Second pharagraph'.
	text := Rtf with: string.
	self assert: text asString = string.
	self
		assert: text privateContents
			= (Rtf new privateContents , '↑and← \{stuff\}\par Second pharagraph')]

