# Elimina la línea de asignación a $dc
# $dc='';

# Instala el módulo Input si es necesario
if (-not (Get-Module -Name Input)) {
  Install-Module Input
}

Import-Module Input

function Close-Session {
  # Simula la pulsación de las teclas "Windows" + "L"
  [System.Windows.Input.Keyboard]::Press(
    [System.Windows.Input.KeyInterop]::ConvertToVirtualKey('L', [System.Windows.Input.ModifierKeys]::Windows)
  )
}

while ($true) {
  # Comprueba si se ha detectado movimiento del mouse
  if ([System.Windows.Input.Mouse]::GetPosition().X -ne $lastMouseX -or
    [System.Windows.Input.Mouse]::GetPosition().Y -ne $lastMouseY) {
    Close-Session
    break
  }

  # Comprueba si se ha presionado una tecla
  if ([System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::Any)) {
    Close-Session
    break
  }

  # Almacena la posición actual del mouse
  $lastMouseX = [System.Windows.Input.Mouse]::GetPosition().X
  $lastMouseY = [System.Windows.Input.Mouse]::GetPosition().Y

  # Espera 100 milisegundos
  Start-Sleep -Milliseconds 100

  # Borra el historial de PowerShell
  Clear-History
}
