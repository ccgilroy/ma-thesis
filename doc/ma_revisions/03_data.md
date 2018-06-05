---
---

# Data and methods

[is this data? or is it methods? should I combine them?]

I proceed by identifying gay neighborhoods, selecting characteristics to examine, and modeling change over time comparatively. I identify gay neighborhoods consistently across a range of cities by using clusters of gay bars. I select seven Census tract features from the American Community Survey at two time points, and use the values of those features at the earlier time period to match tracts within cities. I use linear models with appropriate controls to assess whether gay neighborhoods change differently from other neighborhoods over time.

[NOTE: when do I first say what "recent" means? It's *very* recent, probably *too* recent. But I have plans to fix that later, which I cover in my conclusion.]

## Gay neighborhoods from gay bars

To demarcate gay neighborhoods, I use clusters of gay bars, because concentrations of gay institutions are part of the definition of gay neighborhoods. For this definition, I rely on Levine, who writes that "an urban neighborhood can be termed a 'gay ghetto' if it contains gay institutions in number, a conspicuous and locally dominant gay subculture that is socially isolated from the larger community, and a residential population that is substantially gay" [-@levine_gay_1979]. I use one part of this definition as proxy for the whole in my operationalization. Similarly to Levine, @castells_cultural_1983 compare the locations of gay bars against four other indicators of gay neighborhoods: qualitative reports of gay residence, counts of multiple-male households, votes for a gay electoral candidate, and gay businesses. They find that these measures are generally consistent with each other. In terms of contemporary work, @mattson_style_2014 has documented the centrality of bars to gay cultural and neighborhood life, while @ghaziani_measuring_2014 has called them "anchor institutions" and proposed their use to measure urban sexual cultures. As opposed to other measures, gay bars have the advantage of being widespread and consistently measurable, which enables an analysis spanning multiple cities.

I obtain my list of gay bars from GayCities, a gay travel website. GayCities (www.gaycities.com) was founded in 2005. It relaunched in 2008, and has since grown into Q.Digital, an LGBTQ marketing and media conglomerate. The site solicits crowdsourced opinions, reviews, and information from the LGBTQ community to provide a comprehensive picture of the places it lists. GayCities fulfills a similar role to traditional print gay travel guides and city guides. These guidebooks include the Gayellow Pages [@hayslett_out_2011] and the Damron's guides, which have a 50-year history and have been used in considerable previous research [@levine_gay_1979; @castells_city_1983, 148 Map 14.3; @mattson_counting_2017]. I choose GayCities over these print media source because, as an already-digital source, it is scalable and accessible. I can download bar listings for as many cities as are available, and easily extract the addresses of bars to geocode within Census tracts. For examining change in a recent time period, an internet-based data source has considerable advantages.

**Because I am examining the present outcomes of past gay neighborhoods, my indicator of gay neighborhoods should be historical.** To this end, I use an archived version of GayCities from 2007 to obtain bar listings, instead of the present version of the website. The Internet Archive, a non-profit organization, automatically crawls and archives the internet, which is useful to social scientists for historical research [@gade_.gov_2017]. I use their Wayback Machine tool, which provides snapshots of websites such as GayCities. The earliest relatively complete snapshot of GayCities is from July 28, 2007. I retrieve bar information from this archived version of GayCities through web scraping, the automated retrieval of unstructured data from the Internet [@boeing_new_2017]. Because GayCities' robots.txt is permissive of scraping and GayCities' terms prohibit only commercial use of their data, retrieving bar names and addresses in this way is justified.

In 2007, GayCities lists 902 bars across 63 cities. Of these, 840 bars are located in the US, with the remainder in Canada and Mexico. I exclude the six Canadian cities from consideration, and also choose to exclude nine locations that I classify as LGBTQ resort towns. These are places such as Provincetown and Fire Island. The remaining 48 US cities are candidates for my analysis. The number of bars per city ranges from 62 in New York City to 3 in Hartford, CT. (See Appendix A for a complete listing of cities.) Each GayCities web page also includes informative city-level and bar-level descriptions, which I inspect as context for my analyses.

[THIS MIGHT BE A SPOT TO TALK ABOUT GEOCODING, because that's how I go from bars to tracts to neighborhoods. In that case, cut the descriptors]

**In connecting gay bars to gay neighborhoods, I am not concerned about selectivity in the GayCities listings.** Any archival source is bound to be selective. But gay city guides have the appropriate incentives and the requisite cultural knowledge to document concentrations of gay institutions, gay culture, and gay people. Gay neighborhoods must be visibly gay; a neighborhood that was not known as gay could not have been subject to processes of assimilation and gentrification affecting gay neighborhoods specifically. Finally, while individual bars may open and close, clusters of bars do not spring up overnight.

**In each city that I choose to include, I designate the largest cluster or clusters of gay bars as gay neighborhoods.** Because they are large cities that have played outsized roles in LGBTQ urban history, I include the two largest neighborhoods in San Francisco and Chicago, and three in New York [@mattson_style_2014; @hanhardt_safe_2013; @ghaziani_there_2014]. I rank the other cities based on the size of their largest cluster, and determine 21 to have gay neighborhoods, though I subsequently treat Long Beach, California, as if it were part of Los Angeles because they are both within the same county. I include some more peripheral cities based on their occurrence in prior research, such as New Orleans [@knopp_theoretical_1990], Columbus [@hayslett_out_2011], and San Antonio [@xstone_where_2017]. In total, this gives me 28 gay neighborhoods. I combine neighborhood labels and descriptions from the GayCities data with information from the literature to assign descriptive names to each of them, which I list in Appendix A.

**I exclude the other half of the 48 available cities in the GayCities data entirely, because I cannot be sure that they have gay neighborhoods at all.** The largest city excluded in this way was Phoenix, Arizona. I examine the spatial distribution of bars in all cities visually, and use city descriptions from GayCities, prior qualitative research, and media accounts as supplemental information in making these choices. For instance, the GayCities description for Seattle notes that "Gay Seattle is primarily centered around Capitol Hill, a quaint, friendly neighborhood..." By contrast, the description of Portland, OR, begins by stating that "Although it has no gay district, Portland makes up for that with all that it does have to offer."

**Not all clusters of gay bars are gay neighborhoods, so I use other aspects of Levine's definition to refine the filtering of my neighborhoods.** Because gay neighborhoods should contain gay residential concentration as well as institutions, I filter out warehouse districts in cities like Portland, Austin, and Minneapolis. Because gay neighborhoods are areas where LGBTQ people exert cultural dominance or "set the tone" [@ghaziani_there_2014; @chauncey_gay_1994], I exclude downtown or center city areas. This means that I filter out downtown bars in cities like Columbus and Seattle, even when adjacent to gay neighborhoods.



**Digital data enable analysis at scale.**

this is *why* I can do more than five cities.

; I did not have to choose in advance which cities to digitize---I had 48 to examine.

The most significant city with a documented gay neighborhood that was absent from these data was Oklahoma City.

 [because it looks like a damn checkerboard]

**something about geolocation**

**I merge adjacent tracts in the final analysis for substantive and methodological reasons.**

Census tracts are not neighborhoods

This bar-based approach to gay neighborhoods has several implications that shape my findings.

First,  

**yes to lesbians, no to rural areas, core not periphery**

First, core over periphery

in that regard, it differs from approaches focused on queering space

expect bias toward gay men over lesbians, but not excluding lesbians

Lesbian bars such as the Lexington in San Francisco and the Wildrose in Seattle

## Neighborhood change and comparisons

**why not same-sex couple households?** the error rates are too damn high. cannot compare change over time.

**matched tracts are not contiguous**, unlike gay neighborhood tracts

## Modeling change over time

two approaches: matching, and multilevel modeling
