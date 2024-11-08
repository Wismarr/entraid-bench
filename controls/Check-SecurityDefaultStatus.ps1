function Check-SecurityDefaultStatus {
    [CmdletBinding()]
    param()

    try {

        $controlTitle = "Asegurese de que los valores predeterminados de seguridad estén deshabilitados en Azure Active Directory"
        $controlDescription = "Los valores predeterminados de seguridad proporcionan configuraciones predeterminadas seguras que se administran en nombre de las organizaciones para mantener a los clientes seguros hasta que estén listos para administrar sus propias configuraciones de seguridad de identidad.
        Por ejemplo, haciendo lo siguiente:
        • Requerir que todos los usuarios y administradores se registren en MFA.
        • Desafiar a los usuarios con MFA, principalmente cuando aparecen en un nuevo dispositivo o aplicación, pero más a menudo para roles y tareas criticas.
        • Deshabilitar la autenticacion de clientes de autenticacion heredados, que no pueden realizar MFA."

        # Get Security Defaults policy and check if it's disabled
        $securityDefaultsPolicy = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy | Select-Object -ExpandProperty IsEnabled

        if ($securityDefaultsPolicy -eq $true) {
            $controlFinding = "Security Defaults are enabled."
            $controlResult = "NOT COMPLIANT"
        }
        else {
            $controlFinding = "Security Defaults are disabled."
            $controlResult = "COMPLIANT"
        }

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

# Usage in your scripts:
Check-SecurityDefaultStatus