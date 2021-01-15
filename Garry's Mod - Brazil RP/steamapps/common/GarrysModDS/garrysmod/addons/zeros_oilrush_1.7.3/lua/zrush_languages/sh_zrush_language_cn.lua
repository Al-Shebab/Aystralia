zrush = zrush || {}
zrush.language = zrush.language || {}
zrush.language.General = zrush.language.General || {}
zrush.language.NPC = zrush.language.NPC || {}
zrush.language.VCMOD = zrush.language.VCMOD || {}
zrush.language.DrillTower = zrush.language.DrillTower || {}
zrush.language.Pump = zrush.language.Pump || {}
zrush.language.Refinery = zrush.language.Refinery || {}
zrush.language.MachineCrate = zrush.language.MachineCrate || {}
zrush.language.VGUI = zrush.language.VGUI || {}
zrush.language.VGUI.DrillHole = zrush.language.VGUI.DrillHole || {}
zrush.language.VGUI.DrillTower = zrush.language.VGUI.DrillTower || {}
zrush.language.VGUI.Refinery = zrush.language.VGUI.Refinery || {}
zrush.language.VGUI.Burner = zrush.language.VGUI.Burner || {}
zrush.language.VGUI.Pump = zrush.language.VGUI.Pump || {}
zrush.language.VGUI.Barrel = zrush.language.VGUI.Barrel || {}
zrush.language.VGUI.NPC = zrush.language.VGUI.NPC || {}
zrush.language.Inv = zrush.language.Inv || {}
zrush.language.VGUI.MachineBuilder = zrush.language.VGUI.MachineBuilder || {}


if(zrush.config.selectedLanguage == "cn")then

    zrush.language.NPC["FuelBuyer"] = "燃料买家"
    zrush.language.NPC["Profit"] = "利润:"
    zrush.language.NPC["YouSold"] = "你卖掉了 $Amount$UoM $Fuelname 并拿到了 $Earning$Currency"

    zrush.language.NPC["DialogTransactionComplete"] = "和你做生意非常开心!"
    zrush.language.NPC["NoFuel"] = "你没有任何燃料, 为什么你来这?!"

    zrush.language.NPC["Dialog00"] = "买房子的时候检查是否发霉是非常重要的."
    zrush.language.NPC["Dialog01"] = "我有一个三明治在我的口袋里, 和霉一起."
    zrush.language.NPC["Dialog02"] = "圣诞树会引起过敏因为霉."
    zrush.language.NPC["Dialog03"] = "在霉上喷雾漂白是不建议的."
    zrush.language.NPC["Dialog04"] = "我有一个霉菌收藏品, 你想看看吗?"
    zrush.language.NPC["Dialog05"] = "维他命D会帮助治疗霉过敏."
    zrush.language.NPC["Dialog06"] = "霉会使你发疹."
    zrush.language.NPC["Dialog07"] = "霉菌不会吃美餐."
    zrush.language.NPC["Dialog08"] = "死霉孢子和活孢子一样有害."
    zrush.language.NPC["Dialog09"] = "霉菌被用在生化战争里面."

    zrush.language.VCMOD["NeedMoreFuel"] = "你需要至少 20l 来把他放在容器里!"

    zrush.language.General["AllreadyInUse"] = "正被使用!"
    zrush.language.General["YouDontOwnThis"] = "你不拥有这个!"
    zrush.language.General["NoDrillholeFound"] = "没有找到免费钻孔!"
    zrush.language.General["NoOilSpotFound"] = "没有找到油斑!"
    zrush.language.General["OilSpotSpawner"] = "油斑生成者"

    zrush.language.General["NoFreeSocketAvailable"] = "没有可用的自由插槽!"

    zrush.language.DrillTower["AllreadyReachedOil"] = "你已经找到了石油!"
    zrush.language.DrillTower["DrillPipesMissing"] = "未找到钻杆!"

    zrush.language.Pump["OilSourceEmpty"] = "油源是空的!"
    zrush.language.Pump["MissingBarrel"] = "未找到桶!"

    zrush.language.Refinery["MissingOilBarrel"] = "未找到油桶!"
    zrush.language.Refinery["MissingEmptyBarrel"] = "未找到空桶!"
    zrush.language.VGUI.Refinery["IDLE"] = "等待中"
    zrush.language.VGUI.Refinery["NEED_EMPTY_BARREL"] = "需要空桶来放油!"
    zrush.language.VGUI.Refinery["NEED_OIL_BARREL"] = "需要油桶"
    zrush.language.VGUI.Refinery["READY_FOR_WORK"] = "准备精炼"
    zrush.language.VGUI.Refinery["FUELBARREL_FULL"] = "油桶已满!"
    zrush.language.VGUI.Refinery["REFINING"] = "精炼油中"
    zrush.language.VGUI.Refinery["OVERHEAT"] = "炼油厂过热!"
    zrush.language.VGUI.Refinery["COOLED"] = "炼油厂已冷却!"

    zrush.language.MachineCrate["BuyMachine"] = "<购买设备>"
    zrush.language.MachineCrate["Drill"] = "钻塔"
    zrush.language.MachineCrate["Burner"] = "燃烧器"
    zrush.language.MachineCrate["Pump"] = "泵"
    zrush.language.MachineCrate["Refinery"] = "炼油厂"
    zrush.language.MachineCrate["Occupied"] = "已被占用:"

    zrush.language.VGUI.DrillHole["NEED_PIPES"] = "需要一个钻塔!"
    zrush.language.VGUI.DrillHole["NEED_BURNER"] = "需要一个燃烧器!"
    zrush.language.VGUI.DrillHole["HAS_BURNER"] = "有一个燃烧器!"
    zrush.language.VGUI.DrillHole["NO_OIL"] = "油源是空的"

    zrush.language.VGUI.DrillTower["DrillTower"] = "钻塔"
    zrush.language.VGUI.DrillTower["NEED_PIPES"] = "需要钻杆!"
    zrush.language.VGUI.DrillTower["READY_FOR_WORK"] = "准备钻孔"
    zrush.language.VGUI.DrillTower["IS_WORKING"] = "钻孔中"
    zrush.language.VGUI.DrillTower["JAMMED"] = "钻井机器出现故障!"
    zrush.language.VGUI.DrillTower["FINISHED_DRILLING"] = "结束钻孔"

    zrush.language.VGUI.Burner["IDLE"] = "等待中!"
    zrush.language.VGUI.Burner["BURNING_GAS"] = "燃烧瓦斯中!"
    zrush.language.VGUI.Burner["OVERHEAT"] = "燃烧器过热!"
    zrush.language.VGUI.Burner["COOLED"] = "燃烧器已被冷却!"
    zrush.language.VGUI.Burner["NO_GAS_LEFT"] = "无剩余瓦斯!"

    zrush.language.VGUI.Pump["NEED_BARREL"] = "等待一个桶中"
    zrush.language.VGUI.Pump["PUMP_READY"] = "准备泵油!"
    zrush.language.VGUI.Pump["PUMPING"] = "泵油中"
    zrush.language.VGUI.Pump["BARREL_FULL"] = "油桶已满!"
    zrush.language.VGUI.Pump["JAMMED"] = "泵机器出现故障!"
    zrush.language.VGUI.Pump["NO_OIL"] = "油源是空的"

    zrush.language.VGUI.Barrel["BarrelMenu"] = "桶菜单"
    zrush.language.VGUI.Barrel["BarrelMenuInfo"] = "*这个将会把油放入 VCMod 中的容器."
    zrush.language.VGUI.Barrel["BarrelFuelInfo"] = " 桶"
    zrush.language.VGUI.Barrel["FuelAmount"] = "油量: "
    zrush.language.VGUI.Barrel["Collect"] = "拿起"
    zrush.language.VGUI.Barrel["SpawnVCModFuelCan"] = "生成 VCMod $fueltype 容器"

    zrush.language.VGUI.NPC["FuelBuyer"] = "燃油买家 "
    zrush.language.VGUI.NPC["Sell"] = "出售"
    zrush.language.VGUI.NPC["SellAll"] = "出售全部"
    zrush.language.VGUI.NPC["YourFuelInv"] = "你的燃油库存"
    zrush.language.VGUI.NPC["SaveInfo"] = "*离开服务器前记得出售所有燃油-服务器将不会替你保存任何数据!"

    zrush.language.VGUI["TimeprePipe"] = "每个钻杆所需时间: "
    zrush.language.VGUI["PipesinQueue"] = "进入队列的钻杆数: "
    zrush.language.VGUI["NeededPipes"] = "需要钻杆数量: "
    zrush.language.VGUI["JamChance"] = "出故障几率: " // With Jam i mean like the machine breaking down

    zrush.language.VGUI["Speed"] = "速度: "
    zrush.language.VGUI["BurnAmount"] = "燃烧数量: "
    zrush.language.VGUI["RemainingGas"] = "剩余瓦斯: "
    zrush.language.VGUI["OverHeatChance"] =  "过热几率: "

    zrush.language.VGUI["NA"] =  "不可用" // This is the short version for "Not Available"

    zrush.language.VGUI["PumpAmount"] = "泵数量: "
    zrush.language.VGUI["BarrelOIL"] = "桶(油): "
    zrush.language.VGUI["RemainingOil"] = "剩余油量: "

    zrush.language.VGUI["Fuel"] = "燃料: "
    zrush.language.VGUI["RefineAmount"] = "精炼数量: "
    zrush.language.VGUI["RefineOutput"] = "精炼输出: "
    zrush.language.VGUI["OverHeatChance"] = "过热几率: "
    zrush.language.VGUI["BarrelFuel"] = "桶(燃料): "

    zrush.language.VGUI["Status"] =  "状态: "
    zrush.language.VGUI["pipes"] =  "附加钻杆: +"
    zrush.language.VGUI["BoostAmount"] =  "加速数量: "
    zrush.language.VGUI["FixMachinefirst"] = "快速修复设备!"

    zrush.language.VGUI["Actions"] = "动作:"
    zrush.language.VGUI["Repair"] = "修复"
    zrush.language.VGUI["Stop"] = "停止"
    zrush.language.VGUI["Disassemble"] = "分解"
    zrush.language.VGUI["Start"] = "开始"
    zrush.language.VGUI["CoolDown"] = "冷却"

    zrush.language.VGUI["ModuleShop"] = "组件商店"
    zrush.language.VGUI["Purchase"] = "购买"
    zrush.language.VGUI["Sell"] = "出售"
    zrush.language.VGUI["Locked"] = "已锁定"
    zrush.language.VGUI["NonSocketfound"] = "未查询到免费 \n部件!"
    zrush.language.VGUI["WrongUserGroup"] = "错误的用户组!"
    zrush.language.VGUI["WrongJob"] = "错误的职业!"
    zrush.language.VGUI["TooFarAway"] = "你离物体太远了!"
    zrush.language.VGUI["Youcannotafford"] = "你钱不够!"
    zrush.language.VGUI["allreadyinstalled"] = " 已安装!"
    zrush.language.VGUI["Youbougt"] =  "你购买了一个 $Name 并花了 $Price$Currency"
    zrush.language.VGUI["YouSold"] =  "你卖了一个 $Name 得到了 $Price$Currency"

    zrush.language.VGUI["MachineShop"] = "设备商店"
    zrush.language.VGUI["Place"] = "地方"

    zrush.language.VGUI.MachineBuilder["BuildEntity"] = " - 制造物品"
    zrush.language.VGUI.MachineBuilder["Cancel"] = " - 取消"
    zrush.language.VGUI.MachineBuilder["Needsdrilledfirst"]  = "需要先被钻孔!"
    zrush.language.VGUI.MachineBuilder["NeedsBurnerquick"]  = "需要一个燃烧器!"
    zrush.language.VGUI.MachineBuilder["NeedsPump"]  = "需要一个泵!"
    zrush.language.VGUI.MachineBuilder["NotValidSpace"]  = "不是合适的位置"
    zrush.language.VGUI.MachineBuilder["ToocloseDrillHole"]  = "离另外一个钻孔太近!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildGround"]  = "只能制造在地面上!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildOilSpots"]  = "只能建造在油斑上!"
    zrush.language.VGUI.MachineBuilder["CanonlybuildDrillhole"]  = "只能建造在钻孔上!"
    zrush.language.VGUI.MachineBuilder["NotenoughSpace"]  = "地方不够!"
    zrush.language.VGUI.MachineBuilder["ConnectionLost"]  = "丢失链接!"
    zrush.language.VGUI.MachineBuilder["ReachedMaxDrillhole"]  = "到达最大钻孔数量!"

    zrush.language.Inv["InvEmpty"] = "你的燃油库存为空!"
    zrush.language.Inv["FuelInv"] = "燃油库存: "

    zrush.language.VGUI["speed"] = "速度加成"
    zrush.language.VGUI["production"] = "产物加成"
    zrush.language.VGUI["antijam"] = "去故障加成"
    zrush.language.VGUI["cooling"] = "冷却加成"
    zrush.language.VGUI["refining"] = "精炼加成"
    zrush.language.VGUI["pipes"] = "额外钻杆"

    zrush.language.VGUI.MachineBuilder["MachineLimitReached"] = "达到机器极限！"
end
