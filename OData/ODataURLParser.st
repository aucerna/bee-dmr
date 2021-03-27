"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ODataURLParser,
	#superclass : #ODataURLGrammar,
	#classVars : [
		'Current'
	],
	#category : #OData
}

{ #category : #'pm support' }
ODataURLParser class >> aboutToSaveLibraryOn: aCodeSegmentBuilder [
	aCodeSegmentBuilder map: Current to: nil.
	super aboutToSaveLibraryOn: aCodeSegmentBuilder]

{ #category : #accessing }
ODataURLParser class >> clearCurrent [
	"
	ODataURLParser clearCurrent
	"
	Current := nil]

{ #category : #accessing }
ODataURLParser class >> current [
	Current isNil ifTrue: [Current := self new].
	^Current]

{ #category : #productions }
ODataURLParser >> aliasAndValue [
	^super aliasAndValue
		==> [:nodes | ODataQueryOption name: nodes first value: nodes last]]

{ #category : #productions }
ODataURLParser >> allExpr [
	^super allExpr ==> [:nodes | | variable expression |
		variable := nodes fourth.
		expression := nodes at: 8.
		ODataLambdaOperator new
			operator: 'all';
			variable: variable;
			expression: expression]]

{ #category : #productions }
ODataURLParser >> anyExpr [
	^super anyExpr ==> [:nodes | | predicate variable expression |
		predicate := nodes fourth.
		predicate notNil ifTrue: [
			variable := predicate first.
			expression := predicate last].
		ODataLambdaOperator new
			operator: 'any';
			variable: variable;
			expression: expression]]

{ #category : #productions }
ODataURLParser >> binary [
	^super binary ==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> boolBinaryExpr [
	^super boolBinaryExpr ==> [:nodes | 
		nodes second isNil ifTrue: [nodes first] ifFalse: [
			ODataBinaryExpression
				left: nodes first
				operation: nodes second second
				right: nodes second last]]]

{ #category : #productions }
ODataURLParser >> boolCommonExpr [
	^super boolCommonExpr ==> [:nodes | 
		nodes second isNil ifTrue: [nodes first] ifFalse: [
			ODataBinaryExpression
				left: nodes first
				operation: nodes second second
				right: nodes second last]]]

{ #category : #productions }
ODataURLParser >> booleanValue [
	^super booleanValue ==> [:nodes | 
		ODataPrimitiveLiteral new
			literal: nodes;
			value: nodes = 'true']]

{ #category : #productions }
ODataURLParser >> boolParenExpr [
	^super boolParenExpr ==> [:nodes | nodes third]]

{ #category : #productions }
ODataURLParser >> byteValue [
	^super byteValue ==> [:nodes | 
		ODataPrimitiveLiteral new
			literal: nodes first;
			value: nodes first asInteger]]

{ #category : #productions }
ODataURLParser >> ceilingMethodCallExpr [
	^super ceilingMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'ceiling' argument: (nodes at: 4)]]

{ #category : #productions }
ODataURLParser >> collectionNavigationExpr [
	^super collectionNavigationExpr ==> [:nodes | | prefix level suffix |
		prefix := nodes first
			ifNotNil: [:s | ODataPropertyPath fromString: s]
			ifNil: [ODataPropertyPath new].
		suffix := nodes second size = 2
			ifTrue: [
				level := ODataPropertyPath fromString: nodes second first.
				nodes second second notNil
					ifTrue: [level , nodes second second]
					ifFalse: [level]]
			ifFalse: [nodes second].
		prefix , suffix]]

{ #category : #productions }
ODataURLParser >> collectionPathExpr [
	^super collectionPathExpr
		==> [:nodes | nodes isString ifTrue: [nodes] ifFalse: [nodes second]]]

{ #category : #productions }
ODataURLParser >> commonExpr [
	^super commonExpr ==> [:nodes | 
		nodes second isNil ifTrue: [nodes first] ifFalse: [
			ODataBinaryExpression
				left: nodes first
				operation: nodes second second
				right: nodes second last]]]

{ #category : #productions }
ODataURLParser >> compoundKey [
	^super compoundKey ==> [:nodes | | predicate |
		predicate := Array
			with: nodes second
			withAll: (nodes third collect: #second).
		ODataKeyPredicate new predicate: predicate]]

{ #category : #productions }
ODataURLParser >> concatMethodCallExpr [
	^super concatMethodCallExpr
		==> [:nodes | ODataFunctionCall
			name: 'concat'
			arguments: {nodes at: 4. nodes at: 8}]]

{ #category : #productions }
ODataURLParser >> containsMethodCallExpr [
	^super containsMethodCallExpr
		==> [:nodes | ODataFunctionCall
			name: 'contains'
			arguments: {nodes at: 4. nodes at: 8}]]

{ #category : #productions }
ODataURLParser >> customQueryOption [
	^super customQueryOption ==> [:nodes | | value |
		value := nodes second ifNotNil: [:n | n second].
		ODataQueryOption name: nodes first value: value]]

{ #category : #productions }
ODataURLParser >> dateMethodCallExpr [
	^super dateMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'date' argument: (nodes at: 4)]]

{ #category : #productions }
ODataURLParser >> dateTimeOffsetValue [
	^super dateTimeOffsetValue
		==> [:nodes | | literal date seconds time sign hh mm ts |
			literal := self literalize: nodes.
			date := Date
				day: nodes fifth asInteger
				month: nodes third asInteger
				year: nodes first asInteger.
			seconds := (nodes at: 10) ifNil: 0.0 ifNotNil: [:s | s second asFloat].
			time := Time hours: (nodes at: 7) minutes: (nodes at: 9) seconds: seconds.
			sign := nodes last first = '-' ifTrue: [-1] ifFalse: [1].
			hh := nodes last second asInteger.
			mm := nodes last third asInteger.
			ts := Timestamp date: date time: time offset: hh * 60 + mm * sign.
			ODataPrimitiveLiteral new literal: literal; value: ts]]

{ #category : #productions }
ODataURLParser >> dateValue [
	^super dateValue ==> [:nodes | | literal date |
		literal := self literalize: nodes.
		date := Date
			day: nodes last asInteger
			month: nodes third asInteger
			year: nodes first asInteger.
		ODataPrimitiveLiteral new literal: literal; value: date]]

{ #category : #productions }
ODataURLParser >> dayMethodCallExpr [
	^super dayMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'day' argument: (nodes at: 4)]]

{ #category : #productions }
ODataURLParser >> decimalValue [
	^super decimalValue
		==> [:nodes | ODataPrimitiveLiteral new
			literal: nodes;
			value: nodes asNumber]]

{ #category : #productions }
ODataURLParser >> distanceMethodCallExpr [
	^super distanceMethodCallExpr
		==> [:nodes | ODataFunctionCall
			name: 'geo.distance'
			arguments: {nodes at: 4. nodes at: 8}]]

{ #category : #productions }
ODataURLParser >> doubleValue [
	^super doubleValue ==> [:nodes | | literal number |
		literal := nodes first.
		number := literal = 'NaN' ifTrue: [Number nan] ifFalse: [
			literal = '-INF'
				ifTrue: [Float minusInfinity]
				ifFalse: [literal = 'INF'
					ifTrue: [Float infinity]
					ifFalse: [literal asNumber]]].
		ODataPrimitiveLiteral new literal: literal; value: number]]

{ #category : #productions }
ODataURLParser >> duration [
	^super duration ==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> endsWithMethodCallExpr [
	^super endsWithMethodCallExpr
		==> [:nodes | ODataFunctionCall
			name: 'endswith'
			arguments: {nodes at: 4. nodes at: 8}]]

{ #category : #productions }
ODataURLParser >> entityCastOptions [
	^super entityCastOptions ==> [:nodes | | options |
		options := OrderedCollection new.
		options
			addAll: (nodes first collect: #first);
			add: nodes second;
			addAll: (nodes third collect: #second).
		options]]

{ #category : #productions }
ODataURLParser >> entityOptions [
	^super entityOptions ==> [:nodes | | options |
		options := OrderedCollection new.
		options
			addAll: (nodes first collect: #first);
			add: nodes second;
			addAll: (nodes third collect: #second).
		options]]

{ #category : #productions }
ODataURLParser >> enum [
	^super enum ==> [:nodes | {nodes first. nodes third}]]

{ #category : #productions }
ODataURLParser >> enumValue [
	^super enumValue
		==> [:nodes | Array
			with: nodes first
			withAll: (nodes second collect: #second)]]

{ #category : #productions }
ODataURLParser >> expand [
	^super expand ==> [:nodes | 
		ODataQueryOption
			name: nodes first
			value: (Array with: nodes third withAll: (nodes last collect: #second))]]

{ #category : #productions }
ODataURLParser >> filter [
	^super filter
		==> [:nodes | ODataQueryOption name: nodes first value: nodes last]]

{ #category : #productions }
ODataURLParser >> floorMethodCallExpr [
	^super floorMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'floor' argument: (nodes at: 4)]]

{ #category : #productions }
ODataURLParser >> format [
	^super format
		==> [:nodes | ODataQueryOption name: nodes first value: nodes last]]

{ #category : #productions }
ODataURLParser >> fractionalsecondsMethodCallExpr [
	^super fractionalsecondsMethodCallExpr
		==> [:nodes | ODataFunctionCall
			name: 'fractionalseconds'
			argument: (nodes at: 4)]]

{ #category : #productions }
ODataURLParser >> geographyCollection [
	^super geographyCollection ==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> geographyLineString [
	^super geographyLineString ==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> geographyMultiLineString [
	^super geographyMultiLineString
		==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> geographyMultiPoint [
	^super geographyMultiPoint ==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> geographyMultiPolygon [
	^super geographyMultiPolygon
		==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> geographyPoint [
	^super geographyPoint ==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> geographyPolygon [
	^super geographyPolygon ==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> geoLengthMethodCallExpr [
	^super geoLengthMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'geo.length' argument: (nodes at: 4)]]

{ #category : #productions }
ODataURLParser >> geometryCollection [
	^super geometryCollection ==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> geometryLineString [
	^super geometryLineString ==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> geometryMultiLineString [
	^super geometryMultiLineString
		==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> geometryMultiPoint [
	^super geometryMultiPoint ==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> geometryMultiPolygon [
	^super geometryMultiPolygon
		==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> geometryPoint [
	^super geometryPoint ==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> geometryPolygon [
	^super geometryPolygon ==> [:nodes | self error: 'not implemented yet']]

{ #category : #productions }
ODataURLParser >> guidValue [
	^super guidValue ==> [:nodes | | guid |
		guid := GUID fromString: nodes first.
		ODataPrimitiveLiteral new literal: nodes first; value: guid]]

{ #category : #productions }
ODataURLParser >> hourMethodCallExpr [
	^super hourMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'hour' argument: (nodes at: 4)]]

{ #category : #productions }
ODataURLParser >> id [
	^super id
		==> [:nodes | ODataQueryOption name: nodes first value: nodes last]]

{ #category : #productions }
ODataURLParser >> indexOfMethodCallExpr [
	^super indexOfMethodCallExpr
		==> [:nodes | ODataFunctionCall
			name: 'indexof'
			arguments: {nodes at: 4. nodes at: 8}]]

{ #category : #productions }
ODataURLParser >> inlinecount [
	^super inlinecount
		==> [:nodes | ODataQueryOption name: nodes first value: nodes last]]

{ #category : #productions }
ODataURLParser >> int16Value [
	^super int16Value ==> [:nodes | 
		ODataPrimitiveLiteral new
			literal: nodes first;
			value: nodes first asInteger]]

{ #category : #productions }
ODataURLParser >> int32Value [
	^super int32Value ==> [:nodes | 
		ODataPrimitiveLiteral new
			literal: nodes first;
			value: nodes first asInteger]]

{ #category : #productions }
ODataURLParser >> int64Value [
	^super int64Value ==> [:nodes | 
		ODataPrimitiveLiteral new
			literal: nodes first;
			value: nodes first asInteger]]

{ #category : #productions }
ODataURLParser >> intersectsMethodCallExpr [
	^super intersectsMethodCallExpr ==> [:nodes | 
		ODataFunctionCall
			name: 'geo.intersects'
			arguments: {nodes at: 4. nodes at: 8}]]

{ #category : #productions }
ODataURLParser >> isofExpr [
	^super isofExpr ==> [:nodes | | arguments |
		arguments := nodes fourth isNil
			ifTrue: [{nodes fifth}]
			ifFalse: [{nodes fourth. nodes fifth}].
		ODataFunctionCall name: 'isof' arguments: arguments]]

{ #category : #productions }
ODataURLParser >> keyValuePair [
	^super keyValuePair ==> [:nodes | 
		ODataBinaryExpression new
			left: nodes first;
			operation: '=';
			right: nodes last]]

{ #category : #productions }
ODataURLParser >> lengthMethodCallExpr [
	^super lengthMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'length' argument: (nodes at: 4)]]

{ #category : #private }
ODataURLParser >> literalize: nodes [
	"
	ODataURLParser current literalize: #('2016' '-' '12' '-' '24')
	"
	^String
		streamContents: [:strm | nodes
			select: #notNil
			thenDo: [:node | strm nextPutAll: node asString]]]

{ #category : #productions }
ODataURLParser >> maxDateTimeMethodCallExpr [
	^super maxDateTimeMethodCallExpr
		==> [:nodes | ODataFunctionCall new function: 'maxdatetime']]

{ #category : #productions }
ODataURLParser >> memberExpr [
	^super memberExpr
		==> [:nodes | nodes first isNil ifTrue: [nodes second] ifFalse: [nodes]]]

{ #category : #productions }
ODataURLParser >> minDateTimeMethodCallExpr [
	^super minDateTimeMethodCallExpr
		==> [:nodes | ODataFunctionCall new function: 'mindatetime']]

{ #category : #productions }
ODataURLParser >> minuteMethodCallExpr [
	^super minuteMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'minute' argument: (nodes at: 4)]]

{ #category : #productions }
ODataURLParser >> monthMethodCallExpr [
	^super monthMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'month' argument: (nodes at: 4)]]

{ #category : #productions }
ODataURLParser >> notExpr [
	^super notExpr
		==> [:nodes | ODataFunctionCall name: 'not' argument: nodes last]]

{ #category : #productions }
ODataURLParser >> nowMethodCallExpr [
	^super nowMethodCallExpr
		==> [:nodes | ODataFunctionCall new function: 'now']]

{ #category : #productions }
ODataURLParser >> nullValue [
	^super nullValue ==> [:nodes | ODataPrimitiveLiteral null]]

{ #category : #productions }
ODataURLParser >> odataRelativeUri [
	^super odataRelativeUri ==> [:nodes | | key format options context |
		key := nodes first.
		key = '$batch' ifTrue: [options := nil] ifFalse: [
			key = '$entity'
				ifTrue: [
					options := nodes last.
					key = 3 ifFalse: [key := key , nodes second , nodes third]]
				ifFalse: [
					key = '$metadata'
						ifTrue: [
							format := nodes second ifNotNil: [:n | n second].
							context := nodes last.
							options := (format notNil or: [context notNil])
								ifTrue: [{format. context}]]
						ifFalse: [options := nodes second ifNotNil: [:n | n second]]]].
		{key. options}]]

{ #category : #productions }
ODataURLParser >> odataUri [
	^super odataUri ==> [:nodes | | resource options |
		nodes second notNil ifTrue: [
			resource := nodes second first.
			options := nodes second last].
		ODataURL new
			root: nodes first;
			resource: resource;
			options: options]]

{ #category : #productions }
ODataURLParser >> orderby [
	^super orderby ==> [:nodes | | items |
		items := Array with: nodes third withAll: (nodes last collect: #second).
		ODataQueryOption name: nodes first value: items]]

{ #category : #productions }
ODataURLParser >> orderbyItem [
	^super orderbyItem ==> [:nodes | 
		nodes second notNil
			ifTrue: [nodes first -> nodes second second]
			ifFalse: [nodes first]]]

{ #category : #productions }
ODataURLParser >> propertyPathExpr [
	^super propertyPathExpr ==> [:nodes | | level |
		nodes isString ifTrue: [ODataPropertyPath fromString: nodes] ifFalse: [
			level := ODataPropertyPath fromString: nodes first.
			level , nodes second]]]

{ #category : #productions }
ODataURLParser >> queryOptions [
	^super queryOptions ==> [:nodes | | options |
		options := OrderedCollection new.
		options
			add: nodes first;
			addAll: (nodes second collect: #second).
		options]]

{ #category : #productions }
ODataURLParser >> roundMethodCallExpr [
	^super roundMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'round' argument: (nodes at: 4)]]

{ #category : #productions }
ODataURLParser >> sbyteValue [
	^super sbyteValue ==> [:nodes | 
		ODataPrimitiveLiteral new
			literal: nodes first;
			value: nodes first asInteger]]

{ #category : #productions }
ODataURLParser >> search [
	^super search
		==> [:nodes | ODataQueryOption name: nodes first value: nodes last]]

{ #category : #productions }
ODataURLParser >> secondMethodCallExpr [
	^super secondMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'second' argument: (nodes at: 4)]]

{ #category : #productions }
ODataURLParser >> select [
	^super select ==> [:nodes | 
		ODataQueryOption
			name: nodes first
			value: (Array with: nodes third withAll: (nodes last collect: #second))]]

{ #category : #productions }
ODataURLParser >> selectItem [
	^super selectItem ==> [:nodes | 
		(nodes isString not and: [nodes size = 2])
			ifTrue: [nodes second]
			ifFalse: [nodes]]]

{ #category : #productions }
ODataURLParser >> SIGN [
	^super SIGN
		==> [:nodes | nodes first = '%2B' ifTrue: ['+'] ifFalse: [nodes first]]]

{ #category : #productions }
ODataURLParser >> simpleKey [
	^super simpleKey
		==> [:nodes | ODataKeyPredicate new predicate: nodes second]]

{ #category : #productions }
ODataURLParser >> singleNavigationExpr [
	^super singleNavigationExpr ==> [:nodes | nodes second]]

{ #category : #productions }
ODataURLParser >> skip [
	^super skip
		==> [:nodes | ODataQueryOption
			name: nodes first
			value: nodes last asInteger]]

{ #category : #productions }
ODataURLParser >> skiptoken [
	^super skiptoken
		==> [:nodes | ODataQueryOption name: nodes first value: nodes last]]

{ #category : #productions }
ODataURLParser >> SQUOTE [
	^super SQUOTE ==> [:nodes | '''']]

{ #category : #productions }
ODataURLParser >> startsWithMethodCallExpr [
	^super startsWithMethodCallExpr
		==> [:nodes | ODataFunctionCall
			name: 'startswith'
			arguments: {nodes at: 4. nodes at: 8}]]

{ #category : #productions }
ODataURLParser >> string [
	^super string ==> [:literal | | string |
		string := literal copyFrom: 2 to: literal size - 1.
		ODataPrimitiveLiteral new literal: literal; value: string]]

{ #category : #productions }
ODataURLParser >> substringMethodCallExpr [
	^super indexOfMethodCallExpr ==> [:nodes | | string start end arguments |
		string := nodes at: 4.
		start := nodes at: 8.
		end := (nodes at: 10) ifNotNil: [:a | a third].
		arguments := end notNil
			ifTrue: [{string. start. end}]
			ifFalse: [{string. start}].
		ODataFunctionCall name: 'substring' arguments: arguments]]

{ #category : #productions }
ODataURLParser >> timeMethodCallExpr [
	^super timeMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'time' argument: (nodes at: 4)]]

{ #category : #productions }
ODataURLParser >> timeOfDayValue [
	^super timeOfDayValue ==> [:nodes | | literal seconds time |
		literal := self literalize: nodes.
		seconds := nodes last ifNil: 0.0 ifNotNil: [:s | s second asFloat].
		time := Time
			hours: nodes first asInteger
			minutes: nodes third asInteger
			seconds: seconds.
		ODataPrimitiveLiteral new literal: literal; value: time]]

{ #category : #productions }
ODataURLParser >> toLowerMethodCallExpr [
	^super indexOfMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'tolower' argument: nodes fourth]]

{ #category : #productions }
ODataURLParser >> top [
	^super top
		==> [:nodes | ODataQueryOption
			name: nodes first
			value: nodes last asInteger]]

{ #category : #productions }
ODataURLParser >> totalOffsetMinutesMethodCallExpr [
	^super totalOffsetMinutesMethodCallExpr
		==> [:nodes | ODataFunctionCall
			name: 'totaloffsetminutes'
			argument: (nodes at: 4)]]

{ #category : #productions }
ODataURLParser >> totalsecondsMethodCallExpr [
	^super totalsecondsMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'totalseconds' argument: (nodes
			at: 4)]]

{ #category : #productions }
ODataURLParser >> toUpperMethodCallExpr [
	^super indexOfMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'toupper' argument: nodes fourth]]

{ #category : #productions }
ODataURLParser >> trimMethodCallExpr [
	^super indexOfMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'trim' argument: nodes fourth]]

{ #category : #productions }
ODataURLParser >> yearMethodCallExpr [
	^super yearMethodCallExpr
		==> [:nodes | ODataFunctionCall name: 'year' argument: (nodes at: 4)]]

