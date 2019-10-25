Param (
    $UserName,
    $SessionAgeLimit,
    $ComputerName
)
$i = 0
quser /server:$ComputerName | ForEach-Object {
    IF ($i -ne 0) {
        $_ -replace "SESSIONNAME","" -replace "rdp-tcp#\d\d","" -replace "console","" -replace "Disc","Disconnected" -match '^[\s>]([\w\.]+)\s+(\d+)\s+(\w+)\s+([\d:+"none"\.]+)\s+([\d\/\s:]+)$' | Out-Null
        $Report = "" | Select-Object ComputerName,UserName,State,IdleTime,LogonTime
        $Report.ComputerName = $ComputerName
        $Report.UserName = $matches[1]
        $Report.State = $matches[3]
        $Report.IdleTime = $matches[4] -replace "\+"," Days, " -replace ":"," Hours and " -replace '$'," Minutes"
        $Report.LogonTime = $matches[5]
        $Report
    }
    $i++
} | Where-Object {
    $_.State -eq "Disconnected" -and $_.UserName -eq $UserName -and (((get-date) - (get-date $_.LogonTime)).Days -ge $SessionAgeLimit)
}