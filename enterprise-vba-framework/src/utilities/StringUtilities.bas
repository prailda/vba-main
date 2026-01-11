Attribute VB_Name = "StringUtilities"
'@Folder("Utilities")
'@Description("String manipulation utilities")
Option Explicit

'@Description("Checks if a string is null or empty")
Public Function IsNullOrEmpty(ByVal value As String) As Boolean
    IsNullOrEmpty = (Len(Trim$(value)) = 0)
End Function

'@Description("Checks if a string is null, empty, or whitespace")
Public Function IsNullOrWhiteSpace(ByVal value As String) As Boolean
    IsNullOrWhiteSpace = (Len(Trim$(value)) = 0)
End Function

'@Description("Formats a string with parameters")
Public Function Format(ByVal template As String, ParamArray args() As Variant) As String
    Dim result As String
    result = template
    
    Dim i As Long
    For i = LBound(args) To UBound(args)
        result = Replace(result, "{" & i & "}", CStr(args(i)))
    Next i
    
    Format = result
End Function

'@Description("Joins a collection of strings with a separator")
Public Function Join(ByVal items As Collection, ByVal separator As String) As String
    Dim result As String
    Dim item As Variant
    
    For Each item In items
        If Len(result) > 0 Then
            result = result & separator
        End If
        result = result & CStr(item)
    Next item
    
    Join = result
End Function

'@Description("Splits a string into an array")
Public Function Split(ByVal text As String, ByVal delimiter As String) As Variant
    Split = VBA.Strings.Split(text, delimiter)
End Function

'@Description("Pads a string to the left")
Public Function PadLeft(ByVal text As String, ByVal totalWidth As Long, Optional ByVal paddingChar As String = " ") As String
    If Len(text) >= totalWidth Then
        PadLeft = text
    Else
        PadLeft = String$(totalWidth - Len(text), paddingChar) & text
    End If
End Function

'@Description("Pads a string to the right")
Public Function PadRight(ByVal text As String, ByVal totalWidth As Long, Optional ByVal paddingChar As String = " ") As String
    If Len(text) >= totalWidth Then
        PadRight = text
    Else
        PadRight = text & String$(totalWidth - Len(text), paddingChar)
    End If
End Function

'@Description("Truncates a string to a maximum length")
Public Function Truncate(ByVal text As String, ByVal maxLength As Long, Optional ByVal suffix As String = "...") As String
    If Len(text) <= maxLength Then
        Truncate = text
    Else
        Truncate = Left$(text, maxLength - Len(suffix)) & suffix
    End If
End Function

'@Description("Converts a string to PascalCase")
Public Function ToPascalCase(ByVal text As String) As String
    Dim words() As String
    words = VBA.Strings.Split(LCase$(text), " ")
    
    Dim result As String
    Dim word As Variant
    For Each word In words
        If Len(CStr(word)) > 0 Then
            result = result & UCase$(Left$(CStr(word), 1)) & Mid$(CStr(word), 2)
        End If
    Next word
    
    ToPascalCase = result
End Function

'@Description("Converts a string to camelCase")
Public Function ToCamelCase(ByVal text As String) As String
    Dim pascal As String
    pascal = ToPascalCase(text)
    
    If Len(pascal) > 0 Then
        ToCamelCase = LCase$(Left$(pascal, 1)) & Mid$(pascal, 2)
    End If
End Function

'@Description("Removes all whitespace from a string")
Public Function RemoveWhitespace(ByVal text As String) As String
    RemoveWhitespace = Replace(text, " ", vbNullString)
    RemoveWhitespace = Replace(RemoveWhitespace, vbTab, vbNullString)
    RemoveWhitespace = Replace(RemoveWhitespace, vbCrLf, vbNullString)
    RemoveWhitespace = Replace(RemoveWhitespace, vbCr, vbNullString)
    RemoveWhitespace = Replace(RemoveWhitespace, vbLf, vbNullString)
End Function

'@Description("Repeats a string n times")
Public Function Repeat(ByVal text As String, ByVal count As Long) As String
    If count <= 0 Then
        Repeat = vbNullString
    ElseIf count = 1 Then
        Repeat = text
    Else
        Dim i As Long
        Dim result As String
        For i = 1 To count
            result = result & text
        Next i
        Repeat = result
    End If
End Function

'@Description("Reverses a string")
Public Function Reverse(ByVal text As String) As String
    Reverse = VBA.Strings.StrReverse(text)
End Function

'@Description("Checks if a string contains a substring")
Public Function Contains(ByVal text As String, ByVal substring As String, Optional ByVal ignoreCase As Boolean = False) As Boolean
    If ignoreCase Then
        Contains = InStr(1, text, substring, vbTextCompare) > 0
    Else
        Contains = InStr(1, text, substring, vbBinaryCompare) > 0
    End If
End Function

'@Description("Checks if a string starts with a prefix")
Public Function StartsWith(ByVal text As String, ByVal prefix As String, Optional ByVal ignoreCase As Boolean = False) As Boolean
    If ignoreCase Then
        StartsWith = (InStr(1, text, prefix, vbTextCompare) = 1)
    Else
        StartsWith = (InStr(1, text, prefix, vbBinaryCompare) = 1)
    End If
End Function

'@Description("Checks if a string ends with a suffix")
Public Function EndsWith(ByVal text As String, ByVal suffix As String, Optional ByVal ignoreCase As Boolean = False) As Boolean
    Dim textLen As Long
    Dim suffixLen As Long
    
    textLen = Len(text)
    suffixLen = Len(suffix)
    
    If suffixLen > textLen Then
        EndsWith = False
        Exit Function
    End If
    
    Dim textEnd As String
    textEnd = Right$(text, suffixLen)
    
    If ignoreCase Then
        EndsWith = (StrComp(textEnd, suffix, vbTextCompare) = 0)
    Else
        EndsWith = (StrComp(textEnd, suffix, vbBinaryCompare) = 0)
    End If
End Function
