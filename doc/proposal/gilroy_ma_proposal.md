---
title: |
    | MA Proposal
    | Do gay spaces impact urban change? Assessing coherence and divergence in sociodemographic trajectories between gay and non-gay neighborhoods
author: Connor Gilroy
date: 2017-10-10
output:
    pdf_document:
        latex_engine: xelatex
header-includes:
    - \usepackage{indentfirst}
    - \setlength\parindent{0.5cm}
fontsize: 12pt
geometry: margin=1.5in
mainfont: Gentium Basic
---

<!-- \setlength{\parskip}{0em} -->

\def\UrlBreaks{\do\/\do-\do\.}

Do small and marginalized communities that have mobilized to improve their position in wider society paradoxically have the effect of undermining their own coherence? Or is the stability and continuity of their spaces totally contingent on trends and forces from the broader society? Or, is it some combination or interaction of these two that undermines the spatial and social cohesion of a community?

Minority enclaves are a significant feature of the urban sociological landscape, and territoriality is one aspect of minority groups' relation to society at large. Logically, we can imagine that these clusters form as a result of some combination of an internal desire *for* community and external pressures from the wider society. Whether they persist hinges on whether they continue to attract new members of the in-group due to these same push and pull factors, and on whether they remain unattractive to others. What happens to these spaces in changing contexts tells us about how they are maintained or disrupted.

LGBTQ people are a small, marginalized social group, and they have been known for decades to form spatially-concentrated communities, particularly in urban neighborhoods. They also have experienced recent significant shifts in their status in US society. This combination of characteristics---the longstanding existence of distinct gay neighborhoods, and the more recent improvement in social position and abatement of stigma and prejudice---make for an interesting and important case.

Ultimately, we would want to examine the processes that bring LGBTQ people into gay neighborhoods, desire-for-community and external pressure or prejudice; as well as the processes that bring LGBTQ people out of gay neighborhoods, desire-for-assimilation and external pressure or competition. I contend that combining quantitative data on composition over time with archival and qualitative data about the historical and present location of gay neighborhoods opens the door to putting bounds on the answers to these questions, even if existing data are incapable of answering them fully.

I contend that it is possible to test whether and to what extent the 'gay neighborhood' coheres as a sociological object, whether it is 'disappearing' or otherwise undergoing significant change across the board or only in select locales, and if these changes are plausibly related to the changing social position of LGBTQ people in US society or merely due to contextual and economic factors.

To do this, I propose to measure multiple aspects of sociodemographic change in approximately 30 gay neighborhoods in major US cities, matched against non-gay neighborhoods that were demographically comparable to these in the past as a control. If gay neighborhoods experience more pronounced change than non-gay neighborhoods that were once comparable, then something about the world has changed such that gay neighborhoods are now vulnerable to disruption. If gay and non-gay neighborhoods in the same urban contexts experience the same changes, the position of minority groups is much more contingent on the fact of their being in the minority then anything done to change their position in society.

If there are unexpected costs or losses associated with ostensible improvements in the position of a marginalized group, that is something that politically and sociologically worth knowing about. If, by contrast, despite these sociopolitical changes, they can still lose the spaces they have carved out to economic and contextual forces, that is a sobering lesson as well.

# Proposed data

This is an ecological study. The theoretical object of study is the neighborhood, gay or otherwise. The operationalization of this object is a Census tract or combination of tracts. (It might improve the analysis to have access to individual-level data, but that is not the point, and not what I will start with.)

This study looks at recent changes over time, in a time frame in line with recent and dramatic changes in the position of LGBTQ people in US society, and with what I perceive to be a commensurate rise in concern over the position of gay spaces and institutions. (To take one prominent example, in 2004, multiple states instituted constitutional bans on same-sex marriage; in 2015 the US Supreme Court legalized same-sex marriage across the entire country.)

The simplest way to approach change over time is to pick two time points, which I will refer to below as $t_1$ and $t_2$.

$t_2$ will be the most recent American Community Survey, 2010-2015. With the ACS, I can choose either fine temporal resolution or fine geographic resolution. I think I need the finer geographic resolution in order to have results that are about the object I purport to study.

$t_1$ is debatable, but I think the 2005-2009 ACS is a reasonable choice. This year marks the first time two sets of non-overlapping five-year ACS data are available, which is a unique opportunity. The 2000 Census is also a reasonable choice, but raises some tricky questions about measurement and comparability. My inclination is to do the simplest viable thing first.

To identify gay neighborhoods, I use the concentration of visible gay institutions at $t_1$, corroborated by primarily qualitative secondary literature. A gay neighborhood is a physical space for gay institutions, gay people, and gay culture; it is not just a residential concentration. Because of this, the fact that we have poor measures of residential concentration for LGBTQ people is not only a disadvantage---in some ways, it is also an opportunity. Looking at institutions as well as people is a feature that potentially makes this work more sociological than just demographic.

It is relatively easy to acquire present-day data on the distribution of gay bars; archival and historical data is more challenging. One lead is Damron's Travel Guides, which at least one researcher (Greggor Mattson, Oberlin College) has already compiled for his own research.

Finally, because I suspect that heterogeneity is more important than we typically imagine, I note that I want to be conservative about case selection. I only want to pick neighborhoods that are definitively identifiable as gay neighborhoods, not marginal cases that might be gay. I do not want to muddle my argument by including well-known non-urban gay spaces, either.

I discuss selection of non-gay neighborhoods below.

# Proposed models

The tension I want to set up is between a neighborhood's being marked as gay and other intrinsic contextual qualities of the neighborhood, to investigate the impact a neighborhood being marked as gay has on how that neighborhood changes. To net out differences between cities and/or account for cross-city heterogeneity, I think that doing both of the following is appropriate:

- **matching** neighborhoods (=tracts) on multiple characteristics at t1, using Mahalanobis distance or propensity score matching. The question then becomes, basically, do neighborhoods that are comparable at t1 diverge in a predictable way by t2. (This is not the same as synthetic control or diff-in-diff methods, because there isn't a "treatment" between t1 and t2; the characteristic of interest is a prior characteristic.)
- using a **multilevel model** to account for cross-city variation in trajectories, with the goal being to compare how important between-group differences are as a source of variation in outcomes, against how important to outcomes whether a neighborhood is gay. (Fixed effects for cities are not viable with the number of observations I expect to have.)

Broadly, I would group variables of interest into three categories. These three aspects of change to consider are the economic characteristics of the neighborhood, the demographic characteristics of individuals in the neighborhood, and the composition of households. For each of these three, I would choose either a key indicator variable or create an index to use as the outcome.

I would run separate regressions on each with whether the neighborhood was institutionally gay or not at $t_1$ as the key covariate of interest, illustrated as follows:

$$econ_{t_2} = \beta_1 * gay_{t_1} + X\beta_{econ} + \epsilon_1$$

$$demog_{t_2} = \beta_2 * gay_{t_1} + X\beta_{demog} + \epsilon_2$$

$$households_{t_2} = \beta_3 * gay_{t_1} + X\beta_{households} + \epsilon_3$$

where $X$ is a matrix of economic, demographic, and household controls.

If I think that these outcomes change together in a consistent way, then I can put a correlation matrix on the error terms (creating what economists call Seemingly Unrelated Regressions):

$$\begin{pmatrix}\epsilon_1\\ \epsilon_2\\ \epsilon_3\end{pmatrix} \sim MVN\Bigg[ \begin{pmatrix}0\\ 0\\ 0\end{pmatrix}, \begin{pmatrix}\sigma_1^2 & \rho_1 \sigma_1 \sigma_2 & \rho_2 \sigma_1 \sigma_3\\ \rho_1 \sigma_1 \sigma_2 & \sigma_2^2 & \rho_3 \sigma_2 \sigma_3 \\ \rho_2 \sigma_1 \sigma_3 & \rho_3 \sigma_2 \sigma_3 & \sigma_3^2\end{pmatrix}   \Bigg]$$

The literal interpretations of the results are as follows, with theoretical implications in the subsequent section.

Economic indicators, such as incomes and housing prices, assess whether *the neighborhood is or is not experiencing economic transformations, transformations which may be to the benefit or detriment of current residents*

Relatively static characteristics of individuals, such as race and gender, and changes in the size or density of the population, assess whether *the people in the neighborhood at $t_2$ are different people, or different kinds of people, than at $t_1$.*

Finally, characteristics directly related to sexuality, namely, household structure, mean that *for the subset of people living with partners, I can tell whether the demographics of the neighborhood are becoming more gay and/or less straight. For single people, I can only see that change is or is not happening.*

# Typology of possible results and implications

To theorize about the implications of the above models, there are two clearly distinct possibilities depending on the results, with a third possibility that encompasses a range of heterogeneities falling somewhere in between.

1. Whether or not a neighborhood was gay in the past turns out to matter a great deal for what that neighborhood ends up looking like in the present. Some combination of change in the desires or pressures keeping LGBTQ living *in* these neighborhoods or in the desires and aversions of straight people keeping them *out* has affected these neighborhoods coherently, across the board, in a way that is demographically observable. This story is not so much about local or economic or contextual factors, it really *is* about the position of LGBTQ people in American society. Ideally, I will be able to use household structure information to start to distinguish how much this is a result of straights moving in or gays moving out. "There goes the gayborhood" is a real and general phenomenon, and we can move to exploring the mechanisms of change in more detail.

2. Whether or not a neighborhood is "gay" is not actually that predictive of how it changes; other characteristics (including city-specific ones) are. Gay people just happen to be caught in the middle of general urban processes of upheaval in some places. In other words, what has happened in Capitol Hill really does not differ much from what has happened in Belltown. It only feels different because different communities are impacted. The work done by Amin Ghaziani, Christina Hanhardt, and other scholars, on cities like Chicago, New York, and San Francisco is not *wrong*, per se. Instead, it is too localized. But the only way we can know that is by looking at the data on a broader scale. A process of change that matters deeply to the LGBTQ people living in the specific places affected by urban neighborhood change is not really about them, it only affects them incidentally.

3. Whether gay neighborhoods experience markedly different trends from non-gay one could vary. This could be in a way that is clearly interpretable. For instance, it could turn out that there are regional trends where gay neighborhoods are changing and are changing in more pronounced ways than other neighborhoods only in coastal cities, but not so much in the South or the Midwest. Alternatively, I could wind up with something incomprehensible or unexplainable, at least in terms the kinds of data that I can have, but this would at least pose an interesting puzzle.  Either way, it would turn out that gay neighborhoods are perhaps less coherent or uniform as a sociological construct that we might have believed, and their impact and meaning is more locally specific.

I think the third case is the most interesting possibility. That result would best enable me to make the broader and more meta point that variation matters theoretically and we need to aim our studies at the right level to see this variation.

# Where does this work fit?

I know that there are sexualities scholars in sociology whose work could be validated, extended, or challenged by this project. Some have already expressed interest based on my fumbling attempts to describe what I imagine doing. If I have any success, I am confident that I will be able to submit this work to a sexualities panel for ASA 2018.

This is my first attempt to step into the middle of the broader problem of quantitative and qualitative researchers not taking each other's work seriously enough. In the case of theorizing about changes to gay neighborhoods, I suspect that the qualitative evidence is rather thinner than we would like, and that quantitative research suffers in relevance because it does not consider culturally meaningful objects. The middle position I attempt to carve out, of doing quantitative analysis on a construct largely drawn from qualitative research, is one solution.

Finally, at the Sexualities Section 20-year retrospective session at ASA 2017, Amy Stone presented a meta-analysis documenting the overwhelming focus of LGBQ urban research on a small set of places, primarily San Francisco and New York. Entire regions, principally the South, have been neglected. With its emphasis on heterogeneity in a broad set of cases, this project contributes directly to remedying that narrow focus.
