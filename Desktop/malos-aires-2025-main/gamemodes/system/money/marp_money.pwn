#if defined _marp_money_included
	#endinput
#endif
#define _marp_money_included

#include <YSI_Coding\y_hooks>

static const MONEY_MIN_ALERT_VALUE = 500000; // Valor absoluto mínimo en una sola transacción de GivePlayerCash para elevar una alerta administrativo y generar un log
static const MONEY_MAX_ALLOWED_VALUE = 10000000; // Valor absoluto máximopermitido en una sola transacción de GivePlayerCash antes de bloquear la cuenta

#define ResetMoneyBar ResetPlayerMoney
#define UpdateMoneyBar GivePlayerMoney

CMD:cajero(playerid, params[])
{
	if(!IsAtATM(playerid))
		return 1;

	ATM_Show(playerid, 0);
	return 1;
}

hook OnGameModeInitEnded()
{
	new onATMShowAddress = GetPublicAddressFromName("ATM_Show");

	Button_Create(0, 1114.1572, -1404.3971, 1401.0859, .size = 0.3, .labelText = "Cajero", .onEnterText = "(H) Usar", .onPressCallbackAddress = onATMShowAddress);
	Button_Create(0, 1114.1573, -1406.4835, 1401.0859, .size = 0.3, .labelText = "Cajero", .onEnterText = "(H) Usar", .onPressCallbackAddress = onATMShowAddress);
	return 1;
}

stock IsAtATM(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 0.5,1114.1572,-1404.3971,1401.0859)||
		IsPlayerInRangeOfPoint(playerid, 0.5,1114.1573,-1406.4835,1401.0859)) {
		return 1;
	}
	return 0;
}

CMD:pagar(playerid,params[])
{
	new targetID, amount;
	// Restricción: solo jugadores nivel >= 2 pueden dar dinero a otros
	if(PlayerInfo[playerid][pLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser nivel 2 o superior para pagar a otros jugadores.");

    if(sscanf(params, "ud", targetID, amount))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/pagar [ID/Jugador] [cantidad]");
    if(GetPlayerCash(playerid) < amount || amount < 1 || amount > 500000)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Cantidad de dinero inválida! asegúrate de tener dicha suma y que sea de más de $0 y menos de $500,000).");
	if(!IsPlayerLogged(targetID) || targetID == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
    if(!IsPlayerInRangeOfPlayer(2.0, playerid, targetID))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Deben estar cerca!");

	GivePlayerCash(playerid, -amount);
	GivePlayerCash(targetID, amount);
	SendFMessage(playerid, COLOR_WHITE, "Le has pagado $%d a %s.", amount, GetPlayerCleanName(targetID));
	SendFMessage(targetID, COLOR_WHITE, "%s te ha pagado $%d.", GetPlayerCleanName(playerid), amount);
    PlayerPlayerCmeMessage(playerid, targetID, 15.0, 4000, "Toma algo de dinero y se lo entrega a");
    PlayerPlaySound(targetID, 1052, 0.0, 0.0, 0.0);
    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
    ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="PAGO", .playerid=playerid, .targetid=targetID, .params=<"$%d", amount>);
    return 1;
}

CMD:billetera(playerid, params[])
{
	new money;
	// Restricción: crear billeteras/fajos requiere nivel >= 2
	if(PlayerInfo[playerid][pLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser nivel 2 o superior para crear fajos de billetes.");

	if(sscanf(params, "i", money))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/billetera [cantidad de dinero]");
	if(!(100 <= money <= 20000 && money <= GetPlayerCash(playerid)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Cantidad de dinero inválida! (mínimo $100, máximo$20.000)");

	new freehand = SearchFreeHand(playerid);

	if(freehand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tienes ambas manos ocupadas.");

	GivePlayerCash(playerid, -money);
	SetHandItemAndParam(playerid, freehand, ITEM_ID_DINERO, money);
	PlayerCmeMessage(playerid, 15.0, 4000, "Toma algo de dinero de su billetera.");
	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="/billetera", .playerid=playerid, .params=<"$%i", money>);
	return 1;
}

hook function Item_OnUsed(playerid, hand, itemid, itemType)
{
	if(itemid != ITEM_ID_DINERO)
		return continue(playerid, hand, itemid, itemType);

	new money = GetHandParam(playerid, hand);

	GivePlayerCash(playerid, money);
	SetHandItemAndParam(playerid, hand, 0, 0);
	PlayerCmeMessage(playerid, 15.0, 4000, "Guarda algo de dinero en su billetera.");
	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="/consumir", .playerid=playerid, .params=<"$%i", money>);
	return 1;
}

CMD:ayudacajero(playerid,params[]) {
	return cmd_ayudabanco(playerid, params);
}

CMD:ayudabanco(playerid,params[])
{
	new string[64];

	if(PlayerInfo[playerid][pFaction] != 0)
	{
		if(PlayerInfo[playerid][pRank] == 1)
	    	string = "- /fverbalance - /fdepositar - /fretirar";
    	else
    		string = "- /fdepositar";
	}
    SendFMessage(playerid, COLOR_LIGHTYELLOW2, "[BANCO/CAJERO] /verbalance - /depositar - /retirar - /transferir %s", string);
	return 1;
}

CMD:depositar(playerid,params[])
{
	new amount;

	if(!IsPlayerInRangeOfPoint(playerid, 5.0, POS_BANK_X, POS_BANK_Y, POS_BANK_Z) && !IsAtATM(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar en un banco o cajero automático!");
 	if(sscanf(params, "i", amount))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/depositar [cantidad]");

	if(!Bank_PlayerDeposit(playerid, amount))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Cantidad de dinero inválida!");

    return 1;
}

CMD:retirar(playerid,params[])
{
	new amount;
	
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, POS_BANK_X, POS_BANK_Y, POS_BANK_Z) && !IsAtATM(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar en un banco o cajero automático!");
 	if(sscanf(params, "i", amount))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/retirar [cantidad]");

	if(!Bank_PlayerWithdraw(playerid, amount))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Cantidad de dinero inválida!");

    return 1;
}

CMD:transferir(playerid, params[])
{
	new targetid, amount;
	// Restricción: solo jugadores nivel >= 2 pueden realizar transferencias
	if(PlayerInfo[playerid][pLevel] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser nivel 2 o superior para realizar transferencias bancarias.");

	if(!IsPlayerInRangeOfPoint(playerid, 5.0, POS_BANK_X, POS_BANK_Y, POS_BANK_Z) && !IsAtATM(playerid) && GetHandItem(playerid, HAND_RIGHT) != ITEM_ID_TELEFONO_CELULAR && GetHandItem(playerid, HAND_LEFT) != ITEM_ID_TELEFONO_CELULAR)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar en un banco, cajero automático o tener el celular en la mano!");
	if(sscanf(params, "ud", targetid, amount))
 		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/transferir [ID/Jugador] [cantidad]");

	if(!Bank_PlayerTransferTo(playerid, targetid, amount))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡ID/Jugador o cantidad de dinero inválida!");

 	return 1;
}

CMD:verbalance(playerid,params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, POS_BANK_X, POS_BANK_Y, POS_BANK_Z) && !IsAtATM(playerid))
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar en un banco o cajero automático!");

	SendFMessage(playerid, COLOR_WHITE, "Tu balance actual es de $%d.", PlayerInfo[playerid][pBank]);
	PlayerActionMessage(playerid, 15.0, "recibe un papel con el estado de su cuenta bancaria.");
    return 1;
}

CMD:donar(playerid, params[])
{
	new money, str[128];
	
	if(sscanf(params, "i", money))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/donar [cantidad]");
	if(money < 0)
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "{FF4600}[Error]{C8C8C8} cantidad inválida.");
	if(GetPlayerCash(playerid) < money)
	    return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "{FF4600}[Error]{C8C8C8} no tienes esa cantidad.");
	    
	GivePlayerCash(playerid, -money);
	format(str, sizeof(str), "{878EE7}[INFO]{C8C8C8} %s ha donado $%d.", GetPlayerCleanName(playerid), money);
	AdministratorMessage(COLOR_LIGHTYELLOW2, str, 2);
	SendFMessage(playerid, COLOR_WHITE, "Has donado $%i.", money);
	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="DONACION", .playerid=playerid, .params=<"$%d", money>);
	return 1;
}

stock GivePlayerCash(playerid, money)
{
	SanityCashCheck(playerid, money);
	PlayerInfo[playerid][pCash] += money;
	ResetMoneyBar(playerid);
	UpdateMoneyBar(playerid, PlayerInfo[playerid][pCash]);
	MoneyBars_NewChange(playerid, money);
	return PlayerInfo[playerid][pCash];
}

stock SetPlayerCash(playerid, money)
{
	PlayerInfo[playerid][pCash] = money;
	ResetMoneyBar(playerid);
	UpdateMoneyBar(playerid, PlayerInfo[playerid][pCash]);
	return PlayerInfo[playerid][pCash];
}

stock ResetPlayerCash(playerid)
{
	PlayerInfo[playerid][pCash] = 0;
	ResetMoneyBar(playerid);
	UpdateMoneyBar(playerid, PlayerInfo[playerid][pCash]);
	return PlayerInfo[playerid][pCash];
}

stock GetPlayerCash(playerid) {
	return PlayerInfo[playerid][pCash];
}

stock SyncPlayerCash(playerid)
{
	ResetMoneyBar(playerid);
	UpdateMoneyBar(playerid, PlayerInfo[playerid][pCash]);
}

stock SanityCashCheck(playerid, money)
{
	if(money < (-MONEY_MIN_ALERT_VALUE) || money > MONEY_MIN_ALERT_VALUE)
	{
		new string[128];
		format(string, sizeof(string), "[ALERTA] "COLOR_EMB_GREY" Transacción de dinero elevada en %s (ID %i) por $%i.", GetPlayerCleanName(playerid), playerid, money);
		AdministratorMessage(COLOR_ALERT, string, 2);

		ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="SanityCashCheck", .playerid=playerid, .params=<"$%i", money>);

		if(money < (-MONEY_MAX_ALLOWED_VALUE) || money > MONEY_MAX_ALLOWED_VALUE) {
			BanPlayer(playerid, INVALID_PLAYER_ID, "Bloqueo preventivo por movimiento de dinero irregular.", .days = 0);
		}
	}
}

stock Money_IsValidValue(money, bool:allownegative = false)
{
	if(allownegative) {
		return ((-MONEY_MAX_ALLOWED_VALUE) <= money <= MONEY_MAX_ALLOWED_VALUE);
	} else {
		return (1 <= money <= MONEY_MAX_ALLOWED_VALUE);
	}
}

Bank_PlayerWithdraw(playerid, money)
{
	if(!(1 <= money <= PlayerInfo[playerid][pBank]))
		return 0;

	GivePlayerCash(playerid, money);
	PlayerInfo[playerid][pBank] -= money;
	SendFMessage(playerid, COLOR_WHITE, "Has retirado $%i. Nuevo balance: $%i.", money, PlayerInfo[playerid][pBank]);
	PlayerActionMessage(playerid, 15.0, "realiza una operación en su cuenta bancaria.");
	Bank_OnUpdate(playerid, PlayerInfo[playerid][pBank], PlayerInfo[playerid][pBank] + money);

	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="RETIRO", .playerid=playerid, .params=<"$%d", money>);
	return 1;
}

Bank_PlayerDeposit(playerid, money)
{
	if(!(1 <= money <= GetPlayerCash(playerid)))
		return 0;

	GivePlayerCash(playerid, -money);
	PlayerInfo[playerid][pBank] += money;
	SendFMessage(playerid, COLOR_WHITE, "Has depositado $%i. Nuevo balance: $%i.", money, PlayerInfo[playerid][pBank]);
	PlayerActionMessage(playerid, 15.0, "realiza una operación en su cuenta bancaria.");
	Bank_OnUpdate(playerid, PlayerInfo[playerid][pBank], PlayerInfo[playerid][pBank] - money);

	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="DEPOSITO", .playerid=playerid, .params=<"$%d", money>);
	return 1;
}

Bank_PlayerTransferTo(playerid, targetid, money)
{
	// Protección central: bloquear transferencias bancarias desde cuentas de jugadores nivel < 2
	if(PlayerInfo[playerid][pLevel] < 2) {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser nivel 2 o superior para realizar transferencias bancarias.");
		return 0;
	}

	if(!(1 <= money <= PlayerInfo[playerid][pBank]))
		return 0;
	if(!IsPlayerLogged(targetid) || targetid == playerid)
		return 0;

	PlayerActionMessage(playerid, 15.0, "aprieta algunos botones del cajero y realiza una operación bancaria.");

	PlayerInfo[playerid][pBank] -= money;
	PlayerInfo[targetid][pBank] += money;

	SendFMessage(playerid, COLOR_WHITE, "Has realizado una transferencia de $%i a la cuenta de %s.", money, GetPlayerCleanName(targetid));
	SendFMessage(targetid, COLOR_WHITE, "[Mensaje del Banco] Has recibido una transferencia de la cuenta de %s por $%i.", GetPlayerCleanName(playerid), money);
   
    Bank_OnUpdate(playerid, PlayerInfo[playerid][pBank], PlayerInfo[playerid][pBank] + money);
    Bank_OnUpdate(targetid, PlayerInfo[targetid][pBank], PlayerInfo[targetid][pBank] - money);

	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="TRANSFERENCIA", .playerid=playerid, .targetid=targetid, .params=<"$%d", money>);
	return 1;
}
