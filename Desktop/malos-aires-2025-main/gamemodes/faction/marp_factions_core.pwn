#if defined _marp_factions_core_inc
	#endinput
#endif
#define _marp_factions_core_inc

#define MAX_FACTIONS            21

#define FAC_NAME_LENGTH			50
#define FAC_RANK_LENGTH 		32
#define FAC_RANK_AMOUNT			10 // NO CAMBIAR. SI SE CAMBIA TENER EN CUENTA QUE SE DEBE CAMBIAR LA ESTRUCTURA DE DB TAMBIEN.

#define FAC_NONE                0
#define FAC_PMA                 1 		// Policía.
#define FAC_HOSP                2       // SAME
#define FAC_SIDE                3		// GNA
#define FAC_GOB	                4       // Malos Aires Ciudad
#define FAC_MECH                5       // TMMA
#define FAC_MAN                 6       // CTR-MAN
#define FAC_FREE_LEGAL_1        7       // Faccion Legal
#define FAC_FREE_LEGAL_2        8       // Faccion Legal
#define FAC_FREE_LEGAL_3        9       // Faccion Legal
#define FAC_FREE_LEGAL_4        10       // Faccion Legal
#define FAC_FREE_ILLEGAL_GANG_1 11       // Faccion Ilegal Gang
#define FAC_FREE_ILLEGAL_GANG_2 12       // Faccion Ilegal Gang
#define FAC_FREE_ILLEGAL_GANG_3 13       // Faccion Ilegal Gang
#define FAC_FREE_ILLEGAL_GANG_4 14       // Faccion Ilegal Gang
#define FAC_FREE_ILLEGAL_GANG_5 15       // Faccion Ilegal Gang
#define FAC_FREE_ILLEGAL_MAF_1	16       // Faccion Ilegal Mafia
#define FAC_FREE_ILLEGAL_MAF_2 	17       // Faccion Ilegal Mafia
#define FAC_FREE_ILLEGAL_MAF_3 	18       // Faccion Ilegal Mafia
#define FAC_FREE_ILLEGAL_MAF_4 	19       // Faccion Ilegal Mafia
#define FAC_FREE_ILLEGAL_MAF_5 	20       // Faccion Ilegal Mafia

//#define FAC_TYPE_NONE			0
// #define FAC_TYPE_GOV			1
//#define FAC_TYPE_LEGAL          2
//#define FAC_TYPE_GANG	        3
//#define FAC_TYPE_ILLEGAL        4

enum e_FACTIONS_TAGS(<<= 1)
{
	FAC_TAG_EQUIPMENT = 1, // Si la faccion puede utilizar /equipar
	FAC_TAG_DRUG_TRAFFIC, // Si la faccion puede traficar drogas
	FAC_TAG_WEAPON_TRAFFIC, // Si la faccion puede traficar armas
	FAC_TAG_ILLEGAL_MISSIONS, // Permite iniciar/recibir misiones ilegales (robos/trafico)
	FAC_TAG_ALLOW_JOB, // Si la faccion permite job
	FAC_TAG_GOB_TYPE, // Si la faccion pertenece al gobierno
    FAC_TAG_ALLOW_GRAFITI // Si tiene permitido hacer grafitis
}

enum e_FACTION_DATA {
	fName[FAC_NAME_LENGTH],
	fMaterials,
	fBank,
	fJoinRank,
	fType,
	fRankAmount,
	e_FACTIONS_TAGS:fFlags
};

new FactionInfo[MAX_FACTIONS][e_FACTION_DATA] = {
/*0*/{
    /*fName[FAC_NAME_LENGTH]*/ "",
	/*fMaterials*/ 0,
	/*fBank*/ 0,
	/*fJoinRank*/ 0,
	/*fType*/ 0,
	/*fRankAmount*/ 0,
	/*e_FACTIONS_TAGS:fFlags*/ e_FACTIONS_TAGS:0 
    }, ...    
};
new FactionRanks[MAX_FACTIONS][FAC_RANK_AMOUNT+1][FAC_RANK_LENGTH];
new FactionRanksSalary[MAX_FACTIONS][FAC_RANK_AMOUNT+1];

Faction_IsValidId(factionid) {
	return (0 < factionid < MAX_FACTIONS);
}

Faction_IsValidRank(rank) {
	return (1 <= rank <= FAC_RANK_AMOUNT);
}

Faction_GetMaxAmount() {
	return MAX_FACTIONS - 1;
}

stock Faction_GetName(factionid)
{
	new str[FAC_NAME_LENGTH];
	strcat(str, FactionInfo[factionid][fName], FAC_NAME_LENGTH);
	return str;
}

stock Faction_GetBank(factionid) {
    return (Faction_IsValidId(factionid)) ? (FactionInfo[factionid][fBank]) : (0);
}

stock Faction_GetJoinRank(factionid) {
    return (Faction_IsValidId(factionid)) ? (FactionInfo[factionid][fJoinRank]) : (0);
}

stock Faction_GetMaterials(factionid) {
    return (Faction_IsValidId(factionid)) ? (FactionInfo[factionid][fMaterials]) : (0);
}

stock Faction_GetType(factionid) {
    return (Faction_IsValidId(factionid)) ? (FactionInfo[factionid][fType]) : (0);
}

stock Faction_GetRankAmount(factionid) {
    return (Faction_IsValidId(factionid)) ? (FactionInfo[factionid][fRankAmount]) : (0);
}

stock Faction_HasTag(factionid, e_FACTIONS_TAGS:tag) {
	return (FactionInfo[factionid][fFlags] & tag);
}

stock Faction_HasAllTheseTags(factionid, e_FACTIONS_TAGS:tags) {
	return ((FactionInfo[factionid][fFlags] & tag) == tag);
}

stock Faction_GetRankName(factionid, rank)
{
	new str[FAC_RANK_LENGTH];
	strcat(str, FactionRanks[factionid][rank], FAC_RANK_LENGTH);
	return str;
}

stock Faction_GetRankSalary(factionid, rank)
{
	if(!Faction_IsValidId(factionid) || !Faction_IsValidRank(rank))
		return 0;

	return FactionRanksSalary[factionid][rank];
}

stock Faction_SetName(factionid, name[])
{
	if(!Faction_IsValidId(factionid))
		return 0;

	mysql_escape_string(name, name, FAC_NAME_LENGTH, MYSQL_HANDLE);
	strmid(FactionInfo[factionid][fName], name, 0, strlen(name), FAC_NAME_LENGTH);
	Faction_SQLSaveName(factionid);
	return 1;
}

stock Faction_SetBank(factionid, bank)
{
	if(!Faction_IsValidId(factionid))
		return 0;

	FactionInfo[factionid][fBank] = bank;
	Faction_SQLSaveBank(factionid);
	return 1;
}

stock Faction_GiveMoney(factionid, money)
{
	if(!Faction_IsValidId(factionid))
		return 0;

	FactionInfo[factionid][fBank] += money;
	Faction_SQLSaveBank(factionid);
	return 1;
}

stock Faction_SetType(factionid, type)
{
	if(!Faction_IsValidId(factionid))
		return 0;

	FactionInfo[factionid][fType] = type;
	Faction_SQLSaveType(factionid);
	return 1;
}

stock Faction_SetMaterials(factionid, materials)
{
	if(!Faction_IsValidId(factionid))
		return 0;

	FactionInfo[factionid][fMaterials] = materials;
	Faction_SQLSaveMaterials(factionid);
	return 1;
}

stock Faction_SetJoinRank(factionid, join_rank)
{
	if(!Faction_IsValidId(factionid) || !Faction_IsValidRank(join_rank))
		return 0;

	FactionInfo[factionid][fJoinRank] = join_rank;
	Faction_SQLSaveJoinRank(factionid);
	return 1;
}

stock Faction_SetRankAmount(factionid, rank_amount)
{
	if(!Faction_IsValidId(factionid) || !Faction_IsValidRank(rank_amount))
		return 0;

	FactionInfo[factionid][fRankAmount] = rank_amount;
	Faction_SQLSaveRankAmount(factionid);
	return 1;
}

stock Faction_SetTag(factionid, e_FACTIONS_TAGS:tag)
{
    if(!Faction_IsValidId(factionid))
		return 0;
    
    BitFlag_Toggle(FactionInfo[factionid][fFlags], tag);
    Faction_SQLSaveTags(factionid);
    return 1;
}

stock Faction_SetRankName(factionid, rank, name[])
{
	if(!Faction_IsValidId(factionid) || !Faction_IsValidRank(rank))
		return 0;

	mysql_escape_string(name, name, FAC_RANK_LENGTH, MYSQL_HANDLE);
	strmid(FactionRanks[factionid][rank], name, 0, strlen(name), FAC_RANK_LENGTH);
	Faction_SQLSaveRankName(factionid, rank);
	return 1;
}

stock Faction_SetRankSalary(factionid, rank, value)
{
	if(!Faction_IsValidId(factionid) || !Faction_IsValidRank(rank))
		return 0;

	FactionRanksSalary[factionid][rank] = value;
	Faction_SQLSaveRankSalary(factionid, rank);
	return 1;
}

Faction_SetPlayer(playerid, factionid, rank)
{
	if(factionid >= MAX_FACTIONS)
		return 0;

    new oldfaction = PlayerInfo[playerid][pFaction];
	
    // Si no cambia de faccion solo cambia el rango.
    if(factionid == oldfaction)
    {
        PlayerInfo[playerid][pRank] = rank;
        return 1;
    }

	if(factionid == 0 && (oldfaction == FAC_PMA || oldfaction == FAC_SIDE))
	    EndPlayerDuty(playerid);

	PlayerInfo[playerid][pFaction] = factionid;
	PlayerInfo[playerid][pRank] = rank;

    if(!factionid)
    {
        if(Faction_HasTag(oldfaction, FAC_TAG_ALLOW_JOB))
            PlayerInfo[playerid][pJob] = 0;

      //  if(Faction_HasTag(oldfaction, FAC_TAG_ALLOW_GANGZONE))
	//	    HideGangZonesToPlayer(playerid);
		
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);

        if(oldfaction == FAC_PMA || oldfaction == FAC_SIDE)
		{
            if(PlayerInfo[playerid][pBeltSQLID] > 0)
            {
                Container_Fully_Destroy(PlayerInfo[playerid][pBeltID], PlayerInfo[playerid][pBeltSQLID]);
                PlayerInfo[playerid][pBeltSQLID] = 0;
                PlayerInfo[playerid][pBeltID] = 0;
            }
		}
    }
    else
    {
        if(!Faction_HasTag(factionid, FAC_TAG_ALLOW_JOB))
        {
            SavePlayerJobData(playerid, 1); // Guardamos el viejo
			ResetJobVariables(playerid); // Reseteamos todo a cero
			SetPlayerJob(playerid, 0); // Seteamos job nulo
        }

        if(factionid == FAC_PMA || factionid == FAC_SIDE)
		{
			if(PlayerInfo[playerid][pBeltSQLID] > 0)
				PlayerInfo[playerid][pBeltID] = Container_Load(PlayerInfo[playerid][pBeltSQLID]);
			else
				Container_Create(CONTAINER_BELT_SPACE, 1, PlayerInfo[playerid][pBeltID], PlayerInfo[playerid][pBeltSQLID]);
		}
			
	//	if(Faction_HasTag(factionid, FAC_TAG_ALLOW_GRAFITI))
	//		ShowGangZonesToPlayer(playerid);
    }
    return 1;
}

static Faction_VehStr[4096];

Faction_ShowVehicles(factionid, toplayerid)
{
	new title[64];
	format(title, sizeof(title), "[%s] Vehiculos", Faction_GetName(factionid));
    format(Faction_VehStr, sizeof(Faction_VehStr), "[ID]\tModelo\n", Faction_GetName(factionid));

    new line[64];

    for(new vehid = 1; vehid < MAX_VEH; vehid++)
    {
        if(VehicleInfo[vehid][VehFaction] == factionid)
        {
            format(line, sizeof(line), "[%i]\t%s\n", vehid, Veh_GetName(vehid));
            strcat(Faction_VehStr, line, sizeof(Faction_VehStr));
        }
    }

    Dialog_Open(toplayerid, "DLG_NO_RESPONSE", DIALOG_STYLE_TABLIST_HEADERS, title, Faction_VehStr, "Cerrar", "");
}