
function Test-AuthenticationStrength {
    [CmdletBinding()]
    param()

    try {

        $controlTitle = "Asegurese de que los administradores requieran una 'fortaleza MFA resistente al phishing'"
        $controlDescription = "La fuerza de la autenticacion es un control de acceso condicional que permite a los administradores especificar qué combinacion de metodos de autenticacion se pueden utilizar para acceder a un recurso. Por ejemplo, pueden hacer que sólo esten disponibles metodos de autenticacion resistentes al phishing para acceder a un recurso confidencial. Pero para acceder a un recurso no confidencial, pueden permitir combinaciones de autenticacion multifactor (MFA) menos seguras, como clave + SMS. Microsoft tiene tres puntos fuertes de autenticacion integrados. Fortaleza de MFA, fortaleza de MFA sin clave y fortaleza de MFA resistente a phishing. Asegurese de que los roles de administrador utilicen una politica de CA con solidez de MFA resistente al phishing."

        # Retrieve all Conditional Access policies
        $policies = Get-MgIdentityConditionalAccessPolicy | Sort-Object DisplayName

        foreach ($policy in $policies) {
            $authenticationStrength = $policy.GrantControls.AuthenticationStrength

            if ($authenticationStrength.id -eq "00000000-0000-0000-0000-000000000004") {
                # Phishing-resistant MFA Authentication strength is enabled, output details and stop
                $controlFinding = "La fortaleza de MFA resistente al phishing está habilitada para los administradores."
                $controlResult = "EN CUMPLIMIENTO"

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
        $controlFinding = "No se encontraron politicas con fortaleza MFA resistente al phishing para administradores."
        $controlResult = "NO CUMPLE"

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