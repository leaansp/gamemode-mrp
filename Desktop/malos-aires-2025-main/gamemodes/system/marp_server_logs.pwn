#if defined _marp_server_logs_included
	#endinput
#endif
#define _marp_server_logs_included

#include <YSI_Coding\y_hooks>

enum e_LOG_TYPE_ID
{
	/*0*/ LOG_TYPE_ID_NONE,
	/*1*/ LOG_TYPE_ID_ADMIN,
	/*2*/ LOG_TYPE_ID_MONEY,
	/*3*/ LOG_TYPE_ID_VEHICLES,
	/*4*/ LOG_TYPE_ID_HOUSES,
	/*5*/ LOG_TYPE_ID_WEAPONS
}

static LogTables[e_LOG_TYPE_ID][16] =
{
	"log_none",
	"log_admin",
	"log_money",
	"log_vehicles",
	"log_houses",
	"log_weapons"
};

new sfl_log_str[256];
#define ServerFormattedLog(%1<%2,%3>); {format(sfl_log_str,256,%2,%3);ServerLog(%1 sfl_log_str);}

ServerLog(e_LOG_TYPE_ID:type, id = 0, const entry[] = "", playerid = INVALID_PLAYER_ID, targetid = INVALID_PLAYER_ID, const params[] = "")
{
	new query[512], playerName[MAX_PLAYER_NAME], targetName[MAX_PLAYER_NAME];

	if(playerid != INVALID_PLAYER_ID){
		strcat(playerName, PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
	}

	if(targetid != INVALID_PLAYER_ID) {
		strcat(targetName, PlayerInfo[targetid][pName], MAX_PLAYER_NAME);
	}

	mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO `%s` (`id`,`pID`,`pName`,`tID`,`tName`,`entry`,`params`) VALUES (%i,%i,'%s',%i,'%s','%s','%e');",
		LogTables[type],
		id,
		(playerid != INVALID_PLAYER_ID) ? (PlayerInfo[playerid][pID]) : (0),
		playerName,
		(targetid != INVALID_PLAYER_ID) ? (PlayerInfo[targetid][pID]) : (0),
		targetName,
		entry,
		params
	);

	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}