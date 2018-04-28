Type=Class
Version=7.01
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
'v1.00
Sub Class_Globals
	Public ToList As List
	Public CcList As List
	Public BccList As List
	Public Subject As String
	Public Body As String
	Public HtmlBody As Boolean
	Private eol As String = Chr(13) & Chr(10)
	Public Attachments As List
End Sub

Public Sub Initialize
	ToList.Initialize
	CcList.Initialize
	BccList.Initialize
	Attachments.Initialize
	HtmlBody = False
End Sub

Public Sub ToString As String
	Dim boundary As String = "---------------------------1461124740693"
	Dim su As StringUtils
	Dim sb As StringBuilder
	sb.Initialize
	sb.Append($"Content-Type: multipart/mixed; boundary="${boundary}""$).Append(eol)
	sb.Append("MIME-Version: 1.0").Append(eol)
	sb.Append(ListToCommaSeparated("To", ToList))
	sb.Append(ListToCommaSeparated("Cc", CcList))
	sb.Append(ListToCommaSeparated("Bcc", BccList))
	sb.Append("Subject: ").Append("=?UTF-8?B?").Append(su.EncodeBase64(Subject.GetBytes("utf8"))).Append("?=").Append(eol)
	sb.Append(eol)
	sb.Append("--").Append(boundary).Append(eol)
	Dim mime As String
	If HtmlBody Then mime = "html" Else mime = "plain"
	sb.Append($"Content-Type: text/${mime}; charset="UTF-8""$).Append(eol)
	sb.Append("Content-Transfer-Encoding: 7bit").Append(eol)
	sb.Append(eol)
	sb.Append(Body).Append(eol)
	
	For Each fd As MultipartFileData In Attachments
		sb.Append("--").Append(boundary).Append(eol)
		sb.Append($"Content-Disposition: attachment; filename="${fd.FileName}""$).Append(eol)
		sb.Append($"Content-Transfer-Encoding: base64"$).Append(eol)
		sb.Append($"Content-Type: ${fd.ContentType}"$).Append(eol)
		sb.Append(eol)
		
		Dim b() As Byte = Bit.InputStreamToBytes(File.OpenInput(fd.Dir, fd.FileName))
		sb.Append(su.EncodeBase64(b)).Append(eol)
	Next
	sb.Append("--").Append(boundary).Append("--")
	Return sb.ToString
End Sub

Private Sub ListToCommaSeparated(Header As String, l1 As List) As String
	Dim sb As StringBuilder
	sb.Initialize
	For Each s As String In l1
		sb.Append(s).Append(", ")
	Next
	If sb.Length > 0 Then 
		sb.Remove(sb.Length - 2, sb.Length)
		Return Header & ": " & sb.ToString & eol
	Else
		Return ""
	End If
End Sub
