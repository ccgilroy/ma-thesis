---
---

mechanism to link the two, and to designate neighborhoods from clusters of bars.

# Bars: GayCities

explain GayCities

To my knowledge, this is a novel data source, but the idea is not without precedent.



[As I discuss below in the methods section. *could* validate, but it doesn't really matter, which I'll explain when I get to the clustering bit. I don't need individual bar listings to be accurate---I just need clusters of them to be accurate! That's more likely]

www.gaycities.com

GayCities was founded in 2005, relaunched in 2008.

GayCities bought Queerty in 2011. After acquiring Queerty, they grew into q.digital, an LGBTQ marketing and media conglomerate (and, by their claim, one of the largest).

In other words, they're still around, and they constitute a prominent source

*Web scraping*. These data were acquired through web scraping using Python and extracted from the web pages of bar listings using the `beautifulsoup` module [CITE].

I obtain historical data from the Internet Archive's Wayback Machine [CITE].

Their terms prohibit only commercial use.

The Wayback Machine itself collects URLs for archiving via web scraping.

most significant limitation is the number of cities; however,

I use the earliest complete record of the site, from July 28, 2007.

[qualitatively, the largest city to be excluded for which I can document the existence of a gay neighborhood is Oklahoma City.]

In all, there are 902 bar listings, of which 840 are located in the US, with the remainder in Canada and Mexico.

bars per city ranging from 62 in New York City to 3 in Hartford, CT.

63 cities are included, of six are Canadian and nine are what I classify as LGBTQ resort towns (for instance, Provincetown and Fire Island).[FOOTNOTE] The remaining 48 US cities are candidates for my analysis.

Includes informative city-level and bar-level descriptions;

the city-level descriptions

the bars themselves are (sometimes) labeled as being within particular neighborhoods.

See [Appendix] for a complete listing.

[FOOTNOTE] It is possible to study community change in small towns along with neighborhoods in large cities. Provincetown, in particular, has been studied alongside Andersonville [CITE Japonica]. My framing, however, is concerned with urban neighborhoods. Moreover, my focus on population characteristics makes including non-urban tracts with extensive seasonal migration perilous.

# Variables: the ACS

economic and demographic variables,

as well as the geographies of the census tracts themselves, come from the American Community Survey.

5-year ACS. Tradeoff between spatial and temporal resolution. I need tract-level data.

Looking at combined data from a five-year period, however, could obscure the distinctness of trends.

The most salient limitation is on the use of same-sex couples data.

The Census improved

What this means is that it is not justifiable or meaningful (or possible) to compare counts of same-sex couples between the 2006-2010 5-year data and the 2011-2015 5-year data.

Explain why same-sex couples is bad idea.

Talk about decennial Census, maybe use later. [FOOTNOTE] In subsequent analyses, I plan to incorporate 2000 and 2010 decennial Census data.

regular and recent; disadvantage of being a survey

[footnote: better account for margin of error]

`tidycensus` [CITE]
