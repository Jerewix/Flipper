Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Inicializa el objeto de la cámara
$camera = New-Object System.Windows.Forms.WebBrowser

# Abre la cámara
$camera.Navigate("about:blank")

# Espera a que la cámara se cargue
while ($camera.ReadyState -ne "Complete") {
    Start-Sleep -Milliseconds 100
}

# Captura una imagen de la cámara
$image = $camera.Document.GetElementsByTagName("img") | Select-Object -First 1

# Guarda la imagen en un archivo
$image.src | ForEach-Object {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($_, "foto.jpg")
}

# Cierra la cámara
$camera.Dispose()

Start-Sleep -Seconds 3000
