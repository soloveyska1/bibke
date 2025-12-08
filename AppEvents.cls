VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "AppEvents"
Option Explicit

Public WithEvents App As Word.Application
Private pendingRefresh As Boolean
Private nextRun As Date

Private Sub App_DocumentOpen(ByVal Doc As Document)
    pendingRefresh = True
    ScheduleRefresh
End Sub

Private Sub App_DocumentBeforeSave(ByVal Doc As Document, SaveAsUI As Boolean, Cancel As Boolean)
    On Error Resume Next
    RefreshAll
End Sub

Private Sub App_WindowSelectionChange(ByVal Sel As Selection)
    pendingRefresh = True
    ScheduleRefresh
End Sub

Private Sub App_DocumentBeforeClose(ByVal Doc As Document, Cancel As Boolean)
    On Error Resume Next
    pendingRefresh = False
End Sub

Private Sub ScheduleRefresh()
    On Error GoTo ErrHandler
    If Not pendingRefresh Then Exit Sub
    If DateDiff("s", nextRun, Now) < 30 Then Exit Sub
    nextRun = Now + TimeSerial(0, 0, 30)
    Application.OnTime nextRun, "RefreshAll"
    pendingRefresh = False
    Exit Sub
ErrHandler:
    ' ignore scheduler errors
End Sub
