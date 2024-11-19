Write-Host @"

 ______     ______     __   __     ______     ______     __     __   __     
/\  ___\   /\  __ \   /\ "-.\ \   /\  ___\   /\  ___\   /\ \   /\ "-.\ \    
\ \ \____  \ \ \/\ \  \ \ \-.  \  \ \___  \  \ \  __\   \ \ \  \ \ \-.  \   
 \ \_____\  \ \_____\  \ \_\\"\_\  \/\_____\  \ \_____\  \ \_\  \ \_\\"\_\  
  \/_____/   \/_____/   \/_/ \/_/   \/_____/   \/_____/   \/_/   \/_/ \/_/  
                                                                            
    ______     __   __     ______   ______     ______                       
   /\  ___\   /\ "-.\ \   /\__  _\ /\  == \   /\  __ \                      
   \ \  __\   \ \ \-.  \  \/_/\ \/ \ \  __<   \ \  __ \                     
    \ \_____\  \ \_\\"\_\    \ \_\  \ \_\ \_\  \ \_\ \_\                    
     \/_____/   \/_/ \/_/     \/_/   \/_/ /_/   \/_/\/_/                    
                                                                            
 __     _____                                                               
/\ \   /\  __-.                                                             
\ \ \  \ \ \/\ \                                                            
 \ \_\  \ \____-                                                            
  \/_/   \/____/                                                            
                                                                            
 ______     __  __     ______     ______     __  __     ______     ______   
/\  ___\   /\ \_\ \   /\  ___\   /\  __ \   /\ \/\ \   /\  ___\   /\  __ \  
\ \ \____  \ \  __ \  \ \  __\   \ \ \/\_\  \ \ \_\ \  \ \  __\   \ \ \/\ \ 
 \ \_____\  \ \_\ \_\  \ \_____\  \ \___\_\  \ \_____\  \ \_____\  \ \_____\
  \/_____/   \/_/\/_/   \/_____/   \/___/_/   \/_____/   \/_____/   \/_____/

"@

# Install required AzureAD module
if (Get-Module -ListAvailable -Name Microsoft.Graph) {
    Write-Host "`nEl modulo Microsoft.Graph ya esta instalado." -ForegroundColor Green
} else {
    Write-Host "`nInstalacion del modulo Microsoft.Graph..." -ForegroundColor Cyan
    Install-Module -Name Microsoft.Graph -Scope CurrentUser
}

# Function to connect to Graph with connection check
function Connect-ToGraph {
    if (Get-MgContext) {
      Write-Host "`nYa conectado a Microsoft Graph." -ForegroundColor Green
    } else {
      Write-Host "`nConectando a Microsoft Graph..." -ForegroundColor Cyan
      try {
        Connect-MgGraph -Scopes @(
          'UserAuthenticationMethod.Read.All',
          'User.Read.All',
          'SecurityEvents.Read.All',
          'Policy.Read.All',
          'RoleManagement.Read.All',
          'AccessReview.Read.All'
        )
        Write-Host "`nConectado exitosamente." -ForegroundColor Green
      } catch {
        Write-Error "Error al conectarse a Graph: $_"
      }
    }
  }
  
Connect-ToGraph

Write-Host "`nEjecutando la herramienta de evaluacion de seguridad Microsoft Entra ID..." -ForegroundColor Green

# Specify the path to your script files
$scriptPath = "./controls"  # Replace with the actual path

# List available function names
$functionNames = Get-ChildItem -Path $scriptPath -Filter *.ps1 | ForEach-Object { $_.BaseName }

# Map control file names to titles
$functionTitleMappings = @{
    "Check-authenticationStrength" = "Asegurese de que los administradores requieran una 'fortaleza MFA resistente al phishing'"
    "Check-BannedPasswords" = "Asegurese de que se utilicen listas personalizadas de contraseñas prohibidas"
    "Check-BlockNonAdminTenantCreation" = "Asegurese de que 'Restringir la creacion de inquilinos a usuarios que no sean administradores' este configurado en 'Si'"
    "Check-DynamicGroupForGuestUsers" = "Asegurese de que se cree un grupo dinamico para usuarios invitados"
    "Check-MicrosoftAuthenticatorFatigue" = "Asegurese de que Microsoft Authenticator este configurado para proteger contra la fatiga de MFA"
    "Check-OnPremisesSync" = "Asegurese de que la sincronizacion de hash de clave o password este habilitada para implementaciones hibridas"
    "Check-PermanentActiveAssignments" = "Asegurese de que se utilice 'Gestion de identidad privilegiada' para gestionar roles"
    "Check-SecurityDefaultStatus" = "Asegurese de que los valores predeterminados de seguridad esten deshabilitados en Azure Active Directory"
}

# Initialize progress bar parameters
$totalControls = $functionNames.Count
$completedControls = 0


# Validate and execute the chosen function(s)
    $allResults = @()

    foreach ($functionName in $functionNames) {
        $functionTitle = $functionTitleMappings[$functionName]

            # Update progress bar
            $completedControls++
            # Clear previous progress bar line
            Write-Host "`r" -NoNewline
            # Create a simple progress bar using characters
            $progressBar = '=' * $completedControls + ' ' * (21 - $completedControls)
            Write-Host "Punto de Control: $progressBar ($completedControls de 21): $functionTitle"

        $currentResults = . "$scriptPath\$functionName.ps1" | Select Control, ControlDescription, Finding, OnPremisesSyncEnabled, LastSyncDateTime, DynamicGroupName, DynamicGroupTypes, DynamicGroupMembershipRule, Result
        $allResults += $currentResults  # Append results to the array
        
    }

    $allResults | Export-Csv -Path "scan_results.csv" -NoTypeInformation
    Write-Host "¡Ejecucion del script completada! Todos los resultados se combinaron y exportaron a scan_results.csv." -ForegroundColor Green