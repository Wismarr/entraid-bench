function Check-DynamicGroupForGuestUsers {
    [CmdletBinding()]
    param()

    try {

        $controlTitle = "Asegurese de que se cree un grupo dinámico para usuarios invitados"
        $controlDescription = "Un grupo dinamico es una configuracion dinamica de pertenencia a un grupo de seguridad para Azure Active Directory. Los administradores pueden establecer reglas para completar grupos creados en Azure AD en funcion de los atributos del usuario (como tipo de usuario, departamento o pais/region). Los miembros se pueden agregar o eliminar automaticamente de un grupo de seguridad según sus atributos. El estado recomendado es crear un grupo dinamico que incluya cuentas de invitados."

        # Get all groups with dynamic membership
        $groups = Get-MgGroup | Where-Object { $_.GroupTypes -contains "DynamicMembership" }

        # Filter dynamic groups for guest users
        $guestDynamicGroups = $groups | Where-Object { $_.MembershipRule -like "*user.userType -eq `"`Guest`"*" }
        $allUsersDynamicGroups = $groups | Where-Object { $_.MembershipRule -notlike "*user.userType -eq `"`All Users`"*" }

        if ($guestDynamicGroups) {
            $controlFinding = "Se encontro un grupo dinamico para usuarios invitados."
            $controlResult = "EN CUMPLIMIENTO"
            $findingDetails = $guestDynamicGroups | Select-Object DisplayName, GroupTypes, MembershipRule
        }
        elseif ($allUsersDynamicGroups) {
            $controlFinding = "Grupo dinamico para todos los usuarios encontrados."
            $controlResult = "EN CUMPLIMIENTO"
            $findingDetails = $allUsersDynamicGroups | Select-Object DisplayName, GroupTypes, MembershipRule
        }
        else {
            $controlFinding = "No se encontro ningún grupo dinamico para usuarios invitados."
            $controlResult = "NO CUMPLE"
            $findingDetails = $notguestDynamicGroups | Select-Object DisplayName, GroupTypes, MembershipRule
        }

        return [PSCustomObject]@{
            Control                     = $controlTitle
            ControlDescription          = $controlDescription
            Finding                     = $controlFinding
            DynamicGroupName            = $findingDetails.DisplayName
            DynamicGroupTypes           = $findingDetails.GroupTypes
            DynamicGroupMembershipRule  = $findingDetails.MembershipRule
            Result                      = $controlResult
        }

    }
    catch {
        Write-Error "An error occurred: $_"
    }
}


# Usage in your scripts:
Check-DynamicGroupForGuestUsers