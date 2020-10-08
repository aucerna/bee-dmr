"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ProbabilityDistributionTest,
	#superclass : #TestCase,
	#category : #'Distributions\Tests'
}

{ #category : #dirichlet }
ProbabilityDistributionTest >> computeCovariance: splits [
	| first second third mean1 mean2 mean3 a12 a13 a23 n matrix |
	first := splits first readStream.
	second := splits second readStream.
	third := splits third readStream.
	mean1 := splits first mean.
	mean2 := splits second mean.
	mean3 := splits third mean.
	a12 := 0.
	a13 := 0.
	a23 := 0.
	n := 0.
	[first atEnd] whileFalse: [| x y z |
		n := n + 1.
		x := first next - mean1.
		y := second next - mean2.
		z := third next - mean3.
		a12 := a12 + (x * y).
		a13 := a13 + (x * z).
		a23 := a23 + (y * z)].
	matrix := FloatMatrix newRows: 3 columns: 3.
	matrix
		atRow: 1 column: 2 put: a12 / (n - 3);
		atRow: 1 column: 3 put: a13 / (n - 3);
		atRow: 2 column: 3 put: a23 / (n - 3);
		atRow: 2 column: 1 put: (matrix atRow: 1 column: 2);
		atRow: 3 column: 1 put: (matrix atRow: 1 column: 3);
		atRow: 3 column: 2 put: (matrix atRow: 2 column: 3).
	^matrix]

{ #category : #'basic protocol' }
ProbabilityDistributionTest >> testBA1392 [
	| d r |
	d := DiscreteDistribution new.
	self
		assert: d values isEmptyOrNil
		description: 'Discrete distribution should have no values at the beginning'.
	r := d isConsistentWithBounds: 1.0.
	self
		deny: r
		description: 'Empty discrete distribution should not be consistent with any value']

{ #category : #'basic protocol' }
ProbabilityDistributionTest >> testBA177 [
	| d |
	d := DiscretizedDistribution new.
	d
		instVarNamed: 'distribution' put: #(0.1 0.5 0.9);
		instVarNamed: 'density' put: #(0.13333333 0.33333333e-1 0.0);
		instVarNamed: 'values' put: #(23.0 26.0 38.0);
		instVarNamed: 'uniform' put: (Random new seed: testSeed).
	self
		assert: (d instVarNamed: 'intervalSelector') isNil
		description: 'Bad formed DiscretizedDistribution not detected'.
	self
		shouldnt: [d restoreAfterFile]
		raise: Error
		description: 'Bad formed DiscretizedDistribution not appropriately fixed']

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testBernoulli [
	self testEstimatorsOf: BernoulliDistribution sampleInstance]

{ #category : #beta }
ProbabilityDistributionTest >> testBeta [
	self testEstimatorsOf: BetaDistribution sampleInstance]

{ #category : #beta }
ProbabilityDistributionTest >> testBeta11 [
	| dist |
	dist := BetaDistribution a: 1 b: 1.
	self assert: ((dist inverseDistribution: 0.5) - 0.5) abs < 0.001]

{ #category : #beta }
ProbabilityDistributionTest >> testBeta21 [
	| dist |
	dist := BetaDistribution a: 2 b: 1.
	self assert: ((dist inverseDistribution: 0.25) - 0.5) abs < 0.001]

{ #category : #beta }
ProbabilityDistributionTest >> testBeta22 [
	| dist |
	dist := BetaDistribution a: 2 b: 2.
	self assert: ((dist inverseDistribution: 0.5) - 0.5) abs < 0.001]

{ #category : #beta }
ProbabilityDistributionTest >> testBeta22Samples [
	| dist samples v mu sigma |
	dist := ProbabilityDistribution betaA: 2 b: 2 uniform: self random.
	samples := dist sample: 500.
	mu := samples sum / 500.
	v := 0.
	1 to: 500 do: [:i | v := v + ((samples at: i) - mu) squared].
	sigma := v / 499.
	self assert: (dist mean - mu) abs < 0.1.
	self assert: (dist variance - sigma) abs < 0.1]

{ #category : #beta }
ProbabilityDistributionTest >> testBetaDensities [
	self
		assert: ((BetaDistribution a: 0.5 b: 0.5) density: 0) ~ 0;
		assert: ((BetaDistribution a: 0.5 b: 0.5) density: 1) ~ 0;
		assert: ((BetaDistribution a: 1 b: 1) density: 0.3) ~ 1;
		assert: ((BetaDistribution a: 0.5 b: 0.5) density: 0.8) ~ 0.79577471545948;
		assert: ((BetaDistribution a: 1 b: 0.5) density: 0.2) ~ 0.55901699437495;
		assert: ((BetaDistribution a: 1 b: 0.5) density: 0.8) ~ 1.1180339887499;
		assert: ((BetaDistribution a: 31 b: 30) density: 0.3) ~ 0.23521052769914e-1;
		assert: ((BetaDistribution a: 0.2 b: 0.3) density: 0.3) ~ 0.43402802635743;
		assert: ((BetaDistribution a: 0.2 b: 0.3) density: 0.8) ~ 0.47598187911147;
		assert: ((BetaDistribution a: 0.114 b: 0.3) density: 0.4) ~ 0.27782583172014;
		assert: ((BetaDistribution a: 0.05 b: 0.3) density: 0.2) ~ 0.23576270525813;
		assert: ((BetaDistribution a: 0.3 b: 0.06) density: 0.8) ~ 0.27170004829976;
		assert: ((BetaDistribution a: 0.3 b: 1) density: 0.3) ~ 0.69684530193595;
		assert: ((BetaDistribution a: 0.3 b: 1) density: 0.7) ~ 0.38508147505313;
		assert: ((BetaDistribution a: 30 b: 50) density: 0.3) ~ 2.93301574749977;
		assert: ((BetaDistribution a: 30 b: 20.5) density: 0.3) ~ 0.587486563271e-3;
		assert: ((BetaDistribution a: 30 b: 20.5) density: 0.4) ~ 0.12211215677126;
		assert: ((BetaDistribution a: 0.5 b: 2) density: 0.2) ~ 1.34164078649987;
		assert: ((BetaDistribution a: 0.5 b: 2) density: 0.4) ~ 0.71151247353789;
		assert: ((BetaDistribution a: 0.5 b: 15) density: 0.2) ~ 0.21310667932949;
		assert: ((BetaDistribution a: 15 b: 0.5) density: 0.8) ~ 0.2131066793295;
		assert: ((BetaDistribution a: 2 b: 10.1) density: 0.4) ~ 0.42941847213684;
		assert: ((BetaDistribution a: 2 b: 1.1) density: 0.4) ~ 0.87798500005124;
		assert: ((BetaDistribution a: 2 b: 0.5) density: 0.8) ~ 1.34164078649987;
		assert: ((BetaDistribution a: 2 b: 0.5) density: 0.4) ~ 0.38729833462074;
		assert: ((BetaDistribution a: 0.5 b: 2) density: 0.05) ~ 3.1863968679372]

{ #category : #beta }
ProbabilityDistributionTest >> testBetaDistributions [
	self
		assert: ((BetaDistribution a: 0.5 b: 0.5) distribution: 0) ~ 0;
		assert: ((BetaDistribution a: 0.5 b: 0.5) distribution: 1) ~ 1;
		assert: ((BetaDistribution a: 1 b: 1) distribution: 0.3) ~ 0.3;
		assert: ((BetaDistribution a: 0.5 b: 0.5) distribution: 0.8)
			~ 0.70483276469913336;
		assert: ((BetaDistribution a: 1 b: 0.5) distribution: 0.2)
			~ 0.10557280900008414;
		assert: ((BetaDistribution a: 1 b: 0.5) distribution: 0.8)
			~ 0.55278640450004202;
		assert: ((BetaDistribution a: 31 b: 30) distribution: 0.3)
			~ 0.00036402563242403108;
		assert: ((BetaDistribution a: 0.2 b: 0.3) distribution: 0.3)
			~ 0.52800355495077744;
		assert: ((BetaDistribution a: 0.2 b: 0.3) distribution: 0.8)
			~ 0.72360679774997849;
		assert: (((BetaDistribution a: 0.114 b: 0.3) distribution: 0.4)
			relativeDistanceTo: 0.70600018534085474) < 10.0e-9;
		assert: ((BetaDistribution a: 0.05 b: 0.3) distribution: 0.2)
			~ 0.812586106651628;
		assert: ((BetaDistribution a: 0.3 b: 0.06) distribution: 0.8)
			~ 0.21855185180989883;
		assert: ((BetaDistribution a: 0.3 b: 1) distribution: 0.3) ~ 0.69684530193595;
		assert: ((BetaDistribution a: 0.3 b: 1) distribution: 0.7)
			~ 0.8985234417906397;
		assert: ((BetaDistribution a: 30 b: 50) distribution: 0.3)
			~ 0.079279223823671779;
		assert: ((BetaDistribution a: 30 b: 20.5) distribution: 0.3)
			~ 7.9630229741674156e-06;
		assert: ((BetaDistribution a: 30 b: 20.5) distribution: 0.4)
			~ 0.0027092376571959636;
		assert: ((BetaDistribution a: 0.5 b: 2) distribution: 0.2)
			~ 0.62609903369994102;
		assert: (((BetaDistribution a: 0.5 b: 2) distribution: 0.4)
			relativeDistanceTo: 0.82219219164377866) < 1.0e-9;
		assert: ((BetaDistribution a: 0.5 b: 15) distribution: 0.2)
			~ 0.98972017947079971;
		assert: ((BetaDistribution a: 15 b: 0.5) distribution: 0.8)
			~ 0.010279820529200292;
		assert: ((BetaDistribution a: 2 b: 10.1) distribution: 0.4)
			~ 0.97104269334265891;
		assert: (((BetaDistribution a: 2 b: 1.1) distribution: 0.4)
			relativeDistanceTo: 0.17902701293909562) < 1.0e-9;
		assert: ((BetaDistribution a: 2 b: 0.5) distribution: 0.8)
			~ 0.37390096630005887;
		assert: (((BetaDistribution a: 2 b: 0.5) distribution: 0.4)
			relativeDistanceTo: 0.070483996910219962) < 1.0e-9;
		assert: ((BetaDistribution a: 0.5 b: 2) distribution: 0.05)
			~ 0.32982002668121896]

{ #category : #beta }
ProbabilityDistributionTest >> testBetaInverseDistribution [
	| beta median |
	beta := BetaDistribution a: 3 b: 5.
	median := beta inverseDistribution: 0.5.
	self
		assert: beta mode <= median;
		assert: median <= beta mean]

{ #category : #beta }
ProbabilityDistributionTest >> testBetaLarge [
	| beta |
	beta := BetaDistribution a: 30 b: 5000.
	self
		assert: (beta density: 0.3) ~ 0;
		assert: (beta distribution: 0.3) ~ 1;
		assert: ((beta density: 0.005) - 280.53148715911288) abs < 1;
		assert: ((beta distribution: 0.005) - 0.18955775438711442) abs < 0.001.
	beta := BetaDistribution a: 30 b: 50000.
	self
		assert: (beta density: 0.3) ~ 0;
		assert: ((beta density: 0.005) - 2.8358500314182014e-66) abs < 1.0e-68;
		assert: ((beta density: 0.0005) - 2732.807010303387) abs < 1;
		assert: (beta distribution: 0.0005) - 0.18284057304706164 < 1.0e-4]

{ #category : #beta }
ProbabilityDistributionTest >> testBetaMean [
	| n random beta mean |
	n := 1000.
	random := self random.
	beta := BetaDistribution a: 0.25 b: 0.5.
	beta uniform: random.
	mean := (SampleSpace on: (beta sample: n)) mean.
	self assert: (beta mean - mean) abs < 0.1.
	beta := BetaDistribution a: 1 b: 1.
	beta uniform: random.
	mean := (SampleSpace on: (beta sample: n)) mean.
	self assert: (beta mean - mean) abs < 0.1.
	beta := BetaDistribution a: 6 b: 7.
	beta uniform: random.
	mean := (SampleSpace on: (beta sample: n)) mean.
	self assert: (beta mean - mean) abs < 0.1]

{ #category : #beta }
ProbabilityDistributionTest >> testBetaPowerTerm [
	| args g term |
	args := LargeIncompleteBetaArguments a: 30 b: 20 x: 0.2.
	g := GammaFunction a: args a b: args b.
	term := g * (args x raisedTo: args a) * (args y raisedTo: args b).
	self assert: args powerTerms ~ term]

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testBinomial [
	self testEstimatorsOf: BinomialDistribution sampleInstance]

{ #category : #binomial }
ProbabilityDistributionTest >> testBinomialDistribution [
	"
	ShellDLL current openWebPage: 'http://www.danielsoper.com/statcalc3/calc.aspx?id=70'
	"
	| binomial |
	binomial := BinomialDistribution events: 100 probability: 0.3.
	binomial uniform: self random.
	self
		assert: ((binomial distribution: 30) - 0.54912360076879063) abs < 1.0e-8]

{ #category : #binomial }
ProbabilityDistributionTest >> testBinomialDistributionLarge [
	"
	ShellDLL current openWebPage: 'http://www.danielsoper.com/statcalc3/calc.aspx?id=70'
	"
	| binomial answer |
	binomial := BinomialDistribution events: 1000 probability: 0.3.
	binomial uniform: self random.
	self
		shouldnt: [answer := binomial distribution: 300] raise: Error;
		assert: (answer - 0.5155935198133601) abs < 1.0e-8]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testBooleanDistribution [
	| d sample |
	d := ProbabilityDistribution booleanWith: 0.1 uniform: self random.
	self
		assert: d success;
		deny: d failure;
		assert: (d density: true) = 0.1;
		assert: (d density: false) = 0.9.
	sample := d sample: 1000.
	self assert: (sample count: [:x | x]) < (1000 * d mean * 2)]

{ #category : #'Box-Cox' }
ProbabilityDistributionTest >> testBoxCox [
	| random lognormal sample boxcox data sample2 |
	random := self random.
	lognormal := LogNormalDistribution mean: 3 deviation: 2.
	lognormal uniform: random.
	sample := lognormal sample: 1000.0.
	boxcox := BoxCoxTransformation on: sample.
	boxcox compute.
	boxcox uniform: random.
	self assert: boxcox power abs < 0.1.
	data := boxcox distribution sample: 5000.
	sample2 := SampleSpace on: data.
	sample2 uniform: random.
	self
		assert: (sample2 mean - 3) abs < 0.2;
		assert: (sample2 deviation - 2) abs < 0.3]

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testChiSquare [
	self testEstimatorsOf: ChiSquareDistribution sampleInstance]

{ #category : #'chi-squared' }
ProbabilityDistributionTest >> testChiSquared [
	| degreesOfFreedom modes |
	degreesOfFreedom := #(1 2 3 4 5).
	modes := Dictionary new
		at: 1 put: 0.4549364231195725;
		at: 2 put: 1.3862943611198906;
		at: 3 put: 2.3659738843753377;
		at: 4 put: 3.3566939800333215;
		at: 5 put: 4.3514601910955255;
		yourself.
	degreesOfFreedom do: [:dof | | chi2 |
		chi2 := ChiSquaredDistribution dof: dof.
		self
			assert: chi2 mean = dof;
			assert: chi2 variance ~ (2 * dof);
			assert: chi2 skewness ~ (8 / dof) sqrt;
			assert: chi2 kurtosis ~ (12 / dof);
			assert: (chi2 inverseDistribution: 0.5) ~ (modes at: dof)]]

{ #category : #'chi-squared' }
ProbabilityDistributionTest >> testChiSquaredConfidentInterval [
	| n alpha norm sample sampleSpace variance chi2 oneSided twoSided |
	n := 100.
	alpha := 0.05.
	norm := NormalDistribution standard.
	sample := norm sample: n.
	sampleSpace := SampleSpace on: sample.
	variance := sampleSpace variance.
	chi2 := ChiSquaredDistribution dof: n.
	oneSided := chi2 oneSidedInterval: alpha.
	self assert: variance * n < oneSided.
	twoSided := chi2 twoSidedInterval: alpha.
	self assert: (variance * n between: twoSided first and: twoSided second)]

{ #category : #'chi-squared' }
ProbabilityDistributionTest >> testChiSquaredTest [
	| index table |
	index := Array with: 'Blue collar' with: 'White collar' with: 'Service'.
	table := ContingencyTable index: index.
	table
		at: 'A' put: #(90 30 30);
		at: 'B' put: #(60 50 40);
		at: 'C' put: #(104 51 45);
		at: 'D' put: #(95 20 35).
	table computeMatrix.
	self
		assert: table degreeOfFreedom = 6;
		assert: table pvalue < 0.05;
		assert: (table rejected: 0.05)]

{ #category : #copula }
ProbabilityDistributionTest >> testCopulaDistribution [
	| copula mean marginals p |
	marginals := Array
		with: (BetaDistribution a: 30 b: 70)
		with: (GammaDistribution shape: 2).
	copula := GaussianCopula
		marginals: marginals
		fromSpearman: '
			1    0
			0    1' asFloatMatrix.
	copula uniform: self random.
	mean := copula mean.
	p := 1.
	marginals do: [:marginal | | x |
		x := marginal mean.
		p := p * (marginal distribution: x)].
	self assert: (p - (copula distribution: mean)) abs < 1.0e-4]

{ #category : #copula }
ProbabilityDistributionTest >> testCopulaMean [
	| copula sample sampleMeans means |
	copula := GaussianCopula sampleInstance.
	copula uniform: self random.
	sample := copula sample: 100.
	sampleMeans := OrderedCollection new.
	sample rowsDo: [:row | sampleMeans add: row mean].
	means := copula mean.
	sampleMeans withIndexDo: [:sampleMean :index | | mean |
		mean := means at: 1 @ index.
		self assert: (sampleMean - mean) abs < (0.1 * mean)]]

{ #category : #copula }
ProbabilityDistributionTest >> testCopulaSpearman [
	| copula marginals sample rankings s rho n |
	marginals := Array
		with: (NormalDistribution mean: 30 deviation: 70)
		with: (GammaDistribution shape: 2).
	copula := GaussianCopula
		marginals: marginals
		fromSpearman: '
			1    0.3
			0.3    1' asFloatMatrix.
	copula uniform: self random.
	n := 100.
	sample := copula sample: n.
	rankings := OrderedCollection new.
	sample rowsDo: [:row | rankings add: row ranking].
	s := 0.
	(rankings at: 1) with: (rankings at: 2) do: [:x :y | s := s
		+ (x - y) squared].
	rho := 1 - (6 * s / (n * (n squared - 1))).
	self assert: (rho asFloat - 0.3) abs < 0.1]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testDateDensity [
	| discretized distribution |
	discretized := DiscretizedDistribution
		density: #(0.25 0.25 0.25 0.25 0.0)
		values: #(1.0 2.0 3.0 4.0 5.0).
	distribution := DateDistribution on: discretized startDate: Date today.
	self assert: (distribution density: distribution startDate + 1) = 0.25]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testDateTruncatedMean [
	| distribution |
	distribution := DateDistribution
		truncatedNormalMean: (Date today addDays: 5)
		deviation: 10
		min: nil
		max: Date today.
	self assert: distribution mean < distribution max.
	self
		assert: (distribution mean - (distribution inverseDistribution: 0.5)) abs <= 1]

{ #category : #'negative-binomial' }
ProbabilityDistributionTest >> testDensity [
	| r p nb density |
	nb := NegativeBinomialDistribution sampleInstance.
	nb uniform: self random.
	p := nb p.
	r := nb failures.
	density := [:k | | c |
		c := (k + r - 1) factorial / (k factorial * (r - 1) factorial).
		c * (p raisedTo: k) * (1 - p raisedTo: r)].
	self
		assert: (nb density: 0) ~ (density value: 0);
		assert: (nb density: 4) ~ (density value: 4)]

{ #category : #dirichlet }
ProbabilityDistributionTest >> testDirichletCovariance [
	| n dirichlet sample spaces covariance estimates offDiagonalPoints |
	n := 1000.
	dirichlet := DirichletDistribution on: #(2 3 5).
	dirichlet uniform: self random.
	estimates := Array
		with: OrderedCollection new
		with: OrderedCollection new
		with: OrderedCollection new.
	offDiagonalPoints := Array with: 2 @ 1 with: 3 @ 1 with: 3 @ 2.
	100 timesRepeat: [| covarianceHat |
		sample := dirichlet transposedSample: n.
		covarianceHat := self computeCovariance: sample.
		offDiagonalPoints withIndexDo: [:point :i | | estimate |
			estimate := covarianceHat at: point.
			(estimates at: i) add: estimate]].
	spaces := estimates collect: [:observations | SampleSpace on: observations].
	covariance := dirichlet covariance.
	offDiagonalPoints withIndexDo: [:point :i | | x p |
		x := covariance at: point.
		p := (spaces at: i) distribution: x.
		self assert: (0.05 < p and: [p < 0.95])]]

{ #category : #dirichlet }
ProbabilityDistributionTest >> testDirichletDensity [
	| dirichlet |
	dirichlet := DirichletDistribution sampleInstance.
	dirichlet uniform: self random.
	self
		assert: (dirichlet density: #(0.1 0.1 0.8)) ~ 3.096576000;
		assert: (dirichlet density: #(0.3 0.3 0.4)) ~ 5.225471999999999]

{ #category : #dirichlet }
ProbabilityDistributionTest >> testDirichletLHS [
	| dirichlet sample first second third means |
	dirichlet := DirichletDistribution sampleInstance.
	dirichlet uniform: self random.
	sample := dirichlet latinHypercubeSample: 100.
	first := sample collect: #first.
	second := sample collect: #second.
	third := sample collect: #third.
	means := dirichlet mean.
	self
		assert: (first mean - means first) abs < 0.01;
		assert: (second mean - means second) abs < 0.01;
		assert: (third mean - means third) abs < 0.01]

{ #category : #dirichlet }
ProbabilityDistributionTest >> testDirichletMean [
	| n dirichlet samples spaces means |
	#knownIssue.
	n := 1000.
	dirichlet := DirichletDistribution on: #(2 3 5).
	dirichlet uniform: self random.
	samples := dirichlet transposedSample: n.
	spaces := samples collect: [:sample | SampleSpace on: sample].
	means := dirichlet mean.
	spaces withIndexDo: [:space :i | | mu std mean |
		mu := space mean.
		std := space sd / n sqrt.
		mean := means at: i.
		self assert: (mean - mu) abs / std < 1.96]]

{ #category : #dirichlet }
ProbabilityDistributionTest >> testDirichletVariance [
	| n dirichlet sample means variances sigma2Chi |
	n := 10000.
	dirichlet := DirichletDistribution on: #(2 3 5).
	dirichlet uniform: self random.
	sample := dirichlet transposedSample: n.
	means := dirichlet mean readStream.
	variances := dirichlet variance readStream.
	sigma2Chi := sample collect: [:x | | xmean |
		xmean := means next.
		x sum: [:xi | (xi - xmean) squared]].
	sigma2Chi do: [:s2c | | sigma2 q z |
		sigma2 := variances next.
		q := s2c / sigma2.
		z := q - n / (2 * n) sqrt.
		self assert: z abs < 1.96]]

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testDiscrete [
	true ifTrue: [self testEstimatorsOf: DiscreteDistribution sampleInstance]]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testDiscreteBeUniform [
	| values probabilities d |
	values := Array
		with: 1
		with: 2
		with: 3
		with: 4.
	probabilities := Array
		with: 0.20
		with: 0.30
		with: 0.10
		with: 0.40.
	d := DiscreteDistribution values: values probabilities: probabilities.
	self
		deny: (d distribution: 1) = 0.25;
		assert: (d distribution: 2) = 0.50;
		deny: (d distribution: 3) = 0.75;
		assert: (d distribution: 4) = 1.0.
	d beUniform.
	self
		assert: (d distribution: 1) = 0.25;
		assert: (d distribution: 2) = 0.5;
		assert: (d distribution: 3) = 0.75;
		assert: (d distribution: 4) = 1]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testDiscreteInverseDistribution [
	| discrete |
	discrete := DiscreteDistribution between: 0.0 and: 6.0 steps: 1.
	self assert: (discrete distribution: 0.0) = 0.5.
	self assert: (discrete distribution: 6.0) = 1.0.
	self assert: (discrete inverseDistribution: 0.0) = 0.0.
	self assert: (discrete inverseDistribution: 0.4) = 0.0.
	self assert: (discrete inverseDistribution: 0.6) = 6.0.
	self assert: (discrete inverseDistribution: 0.999) = 6.0.
	self
		assert: (discrete inverseDistribution: (discrete distributionLeft: 0.0)) = 0.0.
	self
		assert: (discrete inverseDistribution: (discrete distributionLeft: 6.0)) = 6.0]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testDiscreteSampling [
	| discrete samples |
	discrete := DiscreteDistribution between: 0.0 and: 6.0 steps: 1.
	samples := (discrete sample: 10) asBag.
	self assert: (samples asSet equalsTo: #(0.0 6.0)).
	self assert: (samples occurrencesOf: 0.0) > 1.
	self assert: (samples occurrencesOf: 6.0) > 1.
	samples := (discrete latinHypercubeSample: 10) asBag.
	self assert: (samples asSet equalsTo: #(0.0 6.0)).
	self assert: (samples occurrencesOf: 0.0) > 1.
	self assert: (samples occurrencesOf: 6.0) > 1]

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testDiscretized [
	false ifTrue: [self testEstimatorsOf: DiscretizedDistribution sampleInstance]]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testDiscretizedBeUniform [
	| d a b |
	d := DiscretizedDistribution
		distribution: #(0.0 0.30 1.0 )
		values: #(1.0 2.0 3.0  ).
	a := 0.5.
	b := -0.5.
	self
		assert: (d distribution: 1) = 0;
		deny: (d distribution: 2) = (a * 2 + b);
		deny: (d distribution: 2.7) = (a * 2.7 + b);
		assert: (d distribution: 3) = 1.
	d beUniform.
	self
		assert: (d distribution: 1) = 0;
		assert: (d distribution: 2) = (a * 2 + b);
		assert: (d distribution: 2.7) = (a * 2.7 + b);
		assert: (d distribution: 3) = 1]

{ #category : #'negative-binomial' }
ProbabilityDistributionTest >> testDistribution [
	| nb cdf n |
	nb := NegativeBinomialDistribution sampleInstance.
	nb uniform: self random.
	n := 4.
	cdf := (0 to: n) sum: [:k | nb density: k].
	self assert: (nb distribution: n) ~ cdf]

{ #category : #utilities }
ProbabilityDistributionTest >> testEstimatorsOf: distribution [
	| statistics tolerance failures |
	distribution uniform: self random.
	tolerance := 0.25.
	failures := 0.
	6 timesRepeat: [
		statistics := distribution statistics: 1000.
		statistics calculate.
		((distribution mean asFloat relativeDistanceTo: statistics mean) < tolerance
			and: [(distribution variance asFloat
				relativeDistanceTo: statistics variance)
				< tolerance]
			and: [
				true or: [
					self
						assert: (distribution kurtosis asFloat
							relativeDistanceTo: statistics kurtosis)
							< tolerance]]
			and: [(distribution skewness asFloat
				relativeDistanceTo: statistics skewness)
				< tolerance])
			ifFalse: [failures := failures + 1]].
	self assert: failures <= 6]

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testExponential [
	self testEstimatorsOf: ExponentialDistribution sampleInstance]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testExponentialSimplex [
	"
	ProbabilityDistributionTest new testExponentialSimplex
	"
	| n uniform simplex copy steps triangles prev space |
	n := 10000.
	uniform := UniformDistribution new uniform: self random.
	simplex := Array streamContents: [:strm | 
		n timesRepeat: [| triad |
			triad := (1 to: 3) collect: [:i | uniform next ln negated].
			strm nextPut: triad * triad sum reciprocal]].
	copy := simplex asOrderedCollection sortBy: [:t :s | t third > s third].
	steps := 100.
	triangles := Array new: steps.
	prev := 0.
	1 to: steps do: [:i | | lambda k |
		lambda := i asFloat / steps.
		k := copy
			findFirst: [:triad | triad third < (1.0 - lambda)]
			ifAbsent: copy size + 1.
		copy := copy allButFirst: k - 1.
		prev := prev + k - 1.
		triangles at: i put: prev / lambda squared].
	space := SampleSpace on: triangles.
	self
		assert: (space mean relativeDistanceTo: n) < 0.05;
		assert: space deviation / space mean < 0.5]

{ #category : #'gamma function' }
ProbabilityDistributionTest >> testGamma [
	| gamma |
	gamma := GammaFunction new.
	self
		assert: (gamma valueAt: 1) ~ 0 factorial;
		assert: (gamma valueAt: 2) ~ 1 factorial;
		assert: (gamma valueAt: 3) ~ 2 factorial;
		assert: (gamma valueAt: 4) ~ 3 factorial;
		assert: (gamma valueAt: 5) ~ 4 factorial;
		assert: (gamma valueAt: 6) ~ 5 factorial;
		assert: (gamma valueAt: 7) ~ 6 factorial;
		assert: (gamma valueAt: 8) ~ 7 factorial;
		assert: (gamma valueAt: 9) ~ 8 factorial;
		assert: (gamma valueAt: 10) ~ 9 factorial;
		assert: (gamma valueAt: 11) ~ 10 factorial;
		assert: (gamma valueAt: 12) ~ 11 factorial;
		assert: (gamma valueAt: 13) ~ 12 factorial;
		assert: (gamma valueAt: 14) ~ 13 factorial;
		assert: (gamma valueAt: 15) ~ 14 factorial]

{ #category : #gamma }
ProbabilityDistributionTest >> testGammaDensity [
	| dist random |
	random := self random.
	dist := GammaDistribution shape: 1.
	dist uniform: random.
	self assert: ((dist density: 1) - 0.3678) abs < 0.001]

{ #category : #gamma }
ProbabilityDistributionTest >> testGammaDistribution [
	| gamma |
	gamma := GammaDistribution shape: 0.5.
	self
		assert: (gamma distribution: 0.5) ~ 0.68268949213709;
		assert: (gamma distribution: 1) ~ 0.84270079294972;
		assert: (gamma distribution: 10) ~ 0.99999225578357.
	gamma := GammaDistribution shape: 1.
	self
		assert: (gamma distribution: 0.5) ~ 0.39346934028737;
		assert: (gamma distribution: 1) ~ 0.63212055882856;
		assert: (gamma distribution: 10) ~ 0.99995460007024.
	gamma := GammaDistribution shape: 10.
	self
		assert: (gamma distribution: 0.5) ~ 0.17096700293489e-9;
		assert: (gamma distribution: 1) ~ 0.11142547833872e-6;
		assert: (gamma distribution: 10) ~ 0.54207028552815]

{ #category : #gamma }
ProbabilityDistributionTest >> testGammaInverseDistribution [
	| gamma |
	gamma := GammaDistribution shape: 0.5.
	self
		assert: (gamma inverseDistribution: 0.68268949213709) ~ 0.5;
		assert: (gamma inverseDistribution: 0.84270079294972) ~ 1;
		assert: ((gamma inverseDistribution: 0.99999225578357)
			relativeDistanceTo: 10)
			< 1.0e-7.
	gamma := GammaDistribution shape: 1.
	self
		assert: (gamma inverseDistribution: 0.39346934028737) ~ 0.5;
		assert: (gamma inverseDistribution: 0.63212055882856) ~ 1;
		assert: (gamma inverseDistribution: 0.99995460007024) ~ 10.
	gamma := GammaDistribution shape: 10.
	self assert: (gamma inverseDistribution: 0.54207028552815) ~ 10]

{ #category : #gamma }
ProbabilityDistributionTest >> testGammaLarge [
	| dist random left right |
	random := self random.
	dist := GammaDistribution shape: 170.
	dist uniform: random.
	left := dist distribution: 169.
	right := dist distribution: 170.
	self assert: (0.5 between: left and: right)]

{ #category : #gamma }
ProbabilityDistributionTest >> testGammaMean [
	| gamma n mean random |
	n := 1000.
	random := self random.
	gamma := GammaDistribution shape: 0.5.
	gamma uniform: random.
	mean := (SampleSpace on: (gamma sample: n)) mean.
	self assert: (gamma mean - mean) abs < 0.5.
	gamma := GammaDistribution shape: 1.
	gamma uniform: random.
	mean := (SampleSpace on: (gamma sample: n)) mean.
	self assert: (gamma mean - mean) abs < 0.5.
	gamma := GammaDistribution shape: 10.
	gamma uniform: random.
	mean := (SampleSpace on: (gamma sample: n)) mean.
	self assert: (gamma mean - mean) abs < 0.5]

{ #category : #gamma }
ProbabilityDistributionTest >> testGammaVariance [
	| n random gamma variance |
	n := 1000.
	random := self random.
	gamma := GammaDistribution shape: 0.5.
	gamma uniform: random.
	variance := (SampleSpace on: (gamma sample: n)) variance.
	self assert: (gamma variance - variance) abs < 0.5.
	gamma := GammaDistribution shape: 1.
	gamma uniform: random.
	variance := (SampleSpace on: (gamma sample: n)) variance.
	self assert: (gamma variance - variance) abs < 0.5.
	gamma := GammaDistribution shape: 10.
	gamma uniform: random.
	variance := (SampleSpace on: (gamma sample: n)) variance.
	self assert: (gamma variance - variance) abs < 5]

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testGeometric [
	self testEstimatorsOf: GeometricDistribution sampleInstance]

{ #category : #'negative-binomial' }
ProbabilityDistributionTest >> testGeometricRelation [
	| nb p geom |
	p := 0.3.
	nb := NegativeBinomialDistribution failures: 1 p: p.
	nb uniform: self random.
	geom := GeometricDistribution around: 1 / (1 - p).
	geom uniform: self random.
	self
		assert: nb mean ~ (p * geom mean);
		assert: nb variance ~ geom variance]

{ #category : #'hypergeometric function' }
ProbabilityDistributionTest >> testHypergeometric [
	| rand hg x p |
	rand := self random.
	p := rand next.
	hg := HypergeometricFunction a: p negated b: 1 c: 1.
	x := rand next.
	self
		assert: ((hg valueAt: x negated) relativeDistanceTo: (1 + x raisedTo: p))
			< 0.00001]

{ #category : #'hypergeometric function' }
ProbabilityDistributionTest >> testHypergeometric2 [
	| rand hg x p |
	rand := self random.
	p := rand next.
	hg := HypergeometricFunction a: 1.0 b: p c: p.
	x := rand next.
	self assert: ((hg valueAt: x) relativeDistanceTo: 1 / (1 - x)) < 0.00001]

{ #category : #'hypergeometric function' }
ProbabilityDistributionTest >> testHypergeometric3 [
	| rand hg x |
	rand := self random.
	hg := HypergeometricFunction a: 0.5 b: -0.5 c: 0.5.
	x := rand next.
	self
		assert: ((hg valueAt: x sin squared) relativeDistanceTo: x cos) < 0.0001]

{ #category : #'hypergeometric function' }
ProbabilityDistributionTest >> testHypergeometric4 [
	| rand hg x |
	rand := self random.
	hg := HypergeometricFunction a: 0.5 b: 0.5 c: 1.5.
	x := rand next.
	self
		assert: ((hg valueAt: x squared) relativeDistanceTo: x arcSin / x) < 0.0002]

{ #category : #'hypergeometric function' }
ProbabilityDistributionTest >> testHypergeometric5 [
	| rand hg x |
	rand := self random.
	hg := HypergeometricFunction a: 1.0 b: 1.0 c: 2.0.
	x := rand next.
	self
		assert: ((hg valueAt: x negated) relativeDistanceTo: (1 + x) ln / x) < 0.00001]

{ #category : #'hypergeometric function' }
ProbabilityDistributionTest >> testHypergeometric6 [
	| rand hg x |
	rand := self random.
	hg := HypergeometricFunction a: 0.5 b: 1.0 c: 1.0.
	x := rand next.
	self
		assert: ((hg valueAt: x sin squared) relativeDistanceTo: 1 / x cos) < 0.0001]

{ #category : #'hypergeometric function' }
ProbabilityDistributionTest >> testHypergeometric7 [
	| rand hg x |
	rand := self random.
	hg := HypergeometricFunction a: 0.5 b: 1.0 c: 1.5.
	x := rand next.
	self
		assert: ((hg valueAt: x squared negated) relativeDistanceTo: x arcTan / x)
			< 0.00001]

{ #category : #'gamma function' }
ProbabilityDistributionTest >> testIncompleteGamma [
	| gamma ratio |
	gamma := IncompleteGammaFunction a: 10.2.
	self
		assert: (gamma at: 0.3) ~ 0.34634830486357e-6;
		assert: (gamma complementaryAt: 0.3) ~ 570499.027840689;
		assert: (gamma at: 0.97) ~ 0.0298014573225;
		assert: (gamma complementaryAt: 0.97) ~ 570498.998039578;
		assert: (gamma at: 20) ~ 567147.63677382;
		assert: (gamma complementaryAt: 20) ~ 3351.39106721473;
		assert: (gamma at: 10.2) ~ 309013.959340303;
		assert: (gamma complementaryAt: 10.2) ~ 261485.068500732.
	gamma := IncompleteGammaFunction a: 0.3.
	self
		assert: (gamma at: 0.3) ~ 2.17474304481568;
		assert: (gamma complementaryAt: 0.3) ~ 0.81682594287191;
		assert: (gamma at: 0.4) ~ 2.32259606881224;
		assert: (gamma complementaryAt: 0.4) ~ 0.66897291887535;
		assert: (gamma at: 0.6) ~ 2.52252517008673;
		assert: (gamma complementaryAt: 0.6) ~ 0.46904381760086.
	ratio := IncompleteGammaFunction new trueGamma: 3.5 deltaRatio: 4.
	gamma := GammaFunction new.
	self assert: ratio ~ ((gamma valueAt: 3.5) / (gamma valueAt: 3.5 + 4))]

{ #category : #'negative-binomial' }
ProbabilityDistributionTest >> testInverseDistribution [
	| nb values |
	nb := NegativeBinomialDistribution sampleInstance.
	nb uniform: self random.
	values := #(0.1 0.3 0.5 0.9).
	values do: [:p | | x |
		x := nb inverseDistribution: p.
		self assert: p <= (nb distribution: x).
		x > 0 ifTrue: [self assert: (nb distribution: x - 1) < p]]]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testIsConsistentWith [
	| distribution exceptions |
	exceptions := #(#GaussianCopula  #SphericalUniform #TruncatedDistribution #TruncatedLogNormalDistribution StringDistribution).
	ProbabilityDistribution allSubclasses
		reject: [:class | exceptions includes: class symbol]
		thenDo: [:each | 
			distribution := each sampleInstance.
			self
				assert: (distribution isConsistentWith: distribution mean)
				description: 'A distribution is not consistent with its mean value'].
	self
		assert: ((TruncatedLogNormalDistribution around: 100) isConsistentWith: 100)
		description: 'TruncatedLogNormalDistribution is not consistent with its default value'.
	distribution := BernoulliDistribution
		parameter: 0.3
		success: true
		failure: false.
	self
		shouldnt: [distribution isConsistentWith: true]
		raise: MessageNotUnderstood
		description: 'BernoulliDistribution fails when checking consistency'.
	self
		assert: (distribution isConsistentWith: true)
		description: 'BernoulliDistribution is not consistent with its possible values';
		assert: (distribution isConsistentWith: false)
		description: 'BernoulliDistribution is not consistent with its possible values']

{ #category : #'other tests' }
ProbabilityDistributionTest >> testIsFinite [
	| distribution |
	distribution := NormalDistribution sampleInstance.
	self deny: distribution isFinite.
	self deny: distribution isDiscrete.
	self deny: distribution isBounded.
	distribution := TriangularDistribution sampleInstance.
	self deny: distribution isFinite.
	self deny: distribution isDiscrete.
	self assert: distribution isBounded.
	distribution := DiscreteDistribution sampleInstance.
	self assert: distribution isFinite.
	self assert: distribution isDiscrete.
	self assert: distribution isBounded.
	distribution := DateDistribution
		between: Date today
		and: (Date today addDays: 10).
	self assert: distribution isFinite.
	self assert: distribution isDiscrete.
	self assert: distribution isBounded.
	distribution := DateDistribution normalMean: Date today deviation: 10.
	self deny: distribution isFinite.
	self assert: distribution isDiscrete.
	self deny: distribution isBounded.
	distribution := DateDistribution
		truncatedNormalMean: Date today
		deviation: 10
		min: (Date today addDays: -3)
		max: (Date today addDays: 5).
	self assert: distribution isFinite.
	self assert: distribution isDiscrete.
	self assert: distribution isBounded]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testIsLike [
	| distribution |
	ProbabilityDistribution allSubclasses do: [:each | 
		distribution := each sampleInstance.
		self
			assert: (distribution isLike: distribution)
			description: 'A distribution is not like itself']]

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testLogNormal [
	true ifTrue: [self testEstimatorsOf: LogNormalDistribution sampleInstance]]

{ #category : #'beta-binomial' }
ProbabilityDistributionTest >> testMoments [
	| distribution beta alpha k gamma gamma2 n p5 |
	alpha := beta := 1.
	n := 10.
	distribution := BetaBinomialDistribution events: n alpha: alpha beta: beta.
	self
		assert: distribution mean = 5;
		assert: distribution variance = (10 * 12 / (2 squared * 3)).
	k := 5.
	gamma := [:x | (x - 1) factorial].
	gamma2 := [:x :y | (gamma value: x) * (gamma value: y) / (gamma
		value: x + y)].
	p5 := (gamma2 value: k + 1 value: n - k + 1) reciprocal / (n + 1)
		* (gamma2 value: k + alpha value: n - k + beta)
		/ (gamma2 value: alpha value: beta).
	self assert: p5 ~ (distribution density: 5)]

{ #category : #'beta-binomial' }
ProbabilityDistributionTest >> testMomentsInference [
	| families distribution |
	"http://en.wikipedia.org/wiki/Beta-binomial_distribution#Example"
	families := #(3 24 104 286 670 1033 1343 1112 829 478 181 45 7).
	distribution := BetaBinomialDistribution from: families.
	self
		assert: (distribution alpha asFloat - 34.1350) abs < 0.0001;
		assert: (distribution beta asFloat - 31.6085) abs < 0.0001]

{ #category : #'negative-binomial' }
ProbabilityDistributionTest >> testNegativeBinomialInverseDistributionLarge [
	| block |
	block := [:nb | | avoid |
		nb uniform: self random.
		avoid := false.
		0 to: 100 do: [:x | | p |
			avoid ifFalse: [
				p := nb distribution: x.
				p ~ 1.0 ifTrue: [avoid := true].
				self assert: (nb inverseDistribution: p) = x]]].
	block value: NegativeBinomialDistribution sampleInstance.
	block value: (NegativeBinomialDistribution failures: 50 p: 0.2)]

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testNormal [
	self testEstimatorsOf: NormalDistribution sampleInstance]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testNormalApproximation [
	"
	NormalDistribution standard initializeStandard
	"
	| d random |
	d := NormalDistribution standard.
	self
		assert: (d distribution: 0.0) ~ 0.5
		description: 'Bad approximation in Normal Distribution'.
	self
		assert: (d inverseDistribution: 0.5) ~ 0.0
		description: 'The inverse distribution of Normal Distributions is wrong'.
	random := UniformDistribution between: -8.0 and: 8.0.
	random uniform: self random.
	1000 timesRepeat: [| u |
		u := random next.
		self assert: (d distribution: u) + (d distribution: u negated) ~ 1.0]]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testNormalContinuity [
	| d value delta less3 less2 less1 central plus1 plus2 plus3 distanceMinus3 distanceMinus2 distanceMinus1 distance1 distance2 distance3 |
	"
	NormalDistribution standard initializeStandard
	"
	d := NormalDistribution standard.
	value := 0.0.
	delta := 1.0e-14.
	less3 := d distribution: value - (delta * 3).
	less2 := d distribution: value - (delta * 2).
	less1 := d distribution: value - delta.
	central := d distribution: value.
	plus1 := d distribution: value + delta.
	plus2 := d distribution: value + (delta * 2).
	plus3 := d distribution: value + (delta * 3).
	distanceMinus3 := less2 - less3.
	distanceMinus2 := less1 - less2.
	distanceMinus1 := central - less1.
	distance1 := plus1 - central.
	distance2 := plus2 - plus1.
	distance3 := plus3 - plus2.
	self assert: (distanceMinus3 relativeDistanceTo: distanceMinus2) < 0.1.
	self assert: (distanceMinus2 relativeDistanceTo: distanceMinus1) < 0.1.
	self assert: (distanceMinus1 relativeDistanceTo: distance1) < 0.1.
	self assert: (distance1 relativeDistanceTo: distance2) < 0.1.
	self assert: (distance2 relativeDistanceTo: distance3) < 0.1]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testNormalDensity [
	| normal |
	normal := NormalDistribution sampleInstance.
	self assert: (normal density: normal deviation * 1000 + normal mean) = 0.0]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testNormalInverseContinuity [
	| d probability delta less3 less2 less1 central plus1 plus2 plus3 distanceMinus3 distanceMinus2 distanceMinus1 distance1 distance2 distance3 |
	"
	NormalDistribution standard initializeStandard
	"
	d := NormalDistribution standard.
	probability := 0.5.
	delta := probability * 1.0e-14.
	less3 := d inverseDistribution: probability - (delta * 3).
	less2 := d inverseDistribution: probability - (delta * 2).
	less1 := d inverseDistribution: probability - delta.
	central := d inverseDistribution: probability.
	plus1 := d inverseDistribution: probability + delta.
	plus2 := d inverseDistribution: probability + (delta * 2).
	plus3 := d inverseDistribution: probability + (delta * 3).
	distanceMinus3 := less2 - less3.
	distanceMinus2 := less1 - less2.
	distanceMinus1 := central - less1.
	distance1 := plus1 - central.
	distance2 := plus2 - plus1.
	distance3 := plus3 - plus2.
	self assert: (distanceMinus3 relativeDistanceTo: distanceMinus2) < 0.1.
	self assert: (distanceMinus2 relativeDistanceTo: distanceMinus1) < 0.1.
	self assert: (distanceMinus1 relativeDistanceTo: distance1) < 0.1.
	self assert: (distance1 relativeDistanceTo: distance2) < 0.1.
	self assert: (distance2 relativeDistanceTo: distance3) < 0.1]

{ #category : #Pareto }
ProbabilityDistributionTest >> testPareto [
	| dist n sample space mean std |
	dist := ParetoDistribution min: 1000 alpha: 15.
	dist uniform: self random.
	n := 1000.
	sample := dist sample: n.
	space := SampleSpace on: sample.
	mean := dist mean.
	std := (dist variance / n) sqrt.
	self assert: space mean - mean / std abs < 1.96]

{ #category : #Pareto }
ProbabilityDistributionTest >> testParetoMomentsAndIQR [
	| dist quantiles iqr |
	dist := ParetoDistribution min: 1000 alpha: 15.
	self
		assert: dist mean ~ 1071.4285714285713;
		assert: dist variance ~ 5886.970172684458.
	quantiles := #(0.25 0.5 0.75) collect: [:q | dist quantile: q].
	iqr := quantiles third - quantiles first.
	self
		assert: quantiles first ~ 1019.3638995121337;
		assert: quantiles second = dist median;
		assert: quantiles second ~ 1047.2941228206266;
		assert: iqr ~ 77.461080182492196]

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testPoisson [
	self testEstimatorsOf: PoissonDistribution sampleInstance]

{ #category : #poisson }
ProbabilityDistributionTest >> testPoissonDensity [
	| lambda poisson definition |
	poisson := PoissonDistribution sampleInstance.
	poisson uniform: self random.
	lambda := poisson mean.
	definition := [:x | (Number e raisedTo: lambda negated) * (lambda
		raisedTo: x)
		/ x factorial].
	1
		to: 10
		do: [:x | self assert: (poisson density: x) ~ (definition value: x)]]

{ #category : #poisson }
ProbabilityDistributionTest >> testPoissonDistribution [
	| poisson definition |
	poisson := PoissonDistribution sampleInstance.
	poisson uniform: self random.
	definition := [:x | (0 to: x) sum: [:k | poisson density: k]].
	1
		to: 10
		do: [:x | self assert: (poisson distribution: x) ~ (definition value: x)]]

{ #category : #poisson }
ProbabilityDistributionTest >> testPoissonInverseDistribution [
	| nb values |
	nb := PoissonDistribution sampleInstance.
	nb uniform: self random.
	values := #(0.1 0.3 0.5 0.9).
	values do: [:p | | x |
		x := nb inverseDistribution: p.
		self assert: p <= (nb distribution: x).
		x > 0 ifTrue: [self assert: (nb distribution: x - 1) < p]]]

{ #category : #poisson }
ProbabilityDistributionTest >> testPoissonInverseDistributionLarge [
	| block |
	block := [:poisson | | avoid |
		poisson uniform: self random.
		avoid := false.
		0 to: 100 do: [:x | | p |
			avoid ifFalse: [
				p := poisson distribution: x.
				p ~ 1.0 ifTrue: [avoid := true].
				self assert: (poisson inverseDistribution: p) = x]]].
	block value: PoissonDistribution sampleInstance.
	block value: (PoissonDistribution around: 25)]

{ #category : #'sample space' }
ProbabilityDistributionTest >> testRankCorrelation [
	| s1 s2 c |
	s1 := #(106 86 100 101 99 103 97 113 112 110).
	s2 := #(7 0 27 50 28 29 20 12 6 17).
	c := s1 rankCorrelation: s2.
	self assert: (c - -0.17575757578) abs < 0.0000000001]

{ #category : #'sample space' }
ProbabilityDistributionTest >> testRanking [
	| space |
	space := #(1.2 2.3 0.8 18 1.2).
	self assert: space ranking = #(2.5 4 1 5 2.5)]

{ #category : #'negative-binomial' }
ProbabilityDistributionTest >> testSample [
	| nb samples |
	nb := NegativeBinomialDistribution sampleInstance.
	nb uniform: self random.
	samples := nb sample: 100.
	self assert: (nb mean - samples mean) abs < (0.2 * nb mean)]

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testSampleInstances [
	| instance |
	ProbabilityDistribution allSubclasses do: [:cls | 
		(#(#ContinuousProbabilityDistribution #DiscreteProbabilityDistribution #MultivariatedDistribution)
			includes: cls symbol)
			ifFalse: [
				self shouldnt: [instance := cls sampleInstance] raise: Error.
				self assert: instance class = cls]]]

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testSampleSpace [
	true ifTrue: [self testEstimatorsOf: SampleSpace sampleInstance]]

{ #category : #'sample space' }
ProbabilityDistributionTest >> testSampleSpaceInterpolatedPercentiles [
	| space sample c |
	sample := #(1 1 2 3 5 5 5 6 8 9).
	space := SampleSpace on: sample.
	c := 0.0.
	sample withoutDuplicates do: [:x | | p |
		p := space density: x.
		c := c + p.
		self assert: (space interpolatedPercentile: c) = x].
	self assert: (space interpolatedPercentile: 0.0) isNil.
	#testTP28638.
	self assert: (space interpolatedPercentile: 0.1) = 1.
	self
		assert: (space interpolatedPercentile: 0.2) = 1;
		assert: (space interpolatedPercentile: 0.25) ~ 1.5;
		assert: (space interpolatedPercentile: 0.3) = 2;
		assert: (space interpolatedPercentile: 1.0) = 9]

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testSampleSpacePercentiles [
	| space |
	space := SampleSpace on: #(2 3 1 3 4).
	#testTP26453.
	self
		assert: (space percentile: 0) isNil;
		assert: (space percentile: 0.2) = 1;
		assert: (space percentile: 0.4) = 2;
		assert: (space percentile: 0.6) = 3;
		assert: (space percentile: 0.8) = 3;
		assert: (space percentile: 1) = 4.
	space := SampleSpace on: #(2 2 2 2 2 2).
	self
		assert: (space percentiles: 10) asSet asArray = #(2)
		description: 'A sample space with a single element should have that element as every valid percentile']

{ #category : #'sample space' }
ProbabilityDistributionTest >> testSampleSpacePercentiles2 [
	| sample percentiles p0 p100 |
	#knownIssue.
	sample := SampleSpace on: (1 to: 20).
	percentiles := sample percentiles: 20.
	p0 := percentiles first.
	p100 := percentiles last.
	self
		assert: (sample distribution: p0) = 0
		description: 'We are not entirely sure about this';
		assert: (sample distribution: p100) = 1]

{ #category : #gamma }
ProbabilityDistributionTest >> testScaledGamma [
	| shape scale gamma sample |
	shape := 5.
	scale := 3.
	gamma := ScaledGammaDistribution shape: shape scale: scale.
	gamma uniform: self random.
	sample := gamma sample: 100.
	self
		assert: gamma mean = (shape * scale);
		assert: gamma variance = (shape * scale squared);
		assert: gamma kurtosis = (6 / shape);
		assert: (sample mean - gamma mean) abs < (0.1 * gamma mean)]

{ #category : #gamma }
ProbabilityDistributionTest >> testScaledGammaEquivalence [
	| shape scale gamma exponential p |
	shape := 1.
	scale := 3.
	gamma := ScaledGammaDistribution shape: shape scale: scale.
	gamma uniform: self random.
	exponential := ExponentialDistribution mean: scale.
	self
		assert: gamma mean = exponential mean;
		assert: gamma variance = exponential variance;
		assert: gamma kurtosis = exponential kurtosis.
	p := 0.3.
	self
		assert: (gamma distribution: gamma mean)
			~ (exponential distribution: gamma mean).
	self
		assert: (gamma inverseDistribution: p) ~ (exponential
			inverseDistribution: p);
		assert: (gamma distribution: (exponential inverseDistribution: 0.3)) ~ 0.3]

{ #category : #strings }
ProbabilityDistributionTest >> testStringSample [
	| values probabilities distribution sample |
	values := #('z' 'a' 'x' 'b' 'f').
	probabilities := #(0.5 0.1 0.2 0.05 0.15).
	distribution := StringDistribution
		values: values
		probabilities: probabilities.
	distribution uniform: self random.
	sample := distribution sample: 10000.
	sample := sample asBag.
	values
		with: probabilities
		do: [:v :p | self
			assert: ((sample occurrencesOf: v) / 10000.0 - p) abs < 0.05]]

{ #category : #'sample space' }
ProbabilityDistributionTest >> testStringStatistics [
	| s |
	self assert: ('a' asFmlValue min: 'b' asFmlValue) = 'a' asFmlValue.
	s := SampleStatistic on: #('a' 'b').
	self
		assert: s min value = 'a';
		assert: s max value = 'b'.
	s := SampleStatistic on: #('a' 'a' 'b' 'c' 'c').
	self
		assert: s min value = 'a';
		assert: s max value = 'c']

{ #category : #'sample space' }
ProbabilityDistributionTest >> testSumFrom [
	self
		assert: 0 sum = 0;
		assert: 1 sum = 1;
		assert: 3 sum = 6.
	self
		assert: (4 sumFrom: 2) = 9;
		assert: (10 sumFrom: 3) = (10 sum - 2 sum)]

{ #category : #'instance creation' }
ProbabilityDistributionTest >> testT5769 [
	self
		shouldnt: [ProbabilityDistribution booleanWith: 2 uniform: self random]
		raise: MessageNotUnderstood]

{ #category : #'instance creation' }
ProbabilityDistributionTest >> testT5932 [
	self assert: (LogNormalDistribution normalMean: 10.0 deviation: -3.2) isNil]

{ #category : #'instance creation' }
ProbabilityDistributionTest >> testT5996 [
	| d dist |
	d := 1.0.
	[
		d := d / 10.0.
		(dist := NormalDistribution mean: 7500.0 deviation: d) notNil]
		whileTrue: [
			self
				deny: (dist quantile: 0.9) = (dist quantile: 0.1)
				description: 'An invaild distribution was built.'].
	d := 1.0.
	[
		d := d / 10.0.
		(dist := LogNormalDistribution mean: 7500.0 deviation: d) notNil]
		whileTrue: [
			self
				deny: (dist quantile: 0.9) = (dist quantile: 0.1)
				description: 'An invaild distribution was built.']]

{ #category : #'instance creation' }
ProbabilityDistributionTest >> testT6034 [
	| dist m |
	m := 9.0.
	[
		m := m + 0.1.
		(dist := TruncatedNormalDistribution
			mean: 7
			deviation: 0.5
			min: m
			max: 12.5) class == TruncatedNormalDistribution]
		whileTrue: [
			self
				deny: (dist quantile: 0.9) = (dist quantile: 0.1)
				description: 'An invaild distribution was built.']]

{ #category : #'instance creation' }
ProbabilityDistributionTest >> testT6140 [
	| dist m |
	m := 2.0.
	[
		m := m * 10.0.
		(dist := TruncatedNormalDistribution
			mean: 0
			deviation: m
			min: -0.25
			max: 0.25) class == TruncatedNormalDistribution]
		whileTrue: [
			self
				deny: (dist quantile: 0.9) < (dist quantile: 0.1)
				description: 'An invaild distribution was built.']]

{ #category : #percentiles }
ProbabilityDistributionTest >> testTP10509 [
	| values probabilities discrete set date truncated set2 |
	values := #(0 365 730 1096).
	probabilities := #(0.4 0.3 0.2 0.1).
	discrete := DiscreteDistribution
		values: values
		probabilities: probabilities.
	set := #(0.0 0.01 0.05 0.10 0.25 0.75 0.90 0.99 1.0)
		collect: [:p | discrete percentile: p]
		thenSelect: #notNil
		in: Set new.
	self assert: set size >= 3.
	self
		assert: (discrete percentile: 0.0) = 0;
		assert: (discrete percentile: 0.4) = 0;
		assert: (discrete percentile: 0.4001) = 365;
		assert: (discrete percentile: 0.7) = 365;
		assert: (discrete percentile: 0.7001) = 730;
		assert: (discrete percentile: 0.9) = 730;
		assert: (discrete percentile: 0.9001) = 1096;
		assert: (discrete percentile: 1.0) = 1096.
	date := DateDistribution
		on: discrete
		startDate: (Date newDay: 7 monthIndex: 1 year: 2010).
	truncated := date
		truncateFrom: (Date newDay: 1 monthIndex: 1 year: 1980)
		to: (Date newDay: 31 monthIndex: 12 year: 2099).
	set2 := #(0.0 0.01 0.05 0.10 0.25 0.75 0.90 0.99 1.0)
		collect: [:p | truncated percentile: p]
		thenSelect: #notNil
		in: Set new.
	self
		assert: set2 size = set size
		description: 'This should have the same number of percentiles than the wrapped discrete distribution. Check percentiles']

{ #category : #'instance creation' }
ProbabilityDistributionTest >> testTP11069 [
	| d |
	d := ProbabilityDistributionValidator new
		validateDiscretizedDistribution: #(0 0.25 0.5 0.75 1.0)
		values: #(4.99999999999997e21 7.49999999999996e21 1.0e22 1.25e22 1.5e22).
	self assert: d notNil]

{ #category : #strings }
ProbabilityDistributionTest >> testTP16442 [
	| distribution |
	distribution := StringDistribution
		values: #('a' 'b' 'c' 'd')
		probabilities: #(0.25 0.25 0.25 0.25).
	self
		assert: distribution mean isNil;
		deny: distribution sd isNil;
		deny: distribution deviation isNil]

{ #category : #'instance creation' }
ProbabilityDistributionTest >> testTP16504 [
	self
		assert: (TriangularDistribution
			withPercentile: 0
			valued: 10.0
			left: 11.0
			right: 22.0) isNil;
		assert: (TriangularDistribution
			withPercentile: 1
			valued: 10.0
			left: 11.0
			right: 22.0) isNil]

{ #category : #'instance creation' }
ProbabilityDistributionTest >> testTP17252 [
	| probabilities values d |
	probabilities := #(0 0.25 0.5 0.75 1.0).
	values := #(0.15 0.225 0.3 0.375 0.45).
	d := ProbabilityDistribution
		cumulativeProbabilities: probabilities
		value: values
		min: values min
		max: values max.
	self assert: d notNil; assert: d validate hasPassed]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testTP17295 [
	| date |
	date := DateDistribution
		around: (Date newDay: 7 monthIndex: 1 year: 2010)
		baseClass: NormalDistribution.
	self assert: (date displayString includesString: 'Normal')]

{ #category : #percentiles }
ProbabilityDistributionTest >> testTP17342 [
	| ln |
	ln := LogNormalDistribution
		withPercentiles: 0.0
		valued: 0.9
		and: 0.0
		valued: 1.0.
	self assert: ln isNil]

{ #category : #percentiles }
ProbabilityDistributionTest >> testTP20293 [
	| d |
	d := BernoulliDistribution parameter: 0.25 success: true failure: false.
	self
		assert: (d percentile: 0.0) = true;
		assert: (d percentile: 0.1) = true;
		assert: (d percentile: 0.3) = false;
		assert: (d percentile: 1.0) = false;
		assert: (d distribution: true) = 0.25;
		assert: (d distribution: false) = 1.0]

{ #category : #percentiles }
ProbabilityDistributionTest >> testTP21612 [
	| distribution p50 strm copy |
	distribution := DiscreteDistribution around: 100.
	p50 := distribution inverseDistribution: 0.5.
	strm := #[] writeStream.
	ObjectSerializer dump: distribution on: strm.
	strm := strm contents readStream.
	copy := ObjectSerializer loadFrom: strm.
	self assert: (copy inverseDistribution: 0.5) = p50]

{ #category : #'sample space' }
ProbabilityDistributionTest >> testTP26453 [
	| sample |
	sample := SampleSpace on: (0 to: 3).
	self
		assert: (sample percentile: 0) isNil;
		assert: (sample inverseDistribution: 0) isNil;
		assert: (sample distribution: 0) = 0.25]

{ #category : #strings }
ProbabilityDistributionTest >> testTP26749 [
	| distribution r |
	distribution := StringDistribution for: 'TP26749'.
	r := self random.
	distribution uniform: r.
	self
		assert: distribution uniform == r;
		assert: distribution deviate uniform == r]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testTP27340 [
	| uniform x sample |
	uniform := self random.
	x := DiscretizedDistribution
		distribution: (0.0 to: 1.0 size: 10)
		values: (1 to: 10).
	x uniform: uniform.
	sample := x sample: 1000.
	100 timesRepeat: [| a count frequency |
		a := 0.9 - 0.6 * uniform next + 0.6.
		count := sample count: [:xi | xi / 10.0 between: a and: a + 0.1].
		frequency := count / sample size asFloat.
		self assert: (0.1 - frequency) abs < 0.05]]

{ #category : #beta }
ProbabilityDistributionTest >> testTP27550 [
	| beta |
	beta := BetaDistribution around: 0.5.
	self assert: (beta density: 0.0) = 0]

{ #category : #'basic protocol' }
ProbabilityDistributionTest >> testTP27657 [
	| random |
	random := self random.
	50 timesRepeat: [| a beta copy |
		a := random next.
		beta := BetaDistribution around: a.
		beta notNil
			ifTrue: [
				copy := BetaDistribution mean: beta mean deviation: beta sd.
				self
					assert: copy a ~ beta a;
					assert: copy b ~ beta b]
			ifFalse: [self assert: (a < 0.1 or: [a > 0.9])]]]

{ #category : #'basic protocol' }
ProbabilityDistributionTest >> testTP27665 [
	| d |
	d := DiscreteDistribution around: 1.
	self assert: d deviation > 0]

{ #category : #'sample space' }
ProbabilityDistributionTest >> testTP28638 [
	| sample space |
	sample := Array new: 20.
	sample
		atAllPut: 0;
		at: 20 put: 10.
	space := SampleSpace on: sample.
	0.05
		to: 0.95
		by: 0.05
		do: [:p | self assert: (space interpolatedPercentile: p) = 0.0].
	self assert: (space interpolatedPercentile: 1) = 10]

{ #category : #beta }
ProbabilityDistributionTest >> testTP28640 [
	| d string d2 |
	d := PertDistribution a: 2.0 b: 2.0.
	string := d pvrSurrogate storeString.
	d2 := Compiler evaluate: string.
	self
		assert: d2 notNil;
		assert: d validate hasPassed;
		assert: (d2 convertValuesWith: 2.0) == d2]

{ #category : #percentiles }
ProbabilityDistributionTest >> testTP28704 [
	| lognormal p90 p10 |
	lognormal := LogNormalDistribution withPercentile: 0.9 ratio: 2 mean: 3.
	p90 := lognormal percentile: 0.9.
	p10 := lognormal percentile: 1.0 - 0.9.
	self
		assert: p90 / p10 = 2;
		assert: lognormal mean = 3.
	lognormal := LogNormalDistribution withPercentile: 0.1 ratio: 0.7 mean: 3.
	p10 := lognormal percentile: 0.1.
	p90 := lognormal percentile: 1.0 - 0.1.
	self
		assert: p10 / p90 ~ 0.7;
		assert: lognormal mean = 3]

{ #category : #beta }
ProbabilityDistributionTest >> testTP28912 [
	| beta x |
	beta := BetaDistribution a: 1 b: 99.
	x := beta inverseDistribution: 0.999.
	self assert: (x relativeDistanceTo: 0.06739665) < 0.01]

{ #category : #'sample space' }
ProbabilityDistributionTest >> testTP30411 [
	| space |
	space := SampleSpace
		on: (Array
			with: Date yesterday
			with: nil asFmlValue
			with: Date today
			with: Date tomorrow).
	self
		assert: (space interpolatedPercentile: 0.25) isUndefinedValue;
		assert: (space interpolatedPercentile: 0.5) = Date yesterday;
		assert: (space interpolatedPercentile: 0.75) = Date today;
		assert: (space interpolatedPercentile: 1) = Date tomorrow]

{ #category : #'sample space' }
ProbabilityDistributionTest >> testTP30411b [
	| space |
	space := SampleSpace on: (Array
		with: 2
		with: nil asFmlValue
		with: 1
		with: 3).
	self
		assert: (space interpolatedPercentile: 0.25) isUndefinedValue;
		assert: (space interpolatedPercentile: 0.4) = 1;
		assert: (space interpolatedPercentile: 0.5) = 1;
		assert: (space interpolatedPercentile: 0.75) = 2;
		assert: (space interpolatedPercentile: 1) = 3]

{ #category : #binomial }
ProbabilityDistributionTest >> testTP31244 [
	"
	ShellDLL current openWebPage: 'http://www.danielsoper.com/statcalc3/calc.aspx?id=70'
	"
	| binomial |
	binomial := BinomialDistribution events: 10 probability: 0.3.
	self assert: ((binomial distribution: 3) - 0.64961072) abs < 1.0e-8]

{ #category : #mode }
ProbabilityDistributionTest >> testTP34536 [
	| distribution |
	distribution := StringDistribution
		values: #('a' 'b' 'c')
		probabilities: #(0.2 0.5 0.3).
	self assert: distribution mode = 'b']

{ #category : #mode }
ProbabilityDistributionTest >> testTP34537 [
	| today distribution |
	today := Date today.
	distribution := DateDistribution
		discreteProbabilities: #(0.2 0.5 0.3)
		values: (Array with: today previousDate with: today with: today nextDate).
	self assert: distribution mode = today]

{ #category : #beta }
ProbabilityDistributionTest >> testTP42890 [
	| pert |
	pert := PertDistribution around: 100.
	self
		assert: pert next - 100 < 10;
		assert: pert kurtosis > 0]

{ #category : #'basic protocol' }
ProbabilityDistributionTest >> testTP5548 [
	| distribution date number boolean exceptions |
	date := Date today.
	number := 7.0.
	boolean := false.
	exceptions := #(#GaussianCopula #BernoulliDistribution #DateDistribution #SphericalUniform).
	ProbabilityDistribution allSubclasses do: [:class | 
		(exceptions includes: class symbol) ifFalse: [
			self
				shouldnt: [
					distribution := class sampleInstance.
					self deny: (distribution isConsistentWith: date).
					self deny: (distribution isConsistentWith: boolean)]
				raise: MessageNotUnderstood].
		distribution := BernoulliDistribution
			parameter: 0.3
			success: true
			failure: false.
		self deny: (distribution isConsistentWith: number).
		self deny: (distribution isConsistentWith: date).
		distribution := DateDistribution around: date.
		self deny: (distribution isConsistentWith: number).
		self deny: (distribution isConsistentWith: boolean)]]

{ #category : #'instance creation' }
ProbabilityDistributionTest >> testTP5972 [
	| log |
	log := LogNormalDistribution
		withPercentiles: 0.1
		valued: 2.0
		and: 0.9
		valued: 1.06497983679518.
	self
		assert: log isNil
		description: 'Should not return a log normal distribtuion with inner normal = nil']

{ #category : #'instance creation' }
ProbabilityDistributionTest >> testTP6060 [
	| lnd |
	self
		shouldnt: [
			lnd := LogNormalDistribution
				withPercentiles: 0.1
				valued: 0.937
				and: 0.9
				valued: 9000000000000000000000000000000000000000000000000000]
		raise: Error;
		assert: lnd isNil]

{ #category : #truncation }
ProbabilityDistributionTest >> testTP6329 [
	| distribution truncated |
	distribution := DiscreteDistribution
		values: #(0.30416666666664 246.4)
		probabilities: #(0.85 0.15).
	truncated := distribution truncateFrom: 0.0 to: 3650.
	self assert: truncated == distribution.
	distribution := DiscreteDistribution
		values: #(0.30416666666664 246.4 300)
		probabilities: #(0.85 0.1 0.05).
	truncated := distribution truncateFrom: 200 to: nil.
	self deny: truncated isNil]

{ #category : #truncation }
ProbabilityDistributionTest >> testTP6714 [
	| d |
	d := DiscreteDistribution sampleInstance.
	self
		shouldnt: [d truncateFrom: d min - 1 to: nil] raise: MessageNotUnderstood;
		shouldnt: [d truncateFrom: nil to: d max + 1] raise: MessageNotUnderstood]

{ #category : #'instance creation' }
ProbabilityDistributionTest >> testTP8263 [
	| t |
	self
		shouldnt: [
			t := TriangularDistribution
				withPercentile: 0
				valued: 0
				left: 0
				right: 0]
		raise: ArithmeticError;
		assert: t isNil]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testTranslateBy [
	| d copy |
	d := DateDistribution around: Date today.
	copy := d copy translateBy: 1.
	self assert: d mean + 1 = copy mean; assert: d sd = copy sd.
	copy translateBy: -1.
	self assert: d mean = copy mean; assert: d sd = copy sd.
	d := SampleSpace on: #(1 2 3 4).
	copy := d copy translateBy: 1.
	self assert: d mean + 1 = copy mean; assert: d sd = copy sd.
	d := NormalDistribution mean: 10 deviation: 1.
	copy := d copy translateBy: -1.
	self assert: d mean - 1 = copy mean; assert: d sd = copy sd.
	d := LogNormalDistribution mean: 10 deviation: 1.
	copy := d copy translateBy: -1.
	self assert: d mean - 1 = copy mean; assert: d sd = copy sd.
	copy := d copy translateBy: -11.
	copy translateBy: 11.
	self deny: d mean = copy mean; assert: d sd = copy sd.
	d := DiscreteDistribution
		values: #(1 2 3 4)
		probabilities: #(0.3 0.2 0.4 0.1).
	copy := d copy translateBy: -1.
	self
		assert: copy values = #(0 1 2 3);
		assert: copy probabilities = d probabilities.
	d := DiscretizedDistribution
		distribution: #(0.0 0.5 0.9 1.0)
		values: #(1 2 3 4).
	copy := d copy translateBy: -1.
	self assert: d mean - 1 = copy mean; assert: d sd = copy sd.
	d := UniformDistribution from: 0 to: 1.
	copy := d copy translateBy: 1.
	self assert: copy min = 1; assert: copy max = 2.
	copy translateBy: -1.
	self assert: d min = copy min; assert: d max = copy max.
	d := TriangularDistribution left: -0.75 mid: 0.0 right: 1.25.
	copy := d copy translateBy: 1.
	self
		assert: copy left = 0.25;
		assert: copy mid = 1;
		assert: copy right = 2.25.
	copy translateBy: -1.
	self
		assert: copy left = d left;
		assert: copy mid = d mid;
		assert: copy right = d right.
	d := TruncatedNormalDistribution around: 1.
	copy := d copy translateBy: 1.
	self assert: copy min = (d min + 1); assert: copy max = (d max + 1).
	copy translateBy: -1.
	self assert: copy min = d min; assert: copy max = d max]

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testTriangular [
	self testEstimatorsOf: TriangularDistribution sampleInstance]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testTruncatedDiscreteInverseDistribution [
	| distribution truncated |
	distribution := DiscreteDistribution between: 0.0 and: 6.0 steps: 1.
	truncated := (DiscreteDistribution between: -6.0 and: 6.0 steps: 2)
		truncateFrom: 0.0
		to: nil.
	self
		assert: (truncated distributionLeft: 0.0)
			~ (distribution distributionLeft: 0.0).
	self
		assert: (truncated distribution: 0.0) ~ (distribution distribution: 0.0).
	self
		assert: (truncated distributionLeft: 6.0)
			~ (distribution distributionLeft: 6.0).
	self
		assert: (truncated distribution: 6.0) = (distribution distribution: 6.0).
	self
		assert: (truncated inverseDistribution: 0.0)
			= (distribution inverseDistribution: 0.0).
	self
		assert: (truncated inverseDistribution: 0.4)
			= (distribution inverseDistribution: 0.4).
	self
		assert: (truncated inverseDistribution: 0.6)
			= (distribution inverseDistribution: 0.6).
	self
		assert: (truncated inverseDistribution: 0.999)
			= (distribution inverseDistribution: 0.999)]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testTruncatedDiscreteSampling [
	| truncated samples |
	truncated := (DiscreteDistribution between: -6.0 and: 6.0 steps: 2)
		truncateFrom: 0.0
		to: nil.
	samples := (truncated sample: 10) asBag.
	self assert: (samples asSet equalsTo: #(0.0 6.0)).
	self assert: (samples occurrencesOf: 0.0) > 1.
	self assert: (samples occurrencesOf: 6.0) > 1.
	samples := (truncated latinHypercubeSample: 10) asBag.
	self assert: (samples asSet equalsTo: #(0.0 6.0)).
	self assert: (samples occurrencesOf: 0.0) > 1.
	self assert: (samples occurrencesOf: 6.0) > 1]

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testTruncatedLogNormal [
	false ifTrue: [self testEstimatorsOf: TruncatedLogNormalDistribution sampleInstance]]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testTruncatedMean [
	| distribution |
	distribution := TruncatedNormalDistribution
		mean: 180.0
		deviation: 9.0
		min: nil
		max: 180.03.
	self assert: distribution mean < distribution max.
	self
		assert: (distribution mean
			relativeDistanceTo: (distribution inverseDistribution: 0.5))
			< 0.01]

{ #category : #'testing estimators' }
ProbabilityDistributionTest >> testTruncatedNormal [
	false ifTrue: [self testEstimatorsOf: TruncatedNormalDistribution sampleInstance]]

{ #category : #'chi-squared' }
ProbabilityDistributionTest >> testUniformChiSquaredTest [
	| n data index table lower expected step |
	n := 10000.
	data := Array new: n.
	data := self random next: n into: data.
	index := Array with: '1'.
	table := ContingencyTable index: index.
	lower := 0.
	step := 1 / 100.0.
	(step to: 1 by: step) do: [:upper | | ocurrences |
		ocurrences := data count: [:r | r between: lower and: upper].
		table at: lower @ upper put: (Array with: ocurrences).
		lower := upper].
	table computeMatrix.
	expected := table matrix collect: [:dummy | n * step].
	table expectedMatrix: expected.
	self
		assert: table degreeOfFreedom = (step reciprocal - 1);
		deny: table pvalue < 0.05;
		deny: (table rejected: 0.05)]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testUnusualTruncation [
	| truncated min max |
	min := 99.
	max := 100.
	truncated := TruncatedNormalDistribution
		mean: 10
		deviation: 1
		min: min
		max: max.
	self assert: truncated isNil]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testValuesNotConstant [
	| distribution values |
	ProbabilityDistribution allSubclasses do: [:each | 
		distribution := each sampleInstance.
		values := (1 to: 100) collect: [:i | distribution next].
		self
			assert: values asSet size > 1
			description: 'All the values answered by a distribution can not be equal']]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testVoutierApproximation [
	| normal rand u x v |
	normal := NormalDistribution mean: 0.0 deviation: 1.0.
	rand := self random.
	1000 timesRepeat: [
		u := rand next.
		x := normal voutier: u.
		v := normal hart: x.
		self assert: (v - u) abs < 0.00001]]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testVoutierApproximation2 [
	| normal rand u x v |
	normal := NormalDistribution mean: -7.0 deviation: 3.0.
	rand := self random.
	1000 timesRepeat: [
		u := rand next.
		x := normal inverseDistribution: u.
		v := normal distribution: x.
		self assert: (v - u) abs < 0.00001]]

{ #category : #'other tests' }
ProbabilityDistributionTest >> testVoutierApproximation3 [
	| normal rand u x v |
	normal := NormalDistribution mean: 0.0 deviation: 1.0.
	rand := self random.
	1000 timesRepeat: [
		u := rand next.
		x := normal inverseDistribution: u.
		v := normal distribution: x.
		self assert: (v - u) abs < 0.00001]]

