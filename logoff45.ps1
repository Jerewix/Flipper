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

    $cameraProcess = Get-Process -Name "microsoft.windows.camera"
    $cameraHwnd = $cameraProcess.MainWindowHandle

    [System.Windows.Forms.AppActivate]::Activate($cameraHwnd)

    Start-Sleep -Seconds 12

    [System.Windows.Forms.SendKeys]::SendWait(" ")

    [UserInputDetector]::LockWorkStation()
    break
  }

  $lastInputTime = $currentInputTime
}
