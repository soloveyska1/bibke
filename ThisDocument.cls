VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisDocument"
Option Explicit

Private AE As AppEvents

Private Sub Document_Open()
    InitializeBiblio
End Sub

Private Sub Document_New()
    InitializeBiblio
End Sub

Private Sub InitializeBiblio()
    On Error GoTo ErrHandler
    BiblioInit
    SetupKeyBindings
    If AE Is Nothing Then
        Set AE = New AppEvents
        Set AE.App = Word.Application
    End If
    Exit Sub
ErrHandler:
    MsgBox "Инициализация библиографии: " & Err.Description, vbExclamation
End Sub
