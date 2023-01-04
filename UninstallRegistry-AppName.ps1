$apps = @(

"AppName"

)

Foreach ($app in $apps){

# Check 32-bit Instance
$32bit = Get-ChildItem -Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -match "$app" }
    If ($32bit -ne $Null) {
        $GUID = $32bit.PSChildName
        Start-Process MsiExec -ArgumentList "/X$GUID /Quiet" -Wait
        }

# Check 64-bit Instance
$64bit = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -match "$app" }
    If ($64bit -ne $Null) {
        $GUID = $64bit.PSChildName
        Start-Process MsiExec -ArgumentList "/X$GUID /Quiet" -Wait
        }
}