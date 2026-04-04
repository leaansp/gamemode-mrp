#if defined _marp_biz_included
	#endinput
#endif
#define _marp_biz_included

#include "business\marp_biz_core.pwn"
#include "business\marp_biz_core_coords.pwn"
#include "business\marp_biz_core_db.pwn"
#include "business\marp_biz_admin.pwn"
#include "business\marp_biz_reviews.pwn"
#include "business\marp_biz_user.pwn"
#include "business\marp_biz_prods_manage.pwn"
#include "business\marp_biz_prods_orders.pwn"
#include "business\marp_biz_purchase.pwn"
#include "business\marp_biz_offer.pwn"
#include "business\types\marp_casino.pwn"
#include "business\types\marp_clothes.pwn"
#include "business\types\marp_biz_mechanic.pwn"
#include "business\marp_biz_employees.pwn"

#include <YSI_Coding\y_hooks>


new	bool:OfferingBusiness[MAX_PLAYERS],
	BusinessOfferPrice[MAX_PLAYERS],
	BusinessOffer[MAX_PLAYERS],
	BusinessOfferId[MAX_PLAYERS];

ResetBusinessOffer(playerid)
{
	OfferingBusiness[playerid] = false;
	BusinessOfferPrice[playerid] = -1;
	BusinessOfferId[playerid] = 0;
	BusinessOffer[playerid] = INVALID_PLAYER_ID;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(KEY_PRESSED_SINGLE(KEY_CTRL_BACK))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
			return 1;

		new bizid = Biz_GetPlayerLastId(playerid);

		if(!bizid)
			return 1;

		if(Biz_IsPlayerAtOutsideDoorId(playerid, bizid))
		{
			if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
			if(!Business[bizid][bEnterable])
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La entrada a este negocio esta deshabilitada.");
			if(Business[bizid][bLocked] && !AdminDuty[playerid])
				return GameTextForPlayer(playerid, "~r~negocio cerrado.", 2000, 4);

			if(Business[bizid][bEntranceFee] > 0 && !KeyChain_Contains(playerid, KEY_TYPE_BUSINESS, bizid))
			{
				if(GetPlayerCash(playerid) < Business[bizid][bEntranceFee])
					return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"¡No tienes el dinero suficiente!");

				GivePlayerCash(playerid, -Business[bizid][bEntranceFee]);
				Business[bizid][bTill] += Business[bizid][bEntranceFee];
				SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"¡Te han cobrado $%i para ingresar al negocio %s!", Business[bizid][bEntranceFee], Business[bizid][bName]);
			}

			Biz_TpPlayerToInsideDoorId(playerid, bizid);
			BizReview_OnPlayerEnter(playerid, bizid);
			return 1;
		}
		else if(Biz_IsPlayerAtInsideDoorId(playerid, bizid))
		{
			if(PlayerInfo[playerid][pDisabled] != DISABLE_NONE)
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No puedes hacerlo en este momento.");
			if(!Business[bizid][bEnterable])
				return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Negocio temporalmente deshabilitado.");
			if(Business[bizid][bLocked] && !AdminDuty[playerid])
				return GameTextForPlayer(playerid, "~r~negocio cerrado.", 2000, 4);

			Biz_TpPlayerToOutsideDoorId(playerid, bizid);
			return 1;
		}
	}
	return 1;
}

//=============================COMANDOS DE NEGOCIO==============================

CMD:ayudanegocio(playerid, params[])
{
	SendClientMessage(playerid, COLOR_WHITE, "_____________________________________[ NEGOCIO ]______________________________________");
	SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" /negociocomprar - /negociovender - /negociogestionar - /negocionombre");
	SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" /negociollave - /negociocaja - /negocioradio - /negociovendera");
	SendClientMessage(playerid, COLOR_USAGE, "[COMANDOS] "COLOR_EMB_GREY" /negociocontratar - /negociodespedir - /negociorenunciar - /negociotrabajo");
	SendClientMessage(playerid, COLOR_WHITE, "______________________________________________________________________________________");
	return 1;
}

CMD:negociovendera(playerid, params[])
{
	new bizid = Biz_IsPlayerAtOutsideDoorAny(playerid);

	if(!bizid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No te encuentras en la puerta de entrada de un negocio.");
	if(!Biz_IsPlayerOwner(playerid, bizid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres el dueño de este negocio.");

	new targetid, price;

	if(sscanf(params, "ui", targetid, price))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/negociovendera [ID/Jugador] [Precio]");
	if(!IsPlayerLogged(targetid) || targetid == playerid)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
	if(price < 1 || price > 10000000)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El precio no puede ser menor a $1 ni mayor a $10,000,000.");
	if(OfferingBusiness[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya te encuentras vendiendo un negocio.");
	if(!IsPlayerInRangeOfPlayer(3.0, playerid, targetid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto no está cerca tuyo.");

	OfferingBusiness[playerid] = true;
	BusinessOfferPrice[targetid] = price;
	BusinessOffer[targetid] = playerid;
	BusinessOfferId[targetid] = bizid;
	SendFMessage(playerid, COLOR_LIGHTBLUE, "Le ofreces las llaves y escritura de tu negocio a %s por $%d.",GetPlayerCleanName(targetid), price);
	SendFMessage(targetid, COLOR_LIGHTBLUE, "%s te esta ofreciendo venderte su negocio por $%d.", GetPlayerCleanName(playerid), price);
	SendClientMessage(targetid, COLOR_LIGHTBLUE, "Utiliza '/negocioaceptar' para aceptar la oferta o '/negociocancelar' para cancelar.");
	SetPVarInt(targetid, "CancelBusinessTransfer", SetTimerEx("CancelBusinessTransfer", 15 * 1000, false, "ii", targetid, 1));
	return 1;
}

CMD:negocioaceptar(playerid, params[])
{
	new sellerid = BusinessOffer[playerid], price = BusinessOfferPrice[playerid], bizid = BusinessOfferId[playerid];
	    	
  	if(sellerid == INVALID_PLAYER_ID)
    	return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te está vendiendo un negocio.");
	if(!IsPlayerLogged(sellerid) || !OfferingBusiness[sellerid])
	{
	    KillTimer(GetPVarInt(playerid, "CancelBusinessTransfer"));
	    CancelBusinessTransfer(playerid, 2);
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Hubo un error durante la venta, cancelando...");
	}
	if(!IsPlayerInRangeOfPlayer(3.0, playerid, sellerid))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El sujeto no está cerca tuyo.");
	if(GetPlayerCash(playerid) < price)
	{
	    KillTimer(GetPVarInt(playerid, "CancelBusinessTransfer"));
	    SendClientMessage(sellerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no tiene el dinero necesario, cancelando...");
	    CancelBusinessTransfer(playerid, 2);
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes el dinero suficiente, cancelando...");
	}
	if(!Biz_IsPlayerOwner(sellerid, bizid))
	{
		KillTimer(GetPVarInt(playerid, "CancelBusinessTransfer"));
		CancelBusinessTransfer(playerid, 2);
		SendClientMessage(sellerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No eres dueño de este negocio, cancelando...");
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador no es el dueño del negocio, cancelando...");
	}

	if(!Biz_SetOwner(bizid, playerid, .save = true))
	{
	    KillTimer(GetPVarInt(playerid, "CancelBusinessTransfer"));
	    SendClientMessage(sellerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Hubo un error durante la venta o el jugador no tiene más espacio en su llavero, cancelando...");
	    CancelBusinessTransfer(playerid, 2);
	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Hubo un error durante la venta o no tienes más espacio en tu llavero, cancelando...");
	}

	GivePlayerCash(playerid, -price);
    GivePlayerCash(sellerid, price);
    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
    PlayerPlaySound(sellerid, 1052, 0.0, 0.0, 0.0);
    PlayerPlayerActionMessage(sellerid, playerid, 15.0 , "toma las llaves y la escritura de su negocio y se las entrega a");
  	SendFMessage(playerid, COLOR_LIGHTBLUE, " ¡Felicidades, has comprado el negocio por $%d! Usa /ayudanegocio para ver los comandos disponibles.", price);
  	SendFMessage(sellerid, COLOR_LIGHTBLUE, " ¡Felicitaciones, has vendido tu negocio por $%d!", price);
  	KillTimer(GetPVarInt(playerid, "CancelBusinessTransfer"));
	CancelBusinessTransfer(playerid, 2);

	BizEmp_OnBizSell(bizid);

	ServerFormattedLog(LOG_TYPE_ID_MONEY, .entry="VENTA NEGOCIO", .playerid=sellerid, .targetid=playerid, .params=<"$%d", price>);
	return 1;
}

CMD:negociocancelar(playerid, params[])
{
	new sellerid = BusinessOffer[playerid];

	if(sellerid == INVALID_PLAYER_ID)
 	    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Nadie te está vendiendo un negocio.");
	KillTimer(GetPVarInt(playerid, "CancelBusinessTransfer"));
	CancelBusinessTransfer(playerid, 0);
	return 1;
}

TIMER:CancelBusinessTransfer(playerid, reason)
{
	if(reason == 1)
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "La venta ha sido cancelada ya que no has respondido en 15 segundos.");
		SendClientMessage(BusinessOffer[playerid], COLOR_LIGHTBLUE, "La venta ha sido cancelada ya que el comprador no ha respondido en 30 segundos.");
	} else
		if(reason == 0)
		{
	    	SendClientMessage(playerid, COLOR_LIGHTBLUE, "Has rechazado la oferta.");
			SendFMessage(BusinessOffer[playerid], COLOR_LIGHTBLUE, "%s ha rechazado la oferta.", GetPlayerCleanName(playerid));
		}

	ResetBusinessOffer(BusinessOffer[playerid]);
	ResetBusinessOffer(playerid);
	return 1;
}

Biz_GetTaxes(bizid) {
	return floatround(Business[bizid][bPrice] * Server_BizTaxPercent, floatround_ceil);
}