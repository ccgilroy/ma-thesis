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

In 2007, GayCities lists 902 bars across 63 cities. Of these, 840 bars are located in the US, with the remainder in Canada and Mexico. I exclude the six Canadian cities from consideration, and also choose to exclude nine locations that I classify as LGBTQ resort towns. These are places such as Provincetown and Fire Island. The remaining 48 US cities are candidates for my analysis. The number of bars per city ranges from 62 in New York City to 3 in Hartford, CT. (See Appendix A for a complete listing of cities.) Each GayCities web page includes informative city-level and bar-level descriptions. [, which I inspect as context for my analyses]

The city-level descriptions often refer explicitly to a marked gay neighborhood, or to the absence of one, while the bars themselves are sometimes explicitly labeled as part of particular neighborhoods. For instance, the page for Seattle notes that "Gay Seattle is primarily centered around Capitol Hill, a quaint, friendly neighborhood..." By contrast, the description of Portland, OR, begins by stating that "Although it has no gay district, Portland makes up for that with all that it does have to offer." Qualitative inspection of these descriptions provides important context for my quantitative analyses.

[do these descriptors go here?!? or later?!?]

**In connecting gay bars to gay neighborhoods, I am not concerned about selectivity in the GayCities listings.** Any archival source is bound to be selective.

an invisible gay neighborhood is not a gay neighborhood

their heuristic is what I want; they have the same incentive to document concentrations of gay institutions, gay culture, and gay people.

**Not all clusters of gay bars are gay neighborhoods, so I use other aspects of the definition to further filter my neighborhoods.**

*residential concentration* -> filter out warehouse districts (e.g. Portland, Austin, Minneapolis)

*set the tone, cultural dominance* -> filter out downtowns, in cities like Columbus, Seattle



Single bars may open and close, but clusters of bars do not spring up overnight.

**Digital data enable analysis at scale.**

this is *why* I can do more than five cities.

; I did not have to choose in advance which cities to digitize---I had 48 to examine.

The most significant city with a documented gay neighborhood that was absent from these data was Oklahoma City.

**in each city, I chose the largest cluster or clusters of gay bars**

I used city descriptions from GayCities, prior qualitative research, and media accounts to make these choices

**I chose half of the available cities**

The largest city excluded was Phoenix. [because it looks like a damn checkerboard]

**something about geolocation**

**I merge adjacent tracts in the final analysis for substantive and methodological reasons.**

Census tracts are not neighborhoods

**yes to lesbians, no to rural areas, core not periphery**

differs from approaches focused on queering space

expect bias toward gay men over lesbians, but not excluding lesbians

Lesbian bars such as the Lexington in San Francisco and the Wildrose in Seattle

## Neighborhood change and comparisons

**why not same-sex couple households?** the error rates are too damn high. cannot compare change over time.

**matched tracts are not contiguous**, unlike gay neighborhood tracts

## Modeling change over time

two approaches: matching, and multilevel modeling
