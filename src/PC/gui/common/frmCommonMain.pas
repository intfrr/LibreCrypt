unit frmCommonMain;
// Description:
// By Sarah Dean
// Email: sdean12@sdean12.org
// WWW:   http://www.FreeOTFE.org/
//
// -----------------------------------------------------------------------------
//


interface

uses
  // delphi
  ActnList, Buttons, Classes, ComCtrls, Controls, Dialogs,
  ExtCtrls, Forms, Graphics, Grids, ImgList, Menus, Messages,
  SDUSystemTrayIcon, Shredder, Spin64, StdCtrls, SysUtils, ToolWin,
  Windows, XPMan,
  // librecrypt
  CommonfrmCDBBackupRestore, CommonSettings,
  MouseRNGDialog_U, OTFE_U,
  DriverControl,
  OTFEFreeOTFE_U, OTFEFreeOTFEBase_U, pkcs11_library, lcDialogs, SDUForms,
  SDUGeneral, SDUMRUList, SDUMultimediaKeys, SDUDialogs;

const
  // Command line parameters...
  CMDLINE_SETTINGSFILE  = 'settings';
  CMDLINE_DRIVE         = 'drive';
  CMDLINE_SILENT        = 'silent';
  CMDLINE_SALTLENGTH    = 'saltlength';
  CMDLINE_KEYITERATIONS = 'keyiterations';
  CMDLINE_NOEXIT        = 'noexit';
  CMDLINE_CREATE        = 'create';

  // Command line return values. not all common, but put here so can use enum

type
  eCmdLine_Exit = (
    // common
    ceSUCCESS = 0,
    ceINVALID_CMDLINE = 100,
    ceUNABLE_TO_MOUNT = 102,
    ceFILE_NOT_FOUND = 106,

    // main specific
    ceUNABLE_TO_CONNECT = 101,
    ceUNABLE_TO_DISMOUNT = 103,
    ceUNABLE_TO_START_PORTABLE_MODE = 104,
    ceUNABLE_TO_STOP_PORTABLE_MODE = 105,
    ceADMIN_PRIVS_NEEDED = 106,
    ceUNABLE_TO_SET_TESTMODE = 107,
    ceUNABLE_TO_SET_INSTALLED = 108,
    ceUNKNOWN_ERROR = 999
    );

const

  WM_USER_POST_SHOW = WM_USER + 10;

  DEVICE_PREFIX     = '\Device';


type
  TAutorunType = (arPostMount, arPreDismount, arPostDismount);

  TfrmCommonMain = class(TSDUForm)
    mmMain: TMainMenu;
    File1: TMenuItem;
    miFreeOTFEMountFile: TMenuItem;
    miDismountMain: TMenuItem;
    miExit: TMenuItem;
    miFreeOTFENew: TMenuItem;
    View1: TMenuItem;
    miRefresh: TMenuItem;
    OpenDialog: TSDUOpenDialog;
    miHelp: TMenuItem;
    About1: TMenuItem;
    N4: TMenuItem;
    miLinuxVolume: TMenuItem;
    miLinuxNew: TMenuItem;
    miLinuxMountFile: TMenuItem;
    N5: TMenuItem;
    miLinuxDismount: TMenuItem;
    miTools: TMenuItem;
    miCDBBackup: TMenuItem;
    miCDBRestore: TMenuItem;
    miCreateKeyfile: TMenuItem;
    miChangePassword: TMenuItem;
    miCDBPlaintextDump: TMenuItem;
    miCDB: TMenuItem;
    N9: TMenuItem;
    miLUKSDump: TMenuItem;
    ActionList1: TActionList;
    actFreeOTFENew: TAction;
    actFreeOTFEMountFile: TAction;
    actDismount: TAction;
    actLinuxNew: TAction;
    actLinuxMountFile: TAction;
    actExit: TAction;
    ilToolbarIcons_Small: TImageList;
    StatusBar_Status: TStatusBar;
    XPManifest1: TXPManifest;
    actRefresh: TAction;
    actListCyphers: TAction;
    Listcyphers1: TMenuItem;
    actListHashes: TAction;
    Listhashes1: TMenuItem;
    N13: TMenuItem;
    actPKCS11TokenManagement: TAction;
    PKCS11management1: TMenuItem;
    N14: TMenuItem;
    actUserGuide: TAction;
    Userguide1: TMenuItem;
    N15: TMenuItem;
    actInstallOnUSBDrive: TAction;
    N16: TMenuItem;
    CopyFreeOTFEtoUSBdrive1: TMenuItem;
    ilToolbarIcons_Large: TImageList;
    ilWindowsStd_24x24: TImageList;
    ilWindowsStd_16x16: TImageList;
    actAbout: TAction;
    actOptions: TAction;
    SDUMultimediaKeys1: TSDUMultimediaKeys;
    actCheckForUpdates: TAction;
    Checkforupdates1: TMenuItem;
    N100: TMenuItem;
    StatusBar_Hint: TStatusBar;
    actCDBBackup: TAction;
    actCDBRestore: TAction;
    actCDBPlaintextDump: TAction;
    actLUKSDump: TAction;
    actMountHidden: TAction;
    Mountfilehidden1: TMenuItem;
    Label1: TLabel;
    miDev: TMenuItem;
    actFullTest: TAction;
    DoTests1: TMenuItem;
    aLuksTest: TAction;
    procedure FormCreate(Sender: TObject);
    procedure miCreateKeyfileClick(Sender: TObject);
    procedure miChangePasswordClick(Sender: TObject);
    procedure actCDBPlaintextDumpExecute(Sender: TObject);
    procedure actFreeOTFENewExecute(Sender: TObject);
    procedure actFreeOTFEMountFileExecute(Sender: TObject);
    procedure actNewPlainLinuxExecute(Sender: TObject);
    procedure actLinuxMountFileExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actListCyphersExecute(Sender: TObject);
    procedure actListHashesExecute(Sender: TObject);
    procedure actPKCS11TokenManagementExecute(Sender: TObject);
    procedure actUserGuideExecute(Sender: TObject);
    procedure actInstallOnUSBDriveExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actCheckForUpdatesExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actCDBBackupExecute(Sender: TObject);
    procedure actCDBRestoreExecute(Sender: TObject);
    procedure actLUKSDumpExecute(Sender: TObject);
    procedure actMountHiddenExecute(Sender: TObject);
    procedure actFullTestExecute(Sender: TObject);
    procedure aLuksTestExecute(Sender: TObject);

  private


  protected

    ficonIdx_Small_VistaUACShield: Integer;

    ficonIdx_Large_VistaUACShield: Integer;

    // This is set to TRUE at the very start of InitApp(...)
    finitAppCalled:                Boolean;
    // This is set to TRUE at the end of calling WMUserPostShow(...) is called
    fwmUserPostShowCalledAlready:  Boolean;


    // Flag to indicate that the login session is about to end
    fendSessionFlag:    Boolean;
    // Flag to indicate that the executable is about to exit
    fIsAppShuttingDown: Boolean;
    // was there an error on last run? (detected with 'AppRunning' setting)
    fWasLastRunError:   Boolean;

    fPkcs11Library:     TPKCS11Library;

    fFuncTestPending:   Boolean;
    // if functional test was selelcted in cmd line but not run yet

    procedure DoAppIdle(Sender: TObject; var Done: Boolean); // TIdleEvent

    function HandleCommandLineOpts_Create(): eCmdLine_Exit; virtual; abstract;
    function HandleCommandLineOpts_Mount(): eCmdLine_Exit; virtual;
    function HandleCommandLineOpts_EnableDevMenu(): eCmdLine_Exit; virtual;


    procedure ReloadSettings(); virtual;

    procedure SetupOTFEComponent(); virtual;
    function ActivateFreeOTFEComponent(suppressMsgs: Boolean): Boolean; virtual;
    procedure DeactivateFreeOTFEComponent(); virtual;
    procedure ShowOldDriverWarnings(); virtual;

    procedure SetupPKCS11(suppressMsgs: Boolean);
    procedure ShutdownPKCS11();
    procedure PKCS11SlotEvent(Sender: TObject; SlotID: Integer);
    procedure PKCS11TokenRemoved(SlotID: Integer); virtual; abstract;
    procedure PKCS11TokenInserted(SlotID: Integer); virtual;

    procedure AddToMRUList(filenames: TStringList); overload;
    procedure AddToMRUList(filename: string); overload;
    procedure RefreshMRUList(); virtual;
    procedure MRUListItemClicked(mruList: TSDUMRUList; idx: Integer);
      virtual; abstract;

    procedure SetStatusBarText(statusText: string);
    procedure EnableDisableControls(); virtual;

    procedure DumpDetailsToFile(LUKSDump: Boolean);

    procedure ExploreDrive(driveLetter: DriveLetterChar);
    procedure AutoRunExecute(autorun: TAutorunType; driveLetter: DriveLetterChar;
      isEmergency: Boolean);

    procedure MountFilesDetectLUKS(fileToMount: string; ReadOnly: Boolean;
      defaultType: TDragDropFileType); overload;
    // procedure MountFilesDetectLUKS(fileToMount: String; ReadOnly: Boolean;
    // defaultType: TDragDropFileType); OVERLOAD;
    // procedure MountFiles(mountAsSystem: TDragDropFileType; filename: String;
    // ReadOnly, forceHidden: Boolean); OVERLOAD;

    procedure MountFiles(mountAsSystem: TDragDropFileType; filename: string;
      ReadOnly, forceHidden: Boolean); overload; virtual; abstract;
    procedure LinuxMountFile(forceHidden: Boolean);

    {$IFDEF VER180}
    {$IFNDEF VER185}
    // Vista fix for Delphi 2006 only
    procedure WMSyscommand(var Message: TWmSysCommand); message WM_SYSCOMMAND;
    {$ENDIF}
    {$ENDIF}
    procedure AddStdIcons();
    procedure AddUACShieldIcons();
    procedure SetupToolbarAndMenuIcons(); virtual;
    procedure RecaptionToolbarAndMenuIcons(); virtual;
    procedure SetIconListsAndIndexes(); virtual;
    procedure SetupToolbarFromSettings(); virtual; abstract;

    procedure StartupUpdateCheck();

    procedure BackupRestore(dlgType: TCDBOperationType;
      volPath: TFilename = ''; hdrPath: TFilename = '';
      silent: Boolean = False);

    procedure SetStatusBarToHint(Sender: TObject);
    function EnsureOTFEComponentActive: Boolean;

    function DoFullTests: Boolean; virtual; abstract;
    function DoLuksTests: Boolean; virtual; abstract;

  public
    constructor Create(AOwner: TComponent); override;

    procedure WMUserPostShow(var msg: TWMEndSession); message WM_USER_POST_SHOW;

    procedure InitApp(); virtual;

    // Handle any command line options; returns TRUE if command line options
    // were passed through
    function HandleCommandLineOpts(out cmdExitCode: eCmdLine_Exit): Boolean;
      virtual; abstract;

    {$IFDEF VER180}
    {$IFNDEF VER185}
    // Vista fix for Delphi 2006 only
    procedure CreateParams(var Params: TCreateParams); override;
    {$ENDIF}
    {$ENDIF}
  end;

resourcestring
  // Captions...
  RS_TOOLBAR_CAPTION_NEW = 'New';
  RS_TOOLBAR_CAPTION_MOUNTFILE = 'Open container';
  RS_TOOLBAR_CAPTION_DISMOUNT = 'Lock';
  // Hints...
  RS_TOOLBAR_HINT_NEW = 'Create a new container';
  RS_TOOLBAR_HINT_MOUNTFILE = 'Open a file based container';
  RS_TOOLBAR_HINT_DISMOUNT = 'Lock an open container';

const
  USERGUIDE_LOCAL = '.\docs\index.html';

  // Command line switch indicator
  // Note: Only used when creating command lines; parsing them is more flexable
  CMDLINE_SWITCH_IND = '/';

  // Command line parameters...
  // CMDLINE_SETTINGSFILE defined in "interface" section; used in HandleCommandLineOpts fn
  CMDLINE_MOUNT           = 'mount';
  CMDLINE_FREEOTFE        = 'LibreCrypt';
  CMDLINE_LINUX           = 'linux';
  CMDLINE_VOLUME          = 'volume';
  CMDLINE_READONLY        = 'readonly';
  CMDLINE_OFFSET          = 'offset';
  CMDLINE_NOCDBATOFFSET   = 'noCDBatoffset';
  CMDLINE_PASSWORD        = 'password';
  CMDLINE_TYPE            = 'type';
  CMDLINE_FILENAME        = 'filename';
  CMDLINE_KEYFILE         = 'keyfile';
  CMDLINE_KEYFILEISASCII  = 'keyfileisascii';
  CMDLINE_KEYFILENEWLINE  = 'keyfilenewline';
  CMDLINE_LESFILE         = 'lesfile';
  CMDLINE_ENABLE_DEV_MENU = 'dev_menu'; // enable dev menu

  // Toolbar button height is set to the image size + this value
  TOOLBAR_ICON_BORDER     = 4;

  // These are the hardcoded FreeOTFE icons in ilToolbarIcons_Small/ilToolbarIcons_Large
  // -1 indicates no icon stored
  { TODO -otdk -cinvestigate : what exactly is the point of this? }
  (*

    ICONIDX_NEW                             = 3;
    ICONIDX_MOUNTFILE                       = 4;
    ICONIDX_MOUNTPARTITION                  = 0;
    ICONIDX_DISMOUNT                        = 1;
    ICONIDX_DISMOUNTALL                     = 2;
    ICONIDX_PORTABLEMODE                    = 5;
    ICONIDX_VISTASHIELD                     = -1;
    ICONIDX_PROPERTIES                      = -1;
    ICONIDX_EXPLORER_BACK                   = 6;
    ICONIDX_EXPLORER_FORWARD                = 7;
    ICONIDX_EXPLORER_UP                     = 8;
    ICONIDX_EXPLORER_MOVETO                 = 9;
    ICONIDX_EXPLORER_COPYTO                 = 10;
    ICONIDX_EXPLORER_DELETE                 = 11;
    ICONIDX_EXPLORER_VIEWS                  = 12;
    ICONIDX_EXPLORER_EXTRACT                = 13;
    ICONIDX_EXPLORER_STORE                  = 14;
    ICONIDX_EXPLORER_PROPERTIES             = 15;
    ICONIDX_EXPLORER_FOLDERS                = 16;
    ICONIDX_EXPLORER_MAPNETWORKDRIVE        = 17;
    ICONIDX_EXPLORER_DISCONNECTNETWORKDRIVE = 18;
  *)

implementation

{$R *.DFM}


uses
  DateUtils,
  ShellApi, // Required for SHGetFileInfo
  Commctrl, // Required for ImageList_GetIcon
  ComObj,   // Required for StringToGUID
  Math,     // Required for min
  {$IFDEF UNICODE}
  AnsiStrings,
  {$ENDIF}
  lcConsts,
  {$IFDEF FREEOTFE_MAIN}
  MainSettings,
  {$ENDIF}
  {$IFDEF FREEOTFE_EXPLORER}
  ExplorerSettings,
  {$ENDIF}
  // freeotfe
  frmAbout,
  CommonfrmCDBDump_Base,
  CommonfrmCDBDump_FreeOTFE,
  CommonfrmCDBDump_LUKS,
  CommonfrmGridReport_Cypher,
  CommonfrmGridReport_Hash,
  CommonfrmInstallOnUSBDrive,
  frmVersionCheck,
  OTFEConsts_U,
  DriverAPI,
  PKCS11Lib, VolumeFileAPI,
  pkcs11_slot,
  SDUFileIterator_U,
  SDUGraphics,
  SDUi18n;

{$IFDEF _NEVER_DEFINED}

// This is just a dummy const to fool dxGetText when extracting message
// information
// This const is never used; it's #ifdef'd out - SDUCRLF in the code refers to
// picks up SDUGeneral.SDUCRLF
const
  SDUCRLF = ''#13#10;
  {$ENDIF}


resourcestring
  AUTORUN_POST_MOUNT = 'post mount';
  AUTORUN_PRE_MOUNT = 'pre dismount';
  AUTORUN_POST_DISMOUNT = 'post dismount';

const
  AUTORUN_TITLE: array [TAutorunType] of string = (
    AUTORUN_POST_MOUNT,
    AUTORUN_PRE_MOUNT,
    AUTORUN_POST_DISMOUNT
    );

  AUTORUN_SUBSTITUTE_DRIVE = '%DRIVE';

constructor TfrmCommonMain.Create(AOwner: TComponent);
begin
  finitAppCalled               := False;
  fwmUserPostShowCalledAlready := False;
  inherited;
end;

procedure TfrmCommonMain.SetupToolbarAndMenuIcons();
begin
  // Default to hardcoded icons...
  (*
    FIconIdx_Small_New                    := ICONIDX_NEW;
    FIconIdx_Small_MountFile              := ICONIDX_MOUNTFILE;
    FIconIdx_Small_MountPartition         := ICONIDX_MOUNTPARTITION;
    FIconIdx_Small_Dismount               := ICONIDX_DISMOUNT;
    FIconIdx_Small_DismountAll            := ICONIDX_DISMOUNTALL;
    FIconIdx_Small_PortableMode           := ICONIDX_PORTABLEMODE;
  *)
  ficonIdx_Small_VistaUACShield := -1;
  (*
    FIconIdx_Small_Properties             := ICONIDX_PROPERTIES;
    FIconIdx_Small_Back                   := ICONIDX_EXPLORER_BACK;
    FIconIdx_Small_Forward                := ICONIDX_EXPLORER_FORWARD;
    FIconIdx_Small_Up                     := ICONIDX_EXPLORER_UP;
    FIconIdx_Small_MoveTo                 := ICONIDX_EXPLORER_MOVETO;
    FIconIdx_Small_CopyTo                 := ICONIDX_EXPLORER_COPYTO;
    FIconIdx_Small_Delete                 := ICONIDX_EXPLORER_DELETE;
    FIconIdx_Small_Views                  := ICONIDX_EXPLORER_VIEWS;
    FIconIdx_Small_Extract                := ICONIDX_EXPLORER_EXTRACT;
    FIconIdx_Small_Store                  := ICONIDX_EXPLORER_STORE;
    FIconIdx_Small_ItemProperties         := ICONIDX_EXPLORER_PROPERTIES;
    FIconIdx_Small_Folders                := ICONIDX_EXPLORER_FOLDERS;
    FIconIdx_Small_MapNetworkDrive        := ICONIDX_EXPLORER_MAPNETWORKDRIVE;
    FIconIdx_Small_DisconnectNetworkDrive := ICONIDX_EXPLORER_DISCONNECTNETWORKDRIVE;

    FIconIdx_Large_New                    := ICONIDX_NEW;
    FIconIdx_Large_MountFile              := ICONIDX_MOUNTFILE;
    FIconIdx_Large_MountPartition         := ICONIDX_MOUNTPARTITION;
    FIconIdx_Large_Dismount               := ICONIDX_DISMOUNT;
    FIconIdx_Large_DismountAll            := ICONIDX_DISMOUNTALL;
    FIconIdx_Large_PortableMode           := ICONIDX_PORTABLEMODE;
  *)
  ficonIdx_Large_VistaUACShield := -1;
  (*
    FIconIdx_Large_Properties             := ICONIDX_PROPERTIES;
    FIconIdx_Large_Back                   := ICONIDX_EXPLORER_BACK;
    FIconIdx_Large_Forward                := ICONIDX_EXPLORER_FORWARD;
    FIconIdx_Large_Up                     := ICONIDX_EXPLORER_UP;
    FIconIdx_Large_MoveTo                 := ICONIDX_EXPLORER_MOVETO;
    FIconIdx_Large_CopyTo                 := ICONIDX_EXPLORER_COPYTO;
    FIconIdx_Large_Delete                 := ICONIDX_EXPLORER_DELETE;
    FIconIdx_Large_Views                  := ICONIDX_EXPLORER_VIEWS;
    FIconIdx_Large_Extract                := ICONIDX_EXPLORER_EXTRACT;
    FIconIdx_Large_Store                  := ICONIDX_EXPLORER_STORE;
    FIconIdx_Large_ItemProperties         := ICONIDX_EXPLORER_PROPERTIES;
    FIconIdx_Large_Folders                := ICONIDX_EXPLORER_FOLDERS;
    FIconIdx_Large_MapNetworkDrive        := ICONIDX_EXPLORER_MAPNETWORKDRIVE;
    FIconIdx_Large_DisconnectNetworkDrive := ICONIDX_EXPLORER_DISCONNECTNETWORKDRIVE;
  *)
  // Load system icons...
  // AddStdIcons();

  if SDUOSVistaOrLater() then begin
    // Mark as appropriate with UAC "shield" icons
    AddUACShieldIcons();
  end;

  SetIconListsAndIndexes();

  RecaptionToolbarAndMenuIcons();
end;

procedure TfrmCommonMain.RecaptionToolbarAndMenuIcons();
begin
  // Redo captions, etc which otherwise get reverted when translation
  // is carried out
  self.Caption     := Application.Title;

  actAbout.Caption := Format(_('About %s...'), [Application.Title]);

  actInstallOnUSBDrive.Caption :=
    Format(_('&Copy %s to USB drive...'), [Application.Title]);
end;

// Add standard Windows icons
procedure TfrmCommonMain.AddStdIcons();

  procedure LoadSystemImagesIntoImageList(imageSet: Integer;
    ImgList: TImageList);
  var
    HToolBar: HWND;
  begin
    ImgList.Clear();
    HToolBar := CreateWindowEx(0, TOOLBARCLASSNAME, nil, WS_CHILD, 0, 0, 0,
      0, Handle, 0, HInstance, nil);
    SendMessage(HToolBar, TB_SETIMAGELIST, 0, ImgList.Handle);
    SendMessage(
      HToolBar,
      TB_LOADIMAGES,
      imageSet,
      LPARAM(HINST_COMMCTRL)
      );
    DestroyWindow(HToolBar);
  end;

  procedure AddStdIconToToolbarIcons(stdIconIdx: Integer;
    var fotfeSmallIdx: Integer;
    var fotfeLargeIdx: Integer);
  var
    tmpIdx: Integer;
  begin
    tmpIdx := ilToolbarIcons_Small.AddImage(ilWindowsStd_16x16, stdIconIdx);
    if (tmpIdx >= 0) then begin
      fotfeSmallIdx := tmpIdx;
    end;

    tmpIdx := ilToolbarIcons_Large.AddImage(ilWindowsStd_24x24, stdIconIdx);
    if (tmpIdx >= 0) then begin
      fotfeLargeIdx := tmpIdx;
    end;

  end;

begin
  // Windows standard icons: Small (16x16)
  ilWindowsStd_16x16.Width  := 16;
  ilWindowsStd_16x16.Height := 16;
  LoadSystemImagesIntoImageList(IDB_STD_SMALL_COLOR, ilWindowsStd_16x16);

  // Windows standard icons: Large (24x24)
  ilWindowsStd_24x24.Width  := 24;
  ilWindowsStd_24x24.Height := 24;
  LoadSystemImagesIntoImageList(IDB_STD_LARGE_COLOR, ilWindowsStd_24x24);

  // Copy certain icons over to the imagelists we use for menuitems/toolbar
  // buttons, and set the stored indexes
  (*
    AddStdIconToToolbarIcons(
    STD_FILENEW,
    FIconIdx_Small_New,
    FIconIdx_Large_New
    );
    AddStdIconToToolbarIcons(
    STD_FILEOPEN,
    FIconIdx_Small_MountFile,
    FIconIdx_Large_MountFile
    );
    AddStdIconToToolbarIcons(
    STD_PROPERTIES,
    FIconIdx_Small_Properties,
    FIconIdx_Large_Properties
    );
  *)
end;

// Add an standard Windows Vista UAC shield icon
procedure TfrmCommonMain.AddUACShieldIcons();
var
  anIcon:     TIcon;
  iconHandle: HICON;
begin
  // Load the Windows Vista UAC shield icon

  // --- SMALL (16x16) ICON ----------
  iconHandle := LoadImage(0, PChar(UAC_IDI_SHIELD), IMAGE_ICON,
    ilToolbarIcons_Small.Width, ilToolbarIcons_Small.Height,
    (LR_CREATEDIBSECTION or LR_SHARED));
  if (iconHandle <> 0) then begin
    anIcon := TIcon.Create();
    try
      anIcon.ReleaseHandle();

      anIcon.Handle := iconHandle;
      {
        if (ilToolbarIcons_Small.Width < anIcon.Width) then
        begin
        ilToolbarIcons_Small.Width := anIcon.Width;
        end;
        if (ilToolbarIcons_Small.Height < anIcon.Height) then
        begin
        ilToolbarIcons_Small.Height := anIcon.Height;
        end;
      }
      ficonIdx_Small_VistaUACShield := ilToolbarIcons_Small.AddIcon(anIcon);

      anIcon.ReleaseHandle();
      DestroyIcon(iconHandle);
    finally
        anIcon.Free();
    end;

  end;


  // --- LARGE (32x32) ICON ----------
  iconHandle := LoadImage(0, PChar(UAC_IDI_SHIELD), IMAGE_ICON,
    ilToolbarIcons_Large.Width, ilToolbarIcons_Large.Height,
    (LR_CREATEDIBSECTION or LR_SHARED));
  if (iconHandle <> 0) then begin
    anIcon := TIcon.Create();
    try
      anIcon.ReleaseHandle();

      anIcon.Handle := iconHandle;
      {
        if (ilToolbarIcons_Large.Width < anIcon.Width) then
        begin
        ilToolbarIcons_Large.Width := anIcon.Width;
        end;
        if (ilToolbarIcons_Large.Height < anIcon.Height) then
        begin
        ilToolbarIcons_Large.Height := anIcon.Height;
        end;
      }
      ficonIdx_Large_VistaUACShield := ilToolbarIcons_Large.AddIcon(anIcon);

      anIcon.ReleaseHandle();
      DestroyIcon(iconHandle);
    finally
        anIcon.Free();
    end;

  end;

end;


procedure TfrmCommonMain.FormCreate(Sender: TObject);
begin
  {$IFDEF FREEOTFE_DEBUG}
  GetFreeOTFEBase().fDebugShowMessage := False;
  // xxx - disable showmessages(...) of debug if built with debug on
  {$ENDIF}

  {$IFDEF VER180}
  {$IFNDEF VER185}
  if SDUOSVistaOrLater() then
  begin
    // Vista fix for Delphi 2006 only
    ShowWindow(Application.Handle, SW_HIDE);
    SetWindowLong(
      Application.Handle,
      GWL_EXSTYLE,
      (
      GetWindowLong(Application.Handle, GWL_EXSTYLE) and not WS_EX_APPWINDOW or WS_EX_TOOLWINDOW
      )
      );
    ShowWindow(Application.Handle, SW_SHOW);
  end;
  {$ENDIF}
  {$ENDIF}
  SetupToolbarAndMenuIcons();

  // Reload settings to ensure any any components are setup, etc
  ReloadSettings();

  // We set these to invisible so that if they're disabled by the user
  // settings, it doens't flicker on them off
  StatusBar_Hint.Visible   := False;
  StatusBar_Status.Visible := False;
  Application.OnHint       := SetStatusBarToHint;
  Application.OnIdle       := DoAppIdle;


end;


procedure TfrmCommonMain.FormShow(Sender: TObject);
begin
  // Post a message back to *this* form to allow any automatic updates check
  // to be carried out *after* the main form is displayed (i.e. post-show)
  // This way, there's no risk of an updates dialog getting "lost", and not
  // appearing on the taskbar if there is a newer version available
  PostMessage(self.Handle, WM_USER_POST_SHOW, 0, 0);
end;

procedure TfrmCommonMain.SetupOTFEComponent();
begin
  GetFreeOTFEBase().fAdvancedMountDlg    := gSettings.OptAdvancedMountDlg;
  GetFreeOTFEBase().fRevertVolTimestamps := gSettings.OptRevertVolTimestamps;
  GetFreeOTFEBase().PasswordChar         := '*';
  if gSettings.OptShowPasswords then begin
    GetFreeOTFEBase().PasswordChar       := #0;
  end;
  GetFreeOTFEBase().AllowNewlinesInPasswords :=
    gSettings.OptAllowNewlinesInPasswords;
  GetFreeOTFEBase().AllowTabsInPasswords := gSettings.OptAllowTabsInPasswords;

  // GetFreeOTFEBase().PKCS11Library setup in SetupPKCS11(...)

end;

// Reload settings, setting up any components as needed
procedure TfrmCommonMain.ReloadSettings();
begin
  SDUSetLanguage(gSettings.OptLanguageCode);
  try
      SDURetranslateComponent(self);
  except
    on E: Exception do begin
      SDUTranslateComponent(self);
    end;
  end;

  RecaptionToolbarAndMenuIcons();

  SetupPKCS11(False);
  SetupOTFEComponent();

  RefreshMRUList();

end;

// procedure TfrmCommonMain.MountFiles(mountAsSystem: TDragDropFileType; filename: String;
// ReadOnly, forceHidden: Boolean);
// var
// tmpFilenames: TStringList;
// begin
// tmpFilenames := TStringList.Create();
// try
// tmpFilenames.Add(filename);
// MountFiles(mountAsSystem, tmpFilenames, ReadOnly, forceHidden);
// finally
// tmpFilenames.Free();
// end;
// end;


// If called with "nil", just refresh the menuitems shown
procedure TfrmCommonMain.AddToMRUList(filenames: TStringList);
begin
  if (filenames <> nil) then begin
    gSettings.OptMRUList.Add(filenames);

    if (gSettings.OptSaveSettings <> slNone) then begin
      gSettings.Save();
    end;
  end;

  RefreshMRUList();

end;

procedure TfrmCommonMain.AddToMRUList(filename: string);
begin

  gSettings.OptMRUList.Add(filename);

  if (gSettings.OptSaveSettings <> slNone) then begin
    gSettings.Save();
  end;


  RefreshMRUList();

end;


procedure TfrmCommonMain.RefreshMRUList();
begin
  gSettings.OptMRUList.OnClick := MRUListItemClicked;
end;

// procedure TfrmCommonMain.MountFilesDetectLUKS(fileToMount: String; ReadOnly: Boolean;
// defaultType: TDragDropFileType);
// var
// tmpFilenames: TStringList;
// begin
// tmpFilenames := TStringList.Create();
// try
// tmpFilenames.Add(fileToMount);
// MountFilesDetectLUKS(
// tmpFilenames,
// ReadOnly,
// defaultType
// );
// finally
// tmpFilenames.Free();
// end;
// end;


procedure TfrmCommonMain.MountFilesDetectLUKS(fileToMount: string;
  ReadOnly: Boolean;
  defaultType: TDragDropFileType);
var
  // i:         Integer;
  mountType: TDragDropFileType;
begin
  // If *all* of the volumes selected are LUKS volumes, mount as LUKS.
  // Otherwise mount the type passed into this function
  // (The chances of a FreeOTFE volume starting with the LUKS signature are
  // pretty low, so this is included to make life easier for LUKS users)
  mountType   := ftLinux;
  // for i := 0 to (filesToMount.Count - 1) do begin
  if not(GetFreeOTFEBase().IsLUKSVolume(fileToMount)) then begin
    mountType := defaultType;
    // break;
  end;
  // end;

  MountFiles(mountType, fileToMount, readonly, False);
end;

procedure TfrmCommonMain.EnableDisableControls();
begin
  actPKCS11TokenManagement.Enabled := gSettings.OptPKCS11Enable;

  // The FreeOTFE object may not be active...
  actFreeOTFENew.Enabled           := GetFreeOTFEBase().Active;
  actFreeOTFEMountFile.Enabled     := GetFreeOTFEBase().Active;
  // Linux menuitem completely disabled if not active...
  miLinuxVolume.Enabled            := GetFreeOTFEBase().Active;
  actLinuxNew.Enabled              := miLinuxVolume.Enabled;
  actLinuxMountFile.Enabled        := miLinuxVolume.Enabled;

  miChangePassword.Enabled         := GetFreeOTFEBase().Active;
  miCreateKeyfile.Enabled          := GetFreeOTFEBase().Active;
  miCDB.Enabled                    := GetFreeOTFEBase().Active;


  // Because the copy system "dumbly" copies the dir *this* executable is in,
  // plus anything below it, we disable the "Copy FreeOTFE to..." menuitem if
  // *this* application is running from a root dir.
  // >3 because the root'll be "X:\"; 3 chars long
  actInstallOnUSBDrive.Enabled := (length(ExtractFilePath(ParamStr(0))) > 3);
end;

procedure TfrmCommonMain.SetIconListsAndIndexes;
begin

end;

procedure TfrmCommonMain.SetStatusBarText(statusText: string);
begin
  StatusBar_Status.SimpleText := statusText;
end;


function TfrmCommonMain.ActivateFreeOTFEComponent(suppressMsgs
  : Boolean): Boolean;
var
  obsoleteDriver: Boolean;
begin
  obsoleteDriver               := False;
  try
      GetFreeOTFEBase().Active := True;
  except
    on EFreeOTFEObsoleteDriver do begin
      obsoleteDriver           := True;
    end;

    else
      // We should only get to here if the FreeOTFE driver isn't both
      // installed & started

  end;

  if (not(suppressMsgs) and not(GetFreeOTFEBase().Active) and not
    fIsAppShuttingDown // Don't complain to user as we're about to exit!
    ) then begin
    if (obsoleteDriver) then begin
      SDUMessageDlg(
        Format(_(
        'In order to use this software, you must first upgrade your %s drivers to a later version.'),
        [Application.Title]) + SDUCRLF + SDUCRLF +
        Format(
        _('If you have just upgraded your copy of %s from a previous version, please ensure that'
        +
        ' you have followed the upgrade instructions that came with it, and have rebooted if necessary.'),
        [Application.Title]),
        mtError
        );
    end else begin
      SDUMessageDlg(
        Format(_('Unable to connect to the main %s driver.'),
        [Application.Title]) + SDUCRLF + SDUCRLF +
        Format(_('Please ensure that the main "%s" driver is installed and started.'),
        [Application.Title]) + SDUCRLF + SDUCRLF +
        Format(_('If you have only just installed %s, please reboot and try again.'),
        [Application.Title]),
        mtError
        );
    end;

    // Note that we don't terminate here; the user may still use the driver
    // control functionality to install and/or start the FreeOTFE driver
  end;

  // Old driver warnings
  if GetFreeOTFEBase().Active then
    ShowOldDriverWarnings();

  Result := GetFreeOTFEBase().Active;
end;

procedure TfrmCommonMain.ShowOldDriverWarnings();
begin
  // No warnings to be shown in base class
end;

procedure TfrmCommonMain.DeactivateFreeOTFEComponent();
begin
  GetFreeOTFEBase().Active := False;
end;

procedure TfrmCommonMain.DoAppIdle(Sender: TObject; var Done: Boolean);
begin
  if fFuncTestPending then begin
    fFuncTestPending := False;
    // actCheckForUpdatesExecute(self);
    // actTestExecute(self);
    // Close;

  end;
  Done := True;
end;

procedure TfrmCommonMain.actCDBBackupExecute(Sender: TObject);
begin
  BackupRestore(opBackup);
end;

procedure TfrmCommonMain.actCDBRestoreExecute(Sender: TObject);
begin
  BackupRestore(opRestore);
end;

procedure TfrmCommonMain.BackupRestore(dlgType: TCDBOperationType;
  volPath: TFilename = ''; hdrPath: TFilename = ''; silent: Boolean = False);
var
  dlg: TfrmCDBBackupRestore;
begin
  dlg                  := TfrmCDBBackupRestore.Create(self);

  try
    dlg.silent         := silent;
    if dlgType = opBackup then begin
      dlg.SrcFilename  := volPath;
      dlg.DestFilename := hdrPath;
    end else begin
      dlg.SrcFilename  := hdrPath;
      dlg.DestFilename := volPath;
    end;

    dlg.OpType         := dlgType;
    dlg.ShowModal();

  finally
      dlg.Free();
  end;
end;

procedure TfrmCommonMain.miCreateKeyfileClick(Sender: TObject);
begin
  GetFreeOTFEBase().WizardCreateKeyfile();
end;

procedure TfrmCommonMain.miChangePasswordClick(Sender: TObject);
begin
  GetFreeOTFEBase().WizardChangePassword();
end;

procedure TfrmCommonMain.actCDBPlaintextDumpExecute(Sender: TObject);
begin
  DumpDetailsToFile(False);

end;

procedure TfrmCommonMain.actLUKSDumpExecute(Sender: TObject);
begin
  DumpDetailsToFile(True);

end;

procedure TfrmCommonMain.DumpDetailsToFile(LUKSDump: Boolean);
var
  dlg: TfrmHdrDump;
begin
  if GetFreeOTFEBase().WarnIfNoHashOrCypherDrivers() then begin
    if LUKSDump then begin
      dlg := TfrmLUKSHdrDump.Create(self);
    end else begin
      dlg := TfrmFreeOTFEHdrDump.Create(self);
    end;
    try
        dlg.ShowModal();
    finally
        dlg.Free();
    end;

  end;

end;


procedure TfrmCommonMain.ExploreDrive(driveLetter: DriveLetterChar);
begin
  if (driveLetter <> #0) then begin
    // explorerCommandLine := 'explorer.exe ' + driveLetter + ':\';
    // ShellExecute(Application.Handle, 'open', PWideChar('Explorer'),PWideChar(driveLetter + ':\') , nil, cmdShow) ;

    if not(SDUWinExecNoWait32('Explorer', driveLetter + ':\', SW_RESTORE)) then
      SDUMessageDlg(_('Error running Explorer'), mtError, [mbOK], 0);
  end;

end;


// Launch autorun executable on specified drive
procedure TfrmCommonMain.AutoRunExecute(autorun: TAutorunType;
  driveLetter: DriveLetterChar;
  isEmergency: Boolean);
var
  exeParams, exeFullCmdLine: string;
  launchOK:                  Boolean;
  splitCmdLine:              TStringList;
  exeOnly:                   string;
begin
  // Sanity...
  if (driveLetter = #0) then begin
    exit;
  end;

  exeFullCmdLine := '';

  case autorun of

    arPostMount:
      begin
        exeFullCmdLine := gSettings.OptPostMountExe;
      end;

    arPreDismount:
      begin
        // We don't bother with predismount in case of emergency
        if not(isEmergency) then begin
          exeFullCmdLine := gSettings.OptPreDismountExe;
        end;
      end;

    arPostDismount:
      begin
        exeFullCmdLine := gSettings.OptPostDismountExe;
      end;

  else
    begin
      if not(isEmergency) then begin
        SDUMessageDlg(_('Unknown autorun type?!'), mtError);
      end;
    end;

  end;

  if (exeFullCmdLine <> '') then begin
    // Split up, in case user is using a commandline with spaces in the
    // executable path
    splitCmdLine                 := TStringList.Create();
    try
      splitCmdLine.QuoteChar     := '"';
      splitCmdLine.Delimiter     := ' ';
      splitCmdLine.DelimitedText := trim(exeFullCmdLine);

      // Relative path with mounted drive letter
      if ((autorun = arPostMount) or (autorun = arPreDismount)) then begin
        splitCmdLine[0] := driveLetter + ':' + splitCmdLine[0];
      end;

      exeOnly           := splitCmdLine[0];
      splitCmdLine.Delete(0);
      // Recombine to produce new commandline
      exeParams         := splitCmdLine.DelimitedText;

    finally
        splitCmdLine.Free();
    end;

    // Perform substitution, if needed
    exeParams := StringReplace(exeParams, AUTORUN_SUBSTITUTE_DRIVE,
      // Cast to prevent compiler warning
      Char(driveLetter), [rfReplaceAll]);


    // NOTE: THIS MUST BE UPDATED IF CMDLINE IS TO SUPPORT COMMAND LINE
    // PARAMETERS!
    if not(FileExists(exeOnly)) then begin
      if (not(isEmergency) and gSettings.OptPrePostExeWarn) then begin
        SDUMessageDlg(
          Format(_('Unable to locate %s executable:'),
          [AUTORUN_TITLE[autorun]]) + SDUCRLF + SDUCRLF + exeOnly,
          mtWarning
          );
      end;
    end else begin
      if (autorun = arPreDismount) then begin
        // Launch and block until terminated...
        launchOK := (SDUWinExecAndWait32(exeFullCmdLine, SW_SHOW,
          ExtractFilePath(exeOnly)) <> EXEC_FAIL_CODE);
      end else begin
        // Fire and forget...
        launchOK := SDUWinExecNoWait32(exeOnly, exeParams, SW_RESTORE);
      end;

      if not(launchOK) then begin
        if not(isEmergency) then begin
          SDUMessageDlg(
            Format(_('Error running %s executable:'),
            [AUTORUN_TITLE[autorun]]) + SDUCRLF + SDUCRLF + exeFullCmdLine,
            mtError
            );
        end;
      end;
    end;
  end;

end;


procedure TfrmCommonMain.actFreeOTFENewExecute(Sender: TObject);
begin
  // Do nothing; method still required here in order that the actionItem isn't
  // automatically disabled because it does nothing
end;

procedure TfrmCommonMain.actInstallOnUSBDriveExecute(Sender: TObject);
var
  dlg: TfrmInstallOnUSBDrive;
begin
  dlg := TfrmInstallOnUSBDrive.Create(nil);
  try
      dlg.ShowModal();
  finally
      dlg.Free();
  end;

end;

procedure TfrmCommonMain.actFreeOTFEMountFileExecute(Sender: TObject);
begin
  if GetFreeOTFEBase().WarnIfNoHashOrCypherDrivers() then begin
    SDUOpenSaveDialogSetup(OpenDialog, '');
    FreeOTFEGUISetupOpenSaveDialog(OpenDialog);
    assert(OpenDialog <> nil);
    OpenDialog.Filter     := FILE_FILTER_FLT_VOLUMES;
    OpenDialog.DefaultExt := FILE_FILTER_DFLT_VOLUMES;
    OpenDialog.Options    := OpenDialog.Options - [ofAllowMultiSelect];

    if OpenDialog.Execute() then begin
      MountFilesDetectLUKS(
        OpenDialog.filename,
        ((ofReadOnly in OpenDialog.Options) or FileIsReadOnly(
        OpenDialog.filename) // Only bother checking the first files
        ),
        ftFreeOTFE
        );
    end;
  end;

end;

// creates plain dmcrypt vol
procedure TfrmCommonMain.actNewPlainLinuxExecute(Sender: TObject);
var
  filename: string;
begin
  // create empty file
  if GetFreeOTFEBase().CreatePlainLinuxVolumeWizard(filename) then begin
    SDUMessageDlg(
      _('Linux container created successfully.') + SDUCRLF + SDUCRLF +
      _('Now mount and format this container before use.'),
      mtInformation);
    { TODO 1 -otdk -cenhance : wipe volume first }
    // create enc vol
    MountFiles(
      ftLinux, filename,
      False, True);
  end else begin
    if (GetFreeOTFEBase().LastErrorCode <> OTFE_ERR_USER_CANCEL) then begin
      SDUMessageDlg(_('Linux container could not be created'), mtError);
    end;
  end;


end;

procedure TfrmCommonMain.actListHashesExecute(Sender: TObject);
var
  dlg: TfrmGridReport_Hash;
begin
  dlg := TfrmGridReport_Hash.Create(self);
  try
      dlg.ShowModal();
  finally
      dlg.Free();
  end;

end;

procedure TfrmCommonMain.actListCyphersExecute(Sender: TObject);
var
  dlg: TfrmGridReport_Cypher;
begin
  dlg := TfrmGridReport_Cypher.Create(self);
  try
      dlg.ShowModal();
  finally
      dlg.Free();
  end;

end;


procedure TfrmCommonMain.LinuxMountFile(forceHidden: Boolean);
begin
  if GetFreeOTFEBase().WarnIfNoHashOrCypherDrivers() then begin
    SDUOpenSaveDialogSetup(OpenDialog, '');
    FreeOTFEGUISetupOpenSaveDialog(OpenDialog);

    OpenDialog.Filter     := FILE_FILTER_FLT_VOLUMES;
    OpenDialog.DefaultExt := FILE_FILTER_DFLT_VOLUMES;
    OpenDialog.Options    := OpenDialog.Options - [ofAllowMultiSelect];
    if OpenDialog.Execute() then begin
      MountFiles(
        ftLinux,
        OpenDialog.filename,
        ((ofReadOnly in OpenDialog.Options) or FileIsReadOnly(
        OpenDialog.filename) // Only bother checking the first files
        ), forceHidden
        );
    end;
  end;

end;

procedure TfrmCommonMain.actLinuxMountFileExecute(Sender: TObject);
begin
  LinuxMountFile(False);
end;

procedure TfrmCommonMain.actMountHiddenExecute(Sender: TObject);
begin
  LinuxMountFile(True);
end;

procedure TfrmCommonMain.actPKCS11TokenManagementExecute(Sender: TObject);
begin
  GetFreeOTFEBase().ShowPKCS11ManagementDlg();
end;

procedure TfrmCommonMain.actRefreshExecute(Sender: TObject);
begin
  // Do nothing in back class - dummy method required to create event for use
  // with multimedia key component to call
end;

procedure TfrmCommonMain.actFullTestExecute(Sender: TObject);
begin
  inherited;
  DoFullTests(); // abstract
end;

procedure TfrmCommonMain.aLuksTestExecute(Sender: TObject);
begin
  inherited;
  DoLuksTests(); // abstract
end;

procedure TfrmCommonMain.actExitExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmCommonMain.actUserGuideExecute(Sender: TObject);
var
  cwd:       string;
  userGuide: string;
begin
  // Determine full path to local userguide
  cwd := ParamStr(0);
  cwd := ExtractFilePath(cwd);

  {$IFDEF DEBUG}
  // browse in dev directory, from bin\PC\Debug\Win32\ to root
  cwd       := cwd + '..\..\..\..';
  {$ENDIF}
  userGuide := cwd + '\' + USERGUIDE_LOCAL;

  // If local userguide doens't exist, fallback to online version...
  if not(FileExists(userGuide)) then begin
    userGuide := URL_USERGUIDE;

    if not(SDUConfirmYN
      (_('This requires a connection to the internet. Continue?'))) then
      exit;

  end;

  // Open HTML userguide
  ShellExecute(
    self.Handle,
    PChar('open'),
    PChar(userGuide),
    PChar(''),
    PChar(''),
    SW_SHOW
    );

end;


{$IFDEF VER180}
{$IFNDEF VER185}

// Vista fix for Delphi 2006 only
procedure TfrmCommonMain.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if SDUOSVistaOrLater() then
  begin
    Params.ExStyle := Params.ExStyle and not WS_EX_TOOLWINDOW or
      WS_EX_APPWINDOW;
  end;

end;
{$ENDIF}
{$ENDIF}

{$IFDEF VER180}
{$IFNDEF VER185}

// Vista fix for Delphi 2006 only
procedure TfrmCommonMain.WMSyscommand(var Message: TWmSysCommand);
begin
  if not(SDUOSVistaOrLater()) then begin
    inherited;
  end else begin
    case (message.CmdType and $FFF0) of
      SC_MINIMIZE:
        begin
          ShowWindow(Handle, SW_MINIMIZE);
          message.Result := 0;
        end;

      SC_RESTORE:
        begin
          ShowWindow(Handle, SW_RESTORE);
          message.Result := 0;
        end;

    else
      begin
        inherited;
      end;

    end;
  end;

end;
{$ENDIF}
{$ENDIF}


procedure TfrmCommonMain.SetupPKCS11(suppressMsgs: Boolean);
var
  tmpPKCS11Lib: TPKCS11Library;
begin
  ShutdownPKCS11();

  tmpPKCS11Lib := nil;
  if (gSettings.OptPKCS11Enable and (gSettings.OptPKCS11Library <> '')) then
  begin
    try
      tmpPKCS11Lib   := TPKCS11Library.Create(gSettings.OptPKCS11Library);
      tmpPKCS11Lib.OnSlotEvent := PKCS11SlotEvent;
      tmpPKCS11Lib.Initialize();
      fPkcs11Library := tmpPKCS11Lib;
      GetFreeOTFEBase().PKCS11Library := fPkcs11Library;
    except
      on E: Exception do begin
        if not(suppressMsgs) then begin
          SDUMessageDlg(
            _('Unable to initialize PKCS#11 support:') + SDUCRLF + SDUCRLF +
            E.Message,
            mtError
            );
        end;

        if (tmpPKCS11Lib <> nil) then begin
          tmpPKCS11Lib.Free();
        end;
      end;
    end;

  end;

end;

procedure TfrmCommonMain.ShutdownPKCS11();
begin
  // Sanity; strip from FreeOTFE copmponent
  GetFreeOTFEBase().PKCS11Library := nil;

  if (fPkcs11Library <> nil) then begin
    try
      fPkcs11Library.Finalize();
      fPkcs11Library.Free();
    except
      on E: Exception do
        // Just swallow it - if there's a problem, there's nothing we can do
        // about it
    end;
  end;

  fPkcs11Library := nil;
end;


procedure TfrmCommonMain.PKCS11TokenInserted(SlotID: Integer);
var
  // tmpFilename:   TStringList;
  mountNameOnly: string;
begin
  SetStatusBarText(Format(_('Detected insertion of token into slot ID: %u'),
    [SlotID]));
  if gSettings.OptPKCS11AutoMount then begin
    // Attempt automount...
    // tmpFilename := TStringList.Create;
    // try
    // tmpFilename.Add(gSettings.OptPKCS11AutoMountVolume);
    mountNameOnly := ExtractFilename(gSettings.OptPKCS11AutoMountVolume);
    SetStatusBarText(Format(_('Automounting: %s'), [mountNameOnly]));
    MountFilesDetectLUKS(
      gSettings.OptPKCS11AutoMountVolume,
      False,
      {$IFDEF FREEOTFE_MAIN}
      gSettings.OptDragDropFileType
      {$ENDIF}
      {$IFDEF FREEOTFE_EXPLORER}
      ftPrompt // lplp
      {$ENDIF}
      );
    // finally
    // tmpFilename.Free();
    // end;

  end;

end;

procedure TfrmCommonMain.PKCS11SlotEvent(Sender: TObject; SlotID: Integer);
var
  lib:  TPKCS11Library;
  slot: TPKCS11Slot;
begin
  // Sanity check; we can't do anything if FreeOTFE component's not available
  if GetFreeOTFEBase().Active then begin
    SetStatusBarText(Format(_('Slot event on slot ID: %d'), [SlotID]));

    lib  := TPKCS11Library(Sender);
    slot := lib.SlotByID[SlotID];
    if (slot = nil) then begin
      // Assume token removed, and the PKCS#11 driver dynamically removes the
      // slot when that happens
      PKCS11TokenRemoved(SlotID);
    end else begin
      if slot.TokenPresent then begin
        PKCS11TokenInserted(SlotID);
      end else begin
        PKCS11TokenRemoved(SlotID);
      end;
    end;

  end;
end;

procedure TfrmCommonMain.StartupUpdateCheck();
var
  nextCheck: TDate;
  doCheck:   Boolean;
begin
  doCheck     := False; // fix warning
  nextCheck   := 0;     // fix warning
  case gSettings.OptUpdateChkFrequency of
    ufNever:
      doCheck := False;
    // for ufRandom - check once per 1000 calls
    ufRandom:
      doCheck := Random(1000) = 123;
    ufAlways:
      doCheck := True;

    ufWeekly:
      // Simply add on 7 days
      nextCheck := gSettings.OptUpdateChkLastChecked + 7;

    ufMonthly:
      // Add on the number of days in the month it was last checked
      nextCheck := gSettings.OptUpdateChkLastChecked +
        DaysInMonth(gSettings.OptUpdateChkLastChecked);

    ufAnnually:
      nextCheck := gSettings.OptUpdateChkLastChecked +
        DaysInYear(gSettings.OptUpdateChkLastChecked);
  else begin
      assert(False, 'UPDATE TfrmCommonMain.StartupUpdateCheck');
      doCheck := True;
    end;
  end;

  if gSettings.OptUpdateChkFrequency in [ufMonthly, ufAnnually, ufWeekly] then
    doCheck := nextCheck <= Now();

  if doCheck then begin
    CheckForUpdates_AutoCheck(
      URL_PADFILE,
      gSettings.OptUpdateChkFrequency,
      gSettings.OptUpdateChkLastChecked,
      gSettings.OptUpdateChkSuppressNotifyVerMajor,
      gSettings.OptUpdateChkSuppressNotifyVerMinor
      );
    // Save any changes to the auto check for updates settings (eg check date)...
    gSettings.Save();
  end;
end;

procedure TfrmCommonMain.actCheckForUpdatesExecute(Sender: TObject);
begin
  CheckForUpdates_UserCheck(URL_PADFILE);
end;

procedure TfrmCommonMain.WMUserPostShow(var msg: TWMEndSession);
begin
  if not fwmUserPostShowCalledAlready then
    StartupUpdateCheck();

  fwmUserPostShowCalledAlready := True;
end;

procedure TfrmCommonMain.InitApp();
begin
  finitAppCalled := True;
end;

function TfrmCommonMain.EnsureOTFEComponentActive(): Boolean;
begin
  Result   := True;
  if not GetFreeOTFEBase().Active then
    Result := ActivateFreeOTFEComponent(True);
end;


function TfrmCommonMain.HandleCommandLineOpts_EnableDevMenu(): eCmdLine_Exit;
begin
  Result             := ceSUCCESS;
  fFuncTestPending   := False;
  if SDUCommandLineSwitch(CMDLINE_ENABLE_DEV_MENU) then begin
    miDev.Visible    := True;
    fFuncTestPending := True;
  end;
end;

// Handle "/mount" command line
// Returns: Exit code
function TfrmCommonMain.HandleCommandLineOpts_Mount(): eCmdLine_Exit;
var
  volume:                VolumeFilenameString;
  ReadOnly:              Boolean;
  mountAs:               DriveLetterString;
  fileOK:                Boolean;
  {$IFDEF FREEOTFE_MAIN}
  useDriveLetter:        string;
  {$ENDIF}
  useKeyfile:            KeyFilenameString;
  useKeyfileIsASCII:     Boolean;
  useKeyfileNewlineType: TSDUNewline;
  useLESFile:            FilenameString;
  usePassword:           TSDUBytes;
  strUsePassword:        string;
  useSilent:             Boolean;
  strTemp:               string;
  useOffset:             ULONGLONG;
  useNoCDBAtOffset:      Boolean;
  useSaltLength:         Integer;
  useKeyIterations:      Integer;
  tmpNewlineType:        TSDUNewline;
  currParamOK:           Boolean;
begin
  Result   := ceSUCCESS;

  if SDUCommandLineSwitch(CMDLINE_MOUNT) then begin
    Result := ceINVALID_CMDLINE;

    if SDUCommandLineParameter(CMDLINE_VOLUME, volume) then begin
      if not(EnsureOTFEComponentActive) then begin
        Result := ceUNABLE_TO_CONNECT;
      end else begin
        Result := ceINVALID_CMDLINE;
        fileOK := True;

        SetupOTFEComponent();

        readonly         := SDUCommandLineSwitch(CMDLINE_READONLY);
        { TODO 1 -otdk -cbug : warn user if not ansi password }
        if not(SDUCommandLineParameter(CMDLINE_PASSWORD, strUsePassword)) then
          strUsePassword := '';

        usePassword      := SDUStringToSDUBytes(strUsePassword);
        useSilent        := SDUCommandLineSwitch(CMDLINE_SILENT);

        useOffset        := 0;
        if SDUCommandLineParameter(CMDLINE_OFFSET, strTemp) then
          fileOK         := SDUParseUnitsAsBytesUnits(strTemp, useOffset);

        useNoCDBAtOffset := SDUCommandLineSwitch(CMDLINE_NOCDBATOFFSET);

        useSaltLength    := DEFAULT_SALT_LENGTH;
        if SDUCommandLineParameter(CMDLINE_SALTLENGTH, strTemp) then
          fileOK         := TryStrToInt(strTemp, useSaltLength);

        useKeyIterations := DEFAULT_KEY_ITERATIONS;
        if SDUCommandLineParameter(CMDLINE_KEYITERATIONS, strTemp) then
          fileOK         := TryStrToInt(strTemp, useKeyIterations);


        {$IFDEF FREEOTFE_MAIN}
        if SDUCommandLineParameter(CMDLINE_DRIVE, useDriveLetter) then begin
          if (length(useDriveLetter) = 0) then
            fileOK                           := False
          else
            GetFreeOTFE().DefaultDriveLetter := (uppercase(useDriveLetter))[1];

        end;
        {$ENDIF}
        useKeyfile     := '';
        if SDUCommandLineParameter(CMDLINE_KEYFILE, useKeyfile) then begin
          if (length(useKeyfile) = 0) then begin
            fileOK     := False;
          end else begin
            useKeyfile := SDURelativePathToAbsolute(useKeyfile);
            if not(FileExists(useKeyfile)) then begin
              Result   := ceFILE_NOT_FOUND;
              fileOK   := False;
            end;
          end;
        end;

        // Flag for Linux keyfiles containing ASCII passwords
        useKeyfileIsASCII     := SDUCommandLineSwitch(CMDLINE_KEYFILEISASCII);

        // Setting for newlines where Linux keyfiles contain ASCII passwords
        useKeyfileNewlineType := LINUX_KEYFILE_DEFAULT_NEWLINE;
        if SDUCommandLineParameter(CMDLINE_KEYFILENEWLINE, strTemp) then begin
          currParamOK         := False;
          for tmpNewlineType  := low(tmpNewlineType) to high(tmpNewlineType) do
          begin
            if (uppercase(strTemp) = uppercase(SDUNEWLINE_TITLE[tmpNewlineType]))
            then begin
              useKeyfileNewlineType := tmpNewlineType;
              currParamOK           := True;
              break;
            end;
          end;

          if not(currParamOK) then begin
            Result := ceINVALID_CMDLINE;
            fileOK := False;
          end;
        end;


        useLESFile     := '';
        if SDUCommandLineParameter(CMDLINE_LESFILE, useLESFile) then begin
          if (length(useLESFile) = 0) then begin
            fileOK     := False;
          end else begin
            useLESFile := SDURelativePathToAbsolute(useLESFile);
            if not(FileExists(useLESFile)) then begin
              Result   := ceFILE_NOT_FOUND;
              fileOK   := False;
            end;
          end;
        end;

        // Convert any relative path to absolute, based on CWD - but not if a
        // device passed through!
        if (Pos(uppercase(DEVICE_PREFIX), uppercase(volume)) <= 0) then begin
          volume   := SDURelativePathToAbsolute(volume);
          if not(FileExists(volume)) then begin
            Result := ceFILE_NOT_FOUND;
            fileOK := False;
          end;
        end;

        if fileOK then begin
          if SDUCommandLineSwitch(CMDLINE_FREEOTFE) then begin
            mountAs := GetFreeOTFEBase().MountFreeOTFE(volume, readonly,
              useKeyfile, usePassword, useOffset, useNoCDBAtOffset, useSilent,
              useSaltLength, useKeyIterations);
          end
          else
            if SDUCommandLineSwitch(CMDLINE_LINUX) then begin
              mountAs := GetFreeOTFEBase().MountLinux(volume, readonly,
                useLESFile,
                usePassword, useKeyfile, useKeyfileIsASCII,
                useKeyfileNewlineType,
                useOffset, useSilent);
            end
            else
              if (useLESFile <> '') then begin
                mountAs := GetFreeOTFEBase().MountLinux(volume, readonly,
                  useLESFile,
                  usePassword, useKeyfile, useKeyfileIsASCII,
                  useKeyfileNewlineType,
                  useOffset, useSilent);
              end
              else
                if (useKeyfile <> '') then begin
                  // If a keyfile was specified, we assume it's a FreeOTFE volume
                  // (Strictly speaking, it could be a LUKS volume, but...)
                  { TODO -otdk -c1 : bug - allow keyfiles & LUKS }
                  mountAs := GetFreeOTFEBase().MountFreeOTFE(volume, readonly,
                    useKeyfile, usePassword, useOffset, useNoCDBAtOffset,
                    useSilent,
                    useSaltLength, useKeyIterations);
                end
                else
                  if (gSettings.OptDragDropFileType = ftFreeOTFE) then begin
                    mountAs := GetFreeOTFEBase().MountFreeOTFE(volume, readonly,
                      useKeyfile, usePassword, useOffset, useNoCDBAtOffset,
                      useSilent,
                      useSaltLength, useKeyIterations);
                  end
                  else
                    if (gSettings.OptDragDropFileType = ftLinux) then begin
                      mountAs := GetFreeOTFEBase().MountLinux(volume, readonly,
                        useLESFile,
                        usePassword, useKeyfile, useKeyfileIsASCII,
                        useKeyfileNewlineType,
                        useOffset, useSilent);
                    end else begin
                      mountAs := GetFreeOTFEBase().Mount(volume, readonly);
                    end;
          Result              := ceSUCCESS;
          if (mountAs = #0) then
            Result            := ceUNABLE_TO_MOUNT;

        end;
      end;
    end;
  end;
end;

procedure TfrmCommonMain.SetStatusBarToHint(Sender: TObject);
var
  showHint:       string;
  statusBarShown: Boolean;
begin
  statusBarShown := (StatusBar_Hint.Visible or StatusBar_Status.Visible);

  // Note: GetLongHint(...) returns '' if there's no hint
  showHint       := GetLongHint(Application.Hint);

  if (showHint <> '') then begin
    // If a hint is to be shown, display statusbar with single panel that has
    // no bevel
    // Note: To so this, we have to use a second statusbar, to prevent messing
    // with the "standard" statusbar's panels
    // We can't use SimpleText for this, as that has a bevel on the
    // single panel
    StatusBar_Status.Visible      := False;
    StatusBar_Hint.Visible        := statusBarShown;
    StatusBar_Hint.panels[0].Text := showHint;
  end else begin
    // If no hint is to be shown, display "standard" statusbar with multiple panels
    StatusBar_Status.Visible      := statusBarShown;
    StatusBar_Hint.Visible        := False;
    StatusBar_Hint.panels[0].Text := '';
  end;

end;


end.
