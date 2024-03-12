Install-Module Windows.Media.Capture

# Importa el módulo necesario
Import-Module Windows.Media.Capture

# Crea un nuevo objeto MediaCapture
$capture = New-Object Windows.Media.Capture.MediaCapture

# Inicializa la cámara
$capture.InitializeAsync()

# Inicia la vista previa de la cámara
$preview = $capture.StartPreviewAsync()

# Espera a que el usuario esté listo para tomar la foto
$ready = $host.ui.PromptForCredential("Listo para tomar la foto?", "", "", "").GetNetworkCredential().UserName

# Toma la foto
$photo = $capture.CapturePhotoAsync()

# Guarda la foto como archivo JPEG
$photo.SaveToFileAsync("foto.jpg", [Windows.Media.MediaProperties.ImageEncodingProperties]::CreateJpeg())

# Detiene la vista previa de la cámara
$preview.StopAsync()

# Libera los recursos
$capture.Dispose()

# Muestra la imagen en el Explorador de archivos
Start-Process "explorer.exe" "foto.jpg"

Start-Sleep -Seconds 3000
