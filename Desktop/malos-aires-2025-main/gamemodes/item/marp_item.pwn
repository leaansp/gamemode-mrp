#if defined _marp_items_included
	#endinput
#endif
#define _marp_items_included

#include "item/marp_item_model_data.pwn"
#include "item/marp_item_type_BN.pwn"
#include "item/marp_item_type_batch.pwn"
#include "item/marp_item_type_toy.pwn"
#include "item/marp_item_type_drug.pwn"
#include "item/marp_item_type_weapon.pwn"

static pItemHandlingCooldown[MAX_PLAYERS];

Item_ApplyHandlingCooldown(playerid, cooldown = 1) {
	pItemHandlingCooldown[playerid] = gettime() + cooldown;
}

Item_IsHandlingCooldownOn(playerid) {
	return (pItemHandlingCooldown[playerid] > gettime());
}

LoadHandItem(playerid, hand)
{
	new itemid = GetHandItem(playerid, hand);

	if(!ItemModel_GetObjectModel(itemid))
		return 0;

	if(hand == HAND_RIGHT && ItemModel_GetType(itemid) == ITEM_WEAPON) {
		Weapon_GiveToPlayer(playerid, .weaponid = ItemModel_GetExtraId(itemid), .ammo = GetHandParam(playerid, HAND_RIGHT));
	}

	ItemModel_AttachOnHand(playerid, itemid, hand);

	if(ItemModel_HasTag(itemid, ITEM_TAG_BOTH_HANDS))
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SetPlayerCarrying(playerid, true);
	}
	return 1;
}

DeleteHandItem(playerid, hand)
{
	new itemid = GetHandItem(playerid, hand);

	if(hand == HAND_RIGHT)
	{
		if(ItemModel_GetType(itemid) == ITEM_WEAPON) {
			Weapon_RemoveFromPlayer(playerid);
		}

		RemovePlayerAttachedObject(playerid, ATTACH_INDEX_ID_HAND_RIGHT);
	} else {
	    RemovePlayerAttachedObject(playerid, ATTACH_INDEX_ID_HAND_LEFT);
	}

	if(ItemModel_HasTag(itemid, ITEM_TAG_BOTH_HANDS))
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		SetPlayerCarrying(playerid, false);
	}
	return 1;
}

Item_Use(playerid, hand)
{
	new itemid = GetHandItem(playerid, hand);

	if(!ItemModel_IsValidId(itemid) || !ItemModel_HasTag(itemid, ITEM_TAG_USE))
		return 0;

	// if(ItemModel_HasTag(itemid, ITEM_TAG_USE))
	// {
	// 	if(ItemModel_HasCallbackOnUse(itemid))
	// 	{
	// 		new function[32];
	// 		ItemModel_GetCallbackOnUse(itemid, function);
	// 		return CallLocalFunction(function, "iii", playerid, itemid, hand);
	// 	}
	// } else {
	// 	return Item_OnUsed(playerid, hand, itemid, ItemModel_GetType(itemid));
	// }

	return Item_OnUsed(playerid, hand, itemid, ItemModel_GetType(itemid));
}