#if defined _marp_item_type_toy_included
	#endinput
#endif
#define _marp_item_type_toy_included

#include <YSI_Coding\y_hooks>

enum e_ITEM_TOY_TAG(<<= 1)
{
	ITEM_TOY_TAG_HIDE_NAME = 1,
	ITEM_TOY_TAG_GIVE_ARMOUR,
	ITEM_TOY_TAG_FLASH_PROTECT
}

static enum e_ITEM_TOY_DATA
{
	toyItemID,
	toyAttachBone,
	Float:toyDefaultPos[3],
	Float:toyDefaultRot[3],
	Float:toyDefaultScale[3],
	e_ITEM_TOY_TAG:toyTag

};

static const ItemToy_Data[][e_ITEM_TOY_DATA] = {
	{
		/*toyItemID*/ ITEM_ID_NULL,
		/*toyAttachBone*/ 0,
		/*toyDefaultPos*/ {0.0, 0.0, 0.0},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_CASCOCOMUN,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.068999, 0.022000, 0.003000},
		/*toyDefaultRot*/ {88.600013, 75.699958, -0.299999},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_CASCOMOTOCROSS,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.068999, 0.022000, 0.003000},
		/*toyDefaultRot*/ {88.600013, 75.699958, -0.299999},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_CASCOROJO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.068999, 0.022000, 0.003000},
		/*toyDefaultRot*/ {88.600013, 75.699958, -0.299999},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_CASCOBLANCO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.068999, 0.022000, 0.003000},
		/*toyDefaultRot*/ {88.600013, 75.699958, -0.299999},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_CASCOROSA,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.068999, 0.022000, 0.003000},
		/*toyDefaultRot*/ {88.600013, 75.699958, -0.299999},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_CASCO_OBRERO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_SOMBRERO_COWBOY_NEGRO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_SOMBRERO_COWBOY_MARRON,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_SOMBRERO_COWBOY_BORDO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_RELOJ_SWATCH,
		/*toyAttachBone*/ ATTACH_BONE_ID_RIGHT_HAND,
		/*toyDefaultPos*/ {-0.019999, -0.008000, -0.018000},
		/*toyDefaultRot*/ {-172.699981, 98.799964, -0.099999},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_RELOJ_ROLEX,
		/*toyAttachBone*/ ATTACH_BONE_ID_RIGHT_HAND,
		/*toyDefaultPos*/ {-0.019999, -0.008000, -0.018000},
		/*toyDefaultRot*/ {-172.699981, 98.799964, -0.099999},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_RELOJ_CASIO,
		/*toyAttachBone*/ ATTACH_BONE_ID_RIGHT_HAND,
		/*toyDefaultPos*/ {-0.019999, -0.008000, -0.018000},
		/*toyDefaultRot*/ {-172.699981, 98.799964, -0.099999},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_RELOJ_SWISSARMY,
		/*toyAttachBone*/ ATTACH_BONE_ID_RIGHT_HAND,
		/*toyDefaultPos*/ {-0.019999, -0.008000, -0.018000},
		/*toyDefaultRot*/ {-172.699981, 98.799964, -0.099999},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_RELOJ_FESTINA,
		/*toyAttachBone*/ ATTACH_BONE_ID_RIGHT_HAND,
		/*toyDefaultPos*/ {-0.019999, -0.008000, -0.018000},
		/*toyDefaultRot*/ {-172.699981, 98.799964, -0.099999},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_SOMBRERO_ANTIGUO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.103999, 0.027999, -0.000999},
		/*toyDefaultRot*/ {11.499997, 87.700012, 92.600013},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BIGOTE_FALSO1,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.018000, 0.128999, 0.000000},
		/*toyDefaultRot*/ {0.000000, 0.000000, -89.400009},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BIGOTE_FALSO2,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.018000, 0.128999, 0.000000},
		/*toyDefaultRot*/ {0.000000, 0.000000, -89.400009},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_SOMBRERO_BLANCO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRO_ROJO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.127999, 0.024000, 0.000000},
		/*toyDefaultRot*/ {0.000000, 90.699958, 87.100036},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRO_ESTAMPADO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.127999, 0.024000, 0.000000},
		/*toyDefaultRot*/ {0.000000, 90.699958, 87.100036},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRO_NEGRO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.127999, 0.024000, 0.000000},
		/*toyDefaultRot*/ {0.000000, 90.699958, 87.100036},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRO_PLAYERO_NEGRO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.127999, 0.024000, 0.000000},
		/*toyDefaultRot*/ {0.000000, 90.699958, 87.100036},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRO_PLAYERO_CUADROS,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.127999, 0.024000, 0.000000},
		/*toyDefaultRot*/ {0.000000, 90.699958, 87.100036},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA_MILITAR,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.120999, 0.012000, -0.008000},
		/*toyDefaultRot*/ {0.000000, 0.000000, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA_GRIS_ESTAMPADA,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.120999, 0.012000, -0.008000},
		/*toyDefaultRot*/ {0.000000, 0.000000, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA_BLANCA_ESTAMPADA,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.120999, 0.012000, -0.008000},
		/*toyDefaultRot*/ {0.000000, 0.000000, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_ANTEOJO_DE_SOL,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.079999, 0.018999, 0.000000},
		/*toyDefaultRot*/ {88.599983, 85.900001, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_ANTEOJO_DEPORTIVO_NEGRO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.079999, 0.018999, 0.000000},
		/*toyDefaultRot*/ {88.599983, 85.900001, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_ANTEOJO_DEPORTIVO_ROJO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.079999, 0.018999, 0.000000},
		/*toyDefaultRot*/ {88.599983, 85.900001, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_ANTEOJO_DEPORTIVO_AZUL,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.079999, 0.018999, 0.000000},
		/*toyDefaultRot*/ {88.599983, 85.900001, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_ANTEOJO_RAYBAN_NEGRO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.079999, 0.018999, 0.000000},
		/*toyDefaultRot*/ {88.599983, 85.900001, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_ANTEOJO_RAYBAN_AZUL,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.079999, 0.018999, 0.000000},
		/*toyDefaultRot*/ {88.599983, 85.900001, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_ANTEOJO_RAYBAN_VIOLETA,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.079999, 0.018999, 0.000000},
		/*toyDefaultRot*/ {88.599983, 85.900001, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_ANTEOJO_RAYBAN_ROSA,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.079999, 0.018999, 0.000000},
		/*toyDefaultRot*/ {88.599983, 85.900001, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_ANTEOJO_RAYBAN_ROJO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.079999, 0.018999, 0.000000},
		/*toyDefaultRot*/ {88.599983, 85.900001, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_ANTEOJO_RAYBAN_NARANJA,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.079999, 0.018999, 0.000000},
		/*toyDefaultRot*/ {88.599983, 85.900001, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_ANTEOJO_RAYBAN_AMARILLO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.079999, 0.018999, 0.000000},
		/*toyDefaultRot*/ {88.599983, 85.900001, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_ANTEOJO_RAYBAN_VERDE,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.079999, 0.018999, 0.000000},
		/*toyDefaultRot*/ {88.599983, 85.900001, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA_SIMPLE_NEGRA,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-178.000000, -1.699998, 21.100015},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA_SIMPLE_AZUL,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-178.000000, -1.699998, 21.100015},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA_SIMPLE_VERDE,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-178.000000, -1.699998, 21.100015},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_TAPABOCA_1,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.073000, 0.003000, -0.012999},
		/*toyDefaultRot*/ {99.200103, 172.200012, 96.000038},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_TAPABOCA_2,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.073000, 0.003000, -0.012999},
		/*toyDefaultRot*/ {99.200103, 172.200012, 96.000038},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_TAPABOCA_3,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.073000, 0.003000, -0.012999},
		/*toyDefaultRot*/ {99.200103, 172.200012, 96.000038},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_TAPABOCA_4,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.073000, 0.003000, -0.012999},
		/*toyDefaultRot*/ {99.200103, 172.200012, 96.000038},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_TAPABOCA_5,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.073000, 0.003000, -0.012999},
		/*toyDefaultRot*/ {99.200103, 172.200012, 96.000038},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_TAPABOCA_6,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.073000, 0.003000, -0.012999},
		/*toyDefaultRot*/ {99.200103, 172.200012, 96.000038},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_TAPABOCA_7,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.073000, 0.003000, -0.012999},
		/*toyDefaultRot*/ {99.200103, 172.200012, 96.000038},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_TAPABOCA_8,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.073000, 0.003000, -0.012999},
		/*toyDefaultRot*/ {99.200103, 172.200012, 96.000038},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_TAPABOCA_9,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.073000, 0.003000, -0.012999},
		/*toyDefaultRot*/ {99.200103, 172.200012, 96.000038},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_TAPABOCA_10,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.073000, 0.003000, -0.012999},
		/*toyDefaultRot*/ {99.200103, 172.200012, 96.000038},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_PASAMONTANAS,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.038000, 0.021999, -0.001000},
		/*toyDefaultRot*/ {80.199989, 80.000000, 93.000030},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_MASCARA_TERROR_BLANCA,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.127999, 0.037000, -0.004999},
		/*toyDefaultRot*/ {93.900001, 82.399986, 0.000000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA_POLICIA,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.171999, 0.000000, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_CHALECO_1,
		/*toyAttachBone*/ ATTACH_BONE_ID_SPINE,
		/*toyDefaultPos*/ {0.140999, 0.032000, 0.000000},
		/*toyDefaultRot*/ {-5.700002, 88.800003, 5.300000},
		/*toyDefaultScale*/ {1.205000, 1.672999, 1.246000},
		/*toyTag*/ ITEM_TOY_TAG_GIVE_ARMOUR
	},
	{
		/*toyItemID*/ ITEM_ID_CHALECO_2,
		/*toyAttachBone*/ ATTACH_BONE_ID_SPINE,
		/*toyDefaultPos*/ {0.304999, -0.007999, -0.177000},
		/*toyDefaultRot*/ {70.000000, 24.199985, 35.900012},
		/*toyDefaultScale*/ {1.031999, 1.037999, 0.947999},
		/*toyTag*/ ITEM_TOY_TAG_GIVE_ARMOUR
	},
	{
		/*toyItemID*/ ITEM_ID_CHALECO_3,
		/*toyAttachBone*/ ATTACH_BONE_ID_SPINE,
		/*toyDefaultPos*/ {0.087999, 0.033999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_GIVE_ARMOUR
	},
	{
		/*toyItemID*/ ITEM_ID_CHALECO_4,
		/*toyAttachBone*/ ATTACH_BONE_ID_SPINE,
		/*toyDefaultPos*/ {0.087999, 0.033999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_GIVE_ARMOUR
	},
	{
		/*toyItemID*/ ITEM_ID_MASCARA_GAS,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.000000, 0.112000, 0.003000},
		/*toyDefaultRot*/ {93.300010, 91.199974, -1.900001},
		/*toyDefaultScale*/ {0.902000, 1.103999, 1.000000},
		/*toyTag*/ ITEM_TOY_TAG_HIDE_NAME
	},
	{
		/*toyItemID*/ ITEM_ID_CASCO_BOMBERO1,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.171999, 0.000000, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_CASCO_BOMBERO2,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.171999, 0.000000, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA_POLICIA2,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {83.000000, 83.699998, 13.100015},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_SOMBRERO_NEGRO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, -10.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_FAKE_HAIR,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-178.000000, -1.699998, 13.100015},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA1,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA2,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA3,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA4,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA5,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA6,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA7,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA8,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA9,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA10,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA11,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA12,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA13,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA14,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA15,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA16,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA17,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA18,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA19,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BANDANA20,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-101.1000, 12.6000, -92.5000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BOINA1,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {0.0000, 0.0000, 0.0000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BOINA2,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {0.0000, 0.0000, 0.0000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BOINA3,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {0.0000, 0.0000, 0.0000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BOINA4,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {0.0000, 0.0000, 0.0000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_BOINA5,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {0.0000, 0.0000, 0.0000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA1,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-178.000000, -1.699998, 21.100015},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA2,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-178.000000, -1.699998, 21.100015},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA3,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-178.000000, -1.699998, 21.100015},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA4,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-178.000000, -1.699998, 21.100015},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA5,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-178.000000, -1.699998, 21.100015},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA6,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-178.000000, -1.699998, 21.100015},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA7,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-178.000000, -1.699998, 21.100015},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRA8,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-178.0000, 101.1000, -83.3000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_CHALECO_REFRACTARIO,
		/*toyAttachBone*/ ATTACH_BONE_ID_SPINE,
		/*toyDefaultPos*/ {0.0879, 0.0356, 0.002},
		/*toyDefaultRot*/ {-89.5000, 88.3000, -87.9000},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_CASCO_CORTO1,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-178.000000, -1.699998, 21.100015},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_CASCO_CORTO2,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-178.000000, -1.699998, 21.100015},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_CASCO_CORTO3,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.135999, -0.011000, 0.004999},
		/*toyDefaultRot*/ {-178.000000, -1.699998, 21.100015},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_SOMBRERO1,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_SOMBRERO2,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_SOMBRERO3,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_SOMBRERO4,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_SOMBRERO5,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_SOMBRERO6,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_SOMBRERO7,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_SOMBRERO8,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_CASCO_BOXEO,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRO_LANA1,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRO_LANA2,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_SOMBRERO9,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_MASCARA_CJ,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {84.0, 87.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRO_LANA3,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {81.0, 102.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_GORRO_LANA4,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {81.0, 102.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ e_ITEM_TOY_TAG:0
	},
	{
		/*toyItemID*/ ITEM_ID_CASCO_SWAT1,
		/*toyAttachBone*/ ATTACH_BONE_ID_HEAD,
		/*toyDefaultPos*/ {0.151999, 0.039999, 0.000000},
		/*toyDefaultRot*/ {0.0, 0.0, 0.0},
		/*toyDefaultScale*/ {1.0, 1.0, 1.0},
		/*toyTag*/ ITEM_TOY_TAG_FLASH_PROTECT
	}
};

ItemToy_IsValidDataId(dataid) {
	return (0 < dataid < sizeof(ItemToy_Data));
}

ItemToy_GetAttachBone(dataid) {
	return ItemToy_Data[dataid][toyAttachBone];
}

ItemToy_HasTag(dataid, e_ITEM_TOY_TAG:tag) {
	return (ItemToy_Data[dataid][toyTag] & tag);
}

ItemToy_GetAttachDefaultCoords(dataid, &Float:x, &Float:y, &Float:z, &Float:rx, &Float:ry, &Float:rz, &Float:sx, &Float:sy, &Float:sz)
{
	x = ItemToy_Data[dataid][toyDefaultPos][0];
	y = ItemToy_Data[dataid][toyDefaultPos][1];
	z = ItemToy_Data[dataid][toyDefaultPos][2];
	rx = ItemToy_Data[dataid][toyDefaultRot][0];
	ry = ItemToy_Data[dataid][toyDefaultRot][1];
	rz = ItemToy_Data[dataid][toyDefaultRot][2];
	sx = ItemToy_Data[dataid][toyDefaultScale][0];
	sy = ItemToy_Data[dataid][toyDefaultScale][1];
	sz = ItemToy_Data[dataid][toyDefaultScale][2];
}

hook OnGameModeInitEnded()
{
	for(new i = 1, size = sizeof(ItemToy_Data); i < size; i++) {
		ItemModel_SetExtraId(ItemToy_Data[i][toyItemID], i);
	}

	printf("[INFO] Se han asociado los datos especiales de toys de %i items.", sizeof(ItemToy_Data) - 1);
	return 1;
}

hook function Item_OnUsed(playerid, hand, itemid, itemType)
{
	if(itemType != ITEM_TOY)
		return continue(playerid, hand, itemid, itemType);

	if(!Toy_Add(playerid, itemid, GetHandParam(playerid, hand)))
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR] "COLOR_EMB_GREY"No tienes más lugar disponible o no puedes equiparte ese ítem en este momento.");

	new str[128];
	format(str, sizeof(str), "Se equipa %s.", ItemModel_GetName(itemid));
	PlayerCmeMessage(playerid, 15.0, 3500, str);
	SetHandItemAndParam(playerid, hand, 0, 0);
	return 1;
}
