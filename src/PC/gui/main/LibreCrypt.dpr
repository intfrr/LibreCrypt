program LibreCrypt;

 {
 layers used are:
 //delphi and 3rd party libs - layer 0
  //sdu & LibreCrypt utils - layer 1
   // LibreCrypt forms - layer 2
    //main form - layer 3
  }

uses
  FastMM4,
  Forms,
  Windows,
  SysUtils,
  Dialogs,
  frmMain in 'frmMain.pas' {frmMain},
  frmVolProperties in 'frmVolProperties.pas' {frmFreeOTFEVolProperties},
  frmSelectOverwriteMethod in 'frmSelectOverwriteMethod.pas' {frmFreeOTFESelectOverwriteMethod},
  CommonfrmCDBBackupRestore in '..\common\CommonfrmCDBBackupRestore.pas' {frmCDBBackupRestore},
  CommonSettings in '..\common\CommonSettings.pas',
  frmCommonOptions in '..\common\frmCommonOptions.pas' {frmOptions},
  CommonfrmGridReport in '..\common\CommonfrmGridReport.pas' {frmGridReport},
  CommonfrmGridReport_Hash in '..\common\CommonfrmGridReport_Hash.pas' {frmGridReport_Hash},
  CommonfrmGridReport_Cypher in '..\common\CommonfrmGridReport_Cypher.pas' {frmGridReport_Cypher},
  fmeBaseOptions in '..\common\fmeBaseOptions.pas' {fmeOptions_Base: TFrame},
  fmeSystemTrayOptions in 'fmeSystemTrayOptions.pas' {fmeOptions_SystemTray: TFrame},
  fmeHotKeysOptions in 'fmeHotKeysOptions.pas' {fmeOptions_Hotkeys: TFrame},
  CommonfmeOptions_PKCS11 in '..\common\CommonfmeOptions_PKCS11.pas' {fmeOptions_PKCS11: TFrame},
  fmeGeneralOptions in 'fmeGeneralOptions.pas' {fmeOptions_FreeOTFEGeneral: TFrame},
  CommonfrmInstallOnUSBDrive in '..\common\CommonfrmInstallOnUSBDrive.pas' {frmInstallOnUSBDrive},
  frmAbout in '..\common\frmAbout.pas' {frmAbout},
  MainSettings in 'MainSettings.pas',
  frmOptions in 'frmOptions.pas' {frmOptions_FreeOTFE},
  fmeLcOptions in 'fmeLcOptions.pas' {fmeFreeOTFEOptions_Base: TFrame},
  fmeAdvancedOptions in 'fmeAdvancedOptions.pas' {fmeOptions_FreeOTFEAdvanced: TFrame},
  CommonConsts in '..\common\CommonConsts.pas',
  CommonfrmCDBDump_LUKS in '..\common\CommonfrmCDBDump_LUKS.pas' {frmCDBDump_LUKS},
  CommonfrmCDBDump_Base in '..\common\CommonfrmCDBDump_Base.pas' {frmCDBDump_Base},
  CommonfrmCDBDump_FreeOTFE in '..\common\CommonfrmCDBDump_FreeOTFE.pas' {frmCDBDump_FreeOTFE},
  SDUForms in '..\common\SDUForms.pas' {SDUForm},
  SDUFrames in '..\common\SDUFrames.pas' {SDUFrame: TFrame},
  SDPartitionImage in '..\common\Filesystem\SDPartitionImage.pas',
  SDPartitionImage_File in '..\common\Filesystem\SDPartitionImage_File.pas',
  SDUProgressDlg in '..\common\SDeanUtils\SDUProgressDlg.pas' {SDUProgressDialog},
  SDUDiskPropertiesDlg in '..\common\SDeanUtils\SDUDiskPropertiesDlg.pas' {SDUDiskPropertiesDialog},
  SDUFilenameEdit_U in '..\common\SDeanUtils\SDUFilenameEdit_U.pas' {SDUFilenameEdit: TFrame},
  SDUPartitionPropertiesDlg in '..\common\SDeanUtils\SDUPartitionPropertiesDlg.pas' {SDUPartitionPropertiesDialog},
  SDUMRUList in '..\common\SDeanUtils\SDUMRUList.pas',
  SDURegistry in '..\common\SDeanUtils\SDURegistry.pas',
  SDUi18n in '..\common\SDeanUtils\SDUi18n.pas',
  gnugettext in 'P:\tools\gnugettext.pas',
  SDUGeneral in '..\common\SDeanUtils\SDUGeneral.pas',
  SDFilesystem in '..\common\Filesystem\SDFilesystem.pas',
  SDFilesystem_FAT in '..\common\Filesystem\SDFilesystem_FAT.pas',
  fmeAutorunOptions in '..\common\fmeAutorunOptions.pas' {fmeOptions_Autorun: TFrame},
  FreeOTFEDLLCypherAPI in '..\common\OTFE\OTFEFreeOTFE\FreeOTFEDLLCypherAPI.pas',
  FreeOTFEDLLHashAPI in '..\common\OTFE\OTFEFreeOTFE\FreeOTFEDLLHashAPI.pas',
  FreeOTFEDLLMainAPI in '..\common\OTFE\OTFEFreeOTFE\FreeOTFEDLLMainAPI.pas',
  frmKeyEntryFreeOTFE in '..\common\OTFE\OTFEFreeOTFE\frmKeyEntryFreeOTFE.pas' {frmKeyEntryFreeOTFE},
  frmKeyEntryLinux in '..\common\OTFE\OTFEFreeOTFE\frmKeyEntryLinux.pas' {frmKeyEntryPlainLinux},
  frmKeyEntryLUKS in '..\common\OTFE\OTFEFreeOTFE\frmKeyEntryLUKS.pas' {frmKeyEntryLUKS},
  frmWizard in '..\common\OTFE\OTFEFreeOTFE\frmWizard.pas' {frmWizard},
  SDURandPool in '..\common\OTFE\SDURandPool.pas',
  OTFEFreeOTFEBase_U in '..\common\OTFE\OTFEFreeOTFEBase_U.pas',
  fmeVolumeSelect in '..\common\OTFE\OTFEFreeOTFE\fmeVolumeSelect.pas',
  SDUObjectManager in '..\common\SDeanUtils\SDUObjectManager.pas',
  fmePKCS11_MgrBase in '..\common\OTFE\OTFEFreeOTFE\fmePKCS11_MgrBase.pas' {fmePKCS11_MgrBase: TFrame},
  fmePKCS11_MgrKeyfile in '..\common\OTFE\OTFEFreeOTFE\fmePKCS11_MgrKeyfile.pas' {fmePKCS11_MgrKeyfile: TFrame},
  fmePKCS11_MgrSecretKey in '..\common\OTFE\OTFEFreeOTFE\fmePKCS11_MgrSecretKey.pas' {fmePKCS11_MgrSecretKey: TFrame},
  frmHashInfo in '..\common\OTFE\OTFEFreeOTFE\frmHashInfo.pas' {frmHashInfo},
  MouseRNGCaptureDlg_U in '..\common\SDeanSecurity\MouseRNGDialog\MouseRNGCaptureDlg_U.pas' {MouseRNGCaptureDlg},
  MouseRNGDialog_U in '..\common\SDeanSecurity\MouseRNGDialog\MouseRNGDialog_U.pas',
  frmSelectVolumeAndOffset in '..\common\OTFE\OTFEFreeOTFE\frmSelectVolumeAndOffset.pas' {frmSelectVolumeFileAndOffset},
  SDUEndianIntegers in '..\common\SDeanUtils\SDUEndianIntegers.pas',
  DbugIntf in 'C:\Program Files (x86)\GExperts for RAD Studio XE2\DbugIntf.pas',
  OTFE_U in '..\common\OTFE\OTFE\OTFE_U.pas',
  SDUWinHTTP in '..\common\SDeanUtils\SDUWinHTTP.pas',
  SDUWinHttp_API in '..\common\SDeanUtils\SDUWinHttp_API.pas',
  MSCryptoAPI in '..\common\SDeanSecurity\MSCryptoAPI\MSCryptoAPI.pas',
  pkcs11_library in '..\common\SDeanSecurity\PKCS#11\pkcs11_library.pas',
  pkcs11_slot in '..\common\SDeanSecurity\PKCS#11\pkcs11_slot.pas',
  pkcs11t in '..\common\SDeanSecurity\PKCS#11\pkcs11t.pas',
  pkcs11_api in '..\common\SDeanSecurity\PKCS#11\pkcs11_api.pas',
  pkcs11_token in '..\common\SDeanSecurity\PKCS#11\pkcs11_token.pas',
  pkcs11f in '..\common\SDeanSecurity\PKCS#11\pkcs11f.pas',
  pkcs11_session in '..\common\SDeanSecurity\PKCS#11\pkcs11_session.pas',
  pkcs11_slot_event_thread in '..\common\SDeanSecurity\PKCS#11\pkcs11_slot_event_thread.pas',
  pkcs11_mechanism in '..\common\SDeanSecurity\PKCS#11\pkcs11_mechanism.pas',
  pkcs11_attribute in '..\common\SDeanSecurity\PKCS#11\pkcs11_attribute.pas',
  pkcs11_object in '..\common\SDeanSecurity\PKCS#11\pkcs11_object.pas',
  PKCS11KnownLibs in '..\common\SDeanSecurity\PKCS#11\PKCS11KnownLibs.pas',
  PKCS11LibrarySelectDlg in '..\common\SDeanSecurity\PKCS#11\PKCS11LibrarySelectDlg.pas' {PKCS11LibrarySelectDialog},
  OTFEFreeOTFE_U in '..\common\OTFE\OTFEFreeOTFE\OTFEFreeOTFE_U.pas',
  DriverAPI in '..\common\OTFE\OTFEFreeOTFE\DriverAPI.pas',
  frmVersionCheck in '..\common\frmVersionCheck.pas' {frmVersionCheck},
  fmeNewPassword in '..\common\fmeNewPassword.pas' {frmeNewPassword: TFrame},
  fmeLUKSKeyOrKeyfileEntry in '..\common\OTFE\OTFEFreeOTFE\fmeLUKSKeyOrKeyfileEntry.pas' {frmeLUKSKeyOrKeyfileEntry: TFrame},
  lcConsts in '..\common\lcConsts.pas',
  frmWizardCreateVolume in '..\common\OTFE\OTFEFreeOTFE\frmWizardCreateVolume.pas' {frmWizardCreateVolume},
  frmCommonMain in '..\common\frmCommonMain.pas' {frmCommonMain},
  frmWizardChangePasswordCreateKeyfile in '..\common\OTFE\OTFEFreeOTFE\frmWizardChangePasswordCreateKeyfile.pas' {frmWizardChangePasswordCreateKeyfile},
  fmeSelectPartition in '..\common\OTFE\OTFEFreeOTFE\fmeSelectPartition.pas',
  fmeDiskPartitionsPanel in '..\common\OTFE\OTFEFreeOTFE\fmeDiskPartitionsPanel.pas',
  fmeSDUDiskPartitions in '..\common\SDeanUtils\fmeSDUDiskPartitions.pas',
  fmeSDUBlocks in '..\common\SDeanUtils\fmeSDUBlocks.pas',
  cryptlib in '..\common\OTFE\OTFEFreeOTFE\cryptlib.pas',
  SDUSysUtils in '..\common\SDeanUtils\SDUSysUtils.pas',
  OTFEConsts_U in '..\common\OTFE\OTFE\OTFEConsts_U.pas';

{$R *.RES}

var
  otherRunningAppWindow: THandle;
  CommandLineOnly:       Boolean;
  cmdExitCode:           eCmdLine_Exit;
  settingsFilename:      String;
{$IF CompilerVersion >= 18.5}
  // Delphi 7 doesn't need this, but Delphi 2007 (and 2006 as well? Not
  // checked...) need this to honor any "Run minimised" option set in any
  // launching MS Windows shortcut
  sui:                   TStartUpInfo;
{$IFEND}

begin
  GLOBAL_VAR_WM_FREEOTFE_RESTORE := RegisterWindowMessage('FREEOTFE_RESTORE');
  GLOBAL_VAR_WM_FREEOTFE_REFRESH := RegisterWindowMessage('FREEOTFE_REFRESH');

{$IFNDEF AlwaysClearFreedMemory}
  // #error - this needs to be set to clear down any freed memory
 {$ENDIF}
{$IFDEF DEBUG}
  System.ReportMemoryLeaksOnShutdown := true;
{$ELSE}
  // this doesnt appear to work (built-in version only?),  so SuppressMessageBoxes set as well
  System.ReportMemoryLeaksOnShutdown := False;
  FastMM4.SuppressMessageBoxes       := True;
{$ENDIF}

{ see http://sourceforge.net/p/fastmm/code/HEAD/tree/FastMM4Options.inc:
  With this option enabled freed memory will immediately be cleared inside the
  FreeMem routine. This incurs a big performance hit, but may be worthwhile for
  additional peace of mind when working with highly sensitive data. This option
  supersedes the ClearMemoryBeforeReturningToOS option.}

  Application.Initialize;

{$IF CompilerVersion >= 15.0}
  // Vista fix for Delphi 2007 and later
  Application.MainFormOnTaskbar := True;
{$IFEND}
  Application.Title             := 'LibreCrypt';
  CommandLineOnly               := False; // if error reading cmds,loading settings, default to off
  try


    MainSettings.gSettings := TMainSettings.Create();
    try
      CommonSettings.CommonSettingsObj := MainSettings.gSettings;
      if SDUCommandLineParameter(CMDLINE_SETTINGSFILE, settingsFilename) then begin
        settingsFilename := SDURelativePathToAbsolute(settingsFilename);
        MainSettings.gSettings.CustomLocation := settingsFilename;
      end;

      MainSettings.gSettings.Load();

      Application.ShowMainForm := False;
      // NOTE: The main form's Visible property is set to FALSE anyway - it *HAS*
      // to be, otherwise it'll be displayed; dispite the following two lines
      Application.CreateForm(TfrmMain, GfrmMain);
  GfrmMain.Visible         := False;
      Application.ShowMainForm := False;

      CommandLineOnly := GfrmMain.HandleCommandLineOpts(cmdExitCode);

      //   if we were called with no command line arguments then
      //     if no running app was found then
      //       we continue to run the main app
      //     else
      //       we raise the previous application to the top
      //   else
      //     quit (ran with command line arguments)

      // if we were called with no command line arguments then
      if (not (CommandLineOnly)) then begin
        otherRunningAppWindow := SDUDetectExistingApp();
        // If no running app was found then
        if ((otherRunningAppWindow = 0) or gSettings.OptAllowMultipleInstances) then begin
          // We continue to run the main app
          GfrmMain.Visible         := True;
          Application.ShowMainForm := True;
          GfrmMain.InitApp();

{$IF CompilerVersion >= 18.5}
          // Delphi 7 doesn't need this, but Delphi 2007 (and 2006 as well? Not
          // checked...) need this to honour any "Run minimised" option set in any
          // launching MS Windows shortcut
          GetStartUpInfo(sui);
          if ((sui.dwFlags and STARTF_USESHOWWINDOW) > 0) then begin
            if (
              //              (sui.wShowWindow = SW_FORCEMINIMIZE) or
              (sui.wShowWindow = SW_HIDE) or (sui.wShowWindow = SW_MINIMIZE) or
              (sui.wShowWindow = SW_SHOWMINIMIZED) or
              (sui.wShowWindow = SW_SHOWMINNOACTIVE)) then begin
              Application.Minimize();
            end;

            // *Should* have a corresponding check for SW_MAXIMIZE / SW_SHOWMAXIMIZED
            // here, but not a priority...
          end;
{$IFEND}
          if SDUCommandLineSwitch(CMDLINE_MINIMIZE) then
            Application.Minimize();

          Application.Run;
        end else begin
          // Poke already running application
{$IF CompilerVersion >= 18.5}
          SendMessage(HWND_BROADCAST, GLOBAL_VAR_WM_FREEOTFE_RESTORE, 0, 0);
{$ELSE}
        SDUPostMessageExistingApp(GLOBAL_VAR_WM_FREEOTFE_RESTORE, 0, 0);
{$IFEND}

          // Alternativly:
          //         SetForegroundWindow(otherRunningAppWindow);
        end;
      end else begin
        // Do nothing; ran with command line arguments, already processed
      end;

    finally
      // Note: We *don't* free of the Settings object if the main form was shown;
      //       the main form is still closing down at this stage, and this causes
      //       an exception.
      //       Instead, this is free'd off in the FormDestroy(...) method
      if not (Application.ShowMainForm) then
        MainSettings.gSettings.Free();
    end;
    // only place is, or should be, catch-all exeption
  except
    on E: Exception do begin
      MessageDlg(_(
        'LibreCrypt had an internal error (a bug) and has closed. Please report this on the LibreCrypt GitHub issues page. Details:') +
        SDUCRLF + E.ClassName + {SDUCRLF+ E.StackTrace+} SDUCRLF + E.message, mtError, [mbOK], 0);
      { TODO 1 -otdk -cenhance : show stack trace - think need 3rd party }
    end;

  end;

  if (CommandLineOnly and (cmdExitCode <> ceSUCCESS)) then
    Halt(Integer(cmdExitCode)); // Note: System.ExitCode may be tested in finalization sections
end.
