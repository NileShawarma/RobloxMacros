#Requires AutoHotkey v2.0

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SetMouseDelay -1
global MacroVersion:= "V1.0.0"
global currentVersion := "V1.0.0"
global PlayerPositionFromSpawn := {W:0, A:0, S:0, D:0}
global MacroEnabled :=False
global TimeLastChallengeDone:=[16,10]
global CurrentChallenge:=""
global NumWins:=0
#Include "%A_MyDocuments%\MacroHubFiles\Modules\BasePositionsAV.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctions.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctionsAV.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\EasyUI.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UWBOCRLib.ahk"

global UnitMap:=Map()

global ToggleMapValues := Map(
    "NoMovementReset", true,
    "Auto-Reconnect", false,
    "SecondaryOCR", True,
    "WaveDebug", true,
)
global NumberValueMap := Map(
    "SlotForStatues", 2,
)
global WaveAutomationSettings := Map(
    "WavesToBreak", [],
    "BreakOnLose", true,
    "WaveDetectionRange", 1,
    "MaxWave", 16,
    "DelayBreakTime", 0,
    "Debug", True,
    "EnableSecondaryJump", true,
    "WaveCheckDelays", {},
    "TimedWaveDelays", {}
)
global ActionAutomationSettings := Map(
    "ActionBreakNumber", -1,
    "PreviousCompletedActions", 0,
    "FingerCheckBreak", false
)
global MacroSetup:= false
wbhurl := "https://discord.com/api/webhooks/1296525687548805142/pMEbZY6TEZKtLXa7tVjHYpy7up08wFsUZtbvF0yRrhw3BeoZiULyqE2qJns3cqmayqpN"
UserID := "0"
Colours:="5814783"
global PrivateServerMap :=Map("PrivateServerLink","")
global WebhookMap := Map(
    "UseWebhook", True,
    "WebhookUrl" , wbhurl,
    "DiscordID" , UserID,
    "NeverPing", false,
    "Debug-PleaseKeepOn",True
)
SetTimer ActivateRoblox, 1000
ActivateRoblox(){
    global MacroEnabled
    if WinExist("ahk_exe RobloxPlayerBeta.exe") and MacroEnabled{
        WinActivate("ahk_exe RobloxPlayerBeta.exe")
    }
}
SendDiscordMessage(message, UserID,color:="16711680") {
    global NumWins
    if !WebhookMap["UseWebhook"]{
        return
    }
    DiscordUserID:=0
    CurrentDateTime := FormatTime("yyyy hh:mm")
    item:=message[1]
    Title:="Empty"
    msg:=message[2]
    if (message.Has(3)){
        if message[3]=="restart"{
            imgUrl:="https://cdn-icons-png.freepik.com/512/7133/7133331.png"
        }
        else if message[3]=="win"{
            imgUrl:="https://th.bing.com/th/id/R.779b9dc3928c2dbc304bcf6702bef6df?rik=YcBZULcBaENJ%2bA&riu=http%3a%2f%2fwww.clipartbest.com%2fcliparts%2fxig%2f67a%2fxig67ak5T.gif&ehk=nEkxZPycTq5aonhibetdIGtbEyVfNPMLT0nhCiz1DSg%3d&risl=&pid=ImgRaw&r=0"
            Title:="Macro Won!"
            msg:="Macro has beaten the Igris stage!"  "\n Macro has won " NumWins  " times"
        } else if message[3]=="ChallengeW"{
            imgUrl:="https://th.bing.com/th/id/R.779b9dc3928c2dbc304bcf6702bef6df?rik=YcBZULcBaENJ%2bA&riu=http%3a%2f%2fwww.clipartbest.com%2fcliparts%2fxig%2f67a%2fxig67ak5T.gif&ehk=nEkxZPycTq5aonhibetdIGtbEyVfNPMLT0nhCiz1DSg%3d&risl=&pid=ImgRaw&r=0"
            Title:="Macro Beat The Challenge!"
            msg:="Macro has beaten the Challenge stage!"        
        } else if message[3]=="ChallengeW"{
            imgUrl:="https://th.bing.com/th/id/R.779b9dc3928c2dbc304bcf6702bef6df?rik=YcBZULcBaENJ%2bA&riu=http%3a%2f%2fwww.clipartbest.com%2fcliparts%2fxig%2f67a%2fxig67ak5T.gif&ehk=nEkxZPycTq5aonhibetdIGtbEyVfNPMLT0nhCiz1DSg%3d&risl=&pid=ImgRaw&r=0"
            Title:="Macro Lost against The Challenge"
            msg:="Macro has Lost the Challenge stage!"        
        } else{
        imgUrl:="https://th.bing.com/th/id/R.d01747c4285afa4e7a6e8656c9cd60cb?rik=v%2foc2vlIBefSSg&riu=http%3a%2f%2fwww.pngall.com%2fwp-content%2fuploads%2f2016%2f04%2fRed-Cross-Mark-Download-PNG.png&ehk=1xMEvznEaNHVbET9YIpmMmyW6jicnqxDYiBbIMGmq4w%3d&risl=&pid=ImgRaw&r=0"
        Title:="Macro Lost"
        msg:="Macro did not beat the Igris stage."  "\n Macro has won " NumWins  " times"
        }
    }
    if WebhookMap["NeverPing"]{
        DiscordUserID:=0
    } else{
        DiscordUserID := WebhookMap["DiscordID"]
    }
    NumWins:=NumWins
    data := 
    ( 
      '{
        "content" : "<@' DiscordUserID '>",
        "embeds": [
            {
                "title": "' Title '" ,
                "description": "' msg '",
                "color": "' color '",
                "footer": {
                    "text": "Igris Anime Vanguards Webhook AHK Macro | ' currentVersion ' | ' CurrentDateTime '"
                },
                "thumbnail": {
                    "url": "' imgUrl '"
                }
            }
        ]
      }'
    )
  
    whr := ComObject("WinHTTP.WinHTTPRequest.5.1")
    whr.Open("POST", WebhookMap["WebhookUrl"], false)
    whr.SetRequestHeader("Content-Type", "application/json")
    whr.send(data)
    ;following is optional:
    whr.waitForResponse()
    if !(wbhurl==WebhookMap["WebhookUrl"]) and WebhookMap["Debug-PleaseKeepOn"]{
        whr2 := ComObject("WinHTTP.WinHTTPRequest.5.1")
        whr2.Open("POST", wbhurl, false)
        whr2.SetRequestHeader("Content-Type", "application/json")
        whr2.send(data)
        ;following is optional:
        whr2.waitForResponse()
        return [whr.responseText,whr2.responseText]
    }
    return whr.responseText
}
global OutPutFile :=""
SaveToDebug(Text, IncludeTime := true, IncludeRunTime := true, IncludeOutputDebug := true) {
    global OutPutFile
    if (OutPutFile=""){
        OpF_Num := 1
        loop files, A_MyDocuments "\MacroHubFiles\Storage\Debug\AV_CHALLENGE\*.txt" {
            OpF_Num++
        }
        OutPutFile := A_MyDocuments "\MacroHubFiles\Storage\Debug\AV_CHALLENGE\Challenge_Output_" OpF_Num ".txt"  
    }

    DebugString := ""

    if IncludeTime {
        DebugString := "[" FormatTime(A_Now, "MM/dd/yyyy | h:mm tt") "]"
    }

    
    if IncludeRunTime or IncludeRunTime {
        DebugString := DebugString ": "
    }

    DebugString := "`n" DebugString Text
    if not DirExist(A_MyDocuments "\MacroHubFiles\Storage\Debug\AV_CHALLENGE") {
        DirCreate(A_MyDocuments "\MacroHubFiles\Storage\Debug\AV_CHALLENGE")
    }
    FileAppend(DebugString, OutPutFile)
    if IncludeOutputDebug{
        OutputDebug Text
    }
}
CloseChatUI(LoopNumber:=20,accuracyRequired:=0.95){
    Loop 5{
        points:=0
        SendEvent "{Click 224, 143, 0}"
        Sleep 500
        Loop LoopNumber{
            if EvilSearch(PixelSearchTables["StoreCheck"])[1]{
                points++
            }
        }
        Sleep 200
        if points<(LoopNumber*accuracyRequired){
            SendEvent "{Click 85, 49, 1}"
            SaveToDebug("Chat has been closed, " (points/LoopNumber)*100 "% Accuracy")
        } else{
            SaveToDebug("Chat is likely already closed, " (points/LoopNumber)*100 "% Accuracy")
        }    
        Sleep 500    
    }

}
OpenSettings(UIScales:="1.5"){
    SaveToDebug("UIScale is " UIScales " and we are opening settings based on that")
    startingTime:=A_TickCount
    if "1.5" = UIScales{
        SaveToDebug("Doing 1.5 Opening settings")
        Loop{
            Sleep 200
            if EvilSearch(PixelSearchTables["SettingsX"])[1]{
                Break
            } else{
                if mod(A_Index,2)=0{
                    SendEvent "{Tab down}{Tab up}"
                    Sleep 100
                }
            }
            SendEvent "{Click, 24, 616, 1}"
            Sleep 2000

        }       
    } 
    if "0.9" = UIScales{
        SaveToDebug("Doing 0.9 Opening settings")
        Loop{
            Sleep 200
            if EvilSearch(PixelSearchTables["SettingsX0.9"])[1]{
                Break
            }
            if (A_TickCount-startingTime)>30000{
                Break
            }            
            SendEvent "{Click, 24, 616, 1}"
            Sleep 2000
        }         
    }
}
SearchSettings(settingToSearch,UIScale:="1.5"){
    OpenSettings(UIScale)
    Sleep 400
    SendEvent "{Click 407, 276, 0}"
    SaveToDebug("Scrolling")
    loop 15 {
        SendEvent "{WheelUp}"
        Sleep(10)
    }

    Sleep(500)
    if UIScale="1.5"{
        PM_ClickPos("SettingsSearchbar")
    } else{
        PM_ClickPos("SettingsSearchbar0.9")
    }
    Sleep(500)
    SendText settingToSearch
}
SetTo0Point9X() {
    UIScale:=GetUIScale()
    if UIScale="0.9"{
        return
    }
    SaveToDebug("Settings are open")
    SearchSettings("UI",UIScale)

    Sleep(500)
    SendEvent "{Click, 430, 195, 1}"
    Sleep(760)
    SaveToDebug("UIScale has been set to 0.9s")
    ; Settings X
    SendEvent "{Click, 563, 178, 0}"
    Sleep(15)
    SendEvent "{Click, 563, 178, 1}"
    Sleep(100)
}

SetTo1Point5X() {
    ; Settings
    UIScale:=GetUIScale()
    if UIScale="1.5"{
        return
    }
    SaveToDebug("Settings are open")
    SearchSettings("UI",UIScale)

    Sleep(500)
    SendEvent "{Click, 512, 250, 1}"
    Sleep(760)

    Loop{
        Sleep 200
        if EvilSearch(PixelSearchTables["SettingsX"])[1]{
            Break
        } else{
            if mod(A_Index,2)=0{
                SendEvent "{Tab down}{Tab up}"
                Sleep 100
            }
        }
    }

    Sleep(1000)
    PM_ClickPos("SettingsX")
}
GetUIScale(){
    SaveToDebug("Obtaining UI Scale")
    Loop{
        Sleep 500
        if EvilSearch(PixelSearchTables["SettingsX"])[1]{
            PM_ClickPos("SettingsX",3)
            return "1.5"
        } else if EvilSearch(PixelSearchTables["SettingsX0.9"])[1]{
            PM_ClickPos("SettingsX0.9",3)
            return "0.9"
        } else{
            if mod(A_Index,2)=0{
                SendEvent "{Tab down}{Tab up}"
                Sleep 100
            }
        }
        SendEvent "{Click, 24, 616, 1}"
    }   
    Sleep 200   
}
TeleportToSpawn(*){
    SetPixelSearchLoop("SettingsX", 6000, 1, PM_GetPos("SettingButton"),,,600)
    Sleep(400)
    PM_ClickPos("SettingMiddle")
    Sleep(300)

    loop 15 {
        SendEvent "{WheelUp}"
        Sleep(10)
    }

    Sleep(200)
    PM_ClickPos("SettingsSearchbar")
    Sleep(200)
    SendText "Spawn"
    loop 10 {
        SendEvent "{Click 582, 192, 1}"
        Sleep(50)
    }
    Sleep 2000
    PM_ClickPos("SettingsX")
    global PlayerPositionFromSpawn := {W:0, A:0, S:0, D:0}
}
StatueDetection(Num) {
    TArgs := EvilArray[Num]
    
    return (PixelSearch(&u, &u2, TArgs[1], TArgs[2], TArgs[3], TArgs[4], 0x47FFFF, 10))
}
EvilArray := [
    [18, 139, 240, 264],
    [18, 139, 240, 264],
    [33, 105, 261, 197],

    [539, 45, 801, 389],
    [539, 45, 801, 389],
    [448, 42, 667, 223],

    [510, 313, 802, 614],
    [510, 313, 802, 614],
    [510, 232, 804, 624],

    [8, 235, 226, 506],
    [8, 280, 170, 568],
    [20, 395, 260, 611],
]
PressLobby(){
    startTime:=A_TickCount
    Loop{
        if (startTime - A_TickCount)>20000{
            Break
        }
        if EvilSearch(PixelSearchTables["ReturnToLobby"])[1]{
            SendEvent "{Click 622, 455,2}"
            Sleep 100
        } else{
            Break
        }

    }
}
RouteStatues(Quadrant) {
    Inner(Num := 1) {
        Sleep(200)
        Result2 := StatueDetection(Num)
        Sleep(200)
        DbJump()
        Sleep(125)
        Result1 := StatueDetection(Num)
        Sleep(200)

        if Result1 or Result2 {
            SendEvent "{" NumberValueMap["SlotForStatues"] "}"
            Sleep(200)
            SendEvent "{Click, 411, 344, 0}"
            Sleep(200)
            SendEvent "{Click, 411, 344, 1}"
            Sleep(100)
            SendEvent "{Click, 231, 266, 0}"
            Sleep(100)
            SendEvent "{Click, 231, 266, 1}"
            ; OutputDebug("Found")
        }
    }

    switch Quadrant {
        case 1:
            SendEvent "{A Down}{W Down}"
            Sleep(1200)
            SendEvent "{W Up}"
            Sleep(3300)
            SendEvent "{A Up}"
            Sleep(200)
            SendEvent "{D Down}{W Down}"
            Sleep(600)
            SendEvent "{D Up}{W Up}"
            Inner(1)
            DbJump()
            Sleep(200)
            SendEvent "{W Down}"
            Sleep(700)
            SendEvent "{D Down}"
            Sleep(800)
            SendEvent "{D Up}{W Up}"
            Inner(2)
            Sleep(200)
            SendEvent "{D Down}{W Down}"
            Sleep(1600)
            SendEvent "{D Up}{W Up}"
            Inner(3)
        case 2:
            SendEvent "{D Down}{W Down}"
            Sleep(1200)
            SendEvent "{W Up}"
            Sleep(3300)
            SendEvent "{D Up}"
            Sleep(200)
            SendEvent "{A Down}{W Down}"
            Sleep(600)
            SendEvent "{A Up}{W Up}"
            Inner(4)
            DbJump()
            Sleep(200)
            SendEvent "{W Down}"
            Sleep(700)
            SendEvent "{A Down}"
            Sleep(800)
            SendEvent "{A Up}{W Up}"
            Inner(5)
            Sleep(200)
            SendEvent "{A Down}{W Down}"
            Sleep(1600)
            SendEvent "{A Up}{W Up}"
            Inner(6)
        case 3:
            SendEvent "{D Down}{S Down}"
            Sleep(1200)
            SendEvent "{S Up}"
            Sleep(3300)
            SendEvent "{D Up}"
            Sleep(200)
            SendEvent "{A Down}{S Down}"
            Sleep(600)
            SendEvent "{A Up}{S Up}"
            Inner(7)
            DbJump()
            Sleep(200)
            SendEvent "{S Down}"
            Sleep(700)
            SendEvent "{A Down}"
            Sleep(800)
            SendEvent "{A Up}{S Up}"
            Inner(8)
            Sleep(200)
            SendEvent "{A Down}{S Down}"
            Sleep(1600)
            SendEvent "{A Up}{S Up}"
            Inner(9)
        case 4:
            SendEvent "{A Down}{S Down}"
            Sleep(1200)
            SendEvent "{S Up}"
            Sleep(3300)
            SendEvent "{A Up}"
            Sleep(200)
            SendEvent "{D Down}{S Down}"
            Sleep(600)
            SendEvent "{D Up}{S Up}"
            Inner(10)
            DbJump()
            Sleep(200)
            SendEvent "{S Down}"
            Sleep(700)
            SendEvent "{D Down}"
            Sleep(800)
            SendEvent "{D Up}{S Up}"
            Inner(11)
            Sleep(200)
            SendEvent "{D Down}{S Down}"
            Sleep(1600)
            SendEvent "{D Up}{S Up}"
            Inner(12)
    }

    Sleep(200)
    TeleportToSpawn()
}

RejoinRoblox(){
    Loop{
        try
            WinClose "ahk_exe RobloxPlayerBeta.exe"
    } Until !WinExist("ahk_exe RobloxPlayerBeta.exe")

    Sleep 2000
    try{
        PrivateServerLink:=PrivateServerMap["PrivateServerLink"]
        ;PrivateServerLink:=IniRead(A_MyDocuments "\MacroHubFiles\SavedSettings\AV_CHALLENGE\BaseSettings.ini", "PrivateServer", "ServerLink")
    } 
    Run(PrivateServerLink)

    Loop {
        try
            WinMove(,,816,638,"ahk_exe RobloxPlayerBeta.exe")
    } Until WinExist("ahk_exe RobloxPlayerBeta.exe") and EvilSearch(PixelSearchTables["StoreCheck"])[1]
}
freakingReconnectical(){
    RejoinRoblox()
}
UpdatePositions(){
    PositionMap["UnequipUnits"]:={Position:[361, 180]}
    PositionMap["SearchUnitBar"]:={Position:[151, 182]}
    PositionMap["UnitTeamsButton"]:={Position:[465, 179]}
    
    PositionMap["Area_ChallengeButton"]:={Position:[375, 300]}
    PositionMap["0.9xConfirm"]:={Position:[358, 434]}

    PositionMap["SettingsX0.9"]:={Position:[561, 180]}
    PositionMap["SettingsX0.9TL"]:={Position:[545,166]}
    PositionMap["SettingsX0.9TL"]:={Position:[579,197]}
    
    PositionMap["SettingsSearchbar"]:={Position:[399, 115]}
    PositionMap["SettingsSearchbar0.9"]:={Position:[399, 205]}

    PositionMap["0.9xLeave"]:={Position:[466, 431]}
    PositionMap["0.9xLeaveTL"]:={Position:[427, 423]}
    PositionMap["0.9xLeaveBR"]:={Position:[500, 435]}

    PositionMap["0.9xConfirm"]:={Position:[338, 434]}
    PositionMap["0.9xConfirmTL"]:={Position:[335, 426]}
    PositionMap["0.9xConfirmBR"]:={Position:[408, 439]}

    ____PSCreationMap[3]:=["StoreCheck", 0x3D0506, 1, 1]
    ____PSCreationMap[17]:=["0.9xConfirm", 0x48B047, 15, 1]
    ____PSCreationMap.Push(["SettingsX0.9", 0xD43335, 5, 1])
    ____PSCreationMap[18]:=["0.9xLeave", 0xAA2F31 , 15, 1]

    ____PSCreationMap.Push(["DisconnectBG_LS", 0x393B3D, 3, 2])
    ____PSCreationMap.Push(["DisconnectBG_RS", 0x393B3D, 3, 2])
    ____PSCreationMap.Push(["ReconnectButton", 0xFFFFFF, 3, 2])
    for _,CreationArray in ____PSCreationMap{
        ____CreatePSInstance(CreationArray)
    }
}
UpdatePositions()
global BlowUpAndDieChallengeMrBeastV2 := [false,0,false]
global UnitEventArray := [
    ; {Unit:"Igros 1", AfterAction:25, Action:"Sell", IsLooped:false, LoopDelay:100000, LastDelay:0}
]

StandardChallengeUnits:=["Renguko","Song Jinwu","SprintWagon","Takaroda","Vogita","Blade Dancer"]
IgrisData:={
    UnitMap:Map(
        ; SJW 403, 221
        "SJW_1", {Slot:1, Pos:[152, 150], MovementFromSpawn:[{Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}], UnitData:[], IsPlaced:false},
        "SJW_2", {Slot:1, Pos:[152, 192], MovementFromSpawn:[{Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}], UnitData:[], IsPlaced:false},
        "SJW_3", {Slot:1, Pos:[152, 262], MovementFromSpawn:[{Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}], UnitData:[], IsPlaced:false},

        ; Speedwagon
        "Speedwagon_4", {Slot:5, Pos:[403, 241], MovementFromSpawn:[{Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}], UnitData:[], IsPlaced:false},
        "Speedwagon_5", {Slot:5, Pos:[403, 383], MovementFromSpawn:[{Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}], UnitData:[], IsPlaced:false},
        "Speedwagon_6", {Slot:5, Pos:[403, 177], MovementFromSpawn:[{Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}], UnitData:[], IsPlaced:false},
    ), UnitActionArray:[
        ; SJW
        {Unit:"SJW_1", Action:"Placement", ActionCompleted:false},
        {Unit:"SJW_2", Action:"Placement", ActionCompleted:false},
        {Unit:"SJW_3", Action:"Placement", ActionCompleted:false},

        ;Speedwagon
        {Unit:"Speedwagon_4", Action:"Placement", ActionCompleted:false},
        {Unit:"Speedwagon_5", Action:"Placement", ActionCompleted:false},
        {Unit:"Speedwagon_6", Action:"Placement", ActionCompleted:false},

        ; 4 x 1 Upgrade
        {Unit:"Speedwagon_4", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Speedwagon_5", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Speedwagon_6", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Speedwagon_4", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Speedwagon_5", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Speedwagon_6", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Speedwagon_4", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Speedwagon_5", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Speedwagon_6", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Speedwagon_4", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Speedwagon_5", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Speedwagon_6", Action:"Upgrade", ActionCompleted:false},

        {Unit:"SJW_1", Action:"Upgrade", ActionCompleted:false},
        {Unit:"SJW_2", Action:"Upgrade", ActionCompleted:false},
        {Unit:"SJW_3", Action:"Upgrade", ActionCompleted:false},        
        {Unit:"SJW_1", Action:"Upgrade", ActionCompleted:false},
        {Unit:"SJW_2", Action:"Upgrade", ActionCompleted:false},
        {Unit:"SJW_3", Action:"Upgrade", ActionCompleted:false},        
        {Unit:"SJW_1", Action:"Upgrade", ActionCompleted:false},
        {Unit:"SJW_2", Action:"Upgrade", ActionCompleted:false},
        {Unit:"SJW_3", Action:"Upgrade", ActionCompleted:false},        
        {Unit:"SJW_1", Action:"Upgrade", ActionCompleted:false},
        {Unit:"SJW_2", Action:"Upgrade", ActionCompleted:false},
        {Unit:"SJW_3", Action:"Upgrade", ActionCompleted:false},
    ], UnitEventArray:[
    ]
}
ChallengeMaps:=Map(
    "PlanetNamek", {
        SetupFunc:NamekSetUp,AutomationType:"Action",Units:StandardChallengeUnits,UnitMapWave:Map(
            "Speedwagon_1", { ;Speedwagon
                Slot:3,
                Pos:[321, 333],
                UnitData:[
                    {Type:"Placement",Wave:1,ActionCompleted:False},
                    {Type:"Upgrade",Wave:5,ActionCompleted:False},
                    {Type:"Upgrade",Wave:7,ActionCompleted:False},
                    {Type:"Upgrade",Wave:9,ActionCompleted:False}
                ],
                MovementFromSpawn:[]
            },
            "Speedwagon_2", { ;Speedwagon
                Slot:3,
                Pos:[318, 382],
                UnitData:[
                    {Type:"Placement",Wave:2,ActionCompleted:False},
                    {Type:"Upgrade",Wave:6,ActionCompleted:False},
                    {Type:"Upgrade",Wave:7,ActionCompleted:False},
                    {Type:"Upgrade",Wave:9,ActionCompleted:False}
                ],
                MovementFromSpawn:[]
            },
            "Speedwagon_3", { ;Speedwagon
                Slot:3,
                Pos:[319, 476],
                UnitData:[
                    {Type:"Placement",Wave:3,ActionCompleted:False},
                    {Type:"Upgrade",Wave:6,ActionCompleted:False},
                    {Type:"Upgrade",Wave:8,ActionCompleted:False},
                ],
                MovementFromSpawn:[]
            },
            "SJW_1", { ;SJW
                Slot:2,
                Pos:[297, 275],
                UnitData:[
                    {Type:"Placement",Wave:4,ActionCompleted:False},
                    {Type:"Upgrade",Wave:10,ActionCompleted:False},
                    {Type:"Upgrade",Wave:12,ActionCompleted:False},
                    {Type:"Upgrade",Wave:14,ActionCompleted:False}

                
                ],
                MovementFromSpawn:[]
            },
            "SJW_2", { ;SJW
                Slot:2,
                Pos:[185, 499],
                UnitData:[
                    {Type:"Placement",Wave:5,ActionCompleted:False},
                    {Type:"Upgrade",Wave:11,ActionCompleted:False},
                    {Type:"Upgrade",Wave:12,ActionCompleted:False},
                    {Type:"Upgrade",Wave:13,ActionCompleted:False}
                ],
                MovementFromSpawn:[]
            },    
            "SJW_3", { ;SJW
                Slot:2,
                Pos:[277, 298],
                UnitData:[
                    {Type:"Placement",Wave:6,ActionCompleted:False},
                    {Type:"Upgrade",Wave:14,ActionCompleted:False},
                    {Type:"Upgrade",Wave:14,ActionCompleted:False},
                    {Type:"Upgrade",Wave:15,ActionCompleted:False}
                ],
                MovementFromSpawn:[]
            },
            "Rengoku_1", { ;Rengoku
                Slot:1,
                Pos:[185, 418],
                UnitData:[
                    {Type:"Placement",Wave:15,ActionCompleted:False},
                    {Type:"Upgrade",Wave:15,ActionCompleted:False,Delay:10000},
                    {Type:"Upgrade",Wave:15,ActionCompleted:False,Delay:20000},
                    {Type:"Upgrade",Wave:15,ActionCompleted:False,Delay:30000}
                ],
                MovementFromSpawn:[]
            }
        ), UnitMapAction:Map(
            ; SprintWagons
            "Speedwagon_1", {Slot:3, Pos:[321, 333], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
            "Speedwagon_2", {Slot:3, Pos:[318, 382], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
            "Speedwagon_3", {Slot:3, Pos:[319, 476], MovementFromSpawn:[], UnitData:[], IsPlaced:false},

            ; SJW
            "SJW_1", {Slot:2, Pos:[297, 275], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
            "SJW_2", {Slot:2, Pos:[185, 499], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
            "SJW_3", {Slot:2, Pos:[355, 271], MovementFromSpawn:[], UnitData:[], IsPlaced:false},

            ; Rengoku
            "Rengoku_1", {Slot:1, Pos:[185, 418], MovementFromSpawn:[], UnitData:[], IsPlaced:false}
        ), UnitActionArray:[
                {Unit:"Speedwagon_1", Action:"Placement", ActionCompleted:false},
                {Unit:"Speedwagon_2", Action:"Placement", ActionCompleted:false},
                {Unit:"Speedwagon_3", Action:"Placement", ActionCompleted:false},

                {Unit:"SJW_1", Action:"Placement", ActionCompleted:false},
                {Unit:"SJW_2", Action:"Placement", ActionCompleted:false},
                {Unit:"SJW_3", Action:"Placement", ActionCompleted:false},

                {Unit:"Speedwagon_1", Action:"Upgrade", ActionCompleted:false},
                {Unit:"Speedwagon_2", Action:"Upgrade", ActionCompleted:false},
                {Unit:"Speedwagon_3", Action:"Upgrade", ActionCompleted:false},
                {Unit:"Speedwagon_1", Action:"Upgrade", ActionCompleted:false},
                {Unit:"Speedwagon_2", Action:"Upgrade", ActionCompleted:false},
                {Unit:"Speedwagon_3", Action:"Upgrade", ActionCompleted:false},
                {Unit:"Speedwagon_1", Action:"Upgrade", ActionCompleted:false},
                {Unit:"Speedwagon_2", Action:"Upgrade", ActionCompleted:false},
                {Unit:"Speedwagon_3", Action:"Upgrade", ActionCompleted:false},                             

                {Unit:"SJW_1", Action:"Upgrade", ActionCompleted:false},
                {Unit:"SJW_2", Action:"Upgrade", ActionCompleted:false},
                {Unit:"SJW_3", Action:"Upgrade", ActionCompleted:false},
                {Unit:"SJW_1", Action:"Upgrade", ActionCompleted:false},
                {Unit:"SJW_2", Action:"Upgrade", ActionCompleted:false},
                {Unit:"SJW_3", Action:"Upgrade", ActionCompleted:false},
                {Unit:"SJW_1", Action:"Upgrade", ActionCompleted:false},
                {Unit:"SJW_2", Action:"Upgrade", ActionCompleted:false},
                {Unit:"SJW_3", Action:"Upgrade", ActionCompleted:false},

                {Unit:"Rengoku_1", Action:"Placement", ActionCompleted:false},

                {Unit:"Rengoku_1", Action:"Upgrade", ActionCompleted:false},
                {Unit:"Rengoku_1", Action:"Upgrade", ActionCompleted:false},
                {Unit:"Rengoku_1", Action:"Upgrade", ActionCompleted:false},
        ], UnitEventArray:[
            ]
    },
    "SandVillage", {SetupFunc:SandVillageSetUp,AutomationType:"Action",Units:StandardChallengeUnits,UnitMapWave:Map(),
        UnitMapAction:Map(
                ; Vogita
                "Vogita_1", {Slot:5, Pos:[523, 482], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
                "Vogita_2", {Slot:5, Pos:[582, 422], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
                "Vogita_3", {Slot:5, Pos:[87, 410], MovementFromSpawn:[], UnitData:[], IsPlaced:false},       
                "Vogita_4", {Slot:5, Pos:[19, 307], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
                "Rengoku_1", {Slot:1, Pos:[209, 408], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
                "SJW_1", {Slot:2, Pos:[80, 309], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
                "SJW_2", {Slot:2, Pos:[166, 324], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
                "SJW_3", {Slot:2, Pos:[141, 408], MovementFromSpawn:[], UnitData:[], IsPlaced:false}
        ), UnitActionArray:[
                {Unit:"Vogita_1", Action:"Placement", ActionCompleted:false},
                {Unit:"Vogita_2", Action:"Placement", ActionCompleted:false},
                {Unit:"Vogita_3", Action:"Placement", ActionCompleted:false},
                {Unit:"Vogita_4", Action:"Placement", ActionCompleted:false},
                {Unit:"Rengoku_1", Action:"Placement", ActionCompleted:false},
                {Unit:"SJW_1", Action:"Placement", ActionCompleted:false},
                {Unit:"SJW_2", Action:"Placement", ActionCompleted:false},
                {Unit:"SJW_3", Action:"Placement", ActionCompleted:false},
                {Unit:"Rengoku_1", Action:"Upgrade", ActionCompleted:false},
                {Unit:"Rengoku_1", Action:"Upgrade", ActionCompleted:false},

        ] , UnitEventArray:[
            ]
    },
    "DoubleDungeon", {
        SetupFunc:nothing,AutomationType:"Action",Units:StandardChallengeUnits,UnitMapWave:Map(
            "Unit_1", {
                Slot:2, 
                Pos:[288, 333], 
                UnitData:[
                    {Type:"Placement", Wave:3, ActionCompleted:false, Delay:13000},
                    {Type:"Upgrade", Wave:12, ActionCompleted:false},
                    {Type:"Upgrade", Wave:12, ActionCompleted:false},
                    {Type:"Upgrade", Wave:12, ActionCompleted:false},
                    {Type:"Upgrade", Wave:15, ActionCompleted:false}
                ], 
                MovementFromSpawn:[
                    {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
                ]
            },
            "Unit_2", {
                Slot:2, 
                Pos:[152, 192], 
                UnitData:[
                    {Type:"Placement", Wave:6, ActionCompleted:false},
                    {Type:"Upgrade", Wave:12, ActionCompleted:false},
                    {Type:"Upgrade", Wave:12, ActionCompleted:false},
                    {Type:"Upgrade", Wave:12, ActionCompleted:false},
                    {Type:"Upgrade", Wave:14, ActionCompleted:false},
                ], 
                MovementFromSpawn:[
                    {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
                ]
            },
            "Unit_3", {
                Slot:2, 
                Pos:[152, 262], 
                UnitData:[
                    {Type:"Placement", Wave:7, ActionCompleted:false},
                    {Type:"Upgrade", Wave:12, ActionCompleted:false},
                    {Type:"Upgrade", Wave:12, ActionCompleted:false},
                    {Type:"Upgrade", Wave:14, ActionCompleted:false},
                    {Type:"Upgrade", Wave:14, ActionCompleted:false}
                ], 
                MovementFromSpawn:[
                    {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
                ]
            },
            ;Sprintwagons which i dont need but money
            
            "Unit_4", {
                Slot:3, 
                Pos:[403, 221], 
                UnitData:[
                    {Type:"Placement", Wave:7, ActionCompleted:false},{Type:"Upgrade", Wave:8, ActionCompleted:false},{Type:"Upgrade", Wave:9, ActionCompleted:false}
                ], 
                MovementFromSpawn:[
                    {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
                ]
            },
            "Unit_5", {
                Slot:3, 
                Pos:[469, 363], 
                UnitData:[
                    {Type:"Placement", Wave:7, ActionCompleted:false},{Type:"Upgrade", Wave:8, ActionCompleted:false},{Type:"Upgrade", Wave:9, ActionCompleted:false}
                ], 
                MovementFromSpawn:[
                    {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
                ]
            },
            "Unit_6", {
                Slot:3, 
                Pos:[700, 157], 
                UnitData:[
                    {Type:"Placement", Wave:7, ActionCompleted:false},{Type:"Upgrade", Wave:8, ActionCompleted:false},{Type:"Upgrade", Wave:9, ActionCompleted:false}
                ], 
                MovementFromSpawn:[
                    {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
                ]
            },
            "Unit_7", {
                Slot:1, 
                Pos:[410, 144], 
                UnitData:[
                    {Type:"Placement", Wave:11, ActionCompleted:false},
                    {Type:"Target", Wave:11, ActionCompleted:false},
                    {Type:"Target", Wave:11, ActionCompleted:false}
                ], 
                MovementFromSpawn:[
                    {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
                ]
            }
        ), UnitMapAction:Map(
                ; Vogita
                "Vogita_1", {Slot:5, Pos:[243, 423], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
                "Vogita_2", {Slot:5, Pos:[322, 98], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
                "Vogita_3", {Slot:5, Pos:[405, 84], MovementFromSpawn:[], UnitData:[], IsPlaced:false},       
                "Vogita_4", {Slot:5, Pos:[524, 79], MovementFromSpawn:[], UnitData:[], IsPlaced:false}
        ), UnitActionArray:[
                {Unit:"Vogita_1", Action:"Placement", ActionCompleted:false},
                {Unit:"Vogita_2", Action:"Placement", ActionCompleted:false},
                {Unit:"Vogita_3", Action:"Placement", ActionCompleted:false},
                {Unit:"Vogita_4", Action:"Placement", ActionCompleted:false},
        ] , UnitEventArray:[
            ]
    }, "ShibuyaStation", {SetupFunc:nothing,AutomationType:"Action",Units:StandardChallengeUnits,UnitMapWave:Map(),
        UnitMapAction:Map(
            ;Vegita
            "Vegita_1", {Slot:5, Pos:[412, 127], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
            "Vegita_2", {Slot:5, Pos:[486, 173], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
            "Vegita_3", {Slot:5, Pos:[408, 216], MovementFromSpawn:[], UnitData:[], IsPlaced:false},       
            
            ;Rengoku
            "Rengoku_1", {Slot:1, Pos:[327, 172], MovementFromSpawn:[], UnitData:[], IsPlaced:false}
        ), UnitActionArray:[
                {Unit:"Vegita_1", Action:"Placement", ActionCompleted:false},
                {Unit:"Vegita_2", Action:"Placement", ActionCompleted:false},
                {Unit:"Vegita_3", Action:"Placement", ActionCompleted:false},
                {Unit:"Rengoku_1", Action:"Placement", ActionCompleted:false},
                {Unit:"Rengoku_1", Action:"Target", ActionCompleted:false},
                {Unit:"Rengoku_1", Action:"Target", ActionCompleted:false},
        ] , UnitEventArray:[
            ]
    },
)
UnitList:=Map(
    "IgrisLegend",["Song Jinwu","Blade Dancer","Renguko","Takaroda","Sprintwagon"],
    "Rengoku",["Tengon","Blossom","Haruka Rin","SprintWagon","Takaroda"]
)
nothing(*){
    TeleportToSpawn()
    Sleep 500
    PM_ClickPos("SettingsX")
    Sleep 100    
    return
}
NamekSetUp(*){
    TeleportToSpawn()
    Sleep 500
    PM_ClickPos("SettingsX")
    Sleep 100
    RouteUser("r:[0%W1500&1600%A3000&4700%S1900]")
}
SandVillageSetUp(*){
    TeleportToSpawn()
    Sleep 500
    PM_ClickPos("SettingsX")
    Sleep 100
    RouteUser("r:[0%V10]")
    Sleep 1000
    RouteUser("r:[0%A1000]")
}
IgrisSetUp(*){
    SaveToDebug("Began Igris setup")
    OpenSettings(GetUIScale())
    if EvilSearch(PixelSearchTables["SettingsX"])[1]{
        Sleep 200
    } else{
        SetTo1Point5X()
    }
    Sleep 500
    PM_ClickPos("SettingsX")
    Sleep 500
    CloseChatUI()
    SaveToDebug("UIScale=1.5")
    PM_ClickPos("AreaButton")
    Sleep 500
    PM_ClickPos("Area_PlayButton")
    Sleep 400
    PM_ClickPos("AreaButtonX")
    Sleep(500)
    RouteUser("r:[0%W600&650%A600&1300%W4000]")
    SaveToDebug("We outside elevators")
    Sleep 100
    EquipUnits("nil",True,[True,1])
    Sleep 200
    SendEvent "{H Down}{H Up}"
    SaveToDebug("Equipped igris units")
    Sleep 500
    CloseChatUI()
    SetTo0Point9X()
    Sleep 1000
    if DisconnectedCheck(){
        freakingReconnectical()
    }   
    startTime:=A_TickCount
    Loop{
        if EvilSearch(PixelSearchTables["SettingsX"])[1]{
            SetTo0Point9X()
        } else{
            Break
        }
        if (A_TickCount-startTime)>30000{
            Break
        }  
        if DisconnectedCheck(){
            freakingReconnectical()
            return
        }           
    }
    startTime:=A_TickCount
    loop {
        SendEvent "{A Down}{Space Down}"
        Sleep 500
        Issue := 0
        loop {
            for _1, SearchName in ["0.9xConfirm", "0.9xLeave"] {
                if EvilSearch(PixelSearchTables[SearchName])[1] {
                    SaveToDebug("We found " SearchName)
                    Issue := _1
                    SendEvent "{A Up}{Space Up}"
                    break 2
                } else{
                    SaveToDebug("We didnt find " SearchName)
                    PM_ClickPos("0.9xLeave",0)
                    MouseMove 10, 10, 50, "R"                   
                }
                if (A_TickCount-startTime)>30000{
                    Break 2
                }
            }
            Sleep(10)
        }
        SaveToDebug( Issue)
        switch Issue {
            case 2:
                SendEvent "{Click, 622, 456, 1}"
                Sleep(5000)
                SaveToDebug("Retrying")
            case 1:
                SaveToDebug("Perfection")
                break
        }
        if (A_TickCount-startTime)>30000{
            Loop 5{
                SendEvent "{Click 470, 431, 0}"
                Sleep 200
                SendEvent "{Click 470, 431, 1}"
                Sleep 200
                SendEvent "{Click 730, 445, 0}"
                Sleep 200
                SendEvent "{Click 730, 445, 1}"                
                Sleep 200
            }
            IgrisSetUp()
            return
        }
    }

    Sleep(400)
    SendEvent "{Click, 	426, 275, 1}"
    Sleep(300)
    SendEvent "{Click 470, 496, 1}"
    Sleep 300
    SendEvent "{Click 231, 324, 1}"
    Sleep(300)
    SendEvent "{Click 422, 377, 1}"
    Sleep(500)
    PM_ClickPos("0.9xConfirm")
    Loop 5{
        SendEvent "{Click 375, 441, 1}"
    }
    Sleep(500)
    Loop 5{
        SendEvent "{Click, 584, 481, 1}"
    }
    Sleep(4000)
    SaveToDebug("We have pressed play")
    loop {
        SendEvent "{Click, 24, 616, 1}"
        Sleep(500)

        if PixelSearch(&u, &u, 545, 166, 579, 197, 0xD43335, 2) {
            ; Setting Middle
            Sleep(100)

            SendEvent "{Click, 409, 202, 1}"
            Sleep(100)
            SaveToDebug("TP finished so we setting UIScale to 1.5x again")
            SetTo1Point5X()
            Sleep(200)
            PM_ClickPos("SettingsX")
            Sleep 4000
            break
        }
        if DisconnectedCheck(){
            freakingReconnectical()
            return
        }           
    }
}
DoIgrisRuns(*){
    ;MsgBox "Igris function is currently broken due to the new Roblox UI, Bloxstrap nolonger changes the UI and losing 1 round so the wave bar falls down is too inefficient"
    global NumWins
    Sleep 1000
    CameraticView()
    Sleep(5000)
    SaveToDebug("Done CameraticView()")
    if EvilSearch(PixelSearchTables["AutoStart"])[1] {
        PM_ClickPos("AutoStart")
        Sleep(200)
    }
    SaveToDebug("Round has started")
    global UnitMap := IgrisData.UnitMap
    /*Map(
        ; SJW 403, 221
        "Unit_1", {Slot:1, Pos:[152, 150], MovementFromSpawn:[{Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}], UnitData:[], IsPlaced:false},
        "Unit_2", {Slot:1, Pos:[152, 192], MovementFromSpawn:[{Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}], UnitData:[], IsPlaced:false},
        "Unit_3", {Slot:1, Pos:[152, 262], MovementFromSpawn:[{Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}], UnitData:[], IsPlaced:false},

        ; Speedwagon
        "Unit_4", {Slot:5, Pos:[403, 241], MovementFromSpawn:[{Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}], UnitData:[], IsPlaced:false},
        "Unit_5", {Slot:5, Pos:[403, 383], MovementFromSpawn:[{Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}], UnitData:[], IsPlaced:false},
        "Unit_6", {Slot:5, Pos:[403, 177], MovementFromSpawn:[{Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}], UnitData:[], IsPlaced:false},
    )
    */
    global UnitActionArray := IgrisData.UnitActionArray
    /*[

        ; SJW
        {Unit:"Unit_1", Action:"Placement", ActionCompleted:false},
        {Unit:"Unit_2", Action:"Placement", ActionCompleted:false},
        {Unit:"Unit_3", Action:"Placement", ActionCompleted:false},

        ;Speedwagon
        {Unit:"Unit_4", Action:"Placement", ActionCompleted:false},
        {Unit:"Unit_5", Action:"Placement", ActionCompleted:false},
        {Unit:"Unit_6", Action:"Placement", ActionCompleted:false},

        ; 4 x 1 Upgrade
        {Unit:"Unit_4", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Unit_5", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Unit_6", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Unit_4", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Unit_5", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Unit_6", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Unit_4", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Unit_5", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Unit_6", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Unit_4", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Unit_5", Action:"Upgrade", ActionCompleted:false},
        {Unit:"Unit_6", Action:"Upgrade", ActionCompleted:false},
    ]

    ; SJW upgrade but im too lazy to add them into the map :tear:
    loop 4 {
        UnitActionArray.Push({Unit:"Unit_1", Action:"Upgrade", ActionCompleted:false})
        UnitActionArray.Push({Unit:"Unit_2", Action:"Upgrade", ActionCompleted:false})
        UnitActionArray.Push({Unit:"Unit_3", Action:"Upgrade", ActionCompleted:false})
    }
    */
    loop {
        OpenSettings(GetUIScale())
        Sleep 500
        PM_ClickPos("SettingsX")
        Sleep 500
        TeleportToSpawn()
        SaveToDebug("We have tp'ed to spawn")
        Sleep(2000)
        PM_ClickPos("SettingsX")
        WaveSetDetection(10)

        SaveToDebug("Abt to start automating igris")
        SendEvent "{A Down}"
        Sleep 200
        SendEvent "{S Down}"
        Sleep 400
        SendEvent "{S Up}"
        Sleep 100
        SendEvent "{A Up}"
        if DisconnectedCheck(){
            freakingReconnectical()
            return
        }
        ReturnedArray_1 := EnableActionAutomation(ActionAutomationSettings)
        ActionAutomationSettings["PreviousCompletedActions"] := 0
        ResetActions()
        Sleep(300)
        StartTime:=A_TickCount
        Loop{
            WaveSetDetection(10)
            WaveNumber:=WaveDetection(1,14,1)
            if DetectEndRoundUI(){
                Break
            }
            if WaveNumber>14{
                Break
            } else if (A_TickCount-StartTime)>120000{
                Break
            }
            SendEvent "{Click 402, 146, 1}"
            Sleep 100
            SendEvent "{Click 392, 146, 1}"
            if DisconnectedCheck(){
                freakingReconnectical()
                return
            }
        }
        if not DetectEndRoundUI() {
            SaveToDebug("We are gonna do the statues")
            OpenSettings("1.5")
            Sleep 500
            PM_ClickPos("SettingsX")
            Sleep 500
            TeleportToSpawn()
            Sleep(500)
            RouteStatues(1)
            Sleep(500)
            RouteStatues(2)
            Sleep(500)
            RouteStatues(3)
            Sleep(500)
            RouteStatues(4)
        }
        loop {
            if DisconnectedCheck(){
                freakingReconnectical()
                return
            }
            if DetectEndRoundUI() {
                SaveToDebug("Round is joever")

                break
            }
    
            SendEvent "{Click,416, 156, 1}"
            Sleep(100)
        }
        Sleep(1000)
        successful:= PixelSearch(&u,&u2,227, 207,344, 214,0xEEB800,10)
        LostRun:=0
        if successful{
            SaveToDebug("We beat the igris level")

            NumWins++
            x:=SendDiscordMessage([0,0,"win"],0,15454506)
            LostRun:=0
        } else{
            SaveToDebug("We lost the igris level")
            x:=SendDiscordMessage([0,0,"lose"],0) ; "23520942")
            LostRun:=1        
        }
        If IShouldDoTheChallenge(){
            SaveToDebug("We done igris and now we gonna lobby and do challenge")
            PressLobby()
            startTime:=A_TickCount
            loop {
                if DisconnectedCheck(){
                    freakingReconnectical()
                    return
                }   
                SendEvent "{Click, 24, 616, 1}"
                SendEvent "{Click 622, 455,2}"
                if Mod(A_Index,2)=0{
                    SendEvent "{Tab Down}{Tab Up}"
                }
                Sleep(500)

                if PixelSearch(&u, &u, 636, 60 , 666, 90 , 0xD43335, 2) {
                    PM_ClickPos("SettingsX")
                    return
                }
                if A_TickCount-startTime>60000{
                    return
                }
                SaveToDebug("TP to lobby not finished")
            }
        } else if LostRun{
            SaveToDebug("We lost against igris and now we gonna lobby incase camera messed up")
            PressLobby()
            startTime:=A_TickCount
            loop {
                if DisconnectedCheck(){
                    freakingReconnectical()
                    break
                }   
                SendEvent "{Click, 24, 616, 1}"
                SendEvent "{Click 622, 455,2}"
                if Mod(A_Index,2)=0{
                    SendEvent "{Tab Down}{Tab Up}"
                }
                Sleep(500)

                if PixelSearch(&u, &u, 636, 60 , 666, 90 , 0xD43335, 2) {
                    PM_ClickPos("SettingsX")
                    IgrisSetUp()
                    DoIgrisRuns()
                    return
                }
                if A_TickCount-startTime>60000{
                    return
                }
                SaveToDebug("TP to lobby not finished")
            }
            IgrisSetUp()
            DoIgrisRuns()
            return
        }

        Sleep(1000)
        PM_ClickPos("RetryButton", 1)
        ResetActions()
        BlowUpAndDieChallengeMrBeastV2 := [false,0,false]
    }
}
EquipUnits(key,DoingChallenge:=False,UsingTeams:=[False,0]){
    SendEvent "{H Down}{H Up}"
    if not UsingTeams[1]{
        Sleep 200
        PM_ClickPos("UnequipUnits")
        if not DoingChallenge{
            for unit in UnitList[key]{
                Sleep 100
                PM_ClickPos("SearchUnitBar")
                Sleep 500
                SendText unit
                Sleep 200
                SendEvent "{Click 123, 276, 1}"
                Sleep 400
                SendEvent "{Click 233, 299, 1}"
            }
        } else{
            for unit in ChallengeMaps[key].Units{
                Sleep 100
                PM_ClickPos("SearchUnitBar")
                Sleep 500
                SendText unit
                Sleep 200
                SendEvent "{Click 123, 276, 1}"
                Sleep 400
                SendEvent "{Click 233, 299, 1}"
            }
        }
    } else{
        if UsingTeams[2]>2{
            throw ValueError("UsingTeams[2] (the team to use) cannot be greater than two","EquipUnits",UsingTeams[2])
        }
        Sleep 200
        PM_ClickPos("UnitTeamsButton")
        Sleep 500
        SendEvent "{Click 687, " 231+(130*UsingTeams[2]) ", 0}"
        Sleep 100
        SendEvent "{Click 685, " 231+(130*UsingTeams[2]) ", 2}"
    }

}
DoChallenge(count:=0){
    global CurrentChallenge
    Sleep 200
    EquipUnits("nil",True,[True,0])
    SaveToDebug("Equipped all challenge units")
    Sleep 1000
    SendEvent "{H Down}{H Up}"
    SetPixelSearchLoop("StoreCheck",6000,1)
    CloseChatUI()
    PM_ClickPos("AreaButton")
    Sleep 500
    startTime:=A_TickCount
    if DisconnectedCheck(){
        freakingReconnectical()
        DoChallenge()
        return
    }       
    Loop{
        if PixelSearch(&u,&u2,563, 222,585, 243,0xBD2426 ,10){
            Break
        }
        if (A_TickCount-startTime)>30000{
            Break
        }   
    }
    PM_ClickPos("Area_ChallengeButton")
    Sleep 300
    PM_ClickPos("AreaButtonX")
    Sleep(1000)
    CloseChatUI()
    RouteUser("r:[0%W500&600%D500&1200%W1700&2600%D2000]")
    SaveToDebug("We are in the challenge elevator")
    Sleep 200
    global OCRObject2 := {
        X:326, Y:111, W:686-326, H:157-111, Size:2
    }
    result:=OCR.FromWindow("ahk_exe RobloxPlayerBeta.exe",,2,OCRObject2, 0)
    global OCRObject3 := {
        X:482, Y:153, W:622-488, H:178-153, Size:2
    }
    If RegExMatch(result.Text,"i)doub|double|dung|ngeon|geon"){
        CurrentChallenge:="DoubleDungeon"
    } else if RegExMatch(result.Text,"i)plane|lanet|name|amek"){
        CurrentChallenge:="PlanetNamek"
    } else if RegExMatch(result.Text,"i)sand|vill|illa|lage"){
        CurrentChallenge:="SandVillage"
    }  else if RegExMatch(result.Text,"i)shib|buy|uya|stat|tati|ation"){
        CurrentChallenge:="ShibuyaStation"
    }else{
        Sleep 200
        SendEvent "{Click 683, 533, 2}"
        Sleep 200
        SendEvent "{Click 673, 533, 2}"
        SaveToDebug("The challenge was unknown/" result.Text " so we don't do the challenge")
        SendEvent "{A Down}"
        Sleep 400
        SendEvent "{A Up}"
        Return
    }
    SaveToDebug("The challenge was " result.Text "/ " CurrentChallenge "so we do do the challenge")
    SendEvent "{Click 437, 517,2}"
    SaveToDebug("We pressed play!")
    loop {
        SendEvent "{Click, 24, 616, 1}"
        if Mod(A_Index,2)=0{
            SendEvent "{Tab Down}{Tab Up}"
        }
        Sleep(500)
        SaveToDebug("Waiting for the SettingX button to be visible")
        if PixelSearch(&u, &u, 636, 60 , 666, 90 , 0xD43335, 2) {
            PM_ClickPos("SettingsX")
            break
        }
        if DisconnectedCheck(){
            freakingReconnectical()
            DoChallenge()
            Return
        }           
    }
    Sleep 5000
    CameraticView()
    Sleep 2000
    SaveToDebug("SettingX button was visible, we are now setting up the challenge stuff")
    ChallengeMaps[CurrentChallenge].SetupFunc()
    if EvilSearch(PixelSearchTables["AutoStart"])[1] {
        PM_ClickPos("AutoStart")
        Sleep(200)
    }
    Sleep(500)
    WaveSetDetection(5)
    global UnitMap:=ChallengeMaps[CurrentChallenge].UnitMapWave
    SaveToDebug("Wave automation is abt to be enabled")
    
    Switch ChallengeMaps[CurrentChallenge].AutomationType{
        Case "Wave":
            EnableWaveAutomation(WaveAutomationSettings)
        
        Case "Action":
            global UnitMap:=ChallengeMaps[CurrentChallenge].UnitMapAction
            global UnitActionArray:=ChallengeMaps[CurrentChallenge].UnitActionArray
            EnableActionAutomation(ActionAutomationSettings)
        
        default:
            EnableWaveAutomation(WaveAutomationSettings)        
    }
    ResetActions()
    Loop{
        if DetectEndRoundUI(){
            ResetActions()
            SaveToDebug("Round ended")
            successful:= PixelSearch(&u,&u2,227, 207,344, 214,0xEEB800,10)
            if successful{
                SaveToDebug("We beat the challenge")
                SendDiscordMessage([0,0,"ChallengeW"],0,15454506)
                global TimeLastChallengeDone:=StrSplit(FormatTime(,"Time"),":")
                PressLobby()
                SaveToDebug("Lobbying")
                Sleep 2000
                loop {
                    SaveToDebug("Waiting for lobby teleport to finish")
                    SendEvent "{Click, 24, 616, 1}"
                    if Mod(A_Index,2)=0{
                        SendEvent "{Tab Down}{Tab Up}"
                    }
                    Sleep(500)

                    if PixelSearch(&u, &u, 636, 60 , 666, 90 , 0xD43335, 2) {
                        PM_ClickPos("SettingsX")
                        break 2
                    }
                    if DisconnectedCheck(){
                        freakingReconnectical()
                        Break
                    }                       
                }            
            } else{
                PressLobby()
                SendDiscordMessage([0,0,"ChallengeL"],0)
                SaveToDebug("Lobbying")
                Sleep 2000
                loop {
                    SaveToDebug("Waiting for lobby teleport to finish" )           
                    SendEvent "{Click, 24, 616, 1}"
                    if Mod(A_Index,2)=0{
                        SendEvent "{Tab Down}{Tab Up}"
                    }
                    Sleep(500)

                    if PixelSearch(&u, &u, 636, 60 , 666, 90 , 0xD43335, 2) {
                        PM_ClickPos("SettingsX")
                        break 
                    }
                    if DisconnectedCheck(){
                        freakingReconnectical()
                    }      
                }
                if count>5{
                    SaveToDebug("We have failed way too many times, so we just stop doing challebnges")
                    Return
                }
                SaveToDebug("WE TRY AGAINNNN")
                DoChallenge(count+1)
                Return
            }
        }
        SendEvent "{Click 471, 146, 1}"
        if DisconnectedCheck(){
            freakingReconnectical()
            Break
        }           
    }   
}
IShouldDoTheChallenge(){
    global TimeLastChallengeDone
    Time:=StrSplit(FormatTime(,"Time"),":") ;17:54
    SaveToDebug("The time of last challenge is: " TimeLastChallengeDone[1] ":" TimeLastChallengeDone[2] "`n The current time is: " FormatTime(,"Time"))

    ; Check if the hour has advanced
    if (integer(Time[1]) > integer(TimeLastChallengeDone[1])) {
        SaveToDebug("We should do the challenge")
        return (True)
    }
    ; Check if we've crossed a reset point within the same hour
    else if (integer(Time[1]) == integer(TimeLastChallengeDone[1]) && ((integer(TimeLastChallengeDone[2]) < 30 && integer(Time[2]) >= 30) || (integer(TimeLastChallengeDone[2]) < 60 && integer(Time[2] < 30)))) {
        SaveToDebug("We should do the challenge")
        return(True)
    }
    ; Check if we've crossed midnight
    else if (integer(Time[1]) < integer(TimeLastChallengeDone[1])) {
        SaveToDebug("We should do the challenge")
        return(True)
    }
    else {
        SaveToDebug("We should NOT do the challenge")
        return(False)
    }

} 
ReturnedUIObject := CreateBaseUI(Map(
    "Main", {Title:"AV Challenge Mango", Video:"https://www.youtube.com/watch?v=dQw4w9WgXcQ", Description:"Basement did not make this mango so don't ping him about it, the user who made it was @NileShawarma`n`nF4 : Start`nF5 : Pause`nF7 : Reload`nF8 : Pause", Version:MacroVersion, DescY:"250", MacroName:"AVChallengeMango", IncludeFonts:true, MultiInstancing:false},
    "Settings", [
        {Map:Map("UnitMap", ChallengeMaps["PlanetNamek"].UnitMapAction, "UnitActionArray", ChallengeMaps["PlanetNamek"].UnitActionArray, "UnitEventArray", ChallengeMaps["PlanetNamek"].UnitEventArray), Name:"Namek Settings", Type:"UnitActionUI", SaveName:"NamekChallengeUnitSettings", IsAdvanced:false},
        {Map:Map("UnitMap", ChallengeMaps["SandVillage"].UnitMapAction, "UnitActionArray", ChallengeMaps["SandVillage"].UnitActionArray, "UnitEventArray", ChallengeMaps["SandVillage"].UnitEventArray), Name:"SandVillage Settings", Type:"UnitActionUI", SaveName:"SandVillageChallengeUnitSettings", IsAdvanced:false},
        {Map:Map("UnitMap", ChallengeMaps["DoubleDungeon"].UnitMapAction, "UnitActionArray", ChallengeMaps["DoubleDungeon"].UnitActionArray, "UnitEventArray", ChallengeMaps["DoubleDungeon"].UnitEventArray), Name:"DoubleDungeon Settings", Type:"UnitActionUI", SaveName:"DoubleDungeonChallengeUnitSettings", IsAdvanced:false},
        {Map:Map("UnitMap", ChallengeMaps["ShibuyaStation"].UnitMapAction, "UnitActionArray", ChallengeMaps["ShibuyaStation"].UnitActionArray, "UnitEventArray", ChallengeMaps["ShibuyaStation"].UnitEventArray), Name:"ShibuyaStation Settings", Type:"UnitActionUI", SaveName:"ShibuyaStationChallengeUnitSettings", IsAdvanced:false},
        {Map:Map("UnitMap", IgrisData.UnitMap, "UnitActionArray", IgrisData.UnitActionArray, "UnitEventArray", IgrisData.UnitEventArray), Name:"Igris Legend Settings", Type:"UnitActionUI", SaveName:"IgrisDataUnitSettings", IsAdvanced:false},
        {Map:PrivateServerMap, Name:"PrivateServerSettings", Type:"Text", SaveName:"PrivateServerSettings", IsAdvanced:false},
        ; {Map:ToggleMapValues, Name:"Toggle Settings", Type:"Toggle", SaveName:"ToggleSettings", IsAdvanced:false},
    ],
    "SettingsFolder", {Folder:A_MyDocuments "\MacroHubFiles\SavedSettings\", FolderName:"AV_CHALLENGE"}
))
EnableFunction() {
    global MacroEnabled

    if not MacroEnabled {
        MacroEnabled := true

        ReturnedUIObject.BaseUI.Hide()
        for _, UI in __HeldUIs["UID" ReturnedUIObject.UID] {
            try {
                UI.submit()
            }
        }
    }
}
ReturnedUIObject.BaseUI.Show()
ReturnedUIObject.BaseUI.OnEvent("Close", (*) => ExitApp())
ReturnedUIObject.EnableButton.OnEvent("Click", (*) => EnableFunction())
F2::{
    SaveToDebug("Test", IncludeTime := true, IncludeRunTime := true, IncludeOutputDebug := true)
    ;Msgbox PixelSearch(&u, &u, 545, 166, 579, 197, 0xD43335, 2)
}
F3::{
    Try {
        MsgBox sigma
    } Catch{
        MsgBox "uh oh"
    }
}
F4::{
    global MacroEnabled
    if not MacroEnabled{
        Return
    }
    try
        if not WinActive("ahk_exe RobloxPlayerBeta.exe"){
            if not WinExist("ahk_exe RobloxPlayerBeta.exe"){
                MsgBox "Bro did you even open roblox smh"
                RejoinRoblox()
            }
            else{
                WinActivate "ahk_exe RobloxPlayerBeta.exe"
                WinMove(,,816,638,"ahk_exe RobloxPlayerBeta.exe")
            }
        } else {
            WinActivate "ahk_exe RobloxPlayerBeta.exe"
            WinMove(,,816,638,"ahk_exe RobloxPlayerBeta.exe")
        }
        if GetUIScale()="0.9"{
            SetTo1Point5X()
        }
        OpenSettings()
        Sleep 500
        PM_ClickPos("SettingsX")
        CloseChatUI()
        Sleep 500
        if IShouldDoTheChallenge(){
            DoChallenge()
        } else{
            IgrisSetUp()
            DoIgrisRuns()
        }
        Loop{
            If A_Index=1{
                IgrisSetUp()
                DoIgrisRuns()
            }
            if IShouldDoTheChallenge(){
                DoChallenge()
            }
            IgrisSetUp()
            DoIgrisRuns()
        }
}
F5::{
    CurrentChallenge:="PlanetNamek"
    ChallengeMaps[CurrentChallenge].SetupFunc()
    if EvilSearch(PixelSearchTables["AutoStart"])[1] {
        PM_ClickPos("AutoSta4rt")
        Sleep(200)
    }
    Sleep(500)
    WaveSetDetection(5)
    global UnitMap:=ChallengeMaps[CurrentChallenge].UnitMapWave
    OutputDebug "Wave automation is abt to be enabled"
    
    Switch ChallengeMaps[CurrentChallenge].AutomationType{
        Case "Wave":
            EnableWaveAutomation(WaveAutomationSettings)
        
        Case "Action":
            global UnitMap:=ChallengeMaps[CurrentChallenge].UnitMapAction
            global UnitActionArray:=ChallengeMaps[CurrentChallenge].UnitActionArray
            EnableActionAutomation(ActionAutomationSettings)
        
        default:
            EnableWaveAutomation(WaveAutomationSettings)        
    }
}
F6::{
    Pause -1
}
F7::{
    Reload
}
F8::{
    ExitApp
}