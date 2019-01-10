# Update-SmtpCredentials

## Description

This is a helper script to update my config files for stored credentials.  This one currently is focused on SMTP but could be worked to support other services.

## Settings Format

For this to work you will need to format your settings json with the following data structure.

``` json
{
    "Smtp":  {
        "Debug" : {
            "To":  "IT_Alerts@directorsmortgage.net",
            "From":  "AD@directorsmortgage.net",
            "Server":  "smtp.office365.com",
            "Port":  587,
            "Credentials":  {
                    "UserName":"", 
                    "Password": "",
                    "GeneratedBy": ""
               }
        },
        "Prod" : {
            "To":  "IT_Alerts@directorsmortgage.net",
            "From":  "AD@directorsmortgage.net",
            "Server":  "smtp.office365.com",
            "Port":  587,
            "Credentials":  {
                    "UserName":"", 
                    "Password": "",
                    "GeneratedBy": ""
               }
        }
    }
}
```

Doing this you will be able to define the entire mail flow depending on if you are in a debug or prod mode.  

## ChangeLog

https://www.pdq.com/blog/secure-password-with-powershell-encrypting-credentials-part-1/

V2
Added Support for Debug and Prod emails
Take note of the json update above.
