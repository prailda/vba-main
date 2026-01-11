VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "IAssert"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'@Folder("TestingFramework")
'@Interface
'@Description("Assertion interface for unit testing")
Option Explicit

'@Description("Asserts that two values are equal")
Public Sub AreEqual(ByVal expected As Variant, ByVal actual As Variant, Optional ByVal message As String = vbNullString)
End Sub

'@Description("Asserts that two values are not equal")
Public Sub AreNotEqual(ByVal expected As Variant, ByVal actual As Variant, Optional ByVal message As String = vbNullString)
End Sub

'@Description("Asserts that a condition is true")
Public Sub IsTrue(ByVal condition As Boolean, Optional ByVal message As String = vbNullString)
End Sub

'@Description("Asserts that a condition is false")
Public Sub IsFalse(ByVal condition As Boolean, Optional ByVal message As String = vbNullString)
End Sub

'@Description("Asserts that an object is Nothing")
Public Sub IsNothing(ByVal obj As Object, Optional ByVal message As String = vbNullString)
End Sub

'@Description("Asserts that an object is not Nothing")
Public Sub IsNotNothing(ByVal obj As Object, Optional ByVal message As String = vbNullString)
End Sub

'@Description("Asserts that a value is greater than another")
Public Sub IsGreaterThan(ByVal value As Variant, ByVal threshold As Variant, Optional ByVal message As String = vbNullString)
End Sub

'@Description("Asserts that a value is less than another")
Public Sub IsLessThan(ByVal value As Variant, ByVal threshold As Variant, Optional ByVal message As String = vbNullString)
End Sub

'@Description("Asserts that a collection contains an item")
Public Sub Contains(ByVal collection As Object, ByVal item As Variant, Optional ByVal message As String = vbNullString)
End Sub

'@Description("Always fails the test")
Public Sub Fail(ByVal message As String)
End Sub
