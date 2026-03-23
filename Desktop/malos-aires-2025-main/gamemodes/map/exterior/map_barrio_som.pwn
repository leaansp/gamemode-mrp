#if defined _map_barrio_som_inc
	#endinput
#endif
#define _map_barrio_som_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid) {

	RemoveBuildingForPlayer(playerid, 3748, 2238.218, -1916.109, 15.187, 0.250);
	RemoveBuildingForPlayer(playerid, 3748, 2261.459, -1916.031, 15.187, 0.250);
	RemoveBuildingForPlayer(playerid, 3748, 2284.702, -1915.875, 15.178, 0.250);
	RemoveBuildingForPlayer(playerid, 3748, 2333.397, -1892.834, 15.250, 0.250);
	RemoveBuildingForPlayer(playerid, 3748, 2333.406, -1933.959, 15.218, 0.250);
	RemoveBuildingForPlayer(playerid, 3628, 2238.218, -1916.109, 15.187, 0.250);
	RemoveBuildingForPlayer(playerid, 712, 2266.195, -1932.953, 21.983, 0.250);
	RemoveBuildingForPlayer(playerid, 3628, 2261.459, -1916.031, 15.187, 0.250);
	RemoveBuildingForPlayer(playerid, 3628, 2284.702, -1915.875, 15.178, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2240.795, -1900.131, 10.803, 0.250);
	RemoveBuildingForPlayer(playerid, 712, 2230.312, -1871.546, 22.413, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2241.616, -1868.578, 10.803, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2265.289, -1900.131, 10.803, 0.250);
	RemoveBuildingForPlayer(playerid, 3628, 2333.406, -1933.959, 15.218, 0.250);
	RemoveBuildingForPlayer(playerid, 712, 2300.968, -1909.553, 21.500, 0.250);
	RemoveBuildingForPlayer(playerid, 3628, 2333.397, -1892.834, 15.250, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2354.937, -1888.241, 10.803, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2357.851, -1917.968, 10.803, 0.250);
	RemoveBuildingForPlayer(playerid, 5111, 2271.360, -1912.380, 14.506, 0.250);
	RemoveBuildingForPlayer(playerid, 5218, 2271.360, -1912.380, 14.506, 0.250);
	RemoveBuildingForPlayer(playerid, 5116, 2361.270, -1918.739, 16.444, 0.250);
	RemoveBuildingForPlayer(playerid, 5222, 2361.270, -1918.739, 16.444, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 2229.100, -1911.810, 11.444, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 2229.100, -1920.290, 11.444, 0.250);

	return true;
}

hook LoadMaps() {

	new tmpobjid;
	tmpobjid = CreateDynamicObject(3651, 2242.364257, -1916.311767, 15.613800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 5520, "bdupshouse_lae", "shingles3", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(3651, 2233.411621, -1916.311767, 15.613800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 5520, "bdupshouse_lae", "shingles3", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(3651, 2256.775878, -1916.311767, 15.613800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 5520, "bdupshouse_lae", "shingles3", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(3651, 2265.598632, -1916.311767, 15.613800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 5520, "bdupshouse_lae", "shingles3", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(3651, 2280.092529, -1916.311767, 15.613800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 5520, "bdupshouse_lae", "shingles3", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(3651, 2288.889404, -1916.311767, 15.613800, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 5520, "bdupshouse_lae", "shingles3", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(3651, 2333.518798, -1889.883911, 15.613800, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 5520, "bdupshouse_lae", "shingles3", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(3651, 2333.518798, -1898.828247, 15.613800, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 5520, "bdupshouse_lae", "shingles3", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(3651, 2333.518798, -1928.583984, 15.613800, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 5520, "bdupshouse_lae", "shingles3", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(3651, 2333.518798, -1937.479125, 15.613800, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 5520, "bdupshouse_lae", "shingles3", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 14668, "711c", "forumstand1_LAe", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2247.760986, -1909.278320, 12.786877, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2237.393554, -1909.278320, 12.776879, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2228.667968, -1909.278320, 12.776879, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	tmpobjid = CreateDynamicObject(5111, 2271.360107, -1912.380004, 14.507800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 1, 4835, "airoads_las", "grassdry_128HV", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 4835, "airoads_las", "grassdry_128HV", 0x00000000);
	tmpobjid = CreateDynamicObject(5116, 2361.270019, -1918.739990, 16.445299, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 2, 4835, "airoads_las", "grassdry_128HV", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2252.053710, -1909.278320, 12.786877, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2260.600341, -1909.278320, 12.786877, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2271.025634, -1909.278320, 12.786877, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2275.337646, -1909.278320, 12.786877, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2294.269042, -1909.278320, 12.786877, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2283.924316, -1909.278320, 12.786877, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2328.602050, -1884.538574, 12.786877, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2328.602050, -1894.870971, 12.786877, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2328.602050, -1903.542114, 12.786877, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2328.602050, -1923.253173, 12.786877, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2328.602050, -1933.475585, 12.786877, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	tmpobjid = CreateDynamicObject(19456, 2328.602050, -1942.188476, 12.786877, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12855, "cunte_cop", "sw_brick05", 0x00000000);
	tmpobjid = CreateDynamicObject(5111, 2271.360107, -1912.380004, 14.507800, 0.000000, 0.000000, 0.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 6, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 7, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 8, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 9, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 11, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 12, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 13, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 15, 2538, "cj_ss_2", "CJ_milk", 0x00000000);
	tmpobjid = CreateDynamicObject(5116, 2361.270019, -1918.739990, 16.445299, 0.000000, 0.000000, 0.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 6, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 7, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 8, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 9, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 10, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 11, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 12, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 13, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 14, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 15, 2538, "cj_ss_2", "CJ_milk", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 2326.826171, -1884.918212, 12.492553, 0.000000, 90.000000, 0.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 15, 2538, "cj_ss_2", "CJ_milk", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 2334.347412, -1884.918212, 12.492553, 0.000000, 90.000000, 0.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 15, 2538, "cj_ss_2", "CJ_milk", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 2339.456787, -1884.918212, 12.492553, 0.000000, 90.000000, 0.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 15, 2538, "cj_ss_2", "CJ_milk", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 2328.552001, -1928.438964, 12.482793, 0.000000, 90.000000, 90.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 15, 2538, "cj_ss_2", "CJ_milk", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 2338.141601, -1928.168701, 12.482793, 0.000000, 90.000000, 90.000000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0); 
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "mirror01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 15, 2538, "cj_ss_2", "CJ_milk", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(673, 2240.077148, -1899.959838, 12.531390, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2264.460937, -1899.927490, 12.531390, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2300.975830, -1909.402099, 11.445308, 356.858398, 0.000000, 3.141590, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2265.953125, -1932.689697, 11.445308, 356.858398, 0.000000, 3.141590, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2240.849365, -1868.541625, 12.531390, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2230.790283, -1871.148437, 12.531390, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2354.194580, -1888.258056, 11.445308, 356.858398, 0.000000, 3.141590, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2357.103515, -1918.155639, 11.445308, 356.858398, 0.000000, 3.141590, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19865, 2245.147460, -1904.484008, 12.546875, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19865, 2231.191406, -1904.484008, 12.546875, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19865, 2238.206787, -1904.443969, 12.546875, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19865, 2254.640380, -1904.484008, 12.546875, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19865, 2268.437011, -1904.443969, 12.546875, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19865, 2261.460937, -1904.443969, 12.546875, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19865, 2277.907714, -1904.443969, 12.546875, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19865, 2291.692138, -1904.443969, 12.546875, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19865, 2284.787109, -1904.443969, 12.546875, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2228.019042, -1911.810058, 11.445300, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(673, 2227.688720, -1920.290039, 11.445300, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19865, 2323.752929, -1900.973022, 12.546875, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19865, 2323.752929, -1887.129760, 12.546875, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19865, 2323.752929, -1894.051513, 12.546875, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19865, 2323.752929, -1925.780395, 12.546875, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19865, 2323.752929, -1939.721679, 12.546875, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
	tmpobjid = CreateDynamicObject(19865, 2323.752929, -1932.710571, 12.546875, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 


	return true;
}