#if defined _marp_debug_included
	#endinput
#endif
#define _marp_debug_included

CMD:printvector(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new vecid;

	if(sscanf(params, "i", vecid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/printvector [ID]");
	if(!vector_print_for_player(vecid, playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID inválida o vector vacío.");

	return 1;
}

CMD:setpvarint(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new targetid, varint[64], value;

    if(sscanf(params, "us[64]i", targetid, varint, value)) {
    	return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/setpvarint [ID/Jugador] [Variable] [Valor]");
    }

	SetPVarInt(targetid, varint, value);
	SendFMessage(playerid, COLOR_LIGHTBLUE, "{878EE7}[INFO]{C8C8C8} Ejecutaste 'SetPVarInt(%s, %s, %d)'.", GetPlayerCleanName(targetid), varint, value);
    return 1;
}

CMD:getpvarint(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new targetid, varint[64], value;

    if(sscanf(params, "us[64]", targetid, varint)) {
    	return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/getpvarint [ID/Jugador] [Variable]");
    }

	value = GetPVarInt(targetid, varint);
	SendFMessage(playerid, COLOR_LIGHTBLUE, "{878EE7}[INFO]{C8C8C8} La variable '%s' del jugador '%s' equivale a '%d'.", varint, GetPlayerCleanName(targetid), value);
    return 1;
}

CMD:applyanimation(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new animlib[64], animname[64], Float:fDelta, loop, lockx, locky, freeze, time, forcesync;

	if(sscanf(params, "s[64]s[64]fdddddd", animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync)) {
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/applyanimation [librería] [nombre] [fDelta] [loop] [lockx] [locky] [freeze] [time] [forcesync]");
	}

	ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
	SendFMessage(playerid, COLOR_WHITE, "Ejecutaste ApplyAnimation(%d, %s, %s, %f, %d, %d, %d, %d, %d, %d);", playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
	return 1;
}

CMD:playerplaysound(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new targetid, sound, Float:pos[3];

	if(sscanf(params, "ui", targetid, sound)) {
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/playerplaysound [ID/Jugador] [ID del sonido]");
	}

	GetPlayerPos(targetid, pos[0], pos[1], pos[2]);
	PlayerPlaySound(targetid, sound, pos[0], pos[1], pos[2]);
	return 1;
}

CMD:getplayervehicleseat(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid)) {
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/getplayervehicleseat [ID/Jugador]");
	}

	SendFMessage(playerid, COLOR_WHITE, "GetPlayerVehicleSeat(%s) = %d", GetPlayerCleanName(targetid), GetPlayerVehicleSeat(targetid));
	return 1;
}

CMD:getvehicledamagestatus(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new vehicleid, panels, doors, lights, tires;

	if(sscanf(params, "i", vehicleid)) {
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/getvehicledamagestatus [ID del vehículo] (params: vid, panels, doors, lights, tires)");
	}

	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
	SendFMessage(playerid, COLOR_WHITE, "Ejecutaste GetVehicleDamageStatus(%d, %d, %d, %d, %d);", vehicleid, panels, doors, lights, tires);
	return 1;
}

CMD:updatevehicledamagestatus(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new vehicleid, panels, doors, lights, tires;

	if(sscanf(params, "iiiii", vehicleid, panels, doors, lights, tires)) {
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/updatevehicledamagestatus [ID del vehículo] [panels] [doors] [lights] [tires]");
	}

	UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
	SendFMessage(playerid, COLOR_WHITE, "Ejecutaste UpdateVehicleDamageStatus(%d, %d, %d, %d, %d);", vehicleid, panels, doors, lights, tires);
	return 1;
}

CMD:playaudiostreamforplayer(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new targetid, url[128];

	if(sscanf(params, "us[128]", targetid, url)) {
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/playaudiostreamforplayer [ID/Jugador] [URL del stream]");
	}

	PlayAudioStreamForPlayer(targetid, url);
	SendFMessage(playerid, COLOR_WHITE, "Ejecutaste PlayAudioStreamForPlayer(%d, %s);", targetid, url);	
	return 1;
}

CMD:stopaudiostreamforplayer(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new targetid;

	if(sscanf(params, "u", targetid)) {
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/stopaudiostreamforplayer [ID/Jugador]");
	}

	StopAudioStreamForPlayer(targetid);
	SendFMessage(playerid, COLOR_WHITE, "Ejecutaste StopAudioStreamForPlayer(%d);", targetid);
	return 1;
}

CMD:getanimation(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	if(GetPlayerAnimationIndex(playerid))
    {
        new animlib[32];
        new animname[32];
        GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, sizeof(animlib), animname, sizeof(animname));
        SendFMessage(playerid, COLOR_WHITE, "Animacion actual - Liberia: %s - Nombre: %s - Index: %i", animlib, animname, GetPlayerAnimationIndex(playerid));
    }
    return 1;
}