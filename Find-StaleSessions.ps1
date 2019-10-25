Param (
    $UserName,
    $SessionAgeLimit,
    $ComputerName
)
Get-Sessions -ComputerName $ComputerName | Where-Object {
    $_.State -eq "Disconnected" -and $_.UserName -eq $UserName -and (((get-date) - (get-date $_.LogonTime)).Days -ge $SessionAgeLimit)
}