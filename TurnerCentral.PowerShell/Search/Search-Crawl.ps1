#
# Search_Crawl.ps1
# Starts, Stops, or performs a full crawl of the specified site collection depending 
# on the parameter passed 
#
# Example: Search-Crawl "http://foo" "full"  --starts the search engine in full crawl mode for all sources
#          Search-Crawl "http://foo" "Incremental" --starts the search engine crawl in incremental mode 
#		   Search-Crawl "http://foo" "Stop" -stops the search engine crawl for all sources
#
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