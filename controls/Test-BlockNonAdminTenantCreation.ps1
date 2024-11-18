function Test-BlockNonAdminTenantCreation {
    [CmdletBinding()]
    param()

    try {

        $controlTitle = "Asegurese de que 'Restringir la creacion de tenant a usuarios que no sean administradores' este configurado en 'Si'."
        $controlDescription = "Restringir la creacion de tenant evita la implementacion de recursos no autorizada o incontrolada y garantiza que la organizacion conserve el control sobre su infraestructura. La generacion de TI en la sombra por parte de los usuarios podría generar entornos multiples e inconexos que pueden dificultar que TI administre y proteja los datos de la organizacion, especialmente si otros usuarios de la organizacion comenzaron a utilizar estos inquilinos para fines comerciales bajo el malentendido de que estaban protegidos por la equipo de seguridad de la organizacion."
    
        # Get Default User Role Permissions
        $defaultUserRolePermissions = (Get-MgPolicyAuthorizationPolicy).DefaultUserRolePermissions

        # Check if 'Restrict non-admin users from creating tenants' is set to 'Yes'
        $allowedToCreateTenants = $defaultUserRolePermissions | Select-Object -ExpandProperty AllowedToCreateTenants

        if ($allowedToCreateTenants -eq "Yes") {
            $controlFinding =  "Los usuarios no administradores no pueden crear tenants"
            $controlResult = "EN CUMPLIMIENTO"
        } else {
            $controlFinding =  "Los usuarios no administradores NO tienen restricciones para crear Tenants"
            $controlResult = "NO CUMPLE"
        }

        return [PSCustomObject]@{
            Control               = $controlTitle
            ControlDescription    = $controlDescription
            Finding               = $controlFinding
            Result                = $controlResult
        }

    } catch {
        Write-Error "An error occurred: $_"
    }
}


# Usage in your scripts:
Test-BlockNonAdminTenantCreation