;ttermpro.exe 119.160.130.97:22 /ssh /2 /auth=password /user=myname /passwd="Srcamlbe"
; Added backups session1 & sasession2. 2.5
; converted doubleclick to singleclick. 2.5
; Added password keeper transfers to clipboard when [Connect] is clicked. 2.5
; Added Help button and window 2.5
; Added full username & pasword save + Aouto-Login 3.0
; Added auto-Save at close If any records werrre deleted 3.0

Global NewList sessions.s()
Global rw.RECT
Global c, sessionsFolder$, ttl$, TeraTerm$, AppName.s, hWin.I, count
#ALL = 3900
Procedure ReallySetForegroundWindow(m_hWnd.I)
  ; http://www.drdobbs.com/184405755
  hOtherWnd.I = GetForegroundWindow_()
  ;
  ; get thread handles on our window and foreground window
  hMyThread.I = GetWindowThreadProcessId_(m_hWnd, 0)
  hOtherThread.I = GetWindowThreadProcessId_(hOtherWnd,0)
  ;
  ; attach our thread to foreground thread, take foreground, and detach threads
  AttachThreadInput_(hMyThread,hOtherThread, #True)
  SetForegroundWindow_(m_hWnd)
  AttachThreadInput_(hMyThread,hOtherThread, #False)
  ; AttachThreadInput_(hOtherThread,hMyThread, #True); backward set
  ; SetForegroundWindow_(m_hWnd)
  ; AttachThreadInput_(hOtherThread,hMyThread, #False)
  ;
  ; Now that our window "thread" has fisrt place in the queue...
  ; make sure our "window" is visible
  If IsIconic_(m_hWnd)
    ShowWindow_(m_hWnd,#SW_RESTORE)
  Else
    ShowWindow_(m_hWnd,#SW_SHOW)
  EndIf
  SetActiveWindow(GetDlgCtrlID_(m_hWnd))
  WaitWindowEvent()
  SetForegroundWindow_(m_hWnd)
EndProcedure 
Procedure Ping(IP$)
  url$="-n 1 "+IP$
  If InternetGetConnectedState_(0,0)=1 ; Only check further if modem is switched on.
    p=RunProgram("ping.exe",url$,"",#PB_Program_Hide|#PB_Program_Open|#PB_Program_Read)
    If p : While ProgramRunning(p) : o$+ReadProgramString(p) : Wend : CloseProgram(p) : EndIf
    If o$<>"" And FindString(o$,"(0% loss",1)>0 And FindString(o$,"Request timed out",1)=0 : Status=1 : EndIf
  EndIf
  ProcedureReturn Status
EndProcedure
Procedure ShowOrHidePass(StringGadget, activate = #True)
   Protected x,y,w,h,s.s
   x=GadgetX(StringGadget)
   y=GadgetY(StringGadget)
   w=GadgetWidth(StringGadget)
   h=GadgetHeight(StringGadget)
   s=GetGadgetText(StringGadget)
   FreeGadget(StringGadget)
   StringGadget(StringGadget,x,y,w,h,s,StringGadgetFlags)
   If activate: SetActiveGadget(StringGadget) :EndIf
   StringGadgetFlags ! #PB_String_Password
EndProcedure

Procedure TogglePasswordVisibility(StringGadgetID.I)
  Debug "YES, Hit PSWD Visibiliy"
  Static PasswordChar
  Static PasswordCharIsKnown
  
  If PasswordCharIsKnown = #False
    PasswordChar = SendMessage_(GadgetID(StringGadgetID),
                                #EM_GETPASSWORDCHAR, 0, 0)
    PasswordCharIsKnown = #True
  EndIf
  
  If GetWindowLongPtr_(GadgetID(StringGadgetID),
                       #GWL_STYLE) & #ES_PASSWORD
    SendMessage_(GadgetID(StringGadgetID), #EM_SETPASSWORDCHAR, 0, 0)
  Else
    SendMessage_(GadgetID(StringGadgetID), #EM_SETPASSWORDCHAR,
                 PasswordChar, 0)
  EndIf
  
  InvalidateRect_(GadgetID(StringGadgetID), 0, 1)
EndProcedure
Procedure.s crypt(crypt$)   ; output job$
  ;Top Secret encryption Has ben substitude with the following:
  job$ = ReverseString(crypt$)
    ProcedureReturn job$
EndProcedure
Procedure.s DeCrypt(job$)
  ;Top Secret encryption Has ben substitude with the following:
  DeCrypt$ = ReverseString(job$)
  ProcedureReturn DeCrypt$
EndProcedure

;######################################################################################
;              DO NOT ALLOW MORE THAN ONE INSTANCE
;######################################################################################
Procedure.l EnumWindows(WindowHandle.l, Parameter.l) 
  Title$ = Space(200)
  GetWindowText_(WindowHandle, @Title$, 200)
  If Left(Title$,12) = "SSH TeraTerm" ;FindString(Title$, AppName, 1, #PB_String_NoCase ) <> 0
    hWin.i = WindowHandle
    Debug title$
    ProcedureReturn #False
  Else 
    ;Debug "NO, NO Notepad"
    ProcedureReturn #True
  EndIf 
  
EndProcedure
AppName = "SSH TeraTerm" ;Session Manager 2.2 (SSHTTSM)"
EnumWindows_(@EnumWindows(), 0)
If hWin.i
  SetForegroundWindow_(hWin.i) ; and bring current instance into foreground.
  ShowWindow_(hWin.i, #SW_RESTORE)
  Delay(250)
  End ; Quit from this duplicate instance.
EndIf
;{- Enumerations / DataSections
;{ Windows
Enumeration
  #Window_0
  #Window_11
EndEnumeration
#KeyDelete = 1

;}
;{ Gadgets
Enumeration
  #ListView_0
  #NAME
  #PSWD
  #SWOWP
  #IPAddress
  #PORT
  #PING
  #UserName
  #User
  #SAVE
  #TITLE
  #ADDRESS
  #PORTno
  #USRPswdOK
  #SHOWpwd
  #PwdLBL
  #MacroLabel
  #SECRET
  #CONNECT
  #HELP
  #PickMacro
  #FOLDER
  #Text_1_11
  #Text_2_11
  #Text_3_11
  #Manual_11
  #More_11
EndEnumeration
;}
Define.l Event, EventWindow, EventGadget, EventType, EventMenu
If FileSize("C:\Program Files (x86)\teraterm5\ttermpro.exe") > 1
  TeraTerm$ = "C:\Program Files (x86)\teraterm5\ttermpro.exe"
  Debug "Exe Path: "+TeraTerm$+CRLF$
Else
  If FileSize("C:\Program Files\teraterm5\ttermpro.exe") > 1
    TeraTerm$ = "C:\Program Files\teraterm5\ttermpro.exe"
    Debug "Exe Path: "+TeraTerm$+CRLF$
  Else
    MessageRequester("BIG PROBLEM", "Cannot find ttermPro.exe Client Application.", #MB_OK|#MB_ICONWARNING|#MB_SYSTEMMODAL)
  EndIf
EndIf
;}
buffer$=Space(512)
s$=""
sessionsFolder$ = GetEnvironmentVariable("AppData")+ "\teraterm5\"
n = FindString(buffer$,"Roaming",#PB_String_NoCase)-1
Debug "sessionsFolder ="+sessionsFolder$
Global Sessions$ = sessionsFolder$+"Sessions"
Global Sessions1$ = sessionsFolder$+"Sessions1"
Global Sessions2$ = sessionsFolder$+"Sessions2"
NewList TTLs.s()
Procedure makebackups()
  Debug "Making BACKUPS"
  Debug "sessions$ = " + sessions$
  Debug "sessions2$ = " + sessions2$
  If FileSize(sessions2$) > 0
    DeleteFile(Sessions2$)
  EndIf
  RenameFile(Sessions1$,Sessions2$)
  Debug "sessions1$ = " + sessions1$
  If FileSize(sessions1$) > 0
    DeleteFile(Sessions1$)
  EndIf
  RenameFile(Sessions$,Sessions1$)
EndProcedure
Procedure Save()
  If CreateFile(0,Sessions$,#PB_Ascii)
    For n = 0 To count ; Loop thru entire list and save each kline in full.
      g$ = GetGadgetItemText(#ListView_0,n)
      ;                 If FindString(g$,Chr(9))
      ;                   g$ = StringField(g$,1,Chr(9))
      ;                 EndIf
      ;                 t$ = GetGadgetText(#NAME)
      ;                 If Left(g$,Len(t$)) = t$
      ;                   Debug "YEP WE SEE THIS ENTRY"
      ;                   g$ + Chr(9) + crypt(GetGadgetText(#SECRET))
      ;                 EndIf
      Debug g$
      WriteStringN(0,g$)
    Next n
    CloseFile(0)
  EndIf
EndProcedure
Procedure SortSessions()
  ;             For item = 0 To CountGadgetItems(#ListView_0)
  ;               SendMessage_(GadgetID(#ListView_0), #LB_ADDSTRING, 0, GetGadgetItemText(#ListView_0,0))
  ;               RemoveGadgetItem(#ListView_0,0)
  ;             Next
  count = CountGadgetItems(#ListView_0)
  If count
    Debug "we have items"
  Else
    Debug "No Items count"
  EndIf
  For n = 0 To count
    g$ = GetGadgetItemText(#ListView_0,n)
    If g$
      AddElement(sessions())
      sessions() = g$
    EndIf
  Next n
  SortList(Sessions(),#PB_Sort_Ascending)
  ClearGadgetItems(#ListView_0)
  ClearGadgetItems(#ListView_0)
  ClearGadgetItems(#ListView_0)
  If GetGadgetItemText(#ListView_0,0)+GetGadgetItemText(#ListView_0,1) = ""
    ForEach sessions()
      If Sessions()
        AddGadgetItem(#ListView_0,-1,sessions())
      EndIf
    Next
  Else
    Debug "Did not Clear List"
  EndIf
EndProcedure
Procedure Connect()
  ;-Connect
  s$ = ""
  x$ = sessionsFolder$+ttl$
  If GetGadgetState(#USRPswdOK)
    s$ + GetGadgetText(#SECRET)
  EndIf
  If FileSize(x$) = 0
    x$ = ""
  EndIf
;  p$ =GetGadgetText(#IPAddress)+":"+GetGadgetText(#PORT)+" /ssh /2 /auth=password /user="+GetGadgetText(#User)+" /passwd="+Chr(34)+GetGadgetText(#SECRET)+Chr(34)
  ;;ttermpro.exe 119.160.130.97:22 /ssh /2 /auth=password /user=myname /passwd="Srcamlbe"
  Debug x$
  title$ = Chr(34)+GetGadgetText(#NAME)+Chr(34)
  If s$ ;Password?
    Debug "HAVE IT"
    ;p$ = GetGadgetText(#IPAddress)+":"+GetGadgetText(#PORT) + " /m="+x$+" /w="+title$
    ;p$ = GetGadgetText(#IPAddress)+":"+GetGadgetText(#PORT) + " /F="+sessionsFolder$+"TERATERM.INI" + " /w="+title$
    p$ = GetGadgetText(#IPAddress)+":"+GetGadgetText(#PORT)+" /ssh /2 /auth=password /user="+GetGadgetText(#User)+" /passwd="+Chr(34)+GetGadgetText(#SECRET)+Chr(34)
  Else
    Debug "DONT HAVE IT"
    ;p$ = GetGadgetText(#IPAddress)+":"+GetGadgetText(#PORT)+" /w="+title$
    p$ = GetGadgetText(#IPAddress)+":"+GetGadgetText(#PORT)+" /ssh /2" ; /user="+GetGadgetText(#User)+" /passwd="+Chr(34)+GetGadgetText(#SECRET)+Chr(34)
  EndIf
  If x$
    p$ + " /m=" + x$
  EndIf
  ;p$ = GetGadgetText(#IPAddress)+":"+GetGadgetText(#PORT) + " /F="+sessionsFolder$+"TERATERM.INI /m="+sessionsFolder$+"tterm.ttl /w="+GetGadgetText(#NAME)
  ;p$ + " /F="+sessionsFolder$+"TERATERM.INI /m=" +x$ + " /w="+title$
  Debug p$
  Exe = RunProgram(TeraTerm$,p$,"",#PB_Program_Open|#PB_Program_Read)
EndProcedure
If ExamineDirectory(0, sessionsFolder$, "*.*")  
  While NextDirectoryEntry(0)
    If DirectoryEntryType(0) = #PB_DirectoryEntry_File
      file$ = DirectoryEntryName(0)
      If GetExtensionPart(file$) = "ttl"
        ttl+1
        AddElement(TTLs())
        TTLs() = DirectoryEntryName(0)
      EndIf
    EndIf
  Wend
  FinishDirectory(0)
  SortList(TTLs(),#PB_Sort_Ascending)
EndIf
fontAri8.i = LoadFont(#PB_Any,"Arial",8) 
fontAri12B.i = LoadFont(#PB_Any,"Arial",12,#PB_Font_Bold)
fontCur12B.i = LoadFont(#PB_Any,"Courier",12, #PB_Font_Bold)
fontAri8B.i = LoadFont(#PB_Any,"Arial",8,#PB_Font_Bold)
Dim m(10)
HWND11 = OpenWindow(#Window_11, 466, 203, 395, 284, "RightClick Help", #PB_Window_Invisible | #PB_Window_BorderLess) ; | $400000)
If HWND11
  SetGadgetFont(#PB_Default,FontID(fontAri8B.i))
  helpText11.W = EditorGadget(#Text_1_11, 0, 0, 94, 205,#PB_Editor_WordWrap)
  SetGadgetFont(#PB_Default,FontID(fontCur12B.i))
  SetGadgetFont(#PB_Default,FontID(fontAri8B.i))
  anyKey2xit11.W = TextGadget(#Text_3_11, -5,205, 403,23, "~  Press any key to close.  ~", #PB_Text_Center | #PB_Text_Border)
  SetGadgetFont(#PB_Default,FontID(fontAri8.i))
  manual11.W = ButtonGadget(#Manual_11, 15, 329, 55, 15, "Manual")
  more11.W = ButtonGadget(#More_11, 413, 329, 55, 15, "F1  More")
  SendMessage_(helpText11, #EM_SETTARGETDEVICE, #Null, 0) ; 0=wrap , 1up=linewidth , $FFFFFF(effectively)=wrapoff
  SendMessage_(helpText11, #EM_SETREADONLY, 1, 0) 
  SendMessage_(helpText11, #EM_SETBKGNDCOLOR, 0, RGB(250, 255, 175))
  HideGadget(#Manual_11, 1)
  HideGadget(#More_11, 1)
  SetWindowColor(#Window_11,0)
EndIf
;-WINDOW
fontVerd11.I = LoadFont(#PB_Default,"Verdana",09)
fontAri10B.I = LoadFont(#PB_Default,"Arial",10,#PB_Font_Bold)
If OpenWindow(#Window_0, 239, 132, 600, 337, "SSH TeraTerm Session Manager 3.1x64 (SSHTTSM)", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_TitleBar | #PB_Window_ScreenCentered)
  SetGadgetFont(#PB_Default,FontID(fontAri10B.I))
    ListViewGadget(#ListView_0, 10, 10, 285, 315)
    StringGadget(#NAME, 350, 5, 240, 32, "")
    IPAddressGadget(#IPAddress, 440, 35, 150, 28)
    StringGadget(#PORT, 515, 65, 70, 20, "22")
    StringGadget(#User, 385, 85, 200, 20, "hds", #PB_String_Password)
    StringGadget(#SECRET, 385, 105, 200, 20, "Secrets!!!", #PB_String_Password)
    ButtonGadget(#SAVE, 510, 155, 65, 25, "SAVE")
    TextGadget(#TITLE, 300, 13, 50, 20, "TITLE ", #PB_Text_Right)
    TextGadget(#ADDRESS, 355, 44, 80, 20, "ADDRESS ", #PB_Text_Right)
    TextGadget(#PORTno, 455, 65, 55, 20, "PORT# ", #PB_Text_Right)
    ButtonGadget(#CONNECT, 305, 305, 105, 25, "CONNECT")
    CheckBoxGadget(#USRPswdOK, 305, 125, 140, 20, "User/Pswd OK")
    CheckBoxGadget(#SHOWpwd, 465, 130, 140, 20, "Show Password")
    TextGadget(#PwdLBL, 310, 105, 75, 20, "Password")
    TextGadget(#MacroLabel, 330, 165, 135, 20,"Pick your Macro file.", #PB_Text_Right)
    ButtonGadget(#FOLDER, 450, 310, 140, 20, "Sessions Folder")
    ButtonGadget(#Help, 420, 310, 20, 20, " ? ")
    ButtonGadget(#PING, 295, 40, 65, 25, "ping")
    TextGadget(#UserName, 315, 85, 65, 20, "UserName")
    SetGadgetState(#USRPswdOK,1)
    SendMessage_(GadgetID(#ListView_0), #LB_SETHORIZONTALEXTENT,1000, #Null)
    y = 165
  ForEach TTLs()
    m+1
    y+20
    V = OptionGadget(#PB_Any,330,y,100,20,TTLs())
    m(m) = V
    If ttls() = "ttxterm.ttl"
      SetGadgetState(V,1)
    EndIf
    If m = 4
      Break
    EndIf
  Next
  y = 85
  n = m
  ForEach TTLs()
    m+1
    y+20
    If m > 8 And m < 13
      V = OptionGadget(#PB_Any,450,y,100,20,TTLs())
      m(n) = V
      n+1
      If ttls() = "ttxterm.ttl"
        SetGadgetState(V,1)
      EndIf
    EndIf
    If n = 4
      Break
    EndIf
  Next
EndIf
;SetGadgetState(m(1),1)
Debug "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
;-READFILE Sessions
If FileSize(Sessions$) > 0
  If ReadFile(0,Sessions$,#PB_Ascii)
    Repeat
      Item$ = ReadString(0)
      c+1
      Debug item$
      If 1;item$
        AddGadgetItem(#ListView_0,-1,Item$)
      EndIf
    Until Eof(0)
    CloseFile(0)
  EndIf
EndIf
;-Call for SORT
SortSessions()
SetActiveWindow(0)
count = CountGadgetItems(#ListView_0)
;- MAIN loop
Repeat
  Event = WaitWindowEvent()
    If GetActiveGadget() = #ListView_0
      AddKeyboardShortcut(0, #PB_Shortcut_Delete, #KeyDelete)
    Else
      RemoveKeyboardShortcut(0, #PB_Shortcut_Delete)
    EndIf
  Select GetActiveWindow()
    Case #Window_0
      HideWindow(#Window_11,1)
      If Event = #PB_Event_Menu And EventMenu() = #KeyDelete
        Debug "DELETE IT SAID!!!"
        i = GetGadgetState(#ListView_0)
        RemoveGadgetItem(#ListView_0, i)
        SetGadgetState(#ListView_0, i)
      EndIf
      Select Event
          ; ///////////////////
        Case #WM_CHAR
          key = EventwParam()
          Select key
            Case 13 ;Return
              g = GetActiveGadget()
              If g + #PSWD ;Save password into the Listings And into sessions()
                pswd$ = GetGadgetText(#SECRET)
                If pswd$ = ""
                  Sel$ = GetGadgetItemText(#ListView_0,GetGadgetState(#ListView_0),0) ;whole line from listbox
                Else
                  Sel$ = GetGadgetItemText(#ListView_0,GetGadgetState(#ListView_0),0)+Chr(9)+crypt(pswd$) ;whole line from listbox
                EndIf
                ; find matching item in listing
                count = CountGadgetItems(#ListView_0)
                For n = 0 To count
                  If FindString(GetGadgetItemText(#ListView_0,item,0),Sel$)
                    Break
                  EndIf
                Next n
                Debug n
                  Debug GetGadgetItemText(#ListView_0,n,0)
                  SelectElement(Sessions(),n)
;                  Debug Sessions()
                  If FindString(Sel$,Chr(9))
                  Else
                  EndIf
                item = GetGadgetState(#ListView_0)
;                   SelectElement(Sessions(),item)
;                 Debug Sessions()
                Sel$ = GetGadgetItemText(#ListView_0,item,0) ;whole line from listbox
                If FindString(Sel$,Chr(9))
                  p$ = Decrypt(StringField( Sel$,2, Chr(9) ) )
                  Debug p$
                  SetGadgetText(#SECRET,p$)
                  Sel$ = StringField(Sel$,1,Chr(9))
                EndIf
                Debug sel$
                  Debug sel$
                  
              Else
                connect()
              EndIf
            Case 27 ;ESCAPE
              Debug "ESCAPE key pressed"
              Quit = 1
          EndSelect
        Case #PB_Event_Gadget
          Debug "Event"
          If EventGadget() = #SHOWpwd ;Or GetFocus_() = GadgetID(#SHOWpwd)
            Debug "HIT Check"
;             ShowOrHidePass(#SECRET)
;             ShowOrHidePass(#User)
            TogglePasswordVisibility(#SECRET)
            TogglePasswordVisibility(#User)
            SetActiveGadget(#SECRET); try comment this and toggle AFTER TYPING on Mac: will show both "passwords"
          EndIf
          EventGadget = EventGadget()
          EventType = EventType()
          Select EventGadget ;-CLICK
            Case #ListView_0
              If EventType() = #PB_EventType_LeftClick
                ; show the selected listview entry on doubleclick
                item = GetGadgetState(#ListView_0)
                SelectElement(Sessions(),item)
                Debug Sessions()
                Sel$ = GetGadgetItemText(#ListView_0,item,0) ;whole line from listbox
                If FindString(Sel$,Chr(9))
                  p$ = Decrypt(StringField( Sel$,2, Chr(9) ) )
                  u$ = Decrypt(StringField( Sel$,3, Chr(9) ) )
                  SetGadgetText(#SECRET,p$)
                  SetGadgetText(#user,u$)
                  Sel$ = StringField(Sel$,1,Chr(9))
                EndIf
                Debug sel$
                SetGadgetText(#NAME,StringField(Sel$,1,","))
                x$ = StringField(Sel$,2,",")
                a1 = Val(StringField(x$,1,"."))
                a2 = Val(StringField(x$,2,"."))
                a3 = Val(StringField(x$,3,"."))
                a4 = Val(StringField(x$,4,"."))
                If a1+a2+a3+a4 >0
                  SetGadgetState(#IPAddress, MakeIPAddress(a1,a2,a3,a4))
                  SetGadgetText(#PORT,StringField(Sel$,3,","))
                Else
                  SetGadgetText(#IPAddress,"")
                EndIf
              EndIf
            Case #PING ;-PING
              n$ = GetGadgetText(#NAME)
              i$ = GetGadgetText(#IPAddress)
              If ping(i$)
                MessageRequester(server$+" Ping Is Good",n$+" / "+i$+Chr(10)+"Server is Visible"+Chr(10)+"And, you have a live network connection.", #MB_OK|#MB_ICONINFORMATION)
              Else
                MessageRequester(server$+" Ping Is Bad",i$+Chr(10)+"Server is NOT Visible"+Chr(10)+"Maybe check your internet", #MB_OK|#MB_ICONERROR)
              EndIf
            Case #SAVE
              If GetGadgetText(#SECRET)
              s$= GetGadgetText(#NAME)+","+GetGadgetText(#IPAddress)+","+GetGadgetText(#PORT) + Chr(9) + crypt(GetGadgetText(#SECRET)) + Chr(9) + crypt(GetGadgetText(#User))
                Else
              s$= GetGadgetText(#NAME)+","+GetGadgetText(#IPAddress)+","+GetGadgetText(#PORT)
                EndIf
              If Len(s$) > 9
                Debug GetGadgetText(#IPAddress)+","+GetGadgetText(#PORT)
                count = CountGadgetItems(#ListView_0)
                If Len(s$) > 0
                  For n = 0 To count
                    update = #False
                    g$ = GetGadgetItemText(#ListView_0,n)
                    If FindString(g$,GetGadgetText(#NAME))
                      Debug n
                      update = #True
                      Break
                    EndIf
                  Next n
                EndIf
                If update
                  Debug update
                  Debug GetGadgetItemText(#ListView_0,n)
                  SetGadgetItemText(#ListView_0,n,s$)
                  Debug "update"
                Else
                  AddGadgetItem(#ListView_0,-1,s$)
                  If CreateFile(0,Sessions$)
                    Debug "Save"
                  EndIf
                EndIf
                ;  Do we want to SortSessions() Before save?
                ;-SAVE
                count = CountGadgetItems(#ListView_0) - 1
                Debug count
                makebackups()
                Save()
              EndIf
            Case #CONNECT
              connect()
              SetActiveGadget(#ListView_0)
            Case #HELP ;-HELP
              HideWindow(#Window_11,0)
              t$ = "  Type in session name, address, port#, (optional user/password) and click [Ssve] to add a new session.  "
              t$ + "You must have [User/Pswd OK] enabled to allow them to save BEFORE you click [Save].  "   
              t$ + "Later just click any previous session in the list and click [Connect] or press Enter.  "
              t$ + "Disable [User/Pswd OK] if you want to login manually when you click [Connect]."+Chr(13)+Chr(13)
              t$ + "You must have [User/Pswd OK] enabled to allow auto-login.  " +Chr(13)
              t$ + "Sessions are stored in a 3 file rotation as follows:"+Chr(13)
              t$ + Chr(34)+"Sessions"+Chr(34)+" is the Active file"+Chr(13)
              t$ + Chr(34)+"Sessions1"+Chr(34)+" is most recent backup"+Chr(13)
              t$ + Chr(34)+"Sessions2"+Chr(34)+" is oldest backup"+Chr(13)
              t$ + "The files rotate each time you click [Save]."+Chr(13)+Chr(13)
              t$ + " Remember default port for SSH is always 22."+Chr(13)+Chr(13)
              t$ + "Macro information here: https://teratermproject.github.io/manual/4/en/macro/"+Chr(13)
              t$ + Chr(34)+"Pick your Macro file"+Chr(34)+" is populated from .ttl files found in your sessions folder."
              GetWindowRect_(WindowID(#Window_0),rw)
              wpx = rw\left
              wpy = rw\top
              SetGadgetText(#Text_1_11,t$)
              HideWindow(#Window_11,0)
              SetForegroundWindow_(HWND11)
              BringWindowToTop_(HWND11)
              ResizeWindow(#Window_11, wpx,wpy, 500,310)
              ResizeGadget(#Text_1_11, 8,8, 478,276)
              ResizeGadget(#Text_3_11,75,288,325,20)
              SetActiveWindow(#Window_11)
            Case #FOLDER
              Debug Sessions$
              If FileSize(Sessions$) >0
                ShellExecute_(0,"open","explorer","/select,"+Sessions$,GetPathPart(Sessions$),#SW_SHOW)
                Else
                  RunProgram("C:\Users\Owner\AppData\Roaming\teraterm5\","","")
                EndIf
          EndSelect
          ;           SelectElement(TTLs(),0)
          ;           ttl$ = TTLs()
          ;           
          ;           SelectElement(TTLs(),1)
          ;           ttl$ = TTLs()
          ;           
          ;           SelectElement(TTLs(),2)
          ;           ttl$ = TTLs()
          ;           Debug TTLs()
          
          ; ////////////////////////
        Case #PB_Event_CloseWindow
          If count > CountGadgetItems(#ListView_0)
            Debug "YES SAVE"
            makebackups()
            Save()
          EndIf
          Break
;         Case #PB_Event_Gadget
;           If EventGadget() = #SHOWpwd
;             TogglePasswordVisibility(0)
;             SetActiveGadget(0);
;           EndIf
      EndSelect
      n = 0
      ForEach TTLs()
        n + 1
        ListIndex(TTLs())
        If GetGadgetState(m(n))
          ;     Debug n
          ttl$ = TTLs()
          ;      Debug ttl$
          Break
        EndIf
      Next
      If ListSize(TTLs()) = 1
        HideGadget(picktext,1)
      EndIf
    Case #Window_11
      Select Event
        Case #WM_NOTIFY
          Debug "HMMMM"
          ; ///////////////////
        Case #WM_CHAR
          key = EventwParam()
          Select key
            Case 13 ;Return
            Case 26 To 126
              Debug "Key pressed"
              HideWindow(#Window_11,1)
          EndSelect
      EndSelect
    Default
      HideWindow(#Window_11,1)
  EndSelect
ForEver

; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; CursorPosition = 87
; FirstLine = 47
; Folding = 9--
; Markers = 245
; EnableThread
; UseIcon = Icons\Icon0345.ico
; Executable = C:\Accessories\SSHTTSM\SSHTTSM(3.0)x64.exe
; IncludeVersionInfo
; VersionField0 = 3.0
; VersionField1 = 3.0
; VersionField2 = SSHTTSM
; VersionField3 = SSHTTSM
; VersionField4 = 3.0
; VersionField5 = 3.0
; VersionField6 = SSH2 Session Manager for "TeraTerm"
; VersionField7 = SSHTTSM
; VersionField8 = SSHTTSM.exe
; EOF
; DontSaveDeclare
; CodePage=65001
; Build=2
; jaPBe Version=3.9.10.812