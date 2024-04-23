const Map<String, String> levels = {
  "levels/guadalcanal": "Guadalcanal",
  "levels/wake_island": "Wake Island",
  "levels/midway": "Midway",
  "levels/malta": "Malta",
  "levels/water_midway": "Midway",
  "levels/water_coral": "Coral Sea",
  "levels/water_guadalcanal": "Guadalcanal",
  "levels/honolulu": "Oahu",
  "levels/britain": "Britain",
  "levels/sicily": "Sicily",
  "levels/berlin": "Berlin",
  "levels/bulge": "Bulge",
  "levels/korsun": "Korsun",
  "levels/stalingrad": "Stalingrad",
  "levels/stalingrad_w": "Winter Stalingrad",
  "levels/krymsk": "Kuban",
  "levels/port_moresby": "Port Moresby",
  "levels/ruhr": "Ruhr",
  "levels/water_east_china_sea": "East China Sea",
  "levels/water": "Pacific Ocean",
  "levels/peleliu": "Peleliu",
  "levels/arcade_africa_canyon": "Canyon, Africa",
  "levels/arcade_asia_4roads": "Mountain Ridge, China",
  "levels/arcade_phiphi_crater": "African Island, Crater",
  "levels/arcade_phiphi_island": "African Island",
  "levels/arcade_alps": "Alpine Meadows",
  "levels/guam": "Guam",
  "levels/saipan": "Saipan",
  "levels/iwo_jima": "Iwo Jima",
  "levels/philippine_sea": "Philippine Sea",
  "levels/korea": "Korea",
  "levels/mozdok": "Mozdok",
  "levels/mozdok_winter": "Winter Mozdok",
  "levels/norway": "Norway",
  "levels/khalkhin_gol": "Khalkhin Gol",
  "levels/avg_kursk": "Kursk - tank battle",
  "levels/kursk": "Kursk",
  "levels/air_race_phiphi_islands": "Tropical Island",
  "levels/moscow": "Moscow",
  "levels/avg_eastern_europe": "Eastern Europe",
  "levels/avg_poland": "Poland",
  "levels/normandy": "Coast of France",
  "levels/arcade_ireland": "Ireland",
  "levels/avg_mozdok": "Mozdok - tank battle",
  "levels/avg_berlin": "Berlin - tank battle",
  "levels/avg_krymsk": "Kuban - tank battle",
  "levels/avg_stalingrad_factory": "Stalingrad - tank battle",
  "levels/avg_rheinland": "Crossing over the Rhine",
  "levels/avg_volokolamsk": "Volokolamsk",
  "levels/avg_tunisia_desert": "Tunisia",
  "levels/avg_snow_alps": "Frozen Pass",
  "levels/avg_africa_desert": "El Alamein",
  "levels/air_africa_desert": "El Alamein",
  "levels/avg_finland": "Finland",
  "levels/avg_iberian_castle": "Iberian Castle",
  "levels/avg_normandy": "Normandy",
  "levels/avg_hurtgen": "Hürtgen Forest",
  "levels/avg_korea_lake": "The 38th parallel",
  "levels/avg_karelia_forest_a": "Karelia",
  "levels/avg_karpaty_passage": "Carpathians",
  "levels/avg_abandoned_factory": "Abandoned Factory",
  "levels/arcade_africa_seashore": "Deserted Coast",
  "levels/dover_strait": "Dover Strait",
  "levels/arcade_rice_terraces": "Rice Terraces",
  "levels/arcade_canyon_snow": "Iron Range",
  "levels/arcade_norway_fjords": "Fjords",
  "levels/arcade_norway_green": "Green Ridge",
  "levels/arcade_norway_plain": "Foothills",
  "levels/arcade_phiphi_crater_rocks": "Pacific Hidden Base",
  "levels/arcade_snow_rocks": "Top of the World",
  "levels/arcade_zhang_park": "Grave Robbers' Cliffs",
  "levels/avg_european_fortress": "White Rock Fortress",
  "levels/avg_guadalcanal": "Guadalcanal - tank battle",
  "levels/avg_ireland": "Ash River",
  "levels/avg_port_novorossiysk": "Novorossiysk",
  "levels/avg_training_ground": "Shooting Range",
  "levels/caribbean_islands": "Caribbean Islands",
  "levels/hangar_airfield_2014": "Military Airfield",
  "levels/hangar_military_base": "Military Base",
  "levels/hangar_military_base_ny": "Military Base 2017",
  "levels/spain": "Spain",
  "levels/zhengzhou": "Zhengzhou",
  "levels/avg_ardennes": "Bulge - tank battle",
  "levels/avg_fulda": "Fulda Gap",
  "levels/avg_japan": "Imperial Gardens",
  "levels/avg_sector_montmedy": "Maginot Line",
  "levels/avg_lazzaro_italy": "Italy",
  "levels/avg_american_valley": "American Desert",
  "levels/avg_alaska_town": "Alaska Town",
  "levels/air_vietnam": "Vietnam",
  "levels/avg_vietnam_hills": "Vietnam Hills",
  "levels/avg_egypt_sinai": "Sinai",
  "levels/avg_syria": "Middle East",
  "levels/air_ladoga": "Ladoga",
  "levels/air_afghan": "Afghanistan",
  "levels/avn_fiji": "Fiji",
  "levels/avn_alps_fjord": "Green Mountains Gulf",
  "levels/arcade_mediterranean": "Greece",
  "levels/avn_volcanic_island": "Volcanic Island",
  "levels/avg_container_port": "Cargo Port",
  "levels/avn_peleliu": "Palau Islands",
  "levels/avn_japan": "Japanese Port",
  "levels/avn_south_africa": "South Africa",
  "levels/avn_new_zeland_cape": "New Zealand Cape",
  "levels/avn_finland_islands": "South Kvarken",
  "levels/avg_sweden": "Sweden",
  "levels/air_denmark": "Denmark",
  "levels/air_smolensk": "Smolensk",
  "levels/hurtgen": "HÃ¼rtgen",
  "levels/sector_montmedy": "Maginot Line",
  "levels/tunisia": "Tunisia",
  "levels/arcade_tabletop_mountain": "Guiana Highlands",
  "levels/avg_lazzaro_italy_new_city": "Campania",
  "levels/avn_aleutian_islands": "Aleutian Islands",
  "levels/avg_kursk_villages": "Fire Arc",
  "levels/air_skyscraper_city": "City",
  "levels/avg_nuclear_incident": "Ground Zero",
  "levels/avg_soviet_suburban": "Seversk-13",
  "levels/avg_western_europe": "Spaceport",
  "levels/arcade_floating_islands": "Floating Islands",
  "levels/avn_sunken_city": "Drowned City",
  "levels/avg_red_desert": "Red Desert",
  "levels/avg_breslau": "Breslau",
  "levels/firing_range": "Proving Ground",
  "levels/avn_northwestern_islands": "Vyborg Bay",
  "levels/air_equatorial_island": "Bourbon Island",
  "levels/avg_aral_sea": "Aral Sea",
  "levels/air_israel": "Golan Heights",
  "levels/avg_israel": "Sun City",
  "levels/avg_abandoned_town": "Abandoned Town",
  "levels/air_south_eastern_city": "Southeastern City",
  "levels/avg_northern_india": "Pradesh",
  "levels/avn_san_francisco": "Golden Bay",
  "levels/air_grand_canyon": "Rocky Canyon",
  "levels/avg_arctic": "Arctic",
  "levels/avg_northern_valley": "Golden Quarry",
  "levels/air_pyrenees": "Mountain Valleys",
  "levels/avn_franz_josef_land": "Franz Josef Land",
  "levels/avg_soviet_range": "Test Site-2271",
  "levels/air_southeastern_cliffs": "Rocky Pillars",
  "levels/avg_vlaanderen": "Flanders",
  "levels/air_kamchatka": "Volcano Valley",
  "levels/avg_netherlands": "North Holland",
  "levels/avn_norway_islands": "Norway Islands",
  "levels/avg_forgotten_land": "Forgotten Lands",
};

const Map<String, String> gameModes = {
  "air_ground_Dom": "Domination",
  "air_naval_Dom": "Domination",
  "ground_strike": "Ground Strike",
  "air_ground_Conq": "Conquest",
  "air_ground_Bttl": "Battle",
  "base_dom": "Base Domination"
};