#if defined _marp_chat_included
	#endinput
#endif
#define _marp_chat_included

#include <YSI_Coding\y_hooks>

static OOCStatus = 0;
static cooldownMps[MAX_PLAYERS] = 0;
static PlayerText:SolidChat_PTD[MAX_PLAYERS] = {INVALID_PLAYER_TEXT_DRAW, ...};

new bool:AdminPMsEnabled[MAX_PLAYERS],
	bool:AdminWhispersEnabled[MAX_PLAYERS],
	bool:AdminFactionEnabled[MAX_PLAYERS],
	bool:AdminSMSEnabled[MAX_PLAYERS],
	bool:Admin911Enabled[MAX_PLAYERS];

hook function OnPlayerResetStats(playerid)
{
	SolidChat_PTD[playerid] = INVALID_PLAYER_TEXT_DRAW;
	return continue(playerid);
}

stock IsOOCEnabled() {
	return OOCStatus;
}

stock ToggleOOCStatus() {
	OOCStatus ^= 1;
}

/*CMD:gooc(playerid, params[])
{
	new text[190];

 	if(sscanf(params, "s[190]", text))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"[/go]oc [mensaje]");
    if(!IsOOCEnabled() && PlayerInfo[playerid][pAdmin] < 2)
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"OOC global desactivado.");
	if(IsPlayerMuted(playerid))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"Usted se encuentra muteado.");

	if(PlayerInfo[playerid][pAdmin] >= 2 && AdminDuty[playerid]) {
		format(text, sizeof(text), "(( [Global] {3CB371}%s{87CEFA}: %s ))", GetPlayerCleanName(playerid), text);
	} else {
		format(text, sizeof(text), "(( [Global] %s: %s ))", GetPlayerCleanName(playerid), text);
	}
	SendClientMessageToAll(COLOR_GLOBALOOC, text);
	return 1;
}*/

CMD:sus(playerid, params[]) {
	return cmd_susurrar(playerid, params);
}

CMD:susurrar(playerid, params[])
{
	new targetid, message[128], text[190];

	if(sscanf(params, "us[128]", targetid, message))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/(sus)urrar [ID/Jugador] [mensaje]");
	if(!IsPlayerLogged(targetid) || targetid == playerid)
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"ID inválida.");
    if(!IsPlayerInRangeOfPlayer(1.5, playerid, targetid))
        return SendClientMessage(playerid, COLOR_YELLOW2, "estás demasiado lejos.");

	format(text, sizeof(text), "%s susurra: %s", GetPlayerChatName(playerid), message);
	SendClientMessage(targetid, COLOR_YELLOW, text);
	SendClientMessage(playerid, COLOR_YELLOW, text);
	PlayerPlayerActionMessage(playerid, targetid, 5.0, "ha susurrado algo al oído de");
	format(text, sizeof(text), "[SUSURRO] ID %d a ID %d: %s", playerid, targetid, message);
    foreach(new i : Player) {
		if(AdminWhispersEnabled[i]) {
			SendClientMessage(i, COLOR_ADMINREAD, text);
		}
	}
	return 1;
}

PlayerPlayerActionMessage(playerid, targetid, Float:radius, const message[])
{
	new string[256];
	format(string, sizeof(string), "* %s %s %s.", GetPlayerChatName(playerid), message, GetPlayerChatName(targetid));
	SendPlayerMessageInRange(radius, playerid, string, COLOR_ACT1, COLOR_ACT2, COLOR_ACT3, COLOR_ACT4, COLOR_ACT5);
	return 1;
}

PlayerPlayerCmeMessage(playerid, targetid, Float:radius, timeexpire, const message[])
{
	new string[256];
	format(string, sizeof(string), "%s %s.", message, GetPlayerChatName(targetid));
	PlayerCmeMessage(playerid, radius, timeexpire, string);
	format(string, sizeof(string), "* %s > %s %s.", GetPlayerChatName(playerid), message, GetPlayerChatName(targetid));
	SendClientMessage(targetid, COLOR_ACT1, string);
}

CMD:me(playerid, params[])
{
	new text[128];

	if(sscanf(params, "s[128]", text))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/me [acción]");

	PlayerActionMessage(playerid, 15.0, text);
	return 1;
}

PlayerActionMessage(playerid, Float:radius, const message[])
{
	new string[256];
	format(string, sizeof(string), "* %s %s", GetPlayerChatName(playerid), message);
	SendPlayerMessageInRange(radius, playerid, string, COLOR_ACT1, COLOR_ACT2, COLOR_ACT3, COLOR_ACT4, COLOR_ACT5);
	return 1;
}

CMD:cme(playerid, params[])
{
    new text[128];

    if(sscanf(params, "s[128]", text))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/cme [texto]. Recuerda que el /cme se usa para indicar acciones.");

	PlayerCmeMessage(playerid, 15.0, 5000, text);
    return 1;
}

PlayerCmeMessage(playerid, Float:drawdistance, timeexpire, message[])
{
	new string[256] = "* > ";

	if(HasPlayerDesc(playerid)) {
		HidePlayerDesc(playerid, timeexpire + 2000); // La descripcion es escondida 2 segundos más que la duracion del cme.
	}
	
    SetPlayerChatBubble(playerid, message, COLOR_ACT1, drawdistance, timeexpire);
    strcat(string, message, sizeof(string));
	SendClientMessage(playerid, COLOR_ACT1, string);
    return 1;
}

CMD:do(playerid, params[])
{
	new text[128];
	
	if(sscanf(params, "s[128]", text))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/do [acción]");
		
	PlayerDoMessage(playerid, 15.0, text);
	return 1;
}

PlayerDoMessage(playerid, Float:radius, const message[])
{
	new string[256];
	format(string, sizeof(string), "* %s (( %s ))", message, GetPlayerChatName(playerid));
	SendPlayerMessageInRange(radius, playerid, string, COLOR_DO1, COLOR_DO2, COLOR_DO3, COLOR_DO4, COLOR_DO5);
	return 1;
}

CMD:dop(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return 1;

	new id, text[200];

	if(sscanf(params, "s[200]", text))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/dop [acción]");

	format(text, sizeof(text), "* %s (( %s )) ", text, GetPlayerChatName(playerid));

	if((id = House_IsPlayerAtAnyDoorAny(playerid)))
	{
		if((House_IsPlayerAtOutDoorId(playerid, id) && strcat(text, "(( Exterior ))")) || strcat(text, "(( Interior ))"))
		{
			foreach(new i : Player)
			{
				if(House_IsPlayerAtAnyDoorRangeId(i, id, 15.0) || House_IsPlayerInId(i, id)) {
					SendClientMessage(i, COLOR_DO1, text);
				}
			}
		}
	}
	else if((id = Biz_IsPlayerAtAnyDoorAny(playerid)))
	{
		if((Biz_IsPlayerAtOutsideDoorId(playerid, id) && strcat(text, "(( Exterior ))")) || strcat(text, "(( Interior ))"))
		{
			foreach(new i : Player)
			{
				if(Biz_IsPlayerAtAnyDoorRangeId(i, id, 15.0) || Biz_IsPlayerInsideId(i, id)) {
					SendClientMessage(i, COLOR_DO1, text);
				}
			}
		}
	}
	else {
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar en la puerta de algúninmueble!");
	}

	return 1;
}

CMD:vb(playerid, params[])
{
	new msg[190];

	if(sscanf(params, "s[190]", msg))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/vb [mensaje]");

	format(msg, sizeof(msg), "[Voz baja] %s dice: %s", GetPlayerChatName(playerid), msg);
	SendPlayerMessageInRange(3.0, playerid, msg, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	return 1;
}

CMD:b(playerid, params[])
{
	new text[128];

	if(sscanf(params, "s[128]", text))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/b [mensaje]");
    if(PlayerInfo[playerid][pMuteB] > 0) {
		if(PlayerInfo[playerid][pMuteB] > 60) {
			SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hablar por /b por %d horas.", PlayerInfo[playerid][pMuteB] / 60);
		} else {
			SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hablar por /b por %d minutos.", PlayerInfo[playerid][pMuteB]);
		}
		return 1;
	}

	PlayerLocalMessage(playerid, 15.0, text);
	if(PlayerInfo[playerid][pAdmin] < 1) {
	    PlayerInfo[playerid][pMuteB] = 5;
	}    
	return 1;
}

PlayerLocalMessage(playerid, Float:radius, const message[])
{
    new string[256];
    if (!AdminDuty[playerid])
    {
    	format(string, sizeof(string), "(( [OOC] %s (%d): %s ))", GetPlayerCleanName(playerid), playerid, message);
        SendPlayerMessageInRange(radius, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	}
    else
    {
		format(string, sizeof(string), "(( [OOC - STAFF] {%06x}%s{FFFFFF} (%d): %s ))", COLOR_STAFF >>> 8, AccountInfo[playerid][accUsername], playerid, message);
        SendPlayerMessageInRange(radius, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
    }
    return 1;
}

CMD:mp(playerid, params[])
{
	new targetid, msg[128], string[190], currentTime = gettime();

	if(sscanf(params, "us[128]", targetid, msg))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mp [ID/Jugador] [mensaje]");
	if(!BitFlag_Get(p_toggle[playerid], FLAG_TOGGLE_MPS) && !AdminDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tienes los mps bloqueados. Usa '/toggle' para activarlos.");
	if(!IsPlayerLogged(targetid) || targetid == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Jugador inválido");
	if(currentTime < cooldownMps[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar 5 segundos antes de usar nuevamente el comando.");
	if(!BitFlag_Get(p_toggle[targetid], FLAG_TOGGLE_MPS) && !AdminDuty[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El usuario tiene los mps bloqueados.");

	format(string, sizeof(string), "(( MP de %s (ID: %d): %s ))", GetPlayerCleanName(playerid), playerid, msg);
	SendClientMessage(targetid, COLOR_MEDIUMBLUE2, string);
	
	format(string, sizeof(string), "(( MP a %s (ID: %d): %s ))", GetPlayerCleanName(targetid), targetid, msg);
	SendClientMessage(playerid, COLOR_MEDIUMBLUE, string);

	format(string, sizeof(string), "[MPS] ID %d a ID %d: %s", playerid, targetid, msg);
	foreach(new i : Player) {
		if(AdminPMsEnabled[i]) {
			SendClientMessage(i, COLOR_ADMINREAD, string);
		}
	}
	
	if(PlayerInfo[playerid][pAdmin] < 1) {
		cooldownMps[playerid] = currentTime + 5;
	}
	return 1;
}

CMD:g(playerid, params[]) {
	return cmd_gritar(playerid, params);
}

CMD:gritar(playerid, params[])
{
	new string[190];
	new selfKick1[]="-corte-";
	new selfKick2[]="-CORTE-";

	
	if(sscanf(params, "s[190]", string))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"(/g)ritar [texto]");
	if(!strcmp(string, selfKick1) || !strcmp(string, selfKick2))
	{
		return KickPlayer(playerid, "el sistema", "NIP (colocar -CORTE- en el /g)");
	}
	


	format(string, sizeof(string), "%s {FF0000}grita{FFFFFF}:  ¡¡%s!!", GetPlayerChatName(playerid), string);
	SendPlayerMessageInRange(35.0, playerid, string, COLOR_DEEPWHITE, COLOR_DEEPWHITE, COLOR_DEEPWHITE, COLOR_DEEPWHITE, COLOR_DEEPWHITE);
	return 1;
}

CMD:ao(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 6)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator I o superior para usar este comando.");

	new text[190];

	if(sscanf(params, "s[190]", text))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/(ao)oc [mensaje]");

	format(text, sizeof(text), "(( [Anuncio] Admin %s: %s ))", GetPlayerCleanName(playerid), text);
	SendClientMessageToAll(COLOR_AOOC, text);
	return 1;
}

CMD:limpiarchat(playerid, params[]) {
	return ClearScreen(playerid);
}

CMD:solidchat(playerid, params[])
{
	new color;
	if(!strlen(params))
	{
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Elegi que color queres de fondo para tu chat.");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Pone /solidchat negro, verde, azul, violeta, gris, blanco, amarillo o apagar.");
		return 1;
	}
	if(!strcmp(params, "apagar", true))
	{
		if(SolidChat_PTD[playerid] != INVALID_PLAYER_TEXT_DRAW)
		{
			PlayerTextDrawDestroy(playerid, SolidChat_PTD[playerid]);
			SolidChat_PTD[playerid] = INVALID_PLAYER_TEXT_DRAW;
			Noti_Create(playerid, 2000, "Has desactivado el fondo de tu chat.");
		}
		return 1;
	}
	if(!strcmp(params, "negro",   true)) color = 0x000000FF;
	else if(!strcmp(params, "verde",   true)) color = 0x003300FF;
	else if(!strcmp(params, "azul",    true)) color = 0x000033FF;
	else if(!strcmp(params, "violeta", true)) color = 0x1A0033FF;
	else if(!strcmp(params, "gris",    true)) color = 0x2A2A2AFF;
	else if(!strcmp(params, "blanco",  true)) color = 0xEEEEEEFF;
	else if(!strcmp(params, "amarillo",true)) color = 0x333300FF;
	else
	{
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Elegi que color queres de fondo para tu chat.");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Pone /solidchat negro, verde, azul, violeta, gris, blanco, amarillo o apagar.");
		return 1;
	}
	if(SolidChat_PTD[playerid] != INVALID_PLAYER_TEXT_DRAW)
	{
		PlayerTextDrawDestroy(playerid, SolidChat_PTD[playerid]);
		SolidChat_PTD[playerid] = INVALID_PLAYER_TEXT_DRAW;
	}
	SolidChat_PTD[playerid] = CreateScreenPTD(playerid, color);
	PlayerTextDrawShow(playerid, SolidChat_PTD[playerid]);
	Noti_Create(playerid, 2000, "Fondo de chat activado.");
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Para desactivarlo, usa /solidchat apagar.");
	return 1;
}
