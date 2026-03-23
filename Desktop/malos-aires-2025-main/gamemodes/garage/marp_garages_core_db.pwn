#if defined _marp_garages_core_db_inc
	#endinput
#endif
#define _marp_garages_core_db_inc

Garage_LoadAll()
{
    mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "Garage_OnDataLoadAll" @Format: "SELECT * FROM `garages` LIMIT %i;", MAX_GARAGES -1);
	print("[INFO] Cargando garages...");
	return 1;
}

CALLBACK:Garage_OnDataLoadAll()
{
    new rows = cache_num_rows();

    for(new row, garageid; row < rows; row++)
	{
        cache_get_value_name_int(row, "gID", garageid);
    
		cache_get_value_name_int(row, "gType", GarageInfo[garageid][gType]);
        cache_get_value_name_int(row, "gExtraId", GarageInfo[garageid][gExtraId]);
        cache_get_value_name_int(row, "gLocked", GarageInfo[garageid][gLocked]);
		
        cache_get_value_name_float(row, "gOutsideX", GarageInfo[garageid][gOutsideX]);
		cache_get_value_name_float(row, "gOutsideY", GarageInfo[garageid][gOutsideY]);
		cache_get_value_name_float(row, "gOutsideZ", GarageInfo[garageid][gOutsideZ]);
		cache_get_value_name_float(row, "gOutsideAng", GarageInfo[garageid][gOutsideAng]);
		cache_get_value_name_int(row, "gOutsideVW", GarageInfo[garageid][gOutsideVW]);
		cache_get_value_name_int(row, "gOutsideInt", GarageInfo[garageid][gOutsideInt]);

        cache_get_value_name_float(row, "gOutsideAreaX", GarageInfo[garageid][gOutsideAreaX]);
		cache_get_value_name_float(row, "gOutsideAreaY", GarageInfo[garageid][gOutsideAreaY]);
		cache_get_value_name_float(row, "gOutsideAreaZ", GarageInfo[garageid][gOutsideAreaZ]);

		cache_get_value_name_float(row, "gInsideX", GarageInfo[garageid][gInsideX]);
		cache_get_value_name_float(row, "gInsideY", GarageInfo[garageid][gInsideY]);
		cache_get_value_name_float(row, "gInsideZ", GarageInfo[garageid][gInsideZ]);
		cache_get_value_name_float(row, "gInsideAng", GarageInfo[garageid][gInsideAng]);
		cache_get_value_name_int(row, "gInsideVW", GarageInfo[garageid][gInsideVW]);
		cache_get_value_name_int(row, "gInsideInt", GarageInfo[garageid][gInsideInt]);

        cache_get_value_name_float(row, "gInsideAreaX", GarageInfo[garageid][gInsideAreaX]);
		cache_get_value_name_float(row, "gInsideAreaY", GarageInfo[garageid][gInsideAreaY]);
		cache_get_value_name_float(row, "gInsideAreaZ", GarageInfo[garageid][gInsideAreaZ]);
    
		Iter_Add(GarageInfo, garageid);
		Garage_ReloadAreas(garageid);

        CallLocalFunction("Garage_OnIdDataLoaded", "ii", garageid, row);
    }

    printf("[INFO] Carga de %i garajes finalizada.", rows);
	CallLocalFunction("Garage_OnAllDataLoaded", "");
    return 1;
}

CALLBACK:Garage_OnIdDataLoaded(garageid, cacherow) {
	return 1;
}

CALLBACK:Garage_OnAllDataLoaded() {
	return 1;
}

Garage_SQLDelete(garageid) {
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "" @Format: "DELETE FROM `garages` WHERE `gID`=%i;", garageid);
}

Garage_SQLCreate(garageid)
{
	new query[1024];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `garages` \
			(`gID`,\
			`gType`,\
			`gExtraId`,\
			`gLocked`,\
			`gOutsideX`,\
			`gOutsideY`,\
			`gOutsideZ`,\
			`gOutsideAng`,\
			`gOutsideVW`,\
			`gOutsideInt`,\
			`gOutsideAreaX`,\
			`gOutsideAreaY`,\
			`gOutsideAreaZ`,\
			`gInsideX`,\
			`gInsideY`,\
			`gInsideZ`,\
			`gInsideAng`,\
			`gInsideVW`,\
			`gInsideInt`,\
			`gInsideAreaX`,\
			`gInsideAreaY`,\
			`gInsideAreaZ`)\
		VALUES \
			(%i,%i,%i,'%i','%f',%f,%f,%f,%i,%i,%f,%f,%f,'%f',%f,%f,%f,%i,%i,%f,%f,%f);",
		garageid,
		GarageInfo[garageid][gType],
        GarageInfo[garageid][gExtraId],
        GarageInfo[garageid][gLocked],
        GarageInfo[garageid][gOutsideX],
		GarageInfo[garageid][gOutsideY],
		GarageInfo[garageid][gOutsideZ],
		GarageInfo[garageid][gOutsideAng],
		GarageInfo[garageid][gOutsideVW],
		GarageInfo[garageid][gOutsideInt],
        GarageInfo[garageid][gOutsideAreaX],
		GarageInfo[garageid][gOutsideAreaY],
		GarageInfo[garageid][gOutsideAreaZ],
		GarageInfo[garageid][gInsideX],
		GarageInfo[garageid][gInsideY],
		GarageInfo[garageid][gInsideZ],
		GarageInfo[garageid][gInsideAng],
		GarageInfo[garageid][gInsideVW],
		GarageInfo[garageid][gInsideInt],
		GarageInfo[garageid][gInsideAreaX],
		GarageInfo[garageid][gInsideAreaY],
		GarageInfo[garageid][gInsideAreaZ]
	);
	mysql_tquery(MYSQL_HANDLE, query);
}

Garage_SQLSaveType(garageid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `garages` SET `gType`='%i' WHERE `gID`=%i;", GarageInfo[garageid][gType], garageid);
}

Garage_SQLSaveExtraId(garageid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `garages` SET `gExtraId`='%i' WHERE `gID`=%i;", GarageInfo[garageid][gExtraId], garageid);
}

Garage_SQLSaveLocked(garageid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `garages` SET `gLocked`='%i' WHERE `gID`=%i;", GarageInfo[garageid][gLocked], garageid);
}

Garage_SQLSaveInsidePoint(garageid) {
	mysql_f_tquery(MYSQL_HANDLE, 255, @Callback: "" @Format: "UPDATE `garages` SET `gInsideX`=%f,`gInsideY`=%f,`gInsideZ`=%f,`gInsideAng`=%f,`gInsideVW`=%i,`gInsideInt`=%i WHERE `gID`=%i;", GarageInfo[garageid][gInsideX], GarageInfo[garageid][gInsideY], GarageInfo[garageid][gInsideZ], GarageInfo[garageid][gInsideAng], GarageInfo[garageid][gInsideVW], GarageInfo[garageid][gInsideInt], garageid);
}

Garage_SQLSaveOutsidePoint(garageid) {
	mysql_f_tquery(MYSQL_HANDLE, 255, @Callback: "" @Format: "UPDATE `garages` SET `gOutsideX`=%f,`gOutsideY`=%f,`gOutsideZ`=%f,`gOutsideAng`=%f,`gOutsideVW`=%i,`gOutsideInt`=%i WHERE `gID`=%i;", GarageInfo[garageid][gOutsideX], GarageInfo[garageid][gOutsideY], GarageInfo[garageid][gOutsideZ], GarageInfo[garageid][gOutsideAng], GarageInfo[garageid][gOutsideVW], GarageInfo[garageid][gOutsideInt], garageid);
}

Garage_SQLSaveInsideArea(garageid) {
	mysql_f_tquery(MYSQL_HANDLE, 255, @Callback: "" @Format: "UPDATE `garages` SET `gInsideAreaX`=%f,`gInsideAreaY`=%f,`gInsideAreaZ`=%f WHERE `gID`=%i;", GarageInfo[garageid][gInsideAreaX], GarageInfo[garageid][gInsideAreaY], GarageInfo[garageid][gInsideAreaZ], garageid);
}

Garage_SQLSaveOutsideArea(garageid) {
	mysql_f_tquery(MYSQL_HANDLE, 255, @Callback: "" @Format: "UPDATE `garages` SET `gOutsideAreaX`=%f,`gOutsideAreaY`=%f,`gOutsideAreaZ`=%f WHERE `gID`=%i;", GarageInfo[garageid][gOutsideAreaX], GarageInfo[garageid][gOutsideAreaY], GarageInfo[garageid][gOutsideAreaZ], garageid);
}

Garage_SQLSave(garageid)
{
	new query[1024];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"UPDATE `garages` SET\
			`gType`=%i,\
			`gExtraId`=%i,\
			`gLocked`=%i,\
			`gOutsideX`=%f,\
			`gOutsideY`=%f,\
			`gOutsideZ`=%f,\
			`gOutsideAng`=%f,\
			`gOutsideVW`=%i,\
			`gOutsideInt`=%i,\
			`gOutsideAreaX`=%f,\
			`gOutsideAreaY`=%f,\
			`gOutsideAreaZ`=%f,\
			`gInsideX`=%f,\
			`gInsideY`=%f,\
			`gInsideZ`=%f,\
			`gInsideAng`=%f,\
			`gInsideVW`=%i,\
			`gInsideInt`=%i,\
			`gInsideAreaX`=%f,\
			`gInsideAreaY`=%f,\
			`gInsideAreaZ`=%f\
		WHERE \
			`gID`=%i;",
		GarageInfo[garageid][gType],
        GarageInfo[garageid][gExtraId],
        GarageInfo[garageid][gLocked],
        GarageInfo[garageid][gOutsideX],
		GarageInfo[garageid][gOutsideY],
		GarageInfo[garageid][gOutsideZ],
		GarageInfo[garageid][gOutsideAng],
		GarageInfo[garageid][gOutsideVW],
		GarageInfo[garageid][gOutsideInt],
        GarageInfo[garageid][gOutsideAreaX],
		GarageInfo[garageid][gOutsideAreaY],
		GarageInfo[garageid][gOutsideAreaZ],
		GarageInfo[garageid][gInsideX],
		GarageInfo[garageid][gInsideY],
		GarageInfo[garageid][gInsideZ],
		GarageInfo[garageid][gInsideAng],
		GarageInfo[garageid][gInsideVW],
		GarageInfo[garageid][gInsideInt],
		GarageInfo[garageid][gInsideAreaX],
		GarageInfo[garageid][gInsideAreaY],
		GarageInfo[garageid][gInsideAreaZ],
		garageid
	);

	mysql_tquery(MYSQL_HANDLE, query);
}

Garage_SaveAll()
{
	new garageamount;
	foreach(new garageid : GarageInfo)
	{
		Garage_SQLSave(garageid);
		garageamount++;
	}

	printf("[INFO] %i Garages guardados.", garageamount);
	return 1;
}