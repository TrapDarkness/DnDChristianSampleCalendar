
--
-- This function sets up our custom calendar calling functions.  
--

function onInit()
-- Register the function to calculate the day of week for the MKgregorian calendar.  In the calender mod db.xml, you tell FG which function to use with the <lunardaycalc type="string">MKgregorian</lunardaycalc> tag.
	CalendarManager.registerLunarDayHandler("MKyuforen", calcMKYuforenLunarDay); 
end

--
-- This function is the default Gregorian day of week calculation defined in CoreRPG.  It calculates the day of the week based on the year, month and day.  For a full explanation of the math involved, see https://cs.uwaterloo.ca/~alopez-o/math-faq/node73.html
--
function calcMKYuforenLunarDay(nYear, nMonth, nDay)
    -- local nAlexDay = (((nYear % 6) + (nDay % 6) - 1) % 6)   --(Year mod 6 + Day Mod 6 - 1) mod  6) = Day of the Week
	-- stores the total number of days in a year
	local tDays=0;
	
	-- get the total number of days in a week
	local nWeekdays = DB.getChildCount("calendar.data.lunarweek");

	-- iterate through the months of the year and calculate the total number of days in a year
	for mMonth=1,DB.getChildCount("calendar.data.periods"),1 do
		local nDays = DB.getValue("calendar.data.periods.period" .. mMonth .. ".days", 0);
		tDays = tDays + nDays;
	end
	-- calculate the total number of days from year 0 to first day of the current year
	local rYear = nYear * tDays;
	local rMonth = nMonth-1;
	local tmDays=0;

	for mMonth=1,rMonth,1 do
		local nDays = DB.getValue("calendar.data.periods.period" .. mMonth .. ".days", 0);
		tmDays = tmDays + nDays;
	end

	local rDay = (rYear + tmDays + nDay) % nWeekdays;

	if rDay == 0 then
		return nWeekdays;
	end

	return rDay
end