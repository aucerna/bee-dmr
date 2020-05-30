"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #Scheduler,
	#superclass : #RBObject,
	#instVars : [
		'taskList',
		'currentTask',
		'currentTaskIdentity',
		'taskTable',
		'tracing',
		'layout',
		'queuePacketCount',
		'holdCount'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
Scheduler class >> new [
 ^ super new initialize 
]

{ #category : #'as yet unclassified' }
Scheduler >> createDevice: identity
priority: priority
work: work
state: state [
	| data |
	data := DeviceTaskDataRecord create.
	self
		createTask: identity
		priority: priority
		work: work
		state: state
		function: [:fwork :word | | localData functionWork |
			localData := word.
			functionWork := fwork.
			RBObject NoWork == functionWork
				ifTrue: [
					RBObject NoWork == (functionWork := localData pending)
						ifTrue: [self wait]
						ifFalse: [
							localData pending: RBObject NoWork.
							self queuePacket: functionWork]]
				ifFalse: [
					localData pending: functionWork.
					self tracing ifTrue: [self trace: functionWork datum].
					self holdSelf]]
		data: data
]

{ #category : #'as yet unclassified' }
Scheduler >> createHandler: identity
priority: priority
work: work
state: state [
	| data |
	data := HandlerTaskDataRecord create.
	self
		createTask: identity
		priority: priority
		work: work
		state: state
		function: [:work1 :word | | localData workPacket |
			data := word.
			RBObject NoWork == work1 ifFalse: [
				RBObject WorkPacketKind == work1 kind
					ifTrue: [data workInAdd: work1]
					ifFalse: [data deviceInAdd: work1]].
			RBObject NoWork == (workPacket := data workIn)
				ifTrue: [self wait]
				ifFalse: [| count |
					count := workPacket datum.
					count > 4
						ifTrue: [
							data workIn: workPacket link.
							self queuePacket: workPacket]
						ifFalse: [| devicePacket |
							RBObject NoWork == (devicePacket := data deviceIn)
								ifTrue: [self wait]
								ifFalse: [
									data deviceIn: devicePacket link.
									devicePacket datum: (workPacket data at: count).
									workPacket datum: count + 1.
									self queuePacket: devicePacket]]]]
		data: data
]

{ #category : #'as yet unclassified' }
Scheduler >> createIdler: identity
priority: priority
work: work
state: state [
	| data |
	data := IdleTaskDataRecord create.
	self
		createTask: identity
		priority: priority
		work: work
		state: state
		function: [:work1 :word | | localData |
			localData := word.
			localData count: localData count - 1.
			0 = localData count ifTrue: [self holdSelf] ifFalse: [
				0 = (localData control & 1)
					ifTrue: [
						localData control: localData control // 2.
						self release: RBObject DeviceA]
					ifFalse: [
						localData control: (localData control // 2 bitXor: 53256).
						self release: RBObject DeviceB]]]
		data: data
]

{ #category : #'as yet unclassified' }
Scheduler >> createPacket: link identity: identity kind: kind [

    ^ Packet create:   link
             identity: identity
             kind:     kind
]

{ #category : #'as yet unclassified' }
Scheduler >> createTask: identity priority: priority work: work state: state function: aBlock data: data [

    | t |
    t := TaskControlBlock   link:             taskList
                            create:           identity
                            priority:         priority
                            initialWorkQueue: work
                            initialState:     state
                            function:         aBlock
                            privateData:      data.
    taskList := t.
    taskTable at: identity put: t
]

{ #category : #'as yet unclassified' }
Scheduler >> createWorker: identity
priority: priority
work: work
state: state [
	| data |
	data := WorkerTaskDataRecord create.
	self
		createTask: identity
		priority: priority
		work: work
		state: state
		function: [:work1 :word | | localData |
			localData := word.
			RBObject NoWork == work1 ifTrue: [self wait] ifFalse: [
				localData
					destination: (RBObject HandlerA = localData destination
						ifTrue: [RBObject HandlerB]
						ifFalse: [RBObject HandlerA]).
				work1 identity: localData destination.
				work1 datum: 1.
				1 to: 4 do: [:i | 
					localData count: localData count + 1.
					localData count > 26 ifTrue: [localData count: 1].
					"work data at: i put: $A asInteger + data count - 1]."
                   work1 data at: i put: 65 + localData count - 1].
				self queuePacket: work1]]
		data: data
]

{ #category : #'as yet unclassified' }
Scheduler >> findTask: identity [

    | t |
    t := taskTable at: identity.
    RBObject NoTask == t ifTrue: [self error: 'findTask failed'].
    ^ t
]

{ #category : #'as yet unclassified' }
Scheduler >> holdSelf [

    holdCount := holdCount + 1.
    currentTask taskHolding: true.
    ^ currentTask link
]

{ #category : #'as yet unclassified' }
Scheduler >> initialize [

    taskList    := RBObject NoTask.
    currentTask := RBObject NoTask.
    currentTaskIdentity := 0.
    taskTable   := Array new: 6 withAll: RBObject NoTask.
    layout      := 0.
    queuePacketCount := 0.
    holdCount   := 0.
]

{ #category : #'as yet unclassified' }
Scheduler >> queuePacket: packet [

    | t |
    t := self findTask: packet identity.
    RBObject NoTask == t ifTrue: [ ^ RBObject NoTask ].
    queuePacketCount := queuePacketCount + 1.
    packet link: RBObject NoWork.
    packet identity: currentTaskIdentity.
    ^ t addInput: packet checkPriority: currentTask
]

{ #category : #'as yet unclassified' }
Scheduler >> release: identity [

      | t |
      t := self findTask: identity.
      RBObject NoTask == t ifTrue: [ ^ RBObject NoTask ].
      t taskHolding: false.
      t priority > currentTask priority
        ifTrue:  [ ^ t ]
        ifFalse: [ ^ currentTask ]
]

{ #category : #'as yet unclassified' }
Scheduler >> schedule [

    currentTask := taskList. 
    [ RBObject NoTask == currentTask ] whileFalse: [
      currentTask isTaskHoldingOrWaiting
        ifTrue:  [ currentTask := currentTask link ]
        ifFalse: [
          currentTaskIdentity := currentTask identity.
          self tracing ifTrue: [ self trace: currentTaskIdentity ].
          currentTask := currentTask runTask ] ]
]

{ #category : #'as yet unclassified' }
Scheduler >> start [

    | workQ |
    self
            createIdler: RBObject Idler
            priority: 0
            work: RBObject NoWork
            state: TaskState running.
    workQ := self
                            createPacket: RBObject NoWork
                            identity: RBObject Worker
                            kind: RBObject WorkPacketKind.
    workQ := self
                            createPacket: workQ
                            identity: RBObject Worker
                            kind: RBObject WorkPacketKind.
    self
            createWorker: RBObject Worker
            priority: 1000
            work: workQ
            state: TaskState waitingWithPacket.
    workQ := self
                            createPacket: RBObject NoWork
                            identity: RBObject DeviceA
                            kind: RBObject DevicePacketKind.
    workQ := self
                            createPacket: workQ
                            identity: RBObject DeviceA
                            kind: RBObject DevicePacketKind.
    workQ := self
                            createPacket: workQ
                            identity: RBObject DeviceA
                            kind: RBObject DevicePacketKind.
    self
            createHandler: RBObject HandlerA
            priority: 2000
            work: workQ
            state: TaskState waitingWithPacket.
    workQ := self
                            createPacket: RBObject NoWork
                            identity: RBObject DeviceB
                            kind: RBObject DevicePacketKind.
    workQ := self
                            createPacket: workQ
                            identity: RBObject DeviceB
                            kind: RBObject DevicePacketKind.
    workQ := self
                            createPacket: workQ
                            identity: RBObject DeviceB
                            kind: RBObject DevicePacketKind.
    self
            createHandler: RBObject HandlerB
            priority: 3000
            work: workQ
            state: TaskState waitingWithPacket.
    self
            createDevice: RBObject DeviceA
            priority: 4000
            work: RBObject NoWork
            state: TaskState waiting.
    self
            createDevice: RBObject DeviceB
            priority: 5000
            work: RBObject NoWork
            state: TaskState waiting.

    self schedule.

    ^ queuePacketCount = 23246 and: holdCount = 9297
]

{ #category : #'as yet unclassified' }
Scheduler >> trace: id [

    layout := layout - 1.
    0 >= layout ifTrue: [
      '' println.
      layout := 50 ].
    id print
]

{ #category : #'as yet unclassified' }
Scheduler >> tracing [

    ^ false
]

{ #category : #'as yet unclassified' }
Scheduler >> wait [

    currentTask taskWaiting: true.
    ^currentTask
]

