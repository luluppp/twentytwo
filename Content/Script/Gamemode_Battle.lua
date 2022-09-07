--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@class BP_Gmaemode_Battle
local Gamemode_Battle = Class()

--function Gamemode_Battle:Initialize(Initializer)
--end

--function Gamemode_Battle:UserConstructionScript()
--end

function Gamemode_Battle:ReceiveBeginPlay()
    local widget_class = UE.UClass.Load("/Game/UMG/BattleHUD.BattleHUD_C")
    self.Battle_Wnd = NewObject(widget_class, self)
    self.Battle_Wnd:AddToViewport()

    self.Blood_class = UE.UClass.Load("/Game/UMG/FloatTextBlood.FloatTextBlood_C")

    --显示鼠标
    self:ShowMouseCursor()

    --获取Player和Enemy
    self.Player = self:GetActorByString("Player")
    self.Enemy = self:GetActorByString("Enemy")
    --if self.Enemy == nil then print("can't find") end

    --绑定UI按钮和技能
    self.Battle_Wnd.RollingDice.OnClicked:Add(self, self.OnRollingDiceButtonClicked)
    self.Battle_Wnd.Skill_1.OnClicked:Add(self, self.OnSkill_1ButtonClicked)
    self.Battle_Wnd.Skill_2.OnClicked:Add(self, self.OnSkill_2ButtonClicked)
    self.Battle_Wnd.Skill_3.OnClicked:Add(self, self.OnSkill_3ButtonClicked)
    self.Battle_Wnd.Skill_4.OnClicked:Add(self, self.OnSkill_4ButtonClicked)

    local GameInstance = UE.UGameplayStatics.GetGameInstance(self)
    --GameInstance:momoo()
    --print(DT_SKILL_MES["Player_Skill_Attack"])

    --绑定技能

    self:BindSkillToSkill_1(ActiveSkills[GameInstance.UseSkills[1]][GameInstance.PlayerActiveSkills[GameInstance.UseSkills[1]]])
    self:BindSkillToSkill_2(ActiveSkills[GameInstance.UseSkills[2]][GameInstance.PlayerActiveSkills[GameInstance.UseSkills[2]]])
    self:BindSkillToSkill_3(ActiveSkills[GameInstance.UseSkills[3]][GameInstance.PlayerActiveSkills[GameInstance.UseSkills[3]]])
    self:BindSkillToSkill_4(ActiveSkills[GameInstance.UseSkills[4]][GameInstance.PlayerActiveSkills[GameInstance.UseSkills[4]]])

    self.Battle_Wnd.Skill_1.OnHovered:Add(self, self.ShowSkill_1Info)
    self.Battle_Wnd.Skill_1.OnUnhovered:Add(self, self.HideSkill_1Info)
    self.Battle_Wnd.Skill_2.OnHovered:Add(self, self.ShowSkill_2Info)
    self.Battle_Wnd.Skill_2.OnUnhovered:Add(self, self.HideSkill_2Info)
    self.Battle_Wnd.Skill_3.OnHovered:Add(self, self.ShowSkill_3Info)
    self.Battle_Wnd.Skill_3.OnUnhovered:Add(self, self.HideSkill_3Info)
    self.Battle_Wnd.Skill_4.OnHovered:Add(self, self.ShowSkill_4Info)
    self.Battle_Wnd.Skill_4.OnUnhovered:Add(self, self.HideSkill_4Info)

    --加载结算界面
    local widget_class = UE.UClass.Load("/Game/UMG/ShowTimeEndHUD.ShowTimeEndHUD_C")
    self.ShowTimeEnd_Wnd = NewObject(widget_class, self)
    self.ShowTimeEnd_Wnd:AddToViewport()

    self.Select = nil

    self.ShowTimeEnd_Wnd.Button_1.OnClicked:Add(self, 
        function(self)
            self:SelectReward(1)
        end
    )
    self.ShowTimeEnd_Wnd.Button_2.OnClicked:Add(self, 
        function(self)
            self:SelectReward(2)
        end
    )
    self.ShowTimeEnd_Wnd.Button_3.OnClicked:Add(self, 
        function(self)
            self:SelectReward(3)
        end
    )

    self.ShowTimeEnd_Wnd.Button_1.OnHovered:Add(self, 
        function(self)
            self:PreSelectReward(1)
        end
    )
    self.ShowTimeEnd_Wnd.Button_2.OnHovered:Add(self, 
        function(self)
            self:PreSelectReward(2)
        end
    )
    self.ShowTimeEnd_Wnd.Button_3.OnHovered:Add(self, 
        function(self)
            self:PreSelectReward(3)
        end
    )

    self.ShowTimeEnd_Wnd.Button_1.OnUnhovered:Add(self, 
        function(self)
            self:Unselect(1)
        end
    )
    self.ShowTimeEnd_Wnd.Button_2.OnUnhovered:Add(self, 
        function(self)
            self:Unselect(2)
        end
    )
    self.ShowTimeEnd_Wnd.Button_3.OnUnhovered:Add(self, 
        function(self)
            self:Unselect(3)
        end
    )

    self.ShowTimeEnd_Wnd.ConfirmButton.OnClicked:Add(self, 
        function(self)
            for i = 1, 3 do
                if i == self.Select then
                    if self.Reward[self.Select]["Level"] ~= 3 then
                        table.insert (GameInstance.GachaPool, self.RewardID[i])
                    end
                else
                    table.insert (GameInstance.GachaPool, self.RewardID[i])
                end
            end
            print(self.Reward[self.Select]["Title"])

            --类型1：主动技能
            if self.Reward[self.Select]["Type"] == 1 then
                GameInstance.PlayerActiveSkills[self.Reward[self.Select]["ID"]] = self.Reward[self.Select]["Level"]
            end
            --类型2：被动技能
            if self.Reward[self.Select]["Type"] == 2 then
                self.Reward[self.Select]["Function"](GameInstance,self.Reward[self.Select]["Value"])
            end

            UE.UGameplayStatics.OpenLevel(self, "Road")
        end
    )

    --回合状态
    self.IsPlayerTurn = true

    --游戏状态
    self.IsEnd = false

    --骰子数值
    self.DiceValue = 0

    --战斗结束后奖励
    self.RewardID = {
    }
    self.Reward = {
    }
    for i = 1, 3 do
        local len = #GameInstance.GachaPool
        local select = math.random(1, len)
        local x = GameInstance.GachaPool[select]
        GameInstance.GachaPool[select] = GameInstance.GachaPool[len]
        GameInstance.GachaPool[len] = nil

        self.RewardID[i] = x
        --第一类：主动技能
        if self.RewardID[i][1] == 1 then
            if GameInstance.PlayerActiveSkills[self.RewardID[i][2]] ~= nil then
                self.Reward[i] = ActiveSkills[self.RewardID[i][2]][math.min(3, GameInstance.PlayerActiveSkills[self.RewardID[i][2]] + 1)]
            else
                self.Reward[i] = ActiveSkills[self.RewardID[i][2]][1]
            end
        end
        --第二类：被动技能
        if self.RewardID[i][1] == 2 then
        
        end
        self:SetSelectBox(i,self.Reward[i])
    end

    --玩家最终选择的奖励的编号，1、2、3
    self.Select = nil
    
    --开始回合
    self:PlayerTurn()
end

--function Gamemode_Battle:ReceiveEndPlay()
--end

-- function Gamemode_Battle:ReceiveTick(DeltaSeconds)
-- end

--function Gamemode_Battle:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function Gamemode_Battle:ReceiveActorBeginOverlap(OtherActor)
--end

--function Gamemode_Battle:ReceiveActorEndOverlap(OtherActor)
--end

function Gamemode_Battle:OnRollingDiceButtonClicked()
    self:RollingDice()
    self.Battle_Wnd.RollingDice:SetVisibility(2)
end

function Gamemode_Battle:OnSkill_1ButtonClicked()
    if self.Skill_1 ~= nil then
        self:Player_Skill(self.Skill_1)
        self:HideSkill()
    else
        print("don't have Skill_1")
    end
end

function Gamemode_Battle:OnSkill_2ButtonClicked()
    if self.Skill_2 ~= nil then
        self:Player_Skill(self.Skill_2)
        self:HideSkill()
    else
        print("don't have Skill_2")
    end
end

function Gamemode_Battle:OnSkill_3ButtonClicked()
    if self.Skill_3 ~= nil then
        self:Player_Skill(self.Skill_3)
        self:HideSkill()
    else
        print("don't have Skill_3")
    end
end

function Gamemode_Battle:OnSkill_4ButtonClicked()
    if self.Skill_4 ~= nil then
        self:Player_Skill(self.Skill_4)
        self:HideSkill()
    else
        print("don't have Skill_4")
    end
end

function Gamemode_Battle:BindSkillToSkill_1(skill)
    if skill == nil then
        return
    end

    self.Skill_1 = skill
    self.Battle_Wnd.Skill_1_Name:SetText(skill["Title"])
end

function Gamemode_Battle:BindSkillToSkill_2(skill)
    if skill == nil then
        return
    end

    self.Skill_2 = skill
    self.Battle_Wnd.Skill_2_Name:SetText(skill["Title"])
end

function Gamemode_Battle:BindSkillToSkill_3(skill)
    if skill == nil then
        return
    end

    self.Skill_3 = skill
    self.Battle_Wnd.Skill_3_Name:SetText(skill["Title"])
end

function Gamemode_Battle:BindSkillToSkill_4(skill)
    if skill == nil then
        return
    end

    self.Skill_4 = skill
    self.Battle_Wnd.Skill_4_Name:SetText(skill["Title"])
end

function Gamemode_Battle:ShowInfo(skill)
    if skill == nil then
        return
    end
    self.Battle_Wnd.SkillTitle:SetText(skill["Title"])
    self.Battle_Wnd.SkillInfo:SetText(skill["Info"])
    self.Battle_Wnd.SkillDetails:SetVisibility(0)
end

function Gamemode_Battle:HideInfo()
    self.Battle_Wnd.SkillTitle:SetText("Title")
    self.Battle_Wnd.SkillInfo:SetText("Info")
    self.Battle_Wnd.SkillDetails:SetVisibility(2)
end

function Gamemode_Battle:ShowSkill_1Info()
    self:ShowInfo(self.Skill_1)
end

function Gamemode_Battle:HideSkill_1Info()
    self:HideInfo(self.Skill_1)
end

function Gamemode_Battle:ShowSkill_2Info()
    self:ShowInfo(self.Skill_2)
end

function Gamemode_Battle:HideSkill_2Info()
    self:HideInfo(self.Skill_2)
end

function Gamemode_Battle:ShowSkill_3Info()
    self:ShowInfo(self.Skill_3)
end

function Gamemode_Battle:HideSkill_3Info()
    self:HideInfo(self.Skill_3)
end

function Gamemode_Battle:ShowSkill_4Info()
    self:ShowInfo(self.Skill_4)
end

function Gamemode_Battle:HideSkill_4Info()
    self:HideInfo(self.Skill_4)
end

function Gamemode_Battle:HideSkill()
    self.Battle_Wnd.Skill_1:SetVisibility(2)
    self.Battle_Wnd.Skill_2:SetVisibility(2)
    self.Battle_Wnd.Skill_3:SetVisibility(2)
    self.Battle_Wnd.Skill_4:SetVisibility(2)
end

function Gamemode_Battle:ShowSkill()
    self.Battle_Wnd.Skill_1:SetVisibility(0)
    self.Battle_Wnd.Skill_2:SetVisibility(0)
    self.Battle_Wnd.Skill_3:SetVisibility(0)
    self.Battle_Wnd.Skill_4:SetVisibility(0)
end

function Gamemode_Battle:SetPlayerHealthBar(current, max)
    self.Battle_Wnd.PlayerHealthProgressBar:SetPercent(current / max)
    self.Battle_Wnd.PlayerHealthText:SetText(current.."/"..max)
end

function Gamemode_Battle:SetEnemyHealthBar(current, max)
    self.Battle_Wnd.EnemyHealthProgressBar:SetPercent(current / max)
    self.Battle_Wnd.EnemyHealthText:SetText(current.."/"..max)
end

function Gamemode_Battle:SetPlayerEnergyBar(current, max)
    self.Battle_Wnd.PlayerEnergyProgressBar:SetPercent(current / max)
    self.Battle_Wnd.PlayerEnergyText:SetText(current.."/"..max)
end

function Gamemode_Battle:SetEnemyEnergyBar(current, max)
    self.Battle_Wnd.EnemyEnergyProgressBar:SetPercent(current / max)
    self.Battle_Wnd.EnemyEnergyText:SetText(current.."/"..max)
end

function Gamemode_Battle:SelectReward(Index)
    self.Select = Index
    for i = 1 , 3 do
        if i ~= Index then 
            self.ShowTimeEnd_Wnd["ButtonSwitch_"..i]:SetActiveWidgetIndex(0)
        else
            self.ShowTimeEnd_Wnd["ButtonSwitch_"..i]:SetActiveWidgetIndex(1)
        end
    end
    self.ShowTimeEnd_Wnd.ConfirmButton:SetVisibility(0)
end

function Gamemode_Battle:PreSelectReward(Index)
    if self.Select == nil or self.Select ~= Index then
        self.ShowTimeEnd_Wnd["ButtonSwitch_"..Index]:SetActiveWidgetIndex(1)
    end
end

function Gamemode_Battle:Unselect(Index)
    if self.Select == nil or self.Select ~= Index then
        self.ShowTimeEnd_Wnd["ButtonSwitch_"..Index]:SetActiveWidgetIndex(0)
    end
end

function Gamemode_Battle:SetSelectBox(Index,Item)
    self.ShowTimeEnd_Wnd["SelectTitle_"..Index]:SetText(Item["Title"])
    self.ShowTimeEnd_Wnd["SelectInfo_"..Index]:SetText(Item["Info"])
end

function Gamemode_Battle:CheckTheEnd()
    print("check~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("player health = ",self.Player.CurrentHealth)
    print("enemy health = ",self.Enemy.CurrentHealth)
    print("check~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    if self.Player.CurrentHealth <= 0 then
        print("Enemy win")
        self.IsEnd = true
        self.Player:K2_DestroyActor()
        return
    end
    if self.Enemy.CurrentHealth <= 0 then
        print("Player win")
        self.IsEnd = true
        self.Enemy:K2_DestroyActor()

        self.Battle_Wnd:SetVisibility(2)
        self.ShowTimeEnd_Wnd:SetVisibility(0)

        return
    end
end

function Gamemode_Battle:Damage(object,x)
    local RealDamage = math.min(x, object.CurrentHealth)
    object.CurrentHealth = object.CurrentHealth - RealDamage
    return RealDamage
end

function Gamemode_Battle:Energy(object,x)
    if object.CurrentEnergy + x < 0 then
        return false
    end
    local RealEnergy = math.min(x, object.MaxEnergy - object.CurrentEnergy)
    object.CurrentEnergy = object.CurrentEnergy + RealEnergy
    return RealEnergy
end

function Gamemode_Battle:Heal(object,x)
    local RealHeal = math.min(x, object.MaxHealth - object.CurrentHealth)
    object.CurrentHealth = object.CurrentHealth + RealHeal
    return RealHeal
end

function Gamemode_Battle:Player_Skill(skill)
    if self.IsEnd then
        print("game end")
        return
    end

    if not self.IsPlayerTurn then
        return
    end

    --结算能量
    if skill["Energy"] then
        local Energy = skill["MULEnergy"] * self.DiceValue + skill["ADDEnergy"]
        if Gamemode_Battle:Energy(self.Player,Energy) == false then
            return 
        end
    end

    --能量充足，技能启动
    print(skill["Title"])
    print(skill["Info"])

    local times = skill["Times"]
    self.TimerHandle = UE.UKismetSystemLibrary.K2_SetTimerDelegate({ self, 
        function(self)
            if not times then
                return 
            end

            local RealDamage
            local RealHeal

            if skill["Damage"] then
                local Damage = skill["MULDamage"] * self.DiceValue + skill["ADDDamage"] + self.Player.Strength
                print("Damage = ",Damage)
                RealDamage = Gamemode_Battle:Damage(self.Enemy,Damage)

                --跳出攻击数字
                if RealDamage > 0 then
                    local Blood_class = UE.UClass.Load("/Game/UMG/FloatTextBlood.FloatTextBlood_C")
                    local parent = self.Battle_Wnd.BattleCanvasPanel
                    local Blood = NewObject(Blood_class)
                    parent:AddChild(Blood)
                    Blood.Slot:SetPosition(UE.FVector2D(1300 + times * 100, -150))

                    Blood.DamageBlock:SetText("-"..RealDamage)

                    Blood:PlayAnimation(self.Battle_Wnd.Animation_Damage)
                    self.FlyBloodTimer = UE.UKismetSystemLibrary.K2_SetTimerDelegate({ self, 
                        function(self)
                            Blood:RemoveFromParent()
                        end
                    }, 1, false)
                end
            end

            if skill["Heal"] then
                local Heal = skill["MULHeal"] * self.DiceValue + skill["ADDHeal"]
                RealHeal = Gamemode_Battle:Heal(self.Player,Heal)
            end

            if skill["Vampire"] then
                local Vampire = skill["MULVampire"] * RealDamage + skill["ADDVampire"]
                RealHeal = Gamemode_Battle:Heal(self.Player,Vampire)
            end

            self.Enemy:SetHealth(self.Enemy.CurrentHealth, self.Enemy.MaxHealth)
            self.Enemy:SetEnergy(self.Enemy.CurrentEnergy, self.Enemy.MaxEnergy)
            self.Player:SetEnergy(self.Player.CurrentEnergy, self.Player.MaxEnergy)
            self.Player:SetHealth(self.Player.CurrentHealth, self.Player.MaxHealth)

            --技能结束
            times = times - 1
            if times == 0 then
                UE.UKismetSystemLibrary.K2_ClearTimerHandle(self, self.TimerHandle)
                self.TimerHandle = nil

                self:CheckTheEnd()
                if self.IsEnd then
                print("game end")
                else
                    coroutine.resume(coroutine.create(Gamemode_Battle.EnemyTurn), self)
                end
            end
        end
    }, 0.3, true)
end

function Gamemode_Battle:PlayerTurn()
    --回合标记转为true，表示Player回合开始
    self.IsPlayerTurn = true
    self.Battle_Wnd.RollingDice:SetVisibility(0)
    print("player turn")
end

function Gamemode_Battle:EnemyTurn()
    --回合标记转为false，表示Enemy回合开始
    self.IsPlayerTurn = false
    print("enemy turn")
    UE.UKismetSystemLibrary.Delay(self, 2)

    --x行动
    --self:Enemy_Attack()

    --随机抽取一个技能
    local EnemySkill = Enemy_Skill_Attack_MES
    --释放
    self:Enemy_Skill(EnemySkill)

    UE.UKismetSystemLibrary.Delay(self, 1)
end

function Gamemode_Battle:Enemy_Skill(skill)
    if self.Enemy.CurrentEnergy + skill["Energy"] < 0 then
        print("能量不足")
        return
    end

    self.Enemy.CurrentEnergy = math.min(self.Enemy.MaxEnergy, math.max(0, self.Enemy.CurrentEnergy + skill["Energy"]))
    self.Enemy:SetEnergy(self.Enemy.CurrentEnergy, self.Enemy.MaxEnergy)

    --能量充足，技能启动
    print(skill["Title"])
    print(skill["Info"])

    local times = skill["Times"]

    self.TimerHandle = UE.UKismetSystemLibrary.K2_SetTimerDelegate({ self, 
        function(self)
            if not times then
                return 
            end

            if skill["Damage"] ~= 0 and self.Player.CurrentHealth > 0 then
                --跳出攻击数字

                local Blood_class = UE.UClass.Load("/Game/UMG/FloatTextBlood.FloatTextBlood_C")
                local parent = self.Battle_Wnd.BattleCanvasPanel
                Blood = NewObject(Blood_class)
                parent:AddChild(Blood)
                Blood.Slot:SetPosition(UE.FVector2D(50 + times * 100, 50))
                Blood.DamageBlock:SetText("-"..skill["Damage"])

                Blood:PlayAnimation(self.Battle_Wnd.Animation_Damage)
                self.FlyBloodTimer = UE.UKismetSystemLibrary.K2_SetTimerDelegate({ self, 
                    function(self)
                        Blood:RemoveFromParent()
                    end
                }, 1, false)
            end

            --结算伤害
            self.Player.CurrentHealth = math.max(0, self.Player.CurrentHealth - skill["Damage"])
            self.Player:SetHealth(self.Player.CurrentHealth, self.Player.MaxHealth)

            --结算治疗量
            self.Enemy.CurrentHealth = math.min(self.Enemy.MaxHealth, self.Enemy.CurrentHealth + skill["Heal"])
            self.Enemy:SetHealth(self.Enemy.CurrentHealth, self.Enemy.MaxHealth)

            --技能结束
            times = times - 1
            if times == 0 then
                UE.UKismetSystemLibrary.K2_ClearTimerHandle(self, self.TimerHandle)
                self.TimerHandle = nil

                self:CheckTheEnd()
                if self.IsEnd then
                    print("game end")
                else
                    self:PlayerTurn()
                end
            end
        end
    }, 0.3, true)
end

function Gamemode_Battle:RollingDice()
    local RollPoint = self:GetActorByString("RollPoint")
    RollPoint:SpawnDice()
    self:GetDiceValue()
end

function Gamemode_Battle:GetDiceValue()
    local Dice = self:GetActorByString("Dice")
    local CheckPoint_1 = Dice:GetArrow_1()
    self.CheckTimer = UE.UKismetSystemLibrary.K2_SetTimerDelegate({ self, 
        function(self)
            local CheckPoint_2 = Dice:GetArrow_1()
            --比较
            if CheckPoint_1.X == CheckPoint_2.X and
            CheckPoint_1.Y == CheckPoint_2.Y and
            CheckPoint_1.Z == CheckPoint_2.Z then

                self.DiceValue = Dice:GetValue()
                print("DiceValue = ",self.DiceValue)
                self:DestroyDice()

                UE.UKismetSystemLibrary.K2_ClearTimerHandle(self, self.CheckTimer)
                self.CheckTimer = nil
            else
                --更新
                CheckPoint_1 = CheckPoint_2
            end
        end
    }, 1, true)
end

function Gamemode_Battle:DestroyDice()
    local Dice = self:GetActorByString("Dice")
    Dice:K2_DestroyActor()
    Dice = nil
    self:ShowSkill()
end

return Gamemode_Battle
