---
---

# Data

In this section, I describe the two data sources on which I rely, and the process of their acquisition. In the subsequent methods section, I develop mechanisms to link the two, and to designate neighborhoods from groups of bars.

## Bars: GayCities

To use gay bars as an indicator or proxy for the locations of gay neighborhoods across multiple cities, I need a consistent source for the locations of gay bars. This source should be from *before* the point in time at which I am measuring the outcomes of potential change.


Gay travel guides

Damron's travel guides [CITE Levine, CITE Mattson], the most prominent, have a 50-year history.

Castells used ???. @hayslett_out_2011 use a 2000 guide called the Gayellow Pages to locate gay bars in their quantitative analysis of Columbus, OH.

explain GayCities

allows users to contribute crowdsourced information about places

To my knowledge, this is a novel data source, but the idea is not without precedent.

[I have also considered and collected Yelp data using their "gay bars" category, but only for 2017. These data are not available historically, only currently, rendering them unsuitable.]

[As I discuss below in the methods section. *could* validate, but it doesn't really matter, which I'll explain when I get to the clustering bit. I don't need individual bar listings to be accurate---I just need clusters of them to be accurate! That's more likely/believable.]

*About GayCities*.

GayCities (www.gaycities.com) was founded in 2005, and relaunched in 2008.

GayCities bought Queerty in 2011. After acquiring Queerty, they grew into q.digital, an LGBTQ marketing and media conglomerate (and, by their claim, one of the largest).

In other words, they have persisted since their founding more than a decade ago, and they constitute a prominent source

*Historical data*. I obtain historical data from the Internet Archive's Wayback Machine [CITE]. I use the earliest complete record of the site, from July 28, 2007.

*Web scraping*. These data were acquired through web scraping using Python and extracted from the web pages of bar listings using the `beautifulsoup` module [CITE]. GayCities' terms prohibit only commercial use of their data. The Wayback Machine itself collects URLs for archiving via web scraping.


*Description of the data set*.

In all, there are 902 bar listings, of which 840 are located in the US, with the remainder in Canada and Mexico.

63 cities are included, of which six are Canadian and nine are what I classify as LGBTQ resort towns (for instance, Provincetown and Fire Island).[FOOTNOTE] The remaining 48 US cities are candidates for my analysis. The number of bars per city ranges from 62 in New York City to 3 in Hartford, CT. See [Appendix] for a complete listing of cities.

Each GayCities web page includes informative city-level and bar-level descriptions. The city-level descriptions often refer explicitly to a marked gay neighborhood, or to the absence of one, while the bars themselves are (sometimes) labeled as being within particular neighborhoods

The most significant limitation would seem to be the number of cities; however, I observe qualitatively that the largest city to be excluded for which I can document the existence of a gay neighborhood is Oklahoma City. I contend that the set of cities available through these data are reasonable; in my analysis I will actually remove cities that I consider to be marginal cases.

[The cities that a gay website chooses to include on launch would logically be more likely to have gay neighborhoods, if anything.]

[at present they have 187 US cities, 215 in North America, and 229 worldwide]

[FOOTNOTE] It is possible to study community change in small towns along with neighborhoods in large cities. Provincetown, in particular, has been studied alongside Andersonville [CITE Japonica]. My framing, however, is concerned with urban neighborhoods. Moreover, my focus on population characteristics makes including non-urban tracts with extensive seasonal migration perilous.

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

`tidycensus` [CITE]
