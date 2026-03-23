#if defined _marp_commands_list_included
	#endinput
#endif
#define _marp_commands_list_included

#include <YSI_Storage\y_amx>

static COMMANDS_LIST_VECTOR;

GenerateCommandsListVector()
{
	if(!COMMANDS_LIST_VECTOR)
	{
		COMMANDS_LIST_VECTOR = vector_create();
		print("[INFO] Searching all available commands list with AMX_GetName...");

		new buffer[32], index;
		index = AMX_GetName(AMX_TABLE_PUBLICS, index, buffer, "cmd_");
		while(index != 0)
		{
			if(strcmp(buffer, "zcmd_OnGameModeInit") && strcmp(buffer, "zcmd_OnFilterScriptInit")) {
				strmid(buffer, buffer, 4, strlen(buffer), 32);
				strins(buffer, "/", 0);
				vector_push_back_arr(COMMANDS_LIST_VECTOR, buffer);
			}
			index = AMX_GetName(AMX_TABLE_PUBLICS, index, buffer, "cmd_");
		}

		printf("[INFO] Search ended: %i available commands proccessed.", vector_size(COMMANDS_LIST_VECTOR));
	}
}

DumpCommandsListToDB()
{
	printf("[INFO] Dumping all available commands to DB.", vector_size(COMMANDS_LIST_VECTOR));

	mysql_tquery(MYSQL_HANDLE, "TRUNCATE commands");

	for(new i = 0, size = vector_size(COMMANDS_LIST_VECTOR), query[128], cmd[32]; i < size; i++)
	{
		vector_get_arr(COMMANDS_LIST_VECTOR, i, cmd, 32);
		mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO commands (command) values ('%s') ON DUPLICATE KEY UPDATE command=command", cmd);
		mysql_tquery(MYSQL_HANDLE, query);
	}
}

stock GetCommandsListVector() {
	return COMMANDS_LIST_VECTOR;
}