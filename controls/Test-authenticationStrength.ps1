
function Test-AuthenticationStrength {
    [CmdletBinding()]
    param()

    try {

        $controlTitle = "Ensure 'Phishing-resistant MFA strength' is required for Administrators"
        $controlDescription = "Authentication strength is a Conditional Access control that allows administrators to specify which combination of authentication methods can be used to access a resource. For example, they can make only phishing-resistant authentication methods available to access a sensitive resource. But to access a non-sensitive resource, they can allow less secure multifactor authentication (MFA) combinations, such as password + SMS. Microsoft has 3 built-in authentication strengths. MFA strength, Passwordless MFA strength, and Phishing-resistant MFA strength. Ensure administrator roles are using a CA policy with Phishing-resistant MFA strength."

        # Retrieve all Conditional Access policies
        $policies = Get-MgIdentityConditionalAccessPolicy | Sort-Object DisplayName

        foreach ($policy in $policies) {
            $authenticationStrength = $policy.GrantControls.AuthenticationStrength

            if ($authenticationStrength.id -eq "00000000-0000-0000-0000-000000000004") {
                # Phishing-resistant MFA Authentication strength is enabled, output details and stop
                $controlFinding = "Phishing-resistant MFA strength is enabled for administrators."
                $controlResult = "COMPLIANT"

                return [PSCustomObject]@{
                    Control                  = $controlTitle
                    ControlDescription       = $controlDescription
                    DisplayName              = $policy.DisplayName
                    Id                       = $policy.Id
                    ModifiedDateTime         = $policy.ModifiedDateTime
                    State                    = $policy.State
                    Finding                  = $controlFinding
                    AuthenticationStrength   = $authenticationStrength.DisplayName
                    AuthenticationStrengthId = $authenticationStrength.id
                    Result                   = $controlResult
                }
            }
        }

        # No policies with phishing-resistant MFA strength found for administrators
        $controlFinding = "No policies with phishing-resistant MFA strength found for administrators."
        $controlResult = "NOT COMPLIANT"

        return [PSCustomObject]@{
            Control            = $controlTitle
            ControlDescription = $controlDescription
            Finding            = $controlFinding
            Result             = $controlResult
        }
    
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}


# Call the function and capture output
#$results = Check-authenticationStrength | select Control, ControlDescription, Finding, Result
Test-AuthenticationStrength 
# Export to CSV
#$results | Export-Csv -Path "Check-AuthenticationStrength.csv" -NoTypeInformation