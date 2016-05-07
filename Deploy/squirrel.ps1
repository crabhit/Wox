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

$squirrel_path = $env:APPVEYOR_BUILD_FOLDER + "\packages\squirrel*\tools\Squirrel.exe"
Write-Host "squirrel path: " + $squirrel_paths
& $squirrel_path --releasify $nupkgPath


Write-Host "===================================================="
& ls
Write-Host "===================================================="

Write-Host "===================================================="
& ls $basePath
Write-Host "===================================================="



Write-Host "===================================================="
$releases = $env:APPVEYOR_BUILD_FOLDER + "\Releases"
& ls $releases
Write-Host "===================================================="