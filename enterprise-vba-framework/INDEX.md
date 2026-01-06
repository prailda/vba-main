# Enterprise VBA Framework - Complete Index

## 📋 Навигация по проекту

### 🎯 Начать здесь
- **[QUICKSTART.md](QUICKSTART.md)** - Быстрый старт за 5 минут
- **[SUMMARY.md](SUMMARY.md)** - Обзор всего проекта
- **[README.md](README.md)** - Основная документация фреймворка

### 📚 Полная документация
- **[Enterprise_VBA_Development_Guide.md](../Enterprise_VBA_Development_Guide.md)** - Комплексное руководство (450+ строк)

## 📂 Структура файлов

### Core Framework (Базовая инфраструктура)
```
src/core/
├── IDependencyContainer.cls    # Интерфейс DI контейнера
├── DependencyContainer.cls     # Реализация DI контейнера  
└── ServiceRegistration.cls     # Регистрация сервисов
```

**Использование:**
```vba
Dim container As IDependencyContainer
Set container = DependencyContainer.Create()
container.Register "ILogger", "FileLogger", Singleton
```

### Logging Framework (Система логирования)
```
src/logging/
├── ILogger.cls                 # Интерфейс логгера
├── FileLogger.cls              # Логирование в файл
└── ConsoleLogger.cls           # Логирование в Immediate Window
```

**Использование:**
```vba
Dim logger As ILogger
Set logger = FileLogger.Create("C:\Logs\app.log", Debug)
logger.Info "Application started"
```

### Code Generation (Генерация кода)
```
src/development-automation/
├── ICodeGenerator.cls          # Интерфейс генератора
├── CodeGenerator.cls           # Реализация генератора
├── ClassSpecification.cls      # Спецификация класса
├── PropertySpecification.cls   # Спецификация свойства
├── MethodSpecification.cls     # Спецификация метода
└── ParameterSpecification.cls  # Спецификация параметра
```

**Использование:**
```vba
Dim spec As New ClassSpecification
spec.ClassName = "Customer"
spec.AddProperty "Name", "String", ReadWrite
```

### Testing Framework (Фреймворк тестирования)
```
src/testing-framework/
├── IAssert.cls                 # Интерфейс assertions
└── Assert.cls                  # Реализация assertions
```

**Использование:**
```vba
Dim assert As IAssert
Set assert = New Assert
assert.AreEqual 4, 2 + 2
```

### Utilities (Утилиты)
```
src/utilities/
├── StringUtilities.bas         # Работа со строками
├── ValidationHelper.bas        # Валидация данных
├── Example_DependencyInjection.bas     # Примеры DI
├── Example_Logging.bas                 # Примеры логирования
├── Example_CodeGeneration.bas          # Примеры генерации
└── CompleteExample.bas                 # Полный пример
```

## 🎓 Учебные материалы

### Уровень 1: Начинающий (15 минут)
1. Прочитать [QUICKSTART.md](QUICKSTART.md)
2. Запустить `Example_Logging.Example_ConsoleLogging()`
3. Запустить `Example_DependencyInjection.Example_BasicDI()`

### Уровень 2: Средний (30 минут)
1. Изучить [README.md](README.md)
2. Запустить `CompleteExample.Main()`
3. Поэкспериментировать с генерацией кода

### Уровень 3: Продвинутый (1-2 часа)
1. Прочитать [Enterprise_VBA_Development_Guide.md](../Enterprise_VBA_Development_Guide.md)
2. Создать свой проект используя фреймворк
3. Добавить custom компоненты

## 🔍 Поиск по функционалу

### Dependency Injection
- **Интерфейс:** `src/core/IDependencyContainer.cls`
- **Реализация:** `src/core/DependencyContainer.cls`
- **Примеры:** `src/utilities/Example_DependencyInjection.bas`
- **Документация:** [README.md#dependency-injection](README.md#1-dependency-injection-container)

### Logging
- **Интерфейс:** `src/logging/ILogger.cls`
- **File Logger:** `src/logging/FileLogger.cls`
- **Console Logger:** `src/logging/ConsoleLogger.cls`
- **Примеры:** `src/utilities/Example_Logging.bas`
- **Документация:** [README.md#logging](README.md#2-logging-framework)

### Code Generation
- **Интерфейс:** `src/development-automation/ICodeGenerator.cls`
- **Реализация:** `src/development-automation/CodeGenerator.cls`
- **Примеры:** `src/utilities/Example_CodeGeneration.bas`
- **Документация:** [README.md#code-generator](README.md#3-code-generator)

### Testing
- **Интерфейс:** `src/testing-framework/IAssert.cls`
- **Реализация:** `src/testing-framework/Assert.cls`
- **Примеры:** В `CompleteExample.bas` → `DemonstrateTesting()`
- **Документация:** [Enterprise Guide → Testing](../Enterprise_VBA_Development_Guide.md#34-testing-framework)

### Utilities
- **String Utils:** `src/utilities/StringUtilities.bas`
- **Validation:** `src/utilities/ValidationHelper.bas`
- **Примеры:** `CompleteExample.bas`

## 📊 Быстрый справочник

### Инициализация приложения
```vba
Public Container As IDependencyContainer

Sub Initialize()
    Set Container = DependencyContainer.Create()
    Container.RegisterInstance "ILogger", ConsoleLogger.Create(Debug)
End Sub
```

### Базовое логирование
```vba
Dim logger As ILogger
Set logger = Container.Resolve("ILogger")
logger.Info "Message"
logger.Debug "Debug info"
logger.Error "Error occurred", Err
```

### Генерация класса
```vba
Dim spec As New ClassSpecification
spec.ClassName = "MyClass"
spec.AddProperty "ID", "Long", ReadOnly
spec.AddProperty "Name", "String", ReadWrite
spec.AddMethod "Save", "Boolean", "Public"
```

### Unit Testing
```vba
Dim assert As IAssert
Set assert = New Assert
assert.AreEqual expected, actual
assert.IsTrue condition
assert.IsNotNothing object
```

### Validation
```vba
Dim valid As Boolean
valid = ValidationHelper.ValidateEmail("user@example.com")
valid = ValidationHelper.ValidateRange(25, 18, 65, "Age")
valid = ValidationHelper.ValidateRequired(value, "Field")
```

### String Operations
```vba
Dim result As String
result = StringUtilities.Format("Hello, {0}!", "World")
result = StringUtilities.ToPascalCase("hello world")
result = StringUtilities.PadLeft("42", 5, "0")
```

## 🎯 Сценарии использования

### Сценарий 1: Простое консольное приложение
**Файлы:** DI Container + Console Logger  
**Пример:** `Example_DependencyInjection.Example_BasicDI()`

### Сценарий 2: Приложение с логированием в файл
**Файлы:** DI Container + File Logger  
**Пример:** `Example_Logging.Example_FileLogging()`

### Сценарий 3: Генерация entity классов
**Файлы:** Code Generator + Specifications  
**Пример:** `Example_CodeGeneration.Example_GenerateSimpleClass()`

### Сценарий 4: Unit тестирование
**Файлы:** Assert + Test utilities  
**Пример:** `CompleteExample.DemonstrateTesting()`

### Сценарий 5: Полное enterprise приложение
**Файлы:** Все компоненты  
**Пример:** `CompleteExample.Main()`

## 📖 Дополнительные ресурсы

### В этом репозитории
- [Rubberduck Guidelines](../../Rubberduck%20Guidelines.md)
- [MVVM Pattern](../../model-view-viewmodel.md)
- [OOP in VBA](../../oop-battleship-part-1-the-patterns.md)
- [Code Insights](../../code-insights-with-rubberduck-excel.md)

### Внешние ресурсы
- [Rubberduck VBA](https://rubberduckvba.com/)
- [VBA Language Spec](../../4-vba-program-organization.md)

## ⚡ Горячие клавиши и команды

### Для тестирования
```vba
' В Immediate Window:
CompleteExample.Main                    ' Полная демонстрация
Example_Logging.Example_ConsoleLogging  ' Тест логирования
Example_DependencyInjection.Example_BasicDI  ' Тест DI
```

### Для отладки
- `F5` - Запустить макрос
- `F8` - Шаг с заходом
- `Ctrl+G` - Immediate Window
- `Ctrl+R` - Project Explorer

## 🎨 Шаблоны кода

### Шаблон класса с DI
```vba
Option Explicit
Implements IService

Private logger As ILogger

Public Sub Initialize(log As ILogger)
    Set logger = log
End Sub

Public Sub DoWork()
    logger.Info "Working..."
End Sub
```

### Шаблон метода с обработкой ошибок
```vba
Public Function ProcessData() As Boolean
    On Error GoTo ErrorHandler
    
    logger.Debug "Processing started"
    ' ... logic
    logger.Info "Processing completed"
    ProcessData = True
    
    Exit Function
ErrorHandler:
    logger.Error "Processing failed", Err
    ProcessData = False
End Function
```

## 🔧 Troubleshooting

### Проблема: "Compile error: User-defined type not defined"
**Решение:** Добавить Reference: Microsoft Scripting Runtime

### Проблема: "Object doesn't support this property or method"
**Решение:** Проверить, что все интерфейсы реализованы

### Проблема: Logger не пишет в файл
**Решение:** Проверить права доступа к папке логов

## 📞 Помощь и поддержка

1. Проверьте [QUICKSTART.md](QUICKSTART.md)
2. Изучите примеры в `src/utilities/`
3. Прочитайте соответствующий раздел в [README.md](README.md)
4. Посмотрите [Enterprise Guide](../Enterprise_VBA_Development_Guide.md)

---

**Последнее обновление:** 2026-01-06  
**Версия:** 1.0.0  
**Статус:** Production Ready ✅
