#if defined _marp_backpack_included
	#endinput
#endif
#define _marp_backpack_included

#include <YSI_Coding\y_hooks>

/*
	Sistema de Mochilas
	
	Las mochilas son contenedores portátiles que permiten guardar items.
	Pueden ser usadas tanto en la mano como equipadas en la espalda.
	
	Capacidades por tamaño:
	- Mochila chica: 35 espacios
	- Mochila mediana: 50 espacios
	- Mochila grande: 70 espacios
	
	Funcionamiento:
	- Cada mochila tiene un contenedor asociado (tabla containers_info/containers_slots)
	- El parámetro del item mochila almacena el container_id en memoria o el SQLID
	- Al usar /mochila se crea/carga el contenedor automáticamente
	- El contenedor se guarda en la BD al agregar/quitar items
*/

// Estructura para almacenar info de mochilas
enum E_BACKPACK_DATA {
	bp_ItemID,			// ID del item de mochila
	bp_ContainerID,		// ID del contenedor en memoria
	bp_ContainerSQLID,	// ID del contenedor en SQL
	bp_Capacity			// Capacidad total de la mochila
}

// Máximo de mochilas activas simultáneamente (ajustar según necesidad)
#define MAX_BACKPACKS 500

new BackpackData[MAX_BACKPACKS][E_BACKPACK_DATA];
new Iterator:BackpackIterator<MAX_BACKPACKS>;

//==============================================================================
// Funciones de utilidad
//==============================================================================

/**
 * Verifica si un item es una mochila
 * @param itemid ID del item a verificar
 * @return true si es mochila, false si no
 */
stock Backpack_IsBackpack(itemid) {
	switch(itemid) {
		case ITEM_ID_MOCHILACHICA, ITEM_ID_MOCHILAMEDIANA, ITEM_ID_MOCHILAGRANDE:
			return true;
	}
	return false;
}

/**
 * Obtiene la capacidad de una mochila según su tamaño
 * @param itemid ID del item de mochila
 * @return Capacidad en espacios
 */
stock Backpack_GetCapacity(itemid) {
	switch(itemid) {
		case ITEM_ID_MOCHILACHICA: return 35;
		case ITEM_ID_MOCHILAMEDIANA: return 50;
		case ITEM_ID_MOCHILAGRANDE: return 70;
	}
	return 0;
}

/**
 * Crea o carga el contenedor de una mochila
 * @param itemid ID del item de mochila
 * @param param Parámetro del item (puede contener container_sqlid o 0)
 * @param backpack_idx Índice del slot de mochila (salida por referencia)
 * @return true si se creó/cargó exitosamente
 */
stock Backpack_EnsureContainer(itemid, &param, &backpack_idx) {
	if(!Backpack_IsBackpack(itemid))
		return false;
	
	new capacity = Backpack_GetCapacity(itemid);
	if(capacity <= 0)
		return false;
	
	// Si param > 0, puede ser un SQLID para cargar o un container_id en memoria
	if(param > 0) {
		// Verificar si ya es un container_id válido en memoria
		if(vector_size(param) > 3) {
			// Ya es un contenedor en memoria, verificar capacidad
			if(Container_GetTotalSpace(param) != capacity) {
				Container_SetTotalSpace(param, capacity);
			}
			
			// Buscar si ya existe en el array
			backpack_idx = Backpack_FindByContainerID(param);
			if(backpack_idx == -1) {
				// Crear nueva entrada con SQLID del contenedor
				new container_sqlid = Container_GetSQLID(param);
				backpack_idx = Backpack_Create(itemid, param, container_sqlid, capacity);
			}
			// Mantener el param como container_id para uso en memoria
			return true;
		}
		
		// Es un SQLID, intentar cargar
		new container_id = Container_Load(param);
		if(container_id > 0) {
			// Cargado exitosamente
			if(Container_GetTotalSpace(container_id) != capacity) {
				Container_SetTotalSpace(container_id, capacity);
			}
			
			backpack_idx = Backpack_Create(itemid, container_id, param, capacity);
			// NO cambiar param, mantener el SQLID original
			return true;
		}
	}
	
	// No hay contenedor, crear uno nuevo
	new container_id, container_sqlid;
	Container_Create(capacity, 1, container_id, container_sqlid);
	
	if(container_id > 0) {
		backpack_idx = Backpack_Create(itemid, container_id, container_sqlid, capacity);
		param = container_sqlid; // Guardar el SQLID, no el container_id
		return true;
	}
	
	return false;
}

/**
 * Crea una nueva entrada de mochila
 * @param itemid ID del item de mochila
 * @param container_id ID del contenedor en memoria
 * @param container_sqlid ID del contenedor en SQL
 * @param capacity Capacidad de la mochila
 * @return Índice del slot creado o -1 si falló
 */
stock Backpack_Create(itemid, container_id, container_sqlid, capacity) {
	new idx = Iter_Free(BackpackIterator);
	if(idx == INVALID_ITERATOR_SLOT)
		return -1;
	
	BackpackData[idx][bp_ItemID] = itemid;
	BackpackData[idx][bp_ContainerID] = container_id;
	BackpackData[idx][bp_ContainerSQLID] = container_sqlid;
	BackpackData[idx][bp_Capacity] = capacity;
	
	Iter_Add(BackpackIterator, idx);
	return idx;
}

/**
 * Busca una mochila por su container_id
 * @param container_id ID del contenedor a buscar
 * @return Índice del slot o -1 si no se encontró
 */
stock Backpack_FindByContainerID(container_id) {
	foreach(new idx : BackpackIterator) {
		if(BackpackData[idx][bp_ContainerID] == container_id)
			return idx;
	}
	return -1;
}

/**
 * Destruye una entrada de mochila (no destruye el contenedor)
 * @param backpack_idx Índice del slot de mochila
 */
stock Backpack_Destroy(backpack_idx) {
	if(!Iter_Contains(BackpackIterator, backpack_idx))
		return;
	
	BackpackData[backpack_idx][bp_ItemID] = 0;
	BackpackData[backpack_idx][bp_ContainerID] = 0;
	BackpackData[backpack_idx][bp_ContainerSQLID] = 0;
	BackpackData[backpack_idx][bp_Capacity] = 0;
	
	Iter_Remove(BackpackIterator, backpack_idx);
}

/**
 * Obtiene el SQLID de un contenedor de mochila para guardarlo
 * @param container_id ID del contenedor en memoria
 * @return SQLID del contenedor
 */
stock Backpack_GetContainerSQLID(container_id) {
	new backpack_idx = Backpack_FindByContainerID(container_id);
	if(backpack_idx == -1)
		return Container_GetSQLID(container_id);
	
	return BackpackData[backpack_idx][bp_ContainerSQLID];
}

/**
 * Obtiene el espacio ocupado de una mochila desde su parámetro
 * @param itemid ID del item de mochila
 * @param param Parámetro del item (SQLID o container_id)
 * @return Espacio ocupado, o -1 si no se puede determinar
 */
stock Backpack_GetOccupiedSpace(itemid, param) {
	if(!Backpack_IsBackpack(itemid) || param <= 0)
		return -1;
	
	new container_id = param;
	
	// Si param es un SQLID pequeño, intentar encontrar el container_id en memoria
	if(param < 1000) {
		// Buscar en el array de mochilas
		foreach(new idx : BackpackIterator) {
			if(BackpackData[idx][bp_ContainerSQLID] == param) {
				container_id = BackpackData[idx][bp_ContainerID];
				break;
			}
		}
		// Si no se encontró, el contenedor no está cargado
		if(container_id == param)
			return -1;
	}
	
	// Verificar que sea un container válido en memoria
	if(vector_size(container_id) <= 3)
		return -1;
	
	return Container_GetUsedSpace(container_id);
}

/**
 * Formatea el texto de display del parámetro de una mochila (ocupado/total)
 * @param itemid ID del item
 * @param param Parámetro del item
 * @param output Buffer de salida
 * @param size Tamaño del buffer
 */
stock Backpack_FormatParamDisplay(itemid, param, output[], size) {
	if(!Backpack_IsBackpack(itemid)) {
		format(output, size, "%d", param);
		return;
	}
	
	new occupied = Backpack_GetOccupiedSpace(itemid, param);
	new capacity = Backpack_GetCapacity(itemid);
	
	if(occupied == -1) {
		// Contenedor no cargado, mostrar solo capacidad
		format(output, size, "0/%d", capacity);
	} else {
		format(output, size, "%d/%d", occupied, capacity);
	}
}

//==============================================================================
// Comandos
//==============================================================================

CMD:mochila(playerid, params[]) {
	new itemid, container_ref, location = -1, backpack_idx;
	
	// Buscar mochila en la espalda
	if(Back_IsCarrying(playerid) == CARRY_TYPE_BACK) {
		itemid = Back_GetItem(playerid);
		if(Backpack_IsBackpack(itemid)) {
			container_ref = Back_GetParam(playerid);
			location = 0; // espalda
		}
	}
	
	// Si no hay en espalda, buscar en mano derecha
	if(location == -1) {
		itemid = GetHandItem(playerid, HAND_RIGHT);
		if(Backpack_IsBackpack(itemid)) {
			container_ref = GetHandParam(playerid, HAND_RIGHT);
			location = HAND_RIGHT;
		}
	}
	
	// Si no hay en mano derecha, buscar en mano izquierda
	if(location == -1) {
		itemid = GetHandItem(playerid, HAND_LEFT);
		if(Backpack_IsBackpack(itemid)) {
			container_ref = GetHandParam(playerid, HAND_LEFT);
			location = HAND_LEFT;
		}
	}
	
	// No tiene mochila
	if(location == -1) {
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una mochila equipada ni en tus manos.");
	}
	
	// Asegurar que el contenedor existe
	if(!Backpack_EnsureContainer(itemid, container_ref, backpack_idx)) {
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No se pudo inicializar el contenedor de la mochila.");
	}
	
	// Obtener el container_id en memoria desde el backpack_idx
	new container_id = BackpackData[backpack_idx][bp_ContainerID];
	new container_sqlid = BackpackData[backpack_idx][bp_ContainerSQLID];
	
	// Actualizar la referencia en su ubicación con el SQLID para persistencia
	if(location == 0) { // espalda
		BackInfo[playerid][backAmount] = container_sqlid;
	} else if(location == HAND_RIGHT) {
		HandInfo[playerid][HAND_RIGHT][Amount] = container_sqlid;
	} else if(location == HAND_LEFT) {
		HandInfo[playerid][HAND_LEFT][Amount] = container_sqlid;
	}
	
	// Mostrar el contenedor usando el container_id en memoria
	if(!Container_Show(playerid, CONTAINER_TYPE_ITEM, container_id, playerid)) {
		return SendClientMessage(playerid, COLOR_YELLOW2, "[ERROR] No se pudo abrir la mochila.");
	}
	
	return 1;
}

CMD:mguardar(playerid, params[])
{
	new hand = HAND_RIGHT;
	// Si la mano derecha está vacía, intentamos con la izquierda
	if(GetHandItem(playerid, hand) == 0) {
		hand = HAND_LEFT;
	}

	new itemid = GetHandItem(playerid, hand);
	if(itemid == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes nada en la mano para guardar.");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
	if(Item_IsHandlingCooldownOn(playerid))
		return SendClientMessage(playerid, COLOR_YELLOW2, "¡Debes esperar un tiempo antes de volver a interactuar con otro item!");
	if(!ItemModel_HasTag(itemid, ITEM_TAG_SAVE))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo con este ítem.");

	// Buscar mochila disponible (prioridad: espalda, luego manos)
	new backpack_item, location = -1, container_ref, backpack_idx;

	if(Back_IsCarrying(playerid) == CARRY_TYPE_BACK) {
		backpack_item = Back_GetItem(playerid);
		if(Backpack_IsBackpack(backpack_item)) {
			container_ref = Back_GetParam(playerid);
			location = 0; // espalda
		}
	}
	if(location == -1) {
		new right = GetHandItem(playerid, HAND_RIGHT);
		if(Backpack_IsBackpack(right)) {
			backpack_item = right;
			container_ref = GetHandParam(playerid, HAND_RIGHT);
			location = HAND_RIGHT;
		}
	}
	if(location == -1) {
		new left = GetHandItem(playerid, HAND_LEFT);
		if(Backpack_IsBackpack(left)) {
			backpack_item = left;
			container_ref = GetHandParam(playerid, HAND_LEFT);
			location = HAND_LEFT;
		}
	}

	if(location == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una mochila equipada ni en tus manos.");

	// No permitir guardar la mochila dentro de sí misma o contenedores dentro de mochila (por ahora)
	if(ItemModel_GetType(itemid) == ITEM_CONTAINER)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes guardar contenedores dentro de la mochila.");

	// Asegurar que el contenedor de la mochila exista
	if(!Backpack_EnsureContainer(backpack_item, container_ref, backpack_idx)) {
		return SendClientMessage(playerid, COLOR_YELLOW2, "[ERROR] No se pudo inicializar el contenedor de la mochila.");
	}

	// Obtener el container_id en memoria
	new container_id = BackpackData[backpack_idx][bp_ContainerID];

	// Guardar item
	new itemparam = GetHandParam(playerid, hand);
	if(!Container_AddItemAndParam(container_id, itemid, itemparam))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay espacio suficiente en la mochila / El ítem es demasiado chico.");

	SetHandItemAndParam(playerid, hand, 0, 0);
	Item_ApplyHandlingCooldown(playerid);

	new str[128], param_display[32];
	Backpack_FormatParamDisplay(backpack_item, Container_GetSQLID(container_id), param_display, sizeof(param_display));
	format(str, sizeof(str), "Guardas un/a %s en la mochila.", ItemModel_GetName(itemid), param_display);
	PlayerCmeMessage(playerid, 15.0, 5000, str);

	if(ItemModel_GetType(itemid) == ITEM_WEAPON) {
		ServerFormattedLog(LOG_TYPE_ID_WEAPONS, .entry="/mguardar", .playerid=playerid, .params=<"guardar %d %s", itemparam, ItemModel_GetName(itemid)>);
	}

	return 1;
}

CMD:mguardari(playerid, params[])
{
	// Versión explícita para mano izquierda
	new hand = HAND_LEFT;
	new itemid = GetHandItem(playerid, hand);
	if(itemid == 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes nada en la mano izquierda para guardar.");
	if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
	if(Item_IsHandlingCooldownOn(playerid))
		return SendClientMessage(playerid, COLOR_YELLOW2, "¡Debes esperar un tiempo antes de volver a interactuar con otro item!");
	if(!ItemModel_HasTag(itemid, ITEM_TAG_SAVE))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo con este ítem.");

	// Buscar mochila disponible (prioridad: espalda, luego manos)
	new backpack_item, location = -1, container_ref, backpack_idx;

	if(Back_IsCarrying(playerid) == CARRY_TYPE_BACK) {
		backpack_item = Back_GetItem(playerid);
		if(Backpack_IsBackpack(backpack_item)) {
			container_ref = Back_GetParam(playerid);
			location = 0; // espalda
		}
	}
	if(location == -1) {
		new right = GetHandItem(playerid, HAND_RIGHT);
		if(Backpack_IsBackpack(right)) {
			backpack_item = right;
			container_ref = GetHandParam(playerid, HAND_RIGHT);
			location = HAND_RIGHT;
		}
	}
	if(location == -1) {
		new left = GetHandItem(playerid, HAND_LEFT);
		if(Backpack_IsBackpack(left)) {
			backpack_item = left;
			container_ref = GetHandParam(playerid, HAND_LEFT);
			location = HAND_LEFT;
		}
	}

	if(location == -1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes una mochila equipada ni en tus manos.");

	if(ItemModel_GetType(itemid) == ITEM_CONTAINER)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes guardar contenedores dentro de la mochila.");

	if(!Backpack_EnsureContainer(backpack_item, container_ref, backpack_idx)) {
		return SendClientMessage(playerid, COLOR_YELLOW2, "[ERROR] No se pudo inicializar el contenedor de la mochila.");
	}

	new container_id = BackpackData[backpack_idx][bp_ContainerID];

	new itemparam = GetHandParam(playerid, hand);
	if(!Container_AddItemAndParam(container_id, itemid, itemparam))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay espacio suficiente en la mochila / El ítem es demasiado chico.");

	SetHandItemAndParam(playerid, hand, 0, 0);
	Item_ApplyHandlingCooldown(playerid);

	new str[128], param_display[32];
	Backpack_FormatParamDisplay(backpack_item, Container_GetSQLID(container_id), param_display, sizeof(param_display));
	format(str, sizeof(str), "Guardas un/a %s en la mochila. (Espacio %s)", ItemModel_GetName(itemid), param_display);
	PlayerCmeMessage(playerid, 15.0, 5000, str);

	if(ItemModel_GetType(itemid) == ITEM_WEAPON) {
		ServerFormattedLog(LOG_TYPE_ID_WEAPONS, .entry="/mguardari", .playerid=playerid, .params=<"guardar %d %s", itemparam, ItemModel_GetName(itemid)>);
	}

	return 1;
}

//==============================================================================
// Limpieza al desconectar
//==============================================================================

hook OnPlayerDisconnect(playerid, reason) {
	// Limpiar mochilas asociadas al jugador si es necesario
	// (Los contenedores se guardan automáticamente al cerrar)
	return 1;
}

