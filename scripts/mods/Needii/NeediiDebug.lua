local mod = get_mod("Needii")

mod.debug.data = {
  playerInfos1 = {
    {
      hp = 0.5,
      career = "we_shade",
      ammo = 0.95,
      inv = {
        
      },
      isDowned = false,
      isDead = false,
      name = "wood_elf",
      isBot = false
    },
    {
      hp = 0.8,
      career = "es_mercenary",
      ammo = 0.4,
      inv = {

      },
      isDowned = false,
      isDead = false,
      name = "empire_soldier",
      isBot = true
    },
    {
      hp = 1,
      career = "bw_adept",
      ammo = 1,
      inv = {
        
      },
      isDowned = false,
      isDead = false,
      name = "bright_wizard",
      isBot = false
    },
    {
      hp = 0.2,
      career = "dr_ranger",
      ammo = 1,
      inv = {
        slot_healthkit = {
          name = "potion_healing_draught_01"
        },
        slot_grenade = {
          name = "grenade_frag"
        }
      },
      isDowned = false,
      isDead = false,
      name = "dwarf_ranger",
      isBot = true
    }
  },
  tests = {
    -- Bombs
    -----------------------------------
    {
      name = "Bomb (2 players (one free slot), 2 bots)",
      itemName = "grenade_frag",
      expected  = {"wood_elf", "empire_soldier", "dwarf_ranger"},
      partyInfo = {
        {
          hp = 1,
          career = "we_shade",
          ammo = 1,
          inv = {
            slot_healthkit = {
              name = "potion_healing_draught_01"
            }
          },
          isDowned = false,
          isDead = false,
          name = "wood_elf",
          isBot = false
        },
        {
          hp = 0.8,
          career = "es_mercenary",
          ammo = 0.4,
          inv = {
            slot_healthkit = {
              name = "potion_healing_draught_01"
            }
          },
          isDowned = false,
          isDead = false,
          name = "empire_soldier",
          isBot = true
        },
        {
          hp = 1,
          career = "bw_adept",
          ammo = 1,
          inv = {
            slot_healthkit = {
              name = "potion_healing_draught_01"
            },
            slot_grenade = {
              name = "grenade_frag"
            }
          },
          isDowned = false,
          isDead = true,
          name = "bright_wizard",
          isBot = false
        },
        {
          hp = 1,
          career = "dr_ranger",
          ammo = 1,
          inv = {
            slot_healthkit = {
              name = "potion_healing_draught_01"
            }
          },
          isDowned = false,
          isDead = false,
          name = "dwarf_ranger",
          isBot = true
        }
      }
    },
    {
      name = "Bomb (1 player, 3 bots)",
      itemName = "grenade_frag",
      expected  = {"wood_elf", "bright_wizard", "empire_soldier", "dwarf_ranger"},
      partyInfo = {
        {
          hp = 1,
          career = "we_shade",
          ammo = 1,
          inv = {
            slot_healthkit = {
              name = "potion_healing_draught_01"
            }
          },
          isDowned = false,
          isDead = false,
          name = "wood_elf",
          isBot = false
        },
        {
          hp = 0.8,
          career = "es_mercenary",
          ammo = 0.4,
          inv = {
            slot_healthkit = {
              name = "potion_healing_draught_01"
            }
          },
          isDowned = false,
          isDead = false,
          name = "empire_soldier",
          isBot = true
        },
        {
          hp = 1,
          career = "bw_adept",
          ammo = 1,
          inv = {
            slot_healthkit = {
              name = "potion_healing_draught_01"
            }
          },
          isDowned = false,
          isDead = false,
          name = "bright_wizard",
          isBot = true
        },
        {
          hp = 1,
          career = "dr_ranger",
          ammo = 1,
          inv = {
            slot_healthkit = {
              name = "potion_healing_draught_01"
            }
          },
          isDowned = false,
          isDead = false,
          name = "dwarf_ranger",
          isBot = true
        }
      }
    },

    -- Pots
    -----------------------------------
    {
      name = "DMG Pot (3 player, 1 bots)",
      itemName = "potion_damage_boost_01",
      expected  = {"wood_elf", "bright_wizard", "empire_soldier", "dwarf_ranger"},
      partyInfo = {
        {
          hp = 1,
          career = "we_shade",
          ammo = 1,
          inv = {
            
          },
          isDowned = false,
          isDead = false,
          name = "wood_elf",
          isBot = false
        },
        {
          hp = 0.8,
          career = "es_mercenary",
          ammo = 0.4,
          inv = {
            slot_potion = {
              name = "potion_damage_boost_01"
            }
          },
          isDowned = false,
          isDead = false,
          name = "empire_soldier",
          isBot = false
        },
        {
          hp = 1,
          career = "bw_adept",
          ammo = 1,
          inv = {
            slot_potion = {
              name = "potion_damage_boost_01"
            }
          },
          isDowned = false,
          isDead = false,
          name = "bright_wizard",
          isBot = false
        },
        {
          hp = 1,
          career = "dr_ranger",
          ammo = 1,
          inv = {
            slot_potion = {
              name = "potion_damage_boost_01"
            }
          },
          isDowned = false,
          isDead = false,
          name = "dwarf_ranger",
          isBot = true
        }
      }
    },

    -- Ammo
    -----------------------------------
    {
      name = "Ammo 1 empty (3 player, 1 bots)",
      itemName = "interaction_ammunition",
      expected  = {"wood_elf", "empire_soldier", "dwarf_ranger", "bright_wizard"},
      partyInfo = {
        {
          hp = 1,
          career = "we_shade",
          ammo = 0,
          inv = {
          },
          isDowned = false,
          isDead = false,
          name = "wood_elf",
          isBot = false
        },
        {
          hp = 0.8,
          career = "es_mercenary",
          ammo = 0.4,
          inv = {
          },
          isDowned = false,
          isDead = false,
          name = "empire_soldier",
          isBot = false
        },
        {
          hp = 1,
          career = "bw_adept",
          ammo = 1,
          inv = {
          },
          isDowned = false,
          isDead = false,
          name = "bright_wizard",
          isBot = false
        },
        {
          hp = 1,
          career = "dr_ranger",
          ammo = 0.7,
          inv = {
          },
          isDowned = false,
          isDead = false,
          name = "dwarf_ranger",
          isBot = true
        }
      }
    },
    {
      name = "Ammo 2 equal (3 player, 1 bots)",
      itemName = "interaction_ammunition",
      expected  = {"wood_elf", "empire_soldier", "dwarf_ranger", "bright_wizard"},
      partyInfo = {
        {
          hp = 1,
          career = "we_shade",
          ammo = 0.5,
          inv = {
          },
          isDowned = false,
          isDead = false,
          name = "wood_elf",
          isBot = false
        },
        {
          hp = 0.8,
          career = "es_mercenary",
          ammo = 0.8,
          inv = {
          },
          isDowned = false,
          isDead = false,
          name = "empire_soldier",
          isBot = false
        },
        {
          hp = 1,
          career = "bw_adept",
          ammo = 1,
          inv = {
          },
          isDowned = false,
          isDead = false,
          name = "bright_wizard",
          isBot = false
        },
        {
          hp = 1,
          career = "dr_ranger",
          ammo = 0.8,
          inv = {
          },
          isDowned = false,
          isDead = false,
          name = "dwarf_ranger",
          isBot = true
        }
      }
    }
  }
}