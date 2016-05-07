$path = $env:APPVEYOR_BUILD_FOLDER + "\Deploy\wox.plugin.nuspec"

$current_path = Convert-Path .
Write-Host "Current path: " + $current_path
Write-Host "Target path: " + $path

& nuget pack $path -Version $env:APPVEYOR_BUILD_VERSION -Properties Configuration=Release

& squirrel --releasify "Wox." + $env:APPVEYOR_BUILD_VERSION + ".nupkg"