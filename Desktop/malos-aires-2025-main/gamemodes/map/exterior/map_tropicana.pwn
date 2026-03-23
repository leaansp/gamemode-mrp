#if defined _map_ext_tropicana_inc
	#endinput
#endif
#define _map_ext_tropicana_inc

#include <YSI_Coding\y_hooks>

hook LoadMaps() {
    Textura = CreateDynamicObject(19479, 1836.391479, -1682.375732, 16.235544, 0.000000, 3.500007, -179.999984, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(Textura, 0, "TROPICANA", 140, "Ariel", 50, 1, 0xFF009EFF, 0x00000000, 1);
    Textura = CreateDynamicObject(19479, 1836.411499, -1682.405761, 15.665534, 0.000000, 0.000000, -179.999984, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(Textura, 0, "BAILABLE", 140, "Fixedsys", 40, 1, 0xFFFF0000, 0x00000000, 1);
    Textura = CreateDynamicObject(19437, 1836.504882, -1679.809570, 15.978141, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(Textura, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    Textura = CreateDynamicObject(19479, 1836.391479, -1682.375732, 16.235544, 0.000000, 0.000000, -179.999984, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(Textura, 0, "TROPICANA", 140, "Ariel", 50, 1, 0xFFC500FF, 0x00000000, 1);
    Textura = CreateDynamicObject(19479, 1836.411499, -1682.405761, 15.665534, 0.000000, 2.700002, -179.999984, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(Textura, 0, "BAILABLE", 140, "Fixedsys", 40, 1, 0xFFECFF00, 0x00000000, 1);
    Textura = CreateDynamicObject(19437, 1836.504882, -1683.141235, 15.978141, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(Textura, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
    Textura = CreateDynamicObject(19437, 1836.504882, -1685.022949, 15.978141, 90.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(Textura, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);

    Textura = CreateDynamicObject(19294, 1832.268798, -1677.549926, 16.276861, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    Textura = CreateDynamicObject(19293, 1832.268798, -1687.282470, 16.186859, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 

    return true;
}