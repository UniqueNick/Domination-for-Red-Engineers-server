// Desc: Team Status Dialog
// Version: 1.3 (November 2008)
//-----------------------------------------------------------------------------
// This is an extract of the base dialog control classes from the Dialog
// Framework project, in order to remove it's dependency on it.
// This should make it easier to incorporate this dialog into other missions
// which already use their own dialogs.
//=============================================================================
//#ifndef _DFCC9_DialogFrameworkClasses_hpp_
//-----------------------------------------------------------------------------
#define TSD9_FontM "TahomaB"

#define TSD9_CT_STATIC 0
#define TSD9_CT_BUTTON 1
#define TSD9_CT_COMBO 4
#define TSD9_CT_LISTBOX 5

// Static styles
#define TSD9_ST_LEFT 0x00
#define TSD9_ST_RIGHT 0x01
#define TSD9_ST_CENTER 0x02

#define TSD9_ST_FRAME 64

//-----------------------------------------------------------------------------
#define TSD9_ColorAttribute_Clear {0, 0, 0, 0}

#define TSD9_Color_Black 0,0,0
#define TSD9_Color_White 1,1,1

// additive primaries
#define TSD9_Color_Red 1,0,0
#define TSD9_Color_Lime 0,1,0
#define TSD9_Color_Blue 0,0,1

// subtractive primaries
#define TSD9_Color_Yellow 1,1,0
#define TSD9_Color_Fuchsia 1,0,1 // TSD9_Color_Magenta
#define TSD9_Color_Aqua 0,1,1 // TSD9_Color_Cyan

// shades
#define TSD9_Color_Maroon 0.5,0,0
#define TSD9_Color_Green 0,0.5,0
#define TSD9_Color_Navy 0,0,0.5

#define TSD9_Color_Olive 0.5,0.5,0
#define TSD9_Color_Purple 0.5,0,0.5
#define TSD9_Color_Teal 0,0.5,0.5

// grays
#define TSD9_Color_Gray 0.5,0.5,0.5 // TSD9_Color_DkGray
#define TSD9_Color_Silver 0.75,0.75,0.75 // TSD9_Color_LtGray
#define TSD9_Color_LtGray 0.75,0.75,0.75 // TSD9_Color_Silver
#define TSD9_Color_DkGray 0.5,0.5,0.5 // TSD9_Color_Gray

// 0.1 is darkest (near black) 0.9 is lightest (near white)
#define TSD9_Color_Gray_1 0.1,0.1,0.1
#define TSD9_Color_Gray_2 0.2,0.2,0.2
#define TSD9_Color_Gray_3 0.3,0.3,0.3
#define TSD9_Color_Gray_4 0.4,0.4,0.4
#define TSD9_Color_Gray_5 0.5,0.5,0.5
#define TSD9_Color_Gray_6 0.6,0.6,0.6
#define TSD9_Color_Gray_7 0.7,0.7,0.7
#define TSD9_Color_Gray_8 0.8,0.8,0.8
#define TSD9_Color_Gray_9 0.9,0.9,0.9

#define TSD9_ColorScheme_DialogBackground 0x29/256, 0x37/256, 0x46/256 // dark blue
#define TSD9_ColorScheme_DialogText 1,1,1 // TSD9_Color_white

#define TSD9_ColorScheme_WindowBackground 0x4C/256, 0x5E/256, 0x4A/256 // pale dark green
#define TSD9_ColorScheme_WindowText 1,1,1 // TSD9_Color_white

#define TSD9_ColorScheme_3DControlBackground 0x7D/256, 0x77/256, 0x66/256 // pale brown grey
#define TSD9_ColorScheme_3DControlText 1,1,1 // TSD9_Color_white

#define TSD9_ColorScheme_3DControlFocus 0xDD/256, 0xDF/256, 0x82/256 // tan
#define TSD9_ColorScheme_HighlightBackground 0x99/256, 0x8C/256, 0x58/256 // tan
#define TSD9_ColorScheme_HighlightText 1,1,1 // TSD9_Color_white

#define TSD9_ColorScheme_CaptionBackground 0x3E/256, 0x74/256, 0x58/256 // dark green
#define TSD9_ColorScheme_CaptionText 1,1,1 // TSD9_Color_white

#define TSD9_ColorScheme_MenuBackground 0x29/256, 0x37/256, 0x46/256 // dark blue

//#define TSD9_Color_PaleBlue 0.3,0.3,0.7

//-----------------------------------------------------------------------------
class TSD9_RscText
{
	type = TSD9_CT_STATIC;
	idc = -1;
	style = TSD9_ST_LEFT;

	x = 0.0;
	y = 0.0;
	w = 0.3;
	h = TSD9_CONTROLHGT;
	sizeEx = TSD9_CONTROLHGT;

	colorBackground[] = {TSD9_ColorScheme_WindowBackground, 1};
	colorText[] = {TSD9_ColorScheme_DialogText, 1};
	font = TSD9_FontM;

	text = "";
};
//-------------------------------------
class TSD9_RscFrame
{
	type = TSD9_CT_STATIC;
	idc = -1;
	style = TSD9_ST_FRAME;

	x = 0.0;
	y = 0.0;
	w = 1.0;
	h = 1.0;
	sizeEx = TSD9_CONTROLHGT;

	colorBackground[] = {TSD9_Color_Red, 1}; // always clear?
	colorText[] = {TSD9_ColorScheme_WindowText, 1};
	font = TSD9_FontM;

	text = "";
};
//-------------------------------------
class TSD9_RscButton
{
	type = TSD9_CT_BUTTON;
	idc = -1;
	style = TSD9_ST_CENTER;

	x = 0.0;
	y = 0.0;
	w = 0.1;
	h = TSD9_CONTROLHGT;
	sizeEx = TSD9_TEXTHGT;
	offsetX = 0;
	offsetY = 0;
	offsetPressedX = 0;
	offsetPressedY = 0;
	borderSize = 0.001;

	colorText[] = {TSD9_ColorScheme_3DControlText,1};
	colorBackground[] = {TSD9_ColorScheme_3DControlBackground, 1};
	colorFocused[] = {TSD9_ColorScheme_3DControlFocus,1};

	colorShadow[] = {TSD9_Color_Red,0.2};
	colorBorder[] = {TSD9_Color_White,0.2};
	colorBackgroundActive[] = {TSD9_ColorScheme_HighlightBackground,1.0};
	colorDisabled[] = {TSD9_Color_Gray_7, 0.7};
	colorBackgroundDisabled[] = {TSD9_ColorScheme_3DControlBackground,0.3};
	font = TSD9_FontM;

	soundEnter[] = {"\ca\ui\data\sound\mouse2", 0.2, 1};
	soundPush[] = {"\ca\ui\data\sound\new1", 0.2, 1};
	soundClick[] = {"\ca\ui\data\sound\mouse3", 0.2, 1};
	soundEscape[] = {"\ca\ui\data\sound\mouse1", 0.2, 1};

	default = false;
	text = "";
	action = "";
};
//-------------------------------------
class TSD9_RscLB_LIST
{
	// type = defined in derived class
	idc = -1;
	style = TSD9_ST_LEFT;

	x = 0.1;
	y = 0.1;
	w = 0.2;
	h = TSD9_CONTROLHGT;
	sizeEx = TSD9_TEXTHGT;
	rowHeight = TSD9_TEXTHGT;

	color[] = {TSD9_Color_White,1};
	colorText[] = {TSD9_ColorScheme_WindowText,1};
	colorBackground[] = {TSD9_ColorScheme_WindowBackground, 1}; // always clear?
	colorSelect[] = {TSD9_ColorScheme_WindowText,1};
	colorSelect2[] = {TSD9_ColorScheme_WindowText,1};
	colorScrollbar[] = {TSD9_Color_White,1};
	colorSelectBackground[] = {TSD9_ColorScheme_3DControlBackground,1};
	colorSelectBackground2[] = {TSD9_ColorScheme_HighlightBackground,1};
	font = TSD9_FontM;

	soundSelect[] = {"\ca\ui\data\sound\mouse3", 0.2, 1};
	soundExpand[] = {"\ca\ui\data\sound\mouse2", 0.2, 1};
	soundCollapse[] = {"\ca\ui\data\sound\mouse1", 0.2, 1};
};
//-------------------------------------
class TSD9_RscCombo: TSD9_RscLB_LIST
{
	type = TSD9_CT_COMBO;

	wholeHeight = 0.3;
};
//-------------------------------------
class TSD9_FullBackground: TSD9_RscText
{
	x = 0.0;
	y = 0.0;
	w = 1.0;
	h = 1.0;

	colorBackground[] = {TSD9_ColorScheme_DialogBackground,0.9};
};
//-------------------------------------
class TSD9_FullBackgroundFrame: TSD9_RscFrame
{
	x = 0.0;
	y = 0.0;
	w = 1.0;
	h = 1.0;

	text = " Выбор диалога ";
};
//-------------------------------------
class TSD9_Caption: TSD9_RscText
{
	//TODO style = ST_HUD_BACKGROUND+ST_LEFT;
	x = 0.0;
	y = 0.0;
	w = 0.3;

	colorBackground[] = {TSD9_ColorScheme_CaptionBackground, 1};
	colorText[] = {TSD9_ColorScheme_CaptionText, 1};
};
//-------------------------------------
class TSD9_WindowCaption: TSD9_Caption
{
	x = 0.0;
	y = 0.0;
	w = 1.0;
};
//-----------------------------------------------------------------------------
//#endif // _DFCC9_DialogFrameworkClasses_hpp_
