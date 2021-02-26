"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusError,
	#superclass : #Error,
	#category : #GDIPlus
}

{ #category : #accessing }
GDIPlusError class >> codeNames [
	^#(" 'Ok'"
	'GenericError'
	'InvalidParameter'
	'OutOfMemory'
	'ObjectBusy'
	'InsufficientBuffer'
	'NotImplemented'
	'Win32Error'
	'WrongState'
	'Aborted'
	'FileNotFound'
	'ValueOverflow'
	'AccessDenied'
	'UnknownImageFormat'
	'FontFamilyNotFound'
	'FontStyleNotFound'
	'NotTrueTypeFont'
	'UnsupportedGdiplusVersion'
	'GdiplusNotInitialized'
	'PropertyNotFound'
	'PropertyNotSupported'
	'ProfileNotFound'
)]

{ #category : #accessing }
GDIPlusError class >> descriptionForStatus: anInteger [
	| description |
	description := self descriptions
		at: anInteger
		ifAbsent: [anInteger asString].
	^'GDI+ Error: ' , description]

{ #category : #accessing }
GDIPlusError class >> descriptionForStatus: anInteger type: aClass [
	| description type |
	description := self descriptions
		at: anInteger
		ifAbsent: [anInteger asString].
	type := aClass name trimPrefix: 'GDIPlus'.
	^'GDI+ error on ' , type , ': ' , description]

{ #category : #accessing }
GDIPlusError class >> descriptions [
	^#(
		'Indicates that there was an error on the method call, which is identified as something other than those defined by the elements of GDI+ Status enumeration.'
		'One of the arguments passed to the method was not valid.'
		'The operating system is out of memory and could not allocate memory to process the method call. Remark: this error is also used for other constructor failures'
		'One of the arguments specified in the application programming interface (API) call is already in use in another thread.'
		'A buffer specified as an argument in the API call is not large enough to hold the data to be received.'
		'The method is not implemented.'
		'The method generated a Microsoft Win32 error.'
		'The object is in an invalid state to satisfy the API call.'
		'The method was aborted.'
		'The specified image file or metafile cannot be found.'
		'The method performed an arithmetic operation that produced a numeric overflow.'
		'A write operation is not allowed on the specified file.'
		'The specified image file format is not known'
		'The specified font family cannot be found. Either the font family name is incorrect or the font family is not installed.'
		'The specified style is not available for the specified font family.'
		'The font retrieved from an HDC or LOGFONT is not a TrueType font and cannot be used with GDI+.'
		'The version of GDI+ that is installed on the system is incompatible with the version with which the application was compiled.'
		'The GDI+API is not in an initialized state. Initialize GDI+ by calling GdiplusStartup.'
		'The specified property does not exist in the image.'
		'The specified property is not supported by the format of the image and, therefore, cannot be set.'
		'The color profile required to save an image in CMYK format was not found.')]

{ #category : #private }
GDIPlusError class >> signalStatus: anInteger type: aClass [
	| description |
	description := self descriptionForStatus: anInteger type: aClass.
	^self new description: description; signal]

