#if defined _marp_database_included
	#endinput
#endif
#define _marp_database_included

#define mysql_f_tquery(%0,%1,%2@Callback:%3@Format:%4); \
	{\
		if(%0 == MYSQL_INVALID_HANDLE) {\
			printf("[DB] mysql_f_tquery skipped: invalid connection handle.");\
		} else {\
			new f_tquery_str[%1];\
			mysql_format(%0, f_tquery_str, sizeof(f_tquery_str), %4);\
			mysql_tquery(%0, f_tquery_str, %3);\
		}\
	}

stock cache_index_int(row_idx, column_idx)
{
	new int_value;
	cache_get_value_index_int(row_idx, column_idx, int_value);
	return int_value;
}

stock Float:cache_index_float(row_idx, column_idx)
{
	new Float:float_value;
	cache_get_value_index_float(row_idx, column_idx, float_value);
	return float_value;
}

stock cache_name_int(row_idx, const column_name[])
{
	new int_value;
	cache_get_value_name_int(row_idx, column_name, int_value);
	return int_value;
}

stock Float:cache_name_float(row_idx, const column_name[])
{
	new Float:float_value;
	cache_get_value_name_float(row_idx, column_name, float_value);
	return float_value;
}

// No bajarle el tamaño o no funca.

new MYSQL_HOST[256],
 	MYSQL_USER[256],
 	MYSQL_PASS[256],
 	MYSQL_DB[256],
 	MySQL:MYSQL_HANDLE = MYSQL_INVALID_HANDLE;

new SQLDB_ReconnectTimerId = 0;

SQLDB_LoadConfig()
{
	print("[INFO] Cargando configuracion de servidor y base de datos ...");

	if(dini_Exists("database/db.cfg"))
	{
	    new sendcmd[128];

		MYSQL_HOST = dini_Get("database/db.cfg", "MYSQL_HOST");
		MYSQL_PASS = dini_Get("database/db.cfg", "MYSQL_PASS");
		MYSQL_USER = dini_Get("database/db.cfg", "MYSQL_USER");
		MYSQL_DB = dini_Get("database/db.cfg", "MYSQL_DB");

		printf("[INFO] Configuracion de DB cargada, HOST: [%s], DATABASE: [%s], USER: [%s], PASSWORD: [%s]",  MYSQL_HOST, MYSQL_DB, MYSQL_USER, MYSQL_PASS);

		if(dini_Isset("database/db.cfg", "SERVER_PASSWORD"))
		{
			format(sendcmd, sizeof(sendcmd), "password %s", dini_Get("database/db.cfg", "SERVER_PASSWORD"));
			SendRconCommand(sendcmd);
			print("[INFO] Password del servidor configurada.");
		}

		if(dini_Isset("database/db.cfg", "SERVER_RCON_PASSWORD"))
		{
			format(sendcmd, sizeof(sendcmd), "rcon_password %s", dini_Get("database/db.cfg", "SERVER_RCON_PASSWORD"));
			SendRconCommand(sendcmd);
			print("[INFO] RCON Password del servidor configurada.");
		}

		if(dini_Isset("database/db.cfg", "SERVER_HOSTNAME"))
		{
			format(sendcmd, sizeof(sendcmd), "hostname %s", dini_Get("database/db.cfg", "SERVER_HOSTNAME"));
			SendRconCommand(sendcmd);
			print("[INFO] Hostname del servidor configurado.");
		}

		if(dini_Isset("database/db.cfg", "SERVER_LANGUAGE"))
		{
			format(sendcmd, sizeof(sendcmd), "language %s", dini_Get("database/db.cfg", "SERVER_LANGUAGE"));
			SendRconCommand(sendcmd);
			print("[INFO] Lenguaje del servidor configurado.");
		}
	} else {
		print("[ERROR] Archivo de configuracion no encontrado.");
	}
	return 1;
}

SQLDB_Connect()
{
	print("[INFO] Iniciando conexion con DB...");
	mysql_log(ERROR | WARNING);
	if(!strlen(MYSQL_HOST) || !strlen(MYSQL_USER) || !strlen(MYSQL_DB)) {
		print("[ERROR] Config de DB incompleta (host/user/db). Verifique database/db.cfg.");
	}
	if(!strlen(MYSQL_PASS)) {
		print("[WARNING] MYSQL_PASS vacío. Si su servidor requiere contraseña, la conexión fallará.");
	}
	MYSQL_HANDLE = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DB);

	if(MYSQL_HANDLE != MYSQL_INVALID_HANDLE)
	{
		printf("[INFO] Conexion establecida. MYSQL_HANDLE = %i.", _:MYSQL_HANDLE);
		mysql_set_charset("latin1", MYSQL_HANDLE);
		new charset[32];
		mysql_get_charset(charset, sizeof(charset), MYSQL_HANDLE);
		printf("[INFO] Charset configurado en '%s'.", charset);
		if(SQLDB_ReconnectTimerId) { KillTimer(SQLDB_ReconnectTimerId); SQLDB_ReconnectTimerId = 0; }
	} else {
		printf("[ERROR] No se pudo conectar con la DB. HOST='%s' USER='%s' DB='%s' PASS_LEN=%d", MYSQL_HOST, MYSQL_USER, MYSQL_DB, strlen(MYSQL_PASS));
		if(!SQLDB_ReconnectTimerId) {
			SQLDB_ReconnectTimerId = SetTimer("SQLDB_AttemptReconnect", 10000, true);
			printf("[DB] Intentando reconectar cada 10s...");
		}
	}
}

forward SQLDB_AttemptReconnect();
public SQLDB_AttemptReconnect()
{
	SQLDB_Connect();
	return 1;
}

SQLDB_Close()
{
	print("[INFO] Cerrando conexion con DB...");
	mysql_close(MYSQL_HANDLE);
}

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle) {
	return printf("[ERROR] DB query: errorid: %d | error: %s | callback: %s | query: %s", errorid, error, callback, query);
}
