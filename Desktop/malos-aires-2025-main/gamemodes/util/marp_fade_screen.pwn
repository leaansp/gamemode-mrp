#if defined _marp_fade_screen_included
	#endinput
#endif
#define _marp_fade_screen_included

#include <YSI_Coding\y_hooks>

#define FADE_SCREEN_UPD_TIME 80

static PlayerText:FadeScreen_PTD[MAX_PLAYERS] = {INVALID_PLAYER_TEXT_DRAW, ...};

static FadeScreen_color[MAX_PLAYERS];
static FadeScreen_speed[MAX_PLAYERS];
static FadeScreen_counter[MAX_PLAYERS];
static FadeScreen_timer[MAX_PLAYERS];

PlayerText:CreateScreenPTD(playerid, color = 0x000000FF)
{
	new PlayerText:ptd = CreatePlayerTextDraw(playerid, 0.0, 0.0, "_");
	PlayerTextDrawLetterSize(playerid, ptd, 10.0, 50.0);
	PlayerTextDrawTextSize(playerid, ptd, 640.0, 480.0);
	PlayerTextDrawBoxColor(playerid, ptd, color);
	PlayerTextDrawUseBox(playerid, ptd, 1);
	return ptd;
}

CMD:fadescreen(playerid, params[])
{
	new targetid, color, transition_time, max_alpha_time;

	if(sscanf(params, "uiii", targetid, color, transition_time, max_alpha_time))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/fadescreen [Jugador/ID] [color] [tiempo de transición] [tiempo de espera]");

	if(!FadeScreen_StartForPlayer(targetid, color, transition_time, max_alpha_time))
		return SendClientMessage(playerid, 0x5CCAF1FF, "Error en la solicitud, algúnparámetro es inválido o la velocidad de actualización resultante es muy baja");

	return 1;
}

FadeScreen_StartForPlayer(playerid, color, transition_time, max_alpha_time)
{
	if(!IsPlayerConnected(playerid) || transition_time < 500 || max_alpha_time < 0)
		return 0;

	FadeScreen_speed[playerid] = floatround(255.0 / float(transition_time) * float(FADE_SCREEN_UPD_TIME));
	
	if(!FadeScreen_speed[playerid])
		return 0;

	FadeScreen_color[playerid] = color & 0xFFFFFF00;
	FadeScreen_counter[playerid] = 0;

	new min_color = (color & 0xFFFFFF00) | FadeScreen_speed[playerid];
	new max_color = (color & 0xFFFFFF00) | (255 - FadeScreen_speed[playerid]);

	if(FadeScreen_timer[playerid]) {
		KillTimer(FadeScreen_timer[playerid]);
	} else {
		FadeScreen_PTD[playerid] = CreateScreenPTD(playerid);
	}

	FadeScreen_timer[playerid] = SetTimerEx("FadeScreen_Update", FADE_SCREEN_UPD_TIME, true, "iiii", playerid, min_color, max_color, max_alpha_time);
	return 1;
}

forward FadeScreen_Update(playerid, min_color, max_color, max_alpha_time);
public FadeScreen_Update(playerid, min_color, max_color, max_alpha_time)
{
	if(FadeScreen_speed[playerid] > 0)
	{
		if(FadeScreen_color[playerid] <= max_color)
		{
			FadeScreen_color[playerid] += FadeScreen_speed[playerid];

			if(FadeScreen_color[playerid] > max_color) {
				FadeScreen_color[playerid] = (FadeScreen_color[playerid] | 0x000000FF);
			}

			PlayerTextDrawBoxColor(playerid, FadeScreen_PTD[playerid], FadeScreen_color[playerid]);
			PlayerTextDrawShow(playerid, FadeScreen_PTD[playerid]);
		}
		else
		{
			FadeScreen_counter[playerid] += FADE_SCREEN_UPD_TIME; // TODO: hacer para una sola transicion, ida o vuelta. Matar timer acá y en maxalphatime invocar la vuelta.
			if(FadeScreen_counter[playerid] >= max_alpha_time) {
				FadeScreen_speed[playerid] = -FadeScreen_speed[playerid];
			}
		}
	}
	else
	{
		if(FadeScreen_color[playerid] >= min_color)
		{
			FadeScreen_color[playerid] += FadeScreen_speed[playerid];
			PlayerTextDrawBoxColor(playerid, FadeScreen_PTD[playerid], FadeScreen_color[playerid]);
			PlayerTextDrawShow(playerid, FadeScreen_PTD[playerid]);
		}
		else
		{
			PlayerTextDrawDestroy(playerid, FadeScreen_PTD[playerid]);
			FadeScreen_PTD[playerid] = INVALID_PLAYER_TEXT_DRAW;
			KillTimer(FadeScreen_timer[playerid]);
			FadeScreen_timer[playerid] = 0;
		}
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(FadeScreen_timer[playerid])
	{
		KillTimer(FadeScreen_timer[playerid]);
		FadeScreen_timer[playerid] = 0;
		FadeScreen_PTD[playerid] = INVALID_PLAYER_TEXT_DRAW;
	}
	return 1;
}
