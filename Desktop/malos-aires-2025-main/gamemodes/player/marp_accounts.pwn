#if defined _marp_accounts_included
	#endinput
#endif
#define _marp_accounts_included

#include <YSI_Coding\y_hooks>

#define MASTER_ACC_MAX_USERNAME      (33)
#define MASTER_ACC_MAX_PASS_HASH     (129)
#define MASTER_ACC_MAX_IP            (24)
#define MASTER_ACC_MAX_LAST_LOGIN    (32)

// Cache vinculado al jugador, poblado desde la tabla master_accounts.
enum eAccountInfo {
    accMasterId,
    accUsername[MASTER_ACC_MAX_USERNAME],
    accPasswordHash[MASTER_ACC_MAX_PASS_HASH],
    accLastIp[MASTER_ACC_MAX_IP],
    accLastLogin[MASTER_ACC_MAX_LAST_LOGIN],
    accAdminLevel
};
new AccountInfo[MAX_PLAYERS][eAccountInfo];

static Map:MASTER_ACC_ID_TO_IDX = INVALID_MAP;
static Map:MASTER_ACC_USER_TO_ID = INVALID_MAP;
static MASTER_ACC_IDS_VEC;
static MASTER_ACC_USER_VEC;
static MASTER_ACC_PASS_HASH_VEC;
static MASTER_ACC_LAST_IP_VEC;
static MASTER_ACC_LAST_LOGIN_VEC;
static MASTER_ACC_ADMIN_LEVEL_VEC;

static MasterAccount_NormalizeUsername(const source[], dest[])
{
    dest[0] = EOS;
    strcat(dest, source, MASTER_ACC_MAX_USERNAME);

    for(new i; dest[i] != EOS; i++) {
        dest[i] = tolower(dest[i]);
    }
}

static MasterAccounts_InitStorage()
{
    if(!MASTER_ACC_IDS_VEC) MASTER_ACC_IDS_VEC = vector_create();
    else vector_clear(MASTER_ACC_IDS_VEC);

    if(!MASTER_ACC_USER_VEC) MASTER_ACC_USER_VEC = vector_create();
    else vector_clear(MASTER_ACC_USER_VEC);

    if(!MASTER_ACC_PASS_HASH_VEC) MASTER_ACC_PASS_HASH_VEC = vector_create();
    else vector_clear(MASTER_ACC_PASS_HASH_VEC);

    if(!MASTER_ACC_LAST_IP_VEC) MASTER_ACC_LAST_IP_VEC = vector_create();
    else vector_clear(MASTER_ACC_LAST_IP_VEC);

    if(!MASTER_ACC_LAST_LOGIN_VEC) MASTER_ACC_LAST_LOGIN_VEC = vector_create();
    else vector_clear(MASTER_ACC_LAST_LOGIN_VEC);

    if(!MASTER_ACC_ADMIN_LEVEL_VEC) MASTER_ACC_ADMIN_LEVEL_VEC = vector_create();
    else vector_clear(MASTER_ACC_ADMIN_LEVEL_VEC);

    if(MASTER_ACC_ID_TO_IDX == INVALID_MAP) MASTER_ACC_ID_TO_IDX = map_new(.ordered = false);
    else map_clear(MASTER_ACC_ID_TO_IDX);

    if(MASTER_ACC_USER_TO_ID == INVALID_MAP) MASTER_ACC_USER_TO_ID = map_new(.ordered = false);
    else map_clear(MASTER_ACC_USER_TO_ID);
}

stock MasterAccount_GetIndex(masterId)
{
    if(MASTER_ACC_ID_TO_IDX == INVALID_MAP)
        return -1;

    new idx;
    if(!map_get_safe(MASTER_ACC_ID_TO_IDX, masterId, idx))
        return -1;

    return idx;
}

static MasterAccount_AddEntry(masterId, username[], passwordHash[], lastIp[], lastLogin[], adminLevel)
{
    new idx = vector_size(MASTER_ACC_IDS_VEC);

    vector_push_back(MASTER_ACC_IDS_VEC, masterId);
    vector_push_back_arr(MASTER_ACC_USER_VEC, username);
    vector_push_back_arr(MASTER_ACC_PASS_HASH_VEC, passwordHash);
    vector_push_back_arr(MASTER_ACC_LAST_IP_VEC, lastIp);
    vector_push_back_arr(MASTER_ACC_LAST_LOGIN_VEC, lastLogin);
    vector_push_back(MASTER_ACC_ADMIN_LEVEL_VEC, adminLevel);

    map_add(MASTER_ACC_ID_TO_IDX, masterId, idx);

    new normalized[MASTER_ACC_MAX_USERNAME];
    MasterAccount_NormalizeUsername(username, normalized);
    map_str_add(MASTER_ACC_USER_TO_ID, normalized, masterId);
}

MasterAccounts_LoadAll()
{
    // Se seleccionan los campos relevantes para evitar consultas repetidas en runtime.
    mysql_tquery(MYSQL_HANDLE,
        "SELECT id, username, password_hash, last_ip, last_login, admin_level FROM master_accounts",
        "MasterAccounts_OnLoadAll");
    print("[INFO] Cargando cache de master_accounts...");
    return 1;
}

forward MasterAccounts_OnLoadAll();
public MasterAccounts_OnLoadAll()
{
    MasterAccounts_InitStorage();

    new rows = cache_num_rows();

    for(new row, masterId; row < rows; row++)
    {
        new username[MASTER_ACC_MAX_USERNAME];
        new passwordHash[MASTER_ACC_MAX_PASS_HASH];
        new lastIp[MASTER_ACC_MAX_IP];
        new lastLogin[MASTER_ACC_MAX_LAST_LOGIN];
        new adminLevel;

        cache_get_value_name_int(row, "id", masterId);
        cache_get_value_name(row, "username", username, sizeof(username));
        cache_get_value_name(row, "password_hash", passwordHash, sizeof(passwordHash));
        cache_get_value_name(row, "last_ip", lastIp, sizeof(lastIp));
        cache_get_value_name(row, "last_login", lastLogin, sizeof(lastLogin));
        cache_get_value_name_int(row, "admin_level", adminLevel);

        MasterAccount_AddEntry(masterId, username, passwordHash, lastIp, lastLogin, adminLevel);
    }

    printf("[INFO] Cache de master_accounts cargada (%i filas).", rows);
    return 1;
}

stock MasterAccount_GetIdByUsername(const username[])
{
    if(MASTER_ACC_USER_TO_ID == INVALID_MAP)
        return 0;

    new normalized[MASTER_ACC_MAX_USERNAME];
    MasterAccount_NormalizeUsername(username, normalized);

    if(map_has_str_key(MASTER_ACC_USER_TO_ID, normalized))
        return map_str_get(MASTER_ACC_USER_TO_ID, normalized);

    return 0;
}

stock MasterAccount_PopulateForPlayer(playerid, masterId)
{
    new idx = MasterAccount_GetIndex(masterId);

    if(idx == -1)
    {
        printf("[DEBUG] MasterAccount_PopulateForPlayer: masterId %d NOT FOUND in cache!", masterId);
        AccountInfo[playerid][accMasterId] = 0;
        return 0;
    }

    AccountInfo[playerid][accMasterId] = masterId;
    vector_get_arr(MASTER_ACC_USER_VEC, idx, AccountInfo[playerid][accUsername], MASTER_ACC_MAX_USERNAME);
    vector_get_arr(MASTER_ACC_PASS_HASH_VEC, idx, AccountInfo[playerid][accPasswordHash], MASTER_ACC_MAX_PASS_HASH);
    vector_get_arr(MASTER_ACC_LAST_IP_VEC, idx, AccountInfo[playerid][accLastIp], MASTER_ACC_MAX_IP);
    vector_get_arr(MASTER_ACC_LAST_LOGIN_VEC, idx, AccountInfo[playerid][accLastLogin], MASTER_ACC_MAX_LAST_LOGIN);
    AccountInfo[playerid][accAdminLevel] = vector_get(MASTER_ACC_ADMIN_LEVEL_VEC, idx);
    printf("[DEBUG] MasterAccount_PopulateForPlayer: masterId=%d, idx=%d, adminLevel=%d", 
        masterId, idx, AccountInfo[playerid][accAdminLevel]);
    return 1;
}

stock MasterAccount_ClearPlayerCache(playerid)
{
    AccountInfo[playerid][accMasterId] = 0;
    AccountInfo[playerid][accUsername][0] = EOS;
    AccountInfo[playerid][accPasswordHash][0] = EOS;
    AccountInfo[playerid][accLastIp][0] = EOS;
    AccountInfo[playerid][accLastLogin][0] = EOS;
    AccountInfo[playerid][accAdminLevel] = 0;

    return 1;
}

hook OnGameModeInitEnded()
{
    MasterAccounts_LoadAll();
    return 1;
}

hook OnGameModeExit()
{
    if(MASTER_ACC_ID_TO_IDX != INVALID_MAP)
    {
        map_delete(MASTER_ACC_ID_TO_IDX);
        MASTER_ACC_ID_TO_IDX = INVALID_MAP;
    }

    if(MASTER_ACC_USER_TO_ID != INVALID_MAP)
    {
        map_delete(MASTER_ACC_USER_TO_ID);
        MASTER_ACC_USER_TO_ID = INVALID_MAP;
    }

    if(MASTER_ACC_IDS_VEC) { vector_clear(MASTER_ACC_IDS_VEC); MASTER_ACC_IDS_VEC = 0; }
    if(MASTER_ACC_USER_VEC) { vector_clear(MASTER_ACC_USER_VEC); MASTER_ACC_USER_VEC = 0; }
    if(MASTER_ACC_PASS_HASH_VEC) { vector_clear(MASTER_ACC_PASS_HASH_VEC); MASTER_ACC_PASS_HASH_VEC = 0; }
    if(MASTER_ACC_LAST_IP_VEC) { vector_clear(MASTER_ACC_LAST_IP_VEC); MASTER_ACC_LAST_IP_VEC = 0; }
    if(MASTER_ACC_LAST_LOGIN_VEC) { vector_clear(MASTER_ACC_LAST_LOGIN_VEC); MASTER_ACC_LAST_LOGIN_VEC = 0; }
    if(MASTER_ACC_ADMIN_LEVEL_VEC) { vector_clear(MASTER_ACC_ADMIN_LEVEL_VEC); MASTER_ACC_ADMIN_LEVEL_VEC = 0; }

    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    MasterAccount_ClearPlayerCache(playerid);
    return 1;
}

hook OnMasterAccountCreated(playerid)
{
    // Refresca la cache cuando se crea una nueva cuenta maestra.
    MasterAccounts_LoadAll();
    return 1;
}

// Función para actualizar el admin_level de una master account en BD y cache
stock MasterAccount_SetAdminLevel(masterId, adminLevel)
{
    new query[128];
    mysql_format(MYSQL_HANDLE, query, sizeof(query), 
        "UPDATE master_accounts SET admin_level=%i WHERE id=%i", 
        adminLevel, masterId);
    mysql_tquery(MYSQL_HANDLE, query);
    
    // Actualizar en la cache global
    new idx = MasterAccount_GetIndex(masterId);
    if(idx != -1)
    {
        vector_set(MASTER_ACC_ADMIN_LEVEL_VEC, idx, adminLevel);
        
        // Actualizar el cache del jugador (AccountInfo)
        foreach(new i : Player)
        {
            if(AccountInfo[i][accMasterId] == masterId)
            {
                AccountInfo[i][accAdminLevel] = adminLevel;
            }
        }
    }
    
    return 1;
}

// Función para recargar el admin level desde la DB (útil si se cambia directamente en la DB)
stock MasterAccount_ReloadAdminLevel(masterId)
{
    new query[128];
    mysql_format(MYSQL_HANDLE, query, sizeof(query), 
        "SELECT admin_level FROM master_accounts WHERE id=%i LIMIT 1", masterId);
    mysql_tquery(MYSQL_HANDLE, query, "OnReloadAdminLevel", "i", masterId);
    return 1;
}

forward OnReloadAdminLevel(masterId);
public OnReloadAdminLevel(masterId)
{
    if(cache_num_rows() == 0)
        return 0;
    
    new adminLevel;
    cache_get_value_name_int(0, "admin_level", adminLevel);
    
    // Actualizar en la cache global
    new idx = MasterAccount_GetIndex(masterId);
    if(idx != -1)
    {
        vector_set(MASTER_ACC_ADMIN_LEVEL_VEC, idx, adminLevel);
        
        // Actualizar todos los jugadores conectados con esta master account
        foreach(new i : Player)
        {
            if(AccountInfo[i][accMasterId] == masterId)
            {
                AccountInfo[i][accAdminLevel] = adminLevel;
                SendFMessage(i, COLOR_INFO, "[INFO] Tu nivel administrativo ha sido actualizado a %d desde la base de datos.", adminLevel);
            }
        }
    }
    
    return 1;
}
