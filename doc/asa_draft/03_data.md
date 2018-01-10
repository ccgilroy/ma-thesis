---
---

# Data

In this section, I describe the two data sources on which I rely, and the process of their acquisition. In the subsequent methods section, I develop mechanisms to link the two, and to designate neighborhoods from groups of bars.

## Bars: GayCities

To use gay bars as an indicator or proxy for the locations of gay neighborhoods across multiple cities, I need a consistent source for the locations of gay bars. This source should be from *before* the point in time at which I am measuring the outcomes of potential change.

Gay travel guides and city guides are a data source with ample precedent.

Damron's travel guides [CITE Levine, CITE Mattson], the most prominent, have a more than 50-year history. They have been used in both classic [@levine_gay_1979; @castells_city_1983, 148 Map 14.3] and contemporary [@mattson_counting_2017] work.

@castells_city_1983 [358] refers to a list of "specialized publications" as a source for gay bar locations in San Francisco, including the Advocate, among others. @hayslett_out_2011 use a 2000 guide called the Gayellow Pages to locate gay bars in their quantitative analysis of Columbus, OH.

Of course, any archival source is bound to be selective.

I believe the impact of these kinds of biases [errors] on my project are mitigated by the fact that it is focused precisely on those spaces that are public and visible, that are more on the core than the periphery.

explain GayCities

allows users to contribute crowdsourced information about places

which has the advantages of being novel, scalable, and accessible

[i.e., already digitized]

because I am interested in a relatively contemporary time period, using an Internet resource is both feasible and logical

To my knowledge, this is a novel data source, but the idea is not without precedent.

[I have also considered other online sources. I collected Yelp data using their "gay bars" category, but only for 2017. These data are not available historically, only currently, rendering them less suitable for this purpose.]

[As I discuss below in the methods section. *could* validate, but it doesn't really matter, which I'll explain when I get to the clustering bit. I don't need individual bar listings to be accurate---I just need clusters of them to be accurate! That's more likely/believable.]

*About GayCities*.

GayCities (www.gaycities.com) was founded in 2005, and relaunched in 2008. Their About page in 2007 describes them as a "gay city guide site with the power of the community as its driving force." In other words, they solicit crowdsourced opinions, reviews, and information from the LGBTQ community to provide a more complete picture of the places that they list. [SAY SOMETHING about crowdsourcing and reliability.]

GayCities has expanded over time, most significantly by purchasing the blog Queerty in 2011. After acquiring Queerty, they grew into q.digital, an LGBTQ marketing and media conglomerate (and, by their claim, one of the largest). [LINK]

In other words, they have persisted since their founding more than a decade ago, and they have evolved into a prominent media source within the LGBTQ community.

[Informally, this fact was surprising to me.]

*Historical data*. I obtain historical data from the Internet Archive's Wayback Machine [CITE]. The Internet Archive is a non-profit organization dedicated to archiving the web.[LINK]


I use the earliest relatively complete record of the site www.gaycities.com, from July 28, 2007. This date precedes the point in time at which I measure my outcomes, as discussed below.

[LINK] https://archive.org/about/

*Web scraping*. These data were acquired through web scraping [DEFINE]. I wrote a Python script to download the relevant web pages and used the `beautifulsoup` module [CITE] to extract bar listings and other data from the pages.

While the popularity of web scraping as a computational data-gathering technique has receded with the proliferation of APIs, and there are increasingly concerns about its permissibility, I believe it is a justifiable tool for this project. The Wayback Machine itself collects URLs for archiving via web scraping or crawling; Gaycities' robots.txt is permissive and GayCities' terms prohibit only commercial use of their data.

*Description of the data set*.

In all, there are 902 bar listings in the GayCities 2007 data set, of which 840 are located in the US, with the remainder in Canada and Mexico. 63 cities are included, of which six are Canadian and nine are what I classify as LGBTQ resort towns (for instance, Provincetown and Fire Island).[FOOTNOTE] The remaining 48 US cities are candidates for my analysis. The number of bars per city ranges from 62 in New York City to 3 in Hartford, CT. See [Appendix] for a complete listing of cities.

Each GayCities web page includes informative city-level and bar-level descriptions. The city-level descriptions often refer explicitly to a marked gay neighborhood, or to the absence of one, while the bars themselves are (sometimes) labeled as being within particular neighborhoods. For instance, the page for Seattle notes that "Gay Seattle is primarily centered around Capitol Hill, a quaint, friendly neighborhood...", while the description of Portland, OR, begins by stating that "Although it has no gay district, Portland makes up for that with all that it does have to offer." Qualitative inspection of these descriptions provides important context for my quantitative analyses.

The most significant limitation of the GayCities 2007 data set would seem to be the number of cities. However, I observe qualitatively that the largest city to be excluded for which I can document the existence of a gay neighborhood is Oklahoma City. Moreover, the cities that a gay website chooses to include on launch would logically be more likely to have gay neighborhoods, if anything. On this basis, I contend that the set of cities available through these data are reasonable. Moreover, in my analysis I will actually remove cities that I consider to be marginal cases.

[They have since expanded. At present in 2018 GayCities covers 229 cities worldwide. This number includes 215 in North America, and 187 in the US alone, so the site remains US-centric.]

[FOOTNOTE] It is possible to study community change in small towns along with neighborhoods in large cities. Provincetown, in particular, has been studied alongside Andersonville [@brown-saracino_neighborhood_2010]. My framing, however, is concerned with urban neighborhoods. Moreover, my focus on the population characteristics of these spaces makes including non-urban tracts with extensive seasonal migration perilous. These tracts are, however, included in the summaries of Table 1 for completeness.

## Variables: the American Community Survey

[who am I talking to with this?]

To assess the structural contexts of gay neighborhoods and how they might be changing, I use counts and proportions of various demographic and economic characteristics [for spatial units].

These economic and demographic variables, as well as the geographies of the Census tracts to which they pertain, come from the American Community Survey (ACS).

ACS estimates are available in 1-year, 3-year, and 5-year data sets, at differing geographic resolutions. I use the 5-year ACS, because for this analysis I need tract-level data only available at this temporal resolution. Looking at combined data from a five-year period, however, could obscure the distinctness of trends. This is a necessary tradeoff between spatial and temporal resolution.

Because the ACS has been performed every year since 2006, with data publicly available, I can obtain data for two non-overlapping five year periods, 2006-2010 and 2011-2015.

This positions me to use the ACS to assess change over time on a variety of characteristics in a recent time frame.

[FOOTNOTE] as of December 2017, through 2016

The fact that the ACS is a survey and not a complete count comes with limitations. The most salient limitation is on the use of same-sex couples data.

Moreover, the Census Bureau improved its form design and made changes to its coding practices, resulting in a decreased error rate, between 2007 and 2008 [CITE]. What this means is that it is not justifiable or meaningful (or possible) to compare counts of same-sex couples between the 2006-2010 5-year data and the 2011-2015 5-year data [LINK].

Explain why same-sex couples is bad idea.

Talk about decennial Census, maybe use later. [FOOTNOTE] In subsequent analyses, I plan to incorporate 2000 and 2010 decennial Census data.

regular and recent; disadvantage of being a survey, with a margin of error

[footnote: better account for margin of error]

I use the `tidycensus` R package to retrieve ACS data for all tracts in all counties containing gay bars [CITE].
