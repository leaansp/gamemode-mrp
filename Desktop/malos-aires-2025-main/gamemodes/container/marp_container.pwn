#if defined _marp_container_included
	#endinput
#endif
#define _marp_container_included

////////////////////////////////////////////////////////////////////////////////
/*
		ESTRUCTURA DE UN CONTENEDOR USANDO VECTORES DINAMICOS
	 	 _______________________________________________________
	   	|    |    |    |    |    |    |    |    |    |    |    |
		| 0  | 1  | 2  | 3  | 4  | 5  |  6 | 7  | 8  | 9  | ...|
	    |    |    |    |    |    |    |    |    |    |    |    |
     	|____|____|____|____|____|____|____|____|____|____|____|

      0: SQLID del contenedor
      1: Mínimo espacio de item aceptado
      2: Espacio total del contenedor
      3: Espacio usado del contenedor
      4: Item1
      5: Param1
      6: Item2
      7: Param2
      8: Item3
      9: Param3
      ...
*/
////////////////////////////////////////////////////////////////////////////////

#define CONTAINER_TYPE_TRUNK     		1
#define CONTAINER_TYPE_INV  	   		2
#define CONTAINER_TYPE_HOUSE      		3
#define CONTAINER_TYPE_ITEM        		4
#define CONTAINER_TYPE_BELT        		5

#define CONTAINER_INDEX_SQLID			0
#define CONTAINER_INDEX_MIN_ITEM_SPACE  1
#define CONTAINER_INDEX_TOTAL_SPACE 	2
#define CONTAINER_INDEX_USED_SPACE   	3

enum ContainerSelectionInfo {
	csId,
	csType,
	csOriginalId
}

new Container_Selection[MAX_PLAYERS][ContainerSelectionInfo];

new Container_DlgInfoStr[4096];

//==============================================================================

ResetContainerSelection(playerid)
{
   	Container_Selection[playerid][csId] = 0;
	Container_Selection[playerid][csType] = 0;
	Container_Selection[playerid][csOriginalId] = 0;
}

//==============================================================================

stock Container_Load(container_sqlid)
{
	new container_id = vector_create();

	vector_push_back(container_id, container_sqlid); // Guarda la sqlid de si mismo.
	vector_push_back(container_id, 0); // Inicializamos donde se va a guardar el espacio mínimo por item.
	vector_push_back(container_id, 0); // Inicializamos donde se va a guardar el espacio total del contenedor.
	vector_push_back(container_id, 0); // Inicializamos donde se va a guardar el espacio usado del contenedor.

	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "OnContainerDataLoad", "i", container_id @Format: "SELECT `MinItemSpace`,`TotalSpace` FROM `containers_info` WHERE `id`=%i LIMIT 1;", container_sqlid);
	mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "OnContainerSlotsLoad", "i", container_id @Format: "SELECT * FROM `containers_slots` WHERE `id`=%i;", container_sqlid);
	return container_id;
}

//==============================================================================

forward OnContainerDataLoad(container_id);
public OnContainerDataLoad(container_id)
{
	if(cache_num_rows())
	{
		new value;
		cache_get_value_index_int(0, 0, value);
		vector_set(container_id, CONTAINER_INDEX_MIN_ITEM_SPACE, value);
		cache_get_value_index_int(0, 1, value);
		vector_set(container_id, CONTAINER_INDEX_TOTAL_SPACE, value);
	}
	return 1;
}

//==============================================================================

forward OnContainerSlotsLoad(container_id);
public OnContainerSlotsLoad(container_id)
{
	new rows = cache_num_rows();

	for(new i = 0, item_id, param; i < rows; i++)
	{
		cache_get_value_name_int(i, "Item", item_id);
		vector_push_back(container_id, item_id);

		vector_set(container_id, CONTAINER_INDEX_USED_SPACE, vector_get(container_id, CONTAINER_INDEX_USED_SPACE) + ItemModel_GetSpaceSize(item_id));

		cache_get_value_name_int(i, "Param", param);

		if(ItemModel_GetType(item_id) == ITEM_CONTAINER) {
			vector_push_back(container_id, Container_Load(param));
		} else {
			vector_push_back(container_id, param);
		}
	}
	return 1;
}

//==============================================================================

stock Container_Create(total_space, min_item_space, &container_id, &container_sqlid)
{
	if(total_space >= 0) // Espacio válido
	{
        container_id = vector_create();

  		vector_push_back(container_id, 0); // Reservado para su SQLID
		vector_push_back(container_id, min_item_space); // Minimo espacio por item que permite
		vector_push_back(container_id, total_space); // Espacio total
		vector_push_back(container_id, 0); // Espacio usado

		mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "GetContainerInsertedId", "ii", container_id, ref(container_sqlid) @Format: "INSERT INTO containers_info (MinItemSpace, TotalSpace) VALUES (%i,%i);", min_item_space, total_space);
		return 1;
	}

	return 0;
}

forward GetContainerInsertedId(container_id, &container_sqlid);
public GetContainerInsertedId(container_id, &container_sqlid)
{
	new last_id = cache_insert_id();
	container_sqlid = last_id;
	vector_set(container_id, CONTAINER_INDEX_SQLID, last_id);
	return 1;
}

//==============================================================================

stock Container_Fully_Destroy(id, container_sqlid)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
	{
		new vec_size = vector_size(id);

		for(new i = 4; i < vec_size; i += 2) // Para todos los items almacenados en el vector que simula el contenedor
		{
		    if(ItemModel_GetType(vector_get(id, i)) == ITEM_CONTAINER) // Como "i" cae en los items, obtenemos el valor en posicion "i" y nos fijamos
			{
			    Container_Fully_Destroy(vector_get(id, i+1), Container_GetSQLID(vector_get(id, i+1))); // Los items CONTAINER, en su parametro guardan la id del vector real de ejecucion de su contenedor
			}
		}
		
		mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "DELETE FROM `containers_info` WHERE `id`=%i;", container_sqlid);
		mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "DELETE FROM `containers_slots` WHERE `id`=%i;", container_sqlid);

		vector_clear(id);
		return 1;
	}

	return 0;
}

//==============================================================================

stock Container_Destroy(id)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
	{
	    new vec_size = vector_size(id);
	    
		for(new i = 4; i < vec_size; i += 2) // Para todos los items almacenados en el vector que simula el contenedor
		{
		    if(ItemModel_GetType(vector_get(id, i)) == ITEM_CONTAINER) // Como "i" cae en los items, obtenemos el valor en posicion "i" y nos fijamos
			{
			    Container_Destroy(vector_get(id, i+1)); // Los items CONTAINER, en su parametro guardan la id del vector real de ejecucion de su contenedor
			}
		}
		vector_clear(id);
		return 1;
	}

	return 0;
}

//==============================================================================

stock Container_AddUsedSpace(id, space)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
	{
		vector_set(id, CONTAINER_INDEX_USED_SPACE, vector_get(id, CONTAINER_INDEX_USED_SPACE) + space);
		return 1;
	}

	return 0;
}

//==============================================================================

stock Container_GetTotalSpace(id)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
     return vector_get(id, CONTAINER_INDEX_TOTAL_SPACE);

	return 0;
}

//==============================================================================

stock Container_SetTotalSpace(id, total_space)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
	{
	    vector_set(id, CONTAINER_INDEX_TOTAL_SPACE, total_space);
		mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "UPDATE `containers_info` SET `TotalSpace`=%i WHERE `id`=%i;", total_space, Container_GetSQLID(id));
		return 1;
	}
	
	return 0;
}

//==============================================================================

stock Container_GetUsedSpace(id)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
	    return vector_get(id, CONTAINER_INDEX_USED_SPACE);

	return 99999;
}

//==============================================================================

stock Container_GetFreeSpace(id)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
	{
		return vector_get(id, CONTAINER_INDEX_TOTAL_SPACE) - vector_get(id, CONTAINER_INDEX_USED_SPACE);
	}
	return 0;
}

//==============================================================================

stock Container_GetElementsAmount(id)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
	    return (vector_size(id) - 4) / 2;

	return 0;
}

//==============================================================================

stock Container_GetSQLID(id)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
	    return vector_get(id, CONTAINER_INDEX_SQLID);

	return 0;
}

//==============================================================================

stock Container_GetMinItemSpace(id)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
	    return vector_get(id, CONTAINER_INDEX_MIN_ITEM_SPACE);

	return 0;
}

//==============================================================================

stock Container_SlotToVecIndex(container_slot)
{
	return (container_slot + 2) * 2;
}

//==============================================================================

stock Container_VecIndexToSlot(vec_index)
{
	return (vec_index - 4) / 2;
}

//==============================================================================

stock Container_GetItem(id, slot)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
	{
		if(slot < 0 || slot >= Container_GetElementsAmount(id)) // Slot inválido
	        return 0;

		return vector_get(id, Container_SlotToVecIndex(slot));
	}
	
	return 0;
}

//==============================================================================

stock Container_GetParam(id, slot)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
	{
		if(slot < 0 || slot >= Container_GetElementsAmount(id)) // Slot inválido
	        return 0;

		return vector_get(id, Container_SlotToVecIndex(slot));
	}

	return 0;
}

//==============================================================================

stock Container_SearchItem(id, itemid)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
	{
	    new aux = Container_GetElementsAmount(id);
	    
	    for(new i = 0; i < aux; i++)
	    {
	    	if(vector_get(id, Container_SlotToVecIndex(i)) == itemid)
	    	    return i;
		}
	}

	return -1;
}

//==============================================================================

stock Container_Empty_Weapons(id)
{
    if(id > 0 && vector_size(id) > 3)
    {
  		new query[128];
        new vec_sqlid = vector_get(id, CONTAINER_INDEX_SQLID);
		new vec_size = vector_size(id);

		for(new i = 4; i < vec_size; i += 2) // Para todos los items almacenados en el vector que simula el contenedor
		{
		    if(ItemModel_GetType(vector_get(id, i)) == ITEM_WEAPON) // Como "i" cae en los items, obtenemos el valor en posicion "i" y nos fijamos
			{
			    vector_set(id, CONTAINER_INDEX_USED_SPACE, vector_get(id, CONTAINER_INDEX_USED_SPACE) - ItemModel_GetSpaceSize(vector_get(id, i)));
			    mysql_format(MYSQL_HANDLE, query, sizeof(query), "DELETE FROM `containers_slots` WHERE `id`=%i AND `Item`=%i AND `Param`=%i LIMIT 1;", vec_sqlid, vector_get(id, i), vector_get(id, i+1)); // Guardamos
                mysql_tquery(MYSQL_HANDLE, query);
				vector_remove(id, i); // Remueve item.
			    vector_remove(id, i); // Al remover item, param cae a la pos de item, por lo tanto borramos la misma.
			    vec_size = vec_size - 2;
			    i = i - 2;
			}
		}
		return 1;
	}

	return 0;
}

//==============================================================================

stock Container_Empty_Drugs(id)
{
    if(id > 0 && vector_size(id) > 3)
    {
  		new query[128];
        new vec_sqlid = vector_get(id, CONTAINER_INDEX_SQLID);
		new vec_size = vector_size(id);

		for(new i = 4; i < vec_size; i += 2) // Para todos los items almacenados en el vector que simula el contenedor
		{
		    if(ItemModel_GetType(vector_get(id, i)) == ITEM_DRUG) // Verificamos si es droga
			{
			    vector_set(id, CONTAINER_INDEX_USED_SPACE, vector_get(id, CONTAINER_INDEX_USED_SPACE) - ItemModel_GetSpaceSize(vector_get(id, i)));
			    mysql_format(MYSQL_HANDLE, query, sizeof(query), "DELETE FROM `containers_slots` WHERE `id`=%i AND `Item`=%i AND `Param`=%i LIMIT 1;", vec_sqlid, vector_get(id, i), vector_get(id, i+1));
                mysql_tquery(MYSQL_HANDLE, query);
				vector_remove(id, i); // Remueve item.
			    vector_remove(id, i); // Al remover item, param cae a la pos de item, por lo tanto borramos la misma.
			    vec_size = vec_size - 2;
			    i = i - 2;
			}
		}
		return 1;
	}

	return 0;
}

//==============================================================================

stock Container_Empty(id)
{
    if(id > 0 && vector_size(id) > 3)
    {
        new vec_sqlid = vector_get(id, CONTAINER_INDEX_SQLID);
		new vec_min_item_space = vector_get(id, CONTAINER_INDEX_MIN_ITEM_SPACE);
		new vec_total_space = vector_get(id, CONTAINER_INDEX_TOTAL_SPACE);
		new vec_size = vector_size(id);
		
		for(new i = 4; i < vec_size; i += 2) // Para todos los items almacenados en el vector que simula el contenedor
		{
		    if(ItemModel_GetType(vector_get(id, i)) == ITEM_CONTAINER) // Como "i" cae en los items, obtenemos el valor en posicion "i" y nos fijamos
			{
			    Container_Fully_Destroy(vector_get(id, i+1), Container_GetSQLID(vector_get(id, i+1))); // Los items CONTAINER, en su parametro guardan la id del vector real de ejecucion de su contenedor
			}
		}

		mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "DELETE FROM `containers_slots` WHERE `id`=%i;", vec_sqlid);
	    
		vector_clear(id);
		vector_push_back(id, vec_sqlid);
		vector_push_back(id, vec_min_item_space);
		vector_push_back(id, vec_total_space);
		vector_push_back(id, 0);
		return 1;
	}

	return 0;
}

//==============================================================================

stock Container_AddItemAndParam(id, item, param)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
	{
	    if(ItemModel_GetSpaceSize(item) < Container_GetMinItemSpace(id))
	        return 0;
		if(Container_GetFreeSpace(id) < ItemModel_GetSpaceSize(item)) // No hay espacio para meter el peso del item
		    return 0;

		vector_push_back(id, item);
		vector_push_back(id, param);

		Container_AddUsedSpace(id, ItemModel_GetSpaceSize(item));

		Container_UpdateOpenedDialogs(id);

		if(ItemModel_GetType(item) == ITEM_CONTAINER) {
			mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "INSERT INTO `containers_slots` (`id`,`Item`,`Param`) VALUES (%i,%i,%i);", Container_GetSQLID(id), item, Container_GetSQLID(param));
		} else {
			mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "INSERT INTO `containers_slots` (`id`,`Item`,`Param`) VALUES (%i,%i,%i);", Container_GetSQLID(id), item, param);
		}
		return 1;
	}

	return 0;
}

//==============================================================================

stock Container_TakeItem(id, slot, &item, &param)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
	{
	    if(slot < 0 || slot >= Container_GetElementsAmount(id)) // Slot inválido
	        return 0;

		new vec_index = Container_SlotToVecIndex(slot);

		item = vector_get(id, vec_index);
	    param = vector_get(id, vec_index + 1);

		vector_remove(id, vec_index);
		vector_remove(id, vec_index);

		Container_AddUsedSpace(id, -ItemModel_GetSpaceSize(item));
		Container_UpdateOpenedDialogs(id);

		if(ItemModel_GetType(item) == ITEM_CONTAINER) {
			mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "DELETE FROM `containers_slots` WHERE `id`=%i AND `Item`=%i AND `Param`=%i LIMIT 1;", Container_GetSQLID(id), item, Container_GetSQLID(param));
		} else {
			mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "" @Format: "DELETE FROM `containers_slots` WHERE `id`=%i AND `Item`=%i AND `Param`=%i LIMIT 1;", Container_GetSQLID(id), item, param);
		}
		return 1;
	}

	return 0;
}

//==============================================================================

stock Container_UpdateOpenedDialogs(id)
{
	foreach(new playerid : Player)
	{
	    if(Container_Selection[playerid][csId] == id && Dialog_IsOpened(playerid)) // Si tiene abierto el dialog de ese contenedor
	    {
	        Dialog_Close(playerid);
		    Container_Show(Container_Selection[playerid][csOriginalId], Container_Selection[playerid][csType], id, playerid);
		}
	}
}

//==============================================================================

stock Container_Show(origid, type, id, playerid, interact=1)
{
	if(id > 0 && vector_size(id) > 3) // Está creado (tiene al menos los 3 elementos que se generan al crearlo)
	{
	    new callback[32], title[64];

		switch(type)
		{
			case CONTAINER_TYPE_TRUNK:
			{
				strcat(callback, "Dlg_Show_Trunk_Container", sizeof(callback));
				strcat(title, "[MALETERO]", sizeof(title));
			}
			case CONTAINER_TYPE_INV:
			{
				strcat(callback, "Dlg_Show_Inv_Container", sizeof(callback));
				strcat(title, "[INVENTARIO]", sizeof(title));
			}
			case CONTAINER_TYPE_HOUSE:
			{
				strcat(callback, "Dlg_Show_House_Container", sizeof(callback));
				strcat(title, "[ARMARIO]", sizeof(title));
			}
			case CONTAINER_TYPE_ITEM:
			{
				strcat(callback, "Dlg_Show_Item_Container", sizeof(callback));
				strcat(title, "[ITEM]", sizeof(title));
			}
			case CONTAINER_TYPE_BELT:
			{
				strcat(callback, "Dlg_Show_Belt_Container", sizeof(callback));
				strcat(title, "[CINTURON]", sizeof(title));
			}
			default: return 0;
		}

	    if(Container_GetElementsAmount(id) > 0)
	    {
			Container_DlgInfoStr = "[#]\tItem\tDetalle\tEspacio\n";

			new vsize = vector_size(id), slot = 0, item, param;

			for(new i = 4, line[128]; i < vsize; i += 2)
			{
			    item = vector_get(id, i);
			    param = vector_get(id, i+1);

				if(ItemModel_GetType(item) == ITEM_CONTAINER) {
					format(line, sizeof(line), "[%i]\t%s\tUsado: %i / %i\t%i\n", slot, ItemModel_GetName(item), Container_GetUsedSpace(param), Container_GetTotalSpace(param), ItemModel_GetSpaceSize(item));
				} else {
					format(line, sizeof(line), "[%i]\t%s\t%s: %i\t%i\n", slot, ItemModel_GetName(item), ItemModel_GetParamName(item), param, ItemModel_GetSpaceSize(item));
				}

			    strcat(Container_DlgInfoStr, line, sizeof(Container_DlgInfoStr));
	            slot++;
			}

			format(title, sizeof(title), "%s Usado: %i / %i", title, Container_GetUsedSpace(id), Container_GetTotalSpace(id));

			if(interact) {
				Dialog_Open(playerid, callback, DIALOG_STYLE_TABLIST_HEADERS, title, Container_DlgInfoStr, "Tomar", "Cerrar");
			} else {
				Dialog_Open(playerid, "Dlg_Print_Container", DIALOG_STYLE_TABLIST_HEADERS, title, Container_DlgInfoStr, "Cerrar", "");
			}
		}
		else
		{
			format(title, sizeof(title), "%s Usado: %i / %i", title, Container_GetUsedSpace(id), Container_GetTotalSpace(id));
			Dialog_Show(playerid, DLG_SHOW_EMPTY_CONTAINER, DIALOG_STYLE_MSGBOX, title, "Vacío", "Cerrar", "");
		}

		if(interact)
		{
			Container_Selection[playerid][csId] = id;
			Container_Selection[playerid][csOriginalId] = origid;
			Container_Selection[playerid][csType] = type;
		}
		return 1;
	}

	return 0;
}
