VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "IDependencyContainer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'@Folder("Core.DependencyInjection")
'@Interface
'@Description("Interface for dependency injection container")
Option Explicit

Public Enum LifetimeType
    Singleton = 0
    Transient = 1
    Scoped = 2
End Enum

'@Description("Registers a service with the container")
Public Sub Register(ByVal interfaceType As String, ByVal implementationType As String, Optional ByVal lifetime As LifetimeType = Transient)
End Sub

'@Description("Registers a singleton instance")
Public Sub RegisterInstance(ByVal interfaceType As String, ByVal instance As Object)
End Sub

'@Description("Registers a named service")
Public Sub RegisterNamed(ByVal serviceName As String, ByVal interfaceType As String, ByVal implementationType As String, Optional ByVal lifetime As LifetimeType = Transient)
End Sub

'@Description("Resolves a service from the container")
Public Function Resolve(ByVal serviceType As String) As Object
End Function

'@Description("Resolves a named service from the container")
Public Function ResolveNamed(ByVal serviceName As String) As Object
End Function

'@Description("Checks if a service is registered")
Public Function IsRegistered(ByVal serviceType As String) As Boolean
End Function

'@Description("Clears all registrations")
Public Sub Clear()
End Sub
