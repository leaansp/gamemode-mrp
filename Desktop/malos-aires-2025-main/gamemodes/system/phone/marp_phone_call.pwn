#if defined _marp_phone_call_included
	#endinput
#endif
#define _marp_phone_call_included

#include <YSI_Coding\y_hooks>

enum PhoneCallStatus {
	PHONECALL_STATUS_CONNECTING,
	PHONECALL_STATUS_ONGOING,
	PHONECALL_STATUS_ENDED
}

enum {
	PHONECALL_STATUS,
	PHONECALL_FROM,
	PHONECALL_TO,
	PHONECALL_TONETIMER,
	PHONECALL_STARTEDTIME,
	PHONECALL_DATA_SIZE
}

enum e_PhoneCallErrors {
	PHONECALL_ERROR_1,
	PHONECALL_ERROR_2,
	PHONECALL_ERROR_3,
	PHONECALL_ERROR_4,
	PHONECALL_ERROR_5
}

static const PhoneCallErrors[][40] = {
	"Telefono de origen inv�lido.",
	"n�mero inv�lido.",
	"n�mero inexistente.",
	"Linea ocupada.",
	"No se pudo conectar, intente mas tarde."
};

PhoneCall_GetError(error_code)
{
	new str[40];
	strcat(str, (error_code < 0 || error_code >= sizeof(PhoneCallErrors)) ? ("Error desconocido") : (PhoneCallErrors[error_code]));
	return str;
}

PhoneCall_IsValid(PhoneCall:this) {
	return (_:this > 0 && vector_size(_:this) == PHONECALL_DATA_SIZE);
}
static PhoneCallStatus:PhoneCall_GetStatus(PhoneCall:this) {
	return PhoneCallStatus:vector_get(_:this, PHONECALL_STATUS);
}

static PhoneCall_SetStatus(PhoneCall:this, PhoneCallStatus:status) {
	vector_set(_:this, PHONECALL_STATUS, _:status);
}

static PHONE_HANDLE:PhoneCall_GetFrom(PhoneCall:this) {
	return PHONE_HANDLE:vector_get(_:this, PHONECALL_FROM);
}

static PhoneCall_SetFrom(PhoneCall:this, PHONE_HANDLE:phone) {
	vector_set(_:this, PHONECALL_FROM, _:phone);
}

static PHONE_HANDLE:PhoneCall_GetTo(PhoneCall:this) {
	return PHONE_HANDLE:vector_get(_:this, PHONECALL_TO);
}

static PhoneCall_SetTo(PhoneCall:this, PHONE_HANDLE:phone) {
	vector_set(_:this, PHONECALL_TO, _:phone);
}

static PhoneCall_GetToneTimer(PhoneCall:this) {
	return vector_get(_:this, PHONECALL_TONETIMER);
}

static PhoneCall_SetToneTimer(PhoneCall:this, timer) {
	vector_set(_:this, PHONECALL_TONETIMER, timer);
}

static PhoneCall_GetStartedTime(PhoneCall:this) {
	return vector_get(_:this, PHONECALL_STARTEDTIME);
}

static PhoneCall_SetStartedTime(PhoneCall:this, unix) {
	vector_set(_:this, PHONECALL_STARTEDTIME, unix);
}

PhoneCall:PhoneCall_New(PHONE_HANDLE:from_phone, to_number, &error)
{
	new PHONE_HANDLE:to_phone = Phone_GetNumberHandle(to_number);

	if(!to_phone) // No existe un tel�fono creado con ese n�mero
	{
		if(!Phone_IsValidPersonalNumber(to_number)) { // No intent� llamar a un n�mero de persona f�sica
			error = PHONECALL_ERROR_3;
		} else {
			error = PHONECALL_ERROR_5;
		}

		return PhoneCall:0;
	}

	if(!Phone_IsValid(from_phone)) { error = PHONECALL_ERROR_1; return PhoneCall:0; }
	if(Phone_IsOnCall(from_phone) || Phone_IsOnCall(to_phone)) { error = PHONECALL_ERROR_4;	return PhoneCall:0;	}
	if(Phone_GetNumber(from_phone) == Phone_GetNumber(to_phone)) { error = PHONECALL_ERROR_2; return PhoneCall:0; }

    new PhoneCall:this = PhoneCall:vector_create(PHONECALL_DATA_SIZE);

	PhoneCall_SetStatus(this, PHONECALL_STATUS_CONNECTING);
	PhoneCall_SetFrom(this, from_phone);
	PhoneCall_SetTo(this, to_phone);
	PhoneCall_SetToneTimer(this, 0);
	PhoneCall_SetStartedTime(this, 0);

	Phone_SetCurrentCall(from_phone, this);	
	Phone_SetCurrentCall(to_phone, this);

	Phone_DialingTone(from_phone);
	PhoneCall_SetToneTimer(this, SetTimerEx("PhoneCall_Tone", 3000, false, "ii", _:this, 0));

	PhoneCall_OnStarted(from_phone, PhoneCall_GetTo(this));

	return this;
}

PhoneCall_Delete(PhoneCall:this)
{
	if(PhoneCall_IsValid(this))
	{
		Phone_SetCurrentCall(PhoneCall_GetFrom(this), PhoneCall:0);
		Phone_SetCurrentCall(PhoneCall_GetTo(this), PhoneCall:0);
		KillTimer(PhoneCall_GetToneTimer(this));
		vector_clear(_:this);
	}
}

PhoneCall_Unload(PhoneCall:this, PHONE_HANDLE:phone)
{
	PhoneCall_Hang(this, phone);
}

forward PhoneCall_Tone(PhoneCall:this, count);
public PhoneCall_Tone(PhoneCall:this, count)
{
	if(!PhoneCall_IsValid(this))
		return 0;
	if(PhoneCall_GetStatus(this) != PHONECALL_STATUS_CONNECTING)
		return 0;

	new PHONE_HANDLE:from_phone = PhoneCall_GetFrom(this), PHONE_HANDLE:to_phone = PhoneCall_GetTo(this);

	if(count == 0)
	{
		Phone_Tone(from_phone);
		Phone_Ring(to_phone);
		PhoneCall_SetToneTimer(this, SetTimerEx("PhoneCall_Tone", 4500, false, "ii", _:this, count + 1));
		PhoneCall_OnReceived(from_phone, to_phone);
	}
	else if(count < 5)
	{
		Phone_Tone(from_phone);
		Phone_Ring(to_phone);
		PhoneCall_SetToneTimer(this, SetTimerEx("PhoneCall_Tone", 4500, false, "ii", _:this, count + 1));	
	}
	else
	{
		PhoneCall_SetStatus(this, PHONECALL_STATUS_ENDED);
		PhoneCall_OnNotAnswered(from_phone, to_phone);
		PhoneCall_Delete(this);
	}
	return 1;
}

PhoneCall_Answer(PhoneCall:this, PHONE_HANDLE:phone)
{
	if(!PhoneCall_IsValid(this))
		return 0;
	if(PhoneCall_GetStatus(this) != PHONECALL_STATUS_CONNECTING)
		return 0;
	if(PhoneCall_GetTo(this) != phone)
		return 0;

	KillTimer(PhoneCall_GetToneTimer(this));
	PhoneCall_SetStatus(this, PHONECALL_STATUS_ONGOING);
	PhoneCall_SetStartedTime(this, gettime());
	PhoneCall_OnAnswered(PhoneCall_GetFrom(this), PhoneCall_GetTo(this));
	return 1;
}

PhoneCall_NewMessage(PhoneCall:this, PHONE_HANDLE:phone, const message[])
{
	if(!PhoneCall_IsValid(this))
		return 0;
	if(PhoneCall_GetStatus(this) != PHONECALL_STATUS_ONGOING)
		return 0;

	if(PhoneCall_GetFrom(this) == phone) {
		PhoneCall_OnMessageReceived(PhoneCall_GetFrom(this), PhoneCall_GetTo(this), message);
	} else {
		PhoneCall_OnMessageReceived(PhoneCall_GetTo(this), PhoneCall_GetFrom(this), message);
	}
	return 1;
}

stock PhoneCall_Hang(PhoneCall:this, PHONE_HANDLE:phone)
{
	if(!PhoneCall_IsValid(this))
		return 0;

	new PHONE_HANDLE:hanger_phone, PHONE_HANDLE:hanged_phone, startedTime = PhoneCall_GetStartedTime(this);

	if(PhoneCall_GetFrom(this) == phone)
	{
		hanger_phone = PhoneCall_GetFrom(this);
		hanged_phone = PhoneCall_GetTo(this);
	}
	else
	{
		hanger_phone = PhoneCall_GetTo(this);
		hanged_phone = PhoneCall_GetFrom(this);
	}

	PhoneCall_SetStatus(this, PHONECALL_STATUS_ENDED);
	PhoneCall_OnHanged(hanger_phone, hanged_phone, (startedTime) ? (gettime() - startedTime) : (0));
	PhoneCall_Delete(this);
	return 1;
}

PhoneCall_OnStarted(PHONE_HANDLE:from_phone, PHONE_HANDLE:to_phone)
{
	new from_playerid = Phone_GetPlayerid(from_phone);

	if(IsPlayerConnected(from_playerid))
	{
		PlayerActionMessage(from_playerid, 15.0, "toma su tel�fono celular y marca un n�mero.");
		if(!IsPlayerInAnyVehicle(from_playerid) && GetPlayerSpecialAction(from_playerid) == SPECIAL_ACTION_NONE) {
			SetPlayerSpecialAction(from_playerid, SPECIAL_ACTION_USECELLPHONE);
		}
	}
	return (1 || from_phone || to_phone);
}

PhoneCall_OnReceived(PHONE_HANDLE:from_phone, PHONE_HANDLE:to_phone)
{
	new to_playerid = Phone_GetPlayerid(to_phone);

	if(IsPlayerLogged(to_playerid))
	{
		PlayerDoMessage(to_playerid, 15.0, "Un tel�fono est� comenzando a sonar");
		SendClientMessage(to_playerid, COLOR_WHITE, "est�s recibiendo una llamada. Puedes ver el telefono y atenderla usando el comando (/tel)efono.");
	}
	return (1 || from_phone || to_phone);
}

PhoneCall_OnNotAnswered(PHONE_HANDLE:from_phone, PHONE_HANDLE:to_phone)
{
	new from_playerid = Phone_GetPlayerid(from_phone);

	if(IsPlayerLogged(from_playerid))
	{
		SendClientMessage(from_playerid, COLOR_WHITE, "La llamada se ha cortado por exceder el tiempo de espera.");
		if(!IsPlayerInAnyVehicle(from_playerid) && GetPlayerSpecialAction(from_playerid) == SPECIAL_ACTION_USECELLPHONE) {
			SetPlayerSpecialAction(from_playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
		}
	}

	return (1 || from_phone || to_phone);
}

PhoneCall_OnAnswered(PHONE_HANDLE:from_phone, PHONE_HANDLE:to_phone)
{
	new from_playerid = Phone_GetPlayerid(from_phone), to_playerid = Phone_GetPlayerid(to_phone);

	if(IsPlayerLogged(from_playerid)) {
		SendClientMessage(from_playerid, COLOR_WHITE, "Han atendido tu llamada.");
	}

	if(IsPlayerLogged(to_playerid))
	{
		SendClientMessage(to_playerid, COLOR_WHITE, "Has atendido la llamada.");
		if(!IsPlayerInAnyVehicle(to_playerid) && GetPlayerSpecialAction(to_playerid) == SPECIAL_ACTION_NONE) {
			SetPlayerSpecialAction(to_playerid, SPECIAL_ACTION_USECELLPHONE);
		}
	}

	return (1 || from_phone || to_phone);
}

PhoneCall_OnMessageReceived(PHONE_HANDLE:from_phone, PHONE_HANDLE:to_phone, const message[])
{
	new to_playerid = Phone_GetPlayerid(to_phone);

	if(IsPlayerLogged(to_playerid)) {
		new str[180] = "[Voz al tel�fono] dice: ";
		strcat(str, message, sizeof(str));
		SendClientMessage(to_playerid, COLOR_YELLOW2, str);
	}

	return (1 || from_phone || to_phone || message[0]);
}

PhoneCall_OnHanged(PHONE_HANDLE:hanger_phone, PHONE_HANDLE:hanged_phone, call_duration)
{
	new hanger_playerid = Phone_GetPlayerid(hanger_phone), hanged_playerid = Phone_GetPlayerid(hanged_phone);

	if(IsPlayerLogged(hanger_playerid))
	{
		SendClientMessage(hanger_playerid, COLOR_WHITE, "Has colgado la llamada.");
		if(!IsPlayerInAnyVehicle(hanger_playerid) && GetPlayerSpecialAction(hanger_playerid) == SPECIAL_ACTION_USECELLPHONE) {
			SetPlayerSpecialAction(hanger_playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			SetTimerEx("Phone_ClearPlayerState", 2*1000, false, "i", hanger_playerid);
		}
	}

	if(IsPlayerLogged(hanged_playerid))
	{
		SendClientMessage(hanged_playerid, COLOR_WHITE, "Han colgado la llamada.");
		if(!IsPlayerInAnyVehicle(hanged_playerid) && GetPlayerSpecialAction(hanged_playerid) == SPECIAL_ACTION_USECELLPHONE) {
			SetPlayerSpecialAction(hanged_playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			SetTimerEx("Phone_ClearPlayerState", 2*1000, false, "i", hanged_playerid);
		}
	}

	return (1 || hanger_phone || hanged_phone || call_duration);
}

Phone_PlayerCallNumber(playerid, number)
{
	if(number == 911)
	{
		Dialog_Show(playerid, DLG_CALL_911, DIALOG_STYLE_LIST, "[911] Operadora: Que servicio solicita?", "Policia / Gendarmeria Nacional Argentina\nParamedico", "Continuar", "Cerrar");
		return 1;
	}
	
	new error;

	if(!PhoneCall_New(Phone_id[playerid], number, error)) {
		SendClientMessage(playerid, COLOR_YELLOW2, PhoneCall_GetError(error));
	}
	return 1;
}

forward Phone_ClearPlayerState(playerid);
public Phone_ClearPlayerState(playerid) {
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_STOPUSECELLPHONE) {
		return SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	return 0;
}
