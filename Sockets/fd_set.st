"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #fd_set,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #accessing }
fd_set class >> def [
	^<def>
	typedef struct fd_set {
		u_int  fd_count;
		SOCKET fd_array[FD_SETSIZE];
	} fd_set;
	</def>]

{ #category : #accessing }
fd_set class >> descriptorSize [
	^4]

{ #category : #'instance creation' }
fd_set class >> fromCollection: aCollection [
	^self new fromCollection: aCollection]

{ #category : #initialization }
fd_set class >> initializeConstants [
	"
	Fd_set initializeConstants
	"
	WindowsConstants at: 'FD_SETSIZE' put: 64]

{ #category : #accessing }
fd_set class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
fd_set class >> typedefTable [
	^Ws2_32DLL typedefTable]

{ #category : #accessing }
fd_set >> fd_array [
	| count data |
	count := 64.
	data := self bytesAtOffset: fd_array count: ExternalInt32 sizeInBytes * count.
	^BufferArray new
		type: ExternalInt32;
		count: count;
		contents: data]

{ #category : #accessing }
fd_set >> fd_array: anIntegerCollection [
	| offset delta |
	offset := fd_array.
	delta := ExternalInt32 sizeInBytes.
	1 to: FD_SETSIZE do: [:i | | elem |
		elem := anIntegerCollection at: i.
		self uLongAtOffset: offset put: elem asParameter.
		offset := offset + delta]]

{ #category : #commands }
fd_set >> fd_arrayAt: index [
	^self uLongAtOffset: 4 + (index * self class descriptorSize)]

{ #category : #commands }
fd_set >> fd_arrayAt: index put: anInteger [
	self
		uLongAtOffset: index - 1 * self class descriptorSize + 4
		put: anInteger]

{ #category : #macros }
fd_set >> fd_clr: descriptor [
	| count index |
	count := self fd_count.
	index := self indexOf: descriptor.
	index = 0 ifTrue: [^self].
	index to: count - 2 do: [:i | | next |
		next := self fd_arrayAt: i + 1.
		self fd_arrayAt: i put: next].
	self fd_count: count - 1]

{ #category : #accessing }
fd_set >> fd_count [
	^self uLongAtOffset: fd_count]

{ #category : #accessing }
fd_set >> fd_count: anInteger [
	self uLongAtOffset: fd_count put: anInteger]

{ #category : #macros }
fd_set >> fd_isset: descriptor [
	^(self indexOf: descriptor) > 0]

{ #category : #macros }
fd_set >> fd_set: descriptor [
	| count |
	count := self fd_count + 1.
	count < FD_SETSIZE ifFalse: [^self].
	self
		fd_arrayAt: count put: descriptor;
		fd_count: count]

{ #category : #macros }
fd_set >> fd_zero [
	^self fd_count: 0]

{ #category : #input }
fd_set >> fromCollection: aCollection [
	aCollection
		collect: #descriptor
		thenDo: [:socket | self fd_set: socket descriptor]]

{ #category : #private }
fd_set >> indexOf: descriptor [
	0 to: self fd_count - 1 do: [:i | | fd |
		fd := self fd_arrayAt: i.
		fd = descriptor ifTrue: [^i]].
	^0]

{ #category : #initialization }
fd_set >> initialize: anInteger [
	super initialize: anInteger.
	self fd_zero]

