
**THIS SITE IS UNDER CONSTRUCTION!**

Stuff is still moving around and being updated intermittently. Once complete, this website will be formally announced on social media.

*Last updated: 11 July 2021*

# Intro

The aim of the tracker is to archive the code that was used to create daily COVID-19 related maps and other figures on Twitter for Austria. Second is to provide some history and context to the whole data sharing process by Austrian authorities, what could have been done differently, and what can still be done.



# Files

The folder structure is as follows:

* `dofiles`: contain the Stata scripts to generate the figures
* `figures`: contains the visualizations
* `GIS`:     contains the spatial files
* `master`:  contains the final data files
* `raw`:     contains the raw data
* `screenshots`: contains some screenshots to display information here
* `temp`:    contains the temporary intermediate files that convert raw data to master files.


# Visualizations

The dofiles create the following figures:

## Line graphs

### Main figure
<img src="./figures/AT_cases_stringency.png" height="300" title="Main graph for cases and stringency">

### Hospitalization and intensive care
<img src="./figures/covid19_austria_tests2.png" height="300" title="Hospitalization and intensive case">

### Mobility trends
<img src="./figures/covid19_mobility_stayathome.png" height="200" title="Stay at home"><img src="./figures/covid19_mobility_workplace.png" height="200" title="Workplace">
<img src="./figures/covid19_mobility_parks.png" height="200" title="Parks"><img src="./figures/covid19_mobility_retail.png" height="200" title="Retail">

## Maps
<img src="./figures/covid19_austria_cases.png" height="200" title="Cases"><img src="./figures/covid19_austria_deaths.png" height="200" title="Deaths">
<img src="./figures/covid19_austria_active.png" height="200" title="Active cases"><img src="./figures/covid19_austria_active_pop.png" height="200" title="Active cases per 10k pop">



# History

This repository takes a look at the creation of Austria's COVID-19 tracker which started off as a bunch of tweets. This was started mostly due to the fact that Austria went into a lockdown phase in March 2020 and there was little information out there. This eventually expanded into a full-fledged project that is now the [COVID-19 Regional Tracker](https://asjadnaqvi.github.io/COVID19-European-Regional-Tracker/).

While Austria's data is now published regularly on the [AGES website](https://covid19-dashboard.ages.at/). This was not the case in the beginning of the pandemic. The data was original published as a table on the original https://info.gesundheitsministerium.at/ website (now completely redesigned): 

<img src="./screenshots/dasboard_V1.jpg" height="300" title="Original dashboard">

This had to be scraped daily. Additionally the website only had the map of Austrian provinces, even though the website provided details for Bezirk-level information. So all of this started with copying down this information around the middle of March 2020 to create Bezirk level maps. Since I was already working on Bezirk data for another project where we had collected other Bezirk-level data, including administrative boundaries from [Statistik Austria](https://statistik.at/web_de/statistiken/index.html), the setup cost for doing daily COVID-19 Bezirk-level maps was fairly low. 

## First stage: March to October 2020

The process of digitizing the data on the website and converting it into a machine-readable form was done daily from March till October 2020. After October 2020, the website switched to AGES which also released all the old statistics in a CSV file. But before this information became public, the original website was updated at irregular intervals, sometimes hourly (mostly in the mornings) and sometimes every two to three hours (mostly in the evenings). This was the beginning of the pandemic and testing was limited. This meant that the information was added on the website as it came in. 


My daily task was to copy the data after the 11 am update. This was done manually for quite some time for two reasons. First, the underlying data structure was modified a few times. For example information for Vienna stopped being published at the Bezirk level (Vienna has 23 districts) and to date are only provided at the city level. While no official explanation has been given to why this is the case, the assumption here is that Vienna Bezirk-level information is considered too fine of a disaggregation for the authorities. 

Here is a map of the last data point for Vienna:

<img src="./screenshots/WIEN_covid19_reported_25_Mar_2020.png" height="300" title="Vienna breakdown">


Second, there were other changes made in the databases where region names were shuffled around. The daily manual activity helped keep these changes in check since we had no Bezirk idenfiers to ensure merges were accurately done over time. 



## Second stage: October 2020 to June 2021

The second phase of the tracker, where the data switched to the AGES website, was fairly straightforward: automate the data download from the website, process the files, and make the maps and other figures. 

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">A major change in the <a href="https://twitter.com/hashtag/Austrian?src=hash&amp;ref_src=twsrc%5Etfw">#Austrian</a> <a href="https://twitter.com/hashtag/COVID19?src=hash&amp;ref_src=twsrc%5Etfw">#COVID19</a> dashboard that was recently taken over by <a href="https://twitter.com/hashtag/AGES?src=hash&amp;ref_src=twsrc%5Etfw">#AGES</a>. Data is no longer shown at the district level but complete time series is now available for cases and deaths at the district level. Could have released info on gender/age as well. <a href="https://twitter.com/hashtag/moredata?src=hash&amp;ref_src=twsrc%5Etfw">#moredata</a> <a href="https://t.co/irWZePdmId">pic.twitter.com/irWZePdmId</a></p>&mdash; Asjad Naqvi (@AsjadNaqvi) <a href="https://twitter.com/AsjadNaqvi/status/1314132730901336064?ref_src=twsrc%5Etfw">October 8, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

By this time several people, most notably [Eric Neuwirth](https://just-the-covid-facts.neuwirth.priv.at/), were making maps and figures daily in German to cater to the local audience. All local newspapers had also set up their own interactive visualizations. I had somewhat captured the international/expat community and my visualizations were also featured here and there in local newspapers. Most notably Metropole picked these up a couple of times. I also recieved messages from random people, mostly internationals living in Vienna or parents of kids studying here. 

The data switch to AGES was not without hiccups. It was not clear when and how the information was updated. This was also the time when testing was scaling up, and information was coming in rapidly. This also had an impact on the visualizations. Figures changed considerably from one hour to the next, with data also being back corrected, probably based on when the test samples were collected. This also caused considerable confusion since different numbers were popping up at the same time. After some weeks, AGES (rightfully so) changed its strategy and started publishing data for the day earlier and with one update at midnight to ensure the numbers are consistent. This strategy was already fairly standard practice for other larger countries like Germany and France which still have one or two day lags by back-corrections are rarely.

This second phase was more experimental with testing out new visualizations, color schemes, and new graph types. At this point, there was little or no novelty in the daily updates. Most media outlets were reporting from their own platforms. I was personally more focused on finishing up the [European COVID-19 regional tracker](https://asjadnaqvi.github.io/COVID19-European-Regional-Tracker/) which also linked to other NUTS-level projects I was involved in. 

By December 2020, information was fairly standardized, and the biggest concern was vaccine roll-outs and the new virus variants. Austria, like other countries was eager to come put of the lock down, especially after the massive losses of not having a ski season.


# Useful links

OTHER PROJECTS FOCUSING ON AUSTRIA HERE.



# Archive of tweets

Links to my Tweets 

## Plain lines and maps

<blockquote class="twitter-tweet"><p lang="en" dir="ltr"><a href="https://twitter.com/hashtag/COVID19?src=hash&amp;ref_src=twsrc%5Etfw">#COVID19</a> update for <a href="https://twitter.com/hashtag/Austria?src=hash&amp;ref_src=twsrc%5Etfw">#Austria</a>. So relaxing the measures have led to speculations abt increase in growth of cases. The peak was crossed around 30th March. Policies were relaxed around 10 April. There is some upward bending of the curves. We will see what the data says next week. <a href="https://t.co/4hahSFbzeH">pic.twitter.com/4hahSFbzeH</a></p>&mdash; Asjad Naqvi (@AsjadNaqvi) <a href="https://twitter.com/AsjadNaqvi/status/1254425679694835713?ref_src=twsrc%5Etfw">April 26, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Here are new cases by day of the week. Strong weekend biases in April May and June. Also not the dip in the middle of the week.<br><br>July seems to be the other way around. More cases are being reported on Sundays now.<br><br>Dropped March since it was pretty chaotic. <a href="https://t.co/1G6YTJt5FA">pic.twitter.com/1G6YTJt5FA</a></p>&mdash; Asjad Naqvi (@AsjadNaqvi) <a href="https://twitter.com/AsjadNaqvi/status/1282624077937729539?ref_src=twsrc%5Etfw">July 13, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet"><p lang="en" dir="ltr"><a href="https://twitter.com/hashtag/COVID19?src=hash&amp;ref_src=twsrc%5Etfw">#COVID19</a> update for <a href="https://twitter.com/hashtag/Austria?src=hash&amp;ref_src=twsrc%5Etfw">#Austria</a>. The graphs are self explanatory but a new color scheme is here! <a href="https://t.co/4ukLlMYZNs">pic.twitter.com/4ukLlMYZNs</a></p>&mdash; Asjad Naqvi (@AsjadNaqvi) <a href="https://twitter.com/AsjadNaqvi/status/1300380988187594753?ref_src=twsrc%5Etfw">August 31, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">A <a href="https://twitter.com/hashtag/COVID19?src=hash&amp;ref_src=twsrc%5Etfw">#COVID19</a> update for <a href="https://twitter.com/hashtag/Austria?src=hash&amp;ref_src=twsrc%5Etfw">#Austria</a>. The official website <a href="https://t.co/YAxEwxF9zV">https://t.co/YAxEwxF9zV</a> now shows when the numbers are updated for &quot;today&quot; and it seems like at random intervals. So to ensure consistency, I will only show figures from &quot;yesterday&quot; which are finalized at 12 midnight. <a href="https://t.co/KccmBVEPne">pic.twitter.com/KccmBVEPne</a></p>&mdash; Asjad Naqvi (@AsjadNaqvi) <a href="https://twitter.com/AsjadNaqvi/status/1318969461899218946?ref_src=twsrc%5Etfw">October 21, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">A <a href="https://twitter.com/hashtag/COVID19?src=hash&amp;ref_src=twsrc%5Etfw">#COVID19</a> update for <a href="https://twitter.com/hashtag/Austria?src=hash&amp;ref_src=twsrc%5Etfw">#Austria</a>. The official website <a href="https://t.co/YAxEwxF9zV">https://t.co/YAxEwxF9zV</a> now shows when the numbers are updated for &quot;today&quot; and it seems like at random intervals. So to ensure consistency, I will only show figures from &quot;yesterday&quot; which are finalized at 12 midnight. <a href="https://t.co/KccmBVEPne">pic.twitter.com/KccmBVEPne</a></p>&mdash; Asjad Naqvi (@AsjadNaqvi) <a href="https://twitter.com/AsjadNaqvi/status/1318969461899218946?ref_src=twsrc%5Etfw">October 21, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Today a <a href="https://twitter.com/hashtag/joyplot?src=hash&amp;ref_src=twsrc%5Etfw">#joyplot</a> view of <a href="https://twitter.com/hashtag/COVID19?src=hash&amp;ref_src=twsrc%5Etfw">#COVID19</a> in <a href="https://twitter.com/hashtag/Austria?src=hash&amp;ref_src=twsrc%5Etfw">#Austria</a>: <a href="https://twitter.com/hashtag/sunsetovervienna?src=hash&amp;ref_src=twsrc%5Etfw">#sunsetovervienna</a> graph and the <a href="https://twitter.com/hashtag/deathvalley?src=hash&amp;ref_src=twsrc%5Etfw">#deathvalley</a> graph. <a href="https://t.co/AHZdS7Vyif">pic.twitter.com/AHZdS7Vyif</a></p>&mdash; Asjad Naqvi (@AsjadNaqvi) <a href="https://twitter.com/AsjadNaqvi/status/1326834241481617409?ref_src=twsrc%5Etfw">November 12, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Today a <a href="https://twitter.com/hashtag/joyplot?src=hash&amp;ref_src=twsrc%5Etfw">#joyplot</a> view of <a href="https://twitter.com/hashtag/COVID19?src=hash&amp;ref_src=twsrc%5Etfw">#COVID19</a> in <a href="https://twitter.com/hashtag/Austria?src=hash&amp;ref_src=twsrc%5Etfw">#Austria</a>: <a href="https://twitter.com/hashtag/sunsetovervienna?src=hash&amp;ref_src=twsrc%5Etfw">#sunsetovervienna</a> graph and the <a href="https://twitter.com/hashtag/deathvalley?src=hash&amp;ref_src=twsrc%5Etfw">#deathvalley</a> graph. <a href="https://t.co/AHZdS7Vyif">pic.twitter.com/AHZdS7Vyif</a></p>&mdash; Asjad Naqvi (@AsjadNaqvi) <a href="https://twitter.com/AsjadNaqvi/status/1326834241481617409?ref_src=twsrc%5Etfw">November 12, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## Doubling time graphs

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Daily <a href="https://twitter.com/hashtag/COVID19?src=hash&amp;ref_src=twsrc%5Etfw">#COVID19</a> update for Austria. some additional graphs. Here we see the slowing down of reported cases across all the <a href="https://twitter.com/hashtag/Bundesl%C3%A4nder?src=hash&amp;ref_src=twsrc%5Etfw">#Bundesländer</a>. The doubling time has fallen to more than 7 days for some provinces. The target is 14 days to avoid going over capacity in hospitals. <a href="https://t.co/YnroQrOEsK">pic.twitter.com/YnroQrOEsK</a></p>&mdash; Asjad Naqvi (@AsjadNaqvi) <a href="https://twitter.com/AsjadNaqvi/status/1246011022739148802?ref_src=twsrc%5Etfw">April 3, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet"><p lang="en" dir="ltr"><a href="https://twitter.com/hashtag/Doublingtime?src=hash&amp;ref_src=twsrc%5Etfw">#Doublingtime</a> for <a href="https://twitter.com/hashtag/COVID19?src=hash&amp;ref_src=twsrc%5Etfw">#COVID19</a> for <a href="https://twitter.com/hashtag/Austria?src=hash&amp;ref_src=twsrc%5Etfw">#Austria</a>. The graphs have been completely redone to include 10-day rolling averages. Got rid of log scales to distinguish between provinces. Doubling time given in brackets. Policies given by vertical lines. More on this below 1/n <a href="https://t.co/l45gfTzwKt">pic.twitter.com/l45gfTzwKt</a></p>&mdash; Asjad Naqvi (@AsjadNaqvi) <a href="https://twitter.com/AsjadNaqvi/status/1248546184437825536?ref_src=twsrc%5Etfw">April 10, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## Hospitalization rates

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">A random note on <a href="https://twitter.com/hashtag/COVID19?src=hash&amp;ref_src=twsrc%5Etfw">#COVID19</a> tests, infection rates, and death rates in <a href="https://twitter.com/hashtag/Austria?src=hash&amp;ref_src=twsrc%5Etfw">#Austria</a>. Tests (grey line) in all provinces ⬆️, infected/tests (black line) now also going ⬆️. Deaths/infected (red line) is going ⬇️. There still might be lag in deaths. Will be clearer in the next 2 weeks. <a href="https://t.co/rvnUBt05RT">pic.twitter.com/rvnUBt05RT</a></p>&mdash; Asjad Naqvi (@AsjadNaqvi) <a href="https://twitter.com/AsjadNaqvi/status/1313533630929657856?ref_src=twsrc%5Etfw">October 6, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


## Excess deaths


<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Some thoughts on attributing excess weekly deaths to <a href="https://twitter.com/hashtag/COVID19?src=hash&amp;ref_src=twsrc%5Etfw">#COVID19</a>. Here is the data for <a href="https://twitter.com/hashtag/Austria?src=hash&amp;ref_src=twsrc%5Etfw">#Austria</a> published on Eurostat. It has been reduced to compare 65+ and 0-64 2020 trends with 2015-2019. One can go further back as well. 1/n... <a href="https://t.co/4P8KtNFX7P">pic.twitter.com/4P8KtNFX7P</a></p>&mdash; Asjad Naqvi (@AsjadNaqvi) <a href="https://twitter.com/AsjadNaqvi/status/1267789428078108676?ref_src=twsrc%5Etfw">June 2, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


## Stringency index

<blockquote class="twitter-tweet"><p lang="en" dir="ltr"><a href="https://twitter.com/hashtag/COVID19?src=hash&amp;ref_src=twsrc%5Etfw">#COVID19</a> update for <a href="https://twitter.com/hashtag/Austria?src=hash&amp;ref_src=twsrc%5Etfw">#Austria</a>. If we look at the gr. of reported cases vs policy stringency index created by <a href="https://twitter.com/BlavatnikSchool?ref_src=twsrc%5Etfw">@BlavatnikSchool</a> <a href="https://twitter.com/UniofOxford?ref_src=twsrc%5Etfw">@UniofOxford</a>, then one can see how the increase in measures resulted in a decrease in growth rates of reported cases. More on this later! <a href="https://t.co/i7s43a5srU">pic.twitter.com/i7s43a5srU</a></p>&mdash; Asjad Naqvi (@AsjadNaqvi) <a href="https://twitter.com/AsjadNaqvi/status/1247100519816052739?ref_src=twsrc%5Etfw">April 6, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


## Google mobility trends

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">A late night reflection on <a href="https://twitter.com/hashtag/COVID19?src=hash&amp;ref_src=twsrc%5Etfw">#COVID19</a> situation in <a href="https://twitter.com/hashtag/Austria?src=hash&amp;ref_src=twsrc%5Etfw">#Austria</a>. Google mobility trends now provides data at the province level as well. Here we see how much was done in the first wave. Roughly 25% of the pop stayed home as compared to less than 10% now. Provinces also vary. <a href="https://t.co/cNnyGaTFGM">pic.twitter.com/cNnyGaTFGM</a></p>&mdash; Asjad Naqvi (@AsjadNaqvi) <a href="https://twitter.com/AsjadNaqvi/status/1325565527029321731?ref_src=twsrc%5Etfw">November 8, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>



## Ridge-line plots

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Today a <a href="https://twitter.com/hashtag/joyplot?src=hash&amp;ref_src=twsrc%5Etfw">#joyplot</a> view of <a href="https://twitter.com/hashtag/COVID19?src=hash&amp;ref_src=twsrc%5Etfw">#COVID19</a> in <a href="https://twitter.com/hashtag/Austria?src=hash&amp;ref_src=twsrc%5Etfw">#Austria</a>: <a href="https://twitter.com/hashtag/sunsetovervienna?src=hash&amp;ref_src=twsrc%5Etfw">#sunsetovervienna</a> graph and the <a href="https://twitter.com/hashtag/deathvalley?src=hash&amp;ref_src=twsrc%5Etfw">#deathvalley</a> graph. <a href="https://t.co/AHZdS7Vyif">pic.twitter.com/AHZdS7Vyif</a></p>&mdash; Asjad Naqvi (@AsjadNaqvi) <a href="https://twitter.com/AsjadNaqvi/status/1326834241481617409?ref_src=twsrc%5Etfw">November 12, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>






