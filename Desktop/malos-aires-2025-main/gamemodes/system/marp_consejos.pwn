// marp_consejos.pwn
// Sistema de consejos periodicos del servidor

#define TIP_COUNT   (51)
#define TIP_PREFIX  "{FFD700}[¿SABÍAS QUÉ?]{FFFFFF} "
#define TIP_L2_CLR  "{DDDDDD}"

static g_TipTimer;
static g_LastTip = -1;
static bool: g_TipsEnabled[MAX_PLAYERS];

static const g_TipL1[TIP_COUNT][128] = {
	"Si alguien te apunta con un arma y estás desarmado, tenés que cumplir sus órdenes.",
	"Sacar un arma sin ningún /me previo no es rol: es usar la mecánica para ganar",
	"Si chocaste fuerte con un auto, tenés que rolearlo aunque el juego no te quite vida.",
	"Cuando tu personaje tiene menos del 50% de vida, tiene que moverse como alguien herido.",
	"Si presenciaste un crimen en la calle, alguien tiene que llamar al 911.",
	"El /do sirve para describir el entorno o el resultado de una acción.",
	"Después de morir, tu personaje no recuerda nada de lo que pasó.",
	"Si te matan y volvés al mismo lugar a buscar revancha, es revenge kill.",
	"Desconectarte cuando te van a arrestar o matar para evitar las consecuencias",
	"Tu personaje no existe en el vacío. Tiene un barrio, una historia y un motivo",
	"El objetivo del rol no es ganar: es construir una historia interesante con otros.",
	"El objetivo del rol no es ganar: es construir una historia interesante con otros.",
	"El objetivo del rol no es ganar: es construir una historia interesante con otros.",
	"El /me debe escribirse en minúsculas y con todos los signos de puntuación.",
	"No podés saber lo que tu personaje no vio. Si no estabas en la conversación,",
	"Hacer zigzag durante un tiroteo para esquivar balas no es estrategia, es bug abuse.",
	"Saltar repetidamente para moverte más rápido no existe en la realidad.",
	"Estacionar en la vereda, en contramano o bloqueando una entrada no es rol.",
	"No uses términos del juego cuando hablás como tu personaje.",
	"Un robo necesita contexto. No podés aparecer de la nada y encañonar a alguien",
	"No podés robarle a alguien que encontraste muerto.",
	"Rematar a un jugador caído sin ningún /me o interacción previa es una falta grave.",
	"El personaje que interpreta un policía o médico tiene una responsabilidad narrativa mayor.",
	"Si tu personaje pertenece a una banda, su comportamiento en el barrio rival debe reflejarlo.",
	"Interpretar bien a un personaje incluye sus miedos, sus límites y sus contradicciones.",
	"El character kill es la muerte permanente del personaje, no se hace a la ligera.",
	"Si un admin te aplica un PK, perdés la memoria de ese evento específico.",
	"Usar el /b para quejarte de cómo te rolearon mientras la situación sigue activa",
	"Las consecuencias del rol son reales. Si le debés plata a alguien, tu personaje le debe.",
	"En una toma de rehenes, las exigencias tienen que ser lógicas y alcanzables.",
	"Si necesitás aclarar algo OOC, usás /b una sola vez y de forma breve.",
	"Si presenciaste un crimen y no sos parte del conflicto, tu personaje igual reacciona.",
	"Dentro de una facción hay jerarquía. Tu personaje respeta a sus superiores",
	"Podés usar /negociosactivos para ver las zonas de rol activas.",
	"Si tu personaje consume alcohol o drogas, tiene que notarse en cómo habla y decide.",
	"Ir al hospital no es solo aparecer con vida llena al rato.",
	"Tu casa y tu negocio tienen historia. No son solo menús de opciones.",
	"Si escuchaste algo en el /b, no podés usarlo como información de tu personaje.",
	"Tu personaje cambia con el tiempo. Las experiencias que vive lo afectan.",
	"Tu personaje cambia con el tiempo. Las experiencias que vive lo afectan.",
	"Tu personaje cambia con el tiempo. Las experiencias que vive lo afectan.",
	"El crimen tiene que tener una motivación real: por necesidad, por encargo o por venganza.",
	"La lealtad dentro de una banda tiene peso. Si tu personaje traiciona a alguien,",
	"Denunciar a alguien a la policía tiene consecuencias para tu personaje.",
	"El auto de tu personaje dice algo de él. Un delincuente con un Ferrari llama la atención.",
	"La hora del día y el clima afectan el rol. Tu personaje adapta su comportamiento al entorno,",
	"El dinero de tu personaje representa su situación de vida.",
	"Explotar un bug del juego, aunque te convenga, es falta.",
	"Tu personaje tiene reputación en la ciudad.",
	"Cuando roleás una pelea sin armas, los golpes necesitan /me. El resultado no es inmediato.",
	"El rol de un secuestro requiere un propósito narrativo claro."
};

static const g_TipL2[TIP_COUNT][128] = {
	"Tu personaje tiene miedo a morir, igual que cualquier persona real.",
	"una situación sin darle ninguna interpretación al personaje.",
	"Un choque a 120 km/h no se puede ignorar.",
	"No podés correr normalmente como si nada.",
	"La ciudad está llena de civiles. Aunque no los veas, existen en el universo del rol.",
	"",
	"No sabe quién lo mató, ni dónde estaba, ni por qué razón.",
	"Tu personaje no recuerda nada de lo que pasó.",
	"es una de las faltas más graves del servidor y es motivo de baneo.",
	"para estar en la ciudad. Todo eso debería verse en cómo actúa.",
	"Perder bien vale más que ganar mal.",
	"Perder bien vale más que ganar mal.",
	"Perder bien vale más que ganar mal.",
	"Ejemplo: /me procede a tomar el trapo y lavar la llanta de su vehículo.",
	"no podés actuar sobre ella aunque la hayas leído en pantalla.",
	"Una persona real no puede esquivar proyectiles corriendo en zigzag.",
	"En el rol, tu personaje tiene cansancio y peso.",
	"Tu personaje sabe manejar y conoce las normas de tránsito.",
	"Decir que tenías poca HP o que alguien te hizo DM rompe el universo del rol.",
	"sin ningún desarrollo previo. El crimen tiene lógica y motivación.",
	"El robo requiere condiciones mínimas de interacción real.",
	"El personaje en el piso sigue siendo un personaje con historia.",
	"No es para farmear dinero: es para generar rol y dar el ejemplo.",
	"No podés caminar tranquilo donde sos enemigo.",
	"Un PJ que no tiene miedo a nada y siempre gana no es un personaje, es un fantaseo.",
	"Requiere acuerdo entre los jugadores involucrados o una falta muy grave.",
	"Esa parte de tu historia se borra y no podés actuar sobre ella.",
	"rompe la escena para todos los que participan y es motivo de sanción.",
	"Si traicionaste a tu banda, las consecuencias IC son reales.",
	"Pedir un helicóptero para soltar a un kiosquero no es rol serio.",
	"Evitemos tener una discusión completa en OOC mientras transcurre el rol.",
	"Puede llamar al 911, alejarse rápido o esconderse. Los testigos existen.",
	"aunque vos no estés de acuerdo. Eso es interpretar el rol de tu rango.",
	"",
	"No podés estar borracho en el rol y actuar con reflejos perfectos.",
	"Tu personaje fue atendido y tiene limitaciones físicas por un tiempo razonable.",
	"Tu personaje los consiguió con esfuerzo y eso se refleja en cómo los trata.",
	"El /b no existe en el universo del juego: es invisible para todos los personajes.",
	"Alguien que perdió a un amigo no actúa igual que antes. Construí una historia.",
	"Alguien que perdió a un amigo no actúa igual que antes. Construí una historia.",
	"Alguien que perdió a un amigo no actúa igual que antes. Construí una historia.",
	"Robar porque sí, sin interpretación, no es válido.",
	"las consecuencias IC son reales y la reputación se construye con esas decisiones.",
	"No es un botón que apretás sin que nadie lo sepa: quedás expuesto como testigo.",
	"Un civil con un auto modesto es invisible. Eso es interpretar un personaje.",
	"y eso se refleja en la calidad de tu interpretación.",
	"Alguien con poco dinero no debería actuar como millonario, salvo que su historia lo justifique.",
	"En el rol, la integridad de la escena importa más que el resultado mecánico.",
	"Asegurate de construir una historia coherente y acorde a su forma de ser.",
	"Rolear recibir un golpe y reaccionar tiene más calidad y es más realista.",
	"Si secuestrás a alguien, tiene que ser para conseguir algo concreto dentro de la historia."
};

hook OnGameModeInit() {
	for(new i = 0; i < MAX_PLAYERS; i++)
		g_TipsEnabled[i] = true;
	g_TipTimer = SetTimer("Timer_Consejo", 5 * 60 * 1000, true);
	return 1;
}

hook OnPlayerConnect(playerid) {
	g_TipsEnabled[playerid] = true;
	return 1;
}

forward Timer_Consejo();
public Timer_Consejo() {
	new idx;
	do {
		idx = random(TIP_COUNT);
	} while(idx == g_LastTip);
	g_LastTip = idx;

	new str[256];
	for(new i = 0; i < MAX_PLAYERS; i++) {
		if(!IsPlayerConnected(i) || !g_TipsEnabled[i])
			continue;
		format(str, sizeof(str), TIP_PREFIX"%s", g_TipL1[idx]);
		SendClientMessage(i, -1, str);
		if(g_TipL2[idx][0]) {
			format(str, sizeof(str), TIP_L2_CLR"%s", g_TipL2[idx]);
			SendClientMessage(i, -1, str);
		}
	}
	return 1;
}

CMD:desactivarconsejos(playerid, params[]) {
	if(!g_TipsEnabled[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya tenés los consejos desactivados. Usá /activarconsejos para volver a recibirlos.");
	g_TipsEnabled[playerid] = false;
	return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Consejos desactivados. Usá /activarconsejos para volver a recibirlos.");
}

CMD:activarconsejos(playerid, params[]) {
	if(g_TipsEnabled[playerid])
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Ya tenés los consejos activados.");
	g_TipsEnabled[playerid] = true;
	return SendClientMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Consejos activados. Recibirás un consejo cada 5 minutos.");
}

CMD:vertip(playerid, params[]) {
	if(AccountInfo[playerid][accAdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tenés permisos para usar este comando.");

	new idx = -1;
	sscanf(params, "i", idx);
	if(idx < 0 || idx >= TIP_COUNT)
		idx = random(TIP_COUNT);

	new str[256];
	format(str, sizeof(str), TIP_PREFIX"%s", g_TipL1[idx]);
	SendClientMessage(playerid, -1, str);
	if(g_TipL2[idx][0]) {
		format(str, sizeof(str), TIP_L2_CLR"%s", g_TipL2[idx]);
		SendClientMessage(playerid, -1, str);
	}
	SendFMessage(playerid, COLOR_INFO, "[INFO] "COLOR_EMB_GREY"Tip #%d de %d (0 a %d).", idx, TIP_COUNT, TIP_COUNT - 1);
	return 1;
}
