VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "FileLogger"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
'@Folder("Logging")
'@PredeclaredId
'@Description("File-based logger implementation")
Option Explicit

Implements ILogger

Private Type TLogger
    LogFilePath As String
    MinimumLevel As LogLevel
    IncludeTimestamp As Boolean
    IncludeLogLevel As Boolean
End Type

Private this As TLogger

'@Description("Creates a new file logger")
Public Function Create(ByVal logFilePath As String, Optional ByVal minimumLevel As LogLevel = Info) As ILogger
    Dim logger As FileLogger
    Set logger = New FileLogger
    logger.Initialize logFilePath, minimumLevel
    Set Create = logger
End Function

Friend Sub Initialize(ByVal logFilePath As String, ByVal minimumLevel As LogLevel)
    this.LogFilePath = logFilePath
    this.MinimumLevel = minimumLevel
    this.IncludeTimestamp = True
    this.IncludeLogLevel = True
    
    ' Create log directory if it doesn't exist
    EnsureLogDirectoryExists
End Sub

Private Sub ILogger_Log(ByVal level As LogLevel, ByVal message As String, Optional ByVal err As ErrObject = Nothing)
    If level < this.MinimumLevel Then Exit Sub
    
    Dim logMessage As String
    logMessage = FormatLogMessage(level, message, err)
    
    WriteToFile logMessage
End Sub

Private Sub ILogger_Trace(ByVal message As String)
    ILogger_Log Trace, message
End Sub

Private Sub ILogger_Debug(ByVal message As String)
    ILogger_Log Debug, message
End Sub

Private Sub ILogger_Info(ByVal message As String)
    ILogger_Log Info, message
End Sub

Private Sub ILogger_Warn(ByVal message As String)
    ILogger_Log Warn, message
End Sub

Private Sub ILogger_Error(ByVal message As String, Optional ByVal err As ErrObject = Nothing)
    ILogger_Log ErrorLevel, message, err
End Sub

Private Sub ILogger_Fatal(ByVal message As String, Optional ByVal err As ErrObject = Nothing)
    ILogger_Log Fatal, message, err
End Sub

Private Sub ILogger_SetMinimumLevel(ByVal level As LogLevel)
    this.MinimumLevel = level
End Sub

Private Function ILogger_GetMinimumLevel() As LogLevel
    ILogger_GetMinimumLevel = this.MinimumLevel
End Function

Private Function FormatLogMessage(ByVal level As LogLevel, ByVal message As String, Optional ByVal err As ErrObject = Nothing) As String
    Dim parts As Collection
    Set parts = New Collection
    
    ' Add timestamp
    If this.IncludeTimestamp Then
        parts.Add Format$(Now, "yyyy-mm-dd hh:nn:ss")
    End If
    
    ' Add log level
    If this.IncludeLogLevel Then
        parts.Add "[" & GetLogLevelName(level) & "]"
    End If
    
    ' Add message
    parts.Add message
    
    ' Add error information
    If Not err Is Nothing Then
        If err.Number <> 0 Then
            parts.Add "Error #" & err.Number & ": " & err.Description
            If Len(err.Source) > 0 Then
                parts.Add "Source: " & err.Source
            End If
        End If
    End If
    
    ' Join all parts
    Dim result As String
    Dim part As Variant
    For Each part In parts
        If Len(result) > 0 Then result = result & " | "
        result = result & CStr(part)
    Next part
    
    FormatLogMessage = result
End Function

Private Function GetLogLevelName(ByVal level As LogLevel) As String
    Select Case level
        Case Trace: GetLogLevelName = "TRACE"
        Case Debug: GetLogLevelName = "DEBUG"
        Case Info: GetLogLevelName = "INFO"
        Case Warn: GetLogLevelName = "WARN"
        Case ErrorLevel: GetLogLevelName = "ERROR"
        Case Fatal: GetLogLevelName = "FATAL"
        Case Else: GetLogLevelName = "UNKNOWN"
    End Select
End Function

Private Sub WriteToFile(ByVal message As String)
    On Error GoTo ErrorHandler
    
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    Dim fileStream As Object
    
    ' Append to existing file or create new
    If fso.FileExists(this.LogFilePath) Then
        Set fileStream = fso.OpenTextFile(this.LogFilePath, 8) ' ForAppending = 8
    Else
        Set fileStream = fso.CreateTextFile(this.LogFilePath, True)
    End If
    
    fileStream.WriteLine message
    fileStream.Close
    
    Set fileStream = Nothing
    Set fso = Nothing
    Exit Sub
    
ErrorHandler:
    ' Fail silently to avoid breaking application
    ' In production, you might want to write to Windows Event Log or Debug window
    Debug.Print "FileLogger Error: " & Err.Description
End Sub

Private Sub EnsureLogDirectoryExists()
    On Error Resume Next
    
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    Dim logDirectory As String
    logDirectory = fso.GetParentFolderName(this.LogFilePath)
    
    If Len(logDirectory) > 0 And Not fso.FolderExists(logDirectory) Then
        fso.CreateFolder logDirectory
    End If
    
    Set fso = Nothing
    On Error GoTo 0
End Sub

Private Sub Class_Initialize()
    ' Default values
    this.MinimumLevel = Info
    this.IncludeTimestamp = True
    this.IncludeLogLevel = True
End Sub
