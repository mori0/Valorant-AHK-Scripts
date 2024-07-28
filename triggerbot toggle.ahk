#NoEnv
#Persistent
#MaxThreadsPerHotkey 2
#KeyHistory 0
ListLines Off
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
CoordMode, Pixel, Screen

; HOTKEYS
key_hold_mode := "alt"
key_exit := "End"
key_hold := "XButton2"
key_config_1 := "Numpad1"
key_config_2 := "Numpad2"
key_config_3 := "Numpad3"
key_config_4 := "Numpad4"
key_config_5 := "Numpad5"

; SETTINGS
global pixel_box := 2             ; Keep between min 3 and max 8
global pixel_sens := 60            ; higher/lower = more/less color sensitive
global pixel_color := 0xFEFE40     ; yellow="0xFEFE40", purple="0xA145A3"
global tap_time := 60              ; Default delay in ms between shots when triggered
global wait_time := 0              ; Default delay in ms before shoots when triggered               
global clicks := 1                 ; Default flag for clicks config
global sound_file := "C:\Windows\Media\chimes.wav"
global sound_file_off := "C:\Windows\Media\Speech Off.wav"
global sound_file_on := "C:\Windows\Media\Speech On.wav"
global waiting := 0
global allKeysNotPressed := 0
global noMovementCheck := 0
global startValue := 0

leftbound := A_ScreenWidth / 2 - pixel_box
rightbound := A_ScreenWidth / 2 + pixel_box
topbound := A_ScreenHeight / 2 - pixel_box
bottombound := A_ScreenHeight / 2 + pixel_box

hotkey, %key_hold_mode%, holdmode_on
hotkey, %key_exit%, terminate
hotkey, %key_config_1%, toggleConfig1
hotkey, %key_config_2%, toggleConfig2
hotkey, %key_config_3%, toggleConfig3
hotkey, %key_config_4%, toggleConfig4
hotkey, %key_config_5%, toggleConfig5
return

start:
    SoundBeep, 500, 1000
    return

terminate:
    SoundPlay, off
    SoundBeep, 500, 500
    Sleep, 400
    ExitApp
    return

holdmode_on:
	if(startValue = 0) {
		SoundPlay, %sound_file_on%
		startValue := 1
		SetTimer, loop2, 1
		} else {
		SoundPlay, %sound_file_off%
		SetTimer, loop2, 0
		startValue := 0
		}
    return

loop2:
    global waiting, allKeysNotPressed, noMovementCheck, startValue
    keys := ["W", "A", "D", "S", "Space"]

    If (startValue = 1) {
        For index, key in keys {
            If (GetKeyState(key, "P") && (noMovementCheck = 0)) {
                allKeysNotPressed := 1
				sleep 150
                break
            } else {
                allKeysNotPressed := 0
            }
        }
        
        If (allKeysNotPressed = 0) {
            If (waiting = 0) {
                PixelSearch()
            }
        }
    }
    return

PixelSearch() {
    global pixel_box, pixel_sens, pixel_color, tap_time, wait_time, clicks, waiting
    global FoundX, FoundY, leftbound, topbound, rightbound, bottombound
    PixelSearch, FoundX, FoundY, leftbound, topbound, rightbound, bottombound, pixel_color, pixel_sens, Fast RGB
	
    If (!(ErrorLevel)) {
        If !GetKeyState("LButton") {
            waiting := 1
            sleep %wait_time%
            ClickWithConfig(tap_time, clicks)
        }
    }
    return
}

ClickWithConfig(tap_delay, repeat_count) {
    global waiting
    loop %repeat_count% {
        click
        sleep %tap_delay%
    }
    sleep 1000
    waiting := 0
    return
}

toggleConfig1: ; sheriff, guardian, marshal
	global noMovementCheck
    SetConfig(300, 0, 1)
	noMovementCheck := 0
    return

toggleConfig2: ; vandal
	global noMovementCheck
    SetConfig(130, 0, 2)
	noMovementCheck := 0
    return

toggleConfig3: ; awp
	global noMovementCheck
    SetConfig(1000, 50, 1)
	noMovementCheck := 0
    return
	
toggleConfig4: ; pistols
	global noMovementCheck
    SetConfig(150, 0, 1)
	noMovementCheck := 0
    return

toggleConfig5: ; jett knives
	global noMovementCheck
    SetConfig(50, 0, 1)
	noMovementCheck := 1
    return

SetConfig(new_tap_time, new_wait_time, new_clicks) {
    global tap_time, wait_time, clicks, sound_file
    tap_time := new_tap_time
    wait_time := new_wait_time
    clicks := new_clicks
    SoundPlay, %sound_file%
    return
}
