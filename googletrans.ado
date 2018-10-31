/*====================================================================
project:       Translate strings using Google Translate
Author:        Andres Castaneda 
Dependencies:  The World Bank
----------------------------------------------------------------------
Creation Date:     5 Apr 2017 - 08:34:53
Modification Date: 15 Nov 2017   
Do-file version:    02
References:          
Output:             
====================================================================*/

/*====================================================================
0: Program set up
====================================================================*/
version 14
cap program drop googletrans
program define googletrans, rclass

syntax varlist [in] [if], ///
[                         ///
Source(string)            ///
Target(string)            ///		
replace                   ///
noUNIFORMLANG             /// if data does not have uniform language
JUSTdetect                /// just detect language. No translate
noDOTS                    /// borrowed from S. Kolenikov
]

marksample touse


/*====================================================================
1: Consistency checks
====================================================================*/

qui  {
	
	cap confirm file "c:\ado\plus\l\libjson.mlib"
	if (_rc) ssc install libjson
	
	*--------------------1.1: defaults
	
	if ("`target'" == "") local target "en"
	
	if ("${google_api}" != "") local api "${google_api}"
	else {
		noi disp as err "you need a valid Google API to use this command"
		error
	}
	local http "https://translation.googleapis.com/language/translate/v2"
	
	* cap keep `if' `in'
	
	*--------------------1.2:format
	** check the variables is string 
	tempvar nobs
	tempname S_tfg
	gen `nobs' = _n
	
	_pctile `nobs', n(10)
	foreach cut of numlist 1/9 {
		local p`cut' = r(r`cut')
	}
	sum `nobs', meanonly
	local p10 = r(max)
	
	**  No. of Obs.
	count
	local n = r(N)
	
	
	/*====================================================================
	2: creation of variables
	====================================================================*/
	
	
	foreach var of varlist `varlist' {
		
		*--------------------2.1: temporal variables and preparation
		tempvar t2t  
		sort `var'
		
		* Check output varlist	
		if ("`justdetect'" == "") {
			cap confirm new var `var'_`target'
			if (_rc) {
				if ("`replace'" == "") {
					noi disp as error "Variable `var'_`target' already exists. Use option replace"
					error
				}
				else drop `var'_`target'
			}
			gen `var'_`target' = ""
		}
		
		*--------------------2.2: Text to Translate
		clonevar `t2t' = `var'
		replace `t2t' = lower(`t2t')
		
		*  eliminate unnecessary characters
		local characters "9 10 13"
		foreach char of local characters {
			replace `t2t' = subinstr(`t2t', `"`=char(`char')'"' , " ",.) 
		}
		
		
		* google characters and double blanks
		replace `t2t' = subinstr(`t2t', char(96) , "",.)
		replace `t2t' = subinstr(`t2t', char(34) , "",.)
		replace `t2t' = subinstr(`t2t', char(39) , "",.)
		
		*--------------------2.3: Original Translated Text
		* gen strL `ott' = ""		
		
		if ("`justdetect'" == "") {
			noi disp in y "Translating variable " in g "`var'." _c
			if ("`dots'" == "") noi disp in y " Each dot represents " ///
			"one observation. Please wait" _n
			local i1 = 1
		}
		else {
			local i1 = round(runiform(1,_N))
		}
		
		forvalues i = `i1'(1)`n' {
			local t2g = `t2t'[`i']  // Text to google
			mata: st_local("t2g", libjson::urlencode(st_local("t2g")))
			
			* Detect original language. 
			if ("`source'" == "") {
				tempname detect
				scalar `detect' = fileread(`"`http'/detect?key=`api'&q=`t2g'"')
				if regexm(`detect', `"^.*"language": "([a-zA-Z\-]+)""') ///
				local source = regexs(1)
				noi disp as txt "language detected in variable `var' in obs `i': " ///
				as result "`source'"
				return local source_`var' "`source'"
			}
			
			if ("`justdetect'" == "justdetect") {
				local source ""
				continue, break
			}
			
			** text from Google
			scalar `S_tfg' = fileread(`"`http'?key=`api'&source=`source'&target=`target'&q=`t2g'"') 
			
			if ("`uniformlang'" != "") local source "" // check source langauge again 
			
			local characters "9 10 13 91 93 123 125 34"
			foreach char of local characters {
				scalar  `S_tfg' = subinstr(`S_tfg', `"`=char(`char')'"' , " ",.) 
			}
			
			
			while regexm(`S_tfg', "\\[Uu][0-9]+[a-zA-z]") {				
				scalar `S_tfg' =  regexr(`S_tfg', "\\[Uu][0-9]+[a-zA-z]", " ")			
			}
			
			scalar `S_tfg' = ltrim(rtrim(itrim(`S_tfg')))
			scalar `S_tfg' =  regexr(`S_tfg', `"^.*translatedText : "', "")		
			
			*--------------------2.4: Final Translated Text
			replace `var'_`target' = `S_tfg' in `i'
			
			**  Errors 
			if regexm(`S_tfg', `"error"') | (`S_tfg' == "") {
				noi disp in y ". text in obs `i' could not be translated."
			}
			
			** Displayed dots
			if ("`dots'" == "") {
				noi disp in w "." _c
				foreach p of numlist 1/10 {
					if (`i'>=`p`p'' & (`i'-1)<`p`p'') {
						noi disp in y _n "`p'0% done! " _n
					}
				}
			} // in case dots are not desired
			
		} //  end of loop for each obs
		
		if ("`justdetect'" == "justdetect") continue
		
		count if `var'_`target' == ""
		if r(N) != 0 {
			noi disp in red "Items that could not be translated"
			noi tab `var' if `var'_`target' == ""
		}
		
		}  // end of varlist loop
	}  // end of qui
	
	
	end
	
	exit
	/* End of do-file */
	
	><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
	
	Notes:
	1.
	2.
	3.
	
	
	Version Control:
	
	
	txttool netplot datanet strdist matchit ngram strgroup txttool	
