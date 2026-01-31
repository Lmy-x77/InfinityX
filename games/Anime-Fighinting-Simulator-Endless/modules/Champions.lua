local Champions = {}

Champions = {
	['1'] = {
		Name = "Levee";
		Desc = "Auto trains 30% of your Sword multiplier every 4 seconds.";
		Abilities = {
			AutoTrainer = {
				['4'] = 0.3;
			};
		};
		ClassNeeded = '4';
		SellingValue = 1000;
		Rarity = 1;
	};
	['2'] = {
		Name = "Sarka";
		Desc = "Auto trains 20% of your Chakra multiplier every 4 seconds and heals 3% of your health every 5 seconds";
		Abilities = {
			AutoTrainer = {
				['3'] = 0.2;
			};
			PassiveHealing = 0.03;
		};
		ClassNeeded = '5';
		SellingValue = 1000;
		Rarity = 1;
	};
	['3'] = {
		Name = "Pilcol";
		Desc = "Auto trains 20% of your Durability and Strength multiplier every 4 seconds.";
		Abilities = {
			AutoTrainer = {
				['2'] = 0.2;
				['1'] = 0.2;
			};
		};
		ClassNeeded = '6';
		SellingValue = 1250;
		Rarity = 2;
	};
	['4'] = {
		Name = "Toju";
		Desc = "Auto trains 35% of your Strength and Durability multiplier every 4 seconds.";
		Abilities = {
			AutoTrainer = {
				['1'] = 0.35;
				['2'] = 0.35;
			};
		};
		ClassNeeded = '8';
		SellingValue = 1250;
		Rarity = 2;
	};
	['5'] = {
		Name = "Keela";
		Desc = "Auto trains 45% of your Speed multiplier every 4 seconds and nerfs Strength damage by 10%.";
		Abilities = {
			AutoTrainer = {
				['6'] = 0.45;
			};
			DamageNerf = {
				['1'] = 0.9;
			};
		};
		ClassNeeded = '4';
		SellingValue = 1000;
		Rarity = 1;
	};
	['6'] = {
		Name = "Canakey";
		Desc = "Auto trains 30% of your Strength multiplier every 4 seconds. Specially buffs Kagune damage by 15% and nerfs incoming Kagune damage by 20%.";
		Abilities = {
			AutoTrainer = {
				['1'] = 0.3;
			};
			SpecialBuff = {"Kagune", 1.15};
			SpecialNerf = {"Kagune", 0.8};
		};
		ClassNeeded = '9';
		SellingValue = 1250;
		Rarity = 2;
	};
	['7'] = {
		Name = "Sunji";
		Desc = "Auto trains 40% of your Agility multiplier every 4 seconds and buffs Punch damage by 40%.";
		Abilities = {
			AutoTrainer = {
				['5'] = 0.4;
			};
			DamageBuff = {
				Punch = 1.4;
			};
		};
		ClassNeeded = '3';
		SellingValue = 1000;
		Rarity = 1;
	};
	['8'] = {
		Name = "Loofi";
		Desc = "Auto trains 40% of your Agility and 35% Strength multiplier every 4 seconds. Specially buffs Fruit damage by 25% and nerfs incoming Fruit damage by 20%.";
		Abilities = {
			AutoTrainer = {
				['5'] = 0.4;
				['1'] = 0.35;
			};
			SpecialBuff = {"Fruit", 1.25};
			SpecialNerf = {"Fruit", 0.8};
		};
		ClassNeeded = '9';
		SellingValue = 1500;
		Rarity = 3;
	};
	['9'] = {
		Name = "Asto";
		Desc = "Auto trains 45% of your Sword multiplier every 4 seconds. Specially buffs Grimoire damage by 25% nerfs incoming Grimoire damage by 20%. Also nerfs and buffs Sword Slash damage by 20%";
		Abilities = {
			AutoTrainer = {
				['4'] = 0.45;
			};
			SpecialBuff = {"Grimoire", 1.25};
			SpecialNerf = {"Grimoire", 0.8};
			DamageNerf = {
				SwordSlash = 0.8;
			};
			DamageBuff = {
				SwordSlash = 1.2;
			};
		};
		ClassNeeded = "11";
		SellingValue = 1500;
		Rarity = 3;
	};
	["10"] = {
		Name = "Junwon";
		Desc = "Auto trains 40% of your Strength multiplier every 4 seconds. Specially buffs Quark damage by 25% nerfs incoming Quark damage by 20%.";
		Abilities = {
			AutoTrainer = {
				['1'] = 0.4;
			};
			SpecialBuff = {"Quirk", 1.25};
			SpecialNerf = {"Quirk", 0.8};
		};
		ClassNeeded = "11";
		SellingValue = 1500;
		Rarity = 3;
	};
	["11"] = {
		Name = "Tojaro";
		Desc = "Auto trains 45% of your Durability multiplier every 4 seconds. Specially buffs Stand damage by 20% and nerfs incoming Stand damage by 25%.";
		Abilities = {
			AutoTrainer = {
				['2'] = 0.45;
			};
			SpecialBuff = {"Stand", 1.2};
			SpecialNerf = {"Stand", 0.75};
		};
		ClassNeeded = "12";
		SellingValue = 1500;
		Rarity = 3;
	};
	["12"] = {
		Name = "Juyari";
		Desc = "Auto trains 50% of your Chakra multiplier every 4 seconds. Nerfs Chakra damage by 25%.";
		Abilities = {
			AutoTrainer = {
				['3'] = 0.5;
			};
			DamageNerf = {
				['3'] = 0.75;
			};
		};
		ClassNeeded = "12";
		SellingValue = 2200;
		Rarity = 4;
	};
	["13"] = {
		Name = "Narnto";
		Desc = "Auto trains 55% of your Chakra multiplier every 4 seconds. Nerfs all Chakra damage by 30% and buffs Chakra damage by 20%.";
		Abilities = {
			AutoTrainer = {
				['3'] = 0.55;
			};
			DamageNerf = {
				['3'] = 0.7;
			};
			DamageBuff = {
				['3'] = 1.2;
			};
		};
		ClassNeeded = "12";
		SellingValue = 2200;
		Rarity = 4;
	};
	["19"] = {
		Name = "Remgonuk";
		Desc = "Auto trains 30% of your Chakra, 70% of your Sword multiplier every 4 seconds. Nerfs all Chakra damage by 40% and buffs Chakra damage by 30%.";
		Abilities = {
			AutoTrainer = {
				['3'] = 0.3;
				['4'] = 0.7;
			};
			DamageNerf = {
				['3'] = 0.6;
			};
			DamageBuff = {
				['3'] = 1.3;
			};
		};
		ClassNeeded = "14";
		SellingValue = 3100;
		Rarity = 5;
	};
	["17"] = {
		Name = "Boras";
		Desc = "Auto trains 30% of your Chakra, 50% Strength and Durability multiplier every 4 seconds. Nerfs all player damage by 30% and buffs all damage by 20%.";
		Abilities = {
			AutoTrainer = {
				['1'] = 0.5;
				['2'] = 0.5;
				['3'] = 0.3;
			};
			DamageNerfAll = 0.7;
			DamageBuffAll = 1.2;
		};
		ClassNeeded = "14";
		SellingValue = 3100;
		Rarity = 5;
	};
	["18"] = {
		Name = "Igicho";
		Desc = "Auto trains 30% of your Strength, 75% of Sword, and 50% of Durability multiplier every 4 seconds. Nerfs all player damage by 10% and buffs all damage by 40%.";
		Abilities = {
			AutoTrainer = {
				['4'] = 0.75;
				['1'] = 0.3;
				['2'] = 0.5;
			};
			DamageNerfAll = 0.9;
			DamageBuffAll = 1.4;
		};
		ClassNeeded = "15";
		SellingValue = 3100;
		Rarity = 5;
	};
	["21"] = {
		Name = "Vetega";
		Desc = "Auto trains 50% of your Strength multiplier every 4 seconds. Nerfs all Strength damage by 30% and all damage is buffed by 1.6x when health is below 30%.";
		Abilities = {
			AutoTrainer = {
				['1'] = 0.5;
			};
			HealthReactive = {
				Type = "DamageBuff";
				Amount = 1.6;
				When = 0.3;
			};
			DamageNerf = {
				['1'] = 0.7;
			};
		};
		ClassNeeded = "13";
		SellingValue = 2250;
		Rarity = 4;
	};
	["22"] = {
		Name = "Sasoke";
		Desc = "Every player kill multiplies damage by 80% for 20 seconds. Trains 80% of chakra, nerfs all damage by 25% and buffs all damage by 50%";
		Abilities = {
			AutoTrainer = {
				['3'] = 0.8;
			};
			DamageNerfAll = 0.75;
			DamageBuffAll = 1.5;
			MultiplyDamage = {
				Active = {
					Kill = true;
				};
				MultiplyBy = 1.8;
				Cooldown = 60;
				LongTime = 20;
			};
		};
		ClassNeeded = "15";
		SellingValue = 7500;
		Rarity = 5;
	};
	["25"] = {
		Name = "Genas";
		Desc = "When the player reaches 20% of his health, all damages are reduced to 30% of their original value. Auto trains 95% of your Chakra, Nerfs all player damage by -30%, buffs all Damage by +15%";
		Abilities = {
			AutoTrainer = {
				['3'] = 0.95;
			};
			DamageNerfAll = 0.3;
			DamageBuffAll = 1.15;
			HealthReactive = {
				Type = "DamageNerfAll";
				Amount = 0.3;
				When = 0.2;
			};
		};
		ClassNeeded = "14";
		SellingValue = 3000;
		Rarity = 5;
	};
	["26"] = {
		Name = "Gokro";
		Desc = "After every player kill your damage doubles for 10 seconds. Auto trains 95% of your Chakra, Nerfs all player damage by -50%, buffs all Damage by +25%";
		Abilities = {
			AutoTrainer = {
				['3'] = 0.95;
			};
			DamageNerfAll = 0.5;
			DamageBuffAll = 1.25;
			MultiplyDamage = {
				Active = {
					Kill = true;
				};
				MultiplyBy = 2;
				Cooldown = 60;
				LongTime = 10;
			};
		};
		ClassNeeded = "16";
		SellingValue = 7500;
		Rarity = 6;
	};
	["27"] = {
		Name = "Goju";
		Desc = "Auto trains 125% Durability, Nerfs all player damage by -50%, buffs all Damage by +25%, and increases your Chikara Per Min by x1.5";
		Abilities = {
			AutoTrainer = {
				['2'] = 1.25;
			};
			DamageNerfAll = 0.5;
			DamageBuffAll = 1.25;
			MultiplyDamage = {
				Active = {
					Kill = true;
				};
				MultiplyBy = 2;
				Cooldown = 60;
				LongTime = 10;
			};
			ChikaraBuff = 1.5;
		};
		ClassNeeded = "16";
		SellingValue = 7500;
		Rarity = 6;
	};
	["28"] = {
		Name = "Kitiro";
		Desc = "Auto trains 125% Sword, Nerfs all player damage by -50%, buffs all Damage by +25%, increases your Yen Per Min by x1.05";
		Abilities = {
			AutoTrainer = {
				['4'] = 1.25;
			};
			DamageNerfAll = 0.5;
			DamageBuffAll = 1.25;
			MultiplyDamage = {
				Active = {
					Kill = true;
				};
				MultiplyBy = 2;
				Cooldown = 60;
				LongTime = 10;
			};
			YenBuff = 1.05;
		};
		ClassNeeded = "16";
		SellingValue = 7500;
		Rarity = 6;
	};
	["29"] = {
		Name = "Itachu";
		Desc = "When the player reaches 10% of his health, he will become immune to all attacks for 8 seconds. Trains 80% of chakra, 20% of Strength and 20% of Durability. He also nerfs all damage by 25% and buffs all damage by 50%";
		Abilities = {
			AutoTrainer = {
				['1'] = 0.2;
				['2'] = 0.2;
				['3'] = 0.8;
			};
			DamageNerfAll = 0.75;
			DamageBuffAll = 1.5;
			Imune = {
				Active = {
					Health = 10;
				};
				Cooldown = 60;
				LongTime = 8;
			};
		};
		ClassNeeded = "16";
		SellingValue = 10000;
		Rarity = 6;
	};
	["30"] = {
		Name = "Bright Yagimi";
		Desc = "Auto trains 100% of your Chakra, Nerfs all player damage by 50%, buffs all Damage by 50%, and increases your Chikara Per Min by x1.5";
		Abilities = {
			AutoTrainer = {
				['3'] = 1;
			};
			DamageNerfAll = 0.5;
			DamageBuffAll = 1.5;
			ChikaraBuff = 1.5;
		};
		ClassNeeded = "17";
		SellingValue = 10000;
		Rarity = 6;
	};
	["31"] = {
		Name = "Saytamu Serious";
		Desc = "Auto trains 150% of your Strength, 150% of your Durability, Nerfs all player damage by 50%, buffs all Damage by 100%, increases your Chikara Per Min by x1.5, increases your Yen Per Min by x1.25";
		Abilities = {
			AutoTrainer = {
				['1'] = 1.5;
				['2'] = 1.5;
			};
			DamageNerfAll = 0.5;
			DamageBuffAll = 2;
			ChikaraBuff = 1.5;
			YenBuff = 1.25;
		};
		ClassNeeded = "20";
		SellingValue = 50000;
		Rarity = 7;
	};
	["32"] = {
		Name = "Awakaned Naturo";
		Desc = "Auto trains 175% of your Durability, Nerfs all player damage by 25%, buffs all Bloodline damage by 55%, increases your Yen Per Min by x1.15";
		Abilities = {
			AutoTrainer = {
				['2'] = 1.75;
			};
			DamageNerfAll = 0.75;
			SpecialBuff = {"Bloodlines", 1.155};
			YenBuff = 1.15;
		};
		ClassNeeded = "20";
		SellingValue = 0;
		Rarity = 7;
	};
	["33"] = {
		Name = "Pebble Lee";
		Desc = "Auto trains 110% of your Strength, 120% of your Durability, 125% of your Speed, 125% of your Agility, Nerfs all player damage by 25%, buffs all damage by 25%, increases your Yen Per Min by x1.05";
		Abilities = {
			AutoTrainer = {
				['1'] = 1.1;
				['2'] = 1.2;
				['5'] = 1.25;
				['6'] = 1.25;
			};
			DamageNerfAll = 0.75;
			DamageBuffAll = 1.25;
			YenBuff = 1.05;
		};
		ClassNeeded = "20";
		SellingValue = 0;
		Rarity = 7;
	};
	["34"] = {
		Name = "Shunks";
		Desc = "Auto trains 125% of your Sword, 125% of your Durability, Nerfs all player damage by 30%, buffs all Damage by 35%, increases your Yen Per Min by x1.1";
		Abilities = {
			AutoTrainer = {
				['2'] = 1.25;
				['4'] = 1.25;
			};
			DamageNerfAll = 0.7;
			DamageBuffAll = 1.35;
			YenBuff = 1.1;
		};
		ClassNeeded = "20";
		SellingValue = 0;
		Rarity = 7;
	};
	["35"] = {
		Name = "Tatashi";
		Desc = "Auto trains 160% of your Strength, Nerfs all player damage by 20%, buffs all Damage by 25%, increases your Yen Per Min by x1.1";
		Abilities = {
			AutoTrainer = {
				['1'] = 1.6;
			};
			DamageNerfAll = 0.8;
			DamageBuffAll = 1.25;
			YenBuff = 1.1;
		};
		ClassNeeded = "20";
		SellingValue = 0;
		Rarity = 7;
	};
	["101"] = {
		Name = "Giovanni";
		Desc = "Trains 60% Strength, and 50% Durability. Buffs all stand damage by 20%";
		Abilities = {
			AutoTrainer = {
				['1'] = 0.6;
				['2'] = 0.5;
			};
			SpecialBuff = {"Stand", 1.2};
		};
		ClassNeeded = "15";
		SellingValue = 2200;
		Rarity = 4;
	};
	["102"] = {
		Name = "Booh";
		Desc = "Trains 70% Strength, and 70% Chakra. Buffs all damage by 20%, Nerfs all damage by 10%";
		Abilities = {
			AutoTrainer = {
				['1'] = 0.7;
				['3'] = 0.7;
			};
			DamageNerfAll = 0.9;
			DamageBuffAll = 1.2;
		};
		ClassNeeded = "16";
		SellingValue = 3100;
		Rarity = 5;
	};
	["103"] = {
		Name = "Gen";
		Desc = "Trains 50% Strength, 50% Durability and 50% Chakra. He nerfs all incoming damage by 35%.";
		Abilities = {
			AutoTrainer = {
				['1'] = 0.5;
				['2'] = 0.5;
				['3'] = 0.5;
			};
			DamageNerfAll = 0.65;
		};
		ClassNeeded = "16";
		SellingValue = 3100;
		Rarity = 5;
	};
	["104"] = {
		Name = "Mallyodas";
		Desc = "A strength oriented Champion by training 90% of Strength and 80% of Durability. Overall, he nerfs all damage by 50% and buffs all outgoing damage by 35%.";
		Abilities = {
			AutoTrainer = {
				['1'] = 0.9;
				['2'] = 0.8;
			};
			DamageNerfAll = 0.5;
			DamageBuffAll = 1.35;
		};
		ClassNeeded = "17";
		SellingValue = 10000;
		Rarity = 6;
	};
	["105"] = {
		Name = "Shunro";
		Desc = "Shunro trains 70% of Speed, 45% of Durability and 55% of Chakra, finally he also doubles all chakra damage.";
		Abilities = {
			AutoTrainer = {
				['2'] = 0.45;
				['3'] = 0.55;
				['6'] = 0.7;
			};
			DamageBuff = {
				['3'] = 2;
			};
		};
		ClassNeeded = "17";
		SellingValue = 10000;
		Rarity = 6;
	};
	["106"] = {
		Name = "Kroll";
		Desc = "Trains 95% Strength and 85% Durability. Buffs all damage by 30%. Nerfs all Quarks by an additional 50%";
		Abilities = {
			AutoTrainer = {
				['1'] = 0.95;
				['2'] = 0.85;
			};
			SpecialNerf = {"Quirk", 0.5};
			DamageBuffAll = 1.3;
		};
		ClassNeeded = "17";
		SellingValue = 10000;
		Rarity = 6;
	};
	["107"] = {
		Name = "Eskano";
		Desc = "Trains 60% Sword, 50% Durability and 45% Strength, he doubles all your damage and nerfs all incoming damage by 50% when it's day time.";
		Abilities = {
			AutoTrainer = {
				['1'] = 0.45;
				['2'] = 0.5;
				['4'] = 0.6;
			};
			DaytimeBuff = {
				DamageNerf = 0.5;
				DamageBuff = 2;
			};
		};
		ClassNeeded = "17";
		SellingValue = 10000;
		Rarity = 6;
	};
	["108"] = {
		Name = "Saytamu";
		Desc = "Auto trains 110% of your Strength, 110% of your Durability, Nerfs all player damage by 50%, buffs all Damage by 50%, increases your Yen Per Min by x1.1";
		Abilities = {
			AutoTrainer = {
				['1'] = 1.1;
				['2'] = 1.1;
			};
			DamageNerfAll = 0.5;
			DamageBuffAll = 1.5;
			YenBuff = 1.1;
		};
		ClassNeeded = "17";
		SellingValue = 10000;
		Rarity = 6;
	};
	["1000"] = {
		Name = "Top Card";
		Desc = "Auto trains 140% of your Strength, 140% of your Durability, Nerfs all player damage by 50%, buffs all Damage by 25%, increases your Yen Per Min by x1.1, and prevents you from being stunned.";
		Abilities = {
			AutoTrainer = {
				['1'] = 1.4;
				['2'] = 1.4;
			};
			DamageNerfAll = 0.5;
			DamageBuffAll = 1.25;
			YenBuff = 1.1;
			NoStun = true;
		};
		ClassNeeded = "17";
		SellingValue = 10000;
		Rarity = 6;
	};
	["1001"] = {
		Name = "Reindeer";
		Desc = "Auto trains 100% of your Durability, 100% of your Sword, Nerfs all player damage by 30%, buffs all Damage by 30%, and increases your Chikara Per Min by x1.05.";
		Abilities = {
			AutoTrainer = {
				['2'] = 1;
				['4'] = 1;
			};
			DamageNerfAll = 0.7;
			DamageBuffAll = 1.3;
			ChikaraBuff = 1.05;
		};
		ClassNeeded = "17";
		SellingValue = 10000;
		Rarity = 6;
	};
	["1002"] = {
		Name = "Riru";
		Desc = "Auto trains 200% of your Chakra, Nerfs all player damage by 50%, buffs all Damage by 50%, and increases your Chikara Per Min by x2.";
		Abilities = {
			AutoTrainer = {
				['3'] = 2;
			};
			DamageNerfAll = 0.5;
			DamageBuffAll = 1.5;
			ChikaraBuff = 2;
		};
		ClassNeeded = "17";
		SellingValue = 10000;
		Rarity = 7;
	};
	["1003"] = {
		Name = "Paien";
		Desc = "Auto trains 150% of your Strength, 140% of your Durability and 40% Sword, Nerfs all player damage by 50%, buffs all Damage by 25%, and increases your Chikara Per Min by x1.75.";
		Abilities = {
			AutoTrainer = {
				['1'] = 1.5;
				['2'] = 1.4;
				['4'] = 0.4;
			};
			DamageNerfAll = 0.5;
			DamageBuffAll = 1.25;
			ChikaraBuff = 1.75;
		};
		ClassNeeded = "17";
		SellingValue = 15000;
		Rarity = 6;
	};
	["1004"] = {
		Name = "Minetu";
		Desc = "Auto trains 175% of your Chakra, Buffs Kuruma damage by 1.5x and Kuruma drop chances by 1.5x, increases your Yen Per Min by x1.05.";
		Abilities = {
			AutoTrainer = {
				['3'] = 1.75;
			};
			BuffDamageKuruma = 1.5;
			BuffKurumaRate = 1.5;
			YenBuff = 1.05;
		};
		ClassNeeded = "17";
		SellingValue = 15000;
		Rarity = 6;
	};
	["999999996"] = {
		Name = "Makima";
		Desc = longstring1;
		Abilities = {
			AutoTrainer = {
				['1'] = 0.01;
				['2'] = 0.01;
				['3'] = 0.01;
				['4'] = 0.01;
			};
			DamageNerfAll = 1;
			DamageBuffAll = 0.01;
			ChikaraBuff = 0;
		};
		ClassNeeded = "99";
		SellingValue = 0;
		Rarity = 7;
	};
	["999999995"] = {
		Name = "Enid";
		Desc = longstring1;
		Abilities = {
			AutoTrainer = {
				['1'] = 0.01;
				['2'] = 0.01;
				['3'] = 0.01;
				['4'] = 0.01;
			};
			DamageNerfAll = 1;
			DamageBuffAll = 0.01;
			ChikaraBuff = 0;
		};
		ClassNeeded = "99";
		SellingValue = 0;
		Rarity = 7;
	};
	["999999997"] = {
		Name = "Esdeath";
		Desc = longstring1;
		Abilities = {
			AutoTrainer = {
				['1'] = 0.01;
				['2'] = 0.01;
				['3'] = 0.01;
				['4'] = 0.01;
			};
			DamageNerfAll = 1;
			DamageBuffAll = 0.01;
			ChikaraBuff = 0;
		};
		ClassNeeded = "99";
		SellingValue = 0;
		Rarity = 7;
	};
	["999999999"] = {
		Name = "Tung Tung Sahur";
		Desc = longstring1;
		Abilities = {
			AutoTrainer = {
				['1'] = 0.01;
				['2'] = 0.01;
				['3'] = 0.01;
				['4'] = 0.01;
			};
			DamageNerfAll = 1;
			DamageBuffAll = 0.01;
			ChikaraBuff = 0;
		};
		ClassNeeded = "99";
		SellingValue = 0;
		Rarity = 7;
	};
	["999999998"] = {
		Name = "Wednesday";
		Desc = longstring1;
		Abilities = {
			AutoTrainer = {
				['1'] = 0.01;
				['2'] = 0.01;
				['3'] = 0.01;
				['4'] = 0.01;
			};
			DamageNerfAll = 1;
			DamageBuffAll = 0.01;
			ChikaraBuff = 0;
		};
		ClassNeeded = "99";
		SellingValue = 0;
		Rarity = 7;
	};
};

return Champions
