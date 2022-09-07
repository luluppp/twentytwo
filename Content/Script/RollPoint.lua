--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@class BP_RollPoint
local RollPoint = Class()

--function RollPoint:Initialize(Initializer)
--end

--function RollPoint:UserConstructionScript()
--end

function RollPoint:ReceiveBeginPlay()
end

--function RollPoint:ReceiveEndPlay()
--end

-- function RollPoint:ReceiveTick(DeltaSeconds)
-- end

--function RollPoint:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function RollPoint:ReceiveActorBeginOverlap(OtherActor)
--end

--function RollPoint:ReceiveActorEndOverlap(OtherActor)
--end

function RollPoint:SpawnDice()
    local Rotation = UE.FRotator(math.random(-180, 180),math.random(-180, 180),math.random(-180, 180))
    local World = self:GetWorld()
    local SpawnClass = UE.UClass.Load("/Game/Blueprint/Props/BP_Dice.BP_Dice_C")
    
    local Transform = UE.FTransform(Rotation:ToQuat(), self:K2_GetActorLocation())
    local sp = UE.FActorSpawnParameters()
	sp.SpawnCollisionHandlingOverride = UE.ESpawnActorCollisionHandlingMethod.AlwaysSpawn
	sp.Owner = self
	sp.Instigator = self

    local AlwaysSpawn = UE.ESpawnActorCollisionHandlingMethod.AlwaysSpawn
    self.Dice = World:SpawnActor(SpawnClass, Transform, sp)
end

return RollPoint
