# Enterprise VBA Development Framework

## Production-Ready Code для автоматизации разработки в VBE Excel

### Описание

Данный фреймворк представляет собой комплексное решение корпоративного уровня для автоматизации и улучшения процессов разработки VBA приложений в Microsoft Excel.

### Структура проекта

```
enterprise-vba-framework/
│
├── src/
│   ├── core/                          # Базовая инфраструктура
│   │   ├── IDependencyContainer.cls   # Интерфейс DI контейнера
│   │   ├── DependencyContainer.cls    # Реализация DI контейнера
│   │   └── ServiceRegistration.cls    # Регистрация сервисов
│   │
│   ├── logging/                       # Система логирования
│   │   ├── ILogger.cls                # Интерфейс логгера
│   │   ├── FileLogger.cls             # Логирование в файл
│   │   └── ConsoleLogger.cls          # Логирование в Immediate Window
│   │
│   ├── development-automation/        # Автоматизация разработки
│   │   ├── ICodeGenerator.cls         # Интерфейс генератора кода
│   │   ├── CodeGenerator.cls          # Реализация генератора
│   │   ├── ClassSpecification.cls     # Спецификация класса
│   │   ├── PropertySpecification.cls  # Спецификация свойства
│   │   ├── MethodSpecification.cls    # Спецификация метода
│   │   └── ParameterSpecification.cls # Спецификация параметра
│   │
│   ├── project-management/            # Управление проектами
│   ├── testing-framework/             # Фреймворк тестирования
│   ├── code-templates/                # Шаблоны кода
│   └── utilities/                     # Утилиты
│
└── README.md
```

### Основные компоненты

#### 1. Dependency Injection Container

Контейнер зависимостей для управления lifecycle объектов и автоматической инъекции зависимостей.

**Пример использования:**

```vba
Sub ConfigureServices()
    Dim container As IDependencyContainer
    Set container = DependencyContainer.Create()
    
    ' Регистрация сервисов
    container.Register "ILogger", "FileLogger", Singleton
    container.Register "ICodeGenerator", "CodeGenerator", Transient
    
    ' Регистрация экземпляра
    Dim config As New AppConfiguration
    container.RegisterInstance "IConfiguration", config
End Sub

Sub UseServices()
    Dim logger As ILogger
    Set logger = container.Resolve("ILogger")
    
    logger.Info "Application started"
End Sub
```

**Поддерживаемые типы lifetime:**
- **Singleton** - один экземпляр на весь контейнер
- **Transient** - новый экземпляр при каждом разрешении
- **Scoped** - один экземпляр на область видимости

#### 2. Logging Framework

Многоуровневая система логирования с поддержкой различных выводов.

**Уровни логирования:**
- TRACE - детальная трассировка
- DEBUG - отладочная информация
- INFO - информационные сообщения
- WARN - предупреждения
- ERROR - ошибки
- FATAL - критические ошибки

**Примеры:**

```vba
' FileLogger - логирование в файл
Sub UseFileLogger()
    Dim logger As ILogger
    Set logger = FileLogger.Create("C:\Logs\app.log", Debug)
    
    logger.Debug "Debug message"
    logger.Info "Information message"
    logger.Warn "Warning message"
    logger.Error "Error occurred", Err
End Sub

' ConsoleLogger - логирование в Immediate Window
Sub UseConsoleLogger()
    Dim logger As ILogger
    Set logger = ConsoleLogger.Create(Info)
    
    logger.Info "Starting process..."
    logger.Info "Process completed"
End Sub
```

#### 3. Code Generator

Автоматическая генерация VBA кода по спецификациям.

**Генерация класса:**

```vba
Sub GenerateCustomerClass()
    Dim logger As ILogger
    Set logger = ConsoleLogger.Create()
    
    Dim templateEngine As ITemplateEngine
    ' Set templateEngine = ... (implement separately)
    
    Dim generator As ICodeGenerator
    Set generator = CodeGenerator.Create(templateEngine, logger)
    
    ' Создание спецификации класса
    Dim spec As New ClassSpecification
    spec.ClassName = "Customer"
    spec.FolderPath = "Domain.Entities"
    spec.Description = "Represents a customer entity"
    spec.IsPredeclaredId = False
    
    ' Добавление интерфейса
    spec.AddInterface "IEntity"
    
    ' Добавление свойств
    spec.AddProperty "ID", "Long", ReadOnly
    spec.AddProperty "Name", "String", ReadWrite
    spec.AddProperty "Email", "String", ReadWrite
    spec.AddProperty "IsActive", "Boolean", ReadWrite
    
    ' Добавление методов
    spec.AddMethod "Validate", "Boolean", "Public"
    spec.AddMethod "Save", "Boolean", "Public"
    
    ' Генерация кода
    Dim generatedCode As String
    generatedCode = generator.GenerateClass(spec)
    
    ' Вывод или сохранение кода
    Debug.Print generatedCode
End Sub
```

**Результат генерации:**

```vba
VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Customer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'@Folder("Domain.Entities")
'@Description("Represents a customer entity")
Option Explicit

Implements IEntity

Private Type TCustomer
    ID As Long
    Name As String
    Email As String
    IsActive As Boolean
End Type

Private this As TCustomer

Public Property Get ID() As Long
    ID = this.ID
End Property

Public Property Get Name() As String
    Name = this.Name
End Property

Public Property Let Name(ByVal value As String)
    this.Name = value
End Property

Public Property Get Email() As String
    Email = this.Email
End Property

Public Property Let Email(ByVal value As String)
    this.Email = value
End Property

Public Property Get IsActive() As Boolean
    IsActive = this.IsActive
End Property

Public Property Let IsActive(ByVal value As Boolean)
    this.IsActive = value
End Property

Public Function Validate() As Boolean
    ' TODO: Implement Validate
End Function

Public Function Save() As Boolean
    ' TODO: Implement Save
End Function
```

### Архитектурные принципы

Фреймворк построен на следующих принципах:

1. **SOLID Principles**
   - Single Responsibility
   - Open/Closed
   - Liskov Substitution
   - Interface Segregation
   - Dependency Inversion

2. **Design Patterns**
   - Dependency Injection
   - Factory Pattern
   - Strategy Pattern
   - Observer Pattern
   - Repository Pattern

3. **Best Practices**
   - Явные типы данных
   - Раннее связывание (Early Binding)
   - Proper error handling
   - Comprehensive logging
   - Unit testing support

### Установка

1. Скопируйте все файлы из `src/` в ваш VBA проект
2. Убедитесь, что включены необходимые References:
   - Microsoft Scripting Runtime
   - Microsoft VBScript Regular Expressions 5.5

3. Настройте Dependency Container при запуске:

```vba
Sub Application_Initialize()
    ConfigureServices
End Sub
```

### Использование с Rubberduck

Фреймворк полностью совместим с [Rubberduck VBA](https://rubberduckvba.com/) и использует его аннотации:

- `@Folder` - организация кода по папкам
- `@Description` - документирование компонентов
- `@PredeclaredId` - маркировка классов с default instance
- `@Interface` - маркировка интерфейсов
- `@TestModule` - тестовые модули
- `@Test` - тестовые методы

### Примеры использования

#### Полный пример: Логирование с DI

```vba
' Настройка DI Container
Sub ConfigureLogging()
    Dim container As IDependencyContainer
    Set container = DependencyContainer.Create()
    
    ' Регистрация логгера как Singleton
    container.RegisterInstance "ILogger", FileLogger.Create("C:\Logs\app.log")
End Sub

' Использование в бизнес-логике
Sub ProcessOrder(orderId As Long)
    Dim logger As ILogger
    Set logger = container.Resolve("ILogger")
    
    logger.Info "Processing order: " & orderId
    
    On Error GoTo ErrorHandler
    
    ' Бизнес-логика
    logger.Debug "Validating order data"
    ' ... validation code
    
    logger.Debug "Saving order to database"
    ' ... save code
    
    logger.Info "Order processed successfully: " & orderId
    Exit Sub
    
ErrorHandler:
    logger.Error "Failed to process order: " & orderId, Err
    Err.Raise Err.Number
End Sub
```

#### Генерация ViewModel класса

```vba
Sub GenerateOrderViewModel()
    Dim generator As ICodeGenerator
    Set generator = CodeGenerator.Create(templateEngine, logger)
    
    Dim spec As New ClassSpecification
    spec.ClassName = "OrderViewModel"
    spec.FolderPath = "Presentation.ViewModels"
    spec.IsPredeclaredId = True
    spec.AddInterface "IViewModel"
    spec.AddInterface "INotifyPropertyChanged"
    
    ' Properties
    spec.AddProperty "OrderId", "Long", ReadWrite
    spec.AddProperty "CustomerName", "String", ReadWrite
    spec.AddProperty "OrderDate", "Date", ReadWrite
    spec.AddProperty "TotalAmount", "Currency", ReadWrite
    spec.AddProperty "SaveCommand", "ICommand", ReadOnly
    spec.AddProperty "CancelCommand", "ICommand", ReadOnly
    
    Dim code As String
    code = generator.GenerateClass(spec)
    
    ' Экспорт в файл или вставка в проект
    Debug.Print code
End Sub
```

### Расширение функциональности

#### Создание custom Logger

```vba
' DatabaseLogger.cls
Option Explicit
Implements ILogger

Private conn As ADODB.Connection
Private minLevel As LogLevel

Public Sub Initialize(connectionString As String)
    Set conn = New ADODB.Connection
    conn.Open connectionString
End Sub

Private Sub ILogger_Log(level As LogLevel, message As String, Optional err As ErrObject = Nothing)
    If level < minLevel Then Exit Sub
    
    Dim sql As String
    sql = "INSERT INTO Logs (Timestamp, Level, Message) VALUES (?, ?, ?)"
    
    Dim cmd As New ADODB.Command
    cmd.ActiveConnection = conn
    cmd.CommandText = sql
    cmd.Parameters.Append cmd.CreateParameter("@ts", adDate, adParamInput, , Now)
    cmd.Parameters.Append cmd.CreateParameter("@level", adInteger, adParamInput, , level)
    cmd.Parameters.Append cmd.CreateParameter("@msg", adVarChar, adParamInput, 1000, message)
    cmd.Execute
End Sub

' Implement other ILogger methods...
```

### Лучшие практики

1. **Всегда используйте DI Container** для управления зависимостями
2. **Логируйте на соответствующих уровнях**:
   - DEBUG для отладки
   - INFO для важных событий
   - WARN для потенциальных проблем
   - ERROR для ошибок
3. **Генерируйте код по спецификациям** для консистентности
4. **Следуйте SOLID принципам** в архитектуре
5. **Используйте интерфейсы** для абстракции

### Документация

Полное руководство доступно в файле:
- [Enterprise_VBA_Development_Guide.md](../../Enterprise_VBA_Development_Guide.md)

### Требования

- Microsoft Excel 2013 или выше
- Windows 7 или выше
- Опционально: Rubberduck VBA для enhanced IDE experience

### Лицензия

Production-Ready Code для использования в корпоративных проектах.

### Поддержка

Для вопросов и предложений по улучшению фреймворка обращайтесь к документации в главном руководстве.

---

**Версия:** 1.0.0  
**Дата:** 2026-01-06  
**Статус:** Production Ready
