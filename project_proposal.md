Project Proposal
================

**Group members and UNIs**

Nichcha Subdee (ns3923) Mukta Patwari (msp2210) Medha Tulsyani (mt3866)
Juhi Mattekatt (jm5916) Maliha Safdar (ms7354)

## Project Title

AED Accessibility and Traffic Congestion in New York City

## Motivation for the project

Automated External Defibrillators (AEDs) are commonly used in
combination with CPR to create what the American Heart Association
describes as the “Chain of Survival” in individuals undergoing sudden
cardiac arrest (Page, 2011). Although AED accessibility is an integral
part of increasing the chances of survival, the constant traffic
congestion in New York City creates a disadvantage for residents with
the time it takes healthcare workers to travel to the scene.

Our motivation for this project is to understand how AED accessibility
corresponds with traffic congestion in New York City. Through a
combination of data on AED locations, traffic volume, and cardiovascular
disease, we hope to identify potential gaps in AED coverage in
high-traffic areas. Additionally, it may useful to analyze current data
to understand how the recently introduced congestion pricing may affect
AED accessibility/EMS response, and to examine differences between
traffic volume pre-pandemic, during the pandemic, and post-pandemic and
how this corresponds with AED accessibility.

## The intended final products

This project will include **three final deliverables**: EDA to summarize
**AED distribution and traffic volume trends** across boroughs from 2019
to 2024, **Inferential analysis** using ANOVA and correlation to compare
AED and traffic measures across boroughs and over time, and
**Dashboard** displaying AED locations, borough-level summaries, and
traffic trends

## The anticipated data sources (NYC Opendata)

**1. NYC Automated External Defibrillator (AED) Inventory**: Lists
registered AED locations in public facilities across NYC (DOHMH)

**2. Automated Traffic Volume Counts (2019–2024)**: Lists vehicle counts
by intersection, year, and borough (DOT)

**3. NYC Leading Causes of Death (through 2021)**: Annual cause-specific
mortality data aggregated citywide (DOHMH)

## Planned analyses/visualizations

### 1. EDA

- AED distribution and density across boroughs and years using
  visualizations like histograms, scatter plots, and line plots
  - Map AED distribution using leaflet and sf
- Traffic volume trends across boroughs and years using visualizations
  like boxplots and line plots
  - Mean and median for traffic volume across borough and year

### 2. Inferential Analysis

- ANOVA to compare mean AED density and mean traffic volume across
  boroughs
- Correlation to assess the relationship between AED density and mean
  traffic volume using Pearson’s correlation coefficient
- Derived Metric: Calculate the Traffic Burden Ratio (TBR) = total
  traffic volume ÷ total AED count per borough. Use TBR to highlight
  boroughs with high congestion and low AED coverage.

### 3. Dashboard

Further visualization where we will develop a flexdashboard that
contains:

- Borough-level AED map
- Traffic trends and summary plots
- AED–traffic comparison charts

## Coding Challenges

We anticipate that some AED location data will be missing or have
inaccurate coordinates. Furthermore, matching the specific point AED
locations to traffic intersections which cover a larger area will be a
challenge. When creating a dashboard with a large set of AED locations
and traffic intersections can lead to lazy loading. We can also
anticipate that ANOVA test will assume AED locations and traffic
intersections are same across all five boroughs. Overall, we will
prioritize efficient code and clear documentation to ensure
reproducibility.

## Planned Timeline

- Nov 7: Submit Proposal
- Nov 10-14: Finalize with teaching team
- Nov 17-21: Start data cleaning, meet with team to delegate parts of
  data cleaning
- Nov 24-28: Create website. Delegate planned analysis/visualizations
  and 3 final deliverables. Start working on them and aim to finalize
  first draft by end of week.
- Dec 1-5: Finalize visualizations, website, deliverables and report for
  submission. Record the screencast and upload on website
- Dec 6: Submit website, deliverables, screencast & report by Dec 6 at
  11:59 pm. Finish peer assessment by Dec 6 at 11:59 pm.

## References

<https://pmc.ncbi.nlm.nih.gov/articles/PMC3116356/>
