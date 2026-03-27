#if defined _marp_acmds_included
	#endinput
#endif
#define _marp_acmds_included

#define CK_MONEY_RATIO				0.25

stock IsAdminFactionEnabled(playerid) {
	return AdminFactionEnabled[playerid];
}

new Muted[MAX_PLAYERS];
static AdminName_labelText[MAX_PLAYERS][MAX_PLAYER_NAME];
static STREAMER_TAG_3D_TEXT_LABEL:AdminName_label[MAX_PLAYERS];

// Sistema de experiencia doble
new bool:DoubleExpActive = false;
new DoubleExpEndTime = 0;
new bool:PlayerHasDoubleExp[MAX_PLAYERS];


CMD:acmds(playerid, params[]) {
	return cmd_admincmds(playerid, params);
}

// Sistema de ayuda administrativa con categorías
CMD:admincmds(playerid, params[])
{	
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes permiso para utilizar este comando.");

	// Obtener el nombre del rango con su color
	new rankName[64], rankColor[16];
	GetAdminRankColor(PlayerInfo[playerid][pAdmin], rankColor);
	format(rankName, sizeof(rankName), "{%s}%s", rankColor, GetAdminRankName(PlayerInfo[playerid][pAdmin]));
	
	// Título del menú
	new title[128];
	format(title, sizeof(title), "Panel de ayuda administrativa - %s", rankName);
	
	// Construir opciones del menú principal
	new options[512] = "Generales\nInformación\nModeración\nVehículos\nComités\nAvanzados\nOtros";
	
	Dialog_Show(playerid, DLG_ACMDS_MENU, DIALOG_STYLE_LIST, title, options, "Seleccionar", "Cerrar");
	return 1;
}
stock AdministratorMessage(color, const string[], level)
{
	foreach(new i : Player) {
		if(PlayerInfo[i][pAdmin] >= level && BitFlag_Get(p_toggle[i], FLAG_TOGGLE_ADMINMSGS)) {
			SendClientMessage(i, color, string);
		}
	}
	return 1;
}

CMD:a(playerid, params[]) {
	return cmd_admin(playerid, params);
}

CMD:admin(playerid, params[])
{
	new text[256];

	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage (playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");
	if(sscanf(params, "s[256]", text))
    	return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY" (/a)dmin [mensaje]");

	format(text, sizeof(text), "[%s] %s (%d): {B8B8B8}%s", GetAdminRankName(PlayerInfo[playerid][pAdmin]), AccountInfo[playerid][accUsername], playerid, text);
	AdministratorMessage(0xCAA572FF, text, 1);
	return 1;
}

// COMANDO DE BANEO OFFLINE LEGACY (DESHABILITADO - Usar /baccoff o /bpjoff en su lugar)
/*
CMD:banearoff(playerid, params[]) {
	new acc[MAX_PLAYER_NAME], reason[128], days;
	
	if(sscanf(params, "s[32]is[128]", acc, days, reason))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/(ban)earoff [Nombre_Apellido] [días (0 = permaban)] [razón]");
	if(days < 0 || days > 300)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La cantidad de días de duración debe estar entre (0 - 300).");
	    
	BanPlayerOffline(acc, playerid, reason, days);
	return true;
}
*/

CMD:p455w0rd(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new pass[128], string[128];

	if(sscanf(params, "s[128]", pass)) {
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/p455w0rd [password]");
	}

    format(string, sizeof(string), "password %s", pass);
	SendRconCommand(string);
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"La nueva password del servidor es "COLOR_EMB_ALERT" %s.", pass);
	return 1;
}

CMD:ppvehiculos(playerid, params[]) 
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new percent;

	if(sscanf(params, "i", percent)) {
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/ppvehiculos [porcentaje del precio]");
	}
	if(percent < 1 || percent > 1000) {
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El porcentaje no puede ser menor a 1 o mayor a 1000.");
	}

	ServerInfo[sVehiclePricePercent] = percent;
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El porcentaje de costo de los vehículos ha sido ajustado a %i%%.", percent);
	return 1;
}

CMD:ainfo(playerid, params[]) {
    if(AccountInfo[playerid][accAdminLevel] < 14)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

    return Dialog_Show(playerid, DLG_AINFO, DIALOG_STYLE_LIST, "Categorías", "Facciones\nJobs\nClimas", "Aceptar", "Cerrar");
}

Dialog:DLG_AINFO(playerid, response, listitem, inputtext[])
{
	if(response) 
	{
		switch(listitem) 
		{
			case 0:
			{
		    	new fac_str[80], dlg_fac_str[1024], size = sizeof(FactionInfo);

				for(new i = 1; i < size; i++)
				{
			        format(fac_str, sizeof(fac_str), "[ID %i] %s\n", i, FactionInfo[i][fName]);
			        strcat(dlg_fac_str, fac_str);
		    	}

		        Dialog_Show(playerid, DLG_AINFO_FAC , DIALOG_STYLE_LIST, "IDs de facciones", dlg_fac_str, "Cerrar", "");
			}
			case 1:
			{
		    	new job_str[64], dlg_job_str[256], size = sizeof(JobInfo);

				for(new i = 1; i < size; i++)
				{
			        format(job_str, sizeof(job_str), "[ID %i] %s\n", i, JobInfo[i][jName]);
			        strcat(dlg_job_str, job_str);
		    	}

		        Dialog_Show(playerid, DLG_AINFO_JOBS , DIALOG_STYLE_LIST, "IDs de trabajos", dlg_job_str, "Cerrar", "");
			}
			case 2:
			{
		    	Dialog_Show(playerid, DLG_AINFO_WEATHER , DIALOG_STYLE_LIST, "IDs de climas",\
		    		"[Soleado] 0, 1, 2, 3, 5, 6, 10, 11, 13, 14, 18, 19\n\
		        	[Nublado] 4, 7, 12, 15\n\
		        	[Lluvioso] 8, 16\n\
		        	[Niebla] 9\n\
		        	[Tormenta de arena] 19", "Cerrar", "");
			}
		}
	}
	return 1;
}

CMD:verjail(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new targetid;

    if(sscanf(params, "u", targetid))
    	return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/verjail [ID/Jugador]");
    if(!IsPlayerLogged(targetid) || playerid == targetid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(PlayerInfo[targetid][pJailed] == JAIL_NONE)
	    return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El usuario no tiene ninguna condena.");

	switch(PlayerInfo[targetid][pJailed])
	{
	    case JAIL_IC_PMA, JAIL_IC_PMA_EAST:
	    {
	    	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El jugador %s se encuentra detenido en comisaria por: %d segundos.", GetPlayerCleanName(targetid), PlayerInfo[targetid][pJailTime]);
		}
		case JAIL_IC_PRISON:
		{
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El jugador %s se encuentra detenido en la prisión por: %d segundos.", GetPlayerCleanName(targetid), PlayerInfo[targetid][pJailTime]);
		}
		case JAIL_OOC:
		{
		    SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El jugador %s se encuentra en jail OOC por: %d segundos.", GetPlayerCleanName(targetid), PlayerInfo[targetid][pJailTime]);
		}
		case JAIL_IC_GOB:
		{
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El jugador %s se encuentra en prisión preventiva (Sin tiempo de salida).", GetPlayerCleanName(targetid));
		}
	}
    return 1;
}

CMD:verip(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new targetid, IP[20];

    if(sscanf(params, "u", targetid))
    	return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/verip [ID/Jugador]");
    if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");

	GetPlayerIp(targetid, IP, 20);
	SendFMessage(playerid, COLOR_WHITE, "{878EE7}[INFO]{C8C8C8} IP de %s: %s", GetPlayerCleanName(targetid), IP);
    return 1;
}

CMD:vertlf(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new phone, count;

    if(sscanf(params, "i", phone)) {
    	return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/vertlf [número de teléfono]");
    }

	foreach(new i : Player)
	{
		if(PlayerInfo[i][pPhoneNumber] == phone)
		{
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El número de teléfono %d pertenece a %s.", phone, GetPlayerCleanName(i));
			count++;
		}
	}
	if(count == 0) {
	    SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El número de teléfono no pertenece a ningún usuario conectado.");
	}
    return 1;
}

CMD:congelar(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

    new string[128], targetid;

	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/congelar [ID/Jugador]");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");

	TogglePlayerControllable(targetid, false);
	PlayerInfo[targetid][pDisabled] = DISABLE_FREEZE;
	SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has sido congelado por %s (%s) [ID: %d].", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
	format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] ha congelado a %s.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid));
	AdministratorMessage(COLOR_ADMINCMD, string, 2);
	return 1;
}

CMD:descongelar(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

    new string[128], targetid;

	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/descongelar [ID/Jugador]");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	    
	TogglePlayerControllable(targetid, true);
	PlayerInfo[targetid][pDisabled] = DISABLE_NONE;
	SendFMessage(targetid, COLOR_INFO,"[INFO] "COLOR_EMB_GREY"Has sido descongelado por %s (%s) [ID: %d].", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
	format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] ha descongelado a %s.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid));
	AdministratorMessage(COLOR_ADMINCMD, string, 2);
	return 1;
}

CMD:setcoord(playerid, params[]) 
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");
	new	targetid, Float:x, Float:y, Float:z, string[128];

	if(sscanf(params, "dfff", targetid, x, y, z)) {
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/setcoord [ID-Jugador] [x] [y] [z]");
	}
	else {
		if(IsPlayerInAnyVehicle(targetid)) {
			SetVehiclePos(GetPlayerVehicleID(targetid), x,y,z);
		} else {
			SetPlayerPos(targetid, x,y,z);
		}
		format(string,sizeof(string),"* El administrador %s (%s) [ID: %d] te ha teletransportado. *", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
        SendClientMessage(targetid, COLOR_LIGHTBLUE, string);
	}
	return 1;
}

CMD:setint(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

	new	interior, targetid;

	if(sscanf(params,"ud", targetid, interior)) {
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/setint [ID-Jugador] [interior]");
	}
	else {
		if(IsPlayerInAnyVehicle(targetid)) {
		    LinkVehicleToInterior(GetPlayerVehicleID(targetid), interior);
		}
        SetPlayerInterior(targetid, interior);
	}
	return 1;
}

CMD:setvw(playerid, params[]) 
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

	new world, targetid;

	if(sscanf(params,"ud", targetid, world)) {
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/setvw [ID-Jugador] [mundo virtual]");
	}
	else {
        SetPlayerVirtualWorld(targetid, world);
	}
	return 1;
}

CMD:recordjugadores(playerid, params[]) 
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El record actual de jugadores es de %i.", ServerInfo[sPlayersRecord]);
	return 1;
}

hook OnPlayerConnect(playerid)
{
	new count = GetPlayerCount();

	if(count > ServerInfo[sPlayersRecord])
	{
		ServerInfo[sPlayersRecord] = count;
		SendFMessageToAll(COLOR_GREEN, "[SERVIDOR] ¡Se ha alcanzado un record de %i jugadores conectados!", count);
	}
	
	// Si el evento de experiencia doble está activo, darle el beneficio al nuevo jugador
	if(DoubleExpActive)
	{
		new currentTime = gettime();
		if(DoubleExpEndTime > currentTime)
		{
			PlayerHasDoubleExp[playerid] = true;
			new remainingTime = DoubleExpEndTime - currentTime;
			new minutes = remainingTime / 60;
			if(minutes < 1) minutes = 1;
			
			SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "[EVENTO] "COLOR_EMB_GREY"¡El evento de experiencia doble está activo!");
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Recibirás sueldo, beneficios y experiencia x2 en el próximo payday. Evento activo por %d minuto(s).", minutes);
		}
		else
		{
			// El cooldown expiró, desactivar el evento
			DoubleExpActive = false;
			DoubleExpEndTime = 0;
			PlayerHasDoubleExp[playerid] = false;
		}
	}
}

CMD:getpos(playerid, params[])  {
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");
	
	new tid, Float:x, Float:y,	Float:z, Float:a;

	if(sscanf(params,"u", tid)) {
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/getpos [ID-Jugador]");
	}
	else if(tid != INVALID_PLAYER_ID) {
		GetPlayerPos(tid, x, y, z);
		GetPlayerFacingAngle(tid, a);
		SendFMessage(playerid, COLOR_WHITE, "Posición de %s: [X:%f - Y:%f - Z:%f - A:%f - Int:%d - VWorld:%d]", GetPlayerCleanName(tid), x, y, z, a, GetPlayerInterior(tid), GetPlayerVirtualWorld(tid));
	}
	return 1;
}

CMD:ajail(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new reason[256], targetID, minutes;

	if(sscanf(params, "uds[256]", targetID, minutes, reason))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/ajail [ID-Jugador] [minutos] [razón]");
	if(!IsPlayerLogged(targetID))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(minutes < 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Cantidad de minutos inválida.");

	SendFMessageToAll(COLOR_RED, "[STAFF]{FFFFFF} %s ha sido sancionado por %s. {E44A4A}Razón:{FFFFFF} %s.", GetPlayerCleanName(targetID), AccountInfo[playerid][accUsername], reason);
	SendFMessage(targetID, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has sido sancionado durante %d minutos por el administrador %s.", minutes, AccountInfo[playerid][accUsername]);
	SendClientMessage(targetID, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Ante cualquier reclamo sobre la sanción, ir al soporte de Discord.");

	PlayerInfo[targetID][pJailed] = JAIL_OOC;
	PlayerInfo[targetID][pJailTime] = minutes * 60;

	if(PlayerInfo[targetID][pJailTime]) {
		TeleportPlayerTo(targetID, 1412.01, -2.59, 1001.47, 0.0, 6, 0, .syncPlayerNewPosData = true, .disableSyncOnExitSeconds = 0);
	}

	ServerFormattedLog(LOG_TYPE_ID_ADMIN, .entry="/ajail", .playerid=playerid, .targetid=targetID, .params=<"%d min por %s", minutes, reason>);
	return 1;
}

CMD:traer(playerid, params[]) {
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

	new tid;

	if(sscanf(params, "u", tid)) 
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/traer [ID/Jugador]");
	if(!IsPlayerLogged(tid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");

	if(IsPlayerInAnyVehicle(tid))
	{
		new	Float:x, Float:y, Float:z, Float:ang, interior, vworld;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, ang);
		interior = GetPlayerInterior(playerid);
		vworld = GetPlayerVirtualWorld(playerid);

		TeleportVehicleTo(GetPlayerVehicleID(tid), x, y, z, ang, interior, vworld);
		
	} else {
		TeleportPlayerToPlayer(tid, playerid);
	}

	SendFMessage(tid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El administrador %s (%s) [ID: %d] te ha teletransportado junto a él.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
	return 1;
}

CMD:goto(playerid, params[]) 
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

	new tid, Float:x, Float:y, Float:z;

	if(!sscanf(params, "p<,>fff", x, y, z))
	{
		if(IsPlayerInAnyVehicle(playerid)) {
			SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
		} else {
			SetPlayerPos(playerid, x, y, z);
		}
	}
	else if(!sscanf(params, "u", tid))
	{
		if(!IsPlayerLogged(tid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");

		if(IsPlayerInAnyVehicle(playerid))
		{
			if(!GetPlayerInterior(tid) && !GetPlayerVirtualWorld(tid))
			{
				GetPlayerPos(tid, x, y, z);
				SetVehiclePos(GetPlayerVehicleID(playerid), x, y + 4.0, z);
			}
			else
			{
				RemovePlayerFromVehicle(playerid);
				TeleportPlayerToPlayer(playerid, tid);
			}
		} else {
			TeleportPlayerToPlayer(playerid, tid);
		}
	} else {
		Dialog_Show(playerid, DLG_CMD_GOTO, DIALOG_STYLE_LIST, "Menu de teleports", "Empleos\nServicios\nCiudades\nVillas/Barrios\nOtros..", "Siguiente", "Cancelar");
	}
	return 1;	
}

Goto_ShowMenu(playerid) {
	return Dialog_Show(playerid, DLG_CMD_GOTO, DIALOG_STYLE_LIST, "Menu de teleports", "Empleos\nServicios\nCiudades\nVillas/Barrios\nOtros..", "Siguiente", "Cancelar");
}

Dialog:DLG_CMD_GOTO(playerid, response, listitem, inputtext[]) {
	if(!response)
		return true;

	switch(listitem)
	{
		case 0: Goto_ShowEmpleos(playerid);
		case 1: Goto_ShowServicios(playerid);
		case 2: Goto_ShowCiudades(playerid);
		case 3: Goto_ShowBarrios(playerid);
		case 4: Goto_ShowOtros(playerid);
	}
	return true;
}

Goto_ShowEmpleos(playerid) {
	Dialog_Show(playerid, DLG_GOTO_EMPLEOS, DIALOG_STYLE_LIST,
		"Empleos de Malos Aires",
		"Camionero urbano\n\
		Granjero\n\
		Basurero\n\
		Moto Delivery\n\
		Taxista\n\
		Piloto\n\
		Colectivero",
		"Ir",
		"Volver"
	);
	
	return true;
}

Dialog:DLG_GOTO_EMPLEOS(playerid, response, listitem, inputtext[]) {
	if(!response)
		return Goto_ShowMenu(playerid);
	
    new Float:x, Float:y, Float:z, int = 0, vworld = 0;
	switch(listitem)
	{
		case 0: { x = 2232.24; y = -2217.89; z = 13.54; }
		case 1: { x = -42.64; y = 75.1548; z = 3.11; }
		case 2: { x = 2442.06; y = -2096.37; z = 13.54; }
		case 3: { x = 1738.28; y = -1591.70; z = 13.54; }
		case 4: { x = 1813.13; y = -1892.28; z = 13.41; }
		case 5: { x = 1962.47; y = -2179.99; z = 13.54; }
		case 6: { x = 2199.73; y = -2606.20; z = 13.54; }
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
		TeleportVehicleTo(GetPlayerVehicleID(playerid), x, y, z, 0.0, int, vworld);
	} else {
		TeleportPlayerTo(playerid, x, y, z, 0.0, int, vworld);
	}
	return true;
}

Goto_ShowServicios(playerid) {
	Dialog_Show(playerid, DLG_GOTO_SERVICIOS, DIALOG_STYLE_LIST,
		"Servicios de Malos Aires",
		"Comisaria Quince\n\
		Comisaria N°53\n\
		Prision Federal\n\
		Gendarmeria\n\
		Gobierno\n\
		Central de Noticias\n\
		Banco\n\
		Hospital Central\n\
		Hospital Secundario\n\
		Taller Mecanico Mercury",
		"Ir",
		"Volver"
	);
	
	return true;
}

Dialog:DLG_GOTO_SERVICIOS(playerid, response, listitem, inputtext[]) {
	if(!response)
		return Goto_ShowMenu(playerid);
	
    new Float:x, Float:y, Float:z, int = 0, vworld = 0;
	switch(listitem)
	{
		case 0: { x = 1290.1902; y = -1635.6903; z = 13.3828; }
		case 1: { x = 2337.9282; y = -1375.2715; z = 24.0000; }
		case 2: { x = 2753.6953; y = -2443.6323; z = 13.6432; }
		case 3: { x = -279.3609; y = -2187.6653; z = 28.6901; }
		case 4: { x = 1480.7455; y = -1739.6498; z = 13.5469; }
		case 5: { x = 640.4639; y = -1357.2834; z = 13.4060; }
		case 6: { x = 1463.5583; y = -1169.9799; z = 23.8225; }
		case 7: { x = 1191.5411; y = -1323.5696; z = 13.3984; }
		case 8: { x = 2002.5573; y = -1444.5435; z = 13.5617; }
		case 9: { x = 2514.9858; y = -1532.4241; z = 24.0080; }
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
		TeleportVehicleTo(GetPlayerVehicleID(playerid), x, y, z, 0.0, int, vworld);
	} else {
		TeleportPlayerTo(playerid, x, y, z, 0.0, int, vworld);
	}
	return true;
}

Goto_ShowCiudades(playerid) {
	Dialog_Show(playerid, DLG_GOTO_CIUDADES, DIALOG_STYLE_LIST,
		"Ciudades de Malos Aires",
		"Los Santos\n\
		San Fierro\n\
		Las Venturas",
		"Ir",
		"Volver"
	);
	
	return true;
}

Dialog:DLG_GOTO_CIUDADES(playerid, response, listitem, inputtext[]) {
	if(!response)
		return Goto_ShowMenu(playerid);
	
    new Float:x, Float:y, Float:z, int = 0, vworld = 0;
	switch(listitem)
	{
		case 0: { x = 1529.6; y = -1691.2; z = 13.3; }
		case 1: { x = -1417.0; y = -295.8; z = 14.1; }
		case 2: { x = 1699.2; y = 1435.1; z = 10.7; }
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
		TeleportVehicleTo(GetPlayerVehicleID(playerid), x, y, z, 0.0, int, vworld);
	} else {
		TeleportPlayerTo(playerid, x, y, z, 0.0, int, vworld);
	}
	return true;
}

Goto_ShowBarrios(playerid) {
	Dialog_Show(playerid, DLG_GOTO_BARRIOS, DIALOG_STYLE_LIST,
		"Barrios de Malos Aires",
		"Villa Fierro\n\
		Villa Corona\n\
		Villa Santa Makumba\n\
		Fuerte Apache\n\
		Don Orione\n\
		Claypole\n\
		Barrio SOM",
		"Ir",
		"Volver"
	);
	
	return true;
}

Dialog:DLG_GOTO_BARRIOS(playerid, response, listitem, inputtext[]) {
	if(!response)
		return Goto_ShowMenu(playerid);
	
    new Float:x, Float:y, Float:z, int = 0, vworld = 0;
	switch(listitem)
	{
		case 0: { x = 2074.4575; y = -1887.9719; z = 13.5469; }
		case 1: { x = 1682.2393; y = -2112.8269; z = 13.3828; }
		case 2: { x = 2286.7644; y = -2128.3726; z = 13.5487; }
		case 3: { x = 1937.0662; y = -1604.4807; z = 13.5469; }
		case 4: { x = 2658.9646; y = -2003.7029; z = 13.3828; }
		case 5: { x = 2499.9058; y = -1939.4127; z = 13.5469; }
		case 6: { x = 2257.6494; y = -1894.3330; z = 13.3928; }
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
		TeleportVehicleTo(GetPlayerVehicleID(playerid), x, y, z, 0.0, int, vworld);
	} else {
		TeleportPlayerTo(playerid, x, y, z, 0.0, int, vworld);
	}
	return true;
}

Goto_ShowOtros(playerid) {
	Dialog_Show(playerid, DLG_GOTO_OTROS, DIALOG_STYLE_LIST,
		"Otros puntos..",
		"Spawn\n\
		Obelisco",
		"Ir",
		"Volver"
	);
	
	return true;
}

Dialog:DLG_GOTO_OTROS(playerid, response, listitem, inputtext[]) {
	if(!response)
		return Goto_ShowMenu(playerid);
	
    new Float:x, Float:y, Float:z, int = 0, vworld = 0;
	switch(listitem)
	{
		case 0: { x = POS_SPAWN_X; y = POS_SPAWN_Y; z = POS_SPAWN_Z; }
		case 1: { x = 1355.96; y = -937.87; z = 34.37; }
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
		TeleportVehicleTo(GetPlayerVehicleID(playerid), x, y, z, 0.0, int, vworld);
	} else {
		TeleportPlayerTo(playerid, x, y, z, 0.0, int, vworld);
	}
	return true;
}

CMD:money(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new targetid, money, string[128];

	if(sscanf(params, "ui", targetid, money))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/money [ID/Jugador] [dinero]");
 	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(!Money_IsValidValue(money, .allownegative = true))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Cantidad inválida.");

    SetPlayerCash(targetid, money);

	format(string, sizeof(string), "[INFO] {C8C8C8}El administrador %s (%s) [ID: %d] ha seteado tu dinero en efectivo en $%d.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, money);
	SendClientMessage(targetid, COLOR_INFO, string);
	format(string, sizeof(string), "[AVISO STAFF] {C8C8C8} El administrador %s (%s) [ID: %d] ha seteado el dinero en efectivo de %s en $%d.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid), money);
    AdministratorMessage(COLOR_ADMINCMD, string, 2);

	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="SET MONEY", .playerid=playerid, .targetid=targetid, .params=<"$%d", money>);
    return 1;
}

CMD:givemoney(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new targetid, money, string[128];

	if(sscanf(params, "ui", targetid, money))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/givemoney [ID/Jugador] [dinero]");
 	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(!Money_IsValidValue(money, .allownegative = true))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Cantidad inválida.");

	GivePlayerCash(targetid, money);
	
	format(string, sizeof(string), "[INFO] {C8C8C8}El administrador %s (%s) [ID: %d] te ha seteado $%d en efectivo adicional a lo que ya tenías.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, money);
	SendClientMessage(targetid, COLOR_INFO, string);
	format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] le ha seteado $%d en efectivo adicional a lo que ya tenía %s.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, money, GetPlayerCleanName(targetid));
    AdministratorMessage(COLOR_ADMINCMD, string, 2);
	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="GIVE MONEY", .playerid=playerid, .targetid=targetid, .params=<"$%d", money>);
    return 1;
}

CMD:sethp(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new targetid, Float:health, string[128];

	if(sscanf(params, "uf", targetid, health))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/sethp [ID/Jugador] [health]");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");

	SetPlayerHealth(targetid, health);
	// Persist health to server state so periodic updates don't revert it
	PlayerInfo[targetid][pHealth] = health;
	SetPVarFloat(targetid, "tempHealth", health);

	// If we set full health, clear crack/dying state and wounds so the player regains control
	if (health >= 100.0) {
		Wound_Reset(targetid);
		PlayerInfo[targetid][pCrack] = 0;
		PlayerInfo[targetid][pDisabled] = DISABLE_NONE;
		TogglePlayerControllable(targetid, true);
		ClearAnimations(targetid, 1);
		Dialog_Close(targetid);
		// Prevent immediate re-application of crack by damage system
		Damage_SuppressCrack(targetid, 10000); // 10 seconds
	}
	else if (health <= 0.0) {
		// Kill the player via the normal death flow
		PlayerInfo[targetid][pHealth] = health;
		SetPlayerHealth(targetid, health);
		Damage_ApplyDeathEffect(targetid);
	}
	else if (health <= DAMAGE_CRACK_HP) {
		// Ensure the crack/dying state is applied. Use the common function to setup effects,
		// then preserve the exact health value the admin requested.
		Damage_ApplyCrackEffect(targetid);
		PlayerInfo[targetid][pHealth] = health;
		SetPlayerHealth(targetid, health);
	}
	else if (PlayerInfo[targetid][pDisabled] == DISABLE_DEATHBED) {
		PlayerInfo[targetid][pDisabled] = DISABLE_NONE;
		TogglePlayerControllable(targetid, true);
	}

    format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] seteó a %.0f la vida de %s", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, health, GetPlayerCleanName(targetid));
	AdministratorMessage(COLOR_ADMINCMD, string, 2);
	return 1;
}

CMD:skin(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new targetid, skin;

    if(sscanf(params, "ui", targetid, skin))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/skin [ID/Jugador] [ID skin]");
    if(!IsPlayerLogged(targetid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(!IsValidSkin(skin))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de skin inválida.");

    SetPlayerSkin(targetid, skin);
    PlayerInfo[targetid][pSkin] = skin;
    return 1;
}

CMD:setadmin(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 19)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Lead Admin o superior para usar este comando.");

	new targetid, adminlevel;

	if(sscanf(params, "ui", targetid, adminlevel))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/setadmin [ID/Jugador] [nivel de administrador]");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(adminlevel < 0 || adminlevel > 21)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El nivel de administrador debe ser entre 0 y 21.");
	if(adminlevel > AccountInfo[playerid][accAdminLevel])
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes otorgar cargos administrativos más altos que el que tú posees.");

	if(adminlevel == 0 && AdminDuty[targetid])
	{
		AdminDuty[targetid] = false;
		SetPlayerHealthEx(targetid, GetPVarFloat(targetid, "tempHealth"));
		SetPlayerColor(targetid, 0xFFFFFF00);
	}
	
	// Guardar en master_accounts si el jugador tiene una master account
	if(PlayerInfo[targetid][pMasterAccountId] > 0)
	{
		MasterAccount_SetAdminLevel(PlayerInfo[targetid][pMasterAccountId], adminlevel);
		
		// Actualizar PlayerInfo[pAdmin] para todos los jugadores conectados de la misma cuenta
		foreach(new i : Player)
		{
			if(PlayerInfo[i][pMasterAccountId] == PlayerInfo[targetid][pMasterAccountId])
			{
				PlayerInfo[i][pAdmin] = adminlevel;
			}
		}
	}
	else
	{
		// Fallback para cuentas sin master account (legacy)
		PlayerInfo[targetid][pAdmin] = adminlevel;
	}
	
	SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"%s te ha hecho administrador nivel %i.", GetPlayerCleanName(playerid), adminlevel);
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has hecho a %s un administrador nivel %i.", GetPlayerCleanName(targetid), adminlevel);
    return 1;
}

CMD:reloadadmin(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 19)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Lead Admin o superior para usar este comando.");

	new targetid;

	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/reloadadmin [ID/Jugador] - Recarga el nivel admin desde la DB");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	
	if(PlayerInfo[targetid][pMasterAccountId] > 0)
	{
		MasterAccount_ReloadAdminLevel(PlayerInfo[targetid][pMasterAccountId]);
		
		// Actualizar PlayerInfo[pAdmin] inmediatamente desde el cache
		PlayerInfo[targetid][pAdmin] = AccountInfo[targetid][accAdminLevel];
		
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Recargando nivel admin de %s desde la base de datos...", GetPlayerCleanName(targetid));
	}
	else
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este jugador no tiene una master account.");
	}
	
    return 1;
}

CMD:check(playerid, params[])
{
    if(!IsPlayerLogged(playerid))
        return false;
    
    if(AccountInfo[playerid][accAdminLevel] < 2)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");
    
    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/check [ID]");
    
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no está conectado.");
    
    // Query a la base de datos para traer datos de master_accounts
    new query[512];
    mysql_format(MYSQL_HANDLE, query, sizeof(query), 
        "SELECT m.id, m.username FROM master_accounts m WHERE m.id = (SELECT master_account_id FROM accounts WHERE Id = %d LIMIT 1) LIMIT 1",
        PlayerInfo[targetid][pID]
    );
    mysql_tquery(MYSQL_HANDLE, query, "ShowStatsCallback_Admin", "ii", playerid, targetid);
    return 1;
}

forward ShowStatsCallback_Admin(playerid, targetid);
public ShowStatsCallback_Admin(playerid, targetid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid))
        return 1;
    
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador se desconectó.");

    new location[MAX_ZONE_NAME], factionText[64], jobText[32];

    GetPlayer2DZone(targetid, location, MAX_ZONE_NAME);
    
    if(PlayerInfo[targetid][pFaction]) {
        format(factionText, sizeof(factionText), "Facción: %s | Rango: %s", FactionInfo[PlayerInfo[targetid][pFaction]][fName], Faction_GetRankName(PlayerInfo[targetid][pFaction], PlayerInfo[targetid][pRank]));
    } else {
        strcat(factionText, "Facción: Ninguna | Rango: Ninguno", sizeof(factionText));
    }

    if(PlayerInfo[targetid][pJob]) {
        strcat(jobText, JobInfo[PlayerInfo[targetid][pJob]][jName], sizeof(jobText));
    } else {
        strcat(jobText, "No", sizeof(jobText));
    }

    new dialog[256], string[1024], IP[20];
    new masterAccountId = 0, masterAccountName[64];
    
    GetPlayerIp(targetid, IP, 20);
    
    // Obtener datos de master_accounts
    if(cache_num_rows() > 0) {
        cache_get_value_name_int(0, "id", masterAccountId);
        cache_get_value_name(0, "username", masterAccountName, 64);
    }
    
    format(dialog, sizeof(dialog), "{2EA8E1}ID:{DBDBDB} %d\n", targetid);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Cuenta:{DBDBDB} %s (ID: %d)\n", masterAccountName, masterAccountId);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Nivel administrativo:{DBDBDB} %d\n", PlayerInfo[targetid][pAdmin]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Mundo:{DBDBDB} %d {2EA8E1}| Interior:{DBDBDB} %d\n", GetPlayerVirtualWorld(targetid), GetPlayerInterior(targetid));
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Advertencias:{DBDBDB} %d\n", PlayerInfo[targetid][pWarnings]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Puntos de rol:{DBDBDB} %d\n", PlayerInfo[targetid][pRolePoints]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Skin:{DBDBDB} %d\n", PlayerInfo[targetid][pSkin]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Ubicación:{DBDBDB} %s\n", location);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Última conexión:{DBDBDB} %s\n", PlayerInfo[targetid][pLastConnected]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}IP:{DBDBDB} %s\n", IP);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), " \n");
    strcat(string, dialog);
    format(dialog, sizeof(dialog), " \n");
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Personaje:{DBDBDB} %s\n", GetPlayerCleanName(targetid));
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Nivel:{DBDBDB} %d\n", PlayerInfo[targetid][pLevel]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Experiencia:{DBDBDB} %d/%d\n", PlayerInfo[targetid][pExp], (PlayerInfo[targetid][pLevel] + 1) * ServerInfo[svLevelExp]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Tiempo de juego:{DBDBDB} %d horas\n", PlayerInfo[targetid][pTimePlayed] / 3600);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Sexo:{DBDBDB} %s\n", (PlayerInfo[targetid][pSex]) ? ("Masculino") : ("Femenino"));
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Edad:{DBDBDB} %d\n", PlayerInfo[targetid][pAge]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Efectivo:{DBDBDB} $%d\n", PlayerInfo[targetid][pCash]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Banco:{DBDBDB} $%d\n", PlayerInfo[targetid][pBank]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Telefono:{DBDBDB} %d\n", PlayerInfo[targetid][pPhoneNumber]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Empleo:{DBDBDB} %s\n", jobText);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Facción:{DBDBDB} %s {2EA8E1}| Rango:{DBDBDB} %s\n", FactionInfo[PlayerInfo[targetid][pFaction]][fName], Faction_GetRankName(PlayerInfo[targetid][pFaction], PlayerInfo[targetid][pRank]));
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Lic. Conduccion:{DBDBDB} %s {2EA8E1}| Vuelo:{DBDBDB} %s {2EA8E1}| Armas:{DBDBDB} %s\n", (PlayerInfo[targetid][pCarLic]) ? ("Si") : ("No"), (PlayerInfo[targetid][pFlyLic]) ? ("Si") : ("No"), (PlayerInfo[targetid][pWepLic]) ? ("Si") : ("No"));
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Salud:{DBDBDB} %.1f\n", GetPlayerHealthEx(targetid));
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Chaleco:{DBDBDB} %.1f\n", PlayerInfo[targetid][pArmour]);
    strcat(string, dialog);
    format(dialog, sizeof(dialog), "{2EA8E1}Hambre:{DBDBDB} %d {2EA8E1}| Sed:{DBDBDB} %d {2EA8E1}| Crack{DBDBDB} %d\n", PlayerInfo[targetid][pHunger], PlayerInfo[targetid][pThirst], PlayerInfo[targetid][pCrack]);
    strcat(string, dialog);
    Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "Información", string, "Aceptar", "");
    return 1;
}

CMD:jetx(playerid,params[]) {
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

    return SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
}

CMD:fly(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

	new Float:pos[3], Float:dist, Float:height;

	if(sscanf(params, "ff", dist, height)) {
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/fly [distancia] [altura]");
	}

	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    GetXYInFrontOfPlayer(playerid, pos[0], pos[1], dist);
	SetPlayerPos(playerid, pos[0], pos[1], pos[2] + height);
	PlayerPlaySound(playerid, 1130, pos[0], pos[1], pos[2] + height);
	return 1;
}

CMD:slap(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

	new Float:pos[3], targetid;
		
	if(sscanf(params, "r", targetid))
		return SendClientMessage(playerid, COLOR_GREY, "USO: /slap [ID/Nombre]");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, -1, "¡No se ha encontrado al jugador!");

	GetPlayerPos(targetid, pos[0], pos[1], pos[2]);
	SetPlayerPos(targetid, pos[0], pos[1], pos[2] + 5.0);
	PlayerPlaySound(targetid, 1130, pos[0], pos[1], pos[2] + 5.0);
	return 1;
}

// NOTA: Los comandos /h y /helper han sido deshabilitados. Usar /a y /admin para comunicación del staff.
/*
CMD:h(playerid, params[])
{
	return cmd_helper(playerid, params);
}

CMD:helper(playerid, params[])
{
	new text[256];

	if(sscanf(params, "s[256]", text))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"(/h)elper [mensaje]");
		
	if(PlayerInfo[playerid][pAdmin] > 0)
	{
		if(PlayerInfo[playerid][pAdmin] > 1)
			format(text, sizeof(text), "{E79600}[HELPER CHAT] {3CB371}%s{E79600}:{FFFFFF} %s", GetPlayerCleanName(playerid), text);
		else
            format(text, sizeof(text), "{E79600}[HELPER CHAT] {C8C8C8}%s{E79600}:{FFFFFF} %s", GetPlayerCleanName(playerid), text);
		AdministratorMessage(COLOR_ACHAT, text, 1);
	}
	return 1;
}
*/

/*
// SISTEMA ANTIGUO - COMENTADO
CMD:verdudas(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

    new string[1024], question[200], pendingquestions;

    foreach(new i : Player)
    {
    	if(PlayerInfo[i][pHaveQuestion] == 0)
    		continue;
		format(question, sizeof(question), "{878EE7}%s (%d) - {C8C8C8} %s.\n", GetPlayerCleanName(i), i, PlayerInfo[i][pQuestion]);
		strcat(string, question);
		pendingquestions++;
	}
	if(pendingquestions == 0)
		strcat(string, "No hay dudas pendientes de respuesta.");
	else
	{
		strcat(string, "\n{FF1212}IMPORTANTE:{C8C8C8} Atender las dudas con el respectivo comando primero (/(re)sponder) en vez de hacerlo solamente por /mp.\n");
        strcat(string, "{C8C8C8}En caso de ver una duda inadecuada (mal uso del comando) {FF1212}NO{C8C8C8} responderla, y dejarla pendiente hasta que la vea un administrador.");
	}
	Dialog_Show(playerid, DLG_QUESTIONS, DIALOG_STYLE_MSGBOX, "{FF0000}Dudas pendientes de respuesta", string, "Aceptar", "");
    return 1;
}
*/

/*
// SISTEMA ANTIGUO - COMENTADO
CMD:re(playerid, params[]) {
	return cmd_responder(playerid, params);
}

CMD:responder(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

	new targetid, str[144];

	if(sscanf(params, "us[144]", targetid, str))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/(re)sponder [ID/Jugador] [Respuesta]");
	if(targetid == INVALID_PLAYER_ID)
	    return 1;
	if(PlayerInfo[targetid][pHaveQuestion] == 0)
	    return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El usuario no tiene una duda pendiente de respuesta.");

	SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"%s (%s) [ID: %d] respondió tu duda:", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
	SendFMessage(targetid, COLOR_DOUBT, "[RESPUESTA] "COLOR_EMB_GREY" %s.", str);
	format(str, sizeof(str), "[INFO]"COLOR_EMB_GREY" %s (%s) [ID: %d] respondió la duda de %s (ID: %d).", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid), targetid);
	AdministratorMessage(COLOR_INFO, str, 1);
	
	PlayerInfo[targetid][pQuestion][0] = EOS;
	PlayerInfo[targetid][pHaveQuestion] = 0;
	return 1;
}
*/

/*
// SISTEMA ANTIGUO - COMENTADO
CMD:despejardudas(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

	foreach(new i : Player)
	    PlayerInfo[i][pHaveQuestion] = 0;

	SendClientMessage(playerid, COLOR_INFO, "[INFO]"COLOR_EMB_GREY" Todas las dudas de usuarios conectados fueron limpiadas.");
	return 1;
}
*/

/*
// SISTEMA ANTIGUO - COMENTADO
CMD:atenderreporte(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

	new targetid, str[144];

	if(sscanf(params, "us[144]", targetid, str))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/atenderreporte [ID/Jugador]");
	if(targetid == INVALID_PLAYER_ID)
	    return 1;
	if(PlayerInfo[targetid][pReport] == 0)
	    return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El usuario no tiene ningún reporte realizado o ya fue atendido.");

	SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"%s (%s) [ID: %d] tomó tu reporte", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
	format(str, sizeof(str), "[INFO]"COLOR_EMB_GREY" %s (%s) [ID: %d] ha tomado el reporte de %s (ID: %d).", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid), targetid);
	AdministratorMessage(COLOR_INFO, str, 1);

	PlayerInfo[targetid][pReport] = 0;
	return 1;
}
*/

/*
// SISTEMA ANTIGUO - COMENTADO
CMD:verreportes(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

    new string[1024], report[200], pendingreports;

    foreach(new i : Player)
    {
    	if(PlayerInfo[i][pReport] == 0)
    		continue;
		format(report, sizeof(report), "{878EE7}%s (%d) - {C8C8C8} %s.\n", GetPlayerCleanName(i), i, PlayerInfo[playerid][pReportReason]);
		strcat(string, report);
		pendingreports++;
	}
	if(pendingreports == 0)
		strcat(string, "No hay reportes pendientes de atención.");
	else
	{
		strcat(string, "\n{FF1212}IMPORTANTE:{C8C8C8} Atender los reportes con el comando primero (/atenderreporte) en vez de hacerlo solamente por /mp.\n");
        strcat(string, "{C8C8C8}En caso de ver un reporte inadecuado (mal uso del comando) {FF1212}NO{C8C8C8} responder, y dejarlo pendiente hasta que la vea un administrador.");
	}
	Dialog_Show(playerid, DLG_QUESTIONS, DIALOG_STYLE_MSGBOX, "{FF0000}Reportes pendientes de atención", string, "Aceptar", "");
    return 1;
}
*/

CMD:set(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new string[128],
	    target,
	    param[16],
	    value[64];
	    
	if(sscanf(params, "us[16]S(null)[64]", target, param, value))
	{
	    SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/set [IDJugador/ParteDelNombre] [opción] [value]");
	    SendClientMessage(playerid, COLOR_USAGE, "[OPCIONES] "COLOR_EMB_GREY" sexo - edad");
	}
	else if(strcmp(param, "sexo", true) == 0)
	{
	    if(strval(value) == 0)
		{
	        SendFMessage(target, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" %s (%s) [ID: %d] te ha seteado el sexo a femenino.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
			format(string, sizeof(string), "[STAFF] %s (%s) [ID: %d] ha seteado el sexo de %s a femenino.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(target));
			AdministratorMessage(COLOR_ADMINCMD, string, 2);
	        PlayerInfo[target][pSex] = 0;
	    }
		else if(strval(value) == 1)
		{
	        SendFMessage(target, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" %s (%s) [ID: %d] te ha seteado el sexo a masculino.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
			format(string, sizeof(string), "[STAFF] %s (%s) [ID: %d] ha seteado el sexo de %s a masculino.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(target));
			AdministratorMessage(COLOR_ADMINCMD, string, 2);
	        PlayerInfo[target][pSex] = 1;
	    }
		else
		{
	        SendClientMessage(playerid, COLOR_WHITE, "Solo se admite un valor igual a 0 (femenino) o 1 (masculino).");
	    }
	}
	else if(strcmp(param, "edad", true) == 0)
	{
	    if(strval(value) >= 15 && strval(value) <= 100)
		{
	        SendFMessage(target, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" %s (%s) [ID: %d] te ha seteado la edad a %d años.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, strval(value));
			format(string, sizeof(string), "[STAFF] %s (%s) [ID: %d] ha seteado la edad de %s a %d años.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(target), strval(value));
			AdministratorMessage(COLOR_ADMINCMD, string, 2);
	        PlayerInfo[target][pAge] = strval(value);
	    }
		else
		{
	        SendClientMessage(playerid, COLOR_WHITE, "Solo se admite un valor mayor o igual a 15 y menor o igual a 100.");
	    }
	}
	return 1;
}

CMD:vercanal(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new param[12];

	if(sscanf(params, "s[12]", param))
	{
	    SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/vercanal [opción]");
	    SendClientMessage(playerid, COLOR_USAGE, "[OPCIONES] "COLOR_EMB_GREY" mps - susurros - faccion - sms - 911 - todos");
	}
	else if(strcmp(param, "mps", true) == 0)
	{
		if(AdminPMsEnabled[playerid])
		{
			AdminPMsEnabled[playerid] = false;
			SendClientMessage(playerid, COLOR_GREEN, "Lector del canal de mensajería privada desactivado.");
		}
		else
		{
			AdminPMsEnabled[playerid] = true;
			SendClientMessage(playerid, COLOR_GREEN, "Lector del canal de mensajería privada activado.");
		}
	}
	else if(strcmp(param, "susurros", true) == 0)
	{
		if(AdminWhispersEnabled[playerid])
		{
			AdminWhispersEnabled[playerid] = false;
			SendClientMessage(playerid, COLOR_GREEN, "Lector del canal de susurros desactivado.");
		}
		else
		{
			AdminWhispersEnabled[playerid] = true;
			SendClientMessage(playerid, COLOR_GREEN, "Lector del canal de susurros activado.");
		}
	}
	else if(strcmp(param, "faccion", true) == 0)
	{
		if(AdminFactionEnabled[playerid])
		{
			AdminFactionEnabled[playerid] = false;
			SendClientMessage(playerid, COLOR_GREEN, "Lector del canal faccionario desactivado.");
		}
		else
		{
			AdminFactionEnabled[playerid] = true;
			SendClientMessage(playerid, COLOR_GREEN, "Lector del canal faccionario activado.");
		}
	}
	else if(strcmp(param, "sms", true) == 0)
	{
		if(AdminSMSEnabled[playerid])
		{
			AdminSMSEnabled[playerid] = false;
			SendClientMessage(playerid, COLOR_GREEN, "Lector de los mensajes de celular desactivado.");
		}
		else
		{
			AdminSMSEnabled[playerid] = true;
			SendClientMessage(playerid, COLOR_GREEN, "Lector de los mensajes de celular activados.");
		}
	}
	else if(strcmp(param, "911", true) == 0)
	{
		if(Admin911Enabled[playerid])
		{
			Admin911Enabled[playerid] = false;
			SendClientMessage(playerid, COLOR_GREEN, "Lector de las llamadas al 911 desactivado.");
		}
		else
		{
            Admin911Enabled[playerid] = true;
			SendClientMessage(playerid, COLOR_GREEN, "Lector de las llamadas al 911 activado.");
		}
	}
	else if(strcmp(param, "todos", true) == 0)
	{
		if(AdminPMsEnabled[playerid] || AdminWhispersEnabled[playerid] || AdminFactionEnabled[playerid] || AdminSMSEnabled[playerid] || Admin911Enabled[playerid])
		{
			AdminPMsEnabled[playerid] = false;
			AdminWhispersEnabled[playerid] = false;
			AdminFactionEnabled[playerid] = false;
			AdminSMSEnabled[playerid] = false;
			Admin911Enabled[playerid] = false;
			SendClientMessage(playerid, COLOR_GREEN, "Todos los lectores administrativos fueron desactivados (MPS-Susurros-Facción-SMS-911)");
		}
		else
		{
			AdminPMsEnabled[playerid] = true;
			AdminWhispersEnabled[playerid] = true;
			AdminFactionEnabled[playerid] = true;
			AdminSMSEnabled[playerid] = true;
			Admin911Enabled[playerid] = true;
			SendClientMessage(playerid, COLOR_GREEN, "Todos los lectores administrativos fueron activados (MPS-Susurros-Facción-SMS-911)");
		}
	}
	return 1;
}

CMD:crearcuenta(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new name[24];

	if(sscanf(params, "s[24]", name))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/crearcuenta [Nombre_Apellido]");
	if(!IsNameRoleplayValid(name))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El formato del nombre debe ser Nombre_Apellido. máximo 24 carácteres.");

	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT EXISTS(SELECT 1 FROM accounts WHERE Name='%s' LIMIT 1) as 'account_exists'", name);
	mysql_tquery(MYSQL_HANDLE, query, "InsertNewAccount", "is", playerid, name);
	return 1;
}

forward InsertNewAccount(playerid, const name[]);
public InsertNewAccount(playerid, const name[])
{
	if(cache_index_int(0, 0))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya existe otra cuenta con ese nombre.");

	new password[10];
	GenerateRandomPassword(password);

	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO accounts (Name, Password) VALUES ('%s', MD5('%s'))", name, password);
	mysql_tquery(MYSQL_HANDLE, query);

	new string[128];
	format(string, sizeof(string), "[STAFF] el administrador/certificador %s (%s) [ID: %d] ha creado la cuenta '%s'.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, name);
	AdministratorMessage(COLOR_ADMINCMD, string, 1);

	SendFMessage(playerid, COLOR_WHITE, "La contraseña de la cuenta que deberás informar al usuario es '%s' (sin las comillas).", password);
	ServerLog(LOG_TYPE_ID_ADMIN, .entry="/crearcuenta", .playerid=playerid, .params=name);
	return 1;
}



CMD:aresetpassword(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new name[MAX_PLAYER_NAME];

	if(sscanf(params, "s[24]", name))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aresetpassword [Nombre_Apellido]");

	new password[10];
	GenerateRandomPassword(password);

	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `accounts` SET `Password`=MD5('%s') WHERE `Name`='%e';", password, name);
	mysql_tquery(MYSQL_HANDLE, query);

	new string[128];
	format(string, sizeof(string), "[STAFF] El administrador %s (%s) [ID: %d] ha reseteado la contraseña de la cuenta '%s'.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, name);
	AdministratorMessage(COLOR_ADMINCMD, string, 1);

	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Si la cuenta existe, la nueva contraseña es '%s' (sin las comillas).", password);
	ServerLog(LOG_TYPE_ID_ADMIN, .entry="/aresetpassword", .playerid=playerid, .params=name);
	return 1;
}

// COMANDOS DE BANEO LEGACY (DESHABILITADOS - Usar /bacc, /bip, /bpj en su lugar)
/*
CMD:ban(playerid, params[]) {
	return cmd_banear(playerid, params);
}

CMD:banear(playerid, params[])
{
	new targetid, reason[128], days;
	
	if(sscanf(params, "uis[128]", targetid, days, reason))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"(/ban)ear [ID/Jugador] [días (0 = permaban)] [razón]");
   	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(days < 0 || days > 300)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La cantidad de días de duración debe estar entre (0 - 300).");
    if(IsPlayerNPC(targetid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La ID corresponde a un NPC.");
	if(PlayerInfo[targetid][pAdmin] >= 20 && !IsPlayerAdmin(playerid))
	    return 1;
	    
	BanPlayer(targetid, playerid, reason, days);
	return 1;
}
*/

CMD:desbanear(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new target[64], banType[64];
	
	// Formato: /desbanear [tipo] [valor]
	// Tipos: cuenta, ip, personaje (o nombre/ip directo para compatibilidad)
	if(sscanf(params, "s[64]S()[64]", banType, target))
	{
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/desbanear [tipo] [valor]");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tipos: cuenta, ip, personaje");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Ejemplos:");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"  /desbanear cuenta NombreUsuario");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"  /desbanear ip 127.0.0.1");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"  /desbanear personaje Roberto_Martinez");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"  /desbanear Roberto_Martinez (busca en todos los tipos)");
		return 1;
	}
	
	// Si no se especificó segundo parámetro, el primero es el valor y se busca en todos los tipos
	if(target[0] == EOS)
	{
		format(target, sizeof(target), "%s", banType);
		
		// Determinar automáticamente el tipo
		if(strfind(target, ".", true) != -1) 
		{
			// Parece una IP
			new query[256];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), 
				"SELECT * FROM `bans` WHERE `pIP`='%e' AND `banActive`=1 AND `banType`='IP' LIMIT 1", target);
			mysql_tquery(MYSQL_HANDLE, query, "OnUnbanDataLoad", "iis", playerid, 3, target);
		}
		else if(strfind(target, "_", true) != -1)
		{
			// Parece un nombre de personaje
			new query[256];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), 
				"SELECT * FROM `bans` WHERE `pName`='%e' AND `banActive`=1 LIMIT 1", target);
			mysql_tquery(MYSQL_HANDLE, query, "OnUnbanDataLoad", "iis", playerid, 4, target);
		}
		else
		{
			// Parece un nombre de usuario de cuenta maestra
			new query[512];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), 
				"SELECT b.* FROM `bans` b INNER JOIN `master_accounts` ma ON b.master_account_id = ma.id WHERE ma.username='%e' AND b.banActive=1 AND b.banType='CUENTA' LIMIT 1", target);
			mysql_tquery(MYSQL_HANDLE, query, "OnUnbanDataLoad", "iis", playerid, 2, target);
		}
	}
	else
	{
		// Se especificó el tipo explícitamente
		if(strcmp(banType, "cuenta", true) == 0)
		{
			new query[512];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), 
				"SELECT b.* FROM `bans` b INNER JOIN `master_accounts` ma ON b.master_account_id = ma.id WHERE ma.username='%e' AND b.banActive=1 AND b.banType='CUENTA' LIMIT 1", target);
			mysql_tquery(MYSQL_HANDLE, query, "OnUnbanDataLoad", "iis", playerid, 2, target);
		}
		else if(strcmp(banType, "ip", true) == 0)
		{
			new query[256];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), 
				"SELECT * FROM `bans` WHERE `pIP`='%e' AND `banActive`=1 AND `banType`='IP' LIMIT 1", target);
			mysql_tquery(MYSQL_HANDLE, query, "OnUnbanDataLoad", "iis", playerid, 3, target);
		}
		else if(strcmp(banType, "personaje", true) == 0 || strcmp(banType, "pj", true) == 0)
		{
			new query[256];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), 
				"SELECT * FROM `bans` WHERE `pName`='%e' AND `banActive`=1 AND `banType`='PERSONAJE' LIMIT 1", target);
			mysql_tquery(MYSQL_HANDLE, query, "OnUnbanDataLoad", "iis", playerid, 4, target);
		}
		else
		{
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tipo de baneo inválido. Usa: cuenta, ip, personaje");
			return 1;
		}
	}
	
	return 1;
}

forward OnUnbanDataLoad(playerid, type, target[64]);
public OnUnbanDataLoad(playerid, type, target[64])
{
	new rows = cache_num_rows(), string[256];

	// type: 0 = nombre personaje legacy, 1 = IP legacy, 2 = cuenta, 3 = IP, 4 = personaje/auto
	if(type == 0) // Legacy: desbanear por nombre
	{
		if(rows)
		{
			new master_id, banTypeStr[16];
			cache_get_value_int(0, "master_account_id", master_id);
			cache_get_value_name(0, "banType", banTypeStr, sizeof(banTypeStr));
			
			format(string, sizeof(string), "[STAFF]{FFFFFF} El administrador %s ha desbaneado a '%s'. {E44A4A}Tipo:{FFFFFF} %s", AccountInfo[playerid][accUsername], target, banTypeStr);
			SendClientMessageToAll(COLOR_RED, string);
			
			// Desbanear considerando el tipo
			if(strcmp(banTypeStr, "CUENTA", false) == 0 && master_id > 0)
			{
				new query[256];
				mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `bans` SET `banActive`=0 WHERE `master_account_id`=%d AND `banType`='CUENTA'", master_id);
				mysql_tquery(MYSQL_HANDLE, query);
			}
			else if(strcmp(banTypeStr, "PERSONAJE", false) == 0)
			{
				new query[256];
				mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `bans` SET `banActive`=0 WHERE `pName`='%e' AND `banType`='PERSONAJE'", target);
				mysql_tquery(MYSQL_HANDLE, query);
			}
			else
			{
				// Fallback para baneos antiguos sin banType
				new query[256];
				if(master_id > 0)
				{
					mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `bans` SET `banActive`=0 WHERE `master_account_id`=%d", master_id);
					mysql_tquery(MYSQL_HANDLE, query);
				}
				else
				{
					mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `bans` SET `banActive`=0 WHERE `pName`='%e'", target);
					mysql_tquery(MYSQL_HANDLE, query);
				}
			}
		}
		else
		{
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No se ha encontrado ningún ban ACTIVO relacionado con '%s'.", target);
			return 1;
		}
	}
	else if(type == 1) // Legacy: desbanear por IP
	{
		if(rows)
		{
			format(string, sizeof(string), "[STAFF]{FFFFFF} El administrador %s ha desbaneado la IP '%s'.", AccountInfo[playerid][accUsername], target);
			SendClientMessageToAll(COLOR_RED, string);
			new query[256];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `bans` SET `banActive`=0 WHERE `pIP`='%e'", target);
			mysql_tquery(MYSQL_HANDLE, query);
		}
		else
		{
		    SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No se ha encontrado ningún ban ACTIVO de IP relacionado con '%s'.", target);
		    return 1;
		}
	}
	else if(type == 2) // Desbanear cuenta
	{
		if(rows)
		{
			new master_id;
			cache_get_value_int(0, "master_account_id", master_id);
			
			format(string, sizeof(string), "[STAFF]{FFFFFF} El administrador %s ha desbaneado la cuenta '%s'.", AccountInfo[playerid][accUsername], target);
			SendClientMessageToAll(COLOR_RED, string);
			
			new query[256];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `bans` SET `banActive`=0 WHERE `master_account_id`=%d AND `banType`='CUENTA'", master_id);
			mysql_tquery(MYSQL_HANDLE, query);
		}
		else
		{
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No se ha encontrado ningún ban ACTIVO de CUENTA para '%s'.", target);
			return 1;
		}
	}
	else if(type == 3) // Desbanear IP
	{
		if(rows)
		{
			format(string, sizeof(string), "[STAFF]{FFFFFF} El administrador %s ha desbaneado la IP '%s'.", AccountInfo[playerid][accUsername], target);
			SendClientMessageToAll(COLOR_RED, string);
			
			new query[256];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `bans` SET `banActive`=0 WHERE `pIP`='%e' AND `banType`='IP'", target);
			mysql_tquery(MYSQL_HANDLE, query);
		}
		else
		{
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No se ha encontrado ningún ban ACTIVO de IP para '%s'.", target);
			return 1;
		}
	}
	else if(type == 4) // Desbanear personaje o auto-detección
	{
		if(rows)
		{
			new banTypeStr[16];
			cache_get_value_name(0, "banType", banTypeStr, sizeof(banTypeStr));
			
			if(strcmp(banTypeStr, "PERSONAJE", false) == 0)
			{
				format(string, sizeof(string), "[STAFF]{FFFFFF} El administrador %s ha desbaneado el personaje '%s'.", AccountInfo[playerid][accUsername], target);
				SendClientMessageToAll(COLOR_RED, string);
				new query[256];
				mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `bans` SET `banActive`=0 WHERE `pName`='%e' AND `banType`='PERSONAJE'", target);
				mysql_tquery(MYSQL_HANDLE, query);
			}
			else
			{
				// Auto-detección encontró un baneo (probablemente de cuenta)
				new master_id;
				cache_get_value_int(0, "master_account_id", master_id);
				
				format(string, sizeof(string), "[STAFF]{FFFFFF} El administrador %s ha desbaneado a '%s'.", AccountInfo[playerid][accUsername], target);
				SendClientMessageToAll(COLOR_RED, string);
				
				new query[256];
				if(master_id > 0)
				{
					mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `bans` SET `banActive`=0 WHERE `pName`='%e' OR `master_account_id`=%d", target, master_id);
					mysql_tquery(MYSQL_HANDLE, query);
				}
				else
				{
					mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE `bans` SET `banActive`=0 WHERE `pName`='%e'", target);
					mysql_tquery(MYSQL_HANDLE, query);
				}
			}
		}
		else
		{
			SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No se ha encontrado ningún ban ACTIVO para '%s'.", target);
			return 1;
		}
	}
	return 1;
}

CMD:verbaneos(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new targetid;
	
	if(sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/verbaneos [ID/Jugador]");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
		
	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), 
		"SELECT * FROM bans WHERE master_account_id=%d ORDER BY banDate DESC LIMIT 10", 
		PlayerInfo[targetid][pMasterAccountId]);
	mysql_tquery(MYSQL_HANDLE, query, "OnShowPlayerBans", "ii", playerid, targetid);
	
	return 1;
}

forward OnShowPlayerBans(playerid, targetid);
public OnShowPlayerBans(playerid, targetid)
{
	new rows = cache_num_rows();
	
	if(rows == 0)
	{
		new string[128];
		format(string, sizeof(string), "El jugador %s no tiene baneos registrados en su cuenta.", GetPlayerCleanName(targetid));
		SendClientMessage(playerid, COLOR_INFO, string);
		return 1;
	}
	
	new string[256];
	format(string, sizeof(string), "=== Baneos de %s (Cuenta maestra ID: %d) ===", 
		GetPlayerCleanName(targetid), PlayerInfo[targetid][pMasterAccountId]);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	
	new banReason[128], banIssuer[MAX_PLAYER_NAME], banDate[32], banEnd[32], isActive;
	
	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name(i, "banReason", banReason, 128);
		cache_get_value_name(i, "banIssuerName", banIssuer, MAX_PLAYER_NAME);
		cache_get_value_name(i, "banDate", banDate, 32);
		cache_get_value_name(i, "banEnd", banEnd, 32);
		cache_get_value_int(i, "banActive", isActive);
		
		format(string, sizeof(string), "%d. [%s] Por: %s | Hasta: %s | Razón: %s", 
			i+1, (isActive ? ("ACTIVO") : ("INACTIVO")), banIssuer, banEnd, banReason);
		SendClientMessage(playerid, COLOR_WHITE, string);
	}
	
	return 1;
}

// ==================== NUEVOS COMANDOS DE BANEO ====================

CMD:bacc(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	// Banear cuenta (master_account) por ID o nombre de jugador conectado
	new targetid, reason[128], days;
	
	if(sscanf(params, "uis[128]", targetid, days, reason))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/bacc [ID/Jugador] [días (0 = permaban)] [razón]");
   	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(days < 0 || days > 300)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La cantidad de días de duración debe estar entre (0 - 300).");
    if(IsPlayerNPC(targetid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La ID corresponde a un NPC.");
	if(PlayerInfo[targetid][pAdmin] >= 20 && !IsPlayerAdmin(playerid))
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes banear a un administrador nivel 20+.");
	    return 1;
	}
	
	if(PlayerInfo[targetid][pMasterAccountId] <= 0)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este jugador no tiene una cuenta maestra asociada.");
	
	printf("[DEBUG] Ejecutando BanAccount: playerid=%d, issuerid=%d, days=%d, reason=%s", targetid, playerid, days, reason);
	BanAccount(targetid, playerid, reason, days);
	return 1;
}

CMD:baccoff(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	// Banear cuenta (master_account) offline por nombre de usuario de la cuenta maestra
	new username[64], reason[128], days;
	
	if(sscanf(params, "s[64]is[128]", username, days, reason))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/baccoff [Usuario_Cuenta] [días (0 = permaban)] [razón]");
	if(days < 0 || days > 300)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La cantidad de días de duración debe estar entre (0 - 300).");
	    
	BanAccountOffline(username, playerid, reason, days);
	return 1;
}

CMD:bip(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	// Banear IP
	new ip[16], reason[128], days;
	
	if(sscanf(params, "s[16]is[128]", ip, days, reason))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/bip [IP] [días (0 = permaban)] [razón]");
	if(days < 0 || days > 300)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La cantidad de días de duración debe estar entre (0 - 300).");
	
	// Validar formato de IP básico
	if(strfind(ip, ".", true) == -1)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Formato de IP inválido.");
	    
	BanIP(ip, playerid, reason, days);
	return 1;
}

CMD:bpj(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	// Banear personaje (solo el personaje específico, no la cuenta completa)
	new targetid, reason[128], days;
	
	if(sscanf(params, "uis[128]", targetid, days, reason))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/bpj [ID/Jugador] [días (0 = permaban)] [razón]");
   	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(days < 0 || days > 300)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La cantidad de días de duración debe estar entre (0 - 300).");
    if(IsPlayerNPC(targetid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La ID corresponde a un NPC.");
	if(PlayerInfo[targetid][pAdmin] >= 20 && !IsPlayerAdmin(playerid))
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes banear a un administrador nivel 20+.");
	    return 1;
	}
	
	printf("[DEBUG] Ejecutando BanCharacter: playerid=%d, issuerid=%d, days=%d, reason=%s", targetid, playerid, days, reason);
	BanCharacter(targetid, playerid, reason, days);
	return 1;
}

CMD:bpjoff(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	// Banear personaje offline por nombre
	new acc[MAX_PLAYER_NAME], reason[128], days;
	
	if(sscanf(params, "s[32]is[128]", acc, days, reason))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/bpjoff [Nombre_Apellido] [días (0 = permaban)] [razón]");
	if(days < 0 || days > 300)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La cantidad de días de duración debe estar entre (0 - 300).");
	    
	BanCharacterOffline(acc, playerid, reason, days);
	return 1;
}

CMD:cambiarnombre(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 10)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator II o superior para usar este comando.");

	new name[24], targetid;

	if(sscanf(params, "us[24]", targetid, name))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/cambiarnombre [ID/Jugador] [nombre]");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(!IsNameRoleplayValid(name))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nombre inválido. Debe seguir el formato esperado para un roleplay. Ej: Roberto_Martinez (máximo 24 carácteres).");

	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT EXISTS(SELECT 1 FROM accounts WHERE Name='%e' LIMIT 1) as 'account_exists'", name);
	mysql_tquery(MYSQL_HANDLE, query, "ChangeAccountName", "iis", playerid, targetid, name);
	return 1;
}

forward ChangeAccountName(playerid, targetid, const name[]);
public ChangeAccountName(playerid, targetid, const name[])
{
	if(!IsPlayerLogged(playerid) || !IsPlayerLogged(targetid))
		return 0;
	if(cache_index_int(0, 0))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya existe otra cuenta con ese nombre.");

	new string[128];
	format(string, sizeof(string), "[STAFF] el administrador %s (%s) [ID: %d] le ha cambiado el nombre a %s a '%s'.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid), name);
	AdministratorMessage(COLOR_ADMINCMD, string, 2);

	ServerLog(LOG_TYPE_ID_ADMIN, .entry="/cambiarnombre", .playerid=playerid, .targetid=targetid, .params=name);
	SetPlayerName(targetid, name);

	KeyChain_UpdatePlayerName(targetid);

	SendFMessage(targetid, COLOR_WHITE, "Tu nombre ha sido cambiado a %s por el administrador %s (%s) [ID: %d].", GetPlayerCleanName(targetid), GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);

	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE accounts SET Name='%s' WHERE Id=%i", name, getPlayerMysqlId(targetid));
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}

CMD:kick(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

    new targetid, reason[128];

	if(sscanf(params, "us[128]", targetid, reason))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/kick [ID/Jugador] [razón]");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(IsPlayerNPC(targetid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"la ID corresponde a un NPC.");
	    
    KickPlayer(targetid, AccountInfo[playerid][accUsername], reason);
    return 1;
}

CMD:checkinv(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new targetID;
	
	if(sscanf(params, "u", targetID))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/checkinv [ID/Jugador]");
	if(!IsPlayerLogged(targetID))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");

	SendFMessage(playerid, COLOR_WHITE, "Usuario: %s (%d) - DBID: %d", GetPlayerCleanName(targetID), targetID, PlayerInfo[targetID][pID]);
	PrintHandsForPlayer(targetID, playerid);
	PrintInvForPlayer(targetID, playerid);
	PrintToysForPlayer(targetID, playerid);
	Back_PrintHandsForPlayer(targetID, playerid);
	Holster_PrintForPlayer(targetID, playerid);
	return 1;
}

CMD:checkllavero(playerid, params[])
{
	if(!IsPlayerLogged(playerid))
		return false;
	
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");
	
	new targetid;
	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/checkllavero [ID/Jugador]");
	
	if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no está conectado o no ha iniciado sesión.");
	
	// Mostrar el llavero del jugador objetivo
	KeyChain_Show(targetid, playerid);
	
	// Mensaje informativo al administrador
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Llavero de %s (ID: %d)", GetPlayerCleanName(targetid), targetid);
	
	return 1;
}

CMD:checkoff(playerid, params[])
{
	if(!IsPlayerLogged(playerid))
		return false;
	
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");
	
	new playername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]", playername))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/checkoff [Nombre_Apellido]");
	
	// Buscar el personaje en la base de datos
	new query[768];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), 
		"SELECT a.Id, a.Name, a.Level, a.Exp, a.Skin, a.Job, a.Faction, a.Rank, a.Warnings, a.pRolePoints, a.CashMoney, a.BankMoney, \
		a.LastConnected, a.pTimePlayed, a.pWorld, a.pInterior, a.Ip, a.Jailed, a.JailedTime, m.id as master_id, m.username, \
		(SELECT COUNT(*) FROM bans WHERE master_account_id = m.id AND banActive = 1) as account_banned, \
		(SELECT COUNT(*) FROM bans WHERE pName = a.Name AND banActive = 1) as char_banned \
		FROM accounts a \
		LEFT JOIN master_accounts m ON a.master_account_id = m.id \
		WHERE a.Name = '%e' LIMIT 1",
		playername
	);
	mysql_tquery(MYSQL_HANDLE, query, "ShowStatsOfflineCallback", "is", playerid, playername);
	
	return 1;
}

forward ShowStatsOfflineCallback(playerid, playername[]);
public ShowStatsOfflineCallback(playerid, playername[])
{
	if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid))
		return 1;
	
	if(cache_num_rows() == 0) {
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontró el personaje '%s' en la base de datos.", playername);
		return 1;
	}
	
	new dialogLine[256], dialogStr[2048];
	new accountId, lvl, exp, playerSkin, playerJob, playerFaction, playerRank, warns, rolepoints, playerCash, playerBank;
	new lastConnected[32], timePlayed, playerWorld, playerInterior, playerIp[20];
	new masterAccountId, masterAccountName[64];
	new charName[MAX_PLAYER_NAME];
	new jailed, jailedTime, accountBanned, charBanned;
	
	// Obtener datos
	cache_get_value_name_int(0, "Id", accountId);
	cache_get_value_name(0, "Name", charName, sizeof(charName));
	cache_get_value_name_int(0, "Level", lvl);
	cache_get_value_name_int(0, "Exp", exp);
	cache_get_value_name_int(0, "Skin", playerSkin);
	cache_get_value_name_int(0, "Job", playerJob);
	cache_get_value_name_int(0, "Faction", playerFaction);
	cache_get_value_name_int(0, "Rank", playerRank);
	cache_get_value_name_int(0, "Warnings", warns);
	cache_get_value_name_int(0, "pRolePoints", rolepoints);
	cache_get_value_name_int(0, "CashMoney", playerCash);
	cache_get_value_name_int(0, "BankMoney", playerBank);
	cache_get_value_name(0, "LastConnected", lastConnected, sizeof(lastConnected));
	cache_get_value_name_int(0, "pTimePlayed", timePlayed);
	cache_get_value_name_int(0, "pWorld", playerWorld);
	cache_get_value_name_int(0, "pInterior", playerInterior);
	cache_get_value_name(0, "Ip", playerIp, sizeof(playerIp));
	cache_get_value_name_int(0, "Jailed", jailed);
	cache_get_value_name_int(0, "JailedTime", jailedTime);
	cache_get_value_name_int(0, "master_id", masterAccountId);
	cache_get_value_name(0, "username", masterAccountName, sizeof(masterAccountName));
	cache_get_value_name_int(0, "account_banned", accountBanned);
	cache_get_value_name_int(0, "char_banned", charBanned);
	
	new factionTxt[64], jobTxt[32];
	
	if(playerFaction > 0) {
		format(factionTxt, sizeof(factionTxt), "%s | Rango: %d", FactionInfo[playerFaction][fName], playerRank);
	} else {
		strcat(factionTxt, "Ninguna | Rango: Ninguno", sizeof(factionTxt));
	}
	
	if(playerJob > 0) {
		strcat(jobTxt, JobInfo[playerJob][jName], sizeof(jobTxt));
	} else {
		strcat(jobTxt, "No", sizeof(jobTxt));
	}
	
	format(dialogLine, sizeof(dialogLine), "{FF0000}[OFFLINE] {2EA8E1}Personaje:{DBDBDB} %s (ID BD: %d)\n", playername, accountId);
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Cuenta:{DBDBDB} %s (ID: %d)\n", masterAccountName, masterAccountId);
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Mundo:{DBDBDB} %d {2EA8E1}| Interior:{DBDBDB} %d\n", playerWorld, playerInterior);
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Advertencias:{DBDBDB} %d\n", warns);
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Puntos de rol:{DBDBDB} %d\n", rolepoints);
	strcat(dialogStr, dialogLine);
	new jailText[64];
	if(jailed) {
		format(jailText, sizeof(jailText), "Sí (%d minutos)", jailedTime);
	} else {
		format(jailText, sizeof(jailText), "No");
	}
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Sanción OOC:{DBDBDB} %s\n", jailText);
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Ban de cuenta:{DBDBDB} %s\n", accountBanned ? "{FF0000}Sí" : "{00FF00}No");
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Ban de personaje:{DBDBDB} %s\n", charBanned ? "{FF0000}Sí" : "{00FF00}No");
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Skin:{DBDBDB} %d\n", playerSkin);
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Última conexión:{DBDBDB} %s\n", lastConnected);
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Tiempo jugado:{DBDBDB} %d horas\n", timePlayed / 3600);
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}IP:{DBDBDB} %s\n", playerIp);
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), " \n");
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Nivel:{DBDBDB} %d\n", lvl);
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Experiencia:{DBDBDB} %d\n", exp);
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Dinero:{DBDBDB} $%d\n", playerCash);
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Banco:{DBDBDB} $%d\n", playerBank);
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Facción:{DBDBDB} %s\n", factionTxt);
	strcat(dialogStr, dialogLine);
	format(dialogLine, sizeof(dialogLine), "{2EA8E1}Empleo:{DBDBDB} %s\n", jobTxt);
	strcat(dialogStr, dialogLine);
	
	Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "[CHECK OFFLINE] Estadísticas", dialogStr, "Cerrar", "");
	return 1;
}

CMD:checkinvoff(playerid, params[])
{
	if(!IsPlayerLogged(playerid))
		return false;
	
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");
	
	new playername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]", playername))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/checkinvoff [Nombre_Apellido]");
	
	// Buscar el inventario del personaje en la base de datos
	new query[768];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), 
		"SELECT a.Name, a.pContainerSQLID, cs.Item, cs.Param, \
		a.r_hand_item, a.r_hand_param, a.l_hand_item, a.l_hand_param, \
		a.back_carry, a.back_item, a.back_param \
		FROM accounts a \
		LEFT JOIN containers_slots cs ON a.pContainerSQLID = cs.id \
		WHERE a.Name = '%e' \
		ORDER BY cs.registry",
		playername
	);
	mysql_tquery(MYSQL_HANDLE, query, "ShowInventoryOfflineCallback", "is", playerid, playername);
	
	return 1;
}

forward ShowInventoryOfflineCallback(playerid, playername[]);
public ShowInventoryOfflineCallback(playerid, playername[])
{
	if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid))
		return 1;
	
	new totalRows = cache_num_rows();
	
	// Verificar si el personaje existe (debe haber al menos 1 row del LEFT JOIN)
	if(totalRows == 0) {
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontró el personaje '%s'.", playername);
		return 1;
	}
	
	new invStr[2048] = "{FF0000}[OFFLINE] {DBDBDB}Inventario de {2EA8E1}";
	strcat(invStr, playername);
	strcat(invStr, "\n\n");
	
	// Obtener objetos en manos y espalda (siempre del primer row porque el personaje siempre está ahí)
	new rHandItem, rHandParam, lHandItem, lHandParam, backCarry, backItm, backParam;
	cache_get_value_name_int(0, "r_hand_item", rHandItem);
	cache_get_value_name_int(0, "r_hand_param", rHandParam);
	cache_get_value_name_int(0, "l_hand_item", lHandItem);
	cache_get_value_name_int(0, "l_hand_param", lHandParam);
	cache_get_value_name_int(0, "back_carry", backCarry);
	cache_get_value_name_int(0, "back_item", backItm);
	cache_get_value_name_int(0, "back_param", backParam);
	
	// Mostrar manos
	if(rHandItem > 0) {
		new invLn[128];
		format(invLn, sizeof(invLn), "{FFA500}[Mano Derecha] {2EA8E1}%s {DBDBDB}- Parámetro: {FFFFFF}%d\n", ItemModel_GetName(rHandItem), rHandParam);
		strcat(invStr, invLn);
	} else {
		strcat(invStr, "{FFA500}[Mano Derecha] {DBDBDB}Vacía\n");
	}
	
	if(lHandItem > 0) {
		new invLn[128];
		format(invLn, sizeof(invLn), "{FFA500}[Mano Izquierda] {2EA8E1}%s {DBDBDB}- Parámetro: {FFFFFF}%d\n", ItemModel_GetName(lHandItem), lHandParam);
		strcat(invStr, invLn);
	} else {
		strcat(invStr, "{FFA500}[Mano Izquierda] {DBDBDB}Vacía\n");
	}
	
	// Mostrar espalda/pecho
	if(backCarry > 0 && backItm > 0) {
		new invLn[128];
		format(invLn, sizeof(invLn), "{00FFFF}[Espalda/Pecho] {2EA8E1}%s {DBDBDB}- Parámetro: {FFFFFF}%d\n", ItemModel_GetName(backItm), backParam);
		strcat(invStr, invLn);
	} else {
		strcat(invStr, "{00FFFF}[Espalda/Pecho] {DBDBDB}Vacío\n");
	}
	
	strcat(invStr, "\n{FFFFFF}--- Inventario ---\n");
	
	new itemFound = false;
	for(new i = 0; i < totalRows; i++)
	{
		new itemId, itemParam;
		cache_get_value_name_int(i, "Item", itemId);
		cache_get_value_name_int(i, "Param", itemParam);
		
		if(itemId > 0)
		{
			itemFound = true;
			new invLn[128];
			format(invLn, sizeof(invLn), "{DBDBDB}[%d] {2EA8E1}%s {DBDBDB}- Parámetro: {FFFFFF}%d\n", i + 1, ItemModel_GetName(itemId), itemParam);
			strcat(invStr, invLn);
		}
	}
	
	if(!itemFound)
		strcat(invStr, "{DBDBDB}El inventario está vacío.\n");
	
	Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "[INVENTARIO OFFLINE]", invStr, "Cerrar", "");
	return 1;
}

CMD:checkllaverooff(playerid, params[])
{
	if(!IsPlayerLogged(playerid))
		return false;
	
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");
	
	new playername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]", playername))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/checkllaverooff [Nombre_Apellido]");
	
	// Buscar el llavero del personaje en la base de datos
	new query[512];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), 
		"SELECT a.Name, pk.keyid, pk.type, pk.extraid, pk.owner, pk.label \
		FROM accounts a \
		INNER JOIN player_key pk ON a.Id = pk.playerid \
		WHERE a.Name = '%e' \
		ORDER BY pk.keyid",
		playername
	);
	mysql_tquery(MYSQL_HANDLE, query, "ShowKeyChainOfflineCallback", "is", playerid, playername);
	
	return 1;
}

forward ShowKeyChainOfflineCallback(playerid, playername[]);
public ShowKeyChainOfflineCallback(playerid, playername[])
{
	if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid))
		return 1;
	
	if(cache_num_rows() == 0) {
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontró el personaje '%s' o no tiene llaves.", playername);
		return 1;
	}
	
	new totalRows = cache_num_rows();
	new keyStr[1024] = "{FF0000}[OFFLINE] {DBDBDB}Llavero de {2EA8E1}";
	strcat(keyStr, playername);
	strcat(keyStr, "\n\n");
	
	for(new i = 0; i < totalRows; i++)
	{
		new keyid, keytype, keyExtraid, keyOwner;
		new keyLabel[32], typeText[32];
		
		cache_get_value_name_int(i, "keyid", keyid);
		cache_get_value_name_int(i, "type", keytype);
		cache_get_value_name_int(i, "extraid", keyExtraid);
		cache_get_value_name_int(i, "owner", keyOwner);
		cache_get_value_name(i, "label", keyLabel, sizeof(keyLabel));
		
		// Determinar el tipo de llave
		switch(keytype)
		{
			case 1: format(typeText, sizeof(typeText), "Vehículo");
			case 2: format(typeText, sizeof(typeText), "Negocio");
			case 3: format(typeText, sizeof(typeText), "Casa");
			default: format(typeText, sizeof(typeText), "Tipo %d", keytype);
		}
		
		new keyLn[128];
		if(keyOwner) {
			format(keyLn, sizeof(keyLn), "{DBDBDB}[%d] {FFFFFF}%s {DBDBDB}- {2EA8E1}%s {DBDBDB}(ID: %d) {00FF00}[DUEÑO]\n", i + 1, keyLabel, typeText, keyExtraid);
		} else {
			format(keyLn, sizeof(keyLn), "{DBDBDB}[%d] {FFFFFF}%s {DBDBDB}- {2EA8E1}%s {DBDBDB}(ID: %d)\n", i + 1, keyLabel, typeText, keyExtraid);
		}
		strcat(keyStr, keyLn);
	}
	
	Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "[LLAVERO OFFLINE]", keyStr, "Cerrar", "");
	return 1;
}

CMD:checkpcintoff(playerid, params[])
{
	if(!IsPlayerLogged(playerid))
		return false;
	
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");
	
	new playername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]", playername))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/checkpcintoff [Nombre_Apellido]");
	
	// Buscar el cinturón policial del personaje en la base de datos
	new query[512];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), 
		"SELECT a.Name, a.pBeltSQLID, cs.Item, cs.Param \
		FROM accounts a \
		LEFT JOIN containers_slots cs ON a.pBeltSQLID = cs.id \
		WHERE a.Name = '%e' \
		ORDER BY cs.registry",
		playername
	);
	mysql_tquery(MYSQL_HANDLE, query, "ShowBeltOfflineCallback", "is", playerid, playername);
	
	return 1;
}

forward ShowBeltOfflineCallback(playerid, playername[]);
public ShowBeltOfflineCallback(playerid, playername[])
{
	if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid))
		return 1;
	
	if(cache_num_rows() == 0) {
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontró el personaje '%s' o no tiene cinturón policial.", playername);
		return 1;
	}
	
	new totalRows = cache_num_rows();
	new beltStr[2048] = "{FF0000}[OFFLINE] {DBDBDB}Cinturón Policial de {2EA8E1}";
	strcat(beltStr, playername);
	strcat(beltStr, "\n\n");
	
	new itemFound = false;
	for(new i = 0; i < totalRows; i++)
	{
		new itemId, itemParam;
		cache_get_value_name_int(i, "Item", itemId);
		cache_get_value_name_int(i, "Param", itemParam);
		
		if(itemId > 0)
		{
			itemFound = true;
			new beltLn[128];
			format(beltLn, sizeof(beltLn), "{DBDBDB}[%d] {2EA8E1}%s {DBDBDB}- %s: {FFFFFF}%d\n", i + 1, ItemModel_GetName(itemId), ItemModel_GetParamName(itemId), itemParam);
			strcat(beltStr, beltLn);
		}
	}
	
	if(!itemFound)
		strcat(beltStr, "{DBDBDB}El cinturón está vacío.\n");
	
	Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "[CINTURÓN POLICIAL OFFLINE]", beltStr, "Cerrar", "");
	return 1;
}

CMD:up(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x, y, z + 2.0);
	return 1;
}

/*CMD:togglegooc(playerid, params[])
{
	new string[64];

	ToggleOOCStatus();
	if(IsOOCEnabled()) {
		format(string, sizeof(string), "[OOC Global] activado por %s.", GetPlayerCleanName(playerid));
	} else {
		format(string, sizeof(string), "[OOC Global] desactivado por %s.", GetPlayerCleanName(playerid));
	}
	SendClientMessageToAll(COLOR_ADMINCMD, string);
	return 1;
}*/

// CMD:anickname(playerid, params[])
// {
// 	new nickname[24], targetid, string[128];
// 
// 	if(sscanf(params, "us[24]", targetid, nickname))
// 	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/anickname [ID] [Apodo] - Máximo 24 carácteres");
// 
// 	new query[128];
// 	mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE accounts SET AdminNickName='%s' WHERE Id=%i", nickname, getPlayerMysqlId(targetid));
// 	mysql_tquery(MYSQL_HANDLE, query);
// 	format(string, sizeof(string), "[STAFF] El apodo de %s ha sido modificado a %s", GetPlayerCleanName(targetid), nickname);
// 	AdministratorMessage(COLOR_ADMINCMD, string, 2);
// 	PlayerInfo[targetid][aNick]=nickname;
// 	
// 	return 1;
// }

CMD:aservicio(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");
	
	if(AdminDuty[playerid])
	{
		AdminDuty[playerid] = false;
		SetPlayerHealthEx(playerid, GetPVarFloat(playerid, "tempHealth"));
		AdminDutyNickOff(playerid);
		SetPlayerHealthEx(playerid, 100);
		SetPlayerColor(playerid, 0xFFFFFF00);
		DeletePVar(playerid, "AdminPointStatus");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Dejas de estar de servicio como administrador.");
	}
	else if(PlayerInfo[playerid][pAdmin] == 1)
	{	
		format(AdminName_labelText[playerid], sizeof(AdminName_labelText), "Support (%s)", AccountInfo[playerid][accUsername]);
		AdminName_label[playerid] = CreateDynamic3DTextLabel(AdminName_labelText[playerid], 0x20989CFF, 0.0, 0.0, 0.30, .drawdistance = 30.0, .attachedplayer = playerid, .attachedvehicle = INVALID_VEHICLE_ID, .testlos = 1, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = 30.0);
		AdminDuty[playerid] = true;
		SetPlayerColor(playerid, COLOR_ADMINDUTY);
		SetPVarFloat(playerid, "tempHealth", GetPlayerHealthEx(playerid));
		SetPlayerHealthEx(playerid, 50000);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Estas en servicio como staff del servidor.");
	}
	else if(PlayerInfo[playerid][pAdmin] >= 2 && PlayerInfo[playerid][pAdmin] <= 5)
	{	
		format(AdminName_labelText[playerid], sizeof(AdminName_labelText), "Moderator (%s)", AccountInfo[playerid][accUsername]);
		AdminName_label[playerid] = CreateDynamic3DTextLabel(AdminName_labelText[playerid], 0x8E71A1FF, 0.0, 0.0, 0.30, .drawdistance = 30.0, .attachedplayer = playerid, .attachedvehicle = INVALID_VEHICLE_ID, .testlos = 1, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = 30.0);
		AdminDuty[playerid] = true;
		SetPlayerColor(playerid, COLOR_ADMINDUTY);
		SetPVarFloat(playerid, "tempHealth", GetPlayerHealthEx(playerid));
		SetPlayerHealthEx(playerid, 50000);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Estas en servicio como staff del servidor.");
	}
	else if(PlayerInfo[playerid][pAdmin] >= 6 && PlayerInfo[playerid][pAdmin] <= 9)
	{	
		format(AdminName_labelText[playerid], sizeof(AdminName_labelText), "Game Operator I (%s)", AccountInfo[playerid][accUsername]);
		AdminName_label[playerid] = CreateDynamic3DTextLabel(AdminName_labelText[playerid], 0x976B94FF, 0.0, 0.0, 0.30, .drawdistance = 30.0, .attachedplayer = playerid, .attachedvehicle = INVALID_VEHICLE_ID, .testlos = 1, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = 30.0);
		AdminDuty[playerid] = true;
		SetPlayerColor(playerid, COLOR_ADMINDUTY);
		SetPVarFloat(playerid, "tempHealth", GetPlayerHealthEx(playerid));
		SetPlayerHealthEx(playerid, 50000);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Estas en servicio como staff del servidor.");
	}
	else if(PlayerInfo[playerid][pAdmin] >= 10 && PlayerInfo[playerid][pAdmin] <= 13)
	{	
		format(AdminName_labelText[playerid], sizeof(AdminName_labelText), "Game Operator II (%s)", AccountInfo[playerid][accUsername]);
		AdminName_label[playerid] = CreateDynamic3DTextLabel(AdminName_labelText[playerid], 0x9C6686FF, 0.0, 0.0, 0.30, .drawdistance = 30.0, .attachedplayer = playerid, .attachedvehicle = INVALID_VEHICLE_ID, .testlos = 1, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = 30.0);
		AdminDuty[playerid] = true;
		SetPlayerColor(playerid, COLOR_ADMINDUTY);
		SetPVarFloat(playerid, "tempHealth", GetPlayerHealthEx(playerid));
		SetPlayerHealthEx(playerid, 50000);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Estas en servicio como staff del servidor.");
	}
	else if(PlayerInfo[playerid][pAdmin] >= 14 && PlayerInfo[playerid][pAdmin] <= 17)
	{	
		format(AdminName_labelText[playerid], sizeof(AdminName_labelText), "Senior Admin (%s)", AccountInfo[playerid][accUsername]);
		AdminName_label[playerid] = CreateDynamic3DTextLabel(AdminName_labelText[playerid], 0x9E6278FF, 0.0, 0.0, 0.30, .drawdistance = 30.0, .attachedplayer = playerid, .attachedvehicle = INVALID_VEHICLE_ID, .testlos = 1, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = 30.0);
		AdminDuty[playerid] = true;
		SetPlayerColor(playerid, COLOR_ADMINDUTY);
		SetPVarFloat(playerid, "tempHealth", GetPlayerHealthEx(playerid));
		SetPlayerHealthEx(playerid, 50000);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Estas en servicio como staff del servidor.");
	}
	else if(PlayerInfo[playerid][pAdmin] == 19)
	{	
		format(AdminName_labelText[playerid], sizeof(AdminName_labelText), "Lead Admin (%s)", AccountInfo[playerid][accUsername]);
		AdminName_label[playerid] = CreateDynamic3DTextLabel(AdminName_labelText[playerid], 0x9D606AFF, 0.0, 0.0, 0.30, .drawdistance = 30.0, .attachedplayer = playerid, .attachedvehicle = INVALID_VEHICLE_ID, .testlos = 1, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = 30.0);
		AdminDuty[playerid] = true;
		SetPlayerColor(playerid, COLOR_ADMINDUTY);
		SetPVarFloat(playerid, "tempHealth", GetPlayerHealthEx(playerid));
		SetPlayerHealthEx(playerid, 50000);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Estas en servicio como staff del servidor.");
	}
	else if(PlayerInfo[playerid][pAdmin] == 20)
	{	
		format(AdminName_labelText[playerid], sizeof(AdminName_labelText), "Development (%s)", AccountInfo[playerid][accUsername]);
		AdminName_label[playerid] = CreateDynamic3DTextLabel(AdminName_labelText[playerid], 0xAB6361FF, 0.0, 0.0, 0.30, .drawdistance = 30.0, .attachedplayer = playerid, .attachedvehicle = INVALID_VEHICLE_ID, .testlos = 1, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = 30.0);
		AdminDuty[playerid] = true;
		SetPlayerColor(playerid, COLOR_ADMINDUTY);
		SetPVarFloat(playerid, "tempHealth", GetPlayerHealthEx(playerid));
		SetPlayerHealthEx(playerid, 50000);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Estas en servicio como staff del servidor.");
	}
	else if(PlayerInfo[playerid][pAdmin] == 21)
	{	
		format(AdminName_labelText[playerid], sizeof(AdminName_labelText), "Management (%s)", AccountInfo[playerid][accUsername]);
		AdminName_label[playerid] = CreateDynamic3DTextLabel(AdminName_labelText[playerid], 0x733B3AFF, 0.0, 0.0, 0.30, .drawdistance = 30.0, .attachedplayer = playerid, .attachedvehicle = INVALID_VEHICLE_ID, .testlos = 1, .worldid = -1, .interiorid = -1, .playerid = -1, .streamdistance = 30.0);
		AdminDuty[playerid] = true;
		SetPlayerColor(playerid, COLOR_ADMINDUTY);
		SetPVarFloat(playerid, "tempHealth", GetPlayerHealthEx(playerid));
		SetPlayerHealthEx(playerid, 50000);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Estas en servicio como staff del servidor.");
	}
	

	return 1;
}

CMD:acpoint(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	if(AdminDuty[playerid] != true)
	{
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar de servicio como administrador para usar este comando.");
	}
	
	new status = GetPVarInt(playerid, "AdminPointStatus");
	
	if(status == 0)
	{
		SetPlayerColor(playerid, COLOR_ADMINDUTY);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Ahora apareces en el mapa con el color de administrador.");
		SetPVarInt(playerid, "AdminPointStatus", 1);
	}
	else
	{
		SetPlayerColor(playerid, 0xFFFFFF00);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Se ha quitado tu color administrativo del mapa.");
		SetPVarInt(playerid, "AdminPointStatus", 0);
	}
	return 1;
}

AdminDutyNickOff(playerid)
{
	SetPlayerChatName(playerid, GetPlayerCleanName(playerid));
	DestroyDynamic3DTextLabel(AdminName_label[playerid]);
	AdminName_label[playerid] = STREAMER_TAG_3D_TEXT_LABEL:0;
	return 1;
}

CMD:ckearplayer(playerid,params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 8)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator II o superior para usar este comando.");

	new targetid, string[128], newname[24],	newage, newsex, newmoney;

    if(sscanf(params, "us[24]ii", targetid, newname, newage, newsex)) {
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/ckearplayer [ID/Jugador] [Nuevo nombre] [Nueva edad] [Nuevo sexo (0 = Femenino | 1 = Masculino)]");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El comando solicitará una confirmación tras completar los parámetros.");
		return 1;
	}
   	if(!IsPlayerLogged(targetid))
   	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(newsex < 0 || newsex > 1)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Elige un sexo válido (0 = Femenino | 1 = Masculino)!");
	if(newage < 1 || newage > 100)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Sólo se permite una edad de 1 a 100 años!");
	if(!IsNameRoleplayValid(newname))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nombre inválido. Debe seguir el formato esperado para un roleplay. Ej: Roberto_Martinez.");

	if(GetPVarInt(playerid, "ckeandoplayer") == 0)
	{
		SendFMessage(playerid, COLOR_INFO, 		"=============="COLOR_EMB_GREY" CKear al jugador %s {878EE7}==============", GetPlayerCleanName(targetid));
		SendFMessage(playerid, COLOR_INFO, 		"Nuevo nombre:{C8C8C8} %s {f5a120}| {878EE7}Nueva edad:{C8C8C8} %d {f5a120}| {878EE7}Nuevo sexo:{C8C8C8} %d.", newname, newage, newsex);
		SendClientMessage(playerid, COLOR_INFO, "[INFO]{C8C8C8} Para realizar el CK, vuelve a ingresar el comando con los mismos parámetros.");
		SendFMessage(playerid, COLOR_INFO, 		"[INFO]{C8C8C8} Para {f5a120}cancelarlo{C8C8C8}, relogea o utiliza el comando {f5a120} /setpvarint %d ckeandoplayer 0 {C8C8C8}.", playerid);
		SendClientMessage(playerid, COLOR_INFO, "============================================================");
		SetPVarInt(playerid, "ckeandoplayer", PlayerInfo[targetid][pID]);
		return 1;
	}

	if(GetPVarInt(playerid, "ckeandoplayer") == PlayerInfo[targetid][pID])
	{
		KeyChain_OnPlayerCharacterKill(targetid, .notifyid = playerid);
		Phone_DeletePhoneForPlayer(targetid);

		GivePlayerCash(targetid, PlayerInfo[targetid][pBank]);
		PlayerInfo[targetid][pBank] = 0;

		Faction_SetPlayer(targetid, 0, 0);

		SavePlayerJobData(targetid, 1, 1);
		ResetJobVariables(targetid);
		SetPlayerJob(targetid, 0);
		ResetThiefVariables(targetid);

		SetHandItemAndParam(targetid, HAND_RIGHT, 0, 0);
		SetHandItemAndParam(targetid, HAND_LEFT, 0, 0);
		Back_SetItemAndParam(playerid, 0, 0, 0);
		Container_Empty(PlayerInfo[targetid][pContainerID]);

		PlayerInfo[targetid][pJailed] = JAIL_NONE;
		PlayerInfo[targetid][pJailTime] = 0;
		ResetPlayerWantedLevelEx(targetid);
		
 		PlayerInfo[targetid][pFlyLic] = 0;
 		PlayerInfo[targetid][pCarLic] = 0;
		PlayerInfo[targetid][pWepLic] = 0;

		newmoney = floatround(GetPlayerCash(targetid)*CK_MONEY_RATIO, floatround_ceil);
    	PlayerInfo[targetid][pBank] = newmoney;
    	SetPlayerCash(targetid, 0);

		format(string, sizeof(string), "[STAFF] el administrador %s ha CKeado a %s. (Nuevo nombre: %s)", GetPlayerCleanName(playerid), GetPlayerCleanName(targetid), newname);
		AdministratorMessage(COLOR_ADMINCMD, string, 2);
		SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El administrador %s ha CKeado tu cuenta. Tu nuevo nombre es %s.", GetPlayerCleanName(playerid), newname);
		SendClientMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" Se vendieron automaticamente todos tus bienes económicos (casa, negocio, autos).");
		SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tu nuevo balance bancario es de $%d (85 por ciento de todo tu patrimonio anterior).", newmoney);

		SetPlayerName(targetid, newname);
    	PlayerInfo[targetid][pSex] = newsex;
    	PlayerInfo[targetid][pAge] = newage;

    	SetPVarInt(playerid, "ckeandoplayer", 0);
    	return 1;
	}
	return 1;
}

stock GetAdminRankName(adminlevel)
{
	new rankname[32];
	if(adminlevel == 1) rankname = "Support";
	else if(adminlevel >= 2 && adminlevel <= 5) rankname = "Moderator";
	else if(adminlevel >= 6 && adminlevel <= 9) rankname = "Game Operator I";
	else if(adminlevel >= 10 && adminlevel <= 13) rankname = "Game Operator II";
	else if(adminlevel >= 14 && adminlevel <= 17) rankname = "Senior Admin";
	else if(adminlevel == 19) rankname = "Lead Admin";
	else if(adminlevel == 20) rankname = "Development";
	else if(adminlevel == 21) rankname = "Management";
	return rankname;
}

stock GetAdminRankColor(adminlevel, color[])
{
	if(adminlevel == 1) format(color, 16, "20989C");
	else if(adminlevel >= 2 && adminlevel <= 5) format(color, 16, "8E71A1");
	else if(adminlevel >= 6 && adminlevel <= 9) format(color, 16, "976B94");
	else if(adminlevel >= 10 && adminlevel <= 13) format(color, 16, "9C6686");
	else if(adminlevel >= 14 && adminlevel <= 17) format(color, 16, "9E6278");
	else if(adminlevel == 19) format(color, 16, "9D606A");
	else if(adminlevel == 20) format(color, 16, "AB6361");
	else if(adminlevel == 21) format(color, 16, "733B3A");
	else format(color, 16, "FFFFFF");
	return 1;
}

CMD:staff(playerid, params[]) {
	return cmd_admins(playerid, params);
}

CMD:invisible(playerid, params[])
{
	// Verificar si es Senior Admin o superior (nivel 14+)
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser Senior Admin o superior para usar este comando.");
	
	new string[256];
	
	if(AdminInvisible[playerid])
	{
		AdminInvisible[playerid] = false;
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Ahora estás {369919}visible{D6D6D6} en la lista de staff.");
		
		// Mensaje para el staff
		format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] se encuentra visible nuevamente.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
		AdministratorMessage(COLOR_ADMINCMD, string, 2);
	}
	else
	{
		AdminInvisible[playerid] = true;
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Ahora estás {991919}invisible{D6D6D6} en la lista de staff.");
		
		// Mensaje para el staff
		format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] se ha colocado en modo invisible.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
		AdministratorMessage(COLOR_ADMINCMD, string, 2);
	}
	return 1;
}

CMD:admins(playerid, params[])
{
	new AdminCount = 0;
	new bool:canSeeInvisible = (PlayerInfo[playerid][pAdmin] >= 14); // Senior Admin o superior pueden ver invisibles

	
	foreach(new id : Player) {
		if(PlayerInfo[id][pAdmin] > 0 && PlayerInfo[id][pAdmin] < 22) {
			// Si el admin está invisible y el que ejecuta el comando no puede verlo, saltar
			if(AdminInvisible[id] && !canSeeInvisible)
				continue;

			if(AdminCount == 0 && PlayerInfo[playerid][pAdmin] < 1){
				SendClientMessage(playerid, COLOR_INFO, "====================[Miembros del STAFF en línea]====================");
			}
			else if(AdminCount == 0){
				SendClientMessage(playerid, COLOR_INFO, "====================[Miembros del STAFF en línea]====================");
			}

			new dutyStatus[64], visibilityStatus[32];
			format(dutyStatus, sizeof(dutyStatus), "%s", AdminDuty[id] ? "{369919}Disponible" : "{991919}No disponible");
			
			// Solo mostrar estado de visibilidad para Senior Admin o superior
			if(canSeeInvisible) {
				format(visibilityStatus, sizeof(visibilityStatus), " (%s)", AdminInvisible[id] ? "{991919}Invisible" : "{369919}Visible");
			} else {
				visibilityStatus[0] = '\0';
			}

			if(PlayerInfo[id][pAdmin] == 1){
				SendFMessage(playerid, COLOR_INFO, "{20989C}[Support]{D6D6D6} %s (%s) [ID: %i] - %s%s{D6D6D6}.", GetPlayerCleanName(id), AccountInfo[id][accUsername], id, dutyStatus, visibilityStatus);
			}
			else if(PlayerInfo[id][pAdmin] >= 2 && PlayerInfo[id][pAdmin] <= 5){
				SendFMessage(playerid, COLOR_INFO, "{8E71A1}[Moderator]{D6D6D6} %s (%s) [ID: %i] - %s%s{D6D6D6}.", GetPlayerCleanName(id), AccountInfo[id][accUsername], id, dutyStatus, visibilityStatus);
			}
			else if(PlayerInfo[id][pAdmin] >= 6 && PlayerInfo[id][pAdmin] <= 9){
				SendFMessage(playerid, COLOR_INFO, "{976B94}[Game Operator I]{D6D6D6} %s (%s) [ID: %i] - %s%s{D6D6D6}.", GetPlayerCleanName(id), AccountInfo[id][accUsername], id, dutyStatus, visibilityStatus);
			}
			else if(PlayerInfo[id][pAdmin] >= 10 && PlayerInfo[id][pAdmin] <= 13){
				SendFMessage(playerid, COLOR_INFO, "{9C6686}[Game Operator II]{D6D6D6} %s (%s) [ID: %i] - %s%s{D6D6D6}.", GetPlayerCleanName(id), AccountInfo[id][accUsername], id, dutyStatus, visibilityStatus);
			}
			else if(PlayerInfo[id][pAdmin] >= 14 && PlayerInfo[id][pAdmin] <= 17){
				SendFMessage(playerid, COLOR_INFO, "{9E6278}[Senior Admin]{D6D6D6} %s (%s) [ID: %i] - %s%s{D6D6D6}.", GetPlayerCleanName(id), AccountInfo[id][accUsername], id, dutyStatus, visibilityStatus);
			}
			else if(PlayerInfo[id][pAdmin] == 19){
				SendFMessage(playerid, COLOR_INFO, "{9D606A}[Lead Admin]{D6D6D6} %s (%s) [ID: %i] - %s%s{D6D6D6}.", GetPlayerCleanName(id), AccountInfo[id][accUsername], id, dutyStatus, visibilityStatus);
			}
			else if(PlayerInfo[id][pAdmin] == 20){
				SendFMessage(playerid, COLOR_INFO, "{AB6361}[Development]{D6D6D6} %s (%s) [ID: %i] - %s%s{D6D6D6}.", GetPlayerCleanName(id), AccountInfo[id][accUsername], id, dutyStatus, visibilityStatus);
			}
			else if(PlayerInfo[id][pAdmin] == 21){
				SendFMessage(playerid, COLOR_INFO, "{733B3A}[Management]{D6D6D6} %s (%s) [ID: %i] - %s%s{D6D6D6}.", GetPlayerCleanName(id), AccountInfo[id][accUsername], id, dutyStatus, visibilityStatus);
			}
			AdminCount++;
		}
	}
	if (AdminCount == 0)
		return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No hay miembros del Staff Team conectados en este momento.");
	else {
		SendClientMessage(playerid, COLOR_INFO, "====================================================================");
	}
	return 1;
}

CMD:mute(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

	new targetid, string[128];

    if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mute [ID/Jugador]");
    if(!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID inválida.");

	if(Muted[targetid] == 0) 
	{
		Muted[targetid] = 1;
		format(string, sizeof(string), "[STAFF] El administrador %s (%s) [ID: %d] ha muteado a %s.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid));
		AdministratorMessage(COLOR_ADMINCMD, string, 2);
		SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has sido muteado por %s (%s) [ID: %d].", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
	} 
	else 
	{
		Muted[targetid] = 0;
		format(string, sizeof(string), "[STAFF] El administrador %s (%s) [ID: %d] ha desmuteado a %s.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid));
		AdministratorMessage(COLOR_ADMINCMD, string, 2);
		SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has sido desmuteado por %s (%s) [ID: %d].", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
	}
	return 1;
}

CMD:muteb(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

	new string[128],
 		minutes,
		targetid;

	if(sscanf(params, "ui", targetid, minutes))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/muteb [ID/Jugador] [minutos]");
	if(!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID inválida.");
	if(minutes >= 30 || minutes < 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes mutear por menos de 0 minutos o más de 30.");
		
	if(minutes > 0)	
	{
		SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tu canal '/b' ha sido muteado por %s (%s) [ID: %d] durante %d minutos.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, minutes);
		format(string, sizeof(string), "[STAFF] el administrador %s (%s) [ID: %d] ha muteado el canal '/b' de %s por %d minutos.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid), minutes);
		AdministratorMessage(COLOR_ADMINCMD, string, 2);
		PlayerInfo[targetid][pMuteB] = 60 * minutes;
	} 
	else 
	{
		SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tu canal '/b' ha sido desmuteado por %s (%s) [ID: %d].", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
		format(string, sizeof(string), "[STAFF] el administrador %s (%s) [ID: %d] ha desmuteado el canal '/b' de %s.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid));
		AdministratorMessage(COLOR_ADMINCMD, string, 2);
		PlayerInfo[targetid][pMuteB] = 0;
	} 
	return 1;
}


CMD:muteartw(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 3)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tenes permiso para usar este comando.");

	new targetid, minutes, motivo[80];
	if(sscanf(params, "uis[80]", targetid, minutes, motivo))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/muteartw [ID] [minutos (0=indefinido)] [motivo]");
	if(!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID invalida.");
	if(minutes < 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Los minutos no pueden ser negativos.");

	PlayerInfo[targetid][pMuteTW] = (minutes == 0) ? -1 : (minutes * 60);
	PlayerInfo[targetid][pMuteTWReason][0] = EOS;
	strcat(PlayerInfo[targetid][pMuteTWReason], motivo, 80);

	new string[256];
	if(minutes == 0)
	{
		SendFMessage(targetid, COLOR_ERROR, "[MUTE] Fuiste muteado de Twitter indefinidamente. Motivo: %s", motivo);
		format(string, sizeof(string), "[STAFF] %s muteo de Twitter a %s indefinidamente. Motivo: %s", GetPlayerCleanName(playerid), GetPlayerCleanName(targetid), motivo);
	}
	else
	{
		SendFMessage(targetid, COLOR_ERROR, "[MUTE] Fuiste muteado de Twitter por %d minuto(s). Motivo: %s", minutes, motivo);
		format(string, sizeof(string), "[STAFF] %s muteo de Twitter a %s por %d minutos. Motivo: %s", GetPlayerCleanName(playerid), GetPlayerCleanName(targetid), minutes, motivo);
	}
	AdministratorMessage(COLOR_ADMINCMD, string, 3);
	return 1;
}

CMD:desmuteartw(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 3)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tenes permiso para usar este comando.");

	new targetid;
	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/desmuteartw [ID]");
	if(!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID invalida.");
	if(PlayerInfo[targetid][pMuteTW] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no esta muteado de Twitter.");

	PlayerInfo[targetid][pMuteTW] = 0;
	PlayerInfo[targetid][pMuteTWReason][0] = EOS;

	SendClientMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tu mute de Twitter fue levantado.");

	new string[128];
	format(string, sizeof(string), "[STAFF] %s desmuteo de Twitter a %s.", GetPlayerCleanName(playerid), GetPlayerCleanName(targetid));
	AdministratorMessage(COLOR_ADMINCMD, string, 3);
	return 1;
}
CMD:setplayerlic(playerid, params[])
{
	new string[128],
		lic,
		targetid;
	if(sscanf(params, "ui", targetid, lic))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/setplayerlic [ID Jugador] [tipo de Licencia - 1 auto | 2 armas | 3 vuelo]");
	if(!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID inválida.");
	
	switch(lic)
	{
		case 1:
		{
			if(PlayerInfo[targetid][pCarLic] == 0)
			{
				PlayerInfo[targetid][pCarLic] = 1;
				SaveAccount(targetid);
				format(string, sizeof(string), "[STAFF] El administrador %s (%s) [ID: %d] ha otorgado la licencia de conducir a %s.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid));
				AdministratorMessage(COLOR_ADMINCMD, string, 2);
				SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has recibido la licencia de conducir por %s (%s) [ID: %d].", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
			}
			else
			{
				SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El jugador %s ya posee la licencia de conducir.", GetPlayerCleanName(targetid));
			}
		}
		case 2:
		{
			if(PlayerInfo[targetid][pWepLic] == 0)
			{
				PlayerInfo[targetid][pWepLic] = 1;
				SaveAccount(targetid);
				format(string, sizeof(string), "[STAFF] El administrador %s (%s) [ID: %d]  ha otorgado la licencia de armas a %s.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid));
				AdministratorMessage(COLOR_ADMINCMD, string, 2);
				SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has recibido la licencia de armas por %s (%s) [ID: %d].", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
			}
			else
			{
				SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El jugador %s ya posee la licencia de armas.", GetPlayerCleanName(targetid));
			}
		}
		case 3:
		{
			if(PlayerInfo[targetid][pFlyLic] == 0)
			{
				PlayerInfo[targetid][pFlyLic] = 1;
				SaveAccount(targetid);
				format(string, sizeof(string), "[STAFF] El administrador %s (%s) [ID: %d]  ha otorgado la licencia de vuelo a %s.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid));
				AdministratorMessage(COLOR_ADMINCMD, string, 2);
				SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has recibido la licencia de navegación por %s (%s) [ID: %d].", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
			}
			else
			{
				SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El jugador %s ya posee la licencia de vuelo.", GetPlayerCleanName(targetid));
			}	
		}
		default:
		{
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tipo de licencia inválido. Usa: 1 (auto), 2 (armas) o 3 (vuelo).");
		}
	}
	return 1;
}

CMD:nref(playerid, params[]){
	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");

	new targetid;

	if(sscanf(params, "u", targetid))
    	return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/nref [ID/Nombre]");
    if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, -1, "¡No se ha encontrado al jugador!");
	
	SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El administrador %s (%s) [ID: %d] ha rellenado las necesidades de tu personaje.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has rellenado las necesidades del jugador %s (ID: %d).", GetPlayerCleanName(targetid), targetid);
	BN_PlayerRefill(targetid);
	return 1;
}



public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(PlayerInfo[playerid][pAdmin] >= 2 && AdminDuty[playerid])
	{
		SetPlayerPosFindZ(playerid, fX, fY, fZ + 0.5);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
	}

	return 1;
}

CMD:nuevos(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");

	new count = 0;
	new string[256];
	new hours;
	new bool:isModerator = (PlayerInfo[playerid][pAdmin] >= 2);

	// Iterar por todos los jugadores conectados
	foreach(new id : Player) {
		// Solo mostrar jugadores de nivel 1
		if(PlayerInfo[id][pLevel] == 1) {
			// Mostrar header solo si es el primer jugador encontrado
			if(count == 0) {
				SendClientMessage(playerid, COLOR_INFO, "=====================[Lista de nuevos usuarios]====================");
			}
			
			hours = PlayerInfo[id][pTimePlayed] / 3600;
			
			if(isModerator) {
				// Mostrar con IP para moderadores y superiores
				format(string, sizeof(string), "%s (%s) [ID: %d] - Horas: %d - IP: %s",
					GetPlayerCleanName(id),
					AccountInfo[id][accUsername],
					id,
					hours,
					PlayerInfo[id][pIP]
				);
			} else {
				// Sin IP para soportes
				format(string, sizeof(string), "%s (%s) [ID: %d] - Horas: %d",
					GetPlayerCleanName(id),
					AccountInfo[id][accUsername],
					id,
					hours
				);
			}
			
			SendClientMessage(playerid, COLOR_WHITE, string);
			count++;
		}
	}

	// Mostrar footer solo si se encontraron jugadores
	if(count > 0) {
		SendClientMessage(playerid, COLOR_INFO, "===================================================================");
	}
	
	// Siempre mostrar el contador
	format(string, sizeof(string), "[INFO] Se encontraron %d jugadores nuevos (nivel 1) conectados.", count);
	SendClientMessage(playerid, COLOR_INFO, string);

	return 1;
}

// ==================== COMANDOS IMPORTADOS DESDE BARP ====================

CMD:aliberar(playerid, params[])
{
	new targetid;

	if(AccountInfo[playerid][accAdminLevel] < 2)
		return SendClientMessage (playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Moderator o superior para usar este comando.");
	if(sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, -1, "USO: /aliberar [ID/Nombre]");
	if(!IsPlayerLogged(targetid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(PlayerInfo[targetid][pJailed] == 0)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este jugador no se encuentra sancionado.");
	
	PlayerInfo[targetid][pJailed] = 0;
	PlayerInfo[targetid][pJailTime] = 0;
	SetPlayerHealthEx(playerid, 100.0);
	SetPlayerColor(playerid, 0xFFFFFF00);
	TeleportPlayerTo(playerid, 1543.1399, -1675.5385, 13.5559, 90.2279, 0, 0, .forceLoadingTime = false, .syncPlayerNewPosData = true, .disableSyncOnExitSeconds = 0);
	SendFMessageToAll(COLOR_RED, "[STAFF]{FFFFFF} %s ha sido liberado de su sanción por %s.", GetPlayerCleanName(targetid), AccountInfo[playerid][accUsername]);
	SendClientMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Un administrador te ha liberado de tu condena.");
	return 1;
}

/*
// SISTEMA ANTIGUO - COMENTADO
CMD:rechazarduda(playerid, params[]) {
	new targetid, str[256];

	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage (playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");
	if(sscanf(params, "us[256]", targetid))
        return SendClientMessage(playerid, COLOR_GREY, "USO: /rechazarduda [ID/Nombre]");
	if(targetid == INVALID_PLAYER_ID)
	    return true;
	if(PlayerInfo[targetid][pHaveQuestion] == 0)
		return SendClientMessage (playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El usuario no tiene ninguna duda actualmente.");
	
	SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El administrador %s rechazó tu duda.", AccountInfo[playerid][accUsername]);
	
	format(str, sizeof(str), "[INFO] "COLOR_EMB_GREY"%s rechazó la duda de %s (ID: %d).", AccountInfo[playerid][accUsername], GetPlayerCleanName(targetid), targetid);
	AdministratorMessage(COLOR_INFO, str, 1);

	PlayerInfo[targetid][pQuestion][0] = EOS;
	PlayerInfo[targetid][pHaveQuestion] = 0;
	return true;
}
*/

CMD:adarlicencia(playerid, params[]) {
	new type, targetid, string[128];
	
	if(AccountInfo[playerid][accAdminLevel] < 5)
		return SendClientMessage (playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");
	if(sscanf(params, "ui", targetid, type))
	    return SendClientMessage(playerid, COLOR_GREY, "USO: /adarlicencia [ID/Nombre] [licencia: 1- armas | 2- conducir | 3- vuelo]");
	if(type < 1 || type > 3)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tipo de licencia inválido.");
	if(!IsPlayerLogged(targetid))
	    return SendClientMessage(playerid, -1, "¡No se ha encontrado al jugador!");

	switch(type)
	{
		case 1:
		{
			if(PlayerInfo[targetid][pWepLic] == 1)
			    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este usuario ya posee licencia de armas. Utiliza /aquitarlicencia para eliminarla.");
			PlayerInfo[targetid][pWepLic] = 1;
			SendClientMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Un administrador te ha dado una licencia de armas.");
			format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] dió una licencia de armas a %s", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid));
			AdministratorMessage(COLOR_ADMINCMD, string, 2);
		}
		case 2:
		{
			if(PlayerInfo[targetid][pCarLic] == 1)
			    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este usuario ya posee licencia de conducir. Utiliza /aquitarlicencia para eliminarla.");
			PlayerInfo[targetid][pCarLic] = 1;
			SendClientMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Un administrador te ha dado una licencia de conducir.");
			format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] dió una licencia de conducir a %s", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid));
			AdministratorMessage(COLOR_ADMINCMD, string, 2);
		}
		case 3:
		{
			if(PlayerInfo[targetid][pFlyLic] == 1)
			    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este usuario ya posee licencia de vuelo. Utiliza /aquitarlicencia para eliminarla.");
			PlayerInfo[targetid][pFlyLic] = 1;
			SendClientMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Un administrador te ha dado una licencia de vuelo.");
			format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] dió una licencia de vuelo a %s", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid));
			AdministratorMessage(COLOR_ADMINCMD, string, 2);
		}
	}
	return true;
}

CMD:aquitarlicencia(playerid, params[]) {
	new type, targetid, string[128];
	
	if(AccountInfo[playerid][accAdminLevel] < 6)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Game Operator I o superior para usar este comando.");
	if(sscanf(params, "ui", targetid, type))
	    return SendClientMessage(playerid, COLOR_GREY, "USO: /aquitarlicencia [ID/Nombre] [licencia: 1- armas | 2- conducir | 3- vuelo]");
	if(type < 1 || type > 3)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tipo de licencia inválido.");
	if(!IsPlayerLogged(targetid))
	    return SendClientMessage(playerid, -1, "¡No se ha encontrado al jugador!");

	switch(type)
	{
		case 1:
		{
			if(PlayerInfo[targetid][pWepLic] == 0)
			    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este usuario no posee licencia de armas.");
			PlayerInfo[targetid][pWepLic] = 0;
			SendClientMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Un administrador te ha quitado tu licencia de armas.");
			format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] removió licencia de armas a %s", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid));
			AdministratorMessage(COLOR_ADMINCMD, string, 2);
		}
		case 2:
		{
			if(PlayerInfo[targetid][pCarLic] == 0)
			    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este usuario no posee licencia de conducir.");
			PlayerInfo[targetid][pCarLic] = 0;
			SendClientMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Un administrador te ha quitado tu licencia de conducir.");
			format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] removió licencia de conducir a %s", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid));
			AdministratorMessage(COLOR_ADMINCMD, string, 2);
		}
		case 3:
		{
			if(PlayerInfo[targetid][pFlyLic] == 0)
			    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este usuario no posee licencia de vuelo.");
			PlayerInfo[targetid][pFlyLic] = 0;
			SendClientMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Un administrador te ha quitado tu licencia de vuelo.");
			format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] removió licencia de vuelo a %s", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, GetPlayerCleanName(targetid));
			AdministratorMessage(COLOR_ADMINCMD, string, 2);
		}
	}
	return true;
}

CMD:aexpdoble(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 4)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes permiso para utilizar este comando.");
	
	new currentTime = gettime();
	
	// Si ya está activo, desactivarlo
	if(DoubleExpActive)
	{
		DoubleExpActive = false;
		DoubleExpEndTime = 0;
		
		// Resetear la marca de todos los jugadores
		foreach(new i : Player)
		{
			PlayerHasDoubleExp[i] = false;
		}
		
		new string[256];
		format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] ha DESACTIVADO el evento de experiencia doble.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
		AdministratorMessage(COLOR_ADMINCMD, string, 1);
		
		SendClientMessageToAll(COLOR_LIGHTYELLOW2, "[EVENTO] "COLOR_EMB_GREY"El evento de experiencia doble ha finalizado.");
		return true;
	}
	
	// Verificar cooldown de 1 hora
	if(DoubleExpEndTime > currentTime)
	{
		new remainingTime = DoubleExpEndTime - currentTime;
		new minutes = remainingTime / 60;
		if(minutes < 1) minutes = 1;
		
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar %d minuto(s) antes de activar nuevamente el evento.", minutes);
		return true;
	}
	
	// Activar experiencia doble
	DoubleExpActive = true;
	DoubleExpEndTime = currentTime + 3600; // 1 hora de cooldown
	
	// Marcar a todos los jugadores conectados actualmente
	foreach(new i : Player)
	{
		if(IsPlayerLogged(i))
		{
			PlayerHasDoubleExp[i] = true;
		}
	}
	
	new string[256];
	format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] ha ACTIVADO el evento de experiencia doble para los jugadores en línea.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
	AdministratorMessage(COLOR_ADMINCMD, string, 1);
	
	SendClientMessageToAll(COLOR_LIGHTYELLOW2, "[EVENTO] "COLOR_EMB_GREY"¡Se ha activado experiencia doble! Sueldo, beneficios y experiencia x2 en el próximo payday.");
	SendClientMessageToAll(COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Solo los jugadores conectados en este momento recibirán el beneficio.");
	
	return true;
}