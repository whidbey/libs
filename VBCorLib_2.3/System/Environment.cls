VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Environment"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'    CopyRight (c) 2004 Kelly Ethridge
'
'    This file is part of VBCorLib.
'
'    VBCorLib is free software; you can redistribute it and/or modify
'    it under the terms of the GNU Library General Public License as published by
'    the Free Software Foundation; either version 2.1 of the License, or
'    (at your option) any later version.
'
'    VBCorLib is distributed in the hope that it will be useful,
'    but WITHOUT ANY WARRANTY; without even the implied warranty of
'    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'    GNU Library General Public License for more details.
'
'    You should have received a copy of the GNU Library General Public License
'    along with Foobar; if not, write to the Free Software
'    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
'
'    Module: Environment
'

''
' The Environment class provides functions for retrieving information about the local machine
'
' @remarks This class cannot be directly instantiated. In order to access the methods, use
' the class name directly.
' <pre>
' Debug.Print Environment.MachineName
' Debug.Print Environment.UserName
' </pre>
'
Option Explicit


Private Const ERR_PATHNOTFOUND              As Long = 76
Private Const MAX_COMPUTERNAME_LENGTH       As Long = 31
Private Const UNLEN                         As Long = 256
Private Const UOI_FLAGS                     As Long = 1
Private Const WSF_VISIBLE                   As Long = 1
Private Const WM_SETTINGCHANGE              As Long = &H1A
Private Const HWND_BROADCAST                As Long = &HFFFF&
Private Const SMTO_NORMAL                   As Long = &H0
Private Const ERROR_ENVVAR_NOT_FOUND        As Long = 203&


''
' This enum represents a list of folders accessible using <i>GetFolderPath</i>.
' These definitions are from the Microsoft Dot NET 1.1 MSDN Library.
'
' @param ApplicationData The directory that serves as a common repository for application-specific data for the current roaming user.
' A roaming user works on more than one computer on a network. A roaming user's profile is kept on a server on the network and is loaded onto a system when the user logs on.
' @param CommonApplicationData The directory that serves as a common repository for application-specific data that is used by all users.
' @param CommonProgramFiles The directory for components that are shared across applications.
' @param Cookies The directory that serves as a common repository for Internet cookies.
' @param Desktop The logical Desktop rather than the physical file system location.
' @param DesktopDirectory The directory used to physically store file objects on the desktop.
' Do not confuse this directory with the desktop folder itself, which is a virtual folder.
' @param Favorites The directory that serves as a common repository for the user's favorite items.
' @param History The directory that serves as a common repository for Internet history items.
' @param InternetCache The directory that serves as a common repository for temporary Internet files.
' @param LocalApplicationData The directory that serves as a common repository for application-specific data that is used by the current, non-roaming user.
' @param MyComputer The "My Computer" folder.
' @param MyMusic The "My Music" folder.
' @param MyPictures The "My Pictures" folder.
' @param Personal The directory that serves as a common repository for documents (My Documents).
' @param ProgramFiles The program files folder.
' @param Programs The directory that contains the user's program groups.
' @param Recent The directory that contains the user's most recently used documents.
' @param SendTo The directory that contains the Send To menu items.
' @param StartMenu The directory that contains the Start menu items.
' @param Startup The directory that corresponds to the user's Startup program group.
' The system starts these programs whenever a user logs on or starts Windows NT or later, or starts Windows 98.
' @param SystemDir The system directory.
' @param Templates The directory that serves as a common repository for document templates.
' @param Windows The windows directory.
'
Public Enum SpecialFolder
   ApplicationData = &H1A
   CommonApplicationData = &H23
   CommonProgramFiles = &H2B
   Cookies = &H21
   Desktop = &H0
   DesktopDirectory = &H10
   Favorites = &H6
   History = &H22
   InternetCache = &H20
   LocalApplicationData = &H1C
   MyComputer = &H11
   MyMusic = &HD
   MyPictures = &H27
   Personal = &H5
   ProgramFiles = &H26
   Programs = &H2
   Recent = &H8
   SendTo = &H9
   StartMenu = &HB
   Startup = &H7
   SystemDir = &H25
   Templates = &H15
   Windows = &H24
End Enum

''
' Used to indicate the source or destination of the
' environment variables when read from or written to the system.
'
' @param Machine The source of the variable is machine wide. These
' are variables that are defined for the system and all users.
' @param Process The source of the variable is for the current process.
' This combines both machine and user level variables, giving priority
' to the user level variables.
' @param User The source of the variable is of the current user.
' @remarks <b>Machine</b> and <b>User</b> are not supported on Windows 95, 98 or ME.
'
Public Enum EnvironmentVariableTarget
    Machine = 0
    Process = 1
    User = 2
End Enum


Private mOSVersion  As New OperatingSystem



''
' Returns the command specified when executing the current application,
' including any arguments typed after the application name.
'
' @return The command line typed in at a command prompt.
'
Public Property Get CommandLine() As String
    CommandLine = SysAllocString(GetCommandLineW)
End Property

''
' Returns the current directy of the executing application.
'
' @return The current directory.
'
Public Property Get CurrentDirectory() As String
    CurrentDirectory = Directory.GetCurrentDirectory
End Property

''
' Sets the current directory for the executing application.
'
' @param RHS The new directory to change to.
'
Public Property Let CurrentDirectory(ByVal RHS As String)
    Call Directory.SetCurrentDirectory(RHS)
End Property

''
' Returns the name of the local computer.
'
' @return The name of the local computer.
'
Public Property Get MachineName() As String
    Dim size As Long
    size = MAX_COMPUTERNAME_LENGTH + 1
    
    Dim ret As String
    ret = String$(size, 0)
    If API.GetComputerName(ret, size) = BOOL_FALSE Then _
        Throw Cor.NewInvalidOperationException(GetErrorMessage(Err.LastDllError))
    
    MachineName = Left$(ret, size)
End Property

''
' Returns string of a newline character for the local computer.
'
' @return The newline characters.
' @remarks Being this always going to be in VB, the return is just vbCrLf.
'
Public Property Get NewLine() As String
    NewLine = vbCrLf
End Property

''
' Returns an object representing the current operating system.
'
' @return The OperatingSystem object that represents the current OS.
'
Public Property Get OSVersion() As OperatingSystem
    Set OSVersion = mOSVersion
End Property

''
' Returns the System directory for the current OS.
'
' @return The system directory.
' @remarks Generally this will be C:\Windows\System32 or C:\Winnt\System32 for NT4 system.
'
Public Property Get SystemDirectory() As String
    Dim ret As String
    ret = String$(MAX_PATH + 1, 0)
    
    Dim size As Long
    size = API.GetSystemDirectory(ret, Len(ret))
    If size > 0 Then SystemDirectory = Left$(ret, size)
End Property

''
' Returns the number of milliseconds the system has been running since it started.
'
' @return Number of milliseconds since the system booted up.
' @remarks Once the maximum value is reached, it will wrap around to be negative,
' at which point negative values will be returned until 0 is reached.
' Wrapping to negative will take place in approximatively 24.85 days.
'
Public Property Get TickCount() As Long
    TickCount = timeGetTime
End Property

''
' Returns the name of the local machine within a domain
'
' @return The computer name within a domain.
' @remarks Typically the domain name is the name of the machine, but
' can change depending on the application being deployed.<br><br>
' <b>UserDomainName</b> is not supported on Windows 95, 98, ME platforms
' and will throw a <b>PlatformNotSupportedException</b> exception.
'
Public Property Get UserDomainName() As String
    Call VerifyNTMachine
    
    Dim size As Long
    size = 1024
    
    Dim Sid As String
    Sid = String$(size, 0)
    
    Dim Buf As String
    Buf = String$(size, 0)
    
    If GetUserNameEx(modWin32Api.NameSamCompatible, Buf, size) <> BOOL_FALSE Then
        Dim i As Long
        i = InStr(Buf, "\")

        If i > 0 Then
            UserDomainName = Left$(Buf, i - 1)
            Exit Property
        End If
    End If
    
    If LookupAccountName(0, StrPtr(UserName), StrPtr(Sid), Len(Sid), StrPtr(Buf), size, 0&) = BOOL_FALSE Then
        IOError Err.LastDllError
    End If
    
    UserDomainName = Left$(Buf, size)
End Property

''
' Determines if the current application is allowed to have user interaction.
'
' @return Indication if user interaction is allowed.
' @remarks This is used primarily for when the application is a service. It can
' be used to supress message dialogs and user entry when not allowed.
'
Public Property Get UserInteractive() As Boolean
    Dim hObj As Handle
    Dim Info As USEROBJECTFLAGS
    
    If OSVersion.Platform = Win32NT Then
        hObj = GetProcessWindowStation
        If GetUserObjectInformation(hObj, UOI_FLAGS, Info, LenB(Info), 0&) Then
            UserInteractive = (Info.dwFlags And WSF_VISIBLE)
        End If
    Else
        UserInteractive = True
    End If
End Property

''
' Returns the name of the currently logged in user of the local computer.
'
' @return The currently logged in user's name.
'
Public Property Get UserName() As String
    Dim size As Long
    size = UNLEN + 1
    
    Dim ret As String
    ret = String$(size, 0)
    If GetUserNameA(ret, size) <> BOOL_FALSE Then UserName = Left$(ret, size - 1)
End Property

''
' Returns the amount of physical memory the current application is allocated.
'
' @return The amount of memory allocated to the application.
' @remarks This method only works for NT installations. 95, 98, and ME will
' receive a 0 when this method is called.
'
Public Property Get WorkingSet() As Long
    If OSVersion.Platform <> Win32NT Then Exit Property
    
    Dim h As Handle
    h = GetCurrentProcess
    
    Dim Info As PROCESS_MEMORY_COUNTERS
    If GetProcessMemoryInfo(h, Info, LenB(Info)) Then
        WorkingSet = Info.WorkingSetSize
    End If
End Property

''
' Replaces environment tags within a string with the actual values.
'
' @param Name A string containing environment variable tags to be replaced.
' @return A string containing actual environment variable values in place of tags.
' @remarks The environment variables are tagged using %.
' A string such as 'My OS is %OS%.' would become 'My OS is Windows_NT.' for NT machines.
'
Public Function ExpandEnvironmentVariables(ByVal Name As String) As String
    Const DEF_SIZE As Long = 1024
    
    If Len(Name) = 0 Then Exit Function
    
    Dim Buf As String
    Buf = SysAllocStringLen(0, DEF_SIZE)
    
    Dim size As Long
    size = API.ExpandEnvironmentStrings(Name, Buf, DEF_SIZE)
    
    If size > DEF_SIZE Then
        Buf = SysAllocStringLen(0, size)
        size = API.ExpandEnvironmentStrings(Name, Buf, size)
    End If
    
    ExpandEnvironmentVariables = Left$(Buf, size - 1)
End Function

''
' Returns an array of parsed Arguments from the command line.
'
' @return An array of command line Arguments, including the application name.
' @remarks The application is the first Argument in the array. Arguments are
' separated by spaces. If spaces are embedded in an Arguments and should not
' be used to separate the Arguments, then the Arguments must be surrounded in quotes.
'
Public Function GetCommandLineArgs() As String()
    GetCommandLineArgs = ParseCommandLineArgs(CommandLine)
End Function

''
' Provides a mechanism to parse arguments from a command line string.
'
' @param Line The string to parse the arguments from.
' @return An array of arguments.
'
Public Function ParseCommandLineArgs(ByVal Line As String) As String()
    Line = Trim$(Line)
    Dim Length As Long
    Length = Len(Line)
    
    If Length = 0 Then
        ParseCommandLineArgs = Cor.NewStrings
        Exit Function
    End If
    
    Dim Arguments As New ArrayList
    
    Dim Chars() As Integer
    Chars = cString.ToCharArray(Line)
    
    Dim ArgBuffer() As Integer
    ReDim ArgBuffer(0 To Length - 1)
    
    Dim ArgIndex    As Long
    Dim Escaped     As Boolean
    Dim Quoted      As Boolean
    Dim index       As Long
    Do While index < Length
        Select Case Chars(index)
            Case vbBackSlash
                If Escaped Then
                    ' We have two back slashes in a row,
                    ' so we actually need to include them
                    ' as part of the argument.
                    ArgBuffer(ArgIndex) = vbBackSlash
                    ArgBuffer(ArgIndex + 1) = vbBackSlash
                    ArgIndex = ArgIndex + 2
                    Escaped = False
                Else
                    ' Begin the potential escape sequence.
                    ' We only support escaping double quotes.
                    Escaped = True
                End If
            
            Case vbDoubleQuote
                If Escaped Then
                    ' We are escaping a quote, so it is to
                    ' be included in the argument, but not
                    ' the backslash.
                    ArgBuffer(ArgIndex) = vbDoubleQuote
                    ArgIndex = ArgIndex + 1
                    Escaped = False
                    
                    ' We don't end a quoted argument with
                    ' an escaped quote, so let the Quoted
                    ' flag remain as is.
                    
                ElseIf Quoted Then
                    ' We are already in quotes, and so we need
                    ' to determine if we have two quotes in a row.
                    ' If so, then one double quote will be added
                    ' to the argument as if it were escaped.
                    
                    ' Do we have enough character left?
                    If index + 1 < Length Then
                        ' We have enough, so check for 2nd quote.
                        If Chars(index + 1) = vbDoubleQuote Then
                            ' We have two quotes, so escape it.
                            ArgBuffer(ArgIndex) = vbDoubleQuote
                            ArgIndex = ArgIndex + 1
                        End If
                    End If
                    
                    Quoted = False
                Else
                    ' We are starting a quoted section
                    Quoted = True
                End If
                
            Case vbSpace
                If Escaped Then
                    ArgBuffer(ArgIndex) = vbBackSlash
                    ArgIndex = ArgIndex + 1
                    Escaped = False
                End If
                
                If Quoted Then
                    ' Being quoted, so include spaces in the argument.
                    ArgBuffer(ArgIndex) = vbSpace
                    ArgIndex = ArgIndex + 1
                Else
                    ' Done with the argument, so add it to the list.
                    Call Arguments.Add(SysAllocStringLen(VarPtr(ArgBuffer(0)), ArgIndex))
                    ArgIndex = 0
                End If
                
            Case Else
                ' If we were escaped, but didn't make use of it
                ' then we need to include that backslash in the ouput.
                If Escaped Then
                    ArgBuffer(ArgIndex) = vbBackSlash
                    ArgIndex = ArgIndex + 1
                    Escaped = False
                End If
                
                ArgBuffer(ArgIndex) = Chars(index)
                ArgIndex = ArgIndex + 1
        End Select
        
        index = index + 1
    Loop
    
    ' If a backslash was the last character in the line, then
    ' it was escaped, but now we need to include it since there
    ' are no more characters.
    If Escaped Then
        ArgBuffer(ArgIndex) = vbBackSlash
        ArgIndex = ArgIndex + 1
    End If
                
    If ArgIndex > 0 Then Call Arguments.Add(SysAllocStringLen(VarPtr(ArgBuffer(0)), ArgIndex))
    
    ParseCommandLineArgs = Arguments.ToArray(ciString)
End Function

''
' Returns an environment variable value.
'
' @param Name The name of the environment variable to return.
' @param Target The system region to retrieve the variable from.
' @return The value of the environment variable.
' @remarks If the variable does not exist, then an empty string is returned.
' <p>A Target of Process will retrieve the variable from the current process. Other
' targets will retrieve the variable value from the registry.</p>
'
Public Function GetEnvironmentVariable(ByVal Name As String, Optional ByVal Target As EnvironmentVariableTarget = EnvironmentVariableTarget.Process) As String
    Dim rk As RegistryKey
    
    Select Case Target
        Case EnvironmentVariableTarget.Process
            ' use the GetEnvironmentVariable api to allow for realtime
            ' updating of the environment variables for the current
            ' process. VB's Environ does not reflect variable changes.
            Dim size As Long
            size = 128
            Do
                Dim Buf As String
                Buf = String$(size, 0)
                size = API.GetEnvironmentVariable(Name, Buf, Len(Buf))
                If size = 0 Then
                    Dim result As Long
                    result = Err.LastDllError
                    If result = ERROR_ENVVAR_NOT_FOUND Or (result = 0) Then Exit Function
                    IOError result, "Name"
                End If
            Loop While size > Len(Buf)
            GetEnvironmentVariable = Left$(Buf, size)
            
        Case EnvironmentVariableTarget.Machine
            Call VerifyNTMachine
            Set rk = Registry.LocalMachine.OpenSubKey("system\currentcontrolset\control\session manager\environment")
            GetEnvironmentVariable = rk.GetValue(Name, vbNullString)
            
        Case EnvironmentVariableTarget.User
            Call VerifyNTMachine
            Set rk = Registry.CurrentUser.OpenSubKey("environment")
            GetEnvironmentVariable = rk.GetValue(Name, vbNullString)
            
        Case Else
            Throw Cor.NewArgumentException("Invalid Target value.", "Target")
    End Select
End Function

''
' Returns an IDictionary object containing all environment variables as name/value pairs.
'
' @param Target The system region to retrieve the environment variable from.
' @return A dictionary containing the name/value pairs.
' @remarks The hidden environment variables are not included in the dictionary.
' <p>A Target of Process will retrieve the variable from the current process. Other
' targets will retrieve the variable value from the registry.</p>
'
Public Function GetEnvironmentVariables(Optional ByVal Target As EnvironmentVariableTarget = Process) As IDictionary
    Dim ret As New Hashtable
    Dim rk  As RegistryKey
    
    If Target = EnvironmentVariableTarget.Process Then
        ' use the GetEnvironmentStrings api to allow for realtime
        ' updating of the environment variables for the current
        ' process. VB's Environ does not reflect variable changes.
        Set ret = InternalGetEnvironmentVariables
    Else
        Call VerifyNTMachine
        Select Case Target
            Case EnvironmentVariableTarget.Machine: Set rk = Registry.LocalMachine.OpenSubKey("system\currentcontrolset\control\session manager\environment")
            Case EnvironmentVariableTarget.User:    Set rk = Registry.CurrentUser.OpenSubKey("environment")
            Case Else: Throw Cor.NewArgumentException("Invalid Target value.", "Target")
        End Select
        
        Dim Names() As String
        Names = rk.GetValueNames
        
        Dim i As Long
        For i = 0 To UBound(Names)
            Call ret.Add(Names(i), rk.GetValue(Names(i)))
        Next i
    End If
    
    Set GetEnvironmentVariables = ret
End Function

''
' Returns the path for a specified folder type.
'
' @param Folder The folder to return the path of.
' @return The path for the specified folder.
'
Public Function GetFolderPath(ByVal Folder As SpecialFolder) As String
    Dim Buf As String
    
    Buf = String$(MAX_PATH, 0)
    Call SHGetFolderPath(0, Folder, 0, 0, Buf)
    GetFolderPath = SysAllocString(StrPtr(Buf))
End Function

''
' Returns the logical drives installed on the local machine.
'
' @return An array containing all of the logical drives installed.
'
Public Function GetLogicalDrives() As String()
    GetLogicalDrives = Directory.GetLogicalDrives
End Function

''
' Sets, creates, or deletes an environment variable in the specified region.
'
' @param Variable The name of the variable to set the value for.
' @param Value The value of the variable.
' @param Target The region the variable is located in the system.
' @remarks Setting the variable in the Process region only affects the current
' process that is setting the variable. Setting a variable in a User or Machine
' region will set the values in the registry.
' <p>by setting the value to an empty string, the variable will be deleted.</p>
'
Public Sub SetEnvironmentVariable(ByVal Variable As String, ByVal value As String, Optional ByVal Target As EnvironmentVariableTarget = Process)
    If Len(Variable) = 0 Then _
        Throw Cor.NewArgumentException("Variable name cannot be an empty string.", "Variable")
    If InStr(Variable, "=") > 0 Then _
        Throw Cor.NewArgumentException("Variable name cannot contain an equal '=' sign.", "Variable")
    If Len(Variable) > 255 Then _
        Throw Cor.NewArgumentException("Variable name cannot exceed 255 characters.", "Variable")
    If Len(value) > 32767 Then _
        Throw Cor.NewArgumentException("Value cannot exceed a length of 32767 characters including the terminating null.", "Value")
    
    Select Case Target
        Case EnvironmentVariableTarget.Process
            If API.SetEnvironmentVariable(Variable, value) = BOOL_FALSE Then _
                Throw Cor.NewArgumentException(GetErrorMessage(Err.LastDllError), "Value")
                
        Case EnvironmentVariableTarget.Machine, EnvironmentVariableTarget.User
            Call VerifyNTMachine
            
            Dim rk As RegistryKey
            If Target = EnvironmentVariableTarget.Machine Then
                Set rk = Registry.LocalMachine.OpenSubKey("system\currentcontrolset\control\session manager\environment", True)
            Else
                Set rk = Registry.CurrentUser.OpenSubKey("environment", True)
            End If
            
            If Len(value) > 0 Then
                Call rk.SetValue(Variable, value)
            Else
                Call rk.DeleteValue(Variable, False)
            End If
            
            Call SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, 0, StrPtr("Environment"), SMTO_NORMAL, 1000, 0)
            
        Case Else
            Throw Cor.NewArgumentException("Invalid target specified.", "Target")
    End Select
End Sub

''
' Returns the number of processors on the current machine.
'
' @return The processor count.
'
Public Property Get ProcessorCount() As Long
    Dim Info As SYSTEM_INFO
    
    Call GetSystemInfo(Info)
    ProcessorCount = Info.dwNumberOfProcessors
End Property



'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   Friend Interface
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Friend Function GetResourceString(ByVal resId As Long, ParamArray args() As Variant) As String
    Dim vArgs() As Variant
    Call Helper.Swap4(ByVal ArrPtr(vArgs), ByVal Helper.DerefEBP(16))
    GetResourceString = cString.FormatArray(LoadResString(resId), vArgs)
End Function

Friend Sub VerifyNTMachine()
    If Not IsNT Then
        Throw Cor.NewNotSupportedException("This operation is only supported on Windows NT platforms.")
    End If
End Sub

Friend Function IsNT() As Boolean
    IsNT = (mOSVersion.Platform = Win32NT)
End Function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   Private Helpers
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

' we need to use the GetEnvironmentStrings API method instead of
' iterating through the variables using Environ because Environ
' does not reflect changes to the variables after the application starts.
Private Function InternalGetEnvironmentVariables() As IDictionary
    Dim Strings() As String
    Strings() = Split(API.GetEnvironmentStrings, vbNullChar)
    
    Dim ret As New Hashtable
    Dim i   As Long
    For i = 0 To UBound(Strings)
        If Asc(Strings(i)) <> vbEqual Then
            Dim Parts() As String
            Parts = Split(Strings(i), "=")
            
            Call ret.Add(Trim$(Parts(0)), Trim$(Parts(1)))
        End If
    Next i
    
    Set InternalGetEnvironmentVariables = ret
End Function


