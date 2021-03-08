"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RtfTextExtractorTest,
	#superclass : #TestCase,
	#instVars : [
		'parser',
		'result'
	],
	#category : #'RTF\Tests'
}

{ #category : #accessing }
RtfTextExtractorTest >> parse: aString [
	result := parser parse: aString]

{ #category : #accessing }
RtfTextExtractorTest >> parse: aString production: aSymbol [
	self assert: aSymbol == #start.
	result := parser parse: aString]

{ #category : #accessing }
RtfTextExtractorTest >> parserClass [
	^RtfStringExtractor]

{ #category : #'set up' }
RtfTextExtractorTest >> setUp [
	super setUp.
	parser := self parserClass new.
	result := nil]

{ #category : #running }
RtfTextExtractorTest >> tearDown [
	super tearDown.
	result := nil]

{ #category : #tests }
RtfTextExtractorTest >> testDocument01 [
	self
		parse: '{\rtf1\ansi\deff3\adeflang1025{\fonttbl{\f0\froman\fprq2\fcharset0 Times New Roman;}{\f1\froman\fprq2\fcharset2 Symbol;}{\f2\fswiss\fprq2\fcharset0 Arial;}{\f3\froman\fprq2\fcharset0 Liberation Serif{\*\falt Times New Roman};}{\f4\fswiss\fprq2\fcharset0 Liberation Sans{\*\falt Arial};}{\f5\fnil\fprq2\fcharset0 Droid Sans Fallback;}{\f6\fnil\fprq2\fcharset0 FreeSans;}{\f7\fswiss\fprq0\fcharset128 FreeSans;}}{\colortbl;\red0\green0\blue0;\red0\green0\blue255;\red0\green255\blue255;\red0\green255\blue0;\red255\green0\blue255;\red255\green0\blue0;\red255\green255\blue0;\red255\green255\blue255;\red0\green0\blue128;\red0\green128\blue128;\red0\green128\blue0;\red128\green0\blue128;\red128\green0\blue0;\red128\green128\blue0;\red128\green128\blue128;\red192\green192\blue192;}{\stylesheet{\s0\snext0\widctlpar\hyphpar0\cf0\kerning1\dbch\af5\langfe2052\dbch\af6\afs24\alang1081\loch\f3\fs24\lang1033 Normal;}{\s15\sbasedon0\snext16\sb240\sa120\keepn\dbch\af5\dbch\af6\afs28\loch\f4\fs28 Heading;}{\s16\sbasedon0\snext16\sl288\slmult1\sb0\sa140 Text Body;}{\s17\sbasedon16\snext17\sl288\slmult1\sb0\sa140\dbch\af7 List;}{\s18\sbasedon0\snext18\sb120\sa120\noline\i\dbch\af7\afs24\ai\fs24 Caption;}{\s19\sbasedon0\snext19\noline\dbch\af7 Index;}}{\*\generator LibreOffice/5.1.2.2.0$Linux_X86_64 LibreOffice_project/10m0$Build-2}{\info{\creatim\yr2016\mo4\dy18\hr16\min27}{\revtim\yr2016\mo4\dy18\hr16\min29}{\printim\yr0\mo0\dy0\hr0\min0}}\deftab709\viewscale160{\*\pgdsctbl{\pgdsc0\pgdscuse451\pgwsxn12240\pghsxn15840\marglsxn1134\margrsxn1134\margtsxn1134\margbsxn1134\pgdscnxt0 Rtf Tests Style;}}\formshade\paperh15840\paperw12240\margl1134\margr1134\margt1134\margb1134\sectd\sbknone\sectunlocked1\pgndec\pgwsxn12240\pghsxn15840\marglsxn1134\margrsxn1134\margtsxn1134\margbsxn1134\ftnbj\ftnstart1\ftnrstcont\ftnnar\aenddoc\aftnrstcont\aftnstart1\aftnnrlc{\*\ftnsep\chftnsep}\pgndec\pard\plain \s0\widctlpar\hyphpar0\cf0\kerning1\dbch\af5\langfe2052\dbch\af6\afs24\alang1081\loch\f3\fs24\lang1033{\rtlch \ltrch\u10006\''3f}\par }'
		production: #start.
	self assert: result first codePoint = 10006]

{ #category : #tests }
RtfTextExtractorTest >> testDocument02 [
	self parse: '\rtf1\ansi' production: #start.
	self assert: result isEmpty]

{ #category : #tests }
RtfTextExtractorTest >> testDocument03 [
	self parse: '\rtf1\ansi  Some text \f1More Text' production: #start.
	self assert: result = ' Some text More Text']

{ #category : #tests }
RtfTextExtractorTest >> testDocument04 [
	self parse: '{ Some text }More Text' production: #start.
	self assert: result = ' Some text More Text'.
	self parse: '{{{{{}}}} Some text }More Text' production: #start.
	self assert: result = ' Some text More Text']

{ #category : #tests }
RtfTextExtractorTest >> testDocument05 [
	self parse: 'X-Wing\u10006?Tie Fighter' production: #start.
	self
		assert: result
			= ('X-Wing' , (Character codePoint: 10006) asString , 'Tie Fighter')]

{ #category : #tests }
RtfTextExtractorTest >> testDocument06 [
	self parse: 'X-Wing\''3ffTie Fighter' production: #start.
	self
		assert: result
			= ('X-Wing' , (Character codePoint: 16r3F) asString , 'fTie Fighter')]

{ #category : #tests }
RtfTextExtractorTest >> testDocument07 [
	self parse: 'X-Wing\parTie Fighter' production: #start.
	self assert: result = 'X-Wing
Tie Fighter']

{ #category : #tests }
RtfTextExtractorTest >> testDocument08 [
	self parse: '\{\}\\' production: #start.
	self assert: result = '{}\']

{ #category : #tests }
RtfTextExtractorTest >> testDocument09 [
	self should: [self parse: '{}}'] raise: RtfParseError.
	self should: [self parse: '}'] raise: RtfParseError.
	self should: [self parse: '{{}{}{}{{}'] raise: RtfParseError]

{ #category : #tests }
RtfTextExtractorTest >> testDocument10 [
	self shouldnt: [self parse: '\uBlah'] raise: RtfParseError.
	self shouldnt: [self parse: '\u{}'] raise: RtfParseError.
	self shouldnt: [self parse: '\u'] raise: RtfParseError.
	self should: [self parse: '\''ZZ'] raise: RtfParseError.
	self should: [self parse: '\''{}'] raise: RtfParseError.
	self should: [self parse: '\''aZ'] raise: RtfParseError.
	self should: [self parse: '\''a}'] raise: RtfParseError.
	self should: [self parse: '\'''] raise: RtfParseError.
	self should: [self parse: '\''0'] raise: RtfParseError]

{ #category : #tests }
RtfTextExtractorTest >> testDocumentB [
	| format |
	format := '{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 Segoe UI Symbol;}}
{\colortbl ;\red64\green64\blue64;\red0\green0\blue250;\red0\green0\blue128;\red128\green0\blue128;}
\viewkind4\uc1\pard\tx300\tx600\tx900\tx1200\tx1500\tx1800\tx2100\tx2400\tx2700\tx3000\tx3300\tx3600\tx3900\tx4200\tx4500\tx4800\tx5100\tx5400\tx5700\tx6000\tx6300\tx6600\tx6900\tx7200\tx7500\tx7800\tx8100\tx8400\tx8700\tx9000\tx9300\tx9600\cf1\lang1033\b\f0\fs20 plainContents\b0\par
\tab | \cf2 string\cf1  |\par
\tab\cf3 raw\cf1  isEmpty ifFalse: [^\cf3 self\cf1  rawContents].\par
\tab\cf3 reader\cf1  := \cf3 writer\cf1  readStream.\par
\tab\cf3 self\cf1  skipHeader.\par
\tab\cf2 string\cf1  := \cf4 RtfTextExtractor\cf1  new parse: \cf3 reader\cf1  upToEnd.\par
\tab ^\cf2 string\cf1  withLineBreaks\par
}
'.
	self parse: format.
	self assert: result first = $p]

{ #category : #tests }
RtfTextExtractorTest >> testTP38873c [
	| formatted |
	formatted := '{\rtf1\ansi\deff0{\fonttbl{\f0\fswiss\fcharset204{\*\fname Arial;}Arial CYR;}{\f1\fnil\fcharset0 Segoe UI Symbol;}}
{\*\generator Msftedit 5.41.21.2510;}\viewkind4\uc1\pard\lang1033\f0\fs20\''fa\''f5\''f1\''f7\f1\par
}'.
	self assert: formatted unformatted = 'ъхсч']

{ #category : #tests }
RtfTextExtractorTest >> testUnicode01 [
	self parse: '\''ab'.
	self assert: result = 16rAB asCharacter asString.
	self parse: '\u1123x'.
	self assert: result = 1123 asCharacter asString.
	self parse: '\u1123 x'.
	self assert: result = 1123 asCharacter asString.
	self parse: '\u1123 {}'.
	self assert: result = 1123 asCharacter asString.
	self parse: '\u1123{}'.
	self assert: result = 1123 asCharacter asString.
	self parse: '\uc0\u1123xy'.
	self assert: result = (1123 asCharacter asString , 'xy').
	self parse: '\uc2\u1123xy'.
	self assert: result = 1123 asCharacter asString.
	self parse: '\uc2{\u1123xy\uc0\u1123xy}\u1123xy'.
	self
		assert: result
			= (1123 asCharacter asString , 1123 asCharacter asString , 'xy'
				, 1123 asCharacter asString)]

{ #category : #tests }
RtfTextExtractorTest >> testUnicode02 [
	self parse: '{\upr{keyword ansi_text}{\*\ud{keyword Unicode_text}}}'.
	self assert: result = 'keyword Unicode_text']

{ #category : #tests }
RtfTextExtractorTest >> testUnicode03 [
	self parse: '\uc3\u1123 x\par \par'.
	self assert: result = 1123 asCharacter asString.
	self parse: '\uc3\u1123 x\blah-12 \par x'.
	self assert: result = (1123 asCharacter asString , 'x').
	self parse: '\uc4\u1123 \\\{\}\~'.
	self assert: result = 1123 asCharacter asString]

