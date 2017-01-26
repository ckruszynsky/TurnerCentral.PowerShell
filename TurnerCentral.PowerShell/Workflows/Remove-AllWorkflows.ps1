#
# Remove_AllWorkflows.ps1
#
param(
	$siteUrl,
	$listName 
)

Site URL
$web = Get-SPWeb $siteUrl
$web.AllowUnsafeUpdates = $true;    

#List Name
$list = $web.Lists[$listName];

# Iterate through all Items in List and all Workflows on Items.         
foreach ($item in $list.Items) {
	foreach ($wf in $item.Workflows) {
		#Cancel Workflows        
		[Microsoft.SharePoint.Workflow.SPWorkflowManager]::CancelWorkflow($wf);      
	}
}

$web.Dispose();
