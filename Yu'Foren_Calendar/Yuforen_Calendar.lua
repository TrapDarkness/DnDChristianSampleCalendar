
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
function calcMKYuforenLunarDay(nYear, nDay)
    local nAlexDay = (((nYear % 6) + (nDay % 6) - 1) % 6)   --(Year mod 6 + Day Mod 6 - 1) mod  6) = Day of the Week

	if nAlexDay == 0 then
		return 6;
	end
	return nAlexDay;
end