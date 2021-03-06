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
	Dim fans As String ="0"
	Dim answers As String ="0"
End Sub

' ignore
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.Name="Zhihu"
	
	'Version of the App
	App.Version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.Description="Show your Zhihu fans count and Reply count"
	
	App.Author="UniqueDing"
	
	App.CoverIcon = 1450
		
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
		<b>MID:</b>
    <ul>
		<li>Go to https://zhihu.com/</li>
		<li>Login your zhihu</li>
		<li>go to your person page<li>
		<li>and url will be https://zhihu.com/people/XXXXXXX</li>
		<li>XXXXXXX is your MID</li><br/><br/>
	</ul>
	"$
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(1450,1451)
	
	'Tickinterval in ms (should be 65 by default)
	App.Tick=65
	

	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("IP:PORT":"","MID":"")
	
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
			App.Download("http://"&App.Get("IP:PORT")&"/zhihu/"&App.Get("MID"))
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
					fans = root.Get("fans")
					answers = root.Get("answers")
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
			App.genText(fans,True,scroll,Null,False)
			App.drawBMP(0,scroll-1,App.getIcon(1450),8,8)
			scroll=scroll+1
		Else
			App.genText(answers,True,1,Null,False)
			App.drawBMP(0,0,App.getIcon(1451),8,8)
		End If
	Else
		App.genText(fans,True,1,Null,False)
		App.drawBMP(0,0,App.getIcon(1450),8,8)
	End If
End Sub
