require "UnLua"

local M = Class()

function M:ReceiveInit()
	print("yeyeyeyeye!!!")

    self.PlayerAttributes = {
        ["CurrentHealth"] = 30,
        ["MaxHealth"] = 30,
        ["CurrentEnergy"] = 20,
        ["MaxEnergy"] = 20,
        ["Strength"] = 3,
        ["Agility"] = 0,
        ["Intelligence"] = 0,
    }

    self.UseSkills = {
        1,
        2,
        5,
        6,
    }

    self.PlayerActiveSkills = {
        [1] = 1,
        [2] = 1,
        [3] = 1,
        [4] = 1,
        [5] = 1,
        [6] = 1,
    }

    --长期生效
    self.PlayerPassiveSkills = {

    }

    self.GachaPool = {
        [1] = {1,1},
        [2] = {1,2},
        [3] = {1,3},
        [4] = {1,4},
        [5] = {1,5},
        [6] = {1,6},
    }
end

function M:ReceiveShutdown()
    print("yeyeyeyeye!")
end

function M:momoo()
    print("brave big lulu")
end

Player_Skill_Attack_MES = {
    ["Title"] = "基础攻击",
    ["Info"] = "消耗1点能量，造成x点伤害",
    ["Energy"] = -1,
    ["Damage"] = 0,
    ["Heal"] = nil,
    ["Times"] = 1,
}

Player_Skill_Heal_MES = {
    ["Title"] = "基础回复生命",
    ["Info"] = "消耗5点能量，回复x点生命",
    ["Energy"] = -5,
    ["Damage"] = nil,
    ["Heal"] = 0,
    ["Times"] = 1,
}

Player_Skill_Energy_MES = {
    ["Title"] = "基础回复能量",
    ["Info"] = "回复3点能量",
    ["Energy"] = 3,
    ["Damage"] = nil,
    ["Heal"] = nil,
    ["Times"] = 1,
}

Player_Skill_Attack_T3_MES = {
    ["Title"] = "三连攻击",
    ["Info"] = "消耗5点能量，造成x点伤害3次",
    ["Energy"] = -5,
    ["Damage"] = 0,
    ["Heal"] = nil,
    ["Times"] = 3,
}

Enemy_Skill_Attack_MES = {
    ["Title"] = "基础攻击",
    ["Info"] = "消耗1点能量，造成5点伤害",
    ["Energy"] = -1,
    ["Damage"] = 5,
    ["Heal"] = 0,
    ["Times"] = 1,
}


ActiveSkills = {
    [1] = {
        [1] = {
            ["Title"] = "普通攻击：1阶",
            ["Info"] = "消耗1点能量，造成0 + x点伤害",

            ["Energy"] = true,
            ["ADDEnergy"] = -1,
            ["MULEnergy"] = 0,

            ["Damage"] = true,
            ["ADDDamage"] = 0,
            ["MULDamage"] = 1,

            ["Heal"] = false,
            ["ADDHeal"] = 0,
            ["MULHeal"] = 0,

            ["Times"] = 1,
            ["Type"] = 1, 
            ["ID"] = 1, 
            ["Level"] = 1, 
        },

        [2] = {
            ["Title"] = "普通攻击：2阶",
            ["Info"] = "消耗1点能量，造成1 + x点伤害",
            
            ["Energy"] = true,
            ["ADDEnergy"] = -1,
            ["MULEnergy"] = 0,

            ["Damage"] = true,
            ["ADDDamage"] = 1,
            ["MULDamage"] = 1,

            ["Heal"] = false,
            ["ADDHeal"] = 0,
            ["MULHeal"] = 0,

            ["Times"] = 1,
            ["Type"] = 1, 
            ["ID"] = 1, 
            ["Level"] = 2, 
        },

        [3] = {
            ["Title"] = "普通攻击：3阶",
            ["Info"] = "消耗1点能量，造成2 + x点伤害",
            
            ["Energy"] = true,
            ["ADDEnergy"] = -1,
            ["MULEnergy"] = 0,

            ["Damage"] = true,
            ["ADDDamage"] = 2,
            ["MULDamage"] = 1,

            ["Heal"] = false,
            ["ADDHeal"] = 0,
            ["MULHeal"] = 0,            

            ["Times"] = 1,
            ["Type"] = 1, 
            ["ID"] = 1, 
            ["Level"] = 3, 
        },
    },
    [2] = {
        [1] = {
            ["Title"] = "回复生命：1阶",
            ["Info"] = "消耗5点能量，回复5点生命",
            
            ["Energy"] = true,
            ["ADDEnergy"] = -5,
            ["MULEnergy"] = 0,

            ["Damage"] = false,
            ["ADDDamage"] = 0,
            ["MULDamage"] = 0,

            ["Heal"] = true,
            ["ADDHeal"] = 5,
            ["MULHeal"] = 0,

            ["Times"] = 1,
            ["Type"] = 1, 
            ["ID"] = 2, 
            ["Level"] = 1, 
        },

        [2] = {
            ["Title"] = "回复生命：2阶",
            ["Info"] = "消耗5点能量，回复7点生命",
            
            ["Energy"] = true,
            ["ADDEnergy"] = -5,
            ["MULEnergy"] = 0,

            ["Damage"] = false,
            ["ADDDamage"] = 0,
            ["MULDamage"] = 0,

            ["Heal"] = true,
            ["ADDHeal"] = 7,
            ["MULHeal"] = 0,

            ["Times"] = 1,
            ["Type"] = 1, 
            ["ID"] = 2, 
            ["Level"] = 2, 
        },

        [3] = {
            ["Title"] = "回复生命：3阶",
            ["Info"] = "消耗6点能量，回复10点生命",
            
            ["Energy"] = true,
            ["ADDEnergy"] = -5,
            ["MULEnergy"] = 0,

            ["Damage"] = false,
            ["ADDDamage"] = 0,
            ["MULDamage"] = 0,

            ["Heal"] = true,
            ["ADDHeal"] = 10,
            ["MULHeal"] = 0,

            ["Times"] = 1,
            ["Type"] = 1, 
            ["ID"] = 2, 
            ["Level"] = 3, 
        },
    },
    [3] = {
        [1] = {
            ["Title"] = "回复能量：1阶",
            ["Info"] = "回复1 + x点能量",
            
            ["Energy"] = true,
            ["ADDEnergy"] = 1,
            ["MULEnergy"] = 1,

            ["Damage"] = false,
            ["ADDDamage"] = 0,
            ["MULDamage"] = 0,

            ["Heal"] = false,
            ["ADDHeal"] = 0,
            ["MULHeal"] = 0,

            ["Times"] = 1,
            ["Type"] = 1, 
            ["ID"] = 3, 
            ["Level"] = 1, 
        },

        [2] = {
            ["Title"] = "回复能量：2阶",
            ["Info"] = "回复2 + x点能量",

            ["Energy"] = true,
            ["ADDEnergy"] = 2,
            ["MULEnergy"] = 1,

            ["Damage"] = false,
            ["ADDDamage"] = 0,
            ["MULDamage"] = 0,

            ["Heal"] = false,
            ["ADDHeal"] = 0,
            ["MULHeal"] = 0,

            ["Times"] = 1,
            ["Type"] = 1, 
            ["ID"] = 3, 
            ["Level"] = 2, 
        },

        [3] = {
            ["Title"] = "回复能量：3阶",
            ["Info"] = "回复3 + x点能量",
            
            ["Energy"] = true,
            ["ADDEnergy"] = 3,
            ["MULEnergy"] = 1,

            ["Damage"] = false,
            ["ADDDamage"] = 0,
            ["MULDamage"] = 0,

            ["Heal"] = false,
            ["ADDHeal"] = 0,
            ["MULHeal"] = 0,

            ["Times"] = 1,
            ["Type"] = 1, 
            ["ID"] = 3, 
            ["Level"] = 3, 
        },
    },
    [4] = {
        [1] = {
            ["Title"] = "连续攻击：1阶",
            ["Info"] = "消耗10点能量，造成x - 1点伤害3次",
            
            ["Energy"] = true,
            ["ADDEnergy"] = -10,
            ["MULEnergy"] = 0,

            ["Damage"] = true,
            ["ADDDamage"] = -1,
            ["MULDamage"] = 1,

            ["Heal"] = false,
            ["ADDHeal"] = 0,
            ["MULHeal"] = 0,

            ["Times"] = 3,
            ["Type"] = 1, 
            ["ID"] = 4, 
            ["Level"] = 1, 
        },

        [2] = {
            ["Title"] = "连续攻击：2阶",
            ["Info"] = "消耗10点能量，造成x - 1点伤害4次",
            
            ["Energy"] = true,
            ["ADDEnergy"] = -10,
            ["MULEnergy"] = 0,

            ["Damage"] = true,
            ["ADDDamage"] = -1,
            ["MULDamage"] = 1,

            ["Heal"] = false,
            ["ADDHeal"] = 0,
            ["MULHeal"] = 0,

            ["Times"] = 4,
            ["Type"] = 1, 
            ["ID"] = 4, 
            ["Level"] = 2, 
        },

        [3] = {
            ["Title"] = "连续攻击：3阶",
            ["Info"] = "消耗10点能量，造成x - 1点伤害5次",
            
            ["Energy"] = true,
            ["ADDEnergy"] = -10,
            ["MULEnergy"] = 0,

            ["Damage"] = true,
            ["ADDDamage"] = -1,
            ["MULDamage"] = 1,

            ["Heal"] = false,
            ["ADDHeal"] = 0,
            ["MULHeal"] = 0,

            ["Times"] = 5,
            ["Type"] = 1, 
            ["ID"] = 4, 
            ["Level"] = 3, 
        },
    },
    --需要增加机制才能使用
    [5] = {
        [1] = {
            ["Title"] = "狂怒攻击：1阶",
            ["Info"] = "消耗2 * x点生命，造成2 * x点伤害",
            
            ["Energy"] = false,
            ["ADDEnergy"] = 0,
            ["MULEnergy"] = 0,

            ["Damage"] = true,
            ["ADDDamage"] = 0,
            ["MULDamage"] = 2,

            ["Heal"] = true,
            ["ADDHeal"] = 0,
            ["MULHeal"] = -2,

            ["Times"] = 1,
            ["Type"] = 1, 
            ["ID"] = 5, 
            ["Level"] = 1, 
        },

        [2] = {
            ["Title"] = "狂怒攻击：2阶",
            ["Info"] = "消耗2 * x点生命，造成3 * x点伤害",
            
            ["Energy"] = false,
            ["ADDEnergy"] = 0,
            ["MULEnergy"] = 0,

            ["Damage"] = true,
            ["ADDDamage"] = 0,
            ["MULDamage"] = 3,

            ["Heal"] = true,
            ["ADDHeal"] = 0,
            ["MULHeal"] = -2,

            ["Times"] = 1,
            ["Type"] = 1, 
            ["ID"] = 5, 
            ["Level"] = 2, 
        },

        [3] = {
            ["Title"] = "狂怒攻击：3阶",
            ["Info"] = "消耗2 * x点生命，造成4 * x点伤害",
            
            ["Energy"] = false,
            ["ADDEnergy"] = 0,
            ["MULEnergy"] = 0,

            ["Damage"] = true,
            ["ADDDamage"] = 0,
            ["MULDamage"] = 4,

            ["Heal"] = true,
            ["ADDHeal"] = 0,
            ["MULHeal"] = -2,

            ["Times"] = 1,
            ["Type"] = 1, 
            ["ID"] = 5, 
            ["Level"] = 3, 
        },
    },
    --需要增加机制才能使用
    [6] = {
        [1] = {
            ["Title"] = "吸血攻击：1阶",
            ["Info"] = "消耗5点能量，造成x - 1点伤害,回复伤害一半的血量",
            
            ["Energy"] = true,
            ["ADDEnergy"] = -5,
            ["MULEnergy"] = 0,

            ["Damage"] = true,
            ["ADDDamage"] = -1,
            ["MULDamage"] = 1,

            ["Vampire"] = true,
            ["ADDVampire"] = 0,
            ["MULVampire"] = 0.5,

            ["Times"] = 1,
            ["Type"] = 1, 
            ["ID"] = 6, 
            ["Level"] = 1, 
        },

        [2] = {
            ["Title"] = "吸血攻击：2阶",
            ["Info"] = "消耗5点能量，造成1 + x点伤害,回复伤害一半的血量",
            
            ["Energy"] = true,
            ["ADDEnergy"] = -5,
            ["MULEnergy"] = 0,

            ["Damage"] = true,
            ["ADDDamage"] = 1,
            ["MULDamage"] = 1,

            ["Vampire"] = true,
            ["ADDVampire"] = 0,
            ["MULVampire"] = 0.5,

            ["Times"] = 1,
            ["Type"] = 1, 
            ["ID"] = 6, 
            ["Level"] = 2, 
        },

        [3] = {
            ["Title"] = "吸血攻击：3阶",
            ["Info"] = "消耗5点能量，造成3 + x点伤害,回复伤害一半的血量",
            
            ["Energy"] = true,
            ["ADDEnergy"] = -5,
            ["MULEnergy"] = 0,

            ["Damage"] = true,
            ["ADDDamage"] = 3,
            ["MULDamage"] = 1,

            ["Vampire"] = true,
            ["ADDVampire"] = 0,
            ["MULVampire"] = 0.5,

            ["Times"] = 1,
            ["Type"] = 1, 
            ["ID"] = 6, 
            ["Level"] = 3, 
        },
    },
}

--长期生效
PassiveSkills = {
    [1] = {
        [1] = {
            ["Title"] = "增强力量：1阶",
            ["Info"] = "对敌人的伤害 + 1",
            ["Value"] = 1,
            ["Function"] = M.AddStrength(),
        },
        [2] = {
            ["Title"] = "增强力量：2阶",
            ["Info"] = "对敌人的伤害 + 2",
            ["Value"] = 2,
            ["Function"] = M.AddStrength(),
        },
        [3] = {
            ["Title"] = "增强力量：3阶",
            ["Info"] = "对敌人的伤害 + 3",
            ["Value"] = 3,
            ["Function"] = M.AddStrength(),
        },
    },
}

function M:AddStrength(x)
    self.PlayerAttributes["Strength"] = x
end

return M
