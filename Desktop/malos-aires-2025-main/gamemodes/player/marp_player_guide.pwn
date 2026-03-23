#if defined marp_player_guide_inc
	#endinput
#endif
#define marp_player_guide_inc

CMD:gps(playerid, params[]) {
	return Guide_Show(playerid);
}

CMD:guia(playerid, params[]) {
	return Guide_Show(playerid);
}

Guide_Show(playerid)
{
	Dialog_Show(playerid, DLG_GUIDE, DIALOG_STYLE_LIST,
		"Guía de Malos Aires",
		"Servicios\n\
		Empleos\n\
		Negocios\n\
		Licencias\n\
		Concesionarias\n\
		Otras ubicaciones",
		"Ver",
		"Cerrar"
	);

	return 1;
}

Dialog:DLG_GUIDE(playerid, response, listitem, inputtext[])
{
	if(!response)
		return 1;

	switch(listitem)
	{
		case 0: Guide_ShowServices(playerid);
		case 1: Guide_ShowJobs(playerid);
		case 2: Guide_ShowBusiness(playerid);
		case 3: Guide_ShowLicenses(playerid);
		case 4: Guide_ShowDealerships(playerid);
		case 5: Guide_ShowOthers(playerid);
	}
	return 1;
}

Guide_ShowServices(playerid)
{
	Dialog_Show(playerid, DLG_GUIDE_SERVICES, DIALOG_STYLE_LIST,
		"Servicios de Malos Aires",
		"Comisaría de la Policía de Malos Aires\n\
		Hospital central del SAME de Malos Aires\n\
		Hospital Secundario del SAME de Malos Aires\n\
		Gobierno de la ciudad de Malos Aires\n\
		Taller mecánico Mercury\n\
		Central de noticias ACEMA\n\
		Banco de Malos Aires",
		"Ver",
		"Volver"
	);
	
	return 1;
}

Dialog:DLG_GUIDE_SERVICES(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Guide_Show(playerid);

	new color = RandomRGBAColor();

	switch(listitem)
	{
		case 0:	MapMarker_CreateForPlayer(playerid, 1289.2552, -1649.1729, 13.5469, .color = COLOR_RED, .time = 120000);
		case 1:	MapMarker_CreateForPlayer(playerid, 1172.6315, -1323.5652, 15.4074, .color = COLOR_RED, .time = 120000);
		case 2:	MapMarker_CreateForPlayer(playerid, 2034.9326, -1405.1610, 17.2486, .color = COLOR_RED, .time = 120000);
		case 3: MapMarker_CreateForPlayer(playerid, 1481.1024, -1769.9182, 13.6017, .color = COLOR_RED, .time = 120000);
		case 4:	MapMarker_CreateForPlayer(playerid, 2503.1433, -1512.8932, 24.0308, .color = COLOR_RED, .time = 120000);
		case 5:	MapMarker_CreateForPlayer(playerid, 777.9178, -1328.5731, 13.5099, .color = COLOR_RED, .time = 120000);
		case 6:	MapMarker_CreateForPlayer(playerid, 1470.0452, -1176.6420, 23.9052, .color = COLOR_RED, .time = 120000);
		default: return true;

	}

	Noti_Create(playerid, .time = 3000, .text = "La localización elegida se marcará en el mapa durante 2 minutos", .backgroundColor = color);
	return 1;
}

Guide_ShowJobs(playerid)
{
	Dialog_Show(playerid, DLG_GUIDE_JOBS, DIALOG_STYLE_LIST,
		"Empleos en Malos Aires",
		"Camionero urbano\n\
		Granjero\n\
		Basurero\n\
		Moto delivery\n\
		Taxista\n\
		Colectivero\n\
		Electricista",
		"Ver",
		"Volver"
	);
	
	return 1;
}

Dialog:DLG_GUIDE_JOBS(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Guide_Show(playerid);

	new color = RandomRGBAColor();

	switch(listitem)
	{
		case 0:	MapMarker_CreateForPlayer(playerid, JobInfo[JOB_TRAN][jTakeX], JobInfo[JOB_TRAN][jTakeY], JobInfo[JOB_TRAN][jTakeZ], .color = color, .time = 120000);
		case 1:	MapMarker_CreateForPlayer(playerid, JobInfo[JOB_FARM][jTakeX], JobInfo[JOB_FARM][jTakeY], JobInfo[JOB_FARM][jTakeZ], .color = color, .time = 120000);
		case 2:	MapMarker_CreateForPlayer(playerid, JobInfo[JOB_GARB][jTakeX], JobInfo[JOB_GARB][jTakeY], JobInfo[JOB_GARB][jTakeZ], .color = color, .time = 120000);
		case 3: MapMarker_CreateForPlayer(playerid, JobInfo[JOB_DELI][jTakeX], JobInfo[JOB_DELI][jTakeY], JobInfo[JOB_DELI][jTakeZ], .color = color, .time = 120000);
		case 4:	MapMarker_CreateForPlayer(playerid, JobInfo[JOB_TAXI][jTakeX], JobInfo[JOB_TAXI][jTakeY], JobInfo[JOB_TAXI][jTakeZ], .color = color, .time = 120000);
		case 5:	MapMarker_CreateForPlayer(playerid, JobInfo[JOB_BUS][jTakeX], JobInfo[JOB_BUS][jTakeY], JobInfo[JOB_BUS][jTakeZ], .color = COLOR_RED, .time = 120000);
		case 6:	MapMarker_CreateForPlayer(playerid, JobInfo[JOB_ELEC][jTakeX], JobInfo[JOB_ELEC][jTakeY], JobInfo[JOB_ELEC][jTakeZ], .color = COLOR_RED, .time = 120000);
		default: return 1;
	}

	Noti_Create(playerid, .time = 3000, .text = "La localización elegida se marcará en el mapa durante 2 minutos", .backgroundColor = color);
	return 1;
}

Guide_ShowBusiness(playerid)
{
	new string[512];

	for(new type = 1, line[64]; type < BIZ_TYPES_AMOUNT; type++)
	{
		format(line, sizeof(line), "Negocio tipo %s\n", Biz_GetTypeName(type));
		strcat(string, line, sizeof(string));
	}

	Dialog_Show(playerid, DLG_GUIDE_BUSINESS, DIALOG_STYLE_LIST, "Negocios en Malos Aires",	string,	"Ver", "Volver");	
	return 1;
}

Dialog:DLG_GUIDE_BUSINESS(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Guide_Show(playerid);
	if(!(1 <= (listitem + 1) <= BIZ_TYPES_AMOUNT))
		return 0;

	new color = RandomRGBAColor();
	new bizid = Biz_GetRandomIdByType(listitem + 1);

	if(!bizid)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay ningun negocio de ese tipo en la ciudad por el momento.");
		return Guide_Show(playerid);
	}

	MapMarker_CreateForPlayer(playerid, Business[bizid][bOutsideX], Business[bizid][bOutsideY], Business[bizid][bOutsideZ], .color = color, .time = 120000);
	Noti_Create(playerid, .time = 3000, .text = "La localización elegida se marcará en el mapa durante 2 minutos", .backgroundColor = color);
	return 1;
}

Guide_ShowLicenses(playerid)
{
	Dialog_Show(playerid, DLG_GUIDE_LICENSES, DIALOG_STYLE_LIST,
		"Licencias de Malos Aires",
		"Centro de licencias de transporte de Malos Aires\n\
		Centro de licencias de armas de la policía de la ciudad de Malos Aires",
		"Ver",
		"Volver"
	);	
	
	return 1;
}

Dialog:DLG_GUIDE_LICENSES(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Guide_Show(playerid);

	new color = RandomRGBAColor();

	switch(listitem)
	{
		case 0:	MapMarker_CreateForPlayer(playerid, 2768.92, -1449.37, 31.05, .color = COLOR_RED, .time = 120000);
		case 1: MapMarker_CreateForPlayer(playerid, 1554.0016, -1675.6106, 16.1710, .color = COLOR_RED, .time = 120000);
		default: return 1;
	}

	Noti_Create(playerid, .time = 3000, .text = "La localización elegida se marcará en el mapa durante 2 minutos", .backgroundColor = color);
	return 1;
}

Guide_ShowDealerships(playerid)
{
	Dialog_Show(playerid, DLG_GUIDE_DEALERSHIPS, DIALOG_STYLE_LIST,
		"Concesionarias en Malos Aires",
		"Concesionarios Bracone\n\
		Autos Valadares\n\
		Pinar Automotores\n\
		Concesionaria Ciudad Moto\n\
		Freddi Aviones\n\
		Nautica Gabott\n\
		Scania",
		"Ver",
		"Volver"
	);
	
	return 1;
}

Dialog:DLG_GUIDE_DEALERSHIPS(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Guide_Show(playerid);

	new color = RandomRGBAColor();

	switch(listitem)
	{
		case 0:	MapMarker_CreateForPlayer(playerid, 542.61, -1298.90, 17.24, .color = COLOR_RED, .time = 120000);
		case 1:	MapMarker_CreateForPlayer(playerid, 2131.77, -1150.91, 24.02, .color = COLOR_RED, .time = 120000);
		case 2:	MapMarker_CreateForPlayer(playerid, 986.23, -1116.85, 27.28, .color = COLOR_RED, .time = 120000);
		case 3: MapMarker_CreateForPlayer(playerid, 1300.74, -1875.69, 13.55, .color = COLOR_RED, .time = 120000);
		case 4:	MapMarker_CreateForPlayer(playerid, 1921.14, -2235.02, 13.54, .color = COLOR_RED, .time = 120000);
		case 5:	MapMarker_CreateForPlayer(playerid, 2939.37, -2051.45, 3.54, .color = COLOR_RED, .time = 120000);
		case 6:	MapMarker_CreateForPlayer(playerid, 2248.24, -2185.43, 13.57, .color = COLOR_RED, .time = 120000);
		default: return 1;
	}

	Noti_Create(playerid, .time = 3000, .text = "La localización elegida se marcará en el mapa durante 2 minutos", .backgroundColor = color);
	return 1;
}

Guide_ShowOthers(playerid)
{
	Dialog_Show(playerid, DLG_GUIDE_OTHER, DIALOG_STYLE_LIST,
		"Otras ubicaciones de Malos Aires",
		"Gimnasio\n\
		Shopping\n\
		Renta de bicicletas\n\
		Carcel de Malos Aires",
		"Ver",
		"Volver"
	);
	
	return 1;
}

Dialog:DLG_GUIDE_OTHER(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Guide_Show(playerid);

	new color = RandomRGBAColor();

	switch(listitem)
	{
		case 0:	MapMarker_CreateForPlayer(playerid, 2229.2471, -1722.1586, 13.6128, .color = COLOR_RED, .time = 120000);
		case 1:	MapMarker_CreateForPlayer(playerid, 1129.8983, -1441.9636, 15.7495, .color = COLOR_RED, .time = 120000);
		case 2:	MapMarker_CreateForPlayer(playerid, 1481.0200, -1724.9226, 13.5443, .color = COLOR_RED, .time = 120000);
		case 3: MapMarker_CreateForPlayer(playerid, 2684.8545, -2457.9390, 13.5385, .color = COLOR_RED, .time = 120000);
		default: return 1;
	}

	Noti_Create(playerid, .time = 3000, .text = "La localización elegida se marcará en el mapa durante 2 minutos", .backgroundColor = color);
	return 1;
}
