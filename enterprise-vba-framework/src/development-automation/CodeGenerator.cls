VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CodeGenerator"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
'@Folder("DevelopmentAutomation")
'@PredeclaredId
'@Description("Code generator implementation")
Option Explicit

Implements ICodeGenerator

Private Type TGenerator
    TemplateEngine As ITemplateEngine
    Logger As ILogger
End Type

Private this As TGenerator

'@Description("Creates a new code generator instance")
Public Function Create(ByVal templateEngine As ITemplateEngine, ByVal logger As ILogger) As ICodeGenerator
    Dim generator As CodeGenerator
    Set generator = New CodeGenerator
    generator.Initialize templateEngine, logger
    Set Create = generator
End Function

Friend Sub Initialize(ByVal templateEngine As ITemplateEngine, ByVal logger As ILogger)
    Set this.TemplateEngine = templateEngine
    Set this.Logger = logger
End Sub

Private Function ICodeGenerator_GenerateClass(ByVal specification As ClassSpecification) As String
    this.Logger.Info "Generating class: " & specification.ClassName
    
    Dim code As String
    code = code & GenerateClassHeader(specification)
    code = code & GenerateClassDeclarations(specification)
    code = code & GenerateClassProperties(specification)
    code = code & GenerateClassMethods(specification)
    code = code & GenerateInterfaceImplementations(specification)
    
    ICodeGenerator_GenerateClass = code
End Function

Private Function ICodeGenerator_GenerateInterface(ByVal specification As InterfaceSpecification) As String
    this.Logger.Info "Generating interface: " & specification.InterfaceName
    
    Dim code As String
    code = code & "VERSION 1.0 CLASS" & vbCrLf
    code = code & "BEGIN" & vbCrLf
    code = code & "  MultiUse = -1  'True" & vbCrLf
    code = code & "END" & vbCrLf
    code = code & "Attribute VB_Name = """ & specification.InterfaceName & """" & vbCrLf
    code = code & "Attribute VB_GlobalNameSpace = False" & vbCrLf
    code = code & "Attribute VB_Creatable = False" & vbCrLf
    code = code & "Attribute VB_PredeclaredId = False" & vbCrLf
    code = code & "Attribute VB_Exposed = True" & vbCrLf
    code = code & "'@Interface" & vbCrLf
    code = code & "'@Description(""" & specification.Description & """)" & vbCrLf
    code = code & "Option Explicit" & vbCrLf & vbCrLf
    
    ' Generate interface members
    Dim member As InterfaceMember
    For Each member In specification.Members
        code = code & GenerateInterfaceMember(member) & vbCrLf
    Next member
    
    ICodeGenerator_GenerateInterface = code
End Function

Private Function ICodeGenerator_GenerateModule(ByVal specification As ModuleSpecification) As String
    this.Logger.Info "Generating module: " & specification.ModuleName
    
    Dim code As String
    code = code & "Attribute VB_Name = """ & specification.ModuleName & """" & vbCrLf
    code = code & "'@Folder(""" & specification.FolderPath & """)" & vbCrLf
    code = code & "Option Explicit" & vbCrLf & vbCrLf
    
    ' Generate constants
    If specification.Constants.Count > 0 Then
        code = code & GenerateConstants(specification.Constants)
    End If
    
    ' Generate procedures
    Dim proc As ProcedureSpecification
    For Each proc In specification.Procedures
        code = code & GenerateProcedure(proc) & vbCrLf
    Next proc
    
    ICodeGenerator_GenerateModule = code
End Function

Private Function ICodeGenerator_GenerateFromTemplate(ByVal templateName As String, ByVal parameters As Object) As String
    this.Logger.Debug "Generating code from template: " & templateName
    
    Dim template As String
    template = this.TemplateEngine.LoadTemplate(templateName)
    
    ICodeGenerator_GenerateFromTemplate = this.TemplateEngine.Render(template, parameters)
End Function

Private Function ICodeGenerator_GenerateViewModelForm(ByVal formName As String, ByVal properties As Collection) As String
    this.Logger.Info "Generating ViewModel form: " & formName
    
    Dim parameters As Object
    Set parameters = CreateObject("Scripting.Dictionary")
    parameters("FormName") = formName
    parameters("ViewModelName") = formName & "ViewModel"
    Set parameters("Properties") = properties
    
    ICodeGenerator_GenerateViewModelForm = ICodeGenerator_GenerateFromTemplate("MVVMForm", parameters)
End Function

' Helper methods for class generation
Private Function GenerateClassHeader(ByVal spec As ClassSpecification) As String
    Dim code As String
    code = code & "VERSION 1.0 CLASS" & vbCrLf
    code = code & "BEGIN" & vbCrLf
    code = code & "  MultiUse = -1  'True" & vbCrLf
    code = code & "END" & vbCrLf
    code = code & "Attribute VB_Name = """ & spec.ClassName & """" & vbCrLf
    code = code & "Attribute VB_GlobalNameSpace = False" & vbCrLf
    code = code & "Attribute VB_Creatable = False" & vbCrLf
    
    If spec.IsPredeclaredId Then
        code = code & "Attribute VB_PredeclaredId = True" & vbCrLf
        code = code & "'@PredeclaredId" & vbCrLf
    Else
        code = code & "Attribute VB_PredeclaredId = False" & vbCrLf
    End If
    
    code = code & "Attribute VB_Exposed = " & IIf(spec.IsExposed, "True", "False") & vbCrLf
    code = code & "'@Folder(""" & spec.FolderPath & """)" & vbCrLf
    
    If Len(spec.Description) > 0 Then
        code = code & "'@Description(""" & spec.Description & """)" & vbCrLf
    End If
    
    code = code & "Option Explicit" & vbCrLf & vbCrLf
    
    GenerateClassHeader = code
End Function

Private Function GenerateClassDeclarations(ByVal spec As ClassSpecification) As String
    Dim code As String
    
    ' Implements statements
    Dim interfaceName As Variant
    For Each interfaceName In spec.Interfaces
        code = code & "Implements " & CStr(interfaceName) & vbCrLf
    Next interfaceName
    
    If Len(code) > 0 Then code = code & vbCrLf
    
    ' Private type declaration
    If spec.Properties.Count > 0 Then
        code = code & "Private Type T" & spec.ClassName & vbCrLf
        
        Dim prop As PropertySpecification
        For Each prop In spec.Properties
            code = code & "    " & prop.Name & " As " & prop.DataType & vbCrLf
        Next prop
        
        code = code & "End Type" & vbCrLf & vbCrLf
        code = code & "Private this As T" & spec.ClassName & vbCrLf & vbCrLf
    End If
    
    GenerateClassDeclarations = code
End Function

Private Function GenerateClassProperties(ByVal spec As ClassSpecification) As String
    Dim code As String
    
    Dim prop As PropertySpecification
    For Each prop In spec.Properties
        code = code & GenerateProperty(prop) & vbCrLf
    Next prop
    
    GenerateClassProperties = code
End Function

Private Function GenerateProperty(ByVal prop As PropertySpecification) As String
    Dim code As String
    
    ' Property Get
    If prop.PropertyType = ReadOnly Or prop.PropertyType = ReadWrite Then
        code = code & "Public Property Get " & prop.Name & "() As " & prop.DataType & vbCrLf
        
        If IsObject(prop.DataType) Then
            code = code & "    Set " & prop.Name & " = this." & prop.Name & vbCrLf
        Else
            code = code & "    " & prop.Name & " = this." & prop.Name & vbCrLf
        End If
        
        code = code & "End Property" & vbCrLf & vbCrLf
    End If
    
    ' Property Let/Set
    If prop.PropertyType = WriteOnly Or prop.PropertyType = ReadWrite Then
        Dim propertyType As String
        propertyType = IIf(IsObject(prop.DataType), "Set", "Let")
        
        code = code & "Public Property " & propertyType & " " & prop.Name & "(ByVal value As " & prop.DataType & ")" & vbCrLf
        
        If IsObject(prop.DataType) Then
            code = code & "    Set this." & prop.Name & " = value" & vbCrLf
        Else
            code = code & "    this." & prop.Name & " = value" & vbCrLf
        End If
        
        code = code & "End Property" & vbCrLf & vbCrLf
    End If
    
    GenerateProperty = code
End Function

Private Function GenerateClassMethods(ByVal spec As ClassSpecification) As String
    Dim code As String
    
    ' Generate factory method if PredeclaredId
    If spec.IsPredeclaredId Then
        code = code & GenerateFactoryMethod(spec)
    End If
    
    ' Generate custom methods
    Dim method As MethodSpecification
    For Each method In spec.Methods
        code = code & GenerateMethod(method) & vbCrLf
    Next method
    
    GenerateClassMethods = code
End Function

Private Function GenerateFactoryMethod(ByVal spec As ClassSpecification) As String
    Dim code As String
    code = code & "Public Function Create() As " & spec.ClassName & vbCrLf
    code = code & "    Dim instance As " & spec.ClassName & vbCrLf
    code = code & "    Set instance = New " & spec.ClassName & vbCrLf
    code = code & "    Set Create = instance" & vbCrLf
    code = code & "End Function" & vbCrLf & vbCrLf
    
    GenerateFactoryMethod = code
End Function

Private Function GenerateMethod(ByVal method As MethodSpecification) As String
    Dim code As String
    
    Dim methodType As String
    methodType = IIf(Len(method.ReturnType) > 0, "Function", "Sub")
    
    code = code & "Public " & methodType & " " & method.Name & "("
    
    ' Parameters
    If method.Parameters.Count > 0 Then
        Dim param As ParameterSpecification
        Dim paramList As String
        For Each param In method.Parameters
            If Len(paramList) > 0 Then paramList = paramList & ", "
            paramList = paramList & "ByVal " & param.Name & " As " & param.DataType
        Next param
        code = code & paramList
    End If
    
    code = code & ")"
    
    If Len(method.ReturnType) > 0 Then
        code = code & " As " & method.ReturnType
    End If
    
    code = code & vbCrLf
    code = code & "    ' TODO: Implement " & method.Name & vbCrLf
    code = code & "End " & methodType & vbCrLf & vbCrLf
    
    GenerateMethod = code
End Function

Private Function GenerateInterfaceImplementations(ByVal spec As ClassSpecification) As String
    ' Placeholder for interface implementation generation
    ' In production, this would generate the interface member implementations
    GenerateInterfaceImplementations = ""
End Function

Private Function GenerateInterfaceMember(ByVal member As InterfaceMember) As String
    Dim code As String
    
    Select Case member.MemberType
        Case "Property"
            code = "Public Property Get " & member.Name & "() As " & member.DataType & vbCrLf
            code = code & "End Property" & vbCrLf
        Case "Function"
            code = "Public Function " & member.Name & "() As " & member.ReturnType & vbCrLf
            code = code & "End Function" & vbCrLf
        Case "Sub"
            code = "Public Sub " & member.Name & "()" & vbCrLf
            code = code & "End Sub" & vbCrLf
    End Select
    
    GenerateInterfaceMember = code
End Function

Private Function GenerateConstants(ByVal constants As Collection) As String
    Dim code As String
    code = "'Constants" & vbCrLf
    
    Dim const As ConstantSpecification
    For Each const In constants
        code = code & "Public Const " & const.Name & " As " & const.DataType & " = " & const.Value & vbCrLf
    Next const
    
    code = code & vbCrLf
    GenerateConstants = code
End Function

Private Function GenerateProcedure(ByVal proc As ProcedureSpecification) As String
    Dim code As String
    
    Dim procType As String
    procType = IIf(Len(proc.ReturnType) > 0, "Function", "Sub")
    
    code = code & "Public " & procType & " " & proc.Name & "()" & IIf(Len(proc.ReturnType) > 0, " As " & proc.ReturnType, "") & vbCrLf
    code = code & "    ' TODO: Implement" & vbCrLf
    code = code & "End " & procType & vbCrLf & vbCrLf
    
    GenerateProcedure = code
End Function

Private Function IsObject(ByVal dataType As String) As Boolean
    ' Simple check - in production, this would be more sophisticated
    Select Case LCase$(dataType)
        Case "string", "long", "integer", "double", "single", "currency", "date", "boolean", "byte", "variant"
            IsObject = False
        Case Else
            IsObject = True
    End Select
End Function
