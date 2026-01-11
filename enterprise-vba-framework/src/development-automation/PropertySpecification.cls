VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "PropertySpecification"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'@Folder("DevelopmentAutomation.Specifications")
Option Explicit

Public Name As String
Public DataType As String
Public PropertyType As PropertyAccessType
Public Description As String
Public DefaultValue As Variant
