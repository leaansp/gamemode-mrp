#if defined _marp_missions_included
	#endinput
#endif
#define _marp_missions_included

#include <YSI_Coding\y_hooks>

#define MISSION_EVENT_TIME      50 // En minutos, tiempo mínimo entre misiones.
#define MISSION_EVENT_EXTRATIME 20 // En minutos, máximo que se le puede agregar al tiempo mínimo entre misiones.

#define NUM_MISSION          	424

#define MAX_MISSION_CAR_POS     3

#define MISSION_MATS_REWARD     500 // Recompensa en dinero por la misión.
#define MISSION_MATS_EXTRA      2500 //  Recompensa en dinero por cada miembro acompañante.
#define MISSION_MATS_BOX        75	 // Materiales por caja.
#define MISSION_MATS_BOX_EXTRA  45   // Extra * cantidad de gente en el vehículo.

static enum
{
/*0*/ MISSION_NONE,
/*1*/ MISSION_MAT,
/*2*/ MISSION_CAR,
/*LEAVE LAST*/ MISSIONS_AMOUNT
}

new pMissionEvent[MAX_PLAYERS],
	pMissionEventTimer[MAX_PLAYERS],
	pMissionEventStep[MAX_PLAYERS],
	pMissionEventParam[MAX_PLAYERS],
	pMissionEventParam2[MAX_PLAYERS];

static const Float:MissionCarPos[MAX_MISSION_CAR_POS][3] = {
	{91.0594, -164.6225, 2.5036},
	{2351.7014, -651.6862, 127.9594},
	{1273.6932, 154.2808, 20.1258}
};

//============================FUNCIONES PUBLICAS================================

forward CreateMissionEventTimer(playerid); // Crea el timer inicial que le dará misiones a playerid mientras esté conectado.
forward KillMissionEventTimer(playerid); // Destruye el timer que genera misiones a playerid.
forward ResetMissionEventVariables(playerid); // Resetea a valores default las variables del sistema.

forward bool:CheckMissionEvent(playerid, step, text[] = "NULO");
// Chequea si hay alguna mision activa y de ser asi devuelve true y ejecuta el codigo, de lo contrario false.
// El parametro 'text' es opcional y sirve para guardar, si fuese necesario, el texto que contiene alguna respuesta del jugador ante una pregunta de la mision.
// 'step' indica que etapa tiene que ejecutar

forward bool:PlayerCancelMissionEvent(playerid); // Devuelve true si se efectuó exitosamente la cancelación de la mision activa en la etapa 1.

//============================FUNCIONES INTERNAS================================

forward MissionEvent(playerid); // Public para crear las misiones. Utilizado por el timer principal.
forward CancelMissionEvent(playerid); // Cancela la mision si no respondió en cierto tiempo.

forward bool:MissionMaterials(playerid, step, text[]); // Todo el codigo separado en etapas de la misión en cuestión.
forward bool:MissionCar(playerid, step, text[]);

forward MissionMaterialsLoad(playerid, vehicleid); // Public correspondiente a la carga de materiales de la mision MISSION_MAT.
forward MissionMaterialsUnload(playerid, matsCount, vehicleid); // Public correspondiente a la descarga de materiales de la mision MISSION_MAT que termina la misión.

//=========================IMPLEMENTACIÓN DE FUNCIONES==========================

stock CreateMissionEventTimer(playerid)
{
	if(PlayerInfo[playerid][pFaction] > 0 && FactionInfo[PlayerInfo[playerid][pFaction]][fType] == FAC_TYPE_ILLEGAL)
	    pMissionEventTimer[playerid] = SetTimerEx("MissionEvent", 60 * 1000 * (MISSION_EVENT_TIME + random(MISSION_EVENT_EXTRATIME)), false, "i", playerid); // No es recursivo para hacer uso del random en tiempo.
}

stock KillMissionEventTimer(playerid)
{
	KillTimer(pMissionEventTimer[playerid]);
}

stock ResetMissionEventVariables(playerid)
{
	pMissionEvent[playerid] = MISSION_NONE;
	pMissionEventStep[playerid] = 0;
	pMissionEventParam[playerid] = 0;
	pMissionEventParam2[playerid] = 0;
}

CMD:missioneventdebug(playerid, params[])
{
	new targetid;
	
	if(PlayerInfo[playerid][pAdmin] < 20)
	    return 1;
	if(sscanf(params, "i", targetid))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/missioneventdebug [playerid]");
	if(targetid < 0 || targetid >= MAX_PLAYERS)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Jugador inválido.");

	SendFMessage(playerid, COLOR_YELLOW, "pMissionEvent [%d] = %d", targetid, pMissionEvent[targetid]);
	SendFMessage(playerid, COLOR_YELLOW, "pMissionEventStep [%d] = %d", targetid, pMissionEventStep[targetid]);
	SendFMessage(playerid, COLOR_YELLOW, "pMissionEventParam [%d] = %d", targetid, pMissionEventParam[targetid]);
	SendFMessage(playerid, COLOR_YELLOW, "pMissionEventParam2 [%d] = %d", targetid, pMissionEventParam2[targetid]);
	SendFMessage(playerid, COLOR_YELLOW, "pMissionEventTimer [%d] = %d", targetid, pMissionEventTimer[targetid]);
	return 1;
}

public MissionEvent(playerid)
{
	new factionID = PlayerInfo[playerid][pFaction];
	// Creamos el timer que llamará a la próxima misión.
	pMissionEventTimer[playerid] = SetTimerEx("MissionEvent", 60 * 1000 * (MISSION_EVENT_TIME + random(MISSION_EVENT_EXTRATIME)), false, "i", playerid);

	if(PlayerInfo[playerid][pJailed] != JAIL_NONE || random(2) == 0 || pMissionEvent[playerid] != MISSION_NONE)
	    return 1;

	if(factionID > 0 && FactionInfo[factionID][fType] == FAC_TYPE_ILLEGAL)
	{
		PlayerDoMessage(playerid, 15.0, "Un teléfono ha comenzado a sonar");
		SendClientMessage(playerid, COLOR_WHITE, "Tienes una llamada, utiliza /atender o /colgar.");
		pMissionEvent[playerid] = 1 + random(MISSIONS_AMOUNT - 1); // Tipo de misión aleatorio.
		SetTimerEx("CancelMissionEvent", 35000, false, "i", playerid);
		pMissionEventStep[playerid] = 1;
	}
	return 1;
}

public CancelMissionEvent(playerid)
{
	if(pMissionEventStep[playerid] == 1)
 	{
		PlayerDoMessage(playerid, 15.0, "Han colgado...");
        ResetMissionEventVariables(playerid);
	}
	return 1;
}

stock bool:PlayerCancelMissionEvent(playerid)
{
	if(pMissionEventStep[playerid] == 1)
	{
	    PlayerActionMessage(playerid, 15.0, "cuelga la llamada y guarda su teléfono celular en el bolsillo.");
     	ResetMissionEventVariables(playerid);
	    return true;
	}
	return false;
}

hook function OnPlayerEnterCPId(playerid, checkpointid)
{
	if(CheckMissionEvent(playerid, 4)) 
		return 1;
	else if(CheckMissionEvent(playerid, 5))
		return 1;

	return continue(playerid, checkpointid);
}

stock bool:CheckMissionEvent(playerid, step, text[] = "NULO")
{
	switch(pMissionEvent[playerid])
	{
	    case MISSION_NONE:
			return false;
	    case MISSION_MAT:
			return MissionMaterials(playerid, step, text);
	    case MISSION_CAR:
			return MissionCar(playerid, step, text);
	}
	return false;
}

stock bool:MissionCar(playerid, step, text[])
{
	if(step != pMissionEventStep[playerid])
	    return false;
	    
	switch(step)
	{
		case 1: // Atender la llamada.
		{
		    PlayerActionMessage(playerid, 15.0, "saca su teléfono y atiende la llamada.");
			SendClientMessage(playerid, COLOR_FADE1, "[Voz al teléfono]: tengo un trabajo para vos: conseguime el auto que te indique. Dinero fácil, ¿qué pensás?");
	        Mobile[playerid] = NUM_MISSION;
			pMissionEventStep[playerid] = 2;
		}
		case 2: // Responder si está interesado o no
		{
			if(Mobile[playerid] == NUM_MISSION)
			{
				if((strcmp("si", text, true) == 0) && (strlen(text) == strlen("si")))
				{
					new bool:isCar = false,
			            vehicleid;

			        while(isCar == false)
			        {
			   			vehicleid = 1 + random(MAX_VEH - 1);
			        	if((VehicleInfo[vehicleid][VehType] == VEH_OWNED || VehicleInfo[vehicleid][VehType] == VEH_FACTION) && Veh_GetModelType(vehicleid) == VTYPE_CAR)
			        	    isCar = true;
					}
					pMissionEventParam[playerid] = vehicleid;
					pMissionEventStep[playerid] = 3;
					SendFMessage(playerid, COLOR_FADE1, "[Voz al teléfono]: Escucha, necesito que me consigas un %s en buen estado. ¿Podés hacerlo?", Veh_GetName(vehicleid));
				}
				else if((strcmp("no", text, true) == 0) && (strlen(text) == strlen("no")))
				{
		 			SendClientMessage(playerid, COLOR_FADE1, "[Voz al teléfono]: vos te lo perdés, chau...");
		            PlayerActionMessage(playerid, 15.0, "cuelga la llamada y guarda su teléfono celular en el bolsillo.");
		            Mobile[playerid] = 255;
		            ResetMissionEventVariables(playerid);
	            }
				else
					SendClientMessage(playerid, COLOR_FADE1, "[Voz al teléfono]: ¡No tengo tiempo para vueltas, di 'si' o 'no'!");
			}
		}
		case 3: // Responder si acepta o no
		{
        	if((strcmp("si", text, true) == 0) && (strlen(text) == strlen("si")))
			{
				SendClientMessage(playerid, COLOR_FADE1, "[Voz al teléfono]: Perfecto, llevame rápidamente el vehículo al lugar que te pasé por el celular.");
				new rnd = random(MAX_MISSION_CAR_POS);
				SetPlayerCheckpoint(playerid, MissionCarPos[rnd][0], MissionCarPos[rnd][1], MissionCarPos[rnd][2], 3.0);
				pMissionEventStep[playerid] = 4;
			    Mobile[playerid] = 255;
           		jobDuty[playerid] = true;
				PlayerActionMessage(playerid, 15.0, "cuelga la llamada y guarda su teléfono celular en el bolsillo.");
			}
			else if((strcmp("no", text, true) == 0) && (strlen(text) == strlen("no")))
			{
				SendClientMessage(playerid, COLOR_FADE1, "[Voz al teléfono]: vos te lo perdés, adiós...");
		        PlayerActionMessage(playerid, 15.0, "cuelga la llamada y guarda su teléfono celular en el bolsillo.");
		        Mobile[playerid] = 255;
            	ResetMissionEventVariables(playerid);
			}
			else
				SendClientMessage(playerid, COLOR_FADE1, "[Voz al teléfono]: ¡No tengo tiempo para vueltas, decime 'si' o 'no'!");
		}
		case 4: // Entregar el auto
		{
  			new vehicleid = GetPlayerVehicleID(playerid);
			if(GetVehicleModel(vehicleid) == GetVehicleModel(pMissionEventParam[playerid]))
			{
				if(!KeyChain_Contains(playerid, KEY_TYPE_VEHICLE, vehicleid))
      			{
      			    new Float:vhp;
      			    GetVehicleHealth(vehicleid, vhp);
      			    if(vhp > 500.0 && VehicleInfo[vehicleid][VehEngine] == 1)
      			    {
						new price = Veh_GetPrice(vehicleid) / 360;
      			        if(price < 1000)
						  	price = 1000;
      			        SendFMessage(playerid, COLOR_WHITE, "Sujeto desconocido: Bien, en tiempo y forma. Acá hay $%d por el auto. Nunca nos vimos.", price);
						GivePlayerCash(playerid, price);
						HideStolenCar(vehicleid);
						PlayerActionMessage(playerid, 15.0, "le entrega un vehículo a un sujeto desconocido y recibe a cambio un paquete.");
				  	} else
      			        SendClientMessage(playerid, COLOR_WHITE, "Sujeto desconocido: Te dije que estuviese en buen estado y andando, no esta porquería. Dios mio...");
      			} else
	    			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No podes entregar un auto del cual tienes las llaves. Se anula la misión.");
			} else
			    SendClientMessage(playerid, COLOR_WHITE, "Sujeto desconocido: ¿Y el auto que te pedí...? Me haces perder el tiempo.");
        	ResetMissionEventVariables(playerid);
		}
	}
	return true;
}

stock bool:MissionMaterials(playerid, step, text[])
{
	new vehicleid = GetPlayerVehicleID(playerid),
	    factionid = PlayerInfo[playerid][pFaction];

	if(step != pMissionEventStep[playerid])
	    return false;
	    
	switch(step)
	{
		case 1: // Atender la llamada
		{
		    PlayerActionMessage(playerid, 15.0, "saca su teléfono y atiende la llamada.");
			SendClientMessage(playerid, COLOR_FADE1, "[Voz al teléfono]: nos ha llegado un cargamento de materiales, ¿vienes a buscarlo? También recibirás efectivo.");
	        Mobile[playerid] = NUM_MISSION;
			pMissionEventStep[playerid] = 2;
		}
		case 2: // Responder si acepta o no
		{
			if(Mobile[playerid] == NUM_MISSION)
			{
				if((strcmp("si", text, true) == 0) && (strlen(text) == strlen("si")))
				{
					SendClientMessage(playerid, COLOR_FADE1, "[Voz al teléfono]: bien, súbete a la van y di 'listo' una vez arriba.");
		   			pMissionEventStep[playerid] = 3;
				    jobDuty[playerid] = true;
				    SetVehicleParamsForPlayer(FactionInfo[PlayerInfo[playerid][pFaction]][fMissionVeh], playerid, 1, 0);
				}
				else if((strcmp("no", text, true) == 0) && (strlen(text) == strlen("no")))
				{
		 			SendClientMessage(playerid, COLOR_FADE1, "[Voz al teléfono]: tú te lo pierdes, adiós...");
		            PlayerActionMessage(playerid, 15.0, "cuelga la llamada y guarda su teléfono celular en el bolsillo.");
		            Mobile[playerid] = 255;
		            ResetMissionEventVariables(playerid);
	            }
				else
					SendClientMessage(playerid, COLOR_FADE1, "[Voz al teléfono]: ¡No tengo tiempo para vueltas, di 'si' o 'no'!");
			}
		}
		case 3: // Responder 'listo' cuando esté en la van
		{
		    if(Mobile[playerid] == NUM_MISSION)
		    {
				if((strcmp("listo", text, true) == 0) && (strlen(text) == strlen("listo")))
				{
                    if(vehicleid == FactionInfo[factionid][fMissionVeh])
					{
						SendClientMessage(playerid, COLOR_FADE1, "[Voz al teléfono]: te he pasado la dirección a tu celular. Vé a buscar los paquetes y llévalos a tu HQ.");
						SetPlayerCheckpoint(playerid, 2792.4609, -2417.5508, 13.7599, 3.0);
						pMissionEventStep[playerid] = 4;
						Mobile[playerid] = 255;
						PlayerActionMessage(playerid, 15.0, "cuelga la llamada y guarda su teléfono celular en el bolsillo.");
                	} else
					    SendClientMessage(playerid, COLOR_FADE1, "[Voz al teléfono]: ¡súbete a la van, no tengo tiempo para vueltas!");
			 	} else
					SendClientMessage(playerid, COLOR_FADE1, "[Voz al teléfono]: ¡no tengo tiempo para vueltas, di 'listo' una vez arriba!");
			}
		}
		case 4: // Carga de materiales cuando llega a destino
		{
			if(FactionInfo[factionid][fMissionVeh] == vehicleid)
			{
				GameTextForPlayer(playerid, "Cargando materiales en el vehiculo...", 6000, 4);
				TogglePlayerControllable(playerid, false);
				SetTimerEx("MissionMaterialsLoad", 6000, false, "ii", playerid, vehicleid);
			} else {
				SetPlayerPos(playerid, 2767.2983, -2417.6804, 13.7573);
				SetPlayerCheckpoint(playerid, 2792.4609, -2417.5508, 13.7599, 3.0);
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en el vehículo de la misión.");
			}
		}
		case 5: // Descarga de materiales cuando llege a destino HQ
		{
			if(FactionInfo[factionid][fMissionVeh] == vehicleid)
			{
				new matsCount = pMissionEventParam[playerid];
				FactionInfo[factionid][fMaterials] += matsCount;
				GameTextForPlayer(playerid, "Descargando materiales del vehiculo...", 6000, 4);
				TogglePlayerControllable(playerid, false);
				SetTimerEx("MissionMaterialsUnload", 6000, false, "iii", playerid, matsCount, vehicleid);
			} else {
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debías estar en el vehículo de la misión. ¡Lo has perdido! Se anula la misión.");
                ResetMissionEventVariables(playerid);
                jobDuty[playerid] = false;
			}
		}
	}
	return true;
}

//=================CARGA DE MATERIALES POR MISION PARA MAFIAS===================

public MissionMaterialsLoad(playerid, vehicleid)
{
	TogglePlayerControllable(playerid, true);

	pMissionEventParam[playerid] = MISSION_MATS_BOX;

	foreach(new i : Player)
	{
		if(playerid != i && PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction] && GetPlayerVehicleID(i) == vehicleid) {
			pMissionEventParam[playerid] += MISSION_MATS_BOX_EXTRA;
		}
	}

	pMissionEventStep[playerid] = 5;
	SetPlayerCheckpoint(playerid, VehicleInfo[vehicleid][VehPosX], VehicleInfo[vehicleid][VehPosY], VehicleInfo[vehicleid][VehPosZ], 3.0);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "SMS de anónimo: vuelve al HQ con la carga. Solo alguien con experiencia podrá ensamblarlas.");
	return 1;
}

//================DESCARGA DE MATERIALES POR MISION PARA MAFIAS=================

public MissionMaterialsUnload(playerid, matsCount, vehicleid)
{
	TogglePlayerControllable(playerid, true);
	SetVehicleParamsForPlayer(vehicleid, playerid, 0, 0);
	jobDuty[playerid] = false;
	SendFMessage(playerid, COLOR_WHITE, "Has descargado %d materiales en el HQ y recibido una ganancia de $%d.", matsCount, MISSION_MATS_REWARD + MISSION_MATS_EXTRA * pMissionEventParam[playerid]);
	GivePlayerCash(playerid, MISSION_MATS_REWARD + MISSION_MATS_EXTRA * pMissionEventParam[playerid]);
	SetVehicleToRespawn(vehicleid);
 	ResetMissionEventVariables(playerid);
    return 1;
}
