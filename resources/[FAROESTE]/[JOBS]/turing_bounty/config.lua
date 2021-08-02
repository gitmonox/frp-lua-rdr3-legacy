Config = {}

Config.Presstext = "Aperte"
Config.Talktext = "para falar com"
Config.NPCTitle = "PROCURADO : Pagamos boas recompensas!"
Config.Debug = false -- true/false Debug Mode
Config.Info = "A encomenda foi marcada no mapa"
Config.Info1 = "Volte para o sheriff com o corpo para receber seu dinheiro"
Config.ShowBlips = true -- Show NPC blips
Config.ItemShow = 1 -- 1: Show Area, 2: Show exact position, 3: None
Config.ItemBlipNameOnMap = "Caçador de Recompensa"
Config.ItemBlipSprite = 1366733613
Config.ShowBackBlip = 1 -- 1: Show Area, 2: None
Config.DeliveryInfo = "Obrigado pela ajuda, aqui está sua recompensa"
Config.FailureInfo = "Como assim? Você deixou escapar, não vai receber nada!"
Config.ShowCircle = true -- Shows circle on item
Config.MarkBounty = true -- Marks bounty on the map
Config.CircleColor = {0,176,0,150} -- Circle Colors(r,g,b,a)
Config.Cooldown = math.random(300000, 900000) -- Tempo entre recompensas 300000 = 5mins /  900000 = 15mins


Config.Quests = {

---- Config de missoes

	[1] = { 
		["Type"] = 1, -- Onde serão respawnados e o premio que vão dar
		["Reward"] = 50, -- Valor em dinheiro
		["Xp"] = 25, -- XP recebida
		["Goal"] = {
			["Name"] = 0xA0968AC2, -- {0xA0968AC2,"mp_u_m_m_legendarybounty_001",1,},	
			["Pos"] = vector3(916.663,-990.111,57.947), -- Posição
		}
	},
	
	[2] = { 
		["Type"] = 1,
		["Reward"] = 100,
		["Xp"] = 50,
		["Goal"] = {
			["Name"] = 0xB2752E7F, -- {0xB2752E7F,"mp_u_m_m_legendarybounty_002",1,},		
			["Pos"] = vector3(1356.251,-1616.246,66.915),
		}
	},
    [3] = { 
		["Type"] = 1,
		["Reward"] = 150,
		["Xp"] = 75,
		["Goal"] = {
			["Name"] = 0xA0968AC2, -- {0xB2752E7F,"mp_u_m_m_legendarybounty_002",1,},		
			["Pos"] = vector3(1564.931,-1122.046,43.464),
		}
	},
}

Config.Npc = {
    [1] = { -- RHODES	
		["Name"] = "Bounty Sheriff", -- Nome
		["Model"] = "mp_u_m_o_blwpolicechief_01", -- Modelo
		["Pos"] = vector3(1354.734,-1304.682,76.897), -- Posição
		["Heading"] = 160.363,
		["Blip"] = -861219276,
		["Missions"] = {3} -- Random do Index Config.Quest, quais inimigos ele vai marcar como recompensa 
	},
	--[[[2] = { -- valentine
		["Name"] = "Bounty Sheriff",
		["Model"] = "U_M_M_ValSheriff_01",
		["Pos"] = vector3(2377.380,348.025,58.980),
		["Heading"] = 196.79,
		["Blip"] = -861219276,
		["Missions"] = {1,2}
	},]]
	
	
}
