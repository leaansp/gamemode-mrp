#if defined _marp_actors_included
	#endinput
#endif
#define _marp_actors_included

#include <YSI_Coding\y_hooks>

#define ACTOR_NICKNAME_MAX_LENGTH 128
#define ACTOR_DESC_MAX_LENGTH 128
#define ACTOR_ANIM_LIB_MAX_LENGTH 32
#define ACTOR_ANIM_NAME_MAX_LENGTH 32

enum e_ActorInactiveHoursFlags:(<<= 1) {
    HOUR_1 = 1, HOUR_2, HOUR_3, HOUR_4, HOUR_5, HOUR_6, HOUR_7, HOUR_8, HOUR_9, HOUR_10, HOUR_11, HOUR_12, HOUR_13,
    HOUR_14, HOUR_15, HOUR_16, HOUR_17, HOUR_18, HOUR_19, HOUR_20, HOUR_21, HOUR_22, HOUR_23, HOUR24
};

enum e_ActorInfo {
	ai_SQLID,
	ai_Nickname[ACTOR_NICKNAME_MAX_LENGTH],
	ai_Description[ACTOR_DESC_MAX_LENGTH],
	ai_LifeTime,
	ai_Interior,
	Text3D:ai_LabelID,
	e_ActorInactiveHoursFlags:ai_InactiveHours,
	ai_AnimLib[ACTOR_ANIM_LIB_MAX_LENGTH],
	ai_AnimName[ACTOR_ANIM_NAME_MAX_LENGTH],
	ai_AnimLoop
};

static ActorInfo[MAX_ACTORS][e_ActorInfo];

static Actor_GetInterior(actorid) {
	return (IsValidActor(actorid)) ? (ActorInfo[actorid][ai_Interior]) : (0);
}

Actor_NewPermanent(skin, Float:x, Float:y, Float:z, Float:angle, interior, vworld)
{
	new actorid = Actor_New(skin, x, y, z, angle, interior, vworld);

	if(actorid == INVALID_ACTOR_ID) {
		return INVALID_ACTOR_ID;
	}

	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO actors (skin, x, y, z, angle, interior, vworld) VALUES (%i, %f, %f, %f, %f, %i, %i)", skin, x, y, z, angle, interior, vworld);
	mysql_tquery(MYSQL_HANDLE, query, "OnActorDatabaseInsertion", "i", actorid);
	return actorid;
}

forward OnActorDatabaseInsertion(actorid);
public OnActorDatabaseInsertion(actorid) {
	ActorInfo[actorid][ai_SQLID] = cache_insert_id();
	return 1;
}

Actor_NewTemporal(skin, Float:x, Float:y, Float:z, Float:angle, interior, vworld, time)
{
	new actorid = Actor_New(skin, x, y, z, angle, interior, vworld);

	if(actorid == INVALID_ACTOR_ID) {
		return INVALID_ACTOR_ID;
	}

	ActorInfo[actorid][ai_LifeTime] = (!time) ? (0) : (gettime() + time);
	return actorid;
}

Actor_New(skin, Float:x, Float:y, Float:z, Float:angle, interior, vworld)
{
	new actorid = CreateActor(skin, x, y, z, angle);

	if(actorid == INVALID_ACTOR_ID) {
		return INVALID_ACTOR_ID;
	}

	SetActorVirtualWorld(actorid, vworld);
	SetActorFacingAngle(actorid, angle);
	SetActorHealth(actorid, 100.0);
	SetActorInvulnerable(actorid, true);
	ActorInfo[actorid][ai_Interior] = interior;
	ActorInfo[actorid][ai_LabelID] = Text3D:INVALID_3DTEXT_ID;
	ActorInfo[actorid][ai_SQLID] = 0;
	ActorInfo[actorid][ai_LifeTime] = 0;
	ActorInfo[actorid][ai_InactiveHours] = e_ActorInactiveHoursFlags:0;
	return actorid;
}

Actor_Delete(actorid)
{
	if(IsValidActor(actorid))
	{
		DestroyActor(actorid);

		if(ActorInfo[actorid][ai_LabelID] != Text3D:INVALID_3DTEXT_ID && IsValidDynamic3DTextLabel(ActorInfo[actorid][ai_LabelID])) {
			DestroyDynamic3DTextLabel(ActorInfo[actorid][ai_LabelID]);
		}

		if(ActorInfo[actorid][ai_SQLID]) {
			new query[64];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), "DELETE FROM actors WHERE id=%d", ActorInfo[actorid][ai_SQLID]);
			mysql_tquery(MYSQL_HANDLE, query);
		}
		ActorInfo[actorid][ai_SQLID] = 0;
		ActorInfo[actorid][ai_LabelID] = Text3D:INVALID_3DTEXT_ID;
	    return 1;
	}
	return 0;
}

Actor_ReloadLabel(actorid)
{
	if(IsValidActor(actorid))
	{
		if(ActorInfo[actorid][ai_LabelID] != Text3D:INVALID_3DTEXT_ID && IsValidDynamic3DTextLabel(ActorInfo[actorid][ai_LabelID])) {
			DestroyDynamic3DTextLabel(ActorInfo[actorid][ai_LabelID]);
		}

		new Float:x, Float:y, Float:z;
		GetActorPos(actorid, x, y, z);
		ActorInfo[actorid][ai_LabelID] = CreateDynamic3DTextLabel(ActorInfo[actorid][ai_Nickname], COLOR_WHITE, x, y, z + 1.2, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GetActorVirtualWorld(actorid), -1, -1, 30.0);
	}
}

Actor_SetNickname(actorid, const nickname[], bool:save = true)
{
	if(!isnull(nickname))
	{
		ActorInfo[actorid][ai_Nickname][0] = '\0';
		strcat(ActorInfo[actorid][ai_Nickname], nickname, ACTOR_NICKNAME_MAX_LENGTH);

		Actor_ReloadLabel(actorid);

		if(save && ActorInfo[actorid][ai_SQLID])
		{
			new query[256];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE actors SET nick='%e' WHERE id=%i", nickname, ActorInfo[actorid][ai_SQLID]);
			mysql_tquery(MYSQL_HANDLE, query);
		}
	}
}

Actor_SetDescription(actorid, const description[], bool:save = true)
{
	if(!isnull(description))
	{
		ActorInfo[actorid][ai_Description][0] = '\0';
		strcat(ActorInfo[actorid][ai_Description], description, ACTOR_DESC_MAX_LENGTH);
		
		if(save && ActorInfo[actorid][ai_SQLID]) {
			new query[256];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE actors SET description='%e' WHERE id=%i", description, ActorInfo[actorid][ai_SQLID]);
			mysql_tquery(MYSQL_HANDLE, query);
		}
	}
}

Actor_SetAnim(actorid, const animlib[], const animname[], bool:animloop, bool:save = true)
{
	if(!isnull(animlib) && !isnull(animname))
	{
		ActorInfo[actorid][ai_AnimLib][0] = '\0';
		ActorInfo[actorid][ai_AnimName][0] = '\0';
		strcat(ActorInfo[actorid][ai_AnimLib], animlib, ACTOR_ANIM_LIB_MAX_LENGTH);
		strcat(ActorInfo[actorid][ai_AnimName], animname, ACTOR_ANIM_NAME_MAX_LENGTH);

		ApplyActorAnimation(actorid, ActorInfo[actorid][ai_AnimLib], ActorInfo[actorid][ai_AnimName], 4.1, animloop, 1, 1, 0, 0);

		if(save && ActorInfo[actorid][ai_SQLID]) {
			new query[256];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE actors SET animlib='%e', animname='%e', animloop=%i WHERE id=%i", animlib, animname, _:animloop, ActorInfo[actorid][ai_SQLID]);
			mysql_tquery(MYSQL_HANDLE, query);
		}
	}
}

Actor_SetInactiveHours(actorid, e_ActorInactiveHoursFlags:hours, bool:save = true)
{
	ActorInfo[actorid][ai_InactiveHours] = hours;

	if(save && ActorInfo[actorid][ai_SQLID]) {
		new query[64];
		mysql_format(MYSQL_HANDLE, query, sizeof(query), "UPDATE actors SET inactive_hours=%i WHERE id=%i", hours, ActorInfo[actorid][ai_SQLID]);
		mysql_tquery(MYSQL_HANDLE, query);
	}
}

hook OnGameModeInitEnded()
{
	mysql_tquery(MYSQL_HANDLE, "SELECT * FROM actors LIMIT 1000", "OnActorDataLoad", "");
	print("[INFO] Cargando actores ...");
	return 1;
}

forward OnActorDataLoad();
public OnActorDataLoad()
{
	new rows = cache_num_rows();

	if(!rows)
	{
		printf("[INFO] Finalizó la carga de %i actores.", rows);
		return 1;
	}

	new actorid, buffer_nick[ACTOR_NICKNAME_MAX_LENGTH], buffer_lib[ACTOR_ANIM_LIB_MAX_LENGTH], buffer_name[ACTOR_ANIM_NAME_MAX_LENGTH];

	for(new i = 0; i < rows; i++)
	{
		actorid = Actor_New(cache_name_int(i, "skin"),
							cache_name_float(i, "x"),
							cache_name_float(i, "y"),
							cache_name_float(i, "z"),
							cache_name_float(i, "angle"),
							cache_name_int(i, "interior"),
							cache_name_int(i, "vworld"));

		if(actorid == INVALID_ACTOR_ID)
			return print("[ERROR] No se ha podido cargar la totalidad de los actores de la base de datos. Límite alcanzado.");

		ActorInfo[actorid][ai_SQLID] = cache_name_int(i, "id");

		cache_get_value_name(i, "nick", buffer_nick, ACTOR_NICKNAME_MAX_LENGTH);
		cache_get_value_name(i, "description", ActorInfo[actorid][ai_Description], ACTOR_DESC_MAX_LENGTH);
		cache_get_value_name(i, "animlib", buffer_lib, ACTOR_ANIM_LIB_MAX_LENGTH);
		cache_get_value_name(i, "animname", buffer_name, ACTOR_ANIM_NAME_MAX_LENGTH);

		ActorInfo[actorid][ai_AnimLoop] = cache_name_int(i, "animloop");
		ActorInfo[actorid][ai_InactiveHours] = e_ActorInactiveHoursFlags:cache_name_int(i, "inactive_hours");

		Actor_SetNickname(actorid, buffer_nick, false);
		Actor_SetAnim(actorid, buffer_lib, buffer_name, bool:ActorInfo[actorid][ai_AnimLoop], false);
	}

	printf("[INFO] Finalizó la carga de %i actores.", rows);
	return 1;
}


CMD:aanombre(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new actorid, nickname[128];

	if(sscanf(params, "is[128]", actorid, nickname))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aanombre [id de actor] [nombre]. El caracter '_' (guión bajo) es bajada de linea, solo una vez.");
	if(!IsValidActor(actorid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Actor inválido o no existe.");

	new charpos = strfind(nickname, "_", true);
	if(charpos != -1)
	    nickname[charpos] = 10; // Codigo decimal para el caracter 'bajada de linea' en el codigo ASCII.
	
	Actor_SetNickname(actorid, nickname);
	SendFMessage(playerid, COLOR_WHITE, "[INFO]: has seteado el nombre del actor %i a '%s'.", actorid, nickname);	
	return 1;
}

CMD:aadesc(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new actorid, description[128];

	if(sscanf(params, "is[128]", actorid, description))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aadesc [id de actor] [Descripción ooc]");
	if(!IsValidActor(actorid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Actor inválido o no existe.");

	Actor_SetDescription(actorid, description);
	SendFMessage(playerid, COLOR_WHITE, "[INFO]: has seteado la Descripción OOC del actor %i a '%s'.", actorid, description);
	return 1;
}

CMD:aacreartemp(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new skin, time;

	if(sscanf(params, "ii", skin, time))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aacrear [id skin] [tiempo de vida en segundos] (use 0 para que viva hasta el apagado de servidor).");
	if(!IsValidSkin(skin) || time < 0)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de skin inválida (se acepta de 1 a 311) o cantidad de tiempo inválida.");

	new Float:x, Float:y, Float:z, Float:angle, actorid;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	if((actorid = Actor_NewTemporal(skin, x, y, z, angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), time)) == INVALID_ACTOR_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Límite de actores alcanzado, por favor reporte el error.");

	SetPlayerPos(playerid, x + 0.7, y, z);
	SendFMessage(playerid, COLOR_WHITE, "[INFO]: actor id %i con skin %i creado correctamente en el mundo virtual %i con una vida de %i segundos.", actorid, skin, GetPlayerVirtualWorld(playerid), time);
	return 1;
}

CMD:aacrearperma(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new skin;

	if(sscanf(params, "i", skin))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aacrear [id skin]");
	if(!IsValidSkin(skin))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ingresa una ID de skin válida (1-311).");

	new Float:x, Float:y, Float:z, Float:angle, actorid;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	if((actorid = Actor_NewPermanent(skin, x, y, z, angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid))) == INVALID_ACTOR_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Límite de actores alcanzado, por favor reporte el error.");

	SetPlayerPos(playerid, x + 0.7, y, z);
	SendFMessage(playerid, COLOR_WHITE, "[INFO]: actor id %i con skin %i creado correctamente en el mundo virtual %i.", actorid, skin, GetPlayerVirtualWorld(playerid));
	return 1;
}

CMD:aaanim(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new animlib[32], animname[32], animloop, actorid;

	if(sscanf(params, "iis[32] s[32]", actorid, animloop, animlib, animname))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aaanim [id de actor] [loop de anim] [librería de anim] [nombre de anim] (ver en 'wiki.sa-mp.com/wiki/Animations')");
	if(!IsValidActor(actorid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Actor inválido o no existe.");
	if(animloop < 0 || animloop > 1)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"En el campo 'loop de anim' elija el valor 1 o 0.");

	Actor_SetAnim(actorid, animlib, animname, bool:animloop);
	SendFMessage(playerid, COLOR_WHITE, "[INFO]: has seteado la animación del actor %d a la '%s' de la librería '%s' con loop en %d.", actorid, animname, animlib, animloop);
	return 1;
}

Actor_GetClosestInRange(playerid, Float:range)
{
	new Float:x, Float:y, Float:z;

	for(new i = 0, actorpool = GetActorPoolSize(); i <= actorpool; i++)
	{
		if(IsValidActor(i))
		{
		    GetActorPos(i, x, y, z);

		    if(GetPlayerVirtualWorld(playerid) == GetActorVirtualWorld(i)) {
			    if(IsPlayerInRangeOfPoint(playerid, range, x, y, z)) {
			        return i;
				}
			}
		}
	}

	return INVALID_ACTOR_ID;
}

CMD:aagetid(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new closest;

	if((closest = Actor_GetClosestInRange(playerid, 2.0)) != INVALID_ACTOR_ID) {
		SendFMessage(playerid, COLOR_WHITE, "La id del actor cercano es %i.", closest);
	} else {
		SendClientMessage(playerid, COLOR_WHITE, "No se ha encontrado ningún actor válido cerca tuyo (2.0 unidades SAMP de cercanía).");
	}
	return 1;
}

CMD:aatele(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new actorid, Float:x, Float:y, Float:z;
	
	if(sscanf(params, "i", actorid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aatele [id de actor]");
	if(!IsValidActor(actorid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Actor inválido o no existe.");
	
	GetActorPos(actorid, x, y, z);
	SetPlayerVirtualWorld(playerid, GetActorVirtualWorld(actorid));
	SetPlayerPos(playerid, x + 0.7, y, z);
	SetPlayerInterior(playerid, Actor_GetInterior(actorid));
	return 1;
}

CMD:aaborrar(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new actorid;

	if(sscanf(params, "i", actorid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aaborrar [id de actor]");
	if(!IsValidActor(actorid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Actor inválido o no existe.");

	if(Actor_Delete(actorid)) {
		SendFMessage(playerid, COLOR_WHITE, "[INFO]: has borrado el actor %i correctamente.", actorid);
	} else {
    	SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Hubo un error con el borrado del actor.");
    }
	return 1;
}

CMD:aahoras(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new actorid, hours;

	if(sscanf(params, "ib", actorid, hours)) {
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aahoras [id de actor] [horas inactivo] (valor binario secuencial de 1 a 24, derecha a izquierda).");
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "{C8C8C8}Ejemplo: 110001 significa desactivar las horas 1,5, y 6 (por omisión, de 6 a 24 quedan activas).");
	}
	if(!IsValidActor(actorid) || hours > 16777215) // 2^24
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Actor inválido o más de 24 bits fueron ingresados.");

	Actor_SetInactiveHours(actorid, e_ActorInactiveHoursFlags:hours);
	SendFMessage(playerid, COLOR_WHITE, "[INFO]: has seteado para el actor %i las horas inactivas %b correctamente.", actorid, hours);
	return 1;
}