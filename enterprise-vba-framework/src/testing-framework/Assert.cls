VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Assert"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
'@Folder("TestingFramework")
'@PredeclaredId
'@Description("Assertion class for unit testing")
Option Explicit

Implements IAssert

Private Const ASSERTION_FAILED As Long = vbObjectError + 9001

Private Sub IAssert_AreEqual(ByVal expected As Variant, ByVal actual As Variant, Optional ByVal message As String = vbNullString)
    If Not AreValuesEqual(expected, actual) Then
        Dim errorMsg As String
        errorMsg = "Expected: " & FormatValue(expected) & ", Actual: " & FormatValue(actual)
        If Len(message) > 0 Then
            errorMsg = message & " - " & errorMsg
        End If
        Err.Raise ASSERTION_FAILED, "Assert.AreEqual", errorMsg
    End If
End Sub

Private Sub IAssert_AreNotEqual(ByVal expected As Variant, ByVal actual As Variant, Optional ByVal message As String = vbNullString)
    If AreValuesEqual(expected, actual) Then
        Dim errorMsg As String
        errorMsg = "Values should not be equal: " & FormatValue(expected)
        If Len(message) > 0 Then
            errorMsg = message & " - " & errorMsg
        End If
        Err.Raise ASSERTION_FAILED, "Assert.AreNotEqual", errorMsg
    End If
End Sub

Private Sub IAssert_IsTrue(ByVal condition As Boolean, Optional ByVal message As String = vbNullString)
    If Not condition Then
        Dim errorMsg As String
        errorMsg = "Expected: True, Actual: False"
        If Len(message) > 0 Then
            errorMsg = message & " - " & errorMsg
        End If
        Err.Raise ASSERTION_FAILED, "Assert.IsTrue", errorMsg
    End If
End Sub

Private Sub IAssert_IsFalse(ByVal condition As Boolean, Optional ByVal message As String = vbNullString)
    If condition Then
        Dim errorMsg As String
        errorMsg = "Expected: False, Actual: True"
        If Len(message) > 0 Then
            errorMsg = message & " - " & errorMsg
        End If
        Err.Raise ASSERTION_FAILED, "Assert.IsFalse", errorMsg
    End If
End Sub

Private Sub IAssert_IsNothing(ByVal obj As Object, Optional ByVal message As String = vbNullString)
    If Not obj Is Nothing Then
        Dim errorMsg As String
        errorMsg = "Expected object to be Nothing"
        If Len(message) > 0 Then
            errorMsg = message & " - " & errorMsg
        End If
        Err.Raise ASSERTION_FAILED, "Assert.IsNothing", errorMsg
    End If
End Sub

Private Sub IAssert_IsNotNothing(ByVal obj As Object, Optional ByVal message As String = vbNullString)
    If obj Is Nothing Then
        Dim errorMsg As String
        errorMsg = "Expected object to not be Nothing"
        If Len(message) > 0 Then
            errorMsg = message & " - " & errorMsg
        End If
        Err.Raise ASSERTION_FAILED, "Assert.IsNotNothing", errorMsg
    End If
End Sub

Private Sub IAssert_IsGreaterThan(ByVal value As Variant, ByVal threshold As Variant, Optional ByVal message As String = vbNullString)
    If Not (CDbl(value) > CDbl(threshold)) Then
        Dim errorMsg As String
        errorMsg = FormatValue(value) & " is not greater than " & FormatValue(threshold)
        If Len(message) > 0 Then
            errorMsg = message & " - " & errorMsg
        End If
        Err.Raise ASSERTION_FAILED, "Assert.IsGreaterThan", errorMsg
    End If
End Sub

Private Sub IAssert_IsLessThan(ByVal value As Variant, ByVal threshold As Variant, Optional ByVal message As String = vbNullString)
    If Not (CDbl(value) < CDbl(threshold)) Then
        Dim errorMsg As String
        errorMsg = FormatValue(value) & " is not less than " & FormatValue(threshold)
        If Len(message) > 0 Then
            errorMsg = message & " - " & errorMsg
        End If
        Err.Raise ASSERTION_FAILED, "Assert.IsLessThan", errorMsg
    End If
End Sub

Private Sub IAssert_Contains(ByVal collection As Object, ByVal item As Variant, Optional ByVal message As String = vbNullString)
    Dim found As Boolean
    found = False
    
    If TypeName(collection) = "Collection" Then
        Dim element As Variant
        For Each element In collection
            If AreValuesEqual(element, item) Then
                found = True
                Exit For
            End If
        Next element
    End If
    
    If Not found Then
        Dim errorMsg As String
        errorMsg = "Collection does not contain: " & FormatValue(item)
        If Len(message) > 0 Then
            errorMsg = message & " - " & errorMsg
        End If
        Err.Raise ASSERTION_FAILED, "Assert.Contains", errorMsg
    End If
End Sub

Private Sub IAssert_Fail(ByVal message As String)
    Err.Raise ASSERTION_FAILED, "Assert.Fail", message
End Sub

' Helper methods
Private Function AreValuesEqual(ByVal value1 As Variant, ByVal value2 As Variant) As Boolean
    On Error Resume Next
    
    If IsObject(value1) Or IsObject(value2) Then
        If IsObject(value1) And IsObject(value2) Then
            AreValuesEqual = (value1 Is value2)
        Else
            AreValuesEqual = False
        End If
    Else
        AreValuesEqual = (value1 = value2)
    End If
    
    On Error GoTo 0
End Function

Private Function FormatValue(ByVal value As Variant) As String
    If IsObject(value) Then
        If value Is Nothing Then
            FormatValue = "Nothing"
        Else
            FormatValue = TypeName(value)
        End If
    ElseIf IsNull(value) Then
        FormatValue = "Null"
    ElseIf IsEmpty(value) Then
        FormatValue = "Empty"
    ElseIf VarType(value) = vbString Then
        FormatValue = """" & CStr(value) & """"
    Else
        FormatValue = CStr(value)
    End If
End Function
