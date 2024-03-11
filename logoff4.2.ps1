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

    public struct LASTINPUTINFO
    {
        public uint cbSize;
        public uint dwTime;
    }

    public static uint GetLastInputTime()
    {
        LASTINPUTINFO lastInputInfo = new LASTINPUTINFO();
        lastInputInfo.cbSize = (uint)Marshal.SizeOf(lastInputInfo);
        GetLastInputInfo(ref lastInputInfo);

        return lastInputInfo.dwTime;
    }
}
'@

Start-Sleep -Seconds 2

$lastInputTime = [UserInputDetector]::GetLastInputTime()

while ($true) {
  Start-Sleep -Seconds 1

  $currentInputTime = [UserInputDetector]::GetLastInputTime()
  if ($currentInputTime -gt $lastInputTime) {
    # Abrir la cámara
    Start-Process microsoft.windows.camera:

    # Esperar 10 segundos (ajustable según necesidad)
    Start-Sleep -Seconds 10

    # Presionar Enter
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

    # Bloquear la estación de trabajo
    [UserInputDetector]::LockWorkStation()
    break
  }

  $lastInputTime = $currentInputTime
}
