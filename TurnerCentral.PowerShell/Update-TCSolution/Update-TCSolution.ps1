#
# Update_TCSolution.ps1
#
param 
(    
)

Add-PSSnapin "Microsoft.SharePoint.PowerShell"
cls
$iniFile = "settings.ini"
$settings = ..\Get-Settings.ps1 $iniFile
$releaseFolder = $settings["Settings"]["ReleaseFolder"]

foreach($kvp in $settings["Solutions"].GetEnumerator()){
		
	if($kvp.Value.Trim() -eq "true") {
		$name = $kvp.Key.Trim()
        Write-Host "Deploying Solution : $name.wsp"
        $path = "$releaseFolder\$name.wsp"
        $path
		Update-SPSolution -Identity "$name.wsp" -LiteralPath $path -GACDeployment -Force
	}
}
