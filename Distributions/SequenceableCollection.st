"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #SequenceableCollection }

{ #category : '*Distributions' }
SequenceableCollection >> correlationCoefficient: aCollection [
	| s t |
	s := SampleStatistic on: self.
	t := SampleStatistic on: aCollection.
	^s correlationCoefficient: t]

{ #category : '*Distributions' }
SequenceableCollection >> rankCorrelation: aCollection [
	| s t |
	s := SampleStatistic on: self.
	t := SampleStatistic on: aCollection.
	^s rankCorrelation: t]

{ #category : '*Distributions' }
SequenceableCollection >> ranking [
	| sample |
	sample := SampleStatistic on: self.
	^sample ranking]

