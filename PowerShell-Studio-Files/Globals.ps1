

#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------


#Sample function that provides the location of the script
function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}

#Sample variable that provides the location of the script
[string]$ScriptDirectory = Get-ScriptDirectory

# Test RunAs function is listed below this line. Testing section of script to see if app can be run with elevated priviledges without further work-arounds.

function Global:Use-RunAs
{
	# Test if script is running as Adminstrator and if not use RunAs
	# -Check ( Return true if Administrator )
	
	param ([Switch]$Check)
	
	$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
	
	if ($Check) { return $IsAdmin }
	
	if ($MyInvocation.ScriptName -ne "")
	{
		if (-not $IsAdmin)
		{
			try
			{
				$arg = "-executionpolicy bypass -windowstyle hidden -sta -file `"$($MyInvocation.ScriptName)`" $env:UserName $env:UserName"
				Start-Process "$psHome\powershell.exe" -Verb Runas -ArgumentList $arg -ErrorAction 'stop'
			}
			catch
			{
				Write-Warning "Error - Failed to run script.... Credential problem?"
				break
			}
			exit # Quit this session of powershell
		}
	}
	else
	{
		Write-Warning "Error - Script must be saved as a .ps1 file first"
		break
	}
}

#End of test script code. delete it if it does not solve issues


