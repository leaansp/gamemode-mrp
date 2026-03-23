#if defined marp_furniture_model_inc
	#endinput
#endif
#define marp_furniture_model_inc

#include <YSI_Coding\y_hooks>

/*
	   ___                                  __      __      __       __       
	  / _/__ __ ____ ___     __ _  ___  ___/ /___  / /  ___/ /___ _ / /_ ___ _
	 / _// // // __// _ \   /  ' \/ _ \/ _  // -_)/ /  / _  // _ `// __// _ `/
	/_/  \_,_//_/  /_//_/  /_/_/_/\___/\_,_/ \__//_/   \_,_/ \_,_/ \__/ \_,_/ 

*/                                                                          

#define FURN_MODEL_MAX_AMOUNT 2048
#define FURN_MODEL_MAX_NAME_LEN 48

enum e_FURN_DATA
{
	fuName[FURN_MODEL_MAX_NAME_LEN],
	fuModelid,
	fuPrice,
	fuCategory
}

new FurnModelData[FURN_MODEL_MAX_AMOUNT][e_FURN_DATA];

FurnModel_IsValidId(furnmodelid) {
	return (0 < furnmodelid < FURN_MODEL_MAX_AMOUNT && FurnModelData[furnmodelid][fuModelid]);
}

static FurnModel_IsValidRawId(furnmodelid) {
	return (0 < furnmodelid < FURN_MODEL_MAX_AMOUNT);
}

/*
	   ___                               __                                    __       __       
	  / _/__ __ ____ ___     ____ ___ _ / /_ ___  ___ _ ___   ____ __ __   ___/ /___ _ / /_ ___ _
	 / _// // // __// _ \   / __// _ `// __// -_)/ _ `// _ \ / __// // /  / _  // _ `// __// _ `/
	/_/  \_,_//_/  /_//_/   \__/ \_,_/ \__/ \__/ \_, / \___//_/   \_, /   \_,_/ \_,_/ \__/ \_,_/ 
	                                            /___/            /___/                           

*/

#define FURN_CATEG_MAX_NAME_LEN 32

static enum
{
	/*0*/ FURN_CATEG_TABLE,
	/*1*/ FURN_CATEG_BEDROOM,
	/*2*/ FURN_CATEG_LIGHTING,
	/*3*/ FURN_CATEG_BATH,
	/*4*/ FURN_CATEG_WALL,
	/*5*/ FURN_CATEG_DOOR,
	/*6*/ FURN_CATEG_FRAMES,
	/*7*/ FURN_CATEG_KITCHEN,
	/*8*/ FURN_CATEG_ELECTRO,
	/*9*/ FURN_CATEG_ENTERTAINMENT,
	/*10*/ FURN_CATEG_APPLIANCE,
	/*11*/ FURN_CATEG_OTHER,
	/*12*/ FURN_CATEG_WALL_SPECIAL,
	/*13*/ FURN_CATEG_KITCHEN_DECO,
	/*14*/ FURN_CATEG_FOOD,
	/*15*/ FURN_CATEG_SOFA,
	/*16*/ FURN_CATEG_SIGNS,
	/*17*/ FURN_CATEG_BIZ_COUNTER,
	/*18*/ FURN_CATEG_PLANTS,
	/*19*/ FURN_CATEG_BEDROOM_DECO,
	/*20*/ FURN_CATEG_OFFICE_WORK,
	/*21*/ FURN_CATEG_EXTERIOR,

	/*LEAVE LAST*/ FURN_CATEG_AMOUNT
}

static enum e_FURN_CATEG_DATA
{
	List:e_FURN_CATEG_MODELS,
	e_FURN_CATEG_NAME[FURN_CATEG_MAX_NAME_LEN],
}

static FurnCategData[FURN_CATEG_AMOUNT][e_FURN_CATEG_DATA] = {
	/*0*/ {INVALID_LIST, "Mesas y sillas"},
	/*1*/ {INVALID_LIST, "Dormitorio"},
	/*2*/ {INVALID_LIST, "Iluminación"},
	/*3*/ {INVALID_LIST, "Baño"},
	/*4*/ {INVALID_LIST, "Paredes"},
	/*5*/ {INVALID_LIST, "Puertas"},
	/*6*/ {INVALID_LIST, "Colgantes"},
	/*7*/ {INVALID_LIST, "Muebles de cocina"},
	/*8*/ {INVALID_LIST, "Electrónica"},
	/*9*/ {INVALID_LIST, "Entretenimiento"},
	/*10*/ {INVALID_LIST, "Electrodomésticos"},
	/*11*/ {INVALID_LIST, "Otros"},
	/*12*/ {INVALID_LIST, "Especiales de construcción"},
	/*13*/ {INVALID_LIST, "Decoración de cocina"},
	/*14*/ {INVALID_LIST, "Alimentos"},
	/*15*/ {INVALID_LIST, "Sillones"},
	/*16*/ {INVALID_LIST, "Carteles"},
	/*17*/ {INVALID_LIST, "Estanterías y exhibidores"},
	/*18*/ {INVALID_LIST, "Plantas"},
	/*19*/ {INVALID_LIST, "Decoración de dormitorio"},
	/*20*/ {INVALID_LIST, "Oficina y trabajo"},
	/*21*/ {INVALID_LIST, "Exterior"}
};

FurnModel_SQLCreate(playerid, const name[64], modelid, price, category)
{
	new query[256];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO `furn_model` (`name`, `modelid`, `price`, `category`) VALUES ('%e', %i, %i, %i);", name, modelid, price, category);
	mysql_query(MYSQL_HANDLE, query);
	FurnModel_LoadIdsRange(1, FURN_MODEL_MAX_AMOUNT - 1); // Siempre se van a buscar entre todas las IDs.
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Agregaste el mueble %s - Mod.: %i - Precio: %i - Cat.: %s.", name, modelid, price, FurnCategData[category][e_FURN_CATEG_NAME]);
}

// const FURN_CATEG_AMOUNT = sizeof(FurnCategData);

static FurnCateg_IsValidId(cat) {
	return (0 <= cat < FURN_CATEG_AMOUNT);
}

/*
	   ___                                  __      __   __               __
	  / _/__ __ ____ ___     __ _  ___  ___/ /___  / /  / /___  ___ _ ___/ /
	 / _// // // __// _ \   /  ' \/ _ \/ _  // -_)/ /  / // _ \/ _ `// _  / 
	/_/  \_,_//_/  /_//_/  /_/_/_/\___/\_,_/ \__//_/  /_/ \___/\_,_/ \_,_/  
	                                                                                                                
*/

hook OnGameModeInitEnded()
{
	FurnModel_LoadIdsRange(1, FURN_MODEL_MAX_AMOUNT - 1);
	return 1;
}

static FurnModel_LoadIdsRange(fromid, toid, notifyPlayerid = INVALID_PLAYER_ID)
{
	printf("[INFO] Cargando modelos de muebles %i a %i...", fromid, toid);

	new query[150];
	mysql_format(MYSQL_HANDLE, query, sizeof(query), "SELECT `furnmodelid`,`name`,`modelid`,`price`,`category` FROM `furn_model` WHERE `furnmodelid` >= %i AND `furnmodelid` <= %i;", fromid, toid);
	mysql_tquery(MYSQL_HANDLE, query, "FurnModel_OnDataLoaded", "i", notifyPlayerid);
}

forward FurnModel_OnDataLoaded(notifyPlayerid);
public FurnModel_OnDataLoaded(notifyPlayerid)
{
	new rows = cache_num_rows(),
		rebuild[FURN_CATEG_AMOUNT];
	
	for(new i, furnmodelid, cat; i < rows; i++)
	{
		cache_get_value_index_int(i, 0, furnmodelid);

		if(!FurnModel_IsValidRawId(furnmodelid))
		{
			printf("[ERROR] Se ha encontrado un mueble con ID invalida. Se descarta el mueble ID %i.", furnmodelid);
			continue;
		}

		cache_get_value_index(i, 1, FurnModelData[furnmodelid][fuName], FURN_MODEL_MAX_NAME_LEN);
		cache_get_value_index_int(i, 2, FurnModelData[furnmodelid][fuModelid]);
		cache_get_value_index_int(i, 3, FurnModelData[furnmodelid][fuPrice]);
		cache_get_value_index_int(i, 4, cat);

		if(!FurnCateg_IsValidId(cat))
		{
			FurnModelData[furnmodelid][fuCategory] = FURN_CATEG_OTHER;
			printf("[ERROR] Se ha encontrado la categoria invalida %i para el mueble ID %i. Se lo asocia a la categoria %i (%s).", cat, furnmodelid, FURN_CATEG_OTHER, FurnCategData[FURN_CATEG_OTHER][e_FURN_CATEG_NAME]);
		} else {
			FurnModelData[furnmodelid][fuCategory] = cat;
		}

		rebuild[FurnModelData[furnmodelid][fuCategory]]++;
	}

	printf("[INFO] Carga de %i modelos de mueble finalizada.", rows);

	if(IsPlayerLogged(notifyPlayerid)) {
		SendFMessage(notifyPlayerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" Carga de %i modelos de mueble finalizada correctamente.", rows);
	}

	FurnCateg_RebuildIds(rebuild, notifyPlayerid);
	return 1;
}

static FurnCateg_RebuildList(cat)
{
	if(list_valid(FurnCategData[cat][e_FURN_CATEG_MODELS])) {
		list_clear(FurnCategData[cat][e_FURN_CATEG_MODELS]);
	} else {
		FurnCategData[cat][e_FURN_CATEG_MODELS] = PMM_NewItemList();
	}
}

static FurnCateg_RebuildIds(rebuild[FURN_CATEG_AMOUNT], notifyPlayerid)
{
	new count;

	/* Para cada categoría recibida, si tenemos que reconstruirla, la vaciamos, de lo contrario queda inalterada */

	for(new cat; cat < FURN_CATEG_AMOUNT; cat++)
	{
		if(rebuild[cat])
		{
			FurnCateg_RebuildList(cat);
			count++;
		}
	}

	/* Recorremos los muebles y vamos reconstruyendo las Categorías solicitadas */

	if(count)
	{
		for(new furnmodelid; furnmodelid < FURN_MODEL_MAX_AMOUNT; furnmodelid++)
		{
			if(FurnModelData[furnmodelid][fuModelid] && rebuild[FurnModelData[furnmodelid][fuCategory]]) {
				FurnCateg_AddModel(furnmodelid, FurnModelData[furnmodelid][fuCategory]);
			}
		}
	}

	printf("[INFO] Reconstruccion de %i categorias de muebles finalizada.", count);

	if(IsPlayerLogged(notifyPlayerid)) {
		SendFMessage(notifyPlayerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" Reconstruccion de %i categorias de muebles finalizada.", count);
	}
}

static FurnCateg_AddModel(furnmodelid, cat)
{
	new desc[PMM_MAX_DESC_LENGTH];
	format(desc, sizeof(desc), "%s $%i", FurnModelData[furnmodelid][fuName], FurnModelData[furnmodelid][fuPrice]);
	PMM_AddItem(FurnCategData[cat][e_FURN_CATEG_MODELS], .modelid = FurnModelData[furnmodelid][fuModelid], .desc = desc, .extraid = furnmodelid, .convertdesc = true);
}

static FurnCateg_GetSize(cat) {
	return (list_valid(FurnCategData[cat][e_FURN_CATEG_MODELS])) ? (list_size(FurnCategData[cat][e_FURN_CATEG_MODELS])) : (0);
}

CMD:amuebleagregar(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	static furnModelReloadCooldown;

	new modelid, price, category, name[64];

	if(sscanf(params, "iiis[64]", modelid, price, category, name))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/amuebleagregar [modelo] [precio] [categoría] [nombre]");
	if(!FurnCateg_IsValidId(category))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ingresaste una categoría inválida.");
	if(gettime() < furnModelReloadCooldown)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar un tiempo para volver a usar el comando.");

	FurnModel_SQLCreate(playerid, name, modelid, price, category);
	furnModelReloadCooldown = gettime() + 3;
	return 1;
}

CMD:amueblesrecargar(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	static furnModelReloadCooldown;

	new fromid, toid;

	if(sscanf(params, "ii", fromid, toid))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/amueblesrecargar [desde ID de mueble] [hasta ID de mueble]. Ejemplo: '/amueblesrecargar 1200 1215'.");
	if(!FurnModel_IsValidRawId(fromid) || !FurnModel_IsValidRawId(toid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Alguna ID es inválida. Actualmente el sistema soporta IDs en el rango [1-"#FURN_MODEL_MAX_AMOUNT").");
	if(fromid > toid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Rango de IDs inválido.");
	if(gettime() < furnModelReloadCooldown)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar un tiempo para volver a usar el comando.");

	FurnModel_LoadIdsRange(fromid, toid, .notifyPlayerid = playerid);
	furnModelReloadCooldown = gettime() + 60;
	return 1;
}


/*
	   ___                               __                                                                            _ 
	  / _/__ __ ____ ___     ____ ___ _ / /_ ___  ___ _ ___   ____ __ __   __ _  ___  ___  __ __   ____   ___ _ __ __ (_)
	 / _// // // __// _ \   / __// _ `// __// -_)/ _ `// _ \ / __// // /  /  ' \/ -_)/ _ \/ // /  /___/  / _ `// // // / 
	/_/  \_,_//_/  /_//_/   \__/ \_,_/ \__/ \__/ \_, / \___//_/   \_, /  /_/_/_/\__//_//_/\_,_/          \_, / \_,_//_/  
	                                            /___/            /___/                                  /___/            
*/

FurnCateg_ShowAllMenu(playerid)
{
	new string[FURN_CATEG_MAX_NAME_LEN * FURN_CATEG_AMOUNT], line[64];

	for(new cat; cat < FURN_CATEG_AMOUNT; cat++)
	{
		format(line, sizeof(line), "%s (%i)\n", FurnCategData[cat][e_FURN_CATEG_NAME], FurnCateg_GetSize(cat));
		strcat(string, line, sizeof(string));
	}

	Dialog_Open(playerid, "DLG_FURN_CATEG_MENU", DIALOG_STYLE_LIST, "Categorías", string, "Continuar", "Volver");
	return 1;
}

Dialog:DLG_FURN_CATEG_MENU(playerid, response, listitem, inputtext[])
{
	if(!response || !FurnCateg_IsValidId(listitem))
		return Furn_ShowMainMenu(playerid);

	SetTimerEx("FurnCateg_ShowBuyMenu", 250, false, "ii", playerid, listitem);
	return 1;
}

forward FurnCateg_ShowBuyMenu(playerid, cat);
public FurnCateg_ShowBuyMenu(playerid, cat)
{
	if(!IsPlayerLogged(playerid))
		return 0;

	new catsize;

	if(!FurnCateg_IsValidId(cat) || !(catsize = FurnCateg_GetSize(cat)))
		return FurnCateg_ShowAllMenu(playerid);

	new title[64];
	format(title, sizeof(title), "%s (%i)", FurnCategData[cat][e_FURN_CATEG_NAME], catsize);
	PMM_ShowForPlayer(playerid, "Furn_CategoryMenuResponse", .itemList = FurnCategData[cat][e_FURN_CATEG_MODELS], .title = title, .deleteMenuDataWhenClosed = false);
	return 1;
}