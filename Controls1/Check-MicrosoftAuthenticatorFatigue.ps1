
function Check-MicrosoftAuthenticatorFatigue {
    [CmdletBinding()]
    param()

    try {

        $controlTitle = "Asegurese de que Microsoft Authenticator este configurado para proteger contra la fatiga de MFA"
        $controlDescription = "Microsoft ha publicado configuraciones adicionales para mejorar la configuracion de la aplicacion Microsoft Authenticator. Estas configuraciones brindan informacion adicional y contexto a los usuarios que reciben solicitudes push y sin clave de MFA, como la ubicacion geográfica de donde proviene la solicitud, la aplicacion solicitante y la solicitud de una coincidencia numerica. Asegurese de que lo siguiente este habilitado.
        • Requerir coincidencia de números para notificaciones automáticas
        • Mostrar el nombre de la aplicación en notificaciones push y sin contraseña
        • Mostrar ubicación geográfica en notificaciones push y sin contraseña"
    
        # Retrieve configuration for Microsoft Authenticator
        $authenticatorConfig = Get-MgPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -AuthenticationMethodConfigurationId MicrosoftAuthenticator
        
        # Check if Microsoft Authenticator is disabled
        if ($authenticatorConfig.State -eq "disabled") {
            $controlFinding = "Microsoft Authenticator esta deshabilitado."

            return [PSCustomObject]@{
                Control               = $controlTitle
                ControlDescription    = $controlDescription
                Finding               = $controlFinding
                Result                = "NO CUMPLE"
            }
        } 
        
        # if Microsoft Authenticator is enabled, check for MFA fatigue resistance settings
        $featureSettings = $authenticatorConfig.AdditionalProperties.featureSettings
        $numberMatchingRequiredState = $featureSettings.numberMatchingRequiredState
        $displayLocationInformationRequiredState = $featureSettings.displayLocationInformationRequiredState
        $displayAppInformationRequiredState = $featureSettings.displayAppInformationRequiredState

        if ($numberMatchingRequiredState.State -eq "enabled" -And $displayLocationInformationRequiredState.State -eq "enabled" -And $displayAppInformationRequiredState.State -eq "enabled" ) {
            $controlFinding = "Microsoft Authenticator esta configurado para ser resistente a la fatiga de MFA."

            return [PSCustomObject]@{
                Control               = $controlTitle
                ControlDescription    = $controlDescription
                Finding               = $controlFinding
                Result                = "EN CUMPLIMIENTO"
            }

        } else {
            $controlFinding = "Microsoft Authenticator no esta configurado para ser resistente a la fatiga de MFA."

            return [PSCustomObject]@{
                Control               = $controlTitle
                ControlDescription    = $controlDescription
                Finding               = $controlFinding
                Result                = "NO CUMPLE"
            }
             
        }

    } catch {
        Write-Error "An error occurred: $_"
    }
}


# Usage in your scripts:
Check-MicrosoftAuthenticatorFatigue