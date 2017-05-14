'    P2P-filter-lists is a script to download lists of IPs.
'    Copyright (C) 2017  Rémi Ducceschi (remileduc) <remi.ducceschi@gmail.com>
'
'    This program is free software: you can redistribute it and/or modify
'    it under the terms of the GNU General Public License as published by
'    the Free Software Foundation, either version 3 of the License, or
'    (at your option) any later version.
'
'    This program is distributed in the hope that it will be useful,
'    but WITHOUT ANY WARRANTY; without even the implied warranty of
'    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'    GNU General Public License for more details.
'
'    You should have received a copy of the GNU General Public License
'    along with this program. If not, see <http://www.gnu.org/licenses/>.

' Downloads P2P filter lists and concatenate them in one list

main()

Sub main()
	' Initialization
	Set shell = CreateObject("Wscript.Shell")
	Dim tempPath, outputFile, tmpFile
	tempPath = WScript.CreateObject("Scripting.FileSystemObject").GetSpecialFolder(2) & "\qbittorrent"
	outputFile = tempPath & "\list.p2p"
	shell.Run "cmd /C mkdir " & tempPath, 0, True
	shell.Run "cmd /C del " & outputFile, 0, True

	' First, we downloadAndExtract the lists:
	downloadFiles shell, tempPath

	' Concatenate all txt files in one .p2p
	concatenate tempPath, outputFile
	shell.Run "cmd /C del " & tempPath & "\*.txt", 0, True

	' Script finished
	MsgBox "Script fini ! Vous pouvez maintenant mettre à jour a liste dans qBittorrent en allant dans ""Outils -> Options... -> Connexions"". En bas de la page, dans la section ""Filtrage IP"", cliquer sur recharger (la fèche verte)."
	wscript.Quit
End Sub

Sub downloadFiles(shell, path)
	' IP ranges of people who we have found to be sharing child pornography in the p2p community.
	downloadAndExtract shell, "http://list.iblocklist.com/?list=dufcxgnbjsdwmwctgfuj&fileformat=p2p&archiveformat=7z", path & "\pedophile.7z"
	' Companies or organizations who are clearly involved with trying to stop filesharing.
	' Companies which anti-p2p activity has been seen from.
	' Companies that produce or have a strong financial interest in copyrighted material.
	' Government ranges or companies that have a strong financial interest in doing work for governments.
	' Legal industry ranges.
	' IPs or ranges of ISPs from which anti-p2p activity has been observed.
	downloadAndExtract shell, "http://list.iblocklist.com/?list=ydxerpxkpcfqjaybcssw&fileformat=p2p&archiveformat=7z", path & "\level1.7z"
	' General corporate ranges.
	' Ranges used by labs or researchers.
	' Proxies.
	downloadAndExtract shell, "http://list.iblocklist.com/?list=gyisgnzbhppbvsphucsw&fileformat=p2p&archiveformat=7z", path & "\level2.7z"
	' Many portal-type websites.
	' ISP ranges that may be dodgy for some reason.
	' Ranges that belong to an individual, but which have not been determined to be used by a particular company.
	' Ranges for things that are unusual in some way.
	' The level3 list is aka the paranoid list.
	downloadAndExtract shell, "http://list.iblocklist.com/?list=uwnukjqktoggdknzrhgh&fileformat=p2p&archiveformat=7z", path & "\level3.7z"
	' Unallocated address space.
	downloadAndExtract shell, "http://list.iblocklist.com/?list=gihxqmhyunbxhbmgqrla&fileformat=p2p&archiveformat=7z", path & "\bogon.7z"
	' Contains advertising trackers and a short list of bad/intrusive porn sites.
	downloadAndExtract shell, "http://list.iblocklist.com/?list=dgxtneitpuvgqqcpfulq&fileformat=p2p&archiveformat=7z", path & "\ads.7z"
	' Known malicious spyware and adware IP Address ranges.
	downloadAndExtract shell, "http://list.iblocklist.com/?list=llvtlsjyoyiczbkjsxpf&fileformat=p2p&archiveformat=7z", path & "\spyware.7z"
	' List of people who have been reported for bad deeds in p2p.
	downloadAndExtract shell, "http://list.iblocklist.com/?list=cwworuawihqvocglcoss&fileformat=p2p&archiveformat=7z", path & "\badpeers.7z"
End Sub

Sub downloadAndExtract(shell, url, filename)
	shell.Run "bin\wget.exe -O " & filename & " """ & url & """", 0, True
	Set objFile = CreateObject("Scripting.FileSystemObject").GetFile(filename)
	sName = objFile.Name
	sPath = objFile.Path
	sPath = Left(sPath, Len(sPath)-Len(sName))
	shell.Run """C:\Program Files\7-Zip\7z.exe"" x -aoa -y -o" & sPath & " " & filename, 0, True
	shell.Run "cmd /C del " & filename, 0, True
End Sub

Sub concatenate(inputFolder, outputFile)
	Const ForReading = 1

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objOutputFile = objFSO.CreateTextFile(outputFile)

	strComputer = "."
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")

	Set FileList = objWMIService.ExecQuery("ASSOCIATORS OF {Win32_Directory.Name='" & inputFolder & "'} Where ResultClass = CIM_DataFile")

	For Each objFile In FileList
		Set objTextFile = objFSO.OpenTextFile(objFile.Name, ForReading) 
		strText = objTextFile.ReadAll
		objTextFile.Close
		objOutputFile.WriteLine strText
	Next

	objOutputFile.Close
End Sub
