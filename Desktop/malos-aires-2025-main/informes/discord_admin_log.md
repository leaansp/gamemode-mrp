# Log de comandos admin en Discord

## Objetivo
Que cada vez que un admin ejecute un comando administrativo, aparezca un mensaje en un canal de Discord con el formato:
> El administrador (username) ha utilizado el comando administrativo /goto

El "username" es `AccountInfo[playerid][accUsername]` — el mismo que aparece en `/admins`.

## Stack necesario

- **Plugin:** samp-discord-connector (maddinat0r) — compatible con SA-MP 0.3DL (Linux .so)
  - https://github.com/maddinat0r/samp-discord-connector/releases/tag/v0.3.5
- **Referencia Pawn:** pawn-discord-cmd (AkshayMohan)
  - https://github.com/AkshayMohan/pawn-discord-cmd
- **Bot de Discord:** gratuito, se crea en discord.com/developers

## Por qué no se puede sin plugin

SA-MP solo soporta HTTP nativo, no HTTPS. Discord requiere HTTPS obligatoriamente.
Sin instalar el plugin en el VPS no hay forma de enviarle mensajes a Discord.

## Qué hay que subir al VPS

1. `discord-connector.so` → carpeta `plugins/`
2. Editar `server.cfg` → agregar el plugin
3. Crear `discord-connector.cfg` → con el token del bot y el ID del canal

## Cómo subir archivos al VPS

Usar **WinSCP** (gratuito, winscp.net) junto a PuTTY.
- Mismos datos de conexión que PuTTY (IP: 51.222.86.176, puerto 22)
- Interfaz drag & drop al VPS

## Cómo editar server.cfg en el VPS

Desde PuTTY con nano:
```bash
nano /ruta/al/servidor/server.cfg
```
- `Ctrl+O` guardar
- `Ctrl+X` salir

## Hook en Pawn

```pawn
hook OnPlayerCommandText(playerid, cmdtext[])
{
    if(PlayerInfo[playerid][pAdmin] > 0)
    {
        new cmd[64];
        sscanf(cmdtext, "s[64]", cmd);
        // DC_SendChannelMessage(CANAL_ID, "El administrador %s ha utilizado el comando administrativo %s", AccountInfo[playerid][accUsername], cmd);
    }
    return 1;
}
```
