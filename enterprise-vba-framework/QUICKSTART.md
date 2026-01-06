# Quick Start Guide - Enterprise VBA Framework

## Быстрый старт за 5 минут

### Шаг 1: Настройка проекта (1 минута)

1. Импортируйте основные модули в ваш VBA проект:
   - `IDependencyContainer.cls`
   - `DependencyContainer.cls`
   - `ILogger.cls`
   - `ConsoleLogger.cls`

2. Убедитесь, что в References включена библиотека:
   - **Microsoft Scripting Runtime**

### Шаг 2: Инициализация (1 минута)

Создайте модуль `Application` и добавьте код инициализации:

```vba
Attribute VB_Name = "Application"
Option Explicit

Public Container As IDependencyContainer

Public Sub Initialize()
    ' Создание DI Container
    Set Container = DependencyContainer.Create()
    
    ' Регистрация базовых сервисов
    Container.RegisterInstance "ILogger", ConsoleLogger.Create(Debug)
    
    Debug.Print "Application initialized"
End Sub
```

### Шаг 3: Первое использование (3 минуты)

Создайте простой пример использования:

```vba
Sub FirstExample()
    ' Инициализация приложения
    Application.Initialize
    
    ' Получение логгера из контейнера
    Dim logger As ILogger
    Set logger = Container.Resolve("ILogger")
    
    ' Использование логгера
    logger.Info "Hello, Enterprise VBA Framework!"
    logger.Debug "This is a debug message"
    logger.Warn "This is a warning"
    
    ' Логирование с ошибкой
    On Error Resume Next
    Dim result As Long
    result = 10 / 0
    If Err.Number <> 0 Then
        logger.Error "An error occurred", Err
        Err.Clear
    End If
    On Error GoTo 0
    
    logger.Info "Example completed"
End Sub
```

### Шаг 4: Запуск

Нажмите `F5` для запуска `FirstExample`. Вы увидите в Immediate Window:

```
Application initialized
10:30:45 [INF] Hello, Enterprise VBA Framework!
10:30:45 [DBG] This is a debug message
10:30:45 [WRN] This is a warning
10:30:45 [ERR] An error occurred | Error #11: Division by zero
10:30:45 [INF] Example completed
```

## Следующие шаги

### Добавление генерации кода

```vba
Sub GenerateClass()
    ' Создание спецификации
    Dim spec As New ClassSpecification
    spec.ClassName = "Product"
    spec.AddProperty "ID", "Long", ReadOnly
    spec.AddProperty "Name", "String", ReadWrite
    spec.AddProperty "Price", "Currency", ReadWrite
    
    Debug.Print "Class specification created for: " & spec.ClassName
End Sub
```

### Добавление тестирования

```vba
Sub RunTests()
    Dim assert As IAssert
    Set assert = New Assert
    
    ' Тест 1: Сложение
    Dim expected As Long
    expected = 4
    
    Dim actual As Long
    actual = 2 + 2
    
    assert.AreEqual expected, actual, "Addition test"
    
    Debug.Print "All tests passed!"
End Sub
```

### Использование утилит

```vba
Sub UseUtilities()
    ' String utilities
    Dim formatted As String
    formatted = StringUtilities.Format("Hello, {0}! You have {1} messages.", "John", 5)
    Debug.Print formatted ' "Hello, John! You have 5 messages."
    
    ' Validation
    Dim isValid As Boolean
    isValid = ValidationHelper.ValidateEmail("user@example.com")
    Debug.Print "Email is valid: " & isValid ' True
    
    isValid = ValidationHelper.ValidateRange(50, 1, 100, "Age")
    Debug.Print "Age is valid: " & isValid ' True
End Sub
```

## Рекомендуемая структура проекта

```
YourProject.xlsm
├── Core
│   ├── Application (module) - точка входа
│   └── Configuration (module) - настройки
│
├── Domain
│   ├── Entities (folder)
│   │   ├── Customer.cls
│   │   ├── Order.cls
│   │   └── Product.cls
│   └── Interfaces (folder)
│       ├── IEntity.cls
│       └── IRepository.cls
│
├── Business
│   └── Services (folder)
│       ├── CustomerService.cls
│       └── OrderService.cls
│
├── DataAccess
│   └── Repositories (folder)
│       ├── CustomerRepository.cls
│       └── OrderRepository.cls
│
├── Presentation
│   ├── ViewModels (folder)
│   │   └── OrderViewModel.cls
│   └── Views (folder)
│       └── OrderForm.frm
│
└── Infrastructure
    ├── Framework (folder) - импортированные компоненты
    └── Utilities (folder) - вспомогательные модули
```

## Полезные советы

1. **Всегда инициализируйте Container при запуске**
   ```vba
   Private Sub Workbook_Open()
       Application.Initialize
   End Sub
   ```

2. **Используйте Try-Catch паттерн с логированием**
   ```vba
   On Error GoTo ErrorHandler
   ' Ваш код
   Exit Sub
   
   ErrorHandler:
       logger.Error "Operation failed", Err
   ```

3. **Регистрируйте сервисы один раз**
   ```vba
   ' В Application.Initialize
   Container.Register "ICustomerService", "CustomerService", Singleton
   ```

4. **Документируйте код аннотациями Rubberduck**
   ```vba
   '@Description("Processes customer orders")
   Public Sub ProcessOrders()
   ```

## Дополнительная документация

- [Полное руководство](../../Enterprise_VBA_Development_Guide.md)
- [README фреймворка](README.md)
- [Примеры использования](src/utilities/)

## Поддержка

При возникновении вопросов:
1. Проверьте примеры в папке `src/utilities/`
2. Ознакомьтесь с полным руководством
3. Проверьте наличие всех необходимых References

---

**Готовы к production использованию!** 🚀
