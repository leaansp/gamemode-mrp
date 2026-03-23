#if defined _map_licencias_inc
	#endinput
#endif
#define _map_licencias_inc

#include <YSI_Coding\y_hooks>


hook RemoveMapsBuildings(playerid) //en caso de no tener Removes, Borrar este hook
{   
    RemoveBuildingForPlayer(playerid, 17555, 2765.090, -1454.439, 29.437, 0.250);
    RemoveBuildingForPlayer(playerid, 17740, 2765.090, -1454.439, 29.437, 0.250);
    RemoveBuildingForPlayer(playerid, 17585, 2765.090, -1454.439, 29.437, 0.250);
    RemoveBuildingForPlayer(playerid, 17740, 2765.090, -1454.439, 29.437, 0.250);
    RemoveBuildingForPlayer(playerid, 17955, 2717.489, -1416.189, 50.429, 0.250);
	return true;
}

hook LoadMaps() {   
    new tmpobjid;
    tmpobjid = CreateObject(6959, 2767.507568, -1458.505249, 29.491481, 0.000000, 0.000014, -0.239999); 
    SetObjectMaterial(tmpobjid, 0, 8391, "ballys01", "greyground256128", 0xFF595959);
    tmpobjid = CreateObject(6959, 2767.555175, -1446.283691, 29.481481, 0.000000, 0.000014, -0.239999); 
    SetObjectMaterial(tmpobjid, 0, 8391, "ballys01", "greyground256128", 0xFF595959);
    tmpobjid = CreateObject(6959, 2767.444824, -1478.463745, 9.481479, 90.000000, 90.000015, 89.749931); 
    SetObjectMaterial(tmpobjid, 0, 17555, "eastbeach3c_lae2", "decobuild2d_LAn", 0xFFA7A7A7);
    tmpobjid = CreateObject(6959, 2788.161865, -1457.913818, 9.481479, 90.000000, 90.000015, 179.739959); 
    SetObjectMaterial(tmpobjid, 0, 17555, "eastbeach3c_lae2", "decobuild2d_LAn", 0xFFA7A7A7);
    tmpobjid = CreateDynamicObject(8674, 2752.002441, -1478.411621, 30.920232, 0.000000, 0.000007, -0.239998, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFA7A7A7);
    tmpobjid = CreateDynamicObject(8674, 2762.291992, -1478.455078, 30.920232, 0.000000, 0.000007, -0.239998, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFA7A7A7);
    tmpobjid = CreateDynamicObject(8674, 2772.580566, -1478.498901, 30.920232, 0.000000, 0.000007, -0.239998, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFA7A7A7);
    tmpobjid = CreateDynamicObject(8674, 2782.874023, -1478.540527, 30.920232, 0.000000, 0.000007, -0.239998, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFA7A7A7);
    tmpobjid = CreateDynamicObject(8674, 2788.071289, -1473.390991, 30.920232, 0.000000, 0.000007, 89.760002, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFA7A7A7);
    tmpobjid = CreateDynamicObject(19453, 2751.737304, -1426.508056, 31.170221, 0.000000, 0.000000, 89.819999, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19453, 2761.346679, -1426.538330, 31.170221, 0.000000, 0.000000, 89.819999, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19453, 2770.936767, -1426.568481, 31.170221, 0.000000, 0.000000, 89.819999, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19453, 2780.486572, -1426.598388, 31.170221, 0.000000, 0.000000, 89.819999, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateObject(16564, 2767.348144, -1446.537231, 29.450237, 0.000000, 0.000000, 179.709960); 
    SetObjectMaterial(tmpobjid, 0, 17545, "burnsground", "newall1-1128", 0xFFF5F5F5);
    SetObjectMaterial(tmpobjid, 1, 16640, "a51", "plaintarmac1", 0x00000000);
    SetObjectMaterial(tmpobjid, 2, 16640, "a51", "plaintarmac1", 0x00000000);
    tmpobjid = CreateDynamicObject(19453, 2783.488769, -1426.610473, 31.170221, 0.000000, 0.000000, 89.819999, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19453, 2746.953857, -1440.813354, 31.170221, 0.000000, 0.000000, -0.180000, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19453, 2746.923095, -1450.413085, 31.170221, 0.000000, 0.000000, -0.180000, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19453, 2746.892333, -1460.042480, 31.170221, 0.000000, 0.000000, -0.180000, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2751.579589, -1478.082885, 27.720218, 0.000007, 0.000000, 89.599952, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2761.198486, -1478.149658, 27.720218, 0.000007, 0.000000, 89.599952, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2770.798095, -1478.216308, 27.720218, 0.000007, 0.000000, 89.599952, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2780.368164, -1478.283447, 27.720218, 0.000007, 0.000000, 89.599952, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2783.120849, -1478.303588, 27.720218, 0.000007, 0.000000, 89.599952, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2751.719726, -1461.202880, 27.720218, 0.000022, 0.000000, 89.599906, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2761.338623, -1461.269653, 27.720218, 0.000022, 0.000000, 89.599906, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2770.938232, -1461.336303, 27.720218, 0.000022, 0.000000, 89.599906, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2780.508300, -1461.403442, 27.720218, 0.000022, 0.000000, 89.599906, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2783.260986, -1461.423583, 27.720218, 0.000022, 0.000000, 89.599906, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2787.905273, -1473.597900, 27.720218, 0.000007, 0.000000, 179.599945, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2787.957519, -1466.190185, 27.720218, 0.000007, 0.000000, 179.599945, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2783.873779, -1473.569580, 27.720218, 0.000007, 0.000000, 179.599945, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2779.784179, -1473.541015, 27.720218, 0.000007, 0.000000, 179.599945, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2776.064941, -1473.515258, 27.720218, 0.000007, 0.000000, 179.599945, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2772.334472, -1473.489379, 27.720218, 0.000007, 0.000000, 179.599945, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2768.514160, -1473.463012, 27.720218, 0.000007, 0.000000, 179.599945, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2764.752929, -1473.435913, 27.720218, 0.000007, 0.000000, 179.599945, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2761.050781, -1473.408691, 27.720218, 0.000007, 0.000000, 179.599945, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19461, 2757.239746, -1473.381835, 27.720218, 0.000007, 0.000000, 179.599945, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9525, "boigas_sfw", "GEwhite1_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19866, 2767.565185, -1451.471557, 33.280204, 0.000000, 0.000000, 269.700073, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1677, "wshxrefhse2", "yellowbeige_128", 0x00000000);
    tmpobjid = CreateDynamicObject(19483, 2767.566650, -1451.573242, 33.770233, 0.000000, 0.000000, 269.750061, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "LICENCIAS ROCA", 130, "Ariel", 70, 1, 0xFF000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19483, 2766.016357, -1451.572021, 33.450218, 0.000000, 0.000000, 269.580108, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "Dirección General", 130, "Ariel", 35, 1, 0xFF000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19483, 2767.697265, -1451.584106, 33.450218, 0.000000, 0.000000, 269.580108, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "Habilitación de Conductores", 130, "Ariel", 35, 1, 0xFF000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19483, 2769.186767, -1451.594360, 33.450218, 0.000000, 0.000000, 269.580108, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "y Transporte", 130, "Ariel", 35, 1, 0xFF000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19453, 2746.985351, -1431.223876, 31.170221, 0.000000, 0.000000, -0.180000, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19453, 2751.544921, -1478.329833, 31.170221, 0.000000, 0.000000, 89.799995, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19453, 2788.164062, -1463.403198, 31.170221, 0.000000, 0.000000, -0.439999, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateObject(6959, 2767.596923, -1426.345336, 9.481479, 90.000000, 90.000015, 89.739974); 
    SetObjectMaterial(tmpobjid, 0, 17555, "eastbeach3c_lae2", "decobuild2d_LAn", 0xFFA7A7A7);
    tmpobjid = CreateDynamicObject(19980, 2746.796875, -1463.583496, 28.983108, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "mirror01", 0x00000000);
    tmpobjid = CreateDynamicObject(19365, 2746.855712, -1463.597290, 31.913131, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "CENTRO PROVINCIAL", 140, "Ariel", 20, 1, 0xFFFFFFFF, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19365, 2746.855712, -1463.597290, 31.793127, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "DE LICENCIAS", 140, "Ariel", 20, 1, 0xFFFFFFFF, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19365, 2746.855712, -1463.587280, 31.223125, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "CIUDAD AUTONOMA DE MALOS AIRES", 140, "Ariel", 15, 1, 0xFFFFFFFF, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19365, 2746.855712, -1463.587280, 31.563129, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "CONDUCCION TIPO: A - B - C - D", 140, "Ariel", 17, 1, 0xFFFFFFFF, 0x00000000, 1);
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    tmpobjid = CreateDynamicObject(1462, 2788.154541, -1425.950439, 15.250000, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
    tmpobjid = CreateDynamicObject(1297, 2757.215576, -1477.373168, 32.830238, 0.000000, 0.000000, 269.610076, -1, -1, -1, 200.00, 200.00); 
    tmpobjid = CreateDynamicObject(1297, 2764.718261, -1477.424926, 32.830238, 0.000000, 0.000000, 269.610076, -1, -1, -1, 200.00, 200.00); 
    tmpobjid = CreateDynamicObject(1297, 2772.299072, -1477.477539, 32.830238, 0.000000, 0.000000, 269.610076, -1, -1, -1, 200.00, 200.00); 
    tmpobjid = CreateDynamicObject(1297, 2779.749755, -1477.528686, 32.830238, 0.000000, 0.000000, 269.610076, -1, -1, -1, 200.00, 200.00); 
    tmpobjid = CreateDynamicObject(1297, 2787.851562, -1477.585205, 32.830238, 0.000000, 0.000000, 269.610076, -1, -1, -1, 200.00, 200.00); 
    tmpobjid = CreateDynamicObject(1227, 2747.717529, -1427.752685, 30.300239, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
    tmpobjid = CreateDynamicObject(1227, 2747.717529, -1430.062500, 30.300239, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00); 
    tmpobjid = CreateDynamicObject(1297, 2775.990966, -1461.670532, 32.830238, 0.000000, 0.000000, 449.610076, -1, -1, -1, 200.00, 200.00); 
    tmpobjid = CreateDynamicObject(1297, 2758.939453, -1461.553222, 32.830238, 0.000000, 0.000000, 449.610076, -1, -1, -1, 200.00, 200.00); 
    tmpobjid = CreateDynamicObject(19869, 2749.632080, -1453.222900, 30.360252, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
    tmpobjid = CreateDynamicObject(19869, 2749.632080, -1453.222900, 27.980249, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
    tmpobjid = CreateDynamicObject(1449, 2785.914062, -1426.235229, 15.779993, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00); 
    tmpobjid = CreateDynamicObject(1344, 2752.668945, -1454.088378, 30.260236, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
    tmpobjid = CreateDynamicObject(1344, 2755.189697, -1454.088378, 30.260236, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00); 
    tmpobjid = CreateDynamicObject(4227, 2746.920410, -1449.039672, 30.901275, 0.000000, 0.000000, -90.200004, -1, -1, -1, 200.00, 200.00); 
	return true;
}