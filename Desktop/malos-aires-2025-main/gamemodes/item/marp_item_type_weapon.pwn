#if defined _marp_item_type_weapon_included
	#endinput
#endif
#define _marp_item_type_weapon_included

#include <YSI_Coding\y_hooks>

static enum e_RELOAD_ANIMS
{
    reloadLibery[32],
    reloadAnim[32]
}

static bool:gPlayerReloading[MAX_PLAYERS] = {false, ...};
static gPlayerReloadTimer[MAX_PLAYERS] = {-1, ...};

#define RELOAD_DELAY_MS (1500)

forward TryStartReload(playerid);
forward FinishReloadTimer(playerid, weaponItemId);

#define RELOAD_DELAY_MS (1500)

static const ItemWeapon_ReloadAnims[][e_RELOAD_ANIMS] = {
/*22*/ {
        /*reloadLibery*/ "colt45",
        /*reloadAnim*/ "colt45_reload"
    },
/*23*/ {
        /*reloadLibery*/ "silenced",
        /*reloadAnim*/ "silence_reload"
    },
/*24*/ {
        /*reloadLibery*/ "python",
        /*reloadAnim*/ "python_reload"
    },
/*25*/ {
        /*reloadLibery*/ "buddy",
        /*reloadAnim*/ "buddy_reload"
    },
/*26*/ {
        /*reloadLibery*/ "colt45",
        /*reloadAnim*/ "sawnoff_reload"
    },
/*27*/ {
        /*reloadLibery*/ "buddy",
        /*reloadAnim*/ "buddy_reload"
    },
/*28*/ {
        /*reloadLibery*/ "colt45",
        /*reloadAnim*/ "colt45_reload"
    },
/*29*/ {
        /*reloadLibery*/ "rifle",
        /*reloadAnim*/ "rifle_load"
    },
/*30*/ {
        /*reloadLibery*/ "rifle",
        /*reloadAnim*/ "rifle_load"
    },
/*31*/ {
        /*reloadLibery*/ "rifle",
        /*reloadAnim*/ "rifle_load"
    },
/*32*/ {
        /*reloadLibery*/ "uzi",
        /*reloadAnim*/ "uzi_reload"
    },
/*33*/ {
        /*reloadLibery*/ "rifle",
        /*reloadAnim*/ "rifle_load"
    },
/*34*/ {
        /*reloadLibery*/ "rifle",
        /*reloadAnim*/ "rifle_load"
    }
};

ItemWeapon_SearchInventory(playerid, itemid, &slot, &containerID)
{
    slot = -1;
    if(isPlayerCopOnDuty(playerid) || isPlayerSideOnDuty(playerid))
    {
        slot = Container_SearchItem(PlayerInfo[playerid][pBeltID], itemid);

        if(slot != -1) 
        {
            containerID = PlayerInfo[playerid][pBeltID];
            return 1;
        }
    }

    slot = Container_SearchItem(PlayerInfo[playerid][pContainerID], itemid);
    containerID = PlayerInfo[playerid][pContainerID];
    return 1;
}

hook function Item_OnUsed(playerid, hand, itemid, itemType)
{
	if(itemType != ITEM_WEAPON || Weapon_GetMagazineId(ItemModel_GetExtraId(itemid)) == ITEM_ID_NULL)
		return continue(playerid, hand, itemid, itemType);

	if(Item_IsHandlingCooldownOn(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes esperar un tiempo antes de volver a interactuar con otro item!");

    new ItemWeapon_dataId = ItemModel_GetExtraId(itemid);
    new magazineitem = Weapon_GetMagazineId(ItemWeapon_dataId);
    new maxmunition = ItemModel_GetParamDefaultValue(itemid);

    new maghand = SearchHandsForItem(playerid, magazineitem);
    new maginvslot, magcontainerid, munition;

    ItemWeapon_SearchInventory(playerid, magazineitem, maginvslot, magcontainerid);

    if(maghand == -1 && maginvslot == -1)
    {
		SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener un %s en una de tus manos o inventario.", ItemModel_GetName(magazineitem));
		return 0;
	}

    if(maghand != -1)
    {
        munition = GetHandParam(playerid, maghand);

        if(munition <= maxmunition)
        {
            if(GetHandParam(playerid, hand) > 0) {
                SetHandItemAndParam(playerid, maghand, magazineitem, GetHandParam(playerid, hand));
            } else {
                SetHandItemAndParam(playerid, maghand, 0, 0); // Borrado lógico y grafico
            }
        }
        else 
        {
            SetHandItemAndParam(playerid, maghand, magazineitem, GetHandParam(playerid, hand) + munition - maxmunition);
            munition = maxmunition;
        }
    }
    else 
    {
        Container_TakeItem(magcontainerid, maginvslot, magazineitem, munition);
        
        if(munition <= maxmunition)
        {
            if(GetHandParam(playerid, hand) > 0) {
                Container_AddItemAndParam(magcontainerid, magazineitem, GetHandParam(playerid, hand));
            }
        }
        else 
        {
            Container_AddItemAndParam(magcontainerid, magazineitem, GetHandParam(playerid, hand) + munition - maxmunition);
            munition = maxmunition;
        }
    }
    
    new animindex = GetPlayerAnimationIndex(playerid);
    new weaponid = Weapon_GetEngineWeaponId(ItemWeapon_dataId);      

    if(22 <= weaponid < 35)
    {   
        if(animindex != 1274 && animindex != 1159) { // PED/WEAPON_CROUCH = 1274 - PED/GUNCROUCHFWD = 1159
            ApplyAnimationEx(playerid, ItemWeapon_ReloadAnims[weaponid - 22][reloadLibery], ItemWeapon_ReloadAnims[weaponid - 22][reloadAnim], 4.0, 0, 0, 0, 0, 0, 1);
        }
    }

	new str[128];
	format(str, sizeof(str), "Recarga su %s", ItemModel_GetName(itemid));
	PlayerCmeMessage(playerid, 15.0, 4000, str);

    SetHandItemAndParam(playerid, hand, itemid, munition);
    Item_ApplyHandlingCooldown(playerid);
    return 1;
}

CMD:descargar(playerid, params[])
{
    new rightitem = GetHandItem(playerid, HAND_RIGHT),
        rightparam = GetHandParam(playerid, HAND_RIGHT);

    if(GetHandItem(playerid, HAND_LEFT))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener la mano izquierda libre.");
    if((ItemModel_GetType(rightitem) != ITEM_WEAPON || !rightparam))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener un arma con un cargador en tu mano derecha.");
	if(Item_IsHandlingCooldownOn(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes esperar un tiempo antes de volver a interactuar con otro item!");

    new ItemWeapon_dataId = ItemModel_GetExtraId(rightitem);
    new magazineitem = Weapon_GetMagazineId(ItemWeapon_dataId);

    if(magazineitem == ITEM_ID_NULL)
        return SendClientMessage(playerid, COLOR_YELLOW2, "Esta arma no utiliza cargadores.");

    new str[128];
	format(str, sizeof(str), "Descarga su %s", ItemModel_GetName(rightitem));
	PlayerCmeMessage(playerid, 15.0, 4000, str);

    SetHandItemAndParam(playerid, HAND_RIGHT, rightitem, 0);
    SetHandItemAndParam(playerid, HAND_LEFT, magazineitem, rightparam);

    new weaponid = Weapon_GetEngineWeaponId(ItemWeapon_dataId);
    new animindex = GetPlayerAnimationIndex(playerid);

    if(22 <= weaponid < 35)
    {
        if(animindex != 1274 && animindex != 1159) { // PED/WEAPON_CROUCH = 1274 - PED/GUNCROUCHFWD = 1159
            ApplyAnimationEx(playerid, ItemWeapon_ReloadAnims[weaponid - 22][reloadLibery], ItemWeapon_ReloadAnims[weaponid - 22][reloadAnim], 4.0, 0, 0, 0, 0, 0, 1);
        }
    }

	Item_ApplyHandlingCooldown(playerid);
    return 1;
}

public FinishReloadTimer(playerid, weaponItemId)
{
    gPlayerReloading[playerid] = false;
    gPlayerReloadTimer[playerid] = -1;

    new currentWeapon = GetHandItem(playerid, HAND_RIGHT);

    // sigue teniendo un arma en la mano derecha?
    if(currentWeapon == 0 || ItemModel_GetType(currentWeapon) != ITEM_WEAPON)
    {
        SendClientMessage(playerid, COLOR_YELLOW2, "Soltaste el arma antes de terminar de recargar.");
        return 1;
    }

    // sigue vacía?
    if(GetHandParam(playerid, HAND_RIGHT) > 0)
    {
        SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El arma ya no está vacía.");
        return 1;
    }

    // listo, recargamos usando el arma ACTUAL, no la vieja
    Item_OnUsed(playerid, HAND_RIGHT, currentWeapon, ITEM_WEAPON);
    return 1;
}

public TryStartReload(playerid)
{
    // anti-spam: ya está recargando?
    if(gPlayerReloading[playerid])
    {
        SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya estás recargando.");
        return 1;
    }

    // control de estado (esposado, stun, herido, etc.)
    if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
    {
        SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes recargar en este estado.");
        return 1;
    }

    // arma en mano derecha
    new weaponItemId = GetHandItem(playerid, HAND_RIGHT);
    if(!weaponItemId || ItemModel_GetType(weaponItemId) != ITEM_WEAPON) 
    {

        return 1;
    }
    
    new weaponAmmo = GetHandParam(playerid, HAND_RIGHT);
    new maxAmmo = ItemModel_GetParamDefaultValue(weaponItemId);

    if(weaponAmmo >= maxAmmo)
    {
        SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El arma ya está completamente cargada.");
        return 1;
    }

    if(weaponAmmo > 0)
    {
        SendClientMessage(playerid, COLOR_YELLOW2, "Todavía tienes balas en el cargador.");
        return 1;
    }


    // datos del arma
    new ItemWeapon_dataId = ItemModel_GetExtraId(weaponItemId);
    new magazineitem = Weapon_GetMagazineId(ItemWeapon_dataId);

    if(magazineitem == ITEM_ID_NULL)
    {
        SendClientMessage(playerid, COLOR_YELLOW2, "Esta arma no utiliza cargadores.");
        return 1;
    }

    // verificar si de verdad tengo cargador disponible
    new maghand = SearchHandsForItem(playerid, magazineitem); // mano izq o der
    new maginvslot, magcontainerid;
    ItemWeapon_SearchInventory(playerid, magazineitem, maginvslot, magcontainerid);

    if(maghand == -1 && maginvslot == -1)
    {
        SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes ningún %s para recargar.", ItemModel_GetName(magazineitem));
        return 1;
    }

    // marcamos que está recargando
    gPlayerReloading[playerid] = true;

    // Animación inicial estilo tu recarga, pero es la "pre-recarga" de 1.5 s
    new animindex = GetPlayerAnimationIndex(playerid);
    new weaponid  = Weapon_GetEngineWeaponId(ItemWeapon_dataId); // ID GTA: 22..34
    if(22 <= weaponid < 35)
    {
        if(animindex != 1274 && animindex != 1159) // PED/WEAPON_CROUCH / PED/GUNCROUCHFWD
        {
            ApplyAnimationEx(playerid,
                ItemWeapon_ReloadAnims[weaponid - 22][reloadLibery],
                ItemWeapon_ReloadAnims[weaponid - 22][reloadAnim],
                4.0, 0, 0, 0, 0, 0, 1
            );
        }
    }

    PlayerCmeMessage(playerid, 15.0, 1500, "Comienza a recargar su arma...");
    SendClientMessage(playerid, COLOR_WHITE, "Recargando...");

    // disparamos el timer que finaliza la recarga
    gPlayerReloadTimer[playerid] = SetTimerEx(
        "FinishReloadTimer",
        RELOAD_DELAY_MS,
        false,
        "ii",
        playerid,
        weaponItemId
    );

    return 1;
}
