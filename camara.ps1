# Importar el módulo multimedia
Import-Module Multimedia

# Crear un objeto para la cámara
$camera = New-Object System.Drawing.Imaging.VideoCaptureDevice

# Iniciar la vista previa de la cámara (opcional)
# $camera.Start()

# Obtener la imagen actual de la cámara
$image = $camera.GetCurrentImage()

# Guardar la imagen como archivo JPEG
$image.Save("C:\Users\Jeremy\OneDrive\Imágenes\Álbum de cámara\imagen.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)

# Detener la vista previa de la cámara (si se inició)
# $camera.Stop()

# Liberar los recursos del objeto cámara
$camera.Dispose()
