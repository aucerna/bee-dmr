"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusStringFormat,
	#superclass : #GDIPlusObject,
	#instVars : [
		'alignment',
		'lineAlignment'
	],
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusStringFormat class >> centered [
	^self new centered]

{ #category : #'instance creation' }
GDIPlusStringFormat class >> format: stringFormatFlags [
	^self format: stringFormatFlags language: nil]

{ #category : #'instance creation' }
GDIPlusStringFormat class >> format: stringFormatFlags language: languageCode [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateStringFormat: stringFormatFlags asParameter
		language: languageCode asParameter
		format: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusStringFormat class >> genericDefault [
	| handle status |
	handle := ExternalPointer external.
	status := self dll GdipStringFormatGetGenericDefault: handle asParameter.
	self checkStatus: status.
	^self fromHandle: handle makeLocal]

{ #category : #'instance creation' }
GDIPlusStringFormat class >> genericTypographic [
	| handle status |
	handle := ExternalPointer external.
	status := self dll
		GdipStringFormatGetGenericTypographic: handle asParameter.
	self checkStatus: status.
	^self fromHandle: handle makeLocal]

{ #category : #'instance creation' }
GDIPlusStringFormat class >> new [
	^self format: nil]

{ #category : #aligning }
GDIPlusStringFormat >> alignment [
	| long |
	alignment isNil ifTrue: [
		long := ExternalInt32 external.
		status := self dll
			GdipGetStringFormatAlign: self asParameter
			align: long asParameter.
		self checkStatus.
		alignment := long makeInteger].
	^alignment]

{ #category : #aligning }
GDIPlusStringFormat >> alignment: anInteger [
	alignment = anInteger ifTrue: [^self].
	status := self dll
		GdipSetStringFormatAlign: self asParameter
		align: anInteger asParameter.
	self checkStatus.
	alignment := anInteger]

{ #category : #private }
GDIPlusStringFormat >> basicRelease [
	status := self dll GdipDeleteStringFormat: self asParameter.
	self checkStatus]

{ #category : #aligning }
GDIPlusStringFormat >> centered [
	self
		alignment: StringAlignmentCenter;
		lineAlignment: StringAlignmentCenter]

{ #category : #copying }
GDIPlusStringFormat >> clone [
	| pointer |
	pointer := ExternalPointer external.
	status := self dll
		GdipCloneStringFormat: self asParameter
		newFormat: pointer asParameter.
	self checkStatus.
	^self class fromHandle: pointer makeLocal]

{ #category : #substitution }
GDIPlusStringFormat >> digitSubstitution: languageCode method: stringDigitSubstitute [
	status := self dll
		GdipSetStringFormatDigitSubstitution: self asParameter
		language: languageCode asParameter
		substitute: stringDigitSubstitute asParameter.
	self checkStatus]

{ #category : #substitution }
GDIPlusStringFormat >> digitSubstitutionLanguage [
	| language |
	language := ExternalInt16 external.
	status := self dll
		GdipGetStringFormatDigitSubstitution: self asParameter
		language: language asParameter
		substitute: 0.
	self checkStatus.
	^language makeUnsignedInteger]

{ #category : #substitution }
GDIPlusStringFormat >> digitSubstitutionMethod [
	| method |
	method := ExternalInt32 external.
	status := self dll
		GdipGetStringFormatDigitSubstitution: self asParameter
		language: 0
		substitute: method asParameter.
	self checkStatus.
	^method makeInteger]

{ #category : #accessing }
GDIPlusStringFormat >> formatFlags [
	| flags |
	flags := ExternalInt32 external.
	status := self dll
		GdipGetStringFormatFlags: self asParameter
		flags: flags asParameter.
	self checkStatus.
	^flags makeInteger]

{ #category : #accessing }
GDIPlusStringFormat >> formatFlags: stringFormatFlags [
	status := self dll
		GdipSetStringFormatFlags: self asParameter
		flags: stringFormatFlags asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusStringFormat >> hotkeyPrefix [
	| result |
	result := ExternalInt32 external.
	status := self dll
		GdipGetStringFormatHotkeyPrefix: self asParameter
		hotkeyPrefix: result asParameter.
	self checkStatus.
	^result makeInteger]

{ #category : #accessing }
GDIPlusStringFormat >> hotkeyPrefix: hotkeyPrefix [
	status := self dll
		GdipSetStringFormatHotkeyPrefix: self asParameter
		hotkeyPrefix: hotkeyPrefix asParameter.
	self checkStatus]

{ #category : #aligning }
GDIPlusStringFormat >> lineAlignment [
	| long |
	lineAlignment isNil ifTrue: [
		long := ExternalInt32 external.
		status := self dll
			GdipGetStringFormatLineAlign: self asParameter
			align: long asParameter.
		self checkStatus.
		lineAlignment := long makeInteger].
	^lineAlignment]

{ #category : #aligning }
GDIPlusStringFormat >> lineAlignment: anInteger [
	lineAlignment = anInteger ifTrue: [^self].
	status := self dll
		GdipSetStringFormatLineAlign: self asParameter
		align: anInteger asParameter.
	self checkStatus.
	lineAlignment := anInteger]

{ #category : #accessing }
GDIPlusStringFormat >> measurableCharacterRangeCount [
	| result |
	result := ExternalInt32 external.
	status := self dll
		GdipGetStringFormatMeasurableCharacterRangeCount: self asParameter
		count: result asParameter.
	self checkStatus.
	^result makeInteger]

{ #category : #accessing }
GDIPlusStringFormat >> tabStops [
	| count tabs |
	count := self tabStopsCount.
	tabs := BufferArray externalNew: count of: ExternalFloat.
	status := self dll
		GdipGetStringFormatTabStops: self asParameter
		count: count asInteger
		firstTabOffset: 0
		tabStops: tabs asParameter.
	self checkStatus.
	^tabs makeLocal asArray collect: #asFloat]

{ #category : #accessing }
GDIPlusStringFormat >> tabStops: stopsCollection [
	| stops |
	stops := stopsCollection notNil
		ifTrue: [BufferArray externalOn: stopsCollection type: ExternalFloat].
	status := self dll
		GdipSetStringFormatTabStops: self asParameter
		firstTabOffset: 0
		count: 0
		tabStops: stops asParameter.
	self checkStatus.
	stops notNil ifTrue: [stops free]]

{ #category : #accessing }
GDIPlusStringFormat >> tabStopsCount [
	| count |
	count := ExternalInt32 external.
	status := self dll
		GdipGetStringFormatTabStopCount: self asParameter
		count: count asParameter.
	self checkStatus.
	^count makeInteger]

{ #category : #accessing }
GDIPlusStringFormat >> trimming [
	| trimming |
	trimming := ExternalInt32 external.
	status := self dll
		GdipGetStringFormatTrimming: self asParameter
		trimming: trimming asParameter.
	self checkStatus.
	^trimming makeInteger]

{ #category : #accessing }
GDIPlusStringFormat >> trimming: stringTrimming [
	status := self dll
		GdipSetStringFormatTrimming: self asParameter
		trimming: stringTrimming asParameter.
	self checkStatus]

