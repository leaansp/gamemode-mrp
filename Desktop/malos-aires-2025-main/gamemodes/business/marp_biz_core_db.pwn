#if defined _marp_biz_core_db_included
	#endinput
#endif
#define _marp_biz_core_db_included

LoadAllBusiness()
{
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "Biz_OnDataLoadAll" @Format: "SELECT * FROM `business` LIMIT %i;", MAX_BUSINESS - 1);
	print("[INFO] Cargando negocios...");
	return 1;
}

forward Biz_OnDataLoadAll();
public Biz_OnDataLoadAll()
{
	new rows = cache_num_rows();

	for(new row, bizid; row < rows; row++)
	{
		cache_get_value_name_int(row, "bID", bizid);

		cache_get_value_name(row, "bName", Business[bizid][bName], BIZ_MAX_NAME_LENGTH);
		cache_get_value_name(row, "bOwnerName", Business[bizid][bOwner], MAX_PLAYER_NAME);

		cache_get_value_name_int(row, "bOwnerID", Business[bizid][bOwnerSQLID]);
		cache_get_value_name_int(row, "bEnterable", Business[bizid][bEnterable]);
		cache_get_value_name_int(row, "bPrice", Business[bizid][bPrice]);
		cache_get_value_name_int(row, "bEntranceCost", Business[bizid][bEntranceFee]);
		cache_get_value_name_int(row, "bTill", Business[bizid][bTill]);
		cache_get_value_name_int(row, "bLocked", Business[bizid][bLocked]);
		cache_get_value_name_int(row, "bType", Business[bizid][bType]);
		cache_get_value_name_int(row, "bRadio", Business[bizid][bRadio]);

		cache_get_value_name_float(row, "bOutsideX", Business[bizid][bOutsideX]);
		cache_get_value_name_float(row, "bOutsideY", Business[bizid][bOutsideY]);
		cache_get_value_name_float(row, "bOutsideZ", Business[bizid][bOutsideZ]);
		cache_get_value_name_float(row, "bOutsideAngle", Business[bizid][bOutsideAngle]);
		cache_get_value_name_int(row, "bOutsideWorld", Business[bizid][bOutsideWorld]);
		cache_get_value_name_int(row, "bOutsideInt", Business[bizid][bOutsideInt]);

		cache_get_value_name_float(row, "bInsideX", Business[bizid][bInsideX]);
		cache_get_value_name_float(row, "bInsideY", Business[bizid][bInsideY]);
		cache_get_value_name_float(row, "bInsideZ", Business[bizid][bInsideZ]);
		cache_get_value_name_float(row, "bInsideAngle", Business[bizid][bInsideAngle]);
		cache_get_value_name_int(row, "bInsideWorld", Business[bizid][bInsideWorld]);
		cache_get_value_name_int(row, "bInsideInt", Business[bizid][bInsideInt]);

		cache_get_value_name_float(row, "bBuyingPointX", Business[bizid][bBuyingPointX]);
		cache_get_value_name_float(row, "bBuyingPointY", Business[bizid][bBuyingPointY]);
		cache_get_value_name_float(row, "bBuyingPointZ", Business[bizid][bBuyingPointZ]);

		cache_get_value_name_float(row, "bDelX", Business[bizid][bDelX]);
		cache_get_value_name_float(row, "bDelY", Business[bizid][bDelY]);
		cache_get_value_name_float(row, "bDelZ", Business[bizid][bDelZ]);

		Business[bizid][bLoaded] = true;

		Biz_ReloadAllPoints(bizid);

		CallLocalFunction("Biz_OnIdDataLoaded", "ii", bizid, row);
	}

	printf("[INFO] Carga de %i negocios finalizada.", rows);
	CallLocalFunction("Biz_OnAllDataLoaded", "");
	return 1;
}

forward Biz_OnIdDataLoaded(bizid, cacherow);
public Biz_OnIdDataLoaded(bizid, cacherow) {
	return 1;
}

forward Biz_OnAllDataLoaded();
public Biz_OnAllDataLoaded() {
	return 1;
}

Biz_SQLSaveName(bizid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `business` SET `bName`='%e' WHERE `bID`=%i;", Business[bizid][bName], bizid);
}

Biz_SQLSaveDelCP(bizid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `business` SET `bDelX`='%f', `bDelY`='%f', `bDelZ`='%f' WHERE `bID`=%i;", Business[bizid][bDelX], Business[bizid][bDelY], Business[bizid][bDelZ], bizid);
}

Biz_SQLSaveOwner(bizid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `business` SET `bOwnerID`=%i,`bOwnerName`='%s' WHERE `bID`=%i;", Business[bizid][bOwnerSQLID], Business[bizid][bOwner], bizid);
}

Biz_SQLSaveRadio(bizid) {
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "" @Format: "UPDATE `business` SET `bRadio`=%i WHERE `bID`=%i;", Business[bizid][bRadio], bizid);
}

Biz_SQLSavePrice(bizid) {
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "" @Format: "UPDATE `business` SET `bPrice`=%i WHERE `bID`=%i;", Business[bizid][bPrice], bizid);
}

Biz_SQLSaveType(bizid) {
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "" @Format: "UPDATE `business` SET `bType`=%i WHERE `bID`=%i;", Business[bizid][bType], bizid);
}

Biz_SQLSaveEntranceFee(bizid) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `business` SET `bEntranceCost`=%i WHERE `bID`=%i;", Business[bizid][bEntranceFee], bizid);
}

Biz_SQLSaveTill(bizid) {
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "" @Format: "UPDATE `business` SET `bTill`=%i WHERE `bID`=%i;", Business[bizid][bTill], bizid);
}

Biz_SQLSaveLocked(bizid) {
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "" @Format: "UPDATE `business` SET `bLocked`=%i WHERE `bID`=%i;", Business[bizid][bLocked], bizid);
}

Biz_SQLSaveEnterable(bizid) {
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "" @Format: "UPDATE `business` SET `bEnterable`=%i WHERE `bID`=%i;", Business[bizid][bEnterable], bizid);
}

Biz_SQLSaveInsidePoint(bizid) {
	mysql_f_tquery(MYSQL_HANDLE, 255, @Callback: "" @Format: "UPDATE `business` SET `bInsideX`=%f,`bInsideY`=%f,`bInsideZ`=%f,`bInsideAngle`=%f,`bInsideWorld`=%i,`bInsideInt`=%i WHERE `bID`=%i;", Business[bizid][bInsideX], Business[bizid][bInsideY], Business[bizid][bInsideZ], Business[bizid][bInsideAngle],	Business[bizid][bInsideWorld], Business[bizid][bInsideInt], bizid);
}

Biz_SQLSaveOutsidePoint(bizid) {
	mysql_f_tquery(MYSQL_HANDLE, 255, @Callback: "" @Format: "UPDATE `business` SET `bOutsideX`=%f,`bOutsideY`=%f,`bOutsideZ`=%f,`bOutsideAngle`=%f,`bOutsideWorld`=%i,`bOutsideInt`=%i WHERE `bID`=%i;", Business[bizid][bOutsideX], Business[bizid][bOutsideY], Business[bizid][bOutsideZ], Business[bizid][bOutsideAngle], Business[bizid][bOutsideWorld], Business[bizid][bOutsideInt], bizid);
}

Biz_SQLSaveBuyingPoint(bizid) {
	mysql_f_tquery(MYSQL_HANDLE, 255, @Callback: "" @Format: "UPDATE `business` SET `bBuyingPointX`=%f,`bBuyingPointY`=%f,`bBuyingPointZ`=%f WHERE `bID`=%i;", Business[bizid][bBuyingPointX], Business[bizid][bBuyingPointY], Business[bizid][bBuyingPointZ], bizid);
}

Biz_SQLDelete(bizid) {
	mysql_f_tquery(MYSQL_HANDLE, 64, @Callback: "" @Format: "DELETE FROM `business` WHERE `bID`=%i;", bizid);
}

Biz_SQLCreate(bizid) {
	new query[1024];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"INSERT INTO `business` \
			(`bID`,\
			`bType`,\
			`bPrice`,\
			`bName`,\
			`bOwnerID`,\
			`bOwnerName`,\
			`bOutsideX`,\
			`bOutsideY`,\
			`bOutsideZ`,\
			`bOutsideAngle`,\
			`bOutsideInt`,\
			`bOutsideWorld`,\
			`bInsideX`,\
			`bInsideY`,\
			`bInsideZ`,\
			`bInsideAngle`,\
			`bInsideInt`,\
			`bInsideWorld`,\
			`bEntranceCost`,\
			`bLocked`,\
			`bRadio`,\
			`bEnterable`, \
			`bDelX`,\
			`bDelY`,\
			`bDelZ`) \
		VALUES \
			(%i,%i,%i,'%e',%i,'%e',%f,%f,%f,%f,%i,%i,%f,%f,%f,%f,%i,%i,%i,%i,%i,%i,%f,%f,%f);",
		bizid,
		Business[bizid][bType],
		Business[bizid][bPrice],
		Business[bizid][bName],
		Business[bizid][bOwnerSQLID],
		Business[bizid][bOwner],
		Business[bizid][bOutsideX],
		Business[bizid][bOutsideY],
		Business[bizid][bOutsideZ],
		Business[bizid][bOutsideAngle],
		Business[bizid][bOutsideInt],
		Business[bizid][bOutsideWorld],
		Business[bizid][bInsideX],
		Business[bizid][bInsideY],
		Business[bizid][bInsideZ],
		Business[bizid][bInsideAngle],
		Business[bizid][bInsideInt],
		Business[bizid][bInsideWorld],
		Business[bizid][bEntranceFee],
		Business[bizid][bLocked],
		Business[bizid][bRadio],
		Business[bizid][bEnterable],
		Business[bizid][bDelX],
		Business[bizid][bDelY],
		Business[bizid][bDelZ]
	);
	mysql_tquery(MYSQL_HANDLE, query);
}

SaveAllBusiness()
{
	for(new bizid = 1; bizid < MAX_BUSINESS; bizid++)
	{
		if(Business[bizid][bLoaded]) {
			SaveBusiness(bizid);
		}
	}

	print("[INFO] Negocios guardados.");
	return 1;
}

SaveBusiness(bizid)
{
    new query[1024];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), \
		"UPDATE `business` SET \
			`bOwnerID`=%i,\
			`bEnterable`=%i,\
			`bPrice`=%i,\
			`bEntranceCost`=%i,\
			`bTill`=%i,\
			`bLocked`=%i,\
			`bRadio`=%i,\
			`bType`=%i,\
			`bOwnerName`='%s',\
			`bName`='%e',\
			`bOutsideX`=%f,\
			`bOutsideY`=%f,\
			`bOutsideZ`=%f,\
			`bOutsideAngle`=%f,\
			`bOutsideWorld`=%i,\
			`bOutsideInt`=%i,\
			`bInsideX`=%f,\
			`bInsideY`=%f,\
			`bInsideZ`=%f,\
			`bInsideAngle`=%f,\
			`bInsideWorld`=%i,\
			`bInsideInt`=%i,\
			`bBuyingPointX`=%f,\
			`bBuyingPointY`=%f,\
			`bBuyingPointZ`=%f \
		WHERE \
			`bID`=%i;",
		Business[bizid][bOwnerSQLID],
		Business[bizid][bEnterable],
		Business[bizid][bPrice],
		Business[bizid][bEntranceFee],
		Business[bizid][bTill],
		Business[bizid][bLocked],
		Business[bizid][bRadio],
		Business[bizid][bType],
		Business[bizid][bOwner],
		Business[bizid][bName],
		Business[bizid][bOutsideX],
		Business[bizid][bOutsideY],
		Business[bizid][bOutsideZ],
		Business[bizid][bOutsideAngle],
		Business[bizid][bOutsideWorld],
		Business[bizid][bOutsideInt],
		Business[bizid][bInsideX],
		Business[bizid][bInsideY],
		Business[bizid][bInsideZ],
		Business[bizid][bInsideAngle],
		Business[bizid][bInsideWorld],
		Business[bizid][bInsideInt],
		Business[bizid][bBuyingPointX],
		Business[bizid][bBuyingPointY],
		Business[bizid][bBuyingPointZ],
		bizid
	);

	mysql_tquery(MYSQL_HANDLE, query);
}