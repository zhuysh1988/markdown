

Name             : Get-Service
CommandType      : Cmdlet
Definition       : Get-Service [[-Name] <String[]>] [-ComputerName <String[]>] [-DependentServices] [-RequiredServices] [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction
                    <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>]
                   Get-Service [-ComputerName <String[]>] [-DependentServices] [-RequiredServices] -DisplayName <String[]> [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAct
                   ion <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>]
                   Get-Service [-ComputerName <String[]>] [-DependentServices] [-RequiredServices] [-Include <String[]>] [-Exclude <String[]>] [-InputObject <ServiceController[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>]
                    [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>]
                   
Path             : 
AssemblyInfo     : 
DLL              : C:\windows\assembly\GAC_MSIL\Microsoft.PowerShell.Commands.Management\1.0.0.0__31bf3856ad364e35\Microsoft.PowerShell.Commands.Management.dll
HelpFile         : Microsoft.PowerShell.Commands.Management.dll-Help.xml
ParameterSets    : {[[-Name] <String[]>] [-ComputerName <String[]>] [-DependentServices] [-RequiredServices] [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPre
                   ference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>], [-ComputerName <String[]>] [-DependentServices] [-RequiredServices] -DisplayName <String[]> [-Include <S
                   tring[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <I
                   nt32>], [-ComputerName <String[]>] [-DependentServices] [-RequiredServices] [-Include <String[]>] [-Exclude <String[]>] [-InputObject <ServiceController[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-W
                   arningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>]}
ImplementingType : Microsoft.PowerShell.Commands.GetServiceCommand
Verb             : Get
Noun             : Service

Name             : New-Service
CommandType      : Cmdlet
Definition       : New-Service [-Name] <String> [-BinaryPathName] <String> [-DisplayName <String>] [-Description <String>] [-StartupType <ServiceStartMode>] [-Credential <PSCredential>] [-DependsOn <String[]>] [-Verbose] [-Debug] [-E
                   rrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   
Path             : 
AssemblyInfo     : 
DLL              : C:\windows\assembly\GAC_MSIL\Microsoft.PowerShell.Commands.Management\1.0.0.0__31bf3856ad364e35\Microsoft.PowerShell.Commands.Management.dll
HelpFile         : Microsoft.PowerShell.Commands.Management.dll-Help.xml
ParameterSets    : {[-Name] <String> [-BinaryPathName] <String> [-DisplayName <String>] [-Description <String>] [-StartupType <ServiceStartMode>] [-Credential <PSCredential>] [-DependsOn <String[]>] [-Verbose] [-Debug] [-ErrorAction 
                   <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]}
ImplementingType : Microsoft.PowerShell.Commands.NewServiceCommand
Verb             : New
Noun             : Service

Name             : Restart-Service
CommandType      : Cmdlet
Definition       : Restart-Service [-Name] <String[]> [-Force] [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>
                   ] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   Restart-Service [-Force] [-PassThru] -DisplayName <String[]> [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <St
                   ring>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   Restart-Service [-Force] [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-InputObject <ServiceController[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-Erro
                   rVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   
Path             : 
AssemblyInfo     : 
DLL              : C:\windows\assembly\GAC_MSIL\Microsoft.PowerShell.Commands.Management\1.0.0.0__31bf3856ad364e35\Microsoft.PowerShell.Commands.Management.dll
HelpFile         : Microsoft.PowerShell.Commands.Management.dll-Help.xml
ParameterSets    : {[-Name] <String[]> [-Force] [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVari
                   able <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm], [-Force] [-PassThru] -DisplayName <String[]> [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPr
                   eference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm], [-Force] [-PassThru] [-Include <String[]>] [-E
                   xclude <String[]>] [-InputObject <ServiceController[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable 
                   <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]}
ImplementingType : Microsoft.PowerShell.Commands.RestartServiceCommand
Verb             : Restart
Noun             : Service

Name             : Resume-Service
CommandType      : Cmdlet
Definition       : Resume-Service [-Name] <String[]> [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-Warnin
                   gVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   Resume-Service [-PassThru] -DisplayName <String[]> [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-W
                   arningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   Resume-Service [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-InputObject <ServiceController[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable 
                   <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   
Path             : 
AssemblyInfo     : 
DLL              : C:\windows\assembly\GAC_MSIL\Microsoft.PowerShell.Commands.Management\1.0.0.0__31bf3856ad364e35\Microsoft.PowerShell.Commands.Management.dll
HelpFile         : Microsoft.PowerShell.Commands.Management.dll-Help.xml
ParameterSets    : {[-Name] <String[]> [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <Str
                   ing>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm], [-PassThru] -DisplayName <String[]> [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-Warni
                   ngAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm], [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-InputO
                   bject <ServiceController[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int3
                   2>] [-WhatIf] [-Confirm]}
ImplementingType : Microsoft.PowerShell.Commands.ResumeServiceCommand
Verb             : Resume
Noun             : Service

Name             : Set-Service
CommandType      : Cmdlet
Definition       : Set-Service [-Name] <String> [-ComputerName <String[]>] [-DisplayName <String>] [-Description <String>] [-StartupType <ServiceStartMode>] [-Status <String>] [-PassThru] [-Verbose] [-Debug] [-ErrorAction <ActionPref
                   erence>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   Set-Service [-ComputerName <String[]>] [-DisplayName <String>] [-Description <String>] [-StartupType <ServiceStartMode>] [-Status <String>] [-InputObject <ServiceController>] [-PassThru] [-Verbose] [-Debug] [-Error
                   Action <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   
Path             : 
AssemblyInfo     : 
DLL              : C:\windows\assembly\GAC_MSIL\Microsoft.PowerShell.Commands.Management\1.0.0.0__31bf3856ad364e35\Microsoft.PowerShell.Commands.Management.dll
HelpFile         : Microsoft.PowerShell.Commands.Management.dll-Help.xml
ParameterSets    : {[-Name] <String> [-ComputerName <String[]>] [-DisplayName <String>] [-Description <String>] [-StartupType <ServiceStartMode>] [-Status <String>] [-PassThru] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-
                   WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm], [-ComputerName <String[]>] [-DisplayName <String>] [-Descri
                   ption <String>] [-StartupType <ServiceStartMode>] [-Status <String>] [-InputObject <ServiceController>] [-PassThru] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorV
                   ariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]}
ImplementingType : Microsoft.PowerShell.Commands.SetServiceCommand
Verb             : Set
Noun             : Service

Name             : Start-Service
CommandType      : Cmdlet
Definition       : Start-Service [-Name] <String[]> [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-Warning
                   Variable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   Start-Service [-PassThru] -DisplayName <String[]> [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-Wa
                   rningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   Start-Service [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-InputObject <ServiceController[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <
                   String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   
Path             : 
AssemblyInfo     : 
DLL              : C:\windows\assembly\GAC_MSIL\Microsoft.PowerShell.Commands.Management\1.0.0.0__31bf3856ad364e35\Microsoft.PowerShell.Commands.Management.dll
HelpFile         : Microsoft.PowerShell.Commands.Management.dll-Help.xml
ParameterSets    : {[-Name] <String[]> [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <Str
                   ing>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm], [-PassThru] -DisplayName <String[]> [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-Warni
                   ngAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm], [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-InputO
                   bject <ServiceController[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int3
                   2>] [-WhatIf] [-Confirm]}
ImplementingType : Microsoft.PowerShell.Commands.StartServiceCommand
Verb             : Start
Noun             : Service

Name             : Stop-Service
CommandType      : Cmdlet
Definition       : Stop-Service [-Name] <String[]> [-Force] [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [
                   -WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   Stop-Service [-Force] [-PassThru] -DisplayName <String[]> [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <Strin
                   g>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   Stop-Service [-Force] [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-InputObject <ServiceController[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVa
                   riable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   
Path             : 
AssemblyInfo     : 
DLL              : C:\windows\assembly\GAC_MSIL\Microsoft.PowerShell.Commands.Management\1.0.0.0__31bf3856ad364e35\Microsoft.PowerShell.Commands.Management.dll
HelpFile         : Microsoft.PowerShell.Commands.Management.dll-Help.xml
ParameterSets    : {[-Name] <String[]> [-Force] [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVari
                   able <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm], [-Force] [-PassThru] -DisplayName <String[]> [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPr
                   eference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm], [-Force] [-PassThru] [-Include <String[]>] [-E
                   xclude <String[]>] [-InputObject <ServiceController[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable 
                   <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]}
ImplementingType : Microsoft.PowerShell.Commands.StopServiceCommand
Verb             : Stop
Noun             : Service

Name             : Suspend-Service
CommandType      : Cmdlet
Definition       : Suspend-Service [-Name] <String[]> [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-Warni
                   ngVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   Suspend-Service [-PassThru] -DisplayName <String[]> [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-
                   WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   Suspend-Service [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-InputObject <ServiceController[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable
                    <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm]
                   
Path             : 
AssemblyInfo     : 
DLL              : C:\windows\assembly\GAC_MSIL\Microsoft.PowerShell.Commands.Management\1.0.0.0__31bf3856ad364e35\Microsoft.PowerShell.Commands.Management.dll
HelpFile         : Microsoft.PowerShell.Commands.Management.dll-Help.xml
ParameterSets    : {[-Name] <String[]> [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <Str
                   ing>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm], [-PassThru] -DisplayName <String[]> [-Include <String[]>] [-Exclude <String[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-Warni
                   ngAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int32>] [-WhatIf] [-Confirm], [-PassThru] [-Include <String[]>] [-Exclude <String[]>] [-InputO
                   bject <ServiceController[]>] [-Verbose] [-Debug] [-ErrorAction <ActionPreference>] [-WarningAction <ActionPreference>] [-ErrorVariable <String>] [-WarningVariable <String>] [-OutVariable <String>] [-OutBuffer <Int3
                   2>] [-WhatIf] [-Confirm]}
ImplementingType : Microsoft.PowerShell.Commands.SuspendServiceCommand
Verb             : Suspend
Noun             : Service



