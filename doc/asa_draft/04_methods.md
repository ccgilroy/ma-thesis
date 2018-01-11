---
---

# Methods

Here I outline the process of going from the data sources above to results that can be meaningfully described and analyzed.

## Geocoding

From the GayCities listings, I programmatically extract each bar's address. I first filter out bars with addresses outside the US. Then, because these listings do not include zip codes, I retrieve more precise addresses, including zip codes and other information, from the Google Maps geocoding API.[^google_maps] I manually adjudicate the 9 addresses for which Google Maps returns multiple results.[^zip] I batch code these refined addresses using the Census Geocoding API, a service that links addresses or coordinates to Census geographies.[^geocoder]

Finally, I geocode the 38 addresses for which the Census returns a tie or a failure to match an address through individual API calls. These calls uses the latitude and longitude provided by Google Maps instead of addresses. In this way, I am able to successfully geocode all 840 bars within Census tracts.

[^zip]: Individual bar pages contain addresses with zip codes. These, however, were not captured as frequently by the Wayback Machine, and might therefore be more recent addresses. In cases of uncertainty, I do use these individual pages to help make qualitative judgments.

[^google_maps]: https://developers.google.com/maps/documentation/geocoding/start

[^geocoder]: https://www.census.gov/geo/maps-data/data/geocoder.html

## Clustering

The previous step gives me a set of 488 Census tracts with varying numbers of bars. However, the object of sociological interest for this study is not Census tracts, but neighborhoods.

Gay bars frequently occur in spatially contiguous clusters of tracts. I use this fact to produce clusters of tracts which I argue will roughly correspond to gay neighborhoods. Achieving this correspondence is the primary motivation for taking this step. Furthermore, this *regionalization* process has the ancillary advantage of reducing the margin of error in ACS variable estimates, which can be substantial at the tract level [@spielman_reducing_2015].

For my clustering process, I only consider the geometries of tracts containing gay bars. I take a simple spatial approach: groups of adjacent, contiguous tracts form a cluster or neighborhood. Tracts that share only a corner, not a line border, are not considered adjacent.[^corners]

[^corners]: These exist, for example, in Denver and Phoenix.

I use the `sf` and `sp` packages for spatial data in R to generate lists of adjacent tracts, and I use the `igraph` package to assign numeric identifiers to the clusters produced by this adjacency list [CITE]. See [APPENDIX] for a network graph of these clusters.

## Filtering

I visually inspect the output of the above clustering process, which produces 253 clusters ranging in size from single tracts to 13 grouped tracts. Not all of these groups are gay neighborhoods. I use the size of the cluster as a filtering mechanism. The key assumption I make is that *far-flung, isolated bars are not part of gay neighborhoods.* Therefore, for each city I retain only largest cluster or clusters by number of bars.[^boston]

[^boston]: In the only case wherein this metric results in a tie, between the South End and Fenway in Boston, I choose the South End, which has more tracts. I note that GayCities observes the South End to be highly gentrified in 2007 (it "was the traditional gay neighborhood and is still a pleasant area for a walk"), and the ACS data support this observation. They do not discuss Fenway.

A second rule I implement is to exclude downtown Census tracts from consideration. I do this based on the assumption that *a city's central business district is not its gay neighborhood.* This is an operationalization of Levine's third criterion for gay neighborhoods, that they be a "culture area" wherein LGBTQ people are "locally dominant" [@levine_gay_1979]. LGBTQ people do not dominate the CBD of any city of which the author is aware, except perhaps Palm Springs. I rerun my clustering algorithm with this restriction in place.

A second aspect of filtering my data is to curate the number of cities I include, because not all cities have well-defined or established gay neighborhoods.[^alternate_clustering] For my analyses, I choose the 24 cities that most clearly have discernible clusters of bars corresponding to known or probable gay neighborhoods. I exclude the other 24 US cities and the nine resort towns. This is done inductively, based both on my interpretation of prior academic literature and on my inspection of the clusters. I assign three clusters to New York, two to San Francisco and Chicago, and one to all other cities that I include.[^la] I combine neighborhood labels and descriptions from the GayCities data with information from the literature to assign descriptive names to each of these 28 neighborhoods. See [APPENDIX] for the full list.

[^la]: Long Beach, in Los Angeles County, is collapsed together with Los Angeles proper for discussions of context. This nominally gives LA two neighborhoods, as well.

[^alternate_clustering]: I plan to implement and evaluate alternative specifications for aggregation and inclusion. To address the concern that my qualitative approach based on consideration of the literature and data is too subjective, I will also employ a filtering approach using only quantitative thresholds for inclusion. For example, I might use the largest cluster for each city. To compare and justify the filtering and aggregation processes as a whole, I will perform baseline analyses using all clusters, regardless of size or relevance, and finally as individual, unclustered tracts. This latter would be the conventional approach in the demographic urban literature (with, perhaps, some allowance for spatial autocorrelation). These are not robustness checks, in the sense that I *do* expect to see differences, but they are an important part of sensitivity analysis. At the moment, I can only claim that my current approach is preferable to these in a qualitative sense.

## Variable selection

I select six specific variables from the ACS, driven by two factors: the kinds of changes I expect to see, and a focus on normative or privileged categories.

In terms of demographic characteristics, I select counts and calculate proportions. I use *male* and non-Hispanic *white*. I also use *college-educated*, meaning with a bachelors degree or graduate/professional degree, and *married*, referring only to different-sex married couples. The Census Bureau recodes same-sex married couples to unmarried partners.

I select two variables as economic indicators, *median rent* and *median income.* The latter is median household income. Where I present numbers, I have converted the 2010 values to 2015 dollars, using the conversion factor recommended by the Census for comparison. Where I combine tracts, I take a simple average of medians.

## Modeling strategies[^modeling]

[^modeling]: I have not yet implemented these models in all their variations. I plan to fit a range of models, beginning with ordinary least squares regression, and moving toward more complex multilevel models. In addition to models using matched neighborhoods, I plan to fit models incorporating all tracts as a baseline and robustness check.

These models will take the following form:

$$x_{t+1} \sim \mathcal{N}(\alpha_{city} + \beta_1 gay_{t} + \beta_2 x_{t} + X\beta_{controls}, \sigma^2)$$

$$\alpha_{city} \sim \mathcal{N}(\alpha, \sigma_\alpha^2)$$

Using the variables above and an indicator for whether or not a neighborhood is a gay neighborhood.

[This is where to talk about RESEARCH DESIGN, like Kate suggested]

to accomplish this purpose, a series

the models I will build toward conform to the following characteristics

matching

multilevel model

Two sets of models, one against all other tracts as a baseline,

regressions of the form

and one using matched neighborhoods synthetically constructed to be comparable to each gay neighborhood at the first time point.

Descriptive plots of variables are not sufficient

why gay neighborhoods are different, whether this can be attributed to something about the fact that they are recognized gay spaces.

Because I am examining neighborhoods grouped within different cities, a *multilevel model* is appropriate.

*matching*

What I describe is already a complex modeling strategy. And I'm not done yet.

Two other complexities to potentially implement are to allow for the correlation of errors and to incorporate uncertainty deriving from measurement. As my earlier discussion of neighborhood change suggests, I expect that different kinds of changes might be correlated with each other. I can allow for that possibility by putting a correlation matrix on the error terms of the equations, creating what economists call Seemingly Unrelated Regressions [@zellner_direct_2010]. Finally, so as not to overstate the certainty of my models, the most appropriate modeling strategy would also incorporate the margins of error associated with the ACS estimates [@mcelreath_statistical_2016].[^complexity] These are important ideas, but not essential ones.

[^complexity]: To incorporate correlations among different regression equations, and measurement error from the ACS observations, I would need to write Bayesian model specifications from scratch in Stan [@carpenter_stan:_2017]. I do not yet know whether my data are sufficient to estimate models of that level of complexity. Again, these are ideal steps, but not critical ones.

I will estimate

answer question, specify theoretical things, most justifiable use of my data.
