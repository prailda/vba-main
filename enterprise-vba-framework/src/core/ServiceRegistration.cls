VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ServiceRegistration"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'@Folder("Core.DependencyInjection")
'@Description("Service registration information")
Option Explicit

Public InterfaceType As String
Public ImplementationType As String
Public lifetime As LifetimeType
