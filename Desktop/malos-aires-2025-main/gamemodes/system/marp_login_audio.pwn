#if defined _marp_login_audio_included
	#endinput
#endif
#define _marp_login_audio_included

#include <YSI_Coding\y_hooks>

// ==================== CONSTANTES ====================
#define MAX_LOGIN_AUDIOS 11
#define INVALID_AUDIO_ID -1

// ==================== VARIABLES GLOBALES ====================
new g_LoginAudioUrl[MAX_LOGIN_AUDIOS][256] =
{
    "http://51.222.86.176/Chalita.mp3", //Chalita
	"http://51.222.86.176/Chalita.mp3", //MARP Intro
	"http://51.222.86.176/Chalita.mp3", //Malos Aires GYSH
	"http://51.222.86.176/Chalita.mp3", //Tranky Funky
	"http://51.222.86.176/Chalita.mp3", //En la ciudad de la furia
	"http://51.222.86.176/Chalita.mp3", //Tan Solo Amantes
	"http://51.222.86.176/Chalita.mp3", //Por una cabeza (Remix)
	"http://51.222.86.176/Chalita.mp3", //Pa la selección
	"http://51.222.86.176/Chalita.mp3", //Bestia Pop
	"http://51.222.86.176/Chalita.mp3", //No voy en tren
	"http://51.222.86.176/Chalita.mp3" //Duraznito 
    
};

new Text:g_LoginAudioTextdraw[MAX_LOGIN_AUDIOS]; // TextDraw ID por audio (o Text:INVALID_TEXT_DRAW)
new g_PlayerLoginAudioId[MAX_PLAYERS];    // ID del audio seleccionado para cada jugador
new Text:g_PlayerAudioTextdraw[MAX_PLAYERS];   // TextDraw activo por jugador
new bool:g_AudioSystemInitialized = false;

// ==================== FUNCIONES PÚBLICAS ====================

/**
 * Inicializar el sistema de audio de login con los 11 audios
 * Debe llamarse una vez al iniciar el servidor (en OnGameModeInit)
 */
stock LoginAudio_Initialize()
{
	if(g_AudioSystemInitialized)
        return 1;

	// Las URLs están inicializadas estáticamente en la declaración de g_LoginAudioUrl
	g_AudioSystemInitialized = true;
	return 1;
}


stock LoginAudio_PlayRandom(playerid)
{
	if(!g_AudioSystemInitialized)
	{
		printf("[LOGIN AUDIO] Error: Sistema no inicializado");
		return 0;
	}

	if(!IsPlayerConnected(playerid))
		return 0;

	// Seleccionar un audio al azar (0-10)
	new randomAudioId = random(MAX_LOGIN_AUDIOS);
	g_PlayerLoginAudioId[playerid] = randomAudioId;

	// Reproducir el audio
	PlayerPlaySound(playerid, 0, 0, 0, 0); // Detener sonidos anteriores
	PlayAudioStreamForPlayer(playerid, g_LoginAudioUrl[randomAudioId]);

	// Mostrar el TextDraw asociado si existe
	if(g_LoginAudioTextdraw[randomAudioId] != Text:INVALID_TEXT_DRAW)
	{
		g_PlayerAudioTextdraw[playerid] = g_LoginAudioTextdraw[randomAudioId];
		TextDrawShowForPlayer(playerid, g_LoginAudioTextdraw[randomAudioId]);
	}

	return 1;
}

/**
 * Detener el audio de login y ocultar el TextDraw
 * Se llama cuando el jugador spawnea
 * 
 * @param playerid - ID del jugador
 * @return 1 si fue exitoso
 */
stock LoginAudio_Stop(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;

	// Detener el audio
	StopAudioStreamForPlayer(playerid);

	// Ocultar el TextDraw si existe
	if(g_PlayerAudioTextdraw[playerid] != Text:INVALID_TEXT_DRAW)
	{
		TextDrawHideForPlayer(playerid, g_PlayerAudioTextdraw[playerid]);
		g_PlayerAudioTextdraw[playerid] = Text:INVALID_TEXT_DRAW;
	}

	g_PlayerLoginAudioId[playerid] = INVALID_AUDIO_ID;

	return 1;
}

/**
 * Obtener el ID del audio que está reproduciendo el jugador
 * 
 * @param playerid - ID del jugador
 * @return ID del audio (0-10) o INVALID_AUDIO_ID si no hay audio activo
 */
stock LoginAudio_GetCurrentAudioId(playerid)
{
	return g_PlayerLoginAudioId[playerid];
}

// ==================== HOOKS ====================

/**
 * Hook para limpiar datos cuando un jugador se desconecta
 */
hook OnPlayerDisconnect(playerid, reason)
{
	LoginAudio_Stop(playerid);
	g_PlayerLoginAudioId[playerid] = INVALID_AUDIO_ID;
	g_PlayerAudioTextdraw[playerid] = INVALID_TEXT_DRAW;
	return 1;
}

/**
 * Hook para detener el audio cuando el jugador spawnea
 * IMPORTANTE: Asegúrate de que este hook se ejecute DESPUÉS de que el jugador haya spawneado completamente
 */
hook OnPlayerSpawn(playerid)
{
	LoginAudio_Stop(playerid);
	return 1;
}

/**
 * Reproducir audio al conectar al servidor
 * Se ejecuta cuando el jugador entra al servidor (antes del spawn)
 */
hook OnPlayerConnect(playerid)
{
	LoginAudio_PlayRandom(playerid);
	return 1;
}

