[Setup]
; Basic App Info
AppName=Pulse
AppVersion=3.2.0
AppPublisher=Ashutosh Pathak
; Output Settings
DefaultDirName={autopf}\Pulse
DisableProgramGroupPage=yes
; This is where the setup.exe will be saved
OutputDir=build\installer
OutputBaseFilename=Pulse_Installer_v3.2.0
SetupIconFile=windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\pulse.exe
Compression=lzma
SolidCompression=yes
WizardStyle=modern

; Requires admin privileges to install into Program Files
PrivilegesRequired=admin

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Copy the main executable and all its required DLLs/folders
Source: "build\windows\x64\runner\Release\pulse.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; Start Menu Icon
Name: "{autoprograms}\Pulse"; Filename: "{app}\pulse.exe"
; Desktop Shortcut
Name: "{autodesktop}\Pulse"; Filename: "{app}\pulse.exe"; Tasks: desktopicon

[Run]
; Option to launch the app immediately after installing
Filename: "{app}\pulse.exe"; Description: "{cm:LaunchProgram,Pulse}"; Flags: nowait postinstall skipifsilent
