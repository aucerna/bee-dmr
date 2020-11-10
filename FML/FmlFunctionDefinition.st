"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlFunctionDefinition,
	#superclass : #Object,
	#instVars : [
		'name',
		'arguments',
		'arity',
		'associative',
		'symbol',
		'unit',
		'type',
		'resultType',
		'defaultArgs',
		'regular',
		'description'
	],
	#classVars : [
		'Functions'
	],
	#category : #FML
}

{ #category : #accessing }
FmlFunctionDefinition class >> functions [
	^Functions]

{ #category : #initialization }
FmlFunctionDefinition class >> initArrayFunctions [
	| functions |
	functions := OrderedCollection new.
	functions
		add: (self new
			text: 'newArray( value )';
			symbol: #newArray;
			resultType: FmlArray;
			description: 'Returns a new array with <value> in each cell');
		add: (self new
			text: 'escalate( value, annualRate )';
			symbol: #escalate:;
			resultType: FmlArray;
			description: 'Returns an array with <value> escalated by <annual rate>');
		add: (self new
			text: 'escalateReference( fromIndex, rate, logic )';
			symbol: #escalateReference:logic:;
			resultType: FmlArray;
			unit: NumberUnit defaultInstance;
			description: 'Returns a reference (escalation factors) array by escalating a value of 1 from the period stated in <fromIndex> using <rate>. The <logic> parameter indicates the behavior for periods before <fromIndex>: setting it to 0 leaves them unescalated (= 1); setting it to 1 performs the inverse escalation for previous values.');
		add: (self new
			text: 'cum( array )';
			symbol: #cum;
			resultType: FmlNumber;
			description: 'Returns the (single) cumulative value of <array>');
		add: (self new
			text: 'runningCum( array )';
			symbol: #runningCum;
			resultType: FmlArray;
			description: 'Returns an array with the running cumulative of <array>, i.e., the individual cumulatives of <array> for each period');
		add: (self new
			text: 'minValue( array )';
			symbol: #minValue;
			resultType: FmlNumber;
			description: 'Returns the minimum value in <array>');
		add: (self new
			text: 'maxValue( array )';
			symbol: #maxValue;
			resultType: FmlNumber;
			description: 'Returns the maximum value in <array>');
		add: (self new
			text: 'firstPositive( array , [ defaultIndex ] )';
			symbol: #firstPositiveIfAbsent:;
			defaultArgs: (Array new: 1);
			resultType: FmlNumber;
			unit: NumberUnit integer;
			description: 'Returns the index of the first positive value in <array>. The optional parameter <defaultIndex> is the value returned if no positive values are found');
		add: (self new
			text: 'firstNegative( array , [ defaultIndex ] )';
			symbol: #firstNegativeIfAbsent:;
			defaultArgs: (Array new: 1);
			resultType: FmlNumber;
			unit: NumberUnit integer;
			description: 'Returns the index of the first negative value in <array>. The optional parameter <defaultIndex> is the value returned if no negative values are found');
		add: (self new
			text: 'lastPositive( array , [ defaultIndex ] )';
			symbol: #lastPositiveIfAbsent:;
			defaultArgs: (Array new: 1);
			resultType: FmlNumber;
			unit: NumberUnit integer;
			description: 'Returns the index of the last positive value in <array>. The optional parameter <defaultIndex> is the value returned if no positive values are found');
		add: (self new
			text: 'lastNegative( array , [ defaultIndex ] )';
			symbol: #lastNegativeIfAbsent:;
			defaultArgs: (Array new: 1);
			resultType: FmlNumber;
			unit: NumberUnit integer;
			description: 'Returns the index of the last negative value in <array>. The optional parameter <defaultIndex> is the value returned if no negative values are found');
		add: (self new
			text: 'firstValue( array )';
			symbol: #firstValue;
			resultType: FmlNumber;
			description: 'Returns the value of the first index in <array>');
		add: (self new
			text: 'lastValue( array )';
			symbol: #lastValue;
			resultType: FmlNumber;
			description: 'Returns the last value in <array>');
		add: (self new
			text: 'shiftRight( array, fill )';
			symbol: #shiftRight:;
			resultType: FmlArray;
			description: 'Same as previousValue: returns a copy of <array> with values pushed one position to the right. The first value is set to <fill>');
		add: (self new
			text: 'shiftLeft( array, fill )';
			symbol: #shiftLeft:;
			resultType: FmlArray;
			description: 'Returns a copy of <array> with values pushed one position to the left. The last value is set to <fill>');
		add: (self new
			text: 'positionsRight( array, fill, positions )';
			symbol: #shiftRightFillWith:positions:;
			resultType: FmlArray;
			description: 'Returns a copy of <array> with values pushed in <positions> positions to the right. The first <positions> values are set to <fill>. The argument <positions> must be an integer');
		add: (self new
			text: 'positionsLeft( array, fill, positions )';
			symbol: #shiftLeftFillWith:positions:;
			resultType: FmlArray;
			description: 'Returns a copy of <array> with values pushed in <positions> positions to the left. The last <positions> values are set to <fill>. The argument <positions> must be an integer');
		add: (self new
			text: 'previousValue( array, fill )';
			symbol: #previousValue:;
			resultType: FmlArray;
			description: 'Same as shiftRight: returns a copy of <array> with values pushed one position to the right. The first value is set to <fill>');
		add: (self new
			text: 'valueAtIndex( array, index )';
			symbol: #valueAtIndex:;
			resultType: FmlValue;
			description: 'Returns the value of <array> at <index>');
		add: (self new
			text: 'copy( array, fromIndex, toIndex, fill )';
			symbol: #copy:to:fill:;
			resultType: FmlArray;
			description: 'Returns a new array with values taken from <array> between index <from> and index <to>. All other values are set to <fill>. The parameters <fromIndex> and <toIndex> must be integers');
		add: (self new
			text: 'indexGTValue( array, value, [ defaultIndex ] )';
			symbol: #indexGTValue:ifAbsent:;
			defaultArgs: (Array new: 1);
			resultType: FmlNumber;
			unit: NumberUnit integer;
			description: 'Returns the first index of <array> whose value is greater than <value>. The optional parameter <defaultIndex> is the value returned if no index is found');
		add: (self new
			text: 'indexLTValue( array, value, [ defaultIndex ] )';
			symbol: #indexLTValue:ifAbsent:;
			defaultArgs: (Array new: 1);
			resultType: FmlNumber;
			unit: NumberUnit integer;
			description: 'Returns the last index of <array> whose value is less than <value>. The optional parameter <defaultIndex> is the value returned if no index is found').
	functions do: [:f | 
		f type: 'Array'.
		Functions at: f name put: f]]

{ #category : #initialization }
FmlFunctionDefinition class >> initDateFunctions [
	| functions |
	functions := OrderedCollection new.
	functions
		add: (self new
			text: 'date( year, month, day )';
			symbol: #date:day:;
			unit: DateUnit defaultInstance;
			description: 'Returns a date value for the specified <year>, <month> and <day>');
		add: (self new
			text: 'year( date )';
			symbol: #year;
			unit: NumberUnit integer;
			description: 'Returns an integer value for the year of <date>');
		add: (self new
			text: 'month( date )';
			symbol: #month;
			unit: NumberUnit integer;
			description: 'Returns an integer value for the month of <date>');
		add: (self new
			text: 'day( date )';
			symbol: #day;
			unit: NumberUnit integer;
			description: 'Returns the day of the month of <date>');
		add: (self new
			text: 'daysInYear( date )';
			symbol: #daysInYear;
			unit: NumberUnit integer;
			description: 'Returns an integer value for the number days in the year of <date>');
		add: (self new
			text: 'dayOfYear( date )';
			symbol: #dayOfYear;
			unit: NumberUnit integer;
			description: 'Returns an integer value for the day of the year of <date>').
	functions do: [:f | 
		f type: 'Date'.
		Functions at: f name put: f]]

{ #category : #initialization }
FmlFunctionDefinition class >> initDepreciationFunctions [
	| functions |
	functions := OrderedCollection new.
	functions
		add: (self new
			text: 'db( array, life, [afterlife])';
			symbol: #db:afterlife:;
			defaultArgs: {false};
			resultType: FmlArray;
			assumeRegularPeriods;
			description: 'Returns the Declining Balance depreciation schedule of <array> with an asset life of <life> fiscal periods. The optional parameter <afterlife>, if present, is a Boolean telling whether the depreciation must continue after the <life> periods');
		add: (self new
			text: 'ddb( array, life, [afterlife])';
			symbol: #ddb:afterlife:;
			defaultArgs: {false};
			resultType: FmlArray;
			assumeRegularPeriods;
			description: 'Returns the Double Declining Balance depreciation schedule of <array> with an asset life of <life>. The optional parameter <afterlife>, if present, is a Boolean telling whether the depreciation must continue after the <life> periods');
		add: (self new
			text: 'macrs( array, life )';
			symbol: #macrs:;
			resultType: FmlArray;
			assumeRegularPeriods;
			description: 'Returns the MACRS depreciation schedule of <array> with an asset life of <life>');
		add: (self new
			text: 'sl( array, life )';
			symbol: #sl:;
			resultType: FmlArray;
			assumeRegularPeriods;
			description: 'Returns the Straight Line depreciation schedule of <array> with an asset life of <life>');
		add: (self new
			text: 'syd( array, life )';
			symbol: #syd:;
			resultType: FmlArray;
			assumeRegularPeriods;
			description: 'Returns the Sum-of-Years-Digits depreciation schedule of <array> with an asset life of <life>').
	functions do: [:f | 
		f type: 'Depreciation'.
		Functions at: f name put: f]]

{ #category : #initialization }
FmlFunctionDefinition class >> initFinancialFunctions [
	"
	FmlFunctionDefinition initializeOperators
	"
	| functions |
	functions := OrderedCollection new.
	functions
		add: (self new
			text: 'npv( rate, array )';
			symbol: #npv:;
			resultType: FmlNumber;
			description: 'Returns the Net Present Value of <array> with the discount rate <rate>. The discount rate must be a (single) Number. When the periodicity is Mixed the rate is annual. Otherwise it refers to the rate for the given period');
		add: (self new
			text: 'xNPV( rate, array, dates )';
			symbol: #xNPV:dates:;
			resultType: FmlNumber;
			description: 'Returns the cumulative Net Present Value of <array> with the discount rate <rate>. Cash flows in <array> occur on <dates>, that is an array of dates. The discount <rate> is assumed to be annual');
		add: (self new
			text: 'xNPVLimit( rate, array, dates, startDate, endDate )';
			symbol: #xNPV:dates:startDate:endDate:;
			resultType: FmlNumber;
			description: 'Returns the cumulative Net Present Value of <array> with the discount rate <rate> and cash flows in <array> occurring on <dates>, that is an array of dates. Only the cash flows between <startDate> and <endDate> are included. The discount <rate> is assumed to be annual');
		add: (self new
			text: 'yearlyNPV( rate, array )';
			symbol: #yearlyNPV:;
			resultType: FmlArray;
			assumeRegularPeriods;
			description: 'Returns an array of the Net Present Values of <array> calculated using the discount <rate>. Note that the <rate> argument is interpreted as an annual rate, rather than a rate associated with the individual period. Thus, for monthly periods, the annual rate provided as an argument is internally divided by 12 and contributes evenly to the cashflow associated to every month. The parameter <rate> can be a single or array value');
		add: (self new
			text: 'periodXNPV( rate, array, dates )';
			symbol: #periodXNPV:dates:;
			resultType: FmlArray;
			description: 'Returns an array of the Net Present Value of <array> calculated using the discount <rate>. Cash flows in <array> occur on <dates>, that is an array of dates. This function can be used if periods in the project are of varying length, i.e. if the Mixed period option is selected. The discount <rate> can be a single or array value. It is assumed to be annual');
		add: (self new
			text: 'periodXNPVLimit( rate, array, dates, startDate, endDate )';
			symbol: #periodXNPV:dates:startDate:endDate:;
			resultType: FmlArray;
			description: 'Returns an array of the Net Present Value of <array> calculated using the discount <rate> and cash flows in <array> occurring on <dates>, that is an array of dates. Only the cash flows between <startDate> and <endDate> are included. This function can be used if periods in the project are of varying length, i.e. if the Mixed period option is selected. The discount <rate> can be a single or array value. It is assumed to be annual');
		add: (self new
			text: 'irr( array )';
			symbol: #irr;
			unit: NumberUnit percent;
			resultType: FmlNumber;
			description: 'Returns the Internal Rate of Return of <array>');
		add: (self new
			text: 'xIRR( array, dates )';
			symbol: #xIRR:;
			unit: NumberUnit percent;
			resultType: FmlNumber;
			description: 'Returns the Internal Rate of Return of <array>. Cash flows in <array> occuring on <dates>, that is an array of dates');
		add: (self new
			text: 'xIRRLimit( array, dates, startDate, endDate )';
			symbol: #xIRR:startDate:endDate:;
			unit: NumberUnit percent;
			resultType: FmlNumber;
			description: 'Returns the Internal Rate of Return of <array> within a given span. Cash flows in <array> occur on <dates>, that is an array of dates. Only the cash flows between <startDate> and <endDate> are included');
		add: (self new
			text: 'yearlyIRR( array )';
			symbol: #yearlyIRR;
			unit: NumberUnit percent;
			resultType: FmlArray;
			assumeRegularPeriods;
			description: 'Returns an array of the running Internal Rate of Return of <array>. The Internal Rate is calculated using all values in <array> up to and including the current value. The Internal Rate of Return is based on whatever period length is selected.
This function should only be used if all periods in the project are of equal length. It should not be used with Mixed period');
		add: (self new
			text: 'periodXIRR( array, dates )';
			symbol: #periodXIRR:;
			unit: NumberUnit percent;
			resultType: FmlArray;
			description: 'Returns an array of the running period Internal Rate of Return of <array>. Cash flows in <array> occur on <dates>, that is an array of dates. The Internal Rate is calculated using all values in <array> up to and including the current value. The Internal Rate of Return is based on whatever period length is selected.
This function can be used if periods in the project are of varying length, i.e. if the Mixed period option is selected');
		add: (self new
			text: 'periodXIRRLimit( array, dates, startDate, endDate )';
			unit: NumberUnit percent;
			symbol: #periodXIRR:startDate:endDate:;
			resultType: FmlArray;
			description: 'Returns an array of the running period Internal Rate of Return of <array> within a given span. Cash flows in <array> occur on <dates>, that is an array of dates. The Internal Rate is calculated using all values in <array> up to and including the current value. The Internal Rate of Return is based on whatever period length is selected. Only the cash flows between <startDate> and <endDate> are included.
This function can be used if periods in the project are of varying length, i.e. if the Mixed period option is selected');
		add: (self new
			text: 'discountFactors( rate )';
			symbol: #discountFactors;
			resultType: FmlArray;
			assumeRegularPeriods;
			description: 'Returns an array of discount factors for the discount <rate>. The discount <rate> refers to the period rate and all periods are assumed to have the same length (i.e., Mixed Periodicity is not supported)');
		add: (self new
			text: 'payment( rate, periods, pv, fv, type )';
			symbol: #payment:pv:fv:type:;
			resultType: FmlNumber;
			description: 'Returns the period payment on a loan amount of present value <pv>, interest <rate> paid over <periods> with a balance of future value <fv> after the final payment. If <type> = 1, payment occurs at the start of each period. If <type> = 0, payment occurs at the end of each period. The <rate> argument refers to the period rate and all periods are assumed to have the same length');
		add: (self new
			text: 'paymentCF( rate, periods, pv, fv, type, firstPeriod )';
			symbol: #paymentCF:pv:fv:type:firstPeriod:;
			resultType: FmlArray;
			description: 'Returns the cash flow for receipt and repayment on a loan amount of present value <pv>, interest rate of <rate> paid over <periods> with a balance of future value <fv> after the final payment. If <type> = 1, payment occurs at the start of period. If <type> = 0, payment occurs at the end of period. The cash flow array starts in period <firstPeriod> with the positive cash flow value of <pv> and continues in the following <periods> with the negative loan installments. The <rate> argument refers to the period rate and all periods are assumed to have the same length').
	functions do: [:f | 
		f type: 'Financial'.
		Functions at: f name put: f]]

{ #category : #initialization }
FmlFunctionDefinition class >> initialize [
	"
	FmlFunctionDefinition initialize
	"
	super initialize.
	self initializeOperators]

{ #category : #initialization }
FmlFunctionDefinition class >> initializeOperators [
	Functions := Dictionary new.
	self
		initMathFunctions;
		initTrigFunctions;
		initArrayFunctions;
		initFinancialFunctions;
		initDepreciationFunctions;
		initLogicalFunctions;
		initTableFunctions;
		initDateFunctions;
		initStringFunctions;
		initProbabilityFunctions;
		initLearningFunctions]

{ #category : #initialization }
FmlFunctionDefinition class >> initLearningFunctions [
	| functions |
	functions := OrderedCollection new.
	functions add: (self new
		text: 'logLearning( repetitions, base, lambda )';
		symbol: #logLearningBase:lambda:;
		description: 'Logarithmic learning reduction factor obtained after reaching any number of repetitions (a.k.a. experience.)').
	functions do: [:f | 
		f type: 'Learning'.
		Functions at: f name put: f]]

{ #category : #initialization }
FmlFunctionDefinition class >> initLogicalFunctions [
	| functions |
	functions := OrderedCollection new.
	functions
		add: (self new
			text: 'if( boolean, ifTrue, ifFalse )';
			symbol: #if:with:;
			description: 'If <boolean> is true a value <ifTrue> is returned. Otherwise <ifFalse> is returned');
		add: (self new
			text: 'and( boolean1, boolean2, … )';
			symbol: #and:;
			description: 'If all expressions from <boolean1> through <boolean n> are true, the value is true, otherwise false');
		add: (self new
			text: 'not( boolean )';
			symbol: #not;
			description: 'Returns true if the expression <boolean> is false');
		add: (self new
			text: 'or( boolean1, boolean2, … )';
			symbol: #or:;
			description: 'Returns true if any expression from <boolean1> through <boolean n> is true');
		add: (self new
			text: 'isDefined( variable )';
			symbol: #isDefined;
			unit: BooleanUnit defaultInstance;
			description: 'Returns true only if a variable with name <variable> has already been defined in the simulation').
	functions do: [:f | 
		f type: 'Logical'.
		Functions at: f name put: f]]

{ #category : #initialization }
FmlFunctionDefinition class >> initMathFunctions [
	| functions |
	functions := OrderedCollection new.
	functions
		add: (self new
			text: 'min( value1, value2, … )';
			symbol: #min:;
			description: 'Outputs the minimum of values <value1> through value n');
		add: (self new
			text: 'average( value1, value2, … )';
			associative: false;
			symbol: #average:;
			resultType: FmlValue;
			description: 'Outputs the arithmetic mean of values <value1> through value n');
		add: (self new
			text: 'geometricMean( value1, value2, … )';
			associative: false;
			resultType: FmlValue;
			symbol: #geometricMean:;
			description: 'Outputs the geometric mean of values <value1> through value n');
		add: (self new
			text: 'max( value1, value2, … )';
			symbol: #max:;
			description: 'Outputs the maximum of values <value1> through value n');
		add: (self new
			text: 'raisedTo( value, exponent )';
			symbol: #raisedTo:;
			description: 'Outputs the <value> raised to <exponent>');
		add: (self new
			text: 'abs( value )';
			symbol: #abs;
			description: 'Absolute value of <value>');
		add: (self new
			text: 'squared( value )';
			symbol: #squared;
			description: 'Square of <value>');
		add: (self new
			text: 'sqrt( value )';
			symbol: #sqrt;
			description: 'Square root of <value>');
		add: (self new
			text: 'ln( value )';
			symbol: #ln;
			description: 'Natural logarithm of <value>');
		add: (self new
			text: 'log10( value )';
			symbol: #log;
			description: 'Base 10 logarithm of <value>');
		add: (self new
			text: 'log( value, base )';
			symbol: #log:;
			description: 'Base <base> logarithm of <value>');
		add: (self new
			text: 'exp( value )';
			symbol: #exp;
			description: 'Exponential function of <value>');
		add: (self new
			text: 'round( value , [ digits ] )';
			symbol: #roundDigits:;
			defaultArgs: #(0);
			description: 'Round off of <value> with optional <digits> to specify the number of digits for the round off value');
		add: (self new
			text: 'ceiling( value , [ significance ] )';
			symbol: #ceiling:;
			defaultArgs: #(1);
			description: 'Round up of <value> with optional <significance> to specify the multiple to which you want to round');
		add: (self new
			text: 'floor( value , [ significance ] )';
			symbol: #floor:;
			defaultArgs: #(1);
			description: 'Round down of <value> with optional <significance> to specify the multiple to which you want to round');
		add: (self new
			text: 'negated( value )';
			symbol: #negated;
			description: 'Negated value of <value>');
		add: (self new
			text: 'reciprocal( value )';
			symbol: #reciprocal;
			description: 'Inverted value of <value>').
	functions do: [:f | 
		f type: 'Mathematical'.
		Functions at: f name put: f]]

{ #category : #initialization }
FmlFunctionDefinition class >> initProbabilityFunctions [
	| functions |
	functions := OrderedCollection new.
	functions
		add: (self new
			text: 'normal( value, mean, sd, [cumulative] )';
			symbol: #normal:sd:cumulative:;
			defaultArgs: {true};
			unit: #distributionUnitOn:;
			description: 'Evaluates the normal distribution in <value> when the optional <cumulative> parameter is omitted or provided as true. Otherwise it evaluates the normal density function.');
		add: (self new
			text: 'lognormal( value, mean, sd, [cumulative] )';
			symbol: #lognormal:sd:cumulative:;
			defaultArgs: {true};
			unit: #distributionUnitOn:;
			description: 'Evaluates the lognormal distribution in <value> when the optional <cumulative> parameter is omitted or provided as true. Otherwise it evaluates the lognormal density function.');
		add: (self new
			text: 'inverseNormal( probability, mean, sd )';
			symbol: #inverseNormal:sd:;
			description: 'Evaluates the inverse of the Normal Cumulative Distribution in <probability>');
		add: (self new
			text: 'inverseLognormal( probability, mean, sd )';
			symbol: #inverseLognormal:sd:;
			description: 'Evaluates the inverse of the Lognormal Cumulative Distribution in <probability>');
		add: (self new
			text: 'inverseTriangular( probability, min, mid, max )';
			symbol: #inverseTriangular:mid:max:;
			description: 'Evaluates the inverse of the Triangular Distribution in <probability>');
		add: (self new
			text: 'averageDistribution( variable, order, value )';
			symbol: #averageDistribution:at:;
			unit: NumberUnit defaultInstance;
			description: 'If <variable> has a normal distribution, evaluates the arithmetic mean of <order> copies of the distributions at <value>. Otherwise it evaluates to Undefined.');
		add: (self new
			text: 'geometricMeanDistribution( variable, order, value )';
			symbol: #geometricMeanDistribution:at:;
			unit: NumberUnit defaultInstance;
			description: 'If <variable> has a lognormal distribution, evaluates the geometric mean of <order> copies of the distribution at <value>. Otherwise it evaluates to Undefined.');
		add: (self new
			text: 'distribution( variable, value )';
			symbol: #distributionAt:;
			unit: NumberUnit defaultInstance;
			description: 'If <variable> has a probability distribution, evaluates its cumulative distribution function at <value>. Otherwise it evaluates to Undefined.');
		add: (self new
			text: 'inverseDistribution( variable, probability )';
			symbol: #inverseDistributionAt:;
			description: 'If <variable> has a probability distribution, evaluates the inverse of its cumulative distribution function at <probability>. Otherwise it evaluates to Undefined.');
		add: (self new
			text: 'mean( variable )';
			symbol: #mean;
			description: 'If <variable> has a probability distribution, evaluates its mean value. Otherwise it evaluates to Undefined.');
		add: (self new
			text: 'sd( variable )';
			symbol: #deviation;
			unit: #sdUnitOn:;
			description: 'If <variable> has a probability distribution, evaluates its standard deviation. Otherwise it evaluates to Undefined.');
		add: (self new
			text: 'normalBayesianEvidence( confidence, error, sd0, sd )';
			symbol: #normalBayesianLearningError:prevSd:actualSd:;
			unit: NumberUnit defaultInstance;
			description: 'Returns the number of new experiments required to update the estimation of a Normal mean within the boundaries of the confidence interval given by <confidence> and <error>. The Normal distribution is assumed to have a standard deviation <sd> and a normally distributed mean with standard deviation <sd0>.');
		add: (self new
			text: 'lognormalBayesianEvidence( confidence, error, mu0, sd0, P90/P10 )';
			symbol: #lognormalBayesianLearningError:prevMean:prevSd:P90P10:;
			unit: NumberUnit defaultInstance;
			description: 'Returns the number of new experiments required to update the estimation of a Lognormal mean within the boundaries of the confidence interval given by <confidence> and <error>. The Lognormal distribution is assumed to have the percentile ratio <P90/P10> and a normally distributed mean with parameters <mu0> and <sd0>. The <error> is relative to the logarithmic width ln(P90) - ln(P10)');
		add: (self new
			text: 'normalMeanOfLognormal( mean, sd )';
			symbol: #normalMeanOfLognormalSd:;
			unit: NumberUnit defaultInstance;
			description: 'Returns the mean value of the Normal distribution associated to the Lognormal distribution with mean <mean> and standard deviation <sd>');
		add: (self new
			text: 'normalSdOfLognormal( mean, sd )';
			symbol: #normalSdOfLognormalSd:;
			unit: NumberUnit defaultInstance;
			description: 'Returns the standard deviation of the Normal distribution associated to the Lognormal distribution with mean <mean> and standard deviation <sd>');
		add: (self new
			text: 'lognormalMeanOfNormal( mean, sd )';
			symbol: #lognormalMeanOfNormalSd:;
			unit: NumberUnit defaultInstance;
			description: 'Returns the mean value of the Lognormal distribution associated to the Normal distribution with mean <mean> and standard deviation <sd>');
		add: (self new
			text: 'lognormalSdOfNormal( mean, sd )';
			symbol: #lognormalSdOfNormalSd:;
			unit: NumberUnit defaultInstance;
			description: 'Returns the standard deviation of the Lognormal distribution associated to the Normal distribution with mean <mean> and standard deviation <sd>').
	functions do: [:f | 
		f type: 'Probability'.
		Functions at: f name put: f]]

{ #category : #initialization }
FmlFunctionDefinition class >> initStringFunctions [
	| functions |
	functions := OrderedCollection new.
	functions
		add: (self new text: 'lowercase( string )'; symbol: #asLowercase);
		add: (self new text: 'uppercase( string )'; symbol: #asUppercase);
		add: (self new text: 'capitalize( string )'; symbol: #capitalized);
		add: (self new
			text: 'copyFromTo( string , [ firstIndex ] , [ lastIndex ] )';
			symbol: #copyFrom:to:;
			defaultArgs: {nil. nil});
		add: (self new
			text: 'includesSubstring( string, substring )';
			symbol: #includesString:;
			unit: BooleanUnit defaultInstance);
		add: (self new text: 'length( string )'; symbol: #length);
		add: (self new
			text: 'objectName()';
			symbol: #assetName;
			arity: 0;
			unit: StringUnit defaultInstance;
			description: 'Returns the name of the model object to which the variable where this function is used belongs').
	functions do: [:f | 
		f type: 'Text'.
		Functions at: f name put: f]]

{ #category : #initialization }
FmlFunctionDefinition class >> initTableFunctions [
	| functions |
	functions := OrderedCollection new.
	functions
		add: (self new
			text: 'index( table, row, column )';
			symbol: #index:col:;
			description: 'Returns the value of cell at <column>, <row> in <table>');
		add: (self new
			text: 'vLookup( table, value, returnColumn )';
			symbol: #vLookup:returnColumn:;
			description: 'Looks up <value> in first column of <table> and returns the corresponding lower value from <returnColumn>. Values in first column must be ascending');
		add: (self new
			text: 'interpolate( table, value, searchColumn, returnColumn , [extrapolate])';
			symbol: #interpolate:searchColumn:returnColumn:extrapolate:;
			defaultArgs: {false};
			description: 'Looks up <value> in column <searchColumn> of <table> and returns a linearly interpolated value from <returnColumn>. Values in <searchColumn> must be ascending. The optional parameter <extrapolate>, if present, is a Boolean telling whether the function must extrapolate linearly outside the provided range');
		add: (self new
			text: 'tableLookup( table, value, searchColumn, returnColumn )';
			symbol: #tableLookup:searchColumn:returnColumn:;
			description: 'Looks up <value> in column <searchColumn> of <table> and returns the corresponding lower value from <returnColumn>. Values in <searchColumn> must be ascending');
		add: (self new
			text: 'tableRollup( table, value, searchColumn, factorColumn )';
			symbol: #tableRollup:searchColumn:factorColumn:;
			description: 'Looks up <value> in column <searchColumn> of <table> and returns the "Rollup" value. Rollup is calculated as the sum of the values in <searchColumn> minus the value in the previous row in <searchColumn> multiplied by the value in the same (previous) row of <factorColumn>, for all rows below the one where <searchColumn> is less than <value>. If <value> = the minimum value in <searchColumn> the value "0" is returned');
		add: (self new
			text: 'interpolate2D( table, x, y )';
			symbol: #interpolate2D:Y:;
			description: 'Performs a 2-dimensional interpolation in <table> by interpolating the values <x> in the columns and <y> in the rows. Both first row and first column values in <table> should be ascending ').
	functions do: [:f | 
		f type: 'Table'.
		Functions at: f name put: f]]

{ #category : #initialization }
FmlFunctionDefinition class >> initTrigFunctions [
	| functions |
	functions := OrderedCollection new.
	functions
		add: (self new
			text: 'sin( radians )';
			symbol: #sin;
			description: 'Sine of <value> radians');
		add: (self new
			text: 'cos( radians )';
			symbol: #cos;
			description: 'Cosine of <value> radians');
		add: (self new
			text: 'tan( radians )';
			symbol: #tan;
			description: 'Tangent of <value> radians');
		add: (self new
			text: 'arcSin( value )';
			symbol: #arcSin;
			description: 'Arc sine of <value> radians');
		add: (self new
			text: 'arcCos( value )';
			symbol: #arcCos;
			description: 'Arc cosine of <value> radians');
		add: (self new
			text: 'arcTan( value )';
			symbol: #arcTan;
			description: 'Arc tangent of <value> radians');
		add: (self new
			text: 'radians( angle )';
			symbol: #degreesToRadians;
			description: 'Radians of angle of <value> degrees');
		add: (self new
			text: 'degrees( radians )';
			symbol: #radiansToDegrees;
			description: 'Degress of angle of <value> radians').
	functions do: [:f | 
		f type: 'Trigonometric'.
		Functions at: f name put: f]]

{ #category : #accessing }
FmlFunctionDefinition class >> named: aString [
	^Functions at: aString ifAbsent: nil]

{ #category : #'instance creation' }
FmlFunctionDefinition class >> new [
	^super new initialize]

{ #category : #inquiries }
FmlFunctionDefinition >> addMagicConstantsOf: fmlCall to: aCollection [
	fmlCall arguments withIndexDo: [:arg :i | 
		(self allowsMagicConstantsAt: i)
			ifTrue: [arg functions do: [:f | f addMagicConstantsTo: aCollection]]
			ifFalse: [arg addMagicConstantsTo: aCollection]]]

{ #category : #inquiries }
FmlFunctionDefinition >> addNumericLiteralsOf: fmlCall to: aCollection [
	fmlCall arguments do: [:arg | arg addNumericLiteralsTo: aCollection]]

{ #category : #testing }
FmlFunctionDefinition >> allowsMagicConstantsAt: index [
	| arg |
	arg := self argumentAt: index.
	^arg notNil and: [arg allowsMagicConstants]]

{ #category : #accessing }
FmlFunctionDefinition >> argumentAt: index [
	| i |
	i := self hasOpenArity ifTrue: [1] ifFalse: [index].
	^arguments at: i ifAbsent: nil]

{ #category : #accessing }
FmlFunctionDefinition >> arguments [
	^arguments]

{ #category : #accessing }
FmlFunctionDefinition >> arguments: aCollection [
	arguments := aCollection]

{ #category : #evaluation }
FmlFunctionDefinition >> argumentsFrom: aCollection [
	| n d |
	n := aCollection size.
	(arity notNil and: [arity <= n]) ifTrue: [^aCollection].
	self hasOpenArity ifTrue: [^aCollection].
	d := defaultArgs size.
	n + d < arity ifTrue: [^aCollection].
	^Array streamContents: [:strm | | first |
		aCollection do: [:each | strm nextPut: each].
		first := d + n - arity + 1.
		first to: d do: [:i | strm nextPut: (defaultArgs at: i) asFmlValue]]]

{ #category : #accessing }
FmlFunctionDefinition >> arity [
	^arity]

{ #category : #accessing }
FmlFunctionDefinition >> arity: anInteger [
	arity := anInteger]

{ #category : #converting }
FmlFunctionDefinition >> asJson [
	| json |
	json := JsonObject new.
	json
		at: 'Name' put: name;
		at: 'Type' put: type;
		at: 'Description' put: description;
		at: 'Arity' put: arity;
		at: 'Associative' put: associative;
		at: 'Arguments' put: (arguments collect: #asJson);
		at: 'Hint' put: self asString.
	^json]

{ #category : #private }
FmlFunctionDefinition >> associative: aBoolean [
	associative := aBoolean]

{ #category : #accessing }
FmlFunctionDefinition >> assumeRegularPeriods [
	regular := true]

{ #category : #testing }
FmlFunctionDefinition >> assumesRegularPeriods [
	^regular]

{ #category : #private }
FmlFunctionDefinition >> basicResultTypeOf: fmlFunctionCall [
	| args t |
	args := fmlFunctionCall arguments.
	self isTableFunction ifTrue: [args := args copyFrom: 2].
	t := args
		inject: args first resultType
		into: [:result :arg | result * arg resultType].
	^t isTableValued ifTrue: [FmlUndefinedValue] ifFalse: [t]]

{ #category : #evaluation }
FmlFunctionDefinition >> checkArity: aFmlFunctionCall [
	| n d args count |
	args := aFmlFunctionCall arguments.
	n := args size.
	count := self numArgs.
	self hasOpenArity ifFalse: [count < n ifTrue: [self signalArityError]].
	count <= n ifTrue: [^self].
	d := defaultArgs size.
	n + d < count ifTrue: [self signalArityError]]

{ #category : #testing }
FmlFunctionDefinition >> couldRequireColumnEvaluation [
	^type = 'Array' and: [resultType == FmlArray]]

{ #category : #accessing }
FmlFunctionDefinition >> defaultArgs: aCollection [
	defaultArgs := aCollection]

{ #category : #accessing }
FmlFunctionDefinition >> description [
	^description]

{ #category : #accessing }
FmlFunctionDefinition >> description: aString [
	description := aString]

{ #category : #accessing }
FmlFunctionDefinition >> descriptionText [
	| rtf |
	rtf := Rtf new.
	rtf
		setFont: GDIFont defaultTextFont;
		setTabStops: (300 to: 9600 by: 300).
	self printDescriptionTextOn: rtf.
	^rtf]

{ #category : #testing }
FmlFunctionDefinition >> distributesIndex [
	"
	Answer true if the function evaluates to an array (when
	the arguments are arrays) and
		FUNCTION(ARRAY)[i] = FUNCTION(ARRAY[i])
	Examples:
		max, min, sin, etc. should return TRUE
		cum, runningCum, shiftRight, etc. should return FALSE
	"
	^resultType isNil]

{ #category : #'unit inference' }
FmlFunctionDefinition >> distributionUnitOn: anFmlFunctionCall [
	| u |
	u := arguments last inferredUnit.
	^(u notNil and: [u isBooleanUnit]) ifTrue: [
		anFmlFunctionCall messageArguments last value == true
			ifTrue: [NumberUnit defaultInstance]
			ifFalse: [
				u := anFmlFunctionCall arguments first unit.
				u notNil ifTrue: [NumberUnit defaultUnit / u]]]]

{ #category : #testing }
FmlFunctionDefinition >> enforcesSingleResultType [
	^resultType notNil and: [resultType isSingleValued]]

{ #category : #'file in/out' }
FmlFunctionDefinition >> fileInActivate [
	symbol == #round: ifTrue: [symbol := #roundDigits:]]

{ #category : #testing }
FmlFunctionDefinition >> hasOpenArity [
	^arity isNil]

{ #category : #testing }
FmlFunctionDefinition >> hasValidArity: aFmlFunctionCall [
	| valid |
	valid := [
		self checkArity: aFmlFunctionCall.
		true]
		on: FmlArityError
		do: [:er | er return: false].
	^valid]

{ #category : #'unit inference' }
FmlFunctionDefinition >> inferredUnitOf: fmlCall argument: index from: aUnit [
	| formal u |
	formal := self argumentAt: index.
	u := formal inferredUnit.
	u notNil ifTrue: [^u].
	self isMathematicalFunction
		ifTrue: [^self unitOnMathematicalCall: fmlCall from: aUnit].
	u := (unit isNil andNot: [self isTableFunction]) ifTrue: [aUnit].
	(u isNil and: [self isTableFunction])
		ifTrue: [u := self unitOnTableCall: fmlCall forArgument: formal].
	(u isNil and: [self isArrayFunction])
		ifTrue: [u := self unitOnArrayCall: fmlCall forArgument: formal].
	(u isNil and: [self isProbabilityFunction])
		ifTrue: [u := self unitOnProbabilityCall: fmlCall forArgument: formal].
	^u]

{ #category : #'unit inference' }
FmlFunctionDefinition >> inferredUnitOn: anFmlFunctionCall [
	| candidate args u |
	(self isEnumeratingFunction and: [anFmlFunctionCall receiver isFmlString])
		ifTrue: [^anFmlFunctionCall receiver referredVariableUnit].
	self isDepreciationFunction ifTrue: [^anFmlFunctionCall receiver unit].
	self isTableFunction ifTrue: [^self unitOnTableCall: anFmlFunctionCall].
	candidate := self unitInferredFromArgumentsOf: anFmlFunctionCall.
	(candidate notNil and: [candidate isInvalidUnit]) ifTrue: [^candidate].
	(unit isKindOf: Unit) ifTrue: [^unit].
	unit isSymbol ifTrue: [u := self perform: unit with: anFmlFunctionCall].
	u notNil ifTrue: [^u].
	(candidate isNil and: [arguments conform: [:arg | arg inferredUnit notNil]])
		ifTrue: [candidate := arguments notEmpty
			ifTrue: [arguments first inferredUnit]].
	candidate isNil ifTrue: [^nil].
	(self isMathematicalFunction and: [candidate respondsTo: symbol]) ifTrue: [
		args := anFmlFunctionCall messageArguments collect: #inferredUnit.
		symbol arity = args size
			ifTrue: [candidate := candidate perform: symbol withArguments: args]
			ifFalse: [self signalArityError]].
	^candidate]

{ #category : #initialization }
FmlFunctionDefinition >> initialize [
	super initialize.
	regular := associative := false.
	arity := 1.
	arguments := OrderedCollection new.
	description := '']

{ #category : #testing }
FmlFunctionDefinition >> isArrayFunction [
	^type = 'Array']

{ #category : #inquiries }
FmlFunctionDefinition >> isArrayValued: fmlFunctionCall [
	| args |
	resultType notNil ifTrue: [^resultType == FmlArray].
	self enforcesSingleResultType ifTrue: [^false].
	args := fmlFunctionCall arguments.
	(args conform: [:arg | arg isArrayValued not]) ifTrue: [^false].
	symbol == #valueAtIndex: ifTrue: [^args last isArrayValued].
	(symbol = #average: and: [args size = 1]) ifTrue: [^false].
	self isTableFunction ifTrue: [args := args copyFrom: 2].
	^args anySatisfy: [:a | a isArrayValued]]

{ #category : #testing }
FmlFunctionDefinition >> isAssociative [
	^associative]

{ #category : #testing }
FmlFunctionDefinition >> isDepreciationFunction [
	^type = 'Depreciation']

{ #category : #testing }
FmlFunctionDefinition >> isEnumeratingFunction [
	^type = 'Enumeration']

{ #category : #testing }
FmlFunctionDefinition >> isFinancialFunction [
	^type = 'Financial']

{ #category : #testing }
FmlFunctionDefinition >> isIdempotent [
	^#('lowercase'
		'uppercase'
		'capitalize'
		'abs'
		'round'
		'ceiling'
		'floor') includes: name]

{ #category : #testing }
FmlFunctionDefinition >> isLogExpFunction [
	^#('ln' 'log10' 'log' 'exp' 
		'normalSdOfLognormal' 'normalMeanOfLognormal' 
		'lognormalSdOfNormal' 'lognormalMeanOfNormal') includes: name]

{ #category : #testing }
FmlFunctionDefinition >> isMathematicalFunction [
	^type = 'Mathematical']

{ #category : #testing }
FmlFunctionDefinition >> isProbabilityFunction [
	^type = 'Probability']

{ #category : #testing }
FmlFunctionDefinition >> isReciprocalFunction [
	^name = 'reciprocal']

{ #category : #testing }
FmlFunctionDefinition >> isRoundingFunction [
	^arguments size = 2
		and: [#('significance' 'digits') includes: arguments second name]]

{ #category : #testing }
FmlFunctionDefinition >> isTableFunction [
	^type = 'Table']

{ #category : #accessing }
FmlFunctionDefinition >> mandatoryArguments [
	^arguments select: [:a | a isMandatory]]

{ #category : #accessing }
FmlFunctionDefinition >> name [
	^name]

{ #category : #evaluation }
FmlFunctionDefinition >> numArgs [
	^self hasOpenArity
		ifTrue: [self isAssociative ifTrue: [2] ifFalse: [1]]
		ifFalse: [arity]]

{ #category : #accessing }
FmlFunctionDefinition >> optionalArguments [
	^arguments select: [:a | a isOptional]]

{ #category : #printing }
FmlFunctionDefinition >> printDescriptionTextOn: rtf [
	| stream char |
	stream := description readStream.
	rtf italic; setCharColor: Color black.
	[stream atEnd] whileFalse: [
		stream peek = $< ifTrue: [
			stream next.
			rtf bold; setCharColor: Color blue].
		stream atEnd ifFalse: [char := stream next].
		char = $>
			ifTrue: [rtf boldOff; setCharColor: Color black]
			ifFalse: [rtf nextPut: char]].
	^rtf]

{ #category : #printing }
FmlFunctionDefinition >> printNLString [
	^self text]

{ #category : #printing }
FmlFunctionDefinition >> printOn: aStream [
	| separator args |
	separator := Locale current dataSeparator.
	aStream nextPutAll: name; nextPut: $(.
	args := self hasOpenArity ifTrue: [arguments && '...'] ifFalse: [arguments].
	args
		do: [:a | aStream nextPutAll: a asString]
		separatedBy: [aStream nextPutAll: separator; space].
	aStream nextPut: $)]

{ #category : #printing }
FmlFunctionDefinition >> printTextOn: rtf [
	| separator args |
	separator := Locale current dataSeparator.
	rtf bold: name; nextPut: $(.
	args := self hasOpenArity ifTrue: [arguments && '...'] ifFalse: [arguments].
	args
		do: [:a | 
			rtf setCharColor: Color blue.
			a printTextOn: rtf]
		separatedBy: [rtf setCharColor: Color black; nextPutAll: separator; space].
	rtf italicOff; setCharColor: Color black; nextPut: $)]

{ #category : #testing }
FmlFunctionDefinition >> requiresArrayReceiver [
	^self isArrayFunction and: [arguments first name = 'array']]

{ #category : #testing }
FmlFunctionDefinition >> requiresVariableReceiver [
	^(self isProbabilityFunction and: [arguments first name = 'variable'])
		or: [self isEnumeratingFunction]]

{ #category : #testing }
FmlFunctionDefinition >> requiresWellGroup [
	^self isEnumeratingFunction]

{ #category : #accessing }
FmlFunctionDefinition >> resultType [
	^resultType]

{ #category : #accessing }
FmlFunctionDefinition >> resultType: aClass [
	resultType := aClass]

{ #category : #inquiries }
FmlFunctionDefinition >> resultTypeOf: fmlFunctionCall [
	| args answer |
	answer := resultType.
	answer notNil ifTrue: [^answer].
	args := fmlFunctionCall arguments.
	args isEmpty ifTrue: [^FmlUndefinedValue].
	answer := self specialResultTypeOf: fmlFunctionCall.
	answer isNil ifTrue: [answer := self basicResultTypeOf: fmlFunctionCall].
	answer isTableValued ifTrue: [^answer].
	answer isSingleValued ifFalse: [^answer].
	^self enforcesSingleResultType
		ifTrue: [self singleResultType]
		ifFalse: [answer]]

{ #category : #'unit inference' }
FmlFunctionDefinition >> sdUnitOn: anFmlFunctionCall [
	| v u |
	v := anFmlFunctionCall receiver.
	u := v isVariableName ifTrue: [v unit].
	^u notNil
		ifTrue: [u isNumeric ifTrue: [u] ifFalse: [NumberUnit defaultInstance]]]

{ #category : #inquiries }
FmlFunctionDefinition >> setLiteralUnitsOf: fmlCall argument: index from: aUnit [
	| actual u |
	actual := fmlCall arguments at: index.
	actual hasNumericLiterals ifFalse: [^self].
	u := self inferredUnitOf: fmlCall argument: index from: aUnit.
	actual setLiteralUnitsFrom: u]

{ #category : #inquiries }
FmlFunctionDefinition >> setLiteralUnitsOf: fmlCall from: aUnit [
	(self hasValidArity: fmlCall) ifFalse: [^self].
	name = 'if' ifTrue: [
		{BooleanUnit defaultInstance. aUnit. aUnit}
			with: fmlCall arguments
			do: [:u :arg | arg setLiteralUnitsFrom: u].
		^self].
	1
		to: fmlCall arguments size
		do: [:i | self setLiteralUnitsOf: fmlCall argument: i from: aUnit]]

{ #category : #error }
FmlFunctionDefinition >> signalArityError [
	FmlArityError
		signal: 'Function ' , name storeString , ' needs '
			, (self hasOpenArity ifTrue: ['at least '] ifFalse: [''])
			, self numArgs printString
			, ' arguments']

{ #category : #accessing }
FmlFunctionDefinition >> singleResultType [
	^unit baseClass fmlValueClass]

{ #category : #private }
FmlFunctionDefinition >> specialResultTypeOf: fmlFunctionCall [
	| args |
	args := fmlFunctionCall arguments.
	symbol == #valueAtIndex: ifTrue: [^args last resultType].
	symbol == #if:with: ifTrue: [
		args size = 3 ifFalse: [^nil].
		(args anySatisfy: [:a | a isArrayValued]) ifTrue: [^FmlArray].
		^args third resultType].
	(symbol = #average: and: [args size = 1]) ifTrue: [^FmlValue].
	^nil]

{ #category : #accessing }
FmlFunctionDefinition >> symbol [
	^symbol]

{ #category : #accessing }
FmlFunctionDefinition >> symbol: aSymbol [
	symbol := aSymbol.
	self hasOpenArity ifFalse: [arity := symbol arity + 1]]

{ #category : #accessing }
FmlFunctionDefinition >> text [
	^String streamContents: [:strm | self printOn: strm]]

{ #category : #accessing }
FmlFunctionDefinition >> text: aString [
	| source i j names |
	self ASSERT: (aString includes: $().
	self ASSERT: (aString includes: $)).
	source := aString withoutBlanks.
	i := source indexOf: $(.
	j := source indexOf: $).
	name := source copyFrom: 1 to: i - 1.
	names := $, split: (source copyFrom: i + 1 to: j - 1).
	arguments := names collect: [:n | FmlArgumentDefinition fromString: n].
	arguments isEmpty
		ifTrue: [
			arity := 0.
			associative := false]
		ifFalse: [
			(#('...' '…') includes: arguments last name) ifTrue: [
				arity := nil.
				associative := true.
				arguments := arguments allButLast]]]

{ #category : #accessing }
FmlFunctionDefinition >> type [
	^type]

{ #category : #accessing }
FmlFunctionDefinition >> type: aString [
	type := aString]

{ #category : #accessing }
FmlFunctionDefinition >> unit: aUnit [
	unit := aUnit]

{ #category : #private }
FmlFunctionDefinition >> unitInferredFromArgumentsOf: anFmlFunctionCall [
	| actual candidate |
	actual := anFmlFunctionCall arguments withIndexCollect: [:arg :i | | formal |
		formal := self argumentAt: i.
		(formal notNil and: [formal inferredUnit isNil]) ifTrue: [arg inferredUnit]].
	candidate := actual detect: #notNil ifNone: nil.
	(candidate notNil and: [
		actual
			anySatisfy: [:u | u notNil
				andNot: [u type isCompatibleWith: candidate type]]])
		ifTrue: [^InvalidUnit defaultInstance].
	^candidate]

{ #category : #'unit inference' }
FmlFunctionDefinition >> unitOnArrayCall: anFmlFunctionCall forArgument: formalArgument [
	| args |
	args := anFmlFunctionCall arguments.
	args size < 1 ifTrue: [^nil].
	^formalArgument name = 'fill' ifTrue: [args first inferredUnit]]

{ #category : #'unit inference' }
FmlFunctionDefinition >> unitOnMathematicalCall: fmlCall from: aUnit [
	self isLogExpFunction ifTrue: [^NumberUnit defaultInstance].
	aUnit isNil ifTrue: [^nil].
	symbol == #squared ifTrue: [^aUnit sqrt].
	symbol == #sqrt ifTrue: [^aUnit squared].
	^aUnit]

{ #category : #'unit inference' }
FmlFunctionDefinition >> unitOnProbabilityCall: anFmlFunctionCall forArgument: formalArgument [
	| var |
	((name beginsWith: 'inverse') and: [formalArgument name = 'value'])
		ifTrue: [^NumberUnit defaultUnit].
	self requiresVariableReceiver ifFalse: [^nil].
	var := anFmlFunctionCall receiver.
	^var isVariableName ifTrue: [var unit]]

{ #category : #private }
FmlFunctionDefinition >> unitOnTableCall: anFmlFunctionCall [
	| args table index column mandatory c |
	args := anFmlFunctionCall arguments.
	mandatory := self mandatoryArguments.
	args size < mandatory size ifTrue: [^nil].
	table := args first table.
	table isNil ifTrue: [^nil].
	name = 'interpolate2D' ifTrue: [^table columnUnitAt: 2].
	index := mandatory
		findLast: [:arg | #('column' 'returnColumn') includes: arg name]
		ifAbsent: [
			name = 'tableRollup' ifTrue: [3] ifFalse: [
				self ASSERT: false.
				^nil]].
	c := (args at: index) evaluate.
	column := c value.
	c isFmlString ifTrue: [column := table columnNamed: column].
	column isNumber ifFalse: [^nil].
	^table columnUnitAt: column asInteger]

{ #category : #'unit inference' }
FmlFunctionDefinition >> unitOnTableCall: anFmlFunctionCall forArgument: formal [
	| args table sc c column units one |
	args := anFmlFunctionCall arguments.
	args size < 1 ifTrue: [^nil].
	table := args first table.
	table isNil ifTrue: [^nil].
	formal name != 'value' ifTrue: [^nil].
	sc := arguments
		findFirst: [:a | a name = 'searchColumn']
		ifAbsent: [^table columnUnitAt: 1].
	c := (args at: sc) evaluate value.
	column := (args at: sc) isFmlString ifTrue: [table columnNamed: c] ifFalse: [
		c isArray
			ifTrue: [
				units := c
					collect: [:v | 
						(table columnUnitAt: v asInteger)
							ifNil: [NumberUnit defaultUnit]
							ifNotNil: [:u | u type]]
					in: Set new.
				one := units anyone.
				(units conform: [:t | t isCompatibleWith: one])
					ifFalse: [^InvalidUnit defaultUnit].
				c anyone asInteger]
			ifFalse: [c asInteger]].
	^column notNil ifTrue: [table columnUnitAt: column]]

