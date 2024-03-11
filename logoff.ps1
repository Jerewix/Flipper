# Importa el módulo de entrada de usuario
Import-Module Input

# Define la función para cerrar sesión
function Close-Session {
  # Simula la pulsación de las teclas "Windows" + "L"
  [System.Windows.Input.Keyboard]::Press(
    [System.Windows.Input.KeyInterop]::ConvertToVirtualKey('L', [System.Windows.Input.ModifierKeys]::Windows)
  )
}

# Inicia un bucle infinito que espera movimiento del mouse o pulsación de tecla
while ($true) {
  # Comprueba si se ha detectado movimiento del mouse
  if ([System.Windows.Input.Mouse]::GetPosition().X -ne $lastMouseX -or
    [System.Windows.Input.Mouse]::GetPosition().Y -ne $lastMouseY) {
    # Cierra la sesión
    Close-Session
    # Sal del bucle
    break
  }

  # Comprueba si se ha presionado una tecla
  if ([System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::Any)) {
    # Cierra la sesión
    Close-Session
    # Sal del bucle
    break
  }

  # Almacena la posición actual del mouse
  $lastMouseX = [System.Windows.Input.Mouse]::GetPosition().X
  $lastMouseY = [System.Windows.Input.Mouse]::GetPosition().Y

  # Espera 100 milisegundos
  Start-Sleep -Milliseconds 100
}