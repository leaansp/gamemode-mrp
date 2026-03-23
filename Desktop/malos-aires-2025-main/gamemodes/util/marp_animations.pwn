#if defined _marp_animations_included
	#endinput
#endif
#define _marp_animations_included

#include <YSI_Coding\y_hooks>

/*DATO DE COLOR SOBRE ANIMACIONES: El lockx y locky si estan en 1 en una animacion que no va a ser estatica (No termina sola), dejan al personaje duro.
    Si la animacion no va a ser estatica, estos parametros deben ir en 0.*/

static Anim_talkingId[MAX_PLAYERS];

static enum e_TALK_ANIMS_INFO {
    talkAnimLib[32],
    talkAnimName[32]
};

static const TalkAnims_Data[][e_TALK_ANIMS_INFO] = {
    {"PED","IDLE_CHAT"},
    {"GANGS","prtial_gngtlkA"},
    {"GANGS","prtial_gngtlkB"},
    {"GANGS","prtial_gngtlkC"},
    {"GANGS","prtial_gngtlkD"},
    {"GANGS","prtial_gngtlkE"},
    {"GANGS","prtial_gngtlkF"},
    {"GANGS","prtial_gngtlkH"},
    {"GANGS","prtial_gngtlkH"},
    {"GANGS","prtial_gngtlkA"},
    {"LOWRIDER","prtial_gngtlkF"},
    {"LOWRIDER","prtial_gngtlkH"},
    {"MISC", "Idle_Chat_02"}
};

static Anim_timer[MAX_PLAYERS];
static Anim_active[MAX_PLAYERS];
static Anim_finishId[MAX_PLAYERS];

static enum e_ANIM_TRANSITION_INFO {
	at_AnimLib[32],
	at_AnimName[32],
	Float:at_Delta,
	at_Loop,
	at_LockX,
	at_LockY,
	at_Freeze,
	at_Time,
	at_ForceSync
}

static const Anim_transitionInfo[][e_ANIM_TRANSITION_INFO] = {
	/*0*/ {"CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1},
	/*1*/ {"INT_SHOP", "SHOP_OUT", 4.0, 0, 0, 0, 0, 1, 0},
	/*2*/ {"COP_AMBIENT", "Copbrowse_out", 4.1, 0, 0, 0, 0, 0, 1},
	/*3*/ {"COP_AMBIENT", "Coplook_out", 4.1, 0, 0, 0, 0, 0, 1},
	/*4*/ {"benchpress", "gym_bp_getoff", 4.1, 0, 0, 0, 0, 0, 1},
	/*5*/ {"GANGS", "leanOUT", 4.1, 0, 0, 0, 0, 0, 1},
	/*6*/ {"SUNBATHE", "ParkSit_M_out", 4.1, 0, 0, 0, 0, 0, 1},
	/*7*/ {"SUNBATHE", "ParkSit_W_out", 4.1, 0, 0, 0, 0, 0, 1},
	/*8*/ {"INT_SHOP", "shop_out", 4.1, 0, 0, 0, 0, 0, 1},
	/*9*/ {"SUNBATHE", "Lay_Bac_out", 4.1, 0, 0, 0, 0, 0, 1},
	/*10*/ {"Freeweights", "gym_free_putdown", 4.1, 0, 0, 0, 0, 0, 1},
	/*11*/ {"INT_HOUSE", "LOU_Out", 4.1, 0, 0, 0, 0, 0, 1},
	/*12*/ {"FOOD", "SHP_Tray_Out", 4.1, 0, 0, 0, 0, 0, 1},
	/*13*/ {"OTB", "wtchrace_out", 4.1, 0, 0, 0, 0, 0, 1},
	/*14*/ {"PARK", "Tai_Chi_Out", 4.1, 0, 0, 0, 0, 0, 1},
	/*15*/ {"PAULNMAC", "Piss_out", 4.1, 0, 0, 0, 0, 0, 1},
	/*16*/ {"PAULNMAC", "wank_out", 4.1, 0, 0, 0, 0, 0, 1},
	/*17*/ {"ped", "getup", 4.1, 0, 0, 0, 0, 0, 1},
	/*18*/ {"ped", "getup_front", 4.1, 0, 0, 0, 0, 0, 1},
	/*19*/ {"ped", "phone_out", 4.1, 0, 0, 0, 0, 0, 1},
	/*20*/ {"FOOD", "FF_SIT_OUT_L_180", 4.0, 0, 0, 0, 0, 0, 1},
	/*21*/ {"FOOD", "FF_SIT_OUT_R_180", 4.0, 0, 0, 0, 0, 0, 1},
	/*22*/ {"ped", "SEAT_up", 4.1, 0, 0, 0, 0, 0, 1}
};

static const s_AnimationLibraries[][] = {
	!"AIRPORT",!"ATTRACTORS",!"BAR",!"BASEBALL",!"BD_FIRE",!"BEACH",
	!"BENCHPRESS",!"BF_INJECTION",!"BIKED",!"BIKEH",!"BIKELEAP",!"BIKES",
	!"BIKEV",!"BIKE_DBZ",!"BLOWJOBZ",!"BMX",!"BOMBER",!"BOX",
	!"BSKTBALL",!"BUDDY",!"BUS",!"CAMERA",!"CAR",!"CARRY",
	!"CAR_CHAT",!"CASINO",!"CHAINSAW",!"CHOPPA",!"CLOTHES",!"COACH",
	!"COLT45",!"COP_AMBIENT",!"COP_DVBYZ",!"CRACK",!"CRIB",!"DAM_JUMP",
	!"DANCING",!"DEALER",!"DILDO",!"DODGE",!"DOZER",!"DRIVEBYS",
	!"FAT",!"FIGHT_B",!"FIGHT_C",!"FIGHT_D",!"FIGHT_E",!"FINALE",
	!"FINALE2",!"FLAME",!"FLOWERS",!"FOOD",!"FREEWEIGHTS",!"GANGS",
	!"GHANDS",!"GHETTO_DB",!"GOGGLES",!"GRAFFITI",!"GRAVEYARD",!"GRENADE",
	!"GYMNASIUM",!"HAIRCUTS",!"HEIST9",!"INT_HOUSE",!"INT_OFFICE",!"INT_SHOP",
	!"JST_BUISNESS",!"KART",!"KISSING",!"KNIFE",!"LAPDAN1",!"LAPDAN2",
	!"LAPDAN3",!"LOWRIDER",!"MD_CHASE",!"MD_END",!"MEDIC",!"MISC",
	!"MTB",!"MUSCULAR",!"NEVADA",!"ON_LOOKERS",!"OTB",!"PARACHUTE",
	!"PARK",!"PAULNMAC",!"PED",!"PLAYER_DVBYS",!"PLAYIDLES",!"POLICE",
	!"POOL",!"POOR",!"PYTHON",!"QUAD",!"QUAD_DBZ",!"RAPPING",
	!"RIFLE",!"RIOT",!"ROB_BANK",!"ROCKET",!"RUSTLER",!"RYDER",
	!"SCRATCHING",!"SHAMAL",!"SHOP",!"SHOTGUN",!"SILENCED",!"SKATE",
	!"SMOKING",!"SNIPER",!"SPRAYCAN",!"STRIP",!"SUNBATHE",!"SWAT",
	!"SWEET",!"SWIM",!"SWORD",!"TANK",!"TATTOOS",!"TEC",
	!"TRAIN",!"TRUCK",!"UZI",!"VAN",!"VENDING",!"VORTEX",
	!"WAYFARER",!"WEAPONS",!"WUZI",!"WOP",!"GFUNK",!"RUNNINGMAN",
	!"SNM", !"SAMP"
};

PreloadAnimations(playerid)
{
	for(new i = 0; i < sizeof(s_AnimationLibraries); i++) {
		ApplyAnimation(playerid, s_AnimationLibraries[i], "null", 0.0, 0, 0, 0, 0, 0, 0);
	}
} 

ResetAnim(playerid)
{
    Anim_active[playerid] = false;
    Anim_finishId[playerid] = 0;

    if(Anim_timer[playerid])
    {
        KillTimer(Anim_timer[playerid]);
        Anim_timer[playerid] = 0;
    }
    return 1;
}

hook OnPlayerDisconnect(playerid)
{
    Anim_talkingId[playerid] = 0;
    ResetAnim(playerid);
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    ResetAnim(playerid);
    PreloadAnimations(playerid);
    return 1;
}

TalkAnim_GetMaxTalkAnimId(){
    return sizeof(TalkAnims_Data);    
}

stock IsPlayerFalling(playerid)
{
	new animindex = GetPlayerAnimationIndex(playerid);

	return (animindex == 1128 || // PED/FALL_BACK
			animindex == 1130 || // PED/FALL_FALL
			animindex == 1131 || // PED/FALL_FRONT
			animindex == 1132); // PED/FALL_GLIDE
}

forward EndAnim(playerid);
public EndAnim(playerid) 
{
	if(!IsPlayerLogged(playerid))
		return 0;

	new finishAnimId = Anim_finishId[playerid];

	ApplyAnimation(playerid,
				Anim_transitionInfo[finishAnimId][at_AnimLib],
				Anim_transitionInfo[finishAnimId][at_AnimName],
				Anim_transitionInfo[finishAnimId][at_Delta],
				Anim_transitionInfo[finishAnimId][at_Loop],
				Anim_transitionInfo[finishAnimId][at_LockX],
				Anim_transitionInfo[finishAnimId][at_LockY],
				Anim_transitionInfo[finishAnimId][at_Freeze],
				Anim_transitionInfo[finishAnimId][at_Time],
				Anim_transitionInfo[finishAnimId][at_ForceSync]);

	ResetAnim(playerid);
    return 1;
}

// Prevendra que las animaciones se cancelen al hablar.
ApplyAnimationEx(playerid, const animlib[], const animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync, bool:autofinish = true, finishAnimId = 0)
{
	Anim_active[playerid] = !autofinish;
	Anim_finishId[playerid] = finishAnimId;
	ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
	return 1;
}

ApplyPlayerTalkAnimation(playerid, duration)
{
    if((GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_NONE && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_SMOKE_CIGGY) || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || PlayerInfo[playerid][pDisabled] != DISABLE_NONE) // Si ya tiene una animacion no aplicamos aplicamos la anim de hablar o si tiene una espacial action aplicada.
        return 1;
    if(Anim_active[playerid]) // Para no cancelar animaciones la medio si hablamos.
        return 1;

    if(Anim_timer[playerid]) {
        KillTimer(Anim_timer[playerid]); // Reseteamos el timer si habla seguido
    }

    ApplyAnimationEx(playerid, TalkAnims_Data[Anim_talkingId[playerid]][talkAnimLib], TalkAnims_Data[Anim_talkingId[playerid]][talkAnimName], 4.0, 1, 1, 1, 1, 1, 1);
    Anim_timer[playerid] = SetTimerEx("EndAnim", duration, false, "i", playerid);
    return 1;
}

ApplyTalkAnimation(playerid, talkanimid, bool:setanim = false)
{
	if(setanim)
	{
		Anim_talkingId[playerid] = talkanimid;
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"has cambiado tu animacion al hablar por la anim id: %d. (Recuerda activarla desde /toggle)", talkanimid + 1);

		if(Anim_timer[playerid]) {
			KillTimer(Anim_timer[playerid]);
		}

		Anim_timer[playerid] = SetTimerEx("EndAnim", 4000, false, "i", playerid);
	}

	ApplyAnimationEx(playerid, TalkAnims_Data[talkanimid][talkAnimLib], TalkAnims_Data[talkanimid][talkAnimName], 4.0, 1, 1, 1, 1, 1, 1, false);
	return 1;
}

CMD:anims(playerid, params[]) {
	return cmd_animaciones(playerid, params);
}

CMD:animaciones(playerid, params[])
{
    SendClientMessage(playerid, COLOR_INFO, "[ANIMACIONES]: ");
	SendClientMessage(playerid, COLOR_GREY, "/hablar - /cambiaranimhablar - /herido - /sentarse - /atomar - /bate - /chau - /lavarmanos - /gimanim");
	SendClientMessage(playerid, COLOR_GREY, "/pete - /bomba - /rifle - /camara - /bailar - /reir - /arrojar - /bondi - /chasis - /brazoventanilla");
	SendClientMessage(playerid, COLOR_GREY, "/motosierra - /mirar - /cbrazos - /cmanos - /animpagar - /jugarplay - /cansado - /balcon - /acomer");
	SendClientMessage(playerid, COLOR_GREY, "/vomitar - /apoyarse - /empujar - /llorar - /cubrirse - /pasartarjeta - /quebrar - /quepaso - /chupala");
	SendClientMessage(playerid, COLOR_GREY, "/dormir - /caminar - /afumar - /gesto - /tantear - /arrastrarse - /rapear - /taxi - /alentar - /taichi");
	SendClientMessage(playerid, COLOR_GREY, "/mear - /paja - /alpiso - /manosarriba - /arevisar - /trafico - /pool - /borracho - /chocado - /apuntar");
    SendClientMessage(playerid, COLOR_GREY, "/reanimar");
    SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Para parar animaciones utiliza /noanim o apreta ~k~~PED_LOCK_TARGET~");
	return 1;
}

CMD:noanim(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes utilizar esto estando incapacitado/congelado!");

    EndAnim(playerid);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(!Anim_active[playerid] || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return 1;
	if(!KEY_PRESSED_SINGLE(KEY_HANDBRAKE) || PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return 1;

	EndAnim(playerid);
    return ~1;
}

CMD:nocargar(playerid, params[])
{
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY && !IsPlayerCarryingObject(playerid)) {
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	return 1;
}

CMD:hablar(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes utilizar esto estando incapacitado/congelado!");

	new anim;
	if(sscanf(params,"i",anim)) {
	    SendFMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY" /hablar [1-%i]", TalkAnim_GetMaxTalkAnimId());
		return 1;
	}
    if(anim < 1 || anim > TalkAnim_GetMaxTalkAnimId()) {
        SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ingresar una animacion entre 1 y %i.", TalkAnim_GetMaxTalkAnimId());
        return 1;
    }

	ApplyTalkAnimation(playerid, anim - 1);
 	return 1; 
}

CMD:cambiaranimhablar(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes utilizar esto estando incapacitado/congelado!");
    
	new anim;
	if(sscanf(params,"i",anim)) {
	    SendFMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY" /cambiaranimhablar [1-%i]", TalkAnim_GetMaxTalkAnimId());
		return 1;
	}
    if(anim < 1 || anim > TalkAnim_GetMaxTalkAnimId()) {
        SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ingresar una animacion entre 1 y %i.", TalkAnim_GetMaxTalkAnimId());
        return 1;
    }

	ApplyTalkAnimation(playerid, anim - 1, true);
 	return 1;
}

CMD:herido(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
    if(sscanf(params,"i",anim))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/herido [1-11]");

    switch(anim)
    {
        case 1: ApplyAnimationEx(playerid, "CRACK", "CRCKDETH1", 4.1, 0, 0, 0, 1, 0, 1, false);
		case 2: ApplyAnimationEx(playerid, "CRACK", "CRCKDETH2", 4.1, 0, 0, 0, 1, 0, 1, false);
		case 3: ApplyAnimationEx(playerid, "CRACK", "CRCKDETH3", 4.1, 0, 0, 0, 1, 0, 1, false);
		case 4: ApplyAnimationEx(playerid, "CRACK", "CRCKDETH4", 4.1, 0, 0, 0, 1, 0, 1, false);
		case 5: ApplyAnimationEx(playerid, "CRACK", "CRCKIDLE2", 4.1, 0, 0, 0, 1, 0, 1, false);
        case 6: ApplyAnimationEx(playerid, "SWEET", "SWEET_INJUREDLOOP", 4.0, 0, 0, 1, 1, 0, 1, false);
        case 7: ApplyAnimationEx(playerid, "SWAT", "gnstwall_injurd", 4.1, 0, 1, 1, 1, 0, 1, false);
        case 8: ApplyAnimationEx(playerid, "CRACK", "CRCKIDLE1", 4.1, 0, 0, 0, 1, 0, 1, false);
        case 9: ApplyAnimationEx(playerid, "CRACK", "CRCKIDLE3", 4.1, 0, 0, 0, 1, 0, 1, false);
        case 10: ApplyAnimationEx(playerid, "CRACK", "CRCKIDLE4", 4.1, 0, 0, 0, 1, 0, 1, false);
        case 11: ApplyAnimationEx(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.1, 0, 1, 1, 1, 0, 1, false);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/herido [1-11]");
    }
    return 1;
}

CMD:sentarse(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
    if(sscanf(params,"i",anim))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/sentarse [1-15]");
    
    switch(anim)
    {
		case 1: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Bored_Loop", 4.1, 1, 0, 0, 0, 0, 1, false);
		case 2: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_idle_Loop", 4.1, 1, 0, 0, 0, 0, 1, false);
		case 3: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_type_Loop", 4.1, 1, 0, 0, 0, 0, 1, false);
		case 4: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Crash", 4.1, 1, 0, 0, 1, 0, 1, false);
		case 5: ApplyAnimationEx(playerid, "BEACH", "ParkSit_M_loop", 4.1, 0, 0, 0, 1, 0, 1, false);
		case 6: ApplyAnimationEx(playerid, "INT_HOUSE", "LOU_Loop", 4.1, 0, 0, 0, 1, 0, 1, false, .finishAnimId = 11);
		case 7: ApplyAnimationEx(playerid, "FOOD", "FF_Sit_Loop", 4.1, 0, 0, 0, 1, 0, 1, false);
		case 8: ApplyAnimationEx(playerid, "FOOD", "FF_SIT_IN_L", 4.0, 0, 0, 0, 1, 0, .forcesync = true, .autofinish = false, .finishAnimId = 20);
		case 9: ApplyAnimationEx(playerid, "FOOD", "FF_SIT_IN_R", 4.0, 0, 0, 0, 1, 0, .forcesync = true, .autofinish = false, .finishAnimId = 21);
		case 10: ApplyAnimationEx(playerid, "SUNBATHE", "ParkSit_M_in", 4.1, 0, 0, 0, 1, 0, 1, false, .finishAnimId = 6);
		case 11: ApplyAnimationEx(playerid, "SUNBATHE", "ParkSit_W_in", 4.1, 0, 0, 0, 1, 0, 1, false, .finishAnimId = 7);
		case 12: ApplyAnimationEx(playerid, "MISC", "SEAT_LR", 4.1, 0, 0, 0, 1, 0, .forcesync = true, .autofinish = false, .finishAnimId = 22);
		case 13: ApplyAnimationEx(playerid, "PED", "SEAT_down", 4.1, 0, 0, 0, 1, 0, .forcesync = true, .autofinish = false, .finishAnimId = 22);
		case 14: ApplyAnimationEx(playerid, "MISC", "SEAT_watch", 4.1, 0, 0, 0, 1, 0, 1, false);
		case 15: ApplyAnimationEx(playerid, "SUNBATHE", "Lay_Bac_in", 4.1, 0, 0, 0, 1, 0, 1, false, .finishAnimId = 9);

		default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/sentarse [1-15]");
    }
    return 1;
}

CMD:atomar(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
    if(sscanf(params,"i",anim))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/atomar [1-5]");
    
    switch(anim)
    {
        case 1: ApplyAnimationEx(playerid, "BAR", "dnk_stndF_loop", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "BAR", "dnk_stndM_loop", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "VENDING", "VEND_Drink_P", 1.8, 0, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "VENDING", "VEND_Drink2_P", 1.8, 0, 1, 1, 1, 1, .forcesync = 1, .autofinish = false, .finishAnimId = 0);
        case 5: ApplyAnimationEx(playerid, "GANGS", "drnkbr_prtl", 1.8, 0, 0, 0, 0, 0, 1);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/atomar [1-5]");
    }
    return 1;
}

CMD:bate(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
    if(sscanf(params,"i",anim))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/bate [1-3]");
    
    switch(anim)
    {
        case 1: ApplyAnimationEx(playerid, "BASEBALL", "Bat_IDLE", 4.1, 1, 1, 1, 1, 0, 1, false);
        case 2: ApplyAnimationEx(playerid, "BASEBALL", "Bat_4", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "BASEBALL", "Bat_3", 4.1, 0, 0, 0, 0, 0, 1);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/bate [1-3]");
    }
    return 1;
}

CMD:chau(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
    if(sscanf(params,"i",anim))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/chau [1-4]");
    
    switch(anim)
    {
        case 1: ApplyAnimationEx(playerid, "BD_FIRE", "BD_GF_Wave", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "KISSING", "gfwave2", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "ON_LOOKERS", "wave_loop", 4.1, 0, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "ped", "endchat_03", 4.1, 0, 0, 0, 0, 0, 1);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/chau [1-4]");
    }
    return 1;
}

CMD:lavarmanos(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes utilizar esto estando incapacitado/congelado!");

    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:gimanim(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
    if(sscanf(params,"i",anim))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/gimanim [1-7]");
    
    switch(anim)
    {
        case 1: ApplyAnimationEx(playerid, "benchpress", "gym_bp_geton", 4.1, 0, 0, 0, 1, 0, 1, false, .finishAnimId = 4);
        case 2: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_smooth", 4.1, 0, 0, 0, 1, 0, 1, false, .finishAnimId = 4);
        case 3: ApplyAnimationEx(playerid, "Freeweights", "gym_free_pickup", 4.1, 0, 0, 0, 1, 0, 1, false, .finishAnimId = 10);
        case 4: ApplyAnimationEx(playerid, "Freeweights", "gym_free_up_smooth", 4.1, 0, 0, 0, 1, 0, 1, false, .finishAnimId = 10);
        case 5: ApplyAnimationEx(playerid, "Freeweights", "gym_free_down", 4.1, 0, 0, 0, 1, 0, 1, false, .finishAnimId = 10);
        case 6: ApplyAnimationEx(playerid, "GYMNASIUM", "GYMshadowbox", 4.1, 1, 0, 0, 0, 0, 1, false); 
        case 7: ApplyAnimationEx(playerid, "GYMNASIUM", "gym_shadowbox", 4.1, 1, 0, 0, 0, 0, 1, false); 

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/gimanim [1-7]");
    }
    return 1;
}

CMD:pete(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
    if(sscanf(params,"i",anim))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/pete [1-2]");
    
    switch(anim)
    {
        case 1: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_START_W", 4.1, 0, 1, 1, 1, 0, 1, false);
        case 2: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_END_W", 4.1, 0, 0, 0, 0, 0, 1);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/pete [1-2]");
    }
    return 1;
}

CMD:bomba(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes utilizar esto estando incapacitado/congelado!");

    ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:rifle(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
    if(sscanf(params,"i",anim))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/rifle [1-5]");
    
    switch(anim)
    {
        case 1: ApplyAnimationEx(playerid, "BUDDY", "buddy_fire_poor", 4.1, 0, 1, 1, 1, 0, 1, false);
        case 2: ApplyAnimationEx(playerid, "BUDDY", "buddy_reload", 4.1, 0, 1, 1, 1, 0, 1, false);
        case 3: ApplyAnimationEx(playerid, "MISC", "PASS_Rifle_Ply", 4.1, 0, 1, 1, 1, 0, 1, false);
        case 4: ApplyAnimationEx(playerid, "ped", "IDLE_armed", 4.1, 0, 1, 1, 1, 0, 1, false);
        case 5: ApplyAnimationEx(playerid, "SHOP", "SHP_Gun_Duck", 4.1, 0, 1, 1, 1, 0, 1, false);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/rifle [1-5]");
    }
    return 1;
}

CMD:camara(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
    if(sscanf(params,"i",anim))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/camara [1-4]");
    
    switch(anim)
    {
        case 1: ApplyAnimationEx(playerid, "CAMERA", "camcrch_cmon", 4.1, 0, 1, 1, 1, 0, 1, false);
        case 2: ApplyAnimationEx(playerid, "CAMERA", "camcrch_idleloop", 4.1, 0, 1, 1, 1, 0, 1, false);
        case 3: ApplyAnimationEx(playerid, "CAMERA", "camstnd_cmon", 4.1, 0, 1, 1, 1, 0, 1, false);
        case 4: ApplyAnimationEx(playerid, "CAMERA", "camstnd_idleloop", 4.1, 0, 1, 1, 1, 0, 1, false);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/camara [1-4]");
    }
    return 1;
}

CMD:bailar(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

	new animid;
	if(sscanf(params, "d", animid)) 
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/bailar [1-17]");
	switch(animid)
	{
  		case 1:	ApplyAnimationEx(playerid, "DANCING", "dnce_M_a",  4.0, 1, 0, 0, 0, 0, 1, false);
   		case 2:	ApplyAnimationEx(playerid, "DANCING", "dnce_M_b",  4.0, 1, 0, 0, 0, 0, 1, false);
  		case 3:	ApplyAnimationEx(playerid, "DANCING", "dnce_M_c",  4.0, 1, 0, 0, 0, 0, 1, false);
  		case 4:	ApplyAnimationEx(playerid, "DANCING", "dnce_M_d",  4.0, 1, 0, 0, 0, 0, 1, false);
   		case 5:	ApplyAnimationEx(playerid, "DANCING", "dnce_M_e",  4.0, 1, 0, 0, 0, 0, 1, false);
        case 6:	ApplyAnimationEx(playerid, "DANCING", "dance_loop",  4.0, 1, 0, 0, 0, 0, 1, false);
        case 7: ApplyAnimationEx(playerid, "DANCING", "DAN_DOWN_A", 4.0, 1, 1, 1, 0, 0, 1, false);
        case 8: ApplyAnimationEx(playerid, "DANCING", "DAN_LOOP_A", 4.0, 1, 1, 1, 0, 0, 1, false);
        case 9: ApplyAnimationEx(playerid, "DANCING", "DAN_RIGHT_A", 4.0, 1, 1, 1, 0, 0, 1, false);
        case 10: ApplyAnimationEx(playerid, "DANCING", "DAN_UP_A", 4.0, 1, 1, 1, 0, 0, 1, false);
        case 11: ApplyAnimationEx(playerid, "STRIP", "PUN_LOOP", 4.0, 1, 1, 1, 0, 0, 1, false);
        case 12: ApplyAnimationEx(playerid, "STRIP", "strip_A", 4.0, 1, 1, 1, 0, 0, 1, false);
        case 13: ApplyAnimationEx(playerid, "STRIP", "strip_B", 4.0, 1, 1, 1, 0, 0, 1, false);
        case 14: ApplyAnimationEx(playerid, "STRIP", "strip_C", 4.0, 1, 1, 1, 0, 0, 1, false);
        case 15: ApplyAnimationEx(playerid, "STRIP", "strip_D", 4.0, 1, 1, 1, 0, 0, 1, false);
        case 16: ApplyAnimationEx(playerid, "STRIP", "strip_G", 4.0, 1, 1, 1, 0, 0, 1, false);
        case 17: ApplyAnimationEx(playerid, "STRIP", "STR_Loop_A", 4.0, 1, 1, 1, 0, 0, 1, false);

  		default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/bailar [1-17]");
 	}
 	return 1;
}

CMD:reir(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    ApplyAnimationEx(playerid, "RAPPING", "LAUGH_01", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:arrojar(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

	ApplyAnimationEx(playerid, "GRENADE", "WEAPON_throw", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:bondi(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

    ApplyAnimationEx(playerid, "PED", "abseil", 4.1, 1, 0, 0, 0, 0, 1, false);
	return 1;
}

CMD:chasis(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
	if(sscanf(params,"i",anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/chasis [1-2]");
	
    switch(anim)
	{
		case 1: ApplyAnimationEx(playerid, "CAR", "Fixn_Car_Loop", 4.1, 0, 0, 0, 1, 0, 1, false);
		case 2: ApplyAnimationEx(playerid, "CAR", "Fixn_Car_Out", 4.1, 0, 0, 0, 0, 0, 1);
        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/chasis [1-2]");
    }
	return 1;
}

CMD:brazoventanilla(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" Debes estar en un vehiculo.");
    if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
	if(sscanf(params,"i",anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/brazoventanilla [1-4]");
	
    switch(anim)
	{
		case 1: ApplyAnimationEx(playerid, "CAR", "Sit_relaxed", 4.1, 0, 0, 0, 1, 1, 1, false);
		case 2: ApplyAnimationEx(playerid, "CAR", "Tap_hand", 1.8, 1, 1, 1, 1, 0, 1, false);
        case 3: ApplyAnimationEx(playerid, "GHETTO_DB", "GDB_Car2_PL", 1.8, 1, 1, 1, 1, 0, 1, false);
        case 4: ApplyAnimationEx(playerid, "LOWRIDER", "lrgirl_hurry", 1.8, 0, 1, 1, 1, 0, 1, false);
        case 5: ApplyAnimationEx(playerid, "LOWRIDER", "lrgirl_idleloop", 1.8, 1, 1, 1, 1, 0, 1, false);
        case 6: ApplyAnimationEx(playerid, "LOWRIDER", "lrgirl_l0_loop", 1.8, 1, 1, 1, 1, 0, 1, false);
        case 7: ApplyAnimationEx(playerid, "ped", "Tap_handP", 1.8, 1, 1, 1, 1, 0, 1, false);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/brazoventanilla [1-7]");
    }
	return 1;
}

CMD:motosierra(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
	if(sscanf(params,"i",anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/motosierra [1-3]");
	
    switch(anim)
	{
		case 1: ApplyAnimationEx(playerid, "CHAINSAW", "CSAW_G", 4.1, 0, 0, 0, 0, 0, 1); 
		case 2: ApplyAnimationEx(playerid, "CHAINSAW", "IDLE_csaw", 4.1, 1, 1, 1, 1, 0, 1, false);
        case 3: ApplyAnimationEx(playerid, "CHAINSAW", "WEAPON_csaw", 4.1, 0, 0, 0, 0, 0, 1);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/motosierra [1-3]");
    }
	return 1;
}

CMD:mirar(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
        
    new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mirar [1-8]");
	switch(anim)
	{
		case 1: ApplyAnimationEx(playerid, "INT_SHOP", "SHOP_LOOKA", 4.0, 1, 0, 0, 0, 0, 1, false, .finishAnimId = 1);
		case 2: ApplyAnimationEx(playerid, "INT_SHOP", "SHOP_LOOP", 4.0, 1, 0, 0, 0, 0, 1, false, .finishAnimId = 1);
        case 3: ApplyAnimationEx(playerid, "COP_AMBIENT", "Copbrowse_in", 4.1, 0, 1, 1, 1, 0, 1, false, .finishAnimId = 2);
        case 4: ApplyAnimationEx(playerid, "COP_AMBIENT", "Copbrowse_loop", 4.1, 0, 1, 1, 1, 0, 1, false, .finishAnimId = 2);
        case 5: ApplyAnimationEx(playerid, "COP_AMBIENT", "Copbrowse_nod", 4.1, 0, 1, 1, 1, 0, 1, false, .finishAnimId = 2);
        case 6: ApplyAnimationEx(playerid, "COP_AMBIENT", "Copbrowse_shake", 4.1, 0, 1, 1, 1, 0, 1, false, .finishAnimId = 2);
        case 7: ApplyAnimationEx(playerid, "FOOD", "SHP_Tray_return", 4.1, 0, 1, 1, 1, 0, 1, false, .finishAnimId = 12);
        case 8:  ApplyAnimationEx(playerid, "WUZI", "wuzi_grnd_chk", 4.1, 0, 0, 0, 0, 0, 1);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/mirar [1-8]");
	}
	return 1;
}

CMD:cbrazos(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
        
    new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/cbrazos [1-5]");
	switch(anim)
	{
        case 1: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_in", 4.1, 0, 1, 1, 1, 0, 1, false, .finishAnimId = 3);
        case 2: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_nod", 4.1, 0, 1, 1, 1, 0, 1, false, .finishAnimId = 3);
        case 3: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_shake", 4.1, 0, 1, 1, 1, 0, 1, false, .finishAnimId = 3);
        case 4: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_think", 4.1, 0, 1, 1, 1, 0, 1, false, .finishAnimId = 3);
        case 5: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_watch", 4.1, 0, 1, 1, 1, 0, 1, false, .finishAnimId = 3);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/cbrazos [1-5]");
	}
	return 1;
}

CMD:cmanos(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
        
    new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/cmanos [1-7]");
	switch(anim)
	{
        case 1: ApplyAnimationEx(playerid, "DEALER", "DEALER_DEAL", 4.1, 0, 1, 1, 1, 0, 1, false); 
        case 2: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 0, 1, false); 
        case 3: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_01", 4.1, 0, 1, 1, 1, 0, 1, false);
        case 4: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_02", 4.1, 0, 1, 1, 1, 0, 1, false);
        case 5: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_03", 4.1, 0, 1, 1, 1, 0, 1, false);
        case 6: ApplyAnimationEx(playerid, "GRAVEYARD", "mrnM_loop", 4.1, 1, 0, 0, 1, 0, 1, false);
        case 7: ApplyAnimationEx(playerid, "GRAVEYARD", "prst_loopa", 4.1, 1, 0, 0, 1, 0, 1, false);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/cmanos [1-7]");
	}
	return 1;
}

CMD:animpagar(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
        
    ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, false);
	return 1;
}

CMD:jugarplay(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
        
    new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/jugarplay [1-3]");
	switch(anim)
	{
        case 1: ApplyAnimationEx(playerid, "CRIB", "PED_Console_Loop", 4.1, 1, 0, 0, 1, 0, 1, false); 
        case 2: ApplyAnimationEx(playerid, "CRIB", "PED_Console_Loose", 4.1, 0, 0, 0, 1, 0, 1, false); 
        case 3: ApplyAnimationEx(playerid, "CRIB", "PED_Console_Win", 4.1, 0, 0, 0, 1, 0, 1, false);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/jugarplay [1-3]");
	}
	return 1;
}

CMD:cansado(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
        
    new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/cansado [1-2]");
	switch(anim)
	{
        case 1: ApplyAnimationEx(playerid, "FAT", "IDLE_tired", 4.1, 0, 1, 1, 1, 0, 1, false); 
        case 2: ApplyAnimationEx(playerid, "ped", "IDLE_tired", 4.1, 0, 1, 1, 1, 0, 1, false); 

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/cansado [1-2]");
	}
	return 1;
}

CMD:balcon(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

    new anim;
    if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/balcon [1-3]");
	switch(anim)
	{
        case 1: ApplyAnimationEx(playerid, "BD_FIRE", "BD_Panic_Loop", 4.1, 0, 1, 1, 1, 0, 1, false); 
        case 2: ApplyAnimationEx(playerid, "FOOD", "SHP_Tray_Pose", 4.1, 0, 1, 1, 1, 0, 1, false, .finishAnimId = 12);
        case 3: ApplyAnimationEx(playerid, "INT_SHOP", "shop_in", 4.1, 0, 1, 1, 1, 0, 1, false, .finishAnimId = 8);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/balcon [1-3]");
	}
	return 1;
}

CMD:acomer(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/acomer [1-4]");
	switch(anim)
	{
		case 1: ApplyAnimationEx(playerid, "FOOD", "EAT_BURGER", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "FOOD", "EAT_CHICKEN", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "FOOD", "EAT_PIZZA", 4.1, 0, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "VENDING", "vend_eat1_P", 4.1, 0, 0, 0, 0, 0, 1);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/acomer [1-4]");
	}
	return 1;
}

CMD:vomitar(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    ApplyAnimationEx(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 0, 0, 0, 0, 1); 
	return 1;
}

CMD:apoyarse(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/apoyarse [1-3]");
	switch(anim)
	{
		case 1: ApplyAnimationEx(playerid, "GANGS", "leanIN", 4.1, 0, 0, 0, 1, 0, 1, false, .finishAnimId = 5);
        case 2: ApplyAnimationEx(playerid, "MISC", "Plyrlean_loop", 4.1, 0, 0, 0, 1, 0, 1, false);
        case 3: ApplyAnimationEx(playerid, "OTB", "wtchrace_in", 4.1, 0, 0, 0, 1, 0, 1, false, .finishAnimId = 13);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/apoyarse [1-3]");
	}
	return 1;
}

CMD:empujar(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/empujar [1-3]");
	switch(anim)
	{
		case 1: ApplyAnimationEx(playerid, "GANGS", "shake_cara", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "GANGS", "shake_carK", 4.1, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "GANGS", "shake_carSH", 4.1, 0, 0, 0, 0, 0, 1);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/empujar [1-3]");
	}
	return 1;
}

CMD:llorar(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    ApplyAnimationEx(playerid, "GRAVEYARD", "mrnF_loop", 4.1, 1, 0, 0, 0, 0, 1, false); 
	return 1;
}

CMD:cubrirse(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    
    new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/cubrirse [1-2]");
	switch(anim)
	{
		case 1: ApplyAnimationEx(playerid, "HEIST9", "swt_wllpk_L_back", 4.1, 0, 1, 1, 1, 0, 1, false);
        case 2: ApplyAnimationEx(playerid, "PED", "cower", 4.1, 0, 1, 1, 1, 0, 1, false);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/cubrirse [1-2]");
	}
	return 1;
}

CMD:pasartarjeta(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    
    ApplyAnimationEx(playerid, "HEIST9", "USE_SWIPECARD", 4.0, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:quebrar(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

    ApplyAnimationEx(playerid, "MISC", "PLUNGER_01", 4.0, 0, 0, 0, 0, 0, 1); 
    return 1;
}

CMD:quepaso(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

	ApplyAnimationEx(playerid, "MISC", "PLYR_SHKHEAD", 4.0, 0, 0, 0, 0, 0, 1); 
	return 1;
}

CMD:chupala(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

	ApplyAnimationEx(playerid, "MISC", "SCRATCHBALLS_01", 4.0, 0, 0, 0, 0, 0, 1); 
    return 1;
}

CMD:dormir(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
	
    new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/dormir [1-4]");
	switch(anim)
	{
		case 1: ApplyAnimationEx(playerid, "INT_HOUSE", "BED_IN_L", 4.0, 0, 0, 0, 1, 0, 1, false);
		case 2: ApplyAnimationEx(playerid, "INT_HOUSE", "BED_OUT_L", 4.0, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "INT_HOUSE", "BED_IN_R", 4.0, 0, 0, 0, 1, 0, 1, false);
		case 4: ApplyAnimationEx(playerid, "INT_HOUSE", "BED_OUT_R", 4.0, 0, 0, 0, 0, 0 ,1);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/dormir [1-4]");
	}
	return 1;
}

CMD:caminar(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

 	new animid;
	if(sscanf(params, "d", animid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/caminar [1-15]");
	switch(animid)
	{
		case 1: ApplyAnimationEx(playerid, "WUZI", "WUZI_WALK", 4.1, 1, 1, 1, 1, 1, 1, false);
		case 2: ApplyAnimationEx(playerid, "PED", "WALK_fat", 4.1, 1, 1, 1, 1, 1, 1, false);
		case 3: ApplyAnimationEx(playerid, "PED", "WALK_fatold", 4.1, 1, 1, 1, 1, 1, 1, false);
		case 4: ApplyAnimationEx(playerid, "PED", "WALK_gang1", 4.1, 1, 1, 1, 1, 1, 1, false);
		case 5: ApplyAnimationEx(playerid, "PED", "WALK_gang2", 4.1, 1, 1, 1, 1, 1, 1, false);
		case 6: ApplyAnimationEx(playerid, "PED", "WALK_old", 4.1, 1, 1, 1, 1, 1, 1, false);
		case 7: ApplyAnimationEx(playerid, "PED", "WALK_wuzi", 4.1, 1, 1, 1, 1, 1, 1, false);
		case 8: ApplyAnimationEx(playerid, "PED", "WOMAN_walkold", 4.1, 1, 1, 1, 1, 1, 1, false);
		case 9: ApplyAnimationEx(playerid, "PED", "WOMAN_walkpro", 4.1, 1, 1, 1, 1, 1, 1, false);
		case 10: ApplyAnimationEx(playerid, "PED", "WOMAN_walksexy", 4.1, 1, 1, 1, 1, 1, 1, false);
		case 11: ApplyAnimationEx(playerid, "PED", "WOMAN_walkshop", 4.1, 1, 1, 1, 1, 1, 1, false);
		case 12: ApplyAnimationEx(playerid, "PED", "WALK_shuffle", 4.1, 1, 1, 1, 1, 1, 1, false);
		case 13: ApplyAnimationEx(playerid, "MUSCULAR", "MUSCLEWALK", 4.1, 1, 1, 1, 1, 1, 1, false);
        case 14: ApplyAnimationEx(playerid, "MUSCULAR", "MUSCLEWALK", 4.1, 1, 1, 1, 1, 1, 1, false);
        case 15: ApplyAnimationEx(playerid, "PED", "Cop_move_FWD", 4.1, 1, 1, 1, 1, 1, 1, false);

		default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/caminar [1-15]");
	}
	return 1;
}

CMD:afumar(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

 	new animid;
	if(sscanf(params, "d", animid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/afumar [1-4]");
	switch(animid)
	{
		case 1: ApplyAnimationEx(playerid, "SMOKING", "M_smklean_loop", 4.1, 0, 1, 1, 1, 0, 1, false);
		case 2: ApplyAnimationEx(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "SMOKING", "M_smk_out", 4.1, 0, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "SMOKING", "M_smk_tap", 4.1, 0, 0, 0, 0, 0, 1);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/afumar [1-4]");
	}
	return 1;
}

CMD:gesto(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

 	new animid;
	if(sscanf(params, "d", animid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/gesto [1-3]");
	switch(animid)
	{
        case 1: ApplyAnimationEx(playerid, "WUZI", "wuzi_follow", 4.1, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "SWAT", "swt_sty", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "SWAT", "swt_lkt", 4.1, 0, 0, 0, 0, 0, 1);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/gesto [1-3]");
	}
	return 1;
}

CMD:tantear(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

	ApplyAnimationEx(playerid, "SWEET", "SWEET_ASS_SLAP", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:apuntar(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

 	new animid;
	if(sscanf(params, "d", animid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/apuntar [1-4]");
	switch(animid)
	{
		case 1: ApplyAnimationEx(playerid, "SWORD", "sword_IDLE", 4.1, 1, 0, 0, 0, 0, 1, false);
        case 2: ApplyAnimationEx(playerid, "ped", "ARRESTgun", 4.1, 0, 1, 1, 1, 0, 1, false);
        case 3: ApplyAnimationEx(playerid, "ped", "gang_gunstand", 4.1, 1, 0, 0, 0, 0, 1, false);
        case 4: ApplyAnimationEx(playerid, "SHOP", "SHP_Gun_Aim", 4.1, 0, 1, 1, 1, 0, 1, false);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/apuntar [1-4]");
	}
	return 1;
}

CMD:arrastrarse(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
 	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    
	ApplyAnimationEx(playerid, "WUZI", "CS_DEAD_GUY", 4.0, 1, 1, 1, 0, 0, 1, false); // /arrastrarse
	return 1;
}

CMD:rapear(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
	
    new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/rapear [1-3]");
	switch(anim)
	{
		case 1: ApplyAnimationEx(playerid, "LOWRIDER", "RAP_A_LOOP", 4.0, 1, 0, 0, 1, 0, 1, false);
		case 2: ApplyAnimationEx(playerid, "LOWRIDER", "RAP_B_LOOP", 4.0, 1, 0, 0, 1, 0, 1, false);
		case 3: ApplyAnimationEx(playerid, "LOWRIDER", "RAP_C_LOOP", 4.0, 1, 0, 0, 1, 0, 1, false);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/rapear [1-3]");
	}
	return 1;
}

CMD:reanimar(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    ApplyAnimationEx(playerid, "MEDIC", "CPR", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:taxi(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
	
    new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/taxi [1-3]");
	switch(anim)
	{
		case 1: ApplyAnimationEx(playerid, "MISC", "HIKER_POSE_L", 4.0, 1, 0, 0, 0, 0, 1, false);
		case 2: ApplyAnimationEx(playerid, "MISC", "HIKER_POSE", 4.0, 1, 0, 0, 0, 0, 1, false);
        case 3: ApplyAnimationEx(playerid, "ped", "IDLE_taxi", 2.8, 0, 0, 0, 0, 0, 1);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/taxi [1-3]");
	}
	return 1;
}

CMD:alentar(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
	
    new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/alentar [1-4]");
	switch(anim)
	{
		case 1: ApplyAnimationEx(playerid, "RIOT", "RIOT_PUNCHES", 4.0, 1, 1, 1, 0, 0, 1, false);
		case 2: ApplyAnimationEx(playerid, "RIOT", "RIOT_SHOUT", 4.0, 0, 1, 1, 0, 0, 1, false);
        case 3: ApplyAnimationEx(playerid, "ON_LOOKERS", "shout_01", 4.0, 0, 1, 1, 0, 0, 1, false);
        case 4: ApplyAnimationEx(playerid, "ON_LOOKERS", "shout_02", 4.0, 0, 1, 1, 0, 0, 1, false);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/alentar [1-4]");
	}
	return 1;
}

CMD:taichi(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    
    ApplyAnimationEx(playerid, "PARK", "TAI_CHI_LOOP", 4.0, 1, 0, 0, 0, 0, 1, false, .finishAnimId = 14);
    return 1;
}

CMD:mear(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
    
    ApplyAnimationEx(playerid, "PAULNMAC", "Piss_loop", 4.0, 1, 0, 0, 0, 0, 1, false, .finishAnimId = 15);
    return 1;
}

CMD:paja(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

	new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/paja [1-2]");
	switch(anim)
	{
		case 1: ApplyAnimationEx(playerid, "PAULNMAC", "wank_in", 4.0, 0, 1, 1, 1, 0, 1, false, .finishAnimId = 16);
		case 2: ApplyAnimationEx(playerid, "PAULNMAC", "wank_loop", 4.0, 1, 0, 0, 0, 0, 1, false, .finishAnimId = 16);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/paja [1-2]");
	}
	return 1;
}

CMD:alpiso(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

	new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/alpiso [1-2]");
	switch(anim)
	{
        case 1: ApplyAnimationEx(playerid, "ped", "FLOOR_hit", 4.0, 0, 1, 1, 1, 0, 1, false, .finishAnimId = 17);
        case 2: ApplyAnimationEx(playerid, "ped", "FLOOR_hit_f", 4.0, 0, 1, 1, 1, 0, 1, false, .finishAnimId = 18);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/alpiso [1-2]");
	}
	return 1;
}

CMD:manosarriba(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

	ApplyAnimationEx(playerid, "PED", "handsup",4.0 , 0, 1, 1, 1, 0, 1, false);
	return 1;
}

CMD:atelefono(playerid, params)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

	ApplyAnimationEx(playerid, "PED", "phone_talk", 1.8 , 1, 1, 1, 1, 1, 1, false, .finishAnimId = 19);
	return 1;
}

CMD:arevisar(playerid, params)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

	ApplyAnimationEx(playerid, "POOL", "POOL_Place_White", 2.8 , 1, 1, 1, 1, 0, 1, false);
	return 1;
}

CMD:trafico(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

	new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/trafico [1-4]");
	switch(anim)
	{
        case 1: ApplyAnimationEx(playerid, "POLICE", "CopTraf_Away", 4.0, 0, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "POLICE", "CopTraf_Come", 4.0, 0, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "POLICE", "CopTraf_Left", 4.0, 0, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "POLICE", "CopTraf_Stop", 4.0, 0, 0, 0, 0, 0, 1);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/trafico [1-4]");
	}
	return 1;
}

CMD:pool(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

	new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/pool [1-9]");
	switch(anim)
	{
        case 1: ApplyAnimationEx(playerid, "POOL", "POOL_ChalkCue", 4.1, 0, 1, 1, 1, 0, 1, false);
        case 2: ApplyAnimationEx(playerid, "POOL", "POOL_Idle_Stance", 4.1, 1, 0, 0, 0, 0, 1, false);
        case 3: ApplyAnimationEx(playerid, "POOL", "POOL_Long_Start", 4.0, 0, 1, 1, 1, 0, 1, false);
        case 4: ApplyAnimationEx(playerid, "POOL", "POOL_Long_Shot", 4.0, 0, 0, 0, 0, 0, 1, false);
        case 5: ApplyAnimationEx(playerid, "POOL", "POOL_Med_Start", 4.0, 0, 1, 1, 1, 0, 1, false);
        case 6: ApplyAnimationEx(playerid, "POOL", "POOL_Med_Shot", 4.0, 0, 0, 0, 0, 0, 1, false);
        case 7: ApplyAnimationEx(playerid, "POOL", "POOL_Short_Shot", 4.0, 0, 1, 1, 1, 0, 1, false);
        case 8: ApplyAnimationEx(playerid, "POOL", "POOL_Short_Start", 4.0, 0, 0, 0, 0, 0, 1, false);
        case 9: ApplyAnimationEx(playerid, "POOL", "POOL_Place_White", 4.0, 0, 0, 0, 0, 0, 1, false);
 
        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/pool [1-9]");
	}
	return 1;
}

CMD:borracho(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

	new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/borracho [1-3]");
	switch(anim)
	{
		case 1: ApplyAnimationEx(playerid, "PED", "WALK_drunk", 4.1, 1, 1, 1, 1, 1, 1, false);
		case 2: ApplyAnimationEx(playerid, "PAULNMAC", "PNM_LOOP_A", 4.0, 1, 0, 0, 0, 0, 1, false);
		case 3: ApplyAnimationEx(playerid, "PAULNMAC", "PNM_LOOP_B", 4.0, 1, 0, 0, 0, 0, 1, false);

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/borracho [1-3]");
	}
	return 1;
}

CMD:chocado(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");

    ApplyAnimationEx(playerid, "MD_CHASE", "CARHIT_TUMBLE", 4.0, 0, 1, 1, 1, 0, 1, false);
	return 1;
}

CMD:enojado(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Solo puedes utilizarlo de pie!");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE) 
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No puedes utilizar esto estando incapacitado/congelado!");
	
    new anim;
	if(sscanf(params, "d", anim))
	    return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/enojado [1-2]");
	switch(anim)
	{
		case 1: ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY", 4.0, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "RIOT", "RIOT_CHANT", 4.0, 0, 0, 0, 0, 0, 1); 

        default: SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/enojado [1-2]");
	}
	return 1;
}
// /applyanimation CRIB CRIB_Use_Switch 4.1 0 0 0 0 0 1 animacion de tocar boton o que simula abrir una puerta.


