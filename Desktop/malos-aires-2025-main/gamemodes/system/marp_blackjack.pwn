#if defined marp_blackjack_inc
	#endinput
#endif
#define marp_blackjack_inc

#include <YSI_Coding\y_hooks>

const BLACKJACK_MAX_PLAYERS = 5;

static Blackjack_HostPlayer[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
static Blackjack_PlayerAmount[MAX_PLAYERS][2] = {{0, 0}, ...};
static Blackjack_Offer[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
static Blackjack_Data[MAX_PLAYERS][BLACKJACK_MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};

static Iterator:Blackjack_Data[MAX_PLAYERS]<BLACKJACK_MAX_PLAYERS>;

static const Blackjack_CardSuit[][16] = {
    "de corazones", "de picas", "de tréboles", "de rombos"
};

static enum e_CARD_DATA 
{
    cardValue,
    cardSecondValue,
    cardName[3]
}

static const Blackjack_CardValue[][e_CARD_DATA] = {
    {
        /*cardValue*/ 1,
        /*cardSecondValue*/ 11,
        /*cardName[3]*/ "As"
    },
    {
        /*cardValue*/ 2,
        /*cardSecondValue*/ 0,
        /*cardName[3]*/ "2"
    },
    {
        /*cardValue*/ 3,
        /*cardSecondValue*/ 0,
        /*cardName[3]*/ "3"
    },
    {
        /*cardValue*/ 4,
        /*cardSecondValue*/ 0,
        /*cardName[3]*/ "4"
    },
    {
        /*cardValue*/ 5,
        /*cardSecondValue*/ 0,
        /*cardName[3]*/ "5"
    },
    {
        /*cardValue*/ 6,
        /*cardSecondValue*/ 0,
        /*cardName[3]*/ "6"
    },
    {
        /*cardValue*/ 7,
        /*cardSecondValue*/ 0,
        /*cardName[3]*/ "7"
    },
    {
        /*cardValue*/ 8,
        /*cardSecondValue*/ 0,
        /*cardName[3]*/ "8"
    },
    {
        /*cardValue*/ 9,
        /*cardSecondValue*/ 0,
        /*cardName[3]*/ "9"
    },
    {
        /*cardValue*/ 10,
        /*cardSecondValue*/ 0,
        /*cardName[3]*/ "10"
    },
    {
        /*cardValue*/ 10,
        /*cardSecondValue*/ 0,
        /*cardName[3]*/ "J"
    },
    {
        /*cardValue*/ 10,
        /*cardSecondValue*/ 0,
        /*cardName[3]*/ "Q"
    },
    {
        /*cardValue*/ 10,
        /*cardSecondValue*/ 0,
        /*cardName[3]*/ "K"
    }
};

Blackjack_InvitePlayer(playerid, targetid)
{
    if(!IsPlayerLogged(targetid))
        return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "El jugador que invitaste se desconecto.");
    if(Blackjack_HostPlayer[targetid] != INVALID_PLAYER_ID)
        return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "El jugador que invitaste se ya esta en una partida.");

    new blackjackid = Iter_Free(Blackjack_Data[playerid]);

	if(blackjackid == ITER_NONE)
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "La partida está llena.");

    Blackjack_Offer[targetid] = playerid;

    SendFMessage(playerid, COLOR_LIGHTBLUE, "Has invitado a %s a una partida de blackjack.", GetPlayerCleanName(targetid));
	SendFMessage(targetid, COLOR_LIGHTBLUE, "%s te ha invitado a una partida de blackjack.", GetPlayerCleanName(playerid));
	SendClientMessage(targetid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY" escribe /aceptar blackjack, para entrar a la partida.");
    return 1;
}

Blackjack_AddPlayer(playerid, targetid)
{
    if(!IsPlayerLogged(targetid))
        return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "El jugador que invitaste se desconecto.");

    new blackjackid = Iter_Free(Blackjack_Data[playerid]);

	if(blackjackid == ITER_NONE)
		return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "La partida está llena.");

    Blackjack_Data[playerid][blackjackid] = targetid;
    Blackjack_HostPlayer[targetid] = playerid;

    SendFMessage(playerid, COLOR_LIGHTBLUE, "%s acepto tu invitación a la partida de blackjack. Es el jugador N°: %i", GetPlayerCleanName(targetid), blackjackid + 1);

    Iter_Add(Blackjack_Data[playerid], blackjackid);
    return 1;
}

Blackjack_RemovePlayer(playerid, blackjackid, bool:forced = false)
{
    if(!Iter_Contains(Blackjack_Data[playerid], blackjackid) && !forced)
		return 0;

    new targetid = Blackjack_Data[playerid][blackjackid];

    Blackjack_HostPlayer[targetid] = INVALID_PLAYER_ID;
    Blackjack_PlayerAmount[targetid][0] = 0;
    Blackjack_PlayerAmount[targetid][1] = 0;

    Blackjack_Data[playerid][blackjackid] = INVALID_PLAYER_ID;

    if(!forced)
        Iter_Remove(Blackjack_Data[playerid], blackjackid);
    
    return 1;
}

Blackjack_GiveCard(playerid, targetid)
{
    new suit = random(sizeof(Blackjack_CardSuit));
    new mean = 2 * sizeof(Blackjack_CardValue) / 3;
    new numbers[3];
    numbers[0] = random(mean), numbers[1] = random(sizeof(Blackjack_CardValue)), numbers[2] = random(sizeof(Blackjack_CardValue)/3) + mean;

    new card = numbers[random(3)];

    Blackjack_PlayerAmount[targetid][0] += Blackjack_CardValue[card][cardValue];
    Blackjack_PlayerAmount[targetid][1] += Blackjack_CardValue[card][cardSecondValue] + Blackjack_CardValue[card][cardValue];

    PlayerPlayerCmeMessage(playerid, targetid, 15.0, 4000, "Deja una carta frente a");

    new text[128];
	format(text, sizeof(text), "La carta de %s es: %s %s.", GetPlayerChatName(targetid), Blackjack_CardValue[card][cardName], Blackjack_CardSuit[suit]);
    PlayerDoMessage(playerid, 15.0, text);
    return 1;
}

Blackjack_RestartAmounts(playerid)
{
    Blackjack_PlayerAmount[playerid][0] = 0;
    Blackjack_PlayerAmount[playerid][1] = 0;

    if(!Iter_Count(Blackjack_Data[playerid]))
        return 0;
	
    foreach(new id : Blackjack_Data[playerid])
    {
        Blackjack_PlayerAmount[Blackjack_Data[playerid][id]][0] = 0;
        Blackjack_PlayerAmount[Blackjack_Data[playerid][id]][1] = 0;
    }
    return 1;
}

Blackjack_PrintGame(playerid, targetid)
{
    SendClientMessage(targetid, COLOR_WHITE, "______________________[ BLACKJACK ]______________________");
    
    SendFMessage(targetid, COLOR_WHITE, "[Crupier N°: 0] - %s ((Mano: %i o %i))", GetPlayerCleanName(playerid), Blackjack_PlayerAmount[playerid][0], Blackjack_PlayerAmount[playerid][1]);

    foreach(new id : Blackjack_Data[playerid]) {
        SendFMessage(targetid, COLOR_WHITE, "[Jugador N°: %i] - %s ((Mano: %i o %i))", id + 1, GetPlayerCleanName(Blackjack_Data[playerid][id]),  Blackjack_PlayerAmount[Blackjack_Data[playerid][id]][0],  Blackjack_PlayerAmount[Blackjack_Data[playerid][id]][1]);
    }

    SendClientMessage(targetid, COLOR_WHITE, "__________________________________________________________");
    return 1;
}

hook function OnPlayerCmdAccept(playerid, const subcmd[])
{
    if(!strcmp(subcmd, "blackjack", true))
	{
        if(Blackjack_Offer[playerid] == INVALID_PLAYER_ID)
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡No tienes ninguna invitación!");
		if(!IsPlayerConnected(Blackjack_Offer[playerid]))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El jugador que te invito se ha desconectado.");
		if(!IsPlayerInRangeOfPlayer(3.0, playerid, Blackjack_Offer[playerid]))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar cerca del jugador que te ha invitado!");
        if(Blackjack_HostPlayer[playerid] != INVALID_PLAYER_ID)
            return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Ya te encuentras en una partida.");

        Blackjack_AddPlayer(Blackjack_Offer[playerid], playerid);
        SendFMessage(playerid, COLOR_LIGHTBLUE, "Has aceptado la invitación de %s a la partida de blackjack.", GetPlayerCleanName(Blackjack_Offer[playerid]));
        Blackjack_Offer[playerid] = INVALID_PLAYER_ID;
        return 1;
    }
    return continue(playerid, subcmd);
}

CMD:blackjack(playerid, params[])
{
    new subcmd[32];

    if(sscanf(params, "s[32] ", subcmd))
		return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/blackjack [ayuda - crear - invitar - expulsar - repartir - barajar - vermano - terminar]");
	
    new suithand = SearchHandsForItem(playerid, ITEM_ID_FRENCH_DECK);

	if(!strcmp(subcmd, "crear", true))
	{
        if(suithand == -1)
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener un mazo de poker en una de tus manos.");
        if(Blackjack_HostPlayer[playerid] != INVALID_PLAYER_ID)
            return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Ya te encuentras en una partida.");

        Blackjack_HostPlayer[playerid] = playerid;
        SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"has creado una partida de blackjack, utiliza '/blackjack invitar' para agregar jugadores (Maximo 5). Eres el jugador N° 0.");
        return 1;
    }
    else if(!strcmp(subcmd, "invitar", true))
    {
        if(Blackjack_HostPlayer[playerid] != playerid)
            return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "No eres el crupier o no te encuentras en una partida.");

        new targetid;

        if(sscanf(params, "s[32]u", subcmd, targetid))
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/blackjack invitar [ID/Jugador]");
        if(!IsPlayerLogged(targetid) || playerid == targetid)
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"ID/Jugador inválido.");
        if(!IsPlayerInRangeOfPlayer(3.0, playerid, targetid))
			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY" ¡Debes estar cerca del jugador que estas invitando!");
        
        Blackjack_InvitePlayer(playerid, targetid);
        return 1;
    }
    else if(!strcmp(subcmd, "expulsar", true))
    {
        if(Blackjack_HostPlayer[playerid] != playerid)
            return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "No eres el crupier o no te encuentras en una partida.");

        new blackjackid;

        if(sscanf(params, "s[32]i", subcmd, blackjackid))
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/blackjack expulsar [N° de Jugador]");
        if(blackjackid < 1 || blackjackid > 5)
            return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "El número debe ser entre 1 y 5.");
        
        if(!Blackjack_RemovePlayer(playerid, blackjackid - 1))
            return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Ese número de jugador no se encuentra en la partida.");
        else {
            SendFMessage(playerid, COLOR_LIGHTYELLOW2, "Expulsado al jugador N° %i de la partida.", blackjackid);
            return 1;
        }
    }
    if(!strcmp(subcmd, "repartir", true))
	{
        if(suithand == -1)
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener un mazo de poker en una de tus manos.");
        if(Blackjack_HostPlayer[playerid] != playerid)
            return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "No eres el crupier o no te encuentras en una partida.");

        new blackjackid;

        if(sscanf(params, "s[32]i", subcmd, blackjackid))
			return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/blackjack repartir [N° de Jugador]");
        if(!blackjackid)
            return Blackjack_GiveCard(playerid, playerid);
        else if(blackjackid < 1 || blackjackid > 5)
            return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "El número debe ser entre 1 y 5.");

        if(!Iter_Contains(Blackjack_Data[playerid], blackjackid - 1))
            return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Este jugador no se encuentra en la partida.");
    
        new targetid = Blackjack_Data[playerid][blackjackid - 1];

        Blackjack_GiveCard(playerid, targetid);
        return 1;
    }
    if(!strcmp(subcmd, "barajar", true))
	{
        if(Blackjack_HostPlayer[playerid] != playerid)
            return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "No eres el crupier o no te encuentras en una partida.");
        if(suithand == -1)
		    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes tener un mazo de poker en una de tus manos.");

        if(!Blackjack_RestartAmounts(playerid))
            return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "No hay cartas sobre la mesa.");

        PlayerCmeMessage(playerid, 15.0, 4000, "Junta todas las cartas y las baraja.");
        return 1;
    }
    if(!strcmp(subcmd, "vermano", true))
	{
        if(Blackjack_HostPlayer[playerid] == playerid)
            return Blackjack_PrintGame(playerid, playerid);
        else if(Blackjack_HostPlayer[playerid] != INVALID_PLAYER_ID)
            SendFMessage(playerid, COLOR_WHITE, "Tu mano suma %i o %i", Blackjack_PlayerAmount[playerid][0],  Blackjack_PlayerAmount[playerid][1]);
        else 
            return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "No eres el crupier o no te encuentras en una partida.");
        return 1;
    }
    if(!strcmp(subcmd, "terminar", true))
	{
        if(Blackjack_HostPlayer[playerid] != playerid)
            return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "No eres el crupier o no te encuentras en una partida.");

        if(Iter_Count(Blackjack_Data[playerid]))
        {
            foreach(new id : Blackjack_Data[playerid])
                Blackjack_RemovePlayer(playerid, id, .forced = true);

            Iter_Clear(Blackjack_Data[playerid]);
        }

        Blackjack_HostPlayer[playerid] = INVALID_PLAYER_ID;
        Blackjack_PlayerAmount[playerid][0] = 0;
        Blackjack_PlayerAmount[playerid][1] = 0;
        return SendClientMessage(playerid, COLOR_LIGHTYELLOW2, "Has finalizado la partida.");
    }
    if(!strcmp(subcmd, "ayuda", true))
    {
        Dialog_Open(playerid, "DLG_NO_RESPONSE", DIALOG_STYLE_MSGBOX, "[AYUDA] Blackjack",
					"['/Blakcjack crear']\n\
					Iniciara una mesa o partida de blackjack.\n \n\
                    ['/Blakcjack invitar [ID/Jugador]']\n\
                    Invita al jugador a participar de la partida. Hasta un maximo de 5 jugadores.\n \n\
                    ['/Blakcjack expulsar [N° de jugador]']\n\
                    Expulsa al jugador con dicho numero de la partida.\n \n\
                    ['/Blakcjack repartir [N° de jugador]']\n\
                    Da una carta al jugador con dicho numero de la partida. El crupier es el jugador 0.\n \n\
                    ['/Blakcjack barajar']\n\
                    Reinicia las manos de todos los jugadores de la partida.\n \n\
                    ['/Blakcjack vermano']\n\
                    Muestra la suma de las cartas.\n \n\
                    ['/Blakcjack terminar']\n\
                    Termina la partida de blackjack.",
					"Cerrar", "");
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(Blackjack_HostPlayer[playerid] == playerid)
    {
        if(Iter_Count(Blackjack_Data[playerid]))
        {
            foreach(new id : Blackjack_Data[playerid])
                Blackjack_RemovePlayer(playerid, id, .forced = true);

            Iter_Clear(Blackjack_Data[playerid]);
        }

    }
    else if(Blackjack_HostPlayer[playerid] != INVALID_PLAYER_ID)
    {
        foreach(new id : Blackjack_Data[Blackjack_HostPlayer[playerid]])
        {
            if(Blackjack_Data[Blackjack_HostPlayer[playerid]][id] == playerid) 
            {
                Blackjack_RemovePlayer(Blackjack_HostPlayer[playerid], id);
                break;
            }
                
        }
    }
	
    Blackjack_HostPlayer[playerid] = INVALID_PLAYER_ID;
    Blackjack_Offer[playerid] = INVALID_PLAYER_ID;
	return 1;
}
