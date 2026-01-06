Attribute VB_Name = "CompleteExample"
'@Folder("Examples")
'@Description("Complete end-to-end example demonstrating all framework features")
Option Explicit

'==============================================================================
' COMPLETE ENTERPRISE APPLICATION EXAMPLE
' Демонстрирует полный цикл разработки enterprise приложения
'==============================================================================

' Глобальные переменные
Private appContainer As IDependencyContainer
Private appLogger As ILogger

'@Description("Main entry point - demonstrates complete application lifecycle")
Public Sub Main()
    Debug.Print String$(80, "=")
    Debug.Print "ENTERPRISE VBA FRAMEWORK - COMPLETE EXAMPLE"
    Debug.Print String$(80, "=")
    Debug.Print ""
    
    ' 1. Инициализация приложения
    InitializeApplication
    
    ' 2. Демонстрация компонентов
    DemonstrateLogging
    DemonstrateDependencyInjection
    DemonstrateCodeGeneration
    DemonstrateValidation
    DemonstrateTesting
    DemonstrateStringUtilities
    
    ' 3. Бизнес-сценарий
    RunBusinessScenario
    
    Debug.Print ""
    Debug.Print String$(80, "=")
    Debug.Print "EXAMPLE COMPLETED SUCCESSFULLY"
    Debug.Print String$(80, "=")
End Sub

'==============================================================================
' APPLICATION INITIALIZATION
'==============================================================================

Private Sub InitializeApplication()
    Debug.Print ">>> STEP 1: Application Initialization"
    Debug.Print ""
    
    ' Создание DI Container
    Set appContainer = DependencyContainer.Create()
    
    ' Регистрация сервисов
    Debug.Print "Registering services..."
    
    ' Logger - Singleton
    Set appLogger = ConsoleLogger.Create(Debug)
    appContainer.RegisterInstance "ILogger", appLogger
    
    ' Named loggers for different purposes
    appContainer.RegisterNamed "FileLogger", "ILogger", "FileLogger", Singleton
    appContainer.RegisterNamed "ConsoleLogger", "ILogger", "ConsoleLogger", Singleton
    
    appLogger.Info "Application initialized successfully"
    appLogger.Info "DI Container configured with " & "services"
    Debug.Print ""
End Sub

'==============================================================================
' FEATURE DEMONSTRATIONS
'==============================================================================

Private Sub DemonstrateLogging()
    Debug.Print ">>> STEP 2: Logging Framework"
    Debug.Print ""
    
    Dim logger As ILogger
    Set logger = appContainer.Resolve("ILogger")
    
    logger.Info "=== Logging Demo ==="
    logger.Trace "This is a TRACE message (detailed debug info)"
    logger.Debug "This is a DEBUG message (development info)"
    logger.Info "This is an INFO message (general info)"
    logger.Warn "This is a WARN message (potential issue)"
    
    ' Error logging demo
    On Error Resume Next
    Dim x As Long
    x = 1 / 0
    If Err.Number <> 0 Then
        logger.Error "Demonstrating error logging", Err
        Err.Clear
    End If
    On Error GoTo 0
    
    Debug.Print ""
End Sub

Private Sub DemonstrateDependencyInjection()
    Debug.Print ">>> STEP 3: Dependency Injection"
    Debug.Print ""
    
    appLogger.Info "=== DI Container Demo ==="
    
    ' Проверка Singleton lifetime
    Dim logger1 As ILogger
    Dim logger2 As ILogger
    Set logger1 = appContainer.Resolve("ILogger")
    Set logger2 = appContainer.Resolve("ILogger")
    
    appLogger.Debug "Singleton test: Same instance = " & (logger1 Is logger2)
    
    ' Named services
    appLogger.Debug "Resolving named services..."
    Dim consoleLogger As ILogger
    Set consoleLogger = appContainer.ResolveNamed("ConsoleLogger")
    consoleLogger.Info "Message from named ConsoleLogger"
    
    Debug.Print ""
End Sub

Private Sub DemonstrateCodeGeneration()
    Debug.Print ">>> STEP 4: Code Generation"
    Debug.Print ""
    
    appLogger.Info "=== Code Generation Demo ==="
    
    ' Create class specification
    Dim spec As New ClassSpecification
    spec.ClassName = "Customer"
    spec.FolderPath = "Domain.Entities"
    spec.Description = "Customer entity with business logic"
    spec.IsPredeclaredId = False
    
    ' Add interface
    spec.AddInterface "IEntity"
    
    ' Add properties
    spec.AddProperty "CustomerID", "Long", ReadOnly
    spec.AddProperty "FirstName", "String", ReadWrite
    spec.AddProperty "LastName", "String", ReadWrite
    spec.AddProperty "Email", "String", ReadWrite
    spec.AddProperty "RegistrationDate", "Date", ReadOnly
    spec.AddProperty "IsActive", "Boolean", ReadWrite
    
    ' Add methods
    spec.AddMethod "GetFullName", "String", "Public"
    spec.AddMethod "Validate", "Boolean", "Public"
    spec.AddMethod "Save", "Boolean", "Public"
    
    appLogger.Info "Class specification created: " & spec.ClassName
    appLogger.Debug "  Properties: " & spec.Properties.Count
    appLogger.Debug "  Methods: " & spec.Methods.Count
    appLogger.Debug "  Interfaces: IEntity"
    
    Debug.Print ""
End Sub

Private Sub DemonstrateValidation()
    Debug.Print ">>> STEP 5: Validation Framework"
    Debug.Print ""
    
    appLogger.Info "=== Validation Demo ==="
    
    ' Email validation
    Dim email As String
    email = "user@example.com"
    Dim isValid As Boolean
    
    isValid = ValidationHelper.ValidateEmail(email)
    appLogger.Debug "Email validation (" & email & "): " & isValid
    
    ' Range validation
    isValid = ValidationHelper.ValidateRange(25, 18, 65, "Age")
    appLogger.Debug "Range validation (Age=25, Range=18-65): " & isValid
    
    ' Length validation
    Dim username As String
    username = "JohnDoe"
    isValid = ValidationHelper.ValidateLength(username, 3, 20, "Username")
    appLogger.Debug "Length validation (Username='" & username & "', Length=3-20): " & isValid
    
    ' Required validation
    isValid = ValidationHelper.ValidateRequired("Some Value", "RequiredField")
    appLogger.Debug "Required validation: " & isValid
    
    Debug.Print ""
End Sub

Private Sub DemonstrateTesting()
    Debug.Print ">>> STEP 6: Testing Framework"
    Debug.Print ""
    
    appLogger.Info "=== Unit Testing Demo ==="
    
    On Error GoTo TestError
    
    Dim assert As IAssert
    Set assert = New Assert
    
    ' Test 1: AreEqual
    assert.AreEqual 4, 2 + 2, "Addition test"
    appLogger.Debug "✓ Test 1 passed: AreEqual"
    
    ' Test 2: IsTrue
    assert.IsTrue (10 > 5), "Comparison test"
    appLogger.Debug "✓ Test 2 passed: IsTrue"
    
    ' Test 3: IsNotNothing
    Dim obj As Object
    Set obj = New Collection
    assert.IsNotNothing obj, "Object existence test"
    appLogger.Debug "✓ Test 3 passed: IsNotNothing"
    
    ' Test 4: IsGreaterThan
    assert.IsGreaterThan 100, 50, "Greater than test"
    appLogger.Debug "✓ Test 4 passed: IsGreaterThan"
    
    appLogger.Info "All tests passed successfully!"
    
    Debug.Print ""
    Exit Sub
    
TestError:
    appLogger.Error "Test failed: " & Err.Description
    Debug.Print ""
End Sub

Private Sub DemonstrateStringUtilities()
    Debug.Print ">>> STEP 7: String Utilities"
    Debug.Print ""
    
    appLogger.Info "=== String Utilities Demo ==="
    
    ' Format
    Dim formatted As String
    formatted = StringUtilities.Format("Hello, {0}! You have {1} new messages.", "Alice", 5)
    appLogger.Debug "Format: " & formatted
    
    ' PascalCase
    Dim pascal As String
    pascal = StringUtilities.ToPascalCase("hello world example")
    appLogger.Debug "PascalCase: " & pascal
    
    ' CamelCase
    Dim camel As String
    camel = StringUtilities.ToCamelCase("hello world example")
    appLogger.Debug "CamelCase: " & camel
    
    ' Truncate
    Dim truncated As String
    truncated = StringUtilities.Truncate("This is a very long text that needs to be shortened", 20)
    appLogger.Debug "Truncate: " & truncated
    
    ' PadLeft
    Dim padded As String
    padded = StringUtilities.PadLeft("42", 5, "0")
    appLogger.Debug "PadLeft: " & padded
    
    Debug.Print ""
End Sub

'==============================================================================
' BUSINESS SCENARIO
'==============================================================================

Private Sub RunBusinessScenario()
    Debug.Print ">>> STEP 8: Business Scenario - Order Processing"
    Debug.Print ""
    
    appLogger.Info "=== Order Processing Scenario ==="
    
    On Error GoTo ErrorHandler
    
    ' Simulate order processing
    Dim orderId As Long
    orderId = 12345
    
    Dim customerName As String
    customerName = "John Smith"
    
    Dim orderTotal As Currency
    orderTotal = 1299.99
    
    ' Step 1: Validate order
    appLogger.Info "Processing order #" & orderId & " for " & customerName
    appLogger.Debug "Validating order data..."
    
    Dim isValid As Boolean
    isValid = ValidationHelper.ValidateRequired(customerName, "CustomerName")
    isValid = isValid And ValidationHelper.ValidateRange(orderTotal, 0, 999999, "OrderTotal")
    
    If Not isValid Then
        appLogger.Warn "Order validation failed"
        Exit Sub
    End If
    
    appLogger.Debug "✓ Validation passed"
    
    ' Step 2: Calculate totals
    appLogger.Debug "Calculating order totals..."
    Dim tax As Currency
    tax = orderTotal * 0.13
    
    Dim finalTotal As Currency
    finalTotal = orderTotal + tax
    
    appLogger.Debug "  Subtotal: " & Format$(orderTotal, "$#,##0.00")
    appLogger.Debug "  Tax (13%): " & Format$(tax, "$#,##0.00")
    appLogger.Debug "  Total: " & Format$(finalTotal, "$#,##0.00")
    
    ' Step 3: Save order
    appLogger.Debug "Saving order to database..."
    
    ' Simulate save delay
    Dim startTime As Double
    startTime = Timer
    
    ' Simulate work
    Dim i As Long
    For i = 1 To 1000000
        ' Busy work
    Next i
    
    Dim duration As Double
    duration = Timer - startTime
    
    appLogger.Debug "✓ Order saved successfully"
    appLogger.Debug "Processing time: " & Format$(duration, "0.000") & " seconds"
    
    ' Step 4: Send confirmation
    appLogger.Debug "Sending order confirmation email..."
    Dim emailValid As Boolean
    emailValid = ValidationHelper.ValidateEmail("customer@example.com")
    
    If emailValid Then
        appLogger.Debug "✓ Confirmation email sent"
    End If
    
    ' Success
    appLogger.Info "Order #" & orderId & " processed successfully!"
    appLogger.Info "Customer will receive confirmation at customer@example.com"
    
    Debug.Print ""
    Exit Sub
    
ErrorHandler:
    appLogger.Error "Order processing failed for order #" & orderId, Err
    Debug.Print ""
End Sub

'==============================================================================
' UTILITY METHODS
'==============================================================================

'@Description("Demonstrates complete CRUD operations")
Private Sub DemonstrateCRUD()
    appLogger.Info "=== CRUD Operations Demo ==="
    
    ' Create
    appLogger.Debug "CREATE: Creating new customer record"
    
    ' Read
    appLogger.Debug "READ: Fetching customer by ID"
    
    ' Update
    appLogger.Debug "UPDATE: Updating customer information"
    
    ' Delete
    appLogger.Debug "DELETE: Marking customer as inactive"
End Sub

'@Description("Demonstrates error handling best practices")
Private Sub DemonstrateErrorHandling()
    On Error GoTo ErrorHandler
    
    appLogger.Info "Executing operation with error handling"
    
    ' Simulate error
    Err.Raise vbObjectError + 1001, "CompleteExample", "Simulated error for demonstration"
    
    Exit Sub
    
ErrorHandler:
    appLogger.Error "Operation failed", Err
    
    ' Handle specific errors
    Select Case Err.Number
        Case vbObjectError + 1001
            appLogger.Warn "This is a known error, handling gracefully"
        Case Else
            appLogger.Fatal "Unexpected error occurred"
    End Select
End Sub
