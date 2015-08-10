#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Dtafalonso-Modern-Xp-ModernXP-09-Keyboard.ico
#AutoIt3Wrapper_Outfile=Serial2Keyboard.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <TrayConstants.au3>
#include 'CommMG.au3'

HotKeySet("+!d", "ExitProgram")

Opt("TrayMenuMode", 3)

Local $sportSetError

Local $idOpen = TrayCreateItem("แก้ไขการเชื่อมต่อ")
Local $idExit = TrayCreateItem("ออกจากโปรแกรม")
TraySetState($TRAY_ICONSTATE_SHOW)

#Region ### START Koda GUI section ### Form=C:\Users\Max\OneDrive\เอกสาร\Serial2Keyboard.kxf

$Form = GUICreate("Serial2Keyboard", 250, 170, -1, -1)
GUICtrlCreateGroup("Connect config", 8, 8, 233, 73)
$Port = GUICtrlCreateCombo("", 24, 40, 89, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
$Baudrates = GUICtrlCreateCombo("", 136, 40, 89, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "1200|2400|4800|9600|19200|38400|57600|115200", "9600")
;~ GUICtrlCreateGroup("", -99, -99, 1, 1)
$ButtonStart = GUICtrlCreateButton("Start !", 8, 96, 233, 49)
GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
$Label1 = GUICtrlCreateLabel("IOXhop - www.ioxhop.com", 64, 152, 130, 17, $SS_CENTER)
GUISetState(@SW_SHOW)

$portlist = _CommListPorts(0)

If Not @error = 1 Then
	For $pl = 1 To $portlist[0]
		GUICtrlSetData($Port, $portlist[$pl])
	Next
EndIf

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $ButtonStart
			If GUICtrlRead($Port) == "" Then
				MsgBox(16, "ผิดพลาด", "กรุณาเลือกพอร์ตที่ถูกต้อง")
			Else
				$setport = StringReplace(GUICtrlRead($Port), 'COM', '')
				$resOpen = _CommSetPort($setport, $sportSetError, GUICtrlRead($Baudrates))
				If $resOpen = 0 Then
					MsgBox(16, "ผิดพลาด", $sportSetError)
				Else
					GUICtrlSetState($ButtonStart, $GUI_DISABLE)

					GUISetState(@SW_HIDE, $Form)
					TrayTip("Serial2Keyboard", "กด Shift-Alt-d เมื่อต้องการออกจากโปรแกรม", 5)
					While 1
						Switch TrayGetMsg()
							Case $idExit
								Exit
							Case $idOpen
								GUISetState(@SW_SHOW, $Form)
						EndSwitch
						$Str = _Commgetstring()
						If $Str <> "" Then
							Send($Str)
						EndIf
					WEnd
				EndIf
			EndIf
	EndSwitch
WEnd

Func ExitProgram()
	Exit
EndFunc
