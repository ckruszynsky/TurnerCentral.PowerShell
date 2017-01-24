#
# Update_TCSolution.ps1
#
param 
(    	
	[string] $iniFile = "settings.ini"
)

Add-PSSnapin "Microsoft.SharePoint.PowerShell"
$settings = ..\Get-Settings.ps1 $iniFile
$releaseFolder = $settings["Settings"]["ReleaseFolder"]

foreach($kvp in $settings["Solutions"].GetEnumerator()){
		
	if($kvp.Value.Trim() -eq "true") {
		Write-Host "Deploying Solution : $name.wsp"
		$name = $kvp.Key.Trim()
		Update-SPSolution -Identity "$name.wsp" -LiteralPath "$releaseFolder\$name.wsp" -GACDeployment -Force
	}
}

