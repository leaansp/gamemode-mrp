#if defined _marp_saludocoordinado_included
	#endinput
#endif 
#define _marp_saludocoordinado_included

new saluteOffer[MAX_PLAYERS],
	saluteStyle[MAX_PLAYERS];
 
stock PlayerFacePlayer(playerid, targetid)
{
	new Float:Angle;
		
	GetPlayerFacingAngle(playerid, Angle);
	SetPlayerFacingAngle(targetid, Angle + 180);
	return 1;
}

CMD:saludar(playerid, params[])
{
	new targetid,
		style;
	
	if(sscanf(params, "ui", targetid, style))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/saludar [ID/Jugador] [Estilo 1-9]");
	if(style > 9 || style < 1)
		return SendClientMessage (playerid, COLOR_YELLOW2, "Solo puedes elegir entre los estilos 1 y 9!");
	if(targetid == playerid || !IsPlayerInRangeOfPlayer(1.5, playerid, targetid))
	    return SendClientMessage(playerid, COLOR_YELLOW2, "¡Jugador inválido o se encuentra muy lejos!");

	saluteOffer[targetid] = playerid;
	saluteStyle[targetid] = style;
	SendFMessage(playerid, COLOR_WHITE, "Saludaste a %s, pero debes esperar su respuesta.", GetPlayerCleanName(targetid));
	SendFMessage(targetid, COLOR_WHITE, "%s está intentando coordinar un saludo con vos, usa /saludo aceptar.", GetPlayerCleanName(playerid));
	return 1;
}

CMD:saludo(playerid, params[])
{
	new cmd[32];
		
	if(sscanf(params, "s[32]", cmd))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/saludo aceptar");

	if(strcmp(cmd, "aceptar") == 0)
	{
	    if(saluteOffer[playerid] == INVALID_PLAYER_ID)
	        return SendClientMessage(playerid, COLOR_YELLOW2, "Nadie te ha ofrecido un saludo.");
		if(saluteOffer[playerid] == playerid || !IsPlayerInRangeOfPlayer(1.5, playerid, saluteOffer[playerid]))
	    	return SendClientMessage(playerid, COLOR_YELLOW2, "¡Jugador inválido o se encuentra muy lejos!");

		PlayerFacePlayer(playerid, saluteOffer[playerid]);
		switch(saluteStyle[playerid])
		{
			case 1:
			{
				ApplyAnimationEx(playerid, "GANGS", "hndshkaa", 4.0, 0, 1, 1, 0, 0, 1);
				ApplyAnimationEx(saluteOffer[playerid], "GANGS", "hndshkaa", 4.0, 0, 1, 1, 0, 0, 1);
			}
			case 2:
			{
				ApplyAnimationEx(playerid, "GANGS", "hndshkca", 4.0, 0, 1, 1, 0, 0, 1);
				ApplyAnimationEx(saluteOffer[playerid], "GANGS", "hndshkca", 4.0, 0, 1, 1, 0, 0, 1);
			}
			case 3:
			{
				ApplyAnimationEx(playerid, "GANGS", "hndshkca", 4.0, 0, 1, 1, 0, 0, 1);
				ApplyAnimationEx(saluteOffer[playerid], "GANGS", "hndshkca", 4.0, 0, 1, 1, 0, 0, 1);
			}
			case 4:
			{
				ApplyAnimationEx(playerid, "GANGS", "hndshkcb", 4.0, 0, 1, 1, 0, 0, 1);
				ApplyAnimationEx(saluteOffer[playerid], "GANGS", "hndshkcb", 4.0, 0, 1, 1, 0, 0, 1);
			}
			case 5:
			{
				ApplyAnimationEx(playerid, "GANGS", "hndshkda", 4.0, 0, 1, 1, 0, 0, 1);
				ApplyAnimationEx(saluteOffer[playerid], "GANGS", "hndshkda", 4.0, 0, 1, 1, 0, 0, 1);
			}
			case 6:
			{
				ApplyAnimationEx(playerid, "GANGS", "hndshkea", 4.0, 0, 1, 1, 0, 0, 1);
				ApplyAnimationEx(saluteOffer[playerid], "GANGS", "hndshkea", 4.0, 0, 1, 1, 0, 0, 1);
			}
			case 7:
			{
				ApplyAnimationEx(playerid, "GANGS", "hndshkfa", 4.0, 0, 1, 1, 0, 0, 1);
				ApplyAnimationEx(saluteOffer[playerid], "GANGS", "hndshkfa", 4.0, 0, 1, 1, 0, 0, 1);
			}
			case 8:
			{
				ApplyAnimationEx(playerid, "GANGS", "prtial_hndshk_01", 4.0, 0, 1, 1, 0, 0, 1);
				ApplyAnimationEx(saluteOffer[playerid], "GANGS", "prtial_hndshk_01", 4.0, 0, 1, 1, 0, 0, 1);
			}
			case 9:
			{
				ApplyAnimationEx(playerid, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 1, 1, 0, 0, 1);
				ApplyAnimationEx(saluteOffer[playerid], "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 1, 1, 0, 0, 1);
			}
		}
		saluteOffer[playerid] = INVALID_PLAYER_ID;
		saluteStyle[playerid] = 0;
	}
	return 1;
}

