
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

Import-Module .\PsLog\PsLog.psm1 -Force
. .\PsLog\PSLogClasses.ps1 -Force

$logger = [PSLog]::new()
$logger.CsvConfig = [PSLogCsv]::new(".\config.json")
$logger.ConsoleConfig = [PSLogConsole]::new(".\config.json")

$logger.Info("Logging Enabled")

. .\Send-EmailTemplate.ps1
. .\Convert-ArrayToString.ps1

$json = Get-Content -Path .\config.json | ConvertFrom-Json

# Get the domain password policy
$PasswordMaxAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days

# Define when we want to send a notice
$in14Days = [datetime]::Now.AddDays(14 - $PasswordMaxAge).ToShortDateString()
$in7Days = [datetime]::Now.AddDays(7 - $PasswordMaxAge).ToShortDateString()
$Tomorrow = [datetime]::Now.AddDays(1 - $PasswordMaxAge).ToShortDateString()

foreach ( $ou in $json.OU ) {

    $logger.Info("Checking for users in: $ou")    

    $users = Get-AdUser -Filter {Enabled -eq $true -and PasswordNeverExpires -eq $false -and PasswordLastSet -gt 0} -Properties *  -SearchBase $ou

    foreach ( $u in $users) {

        # Get when the user last changed there password    
        $PasswordLastSet = $u.PasswordLastSet.ToShortDateString()

        if ( $PasswordLastSet -eq $in14Days ) {
            $logger.Info("$($u.UserPrincipalName)'s password expires in 14 days.  Send notice")

            Send-EmailTemplate -To $u.UserPrincipalName `
                -Subject "Your password expires in 14 days!"
        }

        if ( $PasswordLastSet -eq $in7Days ) {
            $logger.Info("$($u.UserPrincipalName)'s password expires in 07 days.  Send notice")

            Send-EmailTemplate -To $u.UserPrincipalName `
                -Subject "Your password expires in 7 days!"
        }

        if ( $PasswordLastSet -eq $Tomorrow ) {
            $logger.Info("$($u.UserPrincipalName)'s password expires in 01 day.  Send notice")            
            
            Send-EmailTemplate -To $u.UserPrincipalName `
                -Subject "Your password expires in 1 day!"
        }
    }

}

$logger.Info("Script has finished.")