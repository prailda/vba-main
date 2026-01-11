VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "MethodSpecification"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'@Folder("DevelopmentAutomation.Specifications")
Option Explicit

Private Type TMethod
    Name As String
    ReturnType As String
    Visibility As String
    Description As String
    Parameters As Collection
End Type

Private this As TMethod

Public Property Get Name() As String
    Name = this.Name
End Property

Public Property Let Name(ByVal value As String)
    this.Name = value
End Property

Public Property Get ReturnType() As String
    ReturnType = this.ReturnType
End Property

Public Property Let ReturnType(ByVal value As String)
    this.ReturnType = value
End Property

Public Property Get Visibility() As String
    Visibility = this.Visibility
End Property

Public Property Let Visibility(ByVal value As String)
    this.Visibility = value
End Property

Public Property Get Description() As String
    Description = this.Description
End Property

Public Property Let Description(ByVal value As String)
    this.Description = value
End Property

Public Property Get Parameters() As Collection
    Set Parameters = this.Parameters
End Property

Public Sub AddParameter(ByVal paramName As String, ByVal dataType As String)
    Dim param As New ParameterSpecification
    param.Name = paramName
    param.DataType = dataType
    
    this.Parameters.Add param
End Sub

Private Sub Class_Initialize()
    Set this.Parameters = New Collection
    this.Visibility = "Public"
End Sub
