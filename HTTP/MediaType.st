"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MediaType,
	#superclass : #Object,
	#instVars : [
		'type',
		'tree',
		'subtype',
		'suffix',
		'parameters'
	],
	#category : #HTTP
}

{ #category : #'instance creation' }
MediaType class >> binary [
	^self fromString: 'application/octet-stream']

{ #category : #'instance creation' }
MediaType class >> form [
	^self fromString: 'application/x-www-form-urlencoded']

{ #category : #'instance creation' }
MediaType class >> fromString: aString [
	^MediaTypeParser current parse: aString onError: []]

{ #category : #'instance creation' }
MediaType class >> gif [
	^self fromString: 'image/gif']

{ #category : #'instance creation' }
MediaType class >> html [
	^self fromString: 'text/html']

{ #category : #'instance creation' }
MediaType class >> jpeg [
	^self fromString: 'image/jpeg']

{ #category : #'instance creation' }
MediaType class >> json [
	^self fromString: 'application/json']

{ #category : #'instance creation' }
MediaType class >> multipart [
	^self fromString: 'multipart/form-data']

{ #category : #'instance creation' }
MediaType class >> png [
	^self fromString: 'image/png']

{ #category : #'instance creation' }
MediaType class >> text [
	^self fromString: 'text/plain']

{ #category : #'instance creation' }
MediaType class >> xml [
	^self fromString: 'application/xml']

{ #category : #comparing }
MediaType >> = aMediaType [
	self class = aMediaType class ifFalse: [^false].
	^type = aMediaType type
		and: [tree = aMediaType tree]
		and: [subtype = aMediaType subtype]
		and: [suffix = aMediaType suffix]
		and: [parameters = aMediaType parameters]]

{ #category : #services }
MediaType >> charset [
	^self parametersAt: 'charset']

{ #category : #services }
MediaType >> charset: aString [
	self supportsCharset ifTrue: [self parametersAt: 'charset' put: aString]]

{ #category : #comparing }
MediaType >> hash [
	^type hashWith: tree with: subtype with: suffix with: parameters]

{ #category : #testing }
MediaType >> isBinary [
	^subtype = 'octet-stream']

{ #category : #testing }
MediaType >> isForm [
	^subtype = 'form-data']

{ #category : #testing }
MediaType >> isGif [
	^subtype = 'gif']

{ #category : #testing }
MediaType >> isHtml [
	^subtype = 'html']

{ #category : #testing }
MediaType >> isImage [
	^type = 'image']

{ #category : #testing }
MediaType >> isJpeg [
	^subtype = 'jpeg']

{ #category : #testing }
MediaType >> isJson [
	^subtype = 'json']

{ #category : #testing }
MediaType >> isMultipart [
	^type = 'multipart']

{ #category : #testing }
MediaType >> isPng [
	^subtype = 'png']

{ #category : #testing }
MediaType >> isText [
	^type = 'text' and: [subtype = 'plain']]

{ #category : #testing }
MediaType >> isUrlEncodedForm [
	^subtype = 'x-www-form-urlencoded']

{ #category : #testing }
MediaType >> isXml [
	^subtype = 'xml']

{ #category : #testing }
MediaType >> matches: aMediaType [
	^(aMediaType type = '*' or: [aMediaType type = self type])
		and: [aMediaType subtype = '*' or: [aMediaType subtype = self subtype]]]

{ #category : #accessing }
MediaType >> parameters [
	^parameters]

{ #category : #accessing }
MediaType >> parameters: aCollection [
	parameters := aCollection]

{ #category : #accessing }
MediaType >> parametersAt: attribute [
	parameters isNil ifTrue: [^nil].
	^parameters valueAt: attribute]

{ #category : #accessing }
MediaType >> parametersAt: attribute put: value [
	parameters isNil ifTrue: [parameters := Dictionary new].
	parameters at: attribute put: value]

{ #category : #printing }
MediaType >> printOn: aStream [
	type isNil ifTrue: [^super printOn: aStream].
	aStream nextPutAll: type; nextPut: $/.
	tree notNil ifTrue: [aStream nextPutAll: tree; nextPut: $.].
	aStream nextPutAll: subtype.
	suffix notNil ifTrue: [aStream nextPut: $+; nextPutAll: suffix].
	parameters notNil ifTrue: [
		parameters keysAndValuesDo: [:attribute :value | 
			aStream
				nextPutAll: '; ';
				nextPutAll: attribute;
				nextPut: $=;
				nextPutAll: value]]]

{ #category : #accessing }
MediaType >> subtype [
	^subtype]

{ #category : #accessing }
MediaType >> subtype: aString [
	subtype := aString]

{ #category : #accessing }
MediaType >> suffix [
	^suffix]

{ #category : #accessing }
MediaType >> suffix: aString [
	suffix := aString]

{ #category : #testing }
MediaType >> supportsCharset [
	type = 'text' ifTrue: [^true].
	^self isXml or: [self isJson] or: [self isUrlEncodedForm]]

{ #category : #accessing }
MediaType >> tree [
	^tree]

{ #category : #accessing }
MediaType >> tree: aString [
	tree := aString]

{ #category : #accessing }
MediaType >> type [
	^type]

{ #category : #accessing }
MediaType >> type: aString [
	type := aString]

{ #category : #services }
MediaType >> utf8 [
	self charset: 'utf-8']

