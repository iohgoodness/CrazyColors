
local DB = {}

DB = {
    Stats = {
        Level = 0,
        XP = 0,
        Armor = 0,
        HypothermalInsulation = 0,
        HyperthermalInsulation = 0,
        HeatFeeling = 50, --# Cold=0 Hot=100
        Hunger = 50, --# Starvation=0 Full=100
        Thirst = 50, --# Thirsty=0 Full=100
        AvailableSkillPoints = 0,
        SkillPoints = {
            Health = 100,
            Stamina = 100,
            Oxygen = 100,
            Food = 100,
            Water = 100,
            Weight = 100,
            MeleeDamage = 100,
            MovementSpeed = 100,
            CraftingSpeed = 100,
            Fortitude = 100,
            Torpidity = 100,
        },
    },
    Inventory = {

    },
    Engrams = {
        Unlocked = {

        },
    },
}

return DB