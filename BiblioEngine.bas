Attribute VB_Name = "BiblioEngine"
Option Explicit

' ===========================================================================
'  Bibliographic automation engine for Word documents (ГОСТ Р 7.0.100-2018)
'  Handles normalization, key generation, storage, sorting, numbering,
'  citations, audits, export/import, and diagnostic helpers.
'  This module purposely avoids external dependencies and is designed to work
'  in both .docm (with macros) and .docx (when fields are preserved) files.
' ===========================================================================

' ======== Public constants ========
Public Const BIB_SECTION_TITLE As String = "СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ"
Public Const BIB_ITEM_STYLE As String = "BiblioItem"
Public Const BIB_NUM_CHARSTYLE As String = "BiblioNum"
Public Const BIB_SEQ_NAME As String = "BIB"
Public Const BIB_MARK_PREFIX_REF As String = "ref_"
Public Const BIB_MARK_PREFIX_SRC As String = "src_"
Public Const BIB_MARK_PREFIX_META As String = "BIBKEY_"
Public Const BIB_MAP_PREFIX As String = "BIBMAP_"
Public Const BIB_FIRST_PREFIX As String = "BIBFIRST_"
Public Const BIB_STORAGE_XML_NAMESPACE As String = "urn:biblio:1"
Public Const BIB_STORAGE_XML_ROOT As String = "/biblio/items/item"
Public Const AUDIT_REPORT_TITLE As String = "Biblio Audit Report"
Public Const BIB_ORDER_MODE_ALPHA As String = "ALPHA"
Public Const BIB_ORDER_MODE_CITE As String = "CITE"
Public Const BIB_DEFAULT_ORDER_MODE As String = BIB_ORDER_MODE_ALPHA

' ======== Private state ========
' ======== Initialization ========
Public Sub BiblioInit()
    On Error GoTo ErrHandler
    EnsureParagraphStyle BIB_ITEM_STYLE
    EnsureCharStyle BIB_NUM_CHARSTYLE
    EnsureBiblioSection
    EnsureOrderModeVariable
    Exit Sub
ErrHandler:
    MsgBox "BiblioInit: " & Err.Description, vbExclamation
End Sub

Private Sub EnsureOrderModeVariable()
    With ActiveDocument.Variables
        If Not HasDocumentVariable("BIB_ORDER_MODE") Then
            .Add Name:="BIB_ORDER_MODE", Value:=BIB_DEFAULT_ORDER_MODE
        End If
    End With
End Sub

Private Function HasDocumentVariable(ByVal name As String) As Boolean
    On Error Resume Next
    Dim tmp As Variant
    tmp = ActiveDocument.Variables(name).Value
    HasDocumentVariable = (Err.Number = 0)
    Err.Clear
End Function

Private Sub SetDocumentVariable(ByVal name As String, ByVal value As String)
    On Error GoTo Update
    ActiveDocument.Variables.Add Name:=name, Value:=value
    Exit Sub
Update:
    ActiveDocument.Variables(name).Value = value
End Sub

Private Sub EnsureParagraphStyle(ByVal name As String)
    On Error GoTo ErrHandler
    Dim st As Style
    Set st = ActiveDocument.Styles(name)
    If st Is Nothing Then Err.Raise 5
    Exit Sub
ErrHandler:
    Err.Clear
    Set st = ActiveDocument.Styles.Add(name, wdStyleTypeParagraph)
    With st
        .Font.Name = ActiveDocument.Styles(wdStyleNormal).Font.Name
        .Font.Size = 12
        .ParagraphFormat.SpaceAfter = 3
        .ParagraphFormat.SpaceBefore = 0
        .ParagraphFormat.LineSpacingRule = wdLineSpaceSingle
        .ParagraphFormat.LeftIndent = 0
        .ParagraphFormat.FirstLineIndent = CentimetersToPoints(-0.4)
        .ParagraphFormat.TabStops.Add Position:=CentimetersToPoints(0.8), Alignment:=wdAlignTabLeft
    End With
End Sub

Private Sub EnsureCharStyle(ByVal name As String)
    On Error GoTo ErrHandler
    Dim st As Style
    Set st = ActiveDocument.Styles(name)
    If st Is Nothing Then Err.Raise 5
    Exit Sub
ErrHandler:
    Err.Clear
    Set st = ActiveDocument.Styles.Add(name, wdStyleTypeCharacter)
    With st
        .Font.Hidden = True
        .Font.Size = 11
    End With
End Sub

Public Function EnsureBiblioSection() As Range
    Dim rng As Range
    Set rng = FindSectionRange()
    If rng Is Nothing Then
        Set rng = ActiveDocument.Content
        rng.Collapse wdCollapseEnd
        If rng.End > 0 Then rng.InsertParagraphAfter
        rng.InsertAfter BIB_SECTION_TITLE
        rng.Paragraphs(1).Style = wdStyleHeading1
        rng.InsertParagraphAfter
        rng.Collapse wdCollapseEnd
    End If
    Set EnsureBiblioSection = rng
End Function

Private Function FindSectionRange() As Range
    Dim p As Paragraph
    For Each p In ActiveDocument.Paragraphs
        If Trim$(Replace(p.Range.Text, vbCr, vbNullString)) = BIB_SECTION_TITLE Then
            Dim r As Range
            Set r = p.Range
            r.Collapse wdCollapseEnd
            Set FindSectionRange = r
            Exit Function
        End If
    Next
    Set FindSectionRange = Nothing
End Function

' ======== Normalization ========
Public Function NormalizeGOST(ByVal src As String) As String
    Dim s As String
    s = Trim$(src)
    If Len(s) = 0 Then
        NormalizeGOST = s
        Exit Function
    End If

    s = Replace(s, ChrW(&H2013), "—")
    s = Replace(s, ChrW(&H2014), "—")
    s = Replace(s, " - ", " — ")
    s = Replace(s, " – ", " — ")
    s = Replace(s, "--", "—")
    s = Replace(s, "— —", "—")
    s = Replace(s, " ,", ",")
    s = Replace(s, " .", ".")
    s = Replace(s, " ;", ";")
    s = Replace(s, " :", " :")
    s = Replace(s, "//", "//")
    s = Replace(s, " //", " //")
    s = Replace(s, "  ", " ")
    s = Replace(s, "[ Электронный ресурс ]", "[Электронный ресурс]")
    s = ReplaceQuotes(s)

    ' Ensure "URL:" and access date templates
    If InStr(1, s, "http", vbTextCompare) > 0 Then
        Dim firstUrl As String
        firstUrl = ExtractFirstUrl(s)
        If InStr(1, s, "URL:", vbTextCompare) = 0 And Len(firstUrl) > 0 Then
            s = s & " — URL: " & firstUrl
        End If
        If InStr(1, s, "дата обращения", vbTextCompare) = 0 Then
            s = s & " (дата обращения: " & Format$(Date, "dd.mm.yyyy") & ")"
        End If
        If InStr(1, s, "[Электронный ресурс]", vbTextCompare) = 0 Then
            Dim firstStop As Long
            firstStop = InStr(1, s, "//", vbTextCompare)
            If firstStop > 0 Then
                s = Left$(s, firstStop - 1) & " [Электронный ресурс] " & Mid$(s, firstStop)
            Else
                s = s & " [Электронный ресурс]"
            End If
        End If
    End If

    NormalizeGOST = Trim$(s)
End Function

Private Function ReplaceQuotes(ByVal s As String) As String
    s = Replace(s, "\"", "«")
    s = Replace(s, "''", "»")
    s = Replace(s, "\"", "«")
    s = Replace(s, "'", "»")
    s = Replace(s, "\"\"", "«")
    ReplaceQuotes = s
End Function

Private Function ExtractFirstUrl(ByVal s As String) As String
    Dim rx As Object
    Set rx = CreateObject("VBScript.RegExp")
    rx.Pattern = "https?://[^\s\)]*"
    rx.Global = False
    If rx.Test(s) Then
        ExtractFirstUrl = rx.Execute(s)(0).Value
    Else
        ExtractFirstUrl = ""
    End If
End Function

' ======== Key generation ========
Public Function MakeKey(ByVal src As String) As String
    Dim t As String
    t = LCase$(Trim$(src))
    t = Replace(t, "ё", "е")
    t = Replace(t, "й", "и")
    t = TranslitCyrToLat(t)
    t = Replace(t, " ", "_")
    t = Replace(t, "/", "_")
    t = Replace(t, "-", "_")
    t = Replace(t, "—", "_")
    t = FilterKeep(t, "abcdefghijklmnopqrstuvwxyz0123456789_")
    If Len(t) = 0 Then t = "src"
    If Len(t) > 30 Then t = Left$(t, 30)
    MakeKey = EnsureUniqueKey(t)
End Function

Private Function TranslitCyrToLat(ByVal s As String) As String
    Dim srcChars As Variant
    Dim dstChars As Variant
    Dim i As Long
    srcChars = Array("ж", "ц", "ч", "щ", "ш", "ю", "я", "х", "э", "й", "ё", "ы", _
                     "ъ", "ь", "а", "б", "в", "г", "д", "е", "з", "и", "к", "л", _
                     "м", "н", "о", "п", "р", "с", "т", "у", "ф", "Ж", "Ц", "Ч", _
                     "Щ", "Ш", "Ю", "Я", "Х", "Э", "Й", "Ё", "Ы", "Ъ", "Ь", "А", _
                     "Б", "В", "Г", "Д", "Е", "З", "И", "К", "Л", "М", "Н", "О", _
                     "П", "Р", "С", "Т", "У", "Ф")
    dstChars = Array("zh", "ts", "ch", "sch", "sh", "yu", "ya", "kh", "e", "i", "e", "y", _
                     "", "", "a", "b", "v", "g", "d", "e", "z", "i", "k", "l", _
                     "m", "n", "o", "p", "r", "s", "t", "u", "f", "zh", "ts", "ch", _
                     "sch", "sh", "yu", "ya", "kh", "e", "i", "e", "y", "", "", "a", _
                     "b", "v", "g", "d", "e", "z", "i", "k", "l", "m", "n", "o", _
                     "p", "r", "s", "t", "u", "f")
    For i = LBound(srcChars) To UBound(srcChars)
        s = Replace(s, srcChars(i), dstChars(i))
    Next
    TranslitCyrToLat = s
End Function

Private Function FilterKeep(ByVal s As String, ByVal allowed As String) As String
    Dim i As Long
    Dim ch As String
    Dim output As String
    For i = 1 To Len(s)
        ch = Mid$(s, i, 1)
        If InStr(allowed, ch) > 0 Then
            output = output & ch
        End If
    Next
    FilterKeep = output
End Function

Private Function EnsureUniqueKey(ByVal proposed As String) As String
    Dim key As String
    Dim i As Long
    key = proposed
    i = 1
    Do While BookmarkExists(BIB_MARK_PREFIX_SRC & key) Or BookmarkExists(BIB_MARK_PREFIX_REF & key)
        key = proposed & "_" & Format$(i, "00")
        i = i + 1
    Loop
    EnsureUniqueKey = key
End Function

Private Function BookmarkExists(ByVal name As String) As Boolean
    BookmarkExists = ActiveDocument.Bookmarks.Exists(name)
End Function

' ======== Insert/update items ========
Public Function InsertOrUpdateItem(Optional ByVal rawText As String = vbNullString, _
                                   Optional ByVal existingKey As String = vbNullString) As String
    On Error GoTo ErrHandler
    Call BiblioInit

    Dim srcText As String
    If Len(rawText) = 0 Then
        srcText = InputBox("Введите или вставьте описание источника.", "Источник")
    Else
        srcText = rawText
    End If
    If Len(Trim$(srcText)) = 0 Then Exit Function

    Dim norm As String
    norm = NormalizeGOST(srcText)

    Dim key As String
    If Len(existingKey) > 0 Then
        key = existingKey
    Else
        key = MakeKey(norm)
    End If

    Dim paragraphRange As Range
    If BookmarkExists(BIB_MARK_PREFIX_SRC & key) Then
        Set paragraphRange = ActiveDocument.Bookmarks(BIB_MARK_PREFIX_SRC & key).Range
        If Not BookmarkExists(BIB_MARK_PREFIX_REF & key) Then
            SetupParagraphStructure paragraphRange, key
        End If
    Else
        Dim insertRange As Range
        Set insertRange = EnsureBiblioSection()
        insertRange.Collapse wdCollapseEnd
        insertRange.InsertParagraphAfter
        insertRange.Collapse wdCollapseEnd
        insertRange.Text = norm
        insertRange.Paragraphs(1).Style = BIB_ITEM_STYLE
        Set paragraphRange = insertRange.Paragraphs(1).Range
        SetupParagraphStructure paragraphRange, key
    End If

    WriteParagraphBody paragraphRange, norm
    StampKeyMarker paragraphRange, key
    CacheMetadataFromParagraph paragraphRange, key, norm
    SortAndRenumber IsAlphabetMode()
    InsertOrUpdateItem = key
    Exit Function
ErrHandler:
    MsgBox "InsertOrUpdateItem: " & Err.Description, vbExclamation
End Function

Private Sub SetupParagraphStructure(ByVal pr As Range, ByVal key As String)
    Dim numberRange As Range
    Set numberRange = pr.Duplicate
    numberRange.End = numberRange.Start
    numberRange.Fields.Add numberRange, wdFieldSequence, BIB_SEQ_NAME & " \* Arabic", True
    numberRange.InsertAfter vbTab
    numberRange.Style = BIB_NUM_CHARSTYLE
    AddBookmarkAtRange BIB_MARK_PREFIX_REF & key, numberRange
    Dim fullRange As Range
    Set fullRange = pr.Duplicate
    fullRange.End = fullRange.End - 1
    AddBookmarkAtRange BIB_MARK_PREFIX_SRC & key, fullRange
End Sub

Private Sub WriteParagraphBody(ByVal pr As Range, ByVal body As String)
    Dim bodyRange As Range
    Dim key As String
    key = GetKeyByParagraph(pr)
    Set bodyRange = pr.Duplicate
    If bodyRange.MoveStartUntil(vbTab, wdForward) = 0 Then
        If Len(key) > 0 And BookmarkExists(BIB_MARK_PREFIX_REF & key) Then
            Dim numRange As Range
            Set numRange = ActiveDocument.Bookmarks(BIB_MARK_PREFIX_REF & key).Range.Duplicate
            numRange.Collapse wdCollapseEnd
            numRange.InsertAfter vbTab
        Else
            Dim insertRange As Range
            Set insertRange = pr.Duplicate
            insertRange.End = insertRange.Start
            insertRange.InsertAfter vbTab
        End If
        Set bodyRange = pr.Duplicate
        bodyRange.MoveStartUntil vbTab, wdForward
    End If
    If bodyRange.Characters.First.Text = vbTab Then
        bodyRange.MoveStart wdCharacter, 1
    End If
    bodyRange.End = pr.End - 1
    bodyRange.Text = body
End Sub

Private Sub AddBookmarkAtRange(ByVal name As String, ByVal rng As Range)
    On Error Resume Next
    If ActiveDocument.Bookmarks.Exists(name) Then ActiveDocument.Bookmarks(name).Delete
    rng.Bookmarks.Add name, rng
    On Error GoTo 0
End Sub

Private Sub StampKeyMarker(ByVal rng As Range, ByVal key As String)
    Dim commentText As String
    commentText = "{" & BIB_MARK_PREFIX_META & key & "}"
    If Right$(rng.Text, Len(commentText) + 1) <> commentText & vbCr Then
        rng.InsertAfter " " & commentText
    End If
End Sub

Private Sub CacheMetadataFromParagraph(ByVal rng As Range, ByVal key As String, ByVal norm As String)
    Dim numberValue As String
    numberValue = GetNumberFromParagraph(rng)
    If Len(numberValue) > 0 Then
        SetDocumentVariable BIB_MAP_PREFIX & key, numberValue
    End If

    If Not HasDocumentVariable(BIB_FIRST_PREFIX & key) Then
        SetDocumentVariable BIB_FIRST_PREFIX & key, ""
    End If

    StoreRecordInXml key, norm
End Sub

' ======== Sorting and numbering ========
Public Sub SortAndRenumber(Optional ByVal alphabetical As Boolean = True)
    On Error GoTo ErrHandler
    Dim bibRange As Range
    Set bibRange = GetBiblioListRange()
    If bibRange Is Nothing Then Exit Sub

    Dim sortedKeys As Collection
    Set sortedKeys = BuildSortedKeyList(alphabetical)

    ReorderParagraphsByKeys sortedKeys, bibRange
    Set bibRange = GetBiblioListRange()
    If Not bibRange Is Nothing Then
        ResetSequenceFields bibRange
    End If
    UpdateMap
    ActiveDocument.Fields.Update
    Exit Sub
ErrHandler:
    MsgBox "SortAndRenumber: " & Err.Description, vbExclamation
End Sub

Public Sub SwitchOrderMode(ByVal newMode As String)
    If newMode <> BIB_ORDER_MODE_ALPHA And newMode <> BIB_ORDER_MODE_CITE Then
        MsgBox "Неизвестный режим: " & newMode, vbExclamation
        Exit Sub
    End If
    ActiveDocument.Variables("BIB_ORDER_MODE").Value = newMode
    SortAndRenumber (newMode = BIB_ORDER_MODE_ALPHA)
End Sub

Public Function IsAlphabetMode() As Boolean
    On Error Resume Next
    IsAlphabetMode = (ActiveDocument.Variables("BIB_ORDER_MODE").Value <> BIB_ORDER_MODE_CITE)
End Function

Private Function BuildSortedKeyList(ByVal alphabetical As Boolean) As Collection
    Dim coll As New Collection
    Dim dict As Object
    Set dict = CreateObject("Scripting.Dictionary")
    Dim p As Paragraph
    For Each p In ActiveDocument.Paragraphs
        If p.Range.Style = BIB_ITEM_STYLE Then
            Dim key As String
            key = GetKeyByParagraph(p.Range)
            If Len(key) > 0 Then
                Dim sortKey As String
                If alphabetical Then
                    sortKey = BuildAlphabeticalSortKey(p.Range.Text)
                Else
                    sortKey = BuildCitationOrderKey(key)
                End If
                Dim uniqueKey As String
                uniqueKey = sortKey & "|" & Format$(p.Range.Start, "0000000000")
                dict.Add uniqueKey, key
            End If
        End If
    Next
    If dict.Count = 0 Then
        Set BuildSortedKeyList = coll
        Exit Function
    End If

    Dim arr As Variant
    arr = dict.Keys
    If UBound(arr) >= LBound(arr) Then
        QuickSort arr, LBound(arr), UBound(arr)
        Dim i As Long
        For i = LBound(arr) To UBound(arr)
            coll.Add dict(arr(i))
        Next
    End If
    Set BuildSortedKeyList = coll
End Function

Private Function BuildAlphabeticalSortKey(ByVal textValue As String) As String
    Dim s As String
    s = textValue
    s = Replace(s, "[Электронный ресурс]", "")
    s = Replace(s, "[электронный ресурс]", "")
    s = Replace(s, ":", " ")
    s = Replace(s, vbTab, " ")
    s = Replace(s, Chr(160), " ")
    s = Trim$(RemoveLeadingDecorations(s))
    BuildAlphabeticalSortKey = LCase$(s)
End Function

Private Function RemoveLeadingDecorations(ByVal s As String) As String
    Dim rx As Object
    Set rx = CreateObject("VBScript.RegExp")
    rx.Pattern = "^[\d\[\]\s\.,;:«»\-–—]+"
    rx.Global = False
    RemoveLeadingDecorations = rx.Replace(s, "")
End Function

Private Function BuildCitationOrderKey(ByVal key As String) As String
    Dim orderValue As String
    On Error Resume Next
    orderValue = ActiveDocument.Variables(BIB_FIRST_PREFIX & key).Value
    If Len(orderValue) = 0 Then orderValue = "999999"
    BuildCitationOrderKey = Format$(CLng(Val(orderValue)), "000000")
End Function

Private Sub QuickSort(arr As Variant, ByVal first As Long, ByVal last As Long)
    Dim low As Long, high As Long
    Dim mid As String, tmp As String
    low = first
    high = last
    mid = arr((first + last) \ 2)
    Do While low <= high
        Do While arr(low) < mid
            low = low + 1
        Loop
        Do While arr(high) > mid
            high = high - 1
        Loop
        If low <= high Then
            tmp = arr(low)
            arr(low) = arr(high)
            arr(high) = tmp
            low = low + 1
            high = high - 1
        End If
    Loop
    If first < high Then QuickSort arr, first, high
    If low < last Then QuickSort arr, low, last
End Sub

Private Sub ReorderParagraphsByKeys(ByVal keys As Collection, ByVal listRange As Range)
    If keys.Count = 0 Then Exit Sub

    Dim buildAnchor As Range
    Set buildAnchor = ActiveDocument.Content
    buildAnchor.Collapse wdCollapseEnd
    buildAnchor.InsertParagraphAfter
    Dim buildRange As Range
    Set buildRange = buildAnchor.Duplicate
    buildRange.Collapse wdCollapseEnd

    Dim key As Variant
    For Each key In keys
        Dim bmName As String
        bmName = BIB_MARK_PREFIX_SRC & CStr(key)
        If BookmarkExists(bmName) Then
            ActiveDocument.Bookmarks(bmName).Range.Paragraphs(1).Range.Cut
            buildRange.Paste
            buildRange.SetRange buildRange.End, buildRange.End
        End If
    Next

    Dim sortedRange As Range
    Set sortedRange = buildAnchor.Paragraphs(1).Range
    sortedRange.End = buildRange.End

    listRange.SetRange listRange.Start, listRange.Start
    sortedRange.Cut
    listRange.Paste
    buildAnchor.Paragraphs(1).Range.Delete
End Sub

Private Sub ResetSequenceFields(ByVal rng As Range)
    Dim f As Field
    For Each f In rng.Fields
        If f.Type = wdFieldSequence Then
            f.Code.Text = " SEQ " & BIB_SEQ_NAME & " \* Arabic "
            f.Update
        End If
    Next
End Sub

Private Function GetBiblioListRange() As Range
    Dim doc As Document
    Set doc = ActiveDocument
    Dim afterTitle As Range
    Set afterTitle = EnsureBiblioSection()
    Dim startRange As Range
    Dim endRange As Range
    Dim p As Paragraph
    For Each p In doc.Paragraphs
        If p.Range.Start >= afterTitle.Start Then
            If p.Range.Style = BIB_ITEM_STYLE Then
                If startRange Is Nothing Then
                    Set startRange = p.Range.Duplicate
                End If
                Set endRange = p.Range.Duplicate
            ElseIf Not startRange Is Nothing Then
                Exit For
            End If
        End If
    Next
    If startRange Is Nothing Then Exit Function
    startRange.SetRange startRange.Start, endRange.End
    Set GetBiblioListRange = startRange
End Function

Public Sub UpdateMap()
    Dim p As Paragraph
    For Each p In ActiveDocument.Paragraphs
        If p.Range.Style = BIB_ITEM_STYLE Then
            Dim key As String
            key = GetKeyByParagraph(p.Range)
            If Len(key) > 0 Then
                Dim num As String
                num = GetNumberFromParagraph(p.Range)
                If Len(num) > 0 Then
                    SetDocumentVariable BIB_MAP_PREFIX & key, num
                End If
            End If
        End If
    Next
End Sub

Public Function GetKeyByParagraph(ByVal rng As Range) As String
    Dim bm As Bookmark
    For Each bm In rng.Bookmarks
        If Left$(bm.Name, Len(BIB_MARK_PREFIX_SRC)) = BIB_MARK_PREFIX_SRC Then
            GetKeyByParagraph = Mid$(bm.Name, Len(BIB_MARK_PREFIX_SRC) + 1)
            Exit Function
        End If
    Next
    GetKeyByParagraph = ""
End Function

Private Function GetNumberFromParagraph(ByVal rng As Range) As String
    Dim f As Field
    For Each f In rng.Fields
        If f.Type = wdFieldSequence Then
            f.Update
            GetNumberFromParagraph = Trim$(f.Result)
            Exit Function
        End If
    Next
    GetNumberFromParagraph = ""
End Function

' ======== Citations ========
Public Sub InsertCitation(ByVal key As String)
    If Not BookmarkExists(BIB_MARK_PREFIX_REF & key) Then
        MsgBox "Нет источника с ключом " & key, vbExclamation
        Exit Sub
    End If
    Dim sel As Range
    Set sel = Selection.Range
    If sel.Characters.Count > 0 Then sel.Collapse wdCollapseEnd
    sel.InsertAfter "["
    sel.Collapse wdCollapseEnd
    ActiveDocument.Fields.Add sel, wdFieldRef, BIB_MARK_PREFIX_REF & key, False
    sel.Collapse wdCollapseEnd
    sel.InsertAfter "]"
    sel.Collapse wdCollapseEnd
    UpdateFirstMention key
End Sub

Public Sub InsertMultiCitation(ByVal keys As Variant)
    If IsEmpty(keys) Then Exit Sub
    Dim data() As Variant
    Dim i As Long
    ReDim data(LBound(keys) To UBound(keys))
    For i = LBound(keys) To UBound(keys)
        Dim numVal As Long
        numVal = CLng(GetNumberByKey(keys(i)))
        If numVal = 0 Then numVal = 1000000 + i
        data(i) = Array(keys(i), numVal)
        UpdateFirstMention keys(i)
    Next
    QuickSortPairs data, LBound(data), UBound(data)

    Dim groups As Collection
    Set groups = BuildCitationGroups(data)

    Dim outRng As Range
    Set outRng = Selection.Range
    outRng.InsertAfter "["
    outRng.Collapse wdCollapseEnd

    Dim grp As Variant
    Dim index As Long
    index = 1
    For Each grp In groups
        Dim firstItem As Variant
        Dim lastItem As Variant
        firstItem = grp(1)
        lastItem = grp(grp.Count)
        ActiveDocument.Fields.Add outRng, wdFieldRef, BIB_MARK_PREFIX_REF & CStr(firstItem(0)), False
        outRng.Collapse wdCollapseEnd
        If grp.Count > 1 Then
            outRng.InsertAfter "–"
            outRng.Collapse wdCollapseEnd
            ActiveDocument.Fields.Add outRng, wdFieldRef, BIB_MARK_PREFIX_REF & CStr(lastItem(0)), False
            outRng.Collapse wdCollapseEnd
        End If
        If index < groups.Count Then
            outRng.InsertAfter ", "
            outRng.Collapse wdCollapseEnd
        End If
        index = index + 1
    Next
    outRng.InsertAfter "]"
    outRng.Collapse wdCollapseEnd
End Sub

Private Sub QuickSortPairs(ByRef arr() As Variant, ByVal first As Long, ByVal last As Long)
    Dim low As Long, high As Long
    Dim mid As Variant, tmp As Variant
    low = first
    high = last
    mid = arr((first + last) \ 2)(1)
    Do While low <= high
        Do While arr(low)(1) < mid
            low = low + 1
        Loop
        Do While arr(high)(1) > mid
            high = high - 1
        Loop
        If low <= high Then
            tmp = arr(low)
            arr(low) = arr(high)
            arr(high) = tmp
            low = low + 1
            high = high - 1
        End If
    Loop
    If first < high Then QuickSortPairs arr, first, high
    If low < last Then QuickSortPairs arr, low, last
End Sub

Private Function BuildCitationGroups(ByRef data() As Variant) As Collection
    Dim groups As New Collection
    Dim current As Collection
    Dim i As Long
    For i = LBound(data) To UBound(data)
        If current Is Nothing Then
            Set current = New Collection
            current.Add data(i)
        Else
            If data(i)(1) = current(current.Count)(1) + 1 Then
                current.Add data(i)
            Else
                groups.Add current
                Set current = New Collection
                current.Add data(i)
            End If
        End If
    Next
    If Not current Is Nothing Then groups.Add current
    Set BuildCitationGroups = groups
End Function

Private Sub UpdateFirstMention(ByVal key As String)
    Dim vName As String
    vName = BIB_FIRST_PREFIX & key
    If Not HasDocumentVariable(vName) Then
        ActiveDocument.Variables.Add Name:=vName, Value:=Format$(ActiveDocument.Fields.Count + Timer, "0")
    ElseIf Len(ActiveDocument.Variables(vName).Value) = 0 Then
        ActiveDocument.Variables(vName).Value = Format$(ActiveDocument.Fields.Count + Timer, "0")
    End If
End Sub

Private Function GetNumberByKey(ByVal key As String) As Long
    On Error Resume Next
    GetNumberByKey = CLng(ActiveDocument.Variables(BIB_MAP_PREFIX & key).Value)
End Function


' ======== Conversion of plain brackets ========
Public Sub ConvertPlainBracketsToREF()
    Dim rng As Range
    Set rng = ActiveDocument.Content
    With rng.Find
        .ClearFormatting
        .Text = "\[[0-9,; \-–]+\]"
        .MatchWildcards = True
        Do While .Execute
            Dim payload As String
            payload = Mid$(rng.Text, 2, Len(rng.Text) - 2)
            Dim tokens As Variant
            tokens = TokenizeCites(payload)
            Dim newPos As Long
            newPos = ReplaceTokensWithRefs(rng, tokens)
            rng.SetRange newPos, ActiveDocument.Content.End
        Loop
    End With
End Sub

Private Function TokenizeCites(ByVal s As String) As Variant
    Dim out() As String
    Dim buffer As String
    Dim i As Long
    Dim ch As String
    ReDim out(0)
    For i = 1 To Len(s)
        ch = Mid$(s, i, 1)
        If ch Like "[0-9]" Then
            buffer = buffer & ch
        Else
            If Len(buffer) > 0 Then
                AppendToken out, buffer
                buffer = ""
            End If
            AppendToken out, ch
        End If
    Next
    If Len(buffer) > 0 Then AppendToken out, buffer
    TokenizeCites = out
End Function

Private Sub AppendToken(ByRef arr() As String, ByVal value As String)
    Dim n As Long
    If Len(arr(0)) = 0 And UBound(arr) = 0 Then
        arr(0) = value
    Else
        n = UBound(arr) + 1
        ReDim Preserve arr(n)
        arr(n) = value
    End If
End Sub

Private Function ReplaceTokensWithRefs(ByVal rng As Range, ByVal tokens As Variant) As Long
    Dim outRng As Range
    Set outRng = rng.Duplicate
    outRng.Text = ""
    outRng.InsertAfter "["
    outRng.Collapse wdCollapseEnd
    Dim i As Long
    For i = LBound(tokens) To UBound(tokens)
        If IsNumeric(tokens(i)) Then
            Dim key As String
            key = FindKeyByNumber(CLng(tokens(i)))
            If Len(key) > 0 Then
                ActiveDocument.Fields.Add outRng, wdFieldRef, BIB_MARK_PREFIX_REF & key, False
            Else
                outRng.InsertAfter tokens(i)
            End If
        Else
            outRng.InsertAfter tokens(i)
        End If
        outRng.Collapse wdCollapseEnd
    Next
    outRng.InsertAfter "]"
    ReplaceTokensWithRefs = outRng.End
End Function

Private Function FindKeyByNumber(ByVal numberValue As Long) As String
    Dim v As Variable
    For Each v In ActiveDocument.Variables
        If Left$(v.Name, Len(BIB_MAP_PREFIX)) = BIB_MAP_PREFIX Then
            If CLng(Val(v.Value)) = numberValue Then
                FindKeyByNumber = Mid$(v.Name, Len(BIB_MAP_PREFIX) + 1)
                Exit Function
            End If
        End If
    Next
    FindKeyByNumber = ""
End Function

' ======== Audit ========
Public Sub BiblioAudit()
    Dim report As Document
    Set report = Documents.Add
    report.Range.Text = AUDIT_REPORT_TITLE & vbCrLf & String(40, "=") & vbCrLf
    report.Range.InsertAfter AuditBrokenRefs()
    report.Range.InsertAfter AuditHangingSources()
    report.Range.InsertAfter AuditDuplicates()
    report.Range.InsertAfter AuditGostWarnings()
    report.Activate
End Sub

Private Function AuditBrokenRefs() As String
    Dim output As String
    output = "Битые ссылки:" & vbCrLf
    Dim f As Field
    For Each f In ActiveDocument.Fields
        If f.Type = wdFieldRef Then
            Dim codeText As String
            codeText = f.Code.Text
            Dim bm As String
            bm = Trim$(Replace(Replace(codeText, "REF", "", , , vbTextCompare), "\h", "", , , vbTextCompare))
            bm = Replace(bm, Chr(34), "")
            bm = Trim$(bm)
            If Len(bm) > 0 Then
                If Not BookmarkExists(bm) Then
                    output = output & "  - " & bm & vbCrLf
                End If
            End If
        End If
    Next
    output = output & vbCrLf
    AuditBrokenRefs = output
End Function

Private Function AuditHangingSources() As String
    Dim output As String
    output = "Источники без ссылок:" & vbCrLf
    Dim p As Paragraph
    For Each p In ActiveDocument.Paragraphs
        If p.Range.Style = BIB_ITEM_STYLE Then
            Dim key As String
            key = GetKeyByParagraph(p.Range)
            If Len(key) > 0 Then
                If CountRefsToKey(key) = 0 Then
                    output = output & "  - " & key & vbCrLf
                End If
            End If
        End If
    Next
    output = output & vbCrLf
    AuditHangingSources = output
End Function

Private Function CountRefsToKey(ByVal key As String) As Long
    Dim count As Long
    Dim f As Field
    For Each f In ActiveDocument.Fields
        If f.Type = wdFieldRef Then
            If InStr(1, f.Code.Text, BIB_MARK_PREFIX_REF & key, vbTextCompare) > 0 Then
                count = count + 1
            End If
        End If
    Next
    CountRefsToKey = count
End Function

Private Function AuditDuplicates() As String
    Dim output As String
    output = "Дубликаты ключей:" & vbCrLf
    ' duplicates prevented at creation, so only info message
    output = output & "  - проверяются автоматически при вставке" & vbCrLf & vbCrLf
    AuditDuplicates = output
End Function

Private Function AuditGostWarnings() As String
    Dim output As String
    output = "Проверка ГОСТ:" & vbCrLf
    Dim p As Paragraph
    For Each p In ActiveDocument.Paragraphs
        If p.Range.Style = BIB_ITEM_STYLE Then
            Dim txt As String
            txt = p.Range.Text
            If InStr(1, txt, "URL:", vbTextCompare) > 0 Then
                If InStr(1, txt, "дата обращения", vbTextCompare) = 0 Then
                    output = output & "  - " & GetKeyByParagraph(p.Range) & ": нет даты обращения" & vbCrLf
                End If
            End If
            If InStr(1, txt, "--", vbTextCompare) > 0 Or InStr(1, txt, " - ", vbTextCompare) > 0 Then
                output = output & "  - " & GetKeyByParagraph(p.Range) & ": заменить дефис на тире" & vbCrLf
            End If
        End If
    Next
    output = output & vbCrLf
    AuditGostWarnings = output
End Function

' ======== Export / Import ========
Public Sub ExportBibliography()
    Dim xmlContent As String
    xmlContent = BuildXmlExport()
    RewriteStorage xmlContent
    MsgBox "Экспортировано " & CountStoredItems() & " записей", vbInformation
End Sub

Public Sub ImportBibliography()
    Dim xmlDoc As CustomXMLPart
    For Each xmlDoc In ActiveDocument.CustomXMLParts
        If xmlDoc.NamespaceURI = BIB_STORAGE_XML_NAMESPACE Then
            RestoreItemsFromXml xmlDoc
            Exit Sub
        End If
    Next
    MsgBox "Не найдена база источников.", vbInformation
End Sub

Private Function BuildXmlExport() As String
    Dim xml As String
    xml = "<biblio xmlns='" & BIB_STORAGE_XML_NAMESPACE & "'><items>"
    Dim p As Paragraph
    For Each p In ActiveDocument.Paragraphs
        If p.Range.Style = BIB_ITEM_STYLE Then
            Dim key As String
            key = GetKeyByParagraph(p.Range)
            If Len(key) > 0 Then
                xml = xml & "<item key='" & key & "'>"
                xml = xml & "<text>" & EscapeXml(p.Range.Text) & "</text>"
                xml = xml & "</item>"
            End If
        End If
    Next
    xml = xml & "</items></biblio>"
    BuildXmlExport = xml
End Function

Private Function EscapeXml(ByVal s As String) As String
    s = Replace(s, "&", "&amp;")
    s = Replace(s, "<", "&lt;")
    s = Replace(s, ">", "&gt;")
    EscapeXml = s
End Function

Private Sub RestoreItemsFromXml(ByVal part As CustomXMLPart)
    Dim nodes As CustomXMLNodes
    Set nodes = part.SelectNodes(BIB_STORAGE_XML_ROOT)
    Dim node As CustomXMLNode
    For Each node In nodes
        Dim key As String
        key = node.Attributes("key").Text
        Dim textValue As String
        textValue = node.SelectSingleNode("text").Text
        InsertOrUpdateItem textValue, key
    Next
End Sub

Private Sub StoreRecordInXml(ByVal key As String, ByVal norm As String)
    Dim xmlContent As String
    xmlContent = BuildXmlExport()
    RewriteStorage xmlContent
End Sub

' ======== Utility ========
Public Sub RefreshAll()
    SortAndRenumber IsAlphabetMode()
End Sub

Private Sub RewriteStorage(ByVal xmlContent As String)
    Dim xmlDoc As CustomXMLPart
    For Each xmlDoc In ActiveDocument.CustomXMLParts
        If xmlDoc.NamespaceURI = BIB_STORAGE_XML_NAMESPACE Then xmlDoc.Delete
    Next
    ActiveDocument.CustomXMLParts.Add xmlContent
End Sub

Private Function CountStoredItems() As Long
    Dim xmlDoc As CustomXMLPart
    For Each xmlDoc In ActiveDocument.CustomXMLParts
        If xmlDoc.NamespaceURI = BIB_STORAGE_XML_NAMESPACE Then
            CountStoredItems = xmlDoc.SelectNodes(BIB_STORAGE_XML_ROOT).Count
            Exit Function
        End If
    Next
End Function

