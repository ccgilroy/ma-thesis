---
---

# geocoding

From the GayCities listings, I programmatically extract each bar's address.

I first filter out bars with addresses outside the US. Then, because these listings do not include zip codes, I retrieve more precise addresses, including zip codes and other information, from the Google Maps geocoding API. I adjudicate the 9 addresses for which Google Maps returns multiple results manually.[FOOTNOTE]

I batch code these refined addresses using the Census Geocoding API, a service that links addresses or coordinates to Census geographies.[LINK]

Finally, I geocode the 38 addresses for which the Census returns a tie or a failure to match through individual API calls, using the latitude and longitude provided by Google Maps.

In this way, I am able to successfully geocode all 840 bars within Census tracts.

[is that methods or results?]

[FOOTNOTE] Individual bar pages contain addresses with zip codes. These, however, were not captured as frequently by the Wayback Machine, and might therefore be more recent addresses. In cases of uncertainty, I use these individual pages to help make qualitative judgments.

[NOTE] What this means is that Google is better at figuring out where an address is than the Census is.

# clustering

The object of sociological interest is not Census tracts, but neighborhoods.

Gay bars frequently occur in spatially contiguous clusters of tracts.

I use this fact to produce clusters of tracts which roughly correspond to gay neighborhoods.

This regionalization process has the additional advantage of reducing the margin of error in ACS variable estimates [CITE].

I only consider tracts with bars

adjacent tracts

Tracts that share only a corner, not a line border, are not considered adjacent.

I used the `igraph` package [CITE] to assign numeric identifiers to these clusters.

See [APPENDIX] for a network graph of these clusters

# filtering

Far-flung, isolated bars are not part of gay neighborhoods.

rule of no downtowns

*A city's central business district is not its gay neighborhood.*

This is an operationalization of Levine's third criterion for gay neighborhoods, that they be a "culture area" wherein

LGBTQ people do not dominate the CBD of any city of which the author is aware.

ones and zeros.


See [APPENDIX] for these labels. (Or present them in main body of text?)

This approach is qualitative and inductive

the other is quantitative

# ... say things about variables here?

# ... say things about models here?

[This is where to talk about RESEARCH DESIGN, like Kate suggested]

Descriptive plots of variables are not sufficient

why gay neighborhoods are different
