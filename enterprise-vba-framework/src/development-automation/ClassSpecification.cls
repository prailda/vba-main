VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClassSpecification"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'@Folder("DevelopmentAutomation.Specifications")
Option Explicit

Public Enum PropertyAccessType
    ReadOnly = 0
    WriteOnly = 1
    ReadWrite = 2
End Enum

Private Type TSpec
    ClassName As String
    FolderPath As String
    Description As String
    IsPredeclaredId As Boolean
    IsExposed As Boolean
    Interfaces As Collection
    Properties As Collection
    Methods As Collection
End Type

Private this As TSpec

Public Property Get ClassName() As String
    ClassName = this.ClassName
End Property

Public Property Let ClassName(ByVal value As String)
    this.ClassName = value
End Property

Public Property Get FolderPath() As String
    FolderPath = this.FolderPath
End Property

Public Property Let FolderPath(ByVal value As String)
    this.FolderPath = value
End Property

Public Property Get Description() As String
    Description = this.Description
End Property

Public Property Let Description(ByVal value As String)
    this.Description = value
End Property

Public Property Get IsPredeclaredId() As Boolean
    IsPredeclaredId = this.IsPredeclaredId
End Property

Public Property Let IsPredeclaredId(ByVal value As Boolean)
    this.IsPredeclaredId = value
End Property

Public Property Get IsExposed() As Boolean
    IsExposed = this.IsExposed
End Property

Public Property Let IsExposed(ByVal value As Boolean)
    this.IsExposed = value
End Property

Public Property Get Interfaces() As Collection
    Set Interfaces = this.Interfaces
End Property

Public Property Get Properties() As Collection
    Set Properties = this.Properties
End Property

Public Property Get Methods() As Collection
    Set Methods = this.Methods
End Property

Public Sub AddInterface(ByVal interfaceName As String)
    this.Interfaces.Add interfaceName
End Sub

Public Sub AddProperty(ByVal propertyName As String, ByVal dataType As String, ByVal accessType As PropertyAccessType)
    Dim prop As New PropertySpecification
    prop.Name = propertyName
    prop.DataType = dataType
    prop.PropertyType = accessType
    
    this.Properties.Add prop
End Sub

Public Sub AddMethod(ByVal methodName As String, ByVal returnType As String, ByVal visibility As String)
    Dim method As New MethodSpecification
    method.Name = methodName
    method.ReturnType = returnType
    method.Visibility = visibility
    
    this.Methods.Add method
End Sub

Private Sub Class_Initialize()
    Set this.Interfaces = New Collection
    Set this.Properties = New Collection
    Set this.Methods = New Collection
    this.FolderPath = "Generated"
    this.IsExposed = True
    this.IsPredeclaredId = False
End Sub
