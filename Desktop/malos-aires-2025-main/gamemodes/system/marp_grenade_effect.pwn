#if defined _marp_grenade_effect_included
	#endinput
#endif
#define _marp_grenade_effect_included

#include <YSI_Coding\y_hooks>

#define FLASH_BANG_EFFECT_RANGE (10.0)
#define FLASH_BANG_EFFECT_DURATION (4500)
#define FLASH_BANG_IMPACT_TIME (1500)
#define FLASH_BANG_THROW_DISTANCE (8.0)

static GranadeEffectCooldown[MAX_PLAYERS];

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetHandItem(playerid, HAND_RIGHT) != ITEM_ID_FLASHBANG)
		return 1;
	if(!KEY_PRESSED_SINGLE(KEY_FIRE) || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return 1;

	if(KEY_HOLDING(KEY_JUMP))
	{
		new keys, ud, lr;
		GetPlayerKeys(playerid, keys, ud, lr);

		if(ud || lr)
			return 1;
	}

	new animindex = GetPlayerAnimationIndex(playerid);

	if(animindex != 644 && animindex != 1189) // 644: ./GRENADE/WEAPON_START_THROW, 1189: ./PED/IDLE_STANCE
		return ~1;
	if(gettime() < GranadeEffectCooldown[playerid])
		return ~1;

	new Float:x, Float:y, Float:z, Float:a;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	GetXYInFrontOfPoint(x, y, a, x, y, .distance = FLASH_BANG_THROW_DISTANCE);
	PlayerCmeMessage(playerid, 15.0, 4000, "Tira una granada cegadora.");
	SetTimerEx("FlashBang_ApplyEffect", FLASH_BANG_IMPACT_TIME, false, "iifff", playerid, GetPlayerVirtualWorld(playerid), x, y, z);
	GranadeEffectCooldown[playerid] = gettime() + 5; // To prevent click spaming
    return ~1;
}

forward FlashBang_ApplyEffect(issuerid, world, Float:x, Float:y, Float:z);
public FlashBang_ApplyEffect(issuerid, world, Float:x, Float:y, Float:z)
{
	new string[128];
	format(string, sizeof(string), " ¡Has sido alcanzado por una granada cegadora arrojada por %s! El efecto dura %i segundos.", GetPlayerChatName(issuerid), FLASH_BANG_EFFECT_DURATION / 1000);
	SetTimerEx("FlashBang_DestroyEffectObject", 1500, false, "i", CreateDynamicObject(18680, x, y, z - 2.0, 0.0, 0.0, 0.0, .worldid = world, .streamdistance = FLASH_BANG_EFFECT_RANGE));

	foreach(new playerid : Player)
	{
		if(GetPlayerVirtualWorld(playerid) == world && IsPlayerInRangeOfPoint(playerid, FLASH_BANG_EFFECT_RANGE, x, y, z))
		{
			Streamer_Update(playerid, .type = STREAMER_TYPE_OBJECT);
			PlayerPlaySound(playerid, 1159, x, y, z);

			if(!Toy_HasAnyWithItemToyTag(playerid, ITEM_TOY_TAG_FLASH_PROTECT))
			{
				SendClientMessage(playerid, COLOR_LIGHTYELLOW2, string);
				SetPlayerDrunkLevel(playerid, (FLASH_BANG_EFFECT_DURATION / 1000) * 60 + 2500);
				FadeScreen_StartForPlayer(playerid, COLOR_WHITE, 500, FLASH_BANG_EFFECT_DURATION);
			}
		}
	}

	return 1;
}

forward FlashBang_DestroyEffectObject(STREAMER_TAG_OBJECT:objectid);
public FlashBang_DestroyEffectObject(STREAMER_TAG_OBJECT:objectid)
{
	DestroyDynamicObject(objectid);
	return 1;
}

hook function Item_OnUsed(playerid, hand, itemid, itemType)
{
	if(itemid != ITEM_ID_FLASHBANG)
		return continue(playerid, hand, itemid, itemType);

	if(gettime() < GranadeEffectCooldown[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar unos instantes para usar una granada nuevamente.");

	new id, message[128], Float:x, Float:y, Float:z, Float:a, world;

	format(message, sizeof(message), "* Se escucharía caer y rodar un objeto arrojado desde el exterior (( %s ))", GetPlayerChatName(playerid));

	if((id = House_IsPlayerAtOutDoorAny(playerid)))
	{
		if(House_IsLocked(id))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡La puerta esta cerrada!");

		foreach(new i : Player)
		{
			if(House_IsPlayerInId(i, id)) {
				SendClientMessage(i, COLOR_DO1, message);
			}
		}

		a = House_GetInDoorAngle(id);
		world = House_GetInDoorWorld(id);
		House_GetInDoorPos(id, x, y, z);
	}
	else if((id = Biz_IsPlayerAtOutsideDoorAny(playerid)))
	{
		if(Biz_IsLocked(id))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡La puerta esta cerrada!");

		foreach(new i : Player)
		{
			if(Biz_IsPlayerInsideId(i, id)) {
				SendClientMessage(i, COLOR_DO1, message);
			}
		}

		a = Biz_GetInDoorAngle(id);
		world = Biz_GetInDoorWorld(id);
		Biz_GetInDoorPos(id, x, y, z);
	}
	else {
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar en la puerta de entrada de algúninmueble!");
	}

	if(GetHandParam(playerid, hand) - 1 > 0) {
		SetHandItemAndParam(playerid, hand, ITEM_ID_FLASHBANG, GetHandParam(playerid, hand) - 1);
	} else {
		SetHandItemAndParam(playerid, hand, 0, 0);
	}

	PlayerCmeMessage(playerid, 15.0, 4000, "Tira una granada cegadora dentro de la casa.");
	GetXYInFrontOfPoint(x, y, a, x, y, .distance = FLASH_BANG_THROW_DISTANCE);
	SetTimerEx("FlashBang_ApplyEffect", FLASH_BANG_IMPACT_TIME, false, "iifff", playerid, world, x, y, z);
	GranadeEffectCooldown[playerid] = gettime() + 5; // To prevent click spaming
	return 1;
}