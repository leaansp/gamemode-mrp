#if defined _marp_casino_included
	#endinput
#endif
#define _marp_casino_included

#define ROULETTE_COLOR_RED    	  1
#define ROULETTE_COLOR_BLACK      2
#define ROULETTE_COLOR_GREEN      3
#define CASINO_GAME_ROULETTE      1
#define CASINO_GAME_FORTUNE       2
#define CASINO_GAME_TRAGAMONEDAS  3

new	bool:isBetingRoulette[MAX_PLAYERS],
	bool:isBetingFortune[MAX_PLAYERS],
	bool:isBetingTragamonedas[MAX_PLAYERS];

new rouletteData[37] = {
	3,1,2,1,2,
	1,2,1,2,1,
	2,2,1,2,1,
	2,1,2,1,1,
	2,1,2,1,2,
	1,2,1,2,2,
	1,2,1,2,1,
	2,1
};

getRouletteNumberDozen(number)
{
	if(number >= 1 && number <= 12)
	    return 1;
	else
	    if(number >= 13 && number <= 24)
	        return 2;
		else
		    if(number >= 25 && number <= 36)
	        	return 3;
	return 0;
}

forward CasinoBetEnabled(playerid, game);
public CasinoBetEnabled(playerid, game)
{
	switch(game)
	{
	    case CASINO_GAME_ROULETTE:
			if(isBetingRoulette[playerid])
	    		isBetingRoulette[playerid] = false;
		case CASINO_GAME_FORTUNE:
		    if(isBetingFortune[playerid])
	    		isBetingFortune[playerid] = false;
		case CASINO_GAME_TRAGAMONEDAS:
			if(isBetingTragamonedas[playerid])
				isBetingTragamonedas[playerid] = false;
	}
	return 1;
}

CMD:tragamonedas(playerid, params[]) {

    for(new i = 0; i < MAX_BUSINESS; i++) {

		if(IsPlayerInRangeOfPoint(playerid, 100.0, Business[i][bInsideX], Business[i][bInsideY], Business[i][bInsideZ])) {

			if(GetPlayerVirtualWorld(playerid) == Business[i][bInsideWorld]) {

	    		if(Business[i][bType] == BIZ_CASINO) {
                    new numberbet;
                    if(sscanf(params, "i", numberbet))
						return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/tragamonedas [apuesta]");
                    if(isBetingTragamonedas[playerid] == true)
			    		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar medio minuto para volver a apostar!");
					if(numberbet < 10 || numberbet > 200)
					    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La apuesta mínima es de $10 y la máxima de $200!");
                    if(GetPlayerCash(playerid) < numberbet)
		     			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No dispones de esa cantidad en efectivo!");
					if( numberbet * 30 > Business[i][bTill] )
					    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El casino no dispone de tanta liquidez en efectivo en el caso de que ganes. Prueba con otra apuesta.");

                    new string[128], tm1, tm2, tm3, betWin;
                    GivePlayerCash(playerid, -numberbet);
                    Business[i][bTill] += numberbet;

                    new aleatorio1 = random(100);
					if(aleatorio1 < 30) tm1 = 1;
						else if(aleatorio1 < 60) tm1 = 2;
						    else if(aleatorio1 < 80) tm1 = 3;
           						else if(aleatorio1 < 93) tm1 = 4;
   						        	else tm1 = 5;

                    new aleatorio2 = random(100);
					if(aleatorio2 < 30) tm2 = 1;
						else if(aleatorio2 < 60) tm2 = 2;
						    else if(aleatorio2 < 80) tm2 = 3;
           						else if(aleatorio2 < 93) tm2 = 4;
   						        	else tm2 = 5;

				    new aleatorio3 = random(100);
					if(aleatorio3 < 30) tm3 = 1;
						else if(aleatorio3 < 60) tm3 = 2;
						    else if(aleatorio3 < 80) tm3 = 3;
           						else if(aleatorio3 < 93) tm3 = 4;
   						        	else tm3 = 5;

					if ((tm1 == 1)&&(tm2 == 1)&&(tm3 != 1)) betWin = numberbet;
					else if ((tm1 == 2)&&(tm2 == 2)&&(tm3 != 2)) betWin = numberbet;
                    else if ((tm1 == 3)&&(tm2 == 3)&&(tm3 != 3)) betWin = numberbet * 2;
                    else if ((tm1 == 4)&&(tm2 == 4)&&(tm3 != 4)) betWin = numberbet * 3;
                    else if ((tm1 == 5)&&(tm2 == 5)&&(tm3 != 5)) betWin = numberbet * 4;
                    else if ((tm1 == 1)&&(tm2 == 1)&&(tm3 == 1)) betWin = numberbet * 5;
                    else if ((tm1 == 2)&&(tm2 == 2)&&(tm3 == 2)) betWin = numberbet * 5;
                    else if ((tm1 == 3)&&(tm2 == 3)&&(tm3 == 3)) betWin = numberbet * 10;
                    else if ((tm1 == 4)&&(tm2 == 4)&&(tm3 == 4)) betWin = numberbet * 20;
                    else if ((tm1 == 5)&&(tm2 == 5)&&(tm3 == 5)) betWin = numberbet * 30;
                    else betWin = 0;

                    new betsWin[128] = "";
                    format(betsWin, sizeof(betsWin), "La misma empieza a girar y muestra lo siguiente: |%d|%d|%d|.", tm1, tm2, tm3);
                    format(string, sizeof(string), "introduce $%d a la maquina tragamonedas y tira la palanca. %s", numberbet, betsWin);
                    PlayerActionMessage(playerid, 15.0, string);

                    if(betWin == 0)
						 PlayerActionMessage(playerid, 15.0, "ha perdido: el casino se queda con el dinero.");
 					else
					{
                        Business[i][bTill] -= betWin;
					    GivePlayerCash(playerid, betWin);
						format(string, sizeof(string), "tuvo suerte y ganó $%d!", betWin);
					    PlayerActionMessage(playerid, 15.0, string);
					}

					isBetingTragamonedas[playerid] = true;
					SetTimerEx("CasinoBetEnabled", 30000, false, "ii", playerid, CASINO_GAME_TRAGAMONEDAS);
	    		}
			}
		}
	}
	return 1;
}

CMD:apostar(playerid, params[]) {
	return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Comandos para apostar en un casino: /apruleta, /apfortuna, /tragamonedas.");
}

CMD:apruleta(playerid, params[]) {

	for(new i = 0; i < MAX_BUSINESS; i++) {

		if(IsPlayerInRangeOfPoint(playerid, 100.0, Business[i][bInsideX], Business[i][bInsideY], Business[i][bInsideZ])) {

			if(GetPlayerVirtualWorld(playerid) == Business[i][bInsideWorld]) {

	    		if(Business[i][bType] == BIZ_CASINO) {

					new number, numberbet, colour[10], colourbet, dozen, dozenbet;
					if(sscanf(params, "iis[10]iii", number, numberbet, colour, colourbet, dozen, dozenbet))
					{
						SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/apruleta [número] [apuesta] [rojo/negro] [apuesta] [docena] [apuesta].");
     					SendClientMessage(playerid, COLOR_WHITE, "Si en algun campo no deseas apostar, escribe '-1' en el caso del número/docena o 'no' en el caso del color, y su apuesta escribe '0'.");
						return 1;
					}
					if(strcmp(colour, "rojo", true) != 0 && strcmp(colour, "negro", true) != 0 && strcmp(colour, "no", true) != 0)
					{
						SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/apruleta [número] [apuesta] [rojo/negro] [apuesta] [docena] [apuesta].");
     					SendClientMessage(playerid, COLOR_WHITE, "Si en algun campo no deseas apostar, escribe '-1' en el caso del número/docena o 'no' en el caso del color, y en su apuesta escribe '0'.");
						return 1;
					}
					if(isBetingRoulette[playerid] == true)
					    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar un minuto para volver a apostar!");
					if(number < -1 || number > 36)
					    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Los números de una ruleta van del 0 al 36!");
					if(dozen < -1 || dozen > 3)
					    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Solo puedes elegir 1ra, 2da o 3er docena! (1,2,3 o -1 para omitir esa apuesta).");
					if(numberbet < 0 || numberbet > 20000 || colourbet < 0 ||colourbet > 20000 || dozenbet < 0 || dozenbet > 20000)
					    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La apuesta mínima es de $1 y la máxima de $20.000!");
					new totalbet = numberbet + colourbet + dozenbet;
					if(GetPlayerCash(playerid) < totalbet)
     					return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No dispones de esa cantidad en efectivo!");
					if( ( numberbet * 36 + colourbet * 2 + dozenbet * 3) > Business[i][bTill] )
					    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El casino no dispone de tanta liquidez en efectivo en el caso de que ganes. Prueba con otra apuesta.");

	                GivePlayerCash(playerid, -totalbet );
	                Business[i][bTill] += totalbet;

                    new string[128], winnerNumber, winnerColour[10];
					winnerNumber = random(37);
					switch(rouletteData[winnerNumber])
					{
					    case 1: winnerColour = "rojo";
					    case 2: winnerColour = "negro";
					    case 3: winnerColour = "verde";
					}
					format(string, sizeof(string), "apuesta $%d en la ruleta. El croupier empieza a girarla, y tras unos segundos...  ¡%s %d!", totalbet, winnerColour, winnerNumber);
                    PlayerActionMessage(playerid, 15.0, string);

					new betWin = 0;
					new betsWin[128] = "";
					if(winnerNumber == number)
					{
					    betWin += numberbet * 36;
					    format(betsWin, sizeof(betsWin), "número %d, ganó $%d.", winnerNumber, numberbet * 36);
					}
					if(strcmp(winnerColour, colour, true) == 0)
					{
						betWin += colourbet * 2;
						format(betsWin, sizeof(betsWin), "%s Color %s, ganó $%d.", betsWin, winnerColour, colourbet * 2);
					}
					if(getRouletteNumberDozen(winnerNumber) == dozen)
					{
					    betWin += dozenbet * 3;
					    format(betsWin, sizeof(betsWin), "%s Docena NÂº%d, ganó $%d.", betsWin, dozen, dozenbet * 3);
					}
					if(betWin == 0)
					    PlayerActionMessage(playerid, 15.0, "ha perdido todas sus apuestas: el casino se queda con el dinero.");
					else
					{
					    Business[i][bTill] -= betWin;
					    GivePlayerCash(playerid, betWin);
					    format(string, sizeof(string), "tuvo suerte y ganó $%d! %s", betWin, betsWin);
					    PlayerActionMessage(playerid, 15.0, string);
					}
					isBetingRoulette[playerid] = true;
					SetTimerEx("CasinoBetEnabled", 60000, false, "ii", playerid, CASINO_GAME_ROULETTE);
				}
			}
		}
	}
	return 1;
}

CMD:apfortuna(playerid, params[]) {

 	for(new i = 0; i < MAX_BUSINESS; i++) {

		if(IsPlayerInRangeOfPoint(playerid, 100.0, Business[i][bInsideX], Business[i][bInsideY], Business[i][bInsideZ])) {

			if(GetPlayerVirtualWorld(playerid) == Business[i][bInsideWorld]) {

	    		if(Business[i][bType] == BIZ_CASINO) {

  					new number, numberbet;
   					if(sscanf(params, "ii",number, numberbet))
						return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/apfortuna [número] [apuesta]");
	    			if(isBetingFortune[playerid] == true)
			    		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes esperar un minuto para volver a apostar!");
					if(number != 1 && number != 2 && number != 5 && number != 10 && number != 20 && number != 40)
					    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Tienes que apostar por un valor válido: 1, 2, 5, 10, 20 o 40.");
					if(numberbet < 1 || numberbet > 20000)
					    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La apuesta mínima es de $1 y la máxima de $20.000!");
					if(GetPlayerCash(playerid) < numberbet)
		     			return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No dispones de esa cantidad en efectivo!");
					if( number * (numberbet + 1)  > Business[i][bTill] )
					    return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"El casino no dispone de tanta liquidez en efectivo en el caso de que ganes. Prueba con otra apuesta.");

                    new string[128], winnerNumber;
                    GivePlayerCash(playerid, -numberbet);
                    Business[i][bTill] += numberbet;

                    new aleatorio = random(54);
					if(aleatorio < 24) winnerNumber = 1;
						else if(aleatorio < 39) winnerNumber = 2;
						    else if(aleatorio < 46) winnerNumber = 5;
           						else if(aleatorio < 50) winnerNumber = 10;
   						        	else if(aleatorio < 52) winnerNumber = 20;
   						        	    else if(aleatorio < 54) winnerNumber = 40;

					format(string, sizeof(string), "apuesta $%d al numero %d en la rueda de la fortuna. Luego de girar, se detiene en...  ¡%d!", numberbet, number, winnerNumber);
                    PlayerActionMessage(playerid, 15.0, string);
                    if(winnerNumber == number)
                    {
                        GivePlayerCash(playerid, number * (numberbet + 1));
                    	Business[i][bTill] += number * (numberbet + 1);
                    	format(string, sizeof(string), "ha ganado $%d apostándole al %d!", number * (numberbet + 1), number);
					} else
					    	format(string, sizeof(string), "ha perdido $%d apostándole al %d!", numberbet, number);
       				PlayerActionMessage(playerid, 15.0, string);
					isBetingFortune[playerid] = true;
					SetTimerEx("CasinoBetEnabled", 60000, false, "ii", playerid, CASINO_GAME_FORTUNE);
				}
			}
		}
	}
	return 1;
}