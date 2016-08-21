﻿[CmdletBinding()]
param
()

################## Some Globals 
write-verbose "trying to get os type"

if ($env:TERM_PROGRAM)
	{
	write-verbose "supposed to be on Linux or vmware"
	if ($env:TERM_PROGRAM -match "Apple_Terminal")
		{
		write-Verbose "looks like vmxtoolkit is running on osx"
		}
	else	
		{
		write-warning "unsuppoted os"
		exit
		}
	}
else
{
write-verbose "running windows"


write-verbose "getting VMware Path from Registry"
if (!(Test-Path "HKCR:\")) { $NewPSDrive = New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT }
if (!($VMWAREpath = Get-ItemProperty HKCR:\Applications\vmware.exe\shell\open\command -ErrorAction SilentlyContinue))
{
	Write-Error "VMware Binaries not found from registry"; Break
}
$Global:vmxdir = split-path $PSScriptRoot
$VMWAREpath = Split-Path $VMWAREpath.'(default)' -Parent
$VMWAREpath = $VMWAREpath -replace '"', ''
$Global:vmwarepath = $VMWAREpath
$Global:vmware = "$VMWAREpath\vmware.exe"
$Global:vmrun = "$VMWAREpath\vmrun.exe"
$vmwarefileinfo = Get-ChildItem $Global:vmware
# if (Test-Path "$env:appdata\vmware\inventory.vmls")
#{
$Global:vmxinventory = "$env:appdata\vmware\inventory.vmls"
#}
# End VMWare Path
$Global:VMrunErrorCondition = @(
  "Waiting for Command execution Available",
  "Error",
  "Unable to connect to host.",
  "Error: Unable to connect to host.",
  "Error: The operation is not supported for the specified parameters",
  "Unable to connect to host. Error: The operation is not supported for the specified parameters",
  "Error: The operation is not supported for the specified parameters",
  "Error: vmrun was unable to start. Please make sure that vmrun is installed correctly and that you have enough resources available on your system.",
  "Error: The specified guest user must be logged in interactively to perform this operation",
  "Error: A file was not found",
  "Error: VMware Tools are not running in the guest",
  "Error: The VMware Tools are not running in the virtual machine" )
$Global:vmwareversion = New-Object System.Version($vmwarefileinfo.VersionInfo.ProductMajorPart,$vmwarefileinfo.VersionInfo.ProductMinorPart,$vmwarefileinfo.VersionInfo.ProductBuildPart,$vmwarefileinfo.VersionInfo.ProductVersion.Split("-")[1])
# $Global:vmwareMajor = $vmwarefileinfo.VersionInfo.ProductMajorPart
# $Global:vmwareMinor = $vmwarefileinfo.VersionInfo.ProductMinorPart
# $Global:vmwareBuild = $vmwarefileinfo.VersionInfo.ProductBuildPart
# $Global:vmwareversion = $vmwarefileinfo.VersionInfo.ProductVersion
}

