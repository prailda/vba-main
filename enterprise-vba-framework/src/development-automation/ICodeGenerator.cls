VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ICodeGenerator"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'@Folder("DevelopmentAutomation")
'@Interface
'@Description("Interface for code generation")
Option Explicit

'@Description("Generates a VBA class module")
Public Function GenerateClass(ByVal specification As ClassSpecification) As String
End Function

'@Description("Generates a VBA interface")
Public Function GenerateInterface(ByVal specification As InterfaceSpecification) As String
End Function

'@Description("Generates a standard module")
Public Function GenerateModule(ByVal specification As ModuleSpecification) As String
End Function

'@Description("Generates code from a template")
Public Function GenerateFromTemplate(ByVal templateName As String, ByVal parameters As Object) As String
End Function

'@Description("Generates a UserForm with MVVM pattern")
Public Function GenerateViewModelForm(ByVal formName As String, ByVal properties As Collection) As String
End Function
