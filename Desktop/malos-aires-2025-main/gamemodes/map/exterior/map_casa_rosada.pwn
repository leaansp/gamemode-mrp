#if defined _map_ext_casa_rosada_inc
	#endinput
#endif
#define _map_ext_casa_rosada_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid) {
	RemoveBuildingForPlayer(playerid, 4024, 1479.8672, -1790.3984, 56.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 4044, 1481.1875, -1785.0703, 22.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 713, 1407.1953, -1749.3125, 13.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 713, 1405.2344, -1821.1172, 13.1016, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1417.9766, -1832.5313, 11.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1405.5781, -1831.6953, 12.3984, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 1447.1016, -1832.5000, 12.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 4174, 1435.7656, -1823.6641, 15.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1456.3984, -1832.5313, 11.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1464.0938, -1831.8828, 12.3984, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1504.8438, -1832.5313, 11.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1499.0469, -1832.2734, 12.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 1512.9453, -1832.3516, 13.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 1404.9141, -1765.2656, 12.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 4173, 1427.2734, -1756.1797, 15.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1415.3125, -1748.5625, 12.3984, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1429.5313, -1748.4219, 12.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 1438.0313, -1747.9375, 13.4453, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1447.9063, -1748.2266, 12.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 4002, 1479.8672, -1790.3984, 56.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 3980, 1481.1875, -1785.0703, 22.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 4003, 1481.0781, -1747.0313, 33.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1516.0000, -1748.6016, 13.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1549.5313, -1832.3125, 12.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1555.6641, -1830.5938, 13.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 4175, 1524.4141, -1823.8516, 15.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 1554.8203, -1816.1563, 13.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1553.2578, -1764.8125, 12.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 4172, 1534.7656, -1756.1797, 15.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1533.2656, -1749.0234, 12.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1522.1641, -1748.5703, 13.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 1553.7031, -1747.9375, 13.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 1527, 1448.2344, -1755.8984, 14.5234, 0.25);
	return true;
}

hook LoadMaps() {
	Textura = CreateDynamicObject(9950, 1480.869628, -1785.487060, 24.549810, 0.000000, 0.000000, -90.0, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 550.0);
	SetDynamicObjectMaterial(Textura, 1, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 2, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 3, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 4, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 5, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 6, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 7, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 8, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 9, -1, "none", "none", 0xFFEA8F9F);
	Textura = CreateDynamicObject(10049, 1480.703979, -1795.078857, 26.831319, 0.000000, 0.000000, -90.0, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 550.0);
	SetDynamicObjectMaterial(Textura, 0, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 1, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 2, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 3, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 4, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 5, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 6, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 7, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 8, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 9, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 10, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 11, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 12, -1, "none", "none", 0xFF4C845F);
	SetDynamicObjectMaterial(Textura, 13, -1, "none", "none", 0xFFEA8F9F);
	SetDynamicObjectMaterial(Textura, 14, -1, "none", "none", 0xFFEA8F9F);

	Textura = CreateDynamicObject(19456, 1554.656738, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1545.048461, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1535.427001, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1525.818359, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1516.209228, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1506.708251, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1497.207885, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1461.408935, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1451.833251, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1442.253540, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1432.659179, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1423.093139, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1413.642578, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1404.058105, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19364, 1490.832519, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19364, 1467.799194, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19364, 1470.883056, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1472.607299, -1747.140502, 14.21570, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1489.311035, -1747.205322, 14.21570, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1413.642578, -1742.387207, 14.21570, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(18765, 1480.981567, -1767.280395, 10.097100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 8391, "ballys01", "ws_floortiles4");
	Textura = CreateDynamicObject(18765, 1480.981567, -1757.280395, 10.097100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 8391, "ballys01", "ws_floortiles4");
	Textura = CreateDynamicObject(18765, 1480.981567, -1747.280395, 10.097100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 8391, "ballys01", "ws_floortiles4");
	Textura = CreateDynamicObject(18765, 1480.981567, -1777.280395, 10.097100, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 8391, "ballys01", "ws_floortiles4");

	Textura = CreateDynamicObject(2952, 1478.28821, -1815.02845, 12.54500,   0.00000, 0.00000, 90.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 5704, "melrose07_lawn", "hotdoor01_law", 0xFFEA8F9F);
	Textura = CreateDynamicObject(2952, 1480.41748, -1815.02845, 12.54500,   0.00000, 0.00000, 90.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 5704, "melrose07_lawn", "hotdoor01_law", 0xFFEA8F9F);

	Textura = CreateDynamicObject(18981, 1411.62903, -1835.79602, 4.87690,   0.00000, 0.00000, 90.09980, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	Textura = CreateDynamicObject(18981, 1423.07898, -1835.77942, 4.87590,   0.00000, 0.00000, 90.09980, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	Textura = CreateDynamicObject(18981, 1447.46729, -1835.73547, 4.87690,   0.00000, 0.00000, 90.09980, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	Textura = CreateDynamicObject(18981, 1472.25757, -1835.69226, 4.87690,   0.00000, 0.00000, 90.09980, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	Textura = CreateDynamicObject(18981, 1497.15771, -1835.64868, 4.87690,   0.00000, 0.00000, 90.09980, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	Textura = CreateDynamicObject(18981, 1522.14709, -1835.60535, 4.87690,   0.00000, 0.00000, 90.11980, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	Textura = CreateDynamicObject(18981, 1547.05396, -1835.56897, 4.87690,   0.00000, 0.00000, 90.05980, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	
	CreateDynamicObject(700, 1446.601440, -1747.912719, 13.726599, 356.858398, 0.000000, 3.141599, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1433.350097, -1747.912719, 13.726599, 356.858398, 0.000000, 3.141599, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1418.842041, -1747.912719, 13.726599, 356.858398, 0.000000, 3.141599, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1405.953125, -1747.912719, 13.726599, 356.858398, 0.000000, 3.141599, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1405.953125, -1762.365600, 13.726599, 356.858398, 0.000000, 3.141599, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1515.542114, -1747.871093, 13.726599, 356.858398, 0.000000, 3.141599, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1527.085571, -1747.871093, 13.726599, 356.858398, 0.000000, 3.141599, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1539.617675, -1747.871093, 13.726599, 356.858398, 0.000000, 3.141599, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1551.726074, -1747.871093, 13.726599, 356.858398, 0.000000, 3.141599, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1551.726074, -1763.335449, 13.726599, 356.858398, 0.000000, 3.141599, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1553.752441, -1816.502319, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1553.752441, -1832.373168, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1553.752441, -1824.242065, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1542.331665, -1832.373168, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1548.090942, -1832.373168, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1514.111816, -1832.193481, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1493.621582, -1832.193481, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1503.791381, -1832.193481, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1465.130737, -1832.193481, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1445.031005, -1832.193481, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1455.230346, -1832.193481, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1419.939941, -1832.193481, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1413.109863, -1832.193481, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1405.799682, -1832.193481, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1405.799682, -1822.533081, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(700, 1405.799682, -1813.983398, 12.546875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(19279, 1495.958251, -1769.282714, 12.707577, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.0, 300.0);
	CreateDynamicObject(19279, 1466.486328, -1769.339355, 12.707577, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.0, 300.0);

	Textura = CreateDynamicObject(19456, 1559.52368, -1747.11365, 14.21570,   0.00000, 0.00000, 0.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1559.52368, -1756.75049, 14.21570,   0.00000, 0.00000, 0.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1559.52368, -1766.38416, 14.21570,   0.00000, 0.00000, 0.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1559.52368, -1776.01526, 14.21570,   0.00000, 0.00000, 0.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1559.52368, -1785.64905, 14.21570,   0.00000, 0.00000, 0.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1559.52368, -1795.28296, 14.21570,   0.00000, 0.00000, 0.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);

	Textura = CreateDynamicObject(18981, 1546.03174, -1800.59106, 4.87690,   0.00000, 0.00000, 90.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	Textura = CreateDynamicObject(18980, 1559.02844, -1800.59106, 4.87690,   0.00000, 0.00000, 0.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	Textura = CreateDynamicObject(18766, 1559.03406, -1811.29700, 14.87650,   0.00000, 0.00000, 90.07500, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	Textura = CreateDynamicObject(18766, 1559.04895, -1821.05542, 14.87650,   0.00000, 0.00000, 90.07500, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	Textura = CreateDynamicObject(18766, 1559.04895, -1831.05554, 14.87650,   0.00000, 0.00000, 90.07500, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");

	Textura = CreateDynamicObject(18766, 1399.62695, -1831.31494, 14.87650,   0.00000, 0.00000, 90.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	Textura = CreateDynamicObject(18766, 1399.62708, -1821.31604, 14.87650,   0.00000, 0.00000, 90.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	Textura = CreateDynamicObject(18766, 1399.62708, -1811.31995, 14.87650,   0.00000, 0.00000, 90.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	Textura = CreateDynamicObject(18980, 1399.62695, -1800.61694, 4.87690,   0.00000, 0.00000, 0.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	Textura = CreateDynamicObject(18766, 1405.12500, -1800.61694, 14.87650,   0.00000, 0.00000, 0.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");
	Textura = CreateDynamicObject(18981, 1422.62305, -1800.61694, 4.87690,   0.00000, 0.00000, 90.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 17508, "barrio1_lae2", "brickred");

	Textura = CreateDynamicObject(19456, 1399.16321, -1795.29602, 14.21570,   0.00000, 0.00000, 0.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1399.16321, -1785.66199, 14.21570,   0.00000, 0.00000, 0.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1399.16321, -1776.02795, 14.21570,   0.00000, 0.00000, 0.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1399.16321, -1766.39404, 14.21570,   0.00000, 0.00000, 0.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1399.16321, -1756.76050, 14.21570,   0.00000, 0.00000, 0.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);
	Textura = CreateDynamicObject(19456, 1399.16321, -1747.12695, 14.21570,   0.00000, 0.00000, 0.00000, -1, -1, -1, 300.0, 300.0);
	SetDynamicObjectMaterial(Textura, 0, 3646, "ganghouse1_lax", "grille1_LA", 0xFF1F1F1F);

	return true;
}

hook OnGameModeInitEnded() {
    new gateid, asociategate;

	/*Porton 1 de la rosasda*/
	gateid = Gate_Create(13188, 
	 			1559.48022, -1802.39620, 14.96180, 90.00000, 180.00000, 0.00000,
				1558.22156, -1801.14600, 14.96180, 90.00000, 180.00000, -90.00000,
				.worldid = -1, .speed = 0.5, .type = GATE_TYPE_FACTION, .extraid = FAC_GOB, .autoCloseTime = 6000);
	
	Gate_SetVehicleDetection(gateid, 1557.3138, -1805.4809, 13.3642, .size = 10.0);
	Gate_SetTexture(gateid, 0, 9239, "stuff2_sfn", "ws_corrugateddoor1");

	asociategate = Gate_Create(13188,
				1559.48022, -1804.99850, 14.96180, 90.00000, 180.00000, 0.00000,
				1558.22900, -1806.24410, 14.96180, 90.00000, 180.00000, 90.00000,
				.worldid = -1, .speed = 0.5, .type = GATE_TYPE_FACTION, .extraid = FAC_GOB, .autoCloseTime = 6000);

	Gate_SetTexture(asociategate, 0, 9239, "stuff2_sfn", "ws_corrugateddoor1");
	Gate_AssociateToGate(gateid, asociategate);

	/*Porton 2 de la rosasda*/
	gateid = Gate_Create(13188, 
	 			1399.17395, -1805.01599, 14.96180, 90.00000, 180.00000, 180.00000,
				1400.43896, -1806.26501, 14.96180, 90.00000, 180.00000, 90.00000,
				.worldid = -1, .speed = 0.5, .type = GATE_TYPE_FACTION, .extraid = FAC_GOB, .autoCloseTime = 6000);
	
	Gate_SetVehicleDetection(gateid, 1401.2051, -1805.6283, 13.3642, .size = 10.0);
	Gate_SetTexture(gateid, 0, 9239, "stuff2_sfn", "ws_corrugateddoor1");

	asociategate = Gate_Create(13188,
				1399.17395, -1802.41394, 14.96180, 90.00000, 180.00000, 180.00000,
				1400.43896, -1801.17200, 14.96180, 90.00000, 180.00000, 270.00000,
				.worldid = -1, .speed = 0.5, .type = GATE_TYPE_FACTION, .extraid = FAC_GOB, .autoCloseTime = 6000);

	Gate_SetTexture(asociategate, 0, 9239, "stuff2_sfn", "ws_corrugateddoor1");
	Gate_AssociateToGate(gateid, asociategate);

	return true;
}