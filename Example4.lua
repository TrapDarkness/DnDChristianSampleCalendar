
--
-- This function sets up our custom calendar calling functions.  
--

function onInit()
-- Register the function to calculate the day of week for the MKgregorian calendar.  In the calender mod db.xml, you tell FG which function to use with the <lunardaycalc type="string">MKgregorian</lunardaycalc> tag.
	CalendarManager.registerLunarDayHandler("MKgregorian", calcMKGregorianLunarDay); 
-- Register the function to calculate additional days for a month in a leap year for the MKgregorian calendar.  In the calender mod db.xml, you tell FG which function to use with the <periodvarcalc type="string">MKgregorian</periodvarcalc> tag	
	CalendarManager.registerMonthVarHandler("MKgregorian", calcMKGregorianMonthVar);	
end

--
-- This function is the default Gregorian day of week calculation defined in CoreRPG.  It calculates the day of the week based on the year, month and day.  For a full explanation of the math involved, see https://cs.uwaterloo.ca/~alopez-o/math-faq/node73.html
--
function calcMKGregorianLunarDay(nYear, nMonth, nDay)
	local nZellerYear = nYear;
	local nZellerMonth = nMonth;
	if nMonth < 3 then
		nZellerYear = nZellerYear - 1;
		nZellerMonth = nZellerMonth + 12;
	end
	local nZellerDay = (nDay + math.floor(2.6*(nZellerMonth + 1)) + nZellerYear + math.floor(nZellerYear / 4) + (6*math.floor(nZellerYear / 100)) + math.floor(nZellerYear / 400)) % 7;
	if nZellerDay == 0 then
		return 7;
	end
	return nZellerDay;
end

--
-- This function modifies the calendar for leap years.  the value returned is the number of days added or removed.  The default shown below calculates the leap year logic for the gregorian calendar.  
-- The number of days to add can be positive or negative.  For example, if you return a -1 instead, February would have 27 days in a leap year instead of 29.  If doing this, make sure your logic for calculating the days of the week also reflects this logic.
--
function calcMKGregorianMonthVar(nYear, nMonth)
-- If the month is February
	if nMonth == 2 then
	-- get the current year
		local nYear = DB.getValue("calendar.current.year", 0);
		-- If the year is evenly divisible by 400, add 1 day to the month
		if (nYear % 400) == 0 then
			return 1;
		-- Otherwise, if the year is evenly divisible by 100, do not add any days to the month	
		elseif (nYear % 100) == 0 then
			return 0;
		-- Otherwise, if the year is evenly divisible by 4, add 1 day to the month.
		elseif (nYear % 4) == 0 then
			return 1;
		end
	end
-- default to not adding any days if none of the previous conditions match	
	return 0;
end
