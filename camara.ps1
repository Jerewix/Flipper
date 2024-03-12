# Agregar la referencia a la biblioteca WIA
$wiaAssembly = [Reflection.Assembly]::LoadWithPartialName("WIA")

# Crear un dispositivo de escaneo (la cámara)
$deviceManager = New-Object $wiaAssembly.DeviceManagerClass
$device = $deviceManager.DeviceInfos.Item(1).Connect()

# Tomar la imagen
$image = $device.Items.Item(1).Transfer()

# Guardar la imagen en un archivo
$image.SaveFile("C:\Users\Jeremy\OneDrive\Imágenes\Flipper Code\foto.jpg")

Write-Output "Imagen tomada y guardada como foto.jpg"

Start-Sleep -Seconds 3000
