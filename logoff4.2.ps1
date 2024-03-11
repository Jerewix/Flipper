# Load System.Runtime.InteropServices for DllImport attribute
Add-Type -AssemblyName System.Runtime.InteropServices

$Ref = [ref]  # Define a reference for ref parameters

# Define the UserInputDetector class with proper parameter declaration
public static class UserInputDetector
{
    [DllImport("user32.dll")]
    public static extern bool GetLastInputInfo(ref $Ref LASTINPUTINFO plii);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool LockWorkStation();

    public struct LASTINPUTINFO  // Struct definition without access modifier
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

        # Bloquea la estación de trabajo (may require admin privileges)
        [UserInputDetector]::LockWorkStation()
        break
    }
}
