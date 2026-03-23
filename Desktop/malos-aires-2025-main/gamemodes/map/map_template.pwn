#if defined _map_template_inc
	#endinput
#endif
#define _map_template_inc

#include <YSI_Coding\y_hooks>

/*	Si es un interior, completar esto y dejarlo comentado. la POS y el ANGLE tiene q ser el lugar de entrada,
	con el pj mirando hacia la puerta para definir el angulo.

  		  Nombre   Descripcion	PosX	PosY	PosZ	Angle	Int		Tags				
		{"Nombre","Descripcion",0.000, 0.000, 0.000, 	0.0,	0,		(TAG_UNO | TAG_DOS...)}

*/

hook RemoveMapsBuildings(playerid) //en caso de no tener Removes, Borrar este hook
{
	return true;
}

hook LoadMaps() {
	return true;
}