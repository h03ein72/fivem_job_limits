Config = {}

-- Define your jobs to make slot limiter
Config.Jobs = {

    -- govermental jobs
    ["police"] = {Slot= 15, Allow= 10},
    ["sheriff"] = {Slot= 4, Allow= 10},
    ["ambulance"] = {Slot= 6, Allow= 3},
    ["mechanic"] = {Slot= 4, Allow= 4},
    ["taxi"] = {Slot= 4, Allow= 4},

    -- vip mafia / family / gangs
    ["mafia"] = {Slot= 8, Allow= 5},
    ["gang_ballas"] = {Slot= 6, Allow= 5},

}
