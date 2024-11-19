function Check-SecurityDefaultStatus {
    [CmdletBinding()]
    param()

    try {

        $controlTitle = "Asegurese de que los valores predeterminados de seguridad esten deshabilitados en Azure Active Directory"
        $controlDescription = "Los valores predeterminados de seguridad proporcionan configuraciones predeterminadas seguras que se administran en nombre de las organizaciones para mantener a los clientes seguros hasta que estén listos para administrar sus propias configuraciones de seguridad de identidad.
        Por ejemplo, haciendo lo siguiente:
        • Requerir que todos los usuarios y administradores se registren en MFA.
        • Desafiar a los usuarios con MFA, principalmente cuando aparecen en un nuevo dispositivo o aplicacion, pero mas a menudo para roles y tareas criticas.
        • Deshabilitar la autenticacion de clientes de autenticacion heredados, que no pueden realizar MFA."

        # Get Security Defaults policy and check if it's disabled
        $securityDefaultsPolicy = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy | Select-Object -ExpandProperty IsEnabled

        if ($securityDefaultsPolicy -eq $true) {
            $controlFinding = "Los valores predeterminados de seguridad estan habilitados."
            $controlResult = "NO CUMPLE"
        }
        else {
            $controlFinding = "Los valores predeterminados de seguridad están deshabilitados."
            $controlResult = "EN CUMPLIMIENTO"
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