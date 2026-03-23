#if defined _marp_firstlogin_test_included
	#endinput
#endif
#define _marp_firstlogin_test_included 

#define MAX_TEST_OPTIONS 4
#define MAX_TEST_QUESTIONS 10
#include <YSI_Coding\y_hooks>

// ==================== FORWARDS ====================
forward OnInsertCharacterAfterTest(playerid);
forward OnInsertCharacterAfterRegister(playerid);


enum E_TestQuestion {
    questionText[256],
    option0[128],
    option1[128],
    option2[128],
    option3[128],
    correctOption // 0 a 3
};

new const TestQuestions[MAX_TEST_QUESTIONS][E_TestQuestion] = {
    {
        "¿Cuándo corresponde un CK?",
        "Cuando lo decide el afectado.",
        "En cualquier muerte IC.",
        "Con aprobación staff y rol válido.",
        "Cuando la policía lo solicita.",
        2
    },
    {
        "¿Qué NO justifica abrir fuego?",
        "Amenaza directa con arma visible.",
        "Defensa propia inmediata.",
        "Discusión verbal sin armas.",
        "Intento de secuestro previo.",
        2
    },
    {
        "Tras delito grave: ¿qué sigue?",
        "Hacer entorno policial.",
        "Avisar OOC.",
        "Desconectarte 10 minutos.",
        "Nada, ya escapaste.",
        0
    },
    {
        "Si un jugador no responde en rol activo:",
        "Se fuerza inmediatamente.",
        "Se continúa igual.",
        "Se espera y se avisa a staff.",
        "Se mata al personaje.",
        2
    },
    {
        "La reputación IC se construye por:",
        "El tiempo jugado.",
        "El rango en facción.",
        "Consecuencias visibles sostenidas.",
        "Percepción OOC de otros.",
        2
    },
    {
        "Si sobrevive a un trauma, lo lógico es:",
        "Seguir igual si no hubo PK.",
        "Buscar revancha inmediata.",
        "Integrarlo en su conducta futura.",
        "Resetear su historia.",
        2
    },
    {
        "Conflicto entre ilegales debe escalar:",
        "De forma inmediata.",
        "Progresivo y con señales previas.",
        "Solo con autorización staff.",
        "Cuando haya bajas.",
        1
    },
    {
        "¿Qué define una buena reacción IC?",
        "Ignorar lo ocurrido.",
        "Responder según cómo afectó al PJ.",
        "Buscar venganza inmediata.",
        "Actuar pensando en lo OOC.",
        1
},
    {
        "¿Qué es MetaGaming?",
        "Usar info OOC para actuar IC.",
        "Usar el mapa para orientarte.",
        "Hablar por /b durante rol.",
        "Usar el teléfono ingame.",
        0
    },
    {
        "Ejemplo claro de NRH:",
        "Chocar fuerte y seguir como si nada.",
        "Hacer entorno al terminar un robo.",
        "Usar /me para acciones.",
        "Cambiarte de ropa tras un delito.",
        0
    }
};

new shuffledOptions[MAX_PLAYERS][MAX_TEST_OPTIONS][128];
new correctOptionIndex[MAX_PLAYERS];
new currentQuestionIndex[MAX_PLAYERS];
new cAnswers[MAX_PLAYERS];

stock ShuffleOptions(playerid, questionIndex)
{
    new indices[MAX_TEST_OPTIONS] = {0, 1, 2, 3};
    new originalCorrect = TestQuestions[questionIndex][correctOption];

    // Shuffle indices
    for (new i = MAX_TEST_OPTIONS - 1; i > 0; i--)
    {
        new j = random(i + 1);
        new temp = indices[i];
        indices[i] = indices[j];
        indices[j] = temp;
    }

    // Track where the correct option ends up after shuffle
    for (new i = 0; i < MAX_TEST_OPTIONS; i++)
    {
        new optStr[128];
        if (indices[i] == 0)
        {
            format(optStr, sizeof(optStr), "%s", TestQuestions[questionIndex][option0]);
        }
        else if (indices[i] == 1)
        {
            format(optStr, sizeof(optStr), "%s", TestQuestions[questionIndex][option1]);
        }
        else if (indices[i] == 2)
        {
            format(optStr, sizeof(optStr), "%s", TestQuestions[questionIndex][option2]);
        }
        else if (indices[i] == 3)
        {
            format(optStr, sizeof(optStr), "%s", TestQuestions[questionIndex][option3]);
        }
        else
        {
            optStr[0] = '\0';
        }
        format(shuffledOptions[playerid][i], 128, "%s", optStr);

        // Si este índice corresponde a la opción correcta original
        if (indices[i] == originalCorrect)
        {
            correctOptionIndex[playerid] = i; // Guardamos la nueva posición
        }
    }
}

stock ShowQuestion(playerid)
{
    new idx = currentQuestionIndex[playerid];

    if (idx >= MAX_TEST_QUESTIONS)
    {
        if (cAnswers[playerid] >= 6)
        {
            SendClientMessage(playerid, COLOR_GREEN, "¡Felicidades!, completaste el test de rol.");
            // Redirigir al flujo de creación de personaje en el módulo multichar
            CallLocalFunction("AccountRegister_Complete", "i", playerid);
        }
        else
        {
            SendFMessage(playerid, COLOR_ERROR, "Has tenido %d/10 preguntas correctas, necesitas al menos 6 para pasar el test. Deberás realizarlo nuevamente", cAnswers[playerid]);
            AccountRegister(playerid);
        }
        return;
    }

    ShuffleOptions(playerid, idx);

    // Título: mostramos un encabezado corto (evita que el motor de diálogos lo trunque).
    // La pregunta completa se preserva en la variable `qtext` para poder truncarla si es necesario.
    new qtext[256];
    format(qtext, sizeof(qtext), "%s", TestQuestions[idx][questionText]);
    // Recortamos a 120 caracteres para no exceder el límite visual del título
    if (strlen(qtext) > 120)
    {
        qtext[120] = '\0';
        // quitar palabra incompleta al final (opcional) y añadir puntos suspensivos
        qtext[117] = '.'; qtext[118] = '.'; qtext[119] = '.';
    }
    new title[144];
    format(title, sizeof(title), "%d: %s", idx + 1, qtext);

    // Cuerpo solo con opciones (cada línea será una entrada seleccionable)
    new body[512];
    format(body, sizeof(body),
        "%s\n%s\n%s\n%s",
        shuffledOptions[playerid][0],
        shuffledOptions[playerid][1],
        shuffledOptions[playerid][2],
        shuffledOptions[playerid][3]
    );

    Dialog_Show(playerid, DLG_TEST_DYNAMIC, DIALOG_STYLE_LIST,
        title, body, "Siguiente", "");
}


Dialog:DLG_TUT(playerid, response, listitem)
{
    if (!response)
        return KickPlayer(playerid, "el sistema", "evadir test");

    cAnswers[playerid] = 0;
    currentQuestionIndex[playerid] = 0;

    ShowQuestion(playerid);
    return 1;
}
Dialog:DLG_TEST_DYNAMIC(playerid, response, listitem)
{
    if (!response)
        return KickPlayer(playerid, "el sistema", "evadir test");

    if (listitem == correctOptionIndex[playerid])
        cAnswers[playerid]++;

    currentQuestionIndex[playerid]++;
    ShowQuestion(playerid);
    return 1;
}


Dialog:DLG_DESCRIPTION(playerid, response, listitem, inputtext[])
{
    if(!response)
        return KickPlayer(playerid, "el sistema", "evadir registro");
    
    new desc[70];
    format(desc, sizeof(desc), "%s", inputtext);
    
    if(strlen(desc) < 10)
    {
        SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La descripción debe tener al menos 10 caracteres.");
        Dialog_Show(playerid, DLG_DESCRIPTION, DIALOG_STYLE_INPUT, "Descripción del personaje", 
            "Antes de crear tu personaje, escribe una breve descripción física.\n\n\
            Ejemplo: \"Hombre de tez blanca, cabello castaño, ojos marrones\"\n\n\
            {FFD700}Importante:{FFFFFF} Otros jugadores verán tu descripción cuando usen /mirar [tu ID]\n\
            Puedes cambiarla después con /descripcion [texto]\n\n\
            Máximo 65 caracteres:", "Continuar", "");
        return 1;
    }
    
    if(strlen(desc) > 65)
    {
        SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"La descripción es demasiado larga. Máximo 65 caracteres.");
        Dialog_Show(playerid, DLG_DESCRIPTION, DIALOG_STYLE_INPUT, "Descripción del personaje", 
            "Antes de crear tu personaje, escribe una breve descripción física.\n\n\
            Ejemplo: \"Hombre de tez blanca, cabello castaño, ojos marrones\"\n\n\
            {FFD700}Importante:{FFFFFF} Otros jugadores verán tu descripción cuando usen /mirar [tu ID]\n\
            Puedes cambiarla después con /descripcion [texto]\n\n\
            Máximo 65 caracteres:", "Continuar", "");
        return 1;
    }
    
    // Guardar temporalmente la descripción
    format(PlayerInfo[playerid][pDescription], 70, "%s", desc);
    
    // Insertar el personaje en la base de datos con master_account_id y character_slot
    SendClientMessage(playerid, COLOR_GREEN, "Descripción guardada. Creando tu personaje...");
    
    new query[512];
    mysql_format(MYSQL_HANDLE, query, sizeof(query), 
        "INSERT INTO accounts (Name, Password, pDescription, master_account_id, character_slot, FirstLogin) VALUES ('%e', '', '%e', %d, %d, 1)", 
        PlayerInfo[playerid][pName], 
        PlayerInfo[playerid][pDescription], 
        PlayerInfo[playerid][pMasterAccountId], 
        PlayerInfo[playerid][pCharacterSlot]);
    mysql_tquery(MYSQL_HANDLE, query, "OnInsertCharacterAfterTest", "i", playerid);
    
    return 1;
}

Dialog:DLG_REGISTER(playerid, response, listitem, inputtext[])
{
    if(!response)
        return KickPlayer(playerid, "el sistema", "evadir registro");

    new query[512];
    strcat(query, inputtext, sizeof(query));    
    mysql_escape_string(query, query, sizeof(query), MYSQL_HANDLE);
    mysql_format(MYSQL_HANDLE, query, sizeof(query), "INSERT INTO accounts (Name, Password, pDescription, master_account_id, character_slot) VALUES ('%s', MD5('%s'), '%e', %d, %d)", 
        PlayerInfo[playerid][pName], query, PlayerInfo[playerid][pDescription], PlayerInfo[playerid][pMasterAccountId], PlayerInfo[playerid][pCharacterSlot]);	
    mysql_tquery(MYSQL_HANDLE, query, "OnInsertCharacterAfterRegister", "i", playerid);

    return 1;
}

// ==================== CALLBACKS ====================

public OnInsertCharacterAfterTest(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	// El personaje ha sido insertado correctamente, ahora proceder a la creación
	StartAccountFirstLogin(playerid);
	
	return 1;
}

public OnInsertCharacterAfterRegister(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	// El personaje ha sido insertado correctamente, ahora proceder a la creación
	StartAccountFirstLogin(playerid);
	
	return 1;
}