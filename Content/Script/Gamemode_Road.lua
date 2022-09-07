--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@class BP_Gamemode_Road
local Gamemode_Road = Class()

--function Gamemode_Road:Initialize(Initializer)
--end

--function Gamemode_Road:UserConstructionScript()
--end

function Gamemode_Road:ReceiveBeginPlay()
    local widget_class = UE.UClass.Load("/Game/UMG/RoadHUD.RoadHUD_C")
    self.Road_Wnd = NewObject(widget_class, self)
    self.Road_Wnd:AddToViewport()

    self.Road_Wnd.ConfirmButon.OnClicked:Add(self, self.OnConfirmButonClicked)
    self.Road_Wnd.CancelButton.OnClicked:Add(self, self.OnCancelButtonClicked)

    self.Road_Wnd.BagButton.OnClicked:Add(self, self.OnBagButtonClicked)

    local Bag_class = UE.UClass.Load("/Game/UMG/BagHUD.BagHUD_C")
    self.Bag_Wnd = NewObject(Bag_class, self)
    self.Bag_Wnd:AddToViewport()

    self.Bag_Wnd.CloseButton.OnClicked:Add(self, self.OnCloseButtonClicked)

    self.Mode = 0
end

--function Gamemode_Road:ReceiveEndPlay()
--end

-- function Gamemode_Road:ReceiveTick(DeltaSeconds)
-- end

--function Gamemode_Road:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function Gamemode_Road:ReceiveActorBeginOverlap(OtherActor)
--end

--function Gamemode_Road:ReceiveActorEndOverlap(OtherActor)
--end

function Gamemode_Road:OnConfirmButonClicked()
    print("self.Mode = ",self.Mode)
    if self.Mode == 0 then
        print("进入默认关卡")
        UE.UGameplayStatics.OpenLevel(self, "Battle")
        return
    end

    if self.Mode == 1 then
        print("进入战斗关卡")
        UE.UGameplayStatics.OpenLevel(self, "Battle")
        return
    end

    if self.Mode == 2 then
        print("进入宝藏关卡")
        UE.UGameplayStatics.OpenLevel(self, "Road")
        return
    end
end

function Gamemode_Road:OnCancelButtonClicked()
    self.Road_Wnd.DialogBox:SetVisibility(2)
end

function Gamemode_Road:OnBagButtonClicked()
    print("打开背包")
    self.Bag_Wnd:SetVisibility(0)
    self.Road_Wnd.BagButton:SetVisibility(2)
end

function Gamemode_Road:OnCloseButtonClicked()
    print("关闭背包")
    self.Bag_Wnd:SetVisibility(2)
    self.Road_Wnd.BagButton:SetVisibility(0)
end

function Gamemode_Road:HideDialogBox()
    self.Road_Wnd.DialogBox:SetVisibility(2)
end

function Gamemode_Road:ShowDialogBox()
    self.Road_Wnd.DialogBox:SetVisibility(0)
end

function Gamemode_Road:SetMode(num)
    self.Mode = num
    if self.Mode == 0 then
        self.Road_Wnd.Title:SetText("默认")
    end
    if self.Mode == 1 then
        self.Road_Wnd.Title:SetText("战斗")
    end
    if self.Mode == 2 then
        self.Road_Wnd.Title:SetText("宝藏")
    end
end

return Gamemode_Road
