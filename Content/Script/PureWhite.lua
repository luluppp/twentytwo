--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@class BP_PureWhite
local PureWhite = Class()

--function PureWhite:Initialize(Initializer)
--end

--function PureWhite:UserConstructionScript()
--end

function PureWhite:ReceiveBeginPlay()
    local GameInstance = UE.UGameplayStatics.GetGameInstance(self)

    self:SetHealth(GameInstance.PlayerAttributes["CurrentHealth"], GameInstance.PlayerAttributes["MaxHealth"])
    self:SetEnergy(GameInstance.PlayerAttributes["CurrentEnergy"], GameInstance.PlayerAttributes["MaxEnergy"])
    self:SetStrength(GameInstance.PlayerAttributes["Strength"])
    self:SetAgility(GameInstance.PlayerAttributes["Agility"])
    self:SetIntelligence(GameInstance.PlayerAttributes["Intelligence"])

end

--function PureWhite:ReceiveEndPlay()
--end

-- function PureWhite:ReceiveTick(DeltaSeconds)
-- end

--function PureWhite:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function PureWhite:ReceiveActorBeginOverlap(OtherActor)
--end

--function PureWhite:ReceiveActorEndOverlap(OtherActor)
--end

local ModeClass = UE.UClass.Load("/Game/Blueprint/GameMode/BP_Gmaemode_Battle.BP_Gmaemode_Battle_C")

function PureWhite:SetHealth(health, max)
    self.CurrentHealth = health
    self.MaxHealth = max

    local GameMode = UE.UGameplayStatics.GetGameMode(self)
    local BattleMode = GameMode:Cast(ModeClass)

    if BattleMode then
        BattleMode:SetPlayerHealthBar(self.CurrentHealth,self.MaxHealth)
    end

    --print("PureWhite Health = ", self.CurrentHealth)
    --if self.CurrentHealth <= 0 then
        --self:K2_DestroyActor()
    --end
    
end

function PureWhite:SetEnergy(energy, max)
    self.CurrentEnergy = energy
    self.MaxEnergy = max

    --print("PureWhite Energy = ", self.CurrentEnergy)

    local GameMode = UE.UGameplayStatics.GetGameMode(self)
    local BattleMode = GameMode:Cast(ModeClass)

    if BattleMode then
        BattleMode:SetPlayerEnergyBar(self.CurrentEnergy,self.MaxEnergy)
    end
    
end

function PureWhite:SetStrength(x)
    self.Strength = x
end

function PureWhite:SetAgility(x)
    self.Agility = x
end

function PureWhite:SetIntelligence(x)
    self.Intelligence = x
end

return PureWhite
