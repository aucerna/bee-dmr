"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ODataURLGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'geoLiteral',
		'collectionLiteral',
		'complexInUri',
		'annotationInUri',
		'BWS',
		'OPEN',
		'CLOSE',
		'commonExpr',
		'COMMA',
		'odataIdentifier',
		'DIGIT',
		'EQ',
		'RWS',
		'namespace',
		'qualifiedEntityTypeName',
		'SQUOTE',
		'COLON',
		'SIGN',
		'OWS',
		'HEXDIG',
		'quotationmark',
		'functionParameters',
		'unreserved',
		'STAR',
		'complexProperty',
		'geometryPrefix',
		'sridLiteral',
		'geographyPrefix',
		'qualifiedComplexTypeName',
		'complexColProperty',
		'primitiveProperty',
		'pctencoded',
		'nameseparator',
		'primitiveColProperty',
		'boolOperatorExpr',
		'boolCommonExpr',
		'otherdelims',
		'ALPHA',
		'pchar',
		'oneToNine',
		'keyPredicate',
		'collectionPath',
		'searchExpr',
		'subdelims',
		'parameterAlias',
		'boundOperation',
		'valueseparator',
		'entitySetName',
		'boundFunctionExpr',
		'SP',
		'singleNavigation',
		'selectProperty',
		'expand',
		'expandItem',
		'expandOption',
		'contextPropertyPath',
		'selectList',
		'selectListItem',
		'selectListProperty',
		'complexPath',
		'propertyPath',
		'singleNavigationExpr',
		'memberExpr',
		'propertyPathExpr',
		'collectionNavigationExpr',
		'collectionNavigation',
		'singlePath',
		'collectionPathExpr'
	],
	#category : #OData
}

{ #category : #references }
ODataURLGrammar class >> references [
	'https://docs.oasis-open.org/odata/odata/v4.0/os/abnf/odata-abnf-construction-rules.txt'
		asURL
		browse]

{ #category : #productions }
ODataURLGrammar >> abstractSpatialTypeName [
	^'Geography' asParser / 'Geometry' asParser]

{ #category : #productions }
ODataURLGrammar >> action [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> actionImport [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> actionImportCall [
	^self actionImport]

{ #category : #productions }
ODataURLGrammar >> addExpr [
	^RWS , 'add' asParser , RWS , commonExpr]

{ #category : #productions }
ODataURLGrammar >> aliasAndValue [
	^parameterAlias , EQ , self parameterValue]

{ #category : #productions }
ODataURLGrammar >> allExpr [
	^'all' asParser , OPEN , BWS , self lambdaVariableExpr , BWS , COLON , BWS
		, self lambdaPredicateExpr
		, BWS
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> allOperationsInSchema [
	^(namespace , '.' asParser , STAR) flatten]

{ #category : #productions }
ODataURLGrammar >> allowEntityReferencesPreference [
	^'odata.allow-entityreferences' asParser]

{ #category : #productions }
ODataURLGrammar >> ALPHA [
	^(PPPredicateObjectParser between: 16r41 asCharacter and: 16r5A asCharacter)
		/ (PPPredicateObjectParser
			between: 16r61 asCharacter
			and: 16r7A asCharacter)]

{ #category : #productions }
ODataURLGrammar >> andExpr [
	^RWS , 'and' asParser , RWS , boolCommonExpr]

{ #category : #productions }
ODataURLGrammar >> annotationIdentifier [
	^self excludeOperator optional
		, (STAR / (namespace , '.' asParser , (self termName / STAR)))]

{ #category : #productions }
ODataURLGrammar >> annotationInUri [
	^quotationmark , namespace , '.' asParser , self termName , quotationmark
		, nameseparator
		, (complexInUri / self complexColInUri / self primitiveLiteralInJSON
			/ self primitiveColInUri)]

{ #category : #productions }
ODataURLGrammar >> annotationsList [
	| annotationIdentifier |
	annotationIdentifier := self annotationIdentifier.
	^annotationIdentifier , (COMMA , annotationIdentifier) star]

{ #category : #productions }
ODataURLGrammar >> anyExpr [
	^'any' asParser , OPEN , BWS
		, (self lambdaVariableExpr , BWS , COLON , BWS , self lambdaPredicateExpr) optional
		, BWS
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> arrayOrObject [
	^self complexColInUri / complexInUri / self rootExprCol
		/ self primitiveColInUri]

{ #category : #productions }
ODataURLGrammar >> AT [
	^'@' asParser / '%40' asParser]

{ #category : #productions }
ODataURLGrammar >> AtoF [
	^'A' asParser / 'B' asParser / 'C' asParser / 'D' asParser / 'E' asParser
		/ 'F' asParser]

{ #category : #productions }
ODataURLGrammar >> authority [
	^(self userinfo , '@' asParser) optional , self host
		, (':' asParser , self port) optional]

{ #category : #productions }
ODataURLGrammar >> base64b16 [
	^(self base64char times: 2)
		, ('A' asParser / 'E' asParser / 'I' asParser / 'M' asParser
			/ 'Q' asParser
			/ 'U' asParser
			/ 'Y' asParser
			/ 'c' asParser
			/ 'g' asParser
			/ 'k' asParser
			/ 'o' asParser
			/ 's' asParser
			/ 'w' asParser
			/ '0' asParser
			/ '4' asParser
			/ '8' asParser)
		, '=' asParser optional]

{ #category : #productions }
ODataURLGrammar >> base64b8 [
	^self base64char
		, ('A' asParser / 'Q' asParser / 'g' asParser / 'w' asParser)
		, '==' asParser optional]

{ #category : #productions }
ODataURLGrammar >> base64char [
	^ALPHA / DIGIT / '-' asParser / '_' asParser]

{ #category : #productions }
ODataURLGrammar >> beginarray [
	^BWS , ('[' asParser / '%5B' asParser) , BWS]

{ #category : #productions }
ODataURLGrammar >> beginobject [
	^BWS , ('{' asParser / '%7B' asParser) , BWS]

{ #category : #productions }
ODataURLGrammar >> binary [
	^'binary' asParser , SQUOTE , self binaryValue , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> binaryValue [
	^(self base64char times: 4) star , (self base64b16 / self base64b8) optional]

{ #category : #productions }
ODataURLGrammar >> boolBinaryExpr [
	^commonExpr
		, (self eqExpr / self neExpr / self ltExpr / self leExpr / self gtExpr
			/ self geExpr
			/ self hasExpr)
			optional]

{ #category : #productions }
ODataURLGrammar >> boolCommonExpr [
	^boolOperatorExpr , (self andExpr / self orExpr) optional]

{ #category : #productions }
ODataURLGrammar >> booleanValue [
	^'true' asParser / 'false' asParser]

{ #category : #productions }
ODataURLGrammar >> boolMethodCallExpr [
	^self endsWithMethodCallExpr / self startsWithMethodCallExpr
		/ self containsMethodCallExpr
		/ self intersectsMethodCallExpr]

{ #category : #productions }
ODataURLGrammar >> boolOperatorExpr [
	^self isofExpr / self boolMethodCallExpr / self notExpr
		/ self boolBinaryExpr
		/ self boolParenExpr]

{ #category : #productions }
ODataURLGrammar >> boolParenExpr [
	^OPEN , BWS , boolCommonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> boundActionCall [
	^namespace , '.' asParser , self action]

{ #category : #productions }
ODataURLGrammar >> boundComplexColFuncCall [
	^namespace , '.' asParser , self complexColFunction , functionParameters]

{ #category : #productions }
ODataURLGrammar >> boundComplexFuncCall [
	^namespace , '.' asParser , self complexFunction , functionParameters]

{ #category : #productions }
ODataURLGrammar >> boundEntityColFuncCall [
	^namespace , '.' asParser , self entityColFunction , functionParameters]

{ #category : #productions }
ODataURLGrammar >> boundEntityFuncCall [
	^namespace , '.' asParser , self entityFunction , functionParameters]

{ #category : #productions }
ODataURLGrammar >> boundFunctionExpr [
	^self functionExpr]

{ #category : #productions }
ODataURLGrammar >> boundOperation [
	^'/' asParser
		, (self boundActionCall
			/ (self boundEntityColFuncCall , collectionNavigation optional)
			/ (self boundEntityFuncCall , singleNavigation optional)
			/ (self boundComplexColFuncCall , collectionPath optional)
			/ (self boundComplexFuncCall , complexPath optional)
			/ (self boundPrimitiveColFuncCall , collectionPath optional)
			/ (self boundPrimitiveFuncCall , singlePath optional))]

{ #category : #productions }
ODataURLGrammar >> boundPrimitiveColFuncCall [
	^namespace , '.' asParser , self primitiveColFunction , functionParameters]

{ #category : #productions }
ODataURLGrammar >> boundPrimitiveFuncCall [
	^namespace , '.' asParser , self primitiveFunction , functionParameters]

{ #category : #productions }
ODataURLGrammar >> BWS [
	^OWS]

{ #category : #productions }
ODataURLGrammar >> byteValue [
	^(DIGIT min: 1 max: 3) flatten]

{ #category : #productions }
ODataURLGrammar >> callbackPreference [
	| dquote |
	dquote := self DQUOTE.
	^'odata.callback' asParser , OWS , ';' asParser , OWS , 'url' asParser
		, BWS
		, EQ
		, BWS
		, dquote
		, self URI
		, dquote]

{ #category : #productions }
ODataURLGrammar >> castExpr [
	^'cast' asParser , OPEN , BWS , (commonExpr , BWS , COMMA , BWS) optional
		, self qualifiedTypeName
		, BWS
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> ceilingMethodCallExpr [
	^'ceiling' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> charInJSON [
	^self qcharunescaped / self qcharJSONspecial / self escape
		, (quotationmark / self escape / ('/' asParser / '%2F' asParser)
			/ 'b' asParser
			/ 'f' asParser
			/ 'n' asParser
			/ 'r' asParser
			/ 't' asParser
			/ ('u' asParser , (HEXDIG times: 4)))]

{ #category : #productions }
ODataURLGrammar >> CLOSE [
	^')' asParser / '%29' asParser]

{ #category : #productions }
ODataURLGrammar >> collectionLiteral [
	^'Collection(' asParser , geoLiteral , (COMMA , geoLiteral) star , CLOSE]

{ #category : #productions }
ODataURLGrammar >> collectionNavigation [
	^('/' asParser , qualifiedEntityTypeName) optional
		, self collectionNavPath optional]

{ #category : #productions }
ODataURLGrammar >> collectionNavigationExpr [
	^('/' asParser , qualifiedEntityTypeName) optional
		, (keyPredicate , singleNavigationExpr optional / collectionPathExpr)]

{ #category : #productions }
ODataURLGrammar >> collectionNavPath [
	^keyPredicate , singleNavigation optional / collectionPath / self ref]

{ #category : #productions }
ODataURLGrammar >> collectionNavPropInJSON [
	^quotationmark , self entityColNavigationProperty , quotationmark
		, nameseparator
		, self rootExprCol]

{ #category : #productions }
ODataURLGrammar >> collectionPath [
	^self count / boundOperation]

{ #category : #productions }
ODataURLGrammar >> collectionPathExpr [
	| slash |
	slash := '/' asParser.
	^self count / (slash , boundFunctionExpr) / (slash , self anyExpr)
		/ (slash , self allExpr)]

{ #category : #productions }
ODataURLGrammar >> collectionPropertyInUri [
	^quotationmark , primitiveColProperty , quotationmark , nameseparator
		, self primitiveColInUri
		/ (quotationmark , complexColProperty , quotationmark , nameseparator
			, self complexColInUri)]

{ #category : #productions }
ODataURLGrammar >> COLON [
	^':' asParser / '%3A' asParser]

{ #category : #productions }
ODataURLGrammar >> COMMA [
	^',' asParser / '%2C' asParser]

{ #category : #productions }
ODataURLGrammar >> commonExpr [
	^self primitiveLiteral / parameterAlias / self arrayOrObject
		/ self methodCallExpr
		/ self rootExpr
		/ self firstMemberExpr
		/ self functionExpr
		/ self negateExpr
		/ self parenExpr
		/ self castExpr
		, (self addExpr / self subExpr / self mulExpr / self divExpr
			/ self modExpr)
			optional]

{ #category : #productions }
ODataURLGrammar >> complexColFunction [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> complexColFunctionImport [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> complexColFunctionImportCall [
	^self complexColFunctionImport , functionParameters]

{ #category : #productions }
ODataURLGrammar >> complexColInUri [
	^self beginarray
		, (complexInUri , (valueseparator , complexInUri) star) optional
		, self endarray]

{ #category : #productions }
ODataURLGrammar >> complexColProperty [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> complexFunction [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> complexFunctionImport [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> complexFunctionImportCall [
	^self complexFunctionImport , functionParameters]

{ #category : #productions }
ODataURLGrammar >> complexInUri [
	^self beginobject
		, (annotationInUri / self primitivePropertyInUri
			/ self complexPropertyInUri
			/ self collectionPropertyInUri
			/ self navigationPropertyInUri
			, (valueseparator
				, (annotationInUri / self primitivePropertyInUri
					/ self complexPropertyInUri
					/ self collectionPropertyInUri
					/ self navigationPropertyInUri))
				star)
			optional
		, self endobject]

{ #category : #productions }
ODataURLGrammar >> complexPath [
	| slash |
	slash := '/' asParser.
	^(slash , qualifiedComplexTypeName) optional
		, (slash , propertyPath / boundOperation)]

{ #category : #productions }
ODataURLGrammar >> complexPathExpr [
	| slash |
	slash := '/' asParser.
	^slash , (qualifiedComplexTypeName , slash) optional
		, (propertyPathExpr / boundFunctionExpr)]

{ #category : #productions }
ODataURLGrammar >> complexProperty [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> complexPropertyInUri [
	^quotationmark , complexProperty , quotationmark , nameseparator
		, complexInUri]

{ #category : #productions }
ODataURLGrammar >> complexTypeName [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> compoundKey [
	| keyValuePair |
	keyValuePair := self keyValuePair.
	^OPEN , keyValuePair , (COMMA , keyValuePair) star , CLOSE]

{ #category : #productions }
ODataURLGrammar >> concatMethodCallExpr [
	^'concat' asParser , OPEN , BWS , commonExpr , BWS , COMMA , BWS
		, commonExpr
		, BWS
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> concreteSpatialTypeName [
	^'Collection' asParser / 'LineString' asParser / 'MultiLineString' asParser
		/ 'MultiPoint' asParser
		/ 'MultiPolygon' asParser
		/ 'Point' asParser
		/ 'Polygon' asParser]

{ #category : #productions }
ODataURLGrammar >> containmentNavigation [
	| slash |
	slash := '/' asParser.
	^keyPredicate , (slash , qualifiedEntityTypeName) optional
		, (slash , complexProperty , (slash , qualifiedComplexTypeName) optional) star
		, slash
		, self navigationProperty]

{ #category : #productions }
ODataURLGrammar >> containsMethodCallExpr [
	^'contains' asParser , OPEN , BWS , commonExpr , BWS , COMMA , BWS
		, commonExpr
		, BWS
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> contentid [
	^'Content-ID' asParser , COLON , OWS , unreserved plus]

{ #category : #productions }
ODataURLGrammar >> context [
	^'#' asParser , self contextFragment]

{ #category : #productions }
ODataURLGrammar >> contextFragment [
	| entitySet |
	entitySet := self entitySet.
	^'Collection($ref)' asParser / '$ref' asParser
		/ 'Collection(Edm.EntityType)' asParser
		/ 'Collection(Edm.ComplexType)' asParser
		/ self singletonEntity
		/ self qualifiedTypeName
		/ (entitySet
			, ('/$deletedEntity' asParser / '/$link' asParser
				/ '/$deletedLink' asParser))
		/ (entitySet , keyPredicate , '/' asParser , contextPropertyPath)
		/ (entitySet , selectList optional
			, ('/$entity' asParser / '/$delta' asParser) optional)]

{ #category : #productions }
ODataURLGrammar >> contextPropertyPath [
	| slash |
	slash := '/' asParser.
	^primitiveProperty / primitiveColProperty / complexColProperty
		/ (complexProperty
			, ((slash , qualifiedComplexTypeName) optional , slash
				, contextPropertyPath)
				optional)]

{ #category : #productions }
ODataURLGrammar >> continueOnErrorPreference [
	^'odata.continue-on-error' asParser]

{ #category : #productions }
ODataURLGrammar >> count [
	^'/$count' asParser]

{ #category : #productions }
ODataURLGrammar >> crossjoin [
	^'$crossjoin' asParser , OPEN , entitySetName
		, (COMMA , entitySetName) star
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> customName [
	^(self qcharnoAMPEQATDOLLAR , self qcharnoAMPEQ star) flatten]

{ #category : #productions }
ODataURLGrammar >> customQueryOption [
	^self customName , (EQ , self customValue) optional]

{ #category : #productions }
ODataURLGrammar >> customValue [
	^self qcharnoAMP star flatten]

{ #category : #productions }
ODataURLGrammar >> dateMethodCallExpr [
	^'date' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> dateTimeOffsetValue [
	| hyphen hour colon minute |
	hyphen := '-' asParser.
	hour := self hour.
	minute := self minute.
	colon := ':' asParser.
	^self year flatten , hyphen , self month flatten , hyphen
		, self day flatten
		, 'T' asParser
		, hour flatten
		, colon
		, minute flatten
		, (colon
			, (self second , ('.' asParser , self fractionalSeconds) optional) flatten)
			optional
		, ('Z' asParser / SIGN , hour flatten , colon , minute flatten)]

{ #category : #productions }
ODataURLGrammar >> dateValue [
	| hyphen |
	hyphen := '-' asParser.
	^self year flatten , hyphen , self month flatten , hyphen
		, self day flatten]

{ #category : #productions }
ODataURLGrammar >> day [
	^'0' asParser , oneToNine / ('1' asParser / '2' asParser , DIGIT)
		/ ('3' asParser , ('0' asParser / '1' asParser))]

{ #category : #productions }
ODataURLGrammar >> dayMethodCallExpr [
	^'day' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> decimalValue [
	^(SIGN optional , DIGIT plus , ('.' asParser , DIGIT plus) optional) flatten]

{ #category : #productions }
ODataURLGrammar >> decoctet [
	^('1' asParser , (DIGIT times: 2)) flatten
		/ ('2' asParser , (PPPredicateObjectParser between: $1 and: $4) , DIGIT) flatten
		/ ('25' asParser , (PPPredicateObjectParser between: $0 and: $5)) flatten
		/ ((PPPredicateObjectParser between: $1 and: $9) , DIGIT) flatten
		/ DIGIT]

{ #category : #productions }
ODataURLGrammar >> DIGIT [
	^PPPredicateObjectParser between: 16r30 asCharacter and: 16r39 asCharacter]

{ #category : #productions }
ODataURLGrammar >> distanceMethodCallExpr [
	^'geo.distance' asParser , OPEN , BWS , commonExpr , BWS , COMMA , BWS
		, commonExpr
		, BWS
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> divExpr [
	^RWS , 'div' asParser , RWS , commonExpr]

{ #category : #productions }
ODataURLGrammar >> doubleValue [
	^(self decimalValue , ('e' asParser , SIGN optional , DIGIT plus) optional) flatten
		/ self nanInfinity]

{ #category : #productions }
ODataURLGrammar >> DQUOTE [
	^$" asParser]

{ #category : #productions }
ODataURLGrammar >> duration [
	^'duration' asParser , SQUOTE , self durationValue , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> durationValue [
	| digits |
	digits := DIGIT plus.
	^SIGN optional , 'P' asParser , (digits , 'D' asParser) optional
		, ('T' asParser , (digits , 'H' asParser) optional
			, (digits , 'M' asParser) optional
			, (digits , ('.' asParser , digits) optional , 'S' asParser) optional)
			optional]

{ #category : #productions }
ODataURLGrammar >> endarray [
	^BWS , (']' asParser / '%5D' asParser) , BWS]

{ #category : #productions }
ODataURLGrammar >> endobject [
	^BWS , ('}' asParser / '%7D' asParser) , BWS]

{ #category : #productions }
ODataURLGrammar >> endsWithMethodCallExpr [
	^'endswith' asParser , OPEN , BWS , commonExpr , BWS , COMMA , BWS
		, commonExpr
		, BWS
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> entityCastOption [
	^self entityIdOption / expand / self select]

{ #category : #productions }
ODataURLGrammar >> entityCastOptions [
	| entityCastOption and |
	entityCastOption := self entityCastOption.
	and := '&' asParser.
	^(entityCastOption , and) star , self id , (and , entityCastOption) star]

{ #category : #productions }
ODataURLGrammar >> entityColFunction [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> entityColFunctionImport [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> entityColFunctionImportCall [
	^self entityColFunctionImport , functionParameters]

{ #category : #productions }
ODataURLGrammar >> entityColNavigationProperty [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> entityFunction [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> entityFunctionImport [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> entityFunctionImportCall [
	^self entityFunctionImport , functionParameters]

{ #category : #productions }
ODataURLGrammar >> entityIdOption [
	^self format / self customQueryOption]

{ #category : #productions }
ODataURLGrammar >> entityNavigationProperty [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> entityOptions [
	| entityIdOption and |
	entityIdOption := self entityIdOption.
	and := '&' asParser.
	^(entityIdOption , and) star , self id , (and , entityIdOption) star]

{ #category : #productions }
ODataURLGrammar >> entitySet [
	^entitySetName , self containmentNavigation star
		, ('/' asParser , qualifiedEntityTypeName) optional]

{ #category : #productions }
ODataURLGrammar >> entitySetName [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> entityTypeName [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> enum [
	^self qualifiedEnumTypeName , SQUOTE , self enumValue , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> enumerationMember [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> enumerationTypeName [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> enumMemberValue [
	^self int64Value]

{ #category : #productions }
ODataURLGrammar >> enumValue [
	| singleEnumValue |
	singleEnumValue := self singleEnumValue.
	^singleEnumValue , (COMMA , singleEnumValue) star]

{ #category : #productions }
ODataURLGrammar >> EQ [
	^'=' asParser]

{ #category : #productions }
ODataURLGrammar >> eqExpr [
	^RWS , 'eq' asParser , RWS , commonExpr]

{ #category : #productions }
ODataURLGrammar >> escape [
	^'\' asParser / '%5C' asParser]

{ #category : #productions }
ODataURLGrammar >> excludeOperator [
	^'-' asParser]

{ #category : #productions }
ODataURLGrammar >> exp [
	^'e' asParser , ('-' asParser / '+' asParser) optional , DIGIT plus]

{ #category : #productions }
ODataURLGrammar >> expand [
	^'$expand' asParser , EQ , expandItem , (COMMA , expandItem) star]

{ #category : #productions }
ODataURLGrammar >> expandCountOption [
	^self filter / self search]

{ #category : #productions }
ODataURLGrammar >> expandItem [
	| ref semi expandRefOption expandCountOption |
	ref := self ref.
	semi := self SEMI.
	expandRefOption := self expandRefOption.
	expandCountOption := self expandCountOption.
	^STAR , (ref / (OPEN , self levels , CLOSE)) optional
		/ (self expandPath
			, (ref
				, (OPEN , expandRefOption , (semi , expandRefOption) star , CLOSE) optional
				/ (self count
					, (OPEN , expandCountOption , (semi , expandCountOption) star , CLOSE) optional)
				/ (OPEN , expandOption , (semi , expandOption) star , CLOSE))
				optional)]

{ #category : #productions }
ODataURLGrammar >> expandOption [
	^self expandRefOption / self select / expand / self levels]

{ #category : #productions }
ODataURLGrammar >> expandPath [
	| slash |
	slash := '/' asParser.
	^(qualifiedEntityTypeName , slash) optional
		, (complexProperty / complexColProperty , slash
			, (qualifiedComplexTypeName , slash) optional)
			star
		, self navigationProperty
		, (slash , qualifiedEntityTypeName) optional]

{ #category : #productions }
ODataURLGrammar >> expandRefOption [
	^self expandCountOption / self orderby / self skip / self top
		/ self inlinecount]

{ #category : #productions }
ODataURLGrammar >> filter [
	^'$filter' asParser , EQ , boolCommonExpr]

{ #category : #productions }
ODataURLGrammar >> firstMemberExpr [
	^memberExpr
		/ (self inscopeVariableExpr , ('/' asParser , memberExpr) optional)]

{ #category : #productions }
ODataURLGrammar >> floorMethodCallExpr [
	^'floor' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> format [
	^'$format' asParser , EQ
		, ('atom' asParser / 'json' asParser / 'xml' asParser
			/ (pchar plus , '/' asParser , pchar plus) flatten)]

{ #category : #productions }
ODataURLGrammar >> frac [
	^'.' asParser , DIGIT plus]

{ #category : #productions }
ODataURLGrammar >> fractionalSeconds [
	^DIGIT min: 1 max: 12]

{ #category : #productions }
ODataURLGrammar >> fractionalsecondsMethodCallExpr [
	^'fractionalseconds' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> fragment [
	^(pchar / '/' asParser / '?' asParser) star]

{ #category : #productions }
ODataURLGrammar >> fullCollectionLiteral [
	^sridLiteral , collectionLiteral]

{ #category : #productions }
ODataURLGrammar >> fullLineStringLiteral [
	^sridLiteral , self lineStringLiteral]

{ #category : #productions }
ODataURLGrammar >> fullMultiLineStringLiteral [
	^sridLiteral , self multiLineStringLiteral]

{ #category : #productions }
ODataURLGrammar >> fullMultiPointLiteral [
	^sridLiteral , self multiPointLiteral]

{ #category : #productions }
ODataURLGrammar >> fullMultiPolygonLiteral [
	^sridLiteral , self multiPolygonLiteral]

{ #category : #productions }
ODataURLGrammar >> fullPointLiteral [
	^sridLiteral , self pointLiteral]

{ #category : #productions }
ODataURLGrammar >> fullPolygonLiteral [
	^sridLiteral , self polygonLiteral]

{ #category : #productions }
ODataURLGrammar >> function [
	^self entityFunction / self entityColFunction / self complexFunction
		/ self complexColFunction
		/ self primitiveFunction
		/ self primitiveColFunction]

{ #category : #productions }
ODataURLGrammar >> functionExpr [
	| functionExprParameters |
	functionExprParameters := self functionExprParameters.
	^namespace , '.' asParser
		, (self entityColFunction , functionExprParameters
			, collectionNavigationExpr optional
			/ (self entityFunction , functionExprParameters
				, singleNavigationExpr optional)
			/ (self complexColFunction , functionExprParameters
				, collectionPathExpr optional)
			/ (self complexFunction , functionExprParameters
				, self complexPathExpr optional)
			/ (self primitiveColFunction , functionExprParameters
				, collectionPathExpr optional)
			/ (self primitiveFunction , functionExprParameters
				, self singlePathExpr optional))]

{ #category : #productions }
ODataURLGrammar >> functionExprParameter [
	^self parameterName , EQ , (parameterAlias / self parameterValue)]

{ #category : #productions }
ODataURLGrammar >> functionExprParameters [
	| functionExprParameter |
	functionExprParameter := self functionExprParameter.
	^OPEN
		, (functionExprParameter , (COMMA , functionExprParameter) star) optional
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> functionParameter [
	^self parameterName , EQ , (parameterAlias / self primitiveLiteral flatten)]

{ #category : #productions }
ODataURLGrammar >> functionParameters [
	^OPEN
		, (self functionParameter , (COMMA , self functionParameter) star) optional
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> geExpr [
	^RWS , 'ge' asParser , RWS , commonExpr]

{ #category : #productions }
ODataURLGrammar >> geographyCollection [
	^geographyPrefix , SQUOTE , self fullCollectionLiteral , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> geographyLineString [
	^geographyPrefix , SQUOTE , self fullLineStringLiteral , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> geographyMultiLineString [
	^geographyPrefix , SQUOTE , self fullMultiLineStringLiteral , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> geographyMultiPoint [
	^geographyPrefix , SQUOTE , self fullMultiPointLiteral , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> geographyMultiPolygon [
	^geographyPrefix , SQUOTE , self fullMultiPolygonLiteral , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> geographyPoint [
	^geographyPrefix , SQUOTE , self fullPointLiteral , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> geographyPolygon [
	^geographyPrefix , SQUOTE , self fullPolygonLiteral , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> geographyPrefix [
	^'geography' asParser]

{ #category : #productions }
ODataURLGrammar >> geoLengthMethodCallExpr [
	^'geo.length' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> geoLiteral [
	^collectionLiteral / self lineStringLiteral / self multiPointLiteral
		/ self multiLineStringLiteral
		/ self multiPolygonLiteral
		/ self pointLiteral
		/ self polygonLiteral]

{ #category : #productions }
ODataURLGrammar >> geometryCollection [
	^geometryPrefix , SQUOTE , self fullCollectionLiteral , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> geometryLineString [
	^geometryPrefix , SQUOTE , self fullLineStringLiteral , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> geometryMultiLineString [
	^geometryPrefix , SQUOTE , self fullMultiLineStringLiteral , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> geometryMultiPoint [
	^geometryPrefix , SQUOTE , self fullMultiPointLiteral , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> geometryMultiPolygon [
	^geometryPrefix , SQUOTE , self fullMultiPolygonLiteral , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> geometryPoint [
	^geometryPrefix , SQUOTE , self fullPointLiteral , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> geometryPolygon [
	^geometryPrefix , SQUOTE , self fullPolygonLiteral , SQUOTE]

{ #category : #productions }
ODataURLGrammar >> geometryPrefix [
	^'geometry' asParser]

{ #category : #productions }
ODataURLGrammar >> gtExpr [
	^RWS , 'gt' asParser , RWS , commonExpr]

{ #category : #productions }
ODataURLGrammar >> guidValue [
	| hexdig4 hyphen |
	hexdig4 := HEXDIG times: 4.
	hyphen := '-' asParser.
	^((HEXDIG times: 8) , hyphen , hexdig4 , hyphen , hexdig4 , hyphen , hexdig4
		, hyphen
		, (HEXDIG times: 12))
		flatten]

{ #category : #productions }
ODataURLGrammar >> h16 [
	^HEXDIG min: 1 max: 4]

{ #category : #productions }
ODataURLGrammar >> hasExpr [
	^RWS , 'has' asParser , RWS , commonExpr]

{ #category : #productions }
ODataURLGrammar >> header [
	^self contentid / self odataentityid / self odataisolation
		/ self odatamaxversion
		/ self odataversion
		/ self prefer]

{ #category : #productions }
ODataURLGrammar >> HEXDIG [
	^DIGIT / self AtoF]

{ #category : #productions }
ODataURLGrammar >> hierpart [
	^'//' asParser , self authority , self pathabempty / self pathabsolute
		/ self pathrootless]

{ #category : #productions }
ODataURLGrammar >> host [
	^self IPliteral / self IPv4address / self regname]

{ #category : #productions }
ODataURLGrammar >> hour [
	^'0' asParser / '1' asParser , DIGIT
		/ ('2' asParser , ('1' asParser / '2' asParser / '3' asParser))]

{ #category : #productions }
ODataURLGrammar >> hourMethodCallExpr [
	^'hour' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> HTAB [
	#tab asParser]

{ #category : #productions }
ODataURLGrammar >> id [
	^'$id' asParser , EQ , self IRIinquery]

{ #category : #productions }
ODataURLGrammar >> identifierCharacter [
	^ALPHA / '_' asParser / DIGIT]

{ #category : #productions }
ODataURLGrammar >> identifierLeadingCharacter [
	^ALPHA / '_' asParser]

{ #category : #productions }
ODataURLGrammar >> implicitVariableExpr [
	^'$it' asParser]

{ #category : #productions }
ODataURLGrammar >> includeAnnotationsPreference [
	| dquote |
	dquote := self DQUOTE.
	^'odata.include-annotations' asParser , BWS , EQ , BWS , dquote
		, self annotationsList
		, dquote]

{ #category : #productions }
ODataURLGrammar >> indexOfMethodCallExpr [
	^'indexof' asParser , OPEN , BWS , commonExpr , BWS , COMMA , BWS
		, commonExpr
		, BWS
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> inlinecount [
	^'$count' asParser , EQ , self booleanValue]

{ #category : #productions }
ODataURLGrammar >> inscopeVariableExpr [
	^self implicitVariableExpr / self lambdaVariableExpr]

{ #category : #productions }
ODataURLGrammar >> int [
	^'0' asParser / (oneToNine , DIGIT star)]

{ #category : #productions }
ODataURLGrammar >> int16Value [
	^(SIGN optional , (DIGIT min: 1 max: 5)) flatten]

{ #category : #productions }
ODataURLGrammar >> int32Value [
	^(SIGN optional , (DIGIT min: 1 max: 10)) flatten]

{ #category : #productions }
ODataURLGrammar >> int64Value [
	^(SIGN optional , (DIGIT min: 1 max: 19)) flatten]

{ #category : #productions }
ODataURLGrammar >> intersectsMethodCallExpr [
	^'geo.intersects' asParser , OPEN , BWS , commonExpr , BWS , COMMA , BWS
		, commonExpr
		, BWS
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> IPliteral [
	^'[' asParser , (self IPv6address / self IPvFuture) , ']' asParser]

{ #category : #productions }
ODataURLGrammar >> IPv4address [
	| dot decoctet |
	dot := '.' asParser.
	decoctet := self decoctet.
	^(decoctet , dot , decoctet , dot , decoctet , dot , decoctet) flatten]

{ #category : #productions }
ODataURLGrammar >> IPv6address [
	| h16 ls32 colon dcolon |
	h16 := self h16.
	ls32 := self ls32.
	colon := ':' asParser.
	dcolon := '::' asParser.
	^(h16 , colon times: 6) , ls32 / (dcolon , (h16 ":" times: 5) , ls32)
		/ (h16 optional , dcolon , (h16 , colon times: 4) , ls32)
		/ (((h16 , colon max: 1) , h16) optional , dcolon , (h16 , colon times: 3)
			, ls32)
		/ (((h16 , colon max: 2) , h16) optional , dcolon , (h16 , colon times: 2)
			, ls32)
		/ (((h16 , colon max: 3) , h16) optional , dcolon , h16 , colon , ls32)
		/ ((h16 , colon max: 4) , h16 optional , dcolon , ls32)
		/ ((h16 , colon max: 5) , h16 optional , dcolon , h16)
		/ ((h16 , colon max: 6) , h16 optional , dcolon)]

{ #category : #productions }
ODataURLGrammar >> IPvFuture [
	^'v' asParser , HEXDIG plus , '.' asParser
		, (unreserved / subdelims / ':' asParser) plus]

{ #category : #productions }
ODataURLGrammar >> IRIinheader [
	^(self VCHAR / self obstext) plus]

{ #category : #productions }
ODataURLGrammar >> IRIinquery [
	^self qcharnoAMP plus flatten]

{ #category : #productions }
ODataURLGrammar >> isofExpr [
	^'isof' asParser , OPEN , BWS , (commonExpr , BWS , COMMA , BWS) optional
		, self qualifiedTypeName
		, BWS
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> keyPredicate [
	^self simpleKey / self compoundKey]

{ #category : #productions }
ODataURLGrammar >> keyPropertyAlias [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> keyPropertyValue [
	^self primitiveLiteral]

{ #category : #productions }
ODataURLGrammar >> keyValuePair [
	^self primitiveKeyProperty / self keyPropertyAlias , EQ
		, self keyPropertyValue]

{ #category : #productions }
ODataURLGrammar >> lambdaPredicateExpr [
	^boolCommonExpr]

{ #category : #productions }
ODataURLGrammar >> lambdaVariableExpr [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> leExpr [
	^RWS , 'le' asParser , RWS , commonExpr]

{ #category : #productions }
ODataURLGrammar >> lengthMethodCallExpr [
	^'length' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> levels [
	^'$levels' asParser , EQ , (DIGIT plus / 'max' asParser)]

{ #category : #productions }
ODataURLGrammar >> lineStringData [
	| positionLiteral |
	positionLiteral := self positionLiteral.
	^OPEN , positionLiteral , (self COMMA , positionLiteral) plus , CLOSE]

{ #category : #productions }
ODataURLGrammar >> lineStringLiteral [
	^'LineString' asParser , self lineStringData]

{ #category : #productions }
ODataURLGrammar >> ls32 [
	| h16 |
	h16 := self h16.
	^h16 , ':' asParser , h16 / self IPv4address]

{ #category : #productions }
ODataURLGrammar >> ltExpr [
	^RWS , 'lt' asParser , RWS , commonExpr]

{ #category : #productions }
ODataURLGrammar >> maxDateTimeMethodCallExpr [
	^'maxdatetime(' asParser , BWS , ')' asParser]

{ #category : #productions }
ODataURLGrammar >> maxpagesizePreference [
	^'odata.maxpagesize' asParser , BWS , EQ , BWS , oneToNine , DIGIT star]

{ #category : #productions }
ODataURLGrammar >> memberExpr [
	^(qualifiedEntityTypeName , '/' asParser) optional
		, (propertyPathExpr / boundFunctionExpr)]

{ #category : #productions }
ODataURLGrammar >> methodCallExpr [
	^self indexOfMethodCallExpr / self toLowerMethodCallExpr
		/ self toUpperMethodCallExpr
		/ self trimMethodCallExpr
		/ self substringMethodCallExpr
		/ self concatMethodCallExpr
		/ self lengthMethodCallExpr
		/ self yearMethodCallExpr
		/ self monthMethodCallExpr
		/ self dayMethodCallExpr
		/ self hourMethodCallExpr
		/ self minuteMethodCallExpr
		/ self secondMethodCallExpr
		/ self fractionalsecondsMethodCallExpr
		/ self totalsecondsMethodCallExpr
		/ self dateMethodCallExpr
		/ self timeMethodCallExpr
		/ self roundMethodCallExpr
		/ self floorMethodCallExpr
		/ self ceilingMethodCallExpr
		/ self distanceMethodCallExpr
		/ self geoLengthMethodCallExpr
		/ self totalOffsetMinutesMethodCallExpr
		/ self minDateTimeMethodCallExpr
		/ self maxDateTimeMethodCallExpr
		/ self nowMethodCallExpr]

{ #category : #productions }
ODataURLGrammar >> minDateTimeMethodCallExpr [
	^'mindatetime(' asParser , BWS , ')' asParser]

{ #category : #productions }
ODataURLGrammar >> minute [
	^self zeroToFiftyNine]

{ #category : #productions }
ODataURLGrammar >> minuteMethodCallExpr [
	^'minute' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> modExpr [
	^RWS , 'mod' asParser , RWS , commonExpr]

{ #category : #productions }
ODataURLGrammar >> month [
	^'0' asParser , oneToNine
		/ ('1' asParser , ('0' asParser / '1' asParser / '2' asParser))]

{ #category : #productions }
ODataURLGrammar >> monthMethodCallExpr [
	^'month' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> mulExpr [
	^RWS , 'mul' asParser , RWS , commonExpr]

{ #category : #productions }
ODataURLGrammar >> multiLineStringLiteral [
	| lineStringData |
	lineStringData := self lineStringData.
	^'MultiLineString(' asParser
		, (lineStringData , (COMMA , lineStringData) star) optional
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> multiPointLiteral [
	| pointData |
	pointData := self pointData.
	^'MultiPoint(' asParser , (pointData , (COMMA , pointData) star) optional
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> multiPolygonLiteral [
	| polygonData |
	polygonData := self polygonData.
	^'MultiPolygon(' asParser
		, (polygonData , (COMMA , polygonData) star) optional
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> nameseparator [
	^BWS , COLON , BWS]

{ #category : #productions }
ODataURLGrammar >> namespace [
	| namespacePart |
	namespacePart := self namespacePart.
	^namespacePart , ('.' asParser , namespacePart) star]

{ #category : #productions }
ODataURLGrammar >> namespacePart [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> nanInfinity [
	^'NaN' asParser / '-INF' asParser / 'INF' asParser]

{ #category : #productions }
ODataURLGrammar >> navigationProperty [
	^self entityNavigationProperty / self entityColNavigationProperty]

{ #category : #productions }
ODataURLGrammar >> navigationPropertyInUri [
	^self singleNavPropInJSON / self collectionNavPropInJSON]

{ #category : #productions }
ODataURLGrammar >> neExpr [
	^RWS , 'ne' asParser , RWS , commonExpr]

{ #category : #productions }
ODataURLGrammar >> negateExpr [
	^'-' asParser , BWS , commonExpr]

{ #category : #productions }
ODataURLGrammar >> notExpr [
	^'not' asParser , RWS , boolOperatorExpr]

{ #category : #productions }
ODataURLGrammar >> nowMethodCallExpr [
	^'now(' asParser , BWS , ')' asParser]

{ #category : #productions }
ODataURLGrammar >> nullValue [
	^'null' asParser]

{ #category : #productions }
ODataURLGrammar >> numberInJSON [
	^'-' asParser optional , self int , self frac optional , self exp optional]

{ #category : #productions }
ODataURLGrammar >> obstext [
	^PPPredicateObjectParser between: 16r80 asCharacter and: 16rFF asCharacter]

{ #category : #productions }
ODataURLGrammar >> odataentityid [
	^'OData-EntityID' asParser , COLON , OWS , self IRIinheader]

{ #category : #productions }
ODataURLGrammar >> odataIdentifier [
	^(self identifierLeadingCharacter , (self identifierCharacter max: 127)) flatten]

{ #category : #productions }
ODataURLGrammar >> odataisolation [
	^'OData-Isolation' asParser , COLON , OWS , 'snapshot' asParser]

{ #category : #productions }
ODataURLGrammar >> odatamaxversion [
	^'OData-MaxVersion' , COLON , OWS , '4.0' asParser]

{ #category : #productions }
ODataURLGrammar >> odataRelativeUri [
	| mark |
	mark := '?' asParser.
	^'$batch' asParser / ('$entity' asParser , mark , self entityOptions)
		/ ('$entity' asParser , '/' asParser , qualifiedEntityTypeName , mark
			, self entityCastOptions)
		/ ('$metadata' asParser , (mark , self format) optional
			, self context optional)
		/ (self resourcePath flatten , (mark , self queryOptions) optional)]

{ #category : #productions }
ODataURLGrammar >> odataUri [
	^self serviceRoot flatten , self odataRelativeUri optional]

{ #category : #productions }
ODataURLGrammar >> odataversion [
	^'OData-Version' asParser , COLON , OWS , '4.0' asParser]

{ #category : #productions }
ODataURLGrammar >> oneToNine [
	^'1' asParser / '2' asParser / '3' asParser / '4' asParser / '5' asParser
		/ '6' asParser
		/ '7' asParser
		/ '8' asParser
		/ '9' asParser]

{ #category : #productions }
ODataURLGrammar >> OPEN [
	^'(' asParser / '%28' asParser]

{ #category : #productions }
ODataURLGrammar >> orderby [
	| orderbyItem |
	orderbyItem := self orderbyItem.
	^'$orderby' asParser , EQ , orderbyItem , (COMMA , orderbyItem) star]

{ #category : #productions }
ODataURLGrammar >> orderbyItem [
	^commonExpr , (RWS , ('asc' asParser / 'desc' asParser)) optional]

{ #category : #productions }
ODataURLGrammar >> orExpr [
	^RWS , 'or' asParser , RWS , boolCommonExpr]

{ #category : #productions }
ODataURLGrammar >> otherdelims [
	^'!' asParser / '(' asParser / ')' asParser / '*' asParser / '+' asParser
		/ ',' asParser
		/ ';' asParser]

{ #category : #productions }
ODataURLGrammar >> OWS [
	^(SP / self HTAB / '%20' asParser / '%09' asParser) star]

{ #category : #productions }
ODataURLGrammar >> parameterAlias [
	^(self AT , odataIdentifier) flatten]

{ #category : #productions }
ODataURLGrammar >> parameterName [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> parameterNames [
	| parameterName |
	parameterName := self parameterName.
	^parameterName , (COMMA , parameterName) star]

{ #category : #productions }
ODataURLGrammar >> parameterValue [
	^self arrayOrObject / commonExpr]

{ #category : #productions }
ODataURLGrammar >> parenExpr [
	^OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> pathabempty [
	^('/' asParser , self segment) star]

{ #category : #productions }
ODataURLGrammar >> pathabsolute [
	^'/' asParser
		, (self segmentnz , ('/' asParser , self segment) star) optional]

{ #category : #productions }
ODataURLGrammar >> pathrootless [
	^self segmentnz , ('/' asParser , self segment) star]

{ #category : #productions }
ODataURLGrammar >> pchar [
	^unreserved / pctencoded / subdelims / ':' asParser / '@' asParser]

{ #category : #productions }
ODataURLGrammar >> pchar0 [
	^unreserved / pctencoded / self subdelims0 / ':' asParser / '@' asParser]

{ #category : #productions }
ODataURLGrammar >> pcharnoSQUOTE [
	^unreserved / self pctencodednoSQUOTE / otherdelims / '$' asParser
		/ '&' asParser
		/ '=' asParser
		/ ':' asParser
		/ '@' asParser]

{ #category : #productions }
ODataURLGrammar >> pctencoded [
	^'%' asParser , (HEXDIG times: 2)]

{ #category : #productions }
ODataURLGrammar >> pctencodednoSQUOTE [
	| atof |
	atof := self AtoF.
	^'%' asParser
		, ('0' asParser / '1' asParser / '3' asParser / '4' asParser
			/ '5' asParser
			/ '6' asParser
			/ '8' asParser
			/ '9' asParser
			/ atof)
		, HEXDIG
		/ ('%' asParser , '2' asParser
			, ('0' asParser / '1' asParser / '2' asParser / '3' asParser
				/ '4' asParser
				/ '5' asParser
				/ '6' asParser
				/ '8' asParser
				/ '9' asParser
				/ atof))]

{ #category : #productions }
ODataURLGrammar >> pctencodedunescaped [
	| atof |
	atof := self AtoF.
	^'%' asParser
		, ('0' asParser / '1' asParser / '3' asParser / '4' asParser
			/ '6' asParser
			/ '8' asParser
			/ '9' asParser
			/ atof)
		, HEXDIG
		/ ('%' asParser , '2'
			, ('0' asParser / '1' asParser / '3' asParser / '4' asParser
				/ '5' asParser
				/ '6' asParser
				/ '7' asParser
				/ '8' asParser
				/ '9' asParser
				/ atof))
		/ ('%' asParser , '5' asParser
			, (DIGIT / 'A' asParser / 'B' asParser / 'D' asParser / 'E' asParser
				/ 'F' asParser))]

{ #category : #productions }
ODataURLGrammar >> pointData [
	^OPEN , self positionLiteral , CLOSE]

{ #category : #productions }
ODataURLGrammar >> pointLiteral [
	^'Point' asParser , self pointData]

{ #category : #productions }
ODataURLGrammar >> polygonData [
	| ringLiteral |
	ringLiteral := self ringLiteral.
	^OPEN , ringLiteral , (COMMA , ringLiteral) star , CLOSE]

{ #category : #productions }
ODataURLGrammar >> polygonLiteral [
	^'Polygon' asParser , self polygonData]

{ #category : #productions }
ODataURLGrammar >> port [
	^DIGIT star flatten]

{ #category : #productions }
ODataURLGrammar >> positionLiteral [
	| doubleValue |
	doubleValue := self doubleValue.
	^doubleValue , SP , doubleValue]

{ #category : #productions }
ODataURLGrammar >> prefer [
	| preference |
	preference := self preference.
	^'Prefer' asParser , COLON , OWS , preference , (COMMA , preference) star]

{ #category : #productions }
ODataURLGrammar >> preference [
	^self allowEntityReferencesPreference / self callbackPreference
		/ self continueOnErrorPreference
		/ self includeAnnotationsPreference
		/ self maxpagesizePreference
		/ self respondAsyncPreference
		/ self returnPreference
		/ self trackChangesPreference
		/ self waitPreference]

{ #category : #productions }
ODataURLGrammar >> primitiveColFunction [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> primitiveColFunctionImport [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> primitiveColFunctionImportCall [
	^self primitiveColFunctionImport , functionParameters]

{ #category : #productions }
ODataURLGrammar >> primitiveColInUri [
	| primitiveLiteralInJSON |
	primitiveLiteralInJSON := self primitiveLiteralInJSON.
	^self beginarray
		, (primitiveLiteralInJSON , (valueseparator , primitiveLiteralInJSON) star) optional
		, self endarray]

{ #category : #productions }
ODataURLGrammar >> primitiveColProperty [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> primitiveFunction [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> primitiveFunctionImport [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> primitiveFunctionImportCall [
	^self primitiveFunctionImport , functionParameters]

{ #category : #productions }
ODataURLGrammar >> primitiveKeyProperty [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> primitiveLiteral [
	^self nullValue / self booleanValue / self guidValue / self dateValue
		/ self dateTimeOffsetValue
		/ self timeOfDayValue
		/ self decimalValue
		/ self doubleValue
		/ self singleValue
		/ self sbyteValue
		/ self byteValue
		/ self int16Value
		/ self int32Value
		/ self int64Value
		/ self string
		/ self duration
		/ self binary
		/ self enum
		/ self geographyCollection
		/ self geographyLineString
		/ self geographyMultiLineString
		/ self geographyMultiPoint
		/ self geographyMultiPolygon
		/ self geographyPoint
		/ self geographyPolygon
		/ self geometryCollection
		/ self geometryLineString
		/ self geometryMultiLineString
		/ self geometryMultiPoint
		/ self geometryMultiPolygon
		/ self geometryPoint
		/ self geometryPolygon]

{ #category : #productions }
ODataURLGrammar >> primitiveLiteralInJSON [
	^self stringInJSON / self numberInJSON / 'true' asParser / 'false' asParser
		/ 'null' asParser]

{ #category : #productions }
ODataURLGrammar >> primitiveNonKeyProperty [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> primitiveProperty [
	^self primitiveKeyProperty / self primitiveNonKeyProperty]

{ #category : #productions }
ODataURLGrammar >> primitivePropertyInUri [
	^quotationmark , primitiveProperty , quotationmark , nameseparator
		, self primitiveLiteralInJSON]

{ #category : #productions }
ODataURLGrammar >> primitiveTypeName [
	^'Edm.' asParser
		, ('Binary' asParser / 'Boolean' asParser / 'Byte' asParser
			/ 'Date' asParser
			/ 'DateTimeOffset' asParser
			/ 'Decimal' asParser
			/ 'Double' asParser
			/ 'Duration' asParser
			/ 'Guid' asParser
			/ 'Int16' asParser
			/ 'Int32' asParser
			/ 'Int64' asParser
			/ 'SByte' asParser
			/ 'Single' asParser
			/ 'Stream' asParser
			/ 'String' asParser
			/ 'TimeOfDay' asParser
			/ (self abstractSpatialTypeName , self concreteSpatialTypeName optional))]

{ #category : #productions }
ODataURLGrammar >> primitiveValue [
	^self booleanValue / self guidValue / self durationValue / self dateValue
		/ self dateTimeOffsetValue
		/ self timeOfDayValue
		/ self enumValue
		/ self fullCollectionLiteral
		/ self fullLineStringLiteral
		/ self fullMultiPointLiteral
		/ self fullMultiLineStringLiteral
		/ self fullMultiPolygonLiteral
		/ self fullPointLiteral
		/ self fullPolygonLiteral
		/ self decimalValue
		/ self doubleValue
		/ self singleValue
		/ self sbyteValue
		/ self byteValue
		/ self int16Value
		/ self int32Value
		/ self int64Value
		/ self binaryValue]

{ #category : #productions }
ODataURLGrammar >> propertyPath [
	^self entityColNavigationProperty , collectionNavigation
		/ (self entityNavigationProperty , singleNavigation)
		/ (complexColProperty , collectionPath)
		/ (complexProperty , complexPath)
		/ (primitiveColProperty , collectionPath)
		/ (primitiveProperty , singlePath)
		/ (self streamProperty , boundOperation)]

{ #category : #productions }
ODataURLGrammar >> propertyPathExpr [
	^self entityColNavigationProperty , collectionNavigationExpr
		/ (self entityNavigationProperty , singleNavigationExpr)
		/ (complexColProperty , collectionPathExpr)
		/ (complexProperty , self complexPathExpr)
		/ (primitiveColProperty , collectionPathExpr)
		/ (primitiveProperty , self singlePathExpr)
		/ self streamProperty]

{ #category : #productions }
ODataURLGrammar >> qcharJSONspecial [
	^SP / ':' asParser / '{' asParser / '}' asParser / '[' asParser
		/ ']' asParser]

{ #category : #productions }
ODataURLGrammar >> qcharnoAMP [
	^unreserved / pctencoded / otherdelims / ':' asParser / '@' asParser
		/ '/' asParser
		/ '?' asParser
		/ '$' asParser
		/ '''' asParser
		/ '=' asParser]

{ #category : #productions }
ODataURLGrammar >> qcharnoAMPDQUOTE [
	| escape |
	escape := self escape.
	^self qcharunescaped / (escape , (escape / quotationmark))]

{ #category : #productions }
ODataURLGrammar >> qcharnoAMPEQ [
	^unreserved / pctencoded / otherdelims / ':' asParser / '@' asParser
		/ '/' asParser
		/ '?' asParser
		/ '$' asParser
		/ '''' asParser]

{ #category : #productions }
ODataURLGrammar >> qcharnoAMPEQATDOLLAR [
	^unreserved / pctencoded / otherdelims / ':' asParser / '/' asParser
		/ '?' asParser
		/ '''' asParser]

{ #category : #productions }
ODataURLGrammar >> qcharunescaped [
	^unreserved / self pctencodedunescaped / otherdelims / ':' asParser
		/ '@' asParser
		/ '/' asParser
		/ '?' asParser
		/ '$' asParser
		/ '''' asParser
		/ '=' asParser]

{ #category : #productions }
ODataURLGrammar >> qualifiedActionName [
	^namespace , '.' , self action]

{ #category : #productions }
ODataURLGrammar >> qualifiedComplexTypeName [
	^namespace , '.' asParser , self complexTypeName]

{ #category : #productions }
ODataURLGrammar >> qualifiedEntityTypeName [
	^(namespace , '.' asParser , self entityTypeName) flatten]

{ #category : #productions }
ODataURLGrammar >> qualifiedEnumTypeName [
	^namespace flatten]

{ #category : #productions }
ODataURLGrammar >> qualifiedFunctionName [
	^namespace , '.' asParser , self function
		, (OPEN , self parameterNames , CLOSE) optional]

{ #category : #productions }
ODataURLGrammar >> qualifiedTypeDefinitionName [
	^namespace , '.' asParser , self typeDefinitionName]

{ #category : #productions }
ODataURLGrammar >> qualifiedTypeName [
	| singleQualifiedTypeName |
	singleQualifiedTypeName := self singleQualifiedTypeName.
	^singleQualifiedTypeName
		/ ('Collection' asParser , OPEN , singleQualifiedTypeName , CLOSE)]

{ #category : #productions }
ODataURLGrammar >> query [
	^(pchar / '/' asParser / '?' asParser) star]

{ #category : #productions }
ODataURLGrammar >> queryOption [
	^self systemQueryOption / self aliasAndValue / self customQueryOption]

{ #category : #productions }
ODataURLGrammar >> queryOptions [
	| queryOption |
	queryOption := self queryOption.
	^queryOption , ('&' asParser , queryOption) star]

{ #category : #productions }
ODataURLGrammar >> quotationmark [
	^self DQUOTE / '%22' asParser]

{ #category : #productions }
ODataURLGrammar >> ref [
	^'/$ref' asParser]

{ #category : #productions }
ODataURLGrammar >> regname [
	^(unreserved / pctencoded / subdelims) star]

{ #category : #productions }
ODataURLGrammar >> resourcePath [
	^entitySetName , self collectionNavigation optional
		/ (self singletonEntity , self singleNavigation optional)
		/ self actionImportCall
		/ (self entityColFunctionImportCall , self collectionNavigation optional)
		/ (self entityFunctionImportCall , singleNavigation optional)
		/ (self complexColFunctionImportCall , collectionPath optional)
		/ (self complexFunctionImportCall , complexPath optional)
		/ (self primitiveColFunctionImportCall , collectionPath optional)
		/ (self primitiveFunctionImportCall , self singlePath optional)
		/ self crossjoin
		/ '$all' asParser]

{ #category : #productions }
ODataURLGrammar >> respondAsyncPreference [
	^'respond-async' asParser]

{ #category : #productions }
ODataURLGrammar >> returnPreference [
	^'return' asParser , BWS , EQ , BWS
		, ('representation' asParser / 'minimal' asParser)]

{ #category : #productions }
ODataURLGrammar >> ringLiteral [
	| positionLiteral |
	positionLiteral := self positionLiteral.
	^OPEN , positionLiteral , (COMMA , positionLiteral) star , CLOSE]

{ #category : #productions }
ODataURLGrammar >> rootExpr [
	^'$root/' asParser , (entitySetName , keyPredicate / self singletonEntity)
		, singleNavigationExpr optional]

{ #category : #productions }
ODataURLGrammar >> rootExprCol [
	^self beginarray
		, (self rootExpr , (valueseparator , self rootExpr) star) optional
		, self endarray]

{ #category : #productions }
ODataURLGrammar >> roundMethodCallExpr [
	^'round' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> RWS [
	^(SP / self HTAB / '%20' asParser / '%09' asParser) plus]

{ #category : #productions }
ODataURLGrammar >> sbyteValue [
	^(SIGN optional , (DIGIT min: 1 max: 3)) flatten]

{ #category : #productions }
ODataURLGrammar >> scheme [
	^ALPHA , (ALPHA / DIGIT / '+' asParser / '-' asParser / '.' asParser) star]

{ #category : #productions }
ODataURLGrammar >> search [
	^'$search' asParser , EQ , BWS , searchExpr]

{ #category : #productions }
ODataURLGrammar >> searchAndExpr [
	^RWS , ('AND' asParser , RWS) optional , searchExpr]

{ #category : #productions }
ODataURLGrammar >> searchExpr [
	^OPEN , BWS , searchExpr , BWS , CLOSE / self searchTerm
		, (self searchOrExpr / self searchAndExpr) optional]

{ #category : #productions }
ODataURLGrammar >> searchOrExpr [
	^RWS , 'OR' asParser , RWS , searchExpr]

{ #category : #productions }
ODataURLGrammar >> searchPhrase [
	^quotationmark , self qcharnoAMPDQUOTE plus , quotationmark]

{ #category : #productions }
ODataURLGrammar >> searchTerm [
	^('NOT' asParser , RWS) optional , (self searchPhrase / self searchWord)]

{ #category : #productions }
ODataURLGrammar >> searchWord [
	^ALPHA plus]

{ #category : #productions }
ODataURLGrammar >> second [
	^self zeroToFiftyNine]

{ #category : #productions }
ODataURLGrammar >> secondMethodCallExpr [
	^'second' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> segment [
	^pchar star]

{ #category : #productions }
ODataURLGrammar >> segmentnz [
	^self pchar0 plus]

{ #category : #productions }
ODataURLGrammar >> select [
	| selectItem |
	selectItem := self selectItem.
	^'$select' asParser , EQ , selectItem , (COMMA , selectItem) star]

{ #category : #productions }
ODataURLGrammar >> selectItem [
	^STAR / self allOperationsInSchema
		/ ((qualifiedEntityTypeName , '/' asParser) optional
			, (selectProperty / self qualifiedActionName / self qualifiedFunctionName))]

{ #category : #productions }
ODataURLGrammar >> selectList [
	^OPEN , selectListItem , (COMMA , selectListItem) star , CLOSE]

{ #category : #productions }
ODataURLGrammar >> selectListItem [
	^STAR / self allOperationsInSchema
		/ (qualifiedEntityTypeName , '/' asParser) optional
		, (self qualifiedActionName / self qualifiedFunctionName
			/ selectListProperty)]

{ #category : #productions }
ODataURLGrammar >> selectListProperty [
	^primitiveProperty / primitiveColProperty
		/ (self navigationProperty , '+' asParser optional , selectList optional)
		/ (self selectPath , ('/' asParser , selectListProperty) optional)]

{ #category : #productions }
ODataURLGrammar >> selectPath [
	^complexProperty / complexColProperty
		, ('/' asParser , qualifiedComplexTypeName)]

{ #category : #productions }
ODataURLGrammar >> selectProperty [
	^primitiveProperty / primitiveColProperty / self navigationProperty
		/ (self selectPath , ('/' asParser , selectProperty) optional)]

{ #category : #productions }
ODataURLGrammar >> SEMI [
	^';' asParser / '%3B' asParser]

{ #category : #productions }
ODataURLGrammar >> serviceRoot [
	^'https' asParser caseInsensitive / 'http' asParser caseInsensitive
		, '://' asParser
		, self host flatten
		, (':' asParser , self port) optional
		, '/' asParser
		, (self segmentnz , '/' asParser) star flatten]

{ #category : #productions }
ODataURLGrammar >> SIGN [
	^'+' asParser / '%2B' asParser / '-' asParser]

{ #category : #productions }
ODataURLGrammar >> simpleKey [
	^OPEN , self keyPropertyValue , CLOSE]

{ #category : #productions }
ODataURLGrammar >> singleEnumValue [
	^self enumerationMember / self enumMemberValue]

{ #category : #productions }
ODataURLGrammar >> singleNavigation [
	| slash |
	slash := '/' asParser.
	^(slash , qualifiedEntityTypeName) optional
		, (slash , propertyPath , self value optional / boundOperation / self ref
			/ self value)
			optional]

{ #category : #productions }
ODataURLGrammar >> singleNavigationExpr [
	^'/' asParser , memberExpr]

{ #category : #productions }
ODataURLGrammar >> singleNavPropInJSON [
	^quotationmark , self entityNavigationProperty , quotationmark
		, nameseparator
		, self rootExpr]

{ #category : #productions }
ODataURLGrammar >> singlePath [
	^self value / boundOperation]

{ #category : #productions }
ODataURLGrammar >> singlePathExpr [
	^'/' asParser , boundFunctionExpr]

{ #category : #productions }
ODataURLGrammar >> singleQualifiedTypeName [
	^qualifiedEntityTypeName / qualifiedComplexTypeName
		/ self qualifiedTypeDefinitionName
		/ self qualifiedEnumTypeName
		/ self primitiveTypeName]

{ #category : #productions }
ODataURLGrammar >> singletonEntity [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> singleValue [
	^self doubleValue]

{ #category : #productions }
ODataURLGrammar >> skip [
	^'$skip' asParser , EQ , DIGIT asParser plus flatten]

{ #category : #productions }
ODataURLGrammar >> skiptoken [
	^'$skiptoken' asParser , EQ , self qcharnoAMP plus flatten]

{ #category : #productions }
ODataURLGrammar >> SP [
	^#space asParser]

{ #category : #productions }
ODataURLGrammar >> SQUOTE [
	^'''' asParser / '%27' asParser]

{ #category : #productions }
ODataURLGrammar >> SQUOTEinstring [
	^SQUOTE times: 2]

{ #category : #productions }
ODataURLGrammar >> sridLiteral [
	^'SRID' asParser , EQ , (DIGIT min: 1 max: 5) , self SEMI]

{ #category : #productions }
ODataURLGrammar >> STAR [
	^'*' asParser / '%2A' asParser]

{ #category : #accessing }
ODataURLGrammar >> start [
	^self odataUri]

{ #category : #productions }
ODataURLGrammar >> startsWithMethodCallExpr [
	^'startswith' asParser , OPEN , BWS , commonExpr , BWS , COMMA , BWS
		, commonExpr
		, BWS
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> streamProperty [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> string [
	^(SQUOTE , (self SQUOTEinstring / self pcharnoSQUOTE) star , SQUOTE) flatten]

{ #category : #productions }
ODataURLGrammar >> stringInJSON [
	^quotationmark , self charInJSON star , quotationmark]

{ #category : #productions }
ODataURLGrammar >> subdelims [
	^'$' asParser / '&' asParser / '''' asParser / '=' asParser / otherdelims]

{ #category : #productions }
ODataURLGrammar >> subdelims0 [
	^'$' asParser / '&' asParser / '''' asParser / '=' asParser]

{ #category : #productions }
ODataURLGrammar >> subExpr [
	^RWS , 'sub' asParser , RWS , commonExpr]

{ #category : #productions }
ODataURLGrammar >> substringMethodCallExpr [
	^'substring' asParser , OPEN , BWS , commonExpr , BWS , COMMA , BWS
		, commonExpr
		, BWS
		, (COMMA , BWS , commonExpr , BWS) optional
		, CLOSE]

{ #category : #productions }
ODataURLGrammar >> systemQueryOption [
	^expand / self filter / self format / self id / self inlinecount
		/ self orderby
		/ self search
		/ self select
		/ self skip
		/ self skiptoken
		/ self top]

{ #category : #productions }
ODataURLGrammar >> termName [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> timeMethodCallExpr [
	^'time' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> timeOfDayValue [
	| colon |
	colon := ':' asParser.
	^self hour , colon , self minute
		, (colon
			, (self second , ('.' asParser , self fractionalSeconds) optional) flatten)
			optional]

{ #category : #productions }
ODataURLGrammar >> toLowerMethodCallExpr [
	^'tolower' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> top [
	^'$top' asParser , EQ , DIGIT asParser plus flatten]

{ #category : #productions }
ODataURLGrammar >> totalOffsetMinutesMethodCallExpr [
	^'totaloffsetminutes' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> totalsecondsMethodCallExpr [
	^'totalseconds' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> toUpperMethodCallExpr [
	^'toupper' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> trackChangesPreference [
	^'odata.track-changes' asParser]

{ #category : #productions }
ODataURLGrammar >> trimMethodCallExpr [
	^'trim' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> typeDefinitionName [
	^odataIdentifier]

{ #category : #productions }
ODataURLGrammar >> unreserved [
	^ALPHA / DIGIT / '-' asParser / '.' asParser / '_' asParser / '~' asParser]

{ #category : #productions }
ODataURLGrammar >> URI [
	^self scheme , ':' asParser , self hierpart
		, ('?' asParser , self query) optional
		, ('#' asParser , self fragment) optional]

{ #category : #productions }
ODataURLGrammar >> userinfo [
	^(unreserved / pctencoded / subdelims / ':' asParser) star]

{ #category : #productions }
ODataURLGrammar >> value [
	^'/$value' asParser]

{ #category : #productions }
ODataURLGrammar >> valueeparator [
	^BWS , COMMA , BWS]

{ #category : #productions }
ODataURLGrammar >> valueseparator [
	^BWS , COMMA , BWS]

{ #category : #productions }
ODataURLGrammar >> VCHAR [
	^PPPredicateObjectParser between: 16r21 asCharacter and: 16r7E asCharacter]

{ #category : #productions }
ODataURLGrammar >> waitPreference [
	^'wait' asParser , BWS , EQ , BWS , DIGIT plus]

{ #category : #productions }
ODataURLGrammar >> year [
	| xxx |
	xxx := DIGIT times: 3.
	^'-' asParser optional , ('0' asParser , xxx / (oneToNine , xxx))]

{ #category : #productions }
ODataURLGrammar >> yearMethodCallExpr [
	^'year' asParser , OPEN , BWS , commonExpr , BWS , CLOSE]

{ #category : #productions }
ODataURLGrammar >> zeroToFiftyNine [
	^'0' asParser / '1' asParser / '2' asParser / '3' asParser / '4' asParser
		/ '5' asParser
		, DIGIT]

