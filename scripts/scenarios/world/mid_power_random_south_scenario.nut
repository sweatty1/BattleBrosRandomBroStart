this.mid_power_random_south_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.mid_power_southern_random";
		this.m.Name = "Southern Random Brothers";
		this.m.Description = "[p=c][img]gfx/ui/events/event_156.png[/img][/p][p]Start with 3-4 level 1 brothers. At least 1 (sometimes 2) will be from slightly better than basic background. The rest will be from lowerborn or weaker backgrounds.\n\n[color=#bcad8c]A quick start into the southern part of the world, without any particular advantages or disadvantages.[/color][/p]";
		this.m.Difficulty = 2;
		this.m.Order = 821;
	}

	function isValid()
	{
		return this.Const.DLC.Desert && this.Const.DLC.Unhold && this.Const.DLC.Wildmen;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local higherTierNumOfBros = (Math.rand() * 2 / RAND_MAX).tointeger(); 
		higherTierNumOfBros = higherTierNumOfBros + 1
		local lowTierNumOfBros = 0
		if (higherTierNumOfBros == 1) {
			lowTierNumOfBros = (Math.rand() * 1 / RAND_MAX).tointeger(); 
			lowTierNumOfBros = lowTierNumOfBros + 2;
		} else {
			lowTierNumOfBros = (Math.rand() * 2 / RAND_MAX).tointeger(); 
			lowTierNumOfBros = lowTierNumOfBros + 1;
		}
		for( local i = 0; i < higherTierNumOfBros + lowTierNumOfBros; i++){
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.improveMood(1.5, "Joined a brand new mercenary company");
		}
		foreach (index, dude in roster.getAll()){
			if (index < higherTierNumOfBros) {
				dude.setStartValuesEx(this.southlandUpperList());
			} else {
				dude.setStartValuesEx(this.southlandLowbornList());	
			}
			dude.m.LevelUps = 0;
			dude.m.PerkPoints = 0;
			dude.m.Level = 1;
			dude.setPlaceInFormation(index + 1);
		}
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money + 400;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && randomVillage.isSouthern())
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 4), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 4), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else
				{
					local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(13);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/worldmap_11.ogg"
			], this.Const.Music.CrossFadeTime);
			//this.World.Events.fire("event.southern_quickstart_scenario_intro");
		}, null);
	}

	function southlandUpperList() {
		return [
			"wildman_background",
			"witchhunter_background",
			"squire_background",
			"retired_soldier_background",
			"sellsword_background",
			"raider_background",
			"deserter_background",
			"caravan_hand_southern_background",
			"bastard_background",
			"beast_hunter_background",
			"hunter_background",
			"disowned_noble_background",
			"nomad_background",
			"nomad_ranged_background",
			"wildman_background",
			"witchhunter_background",
			"squire_background",
			"retired_soldier_background",
			"sellsword_background",
			"raider_background",
			"deserter_background",
			"caravan_hand_southern_background",
			"bastard_background",
			"beast_hunter_background",
			"hunter_background",
			"nomad_background",
			"nomad_ranged_background",
			"assassin_southern_background",
			"gladiator_background",
			"belly_dancer_background",
			"crucified_background"
		]
	}

	function southlandLowbornList() {
		return [
				"apprentice_background",
				"beggar_southern_background",
				"bowyer_background",
				"brawler_background",
				"butcher_southern_background",
				"caravan_hand_southern_background",
				"cripple_southern_background",
				"cultist_background",
				"daytaler_southern_background",
				"eunuch_southern_background",
				"farmhand_background",
				"fisherman_southern_background",
				"flagellant_background",
				"gambler_southern_background",
				"gravedigger_background",
				"graverobber_background",
				"historian_southern_background",
				"houndmaster_background",
				"juggler_southern_background",
				"killer_on_the_run_background",
				"lumberjack_background",
				"manhunter_background",
				"mason_background",
				"messenger_background",
				"militia_background",
				"miller_background",
				"miner_background",
				"minstrel_background",
				"pimp_background",
				"monk_background",
				"peddler_southern_background",
				"poacher_background",
				"ratcatcher_background",
				"refugee_background",
				"servant_southern_background",
				"shepherd_southern_background",
				"tailor_southern_background",
				"thief_southern_background",
				"vagabond_background"
			]
	}
});

