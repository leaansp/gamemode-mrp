#if defined _map_ext_plaza_fierro_inc
	#endinput
#endif
#define _map_ext_plaza_fierro_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid) //en caso de no tener Removes, Borrar este hook
{
	
	RemoveBuildingForPlayer(playerid, 620, 2121.510, -1909.530, 10.804, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2110.270, -1906.589, 5.031, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2116.929, -1916.079, 10.804, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2122.659, -1916.790, 10.804, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2115.669, -1922.770, 10.804, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2113.399, -1925.040, 10.804, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2114.550, -1928.189, 5.031, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2123.360, -1928.069, 6.843, 0.250);
	/*RemoveBuildingForPlayer(playerid, 620, 2114.5547, -1928.1875, 5.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2113.3984, -1925.0391, 10.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2115.6719, -1922.7656, 10.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2123.3594, -1928.0703, 6.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2122.6563, -1916.7891, 10.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2116.9297, -1916.0781, 10.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2121.5078, -1909.5313, 10.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2110.2734, -1906.5859, 5.0313, 0.25);
  */return true;
}

hook LoadMaps() {
	new tmpobjid;
	tmpobjid = CreateDynamicObject(3660, 2118.394775, -1925.545410, 14.012504, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "crazypave", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 13691, "bevcunto2_lahills", "crazypave", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(3660, 2118.384765, -1914.252319, 14.032505, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "crazypave", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 13691, "bevcunto2_lahills", "crazypave", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19426, "all_walls", "mirror01", 0x00000000);
	tmpobjid = CreateDynamicObject(1256, 2111.742675, -1910.513305, 13.166886, 0.000000, 0.000000, 450.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 4004, "civic07_lan", "downtsign11_LA", 0x00000000);
	tmpobjid = CreateDynamicObject(1256, 2111.742675, -1913.843383, 13.166886, 0.000000, 0.000000, 630.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 1455, "cj_bar", "CJ_SK_DIET_Bar", 0x00000000);
	tmpobjid = CreateDynamicObject(2762, 2111.780761, -1912.185791, 12.876880, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18250, "cw_junkbuildcs_t", "Was_scrpyd_shack_wall", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 18250, "cw_junkbuildcs_t", "Was_scrpyd_shack_wall", 0x00000000);
	tmpobjid = CreateDynamicObject(1256, 2110.607421, -1924.716552, 13.166886, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 2645, "cj_piz_sign", "CJ_PIZZA_MEN1", 0x00000000);
	tmpobjid = CreateDynamicObject(1256, 2113.600341, -1924.716552, 13.166886, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 2577, "cj_sex", "CJ_PORNO_VIDS2", 0x00000000);
	tmpobjid = CreateDynamicObject(2762, 2112.192626, -1924.696411, 12.876880, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18250, "cw_junkbuildcs_t", "Was_scrpyd_shack_wall", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 18250, "cw_junkbuildcs_t", "Was_scrpyd_shack_wall", 0x00000000);
	tmpobjid = CreateDynamicObject(1256, 2124.783203, -1918.183227, 13.166886, 0.000000, 0.000000, 450.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 2543, "cj_ss_3", "CJ_DOG_FOOD2", 0x00000000);
	tmpobjid = CreateDynamicObject(2762, 2124.752685, -1919.777832, 12.876880, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18250, "cw_junkbuildcs_t", "Was_scrpyd_shack_wall", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 18250, "cw_junkbuildcs_t", "Was_scrpyd_shack_wall", 0x00000000);
	tmpobjid = CreateDynamicObject(1256, 2124.783203, -1921.364624, 13.166886, 0.000000, 0.000000, 630.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 2624, "cj_urb", "counter2", 0x00000000);
	tmpobjid = CreateDynamicObject(2691, 2113.263671, -1905.386718, 14.466876, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "{FFFFFF} Plazoleta Obrero", 130, "Calibri", 24, 1, 0x00000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(1483, 2137.385498, -1907.786865, 14.206875, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 17634, "landlae2b", "compfence5b_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(1256, 2126.601074, -1910.543334, 13.166886, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18034, "cj_ammun_extra", "CJ_NAIL_AMMO", 0x00000000);
	tmpobjid = CreateDynamicObject(1256, 2123.658203, -1910.543334, 13.166886, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 2047, "cj_ammo_posters", "CJ_Coltposter", 0x00000000);
	tmpobjid = CreateDynamicObject(2762, 2125.133056, -1910.514526, 12.876880, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 18250, "cw_junkbuildcs_t", "Was_scrpyd_shack_wall", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 18250, "cw_junkbuildcs_t", "Was_scrpyd_shack_wall", 0x00000000);
	tmpobjid = CreateDynamicObject(1483, 2137.385498, -1912.666748, 14.206875, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 17634, "landlae2b", "compfence5b_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(11699, 2134.054199, -1904.387695, 12.421316, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrow-1-edge", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19130, "matarrows", "arrow-1-edge", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 19130, "matarrows", "arrow-1-edge", 0x00000000);
	tmpobjid = CreateDynamicObject(2691, 2134.153808, -1904.325683, 15.066882, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterialText(tmpobjid, 0, "{FFFFFF} E", 90, "Engravers MT", 67, 1, 0x00000000, 0x00000000, 1);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(673, 2114.342041, -1929.004882, 12.642332, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19467, 2104.741210, -1904.929199, 12.026869, 180.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1897, 2122.506835, -1929.156372, 12.596874, 0.000000, 0.000000, 540.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19467, 2104.741210, -1904.278564, 12.026869, 180.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1897, 2122.505859, -1928.175415, 13.576881, 90.000000, 90.000000, 810.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2121.443115, -1930.835449, 12.642332, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2125.656982, -1906.847045, 11.196867, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2121.562500, -1916.838134, 12.456873, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19981, 2113.232421, -1905.444213, 11.796865, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19467, 2131.405273, -1904.929199, 12.026869, 180.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19467, 2131.405273, -1904.266723, 12.016870, 180.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2112.998291, -1918.080200, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1428, 2124.049804, -1926.827514, 14.652837, 104.899993, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1428, 2125.613037, -1926.827514, 13.098691, 14.899993, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(760, 2115.524902, -1907.251831, 11.986869, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1223, 2117.100097, -1919.920288, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1428, 2122.498779, -1926.827514, 13.096987, 14.899993, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1412, 2138.236816, -1904.536376, 13.766900, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(1412, 2138.146728, -1915.959960, 13.766900, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 

	// Arboles grandes
	/*CreateDynamicObject(617, 2108.867675, -1914.757934, 12.163370, 0.000000, 0.000000, 0.000000, -1, -1, -1, .streamdistance = -1.0, .drawdistance = 300.00);
	CreateDynamicObject(659, 2125.114013, -1930.629760, 12.517040, 0.000000, 0.000000, 0.000000, -1, -1, -1, .streamdistance = -1.0, .drawdistance = 300.00);
	CreateDynamicObject(618, 2126.948242, -1907.041992, 12.375947, 0.000000, 0.000000, 0.000000, -1, -1, -1, .streamdistance = -1.0, .drawdistance = 300.00);

	Textura = CreateDynamicObject(19428, 2117.612060, -1906.172851, 12.472700, 0.000000, 90.000000, 90.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(Textura, 0, 4593, "buildblk55", "sl_plazatile01", 0x00000000);
	Textura = CreateDynamicObject(19428, 2117.612060, -1909.675170, 12.472700, 0.000000, 90.000000, -90.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(Textura, 0, 4593, "buildblk55", "sl_plazatile01", 0x00000000);
	Textura = CreateDynamicObject(19428, 2117.612060, -1913.180786, 12.472700, 0.000000, -90.000000, 90.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(Textura, 0, 4593, "buildblk55", "sl_plazatile01", 0x00000000);
	Textura = CreateDynamicObject(19428, 2117.612060, -1916.664062, 12.482700, 0.000000, -90.000000, 90.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(Textura, 0, 4593, "buildblk55", "sl_plazatile01", 0x00000000);
	Textura = CreateDynamicObject(19428, 2117.612060, -1920.117431, 12.492697, 0.000000, -90.000000, 90.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(Textura, 0, 4593, "buildblk55", "sl_plazatile01", 0x00000000);
	Textura = CreateDynamicObject(19428, 2117.609863, -1923.531005, 12.482700, 0.000000, -90.000000, 90.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(Textura, 0, 4593, "buildblk55", "sl_plazatile01", 0x00000000);
	Textura = CreateDynamicObject(19428, 2117.609863, -1926.999755, 12.472700, 0.000000, -90.000000, 90.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(Textura, 0, 4593, "buildblk55", "sl_plazatile01", 0x00000000);
	Textura = CreateDynamicObject(19428, 2117.609863, -1930.476074, 12.474497, 0.000000, -90.000000, 90.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(Textura, 0, 4593, "buildblk55", "sl_plazatile01", 0x00000000);
	Textura = CreateDynamicObject(19428, 2117.609863, -1933.541503, 12.477997, 0.000000, -90.000000, 90.000000, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(Textura, 0, 4593, "buildblk55", "sl_plazatile01", 0x00000000);
	Textura = CreateDynamicObject(19981, 2115.066406, -1904.691284, 11.599291, 0.000000, -0.000015, 179.999908, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterial(Textura, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
	Textura = CreateDynamicObject(1547, 2115.086425, -1904.661254, 14.269298, 89.999992, -90.000000, -89.999992, -1, -1, -1, 100.00, 100.00);
	SetDynamicObjectMaterialText(Textura, 0, "Parque Ferroviario", 130, "Ariel", 70, 0, 0xDADADAFF, 0x00000000, 1);

	// Arboles menores
	CreateDynamicObject(779, 2123.677490, -1910.998657, 12.536217, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	CreateDynamicObject(779, 2124.344726, -1923.958984, 12.536600, 0.000000, 0.000000, 29.340019, -1, -1, -1, 100.00, 100.00);
	CreateDynamicObject(892, 2108.672363, -1907.292968, 11.939007, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	CreateDynamicObject(888, 2115.241210, -1923.520507, 12.127867, 0.000000, 0.000000, 64.199996, -1, -1, -1, 100.00, 100.00);
	CreateDynamicObject(891, 2119.932373, -1916.933349, 12.503060, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	CreateDynamicObject(891, 2109.545898, -1923.519042, 12.534390, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);
	CreateDynamicObject(892, 2112.501953, -1930.561035, 12.537927, 0.000000, 0.000000, 0.000000, -1, -1, -1, 100.00, 100.00);

	// Luminaria
	CreateDynamicObject(1223, 2118.99341, -1908.00305, 12.50890, 0.00000, 0.00000, 180.00000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1223, 2116.30200, -1919.88477, 12.50890, 0.00000, 0.00000, 0.00000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1223, 2118.92285, -1931.79395, 12.50890, 0.00000, 0.00000, 180.00000, -1, -1, -1, 70.00, 70.00);

	// Bancos
	CreateDynamicObject(1280, 2112.916259, -1904.754272, 12.916410, 0.000000, 0.000000, -89.519920, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1280, 2122.897216, -1904.721313, 12.927570, 0.000000, 0.000000, -90.060127, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1280, 2118.886230, -1910.041870, 12.946720, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1280, 2116.416503, -1917.390991, 12.923800, 0.000000, 0.000000, 180.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1280, 2123.885742, -1918.424438, 12.951600, 0.000000, 0.000000, 180.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1280, 2127.452880, -1918.503417, 12.951370, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1280, 2109.655761, -1917.264526, 12.947299, 0.000000, 0.000000, 180.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1280, 2112.151855, -1917.523193, 12.926500, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1280, 2118.921875, -1924.320556, 12.924098, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1280, 2123.276123, -1932.809326, 12.902997, 0.000000, 0.000000, -59.519939, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1280, 2113.426269, -1933.217285, 12.807000, 0.000000, 0.000000, -118.500160, -1, -1, -1, 70.00, 70.00);

	CreateDynamicObject(19838, 2123.896240, -1904.358642, 12.401760, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(19838, 2111.890136, -1904.410278, 12.329277, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(810, 2126.690917, -1906.331298, 12.411470, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(19837, 2116.459472, -1907.287231, 12.352707, 0.000000, 0.000007, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(19837, 2119.117919, -1910.184204, 12.406957, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(2670, 2117.500000, -1907.535766, 12.648130, 0.000000, 0.000000, -69.599983, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(2671, 2117.596191, -1915.972534, 12.559807, 0.000000, 0.000000, -150.119934, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(2674, 2117.340087, -1929.391845, 12.569667, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1487, 2124.603271, -1917.109863, 12.763270, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(2670, 2126.639892, -1918.590209, 12.637517, 0.000000, 0.000000, -76.260040, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1487, 2109.648437, -1918.904296, 12.737580, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1487, 2109.984863, -1919.083007, 12.553917, 0.000000, -90.000000, 24.959989, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1487, 2109.587402, -1918.650268, 12.762928, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1664, 2109.944580, -1918.746948, 12.682370, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(365, 2100.268554, -1921.455444, 12.720800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(365, 2100.365234, -1921.236450, 12.576800, -120.000000, 90.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(17969, 2117.504150, -1942.282348, 13.839400, 0.000000, 0.000000, -90.120002, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(810, 2109.652099, -1915.131469, 12.362910, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(810, 2119.989013, -1916.926757, 12.373270, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(692, 2113.276855, -1909.072387, 12.171680, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(692, 2127.665771, -1910.963256, 12.329298, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(692, 2123.582763, -1921.963867, 12.483737, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(692, 2114.796142, -1930.566772, 12.353070, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(692, 2119.227539, -1934.655761, 12.523980, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(810, 2122.632324, -1929.177978, 12.559107, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(692, 2113.766357, -1924.232421, 12.305917, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(760, 2109.787353, -1924.537231, 12.152379, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(760, 2125.013183, -1930.690307, 11.748888, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(760, 2124.304443, -1924.250366, 11.694950, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(760, 2120.458496, -1905.544067, 12.491530, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(760, 2114.148681, -1914.022827, 12.104087, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1617, 2100.133300, -1911.516479, 16.273609, 0.000000, 0.000000, 180.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1664, 2112.326660, -1906.137451, 12.606240, 0.000000, 90.000000, 212.999908, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(2670, 2124.540039, -1904.571777, 12.633790, 0.000000, 0.000000, 23.580009, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1299, 2100.598876, -1923.919433, 12.991100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(5069, 2103.804199, -1931.865722, 13.996700, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(5069, 2098.418212, -1924.119873, 14.500000, 0.000000, 0.000000, 180.000000, -1, -1, -1, 70.00, 70.00);
	CreateDynamicObject(1413, 2136.551269, -1918.596923, 13.622870, 0.000000, 0.000000, 0.000000, -1, -1, -1, 70.00, 70.00);

	// Basura callejón
	CreateDynamicObject(2676, 2137.577880, -1920.541259, 12.677557, 0.000000, 0.000000, -69.839996, -1, -1, -1, 50.00, 50.00);
	CreateDynamicObject(3302, 2138.332275, -1930.862426, 13.477027, 0.000000, -69.000000, 0.000000, -1, -1, -1, 50.00, 50.00);
	CreateDynamicObject(1440, 2135.918945, -1937.735717, 13.172227, 0.000000, 0.000000, 60.540008, -1, -1, -1, 50.00, 50.00);
	CreateDynamicObject(2674, 2135.478027, -1927.934082, 12.563737, 0.000000, 0.000000, 0.000000, -1, -1, -1, 50.00, 50.00);
	CreateDynamicObject(2671, 2136.153320, -1935.331420, 12.547657, 0.000000, 0.000000, 0.000000, -1, -1, -1, 50.00, 50.00);
	CreateDynamicObject(1327, 2136.245361, -1924.453369, 12.533707, 0.000000, 90.000000, 0.000000, -1, -1, -1, 50.00, 50.00);*/
	return true;
}