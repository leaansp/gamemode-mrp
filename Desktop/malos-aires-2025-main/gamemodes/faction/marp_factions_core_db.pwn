#if defined _marp_factions_core_db_included
	#endinput
#endif
#define _marp_factions_core_db_included

static enum e_FACTION_RANK_DATA 
{
    rankField[16],
    rankSalaryField[16]
}

static const FactionRank_Info[FAC_RANK_AMOUNT + 1][e_FACTION_RANK_DATA] = {
    {"", ""},
	{"Rank1", "Rank1Salary"},
    {"Rank2", "Rank2Salary"},
    {"Rank3", "Rank3Salary"},
    {"Rank4", "Rank4Salary"},
    {"Rank5", "Rank5Salary"},
    {"Rank6", "Rank6Salary"},
    {"Rank7", "Rank7Salary"},
    {"Rank8", "Rank8Salary"},
    {"Rank9", "Rank9Salary"},
    {"Rank10", "Rank10Salary"}
};

LoadAllFactions()
{
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "Faction_OnDataLoadAll" @Format: "SELECT * FROM `factions` LIMIT %i;", MAX_FACTIONS - 1);
	print("[INFO] Cargando facciones ...");
	return 1;
}

forward Faction_OnDataLoadAll();
public Faction_OnDataLoadAll()
{
	new rows = cache_num_rows();

	for(new i = 0, id; i < rows; i++)
	{
		cache_get_value_name_int(i, "Id", id);

		if(Faction_IsValidId(id))
		{
			cache_get_value_name_int(i, "Type", FactionInfo[id][fType]);
			cache_get_value_name_int(i, "Materials", FactionInfo[id][fMaterials]);
			cache_get_value_name_int(i, "Bank", FactionInfo[id][fBank]);
			cache_get_value_name_int(i, "fFlags", _:FactionInfo[id][fFlags]);
			cache_get_value_name_int(i, "JoinRank", FactionInfo[id][fJoinRank]);
			cache_get_value_name_int(i, "RankAmount", FactionInfo[id][fRankAmount]);

			cache_get_value_name(i, "Name", FactionInfo[id][fName], FAC_NAME_LENGTH);
			cache_get_value_name(i, "Rank1", FactionRanks[id][1], FAC_RANK_LENGTH);
			cache_get_value_name(i, "Rank2", FactionRanks[id][2], FAC_RANK_LENGTH);
			cache_get_value_name(i, "Rank3", FactionRanks[id][3], FAC_RANK_LENGTH);
			cache_get_value_name(i, "Rank4", FactionRanks[id][4], FAC_RANK_LENGTH);
			cache_get_value_name(i, "Rank5", FactionRanks[id][5], FAC_RANK_LENGTH);
			cache_get_value_name(i, "Rank6", FactionRanks[id][6], FAC_RANK_LENGTH);
			cache_get_value_name(i, "Rank7", FactionRanks[id][7], FAC_RANK_LENGTH);
			cache_get_value_name(i, "Rank8", FactionRanks[id][8], FAC_RANK_LENGTH);
			cache_get_value_name(i, "Rank9", FactionRanks[id][9], FAC_RANK_LENGTH);
			cache_get_value_name(i, "Rank10", FactionRanks[id][10], FAC_RANK_LENGTH);

			cache_get_value_name_int(i, "Rank1Salary", FactionRanksSalary[id][1]);
			cache_get_value_name_int(i, "Rank2Salary", FactionRanksSalary[id][2]);
			cache_get_value_name_int(i, "Rank3Salary", FactionRanksSalary[id][3]);
			cache_get_value_name_int(i, "Rank4Salary", FactionRanksSalary[id][4]);
			cache_get_value_name_int(i, "Rank5Salary", FactionRanksSalary[id][5]);
			cache_get_value_name_int(i, "Rank6Salary", FactionRanksSalary[id][6]);
			cache_get_value_name_int(i, "Rank7Salary", FactionRanksSalary[id][7]);
			cache_get_value_name_int(i, "Rank8Salary", FactionRanksSalary[id][8]);
			cache_get_value_name_int(i, "Rank9Salary", FactionRanksSalary[id][9]);
			cache_get_value_name_int(i, "Rank10Salary", FactionRanksSalary[id][10]);
		} else {
			printf("[ERROR] No se pudo cargar la faccion ID %i pues es invalida o supera el maximo de %i.", id, MAX_FACTIONS - 1);
		}
	}

	printf("[INFO] Carga de %i facciones finalizada.", rows);
	return 1;
}

Graffiti_LoadAll()
{
    mysql_tquery(MYSQL_HANDLE, "SELECT * FROM graffiti", "Graffiti_OnLoadAll");
    print("[INFO] Cargando grafitis...");
}


Faction_SQLSaveName(facid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `factions` SET `Name`='%e' WHERE `Id`=%i;", FactionInfo[facid][fName], facid);
}

Faction_SQLSaveRankName(facid, rankid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `factions` SET `%s`='%e' WHERE `Id`=%i;", FactionRank_Info[rankid][rankField], FactionRanks[facid][rankid], facid);
}

Faction_SQLSaveRankSalary(facid, rankid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `factions` SET `%s`=%i WHERE `Id`=%i;", FactionRank_Info[rankid][rankSalaryField], FactionRanksSalary[facid][rankid], facid);
}

Faction_SQLSaveMaterials(facid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `factions` SET `Materials`=%i WHERE `Id`=%i;", FactionInfo[facid][fMaterials], facid);
}

Faction_SQLSaveBank(facid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `factions` SET `Bank`=%i WHERE `Id`=%i;", FactionInfo[facid][fBank], facid);
}

Faction_SQLSaveJoinRank(facid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `factions` SET `JoinRank`=%i WHERE `Id`=%i;", FactionInfo[facid][fJoinRank], facid);
}

Faction_SQLSaveRankAmount(facid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `factions` SET `RankAmount`=%i WHERE `Id`=%i;", FactionInfo[facid][fRankAmount], facid);
}

Faction_SQLSaveType(facid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `factions` SET `Type`=%i WHERE `Id`=%i;", FactionInfo[facid][fType], facid);
}

Faction_SQLSaveTags(facid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `factions` SET `fFlags`=%i WHERE `Id`=%i;", FactionInfo[facid][fFlags], facid);
}

SaveAllFactions()
{
	for(new facid = 1; facid < MAX_FACTIONS; facid++) {
		SaveFaction(facid);
	}

	print("[INFO] Facciones guardadas.");
	return 1;
}


SaveFaction(facid)
{
	new query[1024];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"UPDATE `factions` SET \
			`Name`='%e',\
			`Rank1`='%e',\
			`Rank2`='%e',\
			`Rank3`='%e',\
			`Rank4`='%e',\
			`Rank5`='%e',\
			`Rank6`='%e',\
			`Rank7`='%e',\
			`Rank8`='%e',\
			`Rank9`='%e',\
			`Rank10`='%e',\
			`Materials`=%i,\
			`Bank`=%i,\
			`JoinRank`=%i,\
			`Type`=%i,\
			`RankAmount`=%i,\
			`fFlags`=%i,\
			`Rank1Salary`=%i,\
			`Rank2Salary`=%i,\
			`Rank3Salary`=%i,\
			`Rank4Salary`=%i,\
			`Rank5Salary`=%i,\
			`Rank6Salary`=%i,\
			`Rank7Salary`=%i,\
			`Rank8Salary`=%i,\
			`Rank9Salary`=%i,\
			`Rank10Salary`=%i \
		WHERE \
			`Id`=%i;",
		FactionInfo[facid][fName],
		FactionRanks[facid][1],
		FactionRanks[facid][2],
		FactionRanks[facid][3],
		FactionRanks[facid][4],
		FactionRanks[facid][5],
		FactionRanks[facid][6],
		FactionRanks[facid][7],
		FactionRanks[facid][8],
		FactionRanks[facid][9],
		FactionRanks[facid][10],
		FactionInfo[facid][fMaterials],
		FactionInfo[facid][fBank],
		FactionInfo[facid][fJoinRank],
		FactionInfo[facid][fType],
		FactionInfo[facid][fRankAmount],
		FactionInfo[facid][fFlags],
		FactionRanksSalary[facid][1],
		FactionRanksSalary[facid][2],
		FactionRanksSalary[facid][3],
		FactionRanksSalary[facid][4],
		FactionRanksSalary[facid][5],
		FactionRanksSalary[facid][6],
		FactionRanksSalary[facid][7],
		FactionRanksSalary[facid][8],
		FactionRanksSalary[facid][9],
		FactionRanksSalary[facid][10],
		facid
	);
	mysql_tquery(MYSQL_HANDLE, query);
	return 1;
}