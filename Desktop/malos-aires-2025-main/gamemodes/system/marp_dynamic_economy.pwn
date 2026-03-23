#if defined _marp_dynamic_economy_included
    #endinput
#endif
#define _marp_dynamic_economy_included

#include <YSI_Coding\y_hooks>

// ============================================================================
//  SISTEMA DE ECONOMÍA DINÁMICA (VERSIÓN SIMPLE)
//  - Carga sueldos desde la tabla job_economy
//  - Permite modificarlos y guardarlos
//  - Comandos: /setjobsueldo /versueldos /guardarjobs
// ============================================================================

// Dependencias externas
//extern MySQL:MYSQL_HANDLE;
//extern JobInfo[][e_job_info];

// ============================================================================
// DIÁLOGOS
// ============================================================================
enum {
    DLG_ECONOMY_VERSUELDOS = 8500,
    DLG_ECONOMY_EDITSUELDO
}

// Variable temporal para almacenar el job seleccionado
static g_SelectedJobId[MAX_PLAYERS];

// ============================================================================
// FUNCIONES DE UTILIDAD
// ============================================================================

static stock bool:IsValidJobId(jobid)
{
    return (jobid > 0 && jobid < sizeof(JobInfo));
}

// ============================================================================
// CARGA DE SUELDOS DESDE SQL
// ============================================================================
stock Economy_LoadJobSalaries()
{
    mysql_tquery(MYSQL_HANDLE,
        "SELECT job_id, salary_base FROM job_economy;",
        "OnEconomy_LoadJobSalaries");
    return 1;
}

forward OnEconomy_LoadJobSalaries();
public OnEconomy_LoadJobSalaries()
{
    new rows = cache_num_rows();
    if (!rows)
    {
        printf("[ECONOMIA] Tabla job_economy vacía o no inicializada.");
        return 1;
    }

    new loaded;
    for (new i = 0; i < rows; i++)
    {
        new jobid, salary;
        cache_get_value_name_int(i, "job_id", jobid);
        cache_get_value_name_int(i, "salary_base", salary);

        if (!IsValidJobId(jobid)) continue;
        if (JobInfo[jobid][jType] != 1) continue; // 1 = legal

        JobInfo[jobid][jBaseSalary] = salary;
        loaded++;
    }

    printf("[ECONOMIA] Sueldos cargados desde SQL para %d trabajos legales.", loaded);
    return 1;
}

// ============================================================================
// GUARDADO INDIVIDUAL
// ============================================================================
stock Economy_SaveJobSalary(jobid)
{
    if (!IsValidJobId(jobid)) return 0;
    if (JobInfo[jobid][jType] != 1) return 0;

    new query[256];
    mysql_format(MYSQL_HANDLE, query, sizeof(query),
        "INSERT INTO job_economy (job_id, salary_base) VALUES (%d, %d) ON DUPLICATE KEY UPDATE salary_base=%d",
        jobid, JobInfo[jobid][jBaseSalary], JobInfo[jobid][jBaseSalary]);
    mysql_tquery(MYSQL_HANDLE, query);
    return 1;
}

// ============================================================================
// GUARDADO MASIVO
// ============================================================================
stock Economy_SaveAllJobSalaries()
{
    new query[1024];
    for (new i = 1; i < sizeof(JobInfo); i++)
    {
        if (JobInfo[i][jType] != 1) continue;

        new sub[256];
        format(sub, sizeof(sub),
            "INSERT INTO job_economy (job_id, salary_base) VALUES (%d, %d) ON DUPLICATE KEY UPDATE salary_base = VALUES(salary_base);",
            i, JobInfo[i][jBaseSalary]);
        strcat(query, sub);
    }

    if (strlen(query))
    {
        mysql_tquery(MYSQL_HANDLE, query);
        printf("[ECONOMIA] Sueldos de todos los trabajos legales guardados en SQL.");
    }
    return 1;
}

// ============================================================================
// MODIFICAR SUELDO EN MEMORIA + BD
// ============================================================================
stock bool:Economy_SetJobSalary(jobid, newSalary)
{
    if (!IsValidJobId(jobid)) return false;
    if (JobInfo[jobid][jType] != 1) return false;
    if (newSalary < 0) return false;

    JobInfo[jobid][jBaseSalary] = newSalary;
    Economy_SaveJobSalary(jobid);
    return true;
}

// ============================================================================
// COMANDOS ADMINISTRATIVOS
// ============================================================================


CMD:setjobsueldo(playerid, params[])
{
    if(AccountInfo[playerid][accAdminLevel] < 14)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

    new jobid, amount;
    if (sscanf(params, "ii", jobid, amount))
        return SendClientMessage(playerid, COLOR_USAGE, "[USO] "COLOR_EMB_GREY"/setjobsueldo [jobid] [monto]");

    if (!Economy_SetJobSalary(jobid, amount))
        return SendClientMessage(playerid, -1, "Error: job inválido, ilegal o monto negativo.");

    new msg[128];
    format(msg, sizeof msg, "Sueldo de '%s' (ID %d) actualizado a $%d.",
           JobInfo[jobid][jName], jobid, amount);
    SendClientMessage(playerid, -1, msg);
    printf("[ECONOMIA] Admin actualizó sueldo del job %d a $%d.", jobid, amount);
    return 1;
}

// /versueldos - muestra lista interactiva de trabajos
CMD:versueldos(playerid, params[])
{
    if(AccountInfo[playerid][accAdminLevel] < 14)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

    new str[2048];
    str[0] = EOS;

    for (new i = 1; i < sizeof(JobInfo); i++)
    {
        if (JobInfo[i][jType] != 1) continue; // solo legales

        new line[128];
        format(line, sizeof line, "{5CCAF1}[ID %d]{FFFFFF} %s - {FFD700}$%d\n",
               i, JobInfo[i][jName], JobInfo[i][jBaseSalary]);
        strcat(str, line);
    }

    if (!strlen(str))
        format(str, sizeof str, "No hay trabajos legales cargados en memoria.");

    ShowPlayerDialog(playerid, DLG_ECONOMY_VERSUELDOS, DIALOG_STYLE_LIST, "Gestión de Sueldos - Trabajos Legales", str, "Editar", "Cerrar");
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DLG_ECONOMY_VERSUELDOS)
    {
        if (!response)
            return 1;

        // Encontrar el job correspondiente al listitem
        new count = 0;
        new selectedJob = -1;
        
        for (new i = 1; i < sizeof(JobInfo); i++)
        {
            if (JobInfo[i][jType] != 1) continue;
            
            if (count == listitem)
            {
                selectedJob = i;
                break;
            }
            count++;
        }

        if (selectedJob == -1 || !IsValidJobId(selectedJob))
        {
            SendClientMessage(playerid, COLOR_ERROR, "[ERROR] No se pudo identificar el trabajo seleccionado.");
            return 1;
        }

        if (PlayerInfo[playerid][pAdmin] < 20)
        {
            // Solo mostrar info, no permitir editar
            new msg[256];
            format(msg, sizeof msg, "{FFFFFF}Trabajo: {5CCAF1}%s{FFFFFF}\nID: {FFD700}%d{FFFFFF}\nSueldo base: {FFD700}$%d\n\n{E44A4A}Necesitas nivel 20 de admin para editar sueldos.",
                JobInfo[selectedJob][jName], selectedJob, JobInfo[selectedJob][jBaseSalary]);
            ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "Información del Trabajo", msg, "Aceptar", "");
            return 1;
        }

        // Guardar el job seleccionado y mostrar diálogo de edición
        g_SelectedJobId[playerid] = selectedJob;

        new dialog[256];
        format(dialog, sizeof dialog, "{FFFFFF}Trabajo: {5CCAF1}%s{FFFFFF}\nID: {FFD700}%d{FFFFFF}\n\nSueldo actual: {FFD700}$%d{FFFFFF}\n\nIngresa el nuevo sueldo base:",
            JobInfo[selectedJob][jName], selectedJob, JobInfo[selectedJob][jBaseSalary]);
        
        ShowPlayerDialog(playerid, DLG_ECONOMY_EDITSUELDO, DIALOG_STYLE_INPUT, "Editar Sueldo", dialog, "Guardar", "Volver");
        return 1;
    }
    
    if (dialogid == DLG_ECONOMY_EDITSUELDO)
    {
        if (!response)
        {
            // Volver al menú principal
            cmd_versueldos(playerid, "");
            return 1;
        }

        new newSalary = strval(inputtext);
        
        if (newSalary < 0)
        {
            SendClientMessage(playerid, COLOR_ERROR, "[ERROR] El sueldo no puede ser negativo.");
            cmd_versueldos(playerid, "");
            return 1;
        }

        new jobid = g_SelectedJobId[playerid];
        
        if (!IsValidJobId(jobid))
        {
            SendClientMessage(playerid, COLOR_ERROR, "[ERROR] ID de trabajo inválido.");
            return 1;
        }

        if (!Economy_SetJobSalary(jobid, newSalary))
        {
            SendClientMessage(playerid, COLOR_ERROR, "[ERROR] No se pudo actualizar el sueldo.");
            cmd_versueldos(playerid, "");
            return 1;
        }

        new msg[128];
        format(msg, sizeof msg, "{FFFFFF}Sueldo de {5CCAF1}%s{FFFFFF} actualizado a {FFD700}$%d", 
            JobInfo[jobid][jName], newSalary);
        ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "Sueldo Actualizado", msg, "Aceptar", "");
        
        printf("[ECONOMIA] %s actualizó sueldo del job %d (%s) a $%d.", 
            GetPlayerCleanName(playerid), jobid, JobInfo[jobid][jName], newSalary);
        
        return 1;
    }
    
    return 0;
}

// /guardarjobs -> guarda todos los sueldos actuales
CMD:guardarjobs(playerid, params[])
{
    if(AccountInfo[playerid][accAdminLevel] < 14)
        return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"Debes ser rango Senior Admin o superior para usar este comando.");

    Economy_SaveAllJobSalaries();
    SendClientMessage(playerid, -1, "[ECONOMIA] Todos los sueldos legales fueron guardados en la base de datos.");
    return 1;
}