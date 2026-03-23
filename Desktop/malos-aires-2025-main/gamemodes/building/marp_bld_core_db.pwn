#if defined _marp_buildings_db_included
	#endinput
#endif
#define _marp_buildings_db_included

Bld_LoadAll()
{
    mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "Bld_OnAllDataLoad" @Format: "SELECT * FROM `buildings` LIMIT %i;", MAX_BUILDINGS - 1);
    print("[INFO] Cargando edificios...");
    return 1;
}

forward Bld_OnAllDataLoad();
public Bld_OnAllDataLoad()
{
    new rows = cache_num_rows();

    for(new row, buildid; row < rows; row++)
	{
        cache_get_value_name_int(row, "blID", buildid);

        cache_get_value_name(row, "blOutsideText", BuildingInfo[buildid][blOutsideText], BLD_MAX_TEXT_LENGTH);
        cache_get_value_name(row, "blInsideText", BuildingInfo[buildid][blInsideText], BLD_MAX_TEXT_LENGTH);
    
		cache_get_value_name_int(row, "blFaction", BuildingInfo[buildid][blFaction]);
        cache_get_value_name_int(row, "blLocked", BuildingInfo[buildid][blLocked]);
		
        cache_get_value_name_float(row, "blOutsideX", BuildingInfo[buildid][blOutsideX]);
		cache_get_value_name_float(row, "blOutsideY", BuildingInfo[buildid][blOutsideY]);
		cache_get_value_name_float(row, "blOutsideZ", BuildingInfo[buildid][blOutsideZ]);
		cache_get_value_name_float(row, "blOutsideAngle", BuildingInfo[buildid][blOutsideAngle]);
		cache_get_value_name_int(row, "blOutsideWorld", BuildingInfo[buildid][blOutsideWorld]);
		cache_get_value_name_int(row, "blOutsideInt", BuildingInfo[buildid][blOutsideInt]);

		cache_get_value_name_float(row, "blInsideX", BuildingInfo[buildid][blInsideX]);
		cache_get_value_name_float(row, "blInsideY", BuildingInfo[buildid][blInsideY]);
		cache_get_value_name_float(row, "blInsideZ", BuildingInfo[buildid][blInsideZ]);
		cache_get_value_name_float(row, "blInsideAngle", BuildingInfo[buildid][blInsideAngle]);
		cache_get_value_name_int(row, "blInsideWorld", BuildingInfo[buildid][blInsideWorld]);
		cache_get_value_name_int(row, "blInsideInt", BuildingInfo[buildid][blInsideInt]);
    
		cache_get_value_name_int(row, "blOusidePickupModel", BuildingInfo[buildid][blOusidePickupModel]);

		Iter_Add(BuildingInfo, buildid);
		Bld_ReloadAllPoints(buildid);

        CallLocalFunction("Bld_OnIdDataLoaded", "ii", buildid, row);
    }

    printf("[INFO] Carga de %i edificios finalizada.", rows);
	CallLocalFunction("Bld_OnAllDataLoaded", "");
    return 1;
}

forward Bld_OnIdDataLoaded(buildid, cacherow);
public Bld_OnIdDataLoaded(buildid, cacherow) {
	return 1;
}

forward Bld_OnAllDataLoaded();
public Bld_OnAllDataLoaded() {
	return 1;
}

Bld_SQLDelete(buildid) {
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "" @Format: "DELETE FROM `buildings` WHERE `blID`=%i;", buildid);
}

Bld_SQLCreate(buildid)
{
	new query[1024];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `buildings` \
			(`blID`,\
			`blFaction`,\
			`blLocked`,\
			`blOutsideText`,\
			`blInsideText`,\
			`blOutsideX`,\
			`blOutsideY`,\
			`blOutsideZ`,\
			`blOutsideAngle`,\
			`blOutsideInt`,\
			`blOutsideWorld`,\
			`blInsideX`,\
			`blInsideY`,\
			`blInsideZ`,\
			`blInsideAngle`,\
			`blInsideInt`,\
			`blInsideWorld`,\
			`blOusidePickupModel`)\
		VALUES \
			(%i,%i,%i,'%e','%e',%f,%f,%f,%f,%i,%i,%f,%f,%f,%f,%i,%i,%i);",
		buildid,
		BuildingInfo[buildid][blFaction],
		BuildingInfo[buildid][blLocked],
		BuildingInfo[buildid][blOutsideText],
		BuildingInfo[buildid][blInsideText],
		BuildingInfo[buildid][blOutsideX],
		BuildingInfo[buildid][blOutsideY],
		BuildingInfo[buildid][blOutsideZ],
		BuildingInfo[buildid][blOutsideAngle],
		BuildingInfo[buildid][blOutsideInt],
		BuildingInfo[buildid][blOutsideWorld],
		BuildingInfo[buildid][blInsideX],
		BuildingInfo[buildid][blInsideY],
		BuildingInfo[buildid][blInsideZ],
		BuildingInfo[buildid][blInsideAngle],
		BuildingInfo[buildid][blInsideInt],
		BuildingInfo[buildid][blInsideWorld],
		BuildingInfo[buildid][blOusidePickupModel]
	);
	mysql_tquery(MYSQL_HANDLE, query);
}

Bld_SQLSaveFaction(buildid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `buildings` SET `blFaction`='%i' WHERE `blID`=%i;", BuildingInfo[buildid][blFaction], buildid);
}

Bld_SQLSaveLocked(buildid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `buildings` SET `blLocked`='%i' WHERE `blID`=%i;", BuildingInfo[buildid][blLocked], buildid);
}

Bld_SQLSaveOutsideText(buildid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `buildings` SET `blOutsideText`='%e' WHERE `blID`=%i;", BuildingInfo[buildid][blOutsideText], buildid);
}

Bld_SQLSaveInsideText(buildid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `buildings` SET `blInsideText`='%e' WHERE `blID`=%i;", BuildingInfo[buildid][blInsideText], buildid);
}

Bld_SQLSaveInsidePoint(buildid) {
	mysql_f_tquery(MYSQL_HANDLE, 255, @Callback: "" @Format: "UPDATE `buildings` SET `blInsideX`=%f,`blInsideY`=%f,`blInsideZ`=%f,`blInsideAngle`=%f,`blInsideWorld`=%i,`blInsideInt`=%i WHERE `blID`=%i;",  BuildingInfo[buildid][blInsideX],  BuildingInfo[buildid][blInsideY],  BuildingInfo[buildid][blInsideZ],  BuildingInfo[buildid][blInsideAngle],	 BuildingInfo[buildid][blInsideWorld],  BuildingInfo[buildid][blInsideInt], buildid);
}

Bld_SQLSaveOutsidePoint(buildid) {
	mysql_f_tquery(MYSQL_HANDLE, 255, @Callback: "" @Format: "UPDATE `buildings` SET `blOutsideX`=%f,`blOutsideY`=%f,`blOutsideZ`=%f,`blOutsideAngle`=%f,`blOutsideWorld`=%i,`blOutsideInt`=%i WHERE `blID`=%i;",  BuildingInfo[buildid][blOutsideX],  BuildingInfo[buildid][blOutsideY],  BuildingInfo[buildid][blOutsideZ],  BuildingInfo[buildid][blOutsideAngle],  BuildingInfo[buildid][blOutsideWorld],  BuildingInfo[buildid][blOutsideInt], buildid);
}

Bld_SQLSavePickupModel(buildid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `buildings` SET `blOusidePickupModel`='%i' WHERE `blID`=%i;", BuildingInfo[buildid][blOusidePickupModel], buildid);
}

Bld_SQLSave(buildid)
{
	new query[1024];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"UPDATE `buildings` SET \
			`blFaction`=%i,\
			`blLocked`=%i,\
			`blOutsideText`='%e',\
			`blInsideText`='%e',\
			`blOutsideX`=%f,\
			`blOutsideY`=%f,\
			`blOutsideZ`=%f,\
			`blOutsideAngle`=%f,\
			`blOutsideInt`=%i,\
			`blOutsideWorld`=%i,\
			`blInsideX`=%f,\
			`blInsideY`=%f,\
			`blInsideZ`=%f,\
			`blInsideAngle`=%f,\
			`blInsideInt`=%i,\
			`blInsideWorld`=%i,\
			`blOusidePickupModel`=%i \
		WHERE \
			`blID`=%i;",
		BuildingInfo[buildid][blFaction],
		BuildingInfo[buildid][blLocked],
		BuildingInfo[buildid][blOutsideText],
		BuildingInfo[buildid][blInsideText],
		BuildingInfo[buildid][blOutsideX],
		BuildingInfo[buildid][blOutsideY],
		BuildingInfo[buildid][blOutsideZ],
		BuildingInfo[buildid][blOutsideAngle],
		BuildingInfo[buildid][blOutsideInt],
		BuildingInfo[buildid][blOutsideWorld],
		BuildingInfo[buildid][blInsideX],
		BuildingInfo[buildid][blInsideY],
		BuildingInfo[buildid][blInsideZ],
		BuildingInfo[buildid][blInsideAngle],
		BuildingInfo[buildid][blInsideInt],
		BuildingInfo[buildid][blInsideWorld],
		BuildingInfo[buildid][blOusidePickupModel],
		buildid
	);

	mysql_tquery(MYSQL_HANDLE, query);
}

Bld_SaveAll()
{
	new buildamount;
	foreach(new buildid : BuildingInfo)
	{
		Bld_SQLSave(buildid);
		buildamount++;
	}

	printf("[INFO] %i Edificios guardados.", buildamount);
	return 1;
}