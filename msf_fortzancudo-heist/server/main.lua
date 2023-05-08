local rob = false
local robbers = {}
ESX = nil
apagon = false
notificacion = false
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('blackout:apagon', function(apagon1)

apagon = apagon1
end)

RegisterServerEvent('msf_fortzancudeorob:tooFar')
AddEventHandler('msf_fortzancudeorob:tooFar', function(currentStore)
	local _source = source
	local xPlayers = ESX.GetPlayers()
	rob = false

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.job.name == 'police' then
		if apagon == false then
			if not notificacion then
			TriggerClientEvent('okokNotify:Alert', source, "NOTIFICATION", _U('fortzancudorobbery_cancelled_at', Fortzancudo[currentStore].nameOfFortzancudo), 4000, 'error')
			notificacion = true
			Citizen.Wait(4000)
			notificacion = false
		end
			
			
		end
			TriggerClientEvent('msf_fortzancudeorob:killBlip', xPlayers[i])
		end
	end

	if robbers[_source] then
		TriggerClientEvent('msf_fortzancudeorob:tooFar', _source)
		robbers[_source] = nil
		TriggerClientEvent('esx:showNotification', _source, _U('fortzancudorobbery_cancelled_at', Fortzancudo[currentStore].nameOfFortzancudo))
		sendDiscord('Robbers', '**Fort Zancudo |  **Player. ' .. GetPlayerName(_source) .. ' And Player: ' ..xPlayer.name.. '** | Ha **cancel** THE FORT ZANCUDO ROBBERY')
	end
end)

RegisterServerEvent('msf_fortzancudeorob:robberyStarted')
AddEventHandler('msf_fortzancudeorob:robberyStarted', function(currentStore)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	if Fortzancudo[currentStore] then
		local store = Fortzancudo[currentStore]

		if (os.time() - store.lastRobbedFortzancudo) < Config.FortzancudoTimerBeforeNewRob and store.lastRobbedFortzancudo ~= 0 then
			TriggerClientEvent('esx:showNotification', _source, _U('fortzancudorecently_robbed', Config.FortzancudoTimerBeforeNewRob - (os.time() - store.lastRobbedFortzancudo)))
			return
		end

		local cops = 0
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				cops = cops + 1
			end
		end

		if not rob then
			if cops >= Config.FortzancudoPoliceNumberRequired then
				rob = true
			if apagon == false then
				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xPlayer.job.name == 'police' then
						TriggerClientEvent('esx:showNotification', xPlayers[i], _U('fortzancudorob_in_prog', store.nameOfFortzancudo))
						TriggerClientEvent('msf_fortzancudeorob:setBlip', xPlayers[i], Fortzancudo[currentStore].fortzancudo)
					end
				end
			end
				TriggerClientEvent('esx:showNotification', _source, _U('fortzancudostarted_to_rob', store.nameOfFortzancudo))
				TriggerClientEvent('esx:showNotification', _source, _U('fortzancudoalarm_triggered'))
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(10, 10, 10, 0.7); border-radius: 3px;"><i class="far fa-  badge-sheriff"></i> :newspaper: News Update️: <br>{0}</div>',
					args = { "There is an on going Fort Zancudo Robbery. Advising All Citizens to avoid/clear the area. Failure to comply will be apprehended. EMS Please Standby." }
					})

					TriggerEvent("msf_news:StartTimer")
					TriggerEvent("msf_news:PostNews")
					
					TriggerClientEvent('msf_news:sendZancudoNewsToAll', -1)
				
				
				
				TriggerClientEvent('msf_fortzancudeorob:currentlyRobbing', _source, currentStore)
				TriggerClientEvent('msf_fortzancudeorob:startTimer', _source)
				
				Fortzancudo[currentStore].lastRobbedFortzancudo = os.time()
				robbers[_source] = currentStore

				SetTimeout(store.secondsRemainingFortzancudo * 1000, function()
					if robbers[_source] then
						rob = false
						if xPlayer then
							TriggerClientEvent('msf_fortzancudeorob:robberyComplete', _source)

								local number = math.random(1,7)
								
								if number == 1 then
									xPlayer.addInventoryItem('weapon_specialcarbine_mk2', 2)
									xPlayer.addInventoryItem('ammo-9', 500)
									xPlayer.addInventoryItem('ammo-rifle', 400)
									xPlayer.addInventoryItem('at_scope', 2)
									xPlayer.addInventoryItem('weapon_knife', 1)
									xPlayer.addInventoryItem('bandage', 25)
									xPlayer.addInventoryItem('black_money', 127620)
								elseif number == 2 then
									xPlayer.addInventoryItem('secure_card', 2)
									xPlayer.addInventoryItem('weapon_assaultrifle', 13)
									xPlayer.addInventoryItem('ammo-rifle2', 150)
									xPlayer.addInventoryItem('weapon_knife', 2)
									xPlayer.addInventoryItem('black_money', 173500)
								elseif number == 3 then
									xPlayer.addInventoryItem('weapon_specialcarbine_mk2', 1)
									xPlayer.addInventoryItem('ammo-rifle', 160)
									xPlayer.addInventoryItem('ammo-9', 400)
									xPlayer.addInventoryItem('ammo-shotgun', 90)
									xPlayer.addInventoryItem('ammo-rifle2', 200)
									xPlayer.addInventoryItem('bandage', 50)
									xPlayer.addInventoryItem('gauze', 40)
									xPlayer.addInventoryItem('black_money', 512783)
								elseif number == 4 then
									xPlayer.addInventoryItem('weapon_heavypistol', 2)
									xPlayer.addInventoryItem('ammo-rifle', 40)
									xPlayer.addInventoryItem('bandage', 50)
									xPlayer.addInventoryItem('gauze', 40)
									xPlayer.addInventoryItem('black_money', 154340)
								elseif number == 5 then
									xPlayer.addInventoryItem('weapon_pumpshotgun', 2)
									xPlayer.addInventoryItem('weapon_specialcarbine_mk2', 1)
									xPlayer.addInventoryItem('ammo-shotgun', 80)
									xPlayer.addInventoryItem('weapon_bat', 3)
									xPlayer.addInventoryItem('ammo-rifle2', 60)
									xPlayer.addInventoryItem('weapon_knife', 6)
									xPlayer.addInventoryItem('black_money', 153200)
								elseif number == 6 then
									xPlayer.addInventoryItem('weapon_advancedrifle', 1)
									xPlayer.addInventoryItem('ammo-rifle2', 180)
									xPlayer.addInventoryItem('ammo-rifle', 300)
									xPlayer.addInventoryItem('at_grip', 2)
									xPlayer.addInventoryItem('black_money', 125000)
								elseif number == 7 then
									xPlayer.addInventoryItem('bandage', 30)
									xPlayer.addInventoryItem('gauze', 50)
									xPlayer.addInventoryItem('armour', 6)
									xPlayer.addInventoryItem('weapon_musket', 1)
									xPlayer.addInventoryItem('weapon_assaultrifle_mk2', 1)
									xPlayer.addInventoryItem('black_money', 125000)
								end
								
							sendDiscord('Robbers', 'Fort Zancudo | **PLAYER: ' .. GetPlayerName(_source) .. ' And Player:' ..xPlayer.name.. '**| Started Robbery In Warship And Got A Reward Of Package! **' .. number .. '**')

							local xPlayers, xPlayer = ESX.GetPlayers(), nil
							for i=1, #xPlayers, 1 do
								xPlayer = ESX.GetPlayerFromId(xPlayers[i])
				
								if xPlayer.job.name == 'police' then
								if apagon == false then
									TriggerClientEvent('esx:showNotification', xPlayers[i], _U('fortzancudorobbery_complete_at', store.nameOfFortzancudo))
								end
									TriggerClientEvent('msf_fortzancudeorob:killBlip', xPlayers[i])
								end
							end
						end
					end
				end)
			else
				TriggerClientEvent('esx:showNotification', _source, _U('fortzancudomin_police', Config.FortzancudoPoliceNumberRequired))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('fortzancudorobbery_already'))
		end
	end
end)


webhookurl = '' 

function sendDiscord(name, message)
  	PerformHttpRequest(webhookurl, function(err, text, headers) end, 'POST', json.encode({username = name, content = message}), { ['Content-Type'] = 'application/json' })
end