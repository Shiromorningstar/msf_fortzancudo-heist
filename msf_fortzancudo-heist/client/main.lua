local holdingUp = false
local store = ""
local blipRobbery = nil
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function drawTxt(x,y, width, height, scale, text, r,g,b,a, outline)
	SetTextFont(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0,255)
	SetTextDropShadow()
	if outline then SetTextOutline() end

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x - width/2, y - height/2 + 0.005)
end

RegisterNetEvent('msf_fortzancudeorob:currentlyRobbing')
AddEventHandler('msf_fortzancudeorob:currentlyRobbing', function(currentStore)
	holdingUp, store = true, currentStore
end)

RegisterNetEvent('msf_fortzancudeorob:killBlip')
AddEventHandler('msf_fortzancudeorob:killBlip', function()
	RemoveBlip(blipRobbery)
end)

RegisterNetEvent('msf_fortzancudeorob:setBlip')
AddEventHandler('msf_fortzancudeorob:setBlip', function(fortzancudo)
	blipRobbery = AddBlipForCoord(fortzancudo.x, fortzancudo.y, fortzancudo.z)

	SetBlipSprite(blipRobbery, 161)
	SetBlipScale(blipRobbery, 2.0)
	SetBlipColour(blipRobbery, 3)

	PulseBlip(blipRobbery)
end)

RegisterNetEvent('msf_fortzancudeorob:tooFar')
AddEventHandler('msf_fortzancudeorob:tooFar', function()
	holdingUp, store = false, ''
	ESX.ShowNotification(_U('fortzancudorobbery_cancelled'))
end)

RegisterNetEvent('msf_fortzancudeorob:robberyComplete')
AddEventHandler('msf_fortzancudeorob:robberyComplete', function(award)
	holdingUp, store = false, ''
	ESX.ShowNotification(_U('fortzancudorobbery_complete', award))
end)

RegisterNetEvent('msf_fortzancudeorob:startTimer')
AddEventHandler('msf_fortzancudeorob:startTimer', function()
	local timer = Fortzancudo[store].secondsRemainingFortzancudo

	Citizen.CreateThread(function()
		while timer > 0 and holdingUp do
			Citizen.Wait(1000)

			if timer > 0 then
				timer = timer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		while holdingUp do
			Citizen.Wait(0)
			drawTxt(0.66, 1.44, 1.0, 1.0, 0.4, _U('fortzancudorobbery_timer', timer), 255, 255, 255, 255)
		end
	end)
end)

Citizen.CreateThread(function()
	while true do
		local letSleep = true
		local playerPos = GetEntityCoords(PlayerPedId(), true)

		for k,v in pairs(Fortzancudo) do
			local storePos = v.fortzancudo
			local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, storePos.x, storePos.y, storePos.z)

			if distance < Config.FortzancudoFortzancudoMarker.DrawDistance then
				letSleep = false
				if not holdingUp then
					DrawMarker(Config.FortzancudoFortzancudoMarker.Type, storePos.x, storePos.y, storePos.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.FortzancudoFortzancudoMarker.x, Config.FortzancudoFortzancudoMarker.y, Config.FortzancudoFortzancudoMarker.z, Config.FortzancudoFortzancudoMarker.r, Config.FortzancudoFortzancudoMarker.g, Config.FortzancudoFortzancudoMarker.b, Config.FortzancudoFortzancudoMarker.a, false, false, 2, false, false, false, false)

					if distance < 0.5 then
						ESX.ShowHelpNotification(_U('fortzancudopress_to_rob', v.nameOfFortzancudo))

						if IsControlJustReleased(0, 38) then
							if IsPedArmed(PlayerPedId(), 4) then
								TriggerServerEvent('msf_fortzancudeorob:robberyStarted', k)
							else
								ESX.ShowNotification(_U('fortzancudono_threat'))
							end
						end
					end
				end
			end
		end
		if letSleep then
			Citizen.Wait(1000)
		end
		Citizen.Wait(1)

		if holdingUp then
			local storePos = Fortzancudo[store].fortzancudo
			if Vdist(playerPos.x, playerPos.y, playerPos.z, storePos.x, storePos.y, storePos.z) > Config.FortzancudoMaxDistance then
				TriggerServerEvent('msf_fortzancudeorob:tooFar', store)
			end

		end
	end
end)

RegisterNetEvent('msf_news:StartTimer')
AddEventHandler('msf_news:StartTimer', function()
    ESX.Scaleform.ShowBreakingNews("WEAZEL NEWS", "Robbery On Going! @Fort Zancudo AirBase Tower!", bottom, 10)
end)

