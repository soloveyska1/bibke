VERSION 5.00
Begin VB.UserForm frmBiblio 
   Caption         =   "Библиография"
   ClientHeight    =   5160
   ClientLeft      =   45
   ClientTop       =   360
   ClientWidth     =   9600
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox txtSearch 
      Height          =   300
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   6000
   End
   Begin VB.ListBox lstSources 
      ColumnCount     =   2
      ColumnWidths    =   "3cm;10cm"
      Height          =   3600
      Left            =   120
      MultiSelect     =   2  'fmMultiSelectExtended
      TabIndex        =   1
      Top             =   480
      Width           =   7800
   End
   Begin VB.CommandButton cmdInsert 
      Caption         =   "Вставить"
      Height          =   360
      Left            =   8100
      TabIndex        =   2
      Top             =   480
      Width           =   1200
   End
   Begin VB.CommandButton cmdInsertMulti 
      Caption         =   "Мульти"
      Height          =   360
      Left            =   8100
      TabIndex        =   3
      Top             =   900
      Width           =   1200
   End
   Begin VB.CommandButton cmdAdd 
      Caption         =   "Добавить"
      Height          =   360
      Left            =   8100
      TabIndex        =   4
      Top             =   1440
      Width           =   1200
   End
   Begin VB.CommandButton cmdEdit 
      Caption         =   "Править"
      Height          =   360
      Left            =   8100
      TabIndex        =   5
      Top             =   1860
      Width           =   1200
   End
   Begin VB.CommandButton cmdLocate 
      Caption         =   "Показать"
      Height          =   360
      Left            =   8100
      TabIndex        =   6
      Top             =   2280
      Width           =   1200
   End
   Begin VB.CommandButton cmdRefresh 
      Caption         =   "Обновить"
      Height          =   360
      Left            =   8100
      TabIndex        =   7
      Top             =   2700
      Width           =   1200
   End
   Begin VB.CommandButton cmdAudit 
      Caption         =   "Аудит"
      Height          =   360
      Left            =   8100
      TabIndex        =   8
      Top             =   3120
      Width           =   1200
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Закрыть"
      Height          =   360
      Left            =   8100
      TabIndex        =   9
      Top             =   3540
      Width           =   1200
   End
End
Attribute VB_Name = "frmBiblio"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' [code as before]
Private Sub UserForm_Initialize()
    LoadSources vbNullString
End Sub

Private Sub txtSearch_Change()
    LoadSources txtSearch.Text
End Sub

Private Sub cmdRefresh_Click()
    RefreshAll
    LoadSources txtSearch.Text
End Sub

Private Sub cmdAdd_Click()
    CmdAddSource
    LoadSources txtSearch.Text
End Sub

Private Sub cmdEdit_Click()
    Dim key As String
    key = SelectedKey()
    If Len(key) = 0 Then Exit Sub
    Dim current As String
    current = GetSourceText(key)
    Dim updated As String
    updated = InputBox("Измените текст источника", "Правка", current)
    If Len(updated) = 0 Then Exit Sub
    InsertOrUpdateItem updated, key
    LoadSources txtSearch.Text
End Sub

Private Sub cmdInsert_Click()
    Dim key As String
    key = SelectedKey()
    If Len(key) = 0 Then Exit Sub
    InsertCitation key
    Unload Me
End Sub

Private Sub cmdInsertMulti_Click()
    Dim keys As Variant
    keys = SelectedKeys()
    If IsEmpty(keys) Then Exit Sub
    InsertMultiCitation keys
    Unload Me
End Sub

Private Sub cmdAudit_Click()
    BiblioAudit
End Sub

Private Sub cmdClose_Click()
    Unload Me
End Sub

Private Sub lstSources_DblClick(ByVal Cancel As MSForms.ReturnBoolean)
    cmdInsert_Click
End Sub

Private Sub cmdLocate_Click()
    Dim key As String
    key = SelectedKey()
    If Len(key) = 0 Then Exit Sub
    If ActiveDocument.Bookmarks.Exists(BIB_MARK_PREFIX_SRC & key) Then
        ActiveDocument.Bookmarks(BIB_MARK_PREFIX_SRC & key).Range.Select
        Me.Hide
    End If
End Sub

Private Sub LoadSources(ByVal filterText As String)
    Dim normalized As String
    normalized = LCase$(Trim$(filterText))
    lstSources.Clear
    Dim p As Paragraph
    For Each p In ActiveDocument.Paragraphs
        If p.Range.Style = BIB_ITEM_STYLE Then
            Dim key As String
            key = GetKeyByParagraph(p.Range)
            If Len(key) > 0 Then
                Dim body As String
                body = Replace(p.Range.Text, vbCr, vbNullString)
                body = StripKeyMarker(key, body)
                If normalized = vbNullString Or InStr(1, LCase$(body), normalized, vbTextCompare) > 0 Or _
                   InStr(1, LCase$(key), normalized, vbTextCompare) > 0 Then
                    lstSources.AddItem key
                    lstSources.List(lstSources.ListCount - 1, 1) = Left$(body, 180)
                End If
            End If
        End If
    Next
End Sub

Private Function SelectedKey() As String
    If lstSources.ListIndex < 0 Then Exit Function
    SelectedKey = lstSources.List(lstSources.ListIndex, 0)
End Function

Private Function SelectedKeys() As Variant
    Dim items As Collection
    Set items = New Collection
    Dim i As Long
    For i = 0 To lstSources.ListCount - 1
        If lstSources.Selected(i) Then
            items.Add lstSources.List(i, 0)
        End If
    Next
    If items.Count = 0 And lstSources.ListIndex >= 0 Then items.Add lstSources.List(lstSources.ListIndex, 0)
    If items.Count = 0 Then Exit Function
    Dim arr() As String
    ReDim arr(1 To items.Count)
    For i = 1 To items.Count
        arr(i) = items(i)
    Next
    SelectedKeys = arr
End Function

Private Function GetSourceText(ByVal key As String) As String
    If ActiveDocument.Bookmarks.Exists(BIB_MARK_PREFIX_SRC & key) Then
        Dim txt As String
        txt = Replace(ActiveDocument.Bookmarks(BIB_MARK_PREFIX_SRC & key).Range.Text, vbCr, vbNullString)
        txt = StripKeyMarker(key, txt)
        GetSourceText = Trim$(txt)
    End If
End Function

Private Function StripKeyMarker(ByVal key As String, ByVal textValue As String) As String
    Dim marker As String
    marker = " {" & BIB_MARK_PREFIX_META & key & "}"
    If Len(textValue) >= Len(marker) Then
        If Right$(textValue, Len(marker)) = marker Then
            StripKeyMarker = Left$(textValue, Len(textValue) - Len(marker))
            Exit Function
        End If
    End If
    StripKeyMarker = textValue
End Function
