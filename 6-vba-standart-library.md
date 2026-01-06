---
id:
name: section-6-vba-standart-library
title: "Section 2: VBA Computational Environment"
description:
author:
  - Microsoft
domain: vba
tags:
  - vba
  - specification
url: https://learn.microsoft.com/en-us/openspecs/microsoft_general_purpose_programming_languages/ms-vbal/d5418146-0bd2-45eb-9c7a-fd9502722c74
created_at: 2025-05-20T00:00:00
---

# Section 6: VBA Standard Library

**Source:** [MS-VBAL]-250520.docx

---

## 6 VBA Standard Library

### 6.1 VBA Project

"VBA" is the project name (section 4.1) of a host project (section 4.1) that is present in every VBA Environment. The VBA project consists of a set of classes, functions, Enums and constants that form VBA’s standard library.

#### 6.1.1 Predefined Enums

##### 6.1.1.1 FormShowConstants


| Constant | Value |
| -------- | ----- |
| vbModal | 1 |
| vbModeless | 0 |


##### 6.1.1.2 VbAppWinStyle


| Constant | Value |
| -------- | ----- |
| vbHide | 0 |
| vbMaximizedFocus | 3 |
| vbMinimizedFocus | 2 |
| vbMinimizedNoFocus | 6 |
| vbNormalFocus | 1 |
| vbNormalNoFocus | 4 |


##### 6.1.1.3 VbCalendar


| Constant | Value |
| -------- | ----- |
| vbCalGreg | 0 |
| vbCalHijri | 1 |


##### 6.1.1.4 VbCallType



| Constant | Value |
| -------- | ----- |
| vbGet | 2 |
| vbLet | 4 |
| vbMethod | 1 |
| vbSet | 8 |


##### 6.1.1.5 VbCompareMethod


| Constant | Value |
| -------- | ----- |
| vbBinaryCompare | 0 |
| vbTextCompare | 1 |


##### 6.1.1.6 VbDateTimeFormat


| Constant | Value |
| -------- | ----- |
| vbGeneralDate | 0 |
| vbLongDate | 1 |
| vbLongTime | 3 |
| vbShortDate | 2 |
| vbShortTime | 4 |


##### 6.1.1.7 VbDayOfWeek


| Constant | Value |
| -------- | ----- |
| vbFriday | 6 |
| vbMonday | 2 |
| vbSaturday | 7 |
| vbSunday | 1 |
| vbThursday | 5 |
| vbTuesday | 3 |
| vbUseSystemDayOfWeek | 0 |
| vbWednesday | 4 |


##### 6.1.1.8 VbFileAttribute

This Enum is used to encode the return value of the function VBA.Interaction.GetAttr.


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbNormal | 0 | Specifies files with no attributes. |
| vbReadOnly | 1 | Specifies read-only files. |
| vbHidden | 2 | Specifies hidden files. |
| VbSystem | 4 | Specifies system files. |
| vbVolume | 8 | Specifies volume label; if any other attributed is specified, vbVolume is ignored |
| vbDirectory | 16 | Specifies directories or folders. |
| vbArchive | 32 | Specifies files that have changed since the last backup. |
| vbAlias | 64 | Specifies file aliases on platforms that support them. |


##### 6.1.1.9 VbFirstWeekOfYear


| Constant | Value |
| -------- | ----- |
| vbFirstFourDays | 2 |
| vbFirstFullWeek | 3 |
| vbFirstJan1 | 1 |
| vbUseSystem | 0 |


##### 6.1.1.10 VbIMEStatus


| Constant | Value |
| -------- | ----- |
| vbIMEAlphaDbl | 7 |
| vbIMEAlphaSng | 8 |
| vbIMEDisable | 3 |
| vbIMEHiragana | 4 |
| vbIMEKatakanaDbl | 5 |
| vbIMEKatakanaSng | 6 |
| vbIMEModeAlpha | 8 |
| vbIMEModeAlphaFull | 7 |
| vbIMEModeDisable | 3 |
| vbIMEModeHangul | 10 |
| vbIMEModeHangulFull | 9 |
| vbIMEModeHiragana | 4 |
| vbIMEModeKatakana | 5 |
| vbIMEModeKatakanaHalf | 6 |
| vbIMEModeNoControl | 0 |
| vbIMEModeOff | 2 |
| vbIMEModeOn | 1 |
| vbIMENoOp | 0 |
| vbIMEOff | 2 |
| vbIMEOn | 1 |


##### 6.1.1.11 VbMsgBoxResult


| Constant | Value |
| -------- | ----- |
| vbAbort | 3 |
| vbCancel | 2 |
| vbIgnore | 5 |
| vbNo | 7 |
| vbOK | 1 |
| vbRetry | 4 |
| vbYes | 6 |


##### 6.1.1.12 VbMsgBoxStyle



| Constant | Value |
| -------- | ----- |
| vbAbortRetryIgnore | 2 |
| vbApplicationModal | 0 |
| vbCritical | 16 |
| vbDefaultButton1 | 0 |
| vbDefaultButton2 | 256 |
| vbDefaultButton3 | 512 |
| vbDefaultButton4 | 768 |
| vbExclamation | 48 |
| vbInformation | 64 |
| vbMsgBoxHelpButton | 16384 |
| vbMsgBoxRight | 524288 |
| vbMsgBoxRtlReading | 1048576 |
| vbMsgBoxSetForeground | 65536 |
| vbOKCancel | 1 |
| vbOKOnly | 0 |
| vbQuestion | 32 |
| vbRetryCancel | 5 |
| vbSystemModal | 4096 |
| vbYesNo | 4 |
| vbYesNoCancel | 3 |


##### 6.1.1.13 VbQueryClose


| Constant | Value |
| -------- | ----- |
| vbAppTaskManager | 3 |
| vbAppWindows | 2 |
| vbFormCode | 1 |
| vbFormControlMenu | 0 |
| vbFormMDIForm | 4 |


##### 6.1.1.14 VbStrConv


| Constant | Value |
| -------- | ----- |
| vbFromUnicode | 128 |
| vbHiragana | 32 |
| vbKatakana | 16 |
| vbLowerCase | 2 |
| vbNarrow | 8 |
| vbProperCase | 3 |
| vbUnicode | 64 |
| vbUpperCase | 1 |
| vbWide | 4 |


##### 6.1.1.15 VbTriState


| Constant | Value |
| -------- | ----- |
| vbFalse | 0 |
| vbTrue | -1 |
| vbUseDefault | -2 |


##### 6.1.1.16 VbVarType


| Constant | Value |
| -------- | ----- |
| vbArray | 8192 |
| vbBoolean | 11 |
| vbByte | 17 |
| vbCurrency | 6 |
| vbDataObject | 13 |
| vbDate | 7 |
| vbDecimal | 14 |
| vbDouble | 5 |
| vbEmpty | 0 |
| vbError | 10 |
| vbInteger | 2 |
| vbLong | 3 |
| vbLongLong | 20 (defined only on implementations that support a LongLong value type) |
| vbNull | 1 |
| vbObject | 9 |
| vbSingle | 4 |
| vbString | 8 |
| vbUserDefinedType | 36 |
| vbVariant | 12 |


#### 6.1.2 Predefined Procedural Modules

Unless otherwise specified, all Predefined Procedural Modules in the VBA Standard Library defined with the attribute VB_GlobalNamespace set to "True" are global modules, allowing simple name access to their public constants, variables, and procedures as specified in section 5.6.10.

The following modules define their public constants as if they were defined using a `<public-const-declaration>`.

##### 6.1.2.1 ColorConstants Module


| Constant | Value |
| -------- | ----- |
| vbBlack | 0 |
| vbBlue | 16711680 |
| vbCyan | 16776960 |
| vbGreen | 65280 |
| vbMagenta | 16711935 |
| vbRed | 255 |
| vbWhite | 16777215 |
| vbYellow | 65535 |


##### 6.1.2.2 Constants Module


| Constant | Value |
| -------- | ----- |
| vbBack | VBA.Strings.Chr$(8) |
| vbCr | VBA.Strings.Chr$(13) |
| vbCrLf | VBA.Strings.Chr$(13) + VBA.Strings.Chr$(10) |
| vbFormFeed | VBA.Strings.Chr$(12) |
| vbLf | VBA.Strings.Chr$(10) |
| vbNewLine | An implementation-defined String value representing a new line |
| vbNullChar | VBA.Strings.Chr$(0) |
| vbTab | VBA.Strings.Chr$(9) |
| vbVerticalTab | VBA.Strings.Chr$(11) |
| vbNullString | An implementation-defined String value representing a null string pointer |
| vbObjectError | -2147221504 |


##### 6.1.2.3 Conversion Module

###### 6.1.2.3.1 Public Functions

Note that these explicit-coercion functions are the only way to convert values from the LongLong type to any other type, as implicit conversions from LongLong to a declared type other than LongLong or Variant are not allowed.

**6.1.2.3.1.1 CBool**

Function Declaration

```
Function CBool(Expression As Variant) As Boolean
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any data value (section 2.1). |


Runtime Semantics.

If the value of Expression is an Error (section 2.1) data value then return the Integer data value that is the result of the Long error code (section 2.1) of the Error data value being Let-coerced to Boolean (section 5.5.1.2.2).

If the value of Expression is not an Error data value return the Boolean data value that is the result of Expression being Let-coerced to Boolean.

**6.1.2.3.1.2 CByte**

Function Declaration

```
Function CByte(Expression As Variant) As Byte
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any data value (section 2.1). |


Runtime Semantics.

If the value of Expression is an Error (section 2.1) data value then return the Byte data value that is the result of the Long error code (section 2.1) of the Error data value being Let-coerced to Byte (section 5.5.1.2.1).

If the value of Expression is not an Error data value return the Byte data value that is the result of Expression being Let-coerced to Byte.

**6.1.2.3.1.3 CCur**

Function Declaration

```
Function CCur(Expression As Variant) As Currency
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any data value (section 2.1). |


Runtime Semantics.

If the value of Expression is an Error (section 2.1) data value then return the Currency data value that is the result of the Long error code (section 2.1) of the Error data value being Let-coerced to Currency (section 5.5.1.2.1).

If the value of Expression is not an Error data value return the Currency data value that is the result of Expression being Let-coerced to Currency.

**6.1.2.3.1.4 CDate / CVDate**

Function Declaration

```
Function CDate(Expression As Variant) As Date
Function CVDate(Expression As Variant)As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any data value (section 2.1). |


Runtime Semantics.

If the value of Expression is an Error (section 2.1) data value then raise error 13, "Type mismatch".

If the value of Expression is not an Error data value return the Date data value that is the result of Expression being Let-coerced to Date (section 5.5.1.2.3).

CDate MAY recognizes string date formats according to implementation defined locale settings.

CVDate is identical to CDate except for the declared type of its return value.

**6.1.2.3.1.5 CDbl**

Function Declaration

```
Function CDbl(Expression As Variant) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any data value (section 2.1). |


Runtime Semantics.

If the value of Expression is an Error (section 2.1) data value then return the Double data value that is the result of the Long error code (section 2.1) of the Error data value being Let-coerced to Double (section 5.5.1.2.1).

If the value of Expression is not an Error data value return the Double data value that is the result of Expression being Let-coerced to Double.

**6.1.2.3.1.6 CDec**

Function Declaration

```
Function CDec(Expression As Variant)As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any data value (section 2.1). |

Runtime Semantics.

Return the Decimal data value that is the result of Expression being Let-coerced to Decimal (section 5.5.1.2.1).

**6.1.2.3.1.7 CInt**

Function Declaration

```
Function CInt(Expression As Variant) As Integer
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any data value (section 2.1). |

Runtime Semantics.

If the value of Expression is an Error (section 2.1) data value then return the Integer data value that is the result of the Long error code (section 2.1) of the Error data value being Let-coerced to Integer (section 5.5.1.2.1).

If the value of Expression is not an Error data value return the Integer data value that is the result of Expression being Let-coerced to Integer.

**6.1.2.3.1.8 CLng**

Function Declaration

```
Function CLng(Expression As Variant) As Long
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any data value (section 2.1). |


Runtime Semantics.

If the value of Expression is an Error (section 2.1) data value then return the data value of the Long error code (section 2.1) of the Error data value.

If the value of Expression is not an Error data value return the Long data value that is the result of Expression being Let-coerced to Long (section 5.5.1.2.1).

**6.1.2.3.1.9 CLngLng**

Function Declaration

```
Function CLngLng(Expression As Variant) As LongLong
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any data value (section 2.1). |


Runtime Semantics.

If the value of Expression is an Error (section 2.1) data value then return the LongLong data value that is the result of the Long error code (section 2.1) of the Error data value being Let-coerced to LongLong.

If the value of Expression is not an Error data value, then return the LongLong data value that is the result of Expression being Let-coerced to LongLong.

**6.1.2.3.1.10 CLngPtr**

Function Declaration

```
Function CLngPtr(Expression As Variant) As LongPtr
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any data value (section 2.1). |


Runtime Semantics.

If the value of Expression is an Error (section 2.1) data value then return the LongPtr data value that is the result of the Long error code (section 2.1) of the Error data value being Let-coerced to LongPtr.

If the value of Expression is not an Error data value, then return the LongPtr data value that is the result of Expression being Let-coerced to LongPtr.

**6.1.2.3.1.11 CSng**

Function Declaration

```
Function CSng(Expression As Variant) As Single
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any data value (section 2.1). |

Runtime Semantics.

If the value of Expression is an Error (section 2.1) data value then return the Single data value that is the result of the Long error code (section 2.1) of the Error data value being Let-coerced to Single (section 5.5.1.2.1).

If the value of Expression is not an Error data value return the Single data value that is the result of Expression being Let-coerced to Single.

**6.1.2.3.1.12 CStr**

Function Declaration

```
Function CStr(Expression As Variant) As String
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any data value (section 2.1). |


Runtime Semantics.

If the value of Expression is an Error (section 2.1) data value then the returned value is the String data value consisting of "Error" followed by a single space character followed by the String that is the result of the Long error code (section 2.1) of the Error data value Let-coerced to String (section 5.5.1.2.4).

If the value of Expression is not an Error data value return the String data value that is the result of Expression being Let-coerced to String (section 5.5.1.2.4).

**6.1.2.3.1.13 CVar**

Function Declaration

```
Function CVar(Expression As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any data value (section 2.1). |


Runtime Semantics.

The argument data value is returned.

**6.1.2.3.1.14 CVErr**

Function Declaration

```
Function CVErr(Expression As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any data value (section 2.1). |


Runtime Semantics.

If the value of Expression is an Error (section 2.1) data value then the value of Expression is returned without raising an error.

The data value of Expression is Let-coerced to Long (section 5.5.1.2.1) for use as an error code (section 2.1). If the resulting data value is not in the inclusive range 0 to 65535, Error 5 is raised.

Return an Error (section 2.1) data value whose error code is the result of Expression being Let-coerced to Long (section 5.5.1.2.1).

**6.1.2.3.1.15 Error / Error$**

Function Declaration

```
Function Error(Optional ErrorNumber)
Function Error$(Optional ErrorNumber) As String
```



| Parameter | Description |
| --------- | ----------- |
| ErrorNumber | Any data value (section 2.1). |


Runtime Semantics.

- If the parameter ErrorNumber is present its data value is Let-coerced to Long (section 5.5.1.2.1) for use as an error code (section 2.1). If the resulting data value is greater than 65,535 then Error 6 is raised. Negative values for ErrorNumber are acceptable.
- If the parameter ErrorNumber is not present, the most recently raised error number (or 0 if no error has been raised) is used as the error code. Note that the most recently raised error number might not necessarily be the same as the current value of Err.Number (section 6.1.3.2.2.5)
- The string data value returned by the function is determined based upon the error code as follows:
- If the error code is 0 the data value is the zero length String.
- If a descriptive text is specified for the error code, the data value is a String containing that descriptive text.
- If the error code has an implementation specific meaning the descriptive text is also implementation specific.
- Otherwise, the data value is "Application-defined or object-defined error."
- Error$ is identical to Error except for the declared type of its return value.
**6.1.2.3.1.16 Fix**

Returns the integer portion of a number.

Function Declaration

```
Function Fix(Number As Variant)
```



| Parameter | Description |
| --------- | ----------- |
| Number | Any data value (section 2.1). |


Runtime Semantics.

If the data value of Number is Null, Null is returned.

If the value type (section 2.1) of Number is Integer, Long or LongLong, the data value of Number is returned.

If the value type of Number is any numeric value type (section 5.5.1.2.1) other than Integer or Long, the returned value is a data value whose value type is the same as the value type of Number and whose value that is the smallest integer greater than or equal to the data value of Number. If the value to be returned is not in the range of the value type of Number, raise error 6, "Overflow".

If the value type of Number is String, the returned value is the result of the Fix function applied to the result of Let-coercing Number to Double.

If the value type (section 2.1) of Number is Date, the returned value is the same as result of evaluating the expression: CDate(Fix(CDbl(Number)))

Otherwise, the returned value is the result of Number being Let-coerced to Integer.

**6.1.2.3.1.17 Hex / Hex$**

Function Declaration

```
Function Hex(Number As Variant)
Function Hex$(Number As Variant) As String
```



| Parameter | Description |
| --------- | ----------- |
| Number | Any data value (section 2.1). |


Runtime Semantics.

If the data value of the parameter Number is the data value Null the function Hex$ raises error 94, "Invalid use of Null" and the function Hex returns the data value Null.

If the data value of the parameter Number is the data value Empty the function returns the String data value "0"

If the data value of the parameter Number has the value type LongLong, it is not coerced.

If the data value of the parameter Number is any other value, it is Let-coerced to Long (section 5.5.1.2.1).

If the Let-coerced value of Number is positive, the function result is a String data value consisting of the characters of the hexadecimal encoding with no leading zeros of the value.

If the Let-coerced value of Number is in the range -32,767 to -1, the function result is a four character String data value consisting of the characters of the 16-bit 2’s complement hexadecimal encoding of the value.

If the Let-coerced value of Number is in the range -2,147,483,648 to -32,768, the function result is an eight character String data value consisting of the characters of the 32-bit 2’s complement hexadecimal encoding of the value.

If the Let-coerced value of Number is in the range -9,223,372,036,854,775,808 to 2,147,483,649, the function result is a sixteen character String data value consisting of the characters of the 64-bit 2’s complement hexadecimal encoding of the value.

Except for the case where the parameter Number is Null, the semantics of Hex$ is identical to Hex except for the declared type of its returned value.

**6.1.2.3.1.18 Int**

Returns the integer portion of a number.

Function Declaration

```
Function Int(Number As Variant)
```



| Parameter | Description |
| --------- | ----------- |
| Number | Any data value (section 2.1). |


Runtime Semantics.

If the data value of Number is Null, Null is returned.

If the value type (section 2.1) of Number is Integer, Long or LongLong, the data value of Number is returned.

If the value type of Number is any numeric value type (section 5.5.1.2.1) other than Integer or Long, the returned value is a data value whose value type is the same as the value type of Number and whose value that is the greatest integer that is less than or equal to the data value of Number. If the value to be returned is not in the range of the value type of Number, raise error 6, "Overflow".

If the value type of Number is String, the returned value is the result of the Int function applied to the result of Let-coercing Number to Double.

If the value type (section 2.1) of Number is Date, the returned value is the same as result of evaluating the expression: CDate(Int(CDbl(Number)))

Otherwise, the returned value is the result of Number being Let-coerced to Integer.

**6.1.2.3.1.19 Oct / Oct$**

Function Declaration

```
Function Oct(Number As Variant)
Function Oct$(Number As Variant) As String
```



| Parameter | Description |
| --------- | ----------- |
| Number | Any data value (section 2.1). |


Runtime Semantics.

If the data value of the parameter Number is the data value Null the function Oct$ raises error 94, "Invalid use of Null" and the function Oct returns the data value Null.

If the data value of the parameter Number is the data value Empty the function returns the String data value "0".

If the data value of the parameter Number has the value type LongLong, it is not coerced.

If the data value of the parameter Number is any other value, it is Let-coerced to Long (section 5.5.1.2.1).

If the Let-coerced value of Number is positive, the function result is a String data value consisting of the characters of the hexadecimal encoding of the value with no leading zeros.

If the Let-coerced value of Number is in the range -32,767 to -1, the function result is a six character String data value consisting of the characters of the 16-bit 2’s complement octal encoding of the value.

If the Let-coerced value of Number is in the range -2,147,483,648 to -32,768, the function result is an eleven character String data value consisting of the characters of the 32-bit 2’s complement octal encoding of the value.

If the Let-coerced value of Number is in the range -9,223,372,036,854,775,808 to 2,147,483,649, the function result is a twenty-two character String data value consisting of the characters of the 64-bit 2’s complement hexadecimal encoding of the value.

Except for the case where the parameter Number is Null, the semantics of Oct$ is identical to Oct except for the declared type of its returned value.

**6.1.2.3.1.20 Str / Str$**

Function Declaration

```
Function Str(Number As Variant)
Function Str$(Number As Variant) As String
```



| Parameter | Description |
| --------- | ----------- |
| Number | Any data value (section 2.1). |


Runtime Semantics.

If the data value of Number is Null, Null is returned.

If the value of Number is an Error (section 2.1) data value then the returned value is the String data value consisting of "Error" followed by a single space character followed by the String that is the result of the Long error code (section 2.1) of the Error data value Let-coerced to String (section 5.5.1.2.4).

If the value type of Number is Date, the returned value is the result of Let-coercing Number to String.

If the data value of Number is any numeric value type, let S be the result of Let-coercing Number to String using "." as the decimal separator. If the data value of Number is positive (or zero) the result is S with a single space character appended as its first character, otherwise the result is S.

Otherwise, the returned value is the result of the Str function applied to the result of Let-coercing Number to Double.

Str$ is identical to Str except for the declared type of its return value.

**6.1.2.3.1.21 Val**

Function Declaration

```
Function Val(Value As String) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Value | Any String data value (section 2.1). |


Runtime Semantics.

If Value is the 0 length String data value return the Double data value 0.

Returns the numbers contained in a string as a Double.

The Val function stops reading the string at the first character it can't recognize as part of a number. Symbols and characters that are often considered parts of numeric values, such as dollar signs and commas, are not recognized. However, the function recognizes the radix prefixes &O (for octal) and &H (for hexadecimal).

Blanks, tabs, and linefeed characters are stripped from the argument.

##### 6.1.2.4 DateTime Module

###### 6.1.2.4.1 Public Functions

**6.1.2.4.1.1 DateAdd**

Function Declaration

```
Function DateAdd(Interval As String,
Number As Double,
Date As Variant)
```



| Parameter | Description |
| --------- | ----------- |
| Interval | String data value (section 2.1) that specifies the interval of time to add. |
| Number | The number of intervals to add. It can be positive (to get dates in the future) or negative (to get dates in the past). If it is not a integer value, it is rounded to the nearest whole number. |
| Date | Date, data value to which the interval is added. |

Runtime Semantics.

- The DateAdd function returns the result of adding or subtracting a specified time interval from a base date. For example, it can be used to calculate a date 30 days from today or a time 45 minutes from now.
- The interval argument is interpreted according to this table:

| Interval Data Value | Meaning |
| ------------------- | ------- |
| "yyyy" | Year |
| "q" | Quarter |
| "m" | Month |
| "y" | Day of year |
| "d" | Day |
| "w" | Weekday |
| "ww" | Week |
| "h" | Hour |
| "n" | Minute |
| "s" | Second |
| Any other data value | Raise Error 5, "Invalid procedure call or argument" |


- The interpretation of the Interval data value is not case sensitive.
- The DateAdd function won't return an invalid date. The following example adds one month to January 31:
DateAdd("m", 1, "31-Jan-95")

In this case, DateAdd returns 28-Feb-95, not 31-Feb-95. If date is 31-Jan-96, it returns 29-Feb96 because 1996 is a leap year.

- If the calculated date would precede the year 100 (that is, you subtract more years than are in date), an error 5 is raised.
- For date, if the Calendar property setting is Gregorian, the supplied date MUST be Gregorian. If the calendar is Hijri, the supplied date MUST be Hijri. If month values are names, the name MUST be consistent with the current Calendar property setting. To minimize the possibility of month names conflicting with the current Calendar property setting, enter numeric month values (Short Date format).
**6.1.2.4.1.2 DateDiff**

Function Declaration

```
Function DateDiff(Interval As String,
Date1 As Variant,
Date2 As Variant,
Optional FirstDayOfWeek
As VbDayOfWeek = vbSunday,
Optional FirstWeekOfYear
As VbFirstWeekOfYear = vbFirstJan1
)
```



| Parameter | Description |
| --------- | ----------- |
| Interval | String data value (section 2.1) that specifies the interval of time to use to calculate the difference between Date1 and Date2. |
| Date1, Date2 | The two dates to use in the calculation. |
| FirstDayOfWeek | A constant that specifies the first day of the week. If not specified, Sunday is assumed. See section 6.1.1.7. |
| FirstWeekOfYear | A constant that specifies the first week of the year. If not specified, the first week is assumed to be the week in which January 1 occurs. |

Runtime Semantics.

- Returns a Long data value specifying the number of time intervals between two specified dates.
- The Interval argument is interpreted according to this table:


| Interval Data Value | Meaning |
| ------------------- | ------- |
| "yyyy" | Year |
| "q" | Quarter |
| "m" | Month |
| "y" | Day of year |
| "d" | Day |
| "w" | Weekday |
| "ww" | Week |
| "h" | Hour |
| "n" | Minute |
| "s" | Second |
| Any other data value | Raise Error 5, "Invalid procedure call or argument" |


- The interpretation of the Interval data value is not case sensitive.
- If Date1 falls on a Monday, DateDiff counts the number of Mondays until Date2. It counts Date2 but not Date1. If interval is Week ("ww"), however, the DateDiff function returns the number of calendar weeks between the two dates. It counts the number of Sundays between Date1 and Date2. DateDiff counts Date2 if it falls on a Sunday; but it doesn't count Date1, even if it does fall on a Sunday.
- If Date1 refers to a later point in time than Date2, the DateDiff function returns a negative number.
- The FirstDayOfWeek argument affects calculations that use the "w" and "ww" interval symbols.
- When comparing December 31 to January 1 of the immediately succeeding year, DateDiff for Year ("yyyy") returns 1 even though only a day has elapsed.
- For Date1 and Date2, if the Calendar property setting is Gregorian, the supplied date MUST be Gregorian. If the calendar is Hijri, the supplied date MUST be Hijri.
**6.1.2.4.1.3 DatePart**

Function Declaration

```
Function DatePart(Interval As String,
BaseDate As Variant,
Optional FirstDayOfWeek
As VbDayOfWeek = vbSunday,
Optional FirstWeekOfYear
As VbFirstWeekOfYear = vbFirstJan1
)
```



| Parameter | Description |
| --------- | ----------- |
| Interval | String data value (section 2.1) that specifies the interval of time to extract from BaseDate. |
| BaseDate | Date data value from which the interval is extracted. |
| FirstDayOfWeek | A constant that specifies the first day of the week. If not specified, Sunday is assumed. See section 6.1.1.7. |
| FirstWeekOfYear | A constant that specifies the first week of the year. If not specified, the first week is assumed to be the week in which January 1 occurs. |

Runtime Semantics.

Returns a Integer data value containing the specified part of a given date

The Interval argument is interpreted according to this table:



| Interval Data Value | Meaning |
| ------------------- | ------- |
| "yyyy" | Year |
| "q" | Quarter |
| "m" | Month |
| "y" | Day of year |
| "d" | Day |
| "w" | Weekday |
| "ww" | Week |
| "h" | Hour |
| "n" | Minute |
| "s" | Second |
| Any other data value | Raise Error 5, "Invalid procedure call or argument" |


The interpretation of the Interval data value is not case sensitive.

The FirstDayOfWeek argument affects calculations that use the "w" and "ww" interval symbols.

For BaseDate, if the Calendar property setting is Gregorian, the supplied date MUST be Gregorian. If the calendar is Hijri, the supplied date MUST be Hijri.

The returned date part is in the time period units of the current Arabic calendar. For example, if the current calendar is Hijri and the date part to be returned is the year, the year value is a Hijri year.

**6.1.2.4.1.4 DateSerial**

Function Declaration

```
Function DateSerial(Year As Integer, Month As Integer,
Day As Integer)
```



| Parameter | Description |
| --------- | ----------- |
| Year | An Integer data value (section 2.1) in the range 100 and 9999, inclusive. |
| Month | An Integer data value (section 2.1). |
| Day | An Integer data value (section 2.1). |


Runtime Semantics.

The DateSerial function returns a Date for a specified year, month, and day.

To specify a date, such as December 31, 1991, the range of numbers for each DateSerial argument SHOULD be in the accepted range for the unit; that is, 1-31 for days and 1-12 for months. However, you can also specify relative dates for each argument using any numeric expression that represents some number of days, months, or years before or after a certain date.

Two digit years for the year argument are interpreted based on implementation defined settings. The default settings are that values between 0 and 29, inclusive, are interpreted as the years 2000-2029. The default values between 30 and 99 are interpreted as the years 19301999. For all other year arguments, use a four-digit year (for example, 1800).

When any argument exceeds the accepted range for that argument, it increments to the next larger unit as appropriate. For example, if you specify 35 days, it is evaluated as one month and some number of days, depending on where in the year it is applied. If any single argument is outside the range -32,768 to 32,767, an error occurs. If the date specified by the three arguments falls outside the acceptable range of dates, an error occurs.

For Year, Month, and Day, if the Calendar property setting is Gregorian, the supplied value is assumed to be Gregorian. If the Calendar property setting is Hijri, the supplied value is assumed to be Hijri.

The returned date part is in the time period units of the current Visual Basic calendar. For example, if the current calendar is Hijri and the date part to be returned is the year, the year value is a Hijri year. For the argument year, values between 0 and 99, inclusive, are interpreted as the years 1400-1499. For all other year values, use the complete four-digit year (for example, 1520).

**6.1.2.4.1.5 DateValue**

Function Declaration

```
Function DateValue(Date As String) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Date | String data value (section 2.1) representing a date from January 1, 100 through December 31, 9999. The value can also be a date, a time, or both a date and time. |


Runtime Semantics.

Returns a Date data value.

If Date is a string that includes only numbers separated by valid date separators, DateValue recognizes the order for month, day, and year according to the implementation-defined Short Date format. DateValue also recognizes unambiguous dates that contain month names, either in long or abbreviated form. For example, in addition to recognizing 12/30/1991 and 12/30/91, DateValue also recognizes December 30, 1991 and Dec 30, 1991.

If the year part of Date is omitted, DateValue uses the current year from the system’s date.

If the Date argument includes time information, DateValue doesn't return it. However, if Date includes invalid time information (such as "89:98"), an error occurs.

For Date, if the Calendar property setting is Gregorian, the supplied date MUST be Gregorian. If the calendar is Hijri, the supplied date MUST be Hijri. If the supplied date is Hijri, the argument date is a String representing a date from 1/1/100 (Gregorian Aug 2, 718) through 4/3/9666 (Gregorian Dec 31, 9999).

**6.1.2.4.1.6 Day**

Function Declaration

```
Function Day(Date As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Date | Any data value (section 2.1). The data value SHOULD be Let-coercible to Date. |

Runtime Semantics.

Date is Let-coerced to Date and an Integer data value specifying a whole number between 1 and 31, inclusive, representing the day of the month is returned.

If Date is Null, Null is returned.

If the Calendar property setting is Gregorian, the returned Integer represents the Gregorian day of the month for the Date argument. If the calendar is Hijri, the returned Integer represents the Hijri day of the month for the Date argument.

**6.1.2.4.1.7 Hour**

Function Declaration

```
Function Hour(Time As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Time | Any data value (section 2.1). The data value SHOULD be Let-coercible to Date. |

Runtime Semantics.

Time is Let-coerced to Date and an Integer specifying a whole number between 0 and 23, inclusive representing the hour of the day specified by the date is returned.

- If Time is Null, Null is returned.
**6.1.2.4.1.8 Minute**

Function Declaration

```
Function Hour(Time As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Time | Any data value (section 2.1). The data value SHOULD be Let-coercible to Date. |

Runtime Semantics.

Time is Let-coerced to Date and an Integer specifying a whole number between 0 and 59, inclusive representing the minute of the hour specified by the date is returned.

If Time is Null, Null is returned.

**6.1.2.4.1.9 Month**

Function Declaration

```
Function Month(Date As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Date | Any data value (section 2.1). The data value SHOULD be Let-coercible to Date. |

Runtime Semantics.

Date is Let-coerced to Date and an Integer data value specifying a whole number between 1 and 12, inclusive, representing the month of the year is returned.

If Date is Null, Null is returned.

**6.1.2.4.1.10 Second**

Function Declaration

```
Function Second(Time As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Time | Any data value (section 2.1). The data value SHOULD be Let-coercible to Date. |

Runtime Semantics.

Time is Let-coerced to Date and an Integer specifying a whole number between 0 and 59, inclusive representing the second of the minute specified by the date is returned.

If Time is Null, Null is returned.

**6.1.2.4.1.11 TimeSerial**

Function Declaration

```
Function TimeSerial(Hour As Integer,
Minute As Integer,
Second As Integer) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Hour | An Integer data value (section 2.1) in the range 0 and 23, inclusive. |
| Minute | An Integer data value (section 2.1). |
| Second | An Integer data value (section 2.1). |


Runtime Semantics.

Returns a Date containing the time for a specific hour, minute, and second.

To specify a time, such as 11:59:59, the range of numbers for each TimeSerial argument SHOULD be in the normal range for the unit; that is, 023 for hours and 059 for minutes and seconds. However, one can also specify relative times for each argument using any Integer data value that represents some number of hours, minutes, or seconds before or after a certain time.

When any argument exceeds the normal range for that argument, it increments to the next larger unit as appropriate. For example, if Minute specifies 75 minutes, it is evaluated as one hour and 15 minutes. If the time specified by the three arguments causes the date to fall outside the acceptable range of dates, an error is raised.

**6.1.2.4.1.12 TimeValue**

Function Declaration

```
Function TimeValue(Time As String) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Time | String data value (section 2.1) representing a time from 0:00:00 (12:00:00 A.M.) to 23:59:59 (11:59:59 P.M.), inclusive. The value can also be a date, a time, or both a date and time. |


Runtime Semantics.

Returns a Date containing the time. The argument string is Let-coerced to value type Date and the date portions of the data value are set to zero.

If Time is Null, Null is returned.

If the Time argument contains date information, TimeValue doesn't return it. However, if Time includes invalid date information, an error occurs.

**6.1.2.4.1.13 Weekday**

Function Declaration

```
Function Weekday(Date,
Optional FirstDayOfWeek
As VbDayOfWeek = vbSunday                  ) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Date | Any data value (section 2.1). The data value SHOULD be Let-coercible to Date. If Date contains Null, Null is returned. |
| FirstDayOfWeek | A constant that specifies the first day of the week. If not specified, Sunday is assumed. See section 6.1.1.7. |


Runtime Semantics.

Returns an Integer containing a whole number representing the day of the week.

The Weekday function can return any of these values (see section 6.1.1.7):


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbSunday | 1 | Sunday |
| vbMonday | 2 | Monday |
| vbTuesday | 3 | Tuesday |
| vbWednesday | 4 | Wednesday |
| vbThursday | 5 | Thursday |
| vbFriday | 6 | Friday |
| vbSaturday | 7 | Saturday |


If the Calendar property setting is Gregorian, the returned Integer represents the Gregorian day of the week for the Date argument. If the calendar is Hijri, the returned Integer represents the Hijri day of the week for the Date argument. For Hijri dates, the argument number is any numeric expression that can represent a date and/or time from 1/1/100 (Gregorian Aug 2, 718) through 4/3/9666 (Gregorian Dec 31, 9999).

**6.1.2.4.1.14 Year**

Function Declaration

```
Function Year(Date As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Date | Any data value (section 2.1). The data value SHOULD be Let-coercible to Date. |

Runtime Semantics.

Date is Let-coerced to Date and an Integer data value specifying a whole number between 100 and 9999, inclusive, representing the year is returned.

If Date is Null, Null is returned.

###### 6.1.2.4.2 Public Properties

**6.1.2.4.2.1 Calendar**

Property Declaration

```
Property Calendar As VbCalendar
```

Runtime Semantics.

Returns or sets a value specifying the type of calendar to use by subsequent calls to the functions defined in section 6.1.2.4.

**6.1.2.4.2.2 Date/Date$**

Property Declaration

```
Property Date As Variant
Property Date$ As String
```

Runtime Semantics.

Returns a String or a Date containing the current system date.

Date, and if the calendar is Gregorian, Date$ behavior is unchanged by the Calendar property setting. If the calendar is Hijri, Date$ returns a 10-character string of the form mm-dd-yyyy, where mm (01-12), dd (01-30) and yyyy (1400-1523) are the Hijri month, day and year. The equivalent Gregorian range is Jan 1, 1980 through Dec 31, 2099.

**6.1.2.4.2.3 Now**

Property Declaration

```
Property Now As Variant
```

Runtime Semantics.

Returns a Date data value specifying the current date and time.

**6.1.2.4.2.4 Time/Time$**

Property Declaration [Get Property]

```
Property Time As Variant
Property Time$ As String
```

Runtime Semantics.

Returns a String or Date containing the current system time.

Property Declaration [Set Property]

```
Property Time As Variant
```

Runtime Semantics.

Sets the system time.

The value assigned to the Time property MUST be Let-coercible to a Date data value. The time portion of the Date data value is used to set the system time.

If Time is a string, Time attempts to convert it to a time using the time separators specified for the system. If it can't be converted to a valid time, an error occurs.

**6.1.2.4.2.5 Timer**

Function Declaration

```
Property Timer As Single
```

Runtime Semantics.

Returns a Single data value representing the number of seconds elapsed since midnight.

The sub-second resolution is implementation dependent.

##### 6.1.2.5 FileSystem

###### 6.1.2.5.1 Public Functions

**6.1.2.5.1.1 CurDir/CurDir$**

```
Function CurDir(Optional Drive As Variant) As Variant
Function CurDir$(Optional Drive As Variant) As String
```



| Parameter | Description |
| --------- | ----------- |
| Drive | Optional String data value that identifiers an storage drive in an implementation defined manner. |

Runtime Semantics.

The valid format of a Drive String is implementation defined.

If Drive is unspecified, or if Drive is a zero-length string, CurDir returns the current file path for the implementation-defined current drive as a String data value. If Drive validly identifies a storage drive, the current file path for that drive is returned a String data value.

If the value of Drive is not a valid drive identifier, Error 68 ("Device Unavailable") is raised.

**6.1.2.5.1.2 Dir**

Function Declaration

```
Function Dir(Optional PathName As Variant,
Optional Attributes
As VbFileAttribute = vbNormal              )As String
```



| Parameter | Description |
| --------- | ----------- |
| PathName | Any data value (section 2.1) that specifies a file name. It can include directory or folder, and drive. The data value SHOULD be Let-coercible to String. A zero-length string ("") is returned if PathName is not found. |
| Attributes | Constant or numeric expression, whose sum specifies file attributes. If omitted, returns files that match PathName but have no attributes. |


Runtime Semantics.

Returns a String data value representing the name of a file, directory, or folder that matches a specified pattern or file attribute, or the volume label of a drive.

The attributes argument can be the logical or any combination of the values of the vbFileAttribute enumeration.

Dir supports the use of multiple character (*) and single character (?) wildcards to specify multiple files.

**6.1.2.5.1.3 EOF**

Function Declaration

```
Function EOF(FileNumber As Integer) As Boolean
```



| Parameter | Description |
| --------- | ----------- |
| FileNumber | Any data value that is Let-coercible to declared type Integer and that is a valid file number (section 5.4.5). |

Runtime Semantics.

Returns a Boolean data value indicating whether or not the current file-pointer-position (section 5.4.5) is at the end of a file that has been opened for Random or sequential Input.

The EOF function returns False until the file-pointer-position is at the end of the file. With files opened for Random or Binary access, EOF returns False until the last executed Get statement is unable to read an entire record.

Files opened for Output, EOF returns True.

**6.1.2.5.1.4 FileAttr**

Function Declaration

```
Function FileAttr(FileNumber As Integer,
Optional ReturnType As Integer = 1                   ) As Long
```



| Parameter | Description |
| --------- | ----------- |
| FileNumber | An Integer data value that is a valid file number (section 5.4.5). |
| ReturnType | An Integer data value that indicating the type of information to return. Specify the data value 1 to return a value indicating the file mode. The meaning of other data values is implementation defined. |


Runtime Semantics.

Returns a Long representing the file mode (section 5.4.5) for files opened using the Open statement.

When the ReturnType argument is 1, the following return values indicate the file access mode:


| Mode | Value |
| ---- | ----- |
| Input | 1 |
| Output | 2 |
| Random | 4 |
| Append | 8 |
| Binary | 32 |


**6.1.2.5.1.5 FileDateTime**

Function Declaration

```
Function FileDateTime(PathName As String) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| PathName | String expression that specifies a file name; can include directory or folder, and drive. An error is raised if PathName is not found. |


Runtime Semantics.

Returns a Date data value that indicates the date and time when a file was created or last modified.

**6.1.2.5.1.6 FileLen**

Function Declaration

```
Function FileLen(PathName As String) As Long
```



| Parameter | Description |
| --------- | ----------- |
| PathName | String expression that specifies a file name; can include directory or folder, and drive. An error is raised if PathName is not found. |


Runtime Semantics.

Returns a Long specifying the length of a file in bytes.

If the specified file is open when the FileLen function is called, the value returned represents the size of the file immediately before it was opened.

**6.1.2.5.1.7 FreeFile**

Function Declaration

```
Function FreeFile(Optional RangeNumber As Variant                   ) As Integer
```



| Parameter | Description |
| --------- | ----------- |
| RangeNumber | Integer data value that specifies the range from which the next free file number (section 5.4.5) is to be returned. Specify the data value 0 (default) to return a file number in the range 1-255, inclusive. Specify the data value 1 to return a file number in the range 256-511, inclusive. |


Runtime Semantics.

Returns an Integer representing the next file number available for use by the Open statement.

**6.1.2.5.1.8 Loc**

Function Declaration

```
Function Loc(FileNumber As Integer) As Long
```



| Parameter | Description |
| --------- | ----------- |
| FileNumber | An Integer data value that is a valid file number (section 5.4.5). |


Runtime Semantics.

Returns a Long specifying the current read/write position (in other words, the current file-pointer-position (section 5.4.5)) within an open file. The interpretation of the returned value depends upon the file access mode of the open file.

The following describes the return value for each file access mode:


| Mode | Return Value |
| ---- | ------------ |
| Random | Number of the last record read from or written to the file. |
| Sequential | Current byte position in the file divided by 128. However, information returned by Loc for sequential files is neither used nor required. |
| Binary | Position of the last byte read or written. |


**6.1.2.5.1.9 LOF**

Function Declaration

```
Function LOF(FileNumber As Integer) As Long
```



| Parameter | Description |
| --------- | ----------- |
| FileNumber | An Integer data value that is a valid file number (section 5.4.5). |


Runtime Semantics.

Returns a Long representing the size, in bytes, of a file opened using the Open statement.

**6.1.2.5.1.10 Seek**

Function Declaration

```
Function Seek(FileNumber As Integer) As Long
```



| Parameter | Description |
| --------- | ----------- |
| FileNumber | An Integer data value that is a valid file number (section 5.4.5). |


Runtime Semantics.

Returns a Long specifying the current read/write position (in other words, the file-current file-pointer-position (section 5.4.5)) within a file opened using the Open statement. This value will be between 1 and 2,147,483,647 (equivalent to 2^31 - 1), inclusive.

The following describes the return values for each file access mode:


| Mode | Return Value |
| ---- | ------------ |
| Random | Number of the next record read or written. |
| Binary, Output, Append, Input | Byte position at which the next operation takes place. The first byte in a file is at position 1, the second byte is at position 2, and so on. |


###### 6.1.2.5.2 Public Subroutines

**6.1.2.5.2.1 ChDir**

Subroutine Declaration

```
Sub ChDir(Path As String)
```



| Parameter | Description |
| --------- | ----------- |
| Path | String data value that identifies which directory or folder becomes the new default directory or folder. The path can include the drive. If no drive is specified, ChDir changes the default directory or folder on the current drive. |


Runtime Semantics.

ChDir changes the system’s current directory or folder, but not the default drive.

**6.1.2.5.2.2 ChDrive**

Subroutine Declaration

```
Sub ChDrive(Drive As String)
```



| Parameter | Description |
| --------- | ----------- |
| Drive | String data value that specifies an existing drive. If Drive is a zero-length string (""), the current drive doesn't change. If the drive argument is a multiple-character string, ChDrive uses only the first letter. |


Runtime Semantics.

ChDrive changes the current default drive.


**6.1.2.5.2.3 FileCopy**

Subroutine Declaration

```
Sub FileCopy(Source As String, Destination As String)
```



| Parameter | Description |
| --------- | ----------- |
| Source | String data value that specifies the name of the file to be copied. The string can include directory or folder, and drive. |
| Destination | String data value that specifies the target file name. The string can include directory or folder, and drive. |


Runtime Semantics.

Copies a file in an implementation-defined manner.

If the Source file is currently open, an error occurs.


**6.1.2.5.2.4 Kill**

Subroutine Declaration

```
Sub Kill(PathName)
```


| Parameter | Description |
| --------- | ----------- |
| PathName | String data value that specifies one or more file names to be deleted; can include directory or folder, and drive. |


Runtime Semantics.

Kill deletes files from a disk.

Kill supports the use of multiple-character (*) and single-character (?) wildcards to specify multiple files.

**6.1.2.5.2.5 MkDir**

Subroutine Declaration

```
Sub MkDir(Path As String)
```



| Parameter | Description |
| --------- | ----------- |
| Path | String data value that identifies the directory or folder to be created. The path can include the drive. If no drive is specified, MkDir creates the new directory or folder on the current drive. |


Runtime Semantics.

MkDir creates a new directory or folder.


**6.1.2.5.2.6 RmDir**

Subroutine Declaration

```
Sub RmDir(Path As String)
```



| Parameter | Description |
| --------- | ----------- |
| Path | String data value that identifies the directory or folder to be removed. The path can include the drive. If no drive is specified, RmDir removes the directory or folder on the current drive. |


Runtime Semantics.

RmDir removes an existing directory or folder.

An error occurs when using RmDir on a directory or folder containing files.

**6.1.2.5.2.7 SetAttr**

Subroutine Declaration

```
Sub SetAttr(PathName As String,
Attributes As VbFileAttribute)
```



| Parameter | Description |
| --------- | ----------- |
| PathName | String data value that specifies a file name can include directory or folder, and drive. |
| Attributes | Constant or numeric expression, whose sum specifies file attributes. |


Runtime Semantics.

Sets attribute information for a file.

A run-time error occurs when trying to set the attributes of an open file.


---

##### 6.1.2.6 Financial

###### 6.1.2.6.1 Public Functions

**6.1.2.6.1.1 DDB**

Function Declaration

```
Function DDB(Cost As Double, Salvage As Double,
Life As Double, Period As Double,
Optional Factor As Variant) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Cost | Double specifying initial cost of the asset. |
| Salvage | Double specifying value of the asset at the end of its useful life. |
| Life | Double specifying length of useful life of the asset. |
| Period | Double specifying period for which asset depreciation is calculated. |
| Factor | Double data value specifying rate at which the balance declines. If omitted, the data value 2 (double-declining method) is assumed. |


Runtime Semantics.

Returns a Double data value specifying the depreciation of an asset for a specific time period using the double-declining balance method (or some other specified method).

The Life and Period arguments MUST be expressed in the same units. For example, if Life is given in months, Period MUST also be given in months. All arguments MUST be positive numbers.

The DDB function uses the following formula to calculate depreciation for a given period:

Depreciation / Period = ((Cost - Salvage) * Factor) / Life

**6.1.2.6.1.2 FV**

Function Declaration

```
Function FV(Rate As Double, NPer As Double, Pmt As Double,             PV As Variant, Due As Variant) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Rate | Double specifying interest rate per period. For example, if you get a car loan at an annual percentage rate (APR) of 10 percent and make monthly payments, the rate per period is 0.1/12, or 0.0083. |
| NPer | Double specifying total number of payment periods in the annuity. For example, if you make monthly payments on a four-year car loan, your loan has a total of 4 * 12 (or 48) payment periods. |
| Pmt | Double specifying payment to be made each period. Payments usually contain principal and interest that doesn't change over the life of the annuity. |
| Pv | Double data value specifying present value (or lump sum) of a series of future payments. For example, when borrowing money to buy a car, the loan amount is the present value to the lender of the monthly car payments that will be made. If omitted, the data value 0 is assumed. |
| Due | Integer data value specifying when payments are due. Use the data value 0 if payments are due at the end of the payment period, or use the data value 1 if payments are due at the beginning of the period. If omitted, the data value 0 is assumed. |

Runtime Semantics.

Returns a Double specifying the future value of an annuity based on periodic, fixed payments and a fixed interest rate.

The Rate and NPer arguments MUST be calculated using payment periods expressed in the same units. For example, if Rate is calculated using months, NPer MUST also be calculated using months.

For all arguments, cash paid out (such as deposits to savings) is represented by negative numbers; cash received (such as dividend checks) is represented by positive numbers.

**6.1.2.6.1.3 IPmt**

Function Declaration

```
Function IPmt(Rate As Double, Per As Double,
NPer As Double, PV As Double,
Optional FV As Variant,
Optional Due As Variant) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Rate | Double data value specifying interest rate per period. For example, given a car loan at an annual percentage rate (APR) of 10 percent and making monthly payments, the rate per period is 0.1/12, or 0.0083. |
| Per | Double data value specifying payment period in the range 1 through NPer. |
| NPer | Double specifying total number of payment periods in the annuity. For example, if you make monthly payments on a four-year car loan, your loan has a total of 4 * 12 (or 48) payment periods. |
| Pv | Double data value specifying present value, or value today, of a series of future payments or receipts. |
| Fv | Double data value specifying future value or cash balance desired after final payment has been made. For example, the future value of a loan is $0 because that's its value after the final payment. However, if someone wants to save $50,000 over 18 years for their child's education, then $50,000 is the future value. If omitted, the data value 0.0 is assumed. |
| Due | Integer data value specifying when payments are due. Use the data value 0 if payments are due at the end of the payment period, or use the data value 1 if payments are due at the beginning of the period. If omitted, the data value 0 is assumed. |


Runtime Semantics.

Returns a Double specifying the interest payment for a given period of an annuity based on periodic, fixed payments and a fixed interest rate.

The Rate and NPer arguments MUST be calculated using payment periods expressed in the same units. For example, if Rate is calculated using months, NPer MUST also be calculated using months.

For all arguments, cash paid out (such as deposits to savings) is represented by negative numbers; cash received (such as dividend checks) is represented by positive numbers.

**6.1.2.6.1.4 IRR**

Function Declaration

```
Function IRR(ValueArray() As Double,
Optional Guess As Variant) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Values | Array of Double data values specifying cash flow values. The array MUST contain at least one negative value (a payment) and one positive value (a receipt). |
| Guess | Double data value specifying estimated value that will be returned by IRR. If omitted, Guess is the data value 0.1 (10 percent). |


Runtime Semantics.

Returns a Double data value specifying the internal rate of return for a series of periodic cash flows (payments and receipts).

The internal rate of return is the interest rate received for an investment consisting of payments and receipts that occur at regular intervals.

The IRR function uses the order of values within the array to interpret the order of payments and receipts. The cash flow for each period doesn't have to be fixed, as it is for an annuity.

IRR is calculated by iteration. Starting with the value of guess, IRR cycles through the calculation until the result is accurate to within 0.00001 percent. If IRR can't find a result after 20 tries, it fails.

**6.1.2.6.1.5 MIRR**

Function Declaration

```
Function MIRR(ValueArray() As Double,
Finance_Rate As Double,
Reinvest_Rate As Double) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Values | Array of Double data values specifying cash flow values. The array MUST contain at least one negative value (a payment) and one positive value (a receipt). |
| Finance_Rate | Double data value specifying interest rate paid as the cost of financing. |
| Reinvest_Rate | Double data value specifying interest rate received on gains from cash reinvestment. |


Runtime Semantics.

Returns a Double data value specifying the modified internal rate of return for a series of periodic cash flows (payments and receipts).

The modified internal rate of return is the internal rate of return when payments and receipts are financed at different rates. The MIRR function takes into account both the cost of the investment (Finance_Rate) and the interest rate received on reinvestment of cash (Reinvest_Rate).

The Finance_Rate and Reinvest_Rate arguments are percentages expressed as decimal values. For example, 12 percent is expressed as 0.12.

The MIRR function uses the order of values within the array to interpret the order of payments and receipts.

**6.1.2.6.1.6 NPer**

Function Declaration

```
Function NPer(Rate As Double, Pmt As Double, PV As Double,
Optional FV As Variant,
Optional Due As Variant) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Rate | Double data value specifying interest rate per period. For example, given a loan at an annual percentage rate (APR) of 10 percent and making monthly payments, the rate per period is 0.1/12, or 0.0083. |
| Pmt | Double data value specifying payment to be made each period. |
| Pv | Double specifying present value, or value today, of a series of future payments or receipts. |
| Fv | Double data value specifying future value or cash balance desired after final payment has been made. If omitted, the Double data value 0.0 is assumed. |
| Due | Integer data value specifying when payments are due. Use the data value 0 if payments are due at the end of the payment period, or use the data value 1 if payments are due at the beginning of the period.  If omitted, the data value 0 is assumed. |


Runtime Semantics.

Returns a Double data value specifying the number of periods for an annuity based on periodic, fixed payments and a fixed interest rate.

For all arguments, cash paid out (such as deposits to savings) is represented by negative numbers; cash received (such as dividend checks) is represented by positive numbers.

**6.1.2.6.1.7 NPV**

Function Declaration

```
Function NPV(Rate As Double, ValueArray() As Double) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Rate | Double data value specifying discount rate over the length of the period, expressed as a decimal fraction. |
| Values | Array of Double data values specifying cash flow values. The array MUST contain at least one negative value (a payment) and one positive value (a receipt). |


Runtime Semantics.

Returns a Double data value specifying the net present value of an investment based on a series of periodic cash flows (payments and receipts) and a discount rate.

The NPV function uses the order of values within the array to interpret the order of payments and receipts.

The NPV investment begins one period before the date of the first cash flow value and ends with the last cash flow value in the array.

The net present value calculation is based on future cash flows. If the first cash flow occurs at the beginning of the first period, the first value MUST be added to the value returned by NPV and MUST NOT be included in the cash flow values of Values( ).

The NPV function is similar to the PV function (present value) except that the PV function allows cash flows to begin either at the end or the beginning of a period. Unlike the variable NPV cash flow values, PV cash flows MUST be fixed throughout the investment.

**6.1.2.6.1.8 Pmt**

Function Declaration

```
Function Pmt(Rate As Double, NPer As Double, PV As Double,
Optional FV As Variant,
Optional Due As Variant) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Rate | Double data value specifying interest rate per period as a decimal fraction. |
| NPer | Double data value specifying total number of payment periods in the annuity. |
| Pv | Double data value specifying present value (or lump sum) that a series of payments to be paid in the future is worth now. |
| Fv | Double data value specifying future value or cash balance desired after the final payment has been made. If omitted, the data value 0.0 is assumed. |
| Due | Integer data value specifying when payments are due. Use the data value 0 if payments are due at the end of the payment period, or use the data value1 if payments are due at the beginning of the period.  If omitted, the data value 0 is assumed. |


Runtime Semantics.

Returns a Double data value specifying the payment for an annuity based on periodic, fixed payments and a fixed interest rate.

The Rate and NPer arguments MUST be calculated using payment periods expressed in the same units. For example, if Rate is calculated using months, NPer MUST also be calculated using months.

For all arguments, cash paid out (such as deposits to savings) is represented by negative numbers; cash received (such as dividend checks) is represented by positive numbers.

**6.1.2.6.1.9 PPmt**

Function Declaration

```
Function PPmt(Rate As Double, Per As Double,
NPer As Double, PV As Double,
Optional FV As Variant,
Optional Due As Variant) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Rate | Double data value specifying interest rate per period. For example, given a loan at an annual percentage rate (APR) of 10 percent and making monthly payments, the rate per period is 0.1/12, or 0.0083. |
| Per | Double data value specifying payment period in the range 1 through NPer. |
| NPer | Double data value specifying total number of payment periods in the annuity. For example, if making monthly payments on a four-year loan, the loan has a total of 4 * 12 (or 48) payment periods. |
| Pv | Double data value specifying present value, or value today, of a series of future payments or receipts. |
| Fv | Double data value specifying future value or cash balance desired after the final payment has been made. If omitted, the data value 0.0 is assumed. |
| Due | Integer data value specifying when payments are due. Use the data value 0 if payments are due at the end of the payment period, or use the data value1 if payments are due at the beginning of the period.  If omitted, the data value 0 is assumed. |


Runtime Semantics.

Returns a Double data value specifying the principal payment for a given period of an annuity based on periodic, fixed payments and a fixed interest rate. The Rate and NPer arguments MUST be calculated using payment periods expressed in the same units. For example, if Rate is calculated using months, NPer MUST also be calculated using months.

For all arguments, cash paid out (such as deposits to savings) is represented by negative numbers; cash received (such as dividend checks) is represented by positive numbers.

**6.1.2.6.1.10 PV**

Function Declaration

```
Function PV(Rate As Double, NPer As Double, Pmt As Double,
Optional FV As Variant,
Optional Due As Variant) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Rate | Double data value specifying interest rate per period. For example, given a loan at an annual percentage rate (APR) of 10 percent and making monthly payments, the rate per period is 0.1/12, or 0.0083. |
| NPer | Double data value specifying total number of payment periods in the annuity. |
| Pmt | Double data value specifying present value (or lump sum) that a series of payments to be paid in the future is worth now. |
| Fv | Double data value specifying future value or cash balance desired after the final payment has been made. |
| Due | Integer data value specifying when payments are due. Use the data value 0 if payments are due at the end of the payment period, or use the data value 1 if payments are due at the beginning of the period.  If omitted, the data value 0 is assumed. |


Runtime Semantics.

Returns a Double data value specifying the present value of an annuity based on periodic, fixed payments to be paid in the future and a fixed interest rate.

The Rate and NPer arguments MUST be calculated using payment periods expressed in the same units. For example, if Rate is calculated using months, NPer MUST also be calculated using months.

For all arguments, cash paid out (such as deposits to savings) is represented by negative numbers; cash received (such as dividend checks) is represented by positive numbers.

**6.1.2.6.1.11 Rate**

Function Declaration

```
Function Rate(NPer As Double, Pmt As Double, PV As Double,
Optional FV As Variant,
Optional Due As Variant,
Optional Guess As Variant) As Double
```



| Parameter | Description |
| --------- | ----------- |
| NPer | Double data value specifying total number of payment periods in the annuity. |
| Pmt | Double data value specifying payment to be made each period. |
| Pv | Double data value specifying present value, or value today, of a series of future payments or receipts. |
| Fv | Double data value specifying future value or cash balance desired after the final payment has been made. If omitted, the data value 0.0 is assumed. |
| Due | Integer data value specifying when payments are due. Use the data value 0 if payments are due at the end of the payment period, or use the data value1 if payments are due at the beginning of the period. If omitted, the data value 0 is assumed. |
| Guess | Double data value specifying the estimated value that will be returned by Rate. If omitted, guess is the data value 0.1 (10 percent). |

Runtime Semantics.

Returns a Double data value specifying the interest rate per period for an annuity.

For all arguments, cash paid out (such as deposits to savings) is represented by negative numbers; cash received (such as dividend checks) is represented by positive numbers.

Rate is calculated by iteration. Starting with the value of Guess, Rate cycles through the calculation until the result is accurate to within 0.00001 percent. If Rate can't find a result after 20 tries, it fails.

**6.1.2.6.1.12 SLN**

Function Declaration

```
Function SLN(Cost As Double, Salvage As Double,
Life As Double) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Cost | Double data value specifying initial cost of the asset. |
| Salvage | Double data value specifying value of the asset at the end of its useful life. |
| Life | Double data value specifying length of useful life of the asset. |


Runtime Semantics.

Returns a Double data value specifying the straight-line depreciation of an asset for a single period.

The depreciation period MUST be expressed in the same unit as the life argument. All arguments MUST be positive numbers.


**6.1.2.6.1.13 SYD**

Function Declaration

```
Function SYD(Cost As Double, Salvage As Double,
Life As Double, Period As Double) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Cost | Double data value specifying initial cost of the asset. |
| Salvage | Double data value specifying value of the asset at the end of its useful life. |
| Life | Double data value specifying length of useful life of the asset. |
| Period | Double data value specifying period for which asset depreciation is calculated. |


Runtime Semantics.

Returns a Double data value specifying the sum-of-years' digits depreciation of an asset for a specified period.

The Life and Period arguments MUST be expressed in the same units. For example, if Life is given in months, period MUST also be given in months. All arguments MUST be positive numbers.


##### 6.1.2.7 Information

###### 6.1.2.7.1 Public Functions

**6.1.2.7.1.1 IMEStatus**

Function Declaration

```
Function IMEStatus() As VbIMEStatus
```

Runtime Semantics.

Returns an Integer data value specifying the current implementation dependent Input Method Editor (IME) mode.

**6.1.2.7.1.2 IsArray**

Function Declaration

```
Function IsArray(Arg As Variant) As Boolean
```



| Parameter | Description |
| --------- | ----------- |
| Arg | Data value to test to see if it is an array. |


Runtime Semantics.

IsArray returns True if the data value of Arg is an array data value; otherwise, it returns False

**6.1.2.7.1.3 IsDate**

Function Declaration

```
Function IsDate(Arg As Variant) As Boolean
```



| Parameter | Description |
| --------- | ----------- |
| Arg | Data value to test to see if it is a Date. |


Runtime Semantics.

Returns a Boolean value indicating whether Arg is a Date data value or a String data value that can be Let-coerced to a Date data value.

**6.1.2.7.1.4 IsEmpty**

Function Declaration

```
Function IsEmpty(Arg As Variant) As Boolean
```



| Parameter | Description |
| --------- | ----------- |
| Arg | Any data value. |

Runtime Semantics.

IsEmpty returns True if the data value of Arg is the data value Empty. Otherwise, it returns False.

**6.1.2.7.1.5 IsError**

Function Declaration

```
Function IsError(Arg As Variant) As Boolean
```



| Parameter | Description |
| --------- | ----------- |
| Arg | Any data value. |


Runtime Semantics.

IsError returns True if the data value of Arg is an Error data value. Otherwise, it returns False.

**6.1.2.7.1.6 IsMissing**

Function Declaration

```
Function IsMissing(Arg As Variant) As Boolean
```



| Parameter | Description |
| --------- | ----------- |
| Arg | Any data value. |


Runtime Semantics.

IsMissing returns True if the data value of Arg is the Missing data value. Otherwise, it returns False.

If IsMissing is used on a ParamArray argument, it returns False.

**6.1.2.7.1.7 IsNull**

Function Declaration

```
Function IsNull(Arg As Variant) As Boolean
```



| Parameter | Description |
| --------- | ----------- |
| Arg | Any data value. |


Runtime Semantics.

IsNull returns True if the data value of Arg is the Null data value. Otherwise, it returns False.


**6.1.2.7.1.8 IsNumeric**

Function Declaration

```
Function IsNumeric(Arg As Variant) As Boolean
```



| Parameter | Description |
| --------- | ----------- |
| Arg | Any data value. |


Runtime Semantics.

IsNumeric returns True if the value type of the data value of Arg is any of Byte, Currency, Decimal, Double, Integer, Long, LongLong, Single, or Boolean. Otherwise, it returns False.


**6.1.2.7.1.9 IsObject**

Function Declaration

```
Function IsObject(Arg As Variant) As Boolean
```


| Parameter | Description |
| --------- | ----------- |
| Arg | Any data value. |


Runtime Semantics.

Returns True if the value type of the data value of Arg is Object Reference. Otherwise, it returns False.

**6.1.2.7.1.10 QBColor**

Function Declaration

```
Function QBColor(Color As Integer) As Long
```



| Parameter | Description |
| --------- | ----------- |
| Color | Integer data value in the range 0-15. |


Runtime Semantics.

If the data value of Color is outside of the range 0-15 then Error 5 ("Invalid procedure call or argument") is raised.

The color argument represents color values used by earlier versions of Visual Basic. Starting with the least-significant byte, the returned value specifies the red, green, and blue values used to set the appropriate color in the RGB system used by Visual Basic for Applications.

If the return value is specified by the following table:


| Color data value | Returned data value | Common name of color |
| ---------------- | ------------------- | -------------------- |
| 0 | 0 | Black |
| 1 | &H800000 | Blue |
| 2 | &H8000 | Green |
| 3 | &H808000 | Cyan |
| 4 | &H80 | Red |
| 5 | &H800080 | Magenta |
| 6 | &H8080 | Yellow |
| 7 | &HC0C0C0 | White |
| 8 | &H808080 | Gray |
| 9 | &HFF0000 | Light Blue |
| 10 | &HFF00 | Light Green |
| 11 | &HFFFF00 | Light Cyan |
| 12 | &HFF | Light Red |
| 13 | &HFF00FF | Light Magenta |
| 14 | &HFFFF | Light Yellow |
| 15 | &HFFFFFF | Bright White |


**6.1.2.7.1.11 RGB**

Function Declaration

```
Function RGB(Red As Integer, Green As Integer,
Blue As Integer) As Long
```



| Parameter | Description |
| --------- | ----------- |
| Red | Integer data value in the range 0-255, inclusive, that represents the red component of the color. |
| Green | Integer data value in the range 0-255, inclusive, that represents the green component of the color. |
| Blue | Integer data value in the range 0-255, inclusive, that represents the blue component of the color. |


Runtime Semantics.

Returns the Long data value:

(max(Blue,255)*65536)+(max(Green,255)*256)+max(Red,255).


**6.1.2.7.1.12 TypeName**

Function Declaration

```
Function TypeName(Arg As Variant) As String
```



| Parameter | Description |
| --------- | ----------- |
| Arg | Any data value. |


Runtime Semantics.

Returns a String that provides information about a variable.

The string returned by TypeName can be any one of the following:


| Value type of data value of Arg | String data value returned |
| ------------------------------- | -------------------------- |
| An object whose type is Object | The name of the object type |
| Byte | "Byte" |
| Integer | "Integer" |
| Long | "Long" |
| LongLong | "LongLong" |
| Single | "Single" |
| Double | "Double" |
| Currency | "Currency" |
| Decimal | "Decimal" |
| Date | "Date" |
| String | "String" |
| Boolean | "Boolean" |
| An error value or Missing | "Error" |
| Empty | "Empty" |
| Null | "Null" |
| Any Object Reference except Nothing | "Object" |
| An object whose type is unknown | "Unknown" |
| Nothing | "Nothing" |

If Arg is an array, the returned string can be any one of the possible returned strings (or Variant) with empty parentheses appended. For example, if Arg is an array of Integer, TypeName returns "Integer()". If Arg is an array of Variant values, TypeName returns "Variant()".

**6.1.2.7.1.13 VarType**

Function Declaration

```
Function VarType(VarName As Variant) As VbVarType
```



| Parameter | Description |
| --------- | ----------- |
| VarName | Any data value. |


Runtime Semantics.

Returns an Integer indicating the subtype of a variable.

The required VarName argument is a Variant containing any variable except a variable of a user-defined type.

Returns a value from the following table based on VarName’s value type:


| VarName’s value type | Value |
| -------------------- | ----- |
| Any Array type | 8192 + VarType of element’s type |
| Boolean | 11 |
| Byte | 17 |
| Currency | 6 |
| Date | 7 |
| Decimal | 14 |
| Double | 5 |
| Empty | 0 |
| Error or Missing | 10 |
| Integer | 2 |
| Long | 3 |
| LongLong (defined only on implementations that support a LongLong value type) | 20 |
| Null | 1 |
| Object reference | 9 |
| Single | 4 |
| String | 8 |
| Any UDT | 36 when the declared type is Variant.    0 when the declared type is a UDT. |
| Variant (as an element type of an array) | 12 |
| An implementation-defined value that can be stored in a Variant but that has no value in VBA | 13 |


##### 6.1.2.8 Interaction

###### 6.1.2.8.1 Public Functions

**6.1.2.8.1.1 CallByName**

Function Declaration

```
Function CallByName(Object As Object, ProcName As String, CallType As VbCallType, Args() As Variant)
```



| Parameter | Description |
| --------- | ----------- |
| Object | Object containing the object on which the function will be executed. |
| ProcName | String containing the name of a property or method of the object. |
| CallType | A constant of type vbCallType representing the type of procedure being called. |
| Args() | Variant array containing arguments to be passed to the method. |


Runtime Semantics.

The CallByName function is used to get or set a property, or invoke a method at run time using a string name, based on the value of the CallType argument:


| Constant | Value | Action |
| -------- | ----- | ------ |
| vbGet | 2 | Property Get |
| vbLet | 4 | Property Let |
| vbMethod | 1 | Method invocation |
| vbSet | 8 | Property Set |

If CallType has the value vbSet, the last argument in the Args array represents the value to set.

**6.1.2.8.1.2 Choose**

Function Declaration

```
Function Choose(Index As Single, ParamArray Choice() As Variant)
```



| Parameter | Description |
| --------- | ----------- |
| Index | Numeric expression that results in a value between the data value 1 and the number of available choices. |
| Choice | A ParamArray argument containing all the functions arguments starting with the second argument. |


Runtime Semantics.

Returns a value from its list of arguments.

Choose returns a value from the list of choices based on the value of index. If Index is n, Choose returns the n-th element of the Choice ParamArray.

The Choose function returns the data value Null if Index is less than 1 or greater than the number of choices listed.

If Index argument is Let-coerced to declared type Integer before being used to select

**6.1.2.8.1.3 Command**

Function Declaration

```
Function Command() As Variant
Function Command$() As String
```

Runtime Semantics.

Returns the argument portion of the implementation dependent command used to initiate execution of the currently executing VBA program.

The runtime semantics of Command$ are identical to those of Command with the exception that the declared type of the return value is String rather than Variant.

**6.1.2.8.1.4 CreateObject**

Function Declaration

```
Function CreateObject(Class As String, Optional ServerName
As String)
```



| Parameter | Description |
| --------- | ----------- |
| Class | A String data value, containing the application name and class of the object to create. |
| ServerName | A String data value, containing the name of the network server where the object will be created. If ServerName is an empty string (""), the local machine is used. |


Runtime Semantics.

Creates and returns an object reference to an externally provided and possibly remote object.

The class argument uses the Function Declaration AppName.ObjectType and has these parts:


| Parameter | Description |
| --------- | ----------- |
| AppName | The name of the application providing the object. The form and interpretation of an AppName is implementation defined. |
| ObjectType | The name of the type or class of object to create. The form and interpretation of an ObjectType name is implementation defined. |

The data value returned by CreateObject is an object reference and can be used in any context where an object reference is expected.

If remote objects are supported it is via an implementation defined mechanism.

The format and interpretation of the ServerName argument is implementation defined but the intent is to identify a specific remote computer that that is responsible for providing a reference to a remote object.

An implementation can provide implementation defined mechanisms for designating single instance classes in which case only one instance of such a class is created, no matter how many times CreateObject is call requesting an instance of such a class.

**6.1.2.8.1.5 DoEvents**

Function Declaration

```
Function DoEvents() As Integer
```

Runtime Semantics.

Yields execution so that the operating system can process externally generated events.

The DoEvents function returns an Integer with an implementation defined meaning.

DoEvents passes control to the operating system. Control is returned after the operating system has finished processing any events in its queue and all keys in the SendKeys queue have been sent.

**6.1.2.8.1.6 Environ / Environ$**

Function Declaration

```
Function Environ(Key As Variant) As Variant
Function Environ$(Key As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Key | Either a String or a data value that is Let-coercible to Long |

Runtime Semantics.

Returns the String associated with an implementation-defined environment variable.

If Key is a String and is not the name of a defined environment variable, a zero-length string ("") is returned. Otherwise, Environ returns the string value of the environment variable whose name is the value of Key.

If Key is numeric the string occupying that numeric position in the environment-string table is returned. The first value in the table starts at position 1. In this case, Environ returns a string of the form "name=value" where name is the name of the environment variable and value is its value. If there is no environment string in the specified position, Environ returns a zero-length string.

The runtime semantics of Environ$ are identical to those of Environ with the exception that the declared type of the return value is String rather than Variant.

**6.1.2.8.1.7 GetAllSettings**

Function Declaration

```
Function GetAllSettings(AppName As String, Section As String)
```



| Parameter | Description |
| --------- | ----------- |
| AppName | String expression containing the name of the application or project whose key settings are requested. |
| Section | String expression containing the name of the section whose key settings are requested. |

Runtime Semantics.

If either AppName or Section does not exist in the settings store, return the data value Empty.

Returns a two-dimensional array of strings containing all the key settings in the specified section and their corresponding values. The lower bound of each dimension is 1. The upper bound of the first dimension is the number of key/value pair. The upper bound of the second dimension is 2.

**6.1.2.8.1.8 GetAttr**

Function Declaration

```
Function GetAttr(PathName As String) As VbFileAttribute
```



| Parameter | Description |
| --------- | ----------- |
| PathName | Expression that specifies a file name; can include directory or folder, and drive. |

Runtime Semantics.

The argument MUST be a valid implementation defined external file identifier.

Returns an Integer representing attributes of the file, directory, or folder identified by PathName.

The value returned by GetAttr is composed of the sum of the following of the Enum elements of the Enum VBA.VbFileAttribute and have the following meanings:


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbNormal | 0 | Normal. |
| vbReadOnly | 1 | Read-only. |
| vbHidden | 2 | Hidden. |
| vbSystem | 4 | System file. |
| vbDirectory | 16 | Directory or folder. |
| vbArchive | 32 | File has changed since last backup. |


**6.1.2.8.1.9 GetObject**

Function Declaration

```
Function GetObject(Optional PathName As Variant, Optional Class As Variant)
```



| Parameter | Description |
| --------- | ----------- |
| Class | String, containing the application name and class of the object to create. |
| PathName | String, containing the name of the network server where the object will be created. If PathName is an empty string (""), the local machine is used. |

Runtime Semantics.

Returns an object reference to an externally provided and possibly remote object.

The Class argument uses the syntax AppName.ObjectType and has these parts:


| Parameter | Description |
| --------- | ----------- |
| AppName | The name of the application providing the object. The form and interpretation of an AppName is implementation defined. |
| ObjectType | The name of the type or class of object to create. The form and interpretation of an ObjectType name is implementation defined. |

Returns an object reference to an externally provided and possibly remote object.

If an object has registered itself as a single-instance object, only one instance of the object is created, no matter how many times CreateObject is executed. With a single-instance object, GetObject always returns the same instance when called with the zero-length string ("") syntax, and it causes an error if the pathname argument is omitted. You can't use GetObject to obtain a reference to a class created with Visual Basic.

**6.1.2.8.1.10 GetSetting**

Function Declaration

```
Function GetSetting(AppName As String, Section As String, Key As String, Optional Default As Variant) As String
```



| Parameter | Description |
| --------- | ----------- |
| AppName | String expression containing the name of the application or project whose key setting is requested. |
| Section | String expression containing the name of the section where the key setting is found. |
| Key | String expression containing the name of the key setting to return. |
| Default | Variant expression containing the value to return if no value is set in the key setting. If omitted, default is assumed to be a zero-length string (""). |

Runtime Semantics.

Returns a key setting value from an application's entry in an implementation dependent application registry.

If any of the items named in the GetSetting arguments do not exist, GetSetting returns the value of Default.

**6.1.2.8.1.11 IIf**

Function Declaration

```
Function IIf(Expression As Variant, TruePart As Variant, FalsePart As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Variant containing the expression to be evaluated. |
| TruePart | Variant, containing the value to be returned if Expression evaluates to the data value True. |
| FalsePart | Variant, containing the value to be returned if Expression evaluates to the data value False. |

Runtime Semantics.

Returns one of two parts, depending on the evaluation of an expression.

IIf always evaluates both TruePart (first) and FalsePart, even though it returns only one of them. For example, if evaluating FalsePart results in a division by zero error, an error occurs even if Expression is True.

**6.1.2.8.1.12 InputBox**

Function Declaration

```
Function InputBox(Prompt As Variant, Optional Title As
Variant, Optional Default As Variant, Optional XPos As
Variant, Optional YPos As Variant, Optional HelpFile As
Variant, Optional Context As Variant) As String
```



| Parameter | Description |
| --------- | ----------- |
| Prompt | String data value to be displayed as the message in the dialog box. The maximum length of prompt is approximately 1024 characters, depending on the width of the characters used. If prompt consists of more than one line, the lines can be separated using a carriage return character (Chr(13)), a linefeed character (Chr(10)), or carriage return + linefeed character combination (Chr(13) & Chr(10)) between each line. |
| Title | String to be displayed in the title bar of the dialog box. If Title is omitted, the project name( 4.1) is placed in the title bar. |
| Default | String to be displayed in the text box as the default response if no other input is provided. If Default is omitted, the text box is displayed empty. |
| XPos | Long that specifies, in twips, the horizontal distance of the left edge of the dialog box from the left edge of the screen. If XPos is omitted, the dialog box is horizontally centered. |
| YPos | Long that specifies, in twips, the vertical distance of the upper edge of the dialog box from the top of the screen. If YPos is omitted, the dialog box is vertically positioned approximately one-third of the way down the screen. |
| HelpFile | String that identifies the Help file to use to provide context-sensitive Help for the dialog box. If HelpFile is provided, Context MUST also be provided. |
| Context | Long that is the Help context number assigned to the appropriate Help topic by the Help author. If Context is provided, HelpFile MUST also be provided. |


Runtime Semantics.

Displays a prompt in a dialog box, waits for the user to input text or click a button, and returns a String containing the contents of the text box.

When both HelpFile and Context are provided, the user can press F1 to view the Help topic corresponding to the context. Some host applications can also automatically add a Help button to the dialog box. If the user clicks OK or presses ENTER , the InputBox function returns whatever is in the text box. If the user clicks Cancel, the function returns a zero-length string ("").

Note: to specify more than the first named argument, you MUST use InputBox in an expression.

To omit some positional arguments, you MUST include the corresponding comma delimiter.

**6.1.2.8.1.13 MsgBox**

Function Declaration

```
Function MsgBox(Prompt As Variant, Optional Buttons As
VbMsgBoxStyle = vbOKOnly, Optional Title As Variant,
Optional HelpFile As Variant, Optional Context As Variant) As VbMsgBoxResult
```



| Parameter | Description |
| --------- | ----------- |
| Prompt | String to be displayed as the message in the dialog box. The maximum length of prompt is approximately 1024 characters, depending on the width of the characters used. If prompt consists of more than one line, the lines can be separated using a carriage return character (Chr(13)), a linefeed character (Chr(10)), or carriage return + linefeed character combination (Chr(13) & Chr(10)) between each line. |
| Buttons | Numeric expression that is the sum of values specifying the number and type of buttons to display, the icon style to use, the identity of the default button, and the modality of the message box. If omitted, the default value for Buttons is 0. |
| Title | String to be displayed in the title bar of the dialog box. If Title is omitted, the project name (section 4.1) is placed in the title bar. |
| HelpFile | String that identifies the Help file to use to provide context-sensitive Help for the dialog box. If HelpFile is provided, Context MUST also be provided. |
| Context | Long that is the Help context number assigned to the appropriate Help topic by the Help author. If Context is provided, HelpFile MUST also be provided. |

Runtime Semantics.

Displays a message in a dialog box, waits for the user to click a button, and returns an Integer indicating which button the user clicked.

The Buttons argument settings are:


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbOKOnly | 0 | Display OK button only. |
| vbOKCancel | 1 | Display OK and Cancel buttons. |
| vbAbortRetryIgnore | 2 | Display Abort, Retry, and Ignore buttons. |
| vbYesNoCancel | 3 | Display Yes, No, and Cancel buttons. |
| vbYesNo | 4 | Display Yes and No buttons. |
| vbRetryCancel | 5 | Display Retry and Cancel buttons. |
| vbCritical | 16 | Display Critical Message icon. |
| vbQuestion | 32 | Display Warning Query icon. |
| vbExclamation | 48 | Display Warning Message icon. |
| vbInformation | 64 | Display Information Message icon. |
| vbDefaultButton1 | 0 | First button is default. |
| vbDefaultButton2 | 256 | Second button is default. |
| vbDefaultButton3 | 512 | Third button is default. |
| vbDefaultButton4 | 768 | Fourth button is default. |
| vbApplicationModal | 0 | Application modal; the user MUST respond to the message box before continuing work in the current application. |
| vbSystemModal | 4096 | System modal; all applications are suspended until the user responds to the message box. |
| vbMsgBoxHelpButton | 16384 | Adds Help button to the message box |
| VbMsgBoxSetForeground | 65536 | Specifies the message box window as the foreground window |
| vbMsgBoxRight | 524288 | Text is right aligned |
| vbMsgBoxRtlReading | 1048576 | Specifies text SHOULD appear as right-to-left reading on Hebrew and Arabic systems |

The first group of values (05) describes the number and type of buttons displayed in the dialog box; the second group (16, 32, 48, 64) describes the icon style; the third group (0, 256, 512) determines which button is the default; and the fourth group (0, 4096) determines the modality of the message box. When adding numbers to create a final value for the buttons argument, use only one number from each group.

The MsgBox function can return one of the following values:


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbOK | 1 | OK |
| vbCancel | 2 | Cancel |
| vbAbort | 3 | Abort |
| vbRetry | 4 | Retry |
| vbIgnore | 5 | Ignore |
| vbYes | 6 | Yes |
| vbNo | 7 | No |

When both HelpFile and Context are provided, the user can press F1 to view the Help topic corresponding to the context. Some host applications, for example, Microsoft Excel 2010, also automatically add a Help button to the dialog box.

If the dialog box displays a Cancel button, pressing the ESC key has the same effect as clicking Cancel. If the dialog box contains a Help button, context-sensitive Help is provided for the dialog box. However, no value is returned until one of the other buttons is clicked.

Note: to specify more than the first named argument, you MUST use MsgBox in an expression.

To omit some positional arguments, you MUST include the corresponding comma delimiter.

**6.1.2.8.1.14 Partition**

Function Declaration

```
Function Partition(Number As Variant, Start As Variant, Stop As Variant, Interval As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Number | Long to be evaluated against the ranges. |
| Start | Long that is the start of the overall range of numbers. The number can't be less than 0. |
| Stop | Long that is the end of the overall range of numbers. The number can't be equal to or less than Start. |
| Interval | Long that is the interval of each range. The number can’t be less than 1. |

Runtime Semantics.

Returns a String indicating where a number occurs within a calculated series of ranges.

The Partition function identifies the particular range in which Number falls and returns a String describing that range. The Partition function is most useful in queries. You can create a select query that shows how many orders fall within various ranges, for example, order values from 1 to 1000, 1001 to 2000, and so on.

The following table shows how the ranges are determined using three sets of Start, Stop, and Interval parts. The First Range and Last Range columns show what Partition returns. The ranges are represented by lowervalue:uppervalue, where the low end (lowervalue) of the range is separated from the high end (uppervalue) of the range with a colon (:).


| Start | Stop | Interval | Before First | First Range | Last Range | After Last |
| ----- | ---- | -------- | ------------ | ----------- | ---------- | ---------- |
| 0 | 99 | 5 | "   :-1" | "      0:  4" | "     95: 99" | "   100:   " |
| 20 | 199 | 10 | "   :  19" | "    20:  29" | "   190: 199" | "   200:   " |
| 100 | 1010 | 20 | "   :   99" | "  100:  119" | " 1000: 1010" | " 1011:   " |

In the preceding table, the third line shows the result when Start and Stop define a set of numbers that can't be evenly divided by Interval. The last range extends to Stop (11 numbers) even though Interval is 20.

If necessary, Partition returns a range with enough leading spaces so that there are the same number of characters to the left and right of the colon as there are characters in Stop, plus one. This ensures that if you use Partition with other numbers, the resulting text will be handled properly during any subsequent sort operation.

If Interval is 1, the range is number:number, regardless of the Start and Stop arguments. For example, if Interval is 1, Number is 100 and Stop is 1000, Partition returns "  100:  100".

If any of the parts is Null, Partition returns the data value Null.

**6.1.2.8.1.15 Shell**

Function Declaration

```
Function Shell(PathName As Variant, Optional WindowStyle As VbAppWinStyle = vbMinimizedFocus) As Double
```



| Parameter | Description |
| --------- | ----------- |
| PathName | String, containing the name of the program to execute and any required arguments or command-line switches; can include directory or folder and drive. |
| WindowStyle | Integer corresponding to the style of the window in which the program is to be run. If WindowStyle is omitted, the program is started minimized, with focus. |

Runtime Semantics.

Runs an executable program and returns a Double representing the implementation-defined program's task ID if successful, otherwise it returns the data value 0.

The WindowStyle parameter accepts these values:


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbHide | 0 | Window is hidden and focus is passed to the hidden window. |
| vbNormalFocus | 1 | Window has focus and is restored to its original size and position. |
| vbMinimizedFocus | 2 | Window is displayed as an icon with focus. |
| vbMaximizedFocus | 3 | Window is maximized with focus. |
| vbNormalNoFocus | 4 | Window is restored to its most recent size and position. The currently active window remains active. |
| vbMinimizedNoFocus | 6 | Window is displayed as an icon. The currently active window remains active. |

If the Shell function successfully executes the named file, it returns the task ID of the started program. The task ID is an implementation-defined unique number that identifies the running program. If the Shell function can't start the named program, an error occurs.

Note: by default, the Shell function runs other programs asynchronously. This means that a program started with Shell might not finish executing before the statements following the Shell function are executed.

**6.1.2.8.1.16 Switch**

Function Declaration

```
Function Switch(ParamArray VarExpr() As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| VarExpr | Array of type Variant containing expressions to be evaluated. |

Runtime Semantics.

- Evaluates a list of expressions and returns a Variant value or an expression associated with the first expression in the list that evaluates to the data value True.
- The Switch function argument list consists of pairs of expressions and values. The expressions are evaluated from left to right, and the value associated with the first expression to evaluate to True is returned. If the parts aren't properly paired, a run-time error occurs. For example, if VarExpr(0) evaluates to the data value True, Switch returns VarExpr(1). If VarExpr(0) evaluates to the data value False, but VarExpr(2) evaluates to the data value True, Switch returns VarExpr(3), and so on.
- Switch returns a Null value if:
- None of the expressions evaluates to the data value True.
- The first True expression has a corresponding value that is the data value Null.
- Switch evaluates all of the expressions, even though it returns only one of them. For example, if the evaluation of any expression results in a division by zero error, an error occurs.
###### 6.1.2.8.2 Public Subroutines

**6.1.2.8.2.1 AppActivate**

Function Declaration

```
Sub AppActivate(Title As Variant, Optional Wait As Variant)
```



| Parameter | Description |
| --------- | ----------- |
| Title | String specifying the title in the title bar of the application window to activate. The task ID returned by the Shell function can be used in place of title to activate an application. |
| Wait | Boolean value specifying whether the calling application has the focus before activating another. If False (default), the specified application is immediately activated, even if the calling application does not have the focus. If True, the calling application waits until it has the focus, then activates the specified application. |

Runtime Semantics.

Activates an application window.

The AppActivate statement changes the focus to the named application or window but does not affect whether it is maximized or minimized. Focus moves from the activated application window when the user takes some action to change the focus or close the window. Use the Shell function to start an application and set the window style.

In determining which application to activate, Title is compared to the title string of each running application. If there is no exact match, any application whose title string begins with Title is activated. If there is more than one instance of the application named by Title, the window that is activated is implementation-defined.

**6.1.2.8.2.2 Beep**

Function Declaration

```
Sub Beep()
```

Runtime Semantics.

Sounds a tone through the computer's speaker.

The frequency and duration of the beep depend on hardware and system software, and vary among computers.

**6.1.2.8.2.3 DeleteSetting**

Function Declaration

```
Sub DeleteSetting(AppName As String, Optional Section As String, Optional Key As String)
```



| Parameter | Description |
| --------- | ----------- |
| AppName | String expression containing the name of the application or project to which the section or key setting applies. |
| Section | String expression containing the name of the section where the key setting is being deleted. If only AppName and Section are provided, the specified section is deleted along with all related key settings. |
| Key | String expression containing the name of the key setting being deleted. |

Runtime Semantics.

Deletes a section or key setting from an application's entry in an implementation dependent application registry.

If all arguments are provided, the specified setting is deleted. A run-time error occurs if you attempt to use the DeleteSetting statement on a non-existent Section or Key setting.

**6.1.2.8.2.4 SaveSetting**

Function Declaration

```
Sub SaveSetting(AppName As String, Section As String, Key
As String, Setting As String)
```


| Parameter | Description |
| --------- | ----------- |
| AppName | String expression containing the name of the application or project to which the setting applies. |
| Section | String expression containing the name of the section where the key setting is being saved. |
| Key | String expression containing the name of the key setting being saved. |
| Setting | String expression containing the value that key is being set to. |

Runtime Semantics.

Saves or creates an application entry in the application's entry in the implementation dependent application registry.

An error occurs if the key setting can’t be saved for any reason.

**6.1.2.8.2.5 SendKeys**

Function Declaration

```
Sub SendKeys(String As String, Optional Wait As Variant)
```



| Parameter | Description |
| --------- | ----------- |
| String | String expression specifying the keystrokes to send. |
| Wait | Boolean containing a value specifying the wait mode. If it evaluates to the data value False (default), control is returned to the procedure immediately after the keys are sent. If it evaluates to the data value True, keystrokes MUST be processed before control is returned to the procedure. |

Runtime Semantics.

Sends one or more keystrokes to the active window as if typed at the keyboard.

Each key is represented by one or more characters. To specify a single keyboard character, use the character itself. For example, to represent the letter A, use

"A"

for String. To represent more than one character, append each additional character to the one preceding it. To represent the letters A, B, and C, use

"ABC"

for String.

The plus sign (+), caret (^), percent sign (%), tilde (~), and parentheses ( ) have special meanings to SendKeys. To specify one of these characters, enclose it within braces (

{}

). For example, to specify the plus sign, use

{+}

Brackets ([ ]) have no special meaning to SendKeys, but you MUST enclose them in braces. In other applications, brackets do have a special meaning that can be significant when dynamic data exchange (DDE) occurs. To specify brace characters, use

{{}

and

{}}

To specify characters that aren't displayed when you press a key, such as ENTER or TAB, and keys that represent actions rather than characters, use the codes shown in the following table:


| Key | Code |
| --- | ---- |
| BACKSPACE | {BACKSPACE}, {BS}, or {BKSP} |
| BREAK | {BREAK} |
| CAPS LOCK | {CAPSLOCK} |
| DEL or DELETE | {DELETE} or {DEL} |
| DOWN ARROW | {DOWN} |
| END | {END} |
| ENTER | {ENTER}or ~ |
| ESC | {ESC} |
| HELP | {HELP} |
| HOME | {HOME} |
| INS or INSERT | {INSERT} or {INS} |
| LEFT ARROW | {LEFT} |
| NUM LOCK | {NUMLOCK} |
| PAGE DOWN | {PGDN} |
| PAGE UP | {PGUP} |
| PRINT SCREEN | {PRTSC} |
| RIGHT ARROW | {RIGHT} |
| SCROLL LOCK | {SCROLLLOCK} |
| TAB | {TAB} |
| UP ARROW | {UP} |
| F1 | {F1} |
| F2 | {F2} |
| F3 | {F3} |
| F4 | {F4} |
| F5 | {F5} |
| F6 | {F6} |
| F7 | {F7} |
| F8 | {F8} |
| F9 | {F9} |
| F10 | {F10} |
| F11 | {F11} |
| F12 | {F12} |
| F13 | {F13} |

To specify keys combined with any combination of the SHIFT, CTRL, and ALT keys, precede the key code with one or more of the following codes:


| Key | Code |
| --- | ---- |
| SHIFT | + |
| CTRL | ^ |
| ALT | % |

To specify that any combination of SHIFT, CTRL, and ALT SHOULD be held down while several other keys are pressed, enclose the code for those keys in parentheses. For example, to specify to hold down SHIFT while E and C are pressed, use "+(EC)". To specify to hold down SHIFT while E is pressed, followed by C without SHIFT, use "+EC".

To specify repeating keys, use the form {key number}. You MUST put a space between key and number. For example, {LEFT 42} means press the LEFT ARROW key 42 times; {h 10} means press H 10 times.

##### 6.1.2.9 KeyCodeConstants



| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbKeyLButton | 1 | Left mouse button |
| vbKeyRButton | 2 | Right mouse button |
| vbKeyCancel | 3 | CANCEL key |
| vbKeyMButton | 4 | Middle mouse button |
| vbKeyBack | 8 | BACKSPACE key |
| vbKeyTab | 9 | TAB key |
| vbKeyClear | 12 | CLEAR key |
| vbKeyReturn | 13 | ENTER key |
| vbKeyShift | 16 | SHIFT key |
| vbKeyControl | 17 | CTRL key |
| vbKeyMenu | 18 | MENU key |
| vbKeyPause | 19 | PAUSE key |
| vbKeyCapital | 20 | CAPS LOCK key |
| vbKeyEscape | 27 | ESC key |
| vbKeySpace | 32 | SPACEBAR key |
| vbKeyPageUp | 33 | PAGE UP key |
| vbKeyPageDown | 34 | PAGE DOWN key |
| vbKeyEnd | 35 | END key |
| vbKeyHome | 36 | HOME key |
| vbKeyLeft | 37 | LEFT ARROW key |
| vbKeyUp | 38 | UP ARROW key |
| vbKeyRight | 39 | RIGHT ARROW key |
| vbKeyDown | 40 | DOWN ARROW key |
| vbKeySelect | 41 | SELECT key |
| vbKeyPrint | 42 | PRINT SCREEN key |
| vbKeyExecute | 43 | EXECUTE key |
| vbKeySnapshot | 44 | SNAPSHOT key |
| vbKeyInsert | 45 | INS key |
| vbKeyDelete | 46 | DEL key |
| vbKeyHelp | 47 | HELP key |
| vbKeyNumlock | 144 | NUM LOCK key |
| vbKeyA | 65 | A key |
| vbKeyB | 66 | B key |
| vbKeyC | 67 | C key |
| vbKeyD | 68 | D key |
| vbKeyE | 69 | E key |
| vbKeyF | 70 | F key |
| vbKeyG | 71 | G key |
| vbKeyH | 72 | H key |
| vbKeyI | 73 | I key |
| vbKeyJ | 74 | J key |
| vbKeyK | 75 | K key |
| vbKeyL | 76 | L key |
| vbKeyM | 77 | M key |
| vbKeyN | 78 | N key |
| vbKeyO | 79 | O key |
| vbKeyP | 80 | P key |
| vbKeyQ | 81 | Q key |
| vbKeyR | 82 | R key |
| vbKeyS | 83 | S key |
| vbKeyT | 84 | T key |
| vbKeyU | 85 | U key |
| vbKeyV | 86 | V key |
| vbKeyW | 87 | W key |
| vbKeyX | 88 | X key |
| vbKeyY | 89 | Y key |
| vbKeyZ | 90 | Z key |
| vbKey0 | 48 | 0 key |
| vbKey1 | 49 | 1 key |
| vbKey2 | 50 | 2 key |
| vbKey3 | 51 | 3 key |
| vbKey4 | 52 | 4 key |
| vbKey5 | 53 | 5 key |
| vbKey6 | 54 | 6 key |
| vbKey7 | 55 | 7 key |
| vbKey8 | 56 | 8 key |
| vbKey9 | 57 | 9 key |
| vbKeyNumpad0 | 96 | Numpad 0 key |
| vbKeyNumpad1 | 97 | Numpad 1 key |
| vbKeyNumpad2 | 98 | Numpad 2 key |
| vbKeyNumpad3 | 99 | Numpad 3 key |
| vbKeyNumpad4 | 100 | Numpad 4 key |
| vbKeyNumpad5 | 101 | Numpad 5 key |
| vbKeyNumpad6 | 102 | Numpad 6 key |
| vbKeyNumpad7 | 103 | Numpad 7 key |
| vbKeyNumpad8 | 104 | Numpad 8 key |
| vbKeyNumpad9 | 105 | Numpad 9 key |
| vbKeyMultiply | 106 | Numpad MULTIPLICATION SIGN (*) key |
| vbKeyAdd | 107 | Numpad PLUS SIGN (+) key |
| vbKeySeparator | 108 | Numpad ENTER (keypad) key |
| vbKeySubtract | 109 | Numpad MINUS SIGN (-) key |
| vbKeyDecimal | 110 | Numpad DECIMAL POINT(.) key |
| vbKeyDivide | 111 | Numpad DIVISION SIGN (/) key |
| vbKeyF1 | 112 | F1 key |
| vbKeyF2 | 113 | F2 key |
| vbKeyF3 | 114 | F3 key |
| vbKeyF4 | 115 | F4 key |
| vbKeyF5 | 116 | F5 key |
| vbKeyF6 | 117 | F6 key |
| vbKeyF7 | 118 | F7 key |
| vbKeyF8 | 119 | F8 key |
| vbKeyF9 | 120 | F9 key |
| vbKeyF10 | 121 | F10 key |
| vbKeyF11 | 122 | F11 key |
| vbKeyF12 | 123 | F12 key |
| vbKeyF13 | 124 | F13 key |
| vbKeyF14 | 125 | F14 key |
| vbKeyF15 | 126 | F15 key |
| vbKeyF16 | 127 | F16 key |


##### 6.1.2.10 Math

###### 6.1.2.10.1 Public Functions

**6.1.2.10.1.1 Abs**

Function Declaration

```
Function Abs(Number As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Number | Any data value. |

Runtime Semantics.

If Number is the data value Null, returns Null.

If Number is the data value Empty, returns the Integer data value 0.

If Number is of a numeric value type, returns a value of the same value type specifying the absolute value of a number.

Otherwise, the data value of Number is Let-coerced to Double and the absolute value of that data value is returned.

**6.1.2.10.1.2 Atn**

Function Declaration

```
Function Atn(Number As Double) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Number | Double containing any valid numeric expression. |

Runtime Semantics.

Returns a Double specifying the arctangent of a number.

The Atn function takes the ratio of two sides of a right triangle (Number) and returns the corresponding angle in radians. The ratio is the length of the side opposite the angle divided by the length of the side adjacent to the angle.

The range of the result is -pi/2 to pi/2 radians.

**6.1.2.10.1.3 Cos**

Function Declaration

```
Function Cos(Number As Double) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Number | Double containing any valid numeric expression that expresses an angle in radians. |

Runtime Semantics.

Returns a Double specifying the cosine of an angle.

The Cos function takes an angle and returns the ratio of two sides of a right triangle. The ratio is the length of the side adjacent to the angle divided by the length of the hypotenuse. The result lies in the range -1 to 1.

**6.1.2.10.1.4 Exp**

Function Declaration

```
Function Exp(Number As Double) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Number | Double containing any valid numeric expression. |

Runtime Semantics.

Returns a Double specifying e (the base of natural logarithms) raised to a power.

If the value of Number exceeds 709.782712893, an error occurs. The constant e is approximately 2.718282.

**6.1.2.10.1.5 Log**

Function Declaration

```
Function Log(Number As Double) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Number | Double containing any valid numeric expression greater than zero. |

Runtime Semantics.

Returns a Double specifying the natural logarithm of a number.

The natural logarithm is the logarithm to the base e. The constant e is approximately 2.718282.

**6.1.2.10.1.6 Rnd**

Function Declaration

```
Function Rnd(Optional Number As Variant) As Single
```



| Parameter | Description |
| --------- | ----------- |
| Number | Single containing any valid numeric expression. |

Runtime Semantics.

Returns a Single containing a random number, according to the following table:


| If number is | Rnd generates |
| ------------ | ------------- |
| Less than zero | The same number every time, using Number as the seed. |
| Greater than zero | The next random number in the sequence. |
| Equal to zero | The most recently generated number. |
| Not supplied | The next random number in the sequence. |

The Rnd function returns a value less than 1 but greater than or equal to zero.

The value of Number determines how Rnd generates a random number:

o For any given initial seed, the same number sequence is generated because each successive call to the Rnd function uses the previous number as a seed for the next number in the sequence.

Before calling Rnd, use the Randomize statement without an argument to initialize the random-number generator with a seed based on the system timer.

To produce random integers in a given range, use this formula:

Int((upperbound - lowerbound + 1) * Rnd + lowerbound)

Here, upperbound is the highest number in the range, and lowerbound is the lowest number in the range.

An implementation is only required to repeat sequences of random numbers when Rnd is called with a negative argument before calling Randomize with a numeric argument. Using Randomize without calling Rnd in such a way yields implementation-defined results.

The Rnd function necessarily generates numbers in a predictable sequence, and therefore is not required to use cryptographically-random number generators.

**6.1.2.10.1.7 Round**

Function Declaration

```
Function Round(Number As Variant, Optional
NumDigitsAfterDecimal As Long) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Number | Variant containing the numeric expression being rounded. |
| NumDigitsAfterDecimal | Long indicating how many places to the right of the decimal are included in the rounding. If omitted, integers are returned by the Round function. |

Runtime Semantics.

Returns a number rounded to a specified number of decimal places.

**6.1.2.10.1.8 Sgn**

Function Declaration

```
Function Sgn(Number As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Number | Double containing any valid numeric expression. |

Runtime Semantics.

Returns an Integer indicating the sign of a number, according to the following table:


| If number is | Sgn returns |
| ------------ | ----------- |
| Greater than zero | 1 |
| Equal to zero | 0 |
| Less than zero | -1 |

The sign of the number argument determines the return value of the Sgn function.

**6.1.2.10.1.9 Sin**

Function Declaration

```
Function Sin(Number As Double) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Number | Double containing any valid numeric expression that expresses an angle in radians. |

Runtime Semantics.

Returns a Double specifying the sine of an angle.

The Sin function takes an angle and returns the ratio of two sides of a right triangle. The ratio is the length of the side opposite the angle divided by the length of the hypotenuse.

The result lies in the range -1 to 1.

**6.1.2.10.1.10 Sqr**

Function Declaration

```
Function Sqr(Number As Double) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Number | Double containing any valid numeric expression greater than zero. |

Runtime Semantics.

Returns a Double specifying the square root of a number.

**6.1.2.10.1.11 Tan**

Function Declaration

```
Function Tan(Number As Double) As Double
```



| Parameter | Description |
| --------- | ----------- |
| Number | Double containing any valid numeric expression that expresses an angle in radians. |

Runtime Semantics.

Returns a Double specifying the tangent of an angle.

Tan takes an angle and returns the ratio of two sides of a right triangle. The ratio is the length of the side opposite the angle divided by the length of the side adjacent to the angle.

###### 6.1.2.10.2 Public Subroutines

**6.1.2.10.2.1 Randomize**

Function Declaration

```
Sub Randomize(Optional Number As Variant)
```



| Parameter | Description |
| --------- | ----------- |
| Number | Empty or numeric seed value. If the argument is not Empty it MUST be Let-coercible to Double.  Read Only |

Runtime Semantics.

Initializes the random-number generator.

Randomize uses Number to initialize the Rnd function's random-number generator, giving it a new seed value. If the argument is missing or Empty, the value returned by the system timer is used as the new seed value.

If Randomize is not used, the Rnd function (with no arguments) uses the same number as a seed the first time it is called, and thereafter uses the last generated number as a seed value.

An implementation is only required to repeat sequences of random numbers when Rnd is called with a negative argument before calling Randomize with a numeric argument. Using Randomize without calling Rnd in such a way yields implementation-defined results.

##### 6.1.2.11 Strings

###### 6.1.2.11.1 Public Functions

**6.1.2.11.1.1 Asc / AscW**

Function Declaration

```
Function Asc(StringValue As String) As Integer
```



| Parameter | Description |
| --------- | ----------- |
| StringValue | String expression that SHOULD contain at least one character. |

Runtime Semantics.

Returns an Integer data value representing the 7-bit ASCII code point of the first character of StringValue. If the character does not correspond to an ASCII character the result is implementation defined.

Code point value greater than 32,767 are returned as negative Integer data values.

If the argument is the null string ("") Error Number 5 ("Invalid procedure call or argument") is raised.

**6.1.2.11.1.2 AscB**

Function Declaration

```
Function AscB(StringValue As String) As Integer
```



| Parameter | Description |
| --------- | ----------- |
| StringValue | String expression that SHOULD contain at least one character. |

Runtime Semantics.

Returns an Integer data value that is the first eight bits (the first byte) of the implementation dependent character encoding of the string. If individual character code points more than 8 bits it is implementation dependent as to whether the bits returned are the high order or low order bits of the code point.

If the argument is the null string ("") Error Number 5 ("Invalid procedure call or argument") is raised.

**6.1.2.11.1.3 AscW**

Function Declaration

```
Function AscW(StringValue As String) As Integer
```



| Parameter | Description |
| --------- | ----------- |
| StringValue | String expression that SHOULD contain at least one character. |

Runtime Semantics.

If the implemented uses 16-bit Unicode code points returns an Integer data value that is the 16-bit Unicode code point of the first character of StringValue.

If the implementation does not support Unicode, return the result of Asc(StringValue).

Code point values greater than 32,767 are returned as negative Integer data values.

If the argument is the null string ("") Error Number 5 ("Invalid procedure call or argument") is raised.

**6.1.2.11.1.4 Chr / Chr$**

Function Declaration

```
Function Chr(CharCode As Long) As Variant
Function Chr$(CharCode As Long) As String
```



| Parameter | Description |
| --------- | ----------- |
| CharCode | Long whose value is a code point. |

Runtime Semantics.

Returns a String data value consisting of a single character containing the character whose code point is the data value of the argument.

If the argument is not in the range 0 to 255, Error Number 5 ("Invalid procedure call or argument") is raised unless the implementation supports a character set with a larger code point range.

If the argument value is in the range of 0 to 127, it is interpreted as a 7-bit ASCII code point.

If the argument value is in the range of 128 to 255, the code point interpretation of the value is implementation defined.

Chr$ has the same runtime semantics as Chr, however the declared type of its function result is String rather than Variant.

**6.1.2.11.1.5 ChrB / ChrB$**

Function Declaration

```
Function ChrB(CharCode As Long) As Variant
Function ChrB$(CharCode As Long) As String
```



| Parameter | Description |
| --------- | ----------- |
| CharCode | Long whose value is a code point. |

Runtime Semantics.

Returns a String data value consisting of a single byte character whose code point value is the data value of the argument.

If the argument is not in the range 0 to 255, Error Number 6 ("Overflow") is raised.

ChrB$ has the same runtime semantics as ChrB however the declared type of its function result is String rather than Variant.

Note: the ChrB function is used with byte data contained in a String. Instead of returning a character, which can be one or two bytes, ChrB returns a single byte. The ChrW function returns a String containing the Unicode character except on platforms where Unicode is not supported, in which case, the behavior is identical to the Chr function.

**6.1.2.11.1.6 ChrW/ ChrW$**

Function Declaration

```
Function ChrW(CharCode As Long) As Variant
Function ChrW$(CharCode As Long) As String
```



| Parameter | Description |
| --------- | ----------- |
| CharCode | Long whose value is a code point. |

Runtime Semantics.

Returns a String data value consisting of a single character containing the character whose code point is the data value of the argument.

If the argument is not in the range -32,767 to 65,535 then Error Number 5 ("Invalid procedure call or argument") is raised.

If the argument is a negative value it is treated as if it was the value: CharCode + 65,536.

If the implemented uses 16-bit Unicode code points argument, data value is interpreted as a 16-bit Unicode code point.

If the implementation does not support Unicode, ChrW has the same semantics as Chr.

ChrW$ has the same runtime semantics as ChrW, however the declared type of its function result is String rather than Variant.

**6.1.2.11.1.7 Filter**

Function Declaration

```
Function Filter(SourceArray() As Variant, Match As String,
Optional Include As Boolean = True, Optional Compare As
VbCompareMethod = vbBinaryCompare)
```



| Parameter | Description |
| --------- | ----------- |
| SourceArray | Variant containing one-dimensional array of strings to be searched. |
| Match | String to search for. |
| Include | Boolean value indicating whether to return substrings that include or exclude match. If include is True, Filter returns the subset of the array that contains match as a substring. If include is False, Filter returns the subset of the array that does not contain match as a substring. |
| Compare | Numeric value indicating the kind of string comparison to use. See the next table in this section for values. |


Runtime Semantics.

Returns a zero-based array containing subset of a string array based on a specified filter criteria.

The Compare argument can have the following values (if omitted, it uses the `<option-compare-directive>` of the calling module):


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbBinaryCompare | 0 | Performs a binary comparison. |
| vbTextCompare | 1 | Performs a textual comparison. |

If no matches of Match are found within SourceArray, Filter returns an empty array. An error occurs if SourceArray is the data value Null or is not a one-dimensional array.

The array returned by the Filter function contains only enough elements to contain the number of matched items.

**6.1.2.11.1.8 Format**

Function Declaration

```
Function Format(Expression As Variant, Optional Format As
Variant, Optional FirstDayOfWeek As VbDayOfWeek = vbSunday,
Optional FirstWeekOfYear As VbFirstWeekOfYear = vbFirstJan1)
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any valid expression. |
| Format | A valid named or user-defined format expression. |
| FirstDayOfWeek | A constant that specifies the first day of the week. |
| FirstWeekOfYear | A constant that specifies the first week of the year. |

Runtime Semantics.

Returns a String containing an expression formatted according to instructions contained in a format expression.

The FirstDayOfWeek argument has these settings:


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbUseSystem | 0 | Use NLS API setting. |
| VbSunday | 1 | Sunday (default) |
| vbMonday | 2 | Monday |
| vbTuesday | 3 | Tuesday |
| vbWednesday | 4 | Wednesday |
| vbThursday | 5 | Thursday |
| vbFriday | 6 | Friday |
| vbSaturday | 7 | Saturday |

The FirstWeekOfYear argument has these settings:


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbUseSystem | 0 | Use NLS API setting. |
| vbFirstJan1 | 1 | Start with week in which January 1 occurs (default). |
| vbFirstFourDays | 2 | Start with the first week that has at least four days in the year. |
| vbFirstFullWeek | 3 | Start with the first full week of the year. |

To determine how to format a certain type of data, see the following table:


| To Format | Do This |
| --------- | ------- |
| Numbers | Use predefined named numeric formats or create user-defined numeric formats. |
| Dates and times | Use predefined named date/time formats or create user-defined date/time formats. |
| Date and time serial numbers | Use date and time formats or numeric formats. |
| Strings | Create a user-defined string format. |


If you try to format a number without specifying Format, Format provides functionality similar to the Str function, although it is internationally aware. However, positive numbers formatted as strings using Format do not include a leading space reserved for the sign of the value; those converted using Str retain the leading space.

When formatting a non-localized numeric string, use a user-defined numeric format to ensure that it gets formatted correctly.

Note: if the Calendar property setting is Gregorian and format specifies date formatting, the supplied expression MUST be Gregorian. If the Visual Basic Calendar property setting is Hijri, the supplied expression MUST be Hijri.

If the calendar is Gregorian, the meaning of format expression symbols is unchanged. If the calendar is Hijri, all date format symbols (for example, dddd, mmmm, yyyy) have the same meaning but apply to the Hijri calendar. Format symbols remain in English; symbols that result in text display (for example, AM and PM) display the string (English or Arabic) associated with that symbol. The range of certain symbols changes when the calendar is Hijri.


| Symbol | Range |
| ------ | ----- |
| d | 1-30 |
| dd | 1-30 |
| ww | 1-51 |
| mmm | Displays full month names (Hijri month names have no abbreviations). |
| y | 1-355 |
| yyyy | 100-9666 |


**6.1.2.11.1.9 Format$**

This function is functionally identical to the Format function, with the exception that the return type of the function is String rather than Variant.

**6.1.2.11.1.10 FormatCurrency**

Function Declaration

```
Function FormatCurrency(Expression As Variant, Optional
NumDigitsAfterDecimal As Long = -1, Optional
IncludeLeadingDigit As VbTriState = vbUseDefault, Optional
UseParensForNegativeNumbers As VbTriState = vbUseDefault,
Optional GroupDigits As VbTriState = vbUseDefault) As
String
```


| Parameter | Description |
| --------- | ----------- |
| Expression | Variant containing the expression to be formatted. |
| NumDigitsAfterDecimal | Numeric value indicating how many places to the right of the decimal are displayed. Default value is 1, which indicates that the computer's regional settings are used. |
| IncludeLeadingDigit | Tristate constant that indicates whether or not a leading zero is displayed for fractional values. See the next table in this section for values. |
| UseParensForNegativeNumbers | Tristate constant that indicates whether or not to place negative values within parentheses. See the next table in this section for values. |
| GroupDigits | Tristate constant that indicates whether or not numbers are grouped using the group delimiter specified in the computer's regional settings. See the next table in this section for values. |


Runtime Semantics.

Returns an expression formatted as a currency value using the implementation-defined currency symbol.

The IncludeLeadingDigit, UseParensForNegativeNumbers, and GroupDigits arguments have the following settings:


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbTrue | 1 | True |
| vbFalse | 0 | False |
| vbUseDefault | 2 | Implementation-defined value. |

Returns an expression formatted as a currency value using the implementation-defined currency symbol.

When one or more optional arguments are omitted, the values for omitted arguments are implementation-defined.

The position of the currency symbol relative to the currency value is implementation-defined.

**6.1.2.11.1.11 FormatDateTime**

Function Declaration

```
Function FormatDateTime(Expression As Variant, NamedFormat As VbDateTimeFormat = vbGeneralDate) As String
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Variant containing a Date expression to be formatted. |
| NamedFormat | Numeric value that indicates the date/time format used. If omitted, vbGeneralDate is used. |

Runtime Semantics.

Returns an expression formatted as a date or time.

The NamedFormat argument has the following settings:


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbGeneralDate | 0 | Display a date and/or time. If there is a date part, display it as a short date. If there is a time part, display it as a long time. If present, both parts are displayed. |
| vbLongDate | 1 | Display a date using the implementation-defined long date format. |
| vbShortDate | 2 | Display a date using the implementation-defined short date format. |
| vbLongTime | 3 | Display a time using the implementation-defined time format. |
| vbShortTime | 4 | Display a time using the 24-hour format (hh:mm). |


**6.1.2.11.1.12 FormatNumber**

Function Declaration

```
Function FormatNumber(Expression, Optional
NumDigitsAfterDecimal As Long = -1, Optional
IncludeLeadingDigit As VbTriState = vbUseDefault, Optional
UseParensForNegativeNumbers As VbTriState = vbUseDefault,
Optional GroupDigits As VbTriState = vbUseDefault) As String
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Variant containing the expression to be formatted. |
| NumDigitsAfterDecimal | Numeric value indicating how many places to the right of the decimal are displayed. Default value is 1, which indicates that implementation-defined settings are used. |
| IncludeLeadingDigit | Tristate constant that indicates whether or not a leading zero is displayed for fractional values. See the next table in this section for values. |
| UseParensForNegativeNumbers | Tristate constant that indicates whether or not to place negative values within parentheses. See the next table in this section for values. |
| GroupDigits | Tristate constant that indicates whether or not numbers are grouped using the implementation-defined group delimiter. See the next table in this section for values. |

Runtime Semantics.

Returns an expression formatted as a number.

The IncludeLeadingDigit, UseParensForNegativeNumbers, and GroupDigits arguments have the following settings:


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbTrue | 1 | True |
| vbFalse | 0 | False |
| vbUseDefault | 2 | Implementation-defined value. |

Returns an expression formatted as a number.

When one or more optional arguments are omitted, the values for omitted arguments are provided by the computer's regional settings.

**6.1.2.11.1.13 FormatPercent**

Function Declaration

```
Function FormatPercent(Expression, Optional
NumDigitsAfterDecimal As Long = -1, Optional
IncludeLeadingDigit As VbTriState = vbUseDefault, Optional
UseParensForNegativeNumbers As VbTriState = vbUseDefault,
Optional GroupDigits As VbTriState = vbUseDefault) As String
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Variant containing the expression to be formatted. |
| NumDigitsAfterDecimal | Numeric value indicating how many places to the right of the decimal are displayed. Default value is 1, which indicates that implementation-defined settings are used. |
| IncludeLeadingDigit | Tristate constant that indicates whether or not a leading zero is displayed for fractional values. See the next table in this section for values. |
| UseParensForNegativeNumbers | Tristate constant that indicates whether or not to place negative values within parentheses. See the next table in this section for values. |
| GroupDigits | Tristate constant that indicates whether or not numbers are grouped using the implementation-defined group delimiter. See the next table in this section for values. |

Runtime Semantics.

Returns an expression formatted as a percentage (multiplied by 100) with a trailing % character.

The IncludeLeadingDigit, UseParensForNegativeNumbers, and GroupDigits arguments have the following settings:


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbTrue | 1 | True |
| vbFalse | 0 | False |
| vbUseDefault | 2 | Use the setting from the computer's regional settings. |

When one or more optional arguments are omitted, the values for omitted arguments are implementation-defined.

**6.1.2.11.1.14 InStr / InStrB**

Function Declaration

```
Function InStr(Optional Arg1 As Variant, Optional Arg2 As
Variant, Optional Arg3 As Variant, Optional Compare As
VbCompareMethod = vbBinaryCompare)
```

If Arg3 is not present then Arg1 is used as the string to be searched, and Arg2 is used as the pattern (and the start position is 1). If Arg3 IS present then Arg1 is used as a string and Arg2 is used as the pattern.


| Parameter | Description |
| --------- | ----------- |
| Arg1 | Numeric expression that sets the starting position for each search. If omitted, search begins at the first character position. If start contains the data value Null, an error occurs. This argument is required if Compare is specified. |
| Arg2 | String expression to search. |
| Arg3 | String expression sought. |
| Compare | Specifies the type of string comparison. If compare is the data value Null, an error occurs. If Compare is omitted, the Option Compare setting determines the type of comparison. Specify a valid LCID (LocaleID) to use locale-specific rules in the comparison. |

Runtime Semantics.

Returns a Long specifying the position of the first occurrence of one string within another.

The Compare argument can have the following values (if omitted, it uses the `<option-compare-directive>` of the calling module):


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbBinaryCompare | 0 | Performs a binary comparison. |
| vbTextCompare | 1 | Performs a textual comparison. |

InStr returns the following values:


| If | InStr returns |
| --- | ------------- |
| Arg2 is zero-length | 0 |
| Arg2 is Null | Null |
| Arg3 is zero-length | Arg1 |
| Arg3 is Null | Null |
| Arg3 is not found | 0 |
| Arg3 is found within Arg2 | Position at which match is found |
| Arg1 > Arg3 | 0 |

The InStrB function is used with byte data contained in a string. Instead of returning the character position of the first occurrence of one string within another, InStrB returns the byte position.

**6.1.2.11.1.15 InStrRev**

Function Declaration

```
Function InStrRev(StringCheck As String, StringMatch As
String, Optional Start As Long = -1, Optional Compare As VbCompareMethod = vbBinaryCompare) As Long
```



| Parameter | Description |
| --------- | ----------- |
| StringCheck | String expression to search. |
| StringMatch | String expression being searched for. |
| Start | Long containing a numeric expression that sets the starting position for each search. If omitted, the data value 1 is used, which means that the search begins at the last character position. If Start contains the data value Null, an error occurs. |
| Compare | Numeric value indicating the kind of comparison to use when evaluating substrings. If omitted, a binary comparison is performed. See the next table in this section for values. |

Runtime Semantics.

Returns the position of an occurrence of one string within another, from the end of string.

The Compare argument can have the following values (if omitted, it uses the `<option-compare-directive>` of the calling module):


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbBinaryCompare | 0 | Performs a binary comparison. |
| vbTextCompare | 1 | Performs a textual comparison. |

InStrRev returns the following values:


| If | InStrRev returns |
| --- | ---------------- |
| StringCheck is zero-length | 0 |
| StringCheck is Null | Null |
| StringMatch is zero-length | Start |
| StringMatch is Null | Null |
| StringMatch is not found | 0 |
| StringMatch is found within StringCheck | Position at which match is found |
| Start > Len(StringMatch) | 0 |


**6.1.2.11.1.16 Join**

Function Declaration

```
Function Join(SourceArray() As Variant, Optional Delimiter As Variant) As String
```



| Parameter | Description |
| --------- | ----------- |
| SourceArray | Variant containing one-dimensional array containing substrings to be joined. |
| Delimiter | String character used to separate the substrings in the returned string. If omitted, the space character (" ") is used. If Delimiter is a zero-length string (""), all items in the list are concatenated with no delimiters. |

Runtime Semantics.

Returns a string created by joining a number of substrings contained in an array.

**6.1.2.11.1.17 LCase**

Function Declaration

```
Function LCase(String As Variant)
```



| Parameter | Description |
| --------- | ----------- |
| String | Variant containing any valid String expression. If String contains the data value Null, Null is returned. |

Runtime Semantics.

Returns a String that has been converted to lowercase.

Only uppercase letters are converted to lowercase; all lowercase letters and non-letter characters remain unchanged.

**6.1.2.11.1.18 LCase$**

This function is functionally identical to the LCase function, with the exception that the return type of the function is String rather than Variant.

**6.1.2.11.1.19 Left / LeftB**

Function Declaration

```
Function Left(String, Length As Long)
```



| Parameter | Description |
| --------- | ----------- |
| String | String expression from which the leftmost characters are returned. If string contains Null, Null is returned. |
| Length | Long containing a Numeric expression indicating how many characters to return. If it equals the data value 0, a zero-length string ("") is returned. If it’s greater than or equal to the number of characters in String, the entire string is returned. |

Runtime Semantics.

Returns a String containing a specified number of characters from the left side of a string.

Note: use the LeftB function with byte data contained in a string. Instead of specifying the number of characters to return, length specifies the number of bytes.

**6.1.2.11.1.20 Left$**

This function is functionally identical to the Left function, with the exception that the return type of the function is String rather than Variant.

**6.1.2.11.1.21 LeftB$**

This function is functionally identical to the LeftB function, with the exception that the return type of the function is String rather than Variant.

**6.1.2.11.1.22 Len / LenB**

Function Declaration

```
Function Len(Expression As Variant) As Variant
Function LenB(Expression As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Expression | Any valid string expression, or any valid variable name. If the variable name is a Variant, Len/LenB treats it the same as a String and always returns the number of characters it contains. |

Runtime Semantics.

- Returns a Long containing the number of characters in a string or the number of bytes required to store a variable on the current platform.
- If Expression contains the data value Null, Null is returned.
- With user-defined types, Len returns the size as it will be written to the file.
- LenB will return the same value as Len, except for strings or UDTs:
- LenB can return different values than Len for Unicode strings or double-byte character set (DBCS) representations. Instead of returning the number of characters in a string, LenB returns the number of bytes used to represent that string.
- With user-defined types, LenB returns the in-memory size, including any implementation-specific padding between elements.
- Note: Len might not be able to determine the actual number of storage bytes required when used with variable-length strings in user-defined data types.
**6.1.2.11.1.23 LTrim / RTrim / Trim**

Function Declaration

```
Function LTrim(String As Variant) As Variant
Function RTrim(String As Variant) As Variant
Function Trim(String As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| String | Variant, containing any valid String expression. |

Runtime Semantics.

Returns a String containing a copy of a specified string without leading spaces (LTrim), trailing spaces (RTrim), or both leading and trailing spaces (Trim).

If String contains the data value Null, Null is returned.

**6.1.2.11.1.24 LTrim$ / RTrim$ / Trim$**

These functions are functionally identical to the LTrim, RTrim, and Trim functions respectively, with the exception that the return type of these functions is String rather than Variant.

**6.1.2.11.1.25 Mid / MidB**

Function Declaration

```
Function Mid(String As Variant, Start As Long, Optional
Length As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| String | String expression from which characters are returned. If String contains the data value Null, Null is returned. |
| Start | Long containing the character position in String at which the part to be taken begins. If Start is greater than the number of characters in String, Mid returns a zero-length string (""). |
| Length | Long containing the number of characters to return. If omitted or if there are fewer than Length characters in the text (including the character at start), all characters from the start position to the end of the string are returned. |

Runtime Semantics.

Returns a String containing a specified number of characters from a string.

To determine the number of characters in String, use the Len function.

Note: use the MidB function with byte data contained in a string, as in double-byte character set languages. Instead of specifying the number of characters, the arguments specify numbers of bytes.

**6.1.2.11.1.26 Mid$**

This function is functionally identical to the Mid function, with the exception that the return type of the function is String rather than Variant.

**6.1.2.11.1.27 MidB$**

This function is functionally identical to the MidB function, with the exception that the return type of the function is String rather than Variant.

**6.1.2.11.1.28 MonthName**

Function Declaration

```
Function MonthName(Month As Long, Optional Abbreviate As Boolean = False) As String
```


| Parameter | Description |
| --------- | ----------- |
| Month | Long containing the numeric designation of the month. For example, January is 1, February is 2, and so on. |
| Abbreviate | Boolean value that indicates if the month name is to be abbreviated. If omitted, the default is False, which means that the month name is not abbreviated. |

Runtime Semantics.

Returns a String indicating the specified month.

**6.1.2.11.1.29 Replace**

Function Declaration

```
Function Replace(Expression As String, Find As String,
Replace As String, Optional Start As Long = 1, Optional Count As Long = -1, Optional Compare As VbCompareMethod = vbBinaryCompare) As String
```



| Parameter | Description |
| --------- | ----------- |
| Expression | String expression containing substring to replace. |
| Find | Substring being searched for. |
| Replace | Replacement substring. |
| Start | Position within expression where substring search is to begin. If omitted, the data value 1 is assumed. |
| Count | Number of substring substitutions to perform. If omitted, the default value is the data value 1, which means make all possible substitutions. |
| Compare | Numeric value indicating the kind of comparison to use when evaluating substrings. See the next table in this section for values. |

Runtime Semantics.

Returns a String in which a specified substring has been replaced with another substring a specified number of times.

The Compare argument can have the following values (if omitted, it uses the `<option-compare-directive>` of the calling module):


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbBinaryCompare | 0 | Performs a binary comparison. |
| vbTextCompare | 1 | Performs a textual comparison. |


Replace returns the following values:


| If | Replace returns |
| --- | --------------- |
| Expression is zero-length | Zero-length string ("") |
| Expression is Null | An error. |
| Find is zero-length | Copy of Expression. |
| Replace is zero-length | Copy of Expression with all occurrences of Find removed. |
| Start > Len(Expression) | Zero-length string. |
| Count is 0 | Copy of Expression. |

The return value of the Replace function is a String, with substitutions made, that begins at the position specified by Start and concludes at the end of the Expression string. It is not a copy of the original string from start to finish.

**6.1.2.11.1.30 Right / RightB**

Function Declaration

```
Function Right(String, Length As Long)
```



| Parameter | Description |
| --------- | ----------- |
| String | String expression from which the rightmost characters are returned. If string contains the data value Null, Null is returned. |
| Length | Long containing the numeric expression indicating how many characters to return. If it equals the data value 0, a zero-length string ("") is returned. If it is greater than or equal to the number of characters in String, the entire string is returned. |

Runtime Semantics.

Returns a String containing a specified number of characters from the right side of a string.

To determine the number of characters in string, use the Len function.

Note: use the RightB function with byte data contained in a String. Instead of specifying the number of characters to return, length specifies the number of bytes.

**6.1.2.11.1.31 Right$**

This function is functionally identical to the Right function, with the exception that the return type of the function is String rather than Variant.

**6.1.2.11.1.32 RightB$**

This function is functionally identical to the RightB function, with the exception that the return type of the function is String rather than Variant.

**6.1.2.11.1.33 Space**

Function Declaration

```
Function Space(Number As Long) As Variant
```


| Parameter | Description |
| --------- | ----------- |
| Number | Long containing the number of spaces in the String. |

Runtime Semantics.

Returns a String consisting of the specified number of spaces.

The Space function is useful for formatting output and clearing data in fixed-length strings.

**6.1.2.11.1.34 Space$**

This function is functionally identical to the Space function, with the exception that the return type of the function is String rather than Variant.

**6.1.2.11.1.35 Split**

Function Declaration

```
Function Split(Expression As String, Optional Delimiter As
Variant, Optional Limit As Long = -1, Optional Compare As VbCompareMethod = vbBinaryCompare)
```



| Parameter | Description |
| --------- | ----------- |
| Expression | String expression containing substrings and delimiters. If expression is a zero-length string(""), Split returns an empty array, that is, an array with no elements and no data. |
| Delimiter | String containing the character used to identify substring limits. If omitted, the space character (" ") is assumed to be the delimiter. If delimiter is a zero-length string, a single-element array containing the entire expression string is returned. |
| Limit | Number of substrings to be returned; the data value 1 indicates that all substrings are returned. |
| Compare | Numeric value indicating the kind of comparison to use when evaluating substrings. See the next table in this section for values. |

Runtime Semantics.

Returns a zero-based, one-dimensional array containing a specified number of substrings.

The Compare argument can have the following values (if omitted, it uses the `<option-compare-directive>` of the calling module):


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbBinaryCompare | 0 | Performs a binary comparison. |
| vbTextCompare | 1 | Performs a textual comparison. |


**6.1.2.11.1.36 StrComp**

Function Declaration

```
Function StrComp(String1 As Variant, String2 As Variant,
Optional Compare As VbCompareMethod = vbBinaryCompare)
```



| Parameter | Description |
| --------- | ----------- |
| String1 | Any valid String expression. |
| String2 | Any valid String expression. |
| Compare | Specifies the type of string comparison. If the Compare argument is the data value Null, an error occurs. |

Runtime Semantics.

Returns an Integer indicating the result of a string comparison.

The Compare argument can have the following values (if omitted, it uses the `<option-compare-directive>` of the calling module):


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbBinaryCompare | 0 | Performs a binary comparison. |
| vbTextCompare | 1 | Performs a textual comparison. |

The StrComp function has the following return values:


| If | StrComp returns |
| --- | --------------- |
| String1 is less than String2 | -1 |
| String1 is equal to String2 | 0 |
| String1 is greater than String2 | 1 |
| String1 or String2 is Null | Null |


**6.1.2.11.1.37 StrConv**

Function Declaration

```
Function StrConv(String As Variant, Conversion As VbStrConv, LocaleID As Long) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| String | String containing the expression to be converted. |
| Conversion | Integer containing the sum of values specifying the type of conversion to perform. |
| LCID | The LocaleID, if different than the default implementation-defined LocaleID. |

Runtime Semantics.

Returns a String converted as specified.

The Conversion argument settings are:


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbUpperCase | 1 | Converts the string to uppercase characters. |
| vbLowerCase | 2 | Converts the string to lowercase characters. |
| vbProperCase | 3 | Converts the first letter of every word in string to uppercase. |
| vbWide* | 4* | Converts narrow (single-byte) characters in string to wide (double-byte) characters. |
| vbNarrow* | 8* | Converts wide (double-byte) characters in string to narrow (single-byte) characters. |
| vbKatakana** | 16** | Converts Hiragana characters in string to Katakana characters. |
| vbHiragana** | 32** | Converts Katakana characters in string to Hiragana characters. |
| vbUnicode | 64 | Converts the string to Unicode using the default code page of the system. |
| vbFromUnicode | 128 | Converts the string from Unicode to the default code page of the system. |

*Applies to East Asia locales.

**Applies to Japan only.

Note: these constants are specified by VBA, and as a result, they can be used anywhere in code in place of the actual values. Most can be combined, for example, vbUpperCase + vbWide, except when they are mutually exclusive, for example, vbUnicode + vbFromUnicode. The constants vbWide, vbNarrow, vbKatakana, and vbHiragana cause run-time errors when used in locales where they do not apply.

The following are valid word separators for proper casing: Null (Chr$(0)), horizontal tab

(Chr$(9)), linefeed (Chr$(10)), vertical tab (Chr$(11)), form feed (Chr$(12)), carriage return (Chr$(13)), space (SBCS) (Chr$(32)). The actual value for a space varies by country/region for DBCS.

When converting from a Byte array in ANSI format to a String, use the StrConv function. When converting from such an array in Unicode format, use an assignment statement.

**6.1.2.11.1.38 String**

Function Declaration

```
Function String(Number As Long, Character As Variant) As
Variant
```



| Parameter | Description |
| --------- | ----------- |
| Number | Long specifying the length of the returned string. If number contains the data value Null, Null is returned. |
| Character | Variant containing the character code specifying the character or string expression whose first character is used to build the return string. If character contains Null, Null is returned. |

Runtime Semantics.

Returns a String containing a repeating character string of the length specified.

If Character is a number greater than 255, String converts the number to a valid character code using the formula: character Mod 256

**6.1.2.11.1.39 String$**

This function is functionally identical to the String function, with the exception that the return type of the function is String rather than Variant.

**6.1.2.11.1.40 StrReverse**

Function Declaration

```
Function StrReverse(Expression As String) As String
```



| Parameter | Description |
| --------- | ----------- |
| Expression | String whose characters are to be reversed. |

Runtime Semantics.

Returns a String in which the character order of a specified String is reversed.

If Expression is a zero-length string (""), a zero-length string is returned. If Expression is Null, an error occurs.

**6.1.2.11.1.41 UCase**

Function Declaration

```
Function UCase(String As Variant)
```



| Parameter | Description |
| --------- | ----------- |
| String | Variant containing any valid String expression. If String contains the data value Null, Null is returned. |

Runtime Semantics.

Returns a String that has been converted to uppercase.

Only lowercase letters are converted to uppercase; all uppercase letters and non-letter characters remain unchanged.

**6.1.2.11.1.42 UCase$**

This function is functionally identical to the UCase function, with the exception that the return type of the function is String rather than Variant.

**6.1.2.11.1.43 WeekdayName**

Function Declaration

```
Function WeekdayName(Weekday As Long, Optional Abbreviate
As Boolean = False, Optional FirstDayOfWeek As VbDayOfWeek
= vbUseSystemDayOfWeek) As String
```



| Parameter | Description |
| --------- | ----------- |
| Weekday | Long containing the numeric designation for the day of the week. Numeric value of each day depends on setting of the FirstDayOfWeek setting. |
| Abbreviate | Boolean value that indicates if the weekday name is to be abbreviated. If omitted, the default is False, which means that the weekday name is not abbreviated. |
| FirstDayOfWeek | Numeric value indicating the first day of the week. See the next table in this section for values. |

Runtime Semantics.

Returns a String indicating the specified day of the week.

The FirstDayOfWeek argument can have the following values:


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbUseSystem | 0 | Use National Language Support (NLS) API setting. |
| vbSunday | 1 | Sunday (default) |
| vbMonday | 2 | Monday |
| vbTuesday | 3 | Tuesday |
| vbWednesday | 4 | Wednesday |
| vbThursday | 5 | Thursday |
| vbFriday | 6 | Friday |
| vbSaturday | 7 | Saturday |


##### 6.1.2.12 SystemColorConstants

Whenever their values are used in contexts expecting a color value, these system color constants SHOULD be interpreted as their specified implementation-dependent colors.


| Constant | Value | Description |
| -------- | ----- | ----------- |
| vbScrollBars | &H80000000 | Scroll bar color |
| vbDesktop | &H80000001 | Desktop color |
| vbActiveTitleBar | &H80000002 | Color of the title bar for the active window |
| vbInactiveTitleBar | &H80000003 | Color of the title bar for the inactive window |
| vbMenuBar | &H80000004 | Menu background color |
| vbWindowBackground | &H80000005 | Window background color |
| vbWindowFrame | &H80000006 | Window frame color |
| vbMenuText | &H80000007 | Color of text on menus |
| vbWindowText | &H80000008 | Color of text in windows |
| vbTitleBarText | &H80000009 | Color of text in caption, size box, and scroll arrow |
| vbActiveBorder | &H8000000A | Border color of active window |
| vbInactiveBorder | &H8000000B | Border color of inactive window |
| vbApplicationWorkspace | &H8000000C | Background color of multiple-document interface (MDI) applications |
| vbHighlight | &H8000000D | Background color of items selected in a control |
| vbHighlightText | &H8000000E | Text color of items selected in a control |
| vbButtonFace | &H8000000F | Color of shading on the face of command buttons |
| vbButtonShadow | &H80000010 | Color of shading on the edge of command buttons |
| vbGrayText | &H80000011 | Grayed (disabled) text |
| vbButtonText | &H80000012 | Text color on push buttons |
| vbInactiveCaptionText | &H80000013 | Color of text in an inactive caption |
| vb3DHighlight | &H80000014 | Highlight color for 3D display elements |
| vb3DDKShadow | &H80000015 | Darkest shadow color for 3D display elements |
| vb3DLight | &H80000016 | Second lightest of the 3D colors after vb3Dhighlight |
| vb3DFace | &H8000000F | Color of text face |
| vb3Dshadow | &H80000010 | Color of text shadow |
| vbInfoText | &H80000017 | Color of text in ToolTips |
| vbInfoBackground | &H80000018 | Background color of ToolTips |


#### 6.1.3 Predefined Class Modules

##### 6.1.3.1 Collection Object

The Collection class defines the behavior of a collection, which represents a sequence of values.

###### 6.1.3.1.1 Public Functions

**6.1.3.1.1.1 Count**

Function Declaration

```
Function Count() As Long
```

Runtime Semantics.

Returns the number of objects in a collection.

**6.1.3.1.1.2 Item**

Function Declaration

```
Function Item(Index As Variant) As Variant
```



| Parameter | Description |
| --------- | ----------- |
| Index | An expression that specifies the position of a member of the collection. If a numeric expression, Index MUST be a number from 1 to the value of the collection's Count property. If a string expression, Index MUST correspond to the Key argument specified when the member referred to was added to the collection. |

Runtime Semantics.

Returns a specific member of a Collection object either by position or by key.

If the value provided as Index does not match any existing member of the collection, an error occurs.

The Item method is the default method for a collection. Therefore, the following lines of code are equivalent:

Print MyCollection(1)

Print MyCollection.Item(1)

###### 6.1.3.1.2 Public Subroutines

**6.1.3.1.2.1 Add**

Function Declaration

```
Sub Add(Item As Variant, Optional Key As Variant, Optional Before As Variant, Optional After As Variant)
```


| Parameter | Description |
| --------- | ----------- |
| Item | An expression of any type that specifies the member to add to the collection. |
| Key | A unique String expression that specifies a key string that can be used, instead of a positional index, to access a member of the collection. |
| Before | An expression that specifies a relative position in the collection. The member to be added is placed in the collection before the member identified by the before argument. If a numeric expression, before MUST be a number from 1 to the value of the collection's Count property. If a String expression, before MUST correspond to the key specified when the member being referred to was added to the collection. Either a Before position or an After position can be specified, but not both. |
| After | An expression that specifies a relative position in the collection. The member to be added is placed in the collection after the member identified by the After argument. If numeric, After MUST be a number from 1 to the value of the collection's Count property. If a String, After MUST correspond to the Key specified when the member referred to was added to the collection. Either a Before position or an After position can be specified, but not both. |

Runtime Semantics.

Adds a member to a Collection object.

Whether the before or after argument is a string expression or numeric expression, it MUST refer to an existing member of the collection, or an error occurs.

An error also occurs if a specified Key duplicates the key for an existing member of the collection.

An implementation can define a maximum number of elements that a Collection object can contain.

**6.1.3.1.2.2 Remove**

Function Declaration

```
Sub Remove(Index As Variant)
```


| Parameter | Description |
| --------- | ----------- |
| Index | An expression that specifies the position of a member of the collection. If a numeric expression, Index MUST be a number from 1 to the value of the collection's Count property. If a String expression, Index MUST correspond to the Key argument specified when the member referred to was added to the collection. |

Runtime Semantics.

Removes a member from a Collection object.

If the value provided as Index doesn’t match an existing member of the collection, an error occurs.

##### 6.1.3.2 Err Class

The Err Class defines the behavior of its sole instance, known as the Err object. The Err object’s properties and methods reflect and control the error state of the active VBA Environment and can be accessed inside any procedure. The Err Class is a global class module (section 5.2.4.1.2) with a default instance variable (section 5.2.4.1.2) so its sole instance can be directly referenced using the name Err.

###### 6.1.3.2.1 Public Subroutines

**6.1.3.2.1.1 Clear**

Function Declaration

```
Sub Clear()
```

Runtime Semantics.

- Clears all property settings of the Err object.
- The Clear method is called automatically whenever any of the following statements is executed:
- Resume statement (section 5.4.4.2)
- Exit Sub (section 5.4.2.17)
- Exit Function (section 5.4.2.18)
- Exit Property (section 5.4.2.19)
- On Error statement (section 5.4.4.1)
**6.1.3.2.1.2 Raise**

Function Declaration

```
Sub Raise(Number As Long, Optional Source As Variant,
Optional Description As Variant, Optional HelpFile As Variant, Optional HelpContext As Variant)
```


| Parameter | Description |
| --------- | ----------- |
| Number | Long that identifies the nature of the error. VBA errors (both VBA-defined and user-defined errors) are in the range 0-65535. The range 0-512 is reserved for system errors; the range 513-65535 is available for user-defined errors. When setting the Number property to a custom error code in a class module, add the error code number to the vbObjectError constant. For example, to generate the error number 513, assign vbObjectError + 513 to the Number property. |
| Source | String expression naming the object or application that generated the error. When setting this property for an object, use the form project.class. If Source is not specified, current project name (section 4.1) is used. |
| Description | String expression describing the error. If unspecified, the value in Number is examined. If it can be mapped to a VBA run-time error code, the String that would be returned by the Error function is used as Description. If there is no VBA error corresponding to Number, the "Application-defined or object-defined error" message is used. |
| HelpFile | The fully qualified path to the Help file in which help on this error can be found. If unspecified, this value is implementation-defined. |
| HelpContext | The context ID identifying a topic within HelpFile that provides help for the error. If omitted, this value is implementation-defined. |

Runtime Semantics.

Generates a run-time error.

If Raise is invoked without specifying some arguments, and the property settings of the Err object contain values that have not been cleared, those values serve as the values for the new error.

Raise is used for generating run-time errors and can be used instead of the Error statement (section 5.4.4.3). Raise is useful for generating errors when writing class modules, because the Err object gives richer information than possible when generating errors with the Error statement. For example, with the Raise method, the source that generated the error can be specified in the Source property, online Help for the error can be referenced, and so on.

###### 6.1.3.2.2 Public Properties

**6.1.3.2.2.1 Description**

**6.1.3.2.2.2 HelpContext**

```
Property HelpContext As Long
```

Runtime Semantics.

Returns or sets a String expression containing the context ID for a topic in a Help file.

The HelpContext property is used to automatically display the Help topic specified in the HelpFile property. If both HelpFile and HelpContext are empty, the value of Number is checked. If Number corresponds to a VBA run-time error value, then the implementation-defined VBA Help context ID for the error is used. If the Number value doesn’t correspond to a VBA error, an implementation-defined Help screen is displayed.

**6.1.3.2.2.3 HelpFile**

```
Property HelpFile As String
```

Runtime Semantics.

Returns or sets a String expression containing the fully qualified path to a Help file.

If a Help file is specified in HelpFile, it is automatically called when the user presses the Help button (or the F1 KEY) in the error message dialog box. If the HelpContext property contains a valid context ID for the specified file, that topic is automatically displayed. If no HelpFile is specified, an implementation-defined Help file is displayed.

**6.1.3.2.2.4 LastDIIError**

```
Property LastDllError As Long
```

Runtime Semantics.

Returns a system error code produced by a call to a dynamic-link library (DLL). This value is read-only.

The LastDLLError property applies only to DLL calls made from VBA code. When such a call is made, the called function usually returns a code indicating success or failure, and the LastDLLError property is filled. Check the documentation for the DLL's functions to determine the return values that indicate success or failure. Whenever the failure code is returned, the VBA application SHOULD immediately check the LastDLLError property. No error is raised when the LastDLLError property is set.

**6.1.3.2.2.5 Number**

```
Property Number As Long
```

Runtime Semantics.

Returns or sets a numeric value specifying an error. Number is the Err object's default property.

When returning a user-defined error from an object, set Err.Number by adding the number selected as an error code to the vbObjectError constant. For example, use the following code to return the number 1051 as an error code:

Err.Raise Number := vbObjectError + 1051, Source:= "SomeClass"

**6.1.3.2.2.6 Source**

```
Property Source As String
```

Runtime Semantics.

Returns or sets a String expression specifying the name of the object or application that originally generated the error.

This property has an implementation-defined default value for errors raised within VBA code.


##### 6.1.3.3 Global Class

###### 6.1.3.3.1 Public Subroutines

**6.1.3.3.1.1 Load**

Subroutine Declaration

```
Sub Load(Object As Object)
```

Runtime Semantics.

Loads a form or control into memory.

Using the Load statement with forms is unnecessary unless you want to load a form without displaying it. Any reference to a form (except in a Set or If...TypeOf statement) automatically loads it if it's not already loaded. For example, the Show method loads a form before displaying it. Once the form is loaded, its properties and controls can be altered by the application, whether or not the form is actually visible.

When VBA loads a Form object, it sets form properties to their initial values and then performs the Load event procedure. When an application starts, VBA automatically loads and displays the application's startup form.

When loading a Form whose MDIChild property is set to True (in other words, the child form) before loading an MDIForm, the MDIForm is automatically loaded before the child form. MDI child forms cannot be hidden, and thus are immediately visible after the Form_Load event procedure ends.

**6.1.3.3.1.2 Unload**

Unloads a form or control from memory.

Subroutine Declaration

```
Sub Unload(Object As Object)
```

Runtime Semantics.

Unloads a form or control into memory.

Unloading a form or control can be necessary or expedient in some cases where the memory used is needed for something else, or when there is a need to reset properties to their original values.

Before a form is unloaded, the Query_Unload event procedure occurs, followed by the Form_Unload event procedure. Setting the cancel argument to True in either of these events prevents the form from being unloaded. For MDIForm objects, the MDIForm object's Query_Unload event procedure occurs, followed by the Query_Unload event procedure and Form_Unload event procedure for each MDI child form, and finally the MDIForm object's Form_Unload event procedure.

When a form is unloaded, all controls placed on the form at run time are no longer accessible. Controls placed on the form at design time remain intact; however, any run-time changes to those controls and their properties are lost when the form is reloaded. All changes to form properties are also lost. Accessing any controls on the form causes it to be reloaded.

Note: when a form is unloaded, only the displayed component is unloaded. The code associated with the form module remains in memory.

Only control array elements added to a form at run time can be unloaded with the Unload statement. The properties of unloaded controls are reinitialized when the controls are reloaded.


---

*End of Section 6 Part 2 (Sections 6.1.2.6-6.1.3)*