#if defined _marp_factions_admin_included
	#endinput
#endif
#define _marp_factions_admin_included

static enum e_FACTIONS_TAGS_DATA {
	e_FACTIONS_TAGS:fac_flag,
	fac_name[32]
}

static const FACTIONS_TAGS_DATA[][e_FACTIONS_TAGS_DATA] = {
	{FAC_TAG_EQUIPMENT, "Usar /equipar"},
	{FAC_TAG_DRUG_TRAFFIC, "Trafico de drogas"},
	{FAC_TAG_WEAPON_TRAFFIC, "Trafico de armas"},
    {FAC_TAG_ILLEGAL_MISSIONS, "Permite misiones ilegales"},
	{FAC_TAG_ALLOW_JOB, "Permite trabajo"},
	{FAC_TAG_GOB_TYPE, "Pertenece al gobierno"},
    {FAC_TAG_ALLOW_GRAFITI, "Puede hacer grafitis"}
};

// Función auxiliar para verificar acceso básico a Faction Control
static stock HasBasicFactionControlAccess(playerid)
{
	new level = AccountInfo[playerid][accAdminLevel];
	return (level == 3 || level == 5 || level == 7 || level == 9 || level == 11 || level == 13 || level == 15 || level == 17 || level == 19 || level == 20 || level == 21);
}

// Función auxiliar para verificar acceso avanzado a Faction Control
static stock HasAdvancedFactionControlAccess(playerid)
{
	new level = AccountInfo[playerid][accAdminLevel];
	return (level == 15 || level == 17 || level == 19 || level == 20 || level == 21);
}

CMD:afcmds(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Faction Control
	if(!HasBasicFactionControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Faction Control para utilizar este comando.");
	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "_____________________________________[ ADMINISTRACION DE FACCIONES ]______________________________________");
	SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" (/af)acciones - /afdarlider - /afexpulsar - /afvehiculos");
	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "__________________________________________________________________________________________________________");
	return 1;
}

CMD:afdarlider(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Faction Control
	if(!HasBasicFactionControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Faction Control para utilizar este comando.");
	
	new targetid, factionid, string[128];

	if(sscanf(params, "ud", targetid, factionid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/afdarlider [ID/Jugador] [IDfacción]");
    if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"jugador inválido.");

	if(!Faction_SetPlayer(targetid, factionid, 1))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Id de faccion inválida.");

    format(string, sizeof(string), "[STAFF] El administrador %s hizo a %s lider de la facción ID: %d (%s).", GetPlayerCleanName(playerid), GetPlayerCleanName(targetid), factionid, FactionInfo[factionid][fName]);
	AdministratorMessage(COLOR_ADMINCMD, string, 2);
	SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"el administrador %s te ha hecho líder de la facción %s.", GetPlayerCleanName(playerid), FactionInfo[factionid][fName]);
	return 1;
}

CMD:afexpulsar(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Faction Control
	if(!HasBasicFactionControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Faction Control para utilizar este comando.");
	
	new reason[64], string[128], targetid;

	if(sscanf(params, "uS(sin razon)[64]", targetid, reason))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"[ID/Jugador] [razón]");
	if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"jugador inválido.");

    new factionid = PlayerInfo[playerid][pFaction];

	format(string, sizeof(string), "[STAFF] El administrador %s expulso a %s de la facción ID: %d (%s). razón: %s.", GetPlayerCleanName(playerid), GetPlayerCleanName(targetid), factionid, FactionInfo[factionid][fName], reason);
	AdministratorMessage(COLOR_ADMINCMD, string, 2);
	SendFMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"el administrador %s te ha expulso de tu faccion. razón: %s", GetPlayerCleanName(playerid), FactionInfo[factionid][fName], reason);
	Faction_SetPlayer(targetid, 0, 0);
	return 1;
}

CMD:afvehiculos(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Faction Control
	if(!HasBasicFactionControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Faction Control para utilizar este comando.");
	
	new factionid;

	if(sscanf(params, "i", factionid))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/afvehiculos [idfacción]");
    if(!Faction_IsValidId(factionid))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de facción incorrecta.");
    
    Faction_ShowVehicles(factionid, playerid);
	return 1;
}

static af_dlg_str[1024], af_line_str[128], af_fac_selection[MAX_PLAYERS], af_field_selection[MAX_PLAYERS];

CMD:afacciones(playerid, params[]){
	return cmd_af(playerid, params);
}

CMD:af(playerid, params[])
{
	// Verificar si es administrador
	if(AccountInfo[playerid][accAdminLevel] == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes acceso a este comando.");
	
	// Verificar si tiene acceso a Faction Control
	if(!HasBasicFactionControlAccess(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Necesitas variables de Faction Control para utilizar este comando.");
	
	new factionid;

	if(!sscanf(params, "i", factionid))
	{
		if(!Faction_Manage(playerid, factionid))
			return SendClientMessage(playerid, COLOR_INFO, "[USO] "COLOR_EMB_GREY" /af [idfacción] (opcional)");
	}
	else
	{
		af_dlg_str = "Id\tNombre\n";

		for(new i = 1, size = sizeof(FactionInfo); i < size; i++)
		{
			format(af_line_str, sizeof(af_line_str), "%i\t%s\n", i, FactionInfo[i][fName]);
			strcat(af_dlg_str, af_line_str, sizeof(af_dlg_str));
		}	

		Dialog_Show(playerid, DLG_ADM_ALL_FACTIONS, DIALOG_STYLE_TABLIST_HEADERS, "administración de facciones", af_dlg_str, "Aceptar", "Cerrar");
	}
	return 1;
}

Dialog:DLG_ADM_ALL_FACTIONS(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;

	Faction_Manage(playerid, listitem + 1);
	return 1;
}

Faction_Manage(playerid, factionid)
{
	if(!Faction_IsValidId(factionid))
		return 0;

	af_fac_selection[playerid] = factionid;
	af_dlg_str = "Campo\tValor\n";

	format(af_line_str, sizeof(af_line_str), "Nombre\t%s\n", FactionInfo[factionid][fName]);
	strcat(af_dlg_str, af_line_str, sizeof(af_dlg_str));

	format(af_line_str, sizeof(af_line_str), "Tipo\t%i\n", FactionInfo[factionid][fType]);
	strcat(af_dlg_str, af_line_str, sizeof(af_dlg_str));

	format(af_line_str, sizeof(af_line_str), "Materiales\t%i\n", FactionInfo[factionid][fMaterials]);
	strcat(af_dlg_str, af_line_str, sizeof(af_dlg_str));

	format(af_line_str, sizeof(af_line_str), "Balance bancario\t%i\n", FactionInfo[factionid][fBank]);
	strcat(af_dlg_str, af_line_str, sizeof(af_dlg_str));

	format(af_line_str, sizeof(af_line_str), "Rango de ingreso\t%i\n", FactionInfo[factionid][fJoinRank]);
	strcat(af_dlg_str, af_line_str, sizeof(af_dlg_str));

	format(af_line_str, sizeof(af_line_str), "Cantidad de rangos\t%i\n", FactionInfo[factionid][fRankAmount]);
	strcat(af_dlg_str, af_line_str, sizeof(af_dlg_str));

	format(af_line_str, sizeof(af_line_str), "Flags\t-\n");
	strcat(af_dlg_str, af_line_str, sizeof(af_dlg_str));

	for(new i = 1, size = sizeof(FactionRanks[]); i < size; i++)
	{
		format(af_line_str, sizeof(af_line_str), "Rango %i\t%s\n", i, FactionRanks[factionid][i]);
		strcat(af_dlg_str, af_line_str, sizeof(af_dlg_str));
	}

	for(new i = 1, size = sizeof(FactionRanksSalary[]); i < size; i++)
	{
		format(af_line_str, sizeof(af_line_str), "Salario rango %i\t%i\n", i, FactionRanksSalary[factionid][i]);
		strcat(af_dlg_str, af_line_str, sizeof(af_dlg_str));
	}

	format(af_line_str, sizeof(af_line_str), "administración de facción Id %i", factionid);
	Dialog_Show(playerid, DLG_ADM_FACTION, DIALOG_STYLE_TABLIST_HEADERS, af_line_str, af_dlg_str, "Aceptar", "Cerrar");
	return 1;
}

static const af_adm_items[][][] = {
	{"Cambiar nombre", "Ingresa el nuevo nombre:"},
	{"Cambiar tipo", "Ingresa el nuevo tipo:"},
	{"Cambiar cantidad de materiales", "Ingresa la nueva cantidad:"},
	{"Cambiar balance bancario", "Ingresa el nuevo balance:"},
	{"Cambiar rango de ingreso", "Ingresa el nuevo rango:"},
	{"Cambiar rangos en uso", "Ingresa la cantidad de rangos en uso:"},
	{"", ""}, // Relleno, ocupa el lugar de las tags.
	{"Cambiar nombre de rango", "Ingresa el nuevo nombre:"},
	{"Cambiar salario de rango", "Ingresa el nuevo monto:"}
};

Faction_ChangeField(playerid, field_item)
{
	if(0 <= field_item < 6) {
		af_field_selection[playerid] = field_item;
		Dialog_Show(playerid, DLG_ADM_FAC_MOD_VALUE, DIALOG_STYLE_INPUT, af_adm_items[field_item][0], af_adm_items[field_item][1], "Aceptar", "Cancelar");
	} else if (field_item == 6) {
		af_field_selection[playerid] = field_item;
		Faction_ShowFlagsDialog(playerid);
	} else if(7 <= field_item < 17) {
		af_field_selection[playerid] = field_item;
		Dialog_Show(playerid, DLG_ADM_FAC_MOD_VALUE, DIALOG_STYLE_INPUT, af_adm_items[7][0], af_adm_items[7][1], "Aceptar", "Cancelar");
	} else if(17 <= field_item < 27) {
		af_field_selection[playerid] = field_item;
		Dialog_Show(playerid, DLG_ADM_FAC_MOD_VALUE, DIALOG_STYLE_INPUT, af_adm_items[8][0], af_adm_items[8][1], "Aceptar", "Cancelar");
	}
}

Dialog:DLG_ADM_FACTION(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;

	Faction_ChangeField(playerid, listitem);
	return 1;
}

Dialog:DLG_ADM_FAC_MOD_VALUE(playerid, response, listitem, inputtext[])
{
	if(!response || isnull(inputtext))
		return Faction_Manage(playerid, af_fac_selection[playerid]);

	new value;

	if(1 <= af_field_selection[playerid] < 6 || 17 <= af_field_selection[playerid] < 27)
	{
		if(sscanf(inputtext, "i", value))
		{
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ingresar un valor numérico.");
			Faction_ChangeField(playerid, af_field_selection[playerid]);
			return 1;
		}
	}

	new factionid = af_fac_selection[playerid];

	switch(af_field_selection[playerid])
	{
		case 0: Faction_SetName(factionid, inputtext);
		case 1: Faction_SetType(factionid, value);
		case 2: Faction_SetMaterials(factionid, value);
		case 3: Faction_SetBank(factionid, value);
		case 4: Faction_SetJoinRank(factionid, value);
		case 5: Faction_SetRankAmount(factionid, value);
		case 7 .. 16: Faction_SetRankName(factionid, af_field_selection[playerid] - 6, inputtext);
		case 17 .. 26: Faction_SetRankSalary(factionid, af_field_selection[playerid] - 16, value);
	}

	Faction_Manage(playerid, factionid);
	return 1;
}

static dlg_str[128 * sizeof(FACTIONS_TAGS_DATA)];

Faction_ShowFlagsDialog(playerid)
{
	format(dlg_str, sizeof(dlg_str), "TAG\tEstado\n");
	new line_str[64];

	new factionid = af_fac_selection[playerid];

	for(new i = 0, size = sizeof(FACTIONS_TAGS_DATA); i < size; i++)
	{
		format(line_str, sizeof(line_str), "%s\t%s\n", FACTIONS_TAGS_DATA[i][fac_name], (BitFlag_Get(FactionInfo[factionid][fFlags], FACTIONS_TAGS_DATA[i][fac_flag])) ? ("{01DF01}ON{FFFFFF}") : ("{DF0101}OFF{FFFFFF}"));
		strcat(dlg_str, line_str, sizeof(dlg_str));
	}
	Dialog_Show(playerid, DLG_ADM_FAC_MOD_FLAG, DIALOG_STYLE_TABLIST_HEADERS, "Activa o desactiva los flags de la faccion", dlg_str, "Aceptar", "Volver");
}

Dialog:DLG_ADM_FAC_MOD_FLAG(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Faction_Manage(playerid, af_fac_selection[playerid]);

	new factionid = af_fac_selection[playerid];

	Faction_SetTag(factionid, FACTIONS_TAGS_DATA[listitem][fac_flag]);
	Faction_ShowFlagsDialog(playerid);
	SaveFaction(factionid);
	return 1;
}