local Tunnel = module('_core', 'lib/Tunnel')
local Proxy = module('_core', 'lib/Proxy')

cAPI = Proxy.getInterface('API')
API = Tunnel.getInterface('API')


local notif = nil

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local pedCoords = GetEntityCoords(PlayerPedId())
        local bounty = math.random(#Config.Quests)
        for k, v in pairs(Config.Npc) do
            local dist = #(vector3(pedCoords) - vector3(Config.Npc[k]["Pos"].x, Config.Npc[k]["Pos"].y, Config.Npc[k]["Pos"].z))
            if dist <= 2.0 then
                sleep = 4
                if not active and not started then
                    DrawText("Aperte ALT para caçar recompensas" , 0.925, 0.96, 0.25, 0.25, false, 255, 255, 255, 145, 1, 7)
                    if IsControlJustReleased(0, 0xE8342FF2) then -- LEFT ALT
                        StartMissionType1(pedCoords, 
                        Config.Quests[bounty]["Reward"], 
                        Config.Quests[bounty]["Xp"], 
                        Config.Quests[bounty]["Goal"]["Name"], 
                        Config.Quests[bounty]["Goal"]["Pos"])
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function StartMissionType1(coords_player_mission, mission_reward, mission_xp, npc_hash, npc_position)
    Debug("Missão Iniciada")
    local local_player = GetHashKey("PLAYER")
    started = true
    gathered = false
    local _coords_player_mission = coords_player_mission
    local _mission_reward = mission_reward
    local _mission_xp = mission_xp
    local _npc_hash = npc_hash
    local _npc_position = npc_position
    
	local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", Config.Info, Citizen.ResultAsLong())
    Citizen.InvokeNative(0xFA233F8FE190514C, str)
    Citizen.InvokeNative(0xE9990552DEC71600)
    Citizen.CreateThread(function()
        --print(started, not gathered)
        local monox = 1000
        if started and not gathered then
            
			while not HasModelLoaded( _npc_hash ) do
                Wait(500)
                modelrequest( _npc_hash )
            end
            
			bounty_npc = CreatePed(_npc_hash, _npc_position.x, _npc_position.y, _npc_position.z, true, true)
			--print("criou ped?")
			while not DoesEntityExist(bounty_npc) do
				Wait(300)
			end
			
			Debug("NPC HASH: "..bounty_npc)
            Citizen.InvokeNative(0x283978A15512B2FE, bounty_npc, true)
            Killblip = Citizen.InvokeNative(0x23f74c2fda6e7c61, 953018525, bounty_npc)
            Citizen.InvokeNative(0x9CB1A1623062F402, Killblip, 'Recompensa')
			
			-- Random Weapons given npcs
			local  random = math.random(1,3)
			weaponrandom = random
			if weaponrandom == 1 then
				npc_weapon = 0x772C8DD6
			elseif weaponrandom == 2 then
				npc_weapon = 0x169F59F7
			elseif weaponrandom == 3 then
				npc_weapon = 0x6DFA071B
			end
			local groupId = GetPedGroupIndex(bounty_npc)
			local groupIdPed = GetPedGroupIndex(local_player)

            -- SETA O GRUPO DO PED
            SetPedAsGroupMember(bounty_npc, groupId)
            SetPedRelationshipGroupHash(bounty_npc, groupId)
            -- SETA O GRUPO DO PLAYER
            SetPedAsGroupMember(local_player, groupIdPed)
            SetPedRelationshipGroupHash(local_player, groupIdPed)
            -- SETA ODIO ENTRE GRUPOS -- 
			SetRelationshipBetweenGroups(5, groupId, groupIdPed)
			SetRelationshipBetweenGroups(5, groupIdPed , groupId)

            -- NÃO PARECE FUNCIONAR DIREITO, O PED ACABA ATACANDO OUTROS NPCS E AS VEZES NINGUEM, MAS AS VEZES FUNCIONA, CONTINUAREI TRABALHANDO PRA V2.0
			SetPedSeeingRange(bounty_npc, 300.0)
			SetPedHearingRange(bounty_npc, 300.0)
			SetPedCombatAttributes(bounty_npc, 46, 1)
			SetPedFleeAttributes(bounty_npc, 0, 0)
			SetPedCombatRange(bounty_npc,2)
			TaskCombatPed(bounty_npc, GetPlayerPed(), 0, 16)
			SetPedCombatAbility(bounty_npc, 100)
			SetPedCombatMovement(bounty_npc, 2)
            TaskCombatHatedTargets(bounty_npc , 150)
			GiveWeaponToPed_2(bounty_npc, npc_weapon, math.random(20, 100), false, true, 1, true, 0.5, 1.0, 0, true, 0, 0)
			
        end
        while started do
            monox = 4
            local coords3 = GetEntityCoords(PlayerPedId())
            local holding = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
            local model = GetEntityModel(holding)
            if IsControlJustReleased(0, 0x3C0A40F2) then -- F6 -- CANCELA O SERVIÇO A QUALQUER HORA
                --print("cancelado")
                RemoveBlip(Killblip)
                Wait(500)
                SetEntityAsMissionEntity(entity, true, true)
                Wait(500)
                DetachEntity(entity, 1, 1)
                Wait(5000)
                SetEntityCoords(entity, 0.0,0.0,0.0)
                Wait(500)
                DeleteEntity(entity)
                Wait(300)
                delivered = true
                BackBlipShowing = false
                entregue()
                Wait(Config.Cooldown)
                started = false
                gathered = false
                delivered = false
            end
            if IsEntityDead(bounty_npc) and not delivered then
                gathered = true
                RemoveBlip(Killblip)
                ShowBackBlip(_coords_player_mission)
                local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", Config.Info1, Citizen.ResultAsLong())
                Citizen.InvokeNative(0xFA233F8FE190514C, str)
                Citizen.InvokeNative(0xE9990552DEC71600)
				
                local distance3 = Vdist(coords3.x, coords3.y, coords3.z, _coords_player_mission.x, _coords_player_mission.y, _coords_player_mission.z)
                if distance3 < 2.5 and gathered and not delivered then
                    monox = 4
                    holding = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
                    model = GetEntityModel(holding)
					Debug("Carregando Modelo "..model)
                    if holding == bounty_npc then
                        entity = holding
                        Citizen.InvokeNative(0xC7F0B43DCDC57E3D, PlayerPedId(), entity, GetEntityCoords(PlayerPedId()), 10.0, true)
                        Wait(500)
                        SetEntityAsMissionEntity(entity, true, true)
                        Wait(500)
                        DetachEntity(entity, 1, 1)
                        playAnim("script_mp@emotes@hat_flick@male@unarmed@full", "fullbody")
                        Wait(5000)
                        SetEntityCoords(entity, 0.0,0.0,0.0)
                        Wait(500)
                        DeleteEntity(entity)
                        Wait(300)
                        delivered = true
                        BackBlipShowing = false
                        Debug("Mission Type 1 Completed: " .. bounty_npc .. " At POS: " .. _coords_player_mission)
                        TriggerServerEvent("turing_bountyPayout", _mission_reward, _mission_xp)
                        Wait(Config.Cooldown)
                        started = false
                        gathered = false
                        delivered = false
                        entregue()
                   
                    else
                        DrawText("Traga o corpo ou Aperte ALT para cancelar a missão" , 0.925, 0.96, 0.25, 0.25, false, 255, 255, 255, 145, 1, 7)
                        if IsControlJustReleased(0, 0xE8342FF2) then -- LEFT ALT
                            Wait(500)
                            SetEntityAsMissionEntity(entity, true, true)
                            Wait(500)
                            DetachEntity(entity, 1, 1)
                            Wait(5000)
                            SetEntityCoords(entity, 0.0,0.0,0.0)
                            Wait(500)
                            DeleteEntity(entity)
                            Wait(300)
                            delivered = true
                            BackBlipShowing = false
                            RemoveBlip(Killblip)
                            Wait(Config.Cooldown)
                            started = false
                            gathered = false
                            delivered = false
                            entregue()
                        end
                    end
                end
            end
            Citizen.Wait(monox)
        end
    end)
end

-- FUNCTIONS --
function entregue()
    local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10000, "LITERAL_STRING", Config.DeliveryInfo, Citizen.ResultAsLong())
    Citizen.InvokeNative(0xFA233F8FE190514C, str)
    Citizen.InvokeNative(0xE9990552DEC71600)
end
function Debug(var)
    if Config.Debug then
    print(var)
    end
end

function modelrequest( model )
    Citizen.CreateThread(function()
        RequestModel( model )
    end)
end

function playAnim(dict,name)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), dict, name, 8.0, -8.0, 7500, 0, 0, true, 0, false, 0, false)  
end

function SET_PED_RELATIONSHIP_GROUP_HASH ( iVar0, iParam0 )
    return Citizen.InvokeNative( 0xC80A74AC829DDD92, iVar0, _GET_DEFAULT_RELATIONSHIP_GROUP_HASH( iParam0 ) )
end

function _GET_DEFAULT_RELATIONSHIP_GROUP_HASH ( iParam0 )
    return Citizen.InvokeNative( 0x3CC4A718C258BDD0 , iParam0 );
end


function ShowItemBlip(var)
    local _var = var
    Citizen.CreateThread(function()
        if Config.ItemShow == 1 and not gathered then
            AllowSonarBlips(true)
            while not gathered do
                Wait(1000)
                ForceSonarBlipsThisFrame()
                TriggerSonarBlip(348490638, _var.x, _var.y, _var.z)
            end
        elseif Config.ItemShow == 2 and not gathered then
            blip = Citizen.InvokeNative(0x554d9d53f696d002, 1664425300, _var.x, _var.y, _var.z)
            SetBlipSprite(blip, Config.ItemBlipSprite)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.ItemBlipNameOnMap)
        end
    end)
end

function ShowBackBlip(var)
    if not BackBlipShowing then
    local _var = var
    BackBlipShowing = true
    Citizen.CreateThread(function()
        if Config.ShowBackBlip == 1 and not delivered then
            AllowSonarBlips(true)
            while not delivered do
                Wait(1000)
                ForceSonarBlipsThisFrame()
                TriggerSonarBlip(348490638, _var.x, _var.y, _var.z)
            end
        end
    end)
    end
end

function ShowItemCircle(var)
    local _var = var
    Citizen.CreateThread(function()
        while not gathered do
            Wait(0)
            if Config.ShowCircle and not gathered then
                Citizen.InvokeNative(0x2A32FAA57B937173, -1795314153, _var.x, _var.y, _var.z, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 2.0, 2.0, 1.5, Config.CircleColor[1], Config.CircleColor[2], Config.CircleColor[3], Config.CircleColor[4], true, false, 1, true)
            end
        end
    end)
end


-- CREATE NPC BLIPS
function ShowBlips()
    if Config.ShowBlips then
        for b, n in pairs(Config.Npc) do
            local blip = Citizen.InvokeNative(0x554d9d53f696d002, 1664425300, Config.Npc[b]["Pos"].x, Config.Npc[b]["Pos"].y, Config.Npc[b]["Pos"].z)
            SetBlipSprite(blip, Config.Npc[b]["Blip"])
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.Npc[b]["Name"])
        end
    end
end


-- CREATE NPCS
CreateThread(function() 
    for z, x in pairs(Config.Npc) do
       -- print(z, json.encode(x))
    while not HasModelLoaded(GetHashKey(Config.Npc[z]["Model"]) ) do
        Wait(500)
        modelrequest(GetHashKey(Config.Npc[z]["Model"]) )
    end
    local npc = CreatePed(GetHashKey(Config.Npc[z]["Model"]), Config.Npc[z]["Pos"].x, Config.Npc[z]["Pos"].y, Config.Npc[z]["Pos"].z, Config.Npc[z]["Heading"], false, false, 0, 0)
    while not DoesEntityExist(npc) do
        Wait(300)
    end
    Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
    SetEntityInvincible(npc, true)
    TaskStandStill(npc, -1)
    Wait(100)
    SetPedRelationshipGroupHash(npc, GetHashKey(Config.Npc[z]["Model"]))
    SetEntityCanBeDamagedByRelationshipGroup(npc, false, `PLAYER`)
    SetEntityAsMissionEntity(npc, true, true)
    SetModelAsNoLongerNeeded(GetHashKey(Config.Npc[z]["Model"]))
    FreezeEntityPosition(npc, false)
    end
end)


function DrawText(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre, font)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
    SetTextCentre(centre)
    if enableShadow then
        SetTextDropshadow(1, 0, 0, 0, 255)
    end
    Citizen.InvokeNative(0xADA9255D, font)
    DisplayText(CreateVarString(10, "LITERAL_STRING", str), x, y)
  end

  ShowBlips()
