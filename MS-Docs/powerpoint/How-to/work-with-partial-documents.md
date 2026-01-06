---
title: Work with Partial Documents
keywords: vbapp10.chm583138
f1_keywords:
- vbapp10.chm583138
ms.date: 08/02/2022
ms.author: ononder
ms.localizationpriority: medium
---


# Work with partial documents

When you open a presentation with content that is large in size, PowerPoint may serve the document in parts as partial documents. This allows you to open, edit, and collaborate on documents quickly, while the larger media parts (e.g., videos), continue to load in the background. Similarly, since media is handled separately from the rest of the document, collaboration is smoother when media is inserted during a collaboration session.

Because certain content can be deferred initially, some actions can't be taken until the deferred content is loaded. Additionally, there are certain actions like Save As, Export to Video, etc. that won’t function until all the deferred content are downloaded. If you initiate one of these operations, PowerPoint will display UI informing you of the download progress, but that’s not possible for programmatic operations. If you programmatically attempt to call an API to execute an action while content is still downloading, it will fail.


```
Run-time error '-2147188128 (80048260)':
<object> (unknown member) : This method isn't supported until the presentation is fully downloaded. Visit this URL for more information: https://go.microsoft.com/fwlink/?linkid=2172228
```


## Understand the fully downloaded state

To understand if a presentation is fully downloaded programmatically, you may query [Presentation.IsFullyDownloaded](PowerPoint.Presentation.IsFullyDownloaded) property before calling any of the impacted APIs.


```vb
If ActivePresentation.IsFullyDownloaded Then
    MsgBox "Presentation download is complete."
Else
    MsgBox "PowerPoint is still downloading the presentation."
End If
```


## Error handling

 You may also add some error handling to capture the failure and retry the operation once the presentation is fully downloaded. If the error value is `-2147188128` or `0x80048260`, the operation has failed because the presentation is not fully downloaded.
Use **Err.Number** as a key to identify these failures, as show in the following example.


```vb
Sub TestCopySlide()
    On Error GoTo eh    
    ActivePresentation.Slides(1).Copy    
    Exit Sub
eh:
    If Err.Number = -2147188128 Then
        MsgBox "Cannot copy because the presentation is not fully downloaded."
    Else
        MsgBox "Failure is due to a reason other than incomplete download: " & Err.Description.
    End If
    Debug.Print Err.Number, Err.Description
End Sub
```


## Impacted APIs

The following is a list of impacted OM API calls which may return the error code:

| Name                                                                                       |
| :----------------------------------------------------------------------------------------- |
| [Presentation.Export](PowerPoint.Presentation.Export)                             |
| [Presentation.ExportAsFixedFormat](PowerPoint.Presentation.ExportAsFixedFormat)   |
| [Presentation.ExportAsFixedFormat2](PowerPoint.Presentation.ExportAsFixedFormat2) |
| [Presentation.ExportAsFixedFormat3](PowerPoint.Presentation.ExportAsFixedFormat3) |
| [Presentation.SaveAs](PowerPoint.Presentation.SaveAs)                             |
| [Presentation.SaveCopyAs](PowerPoint.Presentation.SaveCopyAs)                     |
| [Presentation.SaveCopyAs2](PowerPoint.Presentation.SaveCopyAs2)                   |
| [Presentation.Password](PowerPoint.Presentation.Password)                         |
| [Presentation.WritePassword](PowerPoint.Presentation.WritePassword)               |
| [Selection.Copy](PowerPoint.Selection.Copy)                                       |
| [Selection.Cut](PowerPoint.Selection.Cut)                                         |
| [Shape.Copy](PowerPoint.Shape.Copy)                                               |
| [Shape.Cut](PowerPoint.Shape.Cut)                                                 |
| [ShapeRange.Cut](PowerPoint.ShapeRange.Cut)                                       |
| [ShapeRange.Copy](PowerPoint.ShapeRange.Copy)                                     |
| [Shapes.Paste](PowerPoint.Shapes.Paste)                                           |
| [Shapes.PasteSpecial](PowerPoint.Shapes.PasteSpecial)                             |
| [Slide.Copy](PowerPoint.Slide.Copy)                                                        |
| [Slide.Cut](PowerPoint.Slide.Cut)                                                 |
| [Slide.Export](PowerPoint.Slide.Export)                                           |
| [SlideRange.Copy](PowerPoint.SlideRange.Copy)                                     |
| [SlideRange.Cut](PowerPoint.SlideRange.Cut)                                       |
| [SlideRange.Export](PowerPoint.SlideRange.Export)                                 |
| [Slides.Paste](PowerPoint.Slides.Paste)                                           |
| [CustomLayouts.Paste](PowerPoint.CustomLayouts.Paste)                             |
| [View.Paste](PowerPoint.View.Paste)                                               |
| [View.PasteSpecial](PowerPoint.View.PasteSpecial)                                 |
| [MediaFormat.Resample](PowerPoint.MediaFormat.Resample)                           |
| [MediaFormat.ResampleFromProfile](PowerPoint.MediaFormat.ResampleFromProfile)     |
| [Player.Play](PowerPoint.Player.Play)                                             |


[!include[Support and feedback](~/includes/feedback-boilerplate.md)]
