---
output:
    pdf_document:
        latex_engine: xelatex
        keep_tex: True
mainfont: Gentium Basic
monofont: InconsolataGo
fontsize: 12pt
header-includes:
    - \usepackage{longtable,booktabs}
    - \usepackage{indentfirst}
---

\newpage

\setlength\parindent{0cm}
\setlength{\parskip}{0.5em}
\setlength\leftskip{0cm}
\linespread{1}\selectfont

# Appendix A: Cities and neighborhoods

Neighborhood labels are derived from a combination of GayCities bar labels and city descriptions and the historical, geographic, and sociological academic literatures.

|City            |Neighborhood                                 | Tracts| Bars|
|:---------------|:--------------------------------------------|------:|----:|
|New York        |West Village - Chelsea                       |     13|   28|
|New York        |East Village                                 |      5|    9|
|New York        |Hell's Kitchen                               |      4|    8|
|San Francisco   |Castro - Mission - Folsom - SOMA             |     11|   33|
|San Francisco   |Polk Street                                  |      4|    6|
|Chicago         |Boystown                                     |      8|   18|
|Chicago         |Andersonville                                |      4|    7|
|Los Angeles     |West Hollywood                               |      6|   18|
|Los Angeles     |Alamitos Beach                               |      2|    6|
|Atlanta         |Midtown                                      |     10|   20|
|Baltimore       |Mount Vernon                                 |      5|   11|
|Boston          |South End                                    |      4|    6|
|Columbus        |German Village                               |      3|    6|
|Dallas          |Oak Lawn                                     |      6|   19|
|Denver          |Capitol Hill                                 |      4|    5|
|Fort Lauderdale |Wilton Manors                                |      8|   14|
|Houston         |Montrose                                     |      5|   13|
|Miami           |South Beach                                  |      2|    4|
|Milwaukee       |Walkers Point                                |      3|   10|
|New Orleans     |French Quarter - Marigny                     |      4|   18|
|Philadelphia    |Rittenhouse Square - Washington Square West  |      3|   12|
|Sacramento      |Midtown                                      |      2|    7|
|San Antonio     |Northcentral                                 |      1|    6|
|San Diego       |Hillcrest - North Park                       |     10|   20|
|Seattle         |Capitol Hill                                 |      4|   11|
|St. Louis       |Manchester Avenue - Central West End         |      4|    9|
|Tampa Bay       |Ybor City                                    |      1|    6|
|Washington DC   |Dupont Circle - Logan Circle - Shaw/U Street |     10|   16|

Other US cities: Albuquerque, Asheville, Austin, Charlotte, Cincinnati, Cleveland, Des Moines, Detroit, Fort Worth, Hartford, Hawaii, Indianapolis, Kansas City, Las Vegas, Memphis, Minneapolis, Nashville, Oakland, Orlando, Phoenix, Pittsburgh, Portland, Salt Lake City, San Jose

US resort towns: Fire Island, Key West, Laguna Beach, Ogunquit, Palm Springs, Provincetown, Rehoboth Beach, Russian River, Saugatuck

Canadian cities: Calgary, Edmonton, Montreal, Toronto, Vancouver, Winnipeg

# Appendix B: Geographic network

Graph of clusters of tracts with gay bars. Nodes shaded red are included as gay neighborhoods.

![](../../output/figures/network.png){ width=6in }\

\newpage

# Appendix C: Maps

Maps of six cities discussed in the paper: San Francisco, New York, Philadelphia, Washington DC, Denver, and Miami.

![](../../output/figures/san_francisco.png){ width=50% } ![](../../output/figures/new_york.png){ width=50% }

![](../../output/figures/philadelphia.png){ width=50% } ![](../../output/figures/washington_dc.png){ width=50% }

![](../../output/figures/denver.png){ width=50% } ![](../../output/figures/miami.png){ width=50% }

\newpage

# Appendix D: Tables of model coefficients

\begin{table}[h!]
\caption{Outcome - proportion college-educated, 2015}
\begin{center}
\begin{tabular}{l c c c c c }
\toprule
 & Baseline & All tracts & Multilevel & Matched & Aggregated \\
\midrule
indicator for gay neighborhood     &                & $0.026^{***}$  & $0.025^{***}$  & $0.023^{**}$  & $0.030^{*}$   \\
                                   &                & $(0.006)$      & $(0.005)$      & $(0.009)$     & $(0.013)$     \\
prop. college-educated, 2010       & $0.891^{***}$  & $0.891^{***}$  & $0.877^{***}$  & $0.757^{***}$ & $0.776^{***}$ \\
                                   & $(0.005)$      & $(0.005)$      & $(0.005)$      & $(0.048)$     & $(0.105)$     \\
proportion male, 2010              & $0.056^{***}$  & $0.048^{***}$  & $0.051^{***}$  & $0.065$       & $0.079$       \\
                                   & $(0.012)$      & $(0.012)$      & $(0.012)$      & $(0.078)$     & $(0.228)$     \\
proportion married, 2010           & $-0.099^{***}$ & $-0.095^{***}$ & $-0.091^{***}$ & $-0.055$      & $0.091$       \\
                                   & $(0.005)$      & $(0.005)$      & $(0.005)$      & $(0.063)$     & $(0.147)$     \\
proportion white, 2010             & $0.053^{***}$  & $0.053^{***}$  & $0.063^{***}$  & $0.083^{*}$   & $0.095$       \\
                                   & $(0.003)$      & $(0.003)$      & $(0.003)$      & $(0.033)$     & $(0.059)$     \\
median income (\$, logged)         & $0.028^{***}$  & $0.028^{***}$  & $0.024^{***}$  & $0.047^{*}$   & $0.071$       \\
                                   & $(0.003)$      & $(0.003)$      & $(0.003)$      & $(0.022)$     & $(0.060)$     \\
median rent (\$, logged)           & $0.011^{***}$  & $0.011^{***}$  & $0.015^{***}$  & $-0.015$      & $-0.092$      \\
                                   & $(0.002)$      & $(0.002)$      & $(0.003)$      & $(0.025)$     & $(0.060)$     \\
pop. density (per sq. mi., logged) & $0.004^{***}$  & $0.004^{***}$  & $0.002^{***}$  & $0.018^{***}$ & $0.027^{*}$   \\
                                   & $(0.001)$      & $(0.001)$      & $(0.001)$      & $(0.005)$     & $(0.011)$     \\
\midrule
AIC                                & -34027.496     & -34048.001     & -34129.066     & -704.764      & -177.967      \\
BIC                                & -33960.365     & -33973.411     & -34047.018     & -667.997      & -157.713      \\
Log Likelihood                     & 17022.748      & 17034.000      & 17075.533      & 362.382       & 98.983        \\
Num. obs.                          & 12823          & 12823          & 12823          & 292           & 56            \\
Num. groups: city                  &                &                & 23             &               &               \\
Var: city (Intercept)              &                &                & 0.000          &               &               \\
Var: Residual                      &                &                & 0.004          &               &               \\
\bottomrule
\multicolumn{6}{l}{\scriptsize{$^{***}p<0.001$, $^{**}p<0.01$, $^*p<0.05$}}
\end{tabular}
\label{table:coefficients}
\end{center}
\end{table}

\newpage

\begin{table}[h!]
\caption{Outcome - proportion male, 2015}
\begin{center}
\begin{tabular}{l c c c c c }
\toprule
 & Baseline & All tracts & Multilevel & Matched & Aggregated \\
\midrule
indicator for gay neighborhood     &                & $0.038^{***}$  & $0.036^{***}$  & $0.024^{***}$ & $0.021^{*}$   \\
                                   &                & $(0.003)$      & $(0.003)$      & $(0.006)$     & $(0.008)$     \\
prop. college-educated, 2010       & $0.001$        & $-0.000$       & $-0.004$       & $-0.033$      & $-0.042$      \\
                                   & $(0.003)$      & $(0.003)$      & $(0.003)$      & $(0.034)$     & $(0.060)$     \\
proportion male, 2010              & $0.387^{***}$  & $0.376^{***}$  & $0.363^{***}$  & $0.522^{***}$ & $0.634^{***}$ \\
                                   & $(0.007)$      & $(0.007)$      & $(0.007)$      & $(0.054)$     & $(0.132)$     \\
proportion married, 2010           & $0.011^{***}$  & $0.016^{***}$  & $0.011^{***}$  & $-0.147^{**}$ & $-0.121$      \\
                                   & $(0.003)$      & $(0.003)$      & $(0.003)$      & $(0.044)$     & $(0.085)$     \\
proportion white, 2010             & $0.006^{***}$  & $0.006^{***}$  & $0.010^{***}$  & $0.005$       & $0.046$       \\
                                   & $(0.002)$      & $(0.002)$      & $(0.002)$      & $(0.023)$     & $(0.034)$     \\
median income (\$, logged)         & $-0.005^{***}$ & $-0.006^{***}$ & $-0.005^{***}$ & $0.026$       & $0.005$       \\
                                   & $(0.001)$      & $(0.001)$      & $(0.002)$      & $(0.016)$     & $(0.035)$     \\
median rent (\$, logged)           & $0.004^{**}$   & $0.004^{**}$   & $0.003^{*}$    & $-0.009$      & $0.001$       \\
                                   & $(0.001)$      & $(0.001)$      & $(0.002)$      & $(0.018)$     & $(0.035)$     \\
pop. density (per sq. mi., logged) & $-0.001$       & $-0.001^{*}$   & $0.000$        & $0.001$       & $0.005$       \\
                                   & $(0.000)$      & $(0.000)$      & $(0.000)$      & $(0.004)$     & $(0.006)$     \\
\midrule
AIC                                & -47781.886     & -47916.508     & -47952.089     & -911.533      & -239.308      \\
BIC                                & -47714.755     & -47841.918     & -47870.040     & -874.766      & -219.054      \\
Log Likelihood                     & 23899.943      & 23968.254      & 23987.045      & 465.767       & 129.654       \\
Num. obs.                          & 12823          & 12823          & 12823          & 292           & 56            \\
Num. groups: city                  &                &                & 23             &               &               \\
Var: city (Intercept)              &                &                & 0.000          &               &               \\
Var: Residual                      &                &                & 0.001          &               &               \\
\bottomrule
\multicolumn{6}{l}{\scriptsize{$^{***}p<0.001$, $^{**}p<0.01$, $^*p<0.05$}}
\end{tabular}
\label{table:coefficients}
\end{center}
\end{table}

\newpage

\begin{table}[h!]
\caption{Outcome - proportion married, 2015}
\begin{center}
\begin{tabular}{l c c c c c }
\toprule
 & Baseline & All tracts & Multilevel & Matched & Aggregated \\
\midrule
indicator for gay neighborhood     &                & $-0.039^{***}$ & $-0.039^{***}$ & $-0.020^{**}$ & $-0.022^{*}$  \\
                                   &                & $(0.006)$      & $(0.006)$      & $(0.006)$     & $(0.008)$     \\
prop. college-educated, 2010       & $-0.044^{***}$ & $-0.043^{***}$ & $-0.046^{***}$ & $-0.041$      & $-0.096$      \\
                                   & $(0.005)$      & $(0.005)$      & $(0.005)$      & $(0.036)$     & $(0.067)$     \\
proportion male, 2010              & $-0.004$       & $0.008$        & $-0.005$       & $-0.067$      & $0.071$       \\
                                   & $(0.013)$      & $(0.013)$      & $(0.013)$      & $(0.058)$     & $(0.145)$     \\
proportion married, 2010           & $0.745^{***}$  & $0.740^{***}$  & $0.721^{***}$  & $0.708^{***}$ & $0.670^{***}$ \\
                                   & $(0.006)$      & $(0.006)$      & $(0.006)$      & $(0.047)$     & $(0.094)$     \\
proportion white, 2010             & $0.023^{***}$  & $0.023^{***}$  & $0.034^{***}$  & $0.039$       & $0.071$       \\
                                   & $(0.003)$      & $(0.003)$      & $(0.003)$      & $(0.024)$     & $(0.038)$     \\
median income (\$, logged)         & $0.051^{***}$  & $0.051^{***}$  & $0.051^{***}$  & $0.044^{**}$  & $0.092^{*}$   \\
                                   & $(0.003)$      & $(0.003)$      & $(0.003)$      & $(0.016)$     & $(0.038)$     \\
median rent (\$, logged)           & $0.021^{***}$  & $0.021^{***}$  & $0.016^{***}$  & $-0.002$      & $-0.079^{*}$  \\
                                   & $(0.003)$      & $(0.003)$      & $(0.003)$      & $(0.019)$     & $(0.038)$     \\
pop. density (per sq. mi., logged) & $-0.004^{***}$ & $-0.004^{***}$ & $-0.006^{***}$ & $-0.008$      & $0.005$       \\
                                   & $(0.001)$      & $(0.001)$      & $(0.001)$      & $(0.004)$     & $(0.007)$     \\
\midrule
AIC                                & -31102.856     & -31140.882     & -31245.463     & -876.635      & -228.677      \\
BIC                                & -31035.725     & -31066.292     & -31163.414     & -839.867      & -208.423      \\
Log Likelihood                     & 15560.428      & 15580.441      & 15633.732      & 448.317       & 124.338       \\
Num. obs.                          & 12823          & 12823          & 12823          & 292           & 56            \\
Num. groups: city                  &                &                & 23             &               &               \\
Var: city (Intercept)              &                &                & 0.000          &               &               \\
Var: Residual                      &                &                & 0.005          &               &               \\
\bottomrule
\multicolumn{6}{l}{\scriptsize{$^{***}p<0.001$, $^{**}p<0.01$, $^*p<0.05$}}
\end{tabular}
\label{table:coefficients}
\end{center}
\end{table}

\newpage

\begin{table}[h!]
\caption{Outcome - proportion white, 2015}
\begin{center}
\begin{tabular}{l c c c c c }
\toprule
 & Baseline & All tracts & Multilevel & Matched & Aggregated \\
\midrule
indicator for gay neighborhood     &                & $0.010$        & $0.011$       & $0.016^{*}$   & $0.031^{**}$  \\
                                   &                & $(0.006)$      & $(0.006)$     & $(0.008)$     & $(0.010)$     \\
prop. college-educated, 2010       & $0.072^{***}$  & $0.072^{***}$  & $0.075^{***}$ & $0.068$       & $-0.004$      \\
                                   & $(0.005)$      & $(0.005)$      & $(0.005)$     & $(0.044)$     & $(0.080)$     \\
proportion male, 2010              & $0.050^{***}$  & $0.047^{***}$  & $0.056^{***}$ & $0.001$       & $0.008$       \\
                                   & $(0.012)$      & $(0.013)$      & $(0.013)$     & $(0.071)$     & $(0.175)$     \\
proportion married, 2010           & $-0.027^{***}$ & $-0.026^{***}$ & $-0.015^{**}$ & $-0.019$      & $0.229^{*}$   \\
                                   & $(0.005)$      & $(0.005)$      & $(0.005)$     & $(0.058)$     & $(0.113)$     \\
proportion white, 2010             & $0.905^{***}$  & $0.905^{***}$  & $0.896^{***}$ & $0.827^{***}$ & $0.912^{***}$ \\
                                   & $(0.003)$      & $(0.003)$      & $(0.003)$     & $(0.030)$     & $(0.045)$     \\
median income (\$, logged)         & $0.002$        & $0.002$        & $0.000$       & $0.048^{*}$   & $0.082$       \\
                                   & $(0.003)$      & $(0.003)$      & $(0.003)$     & $(0.020)$     & $(0.046)$     \\
median rent (\$, logged)           & $-0.007^{**}$  & $-0.007^{**}$  & $-0.005$      & $-0.062^{**}$ & $-0.127^{**}$ \\
                                   & $(0.003)$      & $(0.003)$      & $(0.003)$     & $(0.023)$     & $(0.046)$     \\
pop. density (per sq. mi., logged) & $-0.001$       & $-0.001$       & $-0.001^{*}$  & $0.012^{*}$   & $0.015$       \\
                                   & $(0.001)$      & $(0.001)$      & $(0.001)$     & $(0.005)$     & $(0.009)$     \\
\midrule
AIC                                & -32800.476     & -32801.563     & -32862.824    & -754.015      & -207.985      \\
BIC                                & -32733.345     & -32726.973     & -32780.775    & -717.247      & -187.731      \\
Log Likelihood                     & 16409.238      & 16410.781      & 16442.412     & 387.007       & 113.992       \\
Num. obs.                          & 12823          & 12823          & 12823         & 292           & 56            \\
Num. groups: city                  &                &                & 23            &               &               \\
Var: city (Intercept)              &                &                & 0.000         &               &               \\
Var: Residual                      &                &                & 0.004         &               &               \\
\bottomrule
\multicolumn{6}{l}{\scriptsize{$^{***}p<0.001$, $^{**}p<0.01$, $^*p<0.05$}}
\end{tabular}
\label{table:coefficients}
\end{center}
\end{table}

\newpage

\begin{table}[h!]
\caption{Outcome - median income, 2015 (\$, logged)}
\begin{center}
\begin{tabular}{l c c c c c }
\toprule
 & Baseline & All tracts & Multilevel & Matched & Aggregated \\
\midrule
indicator for gay neighborhood     &               & $0.047^{**}$  & $0.047^{**}$   & $0.039$       & $0.043$       \\
                                   &               & $(0.016)$     & $(0.015)$      & $(0.023)$     & $(0.032)$     \\
prop. college-educated, 2010       & $0.419^{***}$ & $0.418^{***}$ & $0.408^{***}$  & $0.453^{***}$ & $0.483$       \\
                                   & $(0.014)$     & $(0.014)$     & $(0.014)$      & $(0.127)$     & $(0.255)$     \\
proportion male, 2010              & $0.042$       & $0.028$       & $0.028$        & $0.156$       & $-0.104$      \\
                                   & $(0.034)$     & $(0.035)$     & $(0.034)$      & $(0.206)$     & $(0.558)$     \\
proportion married, 2010           & $0.177^{***}$ & $0.183^{***}$ & $0.190^{***}$  & $0.208$       & $0.490$       \\
                                   & $(0.014)$     & $(0.015)$     & $(0.015)$      & $(0.168)$     & $(0.359)$     \\
proportion white, 2010             & $0.073^{***}$ & $0.072^{***}$ & $0.094^{***}$  & $-0.007$      & $0.041$       \\
                                   & $(0.008)$     & $(0.008)$     & $(0.008)$      & $(0.087)$     & $(0.145)$     \\
median income (\$, logged)         & $0.705^{***}$ & $0.704^{***}$ & $0.669^{***}$  & $0.745^{***}$ & $0.909^{***}$ \\
                                   & $(0.007)$     & $(0.007)$     & $(0.007)$      & $(0.059)$     & $(0.146)$     \\
median rent (\$, logged)           & $0.114^{***}$ & $0.114^{***}$ & $0.135^{***}$  & $0.083$       & $-0.201$      \\
                                   & $(0.007)$     & $(0.007)$     & $(0.008)$      & $(0.067)$     & $(0.146)$     \\
pop. density (per sq. mi., logged) & $-0.001$      & $-0.001$      & $-0.018^{***}$ & $0.028^{*}$   & $0.047$       \\
                                   & $(0.001)$     & $(0.001)$     & $(0.002)$      & $(0.014)$     & $(0.027)$     \\
\midrule
AIC                                & -6876.085     & -6882.989     & -7502.015      & -133.962      & -77.999       \\
BIC                                & -6808.954     & -6808.399     & -7419.966      & -97.194       & -57.745       \\
Log Likelihood                     & 3447.043      & 3451.495      & 3762.008       & 76.981        & 48.999        \\
Num. obs.                          & 12823         & 12823         & 12823          & 292           & 56            \\
Num. groups: city                  &               &               & 23             &               &               \\
Var: city (Intercept)              &               &               & 0.004          &               &               \\
Var: Residual                      &               &               & 0.032          &               &               \\
\bottomrule
\multicolumn{6}{l}{\scriptsize{$^{***}p<0.001$, $^{**}p<0.01$, $^*p<0.05$}}
\end{tabular}
\label{table:coefficients}
\end{center}
\end{table}

\newpage

\begin{table}[h!]
\caption{Outcome - median rent, 2015 (\$, logged)}
\begin{center}
\begin{tabular}{l c c c c c }
\toprule
 & Baseline & All tracts & Multilevel & Matched & Aggregated \\
\midrule
indicator for gay neighborhood     &                & $-0.007$       & $-0.006$      & $0.011$       & $0.000$       \\
                                   &                & $(0.014)$      & $(0.014)$     & $(0.015)$     & $(0.029)$     \\
prop. college-educated, 2010       & $0.187^{***}$  & $0.187^{***}$  & $0.217^{***}$ & $0.171^{*}$   & $0.163$       \\
                                   & $(0.012)$      & $(0.012)$      & $(0.012)$     & $(0.086)$     & $(0.226)$     \\
proportion male, 2010              & $0.099^{**}$   & $0.101^{**}$   & $0.106^{***}$ & $0.015$       & $0.069$       \\
                                   & $(0.031)$      & $(0.031)$      & $(0.030)$     & $(0.140)$     & $(0.494)$     \\
proportion married, 2010           & $0.040^{**}$   & $0.040^{**}$   & $0.020$       & $0.007$       & $0.059$       \\
                                   & $(0.013)$      & $(0.013)$      & $(0.013)$     & $(0.114)$     & $(0.318)$     \\
proportion white, 2010             & $-0.039^{***}$ & $-0.039^{***}$ & $-0.009$      & $-0.070$      & $0.020$       \\
                                   & $(0.007)$      & $(0.007)$      & $(0.007)$     & $(0.059)$     & $(0.128)$     \\
median income (\$, logged)         & $0.148^{***}$  & $0.148^{***}$  & $0.138^{***}$ & $0.101^{*}$   & $0.072$       \\
                                   & $(0.007)$      & $(0.007)$      & $(0.006)$     & $(0.040)$     & $(0.130)$     \\
median rent (\$, logged)           & $0.679^{***}$  & $0.679^{***}$  & $0.603^{***}$ & $0.838^{***}$ & $0.830^{***}$ \\
                                   & $(0.006)$      & $(0.006)$      & $(0.007)$     & $(0.046)$     & $(0.130)$     \\
pop. density (per sq. mi., logged) & $0.022^{***}$  & $0.022^{***}$  & $-0.002$      & $0.029^{**}$  & $0.034$       \\
                                   & $(0.001)$      & $(0.001)$      & $(0.002)$     & $(0.009)$     & $(0.024)$     \\
\midrule
AIC                                & -9871.937      & -9870.149      & -10898.589    & -359.652      & -91.605       \\
BIC                                & -9804.806      & -9795.559      & -10816.540    & -322.884      & -71.351       \\
Log Likelihood                     & 4944.968       & 4945.074       & 5460.294      & 189.826       & 55.803        \\
Num. obs.                          & 12823          & 12823          & 12823         & 292           & 56            \\
Num. groups: city                  &                &                & 23            &               &               \\
Var: city (Intercept)              &                &                & 0.004         &               &               \\
Var: Residual                      &                &                & 0.025         &               &               \\
\bottomrule
\multicolumn{6}{l}{\scriptsize{$^{***}p<0.001$, $^{**}p<0.01$, $^*p<0.05$}}
\end{tabular}
\label{table:coefficients}
\end{center}
\end{table}

\newpage

\begin{table}[h!]
\caption{Outcome - population density (per sq. mi. logged)}
\begin{center}
\begin{tabular}{l c c c c c }
\toprule
 & Baseline & All tracts & Multilevel & Matched & Aggregated \\
\midrule
indicator for gay neighborhood     &                & $-0.003$       & $-0.004$       & $-0.006$      & $-0.040$      \\
                                   &                & $(0.014)$      & $(0.014)$      & $(0.020)$     & $(0.025)$     \\
prop. college-educated, 2010       & $0.143^{***}$  & $0.143^{***}$  & $0.123^{***}$  & $0.141$       & $0.101$       \\
                                   & $(0.012)$      & $(0.012)$      & $(0.012)$      & $(0.109)$     & $(0.199)$     \\
proportion male, 2010              & $-0.070^{*}$   & $-0.069^{*}$   & $-0.065^{*}$   & $-0.092$      & $-0.237$      \\
                                   & $(0.030)$      & $(0.030)$      & $(0.030)$      & $(0.177)$     & $(0.435)$     \\
proportion married, 2010           & $-0.085^{***}$ & $-0.086^{***}$ & $-0.108^{***}$ & $-0.356^{*}$  & $-0.493$      \\
                                   & $(0.013)$      & $(0.013)$      & $(0.013)$      & $(0.144)$     & $(0.280)$     \\
proportion white, 2010             & $-0.042^{***}$ & $-0.042^{***}$ & $-0.028^{***}$ & $-0.121$      & $-0.091$      \\
                                   & $(0.007)$      & $(0.007)$      & $(0.007)$      & $(0.075)$     & $(0.113)$     \\
median income (\$, logged)         & $-0.033^{***}$ & $-0.033^{***}$ & $-0.027^{***}$ & $0.063$       & $0.122$       \\
                                   & $(0.006)$      & $(0.006)$      & $(0.006)$      & $(0.050)$     & $(0.114)$     \\
median rent (\$, logged)           & $0.039^{***}$  & $0.039^{***}$  & $0.027^{***}$  & $-0.011$      & $-0.131$      \\
                                   & $(0.006)$      & $(0.006)$      & $(0.007)$      & $(0.058)$     & $(0.114)$     \\
pop. density (per sq. mi., logged) & $0.971^{***}$  & $0.971^{***}$  & $0.961^{***}$  & $0.941^{***}$ & $0.975^{***}$ \\
                                   & $(0.001)$      & $(0.001)$      & $(0.002)$      & $(0.012)$     & $(0.021)$     \\
\midrule
AIC                                & -10185.385     & -10183.429     & -10597.465     & -223.476      & -105.738      \\
BIC                                & -10118.254     & -10108.839     & -10515.416     & -186.708      & -85.485       \\
Log Likelihood                     & 5101.693       & 5101.714       & 5309.732       & 121.738       & 62.869        \\
Num. obs.                          & 12823          & 12823          & 12823          & 292           & 56            \\
Num. groups: city                  &                &                & 23             &               &               \\
Var: city (Intercept)              &                &                & 0.002          &               &               \\
Var: Residual                      &                &                & 0.025          &               &               \\
\bottomrule
\multicolumn{6}{l}{\scriptsize{$^{***}p<0.001$, $^{**}p<0.01$, $^*p<0.05$}}
\end{tabular}
\label{table:coefficients}
\end{center}
\end{table}
