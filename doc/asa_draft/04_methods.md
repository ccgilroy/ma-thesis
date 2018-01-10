---
---

# Methods

Here I outline the process of going from the data sources above to results that can be meaningfully described and analyzed.

## Geocoding

From the GayCities listings, I programmatically extract each bar's address. I first filter out bars with addresses outside the US. Then, because these listings do not include zip codes, I retrieve more precise addresses, including zip codes and other information, from the Google Maps geocoding API. I manually adjudicate the 9 addresses for which Google Maps returns multiple results.[FOOTNOTE] I batch code these refined addresses using the Census Geocoding API, a service that links addresses or coordinates to Census geographies.[LINK]

Finally, I geocode the 38 addresses for which the Census returns a tie or a failure to match an address through individual API calls. These calls uses the latitude and longitude provided by Google Maps instead of addresses. In this way, I am able to successfully geocode all 840 bars within Census tracts.

[FOOTNOTE] Individual bar pages contain addresses with zip codes. These, however, were not captured as frequently by the Wayback Machine, and might therefore be more recent addresses. In cases of uncertainty, I do use these individual pages to help make qualitative judgments.

[NOTE] What this means is that Google is better than the Census at figuring out where an address is. Specifically, I developed this process after noting via manual inspection of an initial map that the Census was failing to correctly code directional addresses (e.g. East Pine Street in Seattle).

## Clustering

The previous step gives me a set of 488 Census tracts with varying numbers of bars. However, the object of sociological interest for this study is not Census tracts, but neighborhoods.

Gay bars frequently occur in spatially contiguous clusters of tracts. I use this fact to produce clusters of tracts which I argue will roughly correspond to gay neighborhoods. Achieving this correspondence is the primary motivation for taking this step. Furthermore, this *regionalization* process has the ancillary advantage of reducing the margin of error in ACS variable estimates, which can be substantial at the tract level [@spielman_reducing_2015].

For my clustering process, I only consider the geometries of tracts containing gay bars. I take a simple spatial approach: groups of adjacent, contiguous tracts form a cluster or neighborhood. Tracts that share only a corner, not a line border, are not considered adjacent.

[FOOTNOTE] These exist, for example, in Denver and Phoenix.

I use the `sf` and `sp` packages for spatial data in R to generate lists of adjacent tracts, and I use the `igraph` package [CITE] to assign numeric identifiers to the clusters produced by this adjacency list. See [APPENDIX] for a network graph of these clusters.

## Filtering

I visually inspect the output of the above clustering process, which produces 253 clusters ranging in size from single tracts to 13 grouped tracts.

operationalize

The key assumption is that *far-flung, isolated bars are not part of gay neighborhoods.* Therefore, for each city



rule of no downtowns

A second rule,

*A city's central business district is not its gay neighborhood.*

This is an operationalization of Levine's third criterion for gay neighborhoods, that they be a "culture area" wherein LGBTQ people are "locally dominant" [@levine_gay_1979].

I rerun

LGBTQ people do not dominate the CBD of any city of which the author is aware.

(Except perhaps Palm Springs)

ones and zeros.

The largest cluster or clusters by number of bars.

[In the only case wherein this metric results in a tie, between the South End and Fenway in Boston, I choose the South End, which has more tracts. I note that GayCities observes the South End to be highly gentrified in 2007, and my data support this observation. They do not mention Fenway.]

A second aspect of filtering my data is to curate the number of cities I include.

See [APPENDIX] for these labels. (Or present them in main body of text?)

This approach is qualitative and inductive

the other is quantitative

## Variable selection

the specific variables I select are vari[???]

Driven by two factors: the kinds of changes I expect to see, and normative or privileged categories.

"male"

"white" means non-Hispanic white

"college-educated" means with a bachelors degree or graduate/professional degree

"married" refers only to different-sex married couples; the Census Bureau recodes same-sex married couples to unmarried partners.

I select two variables as economic indicators, "median rent" and "median income." The latter is median household income. Where I present numbers, I have converted the 2010 values to 2015 dollars, using the conversion factor recommended by the Census for comparison. Where I combine tracts, I take a simple average of medians.

[FOOTNOTE] I will improve this later using more sophisticated approaches, such as weighted averages. I do not yet show median data for counties.

## Modeling strategies

[This is where to talk about RESEARCH DESIGN, like Kate suggested]

Descriptive plots of variables are not sufficient

why gay neighborhoods are different, whether this can be attributed to something about the fact that they are recognized gay spaces.
