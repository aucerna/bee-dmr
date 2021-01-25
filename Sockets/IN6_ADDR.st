"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #IN6_ADDR,
	#superclass : #SocketStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #'instance creation' }
IN6_ADDR class >> any [
	^self new]

{ #category : #accessing }
IN6_ADDR class >> def [
	^<def>
	typedef struct in6_addr {
		union {
			u_char  Byte[16];
			u_short Word[8];
		};
	} IN6_ADDR, *PIN6_ADDR, FAR *LPIN6_ADDR;
	</def>]

{ #category : #accessing }
IN6_ADDR class >> family [
	^AF_INET6]

{ #category : #'instance creation' }
IN6_ADDR class >> loopback [
	^self new byteAtOffset: self sizeInBytes - 1 put: 1]

{ #category : #accessing }
IN6_ADDR class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
IN6_ADDR >> Byte [
	^self bytesAtOffset: Byte count: 16]

{ #category : #accessing }
IN6_ADDR >> Byte: aByteArray [
	| offset delta |
	offset := Byte.
	delta := 1.
	1 to: 16 do: [:i | | elem |
		elem := aByteArray at: i.
		self ansiAtOffset: offset put: elem asParameter.
		offset := offset + delta]]

{ #category : #accessing }
IN6_ADDR >> Word [
	^(0 to: 15 by: 2) collect: [:offset | self uShortAtOffset: offset]]

{ #category : #accessing }
IN6_ADDR >> Word: anIntegerCollection [
	| offset delta |
	offset := Word.
	delta := 2.
	1 to: 8 do: [:i | | elem |
		elem := anIntegerCollection at: i.
		self uShortAtOffset: offset put: elem asParameter.
		offset := offset + delta]]

