Add-Type -TypeDefinition @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;

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

Add-Type -AssemblyName System.Windows.Forms

$seconds = 0

while($true)
{
    Start-Sleep -Seconds 1
    $seconds++

    if ([UserInputDetector]::HasUserInputOccured($seconds))
    {
        # Muestra el mensaje "HOLA" en un cuadro de mensaje
        [System.Windows.Forms.MessageBox]::Show("HOLA", "Mensaje", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

        # Bloquea la estación de trabajo
        [UserInputDetector]::LockWorkStation()
        break
    }
}
