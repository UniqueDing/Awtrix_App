B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim scroll1 As Int
	Dim scroll2 As Int
	Dim scroll3 As Int
	Dim play_count As String ="0"
	Dim coin_count As String ="0"
	Dim like_count As String ="0"
	Dim collect_count As String ="0"
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.Name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.name="BilibiliVideo"
	
	'Version of the App
	App.version="1.0"
	
	'Description of the App. You can use HTML to format it
	App.description="show your bilibili video SAN LIAN"
		
	App.author="UniqueDing"
			
	App.coverIcon = 1442
	
	'How many downloadhandlers should be generated
	App.Downloads=1
	
	'SetupInstructions. You can use HTML to format it
	App.setupDescription= $"
		<b>BV:</b>
    <ul>
		<li>your bilibili video BV</li>
	</ul>
	"$
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.icons=Array As Int(1446,1445,1443,1442)
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.Settings=CreateMap("IP:PORT":"",BV":"")
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick=65
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

Sub App_Started
	scroll1=1
	scroll2=1
	scroll3=1
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download("http://"&App.Get("IP:PORT")&"/bilibilivideo/"&App.Get("BV"))
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
					play_count = root.Get("play")
					like_count = root.Get("like")
					coin_count = root.Get("coin")
					collect_count = root.Get("collect")
			End Select
		End If
	Catch
		Log("Error in: "& App.Name & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

'With this sub you build your frame.
Sub App_genFrame
	If App.startedAt<DateTime.Now-App.duration*1000/4 Then
		If scroll1<10 Then
			App.genText(play_count,True,scroll1,Null,False)
			App.drawBMP(0,scroll1-1,App.getIcon(1442),8,8)
			scroll1=scroll1+1
		Else
			If App.startedAt<DateTime.Now-App.duration*1000*2/4 Then
				If scroll2<10 Then
					App.genText(like_count,True,scroll2,Null,False)
					App.drawBMP(0,scroll2-1,App.getIcon(1445),8,8)
					scroll2=scroll2+1
				Else
					If App.startedAt<DateTime.Now-App.duration*1000*3/4 Then
						If scroll3<10 Then
							App.genText(coin_count,True,scroll3,Null,False)
							App.drawBMP(0,scroll3-1,App.getIcon(1443),8,8)
							scroll3=scroll3+1
						Else
							App.genText(collect_count,True,1,Null,False)
							App.drawBMP(0,0,App.getIcon(1446),8,8)
						End If
					Else
						App.genText(coin_count,True,1,Null,False)
						App.drawBMP(0,0,App.getIcon(1443),8,8)
					End If
				End If
			Else
				App.genText(like_count,True,1,Null,False)
				App.drawBMP(0,0,App.getIcon(1445),8,8)
			End If
		End If
	Else
		App.genText(play_count,True,1,Null,False)
		App.drawBMP(0,0,App.getIcon(1442),8,8)
	End If
End Sub
