Write-Host "===================================================="
& ls
Write-Host "===================================================="


$currentPath = Convert-Path .
Write-Host "Current path: " + $currentPath

$path = $env:APPVEYOR_BUILD_FOLDER + "\Deploy\wox.nuspec"
Write-Host "nuspec path: " + $path
$basePath = $env:APPVEYOR_BUILD_FOLDER + "\Output\Release"
& nuget pack $path -Version $env:APPVEYOR_BUILD_VERSION -Properties Configuration=Release -BasePath $basePath

$nupkgPath = "Wox." + $env:APPVEYOR_BUILD_VERSION + ".nupkg"
Write-Host "nupkg path: " + $nupkgPath
& squirrel --releasify $nupkgPath


Write-Host "===================================================="
& ls
Write-Host "===================================================="
