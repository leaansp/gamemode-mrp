#if defined _marp_toggle_included
	#endinput
#endif
#define _marp_toggle_included

enum e_ToggleFlags:(<<= 1) { 
    FLAG_TOGGLE_MPS = 1,
    FLAG_TOGGLE_CELL,
    FLAG_TOGGLE_NEWS,
    FLAG_TOGGLE_FAC,
    FLAG_TOGGLE_RADIO,
    FLAG_TOGGLE_NICKS,
    FLAG_TOGGLE_HUD,
    FLAG_TOGGLE_ADMINMSGS,
    FLAG_TOGGLE_TALKANIM
};

new e_ToggleFlags:p_toggle[MAX_PLAYERS];

enum e_ToggleDlgTable {
	e_ToggleFlags:e_tt_flag,
	e_tt_desc[32]
}

static const ToggleDlgTable[][e_ToggleDlgTable] = {
	{FLAG_TOGGLE_MPS, "Mensajes Privados"},
	{FLAG_TOGGLE_CELL, "Teléfono"},
	{FLAG_TOGGLE_NEWS, "Noticias"},
	{FLAG_TOGGLE_FAC, "Facción"},
	{FLAG_TOGGLE_RADIO, "Radio"},
	{FLAG_TOGGLE_NICKS, "Nicks"},
	{FLAG_TOGGLE_HUD, "HUD"},
	{FLAG_TOGGLE_ADMINMSGS, "Adminmsgs"},
	{FLAG_TOGGLE_TALKANIM, "Animación al hablar"}
};

Toggle_ShowMenuForPlayer(playerid)
{
	new dlg_str[(32 + 20) * sizeof(ToggleDlgTable)], line_str[32 + 20];
	
	for(new i = 0, size = sizeof(ToggleDlgTable); i < size; i++)
	{
		format(line_str, sizeof(line_str), "%s\t%s\n", ToggleDlgTable[i][e_tt_desc], (BitFlag_Get(p_toggle[playerid], ToggleDlgTable[i][e_tt_flag])) ? ("{01DF01}ON") : ("{DF0101}OFF"));
		strcat(dlg_str, line_str);
	}

	Dialog_Show(playerid, DLG_CMD_TOGGLE, DIALOG_STYLE_TABLIST, "Opciones para activar o desactivar...", dlg_str, "On / Off", "Cerrar");
	return 1;
}

CMD:toggle(playerid, params[]) {
	return Toggle_ShowMenuForPlayer(playerid);
}

Dialog:DLG_CMD_TOGGLE(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 0;

	BitFlag_Toggle(p_toggle[playerid], ToggleDlgTable[listitem][e_tt_flag]);
	//OnPlayerToggleFlag(playerid, ToggleDlgTable[listitem][e_tt_flag]);
	if(ToggleDlgTable[listitem][e_tt_flag] == FLAG_TOGGLE_NICKS)
	{
		new show = BitFlag_Get(p_toggle[playerid], FLAG_TOGGLE_NICKS);

		foreach(new i : Player)
		{
			if(!show || (!HiddenName_IsActive(i) || AdminDuty[playerid])) {
				ShowPlayerNameTagForPlayer(playerid, i, show);
			}
		}
	}
	else if(ToggleDlgTable[listitem][e_tt_flag] == FLAG_TOGGLE_HUD)
	{
		if(BitFlag_Get(p_toggle[playerid], FLAG_TOGGLE_HUD))
		{
			ShowPlayerSpeedo(playerid);
			BN_ShowForPlayer(playerid);
			Logo_ShowForPlayer(playerid);
		}
		else
		{
			HidePlayerSpeedo(playerid);
			BN_HideForPlayer(playerid);
			Logo_HideForPlayer(playerid);
		}
	}

	Toggle_ShowMenuForPlayer(playerid);
	return 1;
}

/*

forward OnPlayerToggleFlag(playerid, e_ToggleFlags:flag);
public OnPlayerToggleFlag(playerid, e_ToggleFlags:flag) {
	return 1;
}

#include <YSI_Coding\y_hooks>
hook OnPlayerToggleFlag(playerid, e_ToggleFlags:flag) {
	if(flag == FLAG_TOGGLE_NICKS) {
		new show = BitFlag_Get(p_toggle[playerid], FLAG_TOGGLE_NICKS);
		foreach(new i : Player) {
			if(!show || (!usingMask[i] || PlayerInfo[playerid][pAdmin])) {
				ShowPlayerNameTagForPlayer(playerid, i, show);
			}
		}	
	}
	return ~1; // use special code return to avoid continuing hooking chain
}

#include <YSI_Coding\y_hooks>
hook OnPlayerToggleFlag(playerid, e_ToggleFlags:flag) {
	if(flag == FLAG_TOGGLE_HUD) {
		if(BitFlag_Get(p_toggle[playerid], FLAG_TOGGLE_HUD)) {
			ShowPlayerSpeedo(playerid);
			BN_ShowForPlayer(playerid);
		} else {
			HidePlayerSpeedo(playerid);
			BN_HideForPlayer(playerid);
		}
	}
	return ~1; // use special code return to avoid continuing hooking chain
}

*/