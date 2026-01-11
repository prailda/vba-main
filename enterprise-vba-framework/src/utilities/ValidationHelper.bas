Attribute VB_Name = "ValidationHelper"
'@Folder("Utilities")
'@Description("Validation helper utilities")
Option Explicit

'@Description("Validates that a value is not empty")
Public Function ValidateRequired(ByVal value As Variant, ByVal fieldName As String) As Boolean
    If IsObject(value) Then
        If value Is Nothing Then
            Debug.Print "Validation failed: " & fieldName & " is required"
            ValidateRequired = False
            Exit Function
        End If
    ElseIf VarType(value) = vbString Then
        If Len(Trim$(CStr(value))) = 0 Then
            Debug.Print "Validation failed: " & fieldName & " cannot be empty"
            ValidateRequired = False
            Exit Function
        End If
    End If
    
    ValidateRequired = True
End Function

'@Description("Validates that a number is within a range")
Public Function ValidateRange(ByVal value As Variant, ByVal minValue As Variant, ByVal maxValue As Variant, ByVal fieldName As String) As Boolean
    If Not IsNumeric(value) Then
        Debug.Print "Validation failed: " & fieldName & " must be numeric"
        ValidateRange = False
        Exit Function
    End If
    
    Dim numValue As Double
    numValue = CDbl(value)
    
    If numValue < CDbl(minValue) Or numValue > CDbl(maxValue) Then
        Debug.Print "Validation failed: " & fieldName & " must be between " & minValue & " and " & maxValue
        ValidateRange = False
        Exit Function
    End If
    
    ValidateRange = True
End Function

'@Description("Validates email format")
Public Function ValidateEmail(ByVal email As String) As Boolean
    Dim regex As Object
    Set regex = CreateObject("VBScript.RegExp")
    
    regex.Pattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    regex.IgnoreCase = True
    
    ValidateEmail = regex.Test(email)
    
    If Not ValidateEmail Then
        Debug.Print "Validation failed: Invalid email format"
    End If
End Function

'@Description("Validates string length")
Public Function ValidateLength(ByVal value As String, ByVal minLength As Long, ByVal maxLength As Long, ByVal fieldName As String) As Boolean
    Dim length As Long
    length = Len(value)
    
    If length < minLength Or length > maxLength Then
        Debug.Print "Validation failed: " & fieldName & " length must be between " & minLength & " and " & maxLength
        ValidateLength = False
        Exit Function
    End If
    
    ValidateLength = True
End Function

'@Description("Validates that a value matches a pattern")
Public Function ValidatePattern(ByVal value As String, ByVal pattern As String, ByVal fieldName As String) As Boolean
    Dim regex As Object
    Set regex = CreateObject("VBScript.RegExp")
    
    regex.Pattern = pattern
    regex.IgnoreCase = False
    
    ValidatePattern = regex.Test(value)
    
    If Not ValidatePattern Then
        Debug.Print "Validation failed: " & fieldName & " does not match required pattern"
    End If
End Function

'@Description("Validates that a date is within a range")
Public Function ValidateDateRange(ByVal value As Date, ByVal minDate As Date, ByVal maxDate As Date, ByVal fieldName As String) As Boolean
    If value < minDate Or value > maxDate Then
        Debug.Print "Validation failed: " & fieldName & " must be between " & minDate & " and " & maxDate
        ValidateDateRange = False
        Exit Function
    End If
    
    ValidateDateRange = True
End Function

'@Description("Validates that a value is one of the allowed values")
Public Function ValidateAllowedValues(ByVal value As Variant, ByVal allowedValues As Variant, ByVal fieldName As String) As Boolean
    Dim allowedValue As Variant
    Dim found As Boolean
    found = False
    
    For Each allowedValue In allowedValues
        If value = allowedValue Then
            found = True
            Exit For
        End If
    Next allowedValue
    
    If Not found Then
        Debug.Print "Validation failed: " & fieldName & " must be one of the allowed values"
        ValidateAllowedValues = False
        Exit Function
    End If
    
    ValidateAllowedValues = True
End Function

'@Description("Validates URL format")
Public Function ValidateUrl(ByVal url As String) As Boolean
    Dim regex As Object
    Set regex = CreateObject("VBScript.RegExp")
    
    regex.Pattern = "^(http|https)://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(/.*)?$"
    regex.IgnoreCase = True
    
    ValidateUrl = regex.Test(url)
    
    If Not ValidateUrl Then
        Debug.Print "Validation failed: Invalid URL format"
    End If
End Function

'@Description("Validates phone number format")
Public Function ValidatePhoneNumber(ByVal phoneNumber As String) As Boolean
    ' Remove common separators
    Dim cleaned As String
    cleaned = phoneNumber
    cleaned = Replace(cleaned, "-", vbNullString)
    cleaned = Replace(cleaned, " ", vbNullString)
    cleaned = Replace(cleaned, "(", vbNullString)
    cleaned = Replace(cleaned, ")", vbNullString)
    cleaned = Replace(cleaned, "+", vbNullString)
    
    ' Check if remaining characters are numeric
    Dim i As Long
    For i = 1 To Len(cleaned)
        If Not IsNumeric(Mid$(cleaned, i, 1)) Then
            Debug.Print "Validation failed: Invalid phone number format"
            ValidatePhoneNumber = False
            Exit Function
        End If
    Next i
    
    ' Check length (typically 10-15 digits)
    If Len(cleaned) < 10 Or Len(cleaned) > 15 Then
        Debug.Print "Validation failed: Phone number must be 10-15 digits"
        ValidatePhoneNumber = False
        Exit Function
    End If
    
    ValidatePhoneNumber = True
End Function

'@Description("Creates a validation result object")
Public Function CreateValidationResult(ByVal isValid As Boolean, Optional ByVal errorMessage As String = vbNullString) As Object
    Dim result As Object
    Set result = CreateObject("Scripting.Dictionary")
    
    result("IsValid") = isValid
    result("ErrorMessage") = errorMessage
    
    Set CreateValidationResult = result
End Function
