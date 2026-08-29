<#
=============================================================================================
                    HỆ THỐNG IT HELPDESK CỦA LUÂN - HOTLINE: 0966.228.133
                SCRIPT TỰ ĐỘNG KÍCH HOẠT BẢN QUYỀN WINDOWS & MICROSOFT OFFICE
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

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  HỆ THỐNG IT HELPDESK CỦA LUÂN - KÍCH HOẠT BẢN QUYỀN" -ForegroundColor Green
Write-Host "  Hotline Kỹ Thuật 24/7: 0966.228.133" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

$kmsServers = @("kms8.msguides.com", "kms9.msguides.com", "kms.lotro.cc", "kms.digiboy.ir")

# -------------------------------------------------------------------------------------------
# 1. KÍCH HOẠT BẢN QUYỀN MICROSOFT WINDOWS
# -------------------------------------------------------------------------------------------
Write-Host "`n[1/2] Dang kiem tra & kich hoat ban quyen Windows..." -ForegroundColor Yellow
try {
    $winStatus = (Get-CimInstance SoftwareLicensingProduct | Where-Object { $_.PartialProductKey -and $_.Name -match "Windows" } | Select-Object -First 1).LicenseStatus
    if ($winStatus -eq 1) {
        Write-Host "  [OK] Windows da co ban quyen hop le (Licensed)." -ForegroundColor Green
    } else {
        Write-Host "  -> Ket noi may chu KMS de kich hoat Windows..." -ForegroundColor Gray
        $winActivated = $false
        foreach ($srv in $kmsServers) {
            cscript //nologo C:\Windows\System32\slmgr.vbs /skms $srv | Out-Null
            cscript //nologo C:\Windows\System32\slmgr.vbs /ato | Out-Null
            $statusCheck = (Get-CimInstance SoftwareLicensingProduct | Where-Object { $_.PartialProductKey -and $_.Name -match "Windows" } | Select-Object -First 1).LicenseStatus
            if ($statusCheck -eq 1) {
                Write-Host "  [OK] Kich hoat ban quyen Windows thanh cong tren KMS $srv!" -ForegroundColor Green
                $winActivated = $true
                break
            }
        }
        if (!$winActivated) {
            Write-Host "  [WARN] Chua the kich hoat Windows qua cac may chu KMS hien tai." -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "  [WARN] Loi kiem tra Windows: $_" -ForegroundColor Yellow
}

# -------------------------------------------------------------------------------------------
# 2. KÍCH HOẠT BẢN QUYỀN MICROSOFT OFFICE (2016, 2019, 2021, 2024, Office 365)
# -------------------------------------------------------------------------------------------
Write-Host "`n[2/2] Dang kiem tra & kich hoat ban quyen Microsoft Office..." -ForegroundColor Yellow
$vbs = if (Test-Path 'C:\Program Files\Microsoft Office\Office16\ospp.vbs') { 'C:\Program Files\Microsoft Office\Office16\ospp.vbs' } else { 'C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs' }
if (!(Test-Path $vbs)) {
    $found = Get-ChildItem "C:\Program Files\Microsoft Office", "C:\Program Files (x86)\Microsoft Office" -Recurse -Filter "ospp.vbs" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) { $vbs = $found.FullName }
}

if ($vbs) {
    Write-Host "  -> Tim thay engine OSPP tai: $vbs" -ForegroundColor Gray
    
    # Nạp chứng chỉ Volume KMS nếu có thư mục Licenses16
    $licDir = 'C:\Program Files\Microsoft Office\root\Licenses16'
    if (Test-Path $licDir) {
        $licFiles = Get-ChildItem -Path $licDir -Filter "ProPlus2021VL_KMS*.xrm-ms"
        foreach ($lic in $licFiles) {
            cscript //nologo C:\Windows\System32\slmgr.vbs /ilc $lic.FullName | Out-Null
        }
    }

    cscript //nologo $vbs /remhst | Out-Null
    cscript //nologo $vbs /inpkey:FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH 2>$null | Out-Null
    
    $officeActivated = $false
    foreach ($srv in $kmsServers) {
        cscript //nologo $vbs /sethst:$srv | Out-Null
        $res = cscript //nologo $vbs /act
        $resStr = $res -join "`n"
        if ($resStr -match "successful") {
            Write-Host "  [OK] Kich hoat Microsoft Office thanh cong tren KMS $srv!" -ForegroundColor Green
            $officeActivated = $true
            break
        }
    }
    
    Write-Host "`n--- TRANG THAI BAN QUYEN OFFICE CHI TIET ---" -ForegroundColor Gray
    cscript //nologo $vbs /dstatus
} else {
    Write-Host "  [!] May tinh chua cai dat Microsoft Office." -ForegroundColor Yellow
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "  ✓ HOÀN TẤT KÍCH HOẠT BẢN QUYỀN WINDOWS & OFFICE!" -ForegroundColor Green
Write-Host "  Mọi sự cố kỹ thuật vui lòng liên hệ Luân: 0966.228.133" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
