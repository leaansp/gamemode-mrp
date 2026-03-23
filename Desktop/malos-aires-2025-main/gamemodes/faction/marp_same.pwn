#if defined _marp_same_included
	#endinput
#endif
#define _marp_same_included

#include <YSI_Coding\y_hooks>

#define PRICE_HOSP_HEAL        	1000

// Tabla de precios y retenciones según rango del médico
enum e_MEDIC_PRICE_INFO
{
	medicRank,
	medicPrice_Light,     // Herida leve
	medicPrice_Severe,    // Herida grave
	medicRetention        // Porcentaje de retención al fondo faccionario
}

// Tabla: índice 0 == Rango 1 (Director), siguiente índices ascendente por rango
static const MedicPriceTable[][e_MEDIC_PRICE_INFO] = {
	// {RangoIndex, Herida Leve, Herida Grave, Retención%}
	{0, 300, 500, 20},    // Rango 1: Director (tope $500, retención 20%)
	{1, 300, 500, 20},    // Rango 2: Cirujano Especialista (comparte techo e impuesto con Director)
	{2, 300, 450, 15},    // Rango 3: Instrumentador quirúrgico
	{3, 300, 400, 15},    // Rango 4: Médico de emergencias
	{4, 250, 350, 15},    // Rango 5: Licenciado en enfermería
	{5, 200, 300, 5},     // Rango 6: Licenciado en paramedicina
	{6, 150, 250, 0},     // Rango 7: Auxiliar paramédico
	{7, 150, 250, 0}      // Rango 8: Interno (comparte techo con Auxiliar)
};


stock Same_GetMedicPrice(medicid, is_severe = 0)
{
	new rank_index = PlayerInfo[medicid][pRank] - 1; // pRank es 1-based en DB
	if(rank_index < 0) rank_index = 0;
	if(rank_index >= sizeof(MedicPriceTable)) rank_index = sizeof(MedicPriceTable) - 1;

	if(is_severe)
		return MedicPriceTable[rank_index][medicPrice_Severe];
	else
		return MedicPriceTable[rank_index][medicPrice_Light];
}

stock Same_GetMedicRetention(medicid)
{
	new rank_index = PlayerInfo[medicid][pRank] - 1;
	if(rank_index < 0) rank_index = 0;
	if(rank_index >= sizeof(MedicPriceTable)) rank_index = sizeof(MedicPriceTable) - 1;

	return MedicPriceTable[rank_index][medicRetention];
}

// Duración de curación según rango (en segundos)
stock Same_GetHealingDuration(medicid)
{
	if(!IsMedicOnDuty(medicid))
		return 20; // Civiles: 20 segundos

	// Médicos: 15s base - 2s por cada rango
	new rank = PlayerInfo[medicid][pRank];
	if(rank < 1) rank = 1;
	if(rank > 8) rank = 8;
	
	new duration = 15 - ((rank - 1) * 2);
	if(duration < 1) duration = 1;
	
	return duration;
}

forward Same_FinishHealing(playerid);

#define POS_HOSP_HEAL_X_1		-2315.10
#define POS_HOSP_HEAL_Y_1		-2305.12
#define POS_HOSP_HEAL_Z_1		801.08 

#define POS_HOSP_HEAL_X_2		-2337.34
#define POS_HOSP_HEAL_Y_2		190.63 
#define POS_HOSP_HEAL_Z_2		1546.99 

new HospHealing[MAX_PLAYERS];

CountMedicsOnDuty()
{
	new aux = 0;
 	foreach(new i : Player)
 	{
        if(IsMedicOnDuty(i))
    	    aux ++;
 	}
 	return aux;
}

IsMedicOnDuty(playerid) {
	return (PlayerInfo[playerid][pFaction] == FAC_HOSP && MedDuty[playerid]);
}

Same_CanEnterDuty(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new equipid = EquipmentPoint_GetId(playerid);   
	
	if(Veh_GetSystemType(vehicleid) == VEH_FACTION && VehicleInfo[vehicleid][VehFaction] == FAC_HOSP)
		return 1;
	else if(EquipmentPoint_IsPlayerAt(playerid))
		return EquipmentPoint_CanPlayerUse(playerid, equipid);
	
	return 0;
}

Same_IsInHealingZone(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 3.0, POS_HOSP_HEAL_X_1, POS_HOSP_HEAL_Y_1, POS_HOSP_HEAL_Z_1) ||
		IsPlayerInRangeOfPoint(playerid, 3.0, POS_HOSP_HEAL_X_2, POS_HOSP_HEAL_Y_2, POS_HOSP_HEAL_Z_2))
		return 1;

	return 0;
}

CMD:mservicio(playerid, params[])
{
	//new string[128];

    if(PlayerInfo[playerid][pFaction] != FAC_HOSP)
		return 1;
	if(!Same_CanEnterDuty(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar en el vestuario o en un vehículo de tu facción!");

	if(MedDuty[playerid] == 0)
	{
		SetPlayerHealthEx(playerid, 100.0);
		MedDuty[playerid] = 1;
		PlayerActionMessage(playerid, 15.0, "se coloca su uniforme y morral médico.");
	}
	else
	{
		PlayerActionMessage(playerid, 15.0, "se quita el uniforme de médico y guarda su morral en el armario.");
		SetPlayerHealthEx(playerid, 100.0);
		MedDuty[playerid] = 0;
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	}
	return 1;
}

forward HospHeal(playerid);
public HospHeal(playerid)
{
	if(HospHealing[playerid])
	{
		TogglePlayerControllable(playerid, 1);
		SetPlayerHealthEx(playerid, 100.0);
		HospHealing[playerid] = 0;
        PlayerDoMessage(playerid, 15.0, "El médico ha finalizado el tratamiento del paciente.");
        PlayerInfo[playerid][pDisabled] = DISABLE_NONE;
	}
    return 1;
}

CMD:curarse(playerid, params[])
{
	new string[128];

    /*if(Bld_GetPlayerLastId(playerid) != BLD_HOSP && Bld_GetPlayerLastId(playerid) != BLD_HOSP2)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en un hospital para usar este comando.");*/
	if(!Same_IsInHealingZone(playerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes registrarte en la sala de recuperación.");
	if(CountMedicsOnDuty() > 0)
	    return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Actualmente hay un médico en servicio, ponte en contacto con él para que te atienda.");
	if(HospHealing[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya estás siendo curado.");
	if(GetPlayerCash(playerid) < PRICE_HOSP_HEAL)
	{
	    SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes el dinero necesario para el tratamiento ($%d).", PRICE_HOSP_HEAL);
		return 1;
	}

	GivePlayerCash(playerid, -PRICE_HOSP_HEAL);
	Faction_GiveMoney(FAC_HOSP, PRICE_HOSP_HEAL);
	PlayerDoMessage(playerid, 15.0, "Un médico examina al paciente y tras un diagnóstico inicial, comienza a curarlo.");
	TogglePlayerControllable(playerid, 0);
	SetTimerEx("HospHeal", 30000, false, "i", playerid);

	new str[BLD_MAX_TEXT_LENGTH];
	Bld_GetOusideText(Bld_GetPlayerLastId(playerid), str);

	format(string, sizeof(string), "[Hospital]: El paciente %s se ha registrado en el %s y está siendo atendido.", GetPlayerCleanName(playerid), str);
	SendFactionMessage(FAC_HOSP, COLOR_WHITE, string);
	HospHealing[playerid] = 1;
	PlayerInfo[playerid][pDisabled] = DISABLE_HEALING;
	GameTextForPlayer(playerid, "Aguarda unos instantes mientras te atienden", 10000, 4);
	return 1;
}

CMD:curar(playerid,params[])
{
    new target, cost;
	
	// Verificar que tenga kit médico en mano (cualquier persona puede intentar usar el kit)
	new hand = SearchHandsForItem(playerid, ITEM_ID_MEDIC_CASE);
	if(hand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Necesitas un maletín de primeros auxilios en mano para curar!");
	
	new uses = GetHandParam(playerid, hand);
	if(uses <= 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Tu maletín de primeros auxilios no tiene usos disponibles!");
	
	if(sscanf(params, "ud", target, cost))
	{
		if(IsMedicOnDuty(playerid))
		{
			new price_light = Same_GetMedicPrice(playerid, 0);
			new price_severe = Same_GetMedicPrice(playerid, 1);
			SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/curar [ID/Jugador] [precio]");
			SendFMessage(playerid, COLOR_INFO, "[INFO] Precios recomendados: Herida Leve $%d | Herida Grave $%d", price_light, price_severe);
			if(cost < 150 || cost > 500)
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡El costo debe estar entre $150 y $500!");
		}
		else
		{
			// Civiles no pueden cobrar; forzar 0
			if(cost != 0) cost = 0;
		}
	}
	
    if(GetPVarInt(playerid, "isHealing") != 0)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Ya estás curando a una persona: debes esperar 15 segundos para usar nuevamente el comando!");
	if(target == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Jugador inválido.");
	if(target == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes curarte a ti mismo.");
	if(!IsPlayerInRangeOfPlayer(2.0, playerid, target))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar cerca del herido!");
	if(PlayerInfo[target][pDisabled] == DISABLE_DEATHBED)
  		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto se encuentra en su lecho de muerte y no hay nada que puedas hacer por él.");

	// Versión para médicos y civiles
	if(IsMedicOnDuty(playerid))
	{
		SendFMessage(target, COLOR_LIGHTBLUE, "El médico %s te ha ofrecido un tratamiento curativo completo por $%d. Escribe (/aceptar medico) para recibirlo.", GetPlayerCleanName(playerid), cost);
		SendFMessage(playerid, COLOR_LIGHTBLUE, "Le has ofrecido a %s un tratamiento curativo completo por $%d.", GetPlayerCleanName(target), cost);
		SendClientMessage(target, COLOR_WHITE, "Si no tienes el dinero, se te cobrará hasta lo que tengas, y el resto se descontará de tu cuenta bancaria.");
	}
	else
	{
		SendFMessage(target, COLOR_LIGHTYELLOW2, "%s te ofrece primeros auxilios gratuitos (máx. 30%% HP). Escribe (/aceptar medico) para aceptar.", GetPlayerCleanName(playerid));
		SendFMessage(playerid, COLOR_LIGHTYELLOW2, "Has ofrecido primeros auxilios básicos gratuitos a %s (máx. 30%% HP).", GetPlayerCleanName(target));
	}

	// Si el que intenta curar NO es médico, verificar HP del herido ahora
	if(!IsMedicOnDuty(playerid))
	{
		new Float:target_hp;
		GetPlayerHealth(target, target_hp);
		if(target_hp > 30.0)
		{
			SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"El paciente necesita atención médica profesional (HP > 30%).");
			SendClientMessage(target, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Necesitas ir al hospital para curarte por completo.");
			return 1;
		}
	}
	SetPVarInt(playerid, "healTarget", target);
	SetPVarInt(playerid, "isHealing", 1);
	SetPVarInt(target, "healIssuer", playerid);
	SetPVarInt(target, "healCost", cost);
	new offer_timer = SetTimerEx("healTimer", 15000, false, "i", playerid);
	SetPVarInt(playerid, "healOfferTimerId", offer_timer);
	return 1;
}

hook function OnPlayerCmdAccept(playerid, const subcmd[])
{
	if(strcmp(subcmd, "medico", true))
		return continue(playerid, subcmd);

	if(GetPVarInt(GetPVarInt(playerid, "healIssuer"), "isHealing") == 1)
	{
		new medic = GetPVarInt(playerid, "healIssuer");
		if(medic == playerid)
		{
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes aceptarte tu propio tratamiento.");
			SetPVarInt(medic, "isHealing", 0);
			return 1;
		}
		
		// Verificar nuevamente que el médico tenga el kit
		new hand = SearchHandsForItem(medic, ITEM_ID_MEDIC_CASE);
		if(hand == -1 || GetHandParam(medic, hand) <= 0)
		{
			SendClientMessage(medic, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Ya no tienes el maletín de primeros auxilios para realizar la curación!");
			SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡El médico ya no tiene su maletín disponible!");
			SetPVarInt(medic, "isHealing", 0);
			return 1;
		}
		
		// Iniciar proceso de curación con animación y timer
		new cure_time = Same_GetHealingDuration(medic);

		if(IsMedicOnDuty(medic)) {
			SendFMessage(medic, COLOR_LIGHTGREEN, "Comenzando tratamiento médico (%ds)...", cure_time);
			SendFMessage(playerid, COLOR_LIGHTGREEN, "El médico %s ha comenzado tu tratamiento (%ds)...", GetPlayerCleanName(medic), cure_time);
		} else {
			SendFMessage(medic, COLOR_LIGHTYELLOW2, "Aplicando primeros auxilios (%ds)...", cure_time);
			SendFMessage(playerid, COLOR_LIGHTYELLOW2, "%s está aplicando primeros auxilios (%ds)...", GetPlayerCleanName(medic), cure_time);
		}

		// Aplicar animación y bloquear controles (forzar sync y evitar autofinish para que ambos la vean)
		ApplyAnimationEx(medic, "MEDIC", "CPR", 4.1, 1, 0, 0, 0, cure_time * 1000, 1, false);
		ApplyAnimationEx(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 1, cure_time * 1000, 1, false);
		TogglePlayerControllable(medic, false);
		TogglePlayerControllable(playerid, false);

		// Cancelar timer de oferta y guardar timer de curación
		new offer_timer = GetPVarInt(medic, "healOfferTimerId");
		if(offer_timer != 0) {
			KillTimer(offer_timer);
			SetPVarInt(medic, "healOfferTimerId", 0);
		}
		
		new timerid = SetTimerEx("Same_FinishHealing", cure_time * 1000, false, "i", playerid);
		SetPVarInt(medic, "healTimerId", timerid);
		SendClientMessage(medic, COLOR_GREY, "[INFO] Presiona la tecla de disparo para cancelar.");
	}
	else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" Ningún médico te ha ofrecido tratamiento!");
	}
	return 1;
}

stock Same_CancelHealing(medicid)
{
	new target = GetPVarInt(medicid, "healTarget");
	if(target == INVALID_PLAYER_ID) return 0;

	// Only cancel if there is an active heal or a running timer
	new isHealing = GetPVarInt(medicid, "isHealing");
	new timerid = GetPVarInt(medicid, "healTimerId");
	if(isHealing == 0 && timerid == 0) return 0;

	// Detener animación y timer
	ClearAnimations(medicid);
	if(timerid != 0) KillTimer(timerid);

	// Descongelar médico
	TogglePlayerControllable(medicid, true);
	
	// Solo descongelar paciente si HP > 15, sino mantenerlo en crack
	if(IsPlayerConnected(target)) {
		new Float:target_hp;
		GetPlayerHealth(target, target_hp);
		if(target_hp > 15.0) {
			// Si el jugador está en estado 'crack' (pCrack), preservamos la animación de crack
			if(PlayerInfo[target][pCrack]) {
				ApplyAnimationEx(target, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 1, 0, 1, false);
			} else {
				ClearAnimations(target);
				TogglePlayerControllable(target, true);
			}
		} else {
			// Mantener en estado crack indefinidamente
			ApplyAnimationEx(target, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 1, 0, 1, false);
		}
	}

	// Notificar (solo si había un proceso)
	SendClientMessage(medicid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" Has cancelado el proceso de curación.");
	if(IsPlayerConnected(target)) SendFMessage(target, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"%s ha cancelado el proceso de curación.", GetPlayerCleanName(medicid));

	// Limpiar vars
	SetPVarInt(medicid, "isHealing", 0);
	SetPVarInt(medicid, "healTarget", INVALID_PLAYER_ID);
	SetPVarInt(medicid, "healTimerId", 0);
	SetPVarInt(target, "healIssuer", INVALID_PLAYER_ID);
	SetPVarInt(target, "healCost", 0);
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if((newkeys & KEY_FIRE) && !(oldkeys & KEY_FIRE))
	{
		// Si es médico en proceso de curar
		if(GetPVarInt(playerid, "isHealing") == 1)
		{
			Same_CancelHealing(playerid);
			return 1;
		}

		// Si es paciente en proceso de ser curado
		new medic = GetPVarInt(playerid, "healIssuer");
		if(medic != INVALID_PLAYER_ID && IsPlayerConnected(medic))
		{
			new Float:hp; GetPlayerHealth(playerid, hp);
			// Si el paciente está inmovil (hp <= 15) sólo el médico puede cancelar
			if(hp <= 15.0)
			{
				// paciente no puede cancelar
				return 1;
			}
			// paciente puede cancelar normalmente
			Same_CancelHealing(medic);
			return 1;
		}
	}
	return 1;
}

public Same_FinishHealing(playerid)
{
	new medic = GetPVarInt(playerid, "healIssuer");
	if(medic == INVALID_PLAYER_ID) return 0;

	// Prohibir autocuración en cualquier caso
	if(medic == playerid)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes curarte a ti mismo.");
		SetPVarInt(medic, "isHealing", 0);
		SetPVarInt(medic, "healTarget", INVALID_PLAYER_ID);
		SetPVarInt(playerid, "healIssuer", INVALID_PLAYER_ID);
		return 1;
	}

	new price = GetPVarInt(playerid, "healCost");
	new victimcash = GetPlayerCash(playerid);

	// Limpiar timer ID
	SetPVarInt(medic, "healTimerId", 0);

	// Detener animación y desbloquear controles
	ClearAnimations(medic);
	TogglePlayerControllable(medic, true);
	// Si el paciente estaba en estado 'crack', reestablecer su animación de crack.
	if(PlayerInfo[playerid][pCrack]) {
		ApplyAnimationEx(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 1, 0, 1, false);
	} else {
		TogglePlayerControllable(playerid, true);
		ClearAnimations(playerid);
	}

	// Verificar que el médico TODAVÍA tenga el kit
	new hand = SearchHandsForItem(medic, ITEM_ID_MEDIC_CASE);
	if(hand == -1 || GetHandParam(medic, hand) <= 0)
	{
		SendClientMessage(medic, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Ya no tienes el maletín de primeros auxilios!");
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡La curación falló!");
		SetPVarInt(medic, "isHealing", 0);
		SetPVarInt(medic, "healTarget", INVALID_PLAYER_ID);
		SetPVarInt(playerid, "healIssuer", INVALID_PLAYER_ID);
		return 1;
	}

	// Aplicar curación
	if(IsMedicOnDuty(medic))
	{
		SetPlayerHealthEx(playerid, 100.00);
		SendClientMessage(playerid, COLOR_LIGHTGREEN, " ¡Has sido curado completamente por un médico profesional!");
	}
	else
	{
		SetPlayerHealthEx(playerid, 30.00);
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, " Has recibido primeros auxilios básicos (estabilizado al 30% HP).");
		SendClientMessage(medic, COLOR_LIGHTYELLOW2, " Has aplicado primeros auxilios básicos.");
	}

	PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
	PlayerPlaySound(medic, 1150, 0.0, 0.0, 0.0);

	// Consumir un uso del kit médico
	new remaining_uses = GetHandParam(medic, hand) - 1;
	if(remaining_uses > 0)
	{
		SetHandItemAndParam(medic, hand, ITEM_ID_MEDIC_CASE, remaining_uses);
		SendFMessage(medic, COLOR_INFO, "[INFO] Has utilizado tu maletín. Usos restantes: %d", remaining_uses);
	}
	else
	{
		SetHandItemAndParam(medic, hand, 0, 0);
		SendClientMessage(medic, COLOR_INFO, "[INFO] Has utilizado tu maletín y se ha agotado.");
	}

	// Log del uso del kit médico
	if(IsMedicOnDuty(medic))
	{
		new log_str[256], retention = Same_GetMedicRetention(medic);
		format(log_str, sizeof(log_str), "%s curó a %s por $%d (Retención: %d%%)", GetPlayerCleanName(medic), GetPlayerCleanName(playerid), price, retention);
		ServerLog(LOG_TYPE_ID_MONEY, .entry="CURACIÓN MÉDICA", .playerid=medic, .targetid=playerid, .params=log_str);
	}

	// Procesar pago solo si tiene costo (médicos profesionales)
	if(price > 0)
	{
		new retention_amount = floatround(price * Same_GetMedicRetention(medic) / 100.0);
		new medic_final_pay = price - retention_amount;

		if(victimcash > price)
		{
			GivePlayerCash(playerid, -price);
			GivePlayerCash(medic, medic_final_pay);
			FactionInfo[FAC_HOSP][fMaterials] += retention_amount;
			SendFMessage(playerid, COLOR_LIGHTBLUE, "Has aceptado el tratamiento por $%d en efectivo.", price);
			SendFMessage(medic, COLOR_LIGHTBLUE, "El herido ha pagado $%d. Recibiste $%d (Retención al fondo: $%d - %d%%).", price, medic_final_pay, retention_amount, Same_GetMedicRetention(medic));
		}
		else if(victimcash > 0)
		{
			new cash_paid = victimcash;
			new bank_debit = price - victimcash;
			new retention_cash = floatround(cash_paid * Same_GetMedicRetention(medic) / 100.0);
			new retention_bank = floatround(bank_debit * Same_GetMedicRetention(medic) / 100.0);

			if(PlayerInfo[playerid][pBank] > bank_debit)
			{
				PlayerInfo[playerid][pBank] -= bank_debit;
				PlayerInfo[medic][pPayCheck] += (bank_debit - retention_bank);
				FactionInfo[FAC_HOSP][fMaterials] += retention_bank;
			}
			else if(PlayerInfo[playerid][pBank] > 0)
			{
				PlayerInfo[medic][pPayCheck] += (PlayerInfo[playerid][pBank] - floatround(PlayerInfo[playerid][pBank] * Same_GetMedicRetention(medic) / 100.0));
				FactionInfo[FAC_HOSP][fMaterials] += floatround(PlayerInfo[playerid][pBank] * Same_GetMedicRetention(medic) / 100.0);
				PlayerInfo[playerid][pBank] = 0;
			}

			GivePlayerCash(medic, cash_paid - retention_cash);
			FactionInfo[FAC_HOSP][fMaterials] += retention_cash;
			ResetPlayerCash(playerid);

			new tmpstr[256];
			format(tmpstr, sizeof(tmpstr), "Has aceptado el tratamiento por $%d. Parte en efectivo y parte descontada del banco.", price);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, tmpstr);
			format(tmpstr, sizeof(tmpstr), "El herido pagó $%d (efectivo $%d + banco $%d). Recibiste $%d (Retención: $%d - %d%%).", price, cash_paid, bank_debit, medic_final_pay, retention_amount, Same_GetMedicRetention(medic));
			SendClientMessage(medic, COLOR_LIGHTBLUE, tmpstr);
		}
		else
		{
			if(PlayerInfo[playerid][pBank] > price)
			{
				PlayerInfo[playerid][pBank] -= price;
				PlayerInfo[medic][pPayCheck] += (price - retention_amount);
				FactionInfo[FAC_HOSP][fMaterials] += retention_amount;
			}
			else if(PlayerInfo[playerid][pBank] > 0)
			{
				new retention_bank = floatround(PlayerInfo[playerid][pBank] * Same_GetMedicRetention(medic) / 100.0);
				PlayerInfo[medic][pPayCheck] += (PlayerInfo[playerid][pBank] - retention_bank);
				FactionInfo[FAC_HOSP][fMaterials] += retention_bank;
				PlayerInfo[playerid][pBank] = 0;
			}
			new tmpstr[256];
			format(tmpstr, sizeof(tmpstr), "Has aceptado el tratamiento por $%d. Se descontó completamente de tu cuenta bancaria.", price);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, tmpstr);
			format(tmpstr, sizeof(tmpstr), "El herido pagó $%d por banco. Recibirás $%d en el Próximo Payday (Retención: $%d - %d%%).", price, (price - retention_amount), retention_amount, Same_GetMedicRetention(medic));
			SendClientMessage(medic, COLOR_LIGHTBLUE, tmpstr);
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTGREEN, " Has recibido primeros auxilios gratuitos.");
		SendClientMessage(medic, COLOR_LIGHTGREEN, " Has brindado primeros auxilios de forma altruista.");
	}

	// Limpiar estado
	SetPVarInt(medic, "isHealing", 0);
	SetPVarInt(medic, "healTarget", INVALID_PLAYER_ID);
	SetPVarInt(playerid, "healIssuer", INVALID_PLAYER_ID);
	SetPVarInt(playerid, "healCost", 0);
	return 1;
}

CMD:verregcurar(playerid, params[])
{
		new targetname[MAX_PLAYER_NAME];

		if(PlayerInfo[playerid][pFaction] != FAC_HOSP || PlayerInfo[playerid][pRank] != 1)
			return 1; // Sólo líder de SAME
		if(sscanf(params, "s[24]", targetname))
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/verregcurar [Nombre_Apellido del médico]");
		if(!IsNameRoleplayValid(targetname))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes utilizar el formato Nombre_Apellido.");

		mysql_f_tquery(MYSQL_HANDLE, 256, @Callback: "Same_OnLoadTreatments", "is", playerid, targetname @Format: "SELECT * FROM `log_money` WHERE `pName`='%e' AND `entry`='CURACIÓN MÉDICA' ORDER BY `id` DESC LIMIT 20;", targetname);
		SendFMessage(playerid, COLOR_INFO, "[INFO] Buscando curaciones de %s en la base de datos...", targetname);
		return 1;
}

static enum e_MEDIC_CLOTHES 
{
	mcSkin,
	mcDescription[32]
};

static const MedicClothes_Info[][e_MEDIC_CLOTHES] = {
	{-1, "Civil\n"},
	{276, "paramédico Masculino (1)\n"},
	{275, "paramédico Masculino (2)\n"},
	{274, "paramédico Masculino (3)\n"},
	{308, "paramédico Femenino (1)\n"},
	{277, "Bombero Masculino (1)\n"},
	{278, "Bombero Masculino (2)\n"},
	{279, "Bombero Masculino (3)\n"},
	{70, "médico\n"}
};

Dialog:dlg_medic_clothes(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(listitem == 0) {
			SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
			PlayerInfo[playerid][pJobSkin] = 0;
		} else {
			PlayerInfo[playerid][pJobSkin] = MedicClothes_Info[listitem][mcSkin]; 
			SetPlayerSkin(playerid, MedicClothes_Info[listitem][mcSkin]);
		}
		PlayerCmeMessage(playerid, 15.0, 4000, "Toma su vestimenta de los casilleros.");
	}
	return 1;
}

CMD:mropero(playerid, params[])
{
	if(!IsMedicOnDuty(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en servicio como médico.");
    if(!Same_CanEnterDuty(playerid))
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes estar en el vestuario o en un vehículo de tu facción.");

	new medic_clothes_str[256];

	for(new i = 0; i < sizeof(MedicClothes_Info); i++) {
		strcat(medic_clothes_str, MedicClothes_Info[i][mcDescription]);
	}

	Dialog_Show(playerid, dlg_medic_clothes, DIALOG_STYLE_LIST, "Selecciona la vestimenta a equipar:", medic_clothes_str, "Aceptar", "Cerrar");
	return 1;
}
