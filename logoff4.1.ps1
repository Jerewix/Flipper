Add-Type -TypeDefinition @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

public static class UserInputDetector
{
    [DllImport("user32.dll")]
    public static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool LockWorkStation();

    internal struct LASTINPUTINFO
    {
        public uint cbSize;
        public uint dwTime;
    }

    public static bool HasUserInputOccured(int seconds)
    {
        LASTINPUTINFO lastInputInfo = new LASTINPUTINFO();
        lastInputInfo.cbSize = (uint)Marshal.SizeOf(lastInputInfo);
        GetLastInputInfo(ref lastInputInfo);

        return lastInputInfo.dwTime / 1000 > (uint)seconds;
    }
}
'@

$seconds = 0

while($true)
{
    Start-Sleep -Seconds 1
    $seconds++

    if ([UserInputDetector]::HasUserInputOccured($seconds))
    {
        # Crea un archivo de texto con el mensaje "HOLA"
        "HOLA" | Out-File -FilePath "$env:TEMP\message.txt"
        
        # Abre el archivo de texto
        Start-Process -FilePath "$env:TEMP\message.txt"

	Start-Sleep -Seconds 10

	Start-Process microsoft.windows.camera:
	
	Start-Sleep -Seconds 10

	[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
        
        # Bloquea la estación de trabajo
        [UserInputDetector]::LockWorkStation()
        break
    }
}
