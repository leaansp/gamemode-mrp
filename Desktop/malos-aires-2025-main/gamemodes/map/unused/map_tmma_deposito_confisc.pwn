#if defined _map_tmma_deposito_confisc_inc
	#endinput
#endif
#define _map_tmma_deposito_confisc_inc

#include <YSI_Coding\y_hooks>

hook RemoveMapsBuildings(playerid) {
	//=====================DEPÓSITO DE CONFISCADOS TALLER=======================
    RemoveBuildingForPlayer(playerid, 3709, 2544.2500, -2524.0938, 16.4453, 0.25);
    RemoveBuildingForPlayer(playerid, 3709, 2544.2500, -2548.8125, 16.7031, 0.25);
    RemoveBuildingForPlayer(playerid, 3746, 2563.1563, -2563.5781, 25.5156, 0.25);
    RemoveBuildingForPlayer(playerid, 3578, 2526.4297, -2561.3047, 13.1719, 0.25);
    RemoveBuildingForPlayer(playerid, 3623, 2544.2500, -2548.8125, 16.7031, 0.25);
    RemoveBuildingForPlayer(playerid, 3623, 2544.2500, -2524.0938, 16.4453, 0.25);
    RemoveBuildingForPlayer(playerid, 3620, 2563.1563, -2563.5781, 25.5156, 0.25);

	return true;
}

hook LoadMaps() {
	// ======= Depósito de confiscados =======
    CreateDynamicObject(19456, 2561.51758, -2563.50732, 13.80950,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19456, 2561.51758, -2554.12720, 13.80950,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19456, 2561.51758, -2544.50708, 13.80950,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19456, 2561.51758, -2534.88721, 13.80950,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19456, 2561.51758, -2525.26709, 13.80950,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19364, 2561.51758, -2518.85181, 13.80950,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19364, 2561.51758, -2515.65161, 13.80950,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19456, 2556.59766, -2514.13525, 13.80950,   0.00000, 0.00000, 90.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19364, 2537.99731, -2514.13525, 13.80950,   0.00000, 0.00000, 90.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19456, 2531.49756, -2514.13525, 13.80950,   0.00000, 0.00000, 90.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19364, 2526.60962, -2515.65161, 13.80950,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19364, 2526.60962, -2518.85156, 13.80950,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19456, 2526.60962, -2525.26709, 13.80950,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19456, 2526.60962, -2534.88721, 13.80950,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19456, 2526.60962, -2544.50708, 13.80950,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19456, 2526.60962, -2554.12720, 13.80950,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19456, 2526.60962, -2563.50732, 13.80950,   0.00000, 0.00000, 0.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19456, 2556.78760, -2568.23511, 13.80950,   0.00000, 0.00000, 90.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19456, 2547.16748, -2568.23511, 13.80950,   0.00000, 0.00000, 90.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19456, 2537.54761, -2568.23511, 13.80950,   0.00000, 0.00000, 90.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19364, 2531.12769, -2568.23511, 13.80950,   0.00000, 0.00000, 90.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19364, 2528.12769, -2568.23511, 13.80950,   0.00000, 0.00000, 90.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(19364, 2548.57764, -2514.13525, 13.80950,   0.00000, 0.00000, 90.00000, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = -1.0, .drawdistance = 350.0);
    CreateDynamicObject(3626, 2555.69629, -2516.95874, 13.59970,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19437, 2550.97754, -2514.13525, 13.80950,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(2008, 2556.87988, -2516.35254, 12.38210,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(3627, 2534.92773, -2536.80273, 15.41230,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(3627, 2553.17383, -2547.07617, 15.41230,   0.00000, 0.00000, 180.00000);
    CreateDynamicObject(3627, 2534.92773, -2547.07617, 15.41230,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1663, 2558.06470, -2515.59790, 12.84280,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(2000, 2559.48560, -2517.89331, 12.38080,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(2000, 2559.48560, -2517.31323, 12.38080,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(2000, 2559.48560, -2516.75317, 12.38080,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(2000, 2559.48560, -2516.19312, 12.38080,   0.00000, 0.00000, -90.00000);	

	return true;
}

hook OnGameModeInitEnded() {
    new gateid;

    gateid = Gate_Create(976,
				2539.61060, -2514.25854, 12.66460, 0.00000, 0.00000, 0.00000,
				2547.1106, -2514.2385, 12.6646, 0.00000, 0.00000, 0.00000,
				.worldid = -1, .speed = 1.8, .type = GATE_TYPE_BUSINESS, .extraid = 84, .autoCloseTime = 6500, .staticObject = true);

    Gate_SetOnFootFrontDetection(gateid, 2539.0400, -2514.0300, 14.3000, 0.0000, 0.0000, 0.0000, .labelText = "Portón");
    Gate_SetOnFootBackDetection(gateid, 2539.0400, -2514.2500, 14.3000, 0.0000, 0.0000, 180.0000, .labelText = "Portón");
    Gate_SetVehicleDetection(gateid, 2543.12, -2513.85, 14, .size = 8.0);

    Gate_SetTexture(gateid, 0, 2660, "cj_banner", "CJ_MERC_LOGO");
    return true;
}