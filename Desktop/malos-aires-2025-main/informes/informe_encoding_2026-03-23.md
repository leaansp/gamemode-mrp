# Informe: Corrección de Encoding (Tildes y Caracteres Especiales)
**Fecha:** 23/03/2026
**Estado:** Resuelto

---

## Problema

Los caracteres especiales del español (á, é, í, ó, ú, ñ, ¡, ¿) aparecían como símbolos raros o signos de interrogación en el chat y diálogos del servidor.

Ejemplo visible: `[INFO] ¡Bienvenido!` se mostraba como `[INFO] Â¡Bienvenido!` o similar.

---

## Causa raíz

**SA-MP trata los strings como bytes crudos.** El compilador Pawn lee el archivo fuente y mete los bytes directamente en el `.amx`. El cliente de GTA:SA espera recibir esos bytes en **Windows-1252** (Latin Occidental).

El problema: **VS Code por defecto guarda los archivos en UTF-8.** En UTF-8, un caracter como `¡` ocupa 2 bytes (`0xC2 0xA1`), mientras que en Windows-1252 ocupa 1 byte (`0xA1`). El servidor mandaba los 2 bytes UTF-8, el cliente los interpretaba como 2 caracteres Windows-1252 distintos → basura en pantalla.

### ¿Cómo llegaron los archivos a estar en UTF-8?
En sesiones anteriores, VS Code abrió archivos `.pwn` (que estaban en Windows-1252) y los guardó en UTF-8 al editarlos, ya que no tenía configurado el encoding correcto.

---

## Archivos afectados

| Archivo | Problema | Solución |
|---|---|---|
| `gamemodes/marp_core.pwn` | UTF-8 en producción | Restaurado desde GitLab + re-aplicados 2 includes |
| `gamemodes/player/marp_inventory.pwn` | UTF-8 | Restaurado + re-aplicadas hotkeys |
| `gamemodes/item/marp_objects.pwn` | UTF-8 | Restaurado + re-aplicado QuickDropObject |
| `gamemodes/item/marp_toy.pwn` | UTF-8 | Restaurado + re-aplicados cambios holster |

Los archivos `marp_item_model_data.pwn`, `marp_item_model_ids.pwn` y `marp_vehicles.pwn` ya estaban en Windows-1252 correctamente.

---

## Solución aplicada

1. **Protección futura:** Se creó `.vscode/settings.json` en la raíz del proyecto:
   ```json
   {
       "files.encoding": "windows1252",
       "files.autoGuessEncoding": false
   }
   ```
   Esto obliga a VS Code a tratar todos los `.pwn` como Windows-1252 siempre que el proyecto esté abierto desde la carpeta raíz.

2. **Restauración de archivos:** Se copiaron los archivos originales desde `gitlab_clean/` (versiones Windows-1252 correctas) usando Python con lectura/escritura binaria para no alterar el encoding.

3. **Re-aplicación de cambios:** Todos los cambios de la sesión (hotkeys, holster, QuickDropObject, includes) se re-aplicaron encima de los archivos limpios, usando texto ASCII puro para no introducir nuevos problemas de encoding.

---

## Reglas para el futuro

- **Siempre abrir VS Code desde la carpeta raíz del proyecto** (no archivos sueltos ni subcarpetas) para que el `.vscode/settings.json` aplique.
- El riesgo de corrupción **solo existe al guardar**, no al leer.
- Si se sospecha corrupción en un archivo, verificar con:
  ```python
  with open('archivo.pwn', 'rb') as f:
      data = f.read()
  # Si hay muchos \xc2 o \xc3 → está en UTF-8
  print(data.count(b'\xc2') + data.count(b'\xc3'))
  ```
- Para chequeo masivo del proyecto, usar el script de detección incluido en la sesión.

---

## Verificación

`sampctl build` compila con exactamente **5 warnings** (pre-existentes, sobre truncamiento de símbolo en `marp_toy.pwn`). Sin errores nuevos.
