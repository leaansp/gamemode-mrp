#if defined marp_thiefjob_inc
	#endinput
#endif
#define marp_thiefjob_inc

#include <YSI_Coding\y_hooks>


// ============================================================================
// DIALOGOS
// ============================================================================

enum {
    DLG_THIEF_REWARDS = 8600,
    DLG_THIEF_EDIT_REWARD
};

// ============================================================================
// DIALOGOS
// ============================================================================

enum {
    DLG_THIEF_REWARDS = 8600,
    DLG_THIEF_EDIT_REWARD
};

//================================CONSTANTES====================================

#define THIEF_HOUSE_THEFT		(1)
#define THIEF_HOUSE_ROBBERY		(2)
#define THIEF_SHOP_THEFT		(3)
#define THIEF_SHOP_ROBBERY		(4)
#define THIEF_PERSON_ROBBERY	(5)

// ============================================================================
// ROBO DE CABLES
// ============================================================================

#define THIEF_CABLE_ROBBERY_LEVEL       (1)
#define THIEF_CABLE_ROBBERY_DURATION    (60)
#define THIEF_CABLE_ROBBERY_COOLDOWN    (25) // minutos
#define THIEF_CABLE_POLICE_DAY          (75)
#define THIEF_CABLE_POLICE_NIGHT        (25)

#define THIEF_CABLE_TYPE_POSTE          (1)
#define THIEF_CABLE_TYPE_VIAS           (2)
#define CABLE_PICKUP_MODEL              (1274)
#define CABLE_PICKUP_TYPE               (1)

#define JOB_THIEF 6 // o el ID real
#define MAX_THIEF_REWARDS 8

enum e_ThiefReward {
    trAction[32],
    Float:trValue
};

new ThiefRewards[MAX_THIEF_REWARDS][e_ThiefReward];
new Iterator:ThiefRewardIter<MAX_THIEF_REWARDS>;




new thief_cable_pickup[MAX_PLAYERS] = {INVALID_STREAMER_ID, ...};
new thief_cable_type[MAX_PLAYERS];
new thief_cable_timer[MAX_PLAYERS];
new Float:thief_cable_origZ[MAX_PLAYERS];
new bool:thief_cable_climbing[MAX_PLAYERS];
new bool:thief_alerted[MAX_PLAYERS];
new bool:thief_cable_pending[MAX_PLAYERS];
new bool:thief_cable_shock_pending[MAX_PLAYERS]; //patada el?ctrica

new Float:thief_cable_x[MAX_PLAYERS];
new Float:thief_cable_y[MAX_PLAYERS];
new Float:thief_cable_z[MAX_PLAYERS];

new thief_edit_reward_idx[MAX_PLAYERS];


const Float:THIEF_SHOP_THEFT_SECS_PER_PRICE = 2.25; // Segundos de cooldown por cada peso ($) que cuesta el ?tem
const THIEF_SHOP_THEFT_MIN_COOLDOWN = 10; // En minutos, m?nimo cooldown sea cual sea el precio
const THIEF_SHOP_THEFT_LEVEL = 1; // Nivel de job al que corresponde
const THIEF_SHOP_THEFT_DURATION = 60; // En segundos, duraci?n del robo

//static const THIEF_SHOP_ROBBERY_CASH = 1000;
static const THIEF_SHOP_ROBBERY_CASH_RANGE = 700;
static const THIEF_SHOP_ROBBERY_COOLDOWN = 15; // En minutos
static const THIEF_SHOP_ROBBERY_LEVEL = 2; // Nivel de job al que corresponde
static const THIEF_SHOP_ROBBERY_DURATION = 60; // En segundos, duraci?n del robo

//static const THIEF_HOUSE_THEFT_CASH = 1200;
static const THIEF_HOUSE_THEFT_CASH_RANGE = 950;
static const THIEF_HOUSE_THEFT_COOLDOWN = 15; // En minutos
static const THIEF_HOUSE_THEFT_LEVEL = 3; // Nivel de job al que corresponde
static const THIEF_HOUSE_THEFT_DURATION = 100; // En segundos, duraci?n del robo

//static const THIEF_HOUSE_ROBBERY_CASH = 1550;
static const THIEF_HOUSE_ROBBERY_CASH_RANGE = 1250;
static const THIEF_HOUSE_ROBBERY_COOLDOWN = 25; // En minutos
static const THIEF_HOUSE_ROBBERY_LEVEL = 4; // Nivel de job al que corresponde
static const THIEF_HOUSE_ROBBERY_DURATION = 100; // En segundos, duraci?n del robo

//==================================DATA========================================


enum tThiefJob
{
	pFelonLevel,
	pFelonExp
};

new ThiefJobInfo[MAX_PLAYERS][tThiefJob];

new thief_stealing[MAX_PLAYERS],
	thief_timer[MAX_PLAYERS],
	thief_timer_secs[MAX_PLAYERS],
	thief_timer_police_call[MAX_PLAYERS],
	thief_target[MAX_PLAYERS],
	thief_type[MAX_PLAYERS],
	thief_victim_of[MAX_PLAYERS],
	thief_listitem[MAX_PLAYERS];
	new thief_selected_itemid[MAX_PLAYERS];


hook OnGameModeInit()
{
    SetTimerEx("LoadThiefRewards", 3000, false, "");
    return 1;
}
forward LoadThiefRewards();
public LoadThiefRewards()
{
    mysql_tquery(MYSQL_HANDLE, "SELECT * FROM thief_rewards;", "OnThiefRewardsLoad");
    return 1;
}

ResetThiefVariables(playerid)
{
	ThiefJobInfo[playerid][pFelonLevel] = 0;
	ThiefJobInfo[playerid][pFelonExp] = 0;

	ResetThiefCrime(playerid);
	
	thief_victim_of[playerid] = INVALID_PLAYER_ID;
}

ResetThiefCrime(playerid)
{
	if(thief_timer[playerid])
	{
	    KillTimer(thief_timer[playerid]);
	    thief_timer[playerid] = 0;
	}
	thief_stealing[playerid] = 0;
	thief_timer_secs[playerid] = -1;
	thief_timer_police_call[playerid] = 0;
	if(thief_type[playerid] == THIEF_PERSON_ROBBERY && thief_target[playerid] != INVALID_PLAYER_ID) {
	    thief_victim_of[thief_target[playerid]] = INVALID_PLAYER_ID;
	}
	thief_target[playerid] = INVALID_PLAYER_ID;
	thief_type[playerid] = 0;
	thief_listitem[playerid] = 0;
	thief_selected_itemid[playerid] = 0;
	thief_cable_shock_pending[playerid] = false;
	ResetCarThiefCrime(playerid);
}


JobThief_LevelCheck(playerid, felonLevel)
{
	if(PlayerInfo[playerid][pJob] != JOB_FELON)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener el trabajo de delincuente para utilizar este comando.");
		return 0;
	}
	if(ThiefJobInfo[playerid][pFelonLevel] < felonLevel)
	{
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas tener una experiencia de nivel %i o mayor en el trabajo para poder usar este comando.", felonLevel);
		return 0;
	}

	return 1;
}

JobThief_IsPlayerStealingCheck(playerid)
{
	if(thief_stealing[playerid] || thief_victim_of[playerid] != INVALID_PLAYER_ID || thief_cable_pending[playerid])
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento ya que te encuentras ocupado en otro robo.");
		return 0;
	}

	return 1;
}
	
//==============================DB CONNECTION===================================

LoadThiefJobData(playerid)
{
	new	query[64];
    mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT * FROM `thief_job` WHERE `accountid`=%i;", PlayerInfo[playerid][pID]);
	mysql_tquery(MYSQL_HANDLE, query, "OnThiefJobDataLoad", "i", playerid);
	return 1;
}


forward OnThiefJobDataLoad(playerid);
public OnThiefJobDataLoad(playerid)
{
	if(cache_num_rows())
	{
		cache_get_value_name_int(0, "pFelonExp", ThiefJobInfo[playerid][pFelonExp]);
		cache_get_value_name_int(0, "pFelonLevel", ThiefJobInfo[playerid][pFelonLevel]);
	}
	else
	{
	    SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Error al cargar la informaci?n del empleo ID %d desde la base de datos. Reportar a un administrador.", PlayerInfo[playerid][pJob]);
        PlayerInfo[playerid][pJob] = 0;
	}
	return 1;
}

forward OnThiefRewardsLoad();
public OnThiefRewardsLoad()
{
	
    new rows = cache_num_rows();
    if (!rows) return print("[THIEF JOB] No se encontraron recompensas.");

	printf("[DEBUG] Callback OnThiefRewardsLoad() ejecutado.");
    printf("[DEBUG] Cantidad de filas: %d", rows);

    for (new i = 0; i < rows && i < MAX_THIEF_REWARDS; i++)
    {
        cache_get_value_name(i, "action_name", ThiefRewards[i][trAction]);
        cache_get_value_name_float(i, "reward", ThiefRewards[i][trValue]);
        Iter_Add(ThiefRewardIter, i);
    }

	printf("[THIEF JOB] Recompensas cargadas desde SQL");
    return 1;
}

// ============================================================
// Obtener valor actual de una recompensa
// ============================================================
stock Float:Thief_GetReward(const action[])
{
    foreach (new i : ThiefRewardIter)
    {
        if (!strcmp(ThiefRewards[i][trAction], action, true))
            return ThiefRewards[i][trValue];
    }

    printf("[THIEF JOB] Acci?n '%s' no encontrada en la tabla.", action);
    return 0.0;
}

// ============================================================
// Actualizar recompensa existente (sin crear nuevas)
// ============================================================
stock bool:Thief_UpdateReward(const action[], Float:value)
{
    foreach (new i : ThiefRewardIter)
    {
        if (!strcmp(ThiefRewards[i][trAction], action, true))
        {
            ThiefRewards[i][trValue] = value;

            new query[256];
            mysql_format(MYSQL_HANDLE, query, sizeof query,
                "UPDATE thief_rewards SET reward = %.2f WHERE action_name = '%s' LIMIT 1;",
                value, action);
            mysql_tquery(MYSQL_HANDLE, query);
            return true;
        }
    }

    return false;
}

SaveThiefJobData(playerid)
{
	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `thief_job` SET `pFelonExp`=%i,`pFelonLevel`=%i WHERE `accountid`=%i;", ThiefJobInfo[playerid][pFelonExp], ThiefJobInfo[playerid][pFelonLevel], getPlayerMysqlId(playerid));
	mysql_tquery(MYSQL_HANDLE, query);
}

SetThiefJobForPlayer(playerid)
{
	new query[64];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT * FROM `thief_job` WHERE `accountid`=%i;", PlayerInfo[playerid][pID]);
	mysql_tquery(MYSQL_HANDLE, query, "OnPlayerThiefJobCheck", "i", playerid);
}

forward OnPlayerThiefJobCheck(playerid);
public OnPlayerThiefJobCheck(playerid)
{
	if(cache_num_rows()) // Alguna vez lo tuvo, por ende encontr? un registro en DB.
	{
		cache_get_value_name_int(0, "pFelonExp", ThiefJobInfo[playerid][pFelonExp]);
		cache_get_value_name_int(0, "pFelonLevel", ThiefJobInfo[playerid][pFelonLevel]);
	}
	else // Primera vez que lo tiene
	{
		ThiefJobInfo[playerid][pFelonLevel] = 1;
		ThiefJobInfo[playerid][pFelonExp] = 0;

		mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "" @Format: "INSERT INTO `thief_job` (`accountid`) VALUES (%i);", PlayerInfo[playerid][pID]);
	}

	PlayerInfo[playerid][pJob] = JOB_FELON;
	PlayerInfo[playerid][pJobTime] = JOB_WAITTIME;
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"?Felicidades, ahora eres un delincuente! Para saber los comandos disponibles mira en /delincuenteayuda y en /ayuda.");
	return 1;
}

GetConnectedCops()
{
	new count = 0;
	foreach (new i : Player)
	{
		if ((PlayerInfo[i][pFaction] == FAC_PMA && CopDuty[i]) || (PlayerInfo[i][pFaction] == FAC_SIDE && SIDEDuty[i]))
		{
			count++;
		}
	}
	return count;
}

forward Thief_Countdown(playerid);
public Thief_Countdown(playerid)
{
	new string[128];

	if(thief_timer_secs[playerid] < 0)
	{
	    SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"[ERROR]: thief_timer_secs < 0. Por favor, saca una foto del chatlog y rep?rtalo a un administrador.");
	    ResetThiefCrime(playerid);
	    return 1;
	}
	
	switch(thief_type[playerid])
	{
	    case THIEF_SHOP_THEFT: //===============================================
		{
			if(thief_timer_secs[playerid] > 0)
			{
			    if(thief_timer_secs[playerid] == thief_timer_police_call[playerid])
				{
					if(!random(3)) // 33%
					{
					    RobberyAlert(playerid, "hurto en negocio", "an?nimo", .bizid = thief_target[playerid]);
				        SendClientMessage(playerid, COLOR_WHITE, "?Un empleado ha notado tu accionar y ha llamado a la polic?a!");
				        SendClientMessage(playerid, COLOR_WHITE, "Puedes utilizar /correr para escapar dejando toda la mercanc?a o esperar para terminar.");
					}
				}
				
		 		format(string, sizeof(string), "~w~Tomando mercancia   ~r~%d~w~ segundos", thief_timer_secs[playerid]);
		 		GameTextForPlayer(playerid, string, 1000, 4);
		        thief_timer_secs[playerid]--;
			}
			else if(thief_timer_secs[playerid] == 0)
			{
				new bizid = Biz_IsPlayerInsideAny(playerid);

				if(!bizid)
				{
					ResetThiefCrime(playerid);
					PlayerInfo[playerid][pDisabled] = DISABLE_NONE;
					return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en el negocio.");
				}

				new freehand = SearchFreeHand(playerid);

				if(freehand == -1)
				{
					ResetThiefCrime(playerid);
					PlayerInfo[playerid][pDisabled] = DISABLE_NONE;
					return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes c?mo agarrar el item ya que tienes ambas manos ocupadas.");
				}
				else
				{
					Biz_UpdateItemStock(bizid, thief_listitem[playerid], GetBizItemStock(bizid, thief_listitem[playerid]) - 1);
					Biz_UpdateSQLItemStock(bizid, thief_listitem[playerid]);

					// Prefer the itemid selected at menu time; fallback to catalog lookup
					new itemid = (thief_selected_itemid[playerid] > 0) ? thief_selected_itemid[playerid] : BusinessCatalog[bizid][thief_listitem[playerid]][bItemid];
					// Intentar dar el item en la mano; si no se puede, intentar guardarlo en inventario
					if(!SetAnyHandItemAndParam(playerid, itemid, 1))
					{
						if(!Container_AddItemAndParam(PlayerInfo[playerid][pContainerID], itemid, 1))
						{
							SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No pudiste recoger el objeto (manos e inventario llenos). Lo dejamos en el local.");
						}
						else
						{
							SendFMessage(playerid, COLOR_WHITE, "?Has hurtado un/a %s y lo guardas en tu inventario!", ItemModel_GetName(itemid));
						}
					}
					else
					{
						new str[128];
						format(str, sizeof(str), "toma un/a %s.", ItemModel_GetName(itemid));
						PlayerCmeMessage(playerid, 15.0, 5000, str);
						SendFMessage(playerid, COLOR_WHITE, "?Has hurtado un/a %s!", ItemModel_GetName(itemid));
					}

					thief_timer_secs[playerid] = -1;
					JobThief_GiveLevelExp(playerid, THIEF_SHOP_THEFT_LEVEL, 10);
					PlayerInfo[playerid][pDisabled] = DISABLE_NONE;
					ResetThiefCrime(playerid);
				}
			}
		}
		case THIEF_SHOP_ROBBERY: //=============================================
		{
		    if(thief_timer_secs[playerid] > 0)
			{
			    if(thief_timer_secs[playerid] == thief_timer_police_call[playerid])
				{
					RobberyAlert(playerid, "robo a mano armada", "an?nimo", .bizid = thief_target[playerid]);
			        SendClientMessage(playerid, COLOR_WHITE, "?Un empleado ha notado tu accionar y ha llamado a la polic?a!");
			        SendClientMessage(playerid, COLOR_WHITE, "Puedes utilizar /correr para escapar dejando todo el dinero o esperar para terminar.");
			    }
			    
			    format(string, sizeof(string), "~w~Guardando dinero ~r~%d~w~ segundos", thief_timer_secs[playerid]);
		 		GameTextForPlayer(playerid, string, 1000, 4);
		        thief_timer_secs[playerid]--;
	        }
			else if(thief_timer_secs[playerid] == 0)
			{
				new bizid = Biz_IsPlayerInsideAny(playerid);

				if(!bizid)
				{
					ResetThiefCrime(playerid);
					PlayerInfo[playerid][pDisabled] = DISABLE_NONE;
					return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en el negocio.");
				}

	            thief_timer_secs[playerid] = -1;
				new cash = floatround(Thief_GetReward("shop_robbery")) + random(THIEF_SHOP_ROBBERY_CASH_RANGE);
				GivePlayerCash(playerid, cash);
				SendFMessage(playerid, COLOR_WHITE, "Has robado "COLOR_EMB_USAGE"$%i"COLOR_EMB_WHITE" de la caja. ?Escapa antes de que venga la polic?a!", cash);
				JobThief_GiveLevelExp(playerid, THIEF_SHOP_ROBBERY_LEVEL, 30);
				PlayerInfo[playerid][pDisabled] = DISABLE_NONE;
				ResetThiefCrime(playerid);
	        }
		}
		case THIEF_HOUSE_THEFT: //==============================================
		{
		    if(thief_timer_secs[playerid] > 0)
			{
		        if(thief_timer_secs[playerid] == thief_timer_police_call[playerid])
				{
					RobberyAlert(playerid, "hurto en domicilio particular", "an?nimo", .houseid = thief_target[playerid]);
			        SendClientMessage(playerid, COLOR_WHITE, "?Un vecino ha notado tu entrada forzosa y ha llamado a la polic?a!");
			        SendClientMessage(playerid, COLOR_WHITE, "Puedes utilizar /correr para escapar dejando la bolsa de objetos o esperar para terminar.");
			    }
			    
			    format(string, sizeof(string), "~w~Robando objetos ~r~%d~w~ segundos", thief_timer_secs[playerid]);
		 		GameTextForPlayer(playerid, string, 1000, 4);
		        thief_timer_secs[playerid]--;
	        }
			else if(thief_timer_secs[playerid] == 0)
			{
	            thief_timer_secs[playerid] = -1;
				new cash = floatround(Thief_GetReward("house_theft")) + random(THIEF_HOUSE_THEFT_CASH_RANGE);
				GivePlayerCash(playerid, cash);
				SendFMessage(playerid, COLOR_WHITE, "Has robado objetos por un valor de "COLOR_EMB_USAGE"$%i"COLOR_EMB_WHITE". ?Escapa antes de que venga la polic?a!", cash);
				JobThief_GiveLevelExp(playerid, THIEF_HOUSE_THEFT_LEVEL, 90);
				PlayerInfo[playerid][pDisabled] = DISABLE_NONE;
				ResetThiefCrime(playerid);
	        }
		}
		case THIEF_HOUSE_ROBBERY: //============================================
		{
		    if(thief_timer_secs[playerid] > 0)
			{
		        if(thief_timer_secs[playerid] == thief_timer_police_call[playerid])
				{
					RobberyAlert(playerid, "asalto en domicilio particular", "an?nimo", .houseid = thief_target[playerid]);
			        SendClientMessage(playerid, COLOR_WHITE, "?Un vecino ha notado tu entrada forzosa y ha llamado a la polic?a!");
			        SendClientMessage(playerid, COLOR_WHITE, "Puedes utilizar /correr para escapar dejando el dinero o esperar para terminar.");
			    }
			    
			    format(string, sizeof(string), "~w~Buscando dinero ~r~%d~w~ segundos", thief_timer_secs[playerid]);
		 		GameTextForPlayer(playerid, string, 1000, 4);
		        thief_timer_secs[playerid]--;
	        }
			else if(thief_timer_secs[playerid] == 0)
			{
	            thief_timer_secs[playerid] = -1;
				new cash = floatround(Thief_GetReward("house_robbery")) + random(THIEF_HOUSE_ROBBERY_CASH_RANGE);
				GivePlayerCash(playerid, cash);
				SendFMessage(playerid, COLOR_WHITE, "Has logrado encontrar "COLOR_EMB_USAGE"$%i"COLOR_EMB_WHITE" en objetos de valor. ?Escapa antes de que venga la polic?a!", cash);
				JobThief_GiveLevelExp(playerid, THIEF_HOUSE_ROBBERY_LEVEL, 270);
				PlayerInfo[playerid][pDisabled] = DISABLE_NONE;
				ResetThiefCrime(playerid);
	        }
		}
		default:
		    ResetThiefCrime(playerid);
		
	}
	return 1;
}

RobberyAlert(playerid, accusedOf[], accusedBy[], houseid = 0, bizid = 0)
{
	new string[144];

 	if(!HiddenName_IsActive(playerid))
 	{
		SetPlayerWantedLevelEx(playerid, GetPlayerWantedLevelEx(playerid) + 1);
 		format(PlayerInfo[playerid][pAccusedOf], 64, accusedOf);
		format(PlayerInfo[playerid][pAccusedBy], 24, accusedBy);
	}
	if(houseid)
	{
	    new area[MAX_ZONE_NAME];
		GetCoords2DZone(House[houseid][OutsideX], House[houseid][OutsideY], area, MAX_ZONE_NAME);
	    format(string, sizeof(string), "[911] Entradera reportada en barrio de %s, altura %i. Lo marcamos en su GPS.", area, houseid);
		foreach(new play : Player)
		{
			if((PlayerInfo[play][pFaction] == FAC_PMA && CopDuty[play]) || (PlayerInfo[play][pFaction] == FAC_SIDE && SIDEDuty[play]))
			{
			    SendClientMessage(play, COLOR_CENTRALRED, string);
				MapMarker_CreateForPlayer(play, House[houseid][OutsideX], House[houseid][OutsideY], House[houseid][OutsideZ], .color = COLOR_LIGHTORANGE, .time = 300000);
			}
		}
	}
	else if(bizid)
	{
		new area[MAX_ZONE_NAME];
		GetCoords2DZone(Business[bizid][bOutsideX], Business[bizid][bOutsideY], area, MAX_ZONE_NAME);
		format(string, sizeof(string), "[911] %s reportado en %s, barrio de %s. Lo marcamos en su GPS.", accusedOf, Business[bizid][bName], area);
		foreach(new play : Player)
		{
			if((PlayerInfo[play][pFaction] == FAC_PMA && CopDuty[play]) || (PlayerInfo[play][pFaction] == FAC_SIDE && SIDEDuty[play]))
			{
			    SendClientMessage(play, COLOR_CENTRALRED, string);
			    MapMarker_CreateForPlayer(play, Business[bizid][bOutsideX], Business[bizid][bOutsideY], Business[bizid][bOutsideZ], .color = COLOR_YELLOW, .time = 300000);
			}
		}
	}
}

//==================================COMANDOS====================================

CMD:hurtarcasa(playerid, params[])
{
	if(!CooldownCMD_Check(playerid, COOLDOWN_CMD_ID_HURTARCASA))
		return 1;
	if(!JobThief_LevelCheck(playerid, .felonLevel = THIEF_HOUSE_THEFT_LEVEL))
		return 1;
	if(!JobThief_IsPlayerStealingCheck(playerid))
		return 1;
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");

	new houseid = House_IsPlayerInAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en una casa.");
	if(KeyChain_Contains(playerid, KEY_TYPE_HOUSE, houseid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"?No puedes robar esta casa!");


	thief_stealing[playerid] = 1;
	thief_timer_police_call[playerid] = (random(4)) ? (1 + random(30)) : (0); // 25 % de que no llame. Si llama lo hace dentro de los ?ltimos (1+X) segundos
	thief_timer_secs[playerid] = THIEF_HOUSE_THEFT_DURATION;
	thief_type[playerid] = THIEF_HOUSE_THEFT;
	thief_target[playerid] = houseid;
	thief_timer[playerid] = SetTimerEx("Thief_Countdown", 1000, true, "i", playerid);
	
	PlayerActionMessage(playerid, 15.0, "empieza a buscar objetos de valor y los almacena en una bolsa.");
	PlayerInfo[playerid][pDisabled] = DISABLE_STEALING;
	CooldownCMD_Apply(playerid, COOLDOWN_CMD_ID_HURTARCASA, .seconds = THIEF_HOUSE_THEFT_COOLDOWN * 60);
	return 1;
}

CMD:asaltarcasa(playerid, params[])
{
	if(!CooldownCMD_Check(playerid, COOLDOWN_CMD_ID_ASALTARCASA))
		return 1;
	if(!JobThief_LevelCheck(playerid, .felonLevel = THIEF_HOUSE_ROBBERY_LEVEL))
		return 1;
	if(!JobThief_IsPlayerStealingCheck(playerid))
		return 1;
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
	if(!hasFireGun(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener un arma de fuego en la mano.");

	if(GetConnectedCops() < 2)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "Debe haber al menos 2 polic?as conectados para poder asaltar una casa.");

	new houseid = House_IsPlayerInAny(playerid);

	if(!houseid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en una casa.");
	if(KeyChain_Contains(playerid, KEY_TYPE_HOUSE, houseid))
		return SendClientMessage(playerid, COLOR_YELLOW2, "?No puedes robar esta casa!");

	thief_stealing[playerid] = 1;
	thief_timer_police_call[playerid] = (random(4)) ? (1 + random(30)) : (0); // 25 % de que no llame. Si llama lo hace dentro de los ?ltimos (1+X) segundos
	thief_timer_secs[playerid] = THIEF_HOUSE_ROBBERY_DURATION;
	thief_type[playerid] = THIEF_HOUSE_ROBBERY;
	thief_target[playerid] = houseid;
	thief_timer[playerid] = SetTimerEx("Thief_Countdown", 1000, true, "i", playerid);
	
	PlayerActionMessage(playerid, 15.0, "comienza a buscar dinero por la casa y lo guarda en una bolsa.");
	ApplyAnimationEx(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
	PlayerInfo[playerid][pDisabled] = DISABLE_STEALING;
	CooldownCMD_Apply(playerid, COOLDOWN_CMD_ID_ASALTARCASA, .seconds = THIEF_HOUSE_ROBBERY_COOLDOWN * 60);
	return 1;
}

CMD:carterista(playerid, params[]) {
	if(!CooldownCMD_Check(playerid, COOLDOWN_CMD_ID_CARTERISTA))
		return true;
	if(!JobThief_IsPlayerStealingCheck(playerid))
		return true;
	if(PlayerInfo[playerid][pLevel] < 3)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"?Deb?s ser nivel 3 o superior!");
	if(PlayerInfo[playerid][pJailed] != JAIL_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"?Deb?s estar en libertad!");

	new target;

	if(sscanf(params, "u", target))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/carterista [ID/Nombre]");
	if(!IsPlayerLogged(target) || target == playerid)
		return SendClientMessage(playerid, -1, "?No se ha encontrado al jugador!");
	if(IsPlayerInAnyVehicle(playerid) && Veh_GetModelType(GetPlayerVehicleID(playerid)) != VTYPE_BIKE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Deb?s estar a pie o en una moto.");
	if(!IsPlayerInRangeOfPlayer(1.2, playerid, target))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"?Ac?rcate a la v?ctima!");
	if(GetPlayerCash(target) <= 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La v?ctima no tiene objetos de valor.");

	if(!random(3)) // 33 % de que falle.
	{
		new string[128];
		format(string, sizeof(string), "ha realizado unas maniobras para hurtar algo del bolsillo de %s pero es descubierto.", GetPlayerCleanName(target));
		PlayerActionMessage(playerid, 15.0, string);
		SendClientMessage(playerid, COLOR_WHITE, "Fallaste. ?Escapa antes que te atrapen!");
	}
	else
	{
		new target_money = GetPlayerCash(target), theft_money = 60 + random(40);

		if(theft_money > target_money) {
			theft_money = target_money;
		}

		SendFMessage(playerid, COLOR_WHITE, "Guardas $%i disimuladamente en tus bolsillos. ?Vete antes que se den cuenta!", theft_money);
	    SendClientMessage(target, COLOR_WHITE, "Inusualmente tus bolsillos est?n m?s flacos que hace un rato... ?Te han robado!");
		GivePlayerCash(target, -theft_money);
		GivePlayerCash(playerid, theft_money);
	}

	CooldownCMD_Apply(playerid, COOLDOWN_CMD_ID_CARTERISTA, .seconds = 30 * 60);
	return true;
}

CMD:hurtartienda(playerid, params[])
{
	if(!CooldownCMD_Check(playerid, COOLDOWN_CMD_ID_HURTARTIENDA))
		return 1;
	if(!JobThief_LevelCheck(playerid, .felonLevel = THIEF_SHOP_THEFT_LEVEL))
		return 1;
	if(!JobThief_IsPlayerStealingCheck(playerid))
		return 1;
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");

	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras dentro de un negocio.");
	if(KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_YELLOW2, "?No puedes robar este negocio!");

	Biz_ShowThiefMenu(playerid, bizid);
	return 1;
}

CMD:asaltartienda(playerid, params[])
{
	if(!CooldownCMD_Check(playerid, COOLDOWN_CMD_ID_ASALTARTIENDA))
		return 1;
	if(!JobThief_LevelCheck(playerid, .felonLevel = THIEF_SHOP_ROBBERY_LEVEL))
		return 1;
	if(!JobThief_IsPlayerStealingCheck(playerid))
		return 1;
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
	if(!hasFireGun(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener un arma de fuego en la mano.");


	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras dentro de un negocio.");
	if(KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
		return SendClientMessage(playerid, COLOR_YELLOW2, "?No puedes robar este negocio!");

    if(Business[bizid][bType] != BIZ_247 && Business[bizid][bType] != BIZ_CLOT &&
		Business[bizid][bType] != BIZ_CLOT2 && Business[bizid][bType] != BIZ_CLUB &&
		Business[bizid][bType] != BIZ_CLUB2 && Business[bizid][bType] != BIZ_REST &&
		Business[bizid][bType] != BIZ_HARD && Business[bizid][bType] != BIZ_PIZZERIA &&
		Business[bizid][bType] != BIZ_BURGER1 && Business[bizid][bType] != BIZ_BURGER2 &&
		Business[bizid][bType] != BIZ_BELL)
		return SendClientMessage(playerid, COLOR_YELLOW2, "Esta tienda no puede ser asaltada, busca otra.");

	thief_stealing[playerid] = 1;
	thief_timer_police_call[playerid] = (random(4)) ? (1 + random(25)) : (0); // 25 % de que no llame. Si llama lo hace dentro de los ?ltimos (1+X) segundos
	thief_timer_secs[playerid] = THIEF_SHOP_ROBBERY_DURATION;
	thief_type[playerid] = THIEF_SHOP_ROBBERY;
	thief_target[playerid] = bizid;
	thief_timer[playerid] = SetTimerEx("Thief_Countdown", 1000, true, "i", playerid);
	
	PlayerActionMessage(playerid, 15.0, "apunta al empleado con el arma y le hace una se?a para que le de todo el dinero.");
    ApplyAnimationEx(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
	PlayerInfo[playerid][pDisabled] = DISABLE_STEALING;
	CooldownCMD_Apply(playerid, COOLDOWN_CMD_ID_ASALTARTIENDA, .seconds = THIEF_SHOP_ROBBERY_COOLDOWN * 60);
	return 1;
}

forward RobberyCancel(playerid);
public RobberyCancel(playerid)
{
    SendClientMessage(thief_target[playerid], COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El robo ha sido cancelado porque no respondiste en 15 segundos.");
    SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El robo ha sido cancelado ya que la victima no ha respondido en 15 segundos.");
    
	thief_stealing[playerid] = 0;
	thief_type[playerid] = 0;
	thief_victim_of[thief_target[playerid]] = INVALID_PLAYER_ID;
	thief_target[playerid] = INVALID_PLAYER_ID;
	return 1;
}

JobThief_GiveLevelExp(playerid, level, exp)
{
	#pragma unused level

	if(PlayerInfo[playerid][pJob] != JOB_FELON || ThiefJobInfo[playerid][pFelonLevel] > 5)
		return 0;

	ThiefJobInfo[playerid][pFelonExp] += exp;
	SendFMessage(playerid, COLOR_WHITE, "Has recibido "COLOR_EMB_USAGE"+%i"COLOR_EMB_WHITE" (%.2f%s) puntos de experiencia para tu nivel actual de trabajo. Usa /verexp para ver tu progreso.", exp, float(exp) / float(JobThief_GetExpNeeded(playerid)) * 100.0, "%%");

	if(ThiefJobInfo[playerid][pFelonExp] >= JobThief_GetExpNeeded(playerid))
	{
		ThiefJobInfo[playerid][pFelonLevel]++;
		ThiefJobInfo[playerid][pFelonExp] = 0;
		SendFMessage(playerid, COLOR_LIGHTBLUE, "?Has subido a nivel %i en tu trabajo! Ahora eres un delincuente m?s experimentado y tienes acceso a nuevos comandos.", ThiefJobInfo[playerid][pFelonLevel]);
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	return 1;
}

JobThief_GetExpNeeded(playerid)
{
	switch(ThiefJobInfo[playerid][pFelonLevel])
	{
		case 1: return 210;
		case 2: return 810;
		case 3: return 3550;
		case 4: return 11000;
		case 5: return 77500;
	}
	return 1;
}

CMD:asaltar(playerid, params[])
{
	if(!CooldownCMD_Check(playerid, COOLDOWN_CMD_ID_ASALTAR))
		return 1;
	if(!JobThief_IsPlayerStealingCheck(playerid))
		return 1;
	if(PlayerInfo[playerid][pLevel] < 3)
		return SendClientMessage(playerid, COLOR_YELLOW2, "Este comando solo puede ser usado por personajes de nivel 3 o mayor.");
	if(PlayerInfo[playerid][pJailed] != JAIL_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo estando encarcelado.");

	new target;

	if(sscanf(params, "u", target))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/asaltar [ID/Jugador]");
	if(!IsPlayerLogged(target) || target == playerid)
		return SendClientMessage(playerid, COLOR_YELLOW2, "Jugador inv?lido.");
	if(PlayerInfo[playerid][pFaction] != 0 && PlayerInfo[target][pFaction] == PlayerInfo[playerid][pFaction])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No le puedes robar a un miembro de tu misma facci?n.");
	if(!hasFireGun(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener un arma de fuego en la mano.");
	if(!IsPlayerInRangeOfPlayer(4.0, playerid, target))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto se encuentra demasiado lejos.");
	if(PlayerInfo[target][pLevel] < 3)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No le puedes robar a un personaje menor de nivel 3.");

	new robbery_amount, string[128];

	if(GetPlayerCash(target) <= 0)
	{
		format(string, sizeof(string), "intenta robarle algo de dinero a %s pero al parecer no tiene nada.", GetPlayerCleanName(target));
		PlayerActionMessage(playerid, 15.0, string);
		return 1;
	}

	if(PlayerInfo[target][pDisabled] != DISABLE_DYING && PlayerInfo[target][pDisabled] != DISABLE_DEATHBED)
	{
		SendFMessage(playerid, COLOR_WHITE, "Has intentado robarle a %s, espera la reacci?n del sujeto...", GetPlayerCleanName(target));
		SendClientMessage(target, COLOR_WHITE, "Te est?n intentando robar, puedes usar '/resistirte', '/cooperar' o '/mentir'.");
		SendClientMessage(target, COLOR_WHITE, "Recuerda que si el ladr?n te descubre mintiendo se enfadar? y perder?s m?s dinero.");

		thief_stealing[playerid] = 1;
		thief_type[playerid] = THIEF_PERSON_ROBBERY;
		thief_target[playerid] = target;
		thief_victim_of[target] = playerid;
		thief_timer[playerid] = SetTimerEx("RobberyCancel", 15000, false, "i", playerid);
	}
	else
	{
		new target_money = GetPlayerCash(target);

		if(target_money <= 100) {
			robbery_amount = target_money;
		}
		else
		{
			robbery_amount = (target_money / 2) + random(target_money / 2);

			if(robbery_amount > 50000) {
				robbery_amount = 50000;
			}
		}
		
  		format(string, sizeof(string), "le ha robado algo de dinero a %s tomando provecho de su incapacidad.", GetPlayerCleanName(target));
 		PlayerActionMessage(playerid, 15.0, string);
		GivePlayerCash(playerid, robbery_amount);
		GivePlayerCash(target, -robbery_amount);
		CooldownCMD_Apply(playerid, COOLDOWN_CMD_ID_ASALTAR, .seconds = 60 * 60);
	}

	if(random(2))
	{
	    if(!HiddenName_IsActive(playerid))
	    {
			SetPlayerWantedLevelEx(playerid, GetPlayerWantedLevelEx(playerid) + 1);
			format(PlayerInfo[playerid][pAccusedOf], 64, "robo a mano armada");
			format(PlayerInfo[playerid][pAccusedBy], 24, "an?nimo");
		}
		
	 	new Float:px, Float:py, Float:pz, area[MAX_ZONE_NAME];
		GetPlayerPos(playerid, px, py, pz);
		GetCoords2DZone(px, py, area, MAX_ZONE_NAME);
		format(string, sizeof(string), "[911] Un civil report? un robo a mano armada en curso en la zona de %s.", area);
		SendFactionMessage(FAC_PMA, COLOR_CENTRALRED, string);
		SendFactionMessage(FAC_SIDE, COLOR_CENTRALRED, string);
    }
	return 1;
}

CMD:resistirte(playerid, params[])
{
	if(thief_victim_of[playerid] != INVALID_PLAYER_ID)
	{
	    if(thief_target[thief_victim_of[playerid]] == playerid && IsPlayerLogged(thief_victim_of[playerid]))
	    {
			PlayerActionMessage(playerid, 15.0, "forcejea con el ladr?n y se resiste al robo.");
			SendClientMessage(thief_victim_of[playerid], COLOR_WHITE, "La v?ctima se ha resistido y ha rechazado darte dinero.");
			ResetThiefCrime(thief_victim_of[playerid]);
			thief_victim_of[playerid] = INVALID_PLAYER_ID;
		}
	}
	return 1;
}

CMD:mentir(playerid, params[])
{
	new string[128],
	    target_money = GetPlayerCash(playerid),
	    thief_id = thief_victim_of[playerid];

	if(thief_id != INVALID_PLAYER_ID)
	{
		if(thief_target[thief_id] == playerid && IsPlayerLogged(thief_id))
 		{
 		    if(target_money > 1)
			{
			    if(!random(4))
				{
					format(string, sizeof(string), "intenta robarle algo de dinero a %s pero al parecer no tiene nada.", GetPlayerCleanName(playerid));
					PlayerActionMessage(thief_id, 15.0, string);
					SendClientMessage(playerid, COLOR_WHITE, "Has logrado enga?ar al delincuente exitosamente y no te ha robado dinero.");
			    }
				else
				{
			        PlayerActionMessage(playerid, 15.0, "le miente al ladr?n y le dice que no tiene dinero.");
		            format(string, sizeof(string), "se da cuenta del enga?o, se enfurece, y le roba gran parte de su dinero a %s.", GetPlayerCleanName(playerid));
		        	PlayerActionMessage(thief_id, 15.0, string);

		        	if(target_money > 50000) {
		        	    target_money = 50000;
					}

					GivePlayerCash(thief_id, target_money);
					GivePlayerCash(playerid, -target_money);
			    }
			}
			else
			{
				format(string, sizeof(string), "intenta robarle algo de dinero a %s pero al parecer no tiene nada.", GetPlayerCleanName(playerid));
				PlayerActionMessage(thief_id, 15.0, string);
			}

			ResetThiefCrime(thief_id);
			thief_victim_of[playerid] = INVALID_PLAYER_ID;
			CooldownCMD_Apply(thief_id, COOLDOWN_CMD_ID_ASALTAR, .seconds = 60 * 60);
		}
	}
	return 1;
}

CMD:cooperar(playerid, params[])
{
	new string[128],
	    target_money = GetPlayerCash(playerid),
		robbery_amount = target_money / 2 + random(target_money / 2),
		thief_id = thief_victim_of[playerid];

	if(thief_id != INVALID_PLAYER_ID)
	{
		if(thief_target[thief_id] == playerid && IsPlayerLogged(thief_id))
 		{
		    if(target_money > 1)
			{
				format(string, sizeof(string), "le ha robado algo de dinero a %s con su cooperaci?n.", GetPlayerCleanName(playerid));
				PlayerActionMessage(thief_id, 15.0, string);
				SendClientMessage(playerid, COLOR_YELLOW2, "Has cooperado y el ladr?n te ha robado algo de dinero.");
				
				if(robbery_amount > 50000) {
				    robbery_amount = 50000;
				}

				GivePlayerCash(thief_id, robbery_amount);
				GivePlayerCash(playerid, -robbery_amount);
			}
			else
			{
				format(string, sizeof(string), "intenta robarle algo de dinero a %s pero al parecer no tiene nada.", GetPlayerCleanName(playerid));
				PlayerActionMessage(thief_id, 15.0, string);
			}

			ResetThiefCrime(thief_id);
			thief_victim_of[playerid] = INVALID_PLAYER_ID;
			CooldownCMD_Apply(thief_id, COOLDOWN_CMD_ID_ASALTAR, .seconds = 60 * 60);
		}
	}
	return 1;
}

CMD:hurtar(playerid, params[])
{
	if(!CooldownCMD_Check(playerid, COOLDOWN_CMD_ID_HURTAR))
		return 1;
	if(!JobThief_IsPlayerStealingCheck(playerid))
		return 1;
	if(PlayerInfo[playerid][pLevel] < 3)
		return SendClientMessage(playerid, COLOR_YELLOW2, "Este comando solo puede ser usado por personajes de nivel 3 o mayor.");	
	if(PlayerInfo[playerid][pJailed] != JAIL_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo estando encarcelado.");

	new target;

	if(sscanf(params, "u", target))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/hurtar [ID/Jugador]");
	if(!IsPlayerLogged(target) || target == playerid)
		return SendClientMessage(playerid, COLOR_YELLOW2, "Jugador inv?lido.");
	if(IsPlayerInAnyVehicle(playerid) && Veh_GetModelType(GetPlayerVehicleID(playerid)) != VTYPE_BIKE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo desde un veh?culo.");
	if(PlayerInfo[playerid][pFaction] != 0 && PlayerInfo[target][pFaction] == PlayerInfo[playerid][pFaction])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No le puedes robar a un miembro de tu misma facci?n.");
	if(!IsPlayerInRangeOfPlayer(1.2, playerid, target))
		return SendClientMessage(playerid, COLOR_YELLOW2, "?Recuerda que debes estar cerca del bolsillo/cartera de la v?ctima!");
	if(PlayerInfo[target][pLevel] < 3)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No le puedes robar a un personaje menor de nivel 3.");
	if(GetPlayerCash(target) <= 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto no tiene nada de valor.");

	if(!random(3)) // 33 % de que falle.
	{
		new string[128];
		format(string, sizeof(string), "ha realizado unas maniobras para hurtar algo del bolsillo de %s pero es descubierto.", GetPlayerCleanName(target));
		PlayerActionMessage(playerid, 15.0, string);
		SendClientMessage(playerid, COLOR_WHITE, "?Has fallado y el sujeto lo ha notado, mejor comienza a correr!");
	}
	else
	{
		new target_money = GetPlayerCash(target), theft_money = 60 + random(40);

		if(theft_money > target_money) {
			theft_money = target_money;
		}

		SendFMessage(playerid, COLOR_WHITE, "Has tomado $%i del sujeto sin que ?ste se percate de lo sucedido, act?a como si nada hubiera pasado.", theft_money);
	    SendFMessage(target, COLOR_WHITE, "[OOC] El jugador ID %i te hurt? y no te diste cuenta. Esta informaci?n es s?lo para un eventual reporte y NO la puedes usar IC.", playerid);
		GivePlayerCash(target, -theft_money);
		GivePlayerCash(playerid, theft_money);
	}

	CooldownCMD_Apply(playerid, COOLDOWN_CMD_ID_HURTAR, .seconds = 30 * 60);
	return 1;
}

CMD:correr(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] != JOB_FELON)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener el trabajo de delincuente para utilizar este comando.");
	if(thief_type[playerid] == 700)
    {
        KillTimer(thief_cable_timer[playerid]);
        thief_cable_timer[playerid] = 0;

        thief_stealing[playerid] = 0;
        thief_type[playerid] = 0;
        thief_alerted[playerid] = false;
		thief_cable_pending[playerid] = false;

        TogglePlayerControllable(playerid, true);
        ClearAnimations(playerid);

        DisablePlayerCheckpoint(playerid);
	

        SendClientMessage(playerid, COLOR_YELLOW2, "Has huido del lugar y abandonado el robo de cables.");
		MapMarker_DeleteForPlayer(playerid, 0);
        return 1;
    }
	if(PlayerInfo[playerid][pDisabled] != DISABLE_STEALING)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar robando para utilizar este comando.");

	
	PlayerInfo[playerid][pDisabled] = DISABLE_NONE;
	PlayerCmeMessage(playerid, 15.0, 5000, "Abandona el robo en curso, dejando atr?s cualquier bot?n obtenido.");
	ResetThiefCrime(playerid);
	return 1;
}

CMD:verexp(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != JOB_FELON)
		return 1;

	SendFMessage(playerid, COLOR_WHITE, "[*Empleo de delincuente*] Nivel: %i - Experiencia: %i / %i - Progreso: "COLOR_EMB_USAGE"%.2f%s"COLOR_EMB_WHITE".", ThiefJobInfo[playerid][pFelonLevel], ThiefJobInfo[playerid][pFelonExp], JobThief_GetExpNeeded(playerid), float(ThiefJobInfo[playerid][pFelonExp]) / float(JobThief_GetExpNeeded(playerid)) * 100.0, "%%");
	return 1;
}

CMD:delincuenteayuda(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] == JOB_FELON)
	{
		SendClientMessage(playerid, COLOR_WHITE, "[Ladron]: /hurtartienda /asaltartienda /hurtarcasa /asaltarcasa /robarcables /verexp /correr (para interrumpir el robo)");
		SendClientMessage(playerid, COLOR_WHITE, "[Ladron de bancos]: /grupoayuda");
	    SendClientMessage(playerid, COLOR_WHITE, "[Ladron de veh?culos]: /barreta /puente /desarmar");
		SendClientMessage(playerid, COLOR_WHITE, "Info: al robar con un comando de tu nivel obtendr?s experiencia para subir de nivel y desbloquear nuevos comandos.");
	}
	return 1;
}

new Float:CablePositions[][5] = {
    {1970.68, -1826.22, 13.54, 218.02, Float:THIEF_CABLE_TYPE_POSTE},
    {2138.35, -1468.34, 23.98, 315.16, Float:THIEF_CABLE_TYPE_POSTE},
    {2138.37, -1404.39, 23.98, 354.95, Float:THIEF_CABLE_TYPE_POSTE},
    {2260.61, -1291.26, 23.97, 300.75, Float:THIEF_CABLE_TYPE_POSTE},
    {2180.76, -1499.88, 23.96, 102.72, Float:THIEF_CABLE_TYPE_POSTE},
    {2352.17, -1637.00, 15.76, 266.91, Float:THIEF_CABLE_TYPE_POSTE},
    {2404.10, -1936.30, 13.54, 149.09, Float:THIEF_CABLE_TYPE_POSTE},
    {2310.71, -2019.03, 13.54, 257.19, Float:THIEF_CABLE_TYPE_POSTE},
    {2271.28, -2013.68, 13.54, 311.71, Float:THIEF_CABLE_TYPE_POSTE},
    {2200.85, -1856.69, 13.45, 356.83, Float:THIEF_CABLE_TYPE_VIAS},
    {2235.47, -1586.70, 17.65, 336.15, Float:THIEF_CABLE_TYPE_VIAS},
    {2006.47, -1956.11, 13.54, 85.51, Float:THIEF_CABLE_TYPE_VIAS}
};



// ---------------------------------------------------------------------------
// /robarcables - pide ubicaci?n con el celular
// ---------------------------------------------------------------------------
CMD:robarcables(playerid, params[])
{
   	if(!CooldownCMD_Check(playerid, (e_COOLDOWN_CMD_ID:COOLDOWN_CMD_ID_ROBARCABLES)) && PlayerInfo[playerid][pAdmin] < 15)
        return 1;
    if(!JobThief_LevelCheck(playerid, THIEF_CABLE_ROBBERY_LEVEL))
        return 1;
    if(!JobThief_IsPlayerStealingCheck(playerid))
        return 1;

	new hand = SearchFreeHand(playerid);
    // Requiere tener un teléfono
	if(!PlayerInfo[playerid][pPhoneNumber])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ?No tienes un teléfono celular! consigue uno en un 24/7.");

	
	if(hand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ?Tienes ambas manos ocupadas!");
    PlayerActionMessage(playerid, 15.0, "toma su teléfono celular del bolsillo.");
	SetHandItemAndParam(playerid, hand, ITEM_ID_TELEFONO_CELULAR, 1);
    TogglePlayerControllable(playerid, false);
	ApplyAnimationEx(playerid, "PED", "phone_in", 4.0, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true);
	SetTimerEx("Thief_Cable_PlayPhoneLoop", 1500, false, "i", playerid);
	thief_cable_pending[playerid] = true;
    SetTimerEx("Thief_Cable_AssignPickup", 3000, false, "i", playerid);
    CooldownCMD_Apply(playerid, (e_COOLDOWN_CMD_ID:COOLDOWN_CMD_ID_ROBARCABLES), THIEF_CABLE_ROBBERY_COOLDOWN * 60);
	SetHandItemAndParam(playerid, hand, 0, 0);
	SendClientMessage(playerid, COLOR_ERROR, "[AVISO]: Record? tener una de las manos libres.");
    return 1;
}

forward Thief_Cable_PlayPhoneLoop(playerid);
public Thief_Cable_PlayPhoneLoop(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    ApplyAnimationEx(playerid, "PED", "phone_talk", 4.0, 1, 0, 0, 0, 0, .forcesync = 1);
    SetTimerEx("Thief_Cable_EndPhoneAnim", 5000, false, "i", playerid);
	SendClientMessage(playerid, COLOR_WHITE, "[Comprador]: Pibe, ahora te paso una ubicaci?n segura para lucrar cobre...");
    return 1;
}

forward Thief_Cable_EndPhoneAnim(playerid);
public Thief_Cable_EndPhoneAnim(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    ClearAnimations(playerid);
    TogglePlayerControllable(playerid, true);
    return 1;
}

// ---------------------------------------------------------------------------
// Asigna ubicaci?n y crea el pickup
// ---------------------------------------------------------------------------
forward Thief_Cable_AssignPickup(playerid);
public Thief_Cable_AssignPickup(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    if(IsValidDynamicPickup(thief_cable_pickup[playerid]))
    {
        DestroyDynamicPickup(thief_cable_pickup[playerid]);
        thief_cable_pickup[playerid] = INVALID_STREAMER_ID;
    }

	DisablePlayerCheckpoint(playerid);

    new idx = random(sizeof(CablePositions));
    thief_cable_type[playerid] = _:CablePositions[idx][4];

    new Float:x = CablePositions[idx][0];
    new Float:y = CablePositions[idx][1];
    new Float:z = CablePositions[idx][2];

	thief_cable_x[playerid] = x;
    thief_cable_y[playerid] = y;
    thief_cable_z[playerid] = z;

    thief_cable_pickup[playerid] = CreateDynamicPickup(CABLE_PICKUP_MODEL, CABLE_PICKUP_TYPE, x, y, z, 0);
	MapMarker_CreateForPlayer(playerid, x, y, z, .color = COLOR_RED, .time = 600000); // dura 10 minutos
    SendClientMessage(playerid, COLOR_WHITE, "Se marc? una ubicaci?n en tu GPS. Dir?gete al punto rojo para comenzar el robo.");
    return 1;
}

// ---------------------------------------------------------------------------
// Comienza el robo al tocar el pickup
// ---------------------------------------------------------------------------
forward Thief_Cable_OnPickup(playerid, pickupid);
public Thief_Cable_OnPickup(playerid, pickupid)
{
    if(pickupid != thief_cable_pickup[playerid]) return 1;

    DestroyDynamicPickup(thief_cable_pickup[playerid]);
    thief_cable_pickup[playerid] = INVALID_STREAMER_ID;
    DisablePlayerCheckpoint(playerid);

    thief_stealing[playerid] = 1;
    thief_type[playerid] = 700;
    thief_timer_secs[playerid] = THIEF_CABLE_ROBBERY_DURATION;
	thief_cable_shock_pending[playerid] = (random(100) < 10);

    new hour, minute;
    gettime(hour, minute);
    new chance = (hour >= 6 && hour < 21) ? THIEF_CABLE_POLICE_DAY : THIEF_CABLE_POLICE_NIGHT;
    thief_timer_police_call[playerid] = (random(100) < chance) ? (1 + random(THIEF_CABLE_ROBBERY_DURATION - 1)) : 0;

    TogglePlayerControllable(playerid, false);
    ClearAnimations(playerid);

    if(thief_cable_type[playerid] == THIEF_CABLE_TYPE_POSTE)
    {
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);

		thief_cable_origZ[playerid] = z; // guardamos la altura original
		thief_cable_climbing[playerid] = true;

		ApplyAnimationEx(playerid, "PED", "CLIMB_JUMP", 4.0, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
		PlayerActionMessage(playerid, 15.0, "se trepa al poste para alcanzar los cables...");

		// Llama al primer paso de la escalada
		SetTimerEx("Thief_Cable_ClimbStep", 300, false, "fffff", playerid, x, y, z, z + 4.5);

    }
    else
    {
        ApplyAnimationEx(playerid, "BOMBER", "BOM_PLANT", 4.0, 1, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
		PlayerActionMessage(playerid, 15.0, "se agacha y comienza a cortar cables de las v?as...");
    }

    thief_cable_timer[playerid] = SetTimerEx("Thief_Cable_Process", 1000, true, "i", playerid);
    return 1;
}

// ---------------------------------------------------------------------------
// Timer de proceso
// ---------------------------------------------------------------------------

forward Thief_Cable_ClimbStep(playerid, Float:x, Float:y, Float:z, Float:endZ);
public Thief_Cable_ClimbStep(playerid, Float:x, Float:y, Float:z, Float:endZ)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(!thief_cable_climbing[playerid]) return 1;

    // Si ya lleg? a la altura deseada, detener la escalada
    if(z >= endZ)
    {
        thief_cable_climbing[playerid] = false;
        ApplyAnimationEx(playerid, "CARRY", "CRRY_PRTIAL", 4.0, 1, 0, 0, 0, 0,
            .forcesync = 1, .autofinish = false, .finishAnimId = 0);
        PlayerActionMessage(playerid, 15.0, "comienza a cortar cables desde la parte superior del poste.");
        return 1;
    }

    SetPlayerPos(playerid, x, y, z);
    SetTimerEx("Thief_Cable_ClimbStep", 300, false, "fffff", playerid, x, y, z + 0.5, endZ);
    return 1;
}

forward Thief_Cable_Process(playerid);
public Thief_Cable_Process(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    if(thief_timer_secs[playerid] > 0)
    {
        if(thief_timer_police_call[playerid] && thief_timer_secs[playerid] == thief_timer_police_call[playerid])
        {
            RobberyAlert(playerid, "robo de cables", "an?nimo");
            SendClientMessage(playerid, COLOR_LIGHTRED, "?Un civil ha alertado a la polic?a!");
			SendClientMessage(playerid, COLOR_YELLOW2, "Pod?s usar /correr para escapar del lugar y cancelar el robo.");
    		thief_alerted[playerid] = true;
        }

        new msg[64];
        format(msg, sizeof(msg), "~w~Robando cables ~r~%d~w~ segundos", thief_timer_secs[playerid]);
        GameTextForPlayer(playerid, msg, 1000, 4);

		if(thief_cable_shock_pending[playerid])
		{
			thief_cable_shock_pending[playerid] = false;

			new Float:hp;
			GetPlayerHealth(playerid, hp);

			new Float:newhp = hp * 0.5;
			if(newhp < 15.0)
			{
				// Evitar "curar" si ya estaba por debajo de 15 de vida
				newhp = (hp < 15.0) ? hp : 15.0;
			}

			SetPlayerHealth(playerid, newhp);
			SendClientMessage(playerid, COLOR_LIGHTRED, "Recibes una patada el?ctrica mientras cortas el cable. Tu salud se reduce.");
		}

		new Float:px, Float:py, Float:pz;
		GetPlayerPos(playerid, px, py, pz);

		if(GetPlayerDistanceFromPoint(playerid, thief_cable_x[playerid], thief_cable_y[playerid], thief_cable_z[playerid]) > 6.0)
		{
			SendClientMessage(playerid, COLOR_YELLOW2, "Te has alejado demasiado del lugar del robo. Lo has cancelado.");
			
			cmd_correr(playerid, "");
			return 1;
		}
        thief_timer_secs[playerid]--;
    }
    else
    {
	if(thief_cable_type[playerid] == THIEF_CABLE_TYPE_POSTE)
	{
    	new Float:x, Float:y;
    	GetPlayerPos(playerid, x, y, thief_cable_origZ[playerid]);
    	SetPlayerPos(playerid, x, y, thief_cable_origZ[playerid]);
	}
    KillTimer(thief_cable_timer[playerid]);
    thief_cable_timer[playerid] = 0;

    thief_stealing[playerid] = 0;
    thief_type[playerid] = 0;
    TogglePlayerControllable(playerid, true);
    ClearAnimations(playerid);

	DisablePlayerCheckpoint(playerid);
   	MapMarker_DeleteForPlayer(playerid, 0);


    if(GetHandItem(playerid, HAND_RIGHT) == 0)
        SetHandItemAndParam(playerid, HAND_RIGHT, ITEM_ID_COPPER_WIRE, 1);
        else
        SetHandItemAndParam(playerid, HAND_LEFT, ITEM_ID_COPPER_WIRE, 1);

	thief_cable_pending[playerid] = false;
    SendClientMessage(playerid, COLOR_WHITE, "Has robado un conjunto de cables de cobre.");
    JobThief_GiveLevelExp(playerid, THIEF_CABLE_ROBBERY_LEVEL, 10);
    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
    }
    return 1;
}

// ---------------------------------------------------------------------------
// Limpieza segura
// ---------------------------------------------------------------------------
forward Thief_Cable_OnDisconnect(playerid);
public Thief_Cable_OnDisconnect(playerid)
{
    if(IsValidDynamicPickup(thief_cable_pickup[playerid]))
    {
        DestroyDynamicPickup(thief_cable_pickup[playerid]);
        thief_cable_pickup[playerid] = INVALID_STREAMER_ID;
		thief_cable_pending[playerid] = false;
    }
	thief_cable_shock_pending[playerid] = false;
    return 1;
}


hook OnPlayerEnterCheckpoint(playerid)
{

    if(thief_cable_pickup[playerid] == INVALID_STREAMER_ID)
        return 1;

    // Destruir pickup y checkpoint
    if(IsValidDynamicPickup(thief_cable_pickup[playerid]))
    {
        DestroyDynamicPickup(thief_cable_pickup[playerid]);
        thief_cable_pickup[playerid] = INVALID_STREAMER_ID;
    }
    DisablePlayerCheckpoint(playerid);

    // Inicia el proceso de robo
    Thief_Cable_OnPickup(playerid, INVALID_STREAMER_ID);
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DLG_THIEF_REWARDS)
    {
        if (!response) return 1; // Cerrar

        if (PlayerInfo[playerid][pAdmin] < 20)
            return SendClientMessage(playerid, COLOR_RED, "Necesitas nivel de admin 20 para editar recompensas.");

        // Convertir listitem al ?ndice del iterador
        new count = 0;
        foreach (new i : ThiefRewardIter)
        {
            if (count == listitem)
            {
                thief_edit_reward_idx[playerid] = i;
                
                new dialog[256];
                format(dialog, sizeof dialog, "{FFFFFF}Est?s editando la recompensa de: {FFFF00}%s\n\n{FFFFFF}Valor actual: {00FF00}$%.0f\n\n{AAAAAA}Ingresa el nuevo valor en pesos:", ThiefRewards[i][trAction], ThiefRewards[i][trValue]);
                
                ShowPlayerDialog(playerid, DLG_THIEF_EDIT_REWARD, DIALOG_STYLE_INPUT, "{FFFFFF}Editar Recompensa", dialog, "Guardar", "Volver");
                return 1;
            }
            count++;
        }
        return 1;
    }

    if (dialogid == DLG_THIEF_EDIT_REWARD)
    {
        if (!response)
        {
            // Volver al men? principal
            cmd_verrecladron(playerid, "");
            return 1;
        }

        new Float:value = floatstr(inputtext);

        if (value < 0.0)
        {
            SendClientMessage(playerid, COLOR_RED, "El valor no puede ser negativo.");
            // Volver al men? principal
            cmd_verrecladron(playerid, "");
            return 1;
        }

        new idx = thief_edit_reward_idx[playerid];
        new old_value = floatround(ThiefRewards[idx][trValue]);
        ThiefRewards[idx][trValue] = value;

        // Actualizar en base de datos
        new query[256];
        mysql_format(MYSQL_HANDLE, query, sizeof query,
            "UPDATE thief_rewards SET reward = %.2f WHERE action_name = '%s' LIMIT 1;",
            value, ThiefRewards[idx][trAction]);
        mysql_tquery(MYSQL_HANDLE, query);

        new msg[128];
        format(msg, sizeof msg, "Recompensa '%s' actualizada de $%d a $%.0f.",
            ThiefRewards[idx][trAction], old_value, value);
        SendClientMessage(playerid, COLOR_GREEN, msg);

        // Log administrativo
        ServerFormattedLog(LOG_TYPE_ID_ADMIN, .entry="/verrecladron", .playerid=playerid, .params=<"%s: $%d -> $%.0f", ThiefRewards[idx][trAction], old_value, value>);

        // Volver al men? actualizado
        cmd_verrecladron(playerid, "");
        return 1;
    }

    return 0;
}


CMD:verrecladron(playerid, params[])
{
    if(AccountInfo[playerid][accAdminLevel] < 14)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

    new str[1024], line[96];
    str[0] = EOS;

    foreach (new i : ThiefRewardIter)
    {
        format(line, sizeof line, "%s\t$%.0f\n",
               ThiefRewards[i][trAction],
               ThiefRewards[i][trValue]);
        strcat(str, line);
    }

    ShowPlayerDialog(playerid, DLG_THIEF_REWARDS, DIALOG_STYLE_TABLIST,
        "{FFFFFF}Recompensas del Job Ladr?n", str, "Editar", "Cerrar");
    return 1;
}

CMD:setrecladron(playerid, params[])
{
    // Ahora redirige al comando con di?logos
    return cmd_verrecladron(playerid, params);
}




