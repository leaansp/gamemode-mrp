# Bug: sistema de crash se activa al subirse como conductor

## Descripción

Al subirse un jugador como conductor a un vehículo detenido, se disparaba
el sistema de choque afectando al conductor y a los pasajeros ya sentados,
mostrando el mensaje "/me sale despedido por el parabrisas y queda herido sobre el capot."

## Causa

`VehicleDamageTimer()` compara la HP actual del vehículo con la anterior cada tick.
Cuando el conductor se sienta, SA-MP modifica internamente la HP del vehículo,
generando un delta falso que supera el umbral de 125 HP (`CRASH_HP_DROP_THRESHOLD`).

`PrevVehicleHP[vehicleid]` nunca se reinicializa al momento de entrada del conductor,
así que el timer lo interpreta como un choque real.

El copiloto que entraba al mismo tiempo no moría porque su estado era
`PLAYER_STATE_ENTER_VEHICLE_PASSENGER` (animación de entrada), ignorado por el loop de `HandleVehicleCrash`.

## Archivos involucrados

- `gamemodes/vehicle/marp_vehicles.pwn`
  - `VehicleDamageTimer()` — línea ~323
  - `HandleVehicleCrash()` — línea ~232
- `gamemodes/vehicle/marp_vehicles.pwn`
  - `OnPlayerStateChange()` — línea 45

## Fix propuesto

En `OnPlayerStateChange`, cuando `newstate == PLAYER_STATE_DRIVER`, resetear
`PrevVehicleHP[vehicleid] = 0.0` para que el timer reinicialice la base en la próxima vuelta.

```pawn
if(newstate == PLAYER_STATE_DRIVER && oldstate == PLAYER_STATE_ONFOOT)
{
    PrevVehicleHP[vehicleid] = 0.0; // evita delta falso al sentarse como conductor
    // ... resto del código existente
}
```

## Cómo testear

1. Un jugador se sienta en el asiento trasero de un auto parado
2. Dos jugadores se suben al mismo tiempo (uno conductor, uno copiloto)
3. **Esperado:** nadie sale despedido
4. Confirmar que chocar fuerte sin cinturón sigue funcionando (no se rompió el sistema legítimo)
5. Confirmar que chocar con cinturón da daño pero no eyecta
