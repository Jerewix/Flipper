# Verifica si el archivo WindowsInput.dll ya está presente
if (Test-Path "$env:ProgramFiles\WindowsInput.dll") {
  # Ya está instalado, no se hace nada
  Write-Host "WindowsInput.dll ya está instalado."
} else {
  # Instala el módulo WindowsInput
  Install-Module WindowsInput -Force
  Write-Host "WindowsInput.dll ha sido instalado."
}

# Importa el módulo WindowsInput
Import-Module WindowsInput.dll

$inputSim = New-Object WindowsInput.InputSimulator

function Close-Session {
  # Simula la pulsación de la tecla "Windows"
  $inputSim.Keyboard.KeyPress([WindowsInput.ModifierKeys]::Windows)
}

while ($true) {
  # Comprueba si se ha detectado alguna tecla presionada
  if ($inputSim.Keyboard.GetKeyState(WindowsInput.VirtualKeyCode.Any)) {
    Close-Session
    break
  }

  # Espera 100 milisegundos
  Start-Sleep -Milliseconds 100

  # Borra el historial de PowerShell
  Clear-History
}
