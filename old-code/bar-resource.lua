["Guardian Rage"] = {
            ["user_y"] = 0,
            ["iconSource"] = -1,
            ["user_x"] = 0,
            ["xOffset"] = 0,
            ["adjustedMax"] = "",
            ["yOffset"] = 0,
            ["anchorPoint"] = "CENTER",
            ["sparkRotation"] = 0,
            ["textureInput"] = "Legionfall_BarFrame-Glow",
            ["url"] = "https://wago.io/yn2XaJbM8/7",
            ["icon"] = false,
            ["icon_color"] = {1, 1, 1, 1},
            ["enableGradient"] = false,
            ["selfPoint"] = "CENTER",
            ["barColor"] = {1, 0.90980398654938, 0.14509804546833, 1},
            ["desaturate"] = false,
            ["rotation"] = 0,
            ["font"] = "Friz Quadrata TT",
            ["sparkOffsetY"] = 0,
            ["gradientOrientation"] = "HORIZONTAL",
            ["load"] = {
                ["use_petbattle"] = false,
                ["use_never"] = false,
                ["talent"] = {
                    ["multi"] = {}
                },
                ["use_vehicle"] = false,
                ["use_class_and_spec"] = false,
                ["class_and_spec"] = {
                    ["multi"] = {
                        [103] = true,
                        [104] = true,
                        [105] = true,
                        [102] = true
                    }
                },
                ["use_dragonriding"] = false,
                ["spec_position"] = {},
                ["use_vehicleUi"] = false,
                ["spec"] = {
                    ["multi"] = {}
                },
                ["class"] = {
                    ["multi"] = {}
                },
                ["ingroup"] = {
                    ["multi"] = {
                        ["group"] = true,
                        ["raid"] = true
                    }
                },
                ["size"] = {
                    ["multi"] = {}
                }
            },
            ["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
            ["startAngle"] = 0,
            ["smoothProgress"] = true,
            ["useAdjustededMin"] = false,
            ["regionType"] = "progresstexture",
            ["blendMode"] = "BLEND",
            ["slantMode"] = "INSIDE",
            ["texture"] = "Clean",
            ["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
            ["spark"] = false,
            ["tocversion"] = 110002,
            ["alpha"] = 1,
            ["uid"] = "PhBdS8ikfQi",
            ["backgroundOffset"] = 2,
            ["sparkOffsetX"] = 0,
            ["wagoID"] = "yn2XaJbM8",
            ["parent"] = "Wrapper - Hiding out of Combat - Bars",
            ["adjustedMin"] = "",
            ["desaturateBackground"] = false,
            ["sparkRotationMode"] = "AUTO",
            ["desaturateForeground"] = true,
            ["triggers"] = {
                {
                    ["trigger"] = {
                        ["type"] = "unit",
                        ["use_absorbHealMode"] = true,
                        ["nameplateType"] = "hostile",
                        ["subeventSuffix"] = "_CAST_START",
                        ["use_absorbMode"] = true,
                        ["event"] = "Power",
                        ["names"] = {},
                        ["unit"] = "player",
                        ["powertype"] = 1,
                        ["spellIds"] = {},
                        ["use_unit"] = true,
                        ["use_nameplateType"] = false,
                        ["subeventPrefix"] = "SPELL",
                        ["use_powertype"] = true,
                        ["debuffType"] = "HELPFUL"
                    },
                    ["untrigger"] = {}
                },
                {
                    ["trigger"] = {
                        ["type"] = "unit",
                        ["use_absorbHealMode"] = true,
                        ["subeventSuffix"] = "_CAST_START",
                        ["use_absorbMode"] = true,
                        ["event"] = "Stance/Form/Aura",
                        ["unit"] = "player",
                        ["names"] = {},
                        ["spellIds"] = {},
                        ["use_unit"] = true,
                        ["use_form"] = true,
                        ["form"] = {
                            ["single"] = 1
                        },
                        ["subeventPrefix"] = "SPELL",
                        ["debuffType"] = "HELPFUL"
                    },
                    ["untrigger"] = {}
                },
                ["disjunctive"] = "all",
                ["activeTriggerMode"] = -10
            },
            ["endAngle"] = 360,
            ["internalVersion"] = 88,
            ["progressSource"] = {-1, ""},
            ["animation"] = {
                ["start"] = {
                    ["easeStrength"] = 3,
                    ["type"] = "none",
                    ["duration_type"] = "seconds",
                    ["easeType"] = "none"
                },
                ["main"] = {
                    ["easeStrength"] = 3,
                    ["type"] = "none",
                    ["duration_type"] = "seconds",
                    ["easeType"] = "none"
                },
                ["finish"] = {
                    ["easeStrength"] = 3,
                    ["type"] = "none",
                    ["duration_type"] = "seconds",
                    ["easeType"] = "none"
                }
            },
            ["version"] = 7,
            ["subRegions"] = {{
                ["type"] = "subbackground"
            }, {
                ["text_text_format_t_time_precision"] = 1,
                ["text_text_format_t_time_legacy_floor"] = false,
                ["text_shadowColor"] = {0, 0, 0, 1},
                ["text_fixedWidth"] = 64,
                ["text_text_format_c_format"] = "none",
                ["rotateText"] = "NONE",
                ["text_color"] = {0.8705883026123, 1, 0.87450987100601, 1},
                ["text_shadowYOffset"] = -1,
                ["text_wordWrap"] = "WordWrap",
                ["text_fontType"] = "OUTLINE",
                ["text_fontSize"] = 15,
                ["anchorXOffset"] = 0,
                ["text_text_format_p_time_mod_rate"] = true,
                ["text_selfPoint"] = "AUTO",
                ["text_automaticWidth"] = "Auto",
                ["text_text_format_t_time_format"] = 0,
                ["anchorYOffset"] = 0,
                ["text_justify"] = "CENTER",
                ["text_text_format_t_format"] = "timed",
                ["type"] = "subtext",
                ["text_visible"] = true,
                ["text_font"] = "2002 Bold",
                ["text_text_format_p_format"] = "timed",
                ["text_text_format_p_time_legacy_floor"] = false,
                ["text_text_format_1.percentpower_format"] = "none",
                ["text_text"] = "%p",
                ["text_text_format_t_time_mod_rate"] = true,
                ["text_text_format_p_time_dynamic_threshold"] = 60,
                ["text_text_format_p_time_format"] = 0,
                ["anchor_point"] = "INNER_CENTER",
                ["text_shadowXOffset"] = 1,
                ["text_text_format_p_time_precision"] = 1,
                ["text_text_format_t_time_dynamic_threshold"] = 60
            }, {
                ["type"] = "subborder",
                ["border_size"] = 2,
                ["border_visible"] = false,
                ["border_color"] = {1, 1, 1, 1},
                ["anchor_area"] = "bar",
                ["border_edge"] = "Square Full White",
                ["border_offset"] = 0
            }},
            ["height"] = 30,
            ["textureSource"] = "Picker",
            ["backgroundTexture"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura3",
            ["sparkBlendMode"] = "ADD",
            ["useAdjustededMax"] = false,
            ["fontSize"] = 12,
            ["source"] = "import",
            ["barColor2"] = {1, 1, 0, 1},
            ["crop_x"] = 0.41,
            ["foregroundTexture"] = "Legionfall_BarFrame-Glow",
            ["mirror"] = false,
            ["compress"] = false,
            ["zoom"] = 0,
            ["sameTexture"] = true,
            ["foregroundColor"] = {0.9960784912109375, 0, 0, 1},
            ["icon_side"] = "RIGHT",
            ["width"] = 300,
            ["authorOptions"] = {},
            ["sparkHeight"] = 30,
            ["preferToUpdate"] = false,
            ["id"] = "Guardian Rage",
            ["actions"] = {
                ["start"] = {},
                ["finish"] = {},
                ["init"] = {}
            },
            ["semver"] = "1.0.7",
            ["backgroundColor"] = {0, 0, 0, 0.5},
            ["sparkHidden"] = "NEVER",
            ["auraRotation"] = 0,
            ["frameStrata"] = 3,
            ["anchorFrameType"] = "SCREEN",
            ["sparkWidth"] = 10,
            ["config"] = {},
            ["inverse"] = false,
            ["crop_y"] = 0.41,
            ["orientation"] = "HORIZONTAL",
            ["conditions"] = {{
                ["check"] = {
                    ["trigger"] = -2,
                    ["variable"] = "OR",
                    ["checks"] = {{
                        ["trigger"] = -1,
                        ["variable"] = "attackabletarget",
                        ["value"] = 1
                    }, {
                        ["trigger"] = -1,
                        ["variable"] = "incombat",
                        ["value"] = 1
                    }}
                },
                ["changes"] = {{
                    ["value"] = 1,
                    ["property"] = "alpha"
                }}
            }, {
                ["check"] = {
                    ["trigger"] = -1,
                    ["variable"] = "alwaystrue"
                },
                ["linked"] = true,
                ["changes"] = {{
                    ["value"] = 0.09999999999999999,
                    ["property"] = "alpha"
                }}
            }},
            ["information"] = {
                ["forceEvents"] = true,
                ["ignoreOptionsEventErrors"] = true
            },
            ["sparkColor"] = {1, 1, 1, 1}
        },




["Warrior Rage"] = {
            ["sparkWidth"] = 10,
            ["iconSource"] = -1,
            ["user_x"] = 0,
            ["xOffset"] = 0,
            ["adjustedMax"] = "",
            ["yOffset"] = 0,
            ["anchorPoint"] = "CENTER",
            ["sparkRotation"] = 0,
            ["textureInput"] = "Legionfall_BarFrame-Glow",
            ["url"] = "https://wago.io/yn2XaJbM8/7",
            ["icon"] = false,
            ["icon_color"] = {1, 1, 1, 1},
            ["enableGradient"] = false,
            ["selfPoint"] = "CENTER",
            ["barColor"] = {1, 0.90980398654938, 0.14509804546833, 1},
            ["desaturate"] = false,
            ["rotation"] = 0,
            ["font"] = "Friz Quadrata TT",
            ["sparkOffsetY"] = 0,
            ["gradientOrientation"] = "HORIZONTAL",
            ["load"] = {
                ["use_petbattle"] = false,
                ["class_and_spec"] = {
                    ["multi"] = {
                        [73] = true,
                        [71] = true,
                        [72] = true,
                        [102] = true
                    }
                },
                ["talent"] = {
                    ["multi"] = {}
                },
                ["use_vehicle"] = false,
                ["use_class_and_spec"] = false,
                ["use_never"] = false,
                ["use_dragonriding"] = false,
                ["ingroup"] = {
                    ["multi"] = {
                        ["group"] = true,
                        ["raid"] = true
                    }
                },
                ["use_vehicleUi"] = false,
                ["class"] = {
                    ["multi"] = {}
                },
                ["spec"] = {
                    ["multi"] = {}
                },
                ["spec_position"] = {},
                ["size"] = {
                    ["multi"] = {}
                }
            },
            ["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
            ["foregroundTexture"] = "Legionfall_BarFrame-Glow",
            ["smoothProgress"] = true,
            ["useAdjustededMin"] = false,
            ["regionType"] = "progresstexture",
            ["blendMode"] = "BLEND",
            ["slantMode"] = "INSIDE",
            ["texture"] = "Clean",
            ["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
            ["spark"] = false,
            ["tocversion"] = 110002,
            ["alpha"] = 1,
            ["uid"] = "7vLXGfKWyyS",
            ["backgroundOffset"] = 2,
            ["sparkOffsetX"] = 0,
            ["wagoID"] = "yn2XaJbM8",
            ["parent"] = "Wrapper - Hiding out of Combat - Bars",
            ["adjustedMin"] = "",
            ["desaturateBackground"] = false,
            ["sparkRotationMode"] = "AUTO",
            ["desaturateForeground"] = true,
            ["triggers"] = {
                {
                    ["trigger"] = {
                        ["type"] = "unit",
                        ["use_absorbHealMode"] = true,
                        ["subeventSuffix"] = "_CAST_START",
                        ["nameplateType"] = "hostile",
                        ["use_absorbMode"] = true,
                        ["event"] = "Power",
                        ["names"] = {},
                        ["unit"] = "player",
                        ["powertype"] = 1,
                        ["spellIds"] = {},
                        ["subeventPrefix"] = "SPELL",
                        ["use_nameplateType"] = false,
                        ["use_unit"] = true,
                        ["use_powertype"] = true,
                        ["debuffType"] = "HELPFUL"
                    },
                    ["untrigger"] = {}
                },
                ["disjunctive"] = "all",
                ["activeTriggerMode"] = -10
            },
            ["endAngle"] = 360,
            ["internalVersion"] = 88,
            ["progressSource"] = {-1, ""},
            ["animation"] = {
                ["start"] = {
                    ["type"] = "none",
                    ["easeStrength"] = 3,
                    ["duration_type"] = "seconds",
                    ["easeType"] = "none"
                },
                ["main"] = {
                    ["type"] = "none",
                    ["easeStrength"] = 3,
                    ["duration_type"] = "seconds",
                    ["easeType"] = "none"
                },
                ["finish"] = {
                    ["type"] = "none",
                    ["easeStrength"] = 3,
                    ["duration_type"] = "seconds",
                    ["easeType"] = "none"
                }
            },
            ["version"] = 7,
            ["subRegions"] = {{
                ["type"] = "subbackground"
            }, {
                ["text_text_format_p_time_precision"] = 1,
                ["text_text"] = "%p",
                ["text_shadowColor"] = {0, 0, 0, 1},
                ["text_fixedWidth"] = 64,
                ["text_text_format_c_format"] = "none",
                ["rotateText"] = "NONE",
                ["text_color"] = {0.8705883026123, 1, 0.87450987100601, 1},
                ["text_shadowYOffset"] = -1,
                ["text_wordWrap"] = "WordWrap",
                ["text_fontType"] = "OUTLINE",
                ["text_fontSize"] = 15,
                ["anchorXOffset"] = 0,
                ["text_text_format_p_time_mod_rate"] = true,
                ["text_selfPoint"] = "AUTO",
                ["text_automaticWidth"] = "Auto",
                ["text_text_format_t_time_format"] = 0,
                ["anchorYOffset"] = 0,
                ["text_justify"] = "CENTER",
                ["text_text_format_t_format"] = "timed",
                ["type"] = "subtext",
                ["text_text_format_t_time_dynamic_threshold"] = 60,
                ["text_font"] = "2002 Bold",
                ["text_shadowXOffset"] = 1,
                ["text_text_format_p_time_format"] = 0,
                ["text_text_format_1.percentpower_format"] = "none",
                ["text_text_format_t_time_legacy_floor"] = false,
                ["text_text_format_t_time_mod_rate"] = true,
                ["text_text_format_p_time_dynamic_threshold"] = 60,
                ["text_text_format_p_time_legacy_floor"] = false,
                ["anchor_point"] = "INNER_CENTER",
                ["text_text_format_p_format"] = "timed",
                ["text_text_format_t_time_precision"] = 1,
                ["text_visible"] = true
            }, {
                ["border_offset"] = 0,
                ["type"] = "subborder",
                ["anchor_area"] = "bar",
                ["border_color"] = {1, 1, 1, 1},
                ["border_visible"] = false,
                ["border_edge"] = "Square Full White",
                ["border_size"] = 2
            }},
            ["height"] = 30,
            ["textureSource"] = "Picker",
            ["sparkColor"] = {1, 1, 1, 1},
            ["sparkBlendMode"] = "ADD",
            ["useAdjustededMax"] = false,
            ["backgroundTexture"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura3",
            ["source"] = "import",
            ["information"] = {
                ["forceEvents"] = true,
                ["ignoreOptionsEventErrors"] = true
            },
            ["conditions"] = {{
                ["check"] = {
                    ["trigger"] = -2,
                    ["variable"] = "OR",
                    ["checks"] = {{
                        ["trigger"] = -1,
                        ["variable"] = "attackabletarget",
                        ["value"] = 1
                    }, {
                        ["trigger"] = -1,
                        ["variable"] = "incombat",
                        ["value"] = 1
                    }}
                },
                ["changes"] = {{
                    ["value"] = 1,
                    ["property"] = "alpha"
                }}
            }, {
                ["check"] = {
                    ["trigger"] = -1,
                    ["variable"] = "alwaystrue"
                },
                ["linked"] = true,
                ["changes"] = {{
                    ["value"] = 0.09999999999999999,
                    ["property"] = "alpha"
                }}
            }},
            ["startAngle"] = 0,
            ["mirror"] = false,
            ["crop_y"] = 0.41,
            ["zoom"] = 0,
            ["config"] = {},
            ["user_y"] = 0,
            ["icon_side"] = "RIGHT",
            ["anchorFrameType"] = "SCREEN",
            ["authorOptions"] = {},
            ["sparkHeight"] = 30,
            ["auraRotation"] = 0,
            ["sparkHidden"] = "NEVER",
            ["backgroundColor"] = {0, 0, 0, 0.5},
            ["semver"] = "1.0.7",
            ["actions"] = {
                ["start"] = {},
                ["init"] = {},
                ["finish"] = {}
            },
            ["id"] = "Warrior Rage",
            ["preferToUpdate"] = false,
            ["frameStrata"] = 3,
            ["width"] = 300,
            ["foregroundColor"] = {0.9960784912109375, 0, 0, 1},
            ["sameTexture"] = true,
            ["inverse"] = false,
            ["compress"] = false,
            ["orientation"] = "HORIZONTAL",
            ["crop_x"] = 0.41,
            ["barColor2"] = {1, 1, 0, 1},
            ["fontSize"] = 12
        },



["Feral Energy"] = {
            ["user_y"] = 0,
            ["iconSource"] = -1,
            ["user_x"] = 0,
            ["xOffset"] = 0,
            ["adjustedMax"] = "",
            ["yOffset"] = 0,
            ["anchorPoint"] = "CENTER",
            ["sparkRotation"] = 0,
            ["textureInput"] = "Legionfall_BarFrame-Glow",
            ["url"] = "https://wago.io/yn2XaJbM8/7",
            ["icon"] = false,
            ["icon_color"] = {1, 1, 1, 1},
            ["enableGradient"] = false,
            ["selfPoint"] = "CENTER",
            ["barColor"] = {1, 0.90980398654938, 0.14509804546833, 1},
            ["desaturate"] = false,
            ["rotation"] = 0,
            ["font"] = "Friz Quadrata TT",
            ["sparkOffsetY"] = 0,
            ["gradientOrientation"] = "HORIZONTAL",
            ["load"] = {
                ["use_petbattle"] = false,
                ["class_and_spec"] = {
                    ["multi"] = {
                        [103] = true,
                        [104] = true,
                        [105] = true,
                        [102] = true
                    }
                },
                ["talent"] = {
                    ["multi"] = {}
                },
                ["use_vehicle"] = false,
                ["use_class_and_spec"] = false,
                ["use_never"] = false,
                ["use_dragonriding"] = false,
                ["ingroup"] = {
                    ["multi"] = {
                        ["group"] = true,
                        ["raid"] = true
                    }
                },
                ["use_vehicleUi"] = false,
                ["class"] = {
                    ["multi"] = {}
                },
                ["spec"] = {
                    ["multi"] = {}
                },
                ["spec_position"] = {},
                ["size"] = {
                    ["multi"] = {}
                }
            },
            ["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
            ["foregroundTexture"] = "Legionfall_BarFrame-Glow",
            ["smoothProgress"] = true,
            ["useAdjustededMin"] = false,
            ["regionType"] = "progresstexture",
            ["blendMode"] = "BLEND",
            ["slantMode"] = "INSIDE",
            ["texture"] = "Clean",
            ["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
            ["spark"] = false,
            ["tocversion"] = 110002,
            ["alpha"] = 1,
            ["uid"] = "b4IXdgp1Elp",
            ["backgroundOffset"] = 2,
            ["sparkOffsetX"] = 0,
            ["wagoID"] = "yn2XaJbM8",
            ["parent"] = "Wrapper - Hiding out of Combat - Bars",
            ["adjustedMin"] = "",
            ["desaturateBackground"] = false,
            ["sparkRotationMode"] = "AUTO",
            ["desaturateForeground"] = true,
            ["triggers"] = {
                {
                    ["trigger"] = {
                        ["type"] = "unit",
                        ["use_absorbHealMode"] = true,
                        ["subeventSuffix"] = "_CAST_START",
                        ["nameplateType"] = "hostile",
                        ["use_absorbMode"] = true,
                        ["event"] = "Power",
                        ["unit"] = "player",
                        ["names"] = {},
                        ["powertype"] = 3,
                        ["spellIds"] = {},
                        ["subeventPrefix"] = "SPELL",
                        ["use_nameplateType"] = false,
                        ["use_unit"] = true,
                        ["use_powertype"] = true,
                        ["debuffType"] = "HELPFUL"
                    },
                    ["untrigger"] = {}
                },
                {
                    ["trigger"] = {
                        ["type"] = "unit",
                        ["use_absorbHealMode"] = true,
                        ["subeventSuffix"] = "_CAST_START",
                        ["use_absorbMode"] = true,
                        ["event"] = "Stance/Form/Aura",
                        ["unit"] = "player",
                        ["names"] = {},
                        ["spellIds"] = {},
                        ["subeventPrefix"] = "SPELL",
                        ["form"] = {
                            ["single"] = 2
                        },
                        ["use_form"] = true,
                        ["use_unit"] = true,
                        ["debuffType"] = "HELPFUL"
                    },
                    ["untrigger"] = {}
                },
                ["disjunctive"] = "all",
                ["activeTriggerMode"] = -10
            },
            ["endAngle"] = 360,
            ["internalVersion"] = 88,
            ["progressSource"] = {-1, ""},
            ["animation"] = {
                ["start"] = {
                    ["type"] = "none",
                    ["easeStrength"] = 3,
                    ["duration_type"] = "seconds",
                    ["easeType"] = "none"
                },
                ["main"] = {
                    ["type"] = "none",
                    ["easeStrength"] = 3,
                    ["duration_type"] = "seconds",
                    ["easeType"] = "none"
                },
                ["finish"] = {
                    ["type"] = "none",
                    ["easeStrength"] = 3,
                    ["duration_type"] = "seconds",
                    ["easeType"] = "none"
                }
            },
            ["version"] = 7,
            ["subRegions"] = {{
                ["type"] = "subbackground"
            }, {
                ["text_text_format_p_time_precision"] = 1,
                ["text_text"] = "%p",
                ["text_shadowColor"] = {0, 0, 0, 1},
                ["text_fixedWidth"] = 64,
                ["text_text_format_p_time_legacy_floor"] = false,
                ["rotateText"] = "NONE",
                ["text_color"] = {0.8705883026123, 1, 0.87450987100601, 1},
                ["text_shadowYOffset"] = -1,
                ["text_wordWrap"] = "WordWrap",
                ["text_visible"] = true,
                ["text_fontSize"] = 15,
                ["anchorXOffset"] = 0,
                ["text_text_format_p_time_mod_rate"] = true,
                ["text_selfPoint"] = "AUTO",
                ["text_automaticWidth"] = "Auto",
                ["text_text_format_t_time_format"] = 0,
                ["anchorYOffset"] = 0,
                ["text_justify"] = "CENTER",
                ["text_text_format_t_format"] = "timed",
                ["type"] = "subtext",
                ["text_text_format_t_time_dynamic_threshold"] = 60,
                ["text_font"] = "2002 Bold",
                ["text_shadowXOffset"] = 1,
                ["text_text_format_p_time_format"] = 0,
                ["text_text_format_1.percentpower_format"] = "none",
                ["text_text_format_t_time_legacy_floor"] = false,
                ["text_text_format_t_time_mod_rate"] = true,
                ["text_text_format_p_time_dynamic_threshold"] = 60,
                ["text_text_format_c_format"] = "none",
                ["anchor_point"] = "INNER_CENTER",
                ["text_text_format_p_format"] = "timed",
                ["text_text_format_t_time_precision"] = 1,
                ["text_fontType"] = "OUTLINE"
            }, {
                ["border_size"] = 2,
                ["border_offset"] = 0,
                ["anchor_area"] = "bar",
                ["border_color"] = {1, 1, 1, 1},
                ["border_visible"] = false,
                ["border_edge"] = "Square Full White",
                ["type"] = "subborder"
            }},
            ["height"] = 30,
            ["textureSource"] = "Picker",
            ["sparkColor"] = {1, 1, 1, 1},
            ["sparkBlendMode"] = "ADD",
            ["useAdjustededMax"] = false,
            ["backgroundTexture"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura3",
            ["source"] = "import",
            ["information"] = {
                ["forceEvents"] = true,
                ["ignoreOptionsEventErrors"] = true
            },
            ["conditions"] = {{
                ["check"] = {
                    ["trigger"] = -2,
                    ["variable"] = "OR",
                    ["checks"] = {{
                        ["trigger"] = -1,
                        ["variable"] = "attackabletarget",
                        ["value"] = 1
                    }, {
                        ["trigger"] = -1,
                        ["variable"] = "incombat",
                        ["value"] = 1
                    }}
                },
                ["changes"] = {{
                    ["value"] = 1,
                    ["property"] = "alpha"
                }}
            }, {
                ["check"] = {
                    ["trigger"] = -1,
                    ["variable"] = "alwaystrue"
                },
                ["linked"] = true,
                ["changes"] = {{
                    ["value"] = 0.09999999999999999,
                    ["property"] = "alpha"
                }}
            }},
            ["fontSize"] = 12,
            ["mirror"] = false,
            ["crop_y"] = 0.41,
            ["zoom"] = 0,
            ["config"] = {},
            ["sparkWidth"] = 10,
            ["icon_side"] = "RIGHT",
            ["anchorFrameType"] = "SCREEN",
            ["authorOptions"] = {},
            ["sparkHeight"] = 30,
            ["auraRotation"] = 0,
            ["sparkHidden"] = "NEVER",
            ["backgroundColor"] = {0, 0, 0, 0.5},
            ["semver"] = "1.0.7",
            ["actions"] = {
                ["start"] = {},
                ["init"] = {},
                ["finish"] = {}
            },
            ["id"] = "Feral Energy",
            ["preferToUpdate"] = false,
            ["frameStrata"] = 3,
            ["width"] = 300,
            ["foregroundColor"] = {0.9960784912109375, 0.8901961445808411, 0, 1},
            ["sameTexture"] = true,
            ["inverse"] = false,
            ["compress"] = false,
            ["orientation"] = "HORIZONTAL",
            ["crop_x"] = 0.41,
            ["barColor2"] = {1, 1, 0, 1},
            ["startAngle"] = 0
        },



["Rogue Energy"] = {
            ["sparkWidth"] = 10,
            ["iconSource"] = -1,
            ["user_x"] = 0,
            ["xOffset"] = 0,
            ["adjustedMax"] = "",
            ["yOffset"] = 0,
            ["anchorPoint"] = "CENTER",
            ["sparkRotation"] = 0,
            ["textureInput"] = "Legionfall_BarFrame-Glow",
            ["url"] = "https://wago.io/yn2XaJbM8/7",
            ["icon"] = false,
            ["icon_color"] = {1, 1, 1, 1},
            ["enableGradient"] = false,
            ["selfPoint"] = "CENTER",
            ["barColor"] = {1, 0.90980398654938, 0.14509804546833, 1},
            ["desaturate"] = false,
            ["rotation"] = 0,
            ["font"] = "Friz Quadrata TT",
            ["sparkOffsetY"] = 0,
            ["gradientOrientation"] = "HORIZONTAL",
            ["load"] = {
                ["use_petbattle"] = false,
                ["use_never"] = false,
                ["talent"] = {
                    ["multi"] = {}
                },
                ["use_vehicle"] = false,
                ["use_class_and_spec"] = false,
                ["class_and_spec"] = {
                    ["multi"] = {
                        [260] = true,
                        [261] = true,
                        [259] = true
                    }
                },
                ["use_dragonriding"] = false,
                ["spec_position"] = {},
                ["use_vehicleUi"] = false,
                ["spec"] = {
                    ["multi"] = {}
                },
                ["class"] = {
                    ["multi"] = {}
                },
                ["ingroup"] = {
                    ["multi"] = {
                        ["group"] = true,
                        ["raid"] = true
                    }
                },
                ["size"] = {
                    ["multi"] = {}
                }
            },
            ["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
            ["foregroundTexture"] = "Legionfall_BarFrame-Glow",
            ["smoothProgress"] = true,
            ["useAdjustededMin"] = false,
            ["regionType"] = "progresstexture",
            ["blendMode"] = "BLEND",
            ["slantMode"] = "INSIDE",
            ["texture"] = "Clean",
            ["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
            ["spark"] = false,
            ["tocversion"] = 110002,
            ["alpha"] = 1,
            ["uid"] = "z1vhT3oj)HY",
            ["backgroundOffset"] = 2,
            ["sparkOffsetX"] = 0,
            ["wagoID"] = "yn2XaJbM8",
            ["parent"] = "Wrapper - Hiding out of Combat - Bars",
            ["adjustedMin"] = "",
            ["desaturateBackground"] = false,
            ["sparkRotationMode"] = "AUTO",
            ["desaturateForeground"] = true,
            ["triggers"] = {
                {
                    ["trigger"] = {
                        ["type"] = "unit",
                        ["use_absorbHealMode"] = true,
                        ["nameplateType"] = "hostile",
                        ["subeventSuffix"] = "_CAST_START",
                        ["use_absorbMode"] = true,
                        ["event"] = "Power",
                        ["unit"] = "player",
                        ["names"] = {},
                        ["powertype"] = 3,
                        ["spellIds"] = {},
                        ["use_unit"] = true,
                        ["use_nameplateType"] = false,
                        ["subeventPrefix"] = "SPELL",
                        ["use_powertype"] = true,
                        ["debuffType"] = "HELPFUL"
                    },
                    ["untrigger"] = {}
                },
                ["disjunctive"] = "all",
                ["activeTriggerMode"] = -10
            },
            ["endAngle"] = 360,
            ["internalVersion"] = 88,
            ["progressSource"] = {-1, ""},
            ["animation"] = {
                ["start"] = {
                    ["easeStrength"] = 3,
                    ["type"] = "none",
                    ["duration_type"] = "seconds",
                    ["easeType"] = "none"
                },
                ["main"] = {
                    ["easeStrength"] = 3,
                    ["type"] = "none",
                    ["duration_type"] = "seconds",
                    ["easeType"] = "none"
                },
                ["finish"] = {
                    ["easeStrength"] = 3,
                    ["type"] = "none",
                    ["duration_type"] = "seconds",
                    ["easeType"] = "none"
                }
            },
            ["version"] = 7,
            ["subRegions"] = {{
                ["type"] = "subbackground"
            }, {
                ["text_shadowXOffset"] = 1,
                ["text_text_format_t_time_legacy_floor"] = false,
                ["text_shadowColor"] = {0, 0, 0, 1},
                ["text_fixedWidth"] = 64,
                ["text_text_format_p_time_legacy_floor"] = false,
                ["rotateText"] = "NONE",
                ["text_color"] = {0.8705883026123, 1, 0.87450987100601, 1},
                ["text_shadowYOffset"] = -1,
                ["text_wordWrap"] = "WordWrap",
                ["text_visible"] = true,
                ["text_fontSize"] = 15,
                ["anchorXOffset"] = 0,
                ["text_text_format_p_time_mod_rate"] = true,
                ["text_selfPoint"] = "AUTO",
                ["text_automaticWidth"] = "Auto",
                ["text_text_format_t_time_format"] = 0,
                ["anchorYOffset"] = 0,
                ["text_justify"] = "CENTER",
                ["text_text_format_t_format"] = "timed",
                ["type"] = "subtext",
                ["text_fontType"] = "OUTLINE",
                ["text_font"] = "2002 Bold",
                ["text_text_format_p_time_precision"] = 1,
                ["text_text_format_t_time_precision"] = 1,
                ["text_text_format_1.percentpower_format"] = "none",
                ["text_text"] = "%p",
                ["text_text_format_t_time_mod_rate"] = true,
                ["text_text_format_p_format"] = "timed",
                ["text_text_format_c_format"] = "none",
                ["anchor_point"] = "INNER_CENTER",
                ["text_text_format_p_time_dynamic_threshold"] = 60,
                ["text_text_format_p_time_format"] = 0,
                ["text_text_format_t_time_dynamic_threshold"] = 60
            }, {
                ["border_offset"] = 0,
                ["type"] = "subborder",
                ["border_visible"] = false,
                ["border_color"] = {1, 1, 1, 1},
                ["anchor_area"] = "bar",
                ["border_edge"] = "Square Full White",
                ["border_size"] = 2
            }},
            ["height"] = 30,
            ["textureSource"] = "Picker",
            ["startAngle"] = 0,
            ["sparkBlendMode"] = "ADD",
            ["useAdjustededMax"] = false,
            ["backgroundTexture"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura3",
            ["source"] = "import",
            ["barColor2"] = {1, 1, 0, 1},
            ["crop_x"] = 0.41,
            ["fontSize"] = 12,
            ["mirror"] = false,
            ["compress"] = false,
            ["zoom"] = 0,
            ["sameTexture"] = true,
            ["foregroundColor"] = {0.9960784912109375, 0.8901961445808411, 0, 1},
            ["icon_side"] = "RIGHT",
            ["width"] = 300,
            ["authorOptions"] = {},
            ["sparkHeight"] = 30,
            ["preferToUpdate"] = false,
            ["id"] = "Rogue Energy",
            ["actions"] = {
                ["start"] = {},
                ["finish"] = {},
                ["init"] = {}
            },
            ["semver"] = "1.0.7",
            ["backgroundColor"] = {0, 0, 0, 0.5},
            ["sparkHidden"] = "NEVER",
            ["auraRotation"] = 0,
            ["frameStrata"] = 3,
            ["anchorFrameType"] = "SCREEN",
            ["user_y"] = 0,
            ["config"] = {},
            ["inverse"] = false,
            ["crop_y"] = 0.41,
            ["orientation"] = "HORIZONTAL",
            ["conditions"] = {{
                ["check"] = {
                    ["trigger"] = -2,
                    ["variable"] = "OR",
                    ["checks"] = {{
                        ["trigger"] = -1,
                        ["variable"] = "attackabletarget",
                        ["value"] = 1
                    }, {
                        ["trigger"] = -1,
                        ["variable"] = "incombat",
                        ["value"] = 1
                    }}
                },
                ["changes"] = {{
                    ["value"] = 1,
                    ["property"] = "alpha"
                }}
            }, {
                ["check"] = {
                    ["trigger"] = -1,
                    ["variable"] = "alwaystrue"
                },
                ["linked"] = true,
                ["changes"] = {{
                    ["value"] = 0.09999999999999999,
                    ["property"] = "alpha"
                }}
            }},
            ["information"] = {
                ["forceEvents"] = true,
                ["ignoreOptionsEventErrors"] = true
            },
            ["sparkColor"] = {1, 1, 1, 1}
        },



["Death Knight Runic Power"] = {
            ["sparkWidth"] = 10,
            ["iconSource"] = -1,
            ["user_x"] = 0,
            ["authorOptions"] = {},
            ["adjustedMax"] = "",
            ["yOffset"] = 0,
            ["anchorPoint"] = "CENTER",
            ["sparkRotation"] = 0,
            ["textureInput"] = "Legionfall_BarFrame-Glow",
            ["url"] = "https://wago.io/yn2XaJbM8/7",
            ["icon"] = false,
            ["icon_color"] = {1, 1, 1, 1},
            ["enableGradient"] = false,
            ["selfPoint"] = "CENTER",
            ["barColor"] = {1, 1, 1, 1},
            ["desaturate"] = false,
            ["rotation"] = 0,
            ["font"] = "Friz Quadrata TT",
            ["sparkOffsetY"] = 0,
            ["gradientOrientation"] = "HORIZONTAL",
            ["load"] = {
                ["use_petbattle"] = false,
                ["class_and_spec"] = {
                    ["multi"] = {
                        [252] = true,
                        [251] = true,
                        [250] = true
                    }
                },
                ["talent"] = {
                    ["multi"] = {}
                },
                ["use_vehicle"] = false,
                ["use_class_and_spec"] = false,
                ["use_never"] = false,
                ["use_dragonriding"] = false,
                ["ingroup"] = {
                    ["multi"] = {
                        ["group"] = true,
                        ["raid"] = true
                    }
                },
                ["use_vehicleUi"] = false,
                ["class"] = {
                    ["multi"] = {}
                },
                ["spec"] = {
                    ["multi"] = {}
                },
                ["spec_position"] = {},
                ["size"] = {
                    ["multi"] = {}
                }
            },
            ["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
            ["startAngle"] = 0,
            ["smoothProgress"] = true,
            ["useAdjustededMin"] = false,
            ["regionType"] = "progresstexture",
            ["blendMode"] = "BLEND",
            ["sparkDesaturate"] = false,
            ["slantMode"] = "INSIDE",
            ["texture"] = "Blizzard Maelstrom",
            ["zoom"] = 0,
            ["spark"] = false,
            ["tocversion"] = 110002,
            ["alpha"] = 1,
            ["config"] = {},
            ["backgroundOffset"] = 0,
            ["sparkOffsetX"] = 0,
            ["wagoID"] = "yn2XaJbM8",
            ["parent"] = "Wrapper - Hiding out of Combat - Bars",
            ["adjustedMin"] = "",
            ["desaturateBackground"] = false,
            ["sparkRotationMode"] = "AUTO",
            ["desaturateForeground"] = true,
            ["triggers"] = {
                {
                    ["trigger"] = {
                        ["names"] = {},
                        ["type"] = "unit",
                        ["use_absorbHealMode"] = true,
                        ["nameplateType"] = "hostile",
                        ["subeventPrefix"] = "SPELL",
                        ["use_absorbMode"] = true,
                        ["use_deficit"] = false,
                        ["use_unit"] = true,
                        ["unit"] = "player",
                        ["powertype"] = 6,
                        ["spellIds"] = {},
                        ["subeventSuffix"] = "_CAST_START",
                        ["use_nameplateType"] = false,
                        ["event"] = "Power",
                        ["use_powertype"] = true,
                        ["debuffType"] = "HELPFUL"
                    },
                    ["untrigger"] = {}
                },
                ["disjunctive"] = "all",
                ["activeTriggerMode"] = -10
            },
            ["endAngle"] = 360,
            ["internalVersion"] = 88,
            ["progressSource"] = {-1, "", 0},
            ["animation"] = {
                ["start"] = {
                    ["type"] = "none",
                    ["easeStrength"] = 3,
                    ["duration_type"] = "seconds",
                    ["easeType"] = "none"
                },
                ["main"] = {
                    ["type"] = "none",
                    ["easeStrength"] = 3,
                    ["duration_type"] = "seconds",
                    ["easeType"] = "none"
                },
                ["finish"] = {
                    ["type"] = "none",
                    ["easeStrength"] = 3,
                    ["duration_type"] = "seconds",
                    ["easeType"] = "none"
                }
            },
            ["uid"] = "VifzJkxzSj5",
            ["version"] = 7,
            ["subRegions"] = {{
                ["type"] = "subbackground"
            }, {
                ["text_text_format_p_time_format"] = 0,
                ["text_text"] = "%p",
                ["text_shadowColor"] = {0, 0, 0, 1},
                ["text_fixedWidth"] = 64,
                ["text_text_format_p_time_legacy_floor"] = false,
                ["rotateText"] = "NONE",
                ["text_color"] = {0.8705883026123, 1, 0.87450987100601, 1},
                ["text_shadowYOffset"] = -1,
                ["text_wordWrap"] = "WordWrap",
                ["text_fontType"] = "OUTLINE",
                ["text_fontSize"] = 15,
                ["anchorXOffset"] = 0,
                ["text_text_format_p_time_mod_rate"] = true,
                ["text_selfPoint"] = "AUTO",
                ["text_automaticWidth"] = "Auto",
                ["text_text_format_t_time_format"] = 0,
                ["anchorYOffset"] = 0,
                ["text_justify"] = "CENTER",
                ["text_text_format_t_format"] = "timed",
                ["type"] = "subtext",
                ["text_text_format_t_time_dynamic_threshold"] = 60,
                ["text_font"] = "2002 Bold",
                ["text_text_format_p_time_dynamic_threshold"] = 60,
                ["text_visible"] = true,
                ["text_text_format_1.percentpower_format"] = "none",
                ["text_text_format_t_time_legacy_floor"] = false,
                ["text_text_format_t_time_mod_rate"] = true,
                ["text_text_format_c_format"] = "none",
                ["text_text_format_t_time_precision"] = 1,
                ["anchor_point"] = "INNER_CENTER",
                ["text_text_format_p_time_precision"] = 1,
                ["text_shadowXOffset"] = 1,
                ["text_text_format_p_format"] = "timed"
            }, {
                ["type"] = "subborder",
                ["border_size"] = 2,
                ["anchor_area"] = "bar",
                ["border_color"] = {1, 1, 1, 1},
                ["border_visible"] = false,
                ["border_edge"] = "Square Full White",
                ["border_offset"] = 0
            }},
            ["height"] = 30,
            ["textureSource"] = "Picker",
            ["information"] = {
                ["forceEvents"] = true,
                ["ignoreOptionsEventErrors"] = true
            },
            ["sparkBlendMode"] = "ADD",
            ["useAdjustededMax"] = false,
            ["backgroundTexture"] = "Unit_Shaman_Maelstrom_Fill",
            ["source"] = "import",
            ["conditions"] = {{
                ["check"] = {
                    ["trigger"] = -2,
                    ["variable"] = "OR",
                    ["checks"] = {{
                        ["trigger"] = -1,
                        ["variable"] = "attackabletarget",
                        ["value"] = 1
                    }, {
                        ["trigger"] = -1,
                        ["variable"] = "incombat",
                        ["value"] = 1
                    }}
                },
                ["changes"] = {{
                    ["value"] = 1,
                    ["property"] = "alpha"
                }}
            }, {
                ["check"] = {
                    ["trigger"] = -1,
                    ["variable"] = "alwaystrue"
                },
                ["linked"] = true,
                ["changes"] = {{
                    ["value"] = 0.09999999999999999,
                    ["property"] = "alpha"
                }}
            }},
            ["foregroundTexture"] = "Legionfall_BarFrame-Glow",
            ["sparkColor"] = {1, 1, 1, 1},
            ["mirror"] = false,
            ["compress"] = false,
            ["sparkTexture"] = "bonusobjectives-bar-spark",
            ["auraRotation"] = 0,
            ["anchorFrameType"] = "SCREEN",
            ["icon_side"] = "RIGHT",
            ["foregroundColor"] = {0, 0.8549020290374756, 1, 1},
            ["actions"] = {
                ["start"] = {},
                ["init"] = {},
                ["finish"] = {}
            },
            ["sparkHeight"] = 30,
            ["sparkHidden"] = "BOTH",
            ["backgroundColor"] = {0, 0, 0, 0.5},
            ["user_y"] = 0,
            ["semver"] = "1.0.7",
            ["preferToUpdate"] = false,
            ["id"] = "Death Knight Runic Power",
            ["xOffset"] = 0,
            ["frameStrata"] = 3,
            ["width"] = 300,
            ["sameTexture"] = true,
            ["crop_y"] = 0.41,
            ["inverse"] = false,
            ["fontSize"] = 12,
            ["orientation"] = "HORIZONTAL",
            ["crop_x"] = 0.41,
            ["barColor2"] = {0, 1, 1, 1},
            ["slanted"] = false
        },