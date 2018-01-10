---
---

# Results

## Clustering and filtering

[show maps - result of clustering AND filtering]

In the maps in Figure [NUMBER], I show the result of the clustering and filtering process described above for two cities, Chicago and Seattle.

[These are the two cities that, based on my own residential history, I am most confident in my ability to interpret.]

![Chicago, suburbs not shown.](../../output/figures/chicago.png)

![Seattle, adjacent downtown bar excluded.](../../output/figures/seattle.png)

overall way to think about things

How well does this work, anyway?

my point is not that these couldn't be contested! they could!

and this is *almost* enough that the margins of error don't overlap on some things! which is good.

talk about types and failures

In some cities with larger gay neighborhoods, qualitatively distinct neighborhoods that are adjacent blur and merge together. Significant examples of this are the Castro, the Mission, and SOMA in San Francisco, West Village and Chelsea in New York, and Dupont Circle, Logan Circle, and Shaw/U Street in Washington, DC. By treating each of these as a single unit, I could be effacing important distinctions. For instance, @hanhardt_safe_2013 and @greene_gay_2014 both take care to characterize the differences between those three DC neighborhoods, which could turn out to matter for the kinds of changes they experience.

I am setting that possibility aside. Perhaps with more detailed on-the-ground knowledge, these clusters could be subdivided more finely, but I do not attempt that here. [FOOTNOTE?] Or perhaps not. For instance, @compton_beyond_2012 discuss the difficulty of drawing a precise boundary between the Castro and the Mission, despite these being well-defined enclaves associated strongly with gay men and lesbians, respectively.

In other cases, what would appear to be a single neighborhood, based on the neighborhood labels associated with the bars in the original data, is fragmented among two or more noncontiguous clusters of tracts. Examples of this fragmentation occur for Capitol Hill in Denver and South Beach in Miami. I do not attempt to unify these fragments; rather, as I describe below [ABOVE?], I choose only the largest cluster to represent the neighborhood as a whole.

Denver + Miami

Austin + Portland?

Dallas + Atlanta

Again, the point is not that *these* boundaries are incontestable.

See [APPENDIX] for more maps

[MOVE PARAGRAPH BELOW TO METHODS?]

For my analyses,
I choose the 24 cities that most clearly have discernible clusters of bars corresponding to known or probable gay neighborhoods. I exclude the other 24 US cities and the nine resort towns. This is done inductively, based both on my interpretation of prior literature and on my inspection of the clusters. I assign three clusters to New York, two to San Francisco and Chicago, and one to all other cities that I include.

[FOOTNOTE] Long Beach, in Los Angeles County, is collapsed together with Los Angeles proper for discussions of context. This nominally gives LA two neighborhoods, as well.

[FOOTNOTE] I plan to implement and evaluate alternative specifications for aggregation and inclusion. To address the concern that my qualitative approach based on consideration of the literature and data is too subjective, I will also employ a filtering approach using only quantitative thresholds for inclusion. For example, I might use the largest cluster for each city. To compare and justify the filtering and aggregation processes as a whole, I will perform baseline analyses using all clusters, regardless of size or relevance, and finally as individual, unclustered tracts. This latter would be the conventional approach in the demographic urban literature (with, perhaps, some allowance for spatial autocorrelation). These are not robustness checks, in the sense that I *do* expect to see differences, but they are an important part of sensitivity analysis. At the moment, I can only claim that my current approach is preferable to these in a qualitative sense.

This gives me 28 clusters ("components") to use as data points in the analyses that I present below. The 488 tracts I begin with fall to 461 once downtowns are excluded. Of these, 146 tracts (29.9% of the original number) remain in the filtered components that I use in my analysis.

I briefly describe the range of clusters, with a full list in [APPENDIX]. I have assigned these descriptive names based on the neighborhood labels and descriptions in the GayCities data and on knowledge from prior literature. The largest gay neighborhood by number of tracts is West Village - Chelsea, New York with 13 tracts, while the largest by number of bars is Castro - Mission - Folsom - SOMA, SF with 33 bars. This shows that the historical prominence accorded to these areas as gay centers persisted---at least institutionally---in 2007. At the other end of the range, the smallest clusters by number of tracts are Northcentral, San Antonio, and Ybor City, Tampa, with one tract each, while the smallest by number of bars is South Beach, Miami, with four bars.

## Descriptive results

[present tables of averages, because they're expected]

This is a typical, but not terribly meaningful, way of presenting these results.

- [present two-way plot of education and rent]
- [present two-way plot of married and white]
- [present plot of demographics relative to cities]

This comes first

![Red lines represent parity.](../../output/figures/demographic_comparison.png)

Do these neighborhoods look like their contexts? No, they do not.

Two way plots:

One without clear trajectories ("demographics")

![](../../output/figures/white_married_2way.png)

"Gay neighborhoods are experiencing an influx of straight, white, married couples." No, not necessarily.

One with clear trajectories ("gentrification")

![](../../output/figures/rent_education_2way.png)

"Gay neighborhoods are experiences changes that look an awful lot like gentrification." Um, yeah.

See [APPENDIX] for select one-way plots of these, as well as median income and male.

I think I have a narrative for these now.

I'm concerned about the (lack of) coherence in the results I have so far. But how clear was I expecting it to be? Also, I ostensibly planned for this.

Story I'd like to be able to tell: starts out as a mess, but then a narrative emerges when we cluster the data sensibly.

Seems clear that part of the problem is I don't know how these neighborhoods are doing relative to their contexts.

PCA: kind of have to decide that variation on different axes is equally important.

Correlation:

Could just look at whether these are different from all other tracts in same city, but then I lose the effect of the aggregation

Talk about building synthetic controls from other census tracts in "conclusions" if I don't get to it. "I plan to..."


Where do these neighborhoods start? Where do they wind up? In absolute terms? and relative to their contexts? and relative to comparable neighborhoods at the beginning?

To confirm, would need to look at


I expect to see economic and demographic changes to go along with {X}

It sounds like emphasizing heterogeneity is going to be important. Even among this, the set of neighborhoods I've chosen to be most clearly

This point holds up looking at one-way plots and at diffs for individual tracts (which I don't want to use, because measurement error)

if the story winds up being: demographics are pretty muddled, but economics show clear trends

that's okay.

Okay, education is pretty coherent, especially with income / rent.

Boystown and Andersonville are both pretty flat on the education front. What does this mean for the criticism we made of Ghaziani two years ago?

Do these neighborhoods systematically differ from their contexts? Yes. They are whiter, more male, more educated, and less married. All of this conforms to our expectations and preconceptions for gay neighborhoods.

What exactly this means varies. Counties are clustered tightly at a little under 50% male; gay neighborhoods range from 50% to 60% male. By contrast, there is much more heterogeneity in how white a county and its corresponding gay neighborhoods are.

## Model results

[put a sad note here about running out of time]

based on the descriptive results for

I expect to find

but not race gender and household type
