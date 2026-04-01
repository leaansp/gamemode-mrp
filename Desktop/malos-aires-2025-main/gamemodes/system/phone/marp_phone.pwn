#if defined _marp_cellphone_included
	#endinput
#endif
#define _marp_cellphone_included

#include <YSI_Coding\y_hooks>

/* Entorno marker duration for responders */
#define ENTORNO_MARKER_MS 120000
#define ENTORNO_COOLDOWN_MS 60000

new gEntornoCooldown[MAX_PLAYERS];
new gEntornoTempMsg[MAX_PLAYERS][256];

static const gEntornoFrases[][] = {
    "Un vecino que miraba por la ventana se rescato y te vio, marco el numero de la policia enseguida.\nA distancia lo percibiste bastante alborotado, era un hombre mayor con anteojos que gesticulaba nervioso.",
    "Una senora que barria la entrada de su casa levanto la vista en el momento menos indicado.\nTe miro fijo unos segundos, entro rapido y cerro la puerta. Al rato se la vio asomarse con el telefono en la mano.",
    "Un pibe en moto que esperaba el semaforo vio toda la escena.\nBajo un pie al piso, saco el celu del camperon y estuvo un buen rato hablando. No arranco hasta que termino la llamada.",
    "Desde el primer piso de un edificio cercano se escucho una voz de mujer gritando pidiendo calma.\nUnos minutos despues el portero electrico empezo a sonar repetidamente, como coordinando algo adentro.",
    "Un pibe de unos quince de edad que andaba en bici por la vereda freno de golpe al ver lo que pasaba.\nSe bajo, miro para todos lados y salio pedaleando rapido en direccion contraria. Fue a buscar a alguien.",
    "El encargado de un local que estaba acomodando la vidriera salio a la puerta con cara de pocos amigos.\nObservo la situacion en silencio, volvio adentro y al rato se lo vio hablando por telefono.",
    "Un delivery en bici que venia doblando la esquina freno en seco cuando vio el panorama.\nBajo de la bici, saco el telefono y estuvo mirando la situacion mientras hablaba. Se fue sin hacer la entrega.",
    "Desde adentro de un kiosco, el encargado observaba todo detras del vidrio sin moverse.\nCuando cruzaste la mirada con el, bajo la persiana a la mitad. Se lo vio marcando algo en el telefono del mostrador.",
    "Una pareja que caminaba por la vereda de enfrente se detuvo al notar la situacion.\nUno le dijo algo al oido al otro, y la chica saco el telefono mientras el se alejaba unos pasos para darle privacidad.",
    "Un taxista estacionado en la parada de la esquina tuvo una vista privilegiada de todo.\nBajo la ventanilla, miro con atencion y agarro la radio del auto para hablar en voz baja.",
    "Un tipo que paseaba al perro se quedo paralizado, el animal empezo a ladrar fuerte.\nEl hombre lo calmo, enrollo la correa y camino decidido hasta el primer negocio abierto. No volvio a salir.",
    "Desde una ventana del segundo piso alguien grababa con el celular sin intentar ocultarse.\nCuando se dio cuenta que lo habian visto cerro la ventana, pero la silueta seguia visible con el telefono en alto.",
    "Un hombre que tomaba mate en la puerta de su casa vio todo desde el principio.\nSe quedo quieto un momento, le dijo algo a alguien adentro y al poco rato salio una mujer con el telefono ya marcando.",
    "Una chica que esperaba el colectivo en la parada se pego a la pared cuando noto lo que pasaba.\nAgarro fuerte la mochila, saco el telefono con movimientos rapidos y estuvo mirando la escena durante toda la llamada.",
    "Un grupo de pibes sentado en el cordon de la vereda se levanto de golpe al escuchar el ruido.\nUno saco el celu y los otros dos se alejaron caminando rapido sin mirar para atras.",
    "Un hombre que venia cargando bolsas del super dejo todo en el piso cuando vio la situacion.\nSaco el telefono, miro la pantalla unos segundos como dudando, y finalmente marco.",
    "Una mujer que lavaba el auto en la vereda de enfrente paro la manguera y se quedo mirando fijo.\nCuando proceso lo que pasaba, tiro la esponja al balde y entro rapido gritandole algo a alguien adentro.",
    "Dos chicas que salian de una peluqueria cercana se detuvieron en la vereda de golpe.\nUna le agarro el brazo a la otra, nego con la cabeza queriendo irse, pero la otra ya estaba marcando el numero.",
    "Desde adentro de un auto estacionado se veia una silueta que observaba todo sin moverse.\nCuando la situacion escalo se escucho el tono de una llamada desde adentro. Las balizas se prendieron un segundo.",
    "Un repartidor que descargaba cajas de una camioneta se paro en seco al escuchar el alboroto.\nSe asomo despacio por el costado, evaluo la situacion y saco el celu semiescondido detras de la carga.",
    "Una chica que andaba con auriculares se saco uno cuando noto que algo pasaba.\nBajo el volumen, miro la situacion unos segundos y se alejo rapido escribiendo algo en el telefono."
};
OnSMSSent(PHONE_HANDLE:phone, to_number, const message[])
{
	new fromPlayerid = Phone_GetPlayerid(phone);

	if(fromPlayerid != INVALID_PLAYER_ID)
	{
		new str[180];
		format(str, sizeof(str), "[SMS] %s (ID %i) a número %i: %s", GetPlayerCleanName(fromPlayerid), fromPlayerid, to_number, message);
		foreach(new i : Player)
		{
			if(AdminSMSEnabled[i]) {
				SendClientMessage(i, COLOR_ADMINREAD, str);
			}
		}
	}
	return 1;
}

CMD:llamar(playerid, params[])
{
	new number;

	if(GetHandItem(playerid, HAND_RIGHT) != ITEM_ID_TELEFONO_CELULAR && GetHandItem(playerid, HAND_LEFT) != ITEM_ID_TELEFONO_CELULAR)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No tienes un teléfono celular en tu mano!");
    if(sscanf(params, "i", number))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/llamar [número de teléfono]");

	Phone_PlayerCallNumber(playerid, number);
	return 1;
}

CMD:tel(playerid, params[]) {
	return cmd_telefono(playerid, params);
}

CMD:telefono(playerid, params[])
{
	if(!PlayerInfo[playerid][pPhoneNumber])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No tienes un teléfono celular! consigue uno en un 24/7.");

	new hand = SearchHandsForItem(playerid, ITEM_ID_TELEFONO_CELULAR);
	if(hand != -1 )
	{
		if(Phone_IsOnCall(Phone_id[playerid])) {
			return SendClientMessage(playerid, COLOR_YELLOW2, "estás en una llamada en curso, cuelga primero con /colgar.");
		}
		PlayerActionMessage(playerid, 15.0, "guarda su teléfono celular en el bolsillo.");
		SetHandItemAndParam(playerid, hand, 0, 0);
		PhoneGUI_Close(playerid);
		return 1;
	}

	hand = SearchFreeHand(playerid);
	if(hand == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Tienes ambas manos ocupadas!");

	PlayerActionMessage(playerid, 15.0, "toma su teléfono celular del bolsillo.");
	SendClientMessage(playerid, -1, "Usa /tel para guardarlo y /t para hablar en una llamada. Usa ESC o click en (X) para poder moverte. Con 'N' reestableces el foco.");
	SetHandItemAndParam(playerid, hand, ITEM_ID_TELEFONO_CELULAR, 1);
	PhoneGUI_Open(playerid);
	return 1;
}

Dialog:DLG_CALL_911(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;

	switch(listitem)
	{
		case 0:
		{
			new string[80];
			format(string, sizeof(string), "[Al teléfono] %s dice: hola, con la policía por favor.", GetPlayerChatName(playerid));
			SendPlayerMessageInRange(15.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
			Dialog_Show(playerid, DLG_CALL_911_POLICE, DIALOG_STYLE_INPUT, "[911] Policía Federal", "Operadora: Policía Federal, por favor de un breve informe de lo ocurrido.", "Continuar", "Cerrar"); 
		}
		case 1:
		{
			new string[80];
			format(string, sizeof(string), "[Al teléfono] %s dice: hola, con emergencias médicas por favor.", GetPlayerChatName(playerid));
			SendPlayerMessageInRange(15.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
			Dialog_Show(playerid, DLG_CALL_911_PARAMEDIC, DIALOG_STYLE_INPUT, "[911] Servicios médicos de Emergencia", "Operadora: departamento de emergencias médicas, por favor de un breve informe de lo ocurrido.", "Continuar", "Cerrar");
		}
	}
	return 1;
}

Dialog:DLG_CALL_911_POLICE(playerid, response, listitem, inputtext[])
{
	if(!response || isnull(inputtext))
		return 1;

	new string[180];
	format(string, sizeof(string), "[Al teléfono] %s dice: %s", GetPlayerChatName(playerid), inputtext);
	SendPlayerMessageInRange(15.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);

	Dialog_Show(playerid, DLG_CALL_911_END, DIALOG_STYLE_MSGBOX, "[911] Policía", "Operadora dice: gracias, hemos alertado a todas las unidades, mantenga la calma y espere en el lugar.", "Cerrar", "");
	
	format(string, sizeof(string), "[Llamada al 911 del %i] %s", PlayerInfo[playerid][pPhoneNumber], inputtext);
	SendFactionRadioMessage(FAC_PMA, COLOR_PMA, string);
	SendFactionRadioMessage(FAC_SIDE, COLOR_PMA, string);

	format(string, sizeof(string), "[911 - POLICÍA del ID %i] %s", playerid, inputtext);
	foreach(new i : Player) {
		if(Admin911Enabled[i] && i != playerid && PlayerInfo[i][pFaction] != FAC_PMA && PlayerInfo[i][pFaction] != FAC_SIDE) {
			SendClientMessage(i, COLOR_ADMINREAD, string);
		}
	}

	lastPoliceCallNumber = PlayerInfo[playerid][pPhoneNumber];
	
	new houseId = House_IsPlayerInAny(playerid);
	new bizId = Biz_IsPlayerInsideAny(playerid);
	new bldId = Bld_IsPlayerInsideAny(playerid);
	
	if(houseId)
	{
		House_GetOutDoorPos(houseId, lastPoliceCallPos[0], lastPoliceCallPos[1], lastPoliceCallPos[2]);
	}
	else if(bizId)
	{
		Biz_GetOutDoorPos(bizId, lastPoliceCallPos[0], lastPoliceCallPos[1], lastPoliceCallPos[2]);
	}
	else if(bldId)
	{
		Bld_GetOutDoorPos(bldId, lastPoliceCallPos[0], lastPoliceCallPos[1], lastPoliceCallPos[2]);
	}
	else
	{
		PlayerPos_GetExteriorPos(playerid, lastPoliceCallPos[0], lastPoliceCallPos[1], lastPoliceCallPos[2]);
	}
	
	return 1;
}

Dialog:DLG_CALL_911_PARAMEDIC(playerid, response, listitem, inputtext[])
{
	if(!response || isnull(inputtext))
		return 1;

	new string[180];
	format(string, sizeof(string), "[Al teléfono] %s dice: %s", GetPlayerChatName(playerid), inputtext);
	SendPlayerMessageInRange(15.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);

	Dialog_Show(playerid, DLG_CALL_911_END, DIALOG_STYLE_MSGBOX, "[911] Servicio de Atención Médica de Emergencia", "Operadora dice: gracias, hemos alertado a todas las unidades, mantenga la calma y espere en el lugar.", "Cerrar", ""); 
	
	format(string, sizeof(string), "[Llamada al 911 del %i] %s", PlayerInfo[playerid][pPhoneNumber], inputtext);
	SendFactionRadioMessage(FAC_HOSP, COLOR_PMA, string);

	format(string, sizeof(string), "[911 - SAME del ID %i] %s", playerid, inputtext);
	foreach(new i : Player) {
		if(Admin911Enabled[i] && i != playerid && PlayerInfo[i][pFaction] != FAC_HOSP) {
			SendClientMessage(i, COLOR_ADMINREAD, string);
		}
	}

	lastMedicCallNumber = PlayerInfo[playerid][pPhoneNumber];
	
	new houseId = House_IsPlayerInAny(playerid);
	new bizId = Biz_IsPlayerInsideAny(playerid);
	new bldId = Bld_IsPlayerInsideAny(playerid);
	
	if(houseId)
	{
		House_GetOutDoorPos(houseId, lastMedicCallPos[0], lastMedicCallPos[1], lastMedicCallPos[2]);
	}
	else if(bizId)
	{
		Biz_GetOutDoorPos(bizId, lastMedicCallPos[0], lastMedicCallPos[1], lastMedicCallPos[2]);
	}
	else if(bldId)
	{
		Bld_GetOutDoorPos(bldId, lastMedicCallPos[0], lastMedicCallPos[1], lastMedicCallPos[2]);
	}
	else
	{
		PlayerPos_GetExteriorPos(playerid, lastMedicCallPos[0], lastMedicCallPos[1], lastMedicCallPos[2]);
	}
	
	return 1;
}

CMD:atender(playerid, params[])
{
	if(GetHandItem(playerid, HAND_RIGHT) != ITEM_ID_TELEFONO_CELULAR && GetHandItem(playerid, HAND_LEFT) != ITEM_ID_TELEFONO_CELULAR)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No tienes un teléfono celular en tu mano!");

	if(Phone_IsOnCall(Phone_id[playerid])) {
		PhoneCall_Answer(Phone_GetCurrentCall(Phone_id[playerid]), Phone_id[playerid]);
	}
	return 1;
}

CMD:t(playerid, params[])
{
	if(GetHandItem(playerid, HAND_RIGHT) != ITEM_ID_TELEFONO_CELULAR && GetHandItem(playerid, HAND_LEFT) != ITEM_ID_TELEFONO_CELULAR)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No tienes un teléfono celular en tu mano!");

	if(Phone_IsOnCall(Phone_id[playerid])) {
		new string[180];
		format(string, sizeof(string), "[Al teléfono] %s dice: %s", GetPlayerChatName(playerid), params);
		SendPlayerMessageInRange(15.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
		PhoneCall_NewMessage(Phone_GetCurrentCall(Phone_id[playerid]), Phone_id[playerid], params);
	}
	return 1;
}

CMD:colgar(playerid, params[])
{
	if(GetHandItem(playerid, HAND_RIGHT) != ITEM_ID_TELEFONO_CELULAR && GetHandItem(playerid, HAND_LEFT) != ITEM_ID_TELEFONO_CELULAR)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No tienes un teléfono celular en tu mano!");

	if(Phone_IsOnCall(Phone_id[playerid])) {
		PhoneCall_Hang(Phone_GetCurrentCall(Phone_id[playerid]), Phone_id[playerid]);
	}
	return 1;
}

CMD:entorno(playerid, params[])
{
	if(isnull(params) || strlen(params) == 0)
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/entorno <mensaje breve>");

	new now = GetTickCount();
	if(gEntornoCooldown[playerid] && now < gEntornoCooldown[playerid]) {
		new rem = (gEntornoCooldown[playerid] - now + 999) / 1000;
		new tmp[64];
		format(tmp, sizeof tmp, "Espera %d segundos para usar /entorno de nuevo.", rem);
		return SendClientMessage(playerid, COLOR_YELLOW2, tmp);
	}
	/* store message and show selection dialog (0=Policía, 1=SAME) */
	format(gEntornoTempMsg[playerid], 256, "%s", params);
	Dialog_Show(playerid, DLG_ENTORNO_SELECT, DIALOG_STYLE_LIST, "[Entorno] A quien llamas?", "Policia / Gendarmeria Nacional Argentina\nSAME", "Enviar", "Cerrar");
	return 1;
}

Dialog:DLG_ENTORNO_SELECT(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;

	if(isnull(gEntornoTempMsg[playerid]) || strlen(gEntornoTempMsg[playerid]) == 0)
		return SendClientMessage(playerid, COLOR_YELLOW2, "Mensaje inválido.");

	new target = listitem; // 0 = Policía, 1 = SAME

	new fmsg[256];
	format(fmsg, sizeof fmsg, "[LLAMADO AL 911] %s", gEntornoTempMsg[playerid]);

	if(target == 0) {
		SendFactionRadioMessage(FAC_PMA, COLOR_PMA, fmsg);
		SendFactionRadioMessage(FAC_SIDE, COLOR_PMA, fmsg);
	} else {
		SendFactionRadioMessage(FAC_HOSP, COLOR_PMA, fmsg);
	}

	new admPol[256]; format(admPol, sizeof admPol, "[911 - POLICÍA] %s", gEntornoTempMsg[playerid]);
	new admMed[256]; format(admMed, sizeof admMed, "[911 - SAME] %s", gEntornoTempMsg[playerid]);
	foreach(new i : Player) {
		if(Admin911Enabled[i] && i != playerid && PlayerInfo[i][pFaction] != FAC_PMA)
			SendClientMessage(i, COLOR_ADMINREAD, admPol);
		if(Admin911Enabled[i] && i != playerid && PlayerInfo[i][pFaction] != FAC_HOSP)
			SendClientMessage(i, COLOR_ADMINREAD, admMed);
	}

	new localStr[256];
	format(localStr, sizeof localStr, "[Entorno] %s", gEntornoTempMsg[playerid]);
	SendPlayerMessageInRange(15.0, playerid, localStr, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);

	new Float:x, Float:y, Float:z;
	
	new houseId = House_IsPlayerInAny(playerid);
	new bizId = Biz_IsPlayerInsideAny(playerid);
	new bldId = Bld_IsPlayerInsideAny(playerid);
	
	if(houseId)
	{
		House_GetOutDoorPos(houseId, x, y, z);
		if(target == 0) {
			lastPoliceCallPos[0] = x;
			lastPoliceCallPos[1] = y;
			lastPoliceCallPos[2] = z;
			lastPoliceCallNumber = PlayerInfo[playerid][pPhoneNumber];
		} else {
			lastMedicCallPos[0] = x;
			lastMedicCallPos[1] = y;
			lastMedicCallPos[2] = z;
			lastMedicCallNumber = PlayerInfo[playerid][pPhoneNumber];
		}
	}
	else if(bizId)
	{
		Biz_GetOutDoorPos(bizId, x, y, z);
		if(target == 0) {
			lastPoliceCallPos[0] = x;
			lastPoliceCallPos[1] = y;
			lastPoliceCallPos[2] = z;
			lastPoliceCallNumber = PlayerInfo[playerid][pPhoneNumber];
		} else {
			lastMedicCallPos[0] = x;
			lastMedicCallPos[1] = y;
			lastMedicCallPos[2] = z;
			lastMedicCallNumber = PlayerInfo[playerid][pPhoneNumber];
		}
	}
	else if(bldId)
	{
		Bld_GetOutDoorPos(bldId, x, y, z);
		if(target == 0) {
			lastPoliceCallPos[0] = x;
			lastPoliceCallPos[1] = y;
			lastPoliceCallPos[2] = z;
			lastPoliceCallNumber = PlayerInfo[playerid][pPhoneNumber];
		} else {
			lastMedicCallPos[0] = x;
			lastMedicCallPos[1] = y;
			lastMedicCallPos[2] = z;
			lastMedicCallNumber = PlayerInfo[playerid][pPhoneNumber];
		}
	}
	else
	{
		PlayerPos_GetExteriorPos(playerid, x, y, z);
	}
	
	foreach(new i : Player) {
		if(PlayerInfo[i][pFaction] == FAC_PMA || PlayerInfo[i][pFaction] == FAC_HOSP || PlayerInfo[i][pFaction] == FAC_SIDE) {
			MapMarker_CreateForPlayer(i, x, y, z, .color = COLOR_RED, .time = ENTORNO_MARKER_MS);
		}
	}

	/* set cooldown */
	gEntornoCooldown[playerid] = GetTickCount() + ENTORNO_COOLDOWN_MS;

	new frase[256], splitPos;
	format(frase, sizeof frase, "%s", gEntornoFrases[random(sizeof(gEntornoFrases))]);
	splitPos = strfind(frase, "\n");
	if(splitPos != -1) {
		new linea1[128], linea2[128];
		strmid(linea1, frase, 0, splitPos, sizeof linea1);
		strmid(linea2, frase, splitPos + 1, strlen(frase), sizeof linea2);
		SendClientMessage(playerid, COLOR_YELLOW2, linea1);
		SendClientMessage(playerid, COLOR_YELLOW2, linea2);
	} else {
		SendClientMessage(playerid, COLOR_YELLOW2, frase);
	}
	SendClientMessage(playerid, COLOR_YELLOW2, "Aviso enviado. Las unidades han sido notificadas y marcadas en su mapa.");
	gEntornoTempMsg[playerid][0] = '\0';
	return 1;
}
