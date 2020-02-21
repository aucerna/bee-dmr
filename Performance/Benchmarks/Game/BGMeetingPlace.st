Class {
	#name : #BGMeetingPlace,
	#superclass : #Object,
	#instVars : [
		'#mutex',
		'#first',
		'#total',
		'#max'
	],
	#category : #Game
}

{ #category : #'instance creation' }
BGMeetingPlace class >> forMeetings: maxMeetings [
    ^super new
        initialize;
        max: maxMeetings;
        yourself
]

{ #category : #'instance creation' }
BGMeetingPlace class >> new [
	^self basicNew initialize
]

{ #category : #'initialize-release' }
BGMeetingPlace >> initialize [
    mutex := Semaphore forMutualExclusion.
    total := 0
]

{ #category : #running }
BGMeetingPlace >> max: maxMeetings [
    max := maxMeetings
]

{ #category : #running }
BGMeetingPlace >> organizeMeetingWith: second [
    total >= max
        ifTrue: [
            first fade.
            second fade ]
        ifFalse: [
            first met: second color.
            second met: first color ].
    total := total + 1
]

{ #category : #running }
BGMeetingPlace >> reachedBy: chameleon [
    mutex critical: [
        first isNil
            ifTrue: [ first := chameleon ]
            ifFalse: [ self organizeMeetingWith: chameleon. first := nil ] ]
]

