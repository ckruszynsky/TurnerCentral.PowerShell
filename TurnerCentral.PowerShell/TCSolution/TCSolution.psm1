
function Get-Settings {
	param ($file)

$ini = @{}
switch -regex -file $file
{
    "^\[(.+)\]$" {
        $section = $matches[1]
        $ini[$section] = @{}
    }
    "(.+)=(.+)" {
        $name,$value = $matches[1..2]
        $ini[$section][$name] = $value
    }
}
$ini
}

function Update-TCSolution {
	param (    
		$iniFile = "settings.ini"
	)
Add-PSSnapin "Microsoft.SharePoint.PowerShell"

$settings = Get-Settings -file $iniFile

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
}



