#if defined _marp_twitter_included
	#endinput
#endif
#define _marp_twitter_included

#include <YSI_Coding\y_hooks>

#define TWITTER_COLOR            0x1DA1F2FF
#define TWITTER_COOLDOWN_DEFAULT 180
#define TWITTER_USERNAME_LEN     20
#define TWITTER_MSG_LEN          128
#define TWITTER_DLG_REGISTER     9600
#define TWITTER_DLG_COOLDOWN     9601

static TwitterCooldown = TWITTER_COOLDOWN_DEFAULT;
static bool:TwitterDisabled = false;
static TwitterUsername[MAX_PLAYERS][TWITTER_USERNAME_LEN + 1];
static bool:TwitterRegistered[MAX_PLAYERS];
static bool:TwitterActive[MAX_PLAYERS];
static TwitterLastMsg[MAX_PLAYERS];

// ================================================================
// CARGA / DESCARGA
// ================================================================

forward Twitter_OnLoad(playerid);
public Twitter_OnLoad(playerid)
{
	if (!IsPlayerConnected(playerid)) return 1;
	if (cache_num_rows() > 0)
	{
		TwitterRegistered[playerid] = true;
		cache_get_value_name(0, "username", TwitterUsername[playerid], TWITTER_USERNAME_LEN + 1);
	}
	else
	{
		TwitterRegistered[playerid] = false;
		TwitterUsername[playerid][0] = EOS;
	}
	return 1;
}

hook LoadAccountDataEnded(playerid)
{
	new query[128];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT `username` FROM `twitter` WHERE `pID`=%i LIMIT 1", PlayerInfo[playerid][pID]);
	mysql_tquery(MYSQL_HANDLE, query, "Twitter_OnLoad", "i", playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	TwitterRegistered[playerid] = false;
	TwitterActive[playerid]     = false;
	TwitterLastMsg[playerid]    = 0;
	TwitterUsername[playerid][0] = EOS;
	return 1;
}

// ================================================================
// REGISTRO
// ================================================================

forward Twitter_OnCheckUsername(playerid);
public Twitter_OnCheckUsername(playerid)
{
	if (!IsPlayerConnected(playerid)) return 1;
	if (cache_num_rows() > 0)
	{
		ShowPlayerDialog(playerid, TWITTER_DLG_REGISTER, DIALOG_STYLE_INPUT, "Twitter - Registrarse", "Ese nombre de usuario ya esta en uso.\nElige otro @username (3-20 caracteres, solo letras, numeros y _):", "Registrarse", "Cancelar");
	}
	else
	{
		new username[TWITTER_USERNAME_LEN + 1];
		GetPVarString(playerid, "TwitterPendingUser", username, sizeof(username));
		DeletePVar(playerid, "TwitterPendingUser");

		new query[256];
		mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO `twitter` (`pID`, `pName`, `username`) VALUES (%i, '%e', '%e')", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], username);
		mysql_tquery(MYSQL_HANDLE, query);

		format(TwitterUsername[playerid], TWITTER_USERNAME_LEN + 1, "%s", username);
		TwitterRegistered[playerid] = true;
		TwitterActive[playerid]     = true;

		new msg[128];
		format(msg, sizeof(msg), "[Twitter] Tu cuenta @%s fue creada. Ya estas conectado a Twitter.", username);
		SendClientMessage(playerid, TWITTER_COLOR, msg);
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch (dialogid)
	{
		case TWITTER_DLG_REGISTER:
		{
			if (!response) return 1;

			new len = strlen(inputtext);
			if (len < 3 || len > TWITTER_USERNAME_LEN)
			{
				ShowPlayerDialog(playerid, TWITTER_DLG_REGISTER, DIALOG_STYLE_INPUT, "Twitter - Registrarse", "El username debe tener entre 3 y 20 caracteres.\nElige un @username:", "Registrarse", "Cancelar");
				return 1;
			}
			for (new i = 0; i < len; i++)
			{
				if (!('a' <= inputtext[i] <= 'z' || 'A' <= inputtext[i] <= 'Z' || '0' <= inputtext[i] <= '9' || inputtext[i] == '_'))
				{
					ShowPlayerDialog(playerid, TWITTER_DLG_REGISTER, DIALOG_STYLE_INPUT, "Twitter - Registrarse", "Solo se permiten letras, numeros y guion bajo (_).\nElige un @username:", "Registrarse", "Cancelar");
					return 1;
				}
			}
			SetPVarString(playerid, "TwitterPendingUser", inputtext);
			new query[128];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT `id` FROM `twitter` WHERE `username`='%e' LIMIT 1", inputtext);
			mysql_tquery(MYSQL_HANDLE, query, "Twitter_OnCheckUsername", "i", playerid);
			return 1;
		}
		case TWITTER_DLG_COOLDOWN:
		{
			if (!response) return 1;
			switch (listitem)
			{
				case 0: { TwitterCooldown = 0;   TwitterDisabled = false; SendClientMessageToAll(TWITTER_COLOR, "[AVISO] El administrador desactivo el cooldown. Sin limite de tiempo entre mensajes."); }
				case 1: { TwitterCooldown = 30;  TwitterDisabled = false; SendClientMessageToAll(TWITTER_COLOR, "[AVISO] El administrador cambio el cooldown a 30 segundos por mensaje."); }
				case 2: { TwitterCooldown = 60;  TwitterDisabled = false; SendClientMessageToAll(TWITTER_COLOR, "[AVISO] El administrador cambio el cooldown a 1 minuto por mensaje."); }
				case 3: { TwitterCooldown = 180; TwitterDisabled = false; SendClientMessageToAll(TWITTER_COLOR, "[AVISO] El administrador cambio el cooldown a 3 minutos por mensaje."); }
				case 4: { TwitterCooldown = 300; TwitterDisabled = false; SendClientMessageToAll(TWITTER_COLOR, "[AVISO] El administrador cambio el cooldown a 5 minutos por mensaje."); }
				case 5: { TwitterDisabled = true; SendClientMessageToAll(TWITTER_COLOR, "[AVISO] Un administrador ha deshabilitado Twitter temporalmente."); }
			}
			return 1;
		}
	}
	return 0;
}

// ================================================================
// COMANDOS
// ================================================================

CMD:cooldowntwitter(playerid, params[])
{
	if (AccountInfo[playerid][accAdminLevel] < 3)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Helper o superior para usar este comando.");

	new title[80];
	format(title, sizeof(title), "Twitter - Cooldown: %ds | Estado: %s", TwitterCooldown, TwitterDisabled ? "DESHABILITADO" : "Activo");
	ShowPlayerDialog(playerid, TWITTER_DLG_COOLDOWN, DIALOG_STYLE_LIST, title,
		"Sin cooldown\n30 segundos por mensaje\n1 minuto por mensaje\n3 minutos por mensaje\n5 minutos por mensaje\nDeshabilitar Twitter",
		"Aplicar", "Cancelar");
	return 1;
}

CMD:ayudatwitter(playerid, params[])
{
	new cooldownStr[32];
	if (TwitterDisabled)
		format(cooldownStr, sizeof(cooldownStr), "DESHABILITADO");
	else if (TwitterCooldown == 0)
		format(cooldownStr, sizeof(cooldownStr), "sin cooldown");
	else if (TwitterCooldown < 60)
		format(cooldownStr, sizeof(cooldownStr), "%d segundos", TwitterCooldown);
	else
		format(cooldownStr, sizeof(cooldownStr), "%d minutos", TwitterCooldown / 60);

	new helpLine[128];
	SendClientMessage(playerid, TWITTER_COLOR, "[Twitter] ========== Comandos de Twitter ==========");
	SendClientMessage(playerid, TWITTER_COLOR, "[Twitter] /registrarsetwitter - Crea tu cuenta (una sola vez).");
	SendClientMessage(playerid, TWITTER_COLOR, "[Twitter] /activartwitter - Conectate para ver y enviar mensajes.");
	SendClientMessage(playerid, TWITTER_COLOR, "[Twitter] /desactivartwitter - Desconectate de Twitter.");
	format(helpLine, sizeof(helpLine), "[Twitter] /tw [mensaje] - Envia un tweet a todos los conectados. Cooldown: %s.", cooldownStr);
	SendClientMessage(playerid, TWITTER_COLOR, helpLine);
	SendClientMessage(playerid, TWITTER_COLOR, "[Twitter] =========================================");
	return 1;
}

CMD:registrarsetwitter(playerid, params[])
{
	if (TwitterRegistered[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya tienes una cuenta de Twitter registrada.");

	ShowPlayerDialog(playerid, TWITTER_DLG_REGISTER, DIALOG_STYLE_INPUT, "Twitter - Registrarse", "Elige tu @username de Twitter\n(3-20 caracteres, solo letras, numeros y _):", "Registrarse", "Cancelar");
	return 1;
}

CMD:activartwitter(playerid, params[])
{
	if (!TwitterRegistered[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes cuenta de Twitter. Usa /registrarsetwitter.");
	if (TwitterActive[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya tienes Twitter activado.");

	TwitterActive[playerid] = true;
	SendClientMessage(playerid, TWITTER_COLOR, "[Twitter] Conectado. Usa /tw [mensaje] para twittear.");
	SendClientMessage(playerid, TWITTER_COLOR, "[AVISO] Recuerda que puedes utilizar /ayudatwitter para más información.");
	return 1;
}

CMD:desactivartwitter(playerid, params[])
{
	if (!TwitterActive[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes Twitter activado.");

	TwitterActive[playerid] = false;
	SendClientMessage(playerid, TWITTER_COLOR, "[Twitter] Te desconectaste de Twitter.");
	return 1;
}

CMD:tw(playerid, params[])
{
	if (!PlayerInfo[playerid][pPhoneNumber])
		return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¿Cómo querés usar Twitter si no tenés un teléfono, pavo? Comprálo en el 24-7.");
	if (!TwitterRegistered[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes cuenta de Twitter. Usa /registrarsetwitter.");
	if (!TwitterActive[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Activa Twitter primero con /activartwitter.");
	if (TwitterDisabled)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Twitter esta deshabilitado por un administrador.");
	if (PlayerInfo[playerid][pMuteTW] != 0)
	{
		new muteTWMsg[160];
		if(PlayerInfo[playerid][pMuteTW] == -1)
		{
			format(muteTWMsg, sizeof(muteTWMsg), "[ERROR] "COLOR_EMB_GREY"Estas muteado de Twitter indefinidamente. Motivo: %s", PlayerInfo[playerid][pMuteTWReason]);
			return SendClientMessage(playerid, COLOR_ERROR, muteTWMsg);
		}
		new mins = (PlayerInfo[playerid][pMuteTW] / 60) + 1;
		format(muteTWMsg, sizeof(muteTWMsg), "[ERROR] "COLOR_EMB_GREY"Estas muteado de Twitter por %d minuto(s). Motivo: %s", mins, PlayerInfo[playerid][pMuteTWReason]);
		return SendClientMessage(playerid, COLOR_ERROR, muteTWMsg);
	}
	if (isnull(params))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/tw [mensaje]");
	if (strlen(params) > TWITTER_MSG_LEN)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Mensaje demasiado largo (max 128 caracteres).");

	if (TwitterCooldown > 0)
	{
		new now = gettime();
		new remaining = TwitterCooldown - (now - TwitterLastMsg[playerid]);
		if (remaining > 0)
		{
			new str[64];
			format(str, sizeof(str), "[ERROR] "COLOR_EMB_GREY"Espera %d segundos para volver a twittear.", remaining);
			return SendClientMessage(playerid, COLOR_ERROR, str);
		}
		TwitterLastMsg[playerid] = now;
	}

	new str[160];
	format(str, sizeof(str), "[Twitter] @%s: %s", TwitterUsername[playerid], params);
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i)) continue;
		if (!TwitterActive[i]) continue;
		SendClientMessage(i, TWITTER_COLOR, str);
	}
	return 1;
}
