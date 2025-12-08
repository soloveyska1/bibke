Attribute VB_Name = "BiblioUI"
Option Explicit

' =========================================================================
' User-facing commands, ribbon bindings, and hotkeys.
' =========================================================================

Public Sub CmdAddSource()
    Dim key As String
    key = InsertOrUpdateItem
    If Len(key) > 0 Then
        MsgBox "Источник сохранён с ключом " & key, vbInformation
    End If
End Sub

Public Sub CmdInsertCitation()
    frmBiblio.Show vbModal
End Sub

Public Sub CmdRefresh()
    RefreshAll
End Sub

Public Sub CmdAudit()
    BiblioAudit
End Sub

Public Sub CmdConvertPlain()
    ConvertPlainBracketsToREF
End Sub

Public Sub CmdSwitchAlphabet()
    SwitchOrderMode BIB_ORDER_MODE_ALPHA
End Sub

Public Sub CmdSwitchCitationOrder()
    SwitchOrderMode BIB_ORDER_MODE_CITE
End Sub

Public Sub CmdExport()
    ExportBibliography
End Sub

Public Sub CmdImport()
    ImportBibliography
End Sub

Public Sub CmdShowManager()
    frmBiblio.Show vbModeless
End Sub

Public Sub SetupKeyBindings()
    AddBinding wdKeyA, "CmdAddSource"
    AddBinding wdKeyR, "CmdInsertCitation"
    AddBinding wdKeyU, "CmdRefresh"
    AddBinding wdKeyL, "CmdAudit"
End Sub

Private Sub AddBinding(ByVal mainKey As Long, ByVal macroName As String)
    Dim binding As KeyBinding
    For Each binding In KeyBindings
        If binding.Command = macroName Then binding.Clear
    Next
    KeyBindings.Add KeyCategory:=wdKeyCategoryMacro, _
                    Command:=macroName, _
                    KeyCode:=BuildKeyCode(wdKeyControl, wdKeyShift, mainKey)
End Sub
