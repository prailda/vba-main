Attribute VB_Name = "Example_Logging"
'@Folder("Examples")
'@Description("Examples demonstrating logging framework usage")
Option Explicit

'@Description("Demonstrates basic file logging")
Public Sub Example_FileLogging()
    ' Create file logger
    Dim logger As ILogger
    Set logger = FileLogger.Create("C:\Temp\VBA\application.log", Debug)
    
    ' Log messages at different levels
    logger.Trace "Application trace message"
    logger.Debug "Debug information: variable value = 42"
    logger.Info "Application started successfully"
    logger.Warn "Configuration file not found, using defaults"
    
    ' Simulate error
    On Error Resume Next
    Dim result As Long
    result = 10 / 0
    If Err.Number <> 0 Then
        logger.Error "Division by zero error occurred", Err
        Err.Clear
    End If
    On Error GoTo 0
    
    logger.Info "Logging example completed"
    
    Debug.Print "Check log file at: C:\Temp\VBA\application.log"
End Sub

'@Description("Demonstrates console logging to Immediate Window")
Public Sub Example_ConsoleLogging()
    ' Create console logger
    Dim logger As ILogger
    Set logger = ConsoleLogger.Create(Debug)
    
    Debug.Print "=== Console Logging Example ==="
    
    logger.Debug "Starting process..."
    logger.Info "Processing 100 records"
    logger.Info "50% complete"
    logger.Info "Processing complete"
    logger.Info "Total time: 2.5 seconds"
    
    Debug.Print "=== Example Complete ==="
End Sub

'@Description("Demonstrates logging with different minimum levels")
Public Sub Example_LogLevels()
    Debug.Print "=== Log Levels Example ==="
    
    ' Logger with INFO level - won't show DEBUG or TRACE
    Dim infoLogger As ILogger
    Set infoLogger = ConsoleLogger.Create(Info)
    
    Debug.Print vbCrLf & "Logger with INFO level:"
    infoLogger.Trace "This won't appear"
    infoLogger.Debug "This won't appear either"
    infoLogger.Info "This will appear"
    infoLogger.Warn "This will appear"
    infoLogger.Error "This will appear"
    
    ' Logger with DEBUG level - will show DEBUG and above
    Dim debugLogger As ILogger
    Set debugLogger = ConsoleLogger.Create(Debug)
    
    Debug.Print vbCrLf & "Logger with DEBUG level:"
    debugLogger.Trace "This won't appear"
    debugLogger.Debug "This will appear"
    debugLogger.Info "This will appear"
    
    ' Logger with TRACE level - will show everything
    Dim traceLogger As ILogger
    Set traceLogger = ConsoleLogger.Create(Trace)
    
    Debug.Print vbCrLf & "Logger with TRACE level:"
    traceLogger.Trace "This will appear"
    traceLogger.Debug "This will appear"
    traceLogger.Info "This will appear"
End Sub

'@Description("Demonstrates structured logging in a business operation")
Public Sub Example_BusinessOperationLogging()
    Dim logger As ILogger
    Set logger = ConsoleLogger.Create(Debug)
    
    Debug.Print "=== Business Operation Logging ==="
    
    ' Simulate order processing
    Dim orderId As Long
    orderId = 12345
    
    logger.Info "Processing order: " & orderId
    logger.Debug "Validating order data"
    
    ' Simulate validation
    Dim isValid As Boolean
    isValid = True
    
    If Not isValid Then
        logger.Warn "Order validation failed: " & orderId
        Exit Sub
    End If
    
    logger.Debug "Order validation passed"
    logger.Debug "Calculating totals"
    
    Dim total As Currency
    total = 999.99
    
    logger.Debug "Order total: " & Format$(total, "$#,##0.00")
    logger.Debug "Saving to database"
    
    ' Simulate save
    Dim saved As Boolean
    saved = True
    
    If saved Then
        logger.Info "Order saved successfully: " & orderId
    Else
        logger.Error "Failed to save order: " & orderId
    End If
    
    Debug.Print "=== Operation Complete ==="
End Sub

'@Description("Demonstrates error logging with context")
Public Sub Example_ErrorLogging()
    Dim logger As ILogger
    Set logger = FileLogger.Create("C:\Temp\VBA\errors.log", Info)
    
    On Error GoTo ErrorHandler
    
    logger.Info "Starting critical operation"
    
    ' Simulate different types of errors
    Dim customerName As String
    customerName = vbNullString
    
    If Len(customerName) = 0 Then
        Err.Raise vbObjectError + 1001, "OrderProcessor", "Customer name cannot be empty"
    End If
    
    logger.Info "Operation completed successfully"
    Exit Sub
    
ErrorHandler:
    Select Case Err.Number
        Case vbObjectError + 1001
            logger.Error "Validation error in operation", Err
        Case Else
            logger.Fatal "Unexpected error occurred", Err
    End Select
    
    ' In production, might want to show user-friendly message
    Debug.Print "Error logged to file: C:\Temp\VBA\errors.log"
End Sub

'@Description("Demonstrates performance logging")
Public Sub Example_PerformanceLogging()
    Dim logger As ILogger
    Set logger = ConsoleLogger.Create(Debug)
    
    Debug.Print "=== Performance Logging Example ==="
    
    Dim startTime As Double
    startTime = Timer
    
    logger.Debug "Starting performance-critical operation"
    
    ' Simulate work
    Dim i As Long
    Dim total As Long
    For i = 1 To 1000000
        total = total + i
    Next i
    
    Dim duration As Double
    duration = Timer - startTime
    
    logger.Info "Operation completed in " & Format$(duration, "0.000") & " seconds"
    logger.Debug "Processed " & Format$(1000000, "#,##0") & " iterations"
    logger.Debug "Average time per iteration: " & Format$(duration / 1000000 * 1000, "0.000") & " ms"
    
    Debug.Print "=== Example Complete ==="
End Sub
