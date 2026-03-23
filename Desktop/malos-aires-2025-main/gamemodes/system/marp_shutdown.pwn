#if defined _marp_shutdown_inc
	#endinput
#endif
#define _marp_shutdown_inc

CMD:gmx(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	print("[INFO] ========= INICIANDO REINICIO DEL SERVIDOR =========");
	ServerShutdown_Initiate(.restart = true);
	return 1;
}

CMD:exit(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	print("[INFO] ========= INICIANDO APAGADO DEL SERVIDOR =========");
	ServerShutdown_Initiate(.restart = false);
	return 1;
}

ServerShutdown_Initiate(bool:restart)
{
	if(restart)
	{
		SendClientMessageToAll(COLOR_WHITE, "El servidor se está reiniciando...");
		GameTextForAll("~w~reiniciando servidor...", 10000, 5);
	} else {
		SendClientMessageToAll(COLOR_WHITE, "El servidor se está apagando...");
		GameTextForAll("~w~apagando servidor...", 10000, 5);
	}

	ServerShutdown_LockWithPassword();
	new lastkickedtime = ServerShutdown_KickAllPlayers();
	SetTimerEx("ServerShutdown", lastkickedtime + 5000, false, "b", restart);
}

ServerShutdown_LockWithPassword()
{
	new rconcmd[32], password[16], rand2;

	rand2 = random(100);
	format(password, sizeof(password), "k1k1c3nt%02d", rand2);

	new msg[96];
	format(msg, sizeof(msg), "[SERVIDOR] Contraseña temporal antes del reinicio: %s", password);
	AdministratorMessage(COLOR_ADMINCMD, msg, 2);

	format(rconcmd, sizeof(rconcmd), "password %s", password);
	SendRconCommand(rconcmd);
}

ServerShutdown_KickAllPlayers()
{
	new time, maxtime;

	foreach(new playerid : Player)
	{
		time = 2000 + playerid * 150;
		SetTimerEx("ServerShutdown_KickPlayer", time, false, "i", playerid);
		maxtime = (time > maxtime) ? (time) : (maxtime);
	}

	return maxtime;
}

forward ServerShutdown_KickPlayer(playerid);
public ServerShutdown_KickPlayer(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;

	KickPlayer(playerid, "el servidor", "cerrando servidor...");
	return 1;
}

forward ServerShutdown(bool:restart);
public ServerShutdown(bool:restart)
{
	if(restart) {
		SendRconCommand("gmx");
	} else {
		SendRconCommand("exit");
	}
	return 1;
}