--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@class BP_NormalEnemy
local NormalEnemy = Class()

--function NormalEnemy:Initialize(Initializer)
--end

--function NormalEnemy:UserConstructionScript()
--end

function NormalEnemy:ReceiveBeginPlay()
    self:SetHealth(20,20)
    self:SetEnergy(20,20)
end

--function NormalEnemy:ReceiveEndPlay()
--end

-- function NormalEnemy:ReceiveTick(DeltaSeconds)
-- end

--function NormalEnemy:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function NormalEnemy:ReceiveActorBeginOverlap(OtherActor)
--end

--function NormalEnemy:ReceiveActorEndOverlap(OtherActor)
--end

local ModeClass = UE.UClass.Load("/Game/Blueprint/GameMode/BP_Gmaemode_Battle.BP_Gmaemode_Battle_C")

function NormalEnemy:SetHealth(health, max)
    self.CurrentHealth = health
    self.MaxHealth = max

    local GameMode = UE.UGameplayStatics.GetGameMode(self)
    local BattleMode = GameMode:Cast(ModeClass)
    if BattleMode then
        BattleMode:SetEnemyHealthBar(self.CurrentHealth,self.MaxHealth)
    end

    --print("NormalEnemy Health = ", self.CurrentHealth)
    --if self.CurrentHealth <= 0 then
        --self:K2_DestroyActor()
    --end
    
end

function NormalEnemy:SetEnergy(energy, max)
    self.CurrentEnergy = energy
    self.MaxEnergy = max

    --print("NormalEnemy Energy = ", self.CurrentEnergy)

    local GameMode = UE.UGameplayStatics.GetGameMode(self)
    local BattleMode = GameMode:Cast(ModeClass)

    if BattleMode then
        BattleMode:SetEnemyEnergyBar(self.CurrentEnergy,self.MaxEnergy)
    end
    
end

return NormalEnemy
