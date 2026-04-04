#if defined _marp_player_payday_inc
	#endinput
#endif
#define _marp_player_payday_inc

#include <YSI_Coding\y_hooks>

static String:gPaydayPlayerString[MAX_PLAYERS] = {STRING_NULL, ...};
new PaydayBonus[MAX_PLAYERS];


hook OnPlayerDisconnect(playerid, reason)
{
	if(gPaydayPlayerString[playerid] != STRING_NULL)
	{
		str_release(gPaydayPlayerString[playerid]);
		gPaydayPlayerString[playerid] = STRING_NULL;
	}
	return 1;
}

Payday(playerid)
{
	if(!IsPlayerLogged(playerid))
		return 0;
	if(gPaydayPlayerString[playerid] != STRING_NULL) {
		str_release(gPaydayPlayerString[playerid]);
	}

	new line[144], paydayStatement[2048];
	
	// Verificar si el jugador tiene experiencia doble activa
	new bool:hasDoubleExp = (DoubleExpActive && PlayerHasDoubleExp[playerid]);
	new expMultiplier = hasDoubleExp ? 2 : 1;

	BizEmp_ProcessEmployeePayday(playerid);

	//=============================EMPLEO===================================

	if(PlayerInfo[playerid][pPayCheck])
	{
		new payAmount = PlayerInfo[playerid][pPayCheck] * expMultiplier;
		format(line, sizeof(line), " \n"COLOR_EMB_USAGE"[Empleo]\tIngresos: $%i%s.\n", payAmount, hasDoubleExp ? " (x2)" : "");
		strcat(paydayStatement, line, sizeof(paydayStatement));
		PlayerInfo[playerid][pPayCheck] = payAmount;
	}

	/*_______________________________FACCION______________________________*/

	new factionPay;

	if(PlayerInfo[playerid][pFaction])
	{
		factionPay = Faction_GetRankSalary(PlayerInfo[playerid][pFaction], PlayerInfo[playerid][pRank]);
		new factionPayFinal = factionPay * expMultiplier;
		PlayerInfo[playerid][pPayCheck] += factionPayFinal;

		if(factionPay)
		{
			format(line, sizeof(line), " \n"COLOR_EMB_USAGE"[%s]\nSalario: $%i%s.\n", FactionInfo[PlayerInfo[playerid][pFaction]][fName], factionPayFinal, hasDoubleExp ? " (x2)" : "");
			strcat(paydayStatement, line, sizeof(paydayStatement));
		}
	}

	/*____________________________SALARIO FIJO____________________________*/

	if(!PlayerInfo[playerid][pCantWork] && !factionPay)
	{
		new socialPayFinal = socialPay * expMultiplier;
		PlayerInfo[playerid][pPayCheck] += socialPayFinal;
		format(line, sizeof(line), " \n"COLOR_EMB_USAGE"[Gobierno]\nAyuda social: $%i%s.\n", socialPayFinal, hasDoubleExp ? " (x2)" : "");
		strcat(paydayStatement, line, sizeof(paydayStatement));
		
	}


	//_____________INGRESOS E IMPUESTOS DE BIENES PERSONALES______________*/

	new income, tax;
	KeyChain_OnPlayerPayday(playerid, income, tax);

	// Aplicar bonos pendientes antes de calcular el nuevo balance
	if(PaydayBonus[playerid] > 0)
	{
		new bonusFinal = PaydayBonus[playerid] * expMultiplier;
		PlayerInfo[playerid][pPayCheck] += bonusFinal;
		format(line, sizeof(line), " \n"COLOR_EMB_USAGE"[Gobierno]\nBono especial: $%i%s.\n", bonusFinal, hasDoubleExp ? " (x2)" : "");
		strcat(paydayStatement, line, sizeof(paydayStatement));
		PaydayBonus[playerid] = 0; // Se borra después de pagarlo
	}

	//========================CONTROL DE BARRIOS============================

	/*if(Faction_IsValidId(PlayerInfo[playerid][pFaction]))
	{
		if(Faction_HasTag(PlayerInfo[playerid][pFaction], FAC_TAG_ALLOW_GANGZONE) && PlayerInfo[playerid][pRank] == 1)
		{
			new gangProfits = GetGangZoneLiderIncome(playerid);
			Faction_GiveMoney(PlayerInfo[playerid][pFaction], gangProfits);
			format(line, sizeof(line), " \n"COLOR_EMB_USAGE"[%s]\nIngresos faccionarios por control de barrios: $%i.\n", FactionInfo[PlayerInfo[playerid][pFaction]][fName], gangProfits);
			strcat(paydayStatement, line, sizeof(paydayStatement));
		}
	}*/

	//========================COSTOS BANCARIOS==============================

	new banktax = floatround(PlayerInfo[playerid][pBank] * 0.0003, floatround_ceil);

	if(banktax < 50) {
		banktax = 50; // mínimo de 50 pesos por tener la cuenta abierta
	}

	//============================INGRESOS==================================

	new newbank = PlayerInfo[playerid][pBank] + PlayerInfo[playerid][pPayCheck] + income - tax - banktax;

	Faction_GiveMoney(FAC_GOB, tax);

	format(line, sizeof(line), " \n"COLOR_EMB_USAGE"[Gobierno]\nImpuestos por bienes personales: $-%i.\n", tax);
	strcat(paydayStatement, line, sizeof(paydayStatement));

	format(line, sizeof(line), " \n"COLOR_EMB_USAGE"[Propiedades]\nOtros ingresos/egresos: $%i.\n", income);
	strcat(paydayStatement, line, sizeof(paydayStatement));

	format(line, sizeof(line), " \n"COLOR_EMB_USAGE"[Banco]\nCosto de mantenimiento de cuenta: $%i.\nBalance anterior: $%i - Nuevo balance: $%i.\n", banktax, PlayerInfo[playerid][pBank], newbank);
	strcat(paydayStatement, line, sizeof(paydayStatement));

	//======================================================================

	PlayerInfo[playerid][pBank] = newbank;
	PlayerInfo[playerid][pPayCheck] = 0;
	
	// Aplicar multiplicador de experiencia si está activo
	new expGain = hasDoubleExp ? 2 : 1;
	PlayerInfo[playerid][pExp] += expGain;

	if(PlayerInfo[playerid][pCantWork] > 0 && PlayerInfo[playerid][pJailed] == JAIL_NONE) {
		PlayerInfo[playerid][pCantWork] = 0;
	}

	if(PlayerInfo[playerid][pJobTime] > 0)	{
		PlayerInfo[playerid][pJobTime]--; // Reducimos la cantidad de tiempo que tiene que esperar para poder tomar otro empleo.
	}

	new expamount = (PlayerInfo[playerid][pLevel] + 1) * ServerInfo[svLevelExp], str[128];

	if(PlayerInfo[playerid][pExp] < expamount)
	{
		if(hasDoubleExp)
			format(str, sizeof(str), " ¡Día de pago! "COLOR_EMB_WHITE"más detalles con '/verpago'. (( Experiencia %i/%i - "COLOR_EMB_USAGE"x2 activo"COLOR_EMB_WHITE" ))", PlayerInfo[playerid][pExp], expamount);
		else
			format(str, sizeof(str), " ¡Día de pago! "COLOR_EMB_WHITE"más detalles con '/verpago'. (( Experiencia %i/%i ))", PlayerInfo[playerid][pExp], expamount);
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, str);

		if(hasDoubleExp)
			format(str, sizeof(str), "~g~~h~ ¡Día de pago!~w~~n~más detalles con '/verpago'.~n~(( Experiencia %i/%i - ~y~x2~w~ ))", PlayerInfo[playerid][pExp], expamount);
		else
			format(str, sizeof(str), "~g~~h~ ¡Día de pago!~w~~n~más detalles con '/verpago'.~n~(( Experiencia %i/%i ))", PlayerInfo[playerid][pExp], expamount);
		Noti_Create(playerid, .time = 6000, .text = str);
	}
	else
	{
		PlayerInfo[playerid][pExp] = 0;
		PlayerInfo[playerid][pLevel]++;
		SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
		expamount = (PlayerInfo[playerid][pLevel] + 1) * ServerInfo[svLevelExp];

		if(hasDoubleExp)
			format(str, sizeof(str), "¡Día de pago! "COLOR_EMB_WHITE"más detalles con '/verpago'. {E0EA64} ¡Tu cuenta subió al nivel %i! "COLOR_EMB_WHITE"(( Experiencia %i/%i - "COLOR_EMB_USAGE"x2 activo"COLOR_EMB_WHITE" ))", PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pExp], expamount);
		else
			format(str, sizeof(str), "¡Día de pago! "COLOR_EMB_WHITE"más detalles con '/verpago'. {E0EA64} ¡Tu cuenta subió al nivel %i! "COLOR_EMB_WHITE"(( Experiencia %i/%i ))", PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pExp], expamount);
		SendClientMessage(playerid, COLOR_LIGHTYELLOW2, str);

		format(str, sizeof(str), "~g~~h~ ¡Día de pago!~w~~n~más detalles con '/verpago'", PlayerInfo[playerid][pLevel]);
		Noti_Create(playerid, .time = 5000, .text = str);

		if(hasDoubleExp)
			format(str, sizeof(str), "~y~ ¡Tu cuenta subió al nivel %i!~n~~w~(( Experiencia %i/%i - ~y~x2~w~ ))", PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pExp], expamount);
		else
			format(str, sizeof(str), "~y~ ¡Tu cuenta subió al nivel %i!~n~~w~(( Experiencia %i/%i ))", PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pExp], expamount);
		Noti_Create(playerid, .time = 7000, .text = str);
	}
	
	// Agregar información del evento al final si está activo
	if(hasDoubleExp)
	{
		format(line, sizeof(line), " \n"COLOR_EMB_USAGE"[EVENTO]\nExperiencia doble: ACTIVO - Beneficios x2 aplicados.\n");
		strcat(paydayStatement, line, sizeof(paydayStatement));
	}

	gPaydayPlayerString[playerid] = str_new(paydayStatement);
	str_acquire(gPaydayPlayerString[playerid]);
	return 1;
}

Payday_AddStatementDeferedInfo(playerid, const info[])
{
	if(gPaydayPlayerString[playerid] == STRING_NULL)
		return 0;

	new String:str = str_new(info);
	str_append(gPaydayPlayerString[playerid], str);
	return 1;
}

CMD:payday(playerid, params[]) {
	return Payday(playerid);
}

CMD:verpago(playerid, params[])
{
	static paydayStatement[4096];

	if(gPaydayPlayerString[playerid] == STRING_NULL)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes ningún resumen reciente del último pago (recuerda que el resumen se borra al desconectarte).");

	str_get(gPaydayPlayerString[playerid], paydayStatement, sizeof(paydayStatement));
	Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_LIST, ""COLOR_EMB_WHITE"Resumen del último pago", paydayStatement, "Cerrar", "");
	return 1;
}
