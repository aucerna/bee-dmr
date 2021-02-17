"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIFontTest,
	#superclass : #TestCase,
	#category : #GDI
}

{ #category : #width }
GDIFontTest >> testHyphenCharWidth [
	| font aSize size |
	font := GDIFont face: 'Tahoma' size: 11.
	aSize := font widthOfCharacter: $A.
	size := font widthOfCharacter: $—.
	self assert: size > aSize.
	font := GDIFont face: 'Segoe UI' size: 11.
	aSize := font widthOfCharacter: $A.
	size := font widthOfCharacter: $—.
	self assert: size > aSize]

{ #category : #all }
GDIFontTest >> testIconFont [
	| font |
	font := VirtualScreen current iconFont.
	self assert: font logicalFont isValid]

{ #category : #all }
GDIFontTest >> testMenuFont [
	| struct font |
	struct := VirtualScreen current getNonClientStruct.
	font := VirtualScreen current menuFont.
	self assert: font logicalFont contents = struct menuFont contents]

{ #category : #all }
GDIFontTest >> testScaling [
	| font increased decreased size |
	#testTP44285.
	4 to: 10 do: [:ps | 
		font := GDIFont arial: ps.
		increased := font increased.
		self assert: increased pointSize = (ps + 1).
		decreased := increased decreased.
		self assert: decreased pointSize = ps].
	11 to: 26 do: [:ps | 
		font := GDIFont arial: ps.
		increased := font increased.
		self assert: increased pointSize = (ps + 2).
		decreased := increased decreased.
		self assert: decreased pointSize = ps].
	#(28 36 48 72 80) withNextDo: [:ps1 :ps2 | 
		font := GDIFont arial: ps1.
		increased := font increased.
		self
			assert: increased pointSize = ps2;
			assert: increased decreased pointSize = ps1].
	size := (80 to: 1630) atRandom.
	font := GDIFont arial: size.
	increased := font increased.
	self
		assert: increased pointSize = (size + 10);
		assert: increased decreased pointSize = size]

{ #category : #'fit into' }
GDIFontTest >> testTP30150 [
	| font w fitString width |
	font := GDIFont arial: 10.
	w := font widthOfCharacter: $1.
	'1234567890'
		do: [:c | (font widthOfCharacter: c) ~= w ifTrue: [self
			precondition: false]].
	fitString := font
		fit: '12345678901234567890'
		to: 40 @ font height
		with: '...'.
	width := font widthOfString: fitString.
	self
		assert: width <= 40;
		assert: width + w > 40]

{ #category : #'fit into' }
GDIFontTest >> testTP30150b [
	| font w fitString writer lines |
	font := GDIFont arial: 10.
	w := font widthOfCharacter: $1.
	'1234567890'
		do: [:c | (font widthOfCharacter: c) ~= w ifTrue: [self
			precondition: false]].
	fitString := font
		fit: '123456789012345678901234567890'
		to: 40 @ 1000
		with: '...'.
	writer := String new writeStream.
	lines := fitString lines.
	lines withIndexDo: [:line :i | | width |
		width := font widthOfString: line.
		self assert: width <= 40.
		i = lines size ifFalse: [self assert: width + w > 40].
		writer nextPutAll: line].
	self assert: writer contents = '123456789012345678901234567890']

{ #category : #'fit into' }
GDIFontTest >> testTP30150c [
	| font fitString n writer lines |
	font := GDIFont arial: 12.
	fitString := font
		fit: 'aabbccddeeffgghhiijjkkllmmnnooppqqrrssttuuvvwwxxyyzz'
		to: 60 @ 1000
		with: '...'.
	n := 0.
	writer := String new writeStream.
	lines := fitString lines.
	lines withIndexDo: [:line :i | | width |
		n := n + line size.
		width := font widthOfString: line.
		self assert: width <= 60.
		i = lines size ifFalse: [| char w |
			char := 'aabbccddeeffgghhiijjkkllmmnnooppqqrrssttuuvvwwxxyyzz' at: n + 1.
			w := font widthOfCharacter: char.
			self assert: width + w > 60].
		writer nextPutAll: line].
	self
		assert: writer contents
			= 'aabbccddeeffgghhiijjkkllmmnnooppqqrrssttuuvvwwxxyyzz']

{ #category : #'fit into' }
GDIFontTest >> testTP30150d [
	| font fitString writer lines string |
	font := GDIFont arial: 12.
	fitString := font
		fit: 'a ab bcc ddee ffggh hiijj kkllmm nnooppq qrrssttu uvvwwxxyy zz'
		to: 60 @ 1000
		with: '...'.
	writer := String new writeStream.
	lines := fitString lines.
	lines do: [:line | | width |
		width := font widthOfString: line.
		self assert: width <= 60.
		writer nextPutAll: line].
	string := writer contents.
	self
		assert: string size
			<= 'a ab bcc ddee ffggh hiijj kkllmm nnooppq qrrssttu uvvwwxxyy zz' size;
		assert: string withoutBlanks
			= 'a ab bcc ddee ffggh hiijj kkllmm nnooppq qrrssttu uvvwwxxyy zz' withoutBlanks]

{ #category : #'fit into' }
GDIFontTest >> testTP30150e [
	| font fitString lines n ellipsisWidth |
	font := GDIFont arial: 12.
	fitString := font
		fit: 'a ab bcc ddee ffggh hiijj kkllmm nnooppq qrrssttu uvvwwxxyy zz'
		to: 60 @ 1000
		with: '...'.
	lines := fitString lines.
	n := lines size // 2.
	self precondition: n > 0.
	ellipsisWidth := font widthOfString: '...'.
	self precondition: ellipsisWidth < 60.
	fitString := font
		fit: 'a ab bcc ddee ffggh hiijj kkllmm nnooppq qrrssttu uvvwwxxyy zz'
		to: 60 @ (font height * n)
		with: '...'.
	self assert: (fitString endsWith: '...')]

{ #category : #all }
GDIFontTest >> testTP38108 [
	self
		assert: (GDIFont defaultTextFont fastStringWidth: 590 asCharacter asString)
			> 0]

{ #category : #'fit into' }
GDIFontTest >> testTP56396 [
	| font dc w |
	font := GDIFont arial: 10.
	dc := DeviceContext forScreen.
	font deviceContext: dc.
	self assert: font deviceContext == dc.
	w := font charWidth.
	dc release.
	font := font fileOutSurrogate fileInActivate.
	self assert: font charWidth = w]

{ #category : #all }
GDIFontTest >> testTrimStringTo [
	| s w |
	s := GDIFont defaultTextFont trimString: '' to: 0.
	self assert: s isEmpty.
	s := GDIFont defaultTextFont trimString: '' to: 10.
	self assert: s isEmpty.
	w := GDIFont defaultTextFont widthOfString: 'Adrian'.
	s := GDIFont defaultTextFont trimString: 'Adrian' to: w.
	self assert: s = 'Adrian'.
	s := GDIFont defaultTextFont trimString: 'Adrian' to: w + 1.
	self assert: s = 'Adrian'.
	s := GDIFont defaultTextFont trimString: 'Adrian' to: w - 1.
	self assert: s = 'Adri…'.
	s := GDIFont defaultTextFont trimString: 'Adrian' to: 1.
	self assert: s = '…'.
	s := GDIFont defaultTextFont trimString: 'Adrian' to: 0.
	self assert: s isEmpty]

