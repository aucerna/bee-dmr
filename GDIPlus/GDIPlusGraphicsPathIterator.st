"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusGraphicsPathIterator,
	#superclass : #GDIPlusObject,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusGraphicsPathIterator class >> fromPath: aGDIPlusGraphicsPath [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreatePathIter: aGDIPlusGraphicsPath asParameter
		path: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #private }
GDIPlusGraphicsPathIterator >> basicRelease [
	status := self dll GdipDeletePathIter: self asParameter.
	self checkStatus]

{ #category : #copying }
GDIPlusGraphicsPathIterator >> copyData: aPointArray
types: typeArray
from: startIndex
to: endIndex [
	| points types copied |
	aPointArray size = typeArray size
		ifFalse: [^self error: 'Invalid argument'].
	aPointArray >= (endIndex - startIndex + 1)
		ifFalse: [^self error: 'Invalid argument'].
	points := MemoryBuffer external: aPointArray * PointF sizeInBytes.
	types := typeArray size externalBytes.
	copied := ExternalInt32 external.
	status := self dll
		GdipPathIterCopyData: self asParameter
		resultCount: copied asParameter
		points: points asParameter
		types: types asParameter
		startIndex: startIndex
		endIndex: endIndex.
	self checkStatus.
	copied := copied makeInteger.
	1 to: copied size do: [:idx | | bytes point type |
		bytes := points makeLocal bytesAtOffset: idx - 1 * 8 count: 8.
		point := (PointF fromBytes: bytes) asPoint.
		aPointArray at: idx put: point.
		type := types makeLocal at: idx.
		typeArray at: idx put: type].
	^copied]

{ #category : #accessing }
GDIPlusGraphicsPathIterator >> count [
	| count |
	count := ExternalInt32 external.
	status := self dll
		GdipPathIterGetCount: self asParameter
		count: count asParameter.
	self checkStatus.
	^count makeInteger]

{ #category : #copying }
GDIPlusGraphicsPathIterator >> enumerate: aPointArray types: typeArray [
	| points types copied |
	aPointArray size = typeArray size
		ifFalse: [^self error: 'Invalid argument'].
	points := MemoryBuffer external: aPointArray size * PointF sizeInBytes.
	types := typeArray size externalBytes.
	copied := ExternalInt32 external.
	status := self dll
		GdipPathIterEnumerate: self asParameter
		resultCount: copied asParameter
		points: points asParameter
		types: types asParameter
		count: typeArray size.
	self checkStatus.
	copied := copied makeLocal asInteger.
	1 to: copied size do: [:idx | | bytes point type |
		bytes := points makeLocal bytesAtOffset: idx - 1 * 8 count: 8.
		point := (PointF fromBytes: bytes) asPoint.
		aPointArray at: idx put: point.
		type := types makeLocal at: idx.
		typeArray at: idx put: type].
	^copied]

{ #category : #testing }
GDIPlusGraphicsPathIterator >> hasCurve [
	| boolean |
	boolean := ExternalInt32 external.
	status := self dll
		GdipPathIterHasCurve: self asParameter
		hasCurve: boolean asParameter.
	self checkStatus.
	^boolean makeLocal asBoolean]

{ #category : #paths }
GDIPlusGraphicsPathIterator >> nextMarkerInterval [
	| count from to |
	count := ExternalInt32 external.
	from := ExternalInt32 external.
	to := ExternalInt32 external.
	status := self dll
		GdipPathIterNextMarker: self asParameter
		resultCount: count asParameter
		startIndex: from asParameter
		endIndex: to asParameter.
	self checkStatus.
	count := count makeInteger.
	count = 0 ifTrue: [^nil].
	from := from makeInteger.
	to := to makeInteger.
	self ASSERT: to - from + 1 = count.
	^from to: to]

{ #category : #paths }
GDIPlusGraphicsPathIterator >> nextMarkerPath [
	| count path |
	count := ExternalInt32 external.
	path := ExternalPointer external.
	status := self dll
		GdipPathIterNextMarkerPath: self asParameter
		resultCount: count asParameter
		path: path asParameter.
	self checkStatus.
	count makeInteger = 0 ifTrue: [^nil].
	^GDIPlusGraphicsPath fromHandle: path makeLocal]

{ #category : #paths }
GDIPlusGraphicsPathIterator >> nextPathType [
	| count from to type |
	count := ExternalInt32 external.
	from := ExternalInt32 external.
	to := ExternalInt32 external.
	type := ExternalInt32 external.
	status := self dll
		GdipPathIterNextPathType: self asParameter
		resultCount: count asParameter
		pathType: type asParameter
		startIndex: from asParameter
		endIndex: to asParameter.
	self checkStatus.
	count := count makeLocal asInteger.
	count = 0 ifTrue: [^nil].
	from := from makeLocal asInteger.
	to := to makeLocal asInteger.
	self ASSERT: to - from + 1 = count.
	^{from to: to. type makeLocal & 255}]

{ #category : #paths }
GDIPlusGraphicsPathIterator >> nextSubpathInterval [
	| count from to closed |
	count := ExternalInt32 external.
	from := ExternalInt32 external.
	to := ExternalInt32 external.
	closed := ExternalInt32 external.
	status := self dll
		GdipPathIterNextSubpath: self asParameter
		resultCount: count asParameter
		startIndex: from asParameter
		endIndex: to asParameter
		isClosed: closed asParameter.
	self checkStatus.
	count := count makeLocal asInteger.
	count = 0 ifTrue: [^nil].
	from := from makeLocal asInteger.
	to := to makeLocal asInteger.
	self ASSERT: to - from + 1 = count.
	^{from to: to. closed makeLocal asBoolean}]

{ #category : #paths }
GDIPlusGraphicsPathIterator >> nextSubpathPath [
	| count path closed |
	count := ExternalInt32 external.
	path := ExternalPointer external.
	closed := ExternalInt32 external.
	status := self dll
		GdipPathIterNextSubpathPath: self asParameter
		resultCount: count asParameter
		path: path asParameter
		isClosed: closed asParameter.
	self checkStatus.
	count makeLocal asInteger = 0 ifTrue: [^nil].
	path := GDIPlusGraphicsPath fromHandle: path makeLocal.
	^{path. closed makeLocal asBoolean}]

{ #category : #paths }
GDIPlusGraphicsPathIterator >> rewind [
	status := self dll GdipPathIterRewind: self asParameter.
	self checkStatus]

{ #category : #paths }
GDIPlusGraphicsPathIterator >> subpathCount [
	| count |
	count := ExternalInt32 external.
	status := self dll
		GdipPathIterGetSubpathCount: self asParameter
		count: count asParameter.
	self checkStatus.
	^count makeInteger]

