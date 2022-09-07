--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@class BP_Dice
local Dice = Class()

--function Dice:Initialize(Initializer)
--end

--function Dice:UserConstructionScript()
--end

function Dice:ReceiveBeginPlay()
    local x = math.random(-2000, 2000)
    local y = math.random(12000, 18000)
    local z = math.random(0, 500)
    self.Dice:AddImpulse(UE.FVector(x, y, z))


    self:SetRandomValue()
    self:SetValueText()

end

--function Dice:ReceiveEndPlay()
--end

-- function Dice:ReceiveTick(DeltaSeconds)
-- end

--function Dice:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function Dice:ReceiveActorBeginOverlap(OtherActor)
--end

--function Dice:ReceiveActorEndOverlap(OtherActor)
--end

function Dice:GetValue()
    local Arrow = {
        self.Arrow_1:k2_getcomponentlocation().Z,
        self.Arrow_2:k2_getcomponentlocation().Z,
        self.Arrow_3:k2_getcomponentlocation().Z,
        self.Arrow_4:k2_getcomponentlocation().Z,
        self.Arrow_5:k2_getcomponentlocation().Z,
        self.Arrow_6:k2_getcomponentlocation().Z,
    }
    --骰子的面的编号
    local mn=nil
    --骰子面的高度
    local mv=nil

    for k, v in pairs(Arrow) do
        print(v)
        if(mv == nil) then
            mv = v
            mn = k 
        end
        if mv < v then
            mv = v
            mn = k
        end
    end
    print(mn)
    --把骰子的面的编号转为骰子的面对应的值
    if mn == 1 then
        return self.Value_1
    end
    if mn == 2 then
        return self.Value_2
    end
    if mn == 3 then
        return self.Value_3
    end
    if mn == 4 then
        return self.Value_4
    end
    if mn == 5 then
        return self.Value_5
    end
    if mn == 6 then
        return self.Value_6
    end
    
end

function Dice:SetRandomValue()
    self.Value_1 = math.random(6, 6)
    self.Value_2 = math.random(6, 6)
    self.Value_3 = math.random(6, 6)
    self.Value_4 = math.random(6, 6)
    self.Value_5 = math.random(6, 6)
    self.Value_6 = math.random(6, 6)
end

function Dice:SetValueText()
    self.TextRender_1:SetText(self.Value_1)
    self.TextRender_2:SetText(self.Value_2)
    self.TextRender_3:SetText(self.Value_3)
    self.TextRender_4:SetText(self.Value_4)
    self.TextRender_5:SetText(self.Value_5)
    self.TextRender_6:SetText(self.Value_6)
end

function Dice:GetArrow_1()
    return self.Arrow_1:k2_getcomponentlocation()
end

return Dice