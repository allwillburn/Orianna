local ver = "0.06"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Orianna" then return end


require("DamageLib")
require("Deftlib")
require("OpenPredict")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Orianna/master/Orianna.lua', SCRIPT_PATH .. 'Orianna.lua', function() PrintChat('<font color = "#00FFFF"> Orianna Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Orianna/master/Orianna.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local OriannaQ = {delay = .6, range = 825, width = 175, speed = 1150}
 
local OriannaMenu = Menu("Orianna", "Orianna")

OriannaMenu:SubMenu("Combo", "Combo")

OriannaMenu.Combo:Boolean("Q", "Use Q in combo", true)
OriannaMenu.Combo:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
OriannaMenu.Combo:Boolean("W", "Use W in combo", true)
OriannaMenu.Combo:Boolean("E", "Use E in combo", true)
OriannaMenu.Combo:Boolean("R", "Use R in combo", true)
OriannaMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)




OriannaMenu:SubMenu("AutoMode", "AutoMode")
OriannaMenu.AutoMode:Boolean("Level", "Auto level spells", false)
OriannaMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
OriannaMenu.AutoMode:Boolean("Q", "Auto Q", false)
OriannaMenu.AutoMode:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
OriannaMenu.AutoMode:Boolean("W", "Auto W", false)
OriannaMenu.AutoMode:Boolean("E", "Auto E", false)
OriannaMenu.AutoMode:Boolean("R", "Auto R", false)

OriannaMenu:SubMenu("LaneClear", "LaneClear")
OriannaMenu.LaneClear:Boolean("Q", "Use Q", true)
OriannaMenu.LaneClear:Boolean("W", "Use W", true)
OriannaMenu.LaneClear:Boolean("E", "Use E", true)


OriannaMenu:SubMenu("Harass", "Harass")
OriannaMenu.Harass:Boolean("Q", "Use Q", true)
OriannaMenu.Harass:Boolean("W", "Use W", true)

OriannaMenu:SubMenu("KillSteal", "KillSteal")
OriannaMenu.KillSteal:Boolean("Q", "KS w Q", true)
OriannaMenu.KillSteal:Boolean("W", "KS w W", true)
OriannaMenu.KillSteal:Boolean("E", "KS w E", true)
OriannaMenu.KillSteal:Boolean("R", "KS w R", true)

OriannaMenu:SubMenu("AutoFarm", "AutoFarm")
OriannaMenu.AutoFarm:Boolean("Q", "Auto Q", false)
OriannaMenu.AutoFarm:Boolean("AA", "AutoAA", true)

OriannaMenu:SubMenu("AutoIgnite", "AutoIgnite")
OriannaMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

OriannaMenu:SubMenu("Drawings", "Drawings")
OriannaMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

OriannaMenu:SubMenu("SkinChanger", "SkinChanger")
OriannaMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
OriannaMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)
        local OriannaQ = {delay = .0, range = 800, width = 50, speed = 1500}
		Balls = {}
		
	

	--AUTO LEVEL UP
	if OriannaMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
          
           if OriannaMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 925) then
				CastTargetSpell(target, _W)
            end 
                    
            if OriannaMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 800) then
				if target ~= nil then 
                                      CastTargetSpell(target, _Q)
                                end
            end          
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
    
            
			 if OriannaMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 825) then
                local QPred = GetPrediction(target,OriannaQ)
                       if QPred.hitChance > (OriannaMenu.Combo.Qpred:Value() * 0.1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
                end

                
            if OriannaMenu.Combo.W:Value() and ValidTarget(target, 825) then        
           
            CastSkillShot(_W, target.pos) 
            end
          	  

			if OriannaMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 825) then
			 CastSpell(_E, myHero)
	    end
             
           	  
      
              
		if OriannaMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 800) then
		     if target ~= nil then 
                         CastTargetSpell(target, _Q)
                     end
            end	
            	
             	   	    
            if OriannaMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 825) and (EnemiesAround(myHeroPos(), 825) >= OriannaMenu.Combo.RX:Value()) then
			CastTargetSpell(target, _R)
            end

          end




         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 825) and OriannaMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastTargetSpell(target, _Q)
		         end
                end 
			
		if IsReady(_W) and ValidTarget(enemy, 825) and OriannaMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("W",enemy) then
		                      
            CastSkillShot(_W, target.pos)
  
                end

                if IsReady(_E) and ValidTarget(enemy, 825) and OriannaMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastTargetSpell(myHero, _E)
  
                end
			
		if IsReady(_R) and ValidTarget(enemy, 825) and OriannaMenu.KillSteal.R:Value() and GetHP(enemy) < getdmg("R",enemy) then
		                      CastTargetSpell(target, _R)
  
                end	
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if OriannaMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 825) then
	        	CastTargetSpell(closeminion, _Q)
                end

                if OriannaMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 825) then
	        	CastTargetSpell(closeminion,_W)
	        end

                if OriannaMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 825) then
	        	 CastSkillShot(_E, closeminion)
	        end

               
	
		
          end
      end
        --AutoMode
         	 if OriannaMenu.AutoMode.Q:Value() and Ready(_Q) and ValidTarget(target, 825) then
                local QPred = GetPrediction(target,OriannaQ)
                       if QPred.hitChance > (OriannaMenu.AutoMode.Qpred:Value() * 0.1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
                end
        if OriannaMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 825) then
	  	      
            CastSkillShot(_W, target.pos)
          end
        end
        if OriannaMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 825) then
		      CastTargetSpell(myHero, _E)
	  end
        end
        if OriannaMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 825) then
		      CastSkillShot(_R, target.pos) 
	  end
        end
		
		--Auto on minions
          for _, minion in pairs(minionManager.objects) do
      			
      			   	
              if OriannaMenu.AutoFarm.Q:Value() and Ready(_Q) and ValidTarget(minion, 825) and GetCurrentHP(minion) < CalcDamage(myHero,minion,QDmg,Q) then
                  CastTargetSpell(minion, _Q)
              end
			
		if OriannaMenu.AutoFarm.AA:Value() and ValidTarget(minion, 500) and GetCurrentHP(minion) < CalcDamage(myHero,minion,AADmg,AA) then
            AttackUnit(minion)
        end		
	end		
		
                
	--AUTO GHOST
	if OriannaMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if OriannaMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 825, 0, 200, GoS.Black)
	end

end)




local function SkinChanger()
	if OriannaMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Orianna</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





