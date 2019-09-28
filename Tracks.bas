B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
'Handler class
Sub Class_Globals
	
End Sub

Public Sub Initialize
	
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	'(id NUMBER UNIQUE PRIMARY KEY, datetime NUMERIC, domain TEXT, category TEXT, message TEXT)
	Dim domain As String = req.GetParameter("d")
	Dim category As String = req.GetParameter("c").ToUpperCase 'I/W/E/F
	Dim message As String = req.GetParameter("m")
	Dim guid As String = req.GetParameter("g")
	Dim stime As String = req.GetParameter("t")
	Dim time As Long
	If stime = "" Then time = 0 Else time = stime
	
	Dim getCode As String = ""
	If domain <> "" Then getCode = getCode & "D" Else getCode = getCode & "d"
	If category <> "" Then getCode = getCode & "C" Else getCode = getCode & "c"
	If guid <> "" Then getCode = getCode & "G" Else getCode = getCode & "g"
	If time <> 0 Then getCode = getCode & "T" Else getCode = getCode & "t"
	
	Dim answer As String
	LogDebug(req.Method)
	
	Select req.Method 
		Case "GET" ' Retrieve
			Dim cursor As ResultSet
			Dim fId As Int
			Dim fDateTime As Long
			Dim fGuid As String
			Dim fDomain As String
			Dim fCategory As String
			Dim fMessage As String
			
			Select getCode
				Case "dcgt"
					'all
					cursor = Main.gSql.ExecQuery("SELECT * FROM Tracks ORDER BY datetime")
				Case "dcgT"
					'time
					cursor = Main.gSql.ExecQuery2("SELECT * FROM Tracks WHERE datetime >= ? ORDER BY datetime",Array As Object(time))
				Case "dcGt"
					'guid
					cursor = Main.gSql.ExecQuery2("SELECT * FROM Tracks WHERE guid = ? ORDER BY datetime",Array As Object(guid))
				Case "dcGT"
					cursor = Main.gSql.ExecQuery2("SELECT * FROM Tracks WHERE guid = ? AND datetime >= ? ORDER BY datetime",Array As Object(guid,time))
				Case "dCgt"
					'category
					cursor = Main.gSql.ExecQuery2("SELECT * FROM Tracks WHERE category = ? ORDER BY datetime",Array As Object(category))
				Case "dCgT"
					cursor = Main.gSql.ExecQuery2("SELECT * FROM Tracks WHERE category = ? AND datetime >= ? ORDER BY datetime",Array As Object(category,time))
				Case "dCGt"
					cursor = Main.gSql.ExecQuery2("SELECT * FROM Tracks WHERE category = ? AND guid >= ? ORDER BY datetime",Array As Object(category,guid))
				Case "dCGT"
					cursor = Main.gSql.ExecQuery2("SELECT * FROM Tracks WHERE category = ? AND guid = ? AND datetime >= ? ORDER BY datetime",Array As Object(category,guid,time))
				Case "Dcgt"
					'domain
					cursor = Main.gSql.ExecQuery2("SELECT * FROM Tracks WHERE domain = ? ORDER BY datetime",Array As Object(domain))
				Case "DcgT"
					cursor = Main.gSql.ExecQuery2("SELECT * FROM Tracks WHERE domain = ? AND datetime >= ? ORDER BY datetime",Array As Object(domain,time))
				Case "DcGt"
					cursor = Main.gSql.ExecQuery2("SELECT * FROM Tracks WHERE domain = ? AND guid >= ? ORDER BY datetime",Array As Object(domain,time))
				Case "DcGT"
					cursor = Main.gSql.ExecQuery2("SELECT * FROM Tracks WHERE domain = ? AND guid = ? AND datetime >= ? ORDER BY datetime",Array As Object(domain,guid,time))
				Case "DCgt"
					cursor = Main.gSql.ExecQuery2("SELECT * FROM Tracks WHERE domain = ? AND category = ? ORDER BY datetime",Array As Object(domain, category))
				Case "DCgT"
					cursor = Main.gSql.ExecQuery2("SELECT * FROM Tracks WHERE domain = ? AND category = ? AND datetime >= ? ORDER BY datetime",Array As Object(domain,category,time))
				Case "DCGt"
					cursor = Main.gSql.ExecQuery2("SELECT * FROM Tracks WHERE domain = ? AND category = ? AND guid >= ? ORDER BY datetime",Array As Object(domain,category,guid))
				Case "DCGT"
					cursor = Main.gSql.ExecQuery2("SELECT * FROM Tracks WHERE domain = ? AND category = ? AND guid = ? AND datetime >= ? ORDER BY datetime",Array As Object(domain,category,guid,time))
			End Select

			Do While cursor.NextRow
				fId = cursor.GetInt("id")
				fDateTime = cursor.GetLong("datetime")
				fGuid = cursor.GetString("guid")
				fDomain = cursor.GetString("domain")
				fCategory = cursor.GetString("category")
				fMessage = cursor.GetString("message")
				resp.Write(fId & TAB & fDateTime & TAB & fGuid & TAB & fDomain & TAB & fCategory & TAB & fMessage & CRLF)
			Loop
			
		Case "PUT" ' Update
			LogDebug(message)
			Dim dattim As Long = DateTime.Now
			Main.gSql.ExecNonQuery2("INSERT INTO Tracks VALUES (null, ?, ?, ?, ?, ?)", Array As Object(dattim, guid, domain, category, message))
			resp.Write("OK")	
		
		Case Else
			resp.Write("FAiL")
	End Select
		
End Sub