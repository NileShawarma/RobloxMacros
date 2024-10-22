#Requires AutoHotkey v2.0

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SetMouseDelay -1
global currentVersion := "V1.0.0"
global PlayerPositionFromSpawn := {W:0, A:0, S:0, D:0}
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
    "SecondaryOCR", false,
    "WaveDebug", true,
)
global NumberValueMap := Map(
    "SlotForStatues", 2,
)
global MacroSetup:= false
wbhurl := "https://discord.com/api/webhooks/1296525687548805142/pMEbZY6TEZKtLXa7tVjHYpy7up08wFsUZtbvF0yRrhw3BeoZiULyqE2qJns3cqmayqpN"
UserID := "0"
Colours:="5814783"

global WebhookMap := Map(
    "UseWebhook", True,
    "WebhookUrl" , wbhurl,
    "DiscordID" , UserID,
    "NeverPing", false,
    "Debug-PleaseKeepOn",True
)
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
            msg:="Macro has beaten the Igris stage!"
        } else{
        imgUrl:="https://th.bing.com/th/id/R.d01747c4285afa4e7a6e8656c9cd60cb?rik=v%2foc2vlIBefSSg&riu=http%3a%2f%2fwww.pngall.com%2fwp-content%2fuploads%2f2016%2f04%2fRed-Cross-Mark-Download-PNG.png&ehk=1xMEvznEaNHVbET9YIpmMmyW6jicnqxDYiBbIMGmq4w%3d&risl=&pid=ImgRaw&r=0"
        Title:="Macro Lost"
        msg:="Macro did not beat the Igris stage."
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
                "description": "' msg ' \n Macro has won ' NumWins ' times",
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
            OutputDebug "Chat has been closed, " (points/LoopNumber)*100 "% Accuracy"
        } else{
            OutputDebug "Chat is likely already closed, " (points/LoopNumber)*100 "% Accuracy"
        }    
        Sleep 500    
    }

}
OpenSettings(UIScales:="1.5"){
    OutputDebug "UIScale is " UIScales " and we are opening settings based on that"
    if "1.5" = UIScales{
        Loop{
            SendEvent "{Click, 24, 616, 1}"
            Sleep 500
            if EvilSearch(PixelSearchTables["SettingsX"])[1]{
                Break
            } else{
                if mod(A_Index,2)=0{
                    SendEvent "{Tab down}{Tab up}"
                    Sleep 100
                }
            }
        }       
    } 
    if "0.9" = UIScales{
        Loop{
            SendEvent "{Click, 24, 616, 1}"
            Sleep 500
            if EvilSearch(PixelSearchTables["SettingsX0.9"])[1]{
                Break
            }
        }         
    }


}
SetTo0Point9X() {
    OpenSettings(GetUIScale())
    OutputDebug "Settings are open"
    Sleep(400)
    PM_ClickPos("SettingMiddle")
    Sleep(300)

    loop 15 {
        SendEvent "{WheelDown}"
        Sleep(10)
    }

    Sleep(100)
    SendEvent "{Click, 429, 557, 1}"
    Sleep(760)
    OutputDebug "UIScale has been set to 0.9s"
    ; Settings X
    SendEvent "{Click, 563, 178, 0}"
    Sleep(15)
    SendEvent "{Click, 563, 178, 1}"
    Sleep(100)
}

SetTo1Point5X() {
    ; Settings
    OpenSettings(GetUIScale())
    OutputDebug "Settings are open"
    Sleep(450)
    ; Setting Middle
    SendEvent "{Click, 409, 202, 1}"
    Sleep(100)

    loop 15 {
        SendEvent "{WheelDown}"
        Sleep(10)
    }

    Sleep(100)
    ; UISCALE 1.5
    SendEvent "{Click, 514, 465, 1}"
    Sleep(1000)
    PM_ClickPos("SettingsX")
}
GetUIScale(){
    OutputDebug "Obtaining UI Scale"
    Loop{
        SendEvent "{Click, 24, 616, 1}"
        Sleep 500
        if EvilSearch(PixelSearchTables["SettingsX"])[1]{
            PM_ClickPos("SettingsX")
            return "1.5"
        } else if EvilSearch(PixelSearchTables["SettingsX0.9"])[1]{
            PM_ClickPos("SettingsX0.9")
            return "0.9"
        } else{
            if mod(A_Index,2)=0{
                SendEvent "{Tab down}{Tab up}"
                Sleep 100
            }
        }
    }      
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
    TpToSpawn()
}

Reconnection() {
    if not ToggleMapValues["Auto-Reconnect"] {
        return false
    }

    if ReconnecticalNightmares() {
        Sleep(400)
        PM_ClickPos("LegendStagesButton_Select")
        Sleep(400)
        PM_ClickPos("Dungeon_2_Select")
        Sleep(400)
        PM_ClickPos("Act3_Igros_Select")
        Sleep(400)
        PM_ClickPos("ConfirmButton")
        Sleep(600)
        PM_ClickPos("QueueStartButton")
        SetPixelSearchLoop("AutoStart", 90000, 1)
        SendEvent "{Tab Down}{Tab Up}"
        Sleep(200)
        PM_ClickPos("AutoStart")
        Sleep(200)
        return true
    }

    return false

}
UpdatePositions(){
    PositionMap["UnequipUnits"]:={Position:[361, 180]}
    PositionMap["SearchUnitBar"]:={Position:[151, 182]}
    PositionMap["Area_ChallengeButton"]:={Position:[375, 300]}
    PositionMap["0.9xConfirm"]:={Position:[358, 434]}

    PositionMap["SettingsX0.9"]:={Position:[561, 180]}
    PositionMap["SettingsX0.9TL"]:={Position:[545,166]}
    PositionMap["SettingsX0.9TL"]:={Position:[579,197]}
    
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

    for _,CreationArray in ____PSCreationMap{
        ____CreatePSInstance(CreationArray)
    }
}
UpdatePositions()

StandardChallengeUnits:=["Renguko","Song Jinwu","SprintWagon","Takaroda","Alligator","Blade Dancer"]
ChallengeMaps:=Map(
    "PlanetNamek", {
        SetupFunc:NamekSetUp,Units:StandardChallengeUnits,UnitMap:Map(
        "Unit_1", { ;Speedwagon
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
        "Unit_2", { ;Speedwagon
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
        "Unit_3", { ;Speedwagon
            Slot:3,
            Pos:[319, 476],
            UnitData:[
                {Type:"Placement",Wave:3,ActionCompleted:False},
                {Type:"Upgrade",Wave:6,ActionCompleted:False},
                {Type:"Upgrade",Wave:8,ActionCompleted:False},
            ],
            MovementFromSpawn:[]
        },
        "Unit_4", { ;SJW
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
        "Unit_5", { ;SJW
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
        "Unit_6", { ;SJW
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
        "Unit_7", { ;Rengoku
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
    )
    },
    "SandVillage", {Units:StandardChallengeUnits},
    "DoubleDungeon", {SetupFunc:nothing,Units:StandardChallengeUnits,UnitMap:Map(
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
    )}
)
UnitList:=Map(
    "IgrisLegend",["Song Jinwu","Blade Dancer","Renguko","Takaroda","Sprintwagon"],
    "Rengoku",["Tengon","Blossom","Haruka Rin","SprintWagon","Takaroda"]
)
nothing(*){
    return
}
NamekSetUp(*){
    TpToSpawn()
    Sleep 500
    RouteUser("r:[0%W1500&1600%A3000&4700%S1900]")
}
IgrisSetUp(*){
    OutputDebug "Began Igris setup"
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
    OutputDebug "UIScale=1.5"
    PM_ClickPos("AreaButton")
    Sleep 500
    PM_ClickPos("Area_PlayButton")
    Sleep 400
    PM_ClickPos("AreaButtonX")
    Sleep(500)
    RouteUser("r:[0%W600&650%A600&1300%W4000]")
    OutputDebug "We outside elevators"
    Sleep 100
    EquipUnits("IgrisLegend")
    Sleep 200
    SendEvent "{H Down}{H Up}"
    OutputDebug "Equipped igris units"
    Sleep 500
    CloseChatUI()
    SetTo0Point9X()
    Sleep 1000
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
    }
    startTime:=A_TickCount
    loop {
        OutputDebug "Some fucking witchcraft or something idek, think this makes sure we in queue"
        SendEvent "{A Down}{Space Down}"

        Issue := 0
        loop {
            for _1, SearchName in ["0.9xConfirm", "0.9xLeave"] {
                if EvilSearch(PixelSearchTables[SearchName])[1] {
                    OutputDebug "We found " SearchName
                    Issue := _1
                    SendEvent "{A Up}{Space Up}"
                    break 2
                } else{
                    OutputDebug "We didnt find " SearchName
                    PM_ClickPos("0.9xLeave",0)
                    MouseMove 10, 10, 50, "R"
                    if (A_TickCount-startTime)>30000{
                        Break 2
                    }                    
                }
            }
            Sleep(10)
        }
        OutputDebug Issue
        switch Issue {
            case 2:
                SendEvent "{Click, 622, 456, 1}"
                Sleep(5000)
                OutputDebug("Retrying")
            case 1:
                OutputDebug("Perfection")
                break
        }
        if (A_TickCount-startTime)>30000{
            Break
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
    Sleep(500)
    SendEvent "{Click, 584, 481, 1}"
    Sleep(4000)
    OutputDebug "We have pressed play"
    loop {
        SendEvent "{Click, 24, 616, 1}"
        Sleep(500)

        if PixelSearch(&u, &u, 545, 166, 579, 197, 0xD43335, 2) {
            ; Setting Middle
            Sleep(100)

            SendEvent "{Click, 409, 202, 1}"
            Sleep(100)
            OutputDebug "TP finished so we setting UIScale to 1.5x again"
            loop 15 {
                SendEvent "{WheelDown}"
                Sleep(10)
            }

            Sleep(100)
            ; UISCALE 1.5
            SendEvent "{Click, 514, 479, 1}"
            Sleep(200)
            OutputDebug "Enable tabinator"
            startTime:=A_TickCount
            Loop{
                If Mod(A_Index,2)=0{
                    SendEvent "{Tab Down}{Tab Up}"
                }
                if PixelSearch(&u, &u, 636, 75 , 666, 90 , 0xD43335, 2) {
                    PM_ClickPos("SettingsX")
                    break
                }
                If (A_TickCount-startTime)>30000{
                    PM_ClickPos("SettingsX")
                    Sleep 500
                    OpenSettings()
                    Sleep 500
                    PM_ClickPos("SettingsX")
                }
            }
            PM_ClickPos("SettingsX")
            break
        }
    }
}
DoIgrisRuns(*){
    global NumWins
    CameraticView()
    Sleep(200)
    OutputDebug "Done CameraticView()"
    if EvilSearch(PixelSearchTables["AutoStart"])[1] {
        PM_ClickPos("AutoStart")
        Sleep(200)
    }
    OutputDebug "Round has started"
    loop {
        if Reconnection() {
            continue
        }
        OpenSettings(GetUIScale())
        Sleep 500
        PM_ClickPos("SettingsX")
        Sleep 500
        TpToSpawn()
        OutputDebug "We have tp'ed to spawn"
        Sleep(2000)
        WaveSetDetection(10)
        global UnitMap:=Map(
                ;Song Jinwu's
                "Unit_1", {
                    Slot:1, 
                    Pos:[152, 150], 
                    UnitData:[
                        {Type:"Placement", Wave:4, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false}
                    ], 
                    MovementFromSpawn:[
                        {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
                    ]
                },
                "Unit_2", {
                    Slot:1, 
                    Pos:[152, 192], 
                    UnitData:[
                        {Type:"Placement", Wave:5, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false},{Type:"Upgrade", Wave:14, ActionCompleted:false}
                    ], 
                    MovementFromSpawn:[
                        {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
                    ]
                },
                "Unit_3", {
                    Slot:1, 
                    Pos:[152, 262], 
                    UnitData:[
                        {Type:"Placement", Wave:6, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false},{Type:"Upgrade", Wave:14, ActionCompleted:false},{Type:"Upgrade", Wave:14, ActionCompleted:false}
                    ], 
                    MovementFromSpawn:[
                        {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
                    ]
                },
                ;Sprintwagons which i dont need but money
                
                "Unit_4", {
                    Slot:5, 
                    Pos:[403, 221], 
                    UnitData:[
                        {Type:"Placement", Wave:7, ActionCompleted:false},{Type:"Upgrade", Wave:8, ActionCompleted:false},{Type:"Upgrade", Wave:9, ActionCompleted:false}
                    ], 
                    MovementFromSpawn:[
                        {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
                    ]
                },
                "Unit_5", {
                    Slot:5, 
                    Pos:[469, 363], 
                    UnitData:[
                        {Type:"Placement", Wave:7, ActionCompleted:false},{Type:"Upgrade", Wave:8, ActionCompleted:false},{Type:"Upgrade", Wave:9, ActionCompleted:false}
                    ], 
                    MovementFromSpawn:[
                        {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
                    ]
                },
                "Unit_6", {
                    Slot:5, 
                    Pos:[432, 157], 
                    UnitData:[
                        {Type:"Placement", Wave:6, ActionCompleted:false},{Type:"Upgrade", Wave:8, ActionCompleted:false},{Type:"Upgrade", Wave:9, ActionCompleted:false}
                    ], 
                    MovementFromSpawn:[
                        {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
                    ]
                },
                "Unit_7", {
                Slot:3, 
                Pos:[410, 144], 
                UnitData:[
                    {Type:"Placement", Wave:15, ActionCompleted:false},
                ], 
                MovementFromSpawn:[
                    {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
                ]
            }
        )
        OutputDebug "Abt to start automating igris"
        EnableWaveAutomation([15], true, 1, 15,,true)
        if Reconnection() {
            ResetActions()
            continue
        }
        if not DetectEndRoundUI() {
            OutputDebug "We are gonna do the statues"
            OpenSettings(GetUIScale())
            Sleep 500
            PM_ClickPos("SettingsX")
            Sleep 500
            TpToSpawn()
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
            if DetectEndRoundUI() {
                OutputDebug "Round is joever"

                break
            }
    
            SendEvent "{Click,416, 156, 1}"
            Sleep(100)
        }
        Sleep(1000)
        successful:= PixelSearch(&u,&u2,227, 207,344, 214,0xEEB800,10)
        if successful{
            OutputDebug "We beat the igris level"

            NumWins++
            x:=SendDiscordMessage([0,0,"win"],0,15454506)
        } else{
            OutputDebug "We lost the igris level"
            x:=SendDiscordMessage([0,0,"lose"],0) ; "23520942")
        }
        If IShouldDoTheChallenge(){
            OutputDebug "We done igris and now we gonna lobby and do challenge"
            PressLobby()
            loop {
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
                OutputDebug "TP to lobby not finished"

            }
        }
        PM_ClickPos("RetryButton", 1)
        Sleep(1000)
        PM_ClickPos("VoteStartButton", 1)
        ResetActions()
    }
}
EquipUnits(key,DoingChallenge:=False){
    SendEvent "{H Down}{H Up}"
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
}
DoChallenge(count:=0){
    global CurrentChallenge
    EquipUnits("PlanetNamek",True)
    OutputDebug "Equipped all challenge units"
    Sleep 1000
    SendEvent "{H Down}{H Up}"
    SetPixelSearchLoop("StoreCheck",6000,1)

    PM_ClickPos("AreaButton")
    Sleep 500
    startTime:=A_TickCount
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
    RouteUser("r:[0%W500&600%D500&1200%W2200&3100%D2000]")
    OutputDebug "We are in the challenge elevator"
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
        Sleep 200
        SendEvent "{Click 683, 533, 2}"
        Sleep 200
        SendEvent "{Click 673, 533, 2}"
        OutputDebug "The challenge was Sand Village so we don't do the challenge"
        return
    } else{
        OutputDebug "The challenge was unknown so we don't do the challenge"
        Return
    }
    OutputDebug "The challenge was " result.Text "/ " CurrentChallenge "so we do do the challenge"
    SendEvent "{Click 437, 517,2}"
    OutputDebug "We pressed play!"
    loop {
        SendEvent "{Click, 24, 616, 1}"
        if Mod(A_Index,2)=0{
            SendEvent "{Tab Down}{Tab Up}"
        }
        Sleep(500)
        OutputDebug "Waiting for the SettingX button to be visible"
        if PixelSearch(&u, &u, 636, 60 , 666, 90 , 0xD43335, 2) {
            PM_ClickPos("SettingsX")
            break
        }
    }
    Sleep 1000
    OutputDebug "SettingX button was visible, we are now setting up the challenge stuff"
    ChallengeMaps[CurrentChallenge].SetupFunc()
    if EvilSearch(PixelSearchTables["AutoStart"])[1] {
        PM_ClickPos("AutoStart")
        Sleep(200)
    }
    Sleep 500
    OutputDebug "The challenge has started, and we will change camera view"
    CameraticView()
    Sleep(500)
    WaveSetDetection(5)
    global UnitMap:=ChallengeMaps[CurrentChallenge].UnitMap
    OutputDebug "Wave automation is abt to be enabled"
    EnableWaveAutomation([125], true, 20, 30, ToggleMapValues["WaveDebug"], true, true)
    Loop{
        if DetectEndRoundUI(){
            ResetActions()
            OutputDebug "Round ended"
            successful:= PixelSearch(&u,&u2,227, 207,344, 214,0xEEB800,10)
            if successful{
                OutputDebug "We beat the challenge"
                TimeLastChallengeDone:=StrSplit(FormatTime(,"Time"),":")
                PressLobby()
                OutputDebug "Lobbying"
                Sleep 2000
                loop {
                    OutputDebug "Waiting for lobby teleport to finish"
                    SendEvent "{Click, 24, 616, 1}"
                    if Mod(A_Index,2)=0{
                        SendEvent "{Tab Down}{Tab Up}"
                    }
                    Sleep(500)

                    if PixelSearch(&u, &u, 636, 60 , 666, 90 , 0xD43335, 2) {
                        PM_ClickPos("SettingsX")
                        break 2
                    }
                }            
            } else{
                PressLobby()
                OutputDebug "Lobbying"
                Sleep 2000
                loop {
                    OutputDebug "Waiting for lobby teleport to finish"            
                    SendEvent "{Click, 24, 616, 1}"
                    if Mod(A_Index,2)=0{
                        SendEvent "{Tab Down}{Tab Up}"
                    }
                    Sleep(500)

                    if PixelSearch(&u, &u, 636, 60 , 666, 90 , 0xD43335, 2) {
                        PM_ClickPos("SettingsX")
                        break 
                    }
                }
                if count>5{
                    OutputDebug "We have failed way too many times, so we just stop doing challebnges"
                    Return
                }
                OutputDebug "WE TRY AGAINNNN"
                DoChallenge(count+1)
                Return
            }
        }
        SendEvent "{Click 471, 146, 1}"
    }
    
}
IShouldDoTheChallenge(){
    global TimeLastChallengeDone
    Time:=StrSplit(FormatTime(,"Time"),":") ;17:54

    ; Check if the hour has advanced
    if (integer(Time[1]) > integer(TimeLastChallengeDone[1])) {
        OutputDebug "We should do the challenge"
        return (True)
    }
    ; Check if we've crossed a reset point within the same hour
    else if (integer(Time[1]) == integer(TimeLastChallengeDone[1]) && ((integer(TimeLastChallengeDone[2]) < 30 && integer(Time[2]) >= 30) || (integer(TimeLastChallengeDone[2]) < 60 && integer(Time[2] < 30)))) {
        OutputDebug "We should do the challenge"
        return(True)
    }
    ; Check if we've crossed midnight
    else if (integer(Time[1]) < integer(TimeLastChallengeDone[1])) {
        OutputDebug "We should do the challenge"
        return(True)
    }
    else {
        OutputDebug "We should NOT do the challenge"
        return(False)
    }

} 
F2::{
    CloseChatUI()
}
F3::{
    loop {
        OutputDebug "Some fucking witchcraft or something idek, think this makes sure we in queue"
        SendEvent "{A Down}{Space Down}"

        Issue := 0
        loop {
            for _1, SearchName in ["0.9xConfirm", "0.9xLeave"] {
                if EvilSearch(PixelSearchTables[SearchName])[1] {
                    OutputDebug "We found " SearchName
                    Issue := _1
                    SendEvent "{A Up}{Space Up}"
                    break 2
                } else{
                    OutputDebug "We didnt find " SearchName
                    PM_ClickPos("0.9xLeave",0)
                    MouseMove 10, 10, 50, "R"
                }
            }
            Sleep(10)
        }
        OutputDebug Issue
        switch Issue {
            case 2:
                SendEvent "{Click, 622, 456, 1}"
                Sleep(5000)
                OutputDebug("Retrying")
            case 1:
                OutputDebug("Perfection")
                break
        }
    }
}
F4::{
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
        DoChallenge()
        IgrisSetUp()
        DoIgrisRuns()
    }
}
F5::{
    loop {
        SendEvent "{Click, 24, 616, 1}"
        Sleep(500)

        if PixelSearch(&u, &u, 545, 166, 579, 197, 0xD43335, 2) {
            ; Setting Middle
            Sleep(100)

            SendEvent "{Click, 409, 202, 1}"
            Sleep(100)
            OutputDebug "TP finished so we setting UIScale to 1.5x again"
            loop 15 {
                SendEvent "{WheelDown}"
                Sleep(10)
            }

            Sleep(100)
            ; UISCALE 1.5
            SendEvent "{Click, 514, 479, 1}"
            Sleep(200)
            OutputDebug "Enable tabinator"
            Loop{
                If Mod(A_Index,2)=0{
                    SendEvent "{Tab Down}{Tab Up}"
                }
                if PixelSearch(&u, &u, 636, 75 , 666, 90 , 0xD43335, 2) {
                    PM_ClickPos("SettingsX")
                    break
                }
            }
            PM_ClickPos("SettingsX")
            break
        }
    }
}
F7::{
    Reload
}
F8::{
    Pause -1
}