Write-Host "===================================================="
& ls
Write-Host "===================================================="


$currentPath = Convert-Path .
Write-Host "Current path: " + $currentPath

$path = $env:APPVEYOR_BUILD_FOLDER + "\Deploy\wox.nuspec"
Write-Host "nuspec path: " + $path
$basePath = $env:APPVEYOR_BUILD_FOLDER + "\Output\Release"
& nuget pack $path -Version $env:APPVEYOR_BUILD_VERSION -Properties Configuration=Release -BasePath $basePath

$nupkgPath = $env:APPVEYOR_BUILD_FOLDER + "\Wox." + $env:APPVEYOR_BUILD_VERSION + ".nupkg"
Write-Host "nupkg path: " + $nupkgPath

$squirrelPath = $env:APPVEYOR_BUILD_FOLDER + "\packages\squirrel.windows.1.4.0\tools\Squirrel.exe"
Write-Host "squirrel path: " + $squirrelPath
$releasesPath = $env:APPVEYOR_BUILD_FOLDER + "\Releases"
Write-Host "release path: " + $releasesPath
$cmd = $squirrelPath + " --releasify " + $nupkgPath + " --releaseDir " + $releasesPath
Write-Host "cmd: " + $cmd

& $squirrelPath --releasify $nupkgPath --releaseDir $releasesPath


Write-Host "===================================================="
& ls
Write-Host "===================================================="

Write-Host "===================================================="

& ls $releasesPath
Write-Host "===================================================="