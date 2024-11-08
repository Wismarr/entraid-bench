function Check-PermanentActiveAssignments {
    [CmdletBinding()]
    param()

    try {

        $controlTitle = "Asegúrese de que se utilice 'Gestion de identidad privilegiada' para gestionar roles"
        $controlDescription = "Azure Active Directory Privileged Identity Management se puede utilizar para auditar roles, permitir la activación de roles justo a tiempo y permitir la certificacion periodica de roles. Las organizaciones deben eliminar a los miembros permanentes de los roles privilegiados de Office 365 y, en su lugar, hacerlos elegibles, a traves de un flujo de trabajo de activación JIT."

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
