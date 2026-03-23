#if defined _marp_ctr_included
	#endinput
#endif
#define _marp_ctr_included

#include <YSI_Coding\y_hooks>

#define PRICE_ADVERTISE 100

static PHONE_HANDLE:Phone_ACEMA_id;

hook OnGameModeInitEnded()
{
	Phone_ACEMA_id = Phone_Create(3900, INVALID_PLAYER_ID);
	return 1;
}

hook OnGameModeExit()
{
	Phone_Delete(Phone_ACEMA_id);
	return 1;
}

hook function OnSMSReceived(PHONE_HANDLE:phone, from_number)
{
	if(phone == Phone_ACEMA_id)
	{
		new str[180];

		format(str, sizeof(str), "Gracias por comunicarte con %s, la radio número uno. Tu mensaje fue recibido por el operador.", FactionInfo[FAC_MAN][fName]);
		PhoneSMS_Send(phone, from_number, str);

		PhoneSMS_GetFirst(PHONE_HANDLE:phone, from_number, str);
		format(str, sizeof(str), "[%s] SMS del %i: %s", FactionInfo[FAC_MAN][fName], from_number, str);
		SendFactionMessage(FAC_MAN, COLOR_WHITE, str);
	}
	
	return continue(_:phone, from_number);
}

// Sistema de entrevistas para CTR-MAN
new InterviewOffer[MAX_PLAYERS],
	bool:InterviewActive[MAX_PLAYERS];

CMD:pronostico(playerid, params[])
{
    new closestVeh = GetClosestVehicle(playerid, 7.0);
    
	if(PlayerInfo[playerid][pFaction] != FAC_MAN)
		return 1;
  	if(!IsPlayerInAnyVehicle(playerid) && (closestVeh == INVALID_VEHICLE_ID || VehicleInfo[closestVeh][VehFaction] != FAC_MAN) && Bld_GetPlayerLastId(playerid) != BLD_MAN)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Para ver el pronóstico debes estar cerca de una furgoneta, helicóptero de reportero o en la central de CTR!");
	if(IsPlayerInAnyVehicle(playerid) && VehicleInfo[GetPlayerVehicleID(playerid)][VehFaction] != FAC_MAN)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Para ver el pronóstico debes estar en algúnvehículo de la facción!");

	SendFMessage(playerid, COLOR_WHITE, "[INFO] Desde el centro de control meteorológico nacional anuncian que el tiempo será '%s' en las próximas horas.", GetWeatherInfo(GetNextServerWeather()));
	return 1;
}

CMD:n(playerid, params[]) {
	return cmd_noticia(playerid, params);
}

CMD:noticia(playerid, params[])
{
    new text[256],
		closestVeh = GetClosestVehicle(playerid, 7.0);
    
	if(PlayerInfo[playerid][pFaction] != FAC_MAN && InterviewActive[playerid] == false)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No eres reportero / No estás en una entrevista!");
  	if(sscanf(params, "s[256]", text))
    	return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"(/n)oticia [texto]");
	if(!IsPlayerInAnyVehicle(playerid) && (closestVeh == INVALID_VEHICLE_ID || VehicleInfo[closestVeh][VehFaction] != FAC_MAN) && Bld_GetPlayerLastId(playerid) != BLD_MAN)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar cerca de una furgoneta, helicóptero de reportero o en la central de CTR!");
	if(IsPlayerInAnyVehicle(playerid) && VehicleInfo[GetPlayerVehicleID(playerid)][VehFaction] != FAC_MAN)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar en algúnvehículo de la facción para transmitir!");
	if(InterviewActive[playerid] && !IsPlayerInRangeOfPlayer(5.0, playerid, InterviewOffer[playerid]))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Para poder transmitir debes estar cerca del reportero que te ofreció la entrevista.");

	format(text, sizeof(text), "[%s] %s", FactionInfo[FAC_MAN][fName], text);

	foreach(new i : Player)
	{
	    if(BitFlag_Get(p_toggle[i], FLAG_TOGGLE_NEWS)) {
	        SendClientMessage(i, COLOR_LIGHTGREEN, text);
	    }
	}
	return 1;
}

forward EndInterviewOffer(playerid);
public EndInterviewOffer(playerid)
{
	if(InterviewActive[playerid] == false) // Si todavia no la aceptó
	    InterviewOffer[playerid] = 999;
	return 1;
}

forward EndInterviewActive(playerid);
public EndInterviewActive(playerid)
{
	InterviewActive[playerid] = false;
	InterviewOffer[playerid] = 999;
	return 1;
}

CMD:entrevistar(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] != FAC_MAN)
		return SendClientMessage(playerid, COLOR_GREY, " ¡Usted no es reportero!");
	new target;
 	if(sscanf(params, "d", target))
    	return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/entrevistar [ID/Jugador]");
	if(!IsPlayerInRangeOfPlayer(5.0, playerid, target))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto no está cerca tuyo.");
	new string[128];
	format(string, sizeof(string), "Le has ofrecido una entrevista a %s, espera su respuesta. La oferta dura 15 segundos.", GetPlayerCleanName(target));
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "El reportero %s te quiere entrevistar por la radio, si lo deseas escribe /entrevistarse. Tienes 15 segundos.", GetPlayerCleanName(playerid));
	SendClientMessage(target, COLOR_LIGHTBLUE, string);
	InterviewOffer[target] = playerid;
	SetTimerEx("EndInterviewOffer", 15000, false, "i", target);
	return 1;
}

CMD:entrevistarse(playerid, params[])
{
	if(InterviewOffer[playerid] == 999 || InterviewOffer[playerid] == INVALID_PLAYER_ID || !IsPlayerConnected(InterviewOffer[playerid]))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡ningún reportero te ha ofrecido una entrevista!");
	if(!IsPlayerInRangeOfPlayer(5.0, playerid, InterviewOffer[playerid]))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El reportero no está cerca tuyo.");
	if(InterviewActive[playerid] == true)
	    return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Ya te encuentras en una entrevista.");
	new string[128];
	SendClientMessage(playerid, COLOR_WHITE, "Has aceptado la entrevista, ahora podrás usar /n para hablar al aire en la radio.");
	format(string, sizeof(string), "acepta la entrevista radial ofrecida por %s. La duración es de 5 minutos.", GetPlayerCleanName(InterviewOffer[playerid]));
	PlayerActionMessage(playerid, 15.0, string);
	InterviewActive[playerid] = true;
	SetTimerEx("EndInterviewActive", 300000, false, "i", playerid);
	return 1;
}

CMD:cla(playerid, params[]) {
	return cmd_clasificado(playerid, params);
}

CMD:clasificado(playerid,params[])
{
	static cooldownAd[MAX_PLAYERS];

	new string[128], text[144] = "[PUBLICIDAD]  ";

    if(sscanf(params, "s[128]", string))
    	return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"(/cla)sificado [mensaje] (costo: $"#PRICE_ADVERTISE")");
    if(PlayerInfo[playerid][pLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser al menos nivel 2 para enviar un anuncio.");
    if(GetPlayerCash(playerid) < PRICE_ADVERTISE)
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes el dinero suficiente, necesitas $"#PRICE_ADVERTISE".");
	if(gettime() < cooldownAd[playerid])
		return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Debes esperar 60 segundos para volver a enviar otro anuncio.");

	GivePlayerCash(playerid, -PRICE_ADVERTISE);
	Faction_GiveMoney(FAC_MAN, PRICE_ADVERTISE);

	strcat(text, string, sizeof(text));
	format(string, sizeof(string), "[STAFF]  Anuncio enviado por %s (ID %i).", GetPlayerCleanName(playerid), playerid);

	foreach(new i : Player)
	{
		if(PlayerInfo[i][pAdmin] >= 2)
		{
			SendClientMessage(i, COLOR_ADVERTISMENT, text);
			SendClientMessage(i, COLOR_LIGHTYELLOW2, string);
		} else {
			SendClientMessage(i, COLOR_ADVERTISMENT, text);
		}
	}

	printf("[%s] %s", GetPlayerCleanName(playerid), text);
	cooldownAd[playerid] = gettime() + 60;
	return 1;
}
