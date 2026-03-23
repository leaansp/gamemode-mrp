#if defined _marp_fade_textdraw_included
	#endinput
#endif
#define _marp_fade_textdraw_included

#define TD_FADE_UPD_TIME 80

stock PlayerText:PTD_CreateCinemaTopSprite(playerid, bool:large = false)
{
	new PlayerText:ptd = CreatePlayerTextDraw(playerid, 0.000000, 0.000000, "_");
	PlayerTextDrawLetterSize(playerid, ptd, 0.250000, (large) ? (12.55) : (8.2));
	PlayerTextDrawTextSize(playerid, ptd, 640.000000, 10.000000);
	PlayerTextDrawColor(playerid, ptd, -1);
	PlayerTextDrawBackgroundColor(playerid, ptd, 255);
	PlayerTextDrawBoxColor(playerid, ptd, 255);
	PlayerTextDrawUseBox(playerid, ptd, 1);
	return ptd;
}

stock PlayerText:PTD_CreateCinemaBotSprite(playerid, bool:large = false)
{
	new PlayerText:ptd = CreatePlayerTextDraw(playerid, 0.000000, (large) ? (333.0) : (373.0), "_");
	PlayerTextDrawLetterSize(playerid, ptd, 0.250000, (large) ? (12.55) : (8.2));
	PlayerTextDrawTextSize(playerid, ptd, 640.000000, 10.000000);
	PlayerTextDrawColor(playerid, ptd, -1);
	PlayerTextDrawBackgroundColor(playerid, ptd, 255);
	PlayerTextDrawBoxColor(playerid, ptd, 255);
	PlayerTextDrawUseBox(playerid, ptd, 1);
	return ptd;
}

stock PlayerText:PTD_CreateBlackScreen(playerid)
{
	new PlayerText:td = CreatePlayerTextDraw(playerid, 320.000000, 0.000000, "_");
	PlayerTextDrawLetterSize(playerid, td, 1.000000, 50.000000);
	PlayerTextDrawTextSize(playerid, td, 10.000000, 640.000000);
	PlayerTextDrawAlignment(playerid, td, 2);
	PlayerTextDrawColor(playerid, td, -1);
	PlayerTextDrawBackgroundColor(playerid, td, 255);
	PlayerTextDrawBoxColor(playerid, td, 255);
	PlayerTextDrawUseBox(playerid, td, 1);
	return td;
}

stock Text:TD_CreateBlackScreen()
{
	new Text:td = TextDrawCreate(320.000000, 0.000000, "_");
	TextDrawLetterSize(td, 1.000000, 50.000000);
	TextDrawTextSize(td, 10.000000, 640.000000);
	TextDrawAlignment(td, 2);
	TextDrawColor(td, -1);
	TextDrawBackgroundColor(td, 255);
	TextDrawBoxColor(td, 255);
	TextDrawUseBox(td, 1);
	return td;
}

stock FadeInOutNormalizeParameters(&transitionTime, &holdOnMaxTime, &startColor, &minAlpha, &maxAlpha, &colorSpeed, &minColorRGBA, &maxColorRGBA)
{
	/* Normalizacion de parámetros que esten desviados respecto a lo esperado */
	transitionTime = (transitionTime < 500) ? (500) : (transitionTime);
	holdOnMaxTime = (holdOnMaxTime < 0 || holdOnMaxTime > 10000) ? (1000) : (holdOnMaxTime);
	maxAlpha = (maxAlpha < 0 || maxAlpha > 255 || maxAlpha <= minAlpha) ? (255) : (maxAlpha);
	minAlpha = (minAlpha < 0 || minAlpha > 255 || minAlpha >= maxAlpha) ? (0) : (minAlpha);

	/* Calculo de velocidad necesaria segun tiempo deseado */
	colorSpeed = floatround(float(maxAlpha - minAlpha) / float(transitionTime) * float(TD_FADE_UPD_TIME));

	/* Rectificacion de mínimo y máximoalpha (si fuese necesario) para ejecutarse en el tiempo deseado */
	maxAlpha = (maxAlpha > (255 - colorSpeed)) ? (255 - colorSpeed) : (maxAlpha);
	minAlpha = (minAlpha < colorSpeed) ? (colorSpeed) : (minAlpha);

	/* Transformo mis valores min y max de alpha (actualmente en decimal) en formato RGBA con los datos del color RGBA recibido */
	minColorRGBA = ((startColor & 0xFFFFFF00) | minAlpha);
	maxColorRGBA = ((startColor & 0xFFFFFF00) | maxAlpha);
}

stock PlayerTextDrawFadeInOut(playerid, PlayerText:td, destroy = 1, transitionTime = 4000, holdOnMaxTime = 1000, startColor = 0xFFFFFF00, minAlpha = 3, maxAlpha = 252)
{
	new colorSpeed, minColorRGBA, maxColorRGBA;
	FadeInOutNormalizeParameters(transitionTime, holdOnMaxTime, startColor, minAlpha, maxAlpha, colorSpeed, minColorRGBA, maxColorRGBA);

	PlayerTextDrawColor(playerid, td, startColor);
	PlayerTextDrawShow(playerid, td);
	SetTimerEx("FadePlayerTextDraw", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, startColor, minColorRGBA, maxColorRGBA, colorSpeed);
}

stock TextDrawFadeInOut(playerid, Text:td, destroy = 0, transitionTime = 4000, holdOnMaxTime = 1000, startColor = 0xFFFFFF00, minAlpha = 3, maxAlpha = 252)
{
	new colorSpeed, minColorRGBA, maxColorRGBA;
	FadeInOutNormalizeParameters(transitionTime, holdOnMaxTime, startColor, minAlpha, maxAlpha, colorSpeed, minColorRGBA, maxColorRGBA);

	TextDrawColor(td, startColor);
	TextDrawShowEx(playerid, td);
	SetTimerEx("FadeTextDraw", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, startColor, minColorRGBA, maxColorRGBA, colorSpeed);
	return 1;
}

forward FadePlayerTextDraw(playerid, PlayerText:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, colorSpeed);
public FadePlayerTextDraw(playerid, PlayerText:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, colorSpeed)
{
	if(!IsPlayerConnected(playerid))
		return 1;

	if(colorSpeed > 0)
	{
		if(currentColor <= maxColor)
		{
			PlayerTextDrawColor(playerid, td, currentColor + colorSpeed);
			PlayerTextDrawShow(playerid, td);
			SetTimerEx("FadePlayerTextDraw", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor + colorSpeed, minColor, maxColor, colorSpeed);
		} else if(holdOnMaxTime > TD_FADE_UPD_TIME) {
			SetTimerEx("FadePlayerTextDraw", holdOnMaxTime, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, -colorSpeed);
		} else {
			SetTimerEx("FadePlayerTextDraw", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, -colorSpeed);
		}
	} else {
		if(currentColor >= minColor)
		{
			PlayerTextDrawColor(playerid, td, currentColor + colorSpeed);
			PlayerTextDrawShow(playerid, td);
			SetTimerEx("FadePlayerTextDraw", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor + colorSpeed, minColor, maxColor, colorSpeed);
		} else {
			PlayerTextDrawHide(playerid, td);
			if(destroy) {
				PlayerTextDrawDestroy(playerid, td);
			}
		}
	}
	return 1;
}

forward FadeTextDraw(playerid, Text:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, colorSpeed);
public FadeTextDraw(playerid, Text:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, colorSpeed)
{
	if(playerid != INVALID_PLAYER_ID && !IsPlayerConnected(playerid))
		return 1;

	if(colorSpeed > 0)
	{
		if(currentColor <= maxColor)
		{
			TextDrawColor(td, currentColor + colorSpeed);
			TextDrawShowEx(playerid, td);
			SetTimerEx("FadeTextDraw", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor + colorSpeed, minColor, maxColor, colorSpeed);
		} else if(holdOnMaxTime > TD_FADE_UPD_TIME) {
			SetTimerEx("FadeTextDraw", holdOnMaxTime, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, -colorSpeed);
		} else {
			SetTimerEx("FadeTextDraw", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, -colorSpeed);
		}
	} else {
		if(currentColor >= minColor)
		{
			TextDrawColor(td, currentColor + colorSpeed);
			TextDrawShowEx(playerid, td);
			SetTimerEx("FadeTextDraw", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor + colorSpeed, minColor, maxColor, colorSpeed);
		} else {
			TextDrawHideEx(playerid, td);
			if(destroy) {
				TextDrawDestroy(td);
			}
		}
	}
	return 1;
}

stock PlayerTextDrawBoxFadeInOut(playerid, PlayerText:td, destroy = 1, transitionTime = 4000, holdOnMaxTime = 1000, startColor = 0xFFFFFF00, minAlpha = 3, maxAlpha = 252)
{
	new colorSpeed, minColorRGBA, maxColorRGBA;
	FadeInOutNormalizeParameters(transitionTime, holdOnMaxTime, startColor, minAlpha, maxAlpha, colorSpeed, minColorRGBA, maxColorRGBA);

	PlayerTextDrawBoxColor(playerid, td, startColor);
	PlayerTextDrawShow(playerid, td);
	SetTimerEx("FadePlayerTextDrawBox", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, startColor, minColorRGBA, maxColorRGBA, colorSpeed);
}

stock TextDrawBoxFadeInOut(playerid, Text:td, destroy = 0, transitionTime = 4000, holdOnMaxTime = 1000, startColor = 0xFFFFFF00, minAlpha = 3, maxAlpha = 252)
{
	new colorSpeed, minColorRGBA, maxColorRGBA;
	FadeInOutNormalizeParameters(transitionTime, holdOnMaxTime, startColor, minAlpha, maxAlpha, colorSpeed, minColorRGBA, maxColorRGBA);

	TextDrawBoxColor(td, startColor);
	TextDrawShowEx(playerid, td);
	SetTimerEx("FadeTextDrawBox", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, startColor, minColorRGBA, maxColorRGBA, colorSpeed);
	return 1;
}

forward FadePlayerTextDrawBox(playerid, PlayerText:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, colorSpeed);
public FadePlayerTextDrawBox(playerid, PlayerText:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, colorSpeed)
{
	if(!IsPlayerConnected(playerid))
		return 1;

	if(colorSpeed > 0)
	{
		if(currentColor <= maxColor)
		{
			PlayerTextDrawBoxColor(playerid, td, currentColor + colorSpeed);
			PlayerTextDrawShow(playerid, td);
			SetTimerEx("FadePlayerTextDrawBox", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor + colorSpeed, minColor, maxColor, colorSpeed);
		} else if(holdOnMaxTime > TD_FADE_UPD_TIME) {
			SetTimerEx("FadePlayerTextDrawBox", holdOnMaxTime, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, -colorSpeed);
		} else {
			SetTimerEx("FadePlayerTextDrawBox", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, -colorSpeed);
		}
	} else {
		if(currentColor >= minColor)
		{
			PlayerTextDrawBoxColor(playerid, td, currentColor + colorSpeed);
			PlayerTextDrawShow(playerid, td);
			SetTimerEx("FadePlayerTextDrawBox", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor + colorSpeed, minColor, maxColor, colorSpeed);
		} else {
			PlayerTextDrawHide(playerid, td);
			if(destroy) {
				PlayerTextDrawDestroy(playerid, td);
			}
		}
	}
	return 1;
}

forward FadeTextDrawBox(playerid, Text:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, colorSpeed);
public FadeTextDrawBox(playerid, Text:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, colorSpeed)
{
	if(playerid != INVALID_PLAYER_ID && !IsPlayerConnected(playerid))
		return 1;
	
	if(colorSpeed > 0)
	{
		if(currentColor <= maxColor)
		{
			TextDrawBoxColor(td, currentColor + colorSpeed);
			TextDrawShowEx(playerid, td);
			SetTimerEx("FadeTextDrawBox", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor + colorSpeed, minColor, maxColor, colorSpeed);
		} else if(holdOnMaxTime > TD_FADE_UPD_TIME) {
			SetTimerEx("FadeTextDrawBox", holdOnMaxTime, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, -colorSpeed);
		} else {
			SetTimerEx("FadeTextDrawBox", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor, minColor, maxColor, -colorSpeed);
		}
	} else {
		if(currentColor >= minColor)
		{
			TextDrawBoxColor(td, currentColor + colorSpeed);
			TextDrawShowEx(playerid, td);
			SetTimerEx("FadeTextDrawBox", TD_FADE_UPD_TIME, false, "iiiiiiii", playerid, _:td, destroy, holdOnMaxTime, currentColor + colorSpeed, minColor, maxColor, colorSpeed);
		} else {
			TextDrawHideEx(playerid, td);
			if(destroy) {
				TextDrawDestroy(td);
			}
		}
	}
	return 1;
}

TextDrawShowEx(playerid, Text:td)
{
	if(playerid == INVALID_PLAYER_ID) {
		TextDrawShowForAll(td);
	} else {
		TextDrawShowForPlayer(playerid, td);
	}
}

TextDrawHideEx(playerid, Text:td)
{
	if(playerid == INVALID_PLAYER_ID) {
		TextDrawHideForAll(td);
	} else {
		TextDrawHideForPlayer(playerid, td);
	}
}