
Write-Host "Welcome to Update-SmtpCredentials.ps1"
Write-Host "This is a helper script to update the config file with new Credentials so that we can use them to send an email."
Write-Host "Please remember, The user account that runs this process will be the only one who can decrypt the string."
Write-Host ""
Write-Host "Script is being ran as $($env:USERDOMAIN)\$($Env:USERNAME)"

# Get the creds
Write-Host "Please enter the email address and password for the account you want to use."
$Creds = Get-Credential

# Convert it to text
$SecurePWAsText = $Creds.Password | ConvertFrom-SecureString

Write-Host "Enter the location of the config.json file."
Write-Host "If you leave this empty I will check '.\config.json'"

# Get User input
$Config = Read-Host 

$json | Out-Null

if ( [System.IO.File]::Exists($Config) -eq $false ) {

    # Generate the json format
    $json = @{
        Smtp = @{
            Debug = @{
                Credentials = @{
                    Username = ""
                    Password = ""
                    GeneratedBy = ""
                }
            }
            Prod = @{
                Credentials = @{
                    Username = ""
                    Password = ""
                    GeneratedBy = ""
                }
            }
        }
    }

} else {
    # Read the Json File
    $json = Get-Content -Path $Config | ConvertFrom-Json
}

# Update the json in memory
$Mode = Read-Host -Prompt "Are we going to edit Debug or Prod Credentials?"
switch ($Mode.ToLower()) {
    "debug" {
        $json.Smtp.Debug.Credentials.UserName = $Creds.UserName
        $json.Smtp.Debug.Credentials.Password = $SecurePWAsText
        $json.Smtp.Debug.Credentials.GeneratedBy = "$($env:USERDOMAIN)\$($Env:USERNAME)"
    }
    "prod" {
        $json.Smtp.Prod.Credentials.UserName = $Creds.UserName
        $json.Smtp.Prod.Credentials.Password = $SecurePWAsText
        $json.Smtp.Prod.Credentials.GeneratedBy = "$($env:USERDOMAIN)\$($Env:USERNAME)"
    }
}

# Write the changes to the config
$json | ConvertTo-Json | Set-Content $Config

