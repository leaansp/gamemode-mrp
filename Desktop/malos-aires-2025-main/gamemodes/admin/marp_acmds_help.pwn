#if defined _marp_acmds_help_included
	#endinput
#endif
#define _marp_acmds_help_included

// Definiciones de diálogos para el sistema de ayuda
enum {
	DLG_ACMDS_MENU = 9000,
	DLG_ACMDS_COMITES,
	DLG_ACMDS_PROP_CTRL
}

// Verificar si el jugador tiene acceso a Faction Control
stock HasFactionControlAccess(playerid) {
	new level = AccountInfo[playerid][accAdminLevel];
	return (level == 3 || level == 5 || level == 7 || level == 9 || level == 11 || level == 13 || level == 15 || level == 17 || level == 19 || level == 20 || level == 21);
}

// Verificar si el jugador tiene acceso a Property Control
stock HasPropertyControlAccess(playerid) {
	new level = AccountInfo[playerid][accAdminLevel];
	return (level == 4 || level == 5 || level == 8 || level == 9 || level == 12 || level == 13 || level == 16 || level == 17 || level == 19 || level == 20 || level == 21);
}

// Función para mostrar comandos generales (Navegación y herramientas básicas)
stock ShowGeneralCommands(playerid) {
	new level = AccountInfo[playerid][accAdminLevel];
	new bool:hasCommands = false;
	
	if(level >= 1) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "===============[Ayuda Staff - Generales]===============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/traer, /goto, /fly, /up, /slap");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/setvw, /setint, /asp (y /asp salir)");
		hasCommands = true;
	}
	
	if(level >= 2) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "===============[Ayuda Staff - Generales]===============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/jetx, /acpoint, /averoculto, /nref, /set");
		hasCommands = true;
	}
	
	if(level >= 6) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "===============[Ayuda Staff - Generales]===============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/ao, /aooc");
		hasCommands = true;
	}
	
	if(level >= 10) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "===============[Ayuda Staff - Generales]===============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/gotografiti, /checkgraf, /borrargrafiti");
		hasCommands = true;
	}
	
	if(level >= 14) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "===============[Ayuda Staff - Generales]===============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/setcoord, /getpos, /invisible");
		hasCommands = true;
	}
	
	if(level >= 20) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "===============[Ayuda Staff - Generales]===============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/crearcuenta, /nivelcomando, /recordjugadores");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/p455w0rd, /gmx, /exit");
		hasCommands = true;
	}
	
	if(!hasCommands) {
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Esta categoría se encuentra vacía.");
		return 1;
	}
	
	SendClientMessage(playerid, COLOR_INFO, "=======================================================");
	return 1;
}

// Función para mostrar comandos de información
stock ShowInfoCommands(playerid) {
	new level = AccountInfo[playerid][accAdminLevel];
	new bool:hasCommands = false;
	
	if(level >= 1) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "==============[ Ayuda Staff - Información]==============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/aservicio, /nuevos, /dudas, /reportes");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/despejardudas, /despejarreportes");
		hasCommands = true;
	}
	
	if(level >= 2) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "==============[ Ayuda Staff - Información]==============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/check, /checkoff, /checkinv, /checkinvoff");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/checkllavero, /checkllaverooff, /checkpcintoff");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/verip, /vertlf, /verjail, /verbaneos");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/verpuntosderol, /vercanal, /veradvertencias");
		hasCommands = true;
	}
	
	if(level >= 14) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "==============[ Ayuda Staff - Información]==============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/ainfo, /ppvehiculos, /versueldos, /verrecladron");
		hasCommands = true;
	}
	
	if(!hasCommands) {
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Esta categoría se encuentra vacía.");
		return 1;
	}
	
	SendClientMessage(playerid, COLOR_INFO, "=======================================================");
	return 1;
}

// Función para mostrar comandos de moderación
stock ShowModerationCommands(playerid) {
	new level = AccountInfo[playerid][accAdminLevel];
	new bool:hasCommands = false;
	
	if(level >= 1) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "==============[Ayuda Staff - Moderación]==============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/mute, /muteb, /aduda (/ad), /rduda (/rd)");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/areporte (/are), /rreporte (/rr)");
		hasCommands = true;
	}
	
	if(level >= 2) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "==============[Ayuda Staff - Moderación]==============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/sethp, /darpuntoderol, /congelar, /descongelar");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/ajail, /aliberar, /kick, /skin");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/bpj, /bpjoff, /bip, /bacc, /baccoff, /desbanear");
		hasCommands = true;
	}
	
	if(level >= 6) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "==============[Ayuda Staff - Moderación]==============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/quitarpuntoderol, /aquitarlicencia, /adarlicencia");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/daradvertencia, /quitaradvertencia, /setjob");
		hasCommands = true;
	}
	
	if(level >= 10) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "==============[Ayuda Staff - Moderación]==============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/cambiarnombre, /ckearplayer");
		hasCommands = true;
	}
	
	if(level >= 14) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "==============[Ayuda Staff - Moderación]==============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/aresetpassword, /money, /givemoney");
		hasCommands = true;
	}
	
	if(level >= 19) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "==============[Ayuda Staff - Moderación]==============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/setadmin, /reloadadmin");
		hasCommands = true;
	}
	
	if(!hasCommands) {
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Esta categoría se encuentra vacía.");
		return 1;
	}
	
	SendClientMessage(playerid, COLOR_INFO, "=======================================================");
	return 1;
}

// Función para mostrar comandos de vehículos
stock ShowVehicleCommands(playerid) {
	new level = AccountInfo[playerid][accAdminLevel];
	new bool:hasCommands = false;
	
	if(level >= 2) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "===============[Ayuda Staff - Vehículos]===============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/av, /aventrar, /avinfo, /avgoto, /avtraer");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/avrespawn, /avfix, /avfuel, /avmotor, /avhp");
		hasCommands = true;
	}
	
	if(level >= 6) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "===============[Ayuda Staff - Vehículos]===============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/avfixcars, /avfuelcars, /avrespawnall");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/avcolor, /avsirena");
		hasCommands = true;
	}
	
	if(level >= 10) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "===============[Ayuda Staff - Vehículos]===============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/avnitro, /avpinchar, /avromper, /avkm");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/avestado, /avestacionar, /avowner");
		hasCommands = true;
	}
	
	if(level >= 14) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "===============[Ayuda Staff - Vehículos]===============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/avmodelo, /avtipo, /avpatente, /avempleo");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/avfaccion, /avcrear, /avborrar");
		hasCommands = true;
	}
	
	if(level >= 20) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "===============[Ayuda Staff - Vehículos]===============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/avresetplates");
		hasCommands = true;
	}
	
	if(!hasCommands) {
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Esta categoría se encuentra vacía.");
		return 1;
	}
	
	SendClientMessage(playerid, COLOR_INFO, "=======================================================");
	return 1;
}

// Función para mostrar comandos avanzados
stock ShowAdvancedCommands(playerid) {
	new level = AccountInfo[playerid][accAdminLevel];
	new bool:hasCommands = false;
	
	if(level >= 10) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "===============[Ayuda Staff - Avanzados]===============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/maprocrear, /maprolistar, /maproacceso");
		hasCommands = true;
	}
	
	if(level >= 14) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "===============[Ayuda Staff - Avanzados]===============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/setjobsueldo, /guardarjobs");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/amuebles, /amuebleagregar, /amueblesrecargar");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/setbm, /delbm, /bmreload, /aexpdoble");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/addequip, /listequip, /delequip");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/order, /ordershow, /orderrandom, /orderdelete");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/aitemdar, /aitemquitar");
		hasCommands = true;
	}
	
	if(level >= 20) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "===============[Ayuda Staff - Avanzados]===============");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/printvector, /setpvarint, /getpvarint");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/applyanimation, /playerplaysound, /getanimation");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/getvehicledamagestatus, /updatevehicledamagestatus");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/playaudiostreamforplayer, /stopaudiostreamforplayer");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/aacrearperma, /aacreartemp, /aaanim, /aaborrar");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/aanombre, /aadesc, /aatele, /aagetid, /aahoras");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/aradiosadd, /aradiosdelete, /aradiossetname");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/aradiossetstream, /aestacionservicio, /areja");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/agregarmodelo, /borrarmodelo");
		hasCommands = true;
	}
	
	if(!hasCommands) {
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Esta categoría se encuentra vacía.");
		return 1;
	}
	
	SendClientMessage(playerid, COLOR_INFO, "=======================================================");
	return 1;
}

// Función para mostrar comandos otros
stock ShowOtherCommands(playerid) {
	new level = AccountInfo[playerid][accAdminLevel];
	new bool:hasCommands = false;
	
	if(level >= 14) {
		if(!hasCommands) SendClientMessage(playerid, COLOR_INFO, "=================[Ayuda Staff - Otros]=================");
		SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/money, /givemoney");
		hasCommands = true;
	}
	
	if(!hasCommands) {
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Esta categoría se encuentra vacía.");
		return 1;
	}
	
	SendClientMessage(playerid, COLOR_INFO, "=======================================================");
	return 1;
}

// Función para mostrar comandos de Faction Control
stock ShowFactionControlCommands(playerid) {
	if(!HasFactionControlAccess(playerid)) {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No formás parte de este comité, por lo cuál, no podés acceder a su información.");
		return 0;
	}
	
	SendClientMessage(playerid, COLOR_INFO, "===========[Ayuda Staff - Comité Faccionario]===========");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/afcmds, /af, /afacciones, /afdarlider, /afexpulsar");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/afvehiculos, /afdbgstart, /afinfomision, /afabortar");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/agrafiti, /checkgraf, /gotografiti, /borrargrafiti");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/aegetid, /aeinfo, /aefaccion");
	SendClientMessage(playerid, COLOR_INFO, "=======================================================");
	return 1;
}

// Función para mostrar comandos de Property Control - Casas
stock ShowPropertyHouseCommands(playerid) {
	if(!HasPropertyControlAccess(playerid)) {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No formás parte de este comité, por lo cuál, no podés acceder a su información.");
		return 0;
	}
	
	SendClientMessage(playerid, COLOR_INFO, "========[Ayuda Staff - Property Control: Casas]========");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/ac, /acinterior, /acentrada, /acsalida");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/acinfo, /actele, /acalquilar, /acnoalquilar");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/acprecio, /acvender, /accrear, /acborrar");
	SendClientMessage(playerid, COLOR_INFO, "=======================================================");
	return 1;
}

// Función para mostrar comandos de Property Control - Negocios
stock ShowPropertyBusinessCommands(playerid) {
	if(!HasPropertyControlAccess(playerid)) {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No formás parte de este comité, por lo cuál, no podés acceder a su información.");
		return 0;
	}
	
	SendClientMessage(playerid, COLOR_INFO, "======[Ayuda Staff - Property Control: Negocios]=======");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/an, /ancrear, /anborrar, /anentrada, /ansalida");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/anpuntocompra, /anmapeo, /ancaja, /annombre");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/anprecio, /anprecioentrada, /antipo, /angetid");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/aninfo, /anvender, /antele, /anhabilitado");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/anrandomstock, /anstock, /anitem, /anrandomstockall");
	SendClientMessage(playerid, COLOR_INFO, "=======================================================");
	return 1;
}

// Función para mostrar comandos de Property Control - Garajes
stock ShowPropertyGarageCommands(playerid) {
	if(!HasPropertyControlAccess(playerid)) {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No formás parte de este comité, por lo cuál, no podés acceder a su información.");
		return 0;
	}
	
	SendClientMessage(playerid, COLOR_INFO, "=======[Ayuda Staff - Property Control: Garajes]=======");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/ag, /aggetid, /agcrear, /agborrar");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/agareaexterior, /agareainterior");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/agpuntoexterior, /agpuntointerior");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/agtipo, /agextraid, /aginfo");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/agcerrado, /agtele");
	SendClientMessage(playerid, COLOR_INFO, "=======================================================");
	return 1;
}

// Función para mostrar comandos de Property Control - Edificios (Puertas)
stock ShowPropertyBuildingCommands(playerid) {
	if(!HasPropertyControlAccess(playerid)) {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No form??s parte de este comit??, por lo cu??l, no pod??s acceder a su informaci??n.");
		return 0;
	}
	
	SendClientMessage(playerid, COLOR_INFO, "=======[Ayuda Staff - Property Control: Puertas]=======");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/ae, /aecrear, /aeborrar, /aetele");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/aepickup, /aeentrada, /aesalida");
	SendClientMessage(playerid, COLOR_WHITE, "{C8C8C8}/aetextoentrada, /aetextosalida, /aecerrado");
	SendClientMessage(playerid, COLOR_INFO, "=======================================================");
	return 1;
}

// Manejador del diálogo del menú principal
Dialog:DLG_ACMDS_MENU(playerid, response, listitem, inputtext[]) {
	if(!response) return 1;
	
	switch(listitem) {
		case 0: ShowGeneralCommands(playerid); // Generales
		case 1: ShowInfoCommands(playerid); // Información
		case 2: ShowModerationCommands(playerid); // Moderación
		case 3: ShowVehicleCommands(playerid); // Vehículos
		case 4: { // Comités
			Dialog_Show(playerid, DLG_ACMDS_COMITES, DIALOG_STYLE_LIST, "Seleccionar Comité", "Comité Faccionario\nComité de Propiedades", "Seleccionar", "Volver");
		}
		case 5: ShowAdvancedCommands(playerid); // Avanzados
		case 6: ShowOtherCommands(playerid); // Otros
	}
	return 1;
}

// Manejador del diálogo de comités
Dialog:DLG_ACMDS_COMITES(playerid, response, listitem, inputtext[]) {
	if(!response) {
		// Volver al menú principal
		return cmd_admincmds(playerid, "");
	}
	
	switch(listitem) {
		case 0: ShowFactionControlCommands(playerid); // Facción
		case 1: { // Propiedades - mostrar submenú
			Dialog_Show(playerid, DLG_ACMDS_PROP_CTRL, DIALOG_STYLE_LIST, "Property Control - Seleccionar Categoría", "Comandos para Casas\nComandos para Negocios\nComandos para Garajes\nComandos para Puertas", "Seleccionar", "Volver");
		}
	}
	return 1;
}

// Manejador del diálogo de Property Control
Dialog:DLG_ACMDS_PROP_CTRL(playerid, response, listitem, inputtext[]) {
	if(!response) {
		// Volver al menú de comités
		Dialog_Show(playerid, DLG_ACMDS_COMITES, DIALOG_STYLE_LIST, "Seleccionar Comité", "Comité Faccionario\nComité de Propiedades", "Seleccionar", "Volver");
		return 1;
	}
	
	switch(listitem) {
		case 0: ShowPropertyHouseCommands(playerid); // Casas
		case 1: ShowPropertyBusinessCommands(playerid); // Negocios
		case 2: ShowPropertyGarageCommands(playerid); // Garajes
		case 3: ShowPropertyBuildingCommands(playerid); // Puertas (Edificios)
	}
	return 1;
}
