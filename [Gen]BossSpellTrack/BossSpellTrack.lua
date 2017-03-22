-------------------------------------
------
------ BossSpellTrack-Button
------
-------------------------------------

--Trigger
function(event, ...)
	if event =="PLAYER_ENTERING_WORLD" then 
		local r = WeakAuras.regions[aura_env.id].region
		local f = CreateFrame("BUTTON", nil, r, "SecureHandlerClickTemplate")
		f:SetAllPoints()
		f:SetScript("OnClick", function()
			if (aura_env.enable == nil or aura_env.enable == false) then
				aura_env.enable = true
			else
				aura_env.enable = false
			end
			WeakAuras.ScanEvents("BST_PRESSED", aura_env.enable)
		end)
		f:SetScript("OnEnter",function()
			GameTooltip:Hide()
			GameTooltip:SetOwner(f,"ANCHOR_RIGHT")
			GameTooltip:SetText("BossSpellTrack: Print message whenever boss casts a spell if enabled.")
			GameTooltip:Show()
		end)
		f:SetScript("OnLeave",function()
			GameTooltip:Hide()
		end)
		return true
	end
end

--%c
function()
	if aura_env.enable then
		return "|cff00aa00".."Enabled".."|r"
	else
		return "|cffaa0000".."Disabled".."|r"
	end
end

-------------------------------------
------
------ BossSpellTrack-Main
------
-------------------------------------

-- Trigger 1: to catch BST_PRESSED
function(event, enable, ...)
	aura_env.enable = enable
	print("[debug] aura_env.enable = "..aura_env.enable)	-- debug
	return true
end

-- Trigger 2: to catch COMBAT_LOG_EVENT_UNFILTERED and print spell message
function(event, timestamp, message, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	if aura_env.enable then
		if message == "SPELL_CAST_SUCCESS" then
			local spellId, spellName, spellSchool, auraType = ...
			local bosses = {"boss1","boss2","boss3","boss4","boss5"}
			for i = 1, #bosses do
				if (UnitExists(bosses[i]) and sourceName == (UnitName(bosses[i]))) then
					if (sourceName and spellName) then
						local duration = math.floor(10*(GetTime() - aura_env.starttime))/10
						print("|cffff6600["..duration.."] "..sourceName.." : "..spellName.."|r")
						return true
					end
				end
			end
		end
	end
end

-- Trigger 3: to catch ENCOUNTER_START and get start time
--					   ENCOUNTER_END   and get combat total time

function(event,...)
	if aura_env.enable then
		if event == "ENCOUNTER_START" then
			aura_env.starttime = GetTime()
			print("|cffff6600".."BossSpellTrack: Encounter started".."|r")
			return true
		elseif event == "ENCOUNTER_END" then
			local encounterID, encounterName, difficultyID, raidSize, endStatus = ...
			local duration = math.floor(10*(GetTime() - aura_env.starttime))/10
			print("|cffff6600".."BossSpellTrack: Encounter "..endStatus.." after "..dutation.." seconds".."|r")
			return true
		end
	end
end

-- backup: old aura string(20170321)
dW05taGivXLuLkzuiLofsXQqsPmlvf3crPDPc)ssH0WurDmvvwMkINHOyAskDnvPSnjsFdKKXPQkNtvvToKuCpvjhejzHqrpuIQjkPYfHkBufPpcfAKsksNeKyLimtOu3uIODcIFkPQHkrzPqjpfyQq6QQsvBfjLQVkPGZcsQ3QkvCxjf1Er9xezWIdlvlgK6XuYKLKlt1MPuFgjgTQsNwkRgjL8AOGzdXTLWUP43GA4ivlxPEUsMUIRRsBhQ67skuJxIW5ruTEjfX7vLk18rs19Lui2pz(hJYGoJYddwm4KdYC8gdkyqfdQyuguI6TTx(WqoF8FT)rMsR9K3GQ)(DYBmy7uAWguYP7mGYg(sNbDRPH3r3nku8DjHRCgcz)DMbEjO3nvEfJjdQAlQ11ynn8od6iimOvXG3bJUPMXeETa0Dee0D3cdmG86TTx(Wq()O2)(9wPqfz(7K)(DYBmWClq3nku89IH8JblhXUm4MzyaM1JIwFjXg3POmabUxXOmy6iUzyuguCrMgJYdpmOQzB3SUid5mkdkUitJr5HhgS7woJYGIlY0yuE4Hb2DRPbByuguCrMgJYdpmGoE6thXndJYGIlY0yuE4HbByeNrzqXfzAmkp8WG7YjzH0xlgAE4Hbwmkd5hJYGRz2nku8nJYaR7AGlyG91ynnydT0icfffLTp3TrXUJSCr4MkricricricricEyq3AA4D0DJcfFxs4kNHq2FNzWSBuO4BgLbd50DgyDxdCbdSURbUGb2xJ10Gn064DZ8r544GgrOOOO0SvC8UzuE96PmSPcQXHfjCqqXHfuGGrs1q9yHDDpkZx3OicffffffffeyRoIY(vn4Dmq1D3xhBNsd2SEN(D3j5g8hTQA(y7uAWgrOOOOOOOOGaB1ruSFv(27JF6Ux40(G57rrRhYZhftd5JY(JYdWTUBVM2nvi(UCKMfgq9c6i9XFOrekkkkkkkk2udWhQqqkdUzMfT0icffffffffBQb4dWA3Op0(uVPCKMfgE(OyFnwtd2qlnIqrrrrrrrrrrrrrrrPg8ogO6U7RdGv3GdVBMfTpycqjvgw4aaC19qJiuuuuuuuuCtfnIqrrrrrrrrekkkkkkkkBFUBJYSVUiuuuuCtLiCtfdSURbUG0qoDNboE3mmWX7MzXGYWMkOghwKWbbfhwqbcgjvd1Jf21XaR7AGli9Tv5mW6Ug4cEyWxVr57WqQ9mdqG7vmkdUlNKXX7BgAgmDe3mmkdkUitJr5Hhgu1STBwxKHCgLbfxKPXO8WddUlNuZqzdFPZyYa64PpDe3mmkdkUitJr5HhgSHrCgLbfxKPXO8WddS7wtd2WOmO4ImngLhEyWUB5mkdkUitJr5HhEyW2P0GnOKt3zqZc2WGwfdWeETa0Dee0D3cdKfZ7mWggu1wuRRXAA4Dg0rqyqjQ32E5ddHSV9)5Js)V0t(7)ZLEYBmWClq3nku89IH8Jb14w18LHu7zgqE922lF4tHQ)iZ)V9)F1sMslfQ(V0)QLTjBT1YGQ2IosNCOybByi)itP)GQt4HHCcJYGQ2IosNCuVeddExwmW6Ug4cuVeddSVgRPbBOLgrOOOO0Sv63DNKBWF4Mo0i(RxZ(6kZx3icfffffffLTp3Tr5H6w22Np37Np)CC8GdcvyInUNJJhQVFeHIIIIJSCrOOOOOOOOS95Unkpu3Y2U3pF(85NJJN6GcGkmXg3ZXXd13pIqrrrXnvIWnvmOBnn8o6UrHIVljCLZqi7VZmWg2mNI0PSyq9VhfBOabhdMDJcfFZOmyiNUZaR7AGlyG1DnWfK(2QCgmTcVIbw31axWa7RXAAWgAD8Uz(OCCCqJiuuuuA2koE3mkVE9GjaLuzyHdaWv3JY81nIqrrrrrrrPzRqB)U7KCd(d30HgXF9Y0quG3k97UtYn4pCthAe)1l7oYYPrz(6grOOOOOOOOOOOO0V7oj3G)WnDOr8xZ(6IqrrrrrrrXrwUiuuuuuuuuuuuu63DNKBWF4Mo0i(l7oYYfHIIIIIIIIBQeHIIIIIIIY2N72Om7Rlcffff3ujc3uXahVBMfdWeGsQmSWba4QJbw31axqAiNUZahVBgEyWAAwyG86U7(0Gnm0m4R3O8D4t)7TAp)7Ttk9)))7hz(7V)yBYw7)mabUxXOm4UCsghVVzOzW0rCZWOmO4ImngLhEyqvZ2UzDrgYzuguCrMgJYdpm4UCsndLn8LoJjdS7wtd2WOmO4ImngLhEyaD80NoIBggLbfxKPXO8Wdd2DlNrzqXfzAmkp8WGnmIZOmO4ImngLhE4Hb2WMb0Qjod53BmOQTOJ0jhmDlmSyW7AXGUX6l8(0DVWpD3lCgudEhduD39f1Gj8AbO7iiO7UfgilM3zGnmy7uAWguYP7my8smmOQTOwxJ10W7mOBiNblhXUm4Mzyq54GGIdlg0mTHKfCbDeF8kgYpg0SGnmMmynDlmSkh2m9MPWnddGceauQdhdQjWWfmKZmOFhygtg0RQAtd20rin7gfk(EXOmKFmkdMDJcfFZOmyiNUZaR7AGlyW144DZWG(DGzq1D3NgSHbNzGJ3nddk)BFukPVwDkodwxOD8UzkB72TsWaqz4WgBgyDxdCbdSVgRPbBO1X7M5JY0k810lO)rPWxRof)JY3wLxEFn((JYc(UTCm(EOu3hLf8DB5q6f(hLf8DB5NI0PS(OSGVBlhRER6uKoL1hLkFny89qPUpkv(AG0l8pkv(AofPtz9rPYxdw9w1PiDkRpkhhh0icfffLMTs)U7KCd(d30HgXF9A2xxz(6grOOOOOOOO0Svk81QtXvE9s5bugoSXMu5ubqjbEF5LJdaEuMVUrrrrrrrrrrrrrekkkkkkkkkkkkiWwDeLfDhbbkvFuw0Deei9c)JYIUJGaS(cdJ8rPF3DuYP7kVuoooeHIIIIIIIIIIIccSvhrbA41YxkVuE3pqdVw)E(8an8ADYZNhOHxlY885bA41Q2NppqdVwV9uJicffffffffffffB4Tst5LYVpVPublcfffffffffffffffLMTYc(UTCi9cx51lfAFVPnq6foTqdVw(6DA1mn0OmFDJiuuuuuuuuuuuuuuuuuuuuA2kl6occKEHlQ)Y0quMVUrekkkkkkkkkkkkkkkkkkkkkkkkiWwDeLQ7UpnyJYlLI(89WgbgEt7VZuB0IrFqBfoT0OqwL(D3j5g8hRPVNPv40qtn6VZIqrrrrrrrrrrrrrrrrrrrrrrrH(UzgAFOULTTTDPLE(878CCuD39PbBooEQzLNJJf8DB5q6f(XXJc1O8CCSO7iiq6f(XXd13p0icfffffffffffffffffffffffLTp3Trz2xxekkkkkkkkkkkkkkkkkkkkUPsekkkkkkkkkkkkkkkkUPsekkkkkkkkkkkkUPsekkkkkkkkUPsekkkkUPseUPIboE3mlguE9LetQqjHD9yKeoQDCqqj9EiNcfSrXHfU6yG1DnWfKgYP7mWX7MHbRl0oE3mGRTDRemGu5ubqjbqPclugyDxdCbPVTkNbtRWR4HbxZSBuO4BgLhEyiNWOmy2nku8nJYGHC6odSURbUGbxJJ3ndd63bMboE3mmO8V9rPK(A1P4myDH2X7MPSTB3kbdaLHdBSzG1DnWfq6fodSVgRPbBO1X7M5ZXXbnIqrrrPzR44DZO86LYtzytfuJdlsyHdJ4GqcheQWeBC19OmFDJiuuuuuuuuA2k97UtYn4pCthAexz(6grOOOOOOOOOOOOqF3mdTpu3Y222U0spF(544bt41cq3rqqBf(MAukhUa6(O4MkV6544H67hAeHIIIIIIIIBQeHIIIIIIIY2N72Om7Rlcffff3ujc3ujcricricricricricricricricricricricricricricricrWaR7AGlyG91ynnydToE3mFoooOrekkkknBfhVBgLxVuEkdBQGACyrclCyehes1bfavyInU6EuMVUrekkkkkkkk97UtYn4pwtFptRWFHrFqBfoT0icfffffffLMTs)U7KCd(d30HgXvMVUrekkkkkkkkkkkk03nZq7d1TSTTTlT0ZNFooEWeETa0Dee0wHVPgLYHlGUpkRPVhV6544H67hAeHIIIIIIIIBQeHIIIIIIIY2N72Om7Rlcffff3ujc3uXahVBMfdkdBQGACyrclCyehes1bfavyInU6(ug2ub14WIew4WioiKWbHkmXgxDmW6Ug4csd50Dg44DZWG1fAhVBgW12UvcgqQCQaOKaOuHfkdSURbUG03wLZGPv4v8WGRz2nku8nJYdp8WGwfdWeETa0Dee0D3cdKTK9MHbMBb6UrHIVxmeYWa7DVWbZUpDgYBmOBS(cVpD3lCuYP7maGdBCLJEkwuvsCmG86TTx(WqilzoZGkF1N7UpodndAg8(E5m0mOg3QMV8PVDgQodv)()))R9mzk9KtQLTjBTLYG10TWWQm4MzyaM1JIwFjXckySMIYGXlXuomc8Mrzi)yi)yiNWq(Xqidd5hdPwgYpE4HhgGNH8R2t(XdZa