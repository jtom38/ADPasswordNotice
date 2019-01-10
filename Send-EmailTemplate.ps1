function Send-EmailTemplate {
    param (
        [string] $To,
        [string] $Subject
    )
    
    Process {

        $html = Get-Content -Path .\PasswordExpires.html
        $HtmlBody = Convert-ArrayToString -Array $html -AppendValue "`r`n"

        $json = Get-Content -Path .\config.json | ConvertFrom-Json

        if ( $json.DebugMode -eq $true ) {

            $username = $Json.Smtp.Debug.Credentials.UserName
            $pw = $($Json.Smtp.Debug.Credentials.Password | ConvertTo-SecureString )
            $EmailCredentials = New-Object System.Management.Automation.PSCredential( $username, $pw )

            try {
                Send-MailMessage -To $To `
                -From $Json.Smtp.Debug.From `
                -Subject $Subject `
                -Priority High `
                -Body $HtmlBody `
                -SmtpServer $json.Smtp.Debug.Server `
                -Port $json.Smtp.Debug.Port `
                -Credential $EmailCredentials `
                -BodyAsHtml `
                -UseSsl

                $Script:Logger.Info("Email was sent to $To about password expiring")
            }
            catch {
                $Script:Logger.Error("Email was not sent to $To.")
            }

        }
        else {
            $username = $Json.Smtp.Prod.Credentials.UserName
            $pw = $($Json.Smtp.Prod.Credentials.Password | ConvertTo-SecureString )
            $EmailCredentials = New-Object System.Management.Automation.PSCredential( $username, $pw )

            try {
                Send-MailMessage -To $To `
                -From $Json.Smtp.Debug.From `
                -Subject $Subject `
                -Priority High `
                -Body $HtmlBody `
                -SmtpServer $json.Smtp.Prod.Server `
                -Port $json.Smtp.Prod.Port `
                -Credential $EmailCredentials `
                -BodyAsHtml `
                -UseSsl

                $Script:Logger.Info("Email was sent to $To about password expiring")
            }
            catch {
                $Script:Logger.Error("Email was not sent to $To.")
            }

        }


    }

}