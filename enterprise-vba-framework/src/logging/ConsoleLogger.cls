VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ConsoleLogger"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
'@Folder("Logging")
'@PredeclaredId
'@Description("Console (Immediate Window) logger implementation")
Option Explicit

Implements ILogger

Private Type TLogger
    MinimumLevel As LogLevel
    UseColors As Boolean
End Type

Private this As TLogger

'@Description("Creates a new console logger")
Public Function Create(Optional ByVal minimumLevel As LogLevel = Info) As ILogger
    Dim logger As ConsoleLogger
    Set logger = New ConsoleLogger
    logger.Initialize minimumLevel
    Set Create = logger
End Function

Friend Sub Initialize(ByVal minimumLevel As LogLevel)
    this.MinimumLevel = minimumLevel
    this.UseColors = False ' VBA Immediate Window doesn't support colors
End Sub

Private Sub ILogger_Log(ByVal level As LogLevel, ByVal message As String, Optional ByVal err As ErrObject = Nothing)
    If level < this.MinimumLevel Then Exit Sub
    
    Dim logMessage As String
    logMessage = FormatLogMessage(level, message, err)
    
    Debug.Print logMessage
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
    Dim result As String
    
    result = Format$(Now, "hh:nn:ss") & " "
    result = result & "[" & GetLogLevelName(level) & "] "
    result = result & message
    
    If Not err Is Nothing Then
        If err.Number <> 0 Then
            result = result & " | Error #" & err.Number & ": " & err.Description
        End If
    End If
    
    FormatLogMessage = result
End Function

Private Function GetLogLevelName(ByVal level As LogLevel) As String
    Select Case level
        Case Trace: GetLogLevelName = "TRC"
        Case Debug: GetLogLevelName = "DBG"
        Case Info: GetLogLevelName = "INF"
        Case Warn: GetLogLevelName = "WRN"
        Case ErrorLevel: GetLogLevelName = "ERR"
        Case Fatal: GetLogLevelName = "FTL"
        Case Else: GetLogLevelName = "???"
    End Select
End Function

Private Sub Class_Initialize()
    this.MinimumLevel = Info
End Sub
