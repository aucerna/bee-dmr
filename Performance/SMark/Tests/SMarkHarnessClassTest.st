Class {
	#name : #SMarkHarnessClassTest,
	#superclass : #TestCase,
	#category : #Tests
}

{ #category : #tests }
SMarkHarnessClassTest >> testShouldShowUsage [
	| example1 example2 example3 example4 |
	example1 := Array with: #ignored with: '--help'.
	example2 := Array with: #ignored.
	example3 := Array with: #ignored with: '-?'.
	example4 := Array with: #ignored with: 1 with: 2.
	self assert: (SMarkHarness shouldShowUsage: example1).
	self assert: (SMarkHarness shouldShowUsage: example2).
	self assert: (SMarkHarness shouldShowUsage: example3).
	self deny: (SMarkHarness shouldShowUsage: example4)
]

