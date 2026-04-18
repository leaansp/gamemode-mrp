# Guía: Agregar edificios custom en SA-MP 0.3DL

## Qué archivos tocar y en qué orden

### 1. `models/artconfig.txt`
Registrar el modelo para que el servidor lo sirva a los clientes.

```
AddSimpleModel(<virtualworld>, <baseid>, <newid>, "<archivo.dff>", "<archivo.txd>");
```

**Reglas importantes:**
- `virtualworld`: usar `0` para el mundo exterior normal, `-1` para que esté disponible en todos los mundos.
- `baseid`: **debe ser un objeto válido de SA-MP con colisión** (ej: 18865). Nunca usar `0` — el servidor lo ignora o falla silenciosamente.
- `newid`: usar un número **negativo entre -1000 y -30000**. Los positivos (ej: 20100) están reservados para skins (`AddCharModel`). El siguiente libre es el que sigue a los ya usados: -2001, -2002 estaban tomados → usamos -2003.
- Los archivos `.dff` y `.txd` van en `models/` y la ruta en artconfig es **relativa a esa carpeta**.

### 2. `gamemodes/map/marp_maps.pwn` — hook `LoadMaps()`
Crear el objeto en el mundo con `CreateDynamicObject` usando el newid asignado.

```pawn
hook LoadMaps() {
    // ...resto del código...
    CreateDynamicObject(-2003, X, Y, Z, RX, RY, RZ, 0, 0, -1, 300.0, 300.0);
    //                                                  ^  ^
    //                                          worldid=0, interiorid=0
}
```

**Nota:** `worldid=0` e `interiorid=0` para el mundo exterior. El stream distance de 300.0 es suficiente para edificios grandes.

### 3. `gamemodes/map/marp_maps.pwn` — hook `RemoveMapsBuildings(playerid)`
Remover el edificio original de SA-MP para que no quede tapando el custom.

```pawn
hook RemoveMapsBuildings(playerid) {
    // ...resto del código...
    RemoveBuildingForPlayer(playerid, <modelid_original>, X, Y, Z, <radio>);
}
```

**Cómo saber el modelid_original:** es el ID del edificio de SA-MP que está en esas coordenadas. Se puede buscar con herramientas como Map Editor o MTA. El radio puede ser grande (250.0) para asegurarse de que cubra el modelo entero.

---

## Dónde se llaman estos hooks

- `LoadMaps()` → se llama desde `OnGameModeInit` en `marp_core.pwn` vía `CallLocalFunction("LoadMaps", "")`.
- `RemoveMapsBuildings(playerid)` → se llama desde `OnPlayerConnectDelayed` en `marp_core.pwn`, que es un **timer de 3 segundos** que se dispara después de `OnPlayerConnect`. No se llama directamente en `OnPlayerConnect`.

---

## Checklist de deploy

1. Archivos `.dff`, `.txd` (y `.col` si tiene colisión custom) colocados en `models/edificios/` (o subcarpeta equivalente).
2. Línea `AddSimpleModel` agregada en `models/artconfig.txt` con baseid válido y newid negativo.
3. `CreateDynamicObject` con el newid en el hook `LoadMaps()`.
4. `RemoveBuildingForPlayer` con el modelid del edificio original en el hook `RemoveMapsBuildings()`.
5. `sampctl build` — **siempre antes de reiniciar**.
6. Reiniciar el servidor — el cliente descarga los modelos al reconectarse.

---

## Qué aprendimos depurando este edificio (market2_lae)

### Problema 1: `baseid=0` en artconfig.txt
La línea original era `AddSimpleModel(0, 0, 20100, ...)`. El baseid `0` es inválido. El servidor acepta la línea pero el cliente no puede cargar el modelo correctamente. **Siempre usar un baseid de un objeto real con colisión.**

### Problema 2: `newid=20100` (positivo)
Los IDs positivos en 0.3DL están reservados para `AddCharModel` (skins). Para objetos de mapa usar siempre IDs negativos.

### Problema 3: el hook `RemoveMapsBuildings` no funcionaba aparentemente
El `RemoveBuildingForPlayer` se ejecuta en `OnPlayerConnectDelayed` (3 segundos post-conexión). El edificio custom sí se creaba (`CreateDynamicObject` retornó ID 24713), pero el original seguía visible porque los hooks de y_hooks estaban encadenados correctamente — el problema real era que el edificio original **no estaba en las coordenadas esperadas** o el `modelid_original` era incorrecto. Una vez corregido, el original se removió y el custom quedó visible.

### Método de debug recomendado

```pawn
// En OnGameModeInit, después de LoadMaps:
printf("DEBUG edificio: %d", CreateDynamicObject(newid, X, Y, Z, ...));
// Si imprime -1 → modelo no registrado o streamer falla
// Si imprime cualquier otro número → objeto creado correctamente

// En hook RemoveMapsBuildings:
printf("DEBUG RemoveBuilding playerid=%d", playerid);
// Si no aparece en el log → el hook no se está encadenando
```
