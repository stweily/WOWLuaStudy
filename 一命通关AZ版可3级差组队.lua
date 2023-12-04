print(">>Script: One Life System.")

--初始建表
CharDBQuery([[
CREATE TABLE IF NOT EXISTS `character_one_life` (
`GUID` INT(10) UNSIGNED NOT NULL COMMENT 'Player guidLow',
`DEAD` TINYINT(4) NOT NULL DEFAULT 7 COMMENT 'Dead States',
PRIMARY KEY (`GUID`)
)
ENGINE=InnoDB;
]])

local oneLifePlayers = {}
local DoubleRequire = 38310

--一命组队限制3级差,否则不加击杀经验
local function OnAddXP(event, player, amount, victim, source)
	local guid = player:GetGUIDLow()
	if oneLifePlayers[guid] and oneLifePlayers[guid] == 0 then
		if player:GetGroup() then

			for k, menber in pairs(player:GetGroup():GetMembers()) do
				if menber:GetLevel() > (player:GetLevel() + 3) then
					player:SendBroadcastMessage("队员等级超过三级，你已自动退组并损失本次经验")
					player:RemoveFromGroup()
					return 0
				end
			end
		end
		if source == 0 then
			--player:SendBroadcastMessage("经验来源类型："..source.."，实际经验为："..amount/10)
			return amount/5	--根据服务器经验设定倍率,在这里恢复默认
		else
			--player:SendBroadcastMessage("经验来源类型："..source.."，实际经验为："..amount/35)
			return amount/17.5	--根据服务器经验设定倍率,在这里恢复默认
		end
	else
		if player:GetItemByEntry(DoubleRequire) and player:GetItemByEntry(DoubleRequire):IsEquipped() and player:GetLevel() < 70 then
			return amount * 5   	--5倍经验
		end
	end
end

--开启一命模式
local function OnChat(event, player, msg, Type, lang)
	if player:GetLevel() == 1 and msg == "yiming" then
		local guid = player:GetGUIDLow()
		if oneLifePlayers[guid] then 
			player:SendBroadcastMessage("已经是一命模式了！")
			return false
		end
		CharDBQuery("INSERT INTO character_one_life (GUID,DEAD) VALUES ("..guid..",0)")
		oneLifePlayers[guid] = 0
		player:SendBroadcastMessage("开启一命模式成功！")
		SendWorldMessage(getPlayerLink(player:GetName()).."开启了一命通关模式，请大家小心呵护。请不要帮他打任何怪和做任何任务，被发现会封号！")
		return false
	end
end

--被玩家杀死
local function OnPlayerKill(event, killer, killed)
	local guid = killed:GetGUIDLow()
	if oneLifePlayers[guid] and oneLifePlayers[guid] == 0 then
		local killerInfo = "失败原因：被不明玩家击杀！"
		if killer then
			killerInfo = "失败原因：被玩家 "..getPlayerLink(killer:GetName()).." 击杀！"
		end
		if killer == killed then
			killerInfo = "失败原因：想不通自杀！"
		end		
		onDeath(killed, killerInfo)
	end
end

--被怪物杀死
local function OnCreatureKill(event, killer, killed)
	local guid = killed:GetGUIDLow()
	if oneLifePlayers[guid]  and oneLifePlayers[guid] == 0 then
		local killerInfo = "失败原因：被不明怪物击杀！"
		if killer then 
			killerInfo = "失败原因：被怪物 "..getCreatureName(killer).." 击杀！"
		end
		onDeath(killed,killerInfo)
	end
end

--70解除一命
local function OnLevelChange(event, player, oldLevel)
	if player:GetLevel() == 70 then
		local guid = player:GetGUIDLow()
		if oneLifePlayers[guid] then
			CharDBQuery("UPDATE character_one_life SET DEAD=6 WHERE GUID="..guid)
			oneLifePlayers[guid] = nil
			--发奖励
			player:SendBroadcastMessage("恭喜！一命挑战成功！收获奖金1000G和物品若干")
			SendWorldMessage("不经一番寒彻骨，怎得梅花扑鼻香......恭喜玩家 "..getPlayerLink(player:GetName()).." 一命模式挑战成功！")
			player:ModifyMoney(10000000)
			if player:GetClass() == 1 or player:GetClass() == 3 or player:GetClass() == 7 then
				SendMail("恭喜！一命挑战成功！","亲爱的"..player:GetName().."：\n\n  所有坎坷，终成坦途！愿你永远保持初心，热爱并享受这个世界！\n\n山口山PLUS欢迎您",guid,0,61,0,0,0,31095,1)
				SendMail("恭喜！一命挑战成功！","亲爱的"..player:GetName().."：\n\n  所有坎坷，终成坦途！愿你永远保持初心，热爱并享受这个世界！\n\n山口山PLUS欢迎您",guid,0,61,0,0,0,31103,1)
				SendMail("恭喜！一命挑战成功！","亲爱的"..player:GetName().."：\n\n  所有坎坷，终成坦途！愿你永远保持初心，热爱并享受这个世界！\n\n山口山PLUS欢迎您",guid,0,61,0,0,0,31091,1)
				SendMail("恭喜！一命挑战成功！","亲爱的"..player:GetName().."：\n\n  所有坎坷，终成坦途！愿你永远保持初心，热爱并享受这个世界！\n\n山口山PLUS欢迎您",guid,0,61,0,0,0,31094,1)
				SendMail("恭喜！一命挑战成功！","亲爱的"..player:GetName().."：\n\n  所有坎坷，终成坦途！愿你永远保持初心，热爱并享受这个世界！\n\n山口山PLUS欢迎您",guid,0,61,0,0,0,31100,1)
			elseif player:GetClass() == 2 or player:GetClass() == 5 or player:GetClass() == 9 then
				SendMail("恭喜！一命挑战成功！","亲爱的"..player:GetName().."：\n\n  所有坎坷，终成坦途！愿你永远保持初心，热爱并享受这个世界！\n\n山口山PLUS欢迎您",guid,0,61,0,0,0,31097,1)
				SendMail("恭喜！一命挑战成功！","亲爱的"..player:GetName().."：\n\n  所有坎坷，终成坦途！愿你永远保持初心，热爱并享受这个世界！\n\n山口山PLUS欢迎您",guid,0,61,0,0,0,31101,1)
				SendMail("恭喜！一命挑战成功！","亲爱的"..player:GetName().."：\n\n  所有坎坷，终成坦途！愿你永远保持初心，热爱并享受这个世界！\n\n山口山PLUS欢迎您",guid,0,61,0,0,0,31089,1)
				SendMail("恭喜！一命挑战成功！","亲爱的"..player:GetName().."：\n\n  所有坎坷，终成坦途！愿你永远保持初心，热爱并享受这个世界！\n\n山口山PLUS欢迎您",guid,0,61,0,0,0,31092,1)
				SendMail("恭喜！一命挑战成功！","亲爱的"..player:GetName().."：\n\n  所有坎坷，终成坦途！愿你永远保持初心，热爱并享受这个世界！\n\n山口山PLUS欢迎您",guid,0,61,0,0,0,31098,1)
			elseif player:GetClass() == 4 or player:GetClass() == 8 or player:GetClass() == 11 then
				SendMail("恭喜！一命挑战成功！","亲爱的"..player:GetName().."：\n\n  所有坎坷，终成坦途！愿你永远保持初心，热爱并享受这个世界！\n\n山口山PLUS欢迎您",guid,0,61,0,0,0,31096,1)
				SendMail("恭喜！一命挑战成功！","亲爱的"..player:GetName().."：\n\n  所有坎坷，终成坦途！愿你永远保持初心，热爱并享受这个世界！\n\n山口山PLUS欢迎您",guid,0,61,0,0,0,31102,1)
				SendMail("恭喜！一命挑战成功！","亲爱的"..player:GetName().."：\n\n  所有坎坷，终成坦途！愿你永远保持初心，热爱并享受这个世界！\n\n山口山PLUS欢迎您",guid,0,61,0,0,0,31090,1)
				SendMail("恭喜！一命挑战成功！","亲爱的"..player:GetName().."：\n\n  所有坎坷，终成坦途！愿你永远保持初心，热爱并享受这个世界！\n\n山口山PLUS欢迎您",guid,0,61,0,0,0,31093,1)
				SendMail("恭喜！一命挑战成功！","亲爱的"..player:GetName().."：\n\n  所有坎坷，终成坦途！愿你永远保持初心，热爱并享受这个世界！\n\n山口山PLUS欢迎您",guid,0,61,0,0,0,31099,1)
			end
		end
	end
end

--上线检测
local function OnLogin(event, player)
	local guid = player:GetGUIDLow()
	if oneLifePlayers[guid] then
		if oneLifePlayers[guid] == 1 then 
			player:KickPlayer()
		else
			SendWorldMessage(getPlayerLink(player:GetName()).."正继续他的一命通关模式。请不要帮他打任何怪和做任何任务，被发现会封号！")
			player:SendBroadcastMessage("当前角色为一命模式！注意安全！")
		end
	elseif player:GetLevel() == 1 then
		player:SendBroadcastMessage("欢迎挑战“一命通关”模式，从1级开始无死亡满级则挑战成功")
		player:SendBroadcastMessage("开启后无法关闭，满级自动退出该模式，并获取丰厚的奖励")
		player:SendBroadcastMessage("满级前无法退出，一旦死亡将永久失去该账号的控制权")
		player:SendBroadcastMessage("升级经验恢复默认值，组队超过3级将自动退组且没有经验")
		player:SendBroadcastMessage("如想开启该挑战模式，请在普通(白字)频道输入   yiming  ") 
	end
end

local function OnResurrect(event, player)
	local guid = player:GetGUIDLow()
	if oneLifePlayers[guid] and oneLifePlayers[guid] == 1 then
		player:KillPlayer()
		player:KickPlayer()
	end
end

--死亡处理
function onDeath(player, killerInfo)
	SendWorldMessage(player:GetLevel().."级玩家"..getPlayerLink(player:GetName()).."在<"..GetAreaName(player:GetAreaId(),4)..">挑战一命通关失败，英勇牺牲。\n"..killerInfo.."请大家默哀三分钟！")
	local guid = player:GetGUIDLow()
	oneLifePlayers[guid] = 1
	CharDBQuery("UPDATE character_one_life SET DEAD=1 WHERE GUID="..guid)
end

--玩家名字链接
function getPlayerLink(name)
	return "|cffffffff|Hplayer:"..name.."|h["..name.."]|h|r"
end

--获取怪物中文名字
function getCreatureName(creature)
	local result = WorldDBQuery("SELECT Name FROM creature_template_locale WHERE entry="..creature:GetEntry().." and locale='zhCN'")
	if result then
		return result:GetString(0)
	else
		return creature:GetName()	
	end
end

--初始加载
local result = CharDBQuery("SELECT GUID,DEAD FROM character_one_life")
if result then
	repeat 
		local guid = result:GetUInt32(0)
		local dead = result:GetUInt32(1)
		if dead < 6 then	--预留其他情形模式用于后续奖励或者功能,为防意外设定7为默认模式,6为一命通关过的角色
			oneLifePlayers[guid] = dead
		end
	until not result:NextRow()
end

--事件注册
RegisterPlayerEvent(12, OnAddXP) --加经验的时候
RegisterPlayerEvent(18, OnChat) --聊天的时候
RegisterPlayerEvent(13, OnLevelChange) --等级变化的时候
RegisterPlayerEvent(3, OnLogin) --上线的时候
RegisterPlayerEvent(6, OnPlayerKill) --被玩家杀死的时候
RegisterPlayerEvent(8, OnCreatureKill) --被怪杀死的时候
RegisterPlayerEvent(36, OnResurrect) --复活的时候