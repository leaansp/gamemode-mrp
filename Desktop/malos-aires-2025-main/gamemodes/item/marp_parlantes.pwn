#if defined _marp_parlantes_included
	#endinput
#endif
#define _marp_parlantes_included

//===============================CONSTANTES=====================================

#define VEC_TYPE_SPEAKER  			1000

#define VEC_INDEX_TYPE          0
#define VEC_INDEX_AREA          1
#define VEC_INDEX_OBJECT        2
#define VEC_INDEX_X             3
#define VEC_INDEX_Y             4
#define VEC_INDEX_Z             5
#define VEC_INDEX_VWORLD        6
#define VEC_INDEX_RADIO         7
#define VEC_INDEX_VOLUME        8

//==================================DATA========================================

new SERVER_SPEAKERS;

//==============================IMPLEMENTACION==================================

InitializeServerSpeakers()
{
	SERVER_SPEAKERS = vector_create();
}

CreateSpeaker(Float:x, Float:y, Float:z, Float:angle, vworld, modelid, radio, volume = 45)
{
	new id = vector_create();

	new STREAMER_TAG_AREA:areaid = CreateDynamicSphere(x, y, z, volume, vworld);
	Streamer_SetExtraIdArray(STREAMER_TYPE_AREA, areaid, STREAMER_ARRAY_TYPE_SPEAKER, id);

 	vector_push_back(id, VEC_TYPE_SPEAKER);
	vector_push_back(id, _:areaid);
	vector_push_back(id, CreateDynamicObject(modelid, x, y, z - 1, 0.0, 0.0, angle + 180, vworld));
	vector_push_back_float(id, x);
	vector_push_back_float(id, y);
	vector_push_back_float(id, z);
	vector_push_back(id, vworld);
	vector_push_back(id, radio);
	vector_push_back(id, volume);
	
	vector_push_back(SERVER_SPEAKERS, id);
	
	return id;
}

IsValidSpeaker(speaker_id)
{
	if(speaker_id > 0 && vector_size(speaker_id) > 8 && vector_get(speaker_id, VEC_INDEX_TYPE) == VEC_TYPE_SPEAKER)
		return 1;
	else
	    return 0;
}

DestroySpeaker(speaker_id)
{
	if(IsValidSpeaker(speaker_id))
	{
		new STREAMER_TAG_AREA:areaid = vector_get(speaker_id, VEC_INDEX_AREA);

	    foreach(new playerid : Player)
		{
			if(IsPlayerInDynamicArea(playerid, areaid) && Radio_IsOnType(playerid, RADIO_TYPE_SPEAKER)) {
			    Radio_Stop(playerid);
			}
		}

		DestroyDynamicObject(vector_get(speaker_id, VEC_INDEX_OBJECT));
		DestroyDynamicArea(areaid);
		vector_clear(speaker_id);

		new index = vector_find(SERVER_SPEAKERS, speaker_id);

		if(index >= 0) {
			vector_remove(SERVER_SPEAKERS, index);
		}

		return 1;
	}
	return 0;
}

PlaySpeakerForPlayer(playerid, speaker_id)
{
	if(IsValidSpeaker(speaker_id))
	{
	    Radio_SetEx(playerid, vector_get(speaker_id, VEC_INDEX_RADIO), RADIO_TYPE_SPEAKER, vector_get_float(speaker_id, VEC_INDEX_X), vector_get_float(speaker_id, VEC_INDEX_Y), vector_get_float(speaker_id, VEC_INDEX_Z), vector_get(speaker_id, VEC_INDEX_VOLUME));
	 	return 1;
	}
	return 0;
}

Speaker_OnPlayerEnterArea(playerid, speaker_id)
{
	if(!Radio_IsOn(playerid)) {
		PlaySpeakerForPlayer(playerid, speaker_id);
	}
}

Speaker_OnPlayerLeaveArea(playerid, speaker_id)
{
	#pragma unused speaker_id

	if(Radio_IsOnType(playerid, RADIO_TYPE_SPEAKER)) {
		Radio_Stop(playerid);
	}
}

//================================COMANDOS======================================

CMD:parlante(playerid, params[])
{
	new radio;

	if(sscanf(params, "i", radio))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/parlante [ID radio]. Se ubicará el equipo en el piso, reproduciendo la radio elegida.");
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar a pie.");
	if(GetHandItem(playerid, HAND_RIGHT) != ITEM_ID_PARLANTE)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener un equipo de música portátil en condiciones en tu mano derecha.");
	if(!Radio_IsValidId(radio))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ingresar una radio válida, utiliza '/radios' para ver las radios disponibles.");

	new vsize = vector_size(SERVER_SPEAKERS),
	    speaker_id;

	for(new i = 0; i < vsize; i++)
	{
	    speaker_id = vector_get(SERVER_SPEAKERS, i);
	    if(IsPlayerInRangeOfPoint(playerid, vector_get(speaker_id, VEC_INDEX_VOLUME) * 2 + 20, vector_get_float(speaker_id, VEC_INDEX_X), vector_get_float(speaker_id, VEC_INDEX_Y), vector_get_float(speaker_id, VEC_INDEX_Z)))
	    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Hay otro equipo de música activo en la cercanía, aléjate más o busca otro lugar");
	}

	new Float:px, Float:py, Float:pz, Float:pangle;
	GetPlayerPos(playerid, px, py, pz);
	GetPlayerFacingAngle(playerid, pangle);

	PlayerActionMessage(playerid, 15.0, "apoya un equipo portátil de música en el piso y lo prende.");
	ApplyAnimationEx(playerid, "BOMBER", "BOM_PLANT", 4.0, 0, 0, 0, 0, 1, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Has puesto un equipo de música prendido en el piso. Para levantarlo utiliza '/tomarparlante'.");
	CreateSpeaker(px, py, pz, pangle, GetPlayerVirtualWorld(playerid), ItemModel_GetObjectModel(GetHandItem(playerid, HAND_RIGHT)), radio);
	SetHandItemAndParam(playerid, HAND_RIGHT, 0, 0);
	return 1;
}

CMD:tomarparlante(playerid, params[])
{
	new freehand = SearchFreeHand(playerid);
	if(freehand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tienes ambas manos ocupadas y no puedes agarrar ningún ítem.");

	new vsize = vector_size(SERVER_SPEAKERS),
	    speaker_id;

	for(new i = 0; i < vsize; i++)
	{
	    speaker_id = vector_get(SERVER_SPEAKERS, i);
	    if(GetPlayerVirtualWorld(playerid) == vector_get(speaker_id, VEC_INDEX_VWORLD))
	    {
		    if(IsPlayerInRangeOfPoint(playerid, 1.5, vector_get_float(speaker_id, VEC_INDEX_X), vector_get_float(speaker_id, VEC_INDEX_Y), vector_get_float(speaker_id, VEC_INDEX_Z)))
		    {
				DestroySpeaker(speaker_id);
				PlayerActionMessage(playerid, 15.0, "apaga el equipo de música y lo agarra.");
				ApplyAnimationEx(playerid, "BOMBER", "BOM_PLANT", 4.0, 0, 0, 0, 0, 0, .forcesync = 1, .autofinish = true, .finishAnimId = 0);
				SetHandItemAndParam(playerid, freehand, ITEM_ID_PARLANTE, 1);
				return 1;
			}
		}
	}
	SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay ningún equipo de música activo cerca tuyo.");
	return 1;
}


