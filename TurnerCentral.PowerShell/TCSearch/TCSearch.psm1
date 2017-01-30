function Stop-Search {
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
}

function Set-SearchCrawler {
param(
	$SiteCollectionURL  =  "",
	$FullIncrementalOrStop = "Full"
)

    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") > $null 
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Office.Server.Search") > $null 

	$site = New-Object Microsoft.SharePoint.SPSite($SiteCollectionURL)
	Write-Host "SiteCollection URL: ", $SiteCollectionURL 
	
	$context = [Microsoft.Office.Server.Search.Administration.SearchContext]::GetContext($site)
	
	$site.Dispose()
	$sspcontent = new-object Microsoft.Office.Server.Search.Administration.Content($context) 
    $sspContentSources =  $sspcontent.ContentSources

	Write-Host "Total of Content Source: ", $sspContentSources.Count

	foreach($cs in $sspContentSources) {
		Write-Host "NAME: ", $cs.Name, " - ID: ", $cs.Id 
        switch($FullIncrementalorStop) 
        { 
        "full" 
            { 
                Write-Host "Start Full Crawl" 
                $cs.StartFullCrawl() 
                Write-Host "Full Crawl Started" 
            } 
        "incremental" 
            { 
                Write-Host "Start Incremental Crawl" 
                $cs.StartIncrementalCrawl() 
                Write-Host "Incremental Crawl Started" 
            } 
        default 
            { 
                Write-Host "Stop Crawl" 
                $cs.StopCrawl() 
                Write-Host "Crawl Stopped" 
            } 
        } 
	}
}

function Set-SearchToPause {
	Add-PSSnapin "*Share*"
	$ssa = Get-EnterpriseSearchServiceApplication
	$ssa.pause()
}