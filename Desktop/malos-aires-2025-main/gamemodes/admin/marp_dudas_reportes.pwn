/*
	Sistema de Dudas y Reportes con IDs Temporales
	Creado: 10 de enero de 2026
	
	Sistema de gestión de dudas y reportes con IDs temporales que no se guardan en base de datos.
	Las IDs son acumulativas y no se reasignan cuando se borra una entrada anterior.
*/

#if defined _marp_dudas_reportes_included
	#endinput
#endif
#define _marp_dudas_reportes_included

// Definiciones
#define MAX_DUDAS 100
#define MAX_REPORTES 100

// Enums para estructuras de datos
enum E_DUDA_DATA {
	bool:dudaActiva,
	dudaJugadorID,
	dudaTexto[144],
	dudaID
}

enum E_REPORTE_DATA {
	bool:reporteActivo,
	reporteReportanteID,
	reporteReportadoID,
	reporteRazon[256],
	reporteID
}

// Variables globales
new DudasData[MAX_DUDAS][E_DUDA_DATA];
new ReportesData[MAX_REPORTES][E_REPORTE_DATA];
new PlayerDudaCooldown[MAX_PLAYERS];
new PlayerReporteCooldown[MAX_PLAYERS];
new ReportesNotificationTimer;

// Diálogos
enum {
	DLG_DUDAS_MENU = 9100,
	DLG_REPORTES_MENU
}

// ============================================================================
// FUNCIONES AUXILIARES
// ============================================================================

// Encuentra el ID más bajo libre para una nueva duda
stock FindFreeDudaID() {
	new bool:idUsed[MAX_DUDAS];
	
	// Marcar todas las IDs en uso
	for(new i = 0; i < MAX_DUDAS; i++) {
		if(DudasData[i][dudaActiva] && DudasData[i][dudaID] > 0 && DudasData[i][dudaID] <= MAX_DUDAS) {
			idUsed[DudasData[i][dudaID] - 1] = true;
		}
	}
	
	// Buscar el ID más bajo disponible
	for(new i = 0; i < MAX_DUDAS; i++) {
		if(!idUsed[i])
			return i + 1;
	}
	
	return -1; // No hay IDs disponibles
}

// Encuentra el ID más bajo libre para un nuevo reporte
stock FindFreeReporteID() {
	new bool:idUsed[MAX_REPORTES];
	
	// Marcar todas las IDs en uso
	for(new i = 0; i < MAX_REPORTES; i++) {
		if(ReportesData[i][reporteActivo] && ReportesData[i][reporteID] > 0 && ReportesData[i][reporteID] <= MAX_REPORTES) {
			idUsed[ReportesData[i][reporteID] - 1] = true;
		}
	}
	
	// Buscar el ID más bajo disponible
	for(new i = 0; i < MAX_REPORTES; i++) {
		if(!idUsed[i])
			return i + 1;
	}
	
	return -1; // No hay IDs disponibles
}

// Encuentra un slot libre para una nueva duda
stock FindFreeDudaSlot() {
	for(new i = 0; i < MAX_DUDAS; i++) {
		if(!DudasData[i][dudaActiva])
			return i;
	}
	return -1;
}

// Encuentra un slot libre para un nuevo reporte
stock FindFreeReporteSlot() {
	for(new i = 0; i < MAX_REPORTES; i++) {
		if(!ReportesData[i][reporteActivo])
			return i;
	}
	return -1;
}

// Encuentra una duda por ID de duda
stock FindDudaByID(dudaid) {
	for(new i = 0; i < MAX_DUDAS; i++) {
		if(DudasData[i][dudaActiva] && DudasData[i][dudaID] == dudaid)
			return i;
	}
	return -1;
}

// Encuentra una duda por ID de jugador
stock FindDudaByPlayerID(playerid) {
	for(new i = 0; i < MAX_DUDAS; i++) {
		if(DudasData[i][dudaActiva] && DudasData[i][dudaJugadorID] == playerid)
			return i;
	}
	return -1;
}

// Encuentra un reporte por ID de reporte
stock FindReporteByID(reporteid) {
	for(new i = 0; i < MAX_REPORTES; i++) {
		if(ReportesData[i][reporteActivo] && ReportesData[i][reporteID] == reporteid)
			return i;
	}
	return -1;
}

// Elimina una duda
stock DeleteDuda(slot) {
	if(slot < 0 || slot >= MAX_DUDAS)
		return 0;
	
	DudasData[slot][dudaActiva] = false;
	DudasData[slot][dudaJugadorID] = INVALID_PLAYER_ID;
	DudasData[slot][dudaTexto][0] = EOS;
	return 1;
}

// Elimina un reporte
stock DeleteReporte(slot) {
	if(slot < 0 || slot >= MAX_REPORTES)
		return 0;
	
	ReportesData[slot][reporteActivo] = false;
	ReportesData[slot][reporteReportanteID] = INVALID_PLAYER_ID;
	ReportesData[slot][reporteReportadoID] = INVALID_PLAYER_ID;
	ReportesData[slot][reporteRazon][0] = EOS;
	return 1;
}

// Limpia todas las dudas de un jugador (al desconectar)
stock CleanPlayerDudas(playerid) {
	for(new i = 0; i < MAX_DUDAS; i++) {
		if(DudasData[i][dudaActiva] && DudasData[i][dudaJugadorID] == playerid)
			DeleteDuda(i);
	}
}

// Limpia todos los reportes relacionados con un jugador (al desconectar)
stock CleanPlayerReportes(playerid) {
	for(new i = 0; i < MAX_REPORTES; i++) {
		if(ReportesData[i][reporteActivo]) {
			if(ReportesData[i][reporteReportanteID] == playerid || ReportesData[i][reporteReportadoID] == playerid)
				DeleteReporte(i);
		}
	}
}

// Cuenta dudas activas
stock CountActiveDudas() {
	new count = 0;
	for(new i = 0; i < MAX_DUDAS; i++) {
		if(DudasData[i][dudaActiva])
			count++;
	}
	return count;
}

// Cuenta reportes activos
stock CountActiveReportes() {
	new count = 0;
	for(new i = 0; i < MAX_REPORTES; i++) {
		if(ReportesData[i][reporteActivo])
			count++;
	}
	return count;
}

// ============================================================================
// COMANDOS PARA JUGADORES
// ============================================================================

CMD:duda(playerid, params[]) {
	new string[144], string2[256];
	
	if(sscanf(params, "s[144]", string))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/duda [texto]");

	// Verificar cooldown
	if(gettime() < PlayerDudaCooldown[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar 1 minuto antes de enviar otra duda.");

	// Verificar si ya tiene una duda activa
	new existingSlot = FindDudaByPlayerID(playerid);
	if(existingSlot != -1) {
		// Reemplazar duda existente
		format(DudasData[existingSlot][dudaTexto], 144, "%s", string);
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tu duda anterior fue reemplazada por esta nueva.");
	}
	else {
		// Buscar ID libre
		new newDudaID = FindFreeDudaID();
		if(newDudaID == -1)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay espacio para más dudas en este momento. Intenta más tarde.");
		
		// Buscar slot libre
		new slot = FindFreeDudaSlot();
		if(slot == -1)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay espacio para más dudas en este momento. Intenta más tarde.");
		
		DudasData[slot][dudaActiva] = true;
		DudasData[slot][dudaJugadorID] = playerid;
		DudasData[slot][dudaID] = newDudaID;
		format(DudasData[slot][dudaTexto], 144, "%s", string);
		
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tu duda ha sido enviada al equipo de staff.");
		
		// Establecer cooldown (1 minuto)
		PlayerDudaCooldown[playerid] = gettime() + 60;
		
		// Notificar al staff
		format(string2, sizeof(string2), "[DUDA] Usuario: %s (ID: %d)", GetPlayerCleanName(playerid), playerid);
		AdministratorMessage(COLOR_DOUBT, string2, 1);
		format(string2, sizeof(string2), "[DUDA] Duda: %s", string);
		AdministratorMessage(COLOR_DOUBT, string2, 1);
		format(string2, sizeof(string2), "[DUDA] Utiliza /aduda %d para aceptar la duda y responderle al usuario.", playerid);
		AdministratorMessage(COLOR_DOUBT, string2, 1);
	}
	
	return 1;
}

CMD:reportar(playerid, params[]) {
	new targetid, reason[256], string[512];
	
	if(sscanf(params, "us[256]", targetid, reason))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/reportar [ID/ParteDelNombre] [razón]");
	
	if(!IsPlayerConnected(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nombre incorrecto o el jugador no se encuentra conectado.");
	
	if(targetid == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes reportarte a ti mismo.");
	
	// Verificar cooldown
	if(gettime() < PlayerReporteCooldown[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar 1 minuto antes de enviar otro reporte.");
	
	// Buscar ID libre
	new newReporteID = FindFreeReporteID();
	if(newReporteID == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay espacio para más reportes en este momento. Intenta más tarde.");
	
	// Buscar slot libre
	new slot = FindFreeReporteSlot();
	if(slot == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay espacio para más reportes en este momento. Intenta más tarde.");
	
	// Crear nuevo reporte
	ReportesData[slot][reporteActivo] = true;
	ReportesData[slot][reporteReportanteID] = playerid;
	ReportesData[slot][reporteReportadoID] = targetid;
	ReportesData[slot][reporteID] = newReporteID;
	format(ReportesData[slot][reporteRazon], 256, "%s", reason);
	
	format(string, sizeof(string), "[INFO] "COLOR_EMB_GREY"Has reportado a %s (ID: %d) - Razón: %s", GetPlayerCleanName(targetid), targetid, reason);
	SendClientMessage(playerid, COLOR_INFO, string);
	
	// Establecer cooldown (1 minuto)
	PlayerReporteCooldown[playerid] = gettime() + 60;
	
	// Notificar al staff
	format(string, sizeof(string), "[REPORTE] Reportante: %s (ID: %d)", GetPlayerCleanName(playerid), playerid);
	AdministratorMessage(COLOR_ADMINCMD, string, 1);
	format(string, sizeof(string), "[REPORTE] Reportado: %s (ID: %d)", GetPlayerCleanName(targetid), targetid);
	AdministratorMessage(COLOR_ADMINCMD, string, 1);
	format(string, sizeof(string), "[REPORTE] Razón: %s", reason);
	AdministratorMessage(COLOR_ADMINCMD, string, 1);
	format(string, sizeof(string), "[REPORTE] Utiliza /areporte %d para aceptar el reporte y encargarte de la situación.", ReportesData[slot][reporteID]);
	AdministratorMessage(COLOR_ADMINCMD, string, 1);
	
	return 1;
}

// ============================================================================
// COMANDOS PARA STAFF - VER DUDAS Y REPORTES
// ============================================================================

CMD:dudas(playerid, params[]) {
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");
	
	new count = CountActiveDudas();
	if(count == 0) {
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No hay dudas pendientes de respuesta.");
		return 1;
	}
	
	new string[2048], line[256];
	string[0] = EOS;
	
	for(new i = 0; i < MAX_DUDAS; i++) {
		if(!DudasData[i][dudaActiva])
			continue;
		
		format(line, sizeof(line), "{910606}[ID %d] {FFFFFF}%s (ID: %d) {FF8000}%s\n", 
			DudasData[i][dudaID],
			GetPlayerCleanName(DudasData[i][dudaJugadorID]),
			DudasData[i][dudaJugadorID],
			DudasData[i][dudaTexto]
		);
		strcat(string, line);
	}
	
	Dialog_Show(playerid, DLG_DUDAS_MENU, DIALOG_STYLE_LIST, "Dudas Pendientes", string, "Ver Duda", "Cerrar");
	return 1;
}

CMD:reportes(playerid, params[]) {
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");
	
	new count = CountActiveReportes();
	if(count == 0) {
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"No hay reportes pendientes de atención.");
		return 1;
	}
	
	new string[2048], line[256];
	string[0] = EOS;
	
	for(new i = 0; i < MAX_REPORTES; i++) {
		if(!ReportesData[i][reporteActivo])
			continue;
		
		format(line, sizeof(line), "{910606}[ID %d] {FFFFFF}%s (ID: %d) {FF8000}reportó a {FFFFFF}%s (ID: %d)\n", 
			ReportesData[i][reporteID],
			GetPlayerCleanName(ReportesData[i][reporteReportanteID]),
			ReportesData[i][reporteReportanteID],
			GetPlayerCleanName(ReportesData[i][reporteReportadoID]),
			ReportesData[i][reporteReportadoID]
		);
		strcat(string, line);
	}
	
	Dialog_Show(playerid, DLG_REPORTES_MENU, DIALOG_STYLE_LIST, "Reportes Pendientes", string, "Ver Reporte", "Cerrar");
	return 1;
}

// ============================================================================
// DIÁLOGOS
// ============================================================================

Dialog:DLG_DUDAS_MENU(playerid, response, listitem, inputtext[]) {
	if(!response)
		return 1;
	
	// Buscar la duda seleccionada
	new currentItem = 0;
	for(new i = 0; i < MAX_DUDAS; i++) {
		if(!DudasData[i][dudaActiva])
			continue;
		
		if(currentItem == listitem) {
			// Mostrar detalles de la duda
			new string[512];
			format(string, sizeof(string), "[DUDA] Usuario: %s (ID: %d)", GetPlayerCleanName(DudasData[i][dudaJugadorID]), DudasData[i][dudaJugadorID]);
			SendClientMessage(playerid, COLOR_DOUBT, string);
			format(string, sizeof(string), "[DUDA] Duda: %s", DudasData[i][dudaTexto]);
			SendClientMessage(playerid, COLOR_DOUBT, string);
			format(string, sizeof(string), "[DUDA] Utiliza /aduda %d [respuesta] para aceptar la duda y responderle al usuario.", DudasData[i][dudaJugadorID]);
			SendClientMessage(playerid, COLOR_DOUBT, string);
			return 1;
		}
		currentItem++;
	}
	
	return 1;
}

Dialog:DLG_REPORTES_MENU(playerid, response, listitem, inputtext[]) {
	if(!response)
		return 1;
	
	// Buscar el reporte seleccionado
	new currentItem = 0;
	for(new i = 0; i < MAX_REPORTES; i++) {
		if(!ReportesData[i][reporteActivo])
			continue;
		
		if(currentItem == listitem) {
			// Mostrar detalles del reporte
			new string[512];
			format(string, sizeof(string), "[REPORTE] Reportante: %s (ID: %d)", GetPlayerCleanName(ReportesData[i][reporteReportanteID]), ReportesData[i][reporteReportanteID]);
			SendClientMessage(playerid, COLOR_ADMINCMD, string);
			format(string, sizeof(string), "[REPORTE] Reportado: %s (ID: %d)", GetPlayerCleanName(ReportesData[i][reporteReportadoID]), ReportesData[i][reporteReportadoID]);
			SendClientMessage(playerid, COLOR_ADMINCMD, string);
			format(string, sizeof(string), "[REPORTE] Razón: %s", ReportesData[i][reporteRazon]);
			SendClientMessage(playerid, COLOR_ADMINCMD, string);
			format(string, sizeof(string), "[REPORTE] Utiliza /areporte %d para aceptar el reporte y encargarte de la situación.", ReportesData[i][reporteID]);
			SendClientMessage(playerid, COLOR_ADMINCMD, string);
			return 1;
		}
		currentItem++;
	}
	
	return 1;
}

// ============================================================================
// COMANDOS PARA STAFF - ATENDER DUDAS Y REPORTES
// ============================================================================

CMD:ad(playerid, params[]) {
	return cmd_aduda(playerid, params);
}

CMD:aduda(playerid, params[]) {
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");
	
	new targetid, respuesta[144], string[512];
	
	if(sscanf(params, "us[144]", targetid, respuesta))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/aduda [ID Jugador] [Respuesta]");
	
	if(!IsPlayerConnected(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no está conectado.");
	
	// Buscar duda del jugador
	new slot = FindDudaByPlayerID(targetid);
	if(slot == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El usuario no tiene una duda pendiente de respuesta.");
	
	// Enviar respuesta al jugador
	format(string, sizeof(string), "[INFO] "COLOR_EMB_GREY"El miembro del Staff Team %s (%s) [ID: %d] respondió tu duda.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
	SendClientMessage(targetid, COLOR_INFO, string);
	format(string, sizeof(string), "[DUDA] Respuesta: %s", respuesta);
	SendClientMessage(targetid, COLOR_DOUBT, string);
	
	// Notificar al staff
	format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El miembro del Staff Team %s (%s) [ID: %d] respondió la duda de %s [ID: %d].", 
		GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid,
		GetPlayerCleanName(targetid), targetid);
	AdministratorMessage(COLOR_ADMINCMD, string, 1);
	
	// Eliminar duda
	DeleteDuda(slot);
	
	return 1;
}

CMD:are(playerid, params[]) {
	return cmd_areporte(playerid, params);
}

CMD:areporte(playerid, params[]) {
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");
	
	new reporteid, string[512];
	
	if(sscanf(params, "d", reporteid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/areporte [ID Reporte]");
	
	// Buscar reporte por ID
	new slot = FindReporteByID(reporteid);
	if(slot == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontró un reporte con esa ID.");
	
	new reportanteID = ReportesData[slot][reporteReportanteID];
	
	// Verificar que el reportante siga conectado
	if(!IsPlayerConnected(reportanteID))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El reportante ya no está conectado.");
	
	// Notificar al reportante
	format(string, sizeof(string), "[INFO] "COLOR_EMB_GREY"El miembro del Staff Team %s (%s) [ID: %d] atendió tu reporte y se encuentra revisando la situación.", GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid);
	SendClientMessage(reportanteID, COLOR_INFO, string);
	
	// Notificar al staff
	format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El miembro del Staff Team %s (%s) [ID: %d] atendió el reporte número %d.", 
		GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, reporteid);
	AdministratorMessage(COLOR_ADMINCMD, string, 1);
	
	// Eliminar reporte
	DeleteReporte(slot);
	
	return 1;
}

// ============================================================================
// COMANDOS PARA STAFF - RECHAZAR DUDAS Y REPORTES
// ============================================================================

CMD:rd(playerid, params[]) {
	return cmd_rduda(playerid, params);
}

CMD:rduda(playerid, params[]) {
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");
	
	new targetid, string[512];
	
	if(sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/rduda [ID Jugador]");
	
	if(!IsPlayerConnected(targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no está conectado.");
	
	// Buscar duda del jugador
	new slot = FindDudaByPlayerID(targetid);
	if(slot == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El usuario no tiene una duda pendiente de respuesta.");
	
	// Notificar al jugador (sin mencionar quién)
	SendClientMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Un miembro del Staff Team desestimó tu duda.");
	
	// Notificar al staff
	format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El miembro del Staff Team %s (%s) [ID: %d] rechazó la duda de %s [ID: %d].", 
		GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid,
		GetPlayerCleanName(targetid), targetid);
	AdministratorMessage(COLOR_ADMINCMD, string, 1);
	
	// Eliminar duda
	DeleteDuda(slot);
	
	return 1;
}

CMD:rr(playerid, params[]) {
	return cmd_rreporte(playerid, params);
}

CMD:rreporte(playerid, params[]) {
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");
	
	new reporteid, string[512];
	
	if(sscanf(params, "d", reporteid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/rreporte [ID Reporte]");
	
	// Buscar reporte por ID
	new slot = FindReporteByID(reporteid);
	if(slot == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se encontró un reporte con esa ID.");
	
	new reportanteID = ReportesData[slot][reporteReportanteID];
	
	// Verificar que el reportante siga conectado
	if(IsPlayerConnected(reportanteID)) {
		// Notificar al reportante (sin mencionar quién)
		SendClientMessage(reportanteID, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Un miembro del Staff Team desestimó tu reporte.");
	}
	
	// Notificar al staff
	format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El miembro del Staff Team %s (%s) [ID: %d] rechazó el reporte número %d.", 
		GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, reporteid);
	AdministratorMessage(COLOR_ADMINCMD, string, 1);
	
	// Eliminar reporte
	DeleteReporte(slot);
	
	return 1;
}

// ============================================================================
// COMANDOS PARA STAFF - LIMPIAR TODOS
// ============================================================================

CMD:despejardudas(playerid, params[]) {
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");
	
	new string[256];
	new count = 0;
	for(new i = 0; i < MAX_DUDAS; i++) {
		if(DudasData[i][dudaActiva]) {
			DeleteDuda(i);
			count++;
		}
	}
	
	format(string, sizeof(string), "[INFO] "COLOR_EMB_GREY"Se eliminaron %d dudas pendientes.", count);
	SendClientMessage(playerid, COLOR_INFO, string);
	
	format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] limpió todas las dudas pendientes (%d en total).", 
		GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, count);
	AdministratorMessage(COLOR_ADMINCMD, string, 1);
	
	return 1;
}

CMD:despejarreportes(playerid, params[]) {
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Support o superior para usar este comando.");
	
	new string[256];
	new count = 0;
	for(new i = 0; i < MAX_REPORTES; i++) {
		if(ReportesData[i][reporteActivo]) {
			DeleteReporte(i);
			count++;
		}
	}
	
	format(string, sizeof(string), "[INFO] "COLOR_EMB_GREY"Se eliminaron %d reportes pendientes.", count);
	SendClientMessage(playerid, COLOR_INFO, string);
	
	format(string, sizeof(string), "[AVISO STAFF] {C8C8C8}El administrador %s (%s) [ID: %d] limpió todos los reportes pendientes (%d en total).", 
		GetPlayerCleanName(playerid), AccountInfo[playerid][accUsername], playerid, count);
	AdministratorMessage(COLOR_ADMINCMD, string, 1);
	
	return 1;
}

// ============================================================================
// HOOK OnPlayerDisconnect - Limpiar datos del jugador
// ============================================================================

hook OnPlayerDisconnect(playerid, reason) {
	CleanPlayerDudas(playerid);
	CleanPlayerReportes(playerid);
	PlayerDudaCooldown[playerid] = 0;
	PlayerReporteCooldown[playerid] = 0;
	PlayerHasDoubleExp[playerid] = false; // Resetear beneficio de experiencia doble
	return 1;
}

// ============================================================================
// SISTEMA DE NOTIFICACIÓN DE REPORTES PENDIENTES
// ============================================================================

forward CheckPendingReportes();
public CheckPendingReportes() {
	// Verificar si hay reportes pendientes
	new count = CountActiveReportes();
	if(count == 0)
		return 1;
	
	// Notificar a todos los administradores en servicio
	foreach(new i : Player) {
		if(AccountInfo[i][accAdminLevel] >= 1 && AdminDuty[i]) {
			GameTextForPlayer(i, "~r~Hay reportes pendientes, utiliza /reportes para verlos", 5000, 3);
		}
	}
	return 1;
}

hook OnGameModeInit() {
	// Iniciar timer de notificación cada 5 segundos
	ReportesNotificationTimer = SetTimer("CheckPendingReportes", 5000, true);
	return 1;
}

hook OnGameModeExit() {
	// Eliminar timer
	KillTimer(ReportesNotificationTimer);
	return 1;
}

