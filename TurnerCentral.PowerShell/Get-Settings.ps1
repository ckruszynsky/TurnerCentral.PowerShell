#
# Process_Settings.ps1
#

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