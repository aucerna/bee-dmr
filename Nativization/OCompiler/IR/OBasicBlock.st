"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OBasicBlock,
	#superclass : #OBeginInstruction,
	#instVars : [
		'end',
		'predecessors',
		'immediateDominator',
		'dominatorDepth',
		'probability'
	],
	#category : #IR
}

{ #category : #private }
OBasicBlock class >> decorator [
	^Smalltalk at: #CollectionDecorator
]

{ #category : #'adding / removing' }
OBasicBlock >> add: instruction [
	^end beforeInsert: instruction
]

{ #category : #'adding / removing' }
OBasicBlock >> addFrom: first to: last [
	end prev afterInsert: first to: last
]

{ #category : #'adding / removing' }
OBasicBlock >> addFront: instruction [
	^self afterInsert: instruction
]

{ #category : #'adding / removing' }
OBasicBlock >> addPredecessor: aBasicBlock [
	predecessors add: aBasicBlock
]

{ #category : #inquiries }
OBasicBlock >> allDominators [
	| result all changed |
	result := Dictionary new.
	all := self withSuccessorsPostOrder.
	all do: [:block | result at: block put: (Set with: block)].
	changed := true.
	[changed] whileTrue: [| current |
		changed := false.
		all reverseDo: [:block | | incoming |
			incoming := block predecessors collect: [:pred | result at: pred].
			current := incoming isEmpty ifTrue: [Set new] ifFalse: [
				incoming
					inject: incoming first
					into: [:intersection :doms | doms intersection: intersection]].
			current add: block.
			current size != (result at: block) size ifTrue: [
				result at: block put: current.
				changed := true]]].
	^result
]

{ #category : #inquiries }
OBasicBlock >> allLoopHeads [
	| loops doms |
	loops := Dictionary new.
	doms := self allDominators.
	self withSuccessorsPostOrder do: [:block | 
		block successors
			do: [:succ | ((doms at: block) includes: succ)
				ifTrue: [loops add: succ -> block]]].
	^loops
]

{ #category : #inquiries }
OBasicBlock >> allLoops [
	| result |
	result := Dictionary new.
	self allLoopHeads
		keysAndValuesDo: [:head :tail | result
			at: head
			put: (tail withPredecessorsUntil: head)].
	^result
]

{ #category : #inquiries }
OBasicBlock >> allReturnsWithBlocks [
	"
	last block ends in a return, but other blocks are the result of inlining,
	hence they end in a jump to the next block, and the return is the instruction
	before that jump
	"
	| result blocks last |
	result := OrderedCollection new.
	blocks := self withSuccessorsPostOrder.
	last := blocks removeFirst.
	result add: last lastInstruction -> last.
	blocks do: [:block | | potential |
		self _ASSERT: block lastInstruction isReturn not.
		potential := block lastInstruction prev.
		potential isReturn ifTrue: [result add: potential -> block]].
	^result
]

{ #category : #converting }
OBasicBlock >> asArray [
	^self asReversePostOrderInstructionsCollection asArray
]

{ #category : #converting }
OBasicBlock >> asOrderedCollection [
	^OrderedCollection withAll: self
]

{ #category : #converting }
OBasicBlock >> asReversePostOrderInstructionsCollection [
	| collection |
	collection := OrderedCollection new.
	self
		instructionsWithReversePostOrderSuccessorsDo: [:inst | collection
			add: inst].
	^collection
]

{ #category : #inquiries }
OBasicBlock >> basicBlock [
	^self
]

{ #category : #'adding / removing' }
OBasicBlock >> beforeInsert: anInstruction [
	self error: 'cannot insert instructions before the start of a basic block'
]

{ #category : #services }
OBasicBlock >> cleanPredecessors [
	predecessors := OrderedCollection new
]

{ #category : #enumerating }
OBasicBlock >> collect: aBlock in: aCollection [
	self do: [:inst | | collected |
		collected := aBlock value: inst.
		aCollection add: collected].
	^aCollection
]

{ #category : #services }
OBasicBlock >> computeDominance [
	"
	This two-finger idom finding implementation is based in the algorithm
 presented in Sect 9.5.2 of Engineering a Compiler, 2nd edition
	"
	| all root idoms indices intersect changed nodes |
	all := self withSuccessorsPostOrder reversed.
	idoms := Array new: all size.
	idoms at: 1 put: 1.
	root := all first.
	indices := Dictionary new.
	all withIndexDo: [:block :index | indices at: block put: index].
	intersect := [:index1 :index2 | | finger1 finger2 |
		finger1 := index1.
		finger2 := index2.
		[finger1 != finger2] whileTrue: [
			finger1 > finger2
				ifTrue: [finger1 := idoms at: finger1]
				ifFalse: [finger2 := idoms at: finger2]].
		finger1].
	changed := true.
	nodes := all copyFrom: 2.
	[changed] whileTrue: [
		changed := false.
		nodes withIndexDo: [:block :index | | processed initial intersection |
			processed := block predecessors select: [:predecessor | | i |
				i := indices at: predecessor.
				(idoms at: i) notNil].
			initial := indices at: processed first.
			intersection := processed
				inject: initial
				into: [:actual :predecessor | | candidate |
					candidate := indices at: predecessor.
					intersect value: actual value: candidate].
			intersection != (idoms at: index + 1) ifTrue: [
				idoms at: index + 1 put: intersection.
				changed := true]]].
	root dominatorDepth: 0.
	2 to: all size do: [:i | | block idom idomIndex |
		block := all at: i.
		idomIndex := idoms at: i.
		idom := all at: idomIndex.
		block immediateDominator: idom]
]

{ #category : #private }
OBasicBlock >> computeLiveOutInto: liveOut andLiveInInto: liveIn [
	| blocks changed |
	blocks := self withSuccessorsPostOrder.
	blocks reverseDo: [:block | | in out |
		in := OrderedCollection new.
		out := OrderedCollection new.
		liveOut at: block put: out.
		liveIn at: block put: in].
	changed := true.
	[changed] whileTrue: [
		changed := false.
		blocks reverseDo: [:block | | live out size |
			live := block successors gather: [:succ | liveIn at: succ].
			out := liveOut at: block.
			size := out size.
			out := out addAll: live; withoutDuplicates.
			changed := changed or: [out size != size].
			block lastInstruction reverseDo: [:instruction | 
				instruction operandsDo: [:argument | 
					live addIfAbsent: argument.
					live removeIfPresent: instruction].
				liveIn at: block put: live]]]
]

{ #category : #copying }
OBasicBlock >> copyTo: copy with: map [
	| copyend |
	copyend := copy next.
	map at: end put: copyend.
	end copyTo: copyend with: map.
	super copyTo: copy with: map.
	copy predecessors: (predecessors collect: [:pred | pred duplicateWith: map])
]

{ #category : #private }
OBasicBlock >> dissolveAllInstructions [
	[next == end] whileFalse: [next dissolveDeep]
]

{ #category : #services }
OBasicBlock >> dissolveIfUnreachable [
	predecessors isEmpty ifTrue: [self dissolveAllInstructions]
]

{ #category : #inquiries }
OBasicBlock >> dominanceFrontiers [
	| idoms |
	idoms := self dominatorTree allImmediateDominators.
	^self dominanceFrontiersUsing: idoms
]

{ #category : #inquiries }
OBasicBlock >> dominanceFrontiersUsing: idoms [
	| blocks result |
	blocks := self withSuccessorsPostOrder.
	result := Dictionary new.
	blocks do: [:block | result at: block put: OrderedCollection new].
	blocks do: [:block | 
		block predecessors size > 1 ifTrue: [
			block predecessors do: [:predecessor | | runner end |
				runner := predecessor.
				end := idoms at: block.
				[runner != end] whileTrue: [| frontiers |
					frontiers := result at: runner.
					(frontiers includes: block) ifFalse: [frontiers add: block].
					runner := idoms at: runner]]]].
	^result
]

{ #category : #accessing }
OBasicBlock >> dominatorDepth [
	^dominatorDepth
]

{ #category : #accessing }
OBasicBlock >> dominatorDepth: anInteger [
	dominatorDepth := anInteger
]

{ #category : #inquiries }
OBasicBlock >> dominatorTree [
	| all root idoms indices intersect changed |
	all := self withSuccessorsPostOrder reversed.
	idoms := Array new: all size.
	idoms at: 1 put: 1.
	root := all first.
	indices := Dictionary new.
	all withIndexDo: [:block :index | indices at: block put: index].
	intersect := [:index1 :index2 | | finger1 finger2 |
		finger1 := index1.
		finger2 := index2.
		[finger1 != finger2] whileTrue: [
			finger1 > finger2
				ifTrue: [finger1 := idoms at: finger1]
				ifFalse: [finger2 := idoms at: finger2]].
		finger1].
	changed := true.
	[changed] whileTrue: [
		changed := false.
		(all copyFrom: 2)
			withIndexDo: [:block :index | | processed initial intersection |
				processed := block predecessors select: [:predecessor | | i |
					i := indices at: predecessor.
					(idoms at: i) notNil].
				initial := indices at: processed first.
				intersection := processed
					inject: initial
					into: [:actual :predecessor | | candidate |
						candidate := indices at: predecessor.
						intersect value: actual value: candidate].
				intersection != (idoms at: index + 1) ifTrue: [
					idoms at: index + 1 put: intersection.
					changed := true]]].
	^ODominatorTree from: root with: all dominators: idoms
]

{ #category : #services }
OBasicBlock >> endWith: jumpType
to: target
skipping: skipped
if: compare [
	| jump |
	jump := jumpType variable: compare target: target implicitTarget: skipped.
	end beforeInsert: jump.
	target addPredecessor: self.
	skipped addPredecessor: self.
	^jump
]

{ #category : #services }
OBasicBlock >> endWithJumpFalseTo: target skipping: skipped if: condition [
	self endWith: OJumpFalse to: target skipping: skipped if: condition
]

{ #category : #services }
OBasicBlock >> endWithJumpTo: target [
	| jump |
	jump := OJump to: target.
	end beforeInsert: jump.
	target addPredecessor: self
]

{ #category : #services }
OBasicBlock >> endWithJumpTrueTo: target skipping: skipped if: condition [
	self endWith: OJumpTrue to: target skipping: skipped if: condition
]

{ #category : #inquiries }
OBasicBlock >> firstInstruction [
	^next
]

{ #category : #inquiries }
OBasicBlock >> firstNonPhi [
	^next firstNonPhi
]

{ #category : #'adding / removing' }
OBasicBlock >> fullyRemovePredecessor: predecessor [
	self removePredecessor: predecessor.
	predecessors isEmpty
		ifTrue: [self successors do: [:succ | succ fullyRemovePredecessor: self]]
]

{ #category : #testing }
OBasicBlock >> hasMultiplePredecessors [
	^predecessors size > 1
]

{ #category : #testing }
OBasicBlock >> hasMultipleSuccessors [
	^self lastInstruction isConditionalJump
]

{ #category : #testing }
OBasicBlock >> hasOnePredecessor [
	^predecessors size = 1
]

{ #category : #testing }
OBasicBlock >> hasSuccessors [
	^self lastInstruction isJump
]

{ #category : #accessing }
OBasicBlock >> immediateDominator [
	^immediateDominator
]

{ #category : #accessing }
OBasicBlock >> immediateDominator: aBasicBlock [
	immediateDominator := aBasicBlock.
	dominatorDepth := immediateDominator dominatorDepth + 1
]

{ #category : #services }
OBasicBlock >> incorporatePhisFrom: predecessor [
	| index |
	predecessors size = 1 ifTrue: [^predecessor movePhisTo: self].
	self phisDo: [:phi | | source parents vars |
		index := phi blocks indexOf: predecessor.
		source := phi variables at: index.
		parents := predecessor predecessors.
		vars := (predecessor phis includes: source)
			ifTrue: [source variables copy]
			ifFalse: [OrderedCollection new: parents size withAll: source].
		vars withIndexDo: [:var :i | | pred |
			pred := parents at: i.
			phi addVariable: var from: pred]]
]

{ #category : #inquiries }
OBasicBlock >> indexOf: anInstruction [
	| current |
	current := 1.
	self instructionsDo: [:instruction | 
		instruction == anInstruction ifTrue: [^current].
		current := current + 1].
	self error: 'instruction not found'
]

{ #category : #initialization }
OBasicBlock >> initialize [
	next := OEndInstruction new prev: self.
	end := next.
	predecessors := OrderedCollection new
]

{ #category : #enumerating }
OBasicBlock >> instructionsAfter: first withReversePostOrderSuccessorsDo: aBlock [
	first do: aBlock.
	self withSuccessorsPostOrder
		removeLast;
		reverseDo: [:block | block instructionsDo: aBlock]
]

{ #category : #inquiries }
OBasicBlock >> instructionsAsCollection [
	| collection |
	collection := OrderedCollection new.
	self instructionsDo: [:inst | collection add: inst].
	^collection
]

{ #category : #enumerating }
OBasicBlock >> instructionsDo: aBlock [
	^next do: aBlock
]

{ #category : #enumerating }
OBasicBlock >> instructionsReverseDo: aBlock [
	^end reverseDo: aBlock
]

{ #category : #enumerating }
OBasicBlock >> instructionsWithPostOrderSuccessorsDo: aBlock [
	self postOrderDo: [:block | block instructionsDo: aBlock]
]

{ #category : #enumerating }
OBasicBlock >> instructionsWithReversePostOrderSuccessorsDo: aBlock [
	self reversePostOrderDo: [:block | block instructionsDo: aBlock]
]

{ #category : #enumerating }
OBasicBlock >> instructionsWithSuccessorsDo: aBlock [
	self withSuccessorsDo: [:block | block instructionsDo: aBlock]
]

{ #category : #testing }
OBasicBlock >> isEmptyBranch [
	self instructionsDo: [:instruction | ^instruction isConditionalJump].
	^false
]

{ #category : #testing }
OBasicBlock >> isEmptyJump [
	self instructionsDo: [:instruction | ^instruction isUnconditionalJump].
	^false
]

{ #category : #testing }
OBasicBlock >> isEmptyPhiBranch [
	self instructionsDo: [:instruction | | empty |
		empty := instruction isPhi and: [| next |
			next := instruction next.
			next isConditionalJump
				and: [next variable == instruction and: [instruction isUsedJustOnce]]].
		^empty].
	^false
]

{ #category : #testing }
OBasicBlock >> isOnlyPhiBranch [
	| last |
	last := self lastInstruction.
	last isConditionalJump ifFalse: [^false].
	self instructionsDo: [:instruction | 
		instruction = last ifTrue: [^true].
		instruction isPhi ifFalse: [^false]]
]

{ #category : #testing }
OBasicBlock >> isPhiArgument: instruction [
	self phisDo: [:phi | (phi variables includes: instruction) ifTrue: [^true]].
	^false
]

{ #category : #testing }
OBasicBlock >> isReachableFrom: aBasicBlock [
	| seen work |
	seen := Set withAll: predecessors.
	work := OrderedCollection withAll: predecessors.
	[work isEmpty] whileFalse: [| block |
		block := work removeFirst.
		block == aBasicBlock ifTrue: [^true].
		block predecessors do: [:p | 
			(seen includes: p) ifFalse: [
				seen add: p.
				work add: p]]].
	^false
]

{ #category : #inquiries }
OBasicBlock >> iteratedDominanceFrontiersOf: blocks using: frontiers [
	| result changed |
	result := (blocks gather: [:block | frontiers at: block]) asSet.
	changed := true.
	[changed] whileTrue: [| size more |
		size := result size.
		more := result gather: [:block | frontiers at: block].
		result addAll: more.
		changed := size != result size].
	^result
]

{ #category : #inquiries }
OBasicBlock >> lastBlock [
	^self postOrderDo: [:block | ^block]
]

{ #category : #inquiries }
OBasicBlock >> lastInstruction [
	^end prev
]

{ #category : #inquiries }
OBasicBlock >> lastValue [
	| last |
	last := end lastValue.
	^last = self
		ifTrue: [predecessors size = 1 ifTrue: [predecessors first lastValue]]
		ifFalse: [last]
]

{ #category : #inquiries }
OBasicBlock >> length [
	| current |
	current := 0.
	self instructionsDo: [:instruction | current := current + 1].
	^current
]

{ #category : #services }
OBasicBlock >> lowestCommonAncestor: block [
	| a b |
	a := self.
	b := block.
	[a dominatorDepth < b dominatorDepth]
		whileTrue: [b := b immediateDominator].
	[a dominatorDepth > b dominatorDepth]
		whileTrue: [a := a immediateDominator].
	[a == b] whileFalse: [
		a := a immediateDominator.
		b := b immediateDominator].
	^a
]

{ #category : #services }
OBasicBlock >> moveAllTo: block [
	self moveAllTo: block after: block lastInstruction
]

{ #category : #services }
OBasicBlock >> moveAllTo: block after: instruction [
	block replace: self asPredecessorIn: self successors.
	next == end ifTrue: [^self].
	end prev afterConnect: instruction next.
	instruction afterConnect: next.
	self afterConnect: end
]

{ #category : #services }
OBasicBlock >> movePhisTo: otherBlock [
	| inst dest |
	inst := next.
	dest := otherBlock.
	[inst isPhi] whileTrue: [| next |
		next := inst next.
		dest afterInsert: inst.
		dest := inst.
		inst := next]
]

{ #category : #inquiries }
OBasicBlock >> name [
	^'#' , self hash printString
]

{ #category : #enumerating }
OBasicBlock >> nodesSelect: aBlock [
	| seen work result visit |
	seen := IdentitySet with: self.
	work := OrderedCollection with: self.
	result := OrderedCollection new.
	visit := [:inst | 
		(seen includes: inst) ifFalse: [
			seen add: inst.
			work add: inst]].
	[work isEmpty] whileFalse: [| node |
		node := work removeLast.
		(aBlock value: node) ifTrue: [result add: node].
		node class = OBlockClosure ifTrue: [visit value: node start].
		node class = OBasicBlock ifTrue: [
			node do: [:inst | visit value: inst].
			node successors do: [:succ | visit value: succ]].
		node operandsDo: [:input | visit value: input]].
	^result
]

{ #category : #enumerating }
OBasicBlock >> operandsDo: aBlock [
	
]

{ #category : #enumerating }
OBasicBlock >> phis [
	| result |
	result := OrderedCollection new.
	self
		instructionsDo: [:instr | instr isPhi
			ifTrue: [result add: instr]
			ifFalse: [^result]]
]

{ #category : #enumerating }
OBasicBlock >> phisDo: aBlock [
	self
		instructionsDo: [:instr | instr isPhi
			ifTrue: [aBlock value: instr]
			ifFalse: [^self]]
]

{ #category : #inquiries }
OBasicBlock >> phiValuesComingFrom: block [
	^self phis collect: [:phi | phi atOperand: block]
]

{ #category : #inquiries }
OBasicBlock >> phiWithArgument: instruction [
	self phisDo: [:phi | (phi variables includes: instruction) ifTrue: [^phi]].
	self error: 'not found'
]

{ #category : #private }
OBasicBlock >> postOrder: result seen: seen [
	seen add: self.
	self
		successorsDo: [:succ | (seen includes: succ)
			ifFalse: [succ postOrder: result seen: seen]].
	result add: self
]

{ #category : #enumerating }
OBasicBlock >> postOrderDo: aBlock [
	self withSuccessorsPostOrder do: [:block | aBlock value: block]
]

{ #category : #accessing }
OBasicBlock >> predecessors [
	^predecessors
]

{ #category : #accessing }
OBasicBlock >> predecessors: aCollection [
	predecessors := aCollection
]

{ #category : #accessing }
OBasicBlock >> prev: anInstruction [
	self error: 'cannot insert instructions before the start of a basic block'
]

{ #category : #printing }
OBasicBlock >> primitivePrintOn: aStream [
	aStream nextPutAll: '<=== '; print: self name; cr.
	next printForwardOn: aStream.
	aStream nextPutAll: '===>'
]

{ #category : #printing }
OBasicBlock >> primitivePrintString [
	^self primitivePrintOn: '' writeStream
]

{ #category : #printing }
OBasicBlock >> printAll [
	| stream |
	stream := '' writeStream.
	self reversePostOrderDo: [:block | 
		block printOn: stream.
		stream cr].
	^stream contents
]

{ #category : #printing }
OBasicBlock >> printAllNamed [
	^String streamContents: [:s | self printAllNamedOn: s]
]

{ #category : #printing }
OBasicBlock >> printAllNamedOn: aStream [
	| activation |
	activation := self next.
	self printAllNamedOn: aStream function: activation function
]

{ #category : #printing }
OBasicBlock >> printAllNamedOn: aStream function: anOFunction [
	| names vars blocks |
	names := Dictionary new.
	vars := 0.
	blocks := 0.
	anOFunction arguments do: [:arg | names at: arg put: 'arg_' , arg name].
	anOFunction temporaries do: [:temp | names at: temp put: 't_' , temp name].
	self reversePostOrderDo: [:block | 
		block instructionsDo: [:inst | 
			names at: inst put: 'v' , vars printString.
			vars := vars + 1].
		names at: block put: 'B' , blocks printString.
		blocks := blocks + 1].
	self reversePostOrderDo: [:block | 
		block printOn: aStream using: names.
		aStream cr]
]

{ #category : #printing }
OBasicBlock >> printOn: aStream [
	self primitivePrintOn: aStream
]

{ #category : #printing }
OBasicBlock >> printOn: aStream using: names [
	| string |
	string := names at: self ifAbsent: [^self primitivePrintOn: aStream].
	aStream
		nextPutAll: '<=== ';
		nextPutAll: string;
		space;
		nextPut: $[;
		nextPutAll: self hash printString;
		nextPut: $];
		space;
		nextPut: $\.
	predecessors size > 0 ifTrue: [
		predecessors allButLast
			do: [:pred | aStream nextPutAll: (names at: pred ifAbsent: '?') , ' | '].
		aStream nextPutAll: (names at: predecessors last ifAbsent: '?')].
	aStream nextPutAll: '/'; cr.
	next printForwardOn: aStream using: names.
	aStream nextPutAll: '===>'
]

{ #category : #accessing }
OBasicBlock >> probability [
	^probability ifNil: [1.0]
]

{ #category : #accessing }
OBasicBlock >> probability: aNumber [
	probability := aNumber
]

{ #category : #enumerating }
OBasicBlock >> realInstructionsDo: aBlock [
	| current |
	current := next.
	[current isPhi] whileTrue: [current := current next].
	current do: aBlock
]

{ #category : #'adding / removing' }
OBasicBlock >> removePredecessor: aBasicBlock [
	predecessors remove: aBasicBlock.
	self phisDo: [:phi | phi removeBlock: aBasicBlock]
]

{ #category : #services }
OBasicBlock >> replace: old asPredecessorIn: successors [
	successors do: [:succ | succ replacePredecessor: old with: self]
]

{ #category : #services }
OBasicBlock >> replaceAllUsesWith: anOBasicBlock [
	self == anOBasicBlock ifTrue: [^self].
	super replaceAllUsesWith: anOBasicBlock.
	predecessors do: [:pred | | jump |
		jump := pred lastInstruction.
		jump isConditionalJump
			ifTrue: [
				jump implicitTarget == self
					ifTrue: [jump implicitTarget: anOBasicBlock]
					ifFalse: [jump target: anOBasicBlock]]
			ifFalse: [jump target: anOBasicBlock].
		anOBasicBlock addPredecessor: pred].
	predecessors removeAll
]

{ #category : #services }
OBasicBlock >> replacePredecessor: old with: new [
	self phisDo: [:phi | phi replaceBlock: old with: new].
	predecessors replace: old with: new
]

{ #category : #enumerating }
OBasicBlock >> reversePostOrderDo: aBlock [
	self withSuccessorsPostOrder reverseDo: [:block | aBlock value: block]
]

{ #category : #services }
OBasicBlock >> scheduleEarly: blocks start: anOBasicBlock [
	(blocks includesKey: self) ifTrue: [^self].
	blocks at: self put: self.
	self
		instructionsDo: [:inst | inst scheduleEarly: blocks start: anOBasicBlock].
	predecessors do: [:pred | pred scheduleEarly: blocks start: anOBasicBlock]
]

{ #category : #services }
OBasicBlock >> scheduleLate: blocks [
	self instructionsDo: [:inst | inst scheduleLate: blocks]
]

{ #category : #inquiries }
OBasicBlock >> scheduleLocal: instructions [
	"
	Perform a topological sort of instructions. Instead of the typical `visited` variable, 
	we use the `instructions` argument to keep track of still unvisited nodes.
	instruction argument contains only unscheduled nodes, we do two phases to schedule
	optimally (deps just before uses): 
		1. we schedule deps of already scheduled nodes.
		2. remaining things are only needed for successor bbs only, we schedule them last.
	We start from any node and traverse it DFS. The resulting path from the start node
	is a valid schedule (in reverse order) for all seen nodes. We do the same with
	the next unseen node, and repeat until all nodes have been visited.
	This implementation cares to leave in place already scheduled nodes (loads, stores,
	sends), by adding a dep to their previous instruction. This is necessary as side-effects
	are not-yet modelled as (anti-)dependencies.
	"
	| insertion ordered postOrder p scheduleDeps |
	insertion := self.
	ordered := OrderedCollection new: instructions size.
	postOrder := nil.
	postOrder := [:node | 
		instructions remove: node ifAbsent: nil.
		node
			operandsDo: [:succ | (instructions includes: succ)
				ifTrue: [postOrder value: succ]].
		node isScheduled ifTrue: [
			p := node prev.
			(instructions includes: p) ifTrue: [postOrder value: p]].
		ordered add: node].
	scheduleDeps := [:inst | 
		postOrder value: inst.
		[ordered isEmpty] whileFalse: [| current |
			current := ordered removeFirst.
			current isScheduled ifFalse: [insertion afterInsert: current].
			current isJump ifFalse: [insertion := current]]].
	self instructionsDo: [:inst | scheduleDeps value: inst].
	[instructions isEmpty]
		whileFalse: [scheduleDeps value: instructions anyone]
]

{ #category : #inquiries }
OBasicBlock >> size [
	| result |
	result := 0.
	next do: [:inst | result := result + 1].
	^result
]

{ #category : #services }
OBasicBlock >> sortPhiVariables [
	self phisDo: [:phi | phi sortAfter: predecessors]
]

{ #category : #services }
OBasicBlock >> split [
	^self class new
]

{ #category : #services }
OBasicBlock >> splitAfter: anInstruction [
	| block start last |
	block := self class new.
	start := anInstruction next.
	start isEnd ifTrue: [^block].
	last := end prev.
	block
		replace: self asPredecessorIn: self successors;
		addFrom: start to: last.
	anInstruction afterConnect: end.
	^block
]

{ #category : #services }
OBasicBlock >> splitAfter: anOInstruction if: condition evaluating: aBlock [
	| truebb falsebb mergebb nextbb |
	truebb := OBasicBlock new.
	falsebb := OBasicBlock new.
	mergebb := OBasicBlock new.
	nextbb := self splitAfter: anOInstruction.
	truebb endWithJumpTo: mergebb.
	falsebb endWithJumpTo: mergebb.
	mergebb endWithJumpTo: nextbb.
	self endWithJumpTrueTo: truebb skipping: falsebb if: condition.
	aBlock value: truebb value: falsebb value: mergebb
]

{ #category : #services }
OBasicBlock >> splitAllCriticalEdges [
	self withSuccessorsPostOrder
		do: [:block | block splitIncomingCriticalEdges]
]

{ #category : #services }
OBasicBlock >> splitBefore: anInstruction [
	^self splitAfter: anInstruction prev
]

{ #category : #services }
OBasicBlock >> splitEdgeTo: block [
	| middle jump branch |
	middle := self class new.
	jump := OJump to: block.
	middle add: jump.
	branch := self lastInstruction.
	branch target = block
		ifTrue: [branch target: middle]
		ifFalse: [branch implicitTarget: middle].
	middle addPredecessor: self.
	block replacePredecessor: self with: middle.
	^middle
]

{ #category : #services }
OBasicBlock >> splitIncomingCriticalEdges [
	predecessors size > 1 ifFalse: [^self].
	predecessors
		do: [:pred | pred hasMultipleSuccessors ifTrue: [pred splitEdgeTo: self]]
]

{ #category : #inquiries }
OBasicBlock >> successors [
	^self lastInstruction targets
]

{ #category : #enumerating }
OBasicBlock >> successorsDo: aBlock [
	next == end ifFalse: [self lastInstruction successorsDo: aBlock]
]

{ #category : #enumerating }
OBasicBlock >> successorsPostOrder [
	| seen result |
	seen := Set new.
	result := OrderedCollection new: 10.
	self
		successorsDo: [:succ | (seen includes: succ)
			ifFalse: [succ postOrder: result seen: seen]].
	^result
]

{ #category : #testing }
OBasicBlock >> usesResultOf: anInstruction [
	next
		detect: [:instruction | instruction usesResultOf: anInstruction]
		ifNone: [^false].
	^true
]

{ #category : #validation }
OBasicBlock >> validateAllInstructions [
	| all blocks |
	self withSuccessorsDo: [:block | | forward current backwards |
		forward := OrderedCollection new.
		current := block.
		[current notNil] whileTrue: [
			self _DENY: (forward includes: current).
			forward add: current.
			current := current next].
		backwards := OrderedCollection new.
		current := forward last.
		[current notNil] whileTrue: [
			self _DENY: (backwards includes: current).
			backwards add: current.
			current := current prev].
		self _ASSERT: forward = backwards reversed].
	all := Set new.
	blocks := OrderedCollection new.
	blocks add: self.
	[blocks isEmpty] whileFalse: [| block |
		block := blocks removeFirst.
		block instructionsWithSuccessorsDo: [:inst | 
			all add: inst.
			inst operandsDo: [:o | o isBlockClosure ifTrue: [blocks add: o start]]]].
	self instructionsWithSuccessorsDo: [:inst | 
		inst
			validateUses;
			usesDo: [:operand | self _ASSERT: (all includes: operand instruction)]]
]

{ #category : #validation }
OBasicBlock >> validateCFG [
	self withSuccessorsDo: [:block | 
		block successors
			do: [:successor | self _ASSERT: (successor predecessors includes: block)].
		block predecessors
			do: [:predecessor | self _ASSERT: (predecessor successors includes: block)]]
]

{ #category : #enumerating }
OBasicBlock >> withPredecessorsUntil: block [
	| result incoming |
	result := OrderedCollection new.
	incoming := OrderedCollection with: self.
	[
		result addAll: incoming.
		incoming := incoming gather: #predecessors.
		incoming
			removeAllSuchThat: [:pred | pred == block or: [result includes: pred]].
		incoming isEmpty] whileFalse.
	^result
]

{ #category : #enumerating }
OBasicBlock >> withSuccessorsDo: aBlock [
	| done remaining |
	done := Set new.
	remaining := OrderedCollection new: 10.
	remaining add: self.
	[remaining notEmpty] whileTrue: [| block more |
		block := remaining removeFirst.
		aBlock value: block.
		done add: block.
		more := block successors
			reject: [:succesor | (done includes: succesor)
				or: [remaining includes: succesor]].
		remaining addAll: more]
]

{ #category : #enumerating }
OBasicBlock >> withSuccessorsPostOrder [
	| seen result |
	seen := Set new.
	result := OrderedCollection new: 10.
	self postOrder: result seen: seen.
	^result
]

