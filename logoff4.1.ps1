Add-Type -AssemblyName System.Windows.Forms

Add-Type -TypeDefinition @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

public static class UserInputDetector
{
    [DllImport("user32.dll")]
    public static extern bool GetLastInputInfo(ref **public** LASTINPUTINFO plii);  // Changed access modifier

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool LockWorkStation();

    **public** struct LASTINPUTINFO  // Changed access modifier
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

while ($true)
{
    Start-Sleep -Seconds 1
    $seconds++

    if ([UserInputDetector]::HasUserInputOccured($seconds))
    {
        Start-Sleep -Seconds 10

        Start-Process microsoft.windows.camera:

        Start-Sleep -Seconds 10

        [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

        # Bloquea la estación de trabajo
        [UserInputDetector]::LockWorkStation()
        break
    }
}
