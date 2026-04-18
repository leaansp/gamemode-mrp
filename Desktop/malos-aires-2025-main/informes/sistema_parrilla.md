# Sistema de Parrilla (Asador) — Diseño e Implementación Pendiente

## Concepto

Los jugadores pueden comprar una parrilla, cargarla con ambas manos, colocarla en la calle y usarla para cocinar choripanes. El sistema de cocción (`marp_asador.pwn`) ya existe — lo que falta es el ítem comprable y los comandos de colocar/levantar.

---

## Flujo completo

1. **Comprar** — en un negocio 24-7, aparece en el catálogo con preview 3D del modelo `19831`
2. **Llevar** — queda en la mano con animación de carga (`SPECIAL_ACTION_CARRY`), ambas manos ocupadas, no entra al bolsillo
3. **Guardar en maletero** — ocupa **2 unidades** del trunk del vehículo
4. **Colocar** — comando `/colocarparrilla` → crea `CreateDynamicObject(19831, ...)` en la posición del jugador, saca el ítem de la mano
5. **Cocinar** — `/choripan` con chorizo en mano → pone chorizo, cocina en 10 segundos, produce 3 choripanes
6. **Levantar** — `/choripan` cerca de la parrilla sin chorizo y sin choripanes listos → levanta la parrilla, vuelve al ítem en mano, destruye el objeto

---

## Implementación requerida

### 1. `gamemodes/item/marp_item_model_ids.pwn`
Agregar:
```pawn
#define ITEM_ID_ASADOR  (326) // o el siguiente ID libre
```

### 2. `gamemodes/item/marp_item_model_data.pwn`
Agregar entrada con:
- `objectModel = 19831`
- `itemTag = ITEM_TAG_BOTH_HANDS | ITEM_TAG_SAVE | ITEM_TAG_GIVE`
- `OccupiedSpace = 2`
- `name = "Parrilla"`

### 3. `gamemodes/business/marp_biz_prods_manage.pwn`
Agregar `ITEM_ID_ASADOR` a la lista del **24-7**:
```pawn
//24-7
{..., ITEM_ID_CHORIZO, ITEM_ID_ASADOR, 0},
```

### 4. `gamemodes/system/marp_asador.pwn`
- Nuevo comando `/colocarparrilla` — verifica que el jugador tenga `ITEM_ID_ASADOR` en mano, verifica zona de exclusión, crea el objeto y saca el ítem
- Modificar `/choripan` — cuando no hay chorizo NI choripanes listos, levantar la parrilla (agregar ítem a mano, destruir objeto)

---

## Zonas de exclusión

Para evitar crashes en zonas con muchos objetos de mapeo, no se puede colocar parrilla en ciertas áreas densas.

### Implementación
```pawn
static const Float:NoAsadorZones[][4] = {
    // {X, Y, Z, Radio}
    {0.0, 0.0, 0.0, 150.0},  // Villa Fierro — PENDIENTE coordenadas
};
```

Antes de `CreateDynamicObject` en `/colocarparrilla`:
```pawn
for (new i = 0; i < sizeof(NoAsadorZones); i++) {
    if (IsPlayerInRangeOfPoint(playerid, NoAsadorZones[i][3], NoAsadorZones[i][0], NoAsadorZones[i][1], NoAsadorZones[i][2]))
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] No podes colocar una parrilla en esta zona.");
}
```

### Cómo calcular el radio de una zona
1. Conectarse al servidor test
2. Pararse en el **extremo A** (entrada o esquina) → `/getpos` → anotar X, Y
3. Caminar hasta el **extremo B** más lejano → `/getpos` → anotar X, Y
4. El radio = distancia entre A y B / 2
5. El centro = punto medio entre A y B

Fórmula de distancia: `sqrt((X2-X1)^2 + (Y2-Y1)^2)`

### Zonas pendientes de medir
- [ ] Villa Fierro — medir con `/getpos` en los dos extremos más lejanos

---

## Notas técnicas

- El catálogo del negocio muestra preview 3D automáticamente usando `ItemModel_GetObjectModel()` — no requiere código extra
- `ITEM_TAG_BOTH_HANDS` activa `SPECIAL_ACTION_CARRY` y animación `liftup105` automáticamente al sacar del maletero
- El sistema de cooking de `marp_asador.pwn` ya funciona — detecta objetos con model `19831` en rango 3.0 unidades
- El chorizo ya se vende en el 24-7 (`ITEM_ID_CHORIZO = 322`, "Bolsa con 3 chorizos")
- Riesgo de crash: el streamer crashea si hay más de 1000 objetos dentro de 300 unidades de un jugador — por eso las zonas de exclusión

---

## Estado actual

- [x] Sistema de cooking (`marp_asador.pwn`) — funciona, detecta objeto `19831`
- [ ] `ITEM_ID_ASADOR` registrado
- [ ] Datos del ítem en `marp_item_model_data.pwn`
- [ ] Agregado al catálogo del 24-7
- [ ] Comandos `/colocarparrilla` y lógica de levantar
- [ ] Coordenadas de zonas de exclusión medidas
- [ ] Zonas de exclusión implementadas
