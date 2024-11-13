function Test-PermanentActiveAssignments {
    [CmdletBinding()]
    param()

    try {

        $controlTitle = "Ensure 'Privileged Identity Management' is used to manage roles"
        $controlDescription = "Azure Active Directory Privileged Identity Management can be used to audit roles, allow just in time activation of roles and allow for periodic role attestation. Organizations should remove permanent members from privileged Office 365 roles and instead make them eligible, through a JIT activation workflow."

        # Get permanent (no endDateTime) active role assignments
        $permanentActiveAssignments = Get-MgRoleManagementDirectoryRoleAssignmentScheduleInstance | Where-Object { $null -eq $_.EndDateTime } | Select-Object AssignmentType, PrincipalId, RoleDefinitionId, StartDateTime, EndDateTime
    
        $users = Get-MgUser -Property Id, DisplayName -CountVariable CountVar -All
        $roles = Get-MgRoleManagementDirectoryRoleDefinition -Property Id, DisplayName
    
        $userIdNameMap = @{}
        foreach ($user in $users) {
            $userIdNameMap[$user.Id] = $user.DisplayName
        }
    
        $roleIdNameMap = @{}
        foreach ($role in $roles) {
            $roleIdNameMap[$role.Id] = $role.DisplayName
        }

        if ($permanentActiveAssignments) {
            $controlFinding = "Permanent active role assignments found."
            
            $FindingDetails = $permanentActiveAssignments | ForEach-Object {
                [PSCustomObject]@{
                    AssignmentType = $_.AssignmentType
                    PrincipalName = $userIdNameMap[$_.PrincipalId]
                    PrincipalId = $_.PrincipalId
                    RoleDefinition = $roleIdNameMap[$_.RoleDefinitionId]
                    RoleDefinitionId = $_.RoleDefinitionId
                    StartDateTime = $_.StartDateTime
                    EndDateTime = $_.EndDateTime
                }
            }
            $FindingDetails | Export-Csv -Path "PermanentActiveAssignments.csv" -NoTypeInformation
            return [PSCustomObject]@{
                Control            = $controlTitle
                ControlDescription = $controlDescription
                Finding            = $controlFinding
                Result             = "NOT COMPLIANT"
                FindingDetails     = "Please visit the PermanentActiveAssignments.csv"
                <# FindingDetails     = $permanentActiveAssignments | ForEach-Object {
                    Write-Host "AssignmentType: $($_.AssignmentType)"
                    Write-Host "Principal: $($userIdNameMap[$_.PrincipalId])"
                    Write-Host "RoleDefinition: $($roleIdNameMap[$_.RoleDefinitionId])"
                    Write-Host "StartDateTime: $($_.StartDateTime)"
                    Write-Host "EndDateTime: $($_.EndDateTime)`n"
                } #>
            }
            
        }
        else {
            $controlFinding = "No permanent active role assignments found."

            return [PSCustomObject]@{
                Control            = $controlTitle
                ControlDescription = $controlDescription
                Finding            = $controlFinding
                Result             = "COMPLIANT"
            }
        }
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}

# Usage in your scripts:
Check-PermanentActiveAssignments
