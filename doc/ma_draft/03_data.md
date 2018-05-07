---
---

# Data

In this section, I describe the two data sources on which I rely, and the process of their acquisition. In the subsequent methods section, I develop mechanisms to link the two, and to designate neighborhoods using groups of bars.

## Bars: GayCities

To use gay bars as an indicator or proxy for the locations of gay neighborhoods across multiple cities, I need a consistent source for the locations of gay bars. This source should be from *before* the point in time at which I am measuring the outcomes of potential change.

For gay bars, gay travel guides and city guides are a data source with ample precedent. Damron's travel guides, the most prominent, have a more than 50-year history [@mattson_counting_2017]. They have been used in both classic [@levine_gay_1979; @castells_city_1983, 148 Map 14.3] and contemporary [@mattson_counting_2017] work. In a similar vein, @hayslett_out_2011 use a 2000 guide called the Gayellow Pages to locate gay bars in their quantitative analysis of Columbus, OH.

While I have investigated these print sources, I choose instead to use an online gay city and travel guide, GayCities. Though it follows the precedent established above, to my knowledge this is a novel data source. As a digital data source, it has the advantages of being scalable and accessible, traits which are crucial for a quantitative analysis covering dozens of cities. Moreover, because I am interested in a relatively contemporary time period, using an Internet resource is both feasible and logical. To be thorough, I have also considered other online sources, going so far as to collect data from Yelp using their "gay bars" category in 2017. These data are not available historically, only in real time, rendering them less suitable than GayCities for this purpose.

Of course, any archival source is bound to be selective. I believe the impact of these kinds of biases on my project is mitigated due to the project's emphasis on precisely on those spaces that are public and visible, and that are more on the core than the periphery. If a neighborhood goes wholly unmarked in gay resources, it is---in some sense by definition---neither visible nor well-known. I am therefore less concerned that using a bar-based index will cause me to miss neighborhoods that are "really" gay. The converse error, classifying a neighborhood as a gay neighborhood when it is not, is of greater concern to me, but I discuss the steps I take to mitigate that error later.

Moreover, because I ultimately aim to locate neighborhoods, not bars, I do not need the listings of individual bars to be entirely complete or totally accurate. Rather, as I explain below in the methods section, I only need groups or clusters of bars to be accurate. In terms of face validity, I find that prospect to be more likely and believable. While it would be possible to digitize a print source like the Damron guides for comparison and validation, I do not believe this to be critical.

*About GayCities*. GayCities (www.gaycities.com) was founded in 2005, and relaunched in 2008. Their About page in 2007 describes them as a "gay city guide site with the power of the community as its driving force." In other words, they solicit crowdsourced opinions, reviews, and information from the LGBTQ community to provide a more complete picture of the places that they list. GayCities has expanded over time, most significantly by purchasing the blog Queerty in 2011.[^queerty] After acquiring Queerty, they grew into q.digital, an LGBTQ marketing and media conglomerate (and, by their claim, one of the largest).[^q.digital] In other words, they have persisted since their founding more than a decade ago, and they have evolved into a prominent media source within the LGBTQ community. This trajectory increases my confidence that GayCities, even in the past, would have had the resources and community knowledge to constitute a reliable data source.

[^queerty]: https://www.queerty.com/gaycities-welcomes-you-to-the-new-queerty-20110505

[^q.digital]: http://q.digital/q-digital-launches-to-become-the-largest-global-lgbtq-online-media-publisher/

*Historical data*. I do not draw my data from the present-day edition of the GayCities website. Instead, I use the listings of bars as they existed on a past version of the site. I obtain this historical data from the Internet Archive's Wayback Machine. The Internet Archive is a non-profit organization dedicated to archiving the web.[^archive] Their repositories have served as a resource for other types of social science research [@gade_.gov_2017]. From the Wayback Machine, I use the earliest relatively complete record of the site www.gaycities.com, dated July 28, 2007. This date precedes the point in time at which I measure my outcomes, as discussed below.

[^archive]: https://archive.org/about/

*Web scraping*. These data were acquired through web scraping, the automated retrieval of unstructured data from the Internet [@boeing_new_2017]. I wrote a Python script to download the relevant web pages and used the `beautiful soup` module to extract bar listings and other data from the pages. While the popularity of web scraping as a computational data-gathering technique has receded with the proliferation of APIs, I believe it is a useful and justifiable tool for this project. Among my reasons for this are that the Wayback Machine itself collects URLs for archiving via web scraping or crawling; Gaycities' robots.txt is permissive and GayCities' terms prohibit only commercial use of their data.

*Description of the data set*. In all, there are 902 bar listings in the GayCities 2007 data set, of which 840 are located in the US, with the remainder in Canada and Mexico. 63 cities are included, of which six are Canadian and nine are what I classify as LGBTQ resort towns (for instance, Provincetown and Fire Island).[^provincetown] The remaining 48 US cities are candidates for my analysis. The number of bars per city ranges from 62 in New York City to 3 in Hartford, CT. See Appendix A for a complete listing of cities.

Each GayCities web page includes informative city-level and bar-level descriptions. The city-level descriptions often refer explicitly to a marked gay neighborhood, or to the absence of one, while the bars themselves are (sometimes) labeled as being within particular neighborhoods. For instance, the page for Seattle notes that "Gay Seattle is primarily centered around Capitol Hill, a quaint, friendly neighborhood...", while the description of Portland, OR, begins by stating that "Although it has no gay district, Portland makes up for that with all that it does have to offer." Qualitative inspection of these descriptions provides important context for my quantitative analyses.

The most significant limitation of the GayCities 2007 data set would seem to be the number of cities.[^cities] However, I observe qualitatively that the largest city to be excluded for which I can document the existence of a gay neighborhood is Oklahoma City. Moreover, the cities that a gay website chooses to include on launch would logically be more likely to have gay neighborhoods, if anything. On this basis, I contend that the set of cities available through these data are reasonable. Moreover, in my analysis I will actually remove cities that I consider to be marginal cases.

[^cities]: They have since expanded. At present in 2018 GayCities covers 229 cities worldwide. This number includes 215 in North America, and 187 in the US alone, so the site remains US-centric.

[^provincetown]: It is possible to study community change in small towns along with neighborhoods in large cities. Provincetown, in particular, has been studied alongside Andersonville [@brown-saracino_neighborhood_2010]. My framing, however, is concerned with urban neighborhoods. Moreover, my focus on the population characteristics of these spaces makes including non-urban tracts with extensive seasonal migration perilous. These tracts are, however, included in the summaries of Table 1 for completeness.

## Variables: the American Community Survey

To assess the structural contexts of gay neighborhoods and how they might be changing, I use counts and proportions of various demographic and economic characteristics. These measures are ecological, i.e., associated with spatial units and contexts rather than individuals. These economic and demographic variables, as well as the geographies of the Census tracts to which they pertain, come from the United States Census Bureau's American Community Survey (ACS).

ACS estimates are available in 1-year, 3-year, and 5-year data sets, at differing geographic resolutions. I use the 5-year ACS, because for this analysis I need tract-level data only available at this temporal resolution. Looking at combined data from a five-year period, however, could obscure the distinctness of trends. This is a necessary tradeoff between spatial and temporal resolution.

Because the ACS has been performed every year since 2006, with data from these years publicly available, I can obtain data for two non-overlapping five year periods, 2006-2010 and 2011-2015.[^acs] This positions me to use the ACS to assess change over time on a variety of characteristics in a recent time frame. The ACS has the significant advantages of being regular, frequent, and recent.

[^acs]: As of December 2017, these data are available through 2016.

However, the fact that the ACS is a survey and not a complete count comes with limitations.[^decennial] As a survey, it has relatively large margins of error, particularly for small areas like Census tracts [@spielman_studying_2015]. Because this problem of error is more acute for small counts than large counts, it influences the variables I choose, described in the Methods section below.

The most salient limitation this creates is on the use of same-sex couples data. Even in tracts with relatively large numbers of same-sex couple households, they remain only a small proportion of the population. Due to the disparity in group sizes, small random errors in different-sex couples recording the genders of spouses or partners result in a large inflation in counts of same-sex couples [@oconnell_same-sex_2011]. To attempt to mitigate this problem, the Census Bureau improved its form design and made changes to its coding practices, resulting in a decreased error rate, between 2007 and 2008.[^2007] A consequence of this change is that it is not meaningful to compare counts of same-sex couples between the 2006-2010 5-year data and the 2011-2015 5-year data.[^2015] Therefore, I do not make this comparison.

[^decennial]: In subsequent analyses, I plan to incorporate 2000 and 2010 decennial Census data. Tract geographies change between 2000 and 2010.

[^2007]: https://www2.census.gov/topics/families/same-sex-couples/guidance/changes-to-acs-2007-to-2008.pdf

[^2015]: https://www.census.gov/programs-surveys/acs/guidance/comparing-acs-data/2015/5-year-comparison.html

I use the `tidycensus` R package to retrieve ACS data for all tracts in all counties containing gay bars.
