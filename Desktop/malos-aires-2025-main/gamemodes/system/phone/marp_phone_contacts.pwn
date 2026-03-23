#if defined _marp_phone_contacts_included
	#endinput
#endif
#define _marp_phone_contacts_included

#define PHONECONTACTS_MAX_NAME_LENGTH 32

PhoneContacts_Load(PHONE_HANDLE:phone) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "PhoneContacts_OnDataLoad", "i", _:phone @Format: "SELECT * FROM `phone_contacts` WHERE `phone`=%i ORDER BY `name` ASC;", Phone_GetNumber(phone));
}

forward PhoneContacts_OnDataLoad(PHONE_HANDLE:phone);
public PhoneContacts_OnDataLoad(PHONE_HANDLE:phone)
{
	new rows = cache_num_rows(), number, name[PHONECONTACTS_MAX_NAME_LENGTH], vecid = Phone_GetContactsVector(phone);

	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name_int(i, "number", number);
		cache_get_value_name(i, "name", name, PHONECONTACTS_MAX_NAME_LENGTH);
		vector_push_back(vecid, number);
		vector_push_back_arr(vecid, name);
	}
	return 1;
}

PhoneContacts_SQLDeleteAll(PHONE_HANDLE:phone) {
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "DELETE FROM `phone_contacts` WHERE `phone`=%i;", Phone_GetNumber(phone));
}

PhoneContacts_New(PHONE_HANDLE:phone, number, name[])
{
	new vecid = Phone_GetContactsVector(phone);

	vector_push_back(vecid, number);
	vector_push_back_arr(vecid, name);

	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "INSERT INTO `phone_contacts` (`phone`, `name`, `number`) VALUES (%i, '%e', %i)", Phone_GetNumber(phone), name, number);
}

PhoneContacts_IsValidPos(PHONE_HANDLE:phone, pos) {
	return (vector_size(Phone_GetContactsVector(phone)) > pos * 2 + 1);
}

PhoneContacts_DeletePos(PHONE_HANDLE:phone, pos)
{
	if(PhoneContacts_IsValidPos(phone, pos))
	{
		new vecid = Phone_GetContactsVector(phone);

		mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "DELETE FROM `phone_contacts` WHERE `phone`=%i AND `number`=%i", Phone_GetNumber(phone), vector_get(vecid, pos * 2));

		vector_remove(vecid, pos * 2 + 1);
		vector_remove(vecid, pos * 2);
		return 1;
	}
	return 0;
}

PhoneContacts_GetCount(PHONE_HANDLE:phone) {
	return (vector_size(Phone_GetContactsVector(phone)) / 2);
}

PhoneContacts_GetPosName(PHONE_HANDLE:phone, pos, name[]) {
	if(PhoneContacts_IsValidPos(phone, pos)) {
		vector_get_arr(Phone_GetContactsVector(phone), pos * 2 + 1, name, PHONECONTACTS_MAX_NAME_LENGTH);
		return 1;
	}
	return 0;
}

PhoneContacts_GetPosNumber(PHONE_HANDLE:phone, pos) {
	if(PhoneContacts_IsValidPos(phone, pos)) {
		return vector_get(Phone_GetContactsVector(phone), pos * 2);
	}
	return 0;
}

PhoneContacts_GetNumberName(PHONE_HANDLE:phone, number, name[])
{
	new vecid = Phone_GetContactsVector(phone);
	new idx = vector_find(vecid, number);

	if(idx != -1) {
		vector_get_arr(vecid, idx+1, name, PHONECONTACTS_MAX_NAME_LENGTH);
		return 1;
	} else {
		valstr(name, number);
		return 0;
	}
}