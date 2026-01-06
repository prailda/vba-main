Attribute VB_Name = "Example_CodeGeneration"
'@Folder("Examples")
'@Description("Examples demonstrating code generation capabilities")
Option Explicit

'@Description("Generates a simple entity class")
Public Sub Example_GenerateSimpleClass()
    ' Note: Requires ITemplateEngine implementation
    ' This is a demonstration of the API
    
    Debug.Print "=== Generating Customer Class ==="
    
    ' Create specification
    Dim spec As New ClassSpecification
    spec.ClassName = "Customer"
    spec.FolderPath = "Domain.Entities"
    spec.Description = "Represents a customer in the system"
    
    ' Add properties
    spec.AddProperty "CustomerId", "Long", ReadOnly
    spec.AddProperty "FirstName", "String", ReadWrite
    spec.AddProperty "LastName", "String", ReadWrite
    spec.AddProperty "Email", "String", ReadWrite
    spec.AddProperty "IsActive", "Boolean", ReadWrite
    
    ' Add methods
    spec.AddMethod "GetFullName", "String", "Public"
    spec.AddMethod "Validate", "Boolean", "Public"
    
    Debug.Print "Specification created for class: " & spec.ClassName
    Debug.Print "Properties: " & spec.Properties.Count
    Debug.Print "Methods: " & spec.Methods.Count
    
    ' In production, you would call:
    ' Dim generator As ICodeGenerator
    ' Dim code As String
    ' code = generator.GenerateClass(spec)
    ' Debug.Print code
End Sub

'@Description("Generates a ViewModel class with MVVM pattern")
Public Sub Example_GenerateViewModel()
    Debug.Print "=== Generating OrderViewModel ==="
    
    Dim spec As New ClassSpecification
    spec.ClassName = "OrderViewModel"
    spec.FolderPath = "Presentation.ViewModels"
    spec.Description = "ViewModel for Order management"
    spec.IsPredeclaredId = True
    
    ' Add interfaces
    spec.AddInterface "IViewModel"
    spec.AddInterface "INotifyPropertyChanged"
    
    ' Add data properties
    spec.AddProperty "OrderId", "Long", ReadWrite
    spec.AddProperty "OrderDate", "Date", ReadWrite
    spec.AddProperty "CustomerName", "String", ReadWrite
    spec.AddProperty "TotalAmount", "Currency", ReadWrite
    spec.AddProperty "Status", "String", ReadWrite
    
    ' Add command properties
    spec.AddProperty "SaveCommand", "ICommand", ReadOnly
    spec.AddProperty "CancelCommand", "ICommand", ReadOnly
    spec.AddProperty "DeleteCommand", "ICommand", ReadOnly
    
    ' Add validation property
    spec.AddProperty "Validation", "IHandleValidationError", ReadOnly
    
    Debug.Print "ViewModel specification created"
    Debug.Print "Class: " & spec.ClassName
    Debug.Print "Implements: IViewModel, INotifyPropertyChanged"
    Debug.Print "Properties: " & spec.Properties.Count
End Sub

'@Description("Generates a Repository class")
Public Sub Example_GenerateRepository()
    Debug.Print "=== Generating CustomerRepository ==="
    
    Dim spec As New ClassSpecification
    spec.ClassName = "CustomerRepository"
    spec.FolderPath = "DataAccess.Repositories"
    spec.Description = "Repository for Customer entity data access"
    spec.IsPredeclaredId = True
    
    ' Add interface
    spec.AddInterface "IRepository"
    
    ' Add dependencies (as properties)
    spec.AddProperty "Logger", "ILogger", ReadWrite
    spec.AddProperty "ConnectionString", "String", ReadWrite
    
    ' Add repository methods
    Dim methodSpec As MethodSpecification
    
    Set methodSpec = New MethodSpecification
    methodSpec.Name = "FindById"
    methodSpec.ReturnType = "Customer"
    methodSpec.AddParameter "id", "Long"
    spec.Methods.Add methodSpec
    
    Set methodSpec = New MethodSpecification
    methodSpec.Name = "FindAll"
    methodSpec.ReturnType = "Collection"
    spec.Methods.Add methodSpec
    
    Set methodSpec = New MethodSpecification
    methodSpec.Name = "Save"
    methodSpec.ReturnType = "Boolean"
    methodSpec.AddParameter "customer", "Customer"
    spec.Methods.Add methodSpec
    
    Set methodSpec = New MethodSpecification
    methodSpec.Name = "Delete"
    methodSpec.ReturnType = "Boolean"
    methodSpec.AddParameter "id", "Long"
    spec.Methods.Add methodSpec
    
    Debug.Print "Repository specification created"
    Debug.Print "Methods: FindById, FindAll, Save, Delete"
End Sub

'@Description("Generates a Service class with dependencies")
Public Sub Example_GenerateService()
    Debug.Print "=== Generating OrderService ==="
    
    Dim spec As New ClassSpecification
    spec.ClassName = "OrderService"
    spec.FolderPath = "Business.Services"
    spec.Description = "Business logic service for order management"
    
    ' Add private dependencies
    spec.AddProperty "Repository", "IRepository", ReadWrite
    spec.AddProperty "Logger", "ILogger", ReadWrite
    spec.AddProperty "Validator", "IValidator", ReadWrite
    
    ' Add public methods
    Dim methodSpec As MethodSpecification
    
    Set methodSpec = New MethodSpecification
    methodSpec.Name = "CreateOrder"
    methodSpec.ReturnType = "Order"
    methodSpec.AddParameter "customerId", "Long"
    methodSpec.AddParameter "items", "Collection"
    spec.Methods.Add methodSpec
    
    Set methodSpec = New MethodSpecification
    methodSpec.Name = "UpdateOrderStatus"
    methodSpec.ReturnType = "Boolean"
    methodSpec.AddParameter "orderId", "Long"
    methodSpec.AddParameter "newStatus", "OrderStatus"
    spec.Methods.Add methodSpec
    
    Set methodSpec = New MethodSpecification
    methodSpec.Name = "CancelOrder"
    methodSpec.ReturnType = "Boolean"
    methodSpec.AddParameter "orderId", "Long"
    spec.Methods.Add methodSpec
    
    Debug.Print "Service specification created"
    Debug.Print "Dependencies: Repository, Logger, Validator"
    Debug.Print "Methods: " & spec.Methods.Count
End Sub

'@Description("Demonstrates bulk class generation")
Public Sub Example_BulkGeneration()
    Debug.Print "=== Bulk Class Generation Example ==="
    
    ' Generate multiple related classes
    Dim classNames As Variant
    classNames = Array("Order", "OrderItem", "Customer", "Product", "Invoice")
    
    Dim className As Variant
    For Each className In classNames
        Dim spec As New ClassSpecification
        spec.ClassName = CStr(className)
        spec.FolderPath = "Domain.Entities"
        spec.Description = "Represents a " & LCase$(CStr(className)) & " in the system"
        
        ' Add common properties
        spec.AddProperty "ID", "Long", ReadOnly
        spec.AddProperty "CreatedDate", "Date", ReadOnly
        spec.AddProperty "ModifiedDate", "Date", ReadWrite
        spec.AddProperty "IsDeleted", "Boolean", ReadWrite
        
        Debug.Print "Specification created for: " & spec.ClassName
    Next className
    
    Debug.Print "Generated " & UBound(classNames) - LBound(classNames) + 1 & " class specifications"
End Sub

'@Description("Shows recommended class structure")
Public Sub Example_RecommendedStructure()
    Debug.Print "=== Recommended Class Structure ==="
    Debug.Print ""
    Debug.Print "1. ENTITY CLASS (Domain Model)"
    Debug.Print "   - Properties with private backing fields"
    Debug.Print "   - Validation methods"
    Debug.Print "   - Business rules"
    Debug.Print ""
    Debug.Print "2. REPOSITORY CLASS (Data Access)"
    Debug.Print "   - CRUD operations"
    Debug.Print "   - Query methods"
    Debug.Print "   - Transaction handling"
    Debug.Print ""
    Debug.Print "3. SERVICE CLASS (Business Logic)"
    Debug.Print "   - Use case implementations"
    Debug.Print "   - Orchestrates repositories"
    Debug.Print "   - Business validations"
    Debug.Print ""
    Debug.Print "4. VIEWMODEL CLASS (Presentation)"
    Debug.Print "   - UI-specific properties"
    Debug.Print "   - Commands for user actions"
    Debug.Print "   - Property change notifications"
    Debug.Print ""
    Debug.Print "5. INTERFACE (Abstraction)"
    Debug.Print "   - Contract definitions"
    Debug.Print "   - Enables dependency inversion"
    Debug.Print "   - Facilitates testing"
End Sub
