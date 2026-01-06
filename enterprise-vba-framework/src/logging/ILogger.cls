VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ILogger"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'@Folder("Logging")
'@Interface
'@Description("Logger interface for structured logging")
Option Explicit

Public Enum LogLevel
    Trace = 0
    Debug = 1
    Info = 2
    Warn = 3
    ErrorLevel = 4
    Fatal = 5
End Enum

'@Description("Logs a message with specified level")
Public Sub Log(ByVal level As LogLevel, ByVal message As String, Optional ByVal err As ErrObject = Nothing)
End Sub

'@Description("Logs a trace message")
Public Sub Trace(ByVal message As String)
End Sub

'@Description("Logs a debug message")
Public Sub Debug(ByVal message As String)
End Sub

'@Description("Logs an info message")
Public Sub Info(ByVal message As String)
End Sub

'@Description("Logs a warning message")
Public Sub Warn(ByVal message As String)
End Sub

'@Description("Logs an error message")
Public Sub Error(ByVal message As String, Optional ByVal err As ErrObject = Nothing)
End Sub

'@Description("Logs a fatal error message")
Public Sub Fatal(ByVal message As String, Optional ByVal err As ErrObject = Nothing)
End Sub

'@Description("Sets the minimum log level")
Public Sub SetMinimumLevel(ByVal level As LogLevel)
End Sub

'@Description("Gets the current minimum log level")
Public Function GetMinimumLevel() As LogLevel
End Function
