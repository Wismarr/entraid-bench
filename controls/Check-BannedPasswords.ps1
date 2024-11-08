function Check-BannedPasswordSettings {
    [CmdletBinding()]
    param()

    try {

        $controlTitle = "Asegurese de que se utilicen listas personalizadas de claves prohibidas"
        $controlDescription = "Crear una nueva clave puede resultar dificil independientemente de los conocimientos tecnicos que se tengan. Es comun buscar sugerencias en el entorno al crear una clave; sin embargo, esto puede incluir elegir palabras especificas de la organizacion como inspiracion para una clave. Un adversario puede emplear lo que se llama un 'mangler' para crear permutaciones de estas palabras especificas en un intento de descifrar claves o hashes para facilitar el logro de su objetivo."
    
        # Retrieve the group setting
        $groupSetting = Get-MgGroupSetting

        # Find the "EnableBannedPasswordCheck" value
        $enableBannedPasswordCheckValue = $groupSetting.Values | Where-Object { $_.Name -eq "EnableBannedPasswordCheck" }

        # Check if EnableBannedPasswordCheck is enabled
        if ($enableBannedPasswordCheckValue -and $enableBannedPasswordCheckValue.Value -eq $true) {

            # Find the "BannedPasswordList" value
            $bannedPasswordListValue = $groupSetting.Values | Where-Object { $_.Name -eq "BannedPasswordList" }

            # Check if BannedPasswordList is empty
            if ($null -eq $bannedPasswordListValue.Value -or $bannedPasswordListValue.Value.Count -eq 0) {
                $controlFinding = "Custom banned passwords setting is enabled but the list of passwords is empty."
                return [PSCustomObject]@{
                    Control            = $controlTitle
                    ControlDescription = $controlDescription
                    Finding            = $controlFinding
                    Result             = "NOT COMPLIANT"
                }
            }
            else {            
                $controlFinding = "Custom banned passwords setting is enabled and the list of passwords is configured."
                return [PSCustomObject]@{
                    Control            = $controlTitle
                    ControlDescription = $controlDescription
                    Finding            = $controlFinding
                    Result             = "COMPLIANT"
                }
            }
        }
        else {
            $controlFinding = "Custom banned passwords setting is disabled."
            return [PSCustomObject]@{
                Control            = $controlTitle
                ControlDescription = $controlDescription
                Finding            = $controlFinding
                Result             = "NOT COMPLIANT"
            }
        }
    }
    catch {
        Write-Error "An error occurred while checking the settings: $_"
    }
}

# Call the function to check the settings
Check-BannedPasswordSettings