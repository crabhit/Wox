$currentPath = Convert-Path .
Write-Host "Current path: " + $currentPath

$path = $env:APPVEYOR_BUILD_FOLDER + "\Deploy\wox.nuspec"
Write-Host "nuspec path: " + $path
$basePath = $env:APPVEYOR_BUILD_FOLDER + "\Output\Release"
& nuget pack $path -Version $env:APPVEYOR_BUILD_VERSION -Properties Configuration=Release -BasePath $basePath

$nupkgPath = $env:APPVEYOR_BUILD_FOLDER + "\Wox." + $env:APPVEYOR_BUILD_VERSION + ".nupkg"
Write-Host "nupkg path: " + $nupkgPath

# must use Squirrel.com, Squirrel.exe will produce nothing 
$squirrelPath = $env:APPVEYOR_BUILD_FOLDER + "\packages\squirrel*\tools\Squirrel.com"
Write-Host "squirrel path: " + $squirrelPath
& $squirrelPath --releasify $nupkgPath
