<#
=============================================================================================
                    HỆ THỐNG IT HELPDESK CỦA LUÂN - HOTLINE: 0966.228.133
            SCRIPT TỰ ĐỘNG CÀI ĐẶT TRỌN BỘ PHẦN MỀM CHO MÁY MỚI CÀI WINDOWS (ALL-IN-ONE)
=============================================================================================
Bao gồm:
 1. Tắt Sleep/Hibernate & Tắt màn hình khi cắm sạc/dùng pin.
 2. Bật hiển thị đầy đủ icon hệ thống trên Desktop (This PC, Thùng rác, Mạng, Control Panel...).
 3. Tải & Cài đặt Google Chrome Enterprise 64-bit.
 4. Tải & Cài đặt Bộ gõ Tiếng Việt UniKey 4.6 RC2 64-bit (1 Task Scheduler duy nhất, chống bật lặp).
 5. Tải & Cài đặt Adobe Acrobat Reader DC (Offline silent).
 6. Tải & Cài đặt UltraViewer (Hỗ trợ từ xa dự phòng).
 7. Tải & Cài đặt Microsoft Office 2021 ProPlus LTSC 64-bit (Word, Excel, PowerPoint, Outlook).
 8. Kích hoạt bản quyền Microsoft Office 2021 & Windows qua máy chủ KMS.
 9. Dọn dẹp triệt để các shortcut trùng lặp trên Desktop.
=============================================================================================
#>

# Tự động yêu cầu quyền Administrator nếu chưa có
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[!] Dang khoi chay lai voi quyen Administrator..." -ForegroundColor Yellow
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls
$ProgressPreference = 'SilentlyContinue'

$tempDir = "C:\LuanHelpdesk_Setup"
if (!(Test-Path $tempDir)) { New-Item -ItemType Directory -Path $tempDir -Force | Out-Null }

$activeUser = (Get-CimInstance Win32_ComputerSystem).UserName.Split('\')[-1]
if (!$activeUser) { $activeUser = $env:USERNAME }
$userDesktop = "C:\Users\$activeUser\Desktop"
$publicDesktop = "C:\Users\Public\Desktop"
$userSid = (Get-CimInstance Win32_UserAccount | Where-Object { $_.Name -eq $activeUser }).SID

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  HỆ THỐNG IT HELPDESK CỦA LUÂN - CÀI ĐẶT MÁY MỚI TỰ ĐỘNG" -ForegroundColor Green
Write-Host "  Nguoi dung: $activeUser (SID: $userSid)" -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan

# -------------------------------------------------------------------------------------------
# 1. TẮT SLEEP, HIBERNATE & TIMEOUT MÀN HÌNH
# -------------------------------------------------------------------------------------------
Write-Host "`n[1/8] Dang tat che do Sleep & Timeout man hinh..." -ForegroundColor Yellow
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0
powercfg /change hibernate-timeout-ac 0
powercfg /change hibernate-timeout-dc 0
powercfg -h off
Write-Host "[OK] Da tat Sleep & Hibernate." -ForegroundColor Green

# -------------------------------------------------------------------------------------------
# 2. BẬT BIỂU TƯỢNG HỆ THỐNG TRÊN DESKTOP (THIS PC, THÙNG RÁC, MẠNG, CONTROL PANEL)
# -------------------------------------------------------------------------------------------
Write-Host "`n[2/8] Dang bat cac bieu tuong he thong tren Desktop..." -ForegroundColor Yellow
$regRoots = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"
)
if ($userSid) {
    $regRoots += "Registry::HKEY_USERS\$userSid\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
    $regRoots += "Registry::HKEY_USERS\$userSid\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"
}

foreach ($r in $regRoots) {
    if (!(Test-Path $r)) { New-Item -Path $r -Force -ErrorAction SilentlyContinue | Out-Null }
    Set-ItemProperty -Path $r -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue # This PC
    Set-ItemProperty -Path $r -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue # Recycle Bin
    Set-ItemProperty -Path $r -Name "{F02C1A0D-BE21-43C2-8B10-2E3C67C7D77F}" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue # Network
    Set-ItemProperty -Path $r -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue # User Files
    Set-ItemProperty -Path $r -Name "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue # Control Panel
}
Write-Host "[OK] Da bat This PC, Thung rac, Mang, Control Panel tren Desktop." -ForegroundColor Green

# -------------------------------------------------------------------------------------------
# 3. CÀI ĐẶT GOOGLE CHROME ENTERPRISE 64-BIT
# -------------------------------------------------------------------------------------------
Write-Host "`n[3/8] Dang cai dat Google Chrome Enterprise 64-bit..." -ForegroundColor Yellow
$chromeExe = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (!(Test-Path $chromeExe)) {
    $chromeMsi = Join-Path $tempDir "GoogleChromeEnterprise64.msi"
    Write-Host "  -> Dang tai Google Chrome MSI..." -ForegroundColor Gray
    & C:\Windows\System32\curl.exe -L -s -S -o $chromeMsi "https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi"
    if (Test-Path $chromeMsi) {
        Write-Host "  -> Dang cai dat silent..." -ForegroundColor Gray
        Start-Process "msiexec.exe" -ArgumentList "/i `"$chromeMsi`" /qn /norestart" -Wait
    }
}
if (Test-Path $chromeExe) {
    $wsh = New-Object -ComObject WScript.Shell
    $sc = $wsh.CreateShortcut((Join-Path $publicDesktop "Google Chrome.lnk"))
    $sc.TargetPath = $chromeExe
    $sc.WorkingDirectory = Split-Path $chromeExe
    $sc.Save()
    Write-Host "[OK] Google Chrome da cai dat thanh cong." -ForegroundColor Green
} else {
    Write-Host "[WARN] Chua tim thay chrome.exe" -ForegroundColor Yellow
}

# -------------------------------------------------------------------------------------------
# 4. CÀI ĐẶT UNIKEY 4.6 RC2 64-BIT (CHUẨN HÓA 1 NGUỒN KHỞI ĐỘNG)
# -------------------------------------------------------------------------------------------
Write-Host "`n[4/8] Dang cai dat Bo go Tieng Viet UniKey 4.6 RC2 64-bit..." -ForegroundColor Yellow
$unikeyDir = "C:\Program Files\UniKey"
$unikeyNT = Join-Path $unikeyDir "UniKeyNT.exe"
$unikeyZip = Join-Path $tempDir "unikey64.zip"

Get-Process -Name "UniKeyNT" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "UniKey" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "UniKey" -Force -ErrorAction SilentlyContinue
Remove-Item "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\UniKey.lnk" -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Users\$activeUser\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\UniKey.lnk" -Force -ErrorAction SilentlyContinue

if (!(Test-Path $unikeyNT)) {
    if (!(Test-Path $unikeyDir)) { New-Item -ItemType Directory -Path $unikeyDir -Force | Out-Null }
    Write-Host "  -> Dang tai UniKey 4.6 RC2 64-bit..." -ForegroundColor Gray
    & C:\Windows\System32\curl.exe -L -k -s -S -A "Mozilla/5.0" -o $unikeyZip "https://www.unikey.org/assets/release/unikey46RC2-230919-win64.zip"
    if (Test-Path $unikeyZip) {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($unikeyZip, $unikeyDir)
        $found = Get-ChildItem -Path $unikeyDir -Recurse -Filter "UniKeyNT.exe" | Select-Object -First 1
        if ($found -and $found.FullName -ne $unikeyNT) {
            Copy-Item -Path "$($found.Directory.FullName)\*" -Destination $unikeyDir -Recurse -Force
        }
    }
}

if (Test-Path $unikeyNT) {
    # Phan quyen Everyone
    $acl = Get-Acl $unikeyDir
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone","FullControl","ContainerInherit,ObjectInherit","None","Allow")
    $acl.AddAccessRule($rule)
    Set-Acl $unikeyDir $acl

    # Tao shortcut duy nhat tren Public Desktop
    $wsh = New-Object -ComObject WScript.Shell
    $sc = $wsh.CreateShortcut((Join-Path $publicDesktop "UniKey.lnk"))
    $sc.TargetPath = $unikeyNT
    $sc.WorkingDirectory = $unikeyDir
    $sc.Save()

    # Dang ky 1 Task Scheduler duy nhat voi quyen Highest
    $action = New-ScheduledTaskAction -Execute $unikeyNT -WorkingDirectory $unikeyDir
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Days 0)
    $principal = New-ScheduledTaskPrincipal -UserId $activeUser -LogonType Interactive -RunLevel Highest
    Register-ScheduledTask -TaskName "UniKeyStartup" -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force | Out-Null
    Start-ScheduledTask -TaskName "UniKeyStartup" -ErrorAction SilentlyContinue
    Write-Host "[OK] UniKey da cai dat va cau hinh khoi dong duy nhat qua Task Scheduler." -ForegroundColor Green
}

# -------------------------------------------------------------------------------------------
# 5. CÀI ĐẶT ADOBE ACROBAT READER DC (OFFLINE INSTALLER)
# -------------------------------------------------------------------------------------------
Write-Host "`n[5/8] Dang cai dat Adobe Acrobat Reader DC..." -ForegroundColor Yellow
$acroExe = "C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"
if (!(Test-Path $acroExe)) {
    $foundAcro = Get-ChildItem "C:\Program Files\Adobe", "C:\Program Files (x86)\Adobe" -Recurse -Filter "AcroRd32.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($foundAcro) { $acroExe = $foundAcro.FullName }
}

if (!(Test-Path $acroExe)) {
    $readerExe = Join-Path $tempDir "AcroRdrDC_Setup.exe"
    Write-Host "  -> Dang tai Adobe Acrobat Reader DC offline installer..." -ForegroundColor Gray
    & C:\Windows\System32\curl.exe -C - -L -s -S -A "Mozilla/5.0" -o $readerExe "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2100120135/AcroRdrDC2100120135_en_US.exe"
    if ((Test-Path $readerExe) -and (Get-Item $readerExe).Length -gt 150000000) {
        Write-Host "  -> Dang cai dat Adobe Reader silent..." -ForegroundColor Gray
        Start-Process -FilePath $readerExe -ArgumentList "/sAll /rs /msi EULA_ACCEPT=YES" -Wait
    }
    $foundAcro = Get-ChildItem "C:\Program Files\Adobe", "C:\Program Files (x86)\Adobe" -Recurse -Filter "AcroRd32.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($foundAcro) { $acroExe = $foundAcro.FullName }
}

if (Test-Path $acroExe) {
    $wsh = New-Object -ComObject WScript.Shell
    $sc = $wsh.CreateShortcut((Join-Path $publicDesktop "Acrobat Reader.lnk"))
    $sc.TargetPath = $acroExe
    $sc.WorkingDirectory = Split-Path $acroExe
    $sc.Save()
    Write-Host "[OK] Adobe Acrobat Reader DC da cai dat thanh cong." -ForegroundColor Green
}

# -------------------------------------------------------------------------------------------
# 6. CÀI ĐẶT ULTRAVIEWER (HỖ TRỢ TỪ XA)
# -------------------------------------------------------------------------------------------
Write-Host "`n[6/8] Dang kiem tra & cai dat UltraViewer..." -ForegroundColor Yellow
$uvExe = "C:\Program Files (x86)\UltraViewer\UltraViewer_Desktop.exe"
if (!(Test-Path $uvExe)) {
    $uvInstaller = Join-Path $tempDir "UltraViewer_setup.exe"
    Write-Host "  -> Dang tai UltraViewer..." -ForegroundColor Gray
    & C:\Windows\System32\curl.exe -L -s -S -A "Mozilla/5.0" -o $uvInstaller "https://ultraviewer.net/UltraViewer_setup_6.6_en.exe"
    if (Test-Path $uvInstaller) {
        Write-Host "  -> Dang cai dat UltraViewer silent..." -ForegroundColor Gray
        Start-Process -FilePath $uvInstaller -ArgumentList "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-" -Wait
    }
}
if (Test-Path $uvExe) {
    $wsh = New-Object -ComObject WScript.Shell
    $sc = $wsh.CreateShortcut((Join-Path $publicDesktop "UltraViewer.lnk"))
    $sc.TargetPath = $uvExe
    $sc.WorkingDirectory = Split-Path $uvExe
    $sc.Save()
    Write-Host "[OK] UltraViewer da cai dat thanh cong." -ForegroundColor Green
}

# -------------------------------------------------------------------------------------------
# 7. CÀI ĐẶT MICROSOFT OFFICE 2021 PROPLUS LTSC 64-BIT & KÍCH HOẠT KMS
# -------------------------------------------------------------------------------------------
Write-Host "`n[7/8] Dang cai dat Microsoft Office 2021 ProPlus LTSC Volume (64-bit)..." -ForegroundColor Yellow
$wordExe = "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"

if (!(Test-Path $wordExe)) {
    $officeSetupDir = "C:\LuanHelpdesk_Setup\OfficeSetup"
    $officeDataDir = "$officeSetupDir\Office\Data\16.0.14334.20848"
    if (!(Test-Path $officeDataDir)) { New-Item -ItemType Directory -Path $officeDataDir -Force | Out-Null }
    
    $setupExe = Join-Path $officeSetupDir "setup.exe"
    $configXml = Join-Path $officeSetupDir "config.xml"
    $cdnBase = "http://officecdn.microsoft.com/pr/5030841d-c919-4594-8d2d-84ae4f96e58e/Office/Data"
    
    Write-Host "  -> Dang tai engine Office setup.exe..." -ForegroundColor Gray
    if (!(Test-Path $setupExe)) {
        & C:\Windows\System32\curl.exe -L -s -S -o $setupExe "https://officecdn.microsoft.com/pr/wsus/setup.exe"
    }

    Write-Host "  -> Dang tai cac goi CAB & Metadata Office 2021..." -ForegroundColor Gray
    & C:\Windows\System32\curl.exe -L -s -S -o "$officeSetupDir\Office\Data\v64.cab" "$cdnBase/v64.cab"
    & C:\Windows\System32\curl.exe -L -s -S -o "$officeSetupDir\Office\Data\v64_16.0.14334.20848.cab" "$cdnBase/v64_16.0.14334.20848.cab"
    & C:\Windows\System32\curl.exe -L -s -S -o "$officeDataDir\i640.cab" "$cdnBase/16.0.14334.20848/i640.cab"
    & C:\Windows\System32\curl.exe -L -s -S -o "$officeDataDir\i641033.cab" "$cdnBase/16.0.14334.20848/i641033.cab"
    & C:\Windows\System32\curl.exe -L -s -S -o "$officeDataDir\s640.cab" "$cdnBase/16.0.14334.20848/s640.cab"
    & C:\Windows\System32\curl.exe -L -s -S -o "$officeDataDir\s641033.cab" "$cdnBase/16.0.14334.20848/s641033.cab"

    Write-Host "  -> Dang tai stream.x64.en-us.dat (270MB)..." -ForegroundColor Gray
    & C:\Windows\System32\curl.exe -C - -L -s -S -o "$officeDataDir\stream.x64.en-us.dat" "$cdnBase/16.0.14334.20848/stream.x64.en-us.dat"

    Write-Host "  -> Dang tai stream.x64.x-none.dat (1.5GB) voi tinh nang Resume..." -ForegroundColor Gray
    & C:\Windows\System32\curl.exe -C - -L -s -S -o "$officeDataDir\stream.x64.x-none.dat" "$cdnBase/16.0.14334.20848/stream.x64.x-none.dat"

    $b64Xml = "PENvbmZpZ3VyYXRpb24+CiAgPEFkZCBTb3VyY2VQYXRoPSJDOlxMdWFuSGVscGRlc2tfU2V0dXBcT2ZmaWNlU2V0dXAiIFZlcnNpb249IjE2LjAuMTQzMzQuMjA4NDgiIE9mZmljZUNsaWVudEVkaXRpb249IjY0IiBDaGFubmVsPSJQZXJwZXR1YWxWTDIwMjEiPgogICAgPFByb2R1Y3QgSUQ9IlByb1BsdXMyMDIxVm9sdW1lIj4KICAgICAgPExhbmd1YWdlIElEPSJlbi11cyIgLz4KICAgICAgPEV4Y2x1ZGVBcHAgSUQ9Ikx5bmMiIC8+CiAgICAgIDxFeGNsdWRlQXBwIElEPSJPbmVEcml2ZSIgLz4KICAgICAgPEV4Y2x1ZGVBcHAgSUQ9Ik9uZU5vdGUiIC8+CiAgICA8L1Byb2R1Y3Q+CiAgPC9BZGQ+CiAgPFByb3BlcnR5IE5hbWU9IkF1dG9BY3RpdmF0ZSIgVmFsdWU9IjEiIC8+CiAgPERpc3BsYXkgTGV2ZWw9Ik5vbmUiIEFjY2VwdEVVTEE9IlRSVUUiIC8+CjwvQ29uZmlndXJhdGlvbj4="
    [System.IO.File]::WriteAllBytes($configXml, [System.Convert]::FromBase64String($b64Xml))

    Write-Host "  -> Dang chay cai dat Office 2021 vao he thong..." -ForegroundColor Gray
    Start-Process -FilePath $setupExe -ArgumentList "/configure `"$configXml`"" -Wait
    Start-Sleep -Seconds 10
}

# Kích hoạt Office qua KMS
Write-Host "  -> Dang kich hoat ban quyen Office 2021 qua KMS..." -ForegroundColor Gray
$vbs = if (Test-Path 'C:\Program Files\Microsoft Office\Office16\ospp.vbs') { 'C:\Program Files\Microsoft Office\Office16\ospp.vbs' } else { 'C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs' }
if ($vbs) {
    $licDir = 'C:\Program Files\Microsoft Office\root\Licenses16'
    if (Test-Path $licDir) {
        $licFiles = Get-ChildItem -Path $licDir -Filter "ProPlus2021VL_KMS*.xrm-ms"
        foreach ($lic in $licFiles) {
            cscript //nologo C:\Windows\System32\slmgr.vbs /ilc $lic.FullName | Out-Null
        }
    }
    cscript //nologo $vbs /remhst | Out-Null
    cscript //nologo $vbs /inpkey:FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH | Out-Null
        
    $servers = @("kms8.msguides.com", "kms9.msguides.com", "kms.lotro.cc", "kms.digiboy.ir")
    foreach ($srv in $servers) {
        cscript //nologo $vbs /sethst:$srv | Out-Null
        $res = cscript //nologo $vbs /act
        if (($res -join "`n") -match "successful") {
            Write-Host "[OK] Kich hoat Office 2021 thanh cong tren KMS $srv!" -ForegroundColor Green
            break
        }
    }
}

# -------------------------------------------------------------------------------------------
# 8. KÍCH HOẠT BẢN QUYỀN WINDOWS (KMS / DIGITAL LICENSE)
# -------------------------------------------------------------------------------------------
Write-Host "`n[8/9] Dang kiem tra va kich hoat ban quyen Windows..." -ForegroundColor Yellow
try {
    $winStatus = (Get-CimInstance SoftwareLicensingProduct | Where-Object { $_.PartialProductKey -and $_.Name -match "Windows" } | Select-Object -First 1).LicenseStatus
    if ($winStatus -eq 1) {
        Write-Host "[OK] Windows da duoc kich hoat ban quyen hop le tu truoc (Licensed)." -ForegroundColor Green
    } else {
        Write-Host "  -> Dang ket noi may chu KMS de kich hoat Windows..." -ForegroundColor Gray
        $servers = @("kms8.msguides.com", "kms9.msguides.com", "kms.lotro.cc", "kms.digiboy.ir")
        foreach ($srv in $servers) {
            cscript //nologo C:\Windows\System32\slmgr.vbs /skms $srv | Out-Null
            cscript //nologo C:\Windows\System32\slmgr.vbs /ato | Out-Null
            $statusCheck = (Get-CimInstance SoftwareLicensingProduct | Where-Object { $_.PartialProductKey -and $_.Name -match "Windows" } | Select-Object -First 1).LicenseStatus
            if ($statusCheck -eq 1) {
                Write-Host "[OK] Kich hoat ban quyen Windows thanh cong tren KMS $srv!" -ForegroundColor Green
                break
            }
        }
    }
} catch {
    Write-Host "[WARN] Khong the kiem tra trang thai ban quyen Windows: $_" -ForegroundColor Yellow
}


# Tạo shortcut Office trên Public Desktop
$appPaths = @{
    "Word.lnk" = "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"
    "Excel.lnk" = "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE"
    "PowerPoint.lnk" = "C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE"
}
$wsh = New-Object -ComObject WScript.Shell
foreach ($entry in $appPaths.GetEnumerator()) {
    if (Test-Path $entry.Value) {
        $sc = $wsh.CreateShortcut((Join-Path $publicDesktop $entry.Key))
        $sc.TargetPath = $entry.Value
        $sc.WorkingDirectory = Split-Path $entry.Value
        $sc.Save()
    }
}
Write-Host "[OK] Da tao shortcuts Office (Word, Excel, PowerPoint)." -ForegroundColor Green

# -------------------------------------------------------------------------------------------
# 9. DỌN DẸP SHORTCUT TRÙNG LẶP & LÀM MỚI DESKTOP
# -------------------------------------------------------------------------------------------
Write-Host "`n[9/9] Dang don dep shortcut trung lap & lam moi Explorer..." -ForegroundColor Yellow
$publicShortcuts = Get-ChildItem $publicDesktop -Filter "*.lnk" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
foreach ($name in $publicShortcuts) {
    $userLnk = Join-Path $userDesktop $name
    if (Test-Path $userLnk) {
        Remove-Item -Path $userLnk -Force -ErrorAction SilentlyContinue
    }
}

# Gửi tín hiệu Refresh Explorer
$code = @"
using System;
using System.Runtime.InteropServices;
public class ShellHelper {
    [DllImport("shell32.dll")]
    public static extern void SHChangeNotify(int wEventId, uint uFlags, IntPtr dwItem1, IntPtr dwItem2);
}
"@
Add-Type -TypeDefinition $code -ErrorAction SilentlyContinue
[ShellHelper]::SHChangeNotify(0x08000000, 0, [IntPtr]::Zero, [IntPtr]::Zero)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  ✓ HOÀN TẤT TOÀN BỘ CÀI ĐẶT VÀ TỐI ƯU MÁY MỚI THÀNH CÔNG!" -ForegroundColor Green
Write-Host "  Hotline Luân: 0966.228.133 (Hỗ trợ kỹ thuật 24/7)" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
