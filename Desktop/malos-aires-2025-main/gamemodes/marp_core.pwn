/*
 				ooo        ooooo           oooo                                               
				`88.       .888'           `888                                               
				 888b     d'888   .oooo.    888   .ooooo.   .oooo.o                           
				 8 Y88. .P  888  `P  )88b   888  d88' `88b d88(  "8                           
				 8  `888'   888   .oP"888   888  888   888 `"Y88b.                            
				 8    Y     888  d8(  888   888  888   888 o.  )88b                           
				o8o        o888o `Y888""8o o888o `Y8bod8P' 8""888P'                           
				      .o.        o8o                                                          
				     .888.       `"'                                                          
				    .8"888.     oooo  oooo d8b  .ooooo.   .oooo.o                             
				   .8' `888.    `888  `888""8P d88' `88b d88(  "8                             
				  .88ooo8888.    888   888     888ooo888 `"Y88b.                              
				 .8'     `888.   888   888     888    .o o.  )88b                             
				o88o     o8888o o888o d888b    `Y8bod8P' 8""888P'                             
      ooooooooo.             oooo                       oooo                        
	  `888   `Y88.           `888                       `888                        
	   888   .d88'  .ooooo.   888   .ooooo.  oo.ooooo.   888   .oooo.   oooo    ooo 
	   888ooo88P'  d88' `88b  888  d88' `88b  888' `88b  888  `P  )88b   `88.  .8'  
	   888`88b.    888   888  888  888ooo888  888   888  888   .oP"888    `88..8'   
	   888  `88b.  888   888  888  888    .o  888   888  888  d8(  888     `888'    
	  o888o  o888o `Y8bod8P' o888o `Y8bod8P'  888bod8P' o888o `Y888""8o     .8'     
	                                          888                       .o..P'      
	                                         o888o                      `Y8P'


 ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ 
|______|______|______|______|______|______|______|______|______|______|______|______|


			  ________     ____                       _       _     _           
			/ / ___\ \   / ___|___  _ __  _   _ _ __(_) __ _| |__ | |_         
		   | | |    | | | |   / _ \| '_ \| | | | '__| |/ _` | '_ \| __|        
		   | | |___ | | | |__| (_) | |_) | |_| | |  | | (_| | | | | |_         
		   | |\____|| |  \____\___/| .__/ \__, |_|  |_|\__, |_| |_|\__|        
			\_\    /_/             |_|    |___/        |___/                   
				  ____   ___  _  ___       ____   ___ ____   ____                     
				 |___ \ / _ \/ |/ _ \     |___ \ / _ \___ \ |  __|             
				   __) | | | | | | | |_____ __) | | | |__) || |__          
				  / __/| |_| | | |_| |_____/ __/| |_| / __/| \__ |     
				 |_____|\___/|_|\___/     |_____|\___/_____|/____|              
								  _                                                                  
								 | |__  _   _                                                        
								 | '_ \| | | |                                                       
								 | |_) | |_| |                                                       
								 |_.__/ \__, |                                                                                                         
						  ____  _       |___/   _                                            
						 |  _ \| |__   ___  ___| | __                                        
						 | |_) | '_ \ / _ \/ _ \ |/ /                                        
						 |  __/| | | |  __/  __/   <                                         
						 |_|   |_| |_|\___|\___|_|\_|                                        
					   ____                 _                                            
					  / ___| __ _ _ __ ___ (_)_ __   __ _                                
					 | |  _ / _` | '_ ` _ \| | '_ \ / _` |                               
					 | |_| | (_| | | | | | | | | | | (_| |                               
					  \____|\__,_|_| |_| |_|_|_| |_|\__, |                           
		 _          _   _                           |___/__      _           
		| |    __ _| |_(_)_ __   ___   __ _ _ __ ___   _/_/ _ __(_) ___ __ _ 
		| |   / _` | __| | '_ \ / _ \ / _` | '_ ` _ \ / _ \ '__| |/ __/ _` |
		| |__| (_| | |_| | | | | (_) | (_| | | | | | |  __/ |  | | (_| (_| |
		|_____\__,_|\__|_|_| |_|\___/ \__,_|_| |_| |_|\___|_|  |_|\___\__,_|

*/

/*******************************************************************************
********************************************************************************
***********************                                 ************************
*********************    MALOS AIRES ROLEPLAY GAMEMODE    **********************
**********										 			         ***********
********    (C) Copyright 2010 - 2025 by Pheek Gaming Latinoamérica    *********
**********                                            				 ***********
***********************    @Do not remove this label    ************************
***********************    @No remueva esta etiqueta    ************************
*************************                             **************************
********************************************************************************
*******************************************************************************/

#pragma warning disable 214 // warning 214: possibly a "const" array argument was intended: "array_name". Solo con pawncc ^3.10.4
#pragma warning disable 239 // warning 239: literal array/string passed to a non-const parameter. Solo con pawncc ^3.10.4

#define MAX_PLAYERS (200)

#include <a_samp>
#include <a_mysql>
#include <sscanf2>
//#include <Rogue-AC>

#define YSI_NO_VERSION_CHECK
#define YSI_NO_CACHE_MESSAGE
#define YSI_NO_MODE_CACHE
#define CGEN_MEMORY (80000) // Requerido por librería YSI para reservar mayor tamaño de memoria para su código

#define FOREACH_NO_LOCALS
#define FOREACH_NO_ACTORS
#define FOREACH_NO_BOTS

#include <PawnPlus>
#include <YSI_Data\y_iterate> // provides foreach
#include <zcmd>
#include <streamer>
#include <Dini>
#include <cstl>
#include <anti_flood>
#include <easyDialog>
#include <progress2>
#include "util/marp_util.pwn" // Siempre arriba del resto de los includes de marp

// Forwards used across modules before definitions
forward IsPlayerMuted(playerid);
forward PP_main();
forward Indirection_OnGameModeInit();
forward isPlayerCopOnDuty(playerid);
forward isPlayerSideOnDuty(playerid);
forward OnPlayerCharSwitch(playerid);

// Declared here so included files can reference them
new gPlayerLogged[MAX_PLAYERS];
new pLoginTransitionTimer[MAX_PLAYERS];

#define HP_GAIN           		2         	                                	// Vida que ganas por segundo al estar hospitalizado.
#define GAS_UPDATE_TIME         36000                                           // Tiempo de actualizacion de la gasolina.
#define MAX_LOGIN_ATTEMPTS      5
#define INTERIOR_EXIT_FREEZE_MS  1000                                            // Congela brevemente al salir de interiores para que cargue el mapeo.

// Posiciones.
#define POS_BANK_X              1479.6465
#define POS_BANK_Y              -1134.2802
#define POS_BANK_Z              1015.4130
#define POS_BANK_I              1
#define POS_BANK_W              1002

#define POS_SPAWN_X				1742.97
#define POS_SPAWN_Y				-1860.21
#define POS_SPAWN_Z				13.57
#define POS_SPAWN_A				0.0
#define POS_SPAWN_WORLD			0
#define POS_SPAWN_INTERIOR		0
/* #define POS_SPAWN_X				-12.21
#define POS_SPAWN_Y				3199.52
#define POS_SPAWN_Z				2412.72
#define POS_SPAWN_A				270.56
#define POS_SPAWN_WORLD			0
#define POS_SPAWN_INTERIOR		1032 */



// Tiempos de jail.
#define DM_JAILTIME 			300 	// 5 minutos



// Precios.
#define PRICE_FIGHTSTYLE        25000
#define PRICE_TREATMENT         800

// ==================== CÁMARAS DE LOGIN ====================
enum e_LoginCamera
{
	Float:lc_x,
	Float:lc_y,
	Float:lc_z,
	Float:lc_look_x,
	Float:lc_look_y,
	Float:lc_look_z
};

new const g_LoginCameras[][e_LoginCamera] = {
	{1465.33, -1679.53, 60.26, 1475.0, -1700.0, 40.0},
	{1301.97, -1669.21, 44.84, 1350.0, -1650.0, 30.0},
	{1481.68, -933.69, 108.24, 1450.0, -900.0, 80.0},
	{2099.01, -1872.44, 30.16, 2050.0, -1850.0, 25.0},
	{1935.37, -1531.96, 24.54, 1950.0, -1500.0, 20.0}
};

#define MAX_LOGIN_CAMERAS (sizeof(g_LoginCameras))

new Float:Server_BizTaxPercent = 0.0018;
new Float:Server_VehTaxPercent = 0.0018; // 0,18%
new socialPay;


#include "util\marp_zones.pwn"              	//Informacion de las diferentes zonas y barrios
#include "util\marp_fade_screen.pwn"
#include "system/marp_previewmodelmenu.pwn"
#include "marp_database.pwn" 					//Funciones varias para acceso a datos
#include "util/marp_commands_list.pwn"
#include "system\streamer\marp_streamer_handling.pwn"
#include "system\streamer\marp_dyn_obj_handling.pwn"
#include "system\marp_button.pwn"
#include "player/marp_accounts.pwn"
#include "player/marp_players.pwn" 				//Contiene definiciones y lógica de negocio para todo lo que involucre a los jugadores (Debe ser incluido antes de cualquier include que dependa de playerInfo)
#include "system\marp_shutdown.pwn"
#include "system\marp_server_logs.pwn"
// #include "system/marp_login_screen.pwn" // disabled: login screen removed by request
#include "system/marp_login_camera.pwn"
#include "system/marp_logo.pwn"
#include "player/marp_toggle.pwn"
#include "system\notification\marp_noti.pwn"
#include "system\marp_cmd_cooldown.pwn"
#include "system\damage\marp_damage.pwn"
#include "item\marp_item.pwn"
#include "item\marp_item_admin.pwn"
#include "item\marp_aiming_camera_fix.pwn"
#include "player/marp_hidden_name.pwn"
#include "system\marp_teleport.pwn"
#include "container/marp_container.pwn"
#include "util/marp_streamings.pwn"
#include "player/marp_mano.pwn" 				//Sistema de items en la mano
#include "system\phone\marp_phone_core.pwn"
#include "system\phone\marp_phone_call.pwn"
#include "system\phone\marp_phone_contacts.pwn"
#include "system\phone\marp_phone_sms.pwn"
#include "system\phone\marp_phone_gui.pwn"
#include "item\marp_toy.pwn" 					//Sistema de toys
#include "system\marp_key_chain.pwn" 			//Sistema de llaveros
#include "player/marp_inventory.pwn" 			//Sistema de inventario
#include "system/marp_hotkeys.pwn"				//Sistema de teclas rapidas
#include "player/marp_holster.pwn"				//Sistema de funda de cadera (/cadera)
#include "player/marp_duty_belt.pwn"
#include "vehicle/marp_vehicles.pwn" 			//Sistema de vehiculos
#include "vehicle/marp_speedo.pwn"
#include "system\marp_gate.pwn"
#include "business\marp_biz.pwn" 			//Sistema de negocios
#include "map/marp_interiors_list.pwn"
#include "house/marp_houses.pwn" 				//Sistema de casas
#include "building/marp_buildings.pwn"          //Sistema de edificios
#include "faction/marp_factions.pwn" 			//Sistema de facciones
#include "system\marp_mapro.pwn"
#include "job/marp_jobs.pwn" 					//Definiciones y funciones para los JOBS
#include "player\marp_player_guide.pwn"
#include "house\marp_armarios.pwn" 				//Sistema de armarios en las casas
#include "job/marp_thiefjob.pwn"
#include "util/marp_animations.pwn" 			//Sistema de animaciones
#include "system/marp_licenses.pwn"
#include "vehicle/marp_sprintrace.pwn"			//Sistema de picadas (carreras)
//#include "faction\marp_gangzones.pwn"  					//Sistema de control de barrios
#include "map/marp_maps.pwn"  					//Mapeos del GM
#include "player/marp_saludocoordinado.pwn" 	//Sistema de saludo coordinado
#include "player/marp_descripcionyo.pwn" 		//Sistema de descripción /yo.
#include "player/marp_chat.pwn"

#include "item/marp_maletin.pwn" 				//sistema maletin
#include "item/marp_objects.pwn"            	//Sistema de objetos en el suelo
#include "job/marp_robobanco.pwn"          		//Robo a banco.
#include "job/marp_carthief.pwn"           		//Robo de autos.
#include "system\marp_gas_station.pwn"
#include "vehicle/marp_racesystem.pwn"          //Sistema de carreras
#include "player\marp_back.pwn"      	//Sistema de espalda/guardado de armas largas
#include "item/marp_backpack.pwn"				//Sistema de mochilas (contenedores portátiles)
#include "system/marp_afk.pwn"          		//Sistema de AFK
#include "system/marp_cmdpermissions.pwn"     	//Permisos dinámicos para comandos
#include "vehicle/marp_concesionaria.pwn"		
#include "job/marp_garbjob.pwn"
#include "job/marp_tranjob.pwn"
#include "job/marp_farmjob.pwn"
#include "job/marp_drugfjob.pwn"
#include "job/marp_delijob.pwn"
#include "job/marp_taxijob.pwn"
#include "job\marp_busjob.pwn"
#include "job/ewires.pwn"
#include "util/marp_cronometro.pwn"   
#include "system/marp_rolepoints.pwn"
#include "system/marp_elogios.pwn"			//Sistema de elogios
#include "system\marp_warnings.pwn"
#include "system\marp_football.pwn"
#include "system/marp_time_and_weather.pwn"
#include "faction/marp_same.pwn"
#include "system/marp_lifts.pwn"
#include "util/marp_actors.pwn"
#include "item/marp_parlantes.pwn"
#include "admin/marp_acmds.pwn"
#include "admin/marp_acmds_help.pwn"
#include "admin/marp_dudas_reportes.pwn"
#include "admin/marp_debug.pwn"
#include "admin/marp_admin_spectate.pwn"
#include "faction/marp_police.pwn"
#include "faction\equipment\marp_equipment.pwn"
#include "faction/marp_gob.pwn"
#include "faction/marp_gen.pwn"
#include "faction/marp_ctr.pwn"
#include "faction/marp_grafitis.pwn"
#include "player/marp_pcmds.pwn"
#include "system/money/marp_money.pwn"
#include "system/money/marp_money_bars.pwn"
#include "system/money/marp_atm_gui.pwn"
#include "system/phone/marp_phone.pwn"
#include "system/marp_player_creation.pwn"
#include "system/marp_scenes.pwn"
#include "player\marp_player_update.pwn"
#include "player\marp_player_anticheat.pwn"
#include "player\marp_player_save_account.pwn"
#include "player\marp_player_basic_needs.pwn"
#include "player\marp_player_jail.pwn"
#include "vehicle/marp_police_deposit.pwn"
#include "house/marp_plantation.pwn"
#include "player/marp_player_drugs.pwn" 
#include "faction/traffic/marp_traffic.pwn"
#include "business/marp_biz_thief.pwn"
#include "system/marp_black_market.pwn"
#include "system/marp_map_marker.pwn"
#include "system\furniture\marp_furniture.pwn"
#include "system\marp_grenade_effect.pwn"
#include "system\marp_blackjack.pwn"
#include "player\marp_player_payday.pwn"
#include "system\marp_paynspray.pwn"
#include "system\tuning\marp_tuning_gui.pwn"
#include "garage\marp_garages.pwn"
#include "system/marp_firstlogin_test.pwn"
#include "player/marp_cambiarpersonaje.pwn"
#include "system/marp_multichar.pwn"
// #include "system/marp_login_audio.pwn" // Deshabilitado: solo diálogos
#include "job/marp_elecjob.pwn"
#include "system/marp_dynamic_economy.pwn" //Economia dinamica
#include "system/marp_anticbug.pwn"
#include "system/marp_anticheat_core.pwn"
#include "system/marp_asador.pwn"				//Sistema de asador (choripanes)
#include "system/marp_vehicle_wear.pwn"		//Desgaste de vehiculos
#include "system/marp_twitter.pwn"			//Sistema de Twitter


new timersID[24];



new	LastDeath[MAX_PLAYERS],
	DeathSpam[MAX_PLAYERS char];

IsPlayerMuted(playerid) {
	return Muted[playerid];
}

new
	P_BANK,
	P_FIGHT_STYLE,
	P_HOSP_HEAL,
	P_HOSP_HEAL_2,
	P_LICENSE_CENTER,
	P_POLICE_ARREST,
	P_POLICE_ARREST2,
	P_JAIL_EAT,
	P_GEN_EAT,
	P_CAR_RENT1,
	P_CAR_RENT2,
	P_CAR_RENT3,
	P_DRUGFARM_MATS,
	P_CAR_DEMOLITION,
	P_CARPART_SHOP,
	P_POLICE_CAMERAS;

new successStart = 0;






static const Float:gStartPositions[][6] =
{
    {-0.48, 3212.90, 2412.72, 178.53, 0.0, 1032.0},
    {-0.07, 3185.73, 2412.72, 12.49, 0.0, 1032.0},
    {-13.79, 3180.46, 2412.72, 260.94, 0.0, 1032.0},
    {-13.74, 3182.98, 2412.72, 282.56, 0.0, 1032.0},
    {-13.94, 3185.50, 2412.72, 282.56, 0.0, 1032.0},
    {-13.62, 3188.11, 2412.72, 262.19, 0.0, 1032.0},
    {-14.51, 3197.93, 2412.72, 266.26, 0.0, 1032.0},
    {-14.04, 3200.67, 2412.72, 266.26, 0.0, 1032.0},
    {-13.69, 3202.95, 2412.72, 266.26, 0.0, 1032.0},
    {-12.37, 3206.34, 2412.72, 266.26, 0.0, 1032.0},
    {-14.63, 3213.54, 2412.72, 259.37, 0.0, 1032.0},
    {-13.77, 3216.59, 2412.72, 259.37, 0.0, 1032.0},
    {-14.40, 3219.53, 2412.72, 259.37, 0.0, 1032.0},
    {-14.67, 3222.86, 2412.72, 259.37, 0.0, 1032.0},
    {-14.88, 3225.25, 2412.72, 259.37, 0.0, 1032.0}
};

// Timers
forward robberyCancel(playerid);
forward healTimer(playerid);
forward AceptarPipeta(playerid);
forward SoplandoPipeta(playerid);

//==============================================================================

main() {
    AntiDeAMX();
	return 1;
}

// PP_main and Indirection_OnGameModeInit are provided by dependencies; remove local stubs.

public OnGameModeInit()
{
	if(GetMaxPlayers() > MAX_PLAYERS)
    {
        printf("[ERROR] 'maxplayers' (%i) excede MAX_PLAYERS (%i). Arreglar.", GetMaxPlayers(), MAX_PLAYERS);
        SendRconCommand("exit");
		return 1;
    }

	successStart = 1;

    SQLDB_LoadConfig();
    SQLDB_Connect();

    GenerateCommandsListVector();
	DumpCommandsListToDB();

    Streamer_SetVisibleItems(.type = STREAMER_TYPE_OBJECT, .items = 850);
    CallLocalFunction("LoadMaps", "");
	LoadPickups();
//	LoadGangZones();

	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	EnableStuntBonusForAll(0);
    DisableInteriorEnterExits();
    AllowInteriorWeapons(1);
	ManualVehicleEngineAndLights();
	SetNameTagDrawDistance(30.0);
	AddPlayerClass(0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);

	LoadServerInfo();
	LoadAllFactions();
	LoadAllVehicles();
	LoadAllHouses();
	Graffiti_LoadAll();
	LoadAllBusiness();
	// Initialize anti-cheat modules that expose public init functions
	CallLocalFunction("CBug_Init", "");
	CallLocalFunction("Vch_Init", "");
	BlackMarket_LoadLocations();
	Economy_LoadJobSalaries();
	// LoginAudio_Initialize(); // Inicializar sistema de audio de login // Deshabilitado: solo diálogos

	
	
	CallLocalFunction("LoadSystemData", "");

	//=======[CARGA DE OBJETOS MODEADOS]=========



	//===================================[TIMERS]===============================

	timersID[0] = SetTimer("VehicleFuelTimer", GAS_UPDATE_TIME, true); // 15 seg. - Actualiza la gasolina de los vehículos.
	timersID[1] = SetTimer("GlobalUpdate", 997, true);	// 1 seg. - Actualiza el score y la hora/fecha.
	timersID[2] = SetTimer("commandPermissionsUpdate", 3600000, true); // 60 min. - Refresca los permisos de los comandos
	timersID[3] = SetTimer("VehicleDamageTimer", 1009, true); // 1 seg. - Actualiza motores dañados y evita explosiones.
	timersID[4] = SetTimer("rentRespawn", 1000 * 60 * 20, true); // Respawn de vehículos de renta.
	timersID[5] = SetTimer("ServerObjectsCleaningTimer", SERVER_OBJECT_UPD_TIME * 60 * 1000, true); // Borrado de objetos con mucho tiempo de vida

	ResetServerRacesVariables();
	InitializeServerSpeakers();
	// Inicializar sistemas adicionales
	CallLocalFunction("VW_Init", "");
	CallLocalFunction("OnGameModeInitEnded", "");
	return 1;
}

forward OnGameModeInitEnded();
public OnGameModeInitEnded() {
	return 1;
}

CALLBACK:LoadSystemData() {
	return 1;
}

public OnGameModeExit()
{
	for(new i; i < sizeof(timersID); i++)
	{
		if(timersID[i]) {
			KillTimer(timersID[i]);
		}
	}

	if(successStart)
	{
		SaveServerInfo();
		SaveAllFactions();
		SaveAllVehicles();
		SaveAllHouses();
		SaveAllBusiness();
		
		CallLocalFunction("SaveSystemData", "");
	}

//	DestroyGangZones();
	ServerObjects_OnServerShutDown();

	Streamer_DestroyAllItems(STREAMER_TYPE_OBJECT);
	Streamer_DestroyAllItems(STREAMER_TYPE_PICKUP);
	Streamer_DestroyAllItems(STREAMER_TYPE_CP);
	Streamer_DestroyAllItems(STREAMER_TYPE_RACE_CP);
	Streamer_DestroyAllItems(STREAMER_TYPE_MAP_ICON);
	Streamer_DestroyAllItems(STREAMER_TYPE_3D_TEXT_LABEL);
	Streamer_DestroyAllItems(STREAMER_TYPE_AREA);
	Streamer_DestroyAllItems(STREAMER_TYPE_ACTOR);

	SQLDB_Close();
	return 1;
}

CALLBACK:SaveSystemData() {
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerLogged(playerid)) {
		return SpawnPlayer(playerid);
	} else {
		//KickPlayer(playerid, "el sistema", "intento de selección de clase sin iniciar sesión");
		return 0;
	}
}

public OnPlayerRequestSpawn(playerid)
{
	if(IsPlayerLogged(playerid)) {
		return 1;
	} else {
		KickPlayer(playerid, "el sistema", "intento de spawn sin iniciar sesión");
		return 0;
	}
}

public OnPlayerConnect(playerid)
{
	if(!AntiFlood(playerid))
		return 0;
	
	// NOTA: La validación de nombre se hace ahora al crear personajes en el sistema multi-char
	// El nombre SA-MP temporal puede ser cualquier cosa hasta que se seleccione/cree un personaje

	// Se eliminó el mensaje de carga al entrar: ya no mostrar "Cargando recursos..."
	TogglePlayerControllable(playerid, 0);

	//PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/j7bia0bysvvt0pa/marp_intro_short.mp3?dl=0"); //Original: https://dl.dropbox.com/s/ml70x04z1r4orvf/marp_intro_short.mp3?dl=0
										
	OnPlayerResetStats(playerid);

	GetPlayerName(playerid, PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
	SetPlayerCleanName(playerid, PlayerInfo[playerid][pName]);
	SetPlayerChatName(playerid, GetPlayerCleanName(playerid));

	GetPlayerIp(playerid, PlayerInfo[playerid][pIP], 16);
	TogglePlayerSpectating(playerid, true);
	pLoginTransitionTimer[playerid] = SetTimerEx("OnPlayerConnectDelayed", 3000, false, "i", playerid);
	return 1;
}

forward OnPlayerConnectDelayed(playerid);
public OnPlayerConnectDelayed(playerid)
{
	// LoginScreen_Start(playerid); // disabled login screen
	ClearScreen(playerid);
	CallLocalFunction("RemoveMapsBuildings", "i", playerid);
	pLoginTransitionTimer[playerid] = 0;
	// SetPVarString(playerid, "Login_Username_TMP", ""); // Deshabilitado: solo diálogos
	// SetPVarString(playerid, "Login_Password_TMP", ""); // Deshabilitado: solo diálogos
	// LoginTD_Show(playerid); // Deshabilitado: solo diálogos
	// LoginAudio_PlayRandom(playerid); // Deshabilitado: solo diálogos
	
	// Establecer cámara aleatoria de login
	LoginCamera_SetRandom(playerid);
	
	MultiChar_StartLogin(playerid);
	return 1;
}

// ==================== FUNCIONES DE CÁMARA DE LOGIN ====================
stock LoginCamera_SetRandom(playerid)
{
	new cameraIdx = random(MAX_LOGIN_CAMERAS);
	new Float:x = g_LoginCameras[cameraIdx][lc_x];
	new Float:y = g_LoginCameras[cameraIdx][lc_y];
	new Float:z = g_LoginCameras[cameraIdx][lc_z];
	new Float:look_x = g_LoginCameras[cameraIdx][lc_look_x];
	new Float:look_y = g_LoginCameras[cameraIdx][lc_look_y];
	new Float:look_z = g_LoginCameras[cameraIdx][lc_look_z];
	
	SetPlayerCameraPos(playerid, x, y, z);
	SetPlayerCameraLookAt(playerid, look_x, look_y, look_z);
	return 1;
}

// DEPRECATED: Reemplazado por sistema multi-personaje
/*
CheckAccountExistence(playerid)
{
	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT Id FROM accounts WHERE Name='%s' LIMIT 1", PlayerInfo[playerid][pName]);
	mysql_tquery(MYSQL_HANDLE, query, "OnAccountExistenceChecked", "i", playerid);
}

forward OnAccountExistenceChecked(playerid);
public OnAccountExistenceChecked(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 1;

	new string[128];

	if(cache_num_rows())
	{
		format(string, sizeof(string), "** %s (%d) se ha conectado al servidor (/verip ID). Registrado: si **", PlayerInfo[playerid][pName], playerid, PlayerInfo[playerid][pIP]);
		pLoginTransitionTimer[playerid] = SetTimerEx("StartAccountLogin", 2500, false, "i", playerid);
	}
	else
	{
		format(string, sizeof(string), "** %s (%d) se ha conectado al servidor (/verip ID). Registrado: no **", PlayerInfo[playerid][pName], playerid, PlayerInfo[playerid][pIP]);
		pLoginTransitionTimer[playerid] = SetTimerEx("CheckForMaxAccounts", 2500, false, "i", playerid);
	}

	new sqlid = (cache_num_rows()) ? (cache_index_int(0, 0)) : (0);

	CheckAccountBans(playerid, sqlid);
	AdministratorMessage(COLOR_GREY, string, 2);
	return 1;
}
*/


// DEPRECATED: Sistema de baneos movido a multi-personaje (OnCheckMasterAccountBan)
/*
CheckAccountBans(playerid, playersqlid)
{
	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT * FROM bans WHERE (pID=%i OR pIP='%s') AND banActive=1 LIMIT 1", playersqlid, PlayerInfo[playerid][pIP]);
	mysql_tquery(MYSQL_HANDLE, query, "OnAccountBansChecked", "ii", playerid, playersqlid);
}

forward OnAccountBansChecked(playerid, playersqlid);
public OnAccountBansChecked(playerid, playersqlid)
{
	if(!IsPlayerConnected(playerid))
		return 1;

	if(cache_num_rows())
	{
		new issuerName[MAX_PLAYER_NAME], banReason[128], banEndDate[32], banEndUnix;

		cache_get_value_name(0, "banIssuerName", issuerName, MAX_PLAYER_NAME);
		cache_get_value_name(0, "banReason", banReason, 128);
		cache_get_value_name(0, "banEnd", banEndDate, 32);
		cache_get_value_name_int(0, "banEndUnix", banEndUnix);
	    
	    if(gettime() > banEndUnix)
	    {
		    SendFMessage(playerid, COLOR_ADMINCMD, "[SERVIDOR] has sido desbaneado ya que el baneo temporal aplicado por %s finalizó el %s.", issuerName, banEndDate);

		    new query[128];  
	        mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE bans SET banActive=0 WHERE (pID=%i OR pIP='%s') AND banActive=1 LIMIT 1", playersqlid, PlayerInfo[playerid][pIP]);
			mysql_tquery(MYSQL_HANDLE, query);
		}
		else
		{
			SendFMessage(playerid, COLOR_ADMINCMD, "Te encuentras baneado/a hasta el %s por %s, razón: %s", banEndDate, issuerName, banReason);
			SendClientMessage(playerid, COLOR_ADMINCMD, "Serás desbaneado automáticamente por el servidor en el momento de finalización del baneo.");
			SendClientMessage(playerid, COLOR_ADMINCMD, "Para más información o para realizar un reclamo/descargo, dirígete a nuestro canal de Discord.");
			SetTimerEx("kickTimer", 1000, false, "d", playerid);
			return 1;
		}
	}
	
	return 1;
}
*/

CALLBACK:CheckForMaxAccounts(playerid)
{
	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT Id FROM accounts WHERE Ip='%e' LIMIT 3", PlayerInfo[playerid][pIP]);
	mysql_tquery(MYSQL_HANDLE, query, "OnMaxAccountsChecked", "i", playerid);
}

CALLBACK:OnMaxAccountsChecked(playerid)
{
	pLoginTransitionTimer[playerid] = 0;

	if (cache_num_rows() > 2)
	{
		SendClientMessage(playerid, COLOR_ADMINCMD, "Se alcanzo el máximo de cuentas posibles registradas por IP.");
		SendClientMessage(playerid, COLOR_ADMINCMD, "Si consideras que esto es un error, realiaz un ticket via discord.");
		SetTimerEx("kickTimer", 1000, false, "d", playerid);
		return 1;
	}

	CallLocalFunction("AccountRegister", "i", playerid);
	return 1;
}

forward AccountRegister(playerid);
public AccountRegister(playerid)
{
	pLoginTransitionTimer[playerid] = 0;
	new str[561+1];
	format(str, sizeof(str), "Malos Aires Roleplay es un servidor de rol basado en Buenos Aires, Argentina (IC conocidos como Malos Aires y Argencholina).\n\n\
	Es importante tener en cuenta que cualquier rol fuera del contexto del ambiente Argentino/Latino podrá ser considerado **NIP** y sancionado en consecuencia.\n\n\
	\n\
	Si tienes dudas:\n\
	- Usa /duda dentro del juego\n\
	- Contacta a un miembro del staff por Discord\n\n\
	Más información:\n\
	- Discord oficial del servidor\n\n\
	A continuación deberás realizar un breve examen de rol.", str);
   	Dialog_Show(playerid, DLG_TUT, DIALOG_STYLE_MSGBOX, "¡Bienvenido a Malos Aires!", str, "Aceptar", "");
    return 1;
}

forward StartAccountLogin(playerid);
public StartAccountLogin(playerid)
{
	pLoginTransitionTimer[playerid] = 0;
	Dialog_Show(playerid, DLG_LOGIN, DIALOG_STYLE_PASSWORD, "¡Bienvenido a Malos Aires!", "Para comenzar, por favor ingresa tu contraseña:", "Ingresar", "");
	return 1;
}


Dialog:DLG_LOGIN(playerid, response, listitem, inputtext[])
{
    if(!response)
    	return KickPlayer(playerid, "el sistema", "evadir inicio de sesión");
	if(gPlayerLogged[playerid])
		return 1;

	new query[256];
	strcat(query, inputtext, sizeof(query));
	mysql_escape_string(query, query, sizeof(query), MYSQL_HANDLE);
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT FirstLogin FROM accounts WHERE Name = '%s' AND Password = MD5('%s') LIMIT 1", PlayerInfo[playerid][pName], query);
	mysql_tquery(MYSQL_HANDLE, query, "OnAccountPasswordChecked", "i", playerid);
    return 1;
}

forward OnAccountPasswordChecked(playerid);
public OnAccountPasswordChecked(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 1;

	if(cache_num_rows())
	{
		if(cache_name_int(0, "FirstLogin")) {
			StartAccountFirstLogin(playerid);
		} else {
			LoadPlayerAccountData(playerid);
		}
	}
	else
	{
	    SetPVarInt(playerid, "LoginAttempts", GetPVarInt(playerid, "LoginAttempts") + 1);

	    if(GetPVarInt(playerid, "LoginAttempts") > MAX_LOGIN_ATTEMPTS)
	        return KickPlayer(playerid, "el sistema", "demasiados intentos de iniciar sesión");

		Dialog_Show(playerid, DLG_LOGIN, DIALOG_STYLE_PASSWORD, "¡Bienvenido a Malos Aires!", "{E44A4A}¡Contraseña incorrecta!\n\n"COLOR_EMB_DLG_DEFAULT"Ingresa tu contraseña por favor:", "Ingresar", "");
	}
	return 1;
}

StartAccountFirstLogin(playerid)
{
	// LoginScreen_End(playerid, 3000); // disabled login screen
	pLoginTransitionTimer[playerid] = PCC_Start(playerid, 5000); // delay character creation panel to 5000 ms
	FadeScreen_StartForPlayer(playerid, 0x0, 2500, 1000); // Color 0 = black, 2500 ms transition time, 1000 hold on max time
	
}

OnPlayerCreationSuccess(playerid, skin, sex, age)
{
    // Cambiar el nombre de SA-MP al nombre del personaje
    SetPlayerName(playerid, PlayerInfo[playerid][pName]);
    SetPlayerCleanName(playerid, PlayerInfo[playerid][pName]);
    SetPlayerChatName(playerid, PlayerInfo[playerid][pName]);
    
    // Elegir posición aleatoria
    new rand = random(sizeof(gStartPositions));
    new Float:x = gStartPositions[rand][0];
    new Float:y = gStartPositions[rand][1];
    new Float:z = gStartPositions[rand][2];
    new Float:a = gStartPositions[rand][3];
    new interior = floatround(gStartPositions[rand][4]);
    new world = floatround(gStartPositions[rand][5]);

    // Guardar en la BD
    new query[256];
    mysql_format(MYSQL_HANDLE, query, sizeof(query),
        "UPDATE accounts SET FirstLogin=0, Skin=%i, Age=%i, Sex=%i, \
        pX=%f, pY=%f, pZ=%f, pA=%f, pInterior=%i, pWorld=%i \
        WHERE Name='%s' LIMIT 1",
        skin, age, sex, x, y, z, a, interior, world, PlayerInfo[playerid][pName]);

    mysql_tquery(MYSQL_HANDLE, query, "OnAccountCreationSucceded", "i", playerid);
    pLoginTransitionTimer[playerid] = 0;

    // Guardar también en memoria (opcional)
    PlayerInfo[playerid][pX] = x;
    PlayerInfo[playerid][pY] = y;
    PlayerInfo[playerid][pZ] = z;
    PlayerInfo[playerid][pA] = a;
    PlayerInfo[playerid][pInterior] = interior;
    PlayerInfo[playerid][pVirtualWorld] = world;

    return 1;
}


forward OnAccountCreationSucceded(playerid);
public OnAccountCreationSucceded(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 1;

	LoadPlayerAccountData(playerid);
	return 1;
}

LoadPlayerAccountData(playerid)
{
	// LoginScreen_End(playerid, 3000); // disabled login screen
	FadeScreen_StartForPlayer(playerid, 0x0, 2500, 4000); // Color 0 = black, 2500 ms transition time, 4000ms hold on max time
	pLoginTransitionTimer[playerid] = SetTimerEx("LoadPlayerAccountDataDelayed", 2700, false, "i", playerid);
}

forward LoadPlayerAccountDataDelayed(playerid);
public LoadPlayerAccountDataDelayed(playerid)
{
	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT * FROM accounts WHERE Name = '%s' LIMIT 1", PlayerInfo[playerid][pName]);
	mysql_tquery(MYSQL_HANDLE, query, "OnPlayerAccountDataLoad", "i", playerid);
	pLoginTransitionTimer[playerid] = 0;
	return 1;
}

forward OnPlayerAccountDataLoad(playerid);
public OnPlayerAccountDataLoad(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 1;
	if(!cache_num_rows())
		return KickPlayer(playerid, "el sistema", "cuenta no encontrada en la base de datos.");

	DeletePVar(playerid, "LoginAttempts");

    cache_get_value_name_int(0, "Id", PlayerInfo[playerid][pID]);
	cache_get_value_name_int(0, "master_account_id", PlayerInfo[playerid][pMasterAccountId]);
	cache_get_value_name_int(0, "character_slot", PlayerInfo[playerid][pCharacterSlot]);
	
	// Verificar si este personaje específico tiene un baneo activo (tipo PERSONAJE)
	new query_ban[256];
	mysql_format(MYSQL_HANDLE, query_ban, sizeof(query_ban), 
		"SELECT * FROM bans WHERE pID=%d AND banType='PERSONAJE' AND banActive=1 LIMIT 1", 
		PlayerInfo[playerid][pID]);
	mysql_tquery(MYSQL_HANDLE, query_ban, "OnCheckCharacterBan", "i", playerid);
	
	return 1;
}

forward OnCheckCharacterBan(playerid);
public OnCheckCharacterBan(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 1;
	
	// Si el personaje tiene un baneo activo, verificar si expiró o kickear
	if(cache_num_rows() > 0)
	{
		new issuerName[MAX_PLAYER_NAME], banReason[128], banEndDate[32], banEndUnix;
		
		cache_get_value_name(0, "banIssuerName", issuerName, MAX_PLAYER_NAME);
		cache_get_value_name(0, "banReason", banReason, 128);
		cache_get_value_name(0, "banEnd", banEndDate, 32);
		cache_get_value_name_int(0, "banEndUnix", banEndUnix);
		
		if(gettime() > banEndUnix)
		{
			// Baneo expirado, desbanear automáticamente
			SendFMessage(playerid, COLOR_ADMINCMD, "[SERVIDOR] Has sido desbaneado ya que el baneo temporal finalizó el %s.", banEndDate);
			
			new query[256];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), 
				"UPDATE bans SET banActive=0 WHERE pID=%d AND banType='PERSONAJE' AND banActive=1", 
				PlayerInfo[playerid][pID]);
			mysql_tquery(MYSQL_HANDLE, query, "OnCharacterUnbanned", "i", playerid);
		}
		else
		{
			// Baneo activo, kickear al jugador
			SendFMessage(playerid, COLOR_ADMINCMD, "Este PERSONAJE está baneado hasta el %s por %s.", banEndDate, issuerName);
			SendFMessage(playerid, COLOR_ADMINCMD, "Razón: %s", banReason);
			SendClientMessage(playerid, COLOR_ADMINCMD, "Este baneo afecta solo a este personaje. Puedes usar otros personajes de tu cuenta.");
			SendClientMessage(playerid, COLOR_ADMINCMD, "Para más información o realizar un reclamo, dirígete a nuestro Discord.");
			SetTimerEx("kickTimer", 1000, false, "d", playerid);
			return 1;
		}
	}
	
	// No hay baneo de personaje activo, continuar con la carga normal del personaje
	ContinueCharacterLoad(playerid);
	return 1;
}

forward OnCharacterUnbanned(playerid);
public OnCharacterUnbanned(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	// Continuar con la carga del personaje después de desbanear
	ContinueCharacterLoad(playerid);
	return 1;
}

stock ContinueCharacterLoad(playerid)
{
	// Cargar el resto de los datos del personaje desde el cache original
	if(!IsPlayerConnected(playerid))
		return 0;
	
	// Volver a ejecutar la query para obtener todos los datos
	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT * FROM accounts WHERE Id = %d LIMIT 1", PlayerInfo[playerid][pID]);
	mysql_tquery(MYSQL_HANDLE, query, "OnContinueCharacterLoad", "i", playerid);
	return 1;
}

forward OnContinueCharacterLoad(playerid);
public OnContinueCharacterLoad(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 1;
	if(!cache_num_rows())
		return KickPlayer(playerid, "el sistema", "cuenta no encontrada en la base de datos.");
	
	// Verificar si el personaje ya está conectado
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(i == playerid) continue;
		if(!IsPlayerConnected(i)) continue;
		if(!gPlayerLogged[i]) continue;
		if(PlayerInfo[i][pID] == PlayerInfo[playerid][pID])
		{
			SendClientMessage(playerid, COLOR_RED, "Este personaje ya está conectado al servidor.");
			SendClientMessage(playerid, COLOR_RED, "Por seguridad, no puedes conectarte dos veces con el mismo personaje.");
			return KickPlayer(playerid, "el sistema", "personaje ya conectado");
		}
	}
	
	// Poblar cache de master account para el jugador
	if(PlayerInfo[playerid][pMasterAccountId] > 0) {
		new populateResult = MasterAccount_PopulateForPlayer(playerid, PlayerInfo[playerid][pMasterAccountId]);
		// Cargar admin level desde master_accounts
		PlayerInfo[playerid][pAdmin] = AccountInfo[playerid][accAdminLevel];
		printf("[DEBUG] PopulateForPlayer result=%d, masterId=%d, accAdminLevel=%d, pAdmin=%d", 
			populateResult, PlayerInfo[playerid][pMasterAccountId], 
			AccountInfo[playerid][accAdminLevel], PlayerInfo[playerid][pAdmin]);
	} else {
		// Si no tiene master account (caso antiguo), usar 0
		PlayerInfo[playerid][pAdmin] = 0;
		printf("[DEBUG] No master account for player %d, setting pAdmin=0", playerid);
	}
	cache_get_value_name_int(0, "Level", PlayerInfo[playerid][pLevel]);
	cache_get_value_name_int(0, "Sex", PlayerInfo[playerid][pSex]);
	cache_get_value_name_int(0, "Age", PlayerInfo[playerid][pAge]);
	cache_get_value_name_int(0, "Exp", PlayerInfo[playerid][pExp]);
	cache_get_value_name_int(0, "CashMoney", PlayerInfo[playerid][pCash]);
	cache_get_value_name_int(0, "BankMoney", PlayerInfo[playerid][pBank]);
	cache_get_value_name_int(0, "Skin", PlayerInfo[playerid][pSkin]);
	cache_get_value_name_int(0, "pThirst", PlayerInfo[playerid][pThirst]);
	cache_get_value_name_int(0, "pHunger", PlayerInfo[playerid][pHunger]);
	cache_get_value_name_int(0, "Job", PlayerInfo[playerid][pJob]);
	PlayerInfo[playerid][pJobSkin] = 0; // Por ahora sin entrada en base de datos.
	cache_get_value_name_int(0, "JobTime", PlayerInfo[playerid][pJobTime]);
	cache_get_value_name_int(0, "pTimePlayed", PlayerInfo[playerid][pTimePlayed]);
	cache_get_value_name_int(0, "PayCheck", PlayerInfo[playerid][pPayCheck]);
	cache_get_value_name_int(0, "pPayTime", PlayerInfo[playerid][pPayTime]);
	cache_get_value_name_int(0, "Faction", PlayerInfo[playerid][pFaction]);
	cache_get_value_name_int(0, "Rank", PlayerInfo[playerid][pRank]);
	cache_get_value_name_int(0, "HouseKey", PlayerInfo[playerid][pHouseKey]);
	cache_get_value_name_int(0, "pRolePoints", PlayerInfo[playerid][pRolePoints]);
	cache_get_value_name_int(0, "pElogios", PlayerInfo[playerid][pElogios]);
	cache_get_value_name_int(0, "pElogiosPendientes", PlayerInfo[playerid][pElogiosPendientes]);
	cache_get_value_name_int(0, "Warnings", PlayerInfo[playerid][pWarnings]);
	cache_get_value_name_int(0, "CarLic", PlayerInfo[playerid][pCarLic]);
	cache_get_value_name_int(0, "FlyLic", PlayerInfo[playerid][pFlyLic]);
	cache_get_value_name_int(0, "WepLic", PlayerInfo[playerid][pWepLic]);
	cache_get_value_name_int(0, "PhoneNumber", PlayerInfo[playerid][pPhoneNumber]);
	cache_get_value_name_int(0, "Jailed", PlayerInfo[playerid][pJailed]);
	cache_get_value_name_int(0, "JailedTime", PlayerInfo[playerid][pJailTime]);
	cache_get_value_name_int(0, "pInterior", PlayerInfo[playerid][pInterior]);
	cache_get_value_name_int(0, "pWorld", PlayerInfo[playerid][pVirtualWorld]);
	cache_get_value_name_int(0, "pHospitalized", PlayerInfo[playerid][pHospitalized]);
	cache_get_value_name_int(0, "pCrack", PlayerInfo[playerid][pCrack]);
	cache_get_value_name_int(0, "pWantedLevel", PlayerInfo[playerid][pWantedLevel]);
	cache_get_value_name_int(0, "pCantWork", PlayerInfo[playerid][pCantWork]);
	cache_get_value_name_int(0, "pMuteB", PlayerInfo[playerid][pMuteB]);
	cache_get_value_name_int(0, "pRentCarID", PlayerInfo[playerid][pRentCarID]);
	cache_get_value_name_int(0, "pRentCarRID", PlayerInfo[playerid][pRentCarRID]);
	cache_get_value_name_int(0, "pFightStyle", PlayerInfo[playerid][pFightStyle]);
	
	cache_get_value_name(0, "Name", PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
	cache_get_value_name(0, "AdminNickName", PlayerInfo[playerid][aNick], MAX_PLAYER_NAME);
	cache_get_value_name(0, "LastConnected", PlayerInfo[playerid][pLastConnected], 32);
	cache_get_value_name(0, "pAccusedOf", PlayerInfo[playerid][pAccusedOf], 64);
	cache_get_value_name(0, "pAccusedBy", PlayerInfo[playerid][pAccusedBy], 24);
	cache_get_value_name(0, "pQuestion", PlayerInfo[playerid][pQuestion], 144);
	cache_get_value_name(0, "pDescription", PlayerInfo[playerid][pDescription], 70);

    cache_get_value_name_int(0, "pHaveQuestion", PlayerInfo[playerid][pHaveQuestion]);
	cache_get_value_name_float(0, "pX", PlayerInfo[playerid][pX]);
	cache_get_value_name_float(0, "pY", PlayerInfo[playerid][pY]);
	cache_get_value_name_float(0, "pZ", PlayerInfo[playerid][pZ]);
	cache_get_value_name_float(0, "pA", PlayerInfo[playerid][pA]);
	cache_get_value_name_float(0, "pHealth", PlayerInfo[playerid][pHealth]);
	cache_get_value_name(0, "pWounds", PlayerInfo[playerid][pWounds], 32);


	
	cache_get_value_name_int(0, "pContainerSQLID", PlayerInfo[playerid][pContainerSQLID]);
	cache_get_value_name_int(0, "pBeltSQLID", PlayerInfo[playerid][pBeltSQLID]);
	

	//=============================MANO DERECHA=============================
	cache_get_value_name_int(0, "r_hand_item", HandInfo[playerid][HAND_RIGHT][Item]);
	cache_get_value_name_int(0, "r_hand_param", HandInfo[playerid][HAND_RIGHT][Amount]);

	if(ItemModel_GetType(HandInfo[playerid][HAND_RIGHT][Item]) == ITEM_CONTAINER) {
	    HandInfo[playerid][HAND_RIGHT][Amount] = Container_Load(HandInfo[playerid][HAND_RIGHT][Amount]);
	}

    //============================MANO IZQUIERDA============================
	cache_get_value_name_int(0, "l_hand_item", HandInfo[playerid][HAND_LEFT][Item]);
	cache_get_value_name_int(0, "l_hand_param", HandInfo[playerid][HAND_LEFT][Amount]);

	if(ItemModel_GetType(HandInfo[playerid][HAND_LEFT][Item]) == ITEM_CONTAINER) {
	    HandInfo[playerid][HAND_LEFT][Amount] = Container_Load(HandInfo[playerid][HAND_LEFT][Amount]);
	}

    //===============================ESPALDA================================
	cache_get_value_name_int(0, "back_carry", BackInfo[playerid][backCarryType]);
    cache_get_value_name_int(0, "back_item", BackInfo[playerid][backItem]);
	cache_get_value_name_int(0, "back_param", BackInfo[playerid][backAmount]);

	if(ItemModel_GetType(BackInfo[playerid][backItem]) == ITEM_CONTAINER) {
	    BackInfo[playerid][backAmount] = Container_Load(BackInfo[playerid][backAmount]);
	}

	//======================================================================
	
	gPlayerLogged[playerid] = 1;
	LoadPlayerJobData(playerid); // Info del job
   	
	/*
   	if(Faction_IsValidId(PlayerInfo[playerid][pFaction]))
   	{
   		if(Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_ALLOW_GANGZONE))
   		    ShowGangZonesToPlayer(playerid);
	}
*/
	//===========================CARGA DE CONTENEDOR========================

	if(PlayerInfo[playerid][pContainerSQLID] > 0)
	    PlayerInfo[playerid][pContainerID] = Container_Load(PlayerInfo[playerid][pContainerSQLID]);
	else
	    Container_Create(CONTAINER_INV_SPACE, 1, PlayerInfo[playerid][pContainerID], PlayerInfo[playerid][pContainerSQLID]);

	if (PlayerInfo[playerid][pFaction] == FAC_PMA || PlayerInfo[playerid][pFaction] == FAC_SIDE)
	{
		if(PlayerInfo[playerid][pBeltSQLID] > 0)
			PlayerInfo[playerid][pBeltID] = Container_Load(PlayerInfo[playerid][pBeltSQLID]);
		else
			Container_Create(CONTAINER_BELT_SPACE, 1, PlayerInfo[playerid][pBeltID], PlayerInfo[playerid][pBeltSQLID]);
	}

	//======================================================================
    
    SetPlayerCash(playerid,PlayerInfo[playerid][pCash]);
    SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
	SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
	SetSpawnInfo(playerid, 1, PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ], PlayerInfo[playerid][pA], 0, 0, 0, 0, 0, 0);

	if(PlayerInfo[playerid][pAdmin]) {
	    SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Bienvenido! Para ver los comandos de administración escribe /acmds.");
	} else {
	    SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Bienvenido! Si necesitas asistencia escribe '/ayuda', o usa '/guia' para conocer distintas ubicaciones.");
	}
	
	if(PlayerInfo[playerid][pRentCarID] > 0)
	{
	    if(RentCarInfo[PlayerInfo[playerid][pRentCarRID]][rRented] == 1 && RentCarInfo[PlayerInfo[playerid][pRentCarRID]][rOwnerSQLID] == PlayerInfo[playerid][pID])
	        SendFMessage(playerid, COLOR_WHITE, "Te quedan %d minutos de renta del vehículo que alquilaste.", RentCarInfo[PlayerInfo[playerid][pRentCarRID]][rTime]);
		else
	    {
	    	PlayerInfo[playerid][pRentCarRID] = 0;
	    	PlayerInfo[playerid][pRentCarID] = 0;
	    	SendClientMessage(playerid, COLOR_WHITE, "Se ha acabado el tiempo de renta de tu vehículo alquilado.");
		}
	}
	
	SendClientMessage(playerid, COLOR_WHITE, " ");

	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) {
		TogglePlayerSpectating(playerid, false);
	} else if(GetPVarInt(playerid, "CSwitchSpawn")) {
		DeletePVar(playerid, "CSwitchSpawn");
		SpawnPlayer(playerid);
		CharSwitch_FreezeOnSpawn(playerid);
	} else {
		SpawnPlayer(playerid);
	}

	SyncPlayerTimeAndWeather(playerid);
	CallLocalFunction("LoadAccountDataEnded", "i", playerid);
	return 1;
}

forward LoadAccountDataEnded(playerid);
public LoadAccountDataEnded(playerid)
{
	StopAudioStreamForPlayer(playerid);
	// LoginScreen_End(playerid, 1000); // disabled login screen
	
	LoginCamera_Start(playerid, 1000, 5500); // 1000ms delay to init login camera, and then an extra 5500ms to start interpolation
	return 1;
}

OnPlayerResetStats(playerid)
{
    MedDuty[playerid] = 0;
    
	/* Vehiculos */
    OfferingVehicle[playerid] = false;
    VehicleOfferPrice[playerid] = -1;
    VehicleOffer[playerid] = INVALID_PLAYER_ID;
    VehicleOfferID[playerid] = -1;
	startingEngine[playerid] = false;
    
    /* Venta de casas */
	ResetHouseOffer(playerid);

	/* Venta de negocios */
	ResetBusinessOffer(playerid);

	
	BlowingPipette[playerid] = 0;
	OfferingPipette[playerid] = 0;
	smoking[playerid] = 0;
	LastVeh[playerid] = 0;
	
	LastCP[playerid] = -1;
	CollectedProds[playerid] = 0;
		
	/* Saludo */
	saluteOffer[playerid] = INVALID_PLAYER_ID;
	saluteStyle[playerid] = 0;
	
	/*Sistema de robo al banco*/
	ResetRobberyGroupVariables(playerid);

	/* Licencia de armas */
	wepLicOffer[playerid] = INVALID_PLAYER_ID;
	
	/* Revision de usuarios */
	ReviseOffer[playerid] = 999;
	
	/* Sistema de camaras */
	usingCamera[playerid] = false;
	
	/* Sistema de Picadas */
	resetSprintRace(playerid);

	/* Sistema de carreras */
	ResetPlayerRaceVariables(playerid);
	
	/* Descripciones de 3Dtexts */
	ResetDescVariables(playerid);
	
	/* Sistema de stream de radios */
	Radio_Reset(playerid);
	
	/* Sistema de entrevistas para CTRMAN */
	InterviewOffer[playerid] = 999;
	InterviewActive[playerid] = false;
	
	/* Sistema de casino */
	isBetingRoulette[playerid] = false;
	isBetingFortune[playerid] = false;
	isBetingTragamonedas[playerid] = false;
	
	/* Sistema de hambre y sed */
    PlayerInfo[playerid][pThirst] = 100;
	PlayerInfo[playerid][pHunger] = 100;
	
	/* Cinturón de Seguridad */
	SeatBelt[playerid] = false;

	/* Sistema de toggle */
	p_toggle[playerid] = e_ToggleFlags:0xFFFFFFFF; // All flags in p_toggle ON
	
	/* Administración */
	AdminDuty[playerid] = false;
	AdminPMsEnabled[playerid] = false;
	AdminWhispersEnabled[playerid] = false;
	AdminFactionEnabled[playerid] = false;
	AdminSMSEnabled[playerid] = false;
	Admin911Enabled[playerid] = false;

    jobDuty[playerid] = false;
	TicketOffer[playerid] = 999;
	TicketMoney[playerid] = 0;
	PlayerCuffed[playerid] = 0;
	CopDuty[playerid] = 0;
	SIDEDuty[playerid] = 0;
	Muted[playerid] = 0;
	HospHealing[playerid] = 0;
	SetPlayerColor(playerid, COLOR_NOTLOGGED);
	FactionRequest[playerid] = 0;
	Mobile[playerid] = 255;
	gPlayerLogged[playerid] = 0;
	
	PlayerInfo[playerid][pFightStyle] = 0;
	PlayerInfo[playerid][pMuteB] = 0;

	PlayerInfo[playerid][pID] = 0;
	PlayerInfo[playerid][pCantWork] = 0;
	PlayerInfo[playerid][pWantedLevel] = 0;
	PlayerInfo[playerid][pWarnings] = 0;
	PlayerInfo[playerid][pLevel] = 1;
	PlayerInfo[playerid][pName] = "XXXXXXXXXXXXXXXXXXXXXXX";
	PlayerInfo[playerid][pLastConnected] = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
	PlayerInfo[playerid][pIP] = "XXXXXXXXXXXXXXX";
	PlayerInfo[playerid][aNick] ="XXXXXXXXXXXXXXXXXXXXXXX";
	PlayerInfo[playerid][pAdmin] = 0;
	PlayerInfo[playerid][pQuestion][0] = '\0';
	PlayerInfo[playerid][pHaveQuestion] = 0;
	PlayerInfo[playerid][pReport] = 0;
	PlayerInfo[playerid][pReportReason]= EOS;
	PlayerInfo[playerid][pSex] = 1;
	PlayerInfo[playerid][pAge] = 0;
	PlayerInfo[playerid][pExp] = 0;
	PlayerInfo[playerid][pCash] = 0;
	PlayerInfo[playerid][pBank] = 0;
	PlayerInfo[playerid][pSkin] = 0;
	PlayerInfo[playerid][pJob] = 0;
	PlayerInfo[playerid][pJobSkin] = 0;
	PlayerInfo[playerid][pJobTime] = 0;
	PlayerInfo[playerid][pTimePlayed] = 0;
	PlayerInfo[playerid][pPayCheck] = 0;
	PlayerInfo[playerid][pPayTime] = 0;
	PlayerInfo[playerid][pDead] = 0;
	PlayerInfo[playerid][pDisabled] = DISABLE_NONE;
	PlayerInfo[playerid][pFaction] = 0;
	PlayerInfo[playerid][pRank] = 0;
	PlayerInfo[playerid][pHouseKey] = 0;
	PlayerInfo[playerid][pWarnings] = 0;
	PlayerInfo[playerid][pCarLic] = 0;
	PlayerInfo[playerid][pWepLic] = 0;
	PlayerInfo[playerid][pFlyLic] = 0;
	PlayerInfo[playerid][pPhoneNumber] = 0;
	PlayerInfo[playerid][pJailed] = JAIL_NONE;
	PlayerInfo[playerid][pJailTime] = 0;
	PlayerInfo[playerid][pX] = 1481.2136;
	PlayerInfo[playerid][pY] = -1751.6758;
	PlayerInfo[playerid][pZ] = 15.4453;
	PlayerInfo[playerid][pA] = 358.1794;
	PlayerInfo[playerid][pInterior] = 0;
	PlayerInfo[playerid][pVirtualWorld] = 0;
	PlayerInfo[playerid][pHospitalized] = 0;
	PlayerInfo[playerid][pCrack] = 0;
	PlayerInfo[playerid][pHealth] = 100.0;
	PlayerInfo[playerid][pArmour] = 0.0;
	PlayerInfo[playerid][pRentCarID] = 0;
	PlayerInfo[playerid][pRentCarRID] = 0;
	PlayerInfo[playerid][pRentBikeVehicleID] = 0;
	PlayerInfo[playerid][pRolePoints] = 0;
	PlayerInfo[playerid][pContainerSQLID] = 0;
	PlayerInfo[playerid][pContainerID] = 0;
	PlayerInfo[playerid][pBeltSQLID] = 0;
	PlayerInfo[playerid][pBeltID] = 0;
	
 	ResetJobVariables(playerid);
 	
 	ResetContainerSelection(playerid);

	J_Garb_ResetVars(playerid);
	J_Garb_ResetInfo(playerid);
	return 0;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(pLoginTransitionTimer[playerid])
	{
		KillTimer(pLoginTransitionTimer[playerid]);
		pLoginTransitionTimer[playerid] = 0;
	}

	ResetDescLabel(playerid);
	AdminDutyNickOff(playerid);
	
	
    KillTimer(GetPVarInt(playerid, "CancelVehicleTransfer"));
    KillTimer(GetPVarInt(playerid, "CancelDrugTransfer"));
    KillTimer(GetPVarInt(playerid, "robberyCancel"));
    KillTimer(GetPVarInt(playerid, "fuelCar"));
	KillTimer(GetPVarInt(playerid, "fuelCarWithCan"));
	KillTimer(ReplenishDescTimer[playerid]);
	ResetThiefCrime(playerid);

	if(jobDuty[playerid])
	{
		if(GetJobType(PlayerInfo[playerid][pJob]) == JOB_TYPE_LEGAL)
		{
			SetVehicleToRespawn(jobVehicle[playerid]);
		}
	}

	OnPlayerLeaveRobberyGroup(playerid, 1);

	EndPlayerDuty(playerid);
	
	deleteAbandonedSprintRace(playerid);
	OnPlayerLeaveRace(playerid);
	
	Radio_Stop(playerid);
		
	//HideGangZonesToPlayer(playerid);
	
	Cronometro_Borrar(playerid);

 	if(gPlayerLogged[playerid])
	{
		switch(reason)
		{
	        case 0: PlayerLocalMessage(playerid, 30.0, "se ha desconectado (razón: timeout/crash).");
			case 1: PlayerLocalMessage(playerid, 30.0, "se ha desconectado (razón: a voluntad).");
			case 2: PlayerLocalMessage(playerid, 30.0, "se ha desconectado (razón: kick/ban).");
	    }

		// Force-sync current position to ensure it saves on disconnect
		PlayerPos_SyncCurrentData(playerid);

		SaveAccount(playerid);
	}

	SetPlayerCarrying(playerid, false);

	DestroyPlayerInventory(playerid);
	DestroyPlayerDutyBelt(playerid);
	DestroyPlayerHands(playerid);
	Back_DestroyContainer(playerid);

	Job_WorkingPlayerDisconnect(playerid);

	J_Garb_OnPlayerDisconnect(playerid);
	J_Bus_OnPlayerDisconnect(playerid);

	gPlayerLogged[playerid] = 0;
	
	// IMPORTANTE: ResetJobVariables debe ser lo ÚLTIMO para que no se guarden datos en 0
	// después de que se hayan reseteado las variables en memoria
	ResetThiefCrime(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(!gPlayerLogged[playerid])
		return 0;

	PlayerInfo[playerid][pDead] = 0;

	SetNormalPlayerGunSkills(playerid);
	SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pFightStyle]);

	if((jobDuty[playerid] || isPlayerCopOnDuty(playerid) || IsMedicOnDuty(playerid) || isPlayerSideOnDuty(playerid)) && PlayerInfo[playerid][pJobSkin] != 0) {
		SetPlayerSkin(playerid, PlayerInfo[playerid][pJobSkin]);
	} else {
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	}

	if(AdminDuty[playerid])
	{
		SetPlayerColor(playerid, COLOR_ADMINDUTY);
		SetPlayerHealthEx(playerid, 50000);
	}  else {
		SetPlayerColor(playerid, 0xFFFFFF00);
	}

	if(PlayerInfo[playerid][pJailed])
	{
		SetPlayerHealthEx(playerid, 100.0);
		TeleportPlayerTo(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ], PlayerInfo[playerid][pA], PlayerInfo[playerid][pInterior], PlayerInfo[playerid][pVirtualWorld], .forceLoadingTime = true);
		return 1;
	}

	if(WasPlayerSpectating(playerid)) {
		ResetPlayerSpectate(playerid);
	} else {
		if(PlayerInfo[playerid][pHospitalized] >= 1) {
			InitiateHospital(playerid);
		} else  {
			TeleportPlayerTo(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ], PlayerInfo[playerid][pA], PlayerInfo[playerid][pInterior], PlayerInfo[playerid][pVirtualWorld]);
		}

		// Ensure player remains frozen/animated if they were in DYING or DEATHBED state
		if (PlayerInfo[playerid][pDisabled] == DISABLE_DYING || PlayerInfo[playerid][pDisabled] == DISABLE_DEATHBED || PlayerInfo[playerid][pCrack]) {
			TogglePlayerControllable(playerid, false);
			if (PlayerInfo[playerid][pCrack] || PlayerInfo[playerid][pDisabled] == DISABLE_DYING) {
				ClearAnimations(playerid, 1);
				ApplyAnimationEx(playerid, "WUZI", "CS_DEAD_GUY", 4.0, 1, 1, 1, 1, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
			} else if (PlayerInfo[playerid][pDisabled] == DISABLE_DEATHBED) {
				ClearAnimations(playerid, 1);
				ApplyAnimationEx(playerid, "PED", "FLOOR_hit_f", 4.0, 0, 0, 0, 1, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
			}
			SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
		}
	}

	LoadHandItem(playerid, HAND_RIGHT);
	LoadHandItem(playerid, HAND_LEFT);
	Back_ShowGraphicObject(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason) {
	new time = gettime();

	PlayerInfo[playerid][pDead] = 1;
	PlayerInfo[playerid][pHealth] = 10.0;

	if(0 <= (time - LastDeath[playerid]) <= 3)
	{
		DeathSpam[playerid]++;

		if(DeathSpam[playerid] == 3)
			return BanPlayer(playerid, INVALID_PLAYER_ID, "fake kills cheat", 0);
	} else {
		DeathSpam[playerid] = 0;
	}
   
    LastDeath[playerid] = time;

	GetPlayerPos(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ]);
	PlayerInfo[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
	PlayerInfo[playerid][pInterior] = GetPlayerInterior(playerid);
    
	if(AdminDuty[playerid])
		return true;

	if(jobDuty[playerid])
	{
		if(PlayerInfo[playerid][pJob] == JOB_BUS)
			BusJob_PlayerDeath(playerid);
	}


	if(PlayerInfo[playerid][pJailed] == JAIL_NONE) {
		if (PlayerInfo[playerid][pHospitalized] >= 1) {
		} else if (PlayerInfo[playerid][pCrack]) {
			InitiateHospital(playerid);
		} else {
			Damage_ApplyDeathEffect(playerid);
		}
	}

	EndPlayerDuty(playerid);
	ResetThiefCrime(playerid);

	Radio_Stop(playerid);
	
	OnPlayerLeaveRobberyGroup(playerid, 2);
	return true;

}

public OnPlayerText(playerid, text[])
{
    if(!gPlayerLogged[playerid]) {
    	return 0;
    }

	if(Muted[playerid])	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] No puedes hablar, has sido silenciado.");
		return 0;
	}

	if(usingCamera[playerid]) {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] No puedes hablar mientras estas viendo una cámara.");
		return 0;
	}

	new string[256], name[MAX_PLAYER_NAME]; name = GetPlayerChatName(playerid);

	// Construir texto con color de /me para segmentos entre guiones
	new dialogText[256];
	// Sanitize underscores: replace '_' with space so underscores aren't shown in chat
	new sanitized[256];
	strcopy(sanitized, text, sizeof(sanitized));
	for(new _i = 0; sanitized[_i] != '\0'; _i++) {
		if(sanitized[_i] == '_') sanitized[_i] = ' ';
	}
	BuildDialogueWithMeColor(sanitized, dialogText, sizeof(dialogText));

    if(!IsPlayerInAnyVehicle(playerid) || Veh_GetModelType(GetPlayerVehicleID(playerid)) != VTYPE_CAR)
	{
		if(BitFlag_Get(p_toggle[playerid], FLAG_TOGGLE_TALKANIM) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
			ApplyPlayerTalkAnimation(playerid, 1250 + strlen(text) * 50);
		}

		format(string, sizeof(string), "%s dice: %s", name, dialogText);
		SendPlayerMessageInRange(15.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	}
	else
	{
		new vehSeat = GetPlayerVehicleSeat(playerid), winState[4];

        GetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), winState[0], winState[1], winState[2], winState[3]);

	  	if(vehSeat < 0 || vehSeat > 3 || winState[vehSeat] != 0)
	    {
			format(string, sizeof(string), "[Ventanillas cerradas] %s dice: %s", name, dialogText);
			SendPlayerMessageInRange(5.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
		}
		else
		{
			format(string, sizeof(string), "[Ventanillas abiertas] %s dice: %s", name, dialogText);
			SendPlayerMessageInRange(15.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
		}
	}
    return 0;
}

public OnPlayerCommandReceived(playerid, cmdtext[]) 
{    
    if(!gPlayerLogged[playerid]) {
        return 0;
    }

    new cmd_str[130];
	sscanf(cmdtext, "s[130] ", cmd_str);

	if(strlen(cmd_str) > (MAX_FUNC_NAME - 4)) { // {strlen("cmd_"+cmd_str-"/") <= 31} <=> {strlen(cmd_str) <= 28}
		return 0;
	}

    if(checkCmdPermission(cmd_str, PlayerInfo[playerid][pAdmin]) == 0) {
        SendClientMessage(playerid, COLOR_ERROR, "[ERROR] No tienes acceso a este comando");
        return 0;
    }

	if(usingCamera[playerid] && strcmp(cmdtext,"/salircam") != 0) {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] Para utilizar un comando antes debes salir de la cámara.");
	    return 0;
	}
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success) 
{
	if(!success) {
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Comando desconocido. Para ver una lista de comandos usa [/ayuda] o envia [/duda] a un administrador.");
	}
	return 1;
}

AntiDeAMX() {
    new b;
    #emit load.pri b
    #emit stor.pri b
}

forward SaveAccount(playerid);
public SaveAccount(playerid)
{
	if(gPlayerLogged[playerid])
	{
		new query[1700];
		
        if(AdminDuty[playerid])
        {
			PlayerInfo[playerid][pHealth] = GetPVarFloat(playerid, "tempHealth");
			AdminDuty[playerid] = false;
			AdminDutyNickOff(playerid);
		}

		if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING && gettime() >= pAllowPosDataSyncTime[playerid])
		{
			GetPlayerPos(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ]);
			GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pA]);
			PlayerInfo[playerid][pInterior] = GetPlayerInterior(playerid);

			if(IsPlayerAFK(playerid)) {
				PlayerInfo[playerid][pVirtualWorld] = AFK_GetReturnWorld(playerid);
			} else {
				PlayerInfo[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
			}
		}

		// TODO: fix container destroy in DestroyPlayerHands getting called before this:

		if(ItemModel_GetType(HandInfo[playerid][HAND_RIGHT][Item]) == ITEM_CONTAINER) {
			HandInfo[playerid][HAND_RIGHT][Amount] = Container_GetSQLID(HandInfo[playerid][HAND_RIGHT][Amount]);
		}
		if(ItemModel_GetType(HandInfo[playerid][HAND_LEFT][Item]) == ITEM_CONTAINER) {
			HandInfo[playerid][HAND_LEFT][Amount]  = Container_GetSQLID(HandInfo[playerid][HAND_LEFT][Amount]);
		}
		if(ItemModel_GetType(BackInfo[playerid][backItem]) == ITEM_CONTAINER) {
			BackInfo[playerid][backAmount] = Container_GetSQLID(BackInfo[playerid][backAmount]);
		}

		mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `accounts` SET \
			`Ip`='%s',\
			`Name`='%s',\
			`Level`=%i,\
			`Sex`=%i,\
			`Age`=%i,\
			`Exp`=%i,\
			`CashMoney`=%i,\
			`BankMoney`=%i,\
			`Skin`=%i,\
			`pHunger`=%i,\
			`Job`=%i,\
			`JobTime`=%i,\
			`pTimePlayed`=%i,\
			`PayCheck`=%i,\
			`pPayTime`=%i,\
			`Faction`=%i,\
			`Rank`=%i,\
			`HouseKey`=%i,\
			`Warnings`=%i,\
			`pMuteB`=%i,\
			`pRentCarID`=%i,\
			`pRentCarRID`=%i,\
			`pFightStyle`=%i,\
			`pRolePoints`=%i,\
			`pElogios`=%i,\
			`pElogiosPendientes`=%i,\
			`pContainerSQLID`=%i,\
			`pBeltSQLID`=%i,\
			`CarLic`=%i,\
			`FlyLic`=%i,\
			`WepLic`=%i,\
			`PhoneNumber`=%i,\
			`Jailed`=%i,\
			`JailedTime`=%i,\
			`pThirst`=%i,\
			`pInterior`=%i,\
			`pWorld`=%i,\
			`pHospitalized`=%i,\
			`pCrack`=%i,\
			`pWantedLevel`=%i,\
			`pCantWork`=%i,\
			`pQuestion`='%e',\
			`pHaveQuestion`=%i,\
			`LastConnected`=CURRENT_TIMESTAMP,\
			`pAccusedOf`='%e',\
			`pAccusedBy`='%s',\
			`pX`=%f,\
			`pY`=%f,\
			`pZ`=%f,\
			`pA`=%f,\
			`pHealth`=%f,\
			`pWounds`='%s',\
			`r_hand_item`=%i,\
			`r_hand_param`=%i,\
			`l_hand_item`=%i,\
			`l_hand_param`=%i,\
			`back_carry`=%i,\
			`back_item`=%i,\
			`back_param`=%i,\
			`pDescription`='%e' WHERE `Id`=%i;",
			PlayerInfo[playerid][pIP],
			PlayerInfo[playerid][pName],
			PlayerInfo[playerid][pLevel],
			PlayerInfo[playerid][pSex],
			PlayerInfo[playerid][pAge],
			PlayerInfo[playerid][pExp],
			PlayerInfo[playerid][pCash],
			PlayerInfo[playerid][pBank],
			PlayerInfo[playerid][pSkin],
			PlayerInfo[playerid][pHunger],
			PlayerInfo[playerid][pJob],
			PlayerInfo[playerid][pJobTime],
			PlayerInfo[playerid][pTimePlayed],
			PlayerInfo[playerid][pPayCheck],
			PlayerInfo[playerid][pPayTime],
			PlayerInfo[playerid][pFaction],
			PlayerInfo[playerid][pRank],
			PlayerInfo[playerid][pHouseKey],
			PlayerInfo[playerid][pWarnings],
			PlayerInfo[playerid][pMuteB],
			PlayerInfo[playerid][pRentCarID],
			PlayerInfo[playerid][pRentCarRID],
			PlayerInfo[playerid][pFightStyle],
			PlayerInfo[playerid][pRolePoints],
			PlayerInfo[playerid][pElogios],
			PlayerInfo[playerid][pElogiosPendientes],
			PlayerInfo[playerid][pContainerSQLID],
			PlayerInfo[playerid][pBeltSQLID],
			PlayerInfo[playerid][pCarLic],
			PlayerInfo[playerid][pFlyLic],
			PlayerInfo[playerid][pWepLic],
			PlayerInfo[playerid][pPhoneNumber],
			PlayerInfo[playerid][pJailed],
			PlayerInfo[playerid][pJailTime],
			PlayerInfo[playerid][pThirst],
			PlayerInfo[playerid][pInterior],
			PlayerInfo[playerid][pVirtualWorld],
			PlayerInfo[playerid][pHospitalized],
			PlayerInfo[playerid][pCrack],
			PlayerInfo[playerid][pWantedLevel],
			PlayerInfo[playerid][pCantWork],
			PlayerInfo[playerid][pQuestion],
			PlayerInfo[playerid][pHaveQuestion],
			PlayerInfo[playerid][pAccusedOf],
			PlayerInfo[playerid][pAccusedBy],
			PlayerInfo[playerid][pX],
			PlayerInfo[playerid][pY],
			PlayerInfo[playerid][pZ],
			PlayerInfo[playerid][pA],
			PlayerInfo[playerid][pHealth],
			PlayerInfo[playerid][pWounds],
			HandInfo[playerid][HAND_RIGHT][Item],
			HandInfo[playerid][HAND_RIGHT][Amount],
			HandInfo[playerid][HAND_LEFT][Item],
			HandInfo[playerid][HAND_LEFT][Amount],
			BackInfo[playerid][backCarryType],
			BackInfo[playerid][backItem],
			BackInfo[playerid][backAmount],
			PlayerInfo[playerid][pDescription],
			PlayerInfo[playerid][pID]
	);

		mysql_tquery(MYSQL_HANDLE, query);
		SavePlayerJobData(playerid); // Info del job
	}
	return 1;
}

forward GlobalUpdate();
public GlobalUpdate() {
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) {
	// Al salir de un interior, congelar unos ms para permitir que el exterior cargue.
	if (oldinteriorid != 0 && newinteriorid == 0 && PlayerInfo[playerid][pDisabled] == DISABLE_NONE) {
		TogglePlayerControllable(playerid, false);
		SetTimerEx("Unfreeze", INTERIOR_EXIT_FREEZE_MS, false, "i", playerid);
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(AdminDuty[playerid]) {
	    return 1;
	}

	// Allow other modules (e.g., ElecJob) to veto vehicle entry (return 0 to block)
	new allow = CallLocalFunction("ElecJob_AllowEnterVehicle", "ii", playerid, vehicleid);
	if (allow == 0) return 0;

	if(VehicleInfo[vehicleid][VehLocked] == 1)
	{
	    new vehModelType = Veh_GetModelType(vehicleid);
	    
		if(vehModelType == VTYPE_BMX || vehModelType == VTYPE_BIKE || vehModelType == VTYPE_QUAD)
		    return 1;

		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		GameTextForPlayer(playerid, "~w~Vehiculo cerrado", 1000, 4);
	}

	if(PlayerInfo[playerid][pCrack]) 
	{
		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		Damage_ApplyCrackAnimation(playerid);
	}

	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid) {
	return 1;
}

/* NOTA MENTAL. SI SE DEVUELVE ~1 O ~0 EN CUALQUIER HOOK SEA A UN PUBLIC, O CUALQUIER VALOR EXCEPTO 'return continue(parametros originales)'
SEA UN FUNCTION, SE INTERRUMPE TODA LA CADENA QUE VENGA DESPUES, INCLUIDA TAMBIEN EL PUBLIC/FUNCTION ORIGINAL */

// TODO: cambiar checkpoints a dynamic
public OnPlayerEnterCheckpoint(playerid)
{
	DisablePlayerCheckpoint(playerid);
	OnPlayerEnterCPId(playerid, GetPlayerActiveCheckpointID(playerid));
	return 1;
}

OnPlayerEnterCPId(playerid, checkpointid)
{
	#pragma unused playerid
	#pragma unused checkpointid

	return 1;
}

public OnPlayerLeaveCheckpoint(playerid) {
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid) {
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid) {
	return 1;
}

public OnObjectMoved(objectid) {
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid) {
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid) {
	return 0;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
	// Forward to module-specific handlers that expect playertext clicks
	CallLocalFunction("ew_onptd", "ii", playerid, _:playertextid);
	return 0;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source) {
	// Right-click player interaction: allow police to tackle with right click
	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(clickedplayerid)) return 1;

	// 'source' indicates click origin; accept common in-game click sources (1 or 2)
	if(source != 1 && source != 2) return 1;

	// Only allow when both are on foot and within range
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
	if(GetPlayerState(clickedplayerid) != PLAYER_STATE_ONFOOT) return 1;
	if(IsPlayerInAnyVehicle(playerid) || IsPlayerInAnyVehicle(clickedplayerid)) return 1;

	// Police tackle: reuse Police helpers
	if(Police_CanTackle(playerid) && IsPlayerInRangeOfPlayer(2.5, playerid, clickedplayerid) && GetPlayerWeapon(clickedplayerid) == 0) {
		Police_DoTackle(playerid, clickedplayerid);
	}
	return 1;
}

LoadPickups() {

	/* Cámaras de Seguridad PMA */
	P_POLICE_CAMERAS = CreateDynamicPickup(1239, 1, -2811.67, 3211.25, 2412.73, -1);
	CreateDynamic3DTextLabel("Cámaras de Seguridad de la Ciudad", COLOR_WHITE, 219.36, 188.31, 1003.75, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 16002, 3, -1, 100.0);

	/* Gimnasio */
	P_FIGHT_STYLE = CreateDynamicPickup(1239, 1, 766.3723, 13.8237, 1000.7015, -1);

	// Curarse en hospital
	P_HOSP_HEAL = CreateDynamicPickup(1240, 1, POS_HOSP_HEAL_X_1, POS_HOSP_HEAL_Y_1, POS_HOSP_HEAL_Z_1, -1);
	P_HOSP_HEAL_2 = CreateDynamicPickup(1240, 1, POS_HOSP_HEAL_X_2, POS_HOSP_HEAL_Y_2, POS_HOSP_HEAL_Z_2, -1);

	// Robo de autos
	P_CAR_DEMOLITION = CreateDynamicPickup(1239, 1, POS_CAR_DEMOLITION_X, POS_CAR_DEMOLITION_Y, POS_CAR_DEMOLITION_Z, -1);
	
	/* Banco de Malos Aires */
	P_BANK = CreateDynamicPickup(1239, 1, POS_BANK_X, POS_BANK_Y, POS_BANK_Z, -1);
	
	/* Cárcel de la Policía Metropolitana */
	P_POLICE_ARREST = CreateDynamicPickup(1239, 1, POS_POLICE_ARREST_X, POS_POLICE_ARREST_Y, POS_POLICE_ARREST_Z, -1);
	P_POLICE_ARREST2 = CreateDynamicPickup(1239, 1, POS_POLICE_ARREST2_X, POS_POLICE_ARREST2_Y, POS_POLICE_ARREST2_Z, -1);
	P_JAIL_EAT = CreateDynamicPickup(1239, 1, 1202.45, 3166.91, 2416.58, -1);
	
	/* Gendarmería */
	P_GEN_EAT = CreateDynamicPickup(1239, 1, -492.45, -515.54, 4217.67, -1);

	/* Centro de Licencias de Malos Aires */
	P_LICENSE_CENTER = CreateDynamicPickup(1239, 1, -2033.2118, -117.4678, 1035.1719, -1);

    /* Cosechador de materia prima */
	P_DRUGFARM_MATS = CreateDynamicPickup(1239, 1, -1060.9709, -1195.5382, 129.6939);

	// Renta de autos
	P_CAR_RENT1 = CreateDynamicPickup(1239, 1, 1569.8145, -2243.8796, 13.5184, -1);
	P_CAR_RENT2	= CreateDynamicPickup(1239, 1, 1276.8502, -1309.8553, 13.3107, -1);
	P_CAR_RENT3 = CreateDynamicPickup(1239, 1, 611.9272, -1294.7240, 15.2081, -1);

	
	// Jobs
	Jobs_LoadPickups();
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(pickupid == P_BANK) {
		GameTextForPlayer(playerid, "~w~/ayudabanco", 2000, 4);
		return 1;

	} else if(pickupid == P_FIGHT_STYLE) {
		GameTextForPlayer(playerid, "~w~Escribe /aprender para adquirir nuevos conocimientos de pelea.", 2000, 4);
		return 1;

	} else if(pickupid == P_POLICE_ARREST && PlayerInfo[playerid][pFaction] == FAC_PMA) {
		GameTextForPlayer(playerid, "~w~/arrestar aqui para arrestar.", 2000, 4);
		return 1;

	} else if(pickupid == P_POLICE_ARREST2 && PlayerInfo[playerid][pFaction] == FAC_PMA) {
		GameTextForPlayer(playerid, "~w~/arrestar aqui para arrestar.", 2000, 4);
		return 1;
		
	} else if(pickupid == P_JAIL_EAT) {
		GameTextForPlayer(playerid, "~w~Usa /carcelcomer para recibir tu bandeja con alimentos.", 2000, 4);
		return 1;

	} else if(pickupid == P_GEN_EAT) {
		GameTextForPlayer(playerid, "~w~Usa /gcomer para recibir tu bandeja con alimentos.", 2000, 4);
		return 1;

	} else if(pickupid == P_LICENSE_CENTER) {
		GameTextForPlayer(playerid, "~w~/licencias para ver las licencias disponibles. ~n~/manuales para ver los manuales.", 2000, 4);
		return 1;

	} else if(pickupid == P_POLICE_CAMERAS) {
		GameTextForPlayer(playerid, "~w~/camaras para seleccionar una camara de la ciudad.", 2000, 4);
		return 1;

	} else if(pickupid == P_HOSP_HEAL || pickupid == P_HOSP_HEAL_2) {
		new string[128];
		format(string, sizeof(string), "~w~/curarse para solicitar un medico que atienda tus heridas ($%d)", PRICE_HOSP_HEAL);
		GameTextForPlayer(playerid, string, 2000, 4);
		return 1;

	} else if(pickupid == P_CAR_DEMOLITION) {
		if(PlayerInfo[playerid][pJob] == JOB_FELON && ThiefJobInfo[playerid][pFelonLevel] >= 5)
			GameTextForPlayer(playerid, "~w~Utiliza /desarmar para desarmar el vehiculo robado.", 2000, 4);
		return 1;

	} else if(pickupid == P_CARPART_SHOP) {
		if(PlayerInfo[playerid][pFaction] == FAC_MECH)
			GameTextForPlayer(playerid, "~w~Utiliza /meccomprar para comprar repuestos de auto.", 2000, 4);
		return 1;

	} else if(pickupid == P_CAR_RENT1 || pickupid == P_CAR_RENT2 || pickupid == P_CAR_RENT3) {
		GameTextForPlayer(playerid, "~w~Alquiler de vehiculos", 2000, 4);
		return 1;


	} else if(pickupid == P_DRUGFARM_MATS) {
	    if(PlayerInfo[playerid][pJob] == JOB_DRUGF) {
	    	new string[128];
			format(string, sizeof(string), "~w~bolsas de materia prima: %d", ServerInfo[sDrugRawMats]);
		    GameTextForPlayer(playerid, string, 2000, 4);
 	    }

	} else if(pickupid == Depo_PickUp) {
        GameTextForPlayer(playerid, "~w~/sacarvehiculo aqui para retirar tu vehiculo del deposito.", 2000, 4);
		return 1;
	} else {
		if(IsBlackMarketPickup(pickupid)) {
			GameTextForPlayer(playerid, "~w~Mercado negro - Utiliza /comprar o /vender.", 2000, 4);
			return 1;
		}
	}
	Thief_Cable_OnPickup(playerid, pickupid);
	return 1;
}

SetNormalPlayerGunSkills(playerid)
{
    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 998);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 998);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 998);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 999);
}

InitiateHospital(playerid)
{
	PlayerInfo[playerid][pHospitalized] = 2;
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Debes reposar un tiempo en el hospital hasta recuperarte.");
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Antes de ser dado de alta el personal del hospital te quitará las armas y te cobrará una suma por el tratamiento recibido.");
	SetPlayerHealthEx(playerid, 16.0);
	TogglePlayerControllable(playerid, false);

	// Limpiar armas del inventario, cinturon, manos y espalda
	// Los policias en servicio que mueren no pierden las armas (no se las confiscan en el hospital)
	if(!isPlayerCopOnDuty(playerid))
	{
		// Quitar armas que tenga en las manos y en la espalda
		ResetHandsWeapons(playerid);
		Back_ResetWeapon(playerid);

		// Vaciar las armas y drogas que pudiera tener en su inventario y cinturón
		if (PlayerInfo[playerid][pContainerID] != 0) {
			Container_Empty_Weapons(PlayerInfo[playerid][pContainerID]);
			Container_Empty_Drugs(PlayerInfo[playerid][pContainerID]);
		}
		if (PlayerInfo[playerid][pBeltID] != 0) {
			Container_Empty_Weapons(PlayerInfo[playerid][pBeltID]);
			Container_Empty_Drugs(PlayerInfo[playerid][pBeltID]);
		}

		// Limpiar armas visuales del motor SAMP
		ResetPlayerWeapons(playerid);
	}

	if(random(2))
	{
		TeleportPlayerTo(playerid, 1188.4574, -1309.2242, 10.5625, 0.0, 0, 0);
		SetPlayerCameraPos(playerid, 1188.4574, -1309.2242, 13.5625 + 6.0);
		SetPlayerCameraLookAt(playerid, 1175.5581, -1324.7922, 18.1610);
		SetPVarInt(playerid, "hosp", 1);
	}
	else
	{
		TeleportPlayerTo(playerid, 1999.5308, -1449.3281, 10.5594, 0.0, 0, 0);
		SetPlayerCameraPos(playerid, 1999.5308, -1449.3281, 13.5594 + 6.0);
		SetPlayerCameraLookAt(playerid, 2036.2179, -1410.3223, 17.1641);
	    SetPVarInt(playerid, "hosp", 2);
	}

	if(GetPVarInt(playerid, "hosp") == 1)
	{
		PlayerInfo[playerid][pX] = 1188.4574;
		PlayerInfo[playerid][pY] = -1309.2242;
		PlayerInfo[playerid][pZ] = 10.5625;
		PlayerInfo[playerid][pA] = 0.0;
		PlayerInfo[playerid][pInterior] = 0;
		PlayerInfo[playerid][pVirtualWorld] = 0;
	}
	else
	{
		PlayerInfo[playerid][pX] = 1999.5308;
		PlayerInfo[playerid][pY] = -1449.3281;
		PlayerInfo[playerid][pZ] = 10.5594;
		PlayerInfo[playerid][pA] = 0.0;
		PlayerInfo[playerid][pInterior] = 0;
		PlayerInfo[playerid][pVirtualWorld] = 0;
	}
	return 1;
}

LoadServerInfo()
{
	new query[64];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT * FROM `server` WHERE `ID`=1;");
	mysql_tquery(MYSQL_HANDLE, query, "OnServerDataLoad");
	print("[INFO] Cargando datos del servidor...");
	return 1;
}

forward OnServerDataLoad();
public OnServerDataLoad()
{
	if(cache_num_rows())
	{
		cache_get_value_name_int(0, "sVehiclePricePercent", ServerInfo[sVehiclePricePercent]);
		cache_get_value_name_int(0, "sPlayersRecord", ServerInfo[sPlayersRecord]);
		cache_get_value_name_int(0, "sElogiosPorPDR", ServerInfo[sElogiosPorPDR]);
		cache_get_value_name_int(0, "svLevelExp", ServerInfo[svLevelExp]);
		cache_get_value_name_int(0, "sDrugRawMats", ServerInfo[sDrugRawMats]);
		cache_get_value_name_float(0, "biz_tax_percent", Server_BizTaxPercent);
		cache_get_value_name_float(0, "veh_tax_percent", Server_VehTaxPercent);
		cache_get_value_name_int(0, "payday_bonus", socialPay);

		print("[INFO] Carga de datos del servidor finalizada.");
	}
	return 1;
}

SaveServerInfo()
{	
    new query[256];
    mysql_format(MYSQL_HANDLE, query, sizeof(query),
        "UPDATE `server` SET `sVehiclePricePercent`=%i,`sPlayersRecord`=%i,`svLevelExp`=%i,`sDrugRawMats`=%i,`biz_tax_percent`=%f,`veh_tax_percent`=%f,`payday_bonus`=%i,`sElogiosPorPDR`=%i WHERE `ID`=1;",
        ServerInfo[sVehiclePricePercent],
        ServerInfo[sPlayersRecord],
        ServerInfo[svLevelExp],
        ServerInfo[sDrugRawMats],
        Server_BizTaxPercent,
        Server_VehTaxPercent,
        socialPay
    );
    mysql_tquery(MYSQL_HANDLE, query);

    print("[INFO] Datos del servidor guardados.");
    return 1;
}


CMD:stats(playerid, params[])
{
    if(!IsPlayerLogged(playerid))
        return false;
    
    // Query a la base de datos para traer datos de master_accounts
    new query[512];
    mysql_format(MYSQL_HANDLE, query, sizeof(query), 
        "SELECT m.id, m.username FROM master_accounts m WHERE m.id = (SELECT master_account_id FROM accounts WHERE Id = %d LIMIT 1) LIMIT 1",
        PlayerInfo[playerid][pID]
    );
    mysql_tquery(MYSQL_HANDLE, query, "ShowStatsCallback", "i", playerid);
    return 1;
}



forward ShowStatsCallback(playerid);
public ShowStatsCallback(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid))
        return 1;

    new location[MAX_ZONE_NAME], factionText[64], jobText[32];

    GetPlayer2DZone(playerid, location, MAX_ZONE_NAME);
    
    if(PlayerInfo[playerid][pFaction]) {
        format(factionText, sizeof(factionText), "Facción: %s | Rango: %s", FactionInfo[PlayerInfo[playerid][pFaction]][fName], Faction_GetRankName(PlayerInfo[playerid][pFaction], PlayerInfo[playerid][pRank]));
    } else {
        strcat(factionText, "Facción: Ninguna | Rango: Ninguno", sizeof(factionText));
    }

    if(PlayerInfo[playerid][pJob]) {
        strcat(jobText, JobInfo[PlayerInfo[playerid][pJob]][jName], sizeof(jobText));
    } else {
        strcat(jobText, "No", sizeof(jobText));
    }

    new dialog[256], string[1024], IP[20];
    new masterAccountId = 0, masterAccountName[64];
    
    GetPlayerIp(playerid, IP, 20);
    
    // Obtener datos de master_accounts
    if(cache_num_rows() > 0) {
        cache_get_value_name_int(0, "id", masterAccountId);
        cache_get_value_name(0, "username", masterAccountName, 64);
    }
    
    format(dialog, sizeof(dialog), "{2EA8E1}ID:{DBDBDB} %d\n", playerid);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Cuenta:{DBDBDB} %s (ID: %d)\n", masterAccountName, masterAccountId);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Nivel administrativo:{DBDBDB} %d\n", PlayerInfo[playerid][pAdmin]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Mundo:{DBDBDB} %d {2EA8E1}| Interior:{DBDBDB} %d\n", GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Advertencias:{DBDBDB} %d\n", PlayerInfo[playerid][pWarnings]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Puntos de rol:{DBDBDB} %d\n", PlayerInfo[playerid][pRolePoints]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Skin:{DBDBDB} %d\n", PlayerInfo[playerid][pSkin]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Ubicación:{DBDBDB} %s\n", location);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Última conexión:{DBDBDB} %s\n", PlayerInfo[playerid][pLastConnected]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), " \n");
    strcat(string, dialog);
    format(dialog, sizeof(dialog), " \n");
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Personaje:{DBDBDB} %s\n", GetPlayerCleanName(playerid));
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Nivel:{DBDBDB} %d\n", PlayerInfo[playerid][pLevel]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Experiencia:{DBDBDB} %d/%d\n", PlayerInfo[playerid][pExp], (PlayerInfo[playerid][pLevel] + 1) * ServerInfo[svLevelExp]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Tiempo de juego:{DBDBDB} %d horas\n", PlayerInfo[playerid][pTimePlayed] / 3600);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Sexo:{DBDBDB} %s\n", (PlayerInfo[playerid][pSex]) ? ("Masculino") : ("Femenino"));
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Edad:{DBDBDB} %d\n", PlayerInfo[playerid][pAge]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Efectivo:{DBDBDB} $%d\n", PlayerInfo[playerid][pCash]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Banco:{DBDBDB} $%d\n", PlayerInfo[playerid][pBank]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Telefono:{DBDBDB} %d\n", PlayerInfo[playerid][pPhoneNumber]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Empleo:{DBDBDB} %s\n", jobText);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Facción:{DBDBDB} %s {2EA8E1}| Rango:{DBDBDB} %s\n", FactionInfo[PlayerInfo[playerid][pFaction]][fName], Faction_GetRankName(PlayerInfo[playerid][pFaction], PlayerInfo[playerid][pRank]));
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Lic. Conduccion:{DBDBDB} %s {2EA8E1}| Vuelo:{DBDBDB} %s {2EA8E1}| Armas:{DBDBDB} %s\n", (PlayerInfo[playerid][pCarLic]) ? ("Si") : ("No"), (PlayerInfo[playerid][pFlyLic]) ? ("Si") : ("No"), (PlayerInfo[playerid][pWepLic]) ? ("Si") : ("No"));
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Salud:{DBDBDB} %.1f\n", GetPlayerHealthEx(playerid));
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Chaleco:{DBDBDB} %.1f\n", PlayerInfo[playerid][pArmour]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Hambre:{DBDBDB} %d {2EA8E1}| Sed:{DBDBDB} %d {2EA8E1}| Crack{DBDBDB} %d\n", PlayerInfo[playerid][pHunger], PlayerInfo[playerid][pThirst], PlayerInfo[playerid][pCrack]);
    strcat(string, dialog);
    Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "Información", string, "Aceptar", "");
    return 1;
}

forward kickTimer(playerid);
public kickTimer(playerid) {
	return Kick(playerid);
}

forward banTimer(playerid);
public banTimer(playerid) {
	return Ban(playerid);
}

forward KickPlayer(playerid, const kickedby[], const reason[]);
public KickPlayer(playerid, const kickedby[], const reason[])
{
	foreach(new i : Player)
	{
	    if(i == playerid) {
	        SendFMessage(i, COLOR_RED, "[STAFF]{FFFFFF} Has sido expulsado por %s. {E44A4A}Razón:{FFFFFF} %s", kickedby, reason);
	    } else if(PlayerInfo[i][pAdmin] > 1) {
	        SendFMessage(i, COLOR_RED, "[STAFF]{FFFFFF} %s ha sido expulsado por %s. {E44A4A}Razón:{FFFFFF} %s", GetPlayerNameEx(playerid), kickedby, reason);
	    }
	}
	SetTimerEx("kickTimer", 1000, false, "d", playerid);
	return 1;
}

forward BanPlayer(playerid, issuerid, const reason[], days);
public BanPlayer(playerid, issuerid, const reason[], days)
{
	new	issuerSQLID,
		issuerName[MAX_PLAYER_NAME],
		playerName[MAX_PLAYER_NAME],
		playerIP[16],
		str[128];
	
	if(issuerid == INVALID_PLAYER_ID)
	{
		issuerName = "el servidor";
		issuerSQLID = -1;
	}
	else
	{
		format(issuerName, sizeof(issuerName), "%s", AccountInfo[issuerid][accUsername]);
	    issuerSQLID = PlayerInfo[issuerid][pID];
	}
		
	GetPlayerName(playerid, playerName, sizeof(playerName));
	
	mysql_escape_string(issuerName, issuerName, sizeof(issuerName), MYSQL_HANDLE);
	mysql_escape_string(playerName, playerName, sizeof(playerName), MYSQL_HANDLE);
	
	GetPlayerIp(playerid, playerIP, sizeof(playerIP));

	new masterId = PlayerInfo[playerid][pMasterAccountId];
	if(masterId == 0)
	{
		masterId = MultiChar_GetMasterAccountId(playerid);
	}

	if(days == 0) // Perma ban
	{
	    days = 2000; // Una fecha lejana
		format(str, sizeof(str), "%s ha sido baneado/a permanentemente por %s, razón: %s.", playerName, issuerName, reason);
	} else {
        format(str, sizeof(str), "%s ha sido baneado/a %d días por %s, razón: %s.", playerName, days, issuerName, reason);
	}

	new query[512];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `bans` \
			(`banType`,\
			`pID`,\
			`master_account_id`,\
			`pName`,\
			`pIP`,\
			`banDate`,\
			`banEnd`,\
			`banEndUnix`,\
			`banReason`,\
			`banIssuerID`,\
			`banIssuerName`,\
			`banActive`) \
		VALUES \
			('CUENTA',%i,%i,'%s','%s',CURRENT_TIMESTAMP,TIMESTAMPADD(DAY,%i,CURRENT_TIMESTAMP),%i,'%e',%i,'%s',1);",
		PlayerInfo[playerid][pID],
		masterId,
		playerName,
		playerIP,
		days,
		gettime() + 86400 * days,
		reason,
		issuerSQLID,
		issuerName
	);
	mysql_tquery(MYSQL_HANDLE, query);

	SendClientMessageToAll(COLOR_ADMINCMD, str);
	TogglePlayerControllable(playerid, false);
	SendClientMessage(playerid, COLOR_WHITE, "Este baneo afecta a todos los personajes de tu cuenta.");
	SendClientMessage(playerid, COLOR_WHITE, "En el caso de ser un baneo temporal, serás desbaneado automaticamente por el servidor en la fecha límite.");
	SendClientMessage(playerid, COLOR_WHITE, "Para más información o para realizar un reclamo/descargo, dirígete a nuestro canal de Discord.");
	SetTimerEx("kickTimer", 1000, false, "d", playerid);
	return 1;
}

forward BanPlayerOffline(const account[MAX_PLAYER_NAME], issuerid, const reason[128], days);
forward OnBanDataLoaded(issuerid, days, const reason[128], const account[MAX_PLAYER_NAME]);
public BanPlayerOffline(const account[MAX_PLAYER_NAME], issuerid, const reason[128], days) {

	// Baneo offline por nombre de personaje (tabla accounts)
	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT `Id`, `master_account_id`, `Name`, `Ip` FROM `accounts` WHERE `Name` = '%e' LIMIT 1", account);
	mysql_tquery(MYSQL_HANDLE, query, "OnBanDataLoaded", "iiss", issuerid, days, reason, account);

	return true;
}

public OnBanDataLoaded(issuerid, days, const reason[128], const account[MAX_PLAYER_NAME]) {
	if(cache_num_rows() == 0)
	{
		if(IsPlayerConnected(issuerid))
		{
			SendFMessage(issuerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontró la cuenta '%s' en accounts.", account);
		}
		return 1;
	}

	new pid, masterId, accName[MAX_PLAYER_NAME], accIP[16];
	cache_get_value_name_int(0, "Id", pid);
	cache_get_value_name_int(0, "master_account_id", masterId);
	cache_get_value_name(0, "Name", accName, sizeof accName);
	cache_get_value_name(0, "Ip", accIP, sizeof accIP);

	new issuerName[MAX_PLAYER_NAME] = "el servidor";
	new issuerSQLID = -1;
	new issuerNameEscaped[MAX_PLAYER_NAME];
	if(IsPlayerConnected(issuerid))
	{
		format(issuerName, sizeof(issuerName), "%s", AccountInfo[issuerid][accUsername]);
		issuerSQLID = PlayerInfo[issuerid][pID];
		format(issuerNameEscaped, sizeof(issuerNameEscaped), "%s", issuerName);
		mysql_escape_string(issuerNameEscaped, issuerNameEscaped, sizeof issuerNameEscaped, MYSQL_HANDLE);
	}

	new accNameEscaped[MAX_PLAYER_NAME];
	format(accNameEscaped, sizeof(accNameEscaped), "%s", accName);
	mysql_escape_string(accNameEscaped, accNameEscaped, sizeof accNameEscaped, MYSQL_HANDLE);
	
	new accIPEscaped[16];
	format(accIPEscaped, sizeof(accIPEscaped), "%s", accIP);
	mysql_escape_string(accIPEscaped, accIPEscaped, sizeof accIPEscaped, MYSQL_HANDLE);

	if(days == 0) days = 2000; // fecha lejana para permaban

	new query[512];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `bans` \
			(`banType`,\
			`pID`,\
			`master_account_id`,\
			`pName`,\
			`pIP`,\
			`banDate`,\
			`banEnd`,\
			`banEndUnix`,\
			`banReason`,\
			`banIssuerID`,\
			`banIssuerName`,\
			`banActive`) \
		VALUES \
			('CUENTA',%i,%i,'%e','%e',CURRENT_TIMESTAMP,TIMESTAMPADD(DAY,%i,CURRENT_TIMESTAMP),%i,'%e',%i,'%e',1);",
		pid,
		masterId,
		accNameEscaped,
		(accIPEscaped[0] ? accIPEscaped : "0.0.0.0"),
		days,
		gettime() + 86400 * days,
		reason,
		issuerSQLID,
		issuerNameEscaped
	);
	mysql_tquery(MYSQL_HANDLE, query);

	new msg[256];
	if(days >= 2000)
		format(msg, sizeof msg, "[STAFF]{FFFFFF} El personaje '%s' ha sido baneado permanentemente por %s. {E44A4A}Razón:{FFFFFF} %s", accName, issuerName, reason);
	else
		format(msg, sizeof msg, "[STAFF]{FFFFFF} El personaje '%s' ha sido baneado por %d días por %s. {E44A4A}Razón:{FFFFFF} %s", accName, days, issuerName, reason);
	AdministratorMessage(COLOR_RED, msg, 2);
	return 1;
}

// ==================== NUEVAS FUNCIONES DE BANEO ====================

stock BanAccount(playerid, issuerid, const reason[], days)
{
	// Banea toda la cuenta maestra (todos los personajes)
	new	issuerSQLID,
		issuerName[MAX_PLAYER_NAME],
		playerName[MAX_PLAYER_NAME],
		playerIP[16],
		str[256];
	
	if(issuerid == INVALID_PLAYER_ID)
	{
		issuerName = "el servidor";
		issuerSQLID = -1;
	}
	else
	{
		format(issuerName, sizeof(issuerName), "%s", AccountInfo[issuerid][accUsername]);
	    issuerSQLID = PlayerInfo[issuerid][pID];
	}
		
	GetPlayerName(playerid, playerName, sizeof(playerName));
	mysql_escape_string(issuerName, issuerName, sizeof(issuerName), MYSQL_HANDLE);
	mysql_escape_string(playerName, playerName, sizeof(playerName), MYSQL_HANDLE);
	GetPlayerIp(playerid, playerIP, sizeof(playerIP));

	new masterId = PlayerInfo[playerid][pMasterAccountId];
	if(masterId <= 0)
	{
		return SendClientMessage(issuerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este jugador no tiene una cuenta maestra.");
	}

	if(days == 0) days = 2000; // Perma ban

	new query[512];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `bans` \
			(`banType`,\
			`pID`,\
			`master_account_id`,\
			`pName`,\
			`pIP`,\
			`banDate`,\
			`banEnd`,\
			`banEndUnix`,\
			`banReason`,\
			`banIssuerID`,\
			`banIssuerName`,\
			`banActive`) \
		VALUES \
			('CUENTA',%i,%i,'%e','%e',CURRENT_TIMESTAMP,TIMESTAMPADD(DAY,%i,CURRENT_TIMESTAMP),%i,'%e',%i,'%e',1);",
		PlayerInfo[playerid][pID],
		masterId,
		playerName,
		playerIP,
		days,
		gettime() + 86400 * days,
		reason,
		issuerSQLID,
		issuerName
	);
	mysql_tquery(MYSQL_HANDLE, query);

	new accountName[64];
	format(accountName, sizeof(accountName), "%s", AccountInfo[playerid][accUsername]);
	
	if(days >= 2000)
		format(str, sizeof(str), "[STAFF]{FFFFFF} La cuenta '%s' ha sido baneada permanentemente por %s. {E44A4A}Razón:{FFFFFF} %s", accountName, issuerName, reason);
	else
		format(str, sizeof(str), "[STAFF]{FFFFFF} La cuenta '%s' ha sido baneada por %d días por %s. {E44A4A}Razón:{FFFFFF} %s", accountName, days, issuerName, reason);

	SendClientMessageToAll(COLOR_RED, str);
	TogglePlayerControllable(playerid, false);
	SendClientMessage(playerid, COLOR_WHITE, "Este baneo afecta a TODA tu cuenta maestra y todos tus personajes.");
	SendClientMessage(playerid, COLOR_WHITE, "En el caso de ser un baneo temporal, serás desbaneado automaticamente por el servidor en la fecha límite.");
	SendClientMessage(playerid, COLOR_WHITE, "Para más información o para realizar un reclamo/descargo, dirígete a nuestro canal de Discord.");
	SetTimerEx("kickTimer", 1000, false, "d", playerid);
	return 1;
}

forward BanAccountOffline(const username[64], issuerid, const reason[128], days);
forward OnBanAccountDataLoaded(issuerid, days, const reason[128], const username[64]);
public BanAccountOffline(const username[64], issuerid, const reason[128], days) 
{
	// Baneo offline por nombre de usuario de la cuenta maestra
	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT `id`, `username`, `last_ip` FROM `master_accounts` WHERE `username` = '%e' LIMIT 1", username);
	mysql_tquery(MYSQL_HANDLE, query, "OnBanAccountDataLoaded", "iiss", issuerid, days, reason, username);
	return true;
}

public OnBanAccountDataLoaded(issuerid, days, const reason[128], const username[64]) 
{
	if(cache_num_rows() == 0)
	{
		if(IsPlayerConnected(issuerid))
		{
			SendFMessage(issuerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontró la cuenta maestra '%s'.", username);
		}
		return 1;
	}

	new masterId, masterUsername[64], masterIP[16];
	cache_get_value_name_int(0, "id", masterId);
	cache_get_value_name(0, "username", masterUsername, sizeof(masterUsername));
	cache_get_value_name(0, "last_ip", masterIP, sizeof(masterIP));

	new issuerName[MAX_PLAYER_NAME] = "el servidor";
	new issuerSQLID = -1;
	new issuerNameEscaped[MAX_PLAYER_NAME];
	if(IsPlayerConnected(issuerid))
	{
		format(issuerName, sizeof(issuerName), "%s", AccountInfo[issuerid][accUsername]);
		issuerSQLID = PlayerInfo[issuerid][pID];
		format(issuerNameEscaped, sizeof(issuerNameEscaped), "%s", issuerName);
		mysql_escape_string(issuerNameEscaped, issuerNameEscaped, sizeof(issuerNameEscaped), MYSQL_HANDLE);
	}
	else
	{
		format(issuerNameEscaped, sizeof(issuerNameEscaped), "%s", issuerName);
	}

	mysql_escape_string(masterUsername, masterUsername, sizeof(masterUsername), MYSQL_HANDLE);
	mysql_escape_string(masterIP, masterIP, sizeof(masterIP), MYSQL_HANDLE);

	if(days == 0) days = 2000;

	new query[512];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `bans` \
			(`banType`,\
			`pID`,\
			`master_account_id`,\
			`pName`,\
			`pIP`,\
			`banDate`,\
			`banEnd`,\
			`banEndUnix`,\
			`banReason`,\
			`banIssuerID`,\
			`banIssuerName`,\
			`banActive`) \
		VALUES \
			('CUENTA',0,%i,'%e','%e',CURRENT_TIMESTAMP,TIMESTAMPADD(DAY,%i,CURRENT_TIMESTAMP),%i,'%e',%i,'%e',1);",
		masterId,
		masterUsername,
		(masterIP[0] ? masterIP : "0.0.0.0"),
		days,
		gettime() + 86400 * days,
		reason,
		issuerSQLID,
		issuerNameEscaped
	);
	mysql_tquery(MYSQL_HANDLE, query);

	new msg[256];
	if(days >= 2000)
		format(msg, sizeof msg, "[STAFF]{FFFFFF} La cuenta '%s' ha sido baneada permanentemente por %s. {E44A4A}Razón:{FFFFFF} %s", masterUsername, issuerName, reason);
	else
		format(msg, sizeof msg, "[STAFF]{FFFFFF} La cuenta '%s' ha sido baneada por %d días por %s. {E44A4A}Razón:{FFFFFF} %s", masterUsername, days, issuerName, reason);
	
	SendClientMessageToAll(COLOR_RED, msg);
	return 1;
}

forward BanIP(const ip[16], issuerid, const reason[128], days);
public BanIP(const ip[16], issuerid, const reason[128], days)
{
	// Banea una IP específica
	new	issuerSQLID,
		issuerName[MAX_PLAYER_NAME],
		escapedIP[16],
		str[256];
	
	if(issuerid == INVALID_PLAYER_ID)
	{
		issuerName = "el servidor";
		issuerSQLID = -1;
	}
	else
	{
		format(issuerName, sizeof(issuerName), "%s", AccountInfo[issuerid][accUsername]);
	    issuerSQLID = PlayerInfo[issuerid][pID];
	}
	
	mysql_escape_string(issuerName, issuerName, sizeof(issuerName), MYSQL_HANDLE);
	format(escapedIP, sizeof(escapedIP), "%s", ip);
	mysql_escape_string(escapedIP, escapedIP, sizeof(escapedIP), MYSQL_HANDLE);

	if(days == 0) days = 2000; // Perma ban

	new query[512];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `bans` \
			(`banType`,\
			`pID`,\
			`master_account_id`,\
			`pName`,\
			`pIP`,\
			`banDate`,\
			`banEnd`,\
			`banEndUnix`,\
			`banReason`,\
			`banIssuerID`,\
			`banIssuerName`,\
			`banActive`) \
		VALUES \
			('IP',0,0,'IP BAN','%e',CURRENT_TIMESTAMP,TIMESTAMPADD(DAY,%i,CURRENT_TIMESTAMP),%i,'%e',%i,'%e',1);",
		escapedIP,
		days,
		gettime() + 86400 * days,
		reason,
		issuerSQLID,
		issuerName
	);
	mysql_tquery(MYSQL_HANDLE, query);

	if(days >= 2000)
		format(str, sizeof(str), "[STAFF]{FFFFFF} La IP '%s' ha sido baneada permanentemente por %s. {E44A4A}Razón:{FFFFFF} %s", ip, issuerName, reason);
	else
		format(str, sizeof(str), "[STAFF]{FFFFFF} La IP '%s' ha sido baneada por %d días por %s. {E44A4A}Razón:{FFFFFF} %s", ip, days, issuerName, reason);

	SendClientMessageToAll(COLOR_RED, str);
	
	// Kickear a todos los jugadores con esa IP
	foreach(new i : Player)
	{
		new playerIP[16];
		GetPlayerIp(i, playerIP, sizeof(playerIP));
		if(strcmp(playerIP, ip, false) == 0)
		{
			SendClientMessage(i, COLOR_WHITE, "Tu IP ha sido baneada del servidor.");
			SendClientMessage(i, COLOR_WHITE, "Para más información o para realizar un reclamo/descargo, dirígete a nuestro canal de Discord.");
			SetTimerEx("kickTimer", 1000, false, "d", i);
		}
	}
	
	return 1;
}

stock BanCharacter(playerid, issuerid, const reason[], days)
{
	// Banea solo el personaje específico (no la cuenta maestra)
	new	issuerSQLID,
		issuerName[MAX_PLAYER_NAME],
		playerName[MAX_PLAYER_NAME],
		playerIP[16],
		str[256];
	
	if(issuerid == INVALID_PLAYER_ID)
	{
		issuerName = "el servidor";
		issuerSQLID = -1;
	}
	else
	{
		format(issuerName, sizeof(issuerName), "%s", AccountInfo[issuerid][accUsername]);
	    issuerSQLID = PlayerInfo[issuerid][pID];
	}
		
	GetPlayerName(playerid, playerName, sizeof(playerName));
	mysql_escape_string(issuerName, issuerName, sizeof(issuerName), MYSQL_HANDLE);
	mysql_escape_string(playerName, playerName, sizeof(playerName), MYSQL_HANDLE);
	GetPlayerIp(playerid, playerIP, sizeof(playerIP));

	new masterId = PlayerInfo[playerid][pMasterAccountId];

	if(days == 0) days = 2000; // Perma ban

	new query[512];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `bans` \
			(`banType`,\
			`pID`,\
			`master_account_id`,\
			`pName`,\
			`pIP`,\
			`banDate`,\
			`banEnd`,\
			`banEndUnix`,\
			`banReason`,\
			`banIssuerID`,\
			`banIssuerName`,\
			`banActive`) \
		VALUES \
			('PERSONAJE',%i,%i,'%e','%e',CURRENT_TIMESTAMP,TIMESTAMPADD(DAY,%i,CURRENT_TIMESTAMP),%i,'%e',%i,'%e',1);",
		PlayerInfo[playerid][pID],
		masterId,
		playerName,
		playerIP,
		days,
		gettime() + 86400 * days,
		reason,
		issuerSQLID,
		issuerName
	);
	mysql_tquery(MYSQL_HANDLE, query);

	if(days >= 2000)
		format(str, sizeof(str), "[STAFF]{FFFFFF} El personaje '%s' ha sido baneado permanentemente por %s. {E44A4A}Razón:{FFFFFF} %s", playerName, issuerName, reason);
	else
		format(str, sizeof(str), "[STAFF]{FFFFFF} El personaje '%s' ha sido baneado por %d días por %s. {E44A4A}Razón:{FFFFFF} %s", playerName, days, issuerName, reason);

	SendClientMessageToAll(COLOR_RED, str);
	TogglePlayerControllable(playerid, false);
	SendClientMessage(playerid, COLOR_WHITE, "Este baneo afecta solo a este personaje, puedes usar otros personajes de tu cuenta.");
	SendClientMessage(playerid, COLOR_WHITE, "En el caso de ser un baneo temporal, serás desbaneado automaticamente por el servidor en la fecha límite.");
	SendClientMessage(playerid, COLOR_WHITE, "Para más información o para realizar un reclamo/descargo, dirígete a nuestro canal de Discord.");
	SetTimerEx("kickTimer", 1000, false, "d", playerid);
	return 1;
}

forward BanCharacterOffline(const account[MAX_PLAYER_NAME], issuerid, const reason[128], days);
forward OnBanCharacterDataLoaded(issuerid, days, const reason[128], const account[MAX_PLAYER_NAME]);
public BanCharacterOffline(const account[MAX_PLAYER_NAME], issuerid, const reason[128], days) 
{
	// Baneo offline por nombre de personaje (tabla accounts)
	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT `Id`, `master_account_id`, `Name`, `Ip` FROM `accounts` WHERE `Name` = '%e' LIMIT 1", account);
	mysql_tquery(MYSQL_HANDLE, query, "OnBanCharacterDataLoaded", "iiss", issuerid, days, reason, account);
	return true;
}

public OnBanCharacterDataLoaded(issuerid, days, const reason[128], const account[MAX_PLAYER_NAME]) 
{
	if(cache_num_rows() == 0)
	{
		if(IsPlayerConnected(issuerid))
		{
			SendFMessage(issuerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontró el personaje '%s'.", account);
		}
		return 1;
	}

	new pid, masterId, accName[MAX_PLAYER_NAME], accIP[16];
	cache_get_value_name_int(0, "Id", pid);
	cache_get_value_name_int(0, "master_account_id", masterId);
	cache_get_value_name(0, "Name", accName, sizeof accName);
	cache_get_value_name(0, "Ip", accIP, sizeof accIP);

	new issuerName[MAX_PLAYER_NAME] = "el servidor";
	new issuerSQLID = -1;
	new issuerNameEscaped[MAX_PLAYER_NAME];
	if(IsPlayerConnected(issuerid))
	{
		format(issuerName, sizeof(issuerName), "%s", AccountInfo[issuerid][accUsername]);
		issuerSQLID = PlayerInfo[issuerid][pID];
		format(issuerNameEscaped, sizeof(issuerNameEscaped), "%s", issuerName);
		mysql_escape_string(issuerNameEscaped, issuerNameEscaped, sizeof issuerNameEscaped, MYSQL_HANDLE);
	}
	else
	{
		format(issuerNameEscaped, sizeof(issuerNameEscaped), "%s", issuerName);
	}

	mysql_escape_string(accName, accName, sizeof accName, MYSQL_HANDLE);
	mysql_escape_string(accIP, accIP, sizeof accIP, MYSQL_HANDLE);

	if(days == 0) days = 2000;

	new query[512];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `bans` \
			(`banType`,\
			`pID`,\
			`master_account_id`,\
			`pName`,\
			`pIP`,\
			`banDate`,\
			`banEnd`,\
			`banEndUnix`,\
			`banReason`,\
			`banIssuerID`,\
			`banIssuerName`,\
			`banActive`) \
		VALUES \
			('PERSONAJE',%i,%i,'%e','%e',CURRENT_TIMESTAMP,TIMESTAMPADD(DAY,%i,CURRENT_TIMESTAMP),%i,'%e',%i,'%e',1);",
		pid,
		masterId,
		accName,
		(accIP[0] ? accIP : "0.0.0.0"),
		days,
		gettime() + 86400 * days,
		reason,
		issuerSQLID,
		issuerNameEscaped
	);
	mysql_tquery(MYSQL_HANDLE, query);

	new msg[256];
	if(days >= 2000)
		format(msg, sizeof msg, "[STAFF]{FFFFFF} El personaje '%s' ha sido baneado permanentemente por %s. {E44A4A}Razón:{FFFFFF} %s", accName, issuerName, reason);
	else
		format(msg, sizeof msg, "[STAFF]{FFFFFF} El personaje '%s' ha sido baneado por %d días por %s. {E44A4A}Razón:{FFFFFF} %s", accName, days, issuerName, reason);
	
	SendClientMessageToAll(COLOR_RED, msg);
	return 1;
}

public healTimer(playerid) {
    // Solo cancelar si NO está en proceso de curación (healTimerId == 0)
    if(GetPVarInt(playerid, "healTimerId") != 0)
        return 1; // Ya está curando, ignorar timeout de oferta
    
    if(GetPVarInt(playerid, "isHealing") != 0)
    {
        SendClientMessage(playerid, COLOR_WHITE, "Tu oferta se ha cancelado, el herido no la ha aceptado.");
        SendClientMessage(GetPVarInt(playerid, "healTarget"), COLOR_WHITE, "Ha pasado demasiado tiempo y has rechazado la oferta del médico.");
    }
    DeletePVar(DeletePVar(playerid, "healTarget"), "healIssuer");
    DeletePVar(DeletePVar(playerid, "healTarget"), "healCost");
    DeletePVar(playerid, "isHealing");
    DeletePVar(playerid, "healTarget");
    DeletePVar(playerid, "healOfferTimerId");
    return 1;
}

ResetPlayerWantedLevelEx(playerid)
{
	PlayerInfo[playerid][pAccusedOf][0] = EOS;
	strcat(PlayerInfo[playerid][pAccusedOf], "Sin cargos", 64);
	PlayerInfo[playerid][pAccusedBy][0] = EOS;
	strcat(PlayerInfo[playerid][pAccusedBy], "Nadie", 24);
	PlayerInfo[playerid][pWantedLevel] = 0;
	return 1;
}

SetPlayerWantedLevelEx(playerid, level) {
	PlayerInfo[playerid][pWantedLevel] = level;
}

GetPlayerWantedLevelEx(playerid) {
	return PlayerInfo[playerid][pWantedLevel];
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_JUMP && !(oldkeys & KEY_JUMP) && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED) {
		ApplyAnimationEx(playerid, "GYMNASIUM", "gym_jog_falloff", 4.1, 0, 1, 1, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
	}

	if(KEY_PRESSED_SINGLE(KEY_WALK))
	{
		if(J_Garb_OnPlayerPressKeyWalk(playerid)) {
		    return 1;
		}
    }

	if(KEY_PRESSED_SINGLE(KEY_ACTION))
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new vehicleid = GetPlayerVehicleID(playerid);

			if(GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510)
			{
				RemovePlayerFromVehicle(playerid);
				SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
			}
		}
	}
	return 1;
}

forward Unfreeze(playerid);
public Unfreeze(playerid)
{
	TogglePlayerControllable(playerid, true);
    return 1;
}

public OnPlayerUpdate(playerid) {
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) { // Dont handle dialogs here, use easyDialogs
    return 0;
}

CMD:pos(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:a, vehicleid;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	SendFMessage(playerid, COLOR_WHITE, "Tu posición es [X: %.2f - Y: %.2f - Z: %.2f - Angle: %.2f - Int: %i - VWorld: %i]", x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

	if((vehicleid = GetPlayerVehicleID(playerid)))
	{
		GetVehiclePos(vehicleid, x, y, z);
		GetVehicleZAngle(vehicleid, a);
		SendFMessage(playerid, COLOR_WHITE, "La posición de tu vehículo es [X: %.2f - Y: %.2f - Z: %.2f - Angle: %.2f - Int: %i - VWorld: %i]", x, y, z, a, GetPlayerInterior(playerid), GetVehicleVirtualWorld(vehicleid));
	}
	return 1;
}

/*
// SISTEMA ANTIGUO - COMENTADO (Ahora en marp_dudas_reportes.pwn)
CMD:duda(playerid,params[])
{
	new string[144], string2[200];
	
	if(sscanf(params, "s[144]", string))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/duda [texto]");

	SendClientMessage(playerid, COLOR_INFO, "[INFO]" COLOR_EMB_GREY" La duda ha sido enviada. Recuerda que si tenías otra duda antes, será reemplazada por la última.");
	PlayerInfo[playerid][pQuestion][0] = EOS;
	strcat(PlayerInfo[playerid][pQuestion], string, 144);
	PlayerInfo[playerid][pHaveQuestion] = 1;
	format(string2, sizeof(string2), "[DUDA] %s (ID: %i): "COLOR_EMB_GREY" %s", GetPlayerCleanName(playerid), playerid, string);
	AdministratorMessage(COLOR_DOUBT, string2, 1);
	return 1;
}
*/

/*
// SISTEMA ANTIGUO - COMENTADO (Ahora en marp_dudas_reportes.pwn)
CMD:reportar(playerid,params[])
{
	new id,
		string[256],
		reason[256];
		
	if(sscanf(params, "us[256]", id, reason))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/reportar [ID/ParteDelNombre] [razón]");
	if(!IsPlayerConnected(id))
	    return SendClientMessage(playerid, COLOR_ERROR,"[ERROR] "COLOR_EMB_GREY" nombre incorrecto o el jugador no se encuentra conectado.");

	PlayerInfo[playerid][pReport]=1;
	format(PlayerInfo[playerid][pReportReason], 256, "%s", reason);
	format(string, sizeof(string), "[Reporte] %s (%d) ha reportado a %s (%d), razón: %s", GetPlayerCleanName(playerid), playerid, GetPlayerCleanName(id), id, PlayerInfo[playerid][pReportReason]);
	AdministratorMessage(COLOR_ADMINCMD, string, 2);
	
	format(string, sizeof(string), "Has reportado a %s (ID:%d), razón: %s", GetPlayerCleanName(id), id, reason);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}
*/


IsPlayerLogged(playerid) {
	return (IsPlayerConnected(playerid) && gPlayerLogged[playerid]);
}

CMD:ayuda(playerid)
{
    return Help_Show(playerid);
}

Help_Show(playerid) {
    Dialog_Show(playerid, DLG_HELP, DIALOG_STYLE_LIST,
        "Soporte sobre el servidor", "Cuenta\nGeneral\nTrabajos\nFacciones\nVehículos\nCasas\nNegocios", "Ver", "Salir");
    return true;
}

Dialog:DLG_HELP(playerid, response, listitem, inputtext[]) {
    if(!response)
        return true;
    
    switch(listitem)
    {
        case 0: Help_ShowAccount(playerid);
        case 1: Help_ShowGeneral(playerid);
        case 2: Help_ShowJobs(playerid);
        case 3: Help_ShowFactions(playerid);
        case 4: Help_ShowVehicles(playerid);
        case 5: Help_ShowHouses(playerid);
        case 6: Help_ShowBusiness(playerid);
    }
    return true;
}

Help_ShowAccount(playerid) {
    new str[512];
    strcat(str, "Comandos disponibles:\n\n");
    strcat(str, "/changepass, /toggle, /stats, /verpago, /hora\n");

    Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
    return true;
}

Help_ShowGeneral(playerid) {
    new str[1024];
    strcat(str, "Comandos disponibles:\n\n");
    strcat(str, "/ayuda, /desbug, /duda, /reportar, /admins\n\n");

    strcat(str, "/comprar, /vender, /cla, /pagar, /moneda, /dado, /entorno (llamado a 911)\n");
    strcat(str, "/mostrardoc, /mostrarlic, /mostrarced, /anim(aciones), /descripcion, /plantacion, /tiempoplantacion\n");
    strcat(str, "/saludar, /examinar, /garajepuerta, /edificiopuerta, /ayudafutbol\n\n");

    strcat(str, "/inventario, /tirar(i), /guardar(i), /agarrar(i), /mano, /esp(alda), /pecho \n");
    strcat(str, "/agarraruno, /combinar, /separar, /sacar\n\n");

    strcat(str, "/tel(efono), /servicios\n\n");
    
    strcat(str, "/mp, /vb, /g, /sus, /ame, /me, /do, /dop, /gooc, /b, /limpiarchat, /solidchat, /verdesc\n\n");

    strcat(str, "/verbalance, /depositar, /retirar, /transferir\n");

    Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
    
    return true;
}

Help_ShowJobs(playerid) {
    if(PlayerInfo[playerid][pJob] == 1)
    {
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/trabajar, /terminar, /tomarempleo, /verempleo, /dejarempleo, /consultarempleo\n\n");

        strcat(str, "Perteneces al trabajo de Moto Delivery, deberás realizar entregas en distintos puntos del mapa.\n");
        strcat(str, "Tu personaje tiene una reputación laboral que se verá afectada según su desempeño. ¡Cuídala o te pueden despedir!\n");

        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
    else if(PlayerInfo[playerid][pJob] == 2)
    {
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/trabajar, /terminar, /tomarempleo, /verempleo, /dejarempleo, /consultarempleo, /taxiverllamadas, /taxicancelar, /taximetro\n\n");

        strcat(str, "Perteneces al trabajo de Taxista, deberás esperar clientes y trasladarlos por la ciudad.\n");
        strcat(str, "Tu personaje tiene una reputación laboral que se verá afectada según su desempeño. ¡Cuídala o te pueden despedir!\n");

        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
    else if(PlayerInfo[playerid][pJob] == 3)
    {
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/trabajar, /terminar, /tomarempleo, /verempleo, /dejarempleo, /consultarempleo\n\n");

        strcat(str, "Perteneces al trabajo de Granjero, debés cosechar la granja con una cosechadora. Una vez termines, entregarás el producto cosechado.\n");
        strcat(str, "Tu personaje tiene una reputación laboral que se verá afectada según su desempeño. ¡Cuídala o te pueden despedir!\n");

        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
    else if(PlayerInfo[playerid][pJob] == 4)
    {
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/trabajar, /terminar, /tomarempleo, /verempleo, /dejarempleo, /consultarempleo\n\n");

        strcat(str, "Perteneces al trabajo de Transportista, debés recorrer la ciudad rellenando la mercadería de los negocios.\n");
        strcat(str, "Tu personaje tiene una reputación laboral que se verá afectada según su desempeño. ¡Cuídala o te pueden despedir!\n");

        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
    else if(PlayerInfo[playerid][pJob] == 5)
    {        
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/basurerocomenzar, /basureroinvitar, /tomarempleo, /basurerocancelar, /basurerorenunciar, /basureroinfo\n\n");

        strcat(str, "Perteneces al trabajo de Basurero, debés recorrer la ciudad recogiendo la basura de los distintos contenedores existentes.\n");
        strcat(str, "Tu personaje tiene una reputación laboral que se verá afectada según su desempeño. ¡Cuídala o te pueden despedir!\n");

        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
    else if(PlayerInfo[playerid][pJob] == 6)
    {
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/hurtar, /asaltartienda, /carterista, /hurtarcasa, /asaltarcasa, /barreta, /puente, /desarmar, /robarcables, /grupoayuda\n\n");

        strcat(str, "Perteneces al trabajo de Delincuente, este es el trabajo más solicitado en el servidor.\n");
        strcat(str, "Deberás ganarte la vida ilegalmente, no te puedes fiar de nada ni nadie. Ten mucho cuidado con la policía, también ..\n");
        strcat(str, ".. recuerda que hay cámaras en la ciudad.\n");
        strcat(str, "A medida que vayas realizando crímenes, obtendrás mayor experiencia y podrás realizar otros de mayor remuneración.\n");

        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
    else if(PlayerInfo[playerid][pJob] == 7)
    {
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/trabajar, /terminar, /tomarempleo, /verempleo, /dejarempleo, /consultarempleo, /ar\n\n");

        strcat(str, "Perteneces al trabajo de Aviador, debés realizar vuelos comerciales con un avión.\n");
        strcat(str, "Tu personaje tiene una reputación laboral que se verá afectada según su desempeño. ¡Cuídala o te pueden despedir!\n");

        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
    }
    else if(PlayerInfo[playerid][pJob] == 8)
    {
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/trabajar, /terminar, /tomarempleo, /verempleo, /dejarempleo, /consultarempleo\n\n");

        strcat(str, "Perteneces al trabajo de Colectivero, debés recorrer la ciudad transportando pasajeros entre las distintas paradas.\n");
        strcat(str, "Tu personaje tiene una reputación laboral que se verá afectada según su desempeño. ¡Cuídala o te pueden despedir!\n");

        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
	else if(PlayerInfo[playerid][pJob] == 9)
    {
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/trabajar, /terminar, /electricistainfo, /tomarempleo, /verempleo, /dejarempleo, /consultarempleo\n\n");

        strcat(str, "Perteneces al trabajo de Electricista, debés recorrer la ciudad arreglando postes de electricidad.\n");
        strcat(str, "Tu personaje tiene una reputación laboral que se verá afectada según su desempeño. ¡Cuídala o te pueden despedir!\n");

        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
    else
    {
        new str[512];

        strcat(str, "Tu personaje está desempleado. Encontrarás muchos trabajos a lo largo de la ciudad.\n\n");
        strcat(str, "NOTA: Recuerda que el modo fácil de ganar dinero es mediante sistema, pero no olvides ..\n");
        strcat(str, ".. que puedes amasar una fortuna roleando. ¡Busca otras alternativas también!\n");

        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }

    return true;
}

Help_ShowFactions(playerid) {
			
    if(PlayerInfo[playerid][pFaction] > 6)
    {
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/fac, /fverbalance, /fdepositar, /fretirar, /traficar\n");
		if(Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_ALLOW_GRAFITI)){
			strcat(str, "/grafiti, /borrargrafiti\n");
		}
        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
    else if(PlayerInfo[playerid][pFaction] == FAC_PMA)
    {
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/fac, /fverbalance, /fdepositar, /fretirar, /f, /r\n");
        strcat(str, "/equipar, /propero, /pservicio, /sosp, /(m)egafono, /arrestar, /esposar, /verpatente\n");
        strcat(str, "/quitaresposas, /revisar, /camaras, /quitar, /multar, /premolcar, /arrastrar, /central\n");
        strcat(str, "/refuerzos, /ult, /vercargos, /buscados, /localizar, /pipeta, /deposito, /verantecedentes\n");
        strcat(str, "/geof, /verregistros, /comprarinsumos, /guardarinsumos, /verinsumos, /pautorizar, /computador, /callsign\n");
        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
    else if(PlayerInfo[playerid][pFaction] == FAC_SIDE)
    {
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/fac, /fverbalance, /fdepositar, /fretirar, /f, /r\n");
        strcat(str, "/equipar, /gropero, /gservicio, /sosp, /(m)egafono, /arrestar, /esposar, /verpatente\n");
        strcat(str, "/quitaresposas, /revisar, /quitar, /multar, /premolcar, /arrastrar, /gcentral\n");
        strcat(str, "/(ref)uerzos, /ult, /vercargos, /buscados, /localizar, /pipeta, /deposito, /verantecedentes\n");
        strcat(str, "/alacran, /verregistros, /comprarinsumos, /guardarinsumos, /verinsumos, /pautorizar, /callsign\n");
        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
    else if(PlayerInfo[playerid][pFaction] == FAC_HOSP)
    {
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/fac, /fverbalance, /fdepositar, /fretirar, /f, /r, /comprarinsumos, /guardarinsumos, /verinsumos\n");
        strcat(str, "/mservicio, /gobierno, (/d)epartamento, (/ult)imallamada, /curar, /callsign, LÍDER: /verregcurar, /verregistros");
        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
    else if(PlayerInfo[playerid][pFaction] == FAC_MECH)
    {
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/fac, /fverbalance, /fdepositar, /fretirar, /f, /r\n");
        strcat(str, "/mecremolcar, /mecreparar, /mectunear, /mecdestunear, /meccerradura");
        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
    else if(PlayerInfo[playerid][pFaction] == FAC_MAN)
    {
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/fac, /fverbalance, /fdepositar, /fretirar, /f, /r\n");
        strcat(str, "/(n)oticia, /entrevistar, /pronostico");
        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
    else if(PlayerInfo[playerid][pFaction] == FAC_GOB)
    {
        new str[512];

        strcat(str, "Comandos disponibles:\n\n");
        strcat(str, "/fac, /fverbalance, /fdepositar, /fretirar, /f, /r\n");
        strcat(str, "/verconectados, /verpresos, /verantecedentes, /departamento, /liberar, /ppreventiva, /gobierno, /callsign, /plansocial, /gestionarimpuestos");
        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
    else
    {
        new str[512];

        strcat(str, "Tu personaje está desempleado. Encontrarás muchas facciones en la ciudad.\n\n");
        strcat(str, "NOTA: Disfrutamos que los jugadores fomenten al juego de rol con facciones ..\n");
        strcat(str, ".. recuerda que puedes postularte a crear la tuya o unirte a otras ya existentes. ¡Nunca es tarde!\n");

        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
        return true;
    }
}

Help_ShowVehicles(playerid) {
    new str[512];

    strcat(str, "Comandos disponibles:\n\n");
    strcat(str, "/motor, /vehpuertas, /vehestacionar, /vehluces, /vehvender, /vehvendera\n");
    strcat(str, "/vehmal, /mal(etero), /vehcapot, /vent(anilla), /cint(uron), /vercint(uron)\n");
    strcat(str, "/vehradio, /llavero, /sacar, /carreraayuda, /cambiarrueda, /verkm\n");
    strcat(str, "/rentar (en vehículo de renta), /rentarbici (en zona de renta de bicis)\n");
    
    Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
    return true;
}

Help_ShowBusiness(playerid) {
    new str[512];

    strcat(str, "Comandos disponibles:\n\n");
    strcat(str, "/negociocomprar, /negociovender, /negociovendera, /negociogestionar, /negocionombre\n");
    strcat(str, "/negociocaja, /negociollave, /negocioradio, /negociocontratar, /negociodespedir\n");
    strcat(str, "/negociorenunciar, /negociotrabajo (desde el interior)\n");
    
    Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
    return true;
}

Help_ShowHouses(playerid) {
    new str[512];

    strcat(str, "Comandos disponibles:\n\n");
    strcat(str, "/casacomprar, /casavender, /casavendera, /casaalquilar, /casadesalquilar, /casaradio\n");
    strcat(str, "/casallave, /casaenalquiler, /casasinalquiler, /casacontrato, /puerta, /armario\n");
    strcat(str, "/casavisitar, /casadomicilio\n");
    
    Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "Panel de ayuda", str, "Cerrar", "");
    return true;
}
	/*
    SendClientMessage(playerid, COLOR_USAGE, " ");
    SendClientMessage(playerid, COLOR_USAGE, "[Administración] "COLOR_EMB_GREY" /reportar /duda");
	SendClientMessage(playerid, COLOR_USAGE, "[General] "COLOR_EMB_GREY" /stats /hora /dar(i) /usar(i) /agarrar(i) /mano /comprar (/cla)sificado /pagar /toy /dado /moneda");
	SendClientMessage(playerid, COLOR_USAGE, "[General] "COLOR_EMB_GREY" /mostrardoc /bidon /mostrarlic /mostrarced (/inv)entario /pecho (/esp)alda /llenar /changepass");
	SendClientMessage(playerid, COLOR_USAGE, "[General] "COLOR_EMB_GREY" /yo /donar /desafiarpicada /comprarmascara /saludar /examinar (/anim)aciones /admins /blackjack");
	SendClientMessage(playerid, COLOR_USAGE, "[Chat] "COLOR_EMB_GREY" /mp /vb /local (/g)ritar /(sus)urrar /me /do /dop /cme /gooc /toggle /limpiarchat /solidchat");
	SendClientMessage(playerid, COLOR_USAGE, "[Teléfono] "COLOR_EMB_GREY" (/tel)efono /servicios");
	SendClientMessage(playerid, COLOR_USAGE, "[Propiedades] "COLOR_EMB_GREY" /ayudacasa /ayudanegocio /ayudabanco /ayudacajero");
	SendClientMessage(playerid, COLOR_USAGE, "[Vehículo] "COLOR_EMB_GREY" (/veh)iculo");
	SendClientMessage(playerid, COLOR_USAGE, "[Garajes] "COLOR_EMB_GREY" (/garajepuerta");
	SendClientMessage(playerid, COLOR_USAGE, "[Fútbol]"COLOR_EMB_GREY "/iniciarpartido /finalizarpartido");

    if(PlayerInfo[playerid][pFaction] != 0)
	{
    	SendClientMessage(playerid, COLOR_USAGE, "[Facción] "COLOR_EMB_GREY" /f /faccion /fdepositar");
		if(PlayerInfo[playerid][pFaction] == FAC_PMA) {
		    SendClientMessage(playerid, COLOR_USAGE, "[PMA] "COLOR_EMB_GREY" /ayudap /gobierno /departamento");

		} else if(PlayerInfo[playerid][pFaction] == FAC_SIDE) {
 	   		SendClientMessage(playerid, COLOR_USAGE, "[GENDARMERÍA] "COLOR_EMB_GREY" /gservicio /gchaleco /equipar /gropero /esposar /quitaresposas /revisar /sosp");
			SendClientMessage(playerid, COLOR_USAGE, "[GENDARMERÍA] "COLOR_EMB_GREY" /arrastrar (/ref)uerzos /vercargos /buscados (/r)adio (/d)epartamento");
            if(PlayerInfo[playerid][pRank] <= 3)
        		SendFMessage(playerid, COLOR_USAGE, "[%s] "COLOR_EMB_GREY" /verregistros /comprarinsumos /guardarinsumos /verinsumos", Faction_GetRankName(FAC_SIDE, 3));
			if(PlayerInfo[playerid][pRank] == 1) {
		    	SendFMessage(playerid, COLOR_USAGE, "[%s] "COLOR_EMB_GREY" /alacran", Faction_GetRankName(FAC_SIDE, 1));
			}

		} else if(PlayerInfo[playerid][pFaction] == FAC_HOSP) {
		    SendClientMessage(playerid, COLOR_USAGE, "[SAME] "COLOR_EMB_GREY" /mservicio /gobierno /departamento /ultimallamada /curar");

		} else if(PlayerInfo[playerid][pFaction] == FAC_MECH) {
			SendClientMessage(playerid, COLOR_USAGE, "[Taller] "COLOR_EMB_GREY" /mecayuda");

		} else if(PlayerInfo[playerid][pFaction] == FAC_MAN) {
			SendClientMessage(playerid, COLOR_USAGE, "[CTR] "COLOR_EMB_GREY" /noticia /entrevistar /pronostico");
			
		} else if(PlayerInfo[playerid][pFaction] == FAC_GOB) {
			SendClientMessage(playerid, COLOR_USAGE, "[GOBIERNO] "COLOR_EMB_GREY" /verconectados /verpresos /verantecedentes /departamento");
			if(PlayerInfo[playerid][pRank] <= 2) {
			SendClientMessage(playerid, COLOR_USAGE, "[Juez] "COLOR_EMB_GREY" /liberar /ppreventiva");
			} if(PlayerInfo[playerid][pRank] == 1) {
			SendClientMessage(playerid, COLOR_USAGE, "[Líder] "COLOR_EMB_GREY" /gobierno");
			}
		}

		if(Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_ALLOW_GRAFITI)) {
			if(PlayerInfo[playerid][pRank] <= 3) {
		        SendClientMessage(playerid, COLOR_USAGE, "[Grafitis] "COLOR_EMB_GREY" /grafiti - /borrargrafiti");
		    }
		}
		if(Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_DRUG_TRAFFIC) || Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_WEAPON_TRAFFIC)) {
		    if(PlayerInfo[playerid][pRank] == 1) {
		        SendClientMessage(playerid, COLOR_USAGE, "[Líder] "COLOR_EMB_GREY" /traficar");
			}
		}

		if(!BizEmp_IsEmployeeOfType(playerid, BIZ_MECH)) {
			SendClientMessage(playerid, COLOR_USAGE, "[Mecánico] "COLOR_EMB_GREY" /mecayuda");
		}
	}

	if(PlayerInfo[playerid][pJob] == JOB_FELON) {
        SendClientMessage(playerid, COLOR_USAGE, "[Delincuente] "COLOR_EMB_GREY" /delincuenteayuda /dejarempleo");
	} else {
		SendClientMessage(playerid, COLOR_USAGE, "[Empleo] "COLOR_EMB_GREY" /tomarempleo /consultarempleo /dejarempleo /verempleo /trabajar /terminar");
	}
	*/

CMD:hora(playerid, params[])
{
	PlayerActionMessage(playerid, 15.0, "toma su reloj y se fija la hora.");
	SendFMessage(playerid, COLOR_WHITE, "La hora actual es %s. {5CACC8}Próximo día de Pago en %d minutos.", GetHourString(), 60 - (PlayerInfo[playerid][pPayTime] / 60));
	return 1;
}

CMD:servicios(playerid, params[]) {
	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Emergencias: 911 | Taller mecánico: sms al 555 | Taxi: sms al 444 | Estación de radiodifusión: sms al 3900");
}

OnPlayerCmdComprar(playerid, const params[])
{
	#pragma unused playerid
	#pragma unused params

	return 1;
}

CMD:comprar(playerid, params[])
{
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");

	OnPlayerCmdComprar(playerid, params);
	return 1;
}

//=============================RENTA DE VEHICULOS===============================

CMD:rentar(playerid, params[])
{
	new vehicleid, rentcarid, price, time;

	if(sscanf(params, "i", time))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/rentar [tiempo] (en horas)");
	if(PlayerInfo[playerid][pRentCarID] != 0)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Ya has rentado un vehículo!");
	if(!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar subido a un vehículo de renta disponible para alquilar.");
 	vehicleid = GetPlayerVehicleID(playerid);
	if(VehicleInfo[vehicleid][VehType] != VEH_RENT)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar subido a un vehículo de renta disponible para alquilar.");
	for(new i = 1; i < MAX_RENTCAR; i++)
	{
	    if(RentCarInfo[i][rVehicleID] == vehicleid)
		{
	        if(RentCarInfo[i][rRented] == 1)
	            return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar subido a un vehículo de renta disponible para alquiler.");
			else
		    {
		        rentcarid = i;
		    	break;
			}
		}
	}
	if(time < 1 || time > 3)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Solo puedes alquilar por un mínimo de una hora, o un máximo de tres.");
	price = Veh_GetPrice(vehicleid) / 200;
	if(price < 100)
		price = 100; // Seteamos un mínimo de precio
	if(GetPlayerCash(playerid) < price * time)
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes el dinero necesario.");

	GivePlayerCash(playerid, -(price * time));
	SendClientMessage(playerid, COLOR_WHITE, "¡Rentaste el vehículo! Usa '/motor' o presiona (~k~~TOGGLE_SUBMISSIONS~) para encenderlo. Será devuelto al acabarse el tiempo.");
    SendClientMessage(playerid, COLOR_WHITE, "(( Si el vehículo respawnea, lo encontrarás en la agencia donde lo rentaste en primer lugar. ))");
	RentCarInfo[rentcarid][rRented] = 1;
	RentCarInfo[rentcarid][rOwnerSQLID] = PlayerInfo[playerid][pID];
	RentCarInfo[rentcarid][rTime] = time * 60; // Guardamos el tiempo en minutos
	PlayerInfo[playerid][pRentCarID] = vehicleid;
	PlayerInfo[playerid][pRentCarRID] = rentcarid;
	return 1;
}


forward BikeRent_Expire(playerid, bikeid);
public BikeRent_Expire(playerid, bikeid)
{
	if(IsValidVehicle(bikeid))
	{
		// Destruir completamente la bicicleta sin respawnear
		DestroyVehicle(bikeid);
		// Limpiar la entrada en RentCarInfo
		for(new i = 1; i < MAX_RENTCAR; i++)
		{
			if(RentCarInfo[i][rVehicleID] == bikeid)
			{
				RentCarInfo[i][rVehicleID] = 0;
				RentCarInfo[i][rOwnerSQLID] = 0;
				RentCarInfo[i][rTime] = 0;
				RentCarInfo[i][rRented] = 0;
				break;
			}
		}
	}
	
	if(IsPlayerConnected(playerid))
	{
		if(PlayerInfo[playerid][pRentBikeVehicleID] == bikeid)
		{
			PlayerInfo[playerid][pRentBikeVehicleID] = 0;
			// Si la bicicleta estaba registrada también como renta general, limpiamos esos campos
			if(PlayerInfo[playerid][pRentCarID] == bikeid)
			{
				PlayerInfo[playerid][pRentCarID] = 0;
				PlayerInfo[playerid][pRentCarRID] = 0;
			}
			SendClientMessage(playerid, COLOR_WHITE, "El tiempo de renta de tu bicicleta ha expirado.");
		}
	}

	// Asegurarnos de que la entrada de renta asociada a esta bici se limpie
	for(new i = 1; i < MAX_RENTCAR; i++)
	{
		if(RentCarInfo[i][rVehicleID] == bikeid)
		{
			RentCarInfo[i][rVehicleID] = 0;
			RentCarInfo[i][rOwnerSQLID] = 0;
			RentCarInfo[i][rTime] = 0;
			RentCarInfo[i][rRented] = 0;
			break;
		}
	}
}

TIMER:rentRespawn()
{
	new ownerid;
	for(new i = 1; i < MAX_RENTCAR; i++)
	{
		if(RentCarInfo[i][rRented] == 1)
		{
 		    RentCarInfo[i][rTime] -= 20;
            if(RentCarInfo[i][rTime] < 30)
            {
                ownerid = -1; // Por default el -1 que significa no está conectado
	           	foreach(new playerid : Player)
			    {
			        if(PlayerInfo[playerid][pID] == RentCarInfo[i][rOwnerSQLID])
			        {
			            ownerid = playerid;
			            break;
					}
				}
				if(RentCarInfo[i][rTime] > 0 && ownerid != 1)
 					SendFMessage(ownerid, COLOR_WHITE, "A tu vehículo de renta le quedan %d minutos de alquiler. Al finalizar será devuelto a la agencia.", RentCarInfo[i][rTime]);
				if(RentCarInfo[i][rTime] <= 0)
				{
				    RentCarInfo[i][rRented] = 0;
				    RentCarInfo[i][rTime] = 0;
				    RentCarInfo[i][rOwnerSQLID] = 0;
				    if(ownerid != -1)
				    {
       					PlayerInfo[ownerid][pRentCarID] = 0;
						PlayerInfo[ownerid][pRentCarRID] = 0;
						SendClientMessage(ownerid, COLOR_WHITE, "Se ha acabado el tiempo de alquiler del vehículo de renta.");
				    }
				}
			}
		}
    	if(RentCarInfo[i][rRented] == 0)
    	{
			VehicleInfo[RentCarInfo[i][rVehicleID]][VehLocked] = 0;
			SetVehicleToRespawn(RentCarInfo[i][rVehicleID]);
			VehicleInfo[RentCarInfo[i][rVehicleID]][VehFuel] = 100;
		}
	}
	return 1;
}

CMD:aceptar(playerid, params[])
{
	new subcmd[32];

	if(sscanf(params, "s[32]", subcmd))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aceptar [comando]");

	OnPlayerCmdAccept(playerid, subcmd);
	return 1;
}

OnPlayerCmdAccept(playerid, const subcmd[])
{
	if(isnull(subcmd)) {
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aceptar [comando]");
	}
	return 1;
}

CMD:cancelar(playerid, params[])
{
	new subcmd[32];

	if(sscanf(params, "s[32]", subcmd))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/cancelar [comando]");

	OnPlayerCmdCancel(playerid, subcmd);
	return 1;
}

OnPlayerCmdCancel(playerid, const subcmd[])
{
	if(isnull(subcmd)) {
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/cancelar [comando]");
	}
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid) {
	return 1;
}

GetPlayerCount() {
	return Iter_Count(Player);
}


//=============================GESTION DE IMPUESTOS===============================

CMD:gestionarimpuestos(playerid, params[])
{
	if (!((PlayerInfo[playerid][pFaction] == FAC_GOB && PlayerInfo[playerid][pRank] >= 2) || PlayerInfo[playerid][pAdmin] >= 15)) 
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes permiso para modificar impuestos.");

	new str[128];
	format(str, sizeof(str),
		"Impuesto negocios actual: %.2f%%\nImpuesto vehículos actual: %.2f%%\n\nSelecciona cuál deseas modificar:",
		Server_BizTaxPercent * 100,
		Server_VehTaxPercent * 100
	);
	Dialog_Show(playerid, 2301, DIALOG_STYLE_LIST, "Gestionar impuestos", "Negocios\nVehículos", "Seleccionar", "Cancelar");
	return 1;
}

Dialog:2301(playerid, response, listitem, inputtext[])
{
    if(!response) return 1;

    switch(listitem)
    {
        case 0: // Negocios
        {
            new str[64];
            format(str, sizeof(str), "Impuesto actual: %.2f%%\nIngresa el nuevo porcentaje (0.18 para 0,18%%)", Server_BizTaxPercent * 100);
            Dialog_Show(playerid, 2302, DIALOG_STYLE_INPUT, "Modificar impuesto de negocios", str, "Aceptar", "Cancelar");
        }
        case 1: // Vehículos
        {
            new str[64];
            format(str, sizeof(str), "Impuesto actual: %.2f%%\nIngresa el nuevo porcentaje (ej: 0.18 para 0,18%%)", Server_VehTaxPercent * 100);
            Dialog_Show(playerid, 2303, DIALOG_STYLE_INPUT, "Modificar impuesto de vehículos", str, "Aceptar", "Cancelar");
        }
    }
    return 1;
}

Dialog:2302(playerid, response, listitem, inputtext[])
{
    if(!response) return 1;

    new Float:bizPercent;
    if(sscanf(inputtext, "f", bizPercent) || bizPercent < 0.01 || bizPercent > 2.5)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Porcentaje inválido. Usa un valor entre 0.01 y 2.5");

    Server_BizTaxPercent = bizPercent / 100.0;
    SaveServerInfo();

    new msg[64];
    format(msg, sizeof(msg), "Impuesto de negocios actualizado a %.2f%%.", bizPercent);
    SendClientMessage(playerid, COLOR_LIGHTGREEN, msg);
    return 1;
}

Dialog:2303(playerid, response, listitem, inputtext[])
{
    if(!response) return 1;

    new Float:vehPercent;
    if(sscanf(inputtext, "f", vehPercent) || vehPercent < 0.01 || vehPercent > 2.5)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Porcentaje inválido. Usa un valor entre 0.01 y 2.5");

    Server_VehTaxPercent = vehPercent / 100.0;
    SaveServerInfo();

    new msg[64];
    format(msg, sizeof(msg), "Impuesto de vehículos actualizado a %.2f%%.", vehPercent);
    SendClientMessage(playerid, COLOR_LIGHTGREEN, msg);
    return 1;
}

CMD:darbonolegal(playerid, params[])
{
	if (!((PlayerInfo[playerid][pFaction] == FAC_GOB && PlayerInfo[playerid][pRank] >= 2) || PlayerInfo[playerid][pAdmin] >= 15)) 
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes permiso para modificar bonos.");

    new amount;
    if (sscanf(params, "i", amount) || amount < 1)
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/darbonolegal [monto]");

    // Primero contamos destinatarios para calcular total y validar fondos
    new count = 0;
    foreach (new i : Player)
    {
        if (!IsPlayerConnected(i) || !gPlayerLogged[i]) continue;
        if (PlayerInfo[i][pJob] != 0 && GetJobType(PlayerInfo[i][pJob]) == JOB_TYPE_LEGAL)
            count++;
    }

    if (count == 0)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay jugadores con trabajo legal conectados.");

    new total = amount * count;
    if (Faction_GetBank(FAC_GOB) < total)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La facción gobierno no tiene suficiente dinero para cubrir todos los bonos.");

    // Descontar a la facción y asignar bonos
    Faction_GiveMoney(FAC_GOB, (-total/2));

    new msg[128];
    new given = 0;
    foreach (new i : Player)
    {
        if (!IsPlayerConnected(i) || !gPlayerLogged[i]) continue;
        if (PlayerInfo[i][pJob] != 0 && GetJobType(PlayerInfo[i][pJob]) == JOB_TYPE_LEGAL)
        {
            PaydayBonus[i] += amount;
            format(msg, sizeof(msg), "¡Has recibido un bono de $%d del gobierno! Se pagará en el próximo payday.", amount);
            SendClientMessage(i, COLOR_LIGHTGREEN, msg);
            given++;
        }
    }

    format(msg, sizeof(msg), "Has asignado un bono de $%d a %d trabajadores legales. Total descontado: $%d.", amount, given, total);
    SendClientMessage(playerid, COLOR_LIGHTGREEN, msg);
    return 1;
}

CMD:plansocial(playerid, params[])
{
	
	if (!((PlayerInfo[playerid][pFaction] == FAC_GOB && PlayerInfo[playerid][pRank] >= 2) || PlayerInfo[playerid][pAdmin] >= 15))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes permiso para dar planes.");

    new amount;
    if (sscanf(params, "i", amount) || amount < 1)
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/plansocial [monto]");
	socialPay = amount;

    // contar destinatarios: no trabajan y sin facción para descontar de forma "espiritual"
    new count = 0;
    foreach (new i : Player)
    {
        if (!IsPlayerConnected(i) || !gPlayerLogged[i]) continue;
        if (PlayerInfo[i][pJob] == 0 && PlayerInfo[i][pFaction] == 0)
            count++;
    }
	

    new total = amount * count;
	new msg[256];

    if (Faction_GetBank(FAC_GOB) < (total/2))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La facción Gobierno no tiene fondos suficientes para cubrir el plan.");

    // descontar y asignar en memoria; persistencia la hace SaveAccount
    Faction_GiveMoney(FAC_GOB, (-total));
    format(msg, sizeof(msg), "Plan asignado: $%d a %d personas. Total descontado de la caja del gobierno aproximado: $%d.", amount, count, total);
    SendClientMessage(playerid, COLOR_LIGHTGREEN, msg);
    return 1;
}

// Convierte segmentos entre guiones a color de /me dentro del diálogo
// Ejemplo: "Hola. -Dijo mientras...-" => partes entre guiones con COLOR_ACT1
stock BuildDialogueWithMeColor(const input[], output[], outsize)
{
	// Embed directo: COLOR_ACT1 -> {BE85D8}, COLOR_WHITE -> {E0E0E0}
	new embMe[] = "{BE85D8}", embDefault[] = "{E0E0E0}";

	output[0] = '\0';
	new len = strlen(input);
	new bool:inAction = false;

	for(new i = 0; i < len; i++)
	{
		if(input[i] == '-')
		{
			if(inAction)
			{
				// cerrar acción: insertar guión dentro del color y volver al color por defecto
				strcat(output, "-", outsize);
				strcat(output, embDefault, outsize);
				inAction = false;
			}
			else
			{
				// Solo abrir acción si hay un guión de cierre más adelante
				new found = 0;
				for(new j = i + 1; j < len; j++) {
					if(input[j] == '-') { found = 1; break; }
				}
				if(found) {
					// abrir acción: cambiar a color /me e insertar guión dentro del color
					strcat(output, embMe, outsize);
					strcat(output, "-", outsize);
					inAction = true;
				} else {
					// no hay cierre: tratar el guión como carácter normal
					strcat(output, "-", outsize);
				}
			}
		}
		else
		{
			new ch[2];
			ch[0] = input[i];
			ch[1] = '\0';
			strcat(output, ch, outsize);
		}
	}
	// Si quedó abierto, cerrar con color por defecto
	if(inAction)
	{
		strcat(output, embDefault, outsize);
	}
	return 1;
}

CMD:dartel(playerid, params[])
{
	new targetid, phoneNumber;
	
	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/dartel [ID/Jugador]");
	
	if(!IsPlayerLogged(targetid) || targetid == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido o no puedes darte el teléfono a ti mismo.");
	
	phoneNumber = PlayerInfo[playerid][pPhoneNumber];
	
	if(phoneNumber == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes un número de teléfono asignado.");
	
	if(!IsPlayerInRangeOfPlayer(3.0, playerid, targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no se encuentra cerca tuyo.");
	
	new string[128];
	
	PlayerInfo[targetid][pPhoneNumber] = phoneNumber;
	
	format(string, sizeof(string), "Has dado el número de teléfono %d a %s.", phoneNumber, GetPlayerCleanName(targetid));
	SendClientMessage(playerid, COLOR_LIGHTGREEN, string);
	
	format(string, sizeof(string), "%s te ha dado el número de teléfono %d.", GetPlayerCleanName(playerid), phoneNumber);
	SendClientMessage(targetid, COLOR_LIGHTGREEN, string);
	
	format(string, sizeof(string), "%s le da el número de teléfono %d a %s.", GetPlayerCleanName(playerid), phoneNumber, GetPlayerCleanName(targetid));
	PlayerActionMessage(playerid, 15.0, string);
	
	return 1;
}