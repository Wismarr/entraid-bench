function Test-OnPremisesSync {
    [CmdletBinding()]
    param()

    try {

        $controlTitle = "Asegurese de que la sincronizacion de hash de clave este habilitada para implementaciones hibridas"
        $controlDescription = "La sincronizacion de hash de claves ayuda a reducir la cantidad de claves que sus usuarios deben mantener a solo una y permite la deteccion de credenciales filtradas para sus cuentas hibridas. La proteccion de credenciales filtradas se aprovecha a traves de Azure AD Identity Protection y es un subconjunto de esa caracteristica que puede ayudar a identificar si las claves de las cuentas de usuario de una organizacion han aparecido en la web oscura o en espacios publicos. El uso de otras opciones para la sincronizacion de su directorio puede ser menos resistente, ya que Microsoft aun puede procesar inicios de sesion en 365 con Hash Sync incluso si no hay disponible una conexion de red a su entorno local."
    
        $organization = Get-MgOrganization
        $OnPremisesSyncEnabled = $organization.OnPremisesSyncEnabled
        $OnPremisesLastSyncDateTime = $organization.OnPremisesLastSyncDateTime

        if ($OnPremisesSyncEnabled) {
            $controlFinding = "La sincronizacion local está habilitada."
            $complianceResult = "EN CUMPLIMIENTO"
        } else {
            $controlFinding = "La sincronizacion local no esta habilitada."
            $complianceResult = "NO CUMPLE"
        }

        return [PSCustomObject]@{
            Control               = $controlTitle
            ControlDescription    = $controlDescription
            Finding               = $controlFinding
            OnPremisesSyncEnabled = $OnPremisesSyncEnabled
            LastSyncDateTime      = $OnPremisesLastSyncDateTime
            Result                = $complianceResult
        }
    
    } catch {
        Write-Error "An error occurred: $_"
    }
}


# Usage in your scripts:
Test-OnPremisesSync