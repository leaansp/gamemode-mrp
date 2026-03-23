#if defined _marp_cmdpermissions_included
	#endinput
#endif
#define _marp_cmdpermissions_included

#include <YSI_Coding\y_hooks>

/**
* CmdPermissions by Nevermore
* This script implements a configurable permission system
**/

static Map:MAP_CMD_PERMISSIONS = INVALID_MAP;

hook OnGameModeInitEnded()
{
	MAP_CMD_PERMISSIONS = map_new(.ordered = false);
	loadCmdPermissions();
	return 1;
}

hook OnGameModeExit()
{
	map_delete(MAP_CMD_PERMISSIONS);
	return 1;
}

loadCmdPermissions() {
	mysql_tquery(MYSQL_HANDLE, "SELECT * FROM `commands_levels`;", "OnCmdListRecovered");
}

forward commandPermissionsUpdate();
public commandPermissionsUpdate()
{
	loadCmdPermissions();
	return 1;
}

checkCmdPermission(command[], level)
{
	for(new i = 0; command[i] != 0; i++) {
		command[i] = tolower(command[i]);
	}

	if(map_has_str_key(MAP_CMD_PERMISSIONS, command)) {
		return (map_str_get(MAP_CMD_PERMISSIONS, command) <= level);
	}

	return 1;
}

setCmdPermission(const command[], level)
{
	if(level > 0)
	{
		map_str_set(MAP_CMD_PERMISSIONS, command, level);
		mysql_f_tquery(MYSQL_HANDLE, 180, @Callback: "" @Format: "INSERT INTO `commands_levels` (`command`,`level`) VALUES ('%e',%i) ON DUPLICATE KEY UPDATE `level`=VALUES(`level`);", command, level);
	}
	else
	{
		map_str_remove(MAP_CMD_PERMISSIONS, command);
		mysql_f_tquery(MYSQL_HANDLE, 180, @Callback: "" @Format: "DELETE FROM `commands_levels` WHERE `command`='%e';", command);
	}

	return 1;
}

forward OnCmdListRecovered();
public OnCmdListRecovered()
{
	new rows = cache_num_rows();

	map_clear(MAP_CMD_PERMISSIONS);

	for(new i = 0, level, command[32]; i < rows; i++)
	{
		cache_get_value_name_int(i, "level", level);
		cache_get_value_name(i, "command", command, sizeof(command));
		map_str_add(MAP_CMD_PERMISSIONS, command, level);
	}

	printf("[INFO] Cargados los permisos de %i comandos.", rows);
	return 1;
}

CMD:nivelcomando(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new cmdstring[32],
		level;

	if(!sscanf(params, "s[32]i", cmdstring, level) && cmdstring[0] == '/')
	{
		setCmdPermission(cmdstring, level);
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has seteado el nivel del comando '%s' a %d.", cmdstring, level);
	} else {
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/nivelcomando /[comando] [nivel]");
	}
	return 1;
}
