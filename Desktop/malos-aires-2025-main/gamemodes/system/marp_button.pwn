#if defined marp_button_inc
	#endinput
#endif
#define marp_button_inc

#include <YSI_Coding\y_hooks>

const BUTTON_MAX_LABEL_TEXT_LENGTH = 144;
const BUTTON_MAX_ENTER_TEXT_LENGTH = 144;
const BUTTON_DEFAULT_ENTER_TEXT_TIME = 2500;
const BUTTON_DEFAULT_LABEL_COLOR = 0xEEEEEEFF;
const Float:BUTTON_DEFAULT_STREAM_DISTANCE = 5.0;

const Button:BUTTON_MAX_AMOUNT = Button:2048;
const BUTTON_ITER_MAX_AMOUNT = _:BUTTON_MAX_AMOUNT;
const Button:BUTTON_RESET_ID = BUTTON_MAX_AMOUNT;
const BUTTON_PLAYER_RESET_ID = MAX_PLAYERS;
const Button:INVALID_BUTTON_ID = Button:-1;

static enum e_BUTTON_DATA
{
	Float:e_BUTTON_X,
	Float:e_BUTTON_Y,
	Float:e_BUTTON_Z,
	e_BUTTON_WORLD,
	e_BUTTON_EXTRA_ID,
	STREAMER_TAG_AREA:e_BUTTON_AREA,
	STREAMER_TAG_CP:e_BUTTON_CHECKPOINT,
	STREAMER_TAG_3D_TEXT_LABEL:e_BUTTON_LABEL,
	STREAMER_TAG_PICKUP:e_BUTTON_PICKUP,
	e_BUTTON_ON_ENTER_TEXT[BUTTON_MAX_ENTER_TEXT_LENGTH],
	e_BUTTON_ON_ENTER_TEXT_TIME,
	e_BUTTON_ON_ENTER_CALLBACK,
	e_BUTTON_ON_EXIT_CALLBACK,
	e_BUTTON_ON_PRESS_CALLBACK,
	e_BUTTON_ON_RELEASE_CALLBACK
}

static ButtonData[BUTTON_MAX_AMOUNT + Button:1][e_BUTTON_DATA] = {
	{
		/*e_BUTTON_X*/ 0.0,
		/*e_BUTTON_Y*/ 0.0,
		/*e_BUTTON_Z*/ 0.0,
		/*e_BUTTON_WORLD*/ 0,
		/*e_BUTTON_EXTRA_ID*/ 0,
		/*STREAMER_TAG_AREA:e_BUTTON_AREA*/ INVALID_STREAMER_ID,
		/*STREAMER_TAG_CP:e_BUTTON_CHECKPOINT*/ INVALID_STREAMER_ID,
		/*STREAMER_TAG_3D_TEXT_LABEL:e_BUTTON_LABEL*/ STREAMER_TAG_3D_TEXT_LABEL:INVALID_STREAMER_ID,
		/*STREAMER_TAG_PICKUP:e_BUTTON_PICKUP*/ INVALID_STREAMER_ID,
		/*e_BUTTON_ON_ENTER_TEXT*/ "",
		/*e_BUTTON_ON_ENTER_TEXT_TIME*/ BUTTON_DEFAULT_ENTER_TEXT_TIME,
		/*e_BUTTON_ON_ENTER_CALLBACK*/ 0,
		/*e_BUTTON_ON_EXIT_CALLBACK*/ 0,
		/*e_BUTTON_ON_PRESS_CALLBACK*/ 0,
		/*e_BUTTON_ON_RELEASE_CALLBACK*/ 0
	}, ...
};

static Iterator:ButtonData<BUTTON_ITER_MAX_AMOUNT>;

static enum e_BUTTON_PLAYER_DATA
{
	Button:butCurrentId,
	Button:butLastPressId,
	butLastPressTick,
	Button:butLastId,
	butOnEnterTextCooldown
}

static ButtonPlayerData[MAX_PLAYERS + 1][e_BUTTON_PLAYER_DATA] = {
	{
		INVALID_BUTTON_ID,
		INVALID_BUTTON_ID,
		0,
		INVALID_BUTTON_ID,
		0
	}, ...
};

enum e_BUTTON_EVENT_METHOD
{
	BUTTON_METHOD_AREA,
	BUTTON_METHOD_CHECKPOINT,
	BUTTON_METHOD_CUSTOM_AREA
}

stock Button_IsValidId(Button:buttonid) {
	return Iter_Contains(ButtonData, _:buttonid);
}

Button:Button_Create(extraid,
				Float:x = 0.0, Float:y = 0.0, Float:z = 0.0,
				Float:size = 0.6,
				worldid = -1,
				e_BUTTON_EVENT_METHOD:method = BUTTON_METHOD_AREA,
				STREAMER_TAG_AREA:customArea = INVALID_STREAMER_ID,
				Float:streamDistance = BUTTON_DEFAULT_STREAM_DISTANCE,
				const labelText[BUTTON_MAX_LABEL_TEXT_LENGTH] = "",
				labelColor = BUTTON_DEFAULT_LABEL_COLOR,
				const onEnterText[BUTTON_MAX_ENTER_TEXT_LENGTH] = "",
				onEnterTextTime = BUTTON_DEFAULT_ENTER_TEXT_TIME,
				const onEnterCallbackAddress = 0,
				const onExitCallbackAddress = 0,
				const onPressCallbackAddress = 0,
				const onReleaseCallbackAddress = 0)
{
	new Button:buttonid = Button:Iter_Free(ButtonData);

	if(buttonid == Button:INVALID_ITERATOR_SLOT)
	{
		printf("[ERROR] Alcanzado BUTTON_MAX_AMOUNT (%i). Iter_Count: %i.", _:BUTTON_MAX_AMOUNT, Iter_Count(ButtonData));
		return INVALID_BUTTON_ID;
	}

	switch(method)
	{
		case BUTTON_METHOD_AREA:
		{
			ButtonData[buttonid][e_BUTTON_AREA] = CreateDynamicCylinder(x, y, z - 1.2, z + 1.2, size, .worldid = worldid);
			Streamer_SetExtraIdArray(STREAMER_TYPE_AREA, ButtonData[buttonid][e_BUTTON_AREA], STREAMER_ARRAY_TYPE_BUTTON, _:buttonid);
		}
		case BUTTON_METHOD_CHECKPOINT:
		{
			ButtonData[buttonid][e_BUTTON_CHECKPOINT] = CreateDynamicCP(x, y, z, size, .worldid = worldid, .streamdistance = streamDistance);
			Streamer_SetExtraIdArray(STREAMER_TYPE_CP, ButtonData[buttonid][e_BUTTON_CHECKPOINT], STREAMER_ARRAY_TYPE_BUTTON, _:buttonid);
		}
		case BUTTON_METHOD_CUSTOM_AREA:
		{
			if(!IsValidDynamicArea(customArea))
				return INVALID_BUTTON_ID;

			ButtonData[buttonid][e_BUTTON_AREA] = customArea;
			Streamer_SetExtraIdArray(STREAMER_TYPE_AREA, ButtonData[buttonid][e_BUTTON_AREA], STREAMER_ARRAY_TYPE_BUTTON, _:buttonid);
		}
		default: return INVALID_BUTTON_ID;
	}

	ButtonData[buttonid][e_BUTTON_X] = x;
	ButtonData[buttonid][e_BUTTON_Y] = y;
	ButtonData[buttonid][e_BUTTON_Z] = z;
	ButtonData[buttonid][e_BUTTON_WORLD] = worldid;
	ButtonData[buttonid][e_BUTTON_EXTRA_ID] = extraid;
	ButtonData[buttonid][e_BUTTON_ON_ENTER_TEXT_TIME] = onEnterTextTime;

	if(!isnull(labelText)) {
		ButtonData[buttonid][e_BUTTON_LABEL] = CreateDynamic3DTextLabel(labelText, labelColor, x, y, (method == BUTTON_METHOD_CHECKPOINT) ? (z + 0.30) : (z), .drawdistance = streamDistance, .testlos = 1, .worldid = worldid, .streamdistance = streamDistance);
	}

	if(!isnull(onEnterText)) {
		strcopy(ButtonData[buttonid][e_BUTTON_ON_ENTER_TEXT], onEnterText, BUTTON_MAX_ENTER_TEXT_LENGTH);
	}

	ButtonData[buttonid][e_BUTTON_ON_ENTER_CALLBACK] = onEnterCallbackAddress;
	ButtonData[buttonid][e_BUTTON_ON_EXIT_CALLBACK] = onExitCallbackAddress;
	ButtonData[buttonid][e_BUTTON_ON_PRESS_CALLBACK] = onPressCallbackAddress;
	ButtonData[buttonid][e_BUTTON_ON_RELEASE_CALLBACK] = onReleaseCallbackAddress;

	Iter_Add(ButtonData, _:buttonid);

	return buttonid;
}

stock Button_SetOnEnterText(Button:buttonid, const text[], time = 0)
{
	if(!Iter_Contains(ButtonData, _:buttonid))
		return 0;

	if(time > 0) {
		ButtonData[buttonid][e_BUTTON_ON_ENTER_TEXT_TIME] = time;
	}

	strcopy(ButtonData[buttonid][e_BUTTON_ON_ENTER_TEXT], text, BUTTON_MAX_ENTER_TEXT_LENGTH);
	return 1;
}

stock Button_SetLabel(Button:buttonid, const text[], color, Float:offsetX = 0.0, Float:offsetY = 0.0, Float:offsetZ = 0.0, Float:streamDistance = BUTTON_DEFAULT_STREAM_DISTANCE)
{
	if(!Iter_Contains(ButtonData, _:buttonid))
		return 0;

	if(ButtonData[buttonid][e_BUTTON_LABEL])
	{
		DestroyDynamic3DTextLabel(ButtonData[buttonid][e_BUTTON_LABEL]);
		ButtonData[buttonid][e_BUTTON_LABEL] = STREAMER_TAG_3D_TEXT_LABEL:INVALID_STREAMER_ID;
	}

	if(isnull(text))
		return 0;

	ButtonData[buttonid][e_BUTTON_LABEL] = CreateDynamic3DTextLabel(text, color, ButtonData[buttonid][e_BUTTON_X] + offsetX, ButtonData[buttonid][e_BUTTON_Y] + offsetY, ButtonData[buttonid][e_BUTTON_Z] + offsetZ, .drawdistance = streamDistance, .testlos = 1, .worldid = ButtonData[buttonid][e_BUTTON_WORLD], .streamdistance = streamDistance);
	return 1;
}

stock Button_UpdateLabelText(Button:buttonid, const text[], color)
{
	if(!Iter_Contains(ButtonData, _:buttonid))
		return 0;
	if(!ButtonData[buttonid][e_BUTTON_LABEL] || isnull(text))
		return 0;

	UpdateDynamic3DTextLabelText(ButtonData[buttonid][e_BUTTON_LABEL], color, text);
	return 1;
}

stock Button_DestroyLabel(Button:buttonid)
{
	if(!Iter_Contains(ButtonData, _:buttonid))
		return 0;
	if(!ButtonData[buttonid][e_BUTTON_LABEL])
		return 0;

	DestroyDynamic3DTextLabel(ButtonData[buttonid][e_BUTTON_LABEL]);
	ButtonData[buttonid][e_BUTTON_LABEL] = STREAMER_TAG_3D_TEXT_LABEL:INVALID_STREAMER_ID;
	return 1;
}

stock Button_SetPickup(Button:buttonid, modelid, Float:offsetX = 0.0, Float:offsetY = 0.0, Float:offsetZ = 0.0, Float:streamDistance = BUTTON_DEFAULT_STREAM_DISTANCE)
{
	if(!Iter_Contains(ButtonData, _:buttonid))
		return 0;

	if(ButtonData[buttonid][e_BUTTON_PICKUP])
	{
		DestroyDynamicPickup(ButtonData[buttonid][e_BUTTON_PICKUP]);
		ButtonData[buttonid][e_BUTTON_PICKUP] = STREAMER_TAG_PICKUP:INVALID_STREAMER_ID;
	}

	ButtonData[buttonid][e_BUTTON_PICKUP] = CreateDynamicPickup(modelid, 1, ButtonData[buttonid][e_BUTTON_X] + offsetX, ButtonData[buttonid][e_BUTTON_Y] + offsetY, ButtonData[buttonid][e_BUTTON_Z] + offsetZ, .worldid = ButtonData[buttonid][e_BUTTON_WORLD], .streamdistance = streamDistance);
	return 1;
}

stock Button_DestroyPickup(Button:buttonid)
{
	if(!Iter_Contains(ButtonData, _:buttonid))
		return 0;
	if(!ButtonData[buttonid][e_BUTTON_PICKUP])
		return 0;

	DestroyDynamicPickup(ButtonData[buttonid][e_BUTTON_PICKUP]);
	ButtonData[buttonid][e_BUTTON_PICKUP] = STREAMER_TAG_PICKUP:INVALID_STREAMER_ID;
	return 1;
}

Button_Destroy(Button:buttonid)
{
	if(!Iter_Contains(ButtonData, _:buttonid))
		return 0;

	if((ButtonData[buttonid][e_BUTTON_AREA] != INVALID_STREAMER_ID && IsAnyPlayerInDynamicArea(ButtonData[buttonid][e_BUTTON_AREA])) || ButtonData[buttonid][e_BUTTON_CHECKPOINT] != INVALID_STREAMER_ID)
	{
		foreach(new playerid : Player)
		{
			if(buttonid == ButtonPlayerData[playerid][butCurrentId]) {
				ButtonPlayerData[playerid][butCurrentId] = INVALID_BUTTON_ID;
			}
			if(buttonid == ButtonPlayerData[playerid][butLastPressId]) {
				ButtonPlayerData[playerid][butLastPressId] = INVALID_BUTTON_ID;
			}
			// Esto supone que al borrar se desea procesar la salida, pero en general el borrado en el sistema origen implica borrado de toda
			// su lógica también, y llamaría a una entidad borrada. Ciertos casos podrían necesitarlo. podría invocarse la callback con una de dos razones de salida, borrado o normal:
			// if(IsPlayerInDynamicArea(playerid, ButtonData[buttonid][e_BUTTON_AREA])) {
			// 	Button_OnPlayerLeaveArea(playerid, buttonid, .reason = BUTTON_LEAVE_REASON_DELETED);
			// }
		}
	}

	if(ButtonData[buttonid][e_BUTTON_LABEL]) {
		DestroyDynamic3DTextLabel(ButtonData[buttonid][e_BUTTON_LABEL]);
	}

	if(ButtonData[buttonid][e_BUTTON_PICKUP]) {
		DestroyDynamicPickup(ButtonData[buttonid][e_BUTTON_PICKUP]);
	}

	if(ButtonData[buttonid][e_BUTTON_AREA]) {
		DestroyDynamicArea(ButtonData[buttonid][e_BUTTON_AREA]);
	}

	if(ButtonData[buttonid][e_BUTTON_CHECKPOINT]) {
		DestroyDynamicCP(ButtonData[buttonid][e_BUTTON_CHECKPOINT]);
	}

	ButtonData[buttonid] = ButtonData[BUTTON_RESET_ID];
	Iter_Remove(ButtonData, _:buttonid);
	return 1;
}

Button_OnPlayerEnter(playerid, Button:buttonid)
{
	ButtonPlayerData[playerid][butCurrentId] = buttonid;

	if(ButtonPlayerData[playerid][butLastPressId] != INVALID_BUTTON_ID)
	{
		if(ButtonData[ButtonPlayerData[playerid][butLastPressId]][e_BUTTON_ON_RELEASE_CALLBACK]) {
			CallFunction(ButtonData[ButtonPlayerData[playerid][butLastPressId]][e_BUTTON_ON_RELEASE_CALLBACK], playerid, ButtonData[ButtonPlayerData[playerid][butLastPressId]][e_BUTTON_EXTRA_ID], GetTickCount() - ButtonPlayerData[playerid][butLastPressTick]);
			//CallFunction(ButtonData[ButtonPlayerData[playerid][butLastPressId]][e_BUTTON_ON_RELEASE_CALLBACK], playerid, ButtonData[ButtonPlayerData[playerid][butLastPressId]][e_BUTTON_EXTRA_ID], GetTickCount() - ButtonPlayerData[playerid][butLastPressTick], BUTTON_RELEASE_ENTER_OTHER);
		}

		ButtonPlayerData[playerid][butLastPressId] = INVALID_BUTTON_ID;
	}

	if(!isnull(ButtonData[buttonid][e_BUTTON_ON_ENTER_TEXT]) && (ButtonPlayerData[playerid][butLastId] != buttonid || gettime() >= ButtonPlayerData[playerid][butOnEnterTextCooldown]))
	{
		Noti_Create(playerid, ButtonData[buttonid][e_BUTTON_ON_ENTER_TEXT_TIME], ButtonData[buttonid][e_BUTTON_ON_ENTER_TEXT]);
		ButtonPlayerData[playerid][butOnEnterTextCooldown] = gettime() + 10;
	}

	if(ButtonData[buttonid][e_BUTTON_ON_ENTER_CALLBACK]) {
		CallFunction(ButtonData[buttonid][e_BUTTON_ON_ENTER_CALLBACK], playerid, ButtonData[buttonid][e_BUTTON_EXTRA_ID]);
	}

	ButtonPlayerData[playerid][butLastId] = buttonid;
}

Button_OnPlayerLeave(playerid, Button:buttonid)
{
	if(buttonid == ButtonPlayerData[playerid][butCurrentId]) {
		ButtonPlayerData[playerid][butCurrentId] = INVALID_BUTTON_ID;
	}

	if(buttonid == ButtonPlayerData[playerid][butLastPressId])
	{
		ButtonPlayerData[playerid][butLastPressId] = INVALID_BUTTON_ID;

		if(ButtonData[buttonid][e_BUTTON_ON_RELEASE_CALLBACK]) {
			CallFunction(ButtonData[buttonid][e_BUTTON_ON_RELEASE_CALLBACK], playerid, ButtonData[buttonid][e_BUTTON_EXTRA_ID], GetTickCount() - ButtonPlayerData[playerid][butLastPressTick]);
			//CallFunction(ButtonData[buttonid][e_BUTTON_ON_RELEASE_CALLBACK], playerid, ButtonData[buttonid][e_BUTTON_EXTRA_ID], GetTickCount() - ButtonPlayerData[playerid][butLastPressTick], BUTTON_RELEASE_LEFT);
		}
	}

	if(ButtonData[buttonid][e_BUTTON_ON_EXIT_CALLBACK]) {
		CallFunction(ButtonData[buttonid][e_BUTTON_ON_EXIT_CALLBACK], playerid, ButtonData[buttonid][e_BUTTON_EXTRA_ID]);
	}
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(ButtonPlayerData[playerid][butCurrentId] != INVALID_BUTTON_ID && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if(KEY_PRESSED_SINGLE(KEY_CTRL_BACK))
		{
			ButtonPlayerData[playerid][butLastPressId] = ButtonPlayerData[playerid][butCurrentId];
			ButtonPlayerData[playerid][butLastPressTick] = GetTickCount();

			if(ButtonData[ButtonPlayerData[playerid][butCurrentId]][e_BUTTON_ON_PRESS_CALLBACK]) {
				CallFunction(ButtonData[ButtonPlayerData[playerid][butCurrentId]][e_BUTTON_ON_PRESS_CALLBACK], playerid, ButtonData[ButtonPlayerData[playerid][butCurrentId]][e_BUTTON_EXTRA_ID]);
			}
		}
		else if(KEY_RELEASED_SINGLE(KEY_CTRL_BACK))
		{
			if(ButtonPlayerData[playerid][butLastPressId] == ButtonPlayerData[playerid][butCurrentId])
			{
				ButtonPlayerData[playerid][butLastPressId] = INVALID_BUTTON_ID;

				if(ButtonData[ButtonPlayerData[playerid][butCurrentId]][e_BUTTON_ON_RELEASE_CALLBACK]) {
					CallFunction(ButtonData[ButtonPlayerData[playerid][butCurrentId]][e_BUTTON_ON_RELEASE_CALLBACK], playerid, ButtonData[ButtonPlayerData[playerid][butCurrentId]][e_BUTTON_EXTRA_ID], GetTickCount() - ButtonPlayerData[playerid][butLastPressTick]);
				}
			}
		}
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	ButtonPlayerData[playerid] = ButtonPlayerData[BUTTON_PLAYER_RESET_ID];
	return 1;
}

stock Button:Button_GetCurrentForPlayer(playerid) {
	return ButtonPlayerData[playerid][butCurrentId];
}

stock Button:Button_IsPlayerInAny(playerid) {
	return (ButtonPlayerData[playerid][butCurrentId] != INVALID_BUTTON_ID);
}

Button_IsPlayerInId(playerid, Button:buttonid) {
	return (Iter_Contains(ButtonData, _:buttonid) && ButtonPlayerData[playerid][butCurrentId] == buttonid);
}