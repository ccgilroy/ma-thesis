---
---

# Results

## Clustering and filtering

In the maps in Figures 1 and 2, I show the results of the clustering and filtering process described above for two cities, Chicago and Seattle. These are the two cities that, based on my own residential history, I am most confident in my ability to interpret. They also exemplify what I would consider clear and interpretable clusters.

![Chicago, suburbs not shown.](../../output/figures/chicago.png){ height=4in }

![Seattle, adjacent downtown bar excluded.](../../output/figures/seattle.png){ height=4in }

In Chicago, Boystown, with eight tracts and 18 bars, can be seen on the North Side by Lake Michigan. Andersonville lies further north, with four tracts and seven bars. These two gay neighborhoods, and their interrelated dynamics, are the focus of @ghaziani_there_2014, and it validates my method that it recovers them.

In Seattle, Capitol Hill covers four tracts and 11 bars, centered around the Pike-Pine corridor [@atkins_gay_2011]. Like Boystown, Capitol Hill is a prominent example of a gay neighborhood, one that would be expected to appear in the results of an approach like this. While successful, this case also illustrates some of the challenges of a bar-based approach and the constraints of Census tract boundaries, which do not have to map onto local knowledge. In the case of Seattle, the more residential areas of Capitol Hill to the north of Pike-Pine are not included in what I am labeling Seattle's gay neighborhood. Meanwhile, pieces of the First Hill and Central District neighborhoods to the south and east are included.

In these cases, my method identifies a recognizable cultural object, centered in a gay culture area with gay institutions. This is the important thing. The overall way to judge the success of my approach for each city is how well it accomplishes this goal. My point is not that the boundaries I have drawn are incontestable. In fact, I think for any case additional qualitative knowledge will have constructive critiques to offer. (The challenge, and eventual goal, is figuring out how to incorporate that knowledge!) What matters is that a bar-based approach produces a good first-order approximation of the locations of gay neighborhoods. It is clearer, even, than using the continuous measure of prevalences of same-sex couples, which requires arbitrary cutoffs [@gates_gay_2004; @brown_places_2006]. This pragmatic choice to impose boundaries enables an analysis of gay spaces rather than gay populations.

To further illustrate the strengths and shortcomings of my approach, I discuss two additional types of clusters emerging from my method. In each set of cases, it identifies gay neighborhoods in a way that is useful but perhaps not entirely satisfying. What I offer is pragmatism, not perfection.

In some cities with larger gay neighborhoods, qualitatively distinct neighborhoods that are adjacent blur and merge together. Significant examples of this are the Castro, the Mission, and SOMA in San Francisco, West Village and Chelsea in New York, Rittenhouse Square and Washington Square West in Philadelphia, and Dupont Circle, Logan Circle, and Shaw/U Street in Washington, DC. By treating each of these as a single unit, I could be effacing important distinctions. For instance, @hanhardt_safe_2013 and @greene_gay_2014 both take care to characterize the differences between those three DC neighborhoods, which could turn out to matter for the kinds of changes they experience. I am setting that possibility aside. Perhaps with more detailed on-the-ground knowledge, these clusters could be subdivided more finely, but I do not attempt that here. (Or perhaps not. For instance, @compton_beyond_2012 discuss the difficulty of drawing a precise boundary between the Castro and the Mission, despite these being well-defined enclaves associated strongly with gay men and lesbians, respectively.)

In other cases, what would appear to be a single neighborhood, based on the neighborhood labels associated with the bars in the original GayCities data, is fragmented among two or more noncontiguous clusters of tracts. Examples of this fragmentation occur for Capitol Hill in Denver and South Beach in Miami. I do not attempt to unify these fragments; rather, as I describe above, I choose only the largest cluster to represent the neighborhood as a whole.

See Appendix C for maps of these cases.

Selecting gay neighborhoods from 24 cities using a combination of qualitative and quantitative criteria gives me 28 clusters to use as data points in the analyses that I present below. The 488 tracts I begin with that contain gay bars fall to 461 candidate tracts once downtowns are excluded. Of these, 146 tracts (29.9% of the original number) remain in the filtered components that I use in my analysis.

I briefly describe the range of clusters, with a full list in Appendix A. The largest gay neighborhood by number of tracts is West Village - Chelsea, New York with 13 tracts, while the largest by number of bars is Castro - Mission - Folsom - SOMA, SF with 33 bars. This shows that the historical prominence accorded to these areas as gay centers persisted---at least institutionally---in 2007. At the other end of the range, the smallest clusters by number of tracts are Northcentral, San Antonio, and Ybor City, Tampa, with one tract each, while the smallest by number of bars is South Beach, Miami, with four bars.

## Descriptive results

In Table 1, I present average tract-level characteristics, four demographic and two economic, for three kinds of tracts: tracts in gay neighborhoods, by my criteria above, other tracts with gay bars that are not classified as being part of gay neighborhoods, and all tracts in the relevant counties that do not contain gay bar. Importantly, for the tracts containing gay bars, these traits were not the criteria for selection into one group or the other. (Of course, I anticipated that they would not be the same: the expectation that these different spaces would have different characteristics was a motivation for making the distinction.)

\begin{table}

\caption{\label{tab:}Average values for tracts}
\centering
\begin{tabular}[t]{lrrrrrr}
\toprule
\multicolumn{1}{c}{ } & \multicolumn{2}{c}{Gay neighborhood tracts} & \multicolumn{2}{c}{Other tracts with gay bars} & \multicolumn{2}{c}{Tracts without gay bars} \\
% \cmidrule(l{2pt}r{2pt}){2-3} \cmidrule(l{2pt}r{2pt}){4-5} \cmidrule(l{2pt}r{2pt}){6-7}
\multicolumn{1}{c}{\em  } & \multicolumn{2}{c}{\em N = 146} & \multicolumn{2}{c}{\em N = 342} & \multicolumn{2}{c}{\em N = 22519} \\
\cmidrule(l{2pt}r{2pt}){2-3} \cmidrule(l{2pt}r{2pt}){4-5} \cmidrule(l{2pt}r{2pt}){6-7}
  & 2006-2010 & 2011-2015 & 2006-2010 & 2011-2015 & 2006-2010 & 2011-2015\\
\midrule
college educated & 0.54 & 0.60 & 0.35 & 0.39 & 0.31 & 0.33\\
male & 0.54 & 0.54 & 0.53 & 0.52 & 0.48 & 0.48\\
married & 0.19 & 0.20 & 0.27 & 0.27 & 0.44 & 0.43\\
white & 0.60 & 0.60 & 0.51 & 0.51 & 0.48 & 0.46\\
median income & 63916.50 & 68341.77 & 48446.03 & 50195.39 & 64326.67 & 61341.20\\
median rent & 1229.51 & 1319.33 & 1000.13 & 1056.72 & 1167.82 & 1194.26\\
\bottomrule
\end{tabular}
\end{table}

On average, tracts in gay neighborhoods are more educated, and have become more educated. They are skewed more male than other tracts, have fewer different-sex married couples, and are whiter, but these characteristics do not change much, on average, in the short window of time covered by my data. Economically, they start off with higher median incomes and rents, and these also increase. The excluded tracts with gay bars fall between on demographic characteristics, and below on economic characteristics.

Averages do not tell the whole story. What is more informative is to look at each neighborhood relative to its own context. This is what I show in Figure 3 for the four demographic characteristics, plotting neighborhood-level characteristics against those same characteristics at the county level.[^county_medians] Here I move from presenting results about Census tracts to presenting results for gay neighborhoods, which are clusters of tracts as defined previously.

[^county_medians]: I have not yet obtained county-level data for median income or median rent, but plan to do so. These cannot be calculated directly from tract-level data.

![Gay neighborhoods in context. Red lines represent parity.](../../output/figures/demographic_comparison.png)

These gay neighborhoods systematically differ from their contexts. They are whiter, more male, more educated, and less married. All of this conforms to our expectations and preconceptions for gay neighborhoods. Though I do not measure the individual cooccurrence of these traits, and I of course cannot measure sexual orientation, these trends are consistent with the idea that these neighborhoods are spaces for white, middle-class, gay men.

What exactly this means varies. Counties are clustered tightly at a little under 50% male; gay neighborhoods range from 50% to 60% male. By contrast, there is much more heterogeneity in how white a county and its corresponding gay neighborhoods are.

From Figure 3, we also begin to see what change in these neighborhoods looks like. To highlight this process more clearly, I now present bivariate plots of different sets of variables. In these, both axes are neighborhood-level characteristics. Each point is a single neighborhood in either 2006-2010 or 2011-2015, and an arrow connects the earlier observation to the later one for the same neighborhood.

![Divergent trajectories.](../../output/figures/white_married_2way.png)

Figure 4 presents two demographic characteristics without a single coherent trajectory: the proportion of white individuals and the proportion of different-sex married couple households. One structural implication of the "there goes the gayborhood" hypothesis is the idea that gay neighborhoods are experiencing an influx and increased prevalence of straight, white, married couples across the board, and that this is what poses a general threat to gay culture and institutions in these spaces.[^prevalence] From these data, this is not necessarily true. Of course, this descriptive finding is subject to the caveat that I am observing a short period of time with noisy data. Further investigation could confirm or undermine this.

[^prevalence]: Strictly speaking, an influx would refer to counts, and increase prevalence would refer to proportions. If in-migration and displacement is the primary concern, the former matters more; if change in the culture or tone of an area matters more, the latter does. I present the latter here.

![Coherent trajectories.](../../output/figures/rent_education_2way.png)

The second plot, Figure 5 shows median rent, an economic indicator, and education, a demographic trait associated with class. Both of these are associated with processes of gentrification. For these, the trajectories for the majority of gay neighborhoods is clear: they are becoming more educated and more expensive. Recall, as shown above, that these neighborhood begin in the first time period with a more highly educated population than average for their contexts, and with more expensive rents. It appears, descriptively, that gay neighborhoods in recent times are generally experiencing changes that strongly resemble gentrification.

In summary, I have described what gay neighborhoods were like in the recent past, and how they have changed. Gay neighborhoods look different from their contexts, and they share similarities with each other. On some axes of structural change---those consistent with what we might call gentrification---they exhibit consistent trends. On others---those that would allow us to assign a clear narrative about the culprits for this change---they do not.

While I have deliberately broadened my sample beyond the most commonly considered set of cities, I have taken care to exclude cities and neighborhoods that do not clearly belong. As a result, the heterogeneity and coherence of different aspects of these neighborhoods are both striking.

In this section, I have carefully looked at the available data, before moving to model or analyze it. I have innovated by relying on quantitative aggregation and qualitative prior knowledge to present the data in a meaningful way.

## Model results[^modeling2]

---

[^modeling2]: Because I have yet to implement and run these models, I describe anticipated results here. I am confident in my ability to implement matching and multilevel modeling techniques for this paper, and to do sufficient sensitivity analyses so as to have robust findings.

Based on the descriptive results above, I expect to find impacts for a neighborhood being marked as gay on increases in education level, rent, and income over time. By contrast, I do not expect clear results for race, gender, or household type. City-level differences will drive anywhere from a moderate to substantial portion of the variation observed.

---

outline:

- orient to models
- interpret results descriptively
- start to say what they mean

---

I now describe the results for my statistical models. Rather than discuss the associations of all covariates, I focus primarily on presenting estimates for $\hat{\beta_{gay}}$, the coefficient for the indicator variable for gay neighborhoods. Figure 6 displays estimates for this single coefficient across 28 models--four models for each of seven outcomes.

All models are multivariate linear regressions of the form shown in the Methods section. The first model ("All") compares gay neighborhood tracts to all other tracts in the same set of counties, excluding tracts which contain gay bars but which are not part of gay neighborhoods. The second model ("All (multilevel)") uses the same data, but allows model intercepts to vary across cities in a multilevel model. The third model ("Matched") restricts the sample of non-gay tracts to only individual matched tracts for comparison. The fourth model ("Aggregated") aggregates the gay neighborhood tracts into gay neighborhoods, and the matched tracts from the third model into synthetic comparison neighborhoods.

All models incorporate the values of each outcome in 2006-2010 as additional covariates. In every case, the strongest predictor of an outcome in 2011-2015 is the same variable in 2006-2010. For full tables of model coefficients for each outcome, see [APPENDIX]. I omit results for multilevel models for the matched and aggregated tracts, because the city-varying slopes in these models were not justified by improvements in model fit. Also in terms of model fit, models with the gay neighborhood indicator were generally preferred to models without.

![Model results.](../../output/figures/gay_coefficient_plot.png)

The models shown in Figure 6 are generally consistent in relation to each other. One limitation is that the standard errors and displayed 95% confidence intervals do not incorporate the measurement error in the American Community Survey. One motivation for the fourth, aggregated model is that aggregation reduces the impact of this measurement error. This is true even as the standard errors increase due to a decrease in the number of observations. For both this reason and the fact that matching attempts to control heterogeneity, the matched and aggregated model provides the most reasonable and appropriate estimates and confidence intervals.

descriptive of coefficients:

what actually found

YES: education, married, male

Gay neighborhoods in 2011-2015 differ from other neighborhoods in terms of education, household types, and gender. They have a higher proportion of college-educated individuals, a lower proportion of different-sex married households, and a higher proportion of men. This is true even after matching them to demographically and economically similar tracts in 2006-2010, and controlling for the levels of these values in 2006-2010. For example, net of the proportion college-educated in 2006-2010 and other controls, a gay neighborhood is predicted to have a higher proportion college-educated in 2011-2015 by 3 percentage points, compared to a set of tracts that was matched as otherwise comparable in 2006-2010. Similarly, a gay neighborhood is predicted to be 2 percentage points more male, and have 2.4 percentage points fewer married-couple households.

married and male suggest that these neighborhoods remain distinct [move interpretation below]

ISH: income, white

Proportion white and median income are less clearly different



Gay neighborhoods are weakly associated with increased median income, but the statistical power of my data is insufficient to say this with certainty.

the most puzzling white?

NO: rent, density

Median rent and population density appear to have no association

; the estimated coefficients are near zero.

models in relation to each other:


how to think about magnitude of coefficients:

Model results confirm the distinctness of gay neighborhoods

demographic evidence is mixed

the clearest signs of displacement---both generally and of LGBTQ populations in particular---are weak or absent


(See appendix for full tables of coefficients)



For all

to get that amount of demographic change in a short period of time


matching and aggregating attenuates the estimates for proportion male and proportion married

I don't know what to do with proportion white. why does it magically turn significant when I aggregate?

compare to other coefficients

compare to random effects---between-city heterogeneity
