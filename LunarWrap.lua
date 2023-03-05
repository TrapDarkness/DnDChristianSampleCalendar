function onInit()
	CalendarManager.registerLunarDayHandler("LunarWrap", getLunarDay); 
end


function getLunarDay(nYear, nMonth, nDay)
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