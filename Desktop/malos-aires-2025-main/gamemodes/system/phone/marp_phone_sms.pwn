#if defined _marp_phone_sms_included
	#endinput
#endif
#define _marp_phone_sms_included

#define PHONESMS_MAX_LENGTH 130

PhoneSMS_Send(PHONE_HANDLE:phone, to_number, const message[])
{
	if(isnull(message))
		return 0;

	new String:string = str_new(message);
	str_acquire(string);

	SetTimerEx("PhoneSMS_Redirect", 1000, false, "iii", _:phone, to_number, _:string);
	OnSMSSent(PHONE_HANDLE:phone, to_number, message);
	return 1;
}

forward PhoneSMS_Redirect(PHONE_HANDLE:from_phone, to_number, String:string);
public PhoneSMS_Redirect(PHONE_HANDLE:from_phone, to_number, String:string)
{
	new PHONE_HANDLE:to_phone = Phone_GetNumberHandle(to_number);

	if(to_phone)
	{
		new message[PHONESMS_MAX_LENGTH];
		str_get(string, message);
		PhoneSMS_Receive(to_phone, Phone_GetNumber(from_phone), message);
	}
	else
	{
		if(!Phone_IsValidPersonalNumber(to_number))
		{
			new str[80];
			format(str, sizeof(str), "Error al enviar el mensaje. El numero %i es inexistente.", to_number);
			PhoneSMS_Receive(from_phone, 111, str);
		}
	}

	str_release(string);
	return 1;
}

PhoneSMS_Receive(PHONE_HANDLE:phone, from_number, message[])
{
	new sms_vec = Phone_GetSMSVector(phone);

	vector_push_back(sms_vec, from_number);
	vector_push_back_arr(sms_vec, message);

	OnSMSReceived(phone, from_number);
}

OnSMSReceived(PHONE_HANDLE:phone, from_number)
{
	new playerid = Phone_GetPlayerid(phone);

	if(playerid != INVALID_PLAYER_ID) {
		Noti_Create(playerid, .time = 4000, .text = "Has recibido un nuevo mensaje en tu teléfono");
	}

	return (1 || from_number);
}

PhoneSMS_GetCount(PHONE_HANDLE:phone) {
	return (vector_size(Phone_GetSMSVector(phone)) / 2);
}

PhoneSMS_GetFirst(PHONE_HANDLE:phone, &from_number, message[])
{
	new sms_vec = Phone_GetSMSVector(phone);

	if(vector_size(sms_vec) < 2)
		return 0;

	from_number = vector_get(sms_vec, 0);
	vector_get_arr(sms_vec, 1, message, PHONESMS_MAX_LENGTH);
	vector_remove(sms_vec, 1);
	vector_remove(sms_vec, 0);
	return 1;
}