{smcl}
{* *! version 1.0 31 Oct 2018}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "googletrans##syntax"}{...}
{viewerjumpto "Description" "googletrans##description"}{...}
{viewerjumpto "Options" "googletrans##options"}{...}
{viewerjumpto "Remarks" "googletrans##remarks"}{...}
{viewerjumpto "Examples" "googletrans##examples"}{...}
{title:Title}
{phang}
{bf:googletrans}  {hline 2} {err: help file in progress}

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:googletrans}
varlist
[{help in}]
[if]
[{cmd:,}
{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt s:ource(string)}} Original language of the source{p_end}
{synopt:{opt t:arget(string)}} Target language{p_end}
{synopt:{opt replace}} reaplce existing file{p_end}
{synopt:{opt nouniformlang}}  Force detection of language{p_end}
{synopt:{opt just:detect}}     Just detect language. Does not translate{p_end}
{synopt:{opt nodots}} Suppress display of dots and progress.{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}
{pstd}
{cmd:googletrans} translate Unicode text from one language to another using the Google
translate API. It requires a Google API Key to work. Store your Google API Key in the global 
macro {it:google_api} so that. To get a Google API key go 
{browse "https://cloud.google.com/translate/docs/quickstart?csw=1":this page}

{marker options}{...}
{title:Options}
{dlgtab:Main}
{phang}
{opt s:ource(string)}  

{phang}
{opt t:arget(string)}  

{phang}
{opt replace}  

{phang}
{opt nouniformlang}  

{phang}
{opt just:detect}  

{phang}
{opt nodots}  


{marker examples}{...}
{title:Examples}

{phang} googletrans item, replace

{title:Author}
{p}

{p 4 4 4}R.Andres Castaneda, The World Bank{p_end}
{p 6 6 4}Email {browse "mailto:acastanedaa@worldbank.org":acastanedaa@worldbank.org}{p_end}

{help libjson} (if installed)   {stata ssc install libjson} (to install libjson)
