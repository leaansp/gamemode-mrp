#if defined _marp_multichar_included
	#endinput
#endif
#define _marp_multichar_included

#include <YSI_Coding\y_hooks>
// #include "system/marp_login_textdraw.pwn" // Deshabilitado: solo diálogos

// ==================== DIÁLOGOS ====================
#define DLG_MASTER_MENU        8999
#define DLG_MASTER_INPUT_NAME  9000
#define DLG_MASTER_INPUT_PASS  9001
#define DLG_MASTER_LOGIN       9010
#define DLG_MASTER_REGISTER    9011
#define DLG_MASTER_REGISTER_PASS 9012
#define DLG_MASTER_MENU_PASSWORD 9013
#define DLG_CHAR_SELECT        9002
#define DLG_CHAR_CREATE_NAME   9003
#define DLG_CHAR_CONFIRM       9004
#define DLG_MASTER_PASSWORD    9014

// ==================== VARIABLES ====================
static g_MasterAccountId[MAX_PLAYERS];
static g_MasterUsername[MAX_PLAYERS][MAX_PLAYER_NAME];
static g_MasterPassword[MAX_PLAYERS][128];
static g_MasterAction[MAX_PLAYERS]; // 0 = login, 1 = register
static g_CharacterList[MAX_PLAYERS][3][MAX_PLAYER_NAME];
static g_CharacterIds[MAX_PLAYERS][3];
static g_CharacterSlots[MAX_PLAYERS];

// ==================== FORWARDS ====================
forward OnCheckIPBan_PreLogin(playerid);
forward OnCheckMasterIPLimit_Register(playerid);
forward AccountRegister_Complete(playerid);
forward OnUpdateBanStatusAfterIPBan(playerid);
forward OnUpdateMasterLastLogin(playerid);
forward OnAccountUnbanned(playerid);

// ==================== FUNCIONES PÚBLICAS ====================

// Verifica si una cuenta maestra ya está conectada
stock bool:IsMasterAccountConnected(masterAccountId, excludePlayerid = INVALID_PLAYER_ID)
{
	if(masterAccountId <= 0) return false;
	
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(i == excludePlayerid) continue; // Excluir al jugador actual
		if(!IsPlayerConnected(i)) continue;
		if(g_MasterAccountId[i] == masterAccountId)
			return true;
	}
	return false;
}

// Verifica si un personaje (por ID de account) ya está conectado
stock bool:IsCharacterConnected(accountId, excludePlayerid = INVALID_PLAYER_ID)
{
	if(accountId <= 0) return false;
	
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(i == excludePlayerid) continue; // Excluir al jugador actual
		if(!IsPlayerConnected(i)) continue;
		// Verificar si el jugador tiene un ID de cuenta válido y coincide
		if(PlayerInfo[i][pID] > 0 && PlayerInfo[i][pID] == accountId)
			return true;
	}
	return false;
}

stock MultiChar_StartLogin(playerid)
{
	g_MasterAccountId[playerid] = 0;
	g_MasterUsername[playerid][0] = EOS;
	g_MasterPassword[playerid][0] = EOS;
	g_MasterAction[playerid] = 0;
	g_CharacterSlots[playerid] = 0;
    
	for(new i = 0; i < 3; i++)
	{
		g_CharacterList[playerid][i][0] = EOS;
		g_CharacterIds[playerid][i] = 0;
	}

	new query[256];
	new playerIP[16];
	GetPlayerIp(playerid, playerIP, sizeof(playerIP));

	// Inicializar PVars temporales para que el textdraw muestre placeholders inmediatos
	// SetPVarString(playerid, "Login_Username_TMP", ""); // Deshabilitado: solo diálogos
	// SetPVarString(playerid, "Login_Password_TMP", ""); // Deshabilitado: solo diálogos
	// Si el textdraw ya está activo, actualizarlo
	// LoginTD_Update(playerid); // Deshabilitado: solo diálogos

	mysql_format(MYSQL_HANDLE, query, sizeof(query),
		"SELECT * FROM bans WHERE pIP='%e' AND banType='IP' AND banActive=1 LIMIT 1",
		playerIP);
	mysql_tquery(MYSQL_HANDLE, query, "OnCheckIPBan_PreLogin", "i", playerid);
	return 1;
}

stock MultiChar_ShowMasterMenu(playerid)
{
	// Flujo directo: pedir usuario
	MultiChar_ShowInputName(playerid);
	return 1;
}

stock MultiChar_ShowInputName(playerid)
{
	new dialog[512];
	strcat(dialog, "{FFFFFF}Bienvenido a {FFD700}Malos Aires Roleplay{FFFFFF}\n\n");
	strcat(dialog, "Ingresa tu nombre de usuario para continuar.\n\n");
	strcat(dialog, "{5CCAF1}Requisitos:{FFFFFF}\n");
	strcat(dialog, "- Entre 3 y 32 caracteres\n");
	strcat(dialog, "- Solo letras, números y guión bajo (_)");
	
	ShowPlayerDialog(playerid, DLG_MASTER_INPUT_NAME, DIALOG_STYLE_INPUT, "Inicio de Sesión", dialog, "Continuar", "");
	return 1;
}

stock MultiChar_ShowInputPassword(playerid)
{
	new dialog[512];
	format(dialog, sizeof(dialog), "{FFFFFF}Usuario: {FFD700}%s{FFFFFF}\n\n", g_MasterUsername[playerid]);
	strcat(dialog, "Ingresa tu contraseña:\n\n");
	strcat(dialog, "{5CCAF1}Requisitos:{FFFFFF}\n");
	strcat(dialog, "- Mínimo 4 caracteres");
	
	ShowPlayerDialog(playerid, DLG_MASTER_INPUT_PASS, DIALOG_STYLE_PASSWORD, "Contraseña", dialog, "Continuar", "");
	return 1;
}

stock MultiChar_ShowMenuPass(playerid)
{
	new dialog[512];
	format(dialog, sizeof(dialog), "{FFFFFF}Usuario: {FFD700}%s{FFFFFF}\n\n¿Qué deseas hacer?\n\n", g_MasterUsername[playerid]);
	strcat(dialog, "{5CCAF1}Opción 1:{FFFFFF} Ingresa tu contraseña y presiona {FFD700}Iniciar sesión\n");
	strcat(dialog, "{5CCAF1}Opción 2:{FFFFFF} O presiona {FFD700}Registrarse{FFFFFF} para crear una nueva cuenta con este usuario.");
	
	ShowPlayerDialog(playerid, DLG_MASTER_MENU_PASSWORD, DIALOG_STYLE_PASSWORD, "Contraseña", dialog, "Iniciar sesión", "Registrarse");
	return 1;
}

stock MultiChar_ShowMasterLoginDialog(playerid)
{
	new dialog[512];
	strcat(dialog, "{FFFFFF}Por favor, ingresa tu nombre de usuario para iniciar sesión.\n\n");
	strcat(dialog, "{5CCAF1}Nota:{FFFFFF} Si no tienes cuenta, vuelve atrás y selecciona Registrarse.");
    
	ShowPlayerDialog(playerid, DLG_MASTER_LOGIN, DIALOG_STYLE_INPUT, "Iniciar Sesión", dialog, "Continuar", "Atrás");
	return 1;
}

stock MultiChar_ShowMasterRegister(playerid)
{
	new dialog[512];
	strcat(dialog, "{FFFFFF}Por favor, ingresa un nombre de usuario para crear tu cuenta.\n\n");
	strcat(dialog, "{5CCAF1}Requisitos:{FFFFFF}\n");
	strcat(dialog, "- Entre 3 y 32 caracteres\n");
	strcat(dialog, "- Solo letras, números y guión bajo (_)");
    
	ShowPlayerDialog(playerid, DLG_MASTER_REGISTER, DIALOG_STYLE_INPUT, "Registro - Nombre de Usuario", dialog, "Continuar", "Atrás");
	return 1;
}

stock MultiChar_ShowCharSelect(playerid)
{
	new dialog[1024];
	new title[128];
	
	// Título con información de la cuenta
	format(title, sizeof(title), "Selecciona tu Personaje | Cuenta: %s", g_MasterUsername[playerid]);
	
	// Body solo con opciones seleccionables (sin texto extra)
	dialog[0] = EOS;
	new line[128];
	for(new i = 0; i < g_CharacterSlots[playerid]; i++)
	{
		format(line, sizeof(line), "{5CCAF1}[Slot %d]{FFFFFF} %s", i+1, g_CharacterList[playerid][i]);
		strcat(dialog, line);
		if(i < g_CharacterSlots[playerid] - 1 || g_CharacterSlots[playerid] < 3)
			strcat(dialog, "\n");
	}
	
	if(g_CharacterSlots[playerid] < 3)
	{
		if(g_CharacterSlots[playerid] > 0)
			strcat(dialog, "\n");
		format(line, sizeof(line), "{FFD700}[Nuevo]{FFFFFF} Crear personaje en Slot %d", g_CharacterSlots[playerid]+1);
		strcat(dialog, line);
	}
	
	ShowPlayerDialog(playerid, DLG_CHAR_SELECT, DIALOG_STYLE_LIST, title, dialog, "Seleccionar", "Salir");
	return 1;
}

stock MultiChar_ShowCreateCharacter(playerid)
{
	new dialog[512];
	format(dialog, sizeof(dialog), "{FFFFFF}Creando personaje en {FFD700}Slot %d{FFFFFF}\n\n", g_CharacterSlots[playerid]+1);
	strcat(dialog, "Ingresa el nombre de tu personaje:\n\n");
	strcat(dialog, "{5CCAF1}Formato:{FFFFFF} Nombre_Apellido\n");
	strcat(dialog, "{E44A4A}Ejemplo:{FFFFFF} Juan_Perez, Maria_Garcia\n\n");
	strcat(dialog, "El nombre debe ser realista y seguir las reglas del servidor.");
	
	ShowPlayerDialog(playerid, DLG_CHAR_CREATE_NAME, DIALOG_STYLE_INPUT, "Crear Personaje", dialog, "Continuar", "Atrás");
	return 1;
}

stock MultiChar_GetMasterAccountId(playerid)
{
	return g_MasterAccountId[playerid];
}

stock MultiChar_GetCharacterSlot(playerid)
{
	return PlayerInfo[playerid][pCharacterSlot];
}

stock MultiChar_GetCharacterSlots(playerid)
{
	return g_CharacterSlots[playerid];
}

stock MultiChar_HandlePostRegFlow(playerid)
{
	if(GetPVarInt(playerid, "NewRegistration") == 1)
	{
		// Nuevo registro: mostrar diálogo de crear personaje
		MultiChar_ShowCreateCharacter(playerid);
	}
	return 1;
}

public OnCheckIPBan_PreLogin(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	new playerIP[16];
	GetPlayerIp(playerid, playerIP, sizeof(playerIP));

	if(cache_num_rows() > 0)
	{
		new issuerName[MAX_PLAYER_NAME], banReason[128], banEndDate[32], banEndUnix;
		cache_get_value_name(0, "banIssuerName", issuerName, MAX_PLAYER_NAME);
		cache_get_value_name(0, "banReason", banReason, 128);
		cache_get_value_name(0, "banEnd", banEndDate, 32);
		cache_get_value_name_int(0, "banEndUnix", banEndUnix);

		if(gettime() > banEndUnix)
		{
			SendFMessage(playerid, COLOR_ADMINCMD, "[SERVIDOR] Has sido desbaneado ya que el baneo temporal finalizó el %s.", banEndDate);

			new query[256];
			mysql_format(MYSQL_HANDLE, query, sizeof(query),
				"UPDATE bans SET banActive=0 WHERE pIP='%e' AND banActive=1",
				playerIP);
			mysql_tquery(MYSQL_HANDLE, query, "OnUpdateBanStatusAfterIPBan", "i", playerid);
		}
		else
		{
			SendFMessage(playerid, COLOR_ADMINCMD, "Tu IP está baneada hasta el %s por %s.", banEndDate, issuerName);
			SendFMessage(playerid, COLOR_ADMINCMD, "Razón: %s", banReason);
			SendClientMessage(playerid, COLOR_ADMINCMD, "Este baneo afecta a todos los personajes asociados a esta IP.");
			SetTimerEx("kickTimer", 1000, false, "d", playerid);
		}
	}
	else
	{
		MultiChar_ShowMasterMenu(playerid);
	}

	return 1;
}

// ==================== DIALOG RESPONSES ====================

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DLG_MASTER_INPUT_NAME:
		{
			if(!response) // Botón "Cancelar"
				return KickPlayer(playerid, "el sistema", "evadir inicio de sesión");
			
			// Validar usuario
			if(strlen(inputtext) < 3 || strlen(inputtext) > 32)
			{
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El nombre de usuario debe tener entre 3 y 32 caracteres.");
				return MultiChar_ShowInputName(playerid);
			}
			
			for(new i = 0, len = strlen(inputtext); i < len; i++)
			{
				if(!('a' <= inputtext[i] <= 'z' || 'A' <= inputtext[i] <= 'Z' || '0' <= inputtext[i] <= '9' || inputtext[i] == '_'))
				{
					SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El usuario solo puede contener letras, números y guión bajo (_).");
					return MultiChar_ShowInputName(playerid);
				}
			}
			
			format(g_MasterUsername[playerid], MAX_PLAYER_NAME, "%s", inputtext);
			
			// Ir directamente a pedir contraseña
			MultiChar_ShowInputPassword(playerid);
			return 1;
		}
		
		case DLG_MASTER_INPUT_PASS:
		{
			if(!response) // Botón "Cancelar"
				return MultiChar_ShowInputName(playerid);
			
			// Validar contraseña
			if(strlen(inputtext) < 4)
			{
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La contraseña debe tener al menos 4 caracteres.");
				return MultiChar_ShowInputPassword(playerid);
			}
			
			format(g_MasterPassword[playerid], 128, "%s", inputtext);
			
			// Verificar si la cuenta existe
			new query[256];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), 
				"SELECT id FROM master_accounts WHERE username='%e' LIMIT 1", 
				g_MasterUsername[playerid]);
			mysql_tquery(MYSQL_HANDLE, query, "OnCheckMasterAccount_AutoLogin", "i", playerid);
			return 1;
		}
		
		case DLG_MASTER_LOGIN:
		{
			// Este diálogo ya no se usa - mantener para compatibilidad
			if(!response)
				return MultiChar_ShowMasterMenu(playerid);
			return 1;
		}
		
		case DLG_MASTER_REGISTER:
		{
			// Este diálogo ya no se usa - mantener para compatibilidad
			if(!response)
				return MultiChar_ShowMasterMenu(playerid);
			return 1;
		}
		
		case DLG_MASTER_PASSWORD:
		{
			if(!response)
				return KickPlayer(playerid, "el sistema", "evadir inicio de sesión");
			
			if(strlen(inputtext) < 4)
			{
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La contraseña debe tener al menos 4 caracteres.");
				
				new dialog[512];
				format(dialog, sizeof(dialog), "{FFFFFF}Cuenta: {FFD700}%s{FFFFFF}\n\nPor favor, ingresa tu contraseña:", g_MasterUsername[playerid]);
				ShowPlayerDialog(playerid, DLG_MASTER_PASSWORD, DIALOG_STYLE_PASSWORD, "Contraseña", dialog, "Ingresar", "Atrás");
				return 1;
			}
			
			new query[512], escaped[128];
			format(escaped, sizeof(escaped), "%s", inputtext);
			mysql_escape_string(escaped, escaped, sizeof(escaped), MYSQL_HANDLE);
			
			mysql_format(MYSQL_HANDLE, query, sizeof(query), 
				"SELECT id FROM master_accounts WHERE username='%e' AND password_hash=MD5('%s') LIMIT 1", 
				g_MasterUsername[playerid], escaped);
			mysql_tquery(MYSQL_HANDLE, query, "OnVerifyMasterPassword", "i", playerid);
			
			return 1;
		}
		
		case DLG_MASTER_REGISTER_PASS:
		{
			if(!response)
				return MultiChar_ShowMasterMenu(playerid);
			
			if(strlen(inputtext) < 4)
			{
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La contraseña debe tener al menos 4 caracteres.");
				
				new dialog[512];
				format(dialog, sizeof(dialog), "{FFFFFF}Usuario: {FFD700}%s{FFFFFF}\n\nIngresa una contraseña para tu cuenta.\n\n", g_MasterUsername[playerid]);
				strcat(dialog, "{E44A4A}Importante:{FFFFFF} Guarda tu contraseña en un lugar seguro.");
				ShowPlayerDialog(playerid, DLG_MASTER_REGISTER_PASS, DIALOG_STYLE_PASSWORD, "Registro - Contraseña", dialog, "Registrarse", "Atrás");
				return 1;
			}
			
			new query[512], escaped[128], playerIP[16];
			format(escaped, sizeof(escaped), "%s", inputtext);
			mysql_escape_string(escaped, escaped, sizeof(escaped), MYSQL_HANDLE);
			GetPlayerIp(playerid, playerIP, sizeof(playerIP));
			
			mysql_format(MYSQL_HANDLE, query, sizeof(query), 
				"INSERT INTO master_accounts (username, password_hash, last_ip) VALUES ('%e', MD5('%s'), '%e')", 
				g_MasterUsername[playerid], escaped, playerIP);
			mysql_tquery(MYSQL_HANDLE, query, "OnMasterAccountCreated", "i", playerid);
			
			return 1;
		}
		
		case DLG_CHAR_SELECT:
		{
			if(!response)
			{
				if(CharSwitch_IsSwitching(playerid))
				{
					CharSwitch_Reset(playerid);
					return SendClientMessage(playerid, COLOR_INFO, "[INFO] Cambio de personaje cancelado.");
				}
				return KickPlayer(playerid, "el sistema", "salir de selección");
			}
			
			// Ocultar textdraws de login cuando selecciona personaje
			// LoginTD_Hide(playerid); // Deshabilitado: solo diálogos
			
			if(CharSwitch_IsSwitching(playerid))
			{
				if(listitem >= g_CharacterSlots[playerid])
				{
					CharSwitch_Reset(playerid);
					return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] Seleccion invalida.");
				}
				if(g_CharacterIds[playerid][listitem] == PlayerInfo[playerid][pID])
				{
					CharSwitch_Reset(playerid);
					return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] Ya estas jugando con ese personaje.");
				}
				if(IsCharacterConnected(g_CharacterIds[playerid][listitem], playerid))
				{
					CharSwitch_Reset(playerid);
					SendClientMessage(playerid, COLOR_RED, "Este personaje ya está conectado al servidor.");
					return SendClientMessage(playerid, COLOR_RED, "Por seguridad, no puedes conectarte dos veces con el mismo personaje.");
				}
				CharSwitch_DoCleanup(playerid);
				PlayerInfo[playerid][pMasterAccountId] = g_MasterAccountId[playerid];
				PlayerInfo[playerid][pCharacterSlot] = listitem + 1;
				format(PlayerInfo[playerid][pName], MAX_PLAYER_NAME, "%s", g_CharacterList[playerid][listitem]);
				SetPlayerName(playerid, g_CharacterList[playerid][listitem]);
				SetPlayerCleanName(playerid, g_CharacterList[playerid][listitem]);
				SetPlayerChatName(playerid, g_CharacterList[playerid][listitem]);
				new query_cs[512];
				mysql_format(MYSQL_HANDLE, query_cs, sizeof(query_cs),
					"SELECT * FROM accounts WHERE Id=%d LIMIT 1",
					g_CharacterIds[playerid][listitem]);
				mysql_tquery(MYSQL_HANDLE, query_cs, "OnPlayerAccountDataLoad", "i", playerid);
				return 1;
			}
			
			if(listitem >= g_CharacterSlots[playerid])
			{
				MultiChar_ShowCreateCharacter(playerid);
			}
			else
			{
				// Verificar si el personaje ya está conectado
				if(IsCharacterConnected(g_CharacterIds[playerid][listitem], playerid))
				{
					SendClientMessage(playerid, COLOR_RED, "Este personaje ya está conectado al servidor.");
					SendClientMessage(playerid, COLOR_RED, "Por seguridad, no puedes conectarte dos veces con el mismo personaje.");
					SetTimerEx("kickTimer", 500, false, "d", playerid);
					return 1;
				}
				
				PlayerInfo[playerid][pMasterAccountId] = g_MasterAccountId[playerid];
				PlayerInfo[playerid][pCharacterSlot] = listitem + 1;
				format(PlayerInfo[playerid][pName], MAX_PLAYER_NAME, "%s", g_CharacterList[playerid][listitem]);
				
				// Cambiar el nombre de SA-MP al nombre del personaje
				SetPlayerName(playerid, g_CharacterList[playerid][listitem]);
				SetPlayerCleanName(playerid, g_CharacterList[playerid][listitem]);
				SetPlayerChatName(playerid, g_CharacterList[playerid][listitem]);
				
				// El audio se reproducirá al conectar (OnPlayerConnect)
				
				new query[512];
				mysql_format(MYSQL_HANDLE, query, sizeof(query), 
					"SELECT * FROM accounts WHERE Id=%d LIMIT 1", 
					g_CharacterIds[playerid][listitem]);
				mysql_tquery(MYSQL_HANDLE, query, "OnPlayerAccountDataLoad", "i", playerid);
			}
			
			return 1;
		}
		
		case DLG_CHAR_CREATE_NAME:
		{
			if(!response)
				return MultiChar_ShowCharSelect(playerid);
			
			if(strlen(inputtext) < 5 || strlen(inputtext) > MAX_PLAYER_NAME-1)
			{
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El nombre debe tener entre 5 y 24 caracteres.");
				MultiChar_ShowCreateCharacter(playerid);
				return 1;
			}
			
			new bool:hasUnderscore = false;
			new underscoreCount = 0;
			
			for(new i = 0, len = strlen(inputtext); i < len; i++)
			{
				if(inputtext[i] == '_')
				{
					hasUnderscore = true;
					underscoreCount++;
				}
				else if(!('a' <= inputtext[i] <= 'z' || 'A' <= inputtext[i] <= 'Z'))
				{
					SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El nombre solo puede contener letras y un guión bajo (_).");
					MultiChar_ShowCreateCharacter(playerid);
					return 1;
				}
			}
			
			if(!hasUnderscore || underscoreCount != 1)
			{
				SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El nombre debe tener el formato: Nombre_Apellido (un solo guión bajo).");
				MultiChar_ShowCreateCharacter(playerid);
				return 1;
			}
			
			inputtext[0] = toupper(inputtext[0]);
			for(new i = 1, len = strlen(inputtext); i < len; i++)
			{
				if(inputtext[i-1] == '_')
					inputtext[i] = toupper(inputtext[i]);
				else
					inputtext[i] = tolower(inputtext[i]);
			}
			
			new query[512];
			mysql_format(MYSQL_HANDLE, query, sizeof(query), 
				"SELECT Id FROM accounts WHERE Name='%e' LIMIT 1", inputtext);
			
			SetPVarString(playerid, "PendingCharName", inputtext);
			mysql_tquery(MYSQL_HANDLE, query, "OnCheckCharacterName", "i", playerid);
			
			return 1;
		}
	}
	return 0;
}

// ==================== CALLBACKS ====================

forward OnCheckMasterAccount(playerid);
forward OnCheckMasterAccount_Login(playerid);
forward OnCheckMasterAccount_Register(playerid);
forward OnCheckMasterAccount_AutoLogin(playerid);
forward OnVerifyMasterPassword(playerid);
forward OnVerifyMasterPasswordDirect(playerid);
forward OnCheckMaster_RegDirect(playerid);

public OnCheckMasterAccount(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	if(cache_num_rows() > 0)
	{
		cache_get_value_int(0, "id", g_MasterAccountId[playerid]);

		// Ocultar textdraws de login al haber verificado correctamente
		// LoginTD_Hide(playerid); // Deshabilitado: solo diálogos
		
		new dialog[512];
		format(dialog, sizeof(dialog), "{FFFFFF}Cuenta: {FFD700}%s{FFFFFF}\n\nPor favor, ingresa tu contraseña:", g_MasterUsername[playerid]);
		
		ShowPlayerDialog(playerid, DLG_MASTER_PASSWORD, DIALOG_STYLE_PASSWORD, "Contraseña", dialog, "Ingresar", "Atrás");
	}
	else
	{
		new query[128];
		new playerIP[16];
		GetPlayerIp(playerid, playerIP, sizeof(playerIP));

		mysql_format(MYSQL_HANDLE, query, sizeof(query),
			"SELECT COUNT(*) AS total FROM master_accounts WHERE last_ip='%e'",
			playerIP);
		mysql_tquery(MYSQL_HANDLE, query, "OnCheckMasterIPLimit_Register", "i", playerid);
	}
	
	return 1;
}

public OnCheckMasterAccount_AutoLogin(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	if(cache_num_rows() > 0)
	{
		// La cuenta existe, intentar login
		cache_get_value_int(0, "id", g_MasterAccountId[playerid]);
		
		// Verificar la contraseña
		new query[512], escaped[128];
		format(escaped, sizeof(escaped), "%s", g_MasterPassword[playerid]);
		mysql_escape_string(escaped, escaped, sizeof(escaped), MYSQL_HANDLE);
		
		mysql_format(MYSQL_HANDLE, query, sizeof(query), 
			"SELECT id FROM master_accounts WHERE username='%e' AND password_hash=MD5('%s') LIMIT 1", 
			g_MasterUsername[playerid], escaped);
		mysql_tquery(MYSQL_HANDLE, query, "OnVerifyMasterPasswordDirect", "i", playerid);
	}
	else
	{
		// La cuenta no existe, proceder con registro
		// Verificar límite de IPs
		new query[256];
		new playerIP[16];
		GetPlayerIp(playerid, playerIP, sizeof(playerIP));

		mysql_format(MYSQL_HANDLE, query, sizeof(query),
			"SELECT COUNT(*) AS total FROM master_accounts WHERE last_ip='%e'",
			playerIP);
		mysql_tquery(MYSQL_HANDLE, query, "OnCheckMasterIPLimit_RegDir", "i", playerid);
	}
	
	return 1;
}

public OnCheckMasterAccount_Login(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	if(cache_num_rows() > 0)
	{
		cache_get_value_int(0, "id", g_MasterAccountId[playerid]);

		// Ocultar textdraws de login al haber verificado correctamente
		// LoginTD_Hide(playerid); // Deshabilitado: solo diálogos
		
		// Verificar la contraseña directamente
		new query[512], escaped[128];
		format(escaped, sizeof(escaped), "%s", g_MasterPassword[playerid]);
		mysql_escape_string(escaped, escaped, sizeof(escaped), MYSQL_HANDLE);
		
		mysql_format(MYSQL_HANDLE, query, sizeof(query), 
			"SELECT id FROM master_accounts WHERE username='%e' AND password_hash=MD5('%s') LIMIT 1", 
			g_MasterUsername[playerid], escaped);
		mysql_tquery(MYSQL_HANDLE, query, "OnVerifyMasterPassword", "i", playerid);
	}
	else
	{
		SendClientMessage(playerid, COLOR_RED, "No existe una cuenta con ese nombre de usuario.");
		SendClientMessage(playerid, COLOR_YELLOW2, "Vuelve al menú anterior e intenta con otro nombre o registrarse.");
		MultiChar_ShowMasterMenu(playerid);
	}
	
	return 1;
}

public OnCheckMasterAccount_Register(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	if(cache_num_rows() > 0)
	{
		SendClientMessage(playerid, COLOR_RED, "Ese nombre de usuario ya está registrado.");
		SendClientMessage(playerid, COLOR_YELLOW2, "Intenta con otro nombre.");
		MultiChar_ShowMasterMenu(playerid);
	}
	else
	{
		// Verificar límite de IPs
		new query[256];
		new playerIP[16];
		GetPlayerIp(playerid, playerIP, sizeof(playerIP));

		mysql_format(MYSQL_HANDLE, query, sizeof(query),
			"SELECT COUNT(*) AS total FROM master_accounts WHERE last_ip='%e'",
			playerIP);
		mysql_tquery(MYSQL_HANDLE, query, "OnCheckMasterIPLimit_Register", "i", playerid);
	}
	
	return 1;
}

public OnCheckMasterIPLimit_Register(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	new total = 0;
	cache_get_value_int(0, "total", total);

	if(total >= 2)
	{
		SendClientMessage(playerid, COLOR_RED, "Se alcanzó el límite de 2 cuentas maestras por IP.");
		SendClientMessage(playerid, COLOR_YELLOW2, "Si consideras que es un error, abre un ticket en Discord.");
		SetTimerEx("kickTimer", 1000, false, "d", playerid);
		return 1;
	}

	// Proceder con el registro de la cuenta
	new query[512], escaped[128], playerIP[16];
	format(escaped, sizeof(escaped), "%s", g_MasterPassword[playerid]);
	mysql_escape_string(escaped, escaped, sizeof(escaped), MYSQL_HANDLE);
	GetPlayerIp(playerid, playerIP, sizeof(playerIP));
	
	mysql_format(MYSQL_HANDLE, query, sizeof(query), 
		"INSERT INTO master_accounts (username, password_hash, last_ip) VALUES ('%e', MD5('%s'), '%e')", 
		g_MasterUsername[playerid], escaped, playerIP);
	mysql_tquery(MYSQL_HANDLE, query, "OnMasterAccountCreated", "i", playerid);
	
	return 1;
}

// ==================== CALLBACKS ASYNC ====================

public OnUpdateBanStatusAfterIPBan(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	MultiChar_ShowMasterMenu(playerid);
	return 1;
}

public OnUpdateMasterLastLogin(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	// Verificar si la cuenta maestra tiene baneos activos (CUENTA, IP o PERSONAJE)
	new query[512];
	new playerIP[16];
	GetPlayerIp(playerid, playerIP, sizeof(playerIP));
	
	// Verificar baneos de: 1) Cuenta maestra, 2) IP, 3) Personaje específico (aunque aún no se cargó)
	mysql_format(MYSQL_HANDLE, query, sizeof(query), 
		"SELECT *, banType FROM bans WHERE ((master_account_id=%d AND banType='CUENTA') OR (pIP='%e' AND banType='IP')) AND banActive=1 ORDER BY banType DESC LIMIT 1", 
		g_MasterAccountId[playerid], playerIP);
	mysql_tquery(MYSQL_HANDLE, query, "OnCheckMasterAccountBan", "i", playerid);
	
	return 1;
}

public OnAccountUnbanned(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	// Continuar con la carga de personajes
	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), 
		"SELECT Id, Name, character_slot FROM accounts WHERE master_account_id=%d ORDER BY character_slot LIMIT 3", 
		g_MasterAccountId[playerid]);
	mysql_tquery(MYSQL_HANDLE, query, "OnLoadCharacterList", "i", playerid);
	
	return 1;
}forward OnVerifyMasterPassword(playerid);
public OnVerifyMasterPassword(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	if(cache_num_rows() > 0)
	{
		cache_get_value_int(0, "id", g_MasterAccountId[playerid]);
		
		// Verificar si la cuenta ya está conectada
		if(IsMasterAccountConnected(g_MasterAccountId[playerid], playerid))
		{
			SendClientMessage(playerid, COLOR_RED, "Esta cuenta ya está conectada al servidor.");
			SendClientMessage(playerid, COLOR_RED, "Por seguridad, no puedes conectarte dos veces con la misma cuenta.");
			SetTimerEx("kickTimer", 500, false, "d", playerid);
			return 1;
		}
		
		new query[256];
		new playerIP[16];
		GetPlayerIp(playerid, playerIP, sizeof(playerIP));
		
		mysql_format(MYSQL_HANDLE, query, sizeof(query), 
			"UPDATE master_accounts SET last_login=NOW(), last_ip='%e' WHERE id=%d", 
			playerIP, g_MasterAccountId[playerid]);
		mysql_tquery(MYSQL_HANDLE, query, "OnUpdateMasterLastLogin", "i", playerid);
	}
	else
	{
		SendClientMessage(playerid, COLOR_RED, "Contraseña incorrecta. Intenta nuevamente.");
		
		new dialog[512];
		format(dialog, sizeof(dialog), "{E44A4A}¡Contraseña incorrecta!{FFFFFF}\n\nCuenta: {FFD700}%s{FFFFFF}\n\nIngresa tu contraseña nuevamente:", g_MasterUsername[playerid]);
		
		ShowPlayerDialog(playerid, DLG_MASTER_PASSWORD, DIALOG_STYLE_PASSWORD, "Contraseña", dialog, "Ingresar", "Atrás");
	}
	
	return 1;
}

forward OnCheckMasterAccountBan(playerid);
public OnCheckMasterAccountBan(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	if(cache_num_rows() > 0)
	{
		new issuerName[MAX_PLAYER_NAME], banReason[128], banEndDate[32], banEndUnix, banType[16];
		new playerIP[16];
		GetPlayerIp(playerid, playerIP, sizeof(playerIP));
		
		cache_get_value_name(0, "banIssuerName", issuerName, MAX_PLAYER_NAME);
		cache_get_value_name(0, "banReason", banReason, 128);
		cache_get_value_name(0, "banEnd", banEndDate, 32);
		cache_get_value_name_int(0, "banEndUnix", banEndUnix);
		cache_get_value_name(0, "banType", banType, sizeof(banType));
		
		if(gettime() > banEndUnix)
		{
			SendFMessage(playerid, COLOR_ADMINCMD, "[SERVIDOR] Has sido desbaneado ya que el baneo temporal finalizó el %s.", banEndDate);
			
			new query[512];
			if(strcmp(banType, "CUENTA", false) == 0)
			{
				mysql_format(MYSQL_HANDLE, query, sizeof(query), 
					"UPDATE bans SET banActive=0 WHERE master_account_id=%d AND banType='CUENTA' AND banActive=1", 
					g_MasterAccountId[playerid]);
			}
			else if(strcmp(banType, "IP", false) == 0)
			{
				mysql_format(MYSQL_HANDLE, query, sizeof(query), 
					"UPDATE bans SET banActive=0 WHERE pIP='%e' AND banType='IP' AND banActive=1", 
					playerIP);
			}
			else // Legacy o PERSONAJE
			{
				mysql_format(MYSQL_HANDLE, query, sizeof(query), 
					"UPDATE bans SET banActive=0 WHERE (master_account_id=%d OR pIP='%e') AND banActive=1", 
					g_MasterAccountId[playerid], playerIP);
			}
			mysql_tquery(MYSQL_HANDLE, query, "OnAccountUnbanned", "i", playerid);
		}
		else
		{
			new banTypeMsg[64];
			if(strcmp(banType, "CUENTA", false) == 0)
				format(banTypeMsg, sizeof(banTypeMsg), "Tu CUENTA MAESTRA");
			else if(strcmp(banType, "IP", false) == 0)
				format(banTypeMsg, sizeof(banTypeMsg), "Tu IP");
			else
				format(banTypeMsg, sizeof(banTypeMsg), "Tu cuenta");
				
			SendFMessage(playerid, COLOR_ADMINCMD, "%s está baneada hasta el %s por %s.", banTypeMsg, banEndDate, issuerName);
			SendFMessage(playerid, COLOR_ADMINCMD, "Razón: %s", banReason);
			
			if(strcmp(banType, "CUENTA", false) == 0)
				SendClientMessage(playerid, COLOR_ADMINCMD, "Este baneo de CUENTA afecta a todos los personajes de tu cuenta maestra.");
			else if(strcmp(banType, "IP", false) == 0)
				SendClientMessage(playerid, COLOR_ADMINCMD, "Este baneo de IP afecta a todas las conexiones desde tu dirección IP.");
			
			SendClientMessage(playerid, COLOR_ADMINCMD, "Para más información o realizar un reclamo, dirígete a nuestro Discord.");
			SetTimerEx("kickTimer", 1000, false, "d", playerid);
		}
		
		return 1;
	}
	
	// No hay baneos activos, continuar con la carga de personajes
	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), 
		"SELECT Id, Name, character_slot FROM accounts WHERE master_account_id=%d ORDER BY character_slot LIMIT 3", 
		g_MasterAccountId[playerid]);
	mysql_tquery(MYSQL_HANDLE, query, "OnLoadCharacterList", "i", playerid);
	
	return 1;
}

forward OnMasterAccountCreated(playerid);
public OnMasterAccountCreated(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	g_MasterAccountId[playerid] = cache_insert_id();
	g_CharacterSlots[playerid] = 0;

	// Ocultar textdraws luego de registrar la cuenta
	// LoginTD_Hide(playerid); // Deshabilitado: solo diálogos
	
	SendClientMessage(playerid, COLOR_GREEN, "¡Cuenta creada exitosamente!");
	SendClientMessage(playerid, COLOR_INFO, "Ahora deberás pasar el test de normativa para crear tu primer personaje.");
	
	// Marcar que es un nuevo registro
	SetPVarInt(playerid, "NewRegistration", 1);
	
	// Redirigir al test de rol
	CallLocalFunction("AccountRegister", "i", playerid);

	
	return 1;
}

// Esta función puede ser llamada por el test de rol cuando el jugador finaliza correctamente.
public AccountRegister_Complete(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	// Si fue un nuevo registro, abrir creación de nombre de personaje
	if(GetPVarInt(playerid, "NewRegistration") == 1)
	{
		// Mostrar la lista de personajes (desde ahí se podrá crear en el slot "Nuevo").
		// No borramos la PVar aquí: se eliminará cuando el jugador confirme el nombre
		// en OnCheckCharacterName para que el flujo post-test continúe correctamente.
		MultiChar_ShowCharSelect(playerid);
		return 1;
	}

	return 1;
}

forward OnLoadCharacterList(playerid);
public OnLoadCharacterList(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	// Ocultar textdraws de login al pasar a selección de personaje
	// LoginTD_Hide(playerid); // Deshabilitado: solo diálogos
	
	g_CharacterSlots[playerid] = cache_num_rows();
	
	for(new i = 0; i < g_CharacterSlots[playerid]; i++)
	{
		cache_get_value_int(i, "Id", g_CharacterIds[playerid][i]);
		cache_get_value_name(i, "Name", g_CharacterList[playerid][i], MAX_PLAYER_NAME);
	}
	
	MultiChar_ShowCharSelect(playerid);
	
	return 1;
}

forward OnCheckCharacterName(playerid);
public OnCheckCharacterName(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	new charname[MAX_PLAYER_NAME];
	GetPVarString(playerid, "PendingCharName", charname, sizeof(charname));
	
	if(cache_num_rows() > 0)
	{
		SendClientMessage(playerid, COLOR_YELLOW2, "Ese nombre de personaje ya está en uso. Intenta con otro.");
		MultiChar_ShowCreateCharacter(playerid);
		return 1;
	}
	
	format(PlayerInfo[playerid][pName], MAX_PLAYER_NAME, "%s", charname);
	PlayerInfo[playerid][pMasterAccountId] = g_MasterAccountId[playerid];
	PlayerInfo[playerid][pCharacterSlot] = g_CharacterSlots[playerid] + 1;
	
	// Verificar si es un nuevo registro (viene del test de rol)
	if(GetPVarInt(playerid, "NewRegistration") == 1)
	{
		DeletePVar(playerid, "NewRegistration");
		
		SendClientMessage(playerid, COLOR_GREEN, "¡Nombre aceptado! Ahora deberás crear tu personaje.");
		SendClientMessage(playerid, COLOR_INFO, "Podrás agregar descripción después con /descripcion [texto]");
		
		// Descripción por defecto para el primer personaje
		format(PlayerInfo[playerid][pDescription], 70, "Sin descripción");
		
		// Insertar personaje en la base de datos
		new query[512];
		mysql_format(MYSQL_HANDLE, query, sizeof(query), 
			"INSERT INTO accounts (Name, Password, pDescription, master_account_id, character_slot, FirstLogin) VALUES ('%e', '', '%e', %d, %d, 1)", 
			PlayerInfo[playerid][pName], 
			PlayerInfo[playerid][pDescription], 
			PlayerInfo[playerid][pMasterAccountId], 
			PlayerInfo[playerid][pCharacterSlot]);
		mysql_tquery(MYSQL_HANDLE, query);
		
		// Ir directo al panel de creación de personaje
		StartAccountFirstLogin(playerid);
	}
	else if(g_CharacterSlots[playerid] > 0)
	{
		SendClientMessage(playerid, COLOR_GREEN, "¡Nombre aceptado! Ahora deberás crear tu personaje.");
		SendClientMessage(playerid, COLOR_INFO, "Podrás agregar descripción después con /descripcion [texto]");
		
		// Descripción por defecto para personajes adicionales
		format(PlayerInfo[playerid][pDescription], 70, "Sin descripción");
		
		// Insertar personaje directamente en la base de datos
		new query[512];
		mysql_format(MYSQL_HANDLE, query, sizeof(query), 
			"INSERT INTO accounts (Name, Password, pDescription, master_account_id, character_slot, FirstLogin) VALUES ('%e', '', '%e', %d, %d, 1)", 
			PlayerInfo[playerid][pName], 
			PlayerInfo[playerid][pDescription], 
			PlayerInfo[playerid][pMasterAccountId], 
			PlayerInfo[playerid][pCharacterSlot]);
		mysql_tquery(MYSQL_HANDLE, query);
		
		// Ir directo al panel de creación de personaje
		StartAccountFirstLogin(playerid);
	}
	else
	{
		// Primer personaje: hacer el test de normativa
		SendClientMessage(playerid, COLOR_GREEN, "¡Nombre aceptado! Ahora deberás pasar el test de normativa.");
		CallLocalFunction("AccountRegister", "i", playerid);
	}
	
	return 1;
}

// Callback para verificar la contraseña cuando presiona "Iniciar sesión" directamente desde el menú
public OnVerifyMasterPasswordDirect(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	if(cache_num_rows() > 0)
	{
		cache_get_value_int(0, "id", g_MasterAccountId[playerid]);
		
		// Verificar si la cuenta ya está conectada
		if(IsMasterAccountConnected(g_MasterAccountId[playerid], playerid))
		{
			SendClientMessage(playerid, COLOR_RED, "Esta cuenta ya está conectada al servidor.");
			SendClientMessage(playerid, COLOR_RED, "Por seguridad, no puedes conectarte dos veces con la misma cuenta.");
			SetTimerEx("kickTimer", 500, false, "d", playerid);
			return 1;
		}
		
		new query[256];
		new playerIP[16];
		GetPlayerIp(playerid, playerIP, sizeof(playerIP));
		
		mysql_format(MYSQL_HANDLE, query, sizeof(query), 
			"UPDATE master_accounts SET last_login=NOW(), last_ip='%e' WHERE id=%d", 
			playerIP, g_MasterAccountId[playerid]);
		mysql_tquery(MYSQL_HANDLE, query);
		
		// Verificar si la cuenta maestra tiene baneos activos
		mysql_format(MYSQL_HANDLE, query, sizeof(query), 
			"SELECT * FROM bans WHERE ((master_account_id=%d AND banType='CUENTA') OR (pIP='%e' AND banType='IP')) AND banActive=1 ORDER BY banType DESC LIMIT 1", 
			g_MasterAccountId[playerid], playerIP);
		mysql_tquery(MYSQL_HANDLE, query, "OnCheckMasterAccountBan", "i", playerid);
	}
	else
	{
		SendClientMessage(playerid, COLOR_RED, "Contraseña incorrecta.");
		MultiChar_ShowMasterMenu(playerid);
	}
	
	return 1;
}

// Callback para registrar directamente desde el menú
public OnCheckMaster_RegDirect(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	if(cache_num_rows() > 0)
	{
		SendClientMessage(playerid, COLOR_RED, "Ese nombre de usuario ya está registrado.");
		MultiChar_ShowMasterMenu(playerid);
	}
	else
	{
		// Verificar límite de IPs
		new query[256];
		new playerIP[16];
		GetPlayerIp(playerid, playerIP, sizeof(playerIP));

		mysql_format(MYSQL_HANDLE, query, sizeof(query),
			"SELECT COUNT(*) AS total FROM master_accounts WHERE last_ip='%e'",
			playerIP);
		mysql_tquery(MYSQL_HANDLE, query, "OnCheckMasterIPLimit_RegDir", "i", playerid);
	}
	
	return 1;
}

forward OnCheckMasterIPLimit_RegDir(playerid);
public OnCheckMasterIPLimit_RegDir(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	new total = 0;
	cache_get_value_int(0, "total", total);

	if(total >= 2)
	{
		SendClientMessage(playerid, COLOR_RED, "Se alcanzó el límite de 2 cuentas maestras por IP.");
		SendClientMessage(playerid, COLOR_YELLOW2, "Si consideras que es un error, abre un ticket en Discord.");
		MultiChar_ShowMasterMenu(playerid);
		return 1;
	}

	// Proceder con el registro de la cuenta
	new query[512], escaped[128], playerIP[16];
	format(escaped, sizeof(escaped), "%s", g_MasterPassword[playerid]);
	mysql_escape_string(escaped, escaped, sizeof(escaped), MYSQL_HANDLE);
	GetPlayerIp(playerid, playerIP, sizeof(playerIP));
	
	mysql_format(MYSQL_HANDLE, query, sizeof(query), 
		"INSERT INTO master_accounts (username, password_hash, last_ip) VALUES ('%e', MD5('%s'), '%e')", 
		g_MasterUsername[playerid], escaped, playerIP);
	mysql_tquery(MYSQL_HANDLE, query, "OnMasterAccountCreated", "i", playerid);
	
	return 1;
}


CMD:cp(playerid, params[])
{
	return cmd_cambiarpersonaje(playerid, params);
}

CMD:cambiarpersonaje(playerid, params[])
{
	if(!gPlayerLogged[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No estas logueado.");

	if(g_CharacterSlots[playerid] < 2)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Solo tienes un personaje. Crea otro desde la pantalla de seleccion de personaje.");

	if(CharSwitch_IsSwitching(playerid))
		return 1;

	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_YELLOW2, "No puedes cambiar de personaje estando incapacitado/congelado.");

	if(PlayerInfo[playerid][pJailed])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes cambiar de personaje estando preso.");

	if(PlayerInfo[playerid][pHospitalized])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes cambiar de personaje estando hospitalizado.");

	CharSwitch_Begin(playerid);
	MultiChar_ShowCharSelect(playerid);
	return 1;
}
