#if defined _marp_biz_prods_orders_included
	#endinput
#endif
#define _marp_biz_prods_orders_included

#include <YSI_Coding\y_hooks>

/*=======================================================================	
	Estructura de la informacion del pedido usando un vector dinámico

	/	0: Typo de la entrega (hecha por jugadores o hecha por sistema)
 O |	1: ID del negocio al que se entrega
 R |	2: Item que se entrega
 D |	3: Cantidad del item que se entrega
 E |	4: Lugar donde se recoge la mercaderia para luego entregarla => index de un array de posiciones
 N |	5: Tiempo restante de la entrega (en horas) - se entrega automaticamente al llegar a 0
	\	6: Estado de la entrega (Disponible - En curso - Entregada - Cancelada)

=======================================================================*/

#define PO_INFO_TYPE				0
#define PO_INFO_BIZ_ID				1
#define PO_INFO_ITEM_ID				2
#define PO_INFO_CANT				3
#define PO_INFO_PICKUP_POS			4
#define PO_INFO_TIME_REMAIN			5
#define PO_INFO_STATE				6

#define ORDER_STATE_FREE			0
#define ORDER_STATE_INCOMING		1
#define ORDER_STATE_DELIVERED		2
#define ORDER_STATE_CANCEL			3

#define ORDER_TYPE_SYSTEM			0
#define ORDER_TYPE_REAL				1

#define ORDER_INITIAL_TIME_REMAIN	24 //tiempo restante en horas con las que se inicia el pedido al crearlo

#define BIZ_MAX_RANDOM_ORDERS		50
#define BIZ_RANDOM_ORDERS_ON_INIT	30
#define BIZ_RANDOM_ORDERS_ON_UPDATE	15

static Products_Order_Vec;

new Products_DlgInfoStr[4096],
	bool:Products_DlgShowing[MAX_PLAYERS] = false,
	Orders_Timer;

forward UpdateOrdersTimeRemain();
public UpdateOrdersTimeRemain()
{
	new vsize = vector_size(Products_Order_Vec);
	printf("[INFO] Procesando %i entregas de transportista.", vsize);

	for(new i = vsize - 1, order, time; i >= 0 ; i--)
	{
		order = vector_get(Products_Order_Vec, i);

		if(PO_GetOrderInfo(order, PO_INFO_TYPE) == ORDER_TYPE_REAL)
		{
			time = PO_GetOrderInfo(order, PO_INFO_TIME_REMAIN);

			if(time > 0)
			{
				time--;
				vector_set(order, PO_INFO_TIME_REMAIN, time);
			}
			else if(vector_get(order, PO_INFO_STATE) == ORDER_STATE_FREE)
			{
				PO_SetOrderToBiz(order);
				PO_DestroyOrder(i);
			}
		}
	}

	vsize = PO_GetOrdersAmount(Products_Order_Vec);

	if(0 <= vsize <= BIZ_RANDOM_ORDERS_ON_UPDATE) { // Si quedan entre [0-X] pedidos en la lista, agregamos mas
		printf("[INFO] Generando %i nuevas entregas de transportista ficticias.", BizOrders_CreateRandomOrders(.orderType = ORDER_TYPE_SYSTEM, .amount = BIZ_RANDOM_ORDERS_ON_UPDATE));
	}
	return 1;
}

forward BizOrders_CreateRandomOrders(orderType, amount);
public BizOrders_CreateRandomOrders(orderType, amount)
{
	if(amount < 1)
		return 0;

	new bizids[BIZ_MAX_RANDOM_ORDERS];

	amount = (amount > BIZ_MAX_RANDOM_ORDERS) ? (BIZ_MAX_RANDOM_ORDERS) : (amount);
	Biz_GetRandomIds(bizids, amount, .allowIdRepetition = true);

	// Creamos cantidad de ordenes igual a la cantidad de ids aleatorias, y se corta si las ids comienzan a ser cero
	new counter = 0;
	for( ; counter < amount && bizids[counter]; counter++) {
		PO_CreateOrder(orderType, bizids[counter], ITEM_ID_PRODUCTOS, 100 + random(300));
	}

	return counter;
}

hook OnPlayerDisconnect(playerid, reason)
{
	Products_DlgShowing[playerid] = false;
	return 1;
}

hook OnGameModeInitEnded()
{
	Products_Order_Vec = vector_create();
	SetTimerEx("BizOrders_CreateRandomOrders", 10000, false, "ii", ORDER_TYPE_SYSTEM, BIZ_RANDOM_ORDERS_ON_INIT); // Luego de levantar los negocios de DB creamos los pedidos
	Orders_Timer = SetTimer("UpdateOrdersTimeRemain", 3600000, true);
	return 1;
}

hook OnGameModeExit()
{
	KillTimer(Orders_Timer);

	for(new i = vector_size(Products_Order_Vec) - 1, order; i >= 0; i--)
	{
		order = vector_get(Products_Order_Vec, i);
		PO_SetOrderToBiz(order);
		vector_clear(order);
	}

	vector_clear(Products_Order_Vec);
	return 1;
}

stock PO_GetOrdersAmount(vec_order)
{
	if(vec_order > 0 && vector_size(vec_order) > 0) //si esta creado y contiene al menos una orden
		return vector_size(vec_order);
	return 0;
		
}

PO_GetOrderInfo(vec_order, info)
{
	if(!PO_IsValidId(vec_order))
		return 0;

	return vector_get(vec_order, info);
}

PO_ChangeState(vec_order, newstate)
{
	if(!PO_IsValidId(vec_order))
		return 0;

	vector_set(vec_order, PO_INFO_STATE, newstate);
	PO_UpdateOpenedDialogs();
	return 1;
}

PO_IsValidIndex(index) {
	return (0 <= index < vector_size(Products_Order_Vec));
}

PO_IsValidId(orderid) {
	return (orderid > 0 && vector_size(orderid) == 7);
}

stock PO_CreateOrder(type, biz, item, cant)
{
	if(Products_Order_Vec > 0)
	{
		new vecid = vector_create();
		vector_push_back(Products_Order_Vec, vecid); //guardamos la ID del pedido en nuestro vector de pedidos

		vector_push_back(vecid, type); //seteamos el type del pedido
		vector_push_back(vecid, biz);  //seteamos el id del negocio
		vector_push_back(vecid, item); //seteamos el id del item
		vector_push_back(vecid, cant); //seteamos la cantidad que se entrega

		new fact = random(7);	//definir que item se recoge en cada fabrica, se puede hacer agregando
		vector_push_back(vecid, fact); 	//un parametro q lo indique con un integer en la lista de items

		vector_push_back(vecid, ORDER_INITIAL_TIME_REMAIN);
		vector_push_back(vecid, ORDER_STATE_FREE);
		PO_UpdateOpenedDialogs();
		return 1;
	}
	return 0;
}

stock PO_OrderToVec(orderid)
{
	return vector_get(Products_Order_Vec, orderid);
}

stock PO_VecToOrder(vec_order)
{
	return vector_find(Products_Order_Vec, vec_order);
}

stock PO_DestroyOrder(id, form = 1, updateDialogs = 1)
{
	if(form == 0) {
		id = PO_VecToOrder(id);
	}

	if(!(0 <= id < vector_size(Products_Order_Vec)))
		return 0;

	new orderid = vector_get(Products_Order_Vec, id);

	if(vector_size(orderid) > 0) { //existe
		vector_clear(orderid);
	}

	vector_remove(Products_Order_Vec, id);

	if(updateDialogs) {
		PO_UpdateOpenedDialogs();
	}
	return 1;
}

BizOrder_DestroyAllForBizId(bizid)
{
	if(!Products_Order_Vec)
		return 0;

	for(new i = vector_size(Products_Order_Vec) - 1, orderid; i >= 0; i--)
	{
		orderid = vector_get(Products_Order_Vec, i);

		if(PO_GetOrderInfo(orderid, PO_INFO_BIZ_ID) == bizid)
		{
			if(PO_GetOrderInfo(orderid, PO_INFO_STATE) != ORDER_STATE_INCOMING) {
				PO_DestroyOrder(i, .form = 1, .updateDialogs = false);
			} else {
				PO_ChangeState(orderid, ORDER_STATE_CANCEL);
			}
		}
	}

	PO_UpdateOpenedDialogs();
	return 1;
}

PO_SetOrderToBiz(orderid)
{
	if(!PO_IsValidId(orderid))
		return 0;

	if(PO_GetOrderInfo(orderid, PO_INFO_TYPE) == ORDER_TYPE_REAL)
	{
		new biz = PO_GetOrderInfo(orderid, PO_INFO_BIZ_ID),
			item = PO_GetOrderInfo(orderid, PO_INFO_ITEM_ID),
			cant = PO_GetOrderInfo(orderid, PO_INFO_CANT),
			totalPrice = (floatround(float(ItemModel_GetPrice(item)) * 0.6, floatround_ceil)) * cant;

		if(totalPrice <= Biz_GetTill(biz)) //si en la caja hay plata para pagar el pedido
		{
			new index = GetBizItemIndex(biz, item);
			if(index != -1 && GetBizItemStock(biz, index) + cant <= MAX_ITEM_STOCK) //si no borraron el item de la lista y se pasa del stock total disponible
			{
				Biz_AddTill(biz, -totalPrice);
				BusinessCatalog[biz][index][bStock] += cant;
				PO_ChangeState(orderid, ORDER_STATE_DELIVERED);
				Biz_UpdateSQLItemStock(biz, index);
				return 1;
			}
			else
			{
				PO_ChangeState(orderid, ORDER_STATE_CANCEL);
				return 0;
			}
		}
		else
		{
			PO_ChangeState(orderid, ORDER_STATE_CANCEL);
			return 0;
		}
	}
	return 1;
}

stock PO_UpdateOpenedDialogs()
{
	foreach(new playerid : Player)
	{
		if(Products_DlgShowing[playerid] == true && Dialog_IsOpened(playerid))
		{
			Dialog_Close(playerid);
			BizOrder_ShowList(playerid, .allowInteraction = true, .filterBiz = 0, .onResponse = "Dlg_Show_Orders");
		}
	}
}

BizOrder_ShowList(playerid, allowInteraction, filterBiz, const onResponse[] = "DLG_NO_RESPONSE")
{
	if(!Products_Order_Vec)
		return 0;

	new vsize = vector_size(Products_Order_Vec);

	if(!vsize)
		return 0;

	new biz, item, cant, status, type, count;

	Products_DlgInfoStr[0] = '\0';
	strcat(Products_DlgInfoStr, "Orden\tDescripción\tLugar de entrega\tEstado\n", sizeof(Products_DlgInfoStr));

	for(new i = 0, orderVec, orderStr[180], statusStr[32]; i < vsize; i++)
	{
		orderVec = vector_get(Products_Order_Vec, i);
		biz = vector_get(orderVec, PO_INFO_BIZ_ID);

		if(!filterBiz || filterBiz == biz)
		{
			type = vector_get(orderVec, PO_INFO_TYPE);

			if(!filterBiz || type == ORDER_TYPE_REAL)
			{		
				item = vector_get(orderVec, PO_INFO_ITEM_ID);
				cant = vector_get(orderVec, PO_INFO_CANT);
				status = vector_get(orderVec, PO_INFO_STATE);

				statusStr = (status == ORDER_STATE_FREE) ? ("{33b20d}Disponible") : (
							(status == ORDER_STATE_INCOMING) ? ("{FF9900}En curso") : (
							(status == ORDER_STATE_DELIVERED) ? ("{c98059}Entregado") : ("{FF5500}Cancelado")));

				format(orderStr, sizeof(orderStr), "%i\t%s%i %s\t%s\t%s\n", orderVec, (type == ORDER_TYPE_SYSTEM) ? ("[NPC] ") : (""), cant, ItemModel_GetName(item), Business[biz][bName], statusStr);
				strcat(Products_DlgInfoStr, orderStr, sizeof(Products_DlgInfoStr));
				count++;
			}
		}
	}

	if(!count)
		return 0;

	if(allowInteraction)
	{
		Dialog_Open(playerid, onResponse, DIALOG_STYLE_TABLIST_HEADERS, "Lista de pedidos", Products_DlgInfoStr, "Elegir", "Cerrar");
		Products_DlgShowing[playerid] = true;
	} else {
		Dialog_Open(playerid, onResponse, DIALOG_STYLE_TABLIST_HEADERS, "Lista de pedidos", Products_DlgInfoStr, "Cerrar", "");
	}
	return 1;
}

Dialog:Dlg_Show_Orders(playerid, response, listitem, inputtext[])
{
	Products_DlgShowing[playerid] = false;

	if(!response)
		return 0;

	if(!PO_IsValidIndex(listitem))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Hubo un error inesperado, por favor intente mas tarde o consulte a un administrador.");

	new orderid = vector_get(Products_Order_Vec, listitem);

	if(!PO_IsValidId(orderid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Hubo un error inesperado, por favor intente mas tarde o consulte a un administrador.");

	if(vector_get(orderid, PO_INFO_STATE) != ORDER_STATE_FREE)
	{
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El trabajo ya está siendo entregado, elige otro.");
		return Dialog_Show(playerid, Dlg_Show_Orders, DIALOG_STYLE_TABLIST_HEADERS, "Lista de encargos", Products_DlgInfoStr, "Trabajar", "Cerrar");
	}
	else
	{
		TranJob_StartWork(playerid, listitem);
		PO_UpdateOpenedDialogs();
	}	
	return 1;
}

CMD:orderrandom(playerid,params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new type, cant;

	if(sscanf(params, "ii", type, cant))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/orderrandom [Tipo (sistema = 0, reales = 1)] [Cantidad de pedidos]");
	if(!Products_Order_Vec)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El vector de ordenes no existe.");
	if(!(0 <= type <= 1))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tipo inválido.");

	new ordersCreated;

	if((ordersCreated = BizOrders_CreateRandomOrders(.orderType = type, .amount = cant)) > 0) {
		SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Dada la cantidad ingresada y la disponibilidad actual de negocios, se crearon %i órdenes aleatorias.", ordersCreated);
	} else {
		SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Cantidad de órdenes inválida o no hay disponibilidad de negocios.");
	}
	return 1;
}

CMD:ordershow(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	if(!Products_Order_Vec)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El vector de ordenes no existe.");

	if(!BizOrder_ShowList(playerid, .allowInteraction = false, .filterBiz = 0, .onResponse = "DLG_NO_RESPONSE"))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No hay pedidos en el sistema.");

	return 1;
}

CMD:orderdebug(playerid, params[])
{
	new order;

	if(sscanf(params, "i", order))
	{
		SendFMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY" /orderdebug [orden]. Products_Order_Vec: %i. tamaño: %i", Products_Order_Vec, vector_size(Products_Order_Vec));
		return 1;
	}
	if(!(0 <= order < vector_size(Products_Order_Vec)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ingresar una orden válida.");

	new ord = PO_OrderToVec(order),
		time = PO_GetOrderInfo(ord, PO_INFO_TIME_REMAIN),
		cant = PO_GetOrderInfo(ord, PO_INFO_CANT),
		item = PO_GetOrderInfo(ord, PO_INFO_ITEM_ID),
		totalPrice = (floatround(float(ItemModel_GetPrice(item)) * 0.6, floatround_ceil)) * cant;

	SendFMessage(playerid, COLOR_WHITE, "[Orden N° %i] Item: %s - Cantidad: %i - Costo de entrega: %i - Tiempo restante: %i", order, ItemModel_GetName(item), cant, totalPrice, time);
	return 1;
}

CMD:orderdelete(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	new id;

	if(sscanf(params, "i", id))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/orderdelete [orden]");
	if(!Products_Order_Vec)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El vector de ordenes no existe.");
	if(!(0 <= id < vector_size(Products_Order_Vec)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ingresar una orden válida.");
	if(vector_get(vector_get(Products_Order_Vec, id), PO_INFO_STATE) != ORDER_STATE_FREE)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El pedido no se puede borrar porque se esta entregando.");

	PO_DestroyOrder(id);
	SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Orden borrada.");
	return 1;
}

CMD:order(playerid, params[])
{
	if(AccountInfo[playerid][accAdminLevel] < 14)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

	SendClientMessage(playerid, COLOR_INFO, "[COMANDO] "COLOR_EMB_GREY" /orderrandom [tipo] [cantidad]: Crea muchos pedidos random en la lista.");
	SendClientMessage(playerid, COLOR_INFO, "[COMANDO] "COLOR_EMB_GREY" /orderdelete [orden]: borra un pedido de la lista.");
	SendClientMessage(playerid, COLOR_INFO, "[COMANDO] "COLOR_EMB_GREY" /ordershow: muestras la lista de pedidos.");
	SendClientMessage(playerid, COLOR_INFO, "[COMANDO] "COLOR_EMB_GREY" /orderdebug [orden]: info del vector principal.");
	return 1;
}