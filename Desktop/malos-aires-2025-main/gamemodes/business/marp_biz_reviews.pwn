#if defined _marp_biz_reviews_included
	#endinput
#endif
#define _marp_biz_reviews_included

#include <YSI_Coding\y_hooks>

// Rating stored as integer * 10 (e.g. 42 = 4.2 stars)
new BusinessRating[MAX_BUSINESS];
new BusinessReviewCount[MAX_BUSINESS];

static BizReviewedThisSession[MAX_PLAYERS];
static BizReviewPending[MAX_PLAYERS]; // bizid pending review dialog

forward BizReview_OnLoadAll();

// Load reviews AFTER businesses are marked as loaded (avoids Biz_IsValidId race)
hook Biz_OnAllDataLoaded()
{
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "BizReview_OnLoadAll" @Format: "SELECT `bizid`, ROUND(AVG(`rating`) * 10) AS avg_rating, COUNT(*) AS cnt FROM `biz_reviews` GROUP BY `bizid`;");
	return 1;
}

public BizReview_OnLoadAll()
{
	new rows = cache_num_rows();
	for(new row = 0; row < rows; row++)
	{
		new bizid;
		cache_get_value_name_int(row, "bizid", bizid);
		if(Biz_IsValidId(bizid)) {
			cache_get_value_name_int(row, "avg_rating", BusinessRating[bizid]);
			cache_get_value_name_int(row, "cnt", BusinessReviewCount[bizid]);
		}
	}
	printf("[INFO] Carga de reseñas de negocios finalizada.");
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	BizReviewedThisSession[playerid] = 0;
	BizReviewPending[playerid] = 0;
	return 1;
}

BizReview_OnPlayerEnter(playerid, bizid)
{
	if(!Biz_IsValidId(bizid) || !IsPlayerLogged(playerid))
		return;
	if(BizReviewedThisSession[playerid] == bizid)
		return;
	if(Business[bizid][bOwnerSQLID] == -1)
		return;

	SendClientMessage(playerid, COLOR_INFO, "[NEGOCIO] "COLOR_EMB_GREY"¿Qué te pareció este negocio? Usá /puntuar para puntuarlo.");
}

BizReview_GetStars(bizid, str[], len)
{
	if(BusinessReviewCount[bizid] == 0) {
		strcat(str, "Sin reseñas aún", len);
		return;
	}
	new avgInt = BusinessRating[bizid] / 10;
	new avgDec = BusinessRating[bizid] - avgInt * 10;
	format(str, len, "%i.%i/5 (%i reseñas)", avgInt, avgDec, BusinessReviewCount[bizid]);
}

CMD:puntuar(playerid, params[])
{
	new bizid = Biz_IsPlayerInsideAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encontrás dentro de un negocio.");
	if(Business[bizid][bOwnerSQLID] == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Este negocio no tiene dueño.");

	BizReviewPending[playerid] = bizid;
	Dialog_Open(playerid, "DLG_BizReview", DIALOG_STYLE_LIST, "Puntuación del negocio", "1 estrella - Muy malo\n2 estrellas - Malo\n3 estrellas - Regular\n4 estrellas - Bueno\n5 estrellas - Excelente", "Enviar", "Cancelar");
	return 1;
}

Dialog:DLG_BizReview(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;

	new bizid = BizReviewPending[playerid];
	BizReviewPending[playerid] = 0;
	if(!Biz_IsValidId(bizid)) return 1;

	new rating = listitem + 1;
	BizReviewedThisSession[playerid] = bizid;

	mysql_f_tquery(MYSQL_HANDLE, 256, @Callback: "BizReview_OnSaved", "iii", playerid, bizid, rating @Format: "INSERT INTO `biz_reviews` (`bizid`, `pID`, `rating`) VALUES (%i, %i, %i) ON DUPLICATE KEY UPDATE `rating`=%i;", bizid, PlayerInfo[playerid][pID], rating, rating);
	return 1;
}

CALLBACK:BizReview_OnSaved(playerid, bizid, rating)
{
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "BizReview_OnAvgLoaded", "i", bizid @Format: "SELECT ROUND(AVG(`rating`) * 10) AS avg_rating, COUNT(*) AS cnt FROM `biz_reviews` WHERE `bizid`=%i;", bizid);
	if(IsPlayerLogged(playerid))
		SendFMessage(playerid, COLOR_INFO, "[NEGOCIO] "COLOR_EMB_GREY"Reseña enviada! Le diste %i estrella(s) a %s.", rating, Biz_GetName(bizid));
	return 1;
}

CALLBACK:BizReview_OnAvgLoaded(bizid)
{
	if(!cache_num_rows()) return 0;
	cache_get_value_name_int(0, "avg_rating", BusinessRating[bizid]);
	cache_get_value_name_int(0, "cnt", BusinessReviewCount[bizid]);
	return 1;
}

