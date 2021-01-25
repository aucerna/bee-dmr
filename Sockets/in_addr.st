"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #in_addr,
	#superclass : #SocketStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #'instance creation' }
in_addr class >> any [
	^self fromInteger: INADDR_ANY]

{ #category : #accessing }
in_addr class >> def [
	^<def>
		typedef struct in_addr {
			union  {
				struct  {
					u_char s_b1; // 0
					u_char s_b2; // 1
					u_char s_b3; // 2
					u_char s_b4; // 3
				}; // sizeInBytes = 4 ; // 0
				struct  {
					u_short s_w1; // 0
					u_short s_w2; // 2
				}; // sizeInBytes = 4 ; // 0
				u_long S_addr; // 0
			}; // sizeInBytes = 4 ; // 0
		} in_addr; // sizeInBytes = 4
	</def>]

{ #category : #accessing }
in_addr class >> family [
	^AF_INET]

{ #category : #'instance creation' }
in_addr class >> fromInteger: anInteger [
	^self new s_addr: anInteger]

{ #category : #'instance creation' }
in_addr class >> loopback [
	^self fromInteger: INADDR_LOOPBACK]

{ #category : #accessing }
in_addr class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
in_addr >> s_addr [
	^self uLongAtOffset: s_b1]

{ #category : #accessing }
in_addr >> S_addr [
	^self uLongAtOffset: S_addr]

{ #category : #accessing }
in_addr >> S_addr: anInteger [
	self uLongAtOffset: S_addr put: anInteger]

{ #category : #accessing }
in_addr >> s_addr: anInteger [
	self uLongAtOffset: s_b1 put: anInteger]

{ #category : #accessing }
in_addr >> s_b1 [
	^self ansiAtOffset: s_b1]

{ #category : #accessing }
in_addr >> s_b1: anInteger [
	self ansiAtOffset: s_b1 put: anInteger]

{ #category : #accessing }
in_addr >> s_b2 [
	^self ansiAtOffset: s_b2]

{ #category : #accessing }
in_addr >> s_b2: anInteger [
	self ansiAtOffset: s_b2 put: anInteger]

{ #category : #accessing }
in_addr >> s_b3 [
	^self ansiAtOffset: s_b3]

{ #category : #accessing }
in_addr >> s_b3: anInteger [
	self ansiAtOffset: s_b3 put: anInteger]

{ #category : #accessing }
in_addr >> s_b4 [
	^self ansiAtOffset: s_b4]

{ #category : #accessing }
in_addr >> s_b4: anInteger [
	self ansiAtOffset: s_b4 put: anInteger]

{ #category : #accessing }
in_addr >> s_w1 [
	^self uShortAtOffset: s_b1]

{ #category : #accessing }
in_addr >> s_w1: anInteger [
	self uShortAtOffset: s_b1 put: anInteger]

{ #category : #accessing }
in_addr >> s_w2 [
	^self uShortAtOffset: s_b3]

{ #category : #accessing }
in_addr >> s_w2: anInteger [
	self uShortAtOffset: s_b3 put: anInteger]

