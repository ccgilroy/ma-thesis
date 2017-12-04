---
title: |
    | Data and Methods Memo
    | Do gay neighborhoods change differently? How the gayness of neighborhoods might matter for neighborhood change
author: Connor Gilroy
date: 2017-12-01
output:
    pdf_document:
        latex_engine: xelatex
header-includes:
    - \usepackage{indentfirst}
    - \setlength\parindent{0.5cm}
fontsize: 12pt
geometry: margin=1.5in
mainfont: Gentium Basic
monofont: InconsolataGo
---

I want to look at whether the fact that some neighborhoods are culturally and institutionally gay has an impact on the kinds of changes (demographic, economic) those neighborhoods experience over time.

The current theory, or at least the suspicion, among scholars of gay neighborhoods is that, with a heightened influx of straight people, these neighborhoods are changing in a particular way that is detrimental to the neighborhoods' current inhabitants and to their specifically gay character. This could mean those neighborhoods get richer, whiter, straighter, and that previous residents are displaced. As far as I know, studies of this are confined to single cities, and are mostly qualitative. I want to bring a different scale and lens to this problem.

This supposed influx and change is relatively recent, so I think I can look at change over the past 10 or so years---though this risks not picking up on earlier trends (which we can imagine being more significant for more established gay neighborhoods, like the Castro in San Francisco). I am using 5-year ACS data, taking advantage of the fact that only recently have non-overlapping sets of 5-year data become available: 2006-2010 and 2011-2015.

To get the temporal ordering right, I need to identify gay neighborhoods at or before my first time point. I've thought about a couple ways to identify these neighborhoods based on the locations of gay bars, a numerous and visible gay cultural institution. For instance, I have Yelp data from 2017 on 652 gay bars in the 100 largest cities in the US, but that's from *after* all the ACS data. I've also picked up a gay travel guide from 2006 (Damron), but I would need to scan and code it or persuade a professor at Oberlin to share his data.

The best solution I've found so far is to use the Internet Archive's Wayback Machine. I needed a website with extensive information on the location of gay bars in cities in the United States; the best one I found turned out to be gaycities.com. GayCities is a community-sourced gay travel website, founded in 2005 (and relaunched in 2008, but with mostly the same content), with listings of gay bars in various cities. The earliest snapshot of their website on the Wayback Machine is from July 28, 2007. (gaycities.com still exists, though it looks very different from that snapshot! GayCities has evolved into Q.Digital, an LGBTQ online media publisher; they own Queerty, for instance.)

I've scraped city and bar data from this snapshot, including bar addresses, using Python and BeautifulSoup. This gave me a data set of 903 bars in 63 cities; I excluded 62 bars in Canada or Mexico, and send the addresses of the rest to the Census's Geocoding Services API. This successfully gave me the **Census tracts for 787 bars in 57 cities.** I wasn't able to match 53 bars using batch address coding, but I have an alternate plan that should handle most of those.

In Seattle, for instance, most bars are explicitly labeled as being in Capitol Hill:

|tract  |neighborhood     |name                 |description                                          |
|:------|:-----------------|:----------------------|:-------------------------------------|
|007900 |Capitol Hill |C.C. Attle's         |Locals' cruise bar at the edge of Capitol Hill                                                  |
|005100 |Wallingford  |Changes              |Wallingford's neighborhood hangout                                                              |
|008100 |Capitol Hill |Eagle                |Seattle's original leather bar                                                                  |
|008400 |Capitol Hill |Madison Pub          |Traditional pub feel with darts, pool and a great jukebox.                                      |
|008200 |Capitol Hill |ManRay               |Video bar and hip lounge with a stand and model crowd.                                          |
|007500 |Capitol Hill |Martin's Off Madison |Bistro restaurant and piano bar.                                                                |
|007500 |Capitol Hill |Purr Cocktail Lounge |Mexican resturant/bar with music and a Sunday beer bash.                                        |
|008200 |Capitol Hill |R Place              |Multi-level club space with an attractive stand and model crowd.                                |
|007300 |Downtown     |Rebar                |Funky and mixed gay / straight crowd with dancing and performances.                             |
|007402 |Capitol Hill |The Crescent Lounge  |Mostly gay karaoke joint, become more popular with the urban hipster crowd.                     |
|007500 |Capitol Hill |The Cuff Complex     |Masculine men hang out in this complex of a "retro leather" bar, outdoor patio and dance floor. |
|008300 |Capitol Hill |Wildrose             |Seattle's lesbian bar with a great jukebox                                                      |

Two bars are missing here: the Double Header (Downtown) and Neighbours (Capitol Hill) weren't correctly geocoded. But what's encouraging is that if you had to answer the question "where is the gay neighborhood in Seattle?", you could do that from these data. That's equally true for some cities, like Atlanta, Dallas, and Chicago, and less true for others, like Boston.

Overall, the clustering of bars *within* tracts (not considering adjacent tracts) looks like this:  

| number of bars in tract| number of tracts|
|-----------------------:|----------------:|
|                       1|              325|
|                       2|               78|
|                       3|               29|
|                       4|               14|
|                       5|                6|
|                       6|                7|
|                       7|                4|
|                       8|                1|
|                       9|                1|
|                      11|                3|
|                      13|                1|

**I think these data need more cleaning and curation.** For instance, resort towns, like Provincetown, MA, (which is the tract with 13 bars above) should be excluded---I don't expect these to behave like urban neighborhoods at all. Moreover, I don't think a single gay bar makes a gay neighborhood (in other words, Wallingford is not Capitol Hill).

I can see two broad ways of cutting down the tracts I consider to be gay and cities I consider to have gay neighborhoods:

- some logical, quantitative, clustering-based method
- a qualitative, interpretive, literature-based approach where I only include cities that I can document as having a gay neighborhood

Substantively I'm interested in the *visibility* of a neighborhood as gay, in it being a meaningful cultural unit, so I'm inclined toward the latter approach. I'd rather be conservative with what I'm labeling as a gay neighborhood, even at the cost of statistical power. But I'm open to trying a range of approaches.

I think an approach that incorporates prior (qualitative) information has the potential to be more accurate or faithful to reality. For instance, the 2007 gaycities.com description of Portland, OR, begins like this:

> "Although it has no gay district, Portland makes up for that with all that it does have to offer. If you like great art, cool people, good food, shopping and nature, gay Portland will be a satisfying destination. Portland is a laid back big city that's still got that small-town feel to it. And, Portland is a great place for lesbians. ..."

If you just looked at the data for Portland, you might think it had a gay neighborhood, because the bars do appear to be clustered in one area---namely, downtown.

# ACS data

Having (mostly) identified tracts, I've started pulling together data from the ACS (largely using the `tidycensus` R package). I'm interested in three things: clear demographic churn, changes in socioeconomic status, and changes in household types. For example, for most people race and gender are static characteristics---so if the racial or gender composition of a tract changes, that's because the people in it are changing.

For the time being, I'm retrieving data for all tracts in the same *counties* as tracts with gay bars in my data set, making for 22737 non-gay and 469 gay tracts---subject to all the caveats mentioned above.
I'm thinking about the data like this, and will probably model clusters of variables separately:

- demographics
    - % white
    - % male
    - population
- households
    - % married-couple households
    - % male ssc
    - % female ssc
- economics
    - housing
    - income

I show the average values for the tracts in the data below. For most, I see differences between gay and non-gay tracts, but not much average change over time.

|variable                                     | 2006-2010 gay| 2006-2010 non-gay| 2011-2015 gay| 2011-2015 non-gay|
|:--------------------------------------------|-------------:|-----------------:|-------------:|-----------------:|
|prop male                                    |     0.5291302|         0.4881073|     0.5274700|         0.4886362|
|prop white                                   |     0.5396375|         0.4836163|     0.5426431|         0.4625080|
|prop different-sex married-couple households |     0.2425616|         0.4475842|     0.2435348|         0.4358257|
|prop male same-sex couple households         |     0.0166652|         0.0038527|     0.0158610|         0.0031547|
|prop female same-sex couple households       |     0.0052555|         0.0031867|     0.0042349|         0.0025770|

|variable                                | 2006-2010 gay| 2006-2010 non-gay| 2011-2015 gay| 2011-2015 non-gay|
|:---------------------------------------|-------------:|-----------------:|-------------:|-----------------:|
|total population                        |     3600.9360|          4112.175|      3836.633|          4329.863|
|median household income                 |    49005.5491|         59204.079|     55658.118|         61389.491|
|median gross rent                       |      980.6931|          1072.606|      1132.497|          1192.545|
|median value for owner-occupied housing |   352414.3187|        324562.036|    357182.224|        305311.299|
|median monthly housing costs            |     1104.3718|          1278.152|      1206.064|          1284.123|

Yes, that's the average median household income in a tract, etc. I should probably look at the median median household income, etc., next.

The variables that I have are drawn from tables like these:

- Table B01003, total population
- Table B01001, sex by age
- Table B03002, race/ethnicity
- Table B11001, family households
- Table B11009, unmarried partners

as well as various tables on income and rent.

There are other variables that I might want and am not sure how to find (or if I need to calculate them) from the ACS: for instance, population *density* and/or a rural vs urban indicator. I also know there is a question on whether someone's moved in the past year. Do people use that?

I've considered some alternate economic variables (e.g. Gini index, % in poverty). Making sense of the housing variables, in particular, is also tricky. (I expect tracts with gay bars to have high proportions of renters, so I'd focus on rent-related variables.)

*Are there other variables I should know about? Things I should control for in matching or modeling?*

# Modeling dilemmas

## Matching

I don't think it makes sense to compare gay tracts to all other tracts in their counties. I plan to use a matching method to pick out tracts that are similar on observed covariates at the 2006-2010 time point. I've heard that Mahalanobis distance is better than propensity score matching for this, but am open to trying and reading about different matching methods.

## Margins of error, aggregation, and uncertainty

Best practice would seem to be to incorporate the margins of error included with ACS estimates into my models, so as not to overstate the certainty or strength of my results. Doing so would probably necessitate building a Bayesian model, but I think I could do that.

There are a few papers on aggregating contiguous & similar Census tracts. This would result in fewer observations, but reduced noise and uncertainty. I think it'd also map better onto meaningful spatial units (a "neighborhood" in the bars data often covers multiple tracts), so I'm inclined to try it.
