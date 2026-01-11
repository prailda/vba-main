# Installation Guide - Enterprise VBA Framework

## Руководство по установке

### Метод 1: Быстрая установка (Рекомендуется)

#### Шаг 1: Подготовка
1. Создайте новый Excel файл или откройте существующий
2. Нажмите `Alt+F11` для открытия VBA Editor

#### Шаг 2: Импорт основных компонентов
В VBA Editor:
1. **File → Import File** (или `Ctrl+M`)
2. Импортируйте файлы в следующем порядке:

**Обязательные компоненты:**
```
✅ src/core/IDependencyContainer.cls
✅ src/core/DependencyContainer.cls
✅ src/core/ServiceRegistration.cls
✅ src/logging/ILogger.cls
✅ src/logging/ConsoleLogger.cls
```

**Опциональные компоненты (по необходимости):**
```
⭐ src/logging/FileLogger.cls                    (для файлового логирования)
⭐ src/development-automation/ICodeGenerator.cls  (для генерации кода)
⭐ src/development-automation/CodeGenerator.cls
⭐ src/development-automation/*.cls               (спецификации)
⭐ src/testing-framework/*.cls                    (для тестирования)
⭐ src/utilities/*.bas                            (утилиты)
```

#### Шаг 3: Настройка References
1. В VBA Editor: **Tools → References**
2. Установите галочки:
   - ✅ **Microsoft Scripting Runtime**
   - ✅ **Microsoft VBScript Regular Expressions 5.5** (для валидации)

#### Шаг 4: Создание модуля инициализации
1. Insert → Module
2. Назовите модуль `Application`
3. Вставьте код:

```vba
Attribute VB_Name = "Application"
Option Explicit

Public Container As IDependencyContainer

Public Sub Initialize()
    ' Создание DI Container
    Set Container = DependencyContainer.Create()
    
    ' Регистрация базовых сервисов
    Container.RegisterInstance "ILogger", ConsoleLogger.Create(Debug)
    
    Debug.Print "Enterprise VBA Framework initialized successfully!"
End Sub

' Вызовите этот метод при открытии книги
Private Sub Workbook_Open()
    Initialize
End Sub
```

#### Шаг 5: Проверка установки
Запустите:
```vba
Sub TestInstallation()
    Application.Initialize
    
    Dim logger As ILogger
    Set logger = Container.Resolve("ILogger")
    logger.Info "Installation successful!"
End Sub
```

---

### Метод 2: Полная установка

#### Импортируйте ВСЕ файлы:

**Core (3 файла)**
```
src/core/IDependencyContainer.cls
src/core/DependencyContainer.cls
src/core/ServiceRegistration.cls
```

**Logging (3 файла)**
```
src/logging/ILogger.cls
src/logging/FileLogger.cls
src/logging/ConsoleLogger.cls
```

**Code Generation (6 файлов)**
```
src/development-automation/ICodeGenerator.cls
src/development-automation/CodeGenerator.cls
src/development-automation/ClassSpecification.cls
src/development-automation/PropertySpecification.cls
src/development-automation/MethodSpecification.cls
src/development-automation/ParameterSpecification.cls
```

**Testing (2 файла)**
```
src/testing-framework/IAssert.cls
src/testing-framework/Assert.cls
```

**Utilities (6 файлов)**
```
src/utilities/StringUtilities.bas
src/utilities/ValidationHelper.bas
src/utilities/Example_DependencyInjection.bas
src/utilities/Example_Logging.bas
src/utilities/Example_CodeGeneration.bas
src/utilities/CompleteExample.bas
```

---

### Метод 3: Выборочная установка

Выберите только нужные компоненты:

#### Вариант A: Только логирование
```
✅ src/core/IDependencyContainer.cls
✅ src/core/DependencyContainer.cls
✅ src/core/ServiceRegistration.cls
✅ src/logging/ILogger.cls
✅ src/logging/ConsoleLogger.cls
✅ src/logging/FileLogger.cls         (опционально)
```

#### Вариант B: Логирование + Генерация кода
```
Вариант A +
✅ src/development-automation/ICodeGenerator.cls
✅ src/development-automation/CodeGenerator.cls
✅ src/development-automation/ClassSpecification.cls
✅ src/development-automation/PropertySpecification.cls
✅ src/development-automation/MethodSpecification.cls
✅ src/development-automation/ParameterSpecification.cls
```

#### Вариант C: Все + Тестирование
```
Вариант B +
✅ src/testing-framework/IAssert.cls
✅ src/testing-framework/Assert.cls
```

---

## Настройка для production

### Шаг 1: Конфигурация логирования

Для **файлового логирования**:
```vba
Public Sub Initialize()
    Set Container = DependencyContainer.Create()
    
    ' Создайте папку для логов
    Dim logPath As String
    logPath = Environ("USERPROFILE") & "\VBALogs\app.log"
    
    Container.RegisterInstance "ILogger", _
        FileLogger.Create(logPath, Info)
End Sub
```

Для **нескольких логгеров**:
```vba
Public Sub Initialize()
    Set Container = DependencyContainer.Create()
    
    ' Console logger для разработки
    Container.RegisterNamed "Console", "ILogger", "ConsoleLogger", Singleton
    
    ' File logger для production
    Container.RegisterNamed "File", "ILogger", "FileLogger", Singleton
    
    ' Default logger
    Container.RegisterInstance "ILogger", ConsoleLogger.Create(Debug)
End Sub
```

### Шаг 2: Организация кода

Рекомендуемая структура папок (используйте Rubberduck):
```
📁 Core
  ├── Application.bas
  └── Configuration.bas
📁 Domain
  📁 Entities
  📁 Interfaces
📁 Business
  📁 Services
📁 DataAccess
  📁 Repositories
📁 Presentation
  📁 ViewModels
  📁 Views
📁 Infrastructure
  📁 Framework (импортированные компоненты)
  📁 Utilities
```

### Шаг 3: Автозапуск при открытии файла

В `ThisWorkbook`:
```vba
Private Sub Workbook_Open()
    ' Инициализация фреймворка
    Application.Initialize
    
    ' Логирование запуска
    Dim logger As ILogger
    Set logger = Container.Resolve("ILogger")
    logger.Info "Application started by " & Environ("USERNAME")
    logger.Info "Excel version: " & Application.Version
End Sub

Private Sub Workbook_BeforeClose(Cancel As Boolean)
    ' Логирование закрытия
    Dim logger As ILogger
    Set logger = Container.Resolve("ILogger")
    logger.Info "Application closing"
End Sub
```

---

## Проверка установки

### Контрольный список

- [ ] Все необходимые файлы импортированы
- [ ] References настроены
- [ ] Модуль `Application` создан
- [ ] Метод `Initialize()` работает
- [ ] Тестовый код выполняется успешно

### Быстрый тест

Запустите в Immediate Window (`Ctrl+G`):
```vba
Application.Initialize
CompleteExample.Main
```

Должны увидеть:
```
================================================================================
ENTERPRISE VBA FRAMEWORK - COMPLETE EXAMPLE
================================================================================

>>> STEP 1: Application Initialization
...
================================================================================
EXAMPLE COMPLETED SUCCESSFULLY
================================================================================
```

---

## Troubleshooting

### Ошибка: "Compile error: User-defined type not defined"

**Причина:** Не подключена библиотека Scripting Runtime  
**Решение:** Tools → References → ✅ Microsoft Scripting Runtime

### Ошибка: "Object variable or With block variable not set"

**Причина:** Забыли вызвать `Application.Initialize`  
**Решение:** Вызовите `Application.Initialize` перед использованием

### Ошибка: FileLogger не создает файл

**Причина:** Нет прав на запись или папка не существует  
**Решение:** 
```vba
' Используйте папку в профиле пользователя
Dim logPath As String
logPath = Environ("USERPROFILE") & "\Documents\VBALogs\app.log"

' Или создайте папку вручную
```

### Ошибка: "Method or data member not found"

**Причина:** Не все файлы импортированы  
**Решение:** Проверьте, что импортированы все зависимые файлы

---

## Обновление

Для обновления до новой версии:

1. Экспортируйте текущие настройки (если есть)
2. Удалите старые файлы фреймворка
3. Импортируйте новые файлы
4. Восстановите настройки
5. Протестируйте работу

---

## Удаление

Для удаления фреймворка:

1. В VBA Editor правой кнопкой на каждом модуле/классе фреймворка
2. **Remove [ModuleName]**
3. Выберите **No** когда спросят о экспорте
4. Tools → References → снимите галочки с неиспользуемых библиотек

---

## Дополнительная настройка

### Интеграция с Rubberduck

1. Установите [Rubberduck VBA](https://rubberduckvba.com/)
2. В коде используйте аннотации:
   ```vba
   '@Folder("Core")
   '@Description("Main application module")
   ```

### Настройка для команды

Создайте общий шаблон:
1. Настройте фреймворк
2. File → Save As → Excel Macro-Enabled Template (.xltm)
3. Распространите шаблон команде

---

## Поддержка

При возникновении проблем:

1. ✅ Проверьте [Troubleshooting](#troubleshooting)
2. ✅ Изучите [QUICKSTART.md](QUICKSTART.md)
3. ✅ Просмотрите примеры в `src/utilities/`
4. ✅ Прочитайте [README.md](README.md)

---

**Установка завершена!** 🎉

Следующий шаг: [QUICKSTART.md](QUICKSTART.md)
