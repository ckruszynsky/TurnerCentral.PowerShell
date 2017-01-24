#
# Stop_Search.ps1
#
param
(
  $searchServiceName = "OSearch15",
  $searchHostControllerName = "SPSearchHostController"
)

$searchService = get-service $searchServiceName
$searchHostControllerService = Get-Service $searchHostControllerName
if($searchService.Status -eq "Running"){
	set-service -Name  $searchServiceName -startuptype Disabled 
	$searchService.stop() 
}

if($searchHostControllerService.Status -eq "Running"){
	set-service -Name $searchHostControllerName -StartupType Disabled
	$searchHostControllerService.Stop()
}


do {
	$hostService = get-service $searchHostControllerName
	if($hostService.Status -eq "Stopped"){
		$yes = 1
	}
	Start-Sleep -Seconds 10
}
until($yes -eq 1)

Write-Host "###################################################"
Write-Host "Search Services are stopped" -ForegroundColor Green
Write-Host "###################################################"
