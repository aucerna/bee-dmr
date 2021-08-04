"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ChangesetTest, 
	#superclass : #TestCase, 
	#category : #Tests
}

{#category : #private}
ChangesetTest >> testSplitChangesetAllBy [
	| source filename f3 f4 changeset3 changeset4 |
	source := '!MethodDefinition
	timestamp: ''2219-03-08T15:13:41.727-03:00''
	author: ''L Caniglia''
	className: ''Foo''
	selector: #foo
	category: #foo
	project: ''Foo Project''
	prev: 1335288
	applicationVersion: 14.102!
foo
	^#foo!

"evaluate" 
''Foo new foo''!

!
MethodDefinition
	timestamp: ''2219-04-08T15:19:06.910-03:00''
	author: ''L Caniglia''
	className: ''Bar''
	selector: #bar
	category: #bar
	project: ''Bar Project''
	prev: 22523788
	applicationVersion: 14.102!
'.
	filename := 'changeset.log' asFilename.
	filename newFile nextPutAll: source; close.
	ChangeLogBrowserModel splitChangeset: filename by: #monthIndex.
	f3 := 'changeLog2219-3.log' asFilename.
	f4 := 'changeLog2219-4.log' asFilename.
	self assert: f3 exists; assert: f4 exists.
	changeset3 := Changeset fromStream: f3 asFile contents readStream.
	changeset4 := Changeset fromStream: f4 asFile contents readStream.
	self
		assert: changeset3 currentChanges size = 2;
		assert: changeset3 currentChanges first class == MethodDefinition;
		assert: changeset3 currentChanges second class == ExpressionEvaluation.
	self
		assert: changeset4 currentChanges size = 1;
		assert: changeset4 currentChanges first class == MethodDefinition]

{#category : #private}
ChangesetTest >> testTP47260 [
	| stream changeset |
	stream := '"*** startUp image on: 4/8/2017 10:37:01 ***"!'.
	changeset := Changeset fromStream: stream readStream.
	self assert: changeset allChanges size = 1]

