---
---

# Results

## Clustering and filtering

[Or, how well does this work, anyway?]

In the maps in Figure [NUMBER], I show the results of the clustering and filtering process described above for two cities, Chicago and Seattle. These are the two cities that, based on my own residential history, I am most confident in my ability to interpret. They also exemplify what I would consider clear and interpretable clusters.

![Chicago, suburbs not shown.](../../output/figures/chicago.png)

![Seattle, adjacent downtown bar excluded.](../../output/figures/seattle.png)

In Chicago, Boystown, with eight tracts and 18 bars, can be seen on the North Side by Lake Michigan. Andersonville lies further north, with four tracts and seven bars. These two gay neighborhoods, and their interrelated dynamics, are the focus of @ghaziani_there_2014, and it validates my method that it recovers them.

In Seattle, Capitol Hill covers four tracts and 11 bars, centered around the Pike-Pine corridor [@atkins_gay_2011]. Like Boystown, Capitol Hill is a prominent example of a gay neighborhood, one that would be expected to appear in the results of an approach like this. While successful, this case also illustrates some of the challenges of a bar-based approach and the constraints of Census tract boundaries, which do not have to map onto local knowledge. In the case of Seattle, the more residential areas of Capitol Hill to the north of Pike-Pine are not included in what I am labeling Seattle's gay neighborhood. Meanwhile, pieces of the First Hill and Central District neighborhoods to the south and east are included.

Recall that the boundaries being imposed are an artificial construct driven by the needs of quantitative analysis, and that the true boundaries could be fuzzy or sharp on the ground.

[DOES THIS PARAGRAPH GO AFTER THE OTHER TYPES OF CITIES?]

In these cases, my method identifies a recognizable cultural object, centered in a gay culture area with gay institutions. This is the important thing. The overall way to judge the success of my approach for each city is how well it accomplishes this goal. My point is not that the boundaries I have drawn are incontestable. In fact, I think for any case additional qualitative knowledge will have constructive critiques to offer. (The challenge, and eventual goal, is figuring out how to incorporate that knowledge!) What matters is that a bar-based approach produces a good first-order approximation of the locations of gay neighborhoods. It is clearer, even, than using the continuous measure of prevalences of same-sex couples, which requires arbitrary cutoffs [@gates_gay_2004; @brown_places_2006]. This pragmatic choice enables an analysis of gay spaces rather than gay populations.

[In other words, it's way better than anything else we've got!]

[and this is *almost* enough that the margins of error don't overlap on some things! which is good.]

[I am certain that readers more knowledgeable than I will find flaws. I want to discuss them explicitly.]

To further illustrate the strengths and shortcomings of my approach, I discuss two [???] additional types of clusters emerging from my method. In each set of cases, it identifies gay neighborhoods in a way that is useful but perhaps not entirely satisfying. What I offer is pragmatism, not perfection.

In some cities with larger gay neighborhoods, qualitatively distinct neighborhoods that are adjacent blur and merge together. Significant examples of this are the Castro, the Mission, and SOMA in San Francisco, West Village and Chelsea in New York, Rittenhouse Square and Washington Square West in Philadelphia, and Dupont Circle, Logan Circle, and Shaw/U Street in Washington, DC. By treating each of these as a single unit, I could be effacing important distinctions. For instance, @hanhardt_safe_2013 and @greene_gay_2014 both take care to characterize the differences between those three DC neighborhoods, which could turn out to matter for the kinds of changes they experience.

I am setting that possibility aside. Perhaps with more detailed on-the-ground knowledge, these clusters could be subdivided more finely, but I do not attempt that here. [FOOTNOTE?] Or perhaps not. For instance, @compton_beyond_2012 discuss the difficulty of drawing a precise boundary between the Castro and the Mission, despite these being well-defined enclaves associated strongly with gay men and lesbians, respectively.

In other cases, what would appear to be a single neighborhood, based on the neighborhood labels associated with the bars in the original GayCities data, is fragmented among two or more noncontiguous clusters of tracts. Examples of this fragmentation occur for Capitol Hill in Denver and South Beach in Miami. I do not attempt to unify these fragments; rather, as I describe below [ABOVE?], I choose only the largest cluster to represent the neighborhood as a whole.

[Austin + Portland? Dallas + Atlanta? Do I need to talk about these examples, or are the above sufficient? What to do with Loring Park in Minneapolis, with only a single gay bar?]

See [APPENDIX] for maps of these cases.

[MOVE PARAGRAPH BELOW TO METHODS?]

For my analyses,
I choose the 24 cities that most clearly have discernible clusters of bars corresponding to known or probable gay neighborhoods. I exclude the other 24 US cities and the nine resort towns. This is done inductively, based both on my interpretation of prior literature and on my inspection of the clusters. I assign three clusters to New York, two to San Francisco and Chicago, and one to all other cities that I include.

[FOOTNOTE] Long Beach, in Los Angeles County, is collapsed together with Los Angeles proper for discussions of context. This nominally gives LA two neighborhoods, as well.

[FOOTNOTE] I plan to implement and evaluate alternative specifications for aggregation and inclusion. To address the concern that my qualitative approach based on consideration of the literature and data is too subjective, I will also employ a filtering approach using only quantitative thresholds for inclusion. For example, I might use the largest cluster for each city. To compare and justify the filtering and aggregation processes as a whole, I will perform baseline analyses using all clusters, regardless of size or relevance, and finally as individual, unclustered tracts. This latter would be the conventional approach in the demographic urban literature (with, perhaps, some allowance for spatial autocorrelation). These are not robustness checks, in the sense that I *do* expect to see differences, but they are an important part of sensitivity analysis. At the moment, I can only claim that my current approach is preferable to these in a qualitative sense.

This gives me 28 clusters ("components") to use as data points in the analyses that I present below. The 488 tracts I begin with fall to 461 once downtowns are excluded. Of these, 146 tracts (29.9% of the original number) remain in the filtered components that I use in my analysis.

I briefly describe the range of clusters, with a full list in [APPENDIX]. I have assigned these descriptive names based on the neighborhood labels and descriptions in the GayCities data and on knowledge from prior literature. The largest gay neighborhood by number of tracts is West Village - Chelsea, New York with 13 tracts, while the largest by number of bars is Castro - Mission - Folsom - SOMA, SF with 33 bars. This shows that the historical prominence accorded to these areas as gay centers persisted---at least institutionally---in 2007. At the other end of the range, the smallest clusters by number of tracts are Northcentral, San Antonio, and Ybor City, Tampa, with one tract each, while the smallest by number of bars is South Beach, Miami, with four bars.

## Descriptive results

In Table [NUMBER], I present 

[present tables of averages, because they're expected]

This is a typical, but not terribly meaningful, way of presenting these results.

- [present two-way plot of education and rent]
- [present two-way plot of married and white]
- [present plot of demographics relative to cities]

Averages do not tell the whole story. What is more informative is to look at each neighborhood relative to its context. This is what I show in Figure [NUMBER] for the four demographic characteristics, plotting neighborhood-level characteristics against those same characteristics at the county level.

[FOOTNOTE] I have not yet obtained county-level data for median income or median rent, but plan to do so. These cannot be calculated directly from tract-level data.

![Red lines represent parity.](../../output/figures/demographic_comparison.png)

Do these neighborhoods look like their contexts? No, they do not.

These gay neighborhoods systematically differ from their contexts. They are whiter, more male, more educated, and less married. All of this conforms to our expectations and preconceptions for gay neighborhoods.

What exactly this means varies. Counties are clustered tightly at a little under 50% male; gay neighborhoods range from 50% to 60% male. By contrast, there is much more heterogeneity in how white a county and its corresponding gay neighborhoods are.

From Figure [NUMBER] above, we also begin to see what change in these neighborhoods looks like.

Two way plots:

One without clear trajectories ("demographics")

Here both axes are neighborhood-level characteristics.

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



## Model results

[put a sad note here about running out of time]

based on the descriptive results for

I expect to find

but not race gender and household type
