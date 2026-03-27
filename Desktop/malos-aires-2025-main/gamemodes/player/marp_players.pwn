#if defined _marp_players_included
	#endinput
#endif
#define _marp_players_included

#define GetPlayerCleanName(%0)			(playerCleanName[%0])
#define GetPlayerChatName(%0)			(playerChatName[%0])
#define GetPlayerJob(%0)				(PlayerInfo[%0][pJob])

new playerCleanName[MAX_PLAYERS][MAX_PLAYER_NAME]; // No va en pInfo pq pawn no puede calcular sizes de arrays en enums.
new playerChatName[MAX_PLAYERS][MAX_PLAYER_NAME]; // No va en pInfo pq pawn no puede calcular sizes de arrays en enums.

enum pInfo {
	pID,
	pMasterAccountId,
	pCharacterSlot,
	pName[MAX_PLAYER_NAME],
	aNick[MAX_PLAYER_NAME],
	pIP[16],
	pLevel,
	pTimePlayed,
	pAdmin,
	pSex,
	pAge,
	pExp,
	pCash,
	pBank,
	pSkin,
	pJob,
	pJobSkin,
	pJobTime,
	pLastConnected[32],
	pPayCheck,
	pPayTime,
	pDead,
	pDisabled,
	pFaction,
	pRank,
	pHouseKey,
	pWarnings,
	pCarLic,
	pFlyLic,
	pWepLic,
	pPhoneNumber,
	pJailed,
	pJailTime,
	Float:pX,
	Float:pY,
	Float:pZ,
	Float:pA,
	pInterior,
	pVirtualWorld,
	pHospitalized,
	pCrack,
	Float:pHealth,
	Float:pArmour,
	pWounds[32],
	pWantedLevel,
	pCantWork,
	pAccusedOf[64],
	pAccusedBy[24],
 	pMuteB,
	pRentCarID,
	pRentCarRID,
	pRentBikeVehicleID,
	pFightStyle,
	
	pQuestion[144],
	pHaveQuestion,
	pReportReason[256],
	pReport,
	pTest,
	
	pThirst,
	pHunger,
	
	pRolePoints,
	pElogios,
	pElogiosPendientes,
	
	pContainerSQLID,
	pContainerID,
	pBeltSQLID,
	pBeltID,
	
	pDescription[70],
};

new PlayerInfo[MAX_PLAYERS][pInfo];

new PHONE_HANDLE:Phone_id[MAX_PLAYERS];

stock getPlayerMysqlId(playerid){
	return PlayerInfo[playerid][pID];
}

stock SetPlayerNameEx(playerid, const name[])
{
	SetPlayerName(playerid, name);
	format(PlayerInfo[playerid][pName], MAX_PLAYER_NAME, "%s", name);
	SetPlayerCleanName(playerid, PlayerInfo[playerid][pName]);

	if(!HiddenName_IsActive(playerid)) {
		SetPlayerChatName(playerid, GetPlayerCleanName(playerid));
	}
}

#if defined _ALS_SetPlayerName
	#undef SetPlayerName
#else
	#define _ALS_SetPlayerName
#endif

#define SetPlayerName SetPlayerNameEx

SetPlayerCleanName(playerid, const rawName[])
{
	playerCleanName[playerid][0] = EOS;
	strcat(playerCleanName[playerid], rawName, MAX_PLAYER_NAME);

	for(new i; i < MAX_PLAYER_NAME; i++)
	{
		if(playerCleanName[playerid][i] == '_') {
			playerCleanName[playerid][i] = ' ';
		}
	}
}

SetPlayerChatName(playerid, const name[])
{
	playerChatName[playerid][0] = EOS;
	strcat(playerChatName[playerid], name, MAX_PLAYER_NAME);
}