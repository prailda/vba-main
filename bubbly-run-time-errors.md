---
id: 9324-C617-ABC8-4652-A7D1-0362-DCB0-3478
name: bubbly-run-time-errors
title: Bubbly Run-Time Errors
description: -
domain: vba
solution: knowlages-solution
category:
  - docs
group:
  - articles
tags:
  - vba
  - knowlages-solution
  - rubberduck
  - articles
author:
  - Rubberduck
url: https://rubberduckvba.blog/2017/04/04/bubbly-run-time-errors/
created_at: 2025-11-19T08:43:02
---
# Bubbly Run-Time Errors

Run-time errors bubble up through call stacks. Errors raised deep in the call stack propagate to callers, then to their callers, continuing until reaching the entry point where they terminate execution if unhandled.

The principle that every procedure must have an error handler is incorrect. Classes responsible for database operations (setting up ADODB connections, parameterizing SQL commands, returning recordsets) should not trap all errors and return `Nothing` on failures. Calling code requires error information. Errors must bubble up to calling code for proper handling.

Data service classes let errors bubble through multiple layers: database errors bubble to data services, then to UserForm initialize handlers, finally reaching parameterless procedures in macro modules (entry points). Entry points display user-friendly messages and send detailed error information to support channels.

#### Getting a Grip on the Handle

Most errors are not handled where raised. Neither "every procedure should have error handlers" nor "no procedure should ever have error handlers" represents sound practice.

##### Avoidable Errors

Most run-time errors result from insufficient input validation. Code making assumptions about value types, formats, and locations creates error-prone situations. Unrecognized assumptions cause bugs. These bugs should terminate execution rather than being handled, as proper unit test coverage prevents them.

Proper input validation prevents avoidable errors. Code making unconscious assumptions creates bugs. VBA code implicitly referring to active worksheets often assumes specific sheets are active:

```vba
foo = Sheet1.Range(Cells(i, j), Cells(i, j)).Value
```

This assumes `Sheet1` is active because unqualified `Cells` calls implicitly refer to the active worksheet. If `foo` is declared as `String` and the cell contains a #VALUE! error, the code fails even when `Sheet1` is active.

##### Errors to Handle On-the-Spot

Validated inputs do not prevent all errors. SQL server downtime causes connection errors regardless of validation. User authorization failures raise errors. Handling decisions depend on responsibility separation among modules and procedures. Utility functions typically should not swallow errors. Testing requirements inform error handling choices.

Client code perspective determines appropriate error handling and "bad result" outputs. Unit test client code indicates correct implementation approaches.

Recoverable errors enabling graceful resumption of normal execution warrant on-the-spot handling when avoidance is impossible.

##### Everything Else

Allow errors to bubble up, catching them before surfacing to users. Code validating inputs, making minimal assumptions, and handling known specific errors requires catch-all handlers at every call stack top. These ultimate bubble catchers gracefully handle exceptions other code must propagate.

Rubberduck could implement inspections warning about possible entry points allowing unhandled run-time error bubbling. Object-returning methods potentially returning `Nothing` could trigger suggestions for `Nothing` validation. Right-clicking `Range.Find` calls could introduce `If` blocks validating returned references, making subsequent code paths safe for failing calls.
