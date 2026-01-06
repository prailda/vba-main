VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "DependencyContainer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
'@Folder("Core.DependencyInjection")
'@PredeclaredId
'@Description("Dependency injection container implementation")
Option Explicit

Implements IDependencyContainer

Private Type TContainer
    Registrations As Object ' Scripting.Dictionary
    Instances As Object     ' Scripting.Dictionary
    NamedRegistrations As Object ' Scripting.Dictionary
End Type

Private this As TContainer
Private Const ERROR_NOT_REGISTERED As Long = vbObjectError + 5001
Private Const ERROR_CREATION_FAILED As Long = vbObjectError + 5002

'@Description("Creates a new instance of the container")
Public Function Create() As IDependencyContainer
    Dim container As DependencyContainer
    Set container = New DependencyContainer
    container.Initialize
    Set Create = container
End Function

Friend Sub Initialize()
    Set this.Registrations = CreateObject("Scripting.Dictionary")
    Set this.Instances = CreateObject("Scripting.Dictionary")
    Set this.NamedRegistrations = CreateObject("Scripting.Dictionary")
End Sub

Private Sub IDependencyContainer_Register(ByVal interfaceType As String, ByVal implementationType As String, Optional ByVal lifetime As LifetimeType = Transient)
    Dim registration As New ServiceRegistration
    registration.InterfaceType = interfaceType
    registration.ImplementationType = implementationType
    registration.lifetime = lifetime
    
    this.Registrations(interfaceType) = registration
End Sub

Private Sub IDependencyContainer_RegisterInstance(ByVal interfaceType As String, ByVal instance As Object)
    Set this.Instances(interfaceType) = instance
    
    Dim registration As New ServiceRegistration
    registration.InterfaceType = interfaceType
    registration.ImplementationType = TypeName(instance)
    registration.lifetime = Singleton
    
    this.Registrations(interfaceType) = registration
End Sub

Private Sub IDependencyContainer_RegisterNamed(ByVal serviceName As String, ByVal interfaceType As String, ByVal implementationType As String, Optional ByVal lifetime As LifetimeType = Transient)
    Dim registration As New ServiceRegistration
    registration.InterfaceType = interfaceType
    registration.ImplementationType = implementationType
    registration.lifetime = lifetime
    
    this.NamedRegistrations(serviceName) = registration
End Sub

Private Function IDependencyContainer_Resolve(ByVal serviceType As String) As Object
    ' Check if instance already exists (Singleton)
    If this.Instances.Exists(serviceType) Then
        Set IDependencyContainer_Resolve = this.Instances(serviceType)
        Exit Function
    End If
    
    ' Check if service is registered
    If Not this.Registrations.Exists(serviceType) Then
        Err.Raise ERROR_NOT_REGISTERED, "DependencyContainer", "Service not registered: " & serviceType
    End If
    
    Dim registration As ServiceRegistration
    Set registration = this.Registrations(serviceType)
    
    ' Create instance
    Dim instance As Object
    On Error GoTo ErrorHandler
    
    Set instance = CreateInstance(registration.ImplementationType)
    
    ' Store singleton instances
    If registration.lifetime = Singleton Then
        Set this.Instances(serviceType) = instance
    End If
    
    Set IDependencyContainer_Resolve = instance
    Exit Function
    
ErrorHandler:
    Err.Raise ERROR_CREATION_FAILED, "DependencyContainer", "Failed to create instance of: " & registration.ImplementationType & " - " & Err.Description
End Function

Private Function IDependencyContainer_ResolveNamed(ByVal serviceName As String) As Object
    If Not this.NamedRegistrations.Exists(serviceName) Then
        Err.Raise ERROR_NOT_REGISTERED, "DependencyContainer", "Named service not registered: " & serviceName
    End If
    
    Dim registration As ServiceRegistration
    Set registration = this.NamedRegistrations(serviceName)
    
    Dim instance As Object
    On Error GoTo ErrorHandler
    
    Set instance = CreateInstance(registration.ImplementationType)
    
    Set IDependencyContainer_ResolveNamed = instance
    Exit Function
    
ErrorHandler:
    Err.Raise ERROR_CREATION_FAILED, "DependencyContainer", "Failed to create named instance: " & serviceName & " - " & Err.Description
End Function

Private Function IDependencyContainer_IsRegistered(ByVal serviceType As String) As Boolean
    IDependencyContainer_IsRegistered = this.Registrations.Exists(serviceType)
End Function

Private Sub IDependencyContainer_Clear()
    this.Registrations.RemoveAll
    this.Instances.RemoveAll
    this.NamedRegistrations.RemoveAll
End Sub

Private Function CreateInstance(ByVal className As String) As Object
    ' This is a simplified version - in production, you might use CallByName or other techniques
    Select Case className
        Case "FileLogger"
            Set CreateInstance = New FileLogger
        Case "ConsoleLogger"
            Set CreateInstance = New ConsoleLogger
        ' Add more mappings as needed
        Case Else
            ' Attempt to create using late binding
            On Error Resume Next
            Set CreateInstance = VBA.Interaction.CreateObject(className)
            If Err.Number <> 0 Then
                On Error GoTo 0
                Err.Raise ERROR_CREATION_FAILED, "DependencyContainer", "Cannot create instance of unknown type: " & className
            End If
            On Error GoTo 0
    End Select
End Function

Private Sub Class_Initialize()
    If this.Registrations Is Nothing Then
        Initialize
    End If
End Sub
