#if defined _marp_time_and_weather_included
	#endinput
#endif
#define _marp_time_and_weather_included

#include <YSI_Coding\y_hooks>

/***************************************************************************
						   __   _                
						  / /_ (_)____ ___   ___ 
						 / __// // __ `__ \ / _ |
						/ /_ / // / / / / //  __/
						\__//_//_/ /_/ /_/ \___/ 

***************************************************************************/

static ServerTimeHour, ServerTimeMin, ServerTimeSec;

hook GlobalUpdate()
{
	gettime(ServerTimeHour, ServerTimeMin, ServerTimeSec);

	if(!ServerTimeMin && !ServerTimeSec)
	{
		if((ServerTimeHour -= 3) < 0) {
			ServerTimeHour += 24;
		}

		SetWorldTime(ServerTimeHour);
	}
	return 1;
}

stock Time_GetWorldHour() {
	return ServerTimeHour;
}

CMD:tod(playerid, params[]) 
{
	new hour;

	if(sscanf(params, "i", hour) || !(0 <= hour <= 23))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/tod [hora del día] (0-23)");

	SetWorldTime(hour);
	return 1;
}

SyncPlayerTimeAndWeather(playerid)
{
	SyncPlayerWeather(playerid);
	SetPlayerTime(playerid, ServerTimeHour, ServerTimeMin);
}

/***************************************************************************
			                         __   __               
			 _      __ ___   ____ _ / /_ / /_   ___   _____
			| | /| / // _ \ / __ `// __// __ \ / _ \ / ___/
			| |/ |/ //  __// /_/ // /_ / / / //  __// /    
			|__/|__/ \___/ \__,_/ \__//_/ /_/ \___//_/     

***************************************************************************/

#define INTERIOR_WEATHER_ID 1
#define MAX_WEATHER_NAME 32
#define MIN_TIME_WEATHER_CHANGE 4 // En horas
#define MAX_TIME_WEATHER_CHANGE 8 // En horas

static enum e_SERVER_WEATHER {
	weatherID,
	nextWeatherID,
	timerID
};

static server_weather[e_SERVER_WEATHER];

static const weather_name[][MAX_WEATHER_NAME] = {
/*0*/	"Despejado",
/*1*/	"Despejado",
/*2*/	"Despejado",
/*3*/	"Despejado",
/*4*/	"Nublado",
/*5*/	"Despejado",
/*6*/	"Despejado",
/*7*/	"Nublado",
/*8*/	"Lluvia",
/*9*/	"Niebla",
/*10*/	"Despejado",
/*11*/	"Despejado",
/*12*/	"Nublado",
/*13*/	"Despejado",
/*14*/	"Despejado",
/*15*/	"Nublado",
/*16*/	"Lluvia",
/*17*/	"Despejado con eclipse nocturno",
/*18*/	"Despejado con eclipse nocturno"
};

SyncPlayerWeather(playerid)
{
	if(!IsPlayerDrugged(playerid) || Drugs_GetPlayerWeather(playerid) == -1)
	{
		if(!GetPlayerInterior(playerid) && !GetPlayerVirtualWorld(playerid)) {
			SetPlayerWeather(playerid, server_weather[weatherID]);
		} else {
			SetPlayerWeather(playerid, INTERIOR_WEATHER_ID);
		}
	} else {
		SetPlayerWeather(playerid, Drugs_GetPlayerWeather(playerid));
	}
}

SyncWeatherForAll()
{
	foreach(new playerid : Player) {
		SyncPlayerWeather(playerid);
	}
}

hook OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
    SyncPlayerWeather(playerid);
	return 1;
}

hook OnGameModeInitEnded()
{
	SetServerWeather(NewRandomWeather());
	return 1;
}

NewRandomWeather() {
	return random(sizeof(weather_name));
}

SetServerWeather(weather)
{
	server_weather[weatherID] = weather;
	server_weather[nextWeatherID] = NewRandomWeather();
	KillTimer(server_weather[timerID]);
	server_weather[timerID] = SetTimer("WeatherAutoChange", (MIN_TIME_WEATHER_CHANGE + random(MAX_TIME_WEATHER_CHANGE - MIN_TIME_WEATHER_CHANGE)) * 60 * 60 * 1000, false);
	SyncWeatherForAll();
}

forward WeatherAutoChange();
public WeatherAutoChange()
{
	SetServerWeather(server_weather[nextWeatherID]);
	return 1;
}

GetNextServerWeather() {
	return server_weather[nextWeatherID];
}

GetWeatherInfo(weatherid)
{
	new string[MAX_WEATHER_NAME];
	
	if(0 <= weatherid < sizeof(weather_name)) {
		strcat(string, weather_name[weatherid], MAX_WEATHER_NAME);
	} else {
		string = "Desconocido";
	}
	
	return string;
}

CMD:clima(playerid, params[])
{
	new weather;

	if(sscanf(params, "i", weather))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/clima [ID clima]");
	if(weather < -500 || weather > 500)
	    return SendClientMessage(playerid, COLOR_YELLOW2, "ID de clima inválida (de -500 a 500).");

	SetServerWeather(weather);
	return 1;
}

