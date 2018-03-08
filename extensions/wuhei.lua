module("extensions.wuhei",package.seeall)
extension=sgs.Package("wuhei")

danyu1 = sgs.General(extension, "danyu1", "wei", "3", true)

danyu_shishui = sgs.CreateTriggerSkill{
name = "danyu_shishui",
frequency = sgs.Skill_Compulsory, --锁定技
events = {sgs.CardUsed, sgs.CardResponded, sgs.EventPhaseChanging,sgs.Player_Finish}, 
on_trigger = function ( self, event, player, data )
	local phase = player:getPhase()
	local room = player:getRoom()
	if event == sgs.EventPhaseChanging then
		--player:drawCards(3)
		local change = data:toPhaseChange()
        if player:hasFlag("kaishishuile") and change.to == sgs.Player_Finish then
			local msg = sgs.LogMessage()
			msg.type = "#mes7"
			msg.to:append(player)
			room:sendLog(msg)
        	player:loseAllMarks("@jingcha")  --失去标志
        	player:drawCards(3)  --摸3张
        	player:turnOver() --翻面
        	room:setPlayerFlag(player,"-kaishishuile")
        end
		if change.to == sgs.Player_RoundStart then
			player:loseAllMarks("@jingcha")
		end
	else
		if phase == sgs.Player_Play then
			--[[
			local msg = sgs.LogMessage()
			msg.type = "#mes2"
			msg.to:append(player)
			room:sendLog(msg)
				local msg = sgs.LogMessage()
				msg.type = "#mes3"
				msg.to:append(player)
				room:sendLog(msg)
			]]
			room:setPlayerFlag(player,"kaishishuile")-- 设置标志
		else
			local change = data:toPhaseChange()
			
		end
    end
	-- body
end, 
priority = 2
}

danyu_jingcha = sgs.CreateTriggerSkill{
	name = "danyu_jingcha",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.Damaged}, --受伤时候触发
	on_trigger = function(self, event, player, data, room)
		local damage = data:toDamage() --伤害量化
		local count = damage.damage   --计数伤害
		local phase = player:getPhase()
		player:gainMark("@jingcha",count) --添加标记
		if not player:faceUp() and player:getMark("@jingcha")>1 then  --获取是否翻面和标记数
			local msg = sgs.LogMessage()
			msg.type = "#mes6"
			msg.to:append(player)
			room:sendLog(msg)
			player:drawCards(3)  --摸3张
			player:turnOver() --翻面
			player:loseAllMarks("@jingcha")
		end
	end
}

danyu1:addSkill(danyu_jingcha)
danyu1:addSkill(danyu_shishui)


sgs.LoadTranslationTable{
	["wuhei"] = "五黑",
	["danyu1"] = "王丹宇",
	["#danyu1"] = "睡罗汉",
	["designer:danyu1"] = "莫里",
	["cv:danyu1"] = "王丹宇",
	["illustrator:danyu1"] = "王丹宇",
	["danyu_shishui"] = "嗜睡",
	[":danyu_shishui"] = "【锁定技】如果在自己的回合内执行了出牌阶段，那么在此回合的结束阶段开始时，自己摸三张牌并且翻面。",
	["danyu_jingcha"] = "惊诧",
	[":danyu_jingcha"] = "自己的武将牌翻面朝上时，每当自己受到两次伤害以上，可以将武将牌翻过来。",
	["#mes"]="QAQ这这这这这这这这这里",
	["#mes2"]="QwwwwwwwwQ这这这这这这这这这里",
	["#mes3"]="QaaaaQ这这这这这这这这这里",
	["#mes4"]="QssssssQ这这这这这这这这这里",
	["#mes5"]="Q000000Q这这这这这这这这这里",
	["#mes6"]="王丹宇醒了",
	["#mes7"]="王丹宇开始沉睡",
	["#mes10"]="xxxxxxxxxxxxxxxxxxxxx",
	["@jingcha"] = "惊诧"
}