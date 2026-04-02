# Bug: Vehículos se convierten en Mesa y aparecen en el mar

**Fecha de análisis:** 2026-04-02
**Branch:** feature/hotkeys
**Severidad:** Alta — afecta a todos los vehículos del servidor

---

## Descripción del síntoma

- Vehículos sin dueño ni modelo asignado aparecen en coordenadas (9999, 9999, 0), que en el mapa de GTA:SA corresponde a una zona fuera de límites sobre el mar.
- Esos vehículos tienen modelo 500 (Mesa) porque así quedan después de ser "borrados".
- Al usar `/avtraer <id>` sobre un vehículo que SÍ tiene dueño, a veces llega transformado en Mesa, o teleporta al slot equivocado y spawnea en el mar.

---

## Causa raíz — tres bugs encadenados

### Bug 1: `Veh_Delete` sobreescribe el estado ANTES de recrear el vehículo SA-MP

**Archivo:** `gamemodes/vehicle/marp_vehicles_core.pwn`, líneas 762–810

```pawn
Veh_Delete(vehicleid) {
    VehicleInfo[vehicleid][VehType]        = VEH_NONE;   // L765
    VehicleInfo[vehicleid][VehRespawnTime] = -1;          // L766
    VehicleInfo[vehicleid][VehModel]       = 500;         // L767  <- Mesa
    VehicleInfo[vehicleid][VehPosX]        = 9999.0;      // L768
    VehicleInfo[vehicleid][VehPosY]        = 9999.0;      // L769
    VehicleInfo[vehicleid][VehPosZ]        = 9999.0;      // L770
    // ...
    Veh_RecreateWithUpdatedParams(vehicleid);              // L803 <- crea un Mesa en (9999, 9999, 9999)
    SaveVehicle(vehicleid);                                // L808 <- guarda ese estado corrupto en la DB
}
```

**Efecto:** Cada vehículo "borrado" queda persistido en la base de datos con modelo Mesa y coordenadas en el mar. Si el servidor se reinicia, ese vehículo carga como Mesa en el mar.

**Nota:** Este comportamiento es parcialmente intencional — los vehículos sin dueño se guardan como Mesa en el mar para quedar disponibles como slot libre para la próxima compra. El problema ocurre cuando el desync contamina vehículos activos con dueño.

---

### Bug 2: `Veh_RecreateWithUpdatedParams` descarta el ID devuelto por `CreateVehicle`

**Archivo:** `gamemodes/vehicle/marp_vehicles_core.pwn`, líneas 951–962

```pawn
Veh_RecreateWithUpdatedParams(vehicleid)
{
    DestroyVehicle(vehicleid);                           // libera el slot SA-MP
    CreateVehicle(                                       // <-- return value DESCARTADO
        VehicleInfo[vehicleid][VehModel],
        VehicleInfo[vehicleid][VehPosX],
        ...
    );
}
```

`CreateVehicle` devuelve el nuevo vehicle ID asignado por SA-MP. SA-MP reutiliza slots en orden, pero **no garantiza** que el nuevo ID sea el mismo que el destruido. Si otro sistema crea un vehículo en el mismo frame, o si los slots están desincronizados por reinicios o disconnects, el nuevo vehículo puede quedar en un slot distinto al esperado.

**Efecto:**
- `VehicleInfo[vehicleid]` queda apuntando al slot SA-MP equivocado.
- El vehículo real existe en el slot Y, pero el sistema lo sigue tratando como si estuviera en el slot X.
- Esto contamina a otros vehículos: el SA-MP slot X ahora pertenece a otro vehículo pero `VehicleInfo[X]` sigue guardando datos del vehículo borrado (Mesa / 9999).

**Ejemplo concreto:**

```
Servidor tiene 100 vehículos activos: slots 1..100
Se borra el vehículo en slot 50 → DestroyVehicle(50) libera slot 50
Se llama CreateVehicle(Mesa, 9999...) → SA-MP devuelve ID 50 [ok en este caso]

Más tarde: se llama Veh_RecreateWithUpdatedParams(75) para actualizar tuning
→ DestroyVehicle(75) libera slot 75
→ CreateVehicle(Infernus, ...) → SA-MP devuelve ID 50 porque 50 fue liberado antes por otro proceso

Resultado:
  VehicleInfo[75] cree que el Infernus está en slot 75 (vacío)
  VehicleInfo[50] cree que el Mesa borrado está en slot 50, pero slot 50 ahora ES el Infernus
```

---

### Bug 3: `OnVehicleSpawn` con `VEH_NONE` siempre manda al mar

**Archivo:** `gamemodes/vehicle/marp_vehicles_core.pwn`, líneas 183–192

```pawn
public OnVehicleSpawn(vehicleid)
{
    switch(VehicleInfo[vehicleid][VehType])
    {
        case VEH_NONE: {
            SetVehiclePos(vehicleid, 9999.0, 9999.0, 0.0);  // <- mar / off-map
        }
        case VEH_CREATED: {
            return Veh_Delete(vehicleid);
        }
        // ...
    }
}
```

Cualquier vehículo cuyo tipo en `VehicleInfo` sea `VEH_NONE` en el momento de su respawn es enviado a (9999, 9999, 0). Si el Bug 2 desincronizó los IDs, un vehículo con dueño puede terminar aquí.

---

### Bug 4: Maletero roto después de `Veh_RecreateWithUpdatedParams`

**Archivo:** `gamemodes/vehicle/marp_vehicles_core.pwn`, líneas 951–962

`Veh_RecreateWithUpdatedParams` llama `DestroyVehicle` + `CreateVehicle`, lo que destruye el attachment del área dinámica del streamer (el cuboid del maletero). Funciones como `/avestacionar`, cambio de color y cambio de modelo llamaban esta función sin recrear el área después.

**Efecto:** Después de usar `/avestacionar`, el jugador no podía abrir el maletero aunque el contenedor y los ítems seguían intactos en memoria y DB.

---

## Cadena completa para el bug de `/avtraer`

```
Admin hace /avtraer 42 (vehículo con dueño, Infernus)

1. Veh_IsValidId(42) → pasa (VehicleInfo[42][VehType] != VEH_NONE)

2. GetVehicleModel(42) → SA-MP devuelve el modelo del slot 42 físico
   PROBLEMA: si hubo desincronización (Bug 2), el slot SA-MP 42 físico
   es ahora un Mesa, aunque VehicleInfo[42] diga "Infernus"

3. GetVehicleModelInfo(500 /*Mesa*/, VEHICLE_MODEL_INFO_SIZE, x, y, z)
   → dist se calcula con el tamaño del Mesa, no del Infernus

4. TeleportVehicleTo(42, ...) → SetVehiclePos(42, x_admin, y_admin, z_admin)
   → mueve el SA-MP vehicle 42, que es un Mesa → el admin ve aparecer un Mesa

5. Si en algún momento el respawn de ese vehículo se dispara,
   OnVehicleSpawn(42) → VehicleInfo[42][VehType] puede ser VEH_NONE
   → SetVehiclePos(42, 9999.0, 9999.0, 0.0) → se va al mar
```

---

## Resumen de archivos involucrados

| Archivo | Líneas clave | Rol en el bug |
|---|---|---|
| `gamemodes/vehicle/marp_vehicles_core.pwn` | 762–810 | `Veh_Delete` sobreescribe estado y guarda Mesa/9999 en DB |
| `gamemodes/vehicle/marp_vehicles_core.pwn` | 951–962 | `Veh_RecreateWithUpdatedParams` descarta return de `CreateVehicle` |
| `gamemodes/vehicle/marp_vehicles_core.pwn` | 183–192 | `OnVehicleSpawn` manda VEH_NONE al mar |
| `gamemodes/vehicle/marp_vehicles_trunk.pwn` | 104–112 | `VehTrunk_Reload` no recreaba área si no existía previamente |
| `gamemodes/vehicle/marp_vehicles_admin.pwn` | 221–249 | `/avtraer` usa `GetVehicleModel` del SA-MP slot (puede ser Mesa) |
| `gamemodes/system/marp_teleport.pwn` | 105–135 | `TeleportVehicleTo` hace `SetVehiclePos` sin verificar estado |

---

## Fixes implementados

### Fix 1: `VehTrunk_Reload` siempre recrea el área dinámica

**Archivo:** `gamemodes/vehicle/marp_vehicles_trunk.pwn`

Antes solo recreaba el área si ya existía una válida. Ahora siempre la crea si el vehículo tiene espacio de maletero y está activo, independientemente de si existía antes.

```pawn
VehTrunk_Reload(vehicleid)
{
    if(IsValidDynamicArea(VehicleInfo[vehicleid][VehTrunkArea]))
    {
        DestroyDynamicArea(VehicleInfo[vehicleid][VehTrunkArea]);
        VehicleInfo[vehicleid][VehTrunkArea] = STREAMER_TAG_AREA:0;
    }
    if(Veh_GetTrunkSpace(vehicleid) > 0 && VehicleInfo[vehicleid][VehType] != VEH_NONE)
    {
        VehTrunk_CreateDynamicArea(vehicleid);
    }
}
```

### Fix 2: `VehTrunk_Reload` llamado en `Veh_RecreateWithUpdatedParams`

**Archivo:** `gamemodes/vehicle/marp_vehicles_core.pwn`

Agregado al final de `Veh_RecreateWithUpdatedParams`, cubriendo automáticamente `/avestacionar`, cambio de color, cambio de modelo y cualquier otra función que recree el vehículo. El maletero ya no se rompe nunca más en esos contextos.

### Fix 3: `/avfixmodel` detecta desync del slot SA-MP

**Archivo:** `gamemodes/vehicle/marp_vehicles_admin.pwn`

Agregado Check 1 al callback `Veh_OnCheckModelFromDB`: compara `GetVehicleModel(vehicleid)` vs `VehicleInfo[vehicleid][VehModel]`. Si difieren, recrea con el modelo correcto y avisa solo al admin:

```
[INFO] Este auto es un Benson, no es un Mesa. Vehiculo recreado.
[INFO] Revisa el maletero del vehiculo 399.
[INFO] Recordale al usuario que utilice /avestacionar para fijar la posicion
       actual y evitar que vuelva a pasar al reiniciar.
```

### Fix 4: `/avfixallmodels` con Check 1 (desync SA-MP)

**Archivo:** `gamemodes/vehicle/marp_vehicles_admin.pwn`

El comando ahora ejecuta dos chequeos en orden para cada vehículo activo:

1. **Check 1** — `GetVehicleModel(id) != VehicleInfo[id][VehModel]` → desync del slot SA-MP → recrea con VehicleInfo como fuente de verdad, guarda en DB
2. **Check 2** — `VehicleInfo[id][VehModel] != DB` → corrupción en memoria → recrea con el modelo de la DB

### Fix 5: Auto scan 1 minuto después del arranque

**Archivo:** `gamemodes/vehicle/marp_vehicles_admin.pwn`

Hook en `Veh_OnAllDataLoaded` que dispara un timer de 60 segundos. Al ejecutarse:

1. Avisa a todos los jugadores conectados:
   ```
   [INFO] El sistema esta verificando los vehiculos. Puede existir un leve lag
          grafico por 1 o 2 segundos. Gracias por tu paciencia!
   ```
2. Corre el scan completo (Check 1 + Check 2)
3. Informa el resultado:
   ```
   [INFO] Verificacion de vehiculos completada. X vehiculos corregidos.
   ```

Cada corrección individual queda registrada en el log del servidor con `[AUTO SCAN]`.

---

## Pendiente (causa raíz sin resolver)

El Bug 2 (`Veh_RecreateWithUpdatedParams` descarta el return de `CreateVehicle`) **sigue sin atacarse directamente**. Los fixes implementados son paliativos que detectan y corrigen el desync cuando ocurre, pero no lo previenen.

Para atacar la causa raíz habría que capturar el return de `CreateVehicle` y remapear `VehicleInfo` si el ID difiere — cambio complejo y riesgoso que requiere confirmación del bug en producción primero.

**Indicador para confirmar causa raíz:** si el auto scan de 1 minuto reporta correcciones consistentemente después de cada reinicio, el bug está en `Veh_RecreateWithUpdatedParams` durante `Veh_OnAllDataLoad` (línea 294 de `marp_vehicles_core.pwn`).

---

## Flujo operativo actual para admins

1. Jugador reporta auto convertido en Mesa
2. Admin corre `/avfixmodel <id>` estando cerca del auto
3. Si hay desync: auto se recrea con modelo correcto, admin ve los mensajes informativos
4. Admin le dice al jugador que use `/avestacionar` para fijar la posición
5. Si hay muchos autos afectados: `/avfixallmodels` (nivel 20)

---

## Queries SQL de diagnóstico

```sql
-- Ver vehículos borrados correctamente (Mesa en el mar)
SELECT COUNT(*) FROM vehicles WHERE VehModel = 500 AND VehPosX = 9999.0;

-- Ver todos los Mesa (para revisión manual)
SELECT VehSQLID, VehModel, VehOwnerName, VehPosX, VehPosY
FROM vehicles WHERE VehModel = 500;

-- Borrar registros Mesa corruptos (confirmar antes)
DELETE FROM vehicles WHERE VehModel = 500 AND VehPosX = 9999.0;
```

---

## Otros fixes de la misma sesión

### `IsValidSkin` — rango extendido hasta 20092

**Archivo:** `gamemodes/util/marp_util.pwn`, línea 230

El rango de skins custom estaba limitado a `20001–20070` pero las skins llegan hasta `20092`. El comando `/skin` y el sistema de actores rechazaban IDs entre 20071 y 20092.

```pawn
// Antes:
return (((1 <= skin <= 311) && skin != 74) || (20001 <= skin <= 20070));

// Después:
return (((1 <= skin <= 311) && skin != 74) || (20001 <= skin <= 20092));
```

El `/ropero` ya tenía su propio rango correcto (`ROPERO_SKIN_MAX = 20092`) y no se modificó.
