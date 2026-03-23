#if defined marp_concesionaria_inc
	#endinput
#endif
#define marp_concesionaria_inc

#include <YSI_Coding\y_hooks>

//=================================CONSTANTES===================================

#define MAX_DEALERSHIPS         7
#define MAX_DEALERSHIP_VEHICLES 30

#define DEALERSHIP_GROTTI       0
#define DEALERSHIP_JEFFERSON    1
#define DEALERSHIP_PINAR     	2
#define DEALERSHIP_CIUDADMOTO   3
#define DEALERSHIP_FREDDI     	4
#define DEALERSHIP_GABOTT     	5
#define DEALERSHIP_HAUL      	6

#define MODEL_CREATE            1
#define MODEL_DELETE            2

#define DEALERSHIP_PAYMENT_CASH 1
#define DEALERSHIP_PAYMENT_BANK 2

//=================================VARIABLES====================================

enum DealershipInfo {
	dName[32],
	Float:dX, // Donde está la concesionaria y su pickup
	Float:dY,
	Float:dZ,
	Float:dParkingX, // Donde va a aparecer el auto estacionado una vez comprado
	Float:dParkingY,
	Float:dParkingZ,
	Float:dParkingAngle
}
static const Dealership[MAX_DEALERSHIPS][DealershipInfo] = {
	{"Concesionarios Bracone", 542.61, -1298.90, 17.24, 546.86, -1266.70, 16.86, 302.50},
	{"Autos Valadares", 2131.77, -1150.91, 24.02, 2128.34, -1135.81, 25.16, 355.38},
	{"Pinar Automotores", 975.50, -1131.89, 23.82, 982.11, -1105.00, 23.82, 88.67},
	{"Ciudad Moto",  1293.07, -1860.04, 13.5, 1295.81, -1856.41, 13.38},
	{"Freddi Aviones", 1921.14, -2235.02, 13.54, 1903.13, -2315.69, 13.18, 218.39},
	{"Nautica Gabott", 2939.37, -2051.45, 3.54, 2937.79, -2064.40, 0.09, 271.84},
	{"Scania Group", 2219.69, -2172.86, 13.54, 2219.23, -2178.56, 14.04, 45.25}
};

new DealershipVehicles[MAX_DEALERSHIPS][MAX_DEALERSHIP_VEHICLES];

new PlayerText:PTD_Concesionaria[MAX_PLAYERS][2];

new carModelSelection[MAX_PLAYERS],
	carColor1Selection[MAX_PLAYERS],
	carColor2Selection[MAX_PLAYERS],
	carPaymentSelection[MAX_PLAYERS];

//============================FUNCIONES PUBLICAS================================

GetNearestDealership(playerid, Float:distance)
{
	for(new i = 0; i < MAX_DEALERSHIPS; i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, distance, Dealership[i][dX], Dealership[i][dY], Dealership[i][dZ]))
	        return i;
	}
	return -1;
}

hook OnGameModeInitEnded()
{
	for(new i; i < MAX_DEALERSHIPS; i++) {
		mysql_f_tquery(MYSQL_HANDLE, 128, @Callback: "OnDealershipDataLoad", "i", i @Format: "SELECT * FROM `dealerships_info` WHERE `Id`=%i LIMIT %i;", i, MAX_DEALERSHIP_VEHICLES);
	}

	for(new i, str[128]; i < MAX_DEALERSHIPS; i++)
	{
		CreateDynamicPickup(1239, 1, Dealership[i][dX], Dealership[i][dY], Dealership[i][dZ]);
		format(str, sizeof(str), "%s\nEscribe '/comprar' para ver los vehículos en venta.", Dealership[i][dName]);
		CreateDynamic3DTextLabel(str, COLOR_WHITE, Dealership[i][dX], Dealership[i][dY], Dealership[i][dZ] + 0.75, .drawdistance = 20.0, .testlos = 1, .streamdistance = 20.0);
	}

	return 1;
}

forward OnDealershipDataLoad(dealership);
public OnDealershipDataLoad(dealership)
{
	new rows = cache_num_rows();

	for(new i; i < rows; i++) {
		cache_get_value_name_int(i, "Model", DealershipVehicles[dealership][i]);
	}
	return 1;
}

forward Dealership_SaveModel(dealership, dealershipSlot, option);
public Dealership_SaveModel(dealership, dealershipSlot, option)
{
	if(option == MODEL_CREATE) {
		mysql_f_tquery(MYSQL_HANDLE, 256, @Callback: "" @Format: "INSERT INTO `dealerships_info` (`Id`,`Model`) VALUES (%i,%i);", dealership, DealershipVehicles[dealership][dealershipSlot]);
	} else if(option == MODEL_DELETE) {
		mysql_f_tquery(MYSQL_HANDLE, 256, @Callback: "" @Format: "DELETE FROM `dealerships_info` WHERE `Id`=%i AND `Model`=%i;", dealership, DealershipVehicles[dealership][dealershipSlot]);
	}
	return 1;
}


Dealership_SearchCar(dealership, modelid)
{
	if(dealership >= 0 && dealership < MAX_DEALERSHIPS)
	{
		for(new i = 0; i < MAX_DEALERSHIP_VEHICLES; i++)
		{
		    if(DealershipVehicles[dealership][i] == modelid)
		        return i;
		}
	}
	return -1;
}

CMD:agregarmodelo(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new dealership, modelid;

	if(sscanf(params, "ii", dealership, modelid))
	{
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/agregarmodelo [ID concesionaria] [modelo]");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"IDS de concesionarias: {ffffff}0.Concesionarios Bracone | 1.Autos Valadares | 2.Pinar | 3.Ciudad moto | 4.Freddi | 5.Gabott | 6.Scania");
		return 1;
	}
	if(dealership < 0 || dealership >= MAX_DEALERSHIPS)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de concesionaria inválida.");
	if(modelid < 400 || modelid > 611)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de modelo inválida.");
	if(GetNearestDealership(playerid, 1.0) != dealership)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Para usar este comando debes estar en la concesionaria.");

	for(new i = 0; i < MAX_DEALERSHIP_VEHICLES; i++)
	{
	    if(DealershipVehicles[dealership][i] == modelid)
	    {
	        SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El modelo %d (%s) ya se encuentra a la venta en la concesionaria ID %d (%s).", modelid, Veh_GetModelName(modelid), dealership, Dealership[dealership][dName]);
            return 1;
		}
	}
	
	for(new x = 0; x < MAX_DEALERSHIP_VEHICLES; x++)
	{
	    if(DealershipVehicles[dealership][x] == 0)
	    {
	        DealershipVehicles[dealership][x] = modelid;
	    	SendFMessage(playerid, COLOR_WHITE, "Has agregado el modelo %d (%s) en la concesionaria ID %d (%s).", modelid, Veh_GetModelName(modelid), dealership, Dealership[dealership][dName]);
            Dealership_SaveModel(dealership, x, MODEL_CREATE);
			return 1;
		}
	}
	
	SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay más espacio (MAX:%d) para otro modelo a la venta en la consecionaria ID %d (%s).", MAX_DEALERSHIP_VEHICLES, dealership, Dealership[dealership][dName]);
	return 1;
}

CMD:borrarmodelo(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 20)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Development o superior para usar este comando.");

	new dealership, modelid;

	if(sscanf(params, "ii", dealership, modelid))
	{
		SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/borrarmodelo [ID concesionaria] [ID del modelo]");
		SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"IDS de concesionarias: {ffffff}0.Grotti | 1.Jefferson | 2.Pinar | 3.Ciudad moto | 4.Freddi | 5.Gabott | 6.RS Haul");
		return 1;
	}
	
	if(dealership < 0 || dealership >= MAX_DEALERSHIPS)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de concesionaria inválida.");
	if(modelid < 400 || modelid > 611)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID de modelo inválida.");
	if(GetNearestDealership(playerid, 1.0) != dealership)
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Para usar este comando debes estar en la concesionaria.");

	for(new i = 0; i < MAX_DEALERSHIP_VEHICLES; i++)
	{
	    if(DealershipVehicles[dealership][i] == modelid)
	    {
	        Dealership_SaveModel(dealership, i, MODEL_DELETE);
            DealershipVehicles[dealership][i] = 0;
	        SendFMessage(playerid, COLOR_WHITE, "El modelo %d (%s) ha sido quitado de venta de la concesionaria ID %d (%s).", modelid, Veh_GetModelName(modelid), dealership, Dealership[dealership][dName]);
		    return 1;
		}
	}

	SendFMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"el modelo %d (%s) no se encuentra a la venta en la concesionaria ID %d (%s).", modelid, Veh_GetModelName(modelid), dealership, Dealership[dealership][dName]);
	return 1;
}

hook function OnPlayerCmdComprar(playerid, const params[])
{
	new dealership = GetNearestDealership(playerid, 1.0);

	if(dealership == -1)
		return continue(playerid, params);

	ShowPlayerDealershipCatalog(playerid, dealership);
	return 1;
}

ShowPlayerDealershipCatalog(playerid, dealership)
{
	new count, string[2048] = "Modelo\tPrecio\tMaletero (espacio)";

	for(new i = 0, modelid, line[128]; i < MAX_DEALERSHIP_VEHICLES; i++)
	{
	    modelid = DealershipVehicles[dealership][i];

	    if(Veh_IsValidModel(modelid))
	    {
			format(line, sizeof(line), "\n%s\t$%i\t%s (%i)", Veh_GetModelName(modelid), Veh_GetModelPrice(modelid), (Veh_GetModelTrunkSpace(modelid) > 0) ? ("Si") : ("No"), Veh_GetModelTrunkSpace(modelid));
			strcat(string, line, sizeof(string));
			count++;
		}
	}

	if(count) {
		Dialog_Show(playerid, Car_Dealer_Step_1, DIALOG_STYLE_TABLIST_HEADERS, "Catálogo de vehículos en venta", string, "Ver", "Cerrar");
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay vehículos a la venta en esta concesionaria actualmente.");
	}
}

Dialog:Car_Dealer_Step_1(playerid, response, listitem, inputtext[])
{
	new dealership = GetNearestDealership(playerid, 1.0);
	
	if(dealership == -1)
     	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Error: debes estar en una concesionaria.");

	if(response)
	{
		if(0 <= listitem < MAX_DEALERSHIP_VEHICLES && Veh_IsValidModel(DealershipVehicles[dealership][listitem]))
		{
			carModelSelection[playerid] = DealershipVehicles[dealership][listitem];
			Dialog_Show(playerid, Car_Dealer_Step_2, DIALOG_STYLE_INPUT, "Selección de color primario", "Ingrese a continuación el número de color {00FF00}primario{a9c4e4} que desea.\n\nColores básicos:\n\t0 - Negro\n\t1 - Blanco\n\t2 - Azul\n\t3 - Rojo\n\t6 - Amarillo\n\t16 - Verde\n\nPara ver una lista mas amplia de colores, visite nuestro catálogo online:\n\thttp://wiki.sa-mp.com/wiki/Vehicle_Color_IDs", "Continuar", "Volver");
			Dealership_CreatePreviewModel(playerid, carModelSelection[playerid], 3, 3);
		}
	}
 	return 1;
}

Dialog:Car_Dealer_Step_2(playerid, response, listitem, inputtext[])
{
	new dealership = GetNearestDealership(playerid, 1.0);

	if(dealership == -1)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Error: debes estar en una concesionaria.");
		Dealership_DestroyPreviewModel(playerid);
		return 1;
	}

	if(response)
	{
		new color1 = strval(inputtext);
		
		if(color1 < 0 || color1 > 255)
		{
			Dialog_Show(playerid, Car_Dealer_Step_2, DIALOG_STYLE_INPUT, "Selección de color primario", "Ingrese a continuación el numero de color {00FF00}primario{a9c4e4} que desea.\n\nColores básicos:\n\t0 - Negro\n\t1 - Blanco\n\t2 - Azul\n\t3 - Rojo\n\t6 - Amarillo\n\t16 - Verde\n\nPara ver una lista mas amplia de colores, visite nuestro catálogo online:\n\thttp://wiki.sa-mp.com/wiki/Vehicle_Color_IDs", "Continuar", "Volver");
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ingresa un número de color válido (0-255).");
		}
		
		carColor1Selection[playerid] = color1;
        Dealership_SetPreviewModelColor(playerid, carColor1Selection[playerid], 3);
		Dialog_Show(playerid, Car_Dealer_Step_3, DIALOG_STYLE_INPUT, "Selección de color secundario", "Ingrese a continuación el número de color {00FF00}secundario{a9c4e4} que desea.\n\nColores básicos:\n\t0 - Negro\n\t1 - Blanco\n\t2 - Azul\n\t3 - Rojo\n\t6 - Amarillo\n\t16 - Verde\n\nPara ver una lista mas amplia de colores, visite nuestro catálogo online:\n\thttp://wiki.sa-mp.com/wiki/Vehicle_Color_IDs", "Continuar", "Volver");
	}
	else
 	{
		ShowPlayerDealershipCatalog(playerid, dealership);
		Dealership_DestroyPreviewModel(playerid);
	}
 	return 1;
}

Dialog:Car_Dealer_Step_3(playerid, response, listitem, inputtext[])
{
	if(GetNearestDealership(playerid, 1.0) == -1)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Error: debes estar en una concesionaria.");
		Dealership_DestroyPreviewModel(playerid);
		return 1;
	}

	if(response)
	{
		new color2 = strval(inputtext);

		if(color2 < 0 || color2 > 255)
		{
			Dialog_Show(playerid, Car_Dealer_Step_3, DIALOG_STYLE_INPUT, "Selección de color secundario", "Ingrese a continuación el numero de color {00FF00}secundario{a9c4e4} que desea.\n\nColores básicos:\n\t0 - Negro\n\t1 - Blanco\n\t2 - Azul\n\t3 - Rojo\n\t6 - Amarillo\n\t16 - Verde\n\nPara ver una lista mas amplia de colores, visite nuestro catálogo online:\n\thttp://wiki.sa-mp.com/wiki/Vehicle_Color_IDs", "Continuar", "Volver");
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ingresa un número de color válido (0-255).");
		}

        carColor2Selection[playerid] = color2;
		Dealership_SetPreviewModelColor(playerid, carColor1Selection[playerid], carColor2Selection[playerid]);
		Dialog_Show(playerid, Car_Dealer_Step_4, DIALOG_STYLE_LIST, "Selecciona la forma de pago que usarás", "Con efectivo\nTransferencia bancaria (recargo del 3%)", "Continuar", "Volver");
	}
	else
	{
	    Dialog_Show(playerid, Car_Dealer_Step_2, DIALOG_STYLE_INPUT, "Selección de color primario", "Ingrese a continuación el numero de color {00FF00}primario{a9c4e4} que desea.\n\nColores básicos:\n\t0 - Negro\n\t1 - Blanco\n\t2 - Azul\n\t3 - Rojo\n\t6 - Amarillo\n\t16 - Verde\n\nPara ver una lista mas amplia de colores, visite nuestro catálogo online:\n\thttp://wiki.sa-mp.com/wiki/Vehicle_Color_IDs", "Continuar", "Volver");
	}
 	return 1;
}

Dialog:Car_Dealer_Step_4(playerid, response, listitem, inputtext[])
{
	if(GetNearestDealership(playerid, 1.0) == -1)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Error: debes estar en una concesionaria.");
		Dealership_DestroyPreviewModel(playerid);
		return 1;
	}

	if(response)
	{
		new str[150];

		if(listitem == 0)
		{
			carPaymentSelection[playerid] = DEALERSHIP_PAYMENT_CASH;
			format(str, sizeof(str), "Detalles del pedido:\n\n\tModelo: %s\n\tColor primario: %d\n\tColor secundario: %d\n\tPrecio: $%d\n\tForma de pago: Pago en efectivo", Veh_GetModelName(carModelSelection[playerid]), carColor1Selection[playerid], carColor2Selection[playerid], Veh_GetModelPrice(carModelSelection[playerid]));
		}
  		else if(listitem == 1)
  		{
  		    carPaymentSelection[playerid] = DEALERSHIP_PAYMENT_BANK;
			format(str, sizeof(str), "Detalles del pedido:\n\n\tModelo: %s\n\tColor primario: %d\n\tColor secundario: %d\n\tPrecio: $%d + 3%s\n\tForma de pago: Transferencia bancaria", Veh_GetModelName(carModelSelection[playerid]), carColor1Selection[playerid], carColor2Selection[playerid], Veh_GetModelPrice(carModelSelection[playerid]), "%%");
		}
		Dialog_Show(playerid, Car_Dealer_Step_5, DIALOG_STYLE_MSGBOX, "Confirmación de la compra", str, "Comprar", "Cancelar");
	}
	else {
	    Dialog_Show(playerid, Car_Dealer_Step_3, DIALOG_STYLE_INPUT, "Selección de color secundario", "Ingrese a continuación el numero de color {00FF00}secundario{a9c4e4} que desea.\n\nColores básicos:\n\t0 - Negro\n\t1 - Blanco\n\t2 - Azul\n\t3 - Rojo\n\t6 - Amarillo\n\t16 - Verde\n\nPara ver una lista mas amplia de colores, visite nuestro catálogo online:\n\thttp://wiki.sa-mp.com/wiki/Vehicle_Color_IDs", "Continuar", "Volver");
	}
	return 1;
}


Dialog:Car_Dealer_Step_5(playerid, response, listitem, inputtext[])
{
    Dealership_DestroyPreviewModel(playerid);
    
	if(response)
	{
		new dealership = GetNearestDealership(playerid, 1.0),
		    price = Veh_GetModelPrice(carModelSelection[playerid]),
		    dealershipSlot = Dealership_SearchCar(dealership, carModelSelection[playerid]);

		if(dealership == -1)
     		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Error: debes estar en una concesionaria.");
		if(dealershipSlot == -1)
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Error: ese modelo ya no se encuentra a la venta.");
		if(!KeyChain_GetFreeSlots(playerid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Error: no tienes más espacio en tu llavero para otra llave.");
		if(carPaymentSelection[playerid] == DEALERSHIP_PAYMENT_CASH && GetPlayerCash(playerid) < price)
        	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"* Vendedor: ¡Vuelve cuando tengas el dinero en efectivo suficiente!");
        if(carPaymentSelection[playerid] == DEALERSHIP_PAYMENT_BANK && PlayerInfo[playerid][pBank] < price / 100 * 103)
        	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"* Vendedor: ¡No tienes suficiente dinero en tu cuenta bancaria!");

		new vehicleid, interior = GetPlayerInterior(playerid), vworld = GetPlayerVirtualWorld(playerid);

		if(!(vehicleid = Veh_Create(carModelSelection[playerid], carColor1Selection[playerid], carColor2Selection[playerid], Dealership[dealership][dParkingX], Dealership[dealership][dParkingY], Dealership[dealership][dParkingZ], Dealership[dealership][dParkingAngle], interior, vworld, -1)))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Límite de vehículos en el servidor alcanzado. REPORTAR A UN ADMIN.");

		if(carPaymentSelection[playerid] == DEALERSHIP_PAYMENT_CASH) {
			GivePlayerCash(playerid, -price);
			ServerFormattedLog(LOG_TYPE_ID_MONEY, .id=vehicleid, .entry="COMPRA VEHICULO", .playerid=playerid, .params=<"$%d", price>);
		}
		else {
		    PlayerInfo[playerid][pBank] -= price / 100 * 103; // Recargo 3%
			ServerFormattedLog(LOG_TYPE_ID_MONEY, .id=vehicleid, .entry="COMPRA VEHICULO", .playerid=playerid, .params=<"$%d", price / 100 * 103>);
		}

		VehicleInfo[vehicleid][VehType] = VEH_OWNED;
		VehicleInfo[vehicleid][VehOwnerSQLID] = PlayerInfo[playerid][pID];
		GetPlayerName(playerid, VehicleInfo[vehicleid][VehOwnerName], MAX_PLAYER_NAME);
		KeyChain_Add(playerid, KEY_TYPE_VEHICLE, vehicleid, .label = Veh_GetName(vehicleid), .owner = true);
		SaveVehicle(vehicleid);
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Has comprado un %s (ID vehículo: %i)! Recuerda estacionarlo fuera de la concesionaria con '/vehestacionar'. De no hacerlo podrá ser incautado.", Veh_GetModelName(carModelSelection[playerid]), vehicleid);
		StartPlayerScene(playerid, dealership + 3);
		ServerFormattedLog(LOG_TYPE_ID_VEHICLES, .id=vehicleid, .entry="/comprar", .playerid=playerid, .params=<"Mod:%d C1:%d C2:%d", carModelSelection[playerid], carColor1Selection[playerid], carColor2Selection[playerid]>);
	}
 	return 1;
}

Dealership_CreatePreviewModel(playerid, carmodel, color1, color2)
{
	// Frente
	PTD_Concesionaria[playerid][0] = CreatePlayerTextDraw(playerid, 480, 150, " ");
	PlayerTextDrawFont(playerid, PTD_Concesionaria[playerid][0], TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawBackgroundColor(playerid, PTD_Concesionaria[playerid][0], 0x00000090);
	PlayerTextDrawTextSize(playerid, PTD_Concesionaria[playerid][0], 150.0, 112.0);
	PlayerTextDrawSetPreviewModel(playerid, PTD_Concesionaria[playerid][0], carmodel);
	PlayerTextDrawSetPreviewRot(playerid, PTD_Concesionaria[playerid][0], -20.0, 0.0, -28.0, 0.85);
	PlayerTextDrawSetPreviewVehCol(playerid, PTD_Concesionaria[playerid][0], color1, color2);
	PlayerTextDrawShow(playerid, PTD_Concesionaria[playerid][0]);
	// Cola
	PTD_Concesionaria[playerid][1] = CreatePlayerTextDraw(playerid, 480, 262, " ");
	PlayerTextDrawFont(playerid, PTD_Concesionaria[playerid][1], TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawBackgroundColor(playerid, PTD_Concesionaria[playerid][1], 0x00000090);
	PlayerTextDrawTextSize(playerid, PTD_Concesionaria[playerid][1], 150.0, 112.0);
	PlayerTextDrawSetPreviewModel(playerid, PTD_Concesionaria[playerid][1], carmodel);
	PlayerTextDrawSetPreviewRot(playerid, PTD_Concesionaria[playerid][1], -20.0, 0.0, 152.0, 0.85);
	PlayerTextDrawSetPreviewVehCol(playerid, PTD_Concesionaria[playerid][1], color1, color2);
	PlayerTextDrawShow(playerid, PTD_Concesionaria[playerid][1]);
}

Dealership_SetPreviewModelColor(playerid, color1, color2)
{
	// Frente
	PlayerTextDrawSetPreviewVehCol(playerid, PTD_Concesionaria[playerid][0], color1, color2);
    PlayerTextDrawShow(playerid, PTD_Concesionaria[playerid][0]);
    // Cola
   	PlayerTextDrawSetPreviewVehCol(playerid, PTD_Concesionaria[playerid][1], color1, color2);
    PlayerTextDrawShow(playerid, PTD_Concesionaria[playerid][1]);
}

Dealership_DestroyPreviewModel(playerid)
{
	// Frente
	PlayerTextDrawDestroy(playerid, PTD_Concesionaria[playerid][0]);
	// Cola
	PlayerTextDrawDestroy(playerid, PTD_Concesionaria[playerid][1]);
}
