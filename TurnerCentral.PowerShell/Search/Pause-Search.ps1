#
# Pause_Search.ps1
#

param
(
)


Add-PSSnapin "*Share*"

$ssa = Get-EnterpriseSearchServiceApplication
$ssa.pause()