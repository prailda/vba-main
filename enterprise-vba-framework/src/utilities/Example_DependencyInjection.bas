Attribute VB_Name = "Example_DependencyInjection"
'@Folder("Examples")
'@Description("Example demonstrating Dependency Injection usage")
Option Explicit

'@Description("Demonstrates basic DI container configuration and usage")
Public Sub Example_BasicDI()
    ' Create and configure DI container
    Dim container As IDependencyContainer
    Set container = DependencyContainer.Create()
    
    ' Register services
    Debug.Print "Registering services..."
    container.Register "ILogger", "ConsoleLogger", Singleton
    
    ' Resolve and use service
    Debug.Print "Resolving ILogger service..."
    Dim logger As ILogger
    Set logger = container.Resolve("ILogger")
    
    logger.Info "DI Container initialized successfully"
    logger.Debug "This is a debug message"
    logger.Warn "This is a warning message"
    
    Debug.Print "Example completed successfully"
End Sub

'@Description("Demonstrates singleton vs transient lifetime")
Public Sub Example_ServiceLifetimes()
    Dim container As IDependencyContainer
    Set container = DependencyContainer.Create()
    
    ' Register as Singleton
    container.Register "ISingletonLogger", "FileLogger", Singleton
    
    ' Register as Transient
    container.Register "ITransientLogger", "FileLogger", Transient
    
    ' Resolve Singleton twice - should be same instance
    Dim logger1 As ILogger
    Dim logger2 As ILogger
    Set logger1 = container.Resolve("ISingletonLogger")
    Set logger2 = container.Resolve("ISingletonLogger")
    
    Debug.Print "Singleton instances are same: " & (logger1 Is logger2) ' True
    
    ' Resolve Transient twice - should be different instances
    Dim logger3 As ILogger
    Dim logger4 As ILogger
    Set logger3 = container.Resolve("ITransientLogger")
    Set logger4 = container.Resolve("ITransientLogger")
    
    Debug.Print "Transient instances are different: " & Not (logger3 Is logger4) ' True
End Sub

'@Description("Demonstrates named service registration")
Public Sub Example_NamedServices()
    Dim container As IDependencyContainer
    Set container = DependencyContainer.Create()
    
    ' Register multiple implementations with different names
    container.RegisterNamed "FileLogger", "ILogger", "FileLogger", Singleton
    container.RegisterNamed "ConsoleLogger", "ILogger", "ConsoleLogger", Singleton
    
    ' Resolve by name
    Dim fileLogger As ILogger
    Set fileLogger = container.ResolveNamed("FileLogger")
    fileLogger.Info "Message from FileLogger"
    
    Dim consoleLogger As ILogger
    Set consoleLogger = container.ResolveNamed("ConsoleLogger")
    consoleLogger.Info "Message from ConsoleLogger"
End Sub

'@Description("Demonstrates complete application setup with DI")
Public Sub Example_ApplicationSetup()
    ' Global container initialization
    Dim container As IDependencyContainer
    Set container = DependencyContainer.Create()
    
    ' Configure all application services
    Debug.Print "Configuring application services..."
    
    ' Logging
    Dim fileLogger As ILogger
    Set fileLogger = FileLogger.Create("C:\Temp\VBA\app.log", Debug)
    container.RegisterInstance "ILogger", fileLogger
    
    ' Code Generator (would need ITemplateEngine implementation)
    ' container.Register "ICodeGenerator", "CodeGenerator", Transient
    
    ' Configuration
    ' container.Register "IConfiguration", "ConfigurationManager", Singleton
    
    Debug.Print "Application configured successfully"
    
    ' Use services throughout application
    Dim logger As ILogger
    Set logger = container.Resolve("ILogger")
    logger.Info "Application started"
    logger.Info "Services initialized"
End Sub
