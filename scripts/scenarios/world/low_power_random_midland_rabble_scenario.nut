this.low_power_random_midland_rabble_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.low_power_random_midland_rabble";
		this.m.Name = "Random Rabble";
		this.m.Description = "[p=c][img]gfx/ui/events/event_141.png[/img][/p][p]Start with 3-7 brothers from basic, weaker backgrounds.\n\n[color=#bcad8c]A quick start into the world, without any particular advantages or disadvantages.[/color][/p]";
		this.m.Difficulty = 3;
		this.m.Order = 850;
	}

	function isValid()
	{
		return this.Const.DLC.Desert && this.Const.DLC.Unhold && this.Const.DLC.Wildmen;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local numOfBros = (Math.rand() * 5 / RAND_MAX).tointeger(); 
		numOfBros = numOfBros + 3;
		for( local i = 0; i < numOfBros; i++){
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.improveMood(1.5, "Joined a brand new mercenary company");
		}
		foreach (index, dude in roster.getAll()){
			dude.setStartValuesEx(this.midlandLowbornList());
			dude.m.LevelUps = 0;
			dude.m.PerkPoints = 0;
			dude.m.Level = 1;
			dude.setPlaceInFormation(index + 1);
		}
		this.World.Assets.m.BusinessReputation = 0;
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money + 400;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3 && !randomVillage.isSouthern())
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
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(this.Const.Music.IntroTracks, this.Const.Music.CrossFadeTime);
			//this.World.Events.fire("event.true_random_rabble_scenario_intro");
		}, null);
	}

	function midlandLowbornList() {
		return [
				"apprentice_background",
				"beggar_background",
				"bowyer_background",
				"brawler_background",
				"butcher_background",
				"caravan_hand_background",
				"cripple_background",
				"cultist_background",
				"daytaler_background",
				"eunuch_background",
				"farmhand_background",
				"fisherman_background",
				"flagellant_background",
				"gambler_background",
				"gravedigger_background",
				"graverobber_background",
				"historian_background",
				"houndmaster_background",
				"juggler_background",
				"killer_on_the_run_background",
				"lumberjack_background",
				"manhunter_background",
				"mason_background",
				"messenger_background",
				"militia_background",
				"miller_background",
				"miner_background",
				"minstrel_background",
				"monk_background",
				"peddler_background",
				"pimp_background",
				"poacher_background",
				"ratcatcher_background",
				"refugee_background",
				"servant_background",
				"shepherd_background",
				"tailor_background",
				"thief_background",
				"vagabond_background"
			]
	}
});
