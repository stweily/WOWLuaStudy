--RegisterPlayerEvent(18, function(e,p,m,t,l) if m == "test" then OnGossipHello(e,p,p) end end)
--RegisterPlayerGossipEvent(menu_id, 2, OnGossipSelect)

print(">>Script: 加载FM大师")


local function LocText(id, p) -- "%s":format("test")
    if Locales[id] then
        local s = Locales[id][p:GetDbcLocale()+1] or Locales[id][1]
        if s then
            return s
        end
    end
    return "Text not found: "..(id or 0)
end

local function OnGossipHello123(event, player)
    player:SendBroadcastMessage("123")
    local itemid = player:GetItemByPos(255, 3)
    print(itemid:SetEnchantment(34, 0))
    print(itemid:SetEnchantment(34, 1))
end

local function OnGossipSelect(event, player, creature, slotid, uiAction)
    player:SendBroadcastMessage("真的不行哟")
end


function MesBox(event, player, msg, Type, lang )
    PrintInfo("我要打中文")
    if(msg == "123") then
        OnGossipHello123(event,player)
    end
end

function FM12(event, player, item, target)
    PrintInfo("4560111111111213")
	-- body
end


RegisterPlayerEvent(18, MesBox)
RegisterPlayerGossipEvent(menu_id, 2, OnGossipSelect)
RegisterItemEvent(117, 2,FM12)