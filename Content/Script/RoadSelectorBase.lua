--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@class BP_RoadSelectorBase
local RoadSelectorBase = Class()

--function RoadSelectorBase:Initialize(Initializer)
--end

--function RoadSelectorBase:UserConstructionScript()
--end

local ModeClass = UE.UClass.Load("/Game/Blueprint/GameMode/BP_Gamemode_Road.BP_Gamemode_Road_C")

function RoadSelectorBase:ReceiveBeginPlay()
    self.SphereCollision.OnComponentBeginOverlap:Add(self, RoadSelectorBase.BeginOverlap)
    self.SphereCollision.OnComponentEndOverlap:Add(self, RoadSelectorBase.EndOverlap)
end

--function RoadSelectorBase:ReceiveEndPlay()
--end

-- function RoadSelectorBase:ReceiveTick(DeltaSeconds)
-- end

--function RoadSelectorBase:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function RoadSelectorBase:ReceiveActorBeginOverlap(OtherActor)
--end

--function RoadSelectorBase:ReceiveActorEndOverlap(OtherActor)
--end

local CharacterClass = UE.UClass.Load("/Game/Blueprint/PlayerCharacter/BP_RoadCharacter.BP_RoadCharacter_C")

function RoadSelectorBase:BeginOverlap(HitComponent, OtherActor, OtherComp, NormalImpulse, Hit)
    local Character = OtherActor:Cast(CharacterClass)
	if Character and self.DialogBox == nil then
        print("welcome~")
        local GameMode = UE.UGameplayStatics.GetGameMode(self)
        local RoadMode = GameMode:Cast(ModeClass)
        RoadMode:SetMode(self.Mode)
        RoadMode:ShowDialogBox()
	end
end

function RoadSelectorBase:EndOverlap(HitComponent, OtherActor, OtherComp, NormalImpulse, Hit)
    print("byebye~")
    local GameMode = UE.UGameplayStatics.GetGameMode(self)
    local RoadMode = GameMode:Cast(ModeClass)
    RoadMode:HideDialogBox()
end

return RoadSelectorBase
