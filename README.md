# Conseinentraid-Chequeo: Herramienta de Chequeo del Microsoft Entra ID Security 
 

## Visión general

CONSEIN EntraID Bench es un script de PowerShell diseñado para evaluar y mejorar la seguridad del entorno de Microsoft Entra ID mediante la API Graph. Automatiza las comprobaciones de seguridad para garantizar el cumplimiento de CIS Microsoft 365 Foundations Benchmark 3.0.0.

## Funciones

- **Ejecución de múltiples controles:** Evalúa de manera eficiente varios aspectos de seguridad en una sola ejecución.
- **Exportación de resultados: ** Genere archivos CSV para análisis e informes detallados.
- **Diseño modular: ** Fácilmente personalizable para cumplir con requisitos de seguridad específicos.

## Requisitos

- PowerShell 5.1 o posterior
- [Microsoft Graph PowerShell module](https://learn.microsoft.com/en-us/powershell/microsoftgraph/installation?view=graph-powershell-1.0) 
- Entra ID permissions for required Graph API calls:
Permisos de ID de Entra para las llamadas a la API de Graph necesarias
```
'UserAuthenticationMethod.Read.All',
'User.Read.All',
'SecurityEvents.Read.All',
'Policy.Read.All',
'RoleManagement.Read.All',
'AccessReview.Read.All'
```

## Uso

1. Clonar este repositorio en el equipo local.
2. Ejecute el script principal: '.\entraid_scanner.ps1`
3. Si no posee instalados los prequisitos como el Modulo de NPM o Microsoft.Graph en su equipo, serán instalados. En caso contrario validara que esten instalados y continuara la ejecución.
4. Solicitará la cuenta para acceder al Tenant del Microsoft ID Entre, la cual debe tener los permisos que arriba se indicaron.
5. Revisión de los resultados en los archivos CSV generados.

## Evaluación durante la Ejecucón

- Asegúrese de que se requiere la "fortaleza de MFA resistente al phishing" para los administradores
- Asegúrese de que se utilizan listas personalizadas de contraseñas prohibidas
- Asegúrese de que la opción "Restringir la creación de inquilinos a usuarios que no son administradores" esté establecida en "Sí".
- Asegúrese de que se crea un grupo dinámico para los usuarios invitados
- Asegúrese de que Microsoft Authenticator está configurado para proteger contra la fatiga de MFA
- Asegúrese de que la sincronización de hash de contraseña esté habilitada para implementaciones híbridas
- Asegúrese de que se utilice "Privileged Identity Management" para administrar roles
- Asegúrese de que los valores predeterminados de seguridad están deshabilitados en Azure Active Directory
- Habilitación de directivas de riesgo de usuario de Azure AD Identity Protection
- Asegúrese de que el flujo de trabajo de consentimiento del administrador esté habilitado
- Asegúrese de que la "Administración de Microsoft Azure" se limite a los roles administrativos
- Asegúrese de que las "Conexiones de la cuenta de LinkedIn" estén deshabilitadas
- Asegúrese de que la protección con contraseña esté habilitada para Active Directory local
- Asegúrese de que la frecuencia de inicio de sesión esté habilitada y que las sesiones del explorador no sean persistentes para los usuarios administrativos
- Asegúrese de que no se permitan aplicaciones integradas de terceros
- Asegúrese de que no se permita el consentimiento del usuario para que las aplicaciones accedan a los datos de la empresa en su nombre.
- Habilitación de directivas de acceso condicional para bloquear la autenticación heredada
- Asegúrese de que "Restablecimiento de contraseña de autoservicio habilitado" esté establecido en "Todos"
- Habilitación de directivas de riesgo de inicio de sesión de Azure AD Identity Protection
- Asegúrese de que la autenticación multifactor esté habilitada para todos los usuarios con roles administrativos
- Asegúrese de que la autenticación multifactor esté habilitada para todos los usuarios

## Contacto

Para preguntas o comentarios, por favor contácteme en wrivas@consein.com 

¡Gracias por usar la herramienta de evaluación de seguridad de Consein Entra ID!