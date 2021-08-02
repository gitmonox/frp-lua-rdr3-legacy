local Tunnel = module("_core", "lib/Tunnel")
local Proxy = module("_core", "lib/Proxy")

API = Proxy.getInterface("API")
cAPI = Tunnel.getInterface("API")


RegisterNetEvent("turing_bountyPayout")
AddEventHandler("turing_bountyPayout", function(money, xp)
    local _source = source
    local User = API.getUserFromSource(_source)
    local Inventory = User:getCharacter():getInventory()
    User:getCharacter():varyExp(xp)
    Inventory:addItem('money', money)
end)