function creartodo
{
                Clear-Host
                $ficheroCsvUO=Read-Host "Introduce el fichero csv de UO's:"
                $fichero = import-csv -Path $ficheroCsvUO -delimiter :
                foreach($line in $fichero)
{
   New-ADOrganizationalUnit -Description:$line.Descripcion -Name:$line.Name -Path:$line.Path -ProtectedFromAccidentalDeletion:$true
}
                $gruposCsv=Read-Host "Introduce el fichero csv de Grupos"
                $fichero = import-csv -Path $gruposCsv -delimiter :
                foreach($linea in $fichero)
{
   New-ADGroup -Name:$linea.Name -Path:$linea.Path -Description:$linea.Description -GroupCategory:$linea.Category -GroupScope:$linea.Scope 
}
                $equiposCsv=Read-Host "Introduce el fichero csv de Equipos:"
                $fichero= import-csv -Path $equiposCsv -delimiter ":"
                foreach($line in $fichero)
{
   New-ADComputer -Enabled:$true -Name:$line.Computer -Path:$line.Path -SamAccountName:$line.Computer
}
                $fichero_csv=Read-Host "Introduce el fichero csv de los usuarios:"
                $fichero_csv_importado = import-csv -Path $fichero_csv -Delimiter : 			     
                foreach($linea in $fichero_csv_importado)
{
                $gmail=$linea.A+"."+$linea.B+"."+$linea.C
                $path="DC=alcoy,DC=upv,DC=es"
  	            $rutaContenedor=$linea.ContainerPath+","+$path
  	            $passAccount=ConvertTo-SecureString $linea.Dni -AsPlainText -force
	            $name=$linea.Name
	            $nameShort=$linea.Name+' '+$linea.Surname1
	            $Surnames=$linea.Surname
	            $nameLarge=$linea.Name+'.'+$linea.Surname1+'.'+$linea.Surname2
	            $computerAccount=$linea.Computer
	            $email=$nameLarge+"@"+$gmail
                
	  
	            if (Get-ADUser -filter { name -eq $nameShort })
{
   $nameShort=$linea.Surname
}
	
	            [boolean]$Habilitado=$true
  	            If($linea.Hability -Match 'false') {$Habilitado=$false}
  	            $ExpirationAccount = $linea.DaysAccountExpire
 	            $timeExp = (get-date).AddDays($ExpirationAccount)
	
	            New-ADUser `
    		        -SamAccountName $nameShort `
   	 	            -UserPrincipalName $nameShort `
    		        -Name $nameShort `
		            -Surname $Surnames `
    		        -DisplayName $nameShort `
    		        -GivenName $nameShort `
    		        -LogonWorkstations:$linea.Computer `
		            -Description "Cuenta de $nameLarge" `
    		        -EmailAddress $email `
		            -AccountPassword $passAccount `
    		        -Enabled $Habilitado `
		            -CannotChangePassword $false `
    		        -ChangePasswordAtLogon $true `
		            -PasswordNotRequired $false `
    		        -Path $rutaContenedor `
    		        -AccountExpirationDate $timeExp
		    
		        Add-ADGroupMember -Identity $linea.Group -Members $nameShort
	
	
	            Import-Module C:\Users\Administrador\Desktop\FASE3\SetADUserLogonTime.psm1
	            Set-OSCLogonHours -SamAccountName $nameShort -DayofWeek Monday,Tuesday,Wednesday,Thursday,Friday -From $linea.Horario -To $linea.To
}
                pause
}
function borrartodo
{
                Clear-Host 
                Set-ADOrganizationalUnit -Identity "OU=UsuariosALCOY,DC=alcoy,DC=upv,DC=es" -ProtectedFromAccidentalDeletion $false
                Remove-ADOrganizationalUnit -Identity "OU=UsuariosALCOY,DC=alcoy,DC=upv,DC=es" -Recursive
                pause
}
function altausu
{
                Clear-Host
                $user=Read-Host "Escribe el nombre de la cuenta a habilitar"
                $path=Read-Host "Escribe el nombre del departamento"
                Enable-ADAccount -Identity "CN=$user, OU=$path,OU=UsuariosALCOY,DC=alcoy,DC=upv,DC=es"
                return
                pause
}
function altagrupo
{
$descrip=Read-Host "Escribe la descripcion de este grupo"
$name=Read-Host "Escribe el nombre del grupo a crear"
New-LocalGroup -Name $name -Description $descrip
}
function altaequi
{
$name=Read-Host "Escribe el nombre del equipo a crear"
New-ADComputer -Enabled:$true -Name $name -Path "OU=OrdenadoresALCOY,OU=UsuariosALCOY,DC=alcoy,DC=upv,DC=es"
}
function altauo
{
$name=Read-Host "Escribe el nombre de la uo a crear"
New-ADOrganizationalUnit -Name:$name -Path:"DC=alcoy,DC=upv,DC=es" -ProtectedFromAccidentalDeletion:$true
}
#A PAR TIR DE AQUI QUITAR
function qaltausu
{
                Clear-Host
                $user=Read-Host "Escribe el nombre de la cuenta a deshabilitar"
                $path=Read-Host "Escribe el nombre del departamento"
                Disable-ADAccount -Identity "CN=$user, OU=$path,OU=UsuariosALCOY,DC=alcoy,DC=upv,DC=es"
                return
                pause
}
function qaltagrupo
{
###
$name=Read-Host "Escribe el nombre del grupo a eliminar"
Remove-LocalGroup -Name $name
}
function qaltaequi
{
$name=Read-Host "Escribe el nombre del equipo a eliminar"
Set-ADComputer -Identity $name -Enable $false
}
function qaltauo
{
Clear-Host 
$name=Read-Host "Escribe el nombre de la uo a eliminar"
                Set-ADOrganizationalUnit -Identity "OU=$name, DC=alcoy,DC=upv,DC=es" -ProtectedFromAccidentalDeletion $false
                Remove-ADOrganizationalUnit -Identity "OU=$name, DC=alcoy,DC=upv,DC=es" -Recursive
                pause
}
function busu
{
$name=Read-Host "Escribe el nombre del usuario a buscar"
dsquery user -name $name
}
function busug
{
$name=Read-Host "Escribe el nombre del grupo a buscar"
dsquery group -name $name
}
function busue
{
$name=Read-Host "Escribe el nombre del ordenador a buscar"
dsquery computer -name $name
}
function buscartodo
{
dsquery * -limit 1000 | more
}
function mostrar_Submenu2
{
     param (
           [string]$Titulo = 'Submenu de Altas'
     )
     Clear-Host 
     Write-Host "================ $Titulo ================"
    
     Write-Host "1: Alta de un usuario"
     Write-Host "2: Alta de un grupo"
     Write-Host "3: Alta de un equipo"
     Write-Host "4: Alta de una UO"
     Write-Host "s: Volver al menu principal."
do
{
     $input = Read-Host "Por favor, pulse una opción"
     switch ($input)
     {
           '1' {
                Clear-Host
                altausu
                return
           } '2' {
                Clear-Host
                altagrupo
                return
           } '3' {
                Clear-Host
                altaequi
                return
           } '4' {
                Clear-Host
                altauo
                return
           } 's' {
                "Saliendo del submenu..."
                return
           } 
     }
}
until ($input -eq 'q')
}
function mostrar_Submenu3
{
     param (
           [string]$Titulo = 'Submenu de Bajas'
     )
     Clear-Host 
     Write-Host "================ $Titulo ================"
    
     Write-Host "1: Baja un Usuario"
     Write-Host "2: Baja un Grupo"
     Write-Host "3: Baja un Equipo"
     Write-Host "4: Baja una UO"
     Write-Host "s: Volver al menu principal."
do
{
     $input = Read-Host "Por favor, pulse una opción"
     switch ($input)
     {
           '1' {
               Clear-Host
                qaltausu
                return
           } '2' {
                Clear-Host
                qaltagrupo
                return
           } '3' {
                Clear-Host
                qaltaequi
                return
           } '4' {
                Clear-Host
                qaltauo
                return
           } 's' {
                "Saliendo del submenu..."
                return
           } 
     }
}
until ($input -eq 'q')
}
function mostrar_Submenu4
{
     param (
           [string]$Titulo = 'Submenu de Bajas'
     )
     Clear-Host 
     Write-Host "================ $Titulo ================"
    
     Write-Host "1: Buscar un Usuario"
     Write-Host "2: Buscar un Grupo"
     Write-Host "3: Buscar un Equipo"
     Write-Host "s: Volver al menu principal."
do
{
     $input = Read-Host "Por favor, pulse una opción"
     switch ($input)
     {
           '1' {
               Clear-Host
                busu
                return
           } '2' {
                Clear-Host
                busug
                return
           } '3' {
                Clear-Host
                busue
                return
           } 's' {
                "Saliendo del submenu..."
                return
           } 
     }
}
until ($input -eq 'q')
}
function mostrar_Submenu1
{
     param (
           [string]$Titulo = 'Submenu.....'
     )
     Clear-Host 
     Write-Host "================ $Titulo ================"
    
     Write-Host "1: Alta de un objeto"
     Write-Host "2: Baja de un objeto"
     Write-Host "3: Busqueda de un objeto"
     Write-Host "s: Volver al menu principal."
do
{
     $input = Read-Host "Por favor, pulse una opción"
     switch ($input)
     {
           '1' {
                Clear-Host
                mostrar_Submenu2
                return
           } '2' {
                Clear-Host
                mostrar_Submenu3
                return
           } '3' {
                Clear-Host
                mostrar_Submenu4
                return
           } 's' {
                "Saliendo del submenu..."
                return
           } 
     }
}
until ($input -eq 'q')
}



#Función que nos muestra un menú por pantalla con 3 opciones, donde una de ellas es para acceder
# a un submenú) y una última para salir del mismo.

function mostrarMenu 
{ 
     param ( 
           [string]$Titulo = 'Selección de opciones' 
     ) 
     Clear-Host 
     Write-Host "================ $Titulo================" 
      
     
     Write-Host "1. Estructura lógica" 
     Write-Host "2. Eliminación estructura lógica" 
     Write-Host "3. Consulta de todos los objetos del subdominio" 
     Write-Host "4. Gestión de objetos" 
     Write-Host "s. Presiona 's' para salir" 
}

do 
{ 
     mostrarMenu 
     $input = Read-Host "Elegir una Opción" 
     switch ($input) 
     { 
           '1' { 
                creartodo
           } '2' { 
                borrartodo
           } '3' {  
                buscartodo
           } '4' {  
                Clear-Host
                mostrar_Submenu1      
           } 's' {
                'Saliendo del script...'
                return 
           }  
     } 
     pause 
} 
until ($input -eq 's')