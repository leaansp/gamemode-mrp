#if defined _marp_phone_core_included
	#endinput
#endif
#define _marp_phone_core_included

#include <YSI_Coding\y_hooks>

static Map:PHONE_NUMBER_TO_ID_MAP = INVALID_MAP;

hook OnGameModeInit()
{
	PHONE_NUMBER_TO_ID_MAP = map_new(.ordered = false);
	return 1;
}

hook OnGameModeExit()
{
	for(new Iter:i = map_iter(PHONE_NUMBER_TO_ID_MAP, .index = 0), vecid; iter_inside(i); iter_move_next(i))
	{
		if(!iter_get_value_safe(i, vecid))
			continue;

		Phone_Delete(PHONE_HANDLE:vecid, .mapremove = false);
	}

	map_delete(PHONE_NUMBER_TO_ID_MAP);
	return 1;
}

enum e_PHONE_DATA {
	PHONE_NUMBER,
	PHONE_PLAYERID,
	PHONE_ON_OFF,
	PHONE_CURRENT_CALL,
	PHONE_SMS_VECTOR,
	PHONE_CONTACTS_VECTOR,
	PHONE_DATA_SIZE
}

stock PHONE_HANDLE:Phone_GetPlayerHandle(playerid) {
	return Phone_id[playerid];
}

stock Phone_SetPlayerHandle(playerid, PHONE_HANDLE:phone) {
	phone_id[playerid] = phone;
}

PHONE_HANDLE:Phone_GetNumberHandle(number)
{
	if(!number)
		return PHONE_HANDLE:0;
	if(!map_has_key(PHONE_NUMBER_TO_ID_MAP, number))
		return PHONE_HANDLE:0;

	new vecid;
	map_get_safe(PHONE_NUMBER_TO_ID_MAP, number, vecid);

	if(!Phone_IsValid(PHONE_HANDLE:vecid))
		return PHONE_HANDLE:0;

	return PHONE_HANDLE:vecid;
}

Phone_IsValid(PHONE_HANDLE:phone) {
	return (_:phone > 0 && vector_size(_:phone) == _:PHONE_DATA_SIZE);
}

Phone_GetContactsVector(PHONE_HANDLE:phone) {
	return (Phone_IsValid(phone)) ? (vector_get(_:phone, PHONE_CONTACTS_VECTOR)) : 0;
}

Phone_GetSMSVector(PHONE_HANDLE:phone) {
	return (Phone_IsValid(phone)) ? (vector_get(_:phone, PHONE_SMS_VECTOR)) : 0;
}

Phone_GetPlayerid(PHONE_HANDLE:phone) {
	return (Phone_IsValid(phone)) ? (vector_get(_:phone, PHONE_PLAYERID)) : INVALID_PLAYER_ID;
}

Phone_GetNumber(PHONE_HANDLE:phone) {
	return (Phone_IsValid(phone)) ? (vector_get(_:phone, PHONE_NUMBER)) : 0;
}

Phone_GetOnOff(PHONE_HANDLE:phone) {
	return (Phone_IsValid(phone)) ? (vector_get(_:phone, PHONE_ON_OFF)) : 0;
}

stock Phone_ToggleOnOff(PHONE_HANDLE:phone) {
	if(Phone_IsValid(phone)) {
		vector_set(_:phone, PHONE_ON_OFF, (vector_get(_:phone, PHONE_ON_OFF)) ? 0 : 1);
	}
}

Phone_IsOnCall(PHONE_HANDLE:phone) {
	return (Phone_IsValid(phone)) ? (vector_get(_:phone, PHONE_CURRENT_CALL)) : 0;
}

PhoneCall:Phone_GetCurrentCall(PHONE_HANDLE:phone) {
	return PhoneCall:((Phone_IsValid(phone)) ? (vector_get(_:phone, PHONE_CURRENT_CALL)) : 0);
}

Phone_SetCurrentCall(PHONE_HANDLE:phone, PhoneCall:call) {
	if(Phone_IsValid(phone)) {
		vector_set(_:phone, PHONE_CURRENT_CALL, _:call);
	}
}

PHONE_HANDLE:Phone_Create(number, playerid)
{
	if(!number)
		return PHONE_HANDLE:0;

	new vecid = vector_create(_:PHONE_DATA_SIZE);
	map_add(PHONE_NUMBER_TO_ID_MAP, number, vecid);

	vector_set(vecid, PHONE_NUMBER, number);
	vector_set(vecid, PHONE_PLAYERID, playerid);
	vector_set(vecid, PHONE_ON_OFF, 1);
	vector_set(vecid, PHONE_CURRENT_CALL, 0);

	vector_set(vecid, PHONE_SMS_VECTOR, vector_create());

	vector_set(vecid, PHONE_CONTACTS_VECTOR, vector_create());
	if (MYSQL_HANDLE != MYSQL_INVALID_HANDLE) {
		PhoneContacts_Load(PHONE_HANDLE:vecid);
	} else {
		printf("[PHONE] DB not connected, skipping contacts load for phone %i.", Phone_GetNumber(PHONE_HANDLE:vecid));
	}

	return PHONE_HANDLE:vecid;
}

Phone_Delete(PHONE_HANDLE:phone, bool:mapremove = true)
{
	if(!Phone_IsValid(phone))
		return 0;

	if(mapremove) {
		map_remove_deep(PHONE_NUMBER_TO_ID_MAP, Phone_GetNumber(phone));
	}

	if(Phone_IsOnCall(phone)) {
		PhoneCall_Unload(Phone_GetCurrentCall(phone), phone);
	}
	
	vector_clear(Phone_GetSMSVector(phone));
	vector_clear(Phone_GetContactsVector(phone));
	vector_clear(_:phone);

	return 1;
}

Phone_NewRandomNumber() {
	return (1500000000 + random(99999999));
}

Phone_IsValidPersonalNumber(number) {
	return (number >= 1500000000 && number <= 1599999999);
}

Phone_IsValidInputNumber(number) {
	return (number > 0 && number <= 1599999999);
}

Phone_Ring(PHONE_HANDLE:phone)
{
	if(Phone_IsValid(phone))
	{
		if(Phone_GetOnOff(phone)) // Si está prendido
		{
			new playerid = Phone_GetPlayerid(phone);

			if(IsPlayerLogged(playerid)) {
				PlaySoundInRangeOfPlayer(playerid, 15.0, 20804);
			}
		}
	}
}

Phone_Tone(PHONE_HANDLE:phone)
{
	if(Phone_IsValid(phone))
	{
		new playerid = Phone_GetPlayerid(phone);

		if(IsPlayerLogged(playerid)) {
			PlayerPlaySound(playerid, 16001, 0.0, 0.0, 0.0);
		}
	}
}

Phone_DialingTone(PHONE_HANDLE:phone)
{
	if(Phone_IsValid(phone))
	{
		new playerid = Phone_GetPlayerid(phone);

		if(IsPlayerLogged(playerid)) {
			PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);
		}
	}
}

hook LoadAccountDataEnded(playerid)
{
	if(PlayerInfo[playerid][pPhoneNumber]) {
		Phone_id[playerid] = Phone_Create(PlayerInfo[playerid][pPhoneNumber], playerid);
	}
	return 1;
}

Phone_DeletePhoneForPlayer(playerid)
{
	if(PlayerInfo[playerid][pPhoneNumber] != 0)
	{
		PhoneContacts_SQLDeleteAll(Phone_id[playerid]);
		Phone_Delete(Phone_id[playerid]);
		Phone_id[playerid] = PHONE_HANDLE:0;
		PlayerInfo[playerid][pPhoneNumber] = 0;
	}
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(PlayerInfo[playerid][pPhoneNumber] != 0) {
		Phone_Delete(Phone_id[playerid]);
		Phone_id[playerid] = PHONE_HANDLE:0;
	}
	return 1;
}