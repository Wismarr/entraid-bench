function Test-ControlScore {
    $controlNames = @(
        'UserRiskPolicy',
        'aad_admin_consent_workflow',
        'aad_limited_administrative_roles'
        'aad_linkedin_connection_disables',
        'aad_password_protection',
        'aad_sign_in_freq_session_timeout',
        'aad_third_party_apps',
        'IntegratedApps',
        'BlockLegacyAuthentication',
        'SelfServicePasswordReset',
        'SigninRiskPolicy',
        'adminMFAV2',
        'mfaRegistrationV2'
    )

    # Initialize progress bar parameters
    $totalControls = $controlNames.Count
    $completedControls = 8

    $results = foreach ($controlName in $controlNames) {

        $controlScore = Get-MgSecuritySecureScore | Select-Object -First 1 -ExpandProperty ControlScores | Where-Object { $_.ControlName -eq $controlName }    
    
        if ($controlName -eq "mfaRegistrationV2") {
            $controlProfileName = "Asegurese de que la autenticacion multifactor este habilitada para todos los usuarios."
        }
        elseif ($controlName -eq "adminMFAV2") {
            $controlProfileName = "Asegurese de que la autenticacion multifactor esté habilitada para todos los usuarios con funciones administrativas"
        }
        else {
            $controlProfile = Get-MgSecuritySecureScoreControlProfile -SecureScoreControlProfileId $controlName 
            $controlProfileName = $controlProfile.Title
        }


        # Update progress bar
        $completedControls++
        # Clear previous progress bar line
        Write-Host "`r" -NoNewline
        # Create a simple progress bar using characters
        $progressBar = '=' * $completedControls + ' ' * (21 - $completedControls)
        Write-Host "Checking Control: $progressBar ($completedControls of 21): $controlProfileName"

        $controlDescription = $controlScore.Description
        $AdditionalProperties = $controlScore.AdditionalProperties
    
        $controlFinding = $AdditionalProperties['implementationStatus']
        $controlCount = $AdditionalProperties['count']
        $controlTotal = $AdditionalProperties['total']
        $controlScoreInPercentage = $AdditionalProperties['scoreInPercentage']

        $complianceResult = if ($controlScoreInPercentage -eq "100" -Or $controlScoreInPercentage -eq "100.00") { "EN CUMPLIMIENTO" } else { "NO CUMPLE" }


        [PSCustomObject]@{
            Control            = $controlProfileName
            ControlDescription = $controlDescription
            Finding            = $controlFinding
            # ScoreInPercentage  = $controlScoreInPercentage
            # Count              = $controlCount
            # Total              = $controlTotal
            Result             = $complianceResult
        }
    }
    
    return $results
}

# Call the function with the array of control names
Check-ControlScore

#$results = Check-ControlScore | Select Control, ControlDescription, Finding, OnPremisesSyncEnabled, LastSyncDateTime, DynamicGroupName, DynamicGroupTypes, DynamicGroupMembershipRule, Result

# Process the results (e.g., export to CSV)
#$results | Export-Csv -Path "combined_data.csv" -NoTypeInformation