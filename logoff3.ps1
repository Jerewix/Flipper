# Importa la biblioteca para detectar eventos de teclado y mouse
Import-Module InputObject

# Función para detectar movimiento del mouse
function MouseMove {
    # Cierra la sesión si se detecta movimiento
    Lock-Workstation
}

# Función para detectar pulsación de tecla
function KeyPress {
    # Cierra la sesión si se detecta una pulsación de tecla
    Lock-Workstation
}

# Registra eventos de movimiento del mouse
Register-ObjectEvent -InputObject (Get-Mouse) -EventName MouseMove -SourceIdentifier "MouseMove"

# Registra eventos de pulsación de tecla
Register-ObjectEvent -InputObject (Get-Key) -EventName KeyPress -SourceIdentifier "KeyPress"

# Inicia un bucle infinito para mantener el script en ejecución
while ($true) {
    # Espera a que se detecte un evento
    Wait-Event -SourceIdentifier "MouseMove", "KeyPress"
}
