B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=1.0
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX	
	
	'Define your variables here
	Dim scroll As Int
	Dim rate As String ="0"
	Dim acs As String ="0"
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="LeetcodeCN"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="Show your LeetcodeCN rate and ac count"
	
	App.Author="UniqueDing"
	
	App.CoverIcon = 1447
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
		<b>MID:</b>
    <ul>
		<li>your leetcode-cn user name</li>
		<li>https://leetcode-cn.com/u/XXXXXXX</li>
		<li>XXXXXXX is your MID</li><br/><br/>
	</ul>
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(1447,1448)
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
	

	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("URL":"","MID":"")
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub
' ignore
public Sub GetNiceName() As String
	Return App.Name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

Sub App_Started
	scroll=1
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download("http://"&App.Get("URL")&"/leetcodecn/"&App.Get("MID"))
	End Select

End Sub

Sub App_evalJobResponse(Resp As JobResponse)
	Try
		If Resp.success Then
			Select Resp.jobNr
				Case 1
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					rate = root.Get("rate")
					acs = root.Get("acs")
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

'Generate your Frame. This Sub is called with every Tick
Sub App_genFrame
	If App.startedAt<DateTime.Now-App.duration*1000/2 Then
		If scroll<10 Then
			App.genText(rate,True,scroll,Null,False)
			App.drawBMP(0,scroll-1,App.getIcon(1447),8,8)
			scroll=scroll+1
		Else
			App.genText(acs,True,1,Null,False)
			App.drawBMP(0,0,App.getIcon(1448),8,8)
		End If
	Else
		App.genText(rate,True,1,Null,False)
		App.drawBMP(0,0,App.getIcon(1447),8,8)
	End If
End Sub
