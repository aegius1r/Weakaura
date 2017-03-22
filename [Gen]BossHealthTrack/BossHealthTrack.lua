boss health track

-- catch ENCOUNTER_START and get start time
--		 ENCOUNTER_END   and get combat total time

function()
	if UnitExists(boss1) then
		local health = UnitHealth(boss1)
		local max_health = UnitHealthMax(boss1)
		if health/max_health < 0.3 then
			return true
		end
	end
end