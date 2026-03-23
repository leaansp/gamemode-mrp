#if defined _marp_hotkeys_included
	#endinput
#endif
#define _marp_hotkeys_included

// Sistema de teclas rapidas - el hook de KEY_NO esta en marp_inventory.pwn

CMD:teclas(playerid, params[])
{
	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "===========================[ TECLAS RAPIDAS ]===========================");
	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "  A PIE:");
	SendClientMessage(playerid, COLOR_INFO, "[TECLAS] "COLOR_EMB_GREY"~k~~GROUP_CONTROL_BWD~ (H) - entrar/salir edificios, casas, negocios");
	SendClientMessage(playerid, COLOR_INFO, "[TECLAS] "COLOR_EMB_GREY"Alt izquierdo - trabajo de basura / recargar arma");
	SendClientMessage(playerid, COLOR_INFO, "[TECLAS] "COLOR_EMB_GREY"Alt izquierdo + Y - intercambiar manos");
	SendClientMessage(playerid, COLOR_INFO, "[TECLAS] "COLOR_EMB_GREY"Correr + Y - guardar item de la mano derecha al inventario");
	SendClientMessage(playerid, COLOR_INFO, "[TECLAS] "COLOR_EMB_GREY"Tecla Y - abrir inventario");
	SendClientMessage(playerid, COLOR_INFO, "[TECLAS] "COLOR_EMB_GREY"~k~~CONVERSATION_NO~ (N) - agarrar objeto del suelo / guardar mano derecha");
	SendClientMessage(playerid, COLOR_INFO, "[TECLAS] "COLOR_EMB_GREY"Alt izquierdo + N - guardar item de la mano izquierda al inventario");
	SendClientMessage(playerid, COLOR_INFO, "[TECLAS] "COLOR_EMB_GREY"Correr + N - tirar item de la mano derecha (sin animacion)");
	SendClientMessage(playerid, COLOR_INFO, "[TECLAS] "COLOR_EMB_GREY"Alt izquierdo + Click derecho - cerrar maletero del vehiculo cercano");
	SendClientMessage(playerid, COLOR_INFO, "[TECLAS] "COLOR_EMB_GREY"Espacio + Click derecho - usar maletero del vehiculo cercano");
	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "  EN VEHICULO:");
	SendClientMessage(playerid, COLOR_INFO, "[TECLAS] "COLOR_EMB_GREY"~k~~TOGGLE_SUBMISSIONS~ (Numpad 2) - encender / apagar motor");
	SendClientMessage(playerid, COLOR_INFO, "[TECLAS] "COLOR_EMB_GREY"~k~~CONVERSATION_NO~ (N) - cinturon de seguridad");
	SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "=======================================================================");
	return 1;
}
