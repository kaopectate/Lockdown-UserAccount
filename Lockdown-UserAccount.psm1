Function LockDown-UserAccount {
        <#
    .SYNOPSIS
    Disables a user account, reset it password and block 0365 sign in one simple function.
    Must be connected to MSOL using cmdlet Connect-MsolService
    Requires MSOnline 
    .EXAMPLE
    LockDown-UserAccount -Name Alice
    .EXAMPLE
    LockDown-UserAccount -Name Alice,Bob,Carol
    .EXAMPLE
    Get-Content breachedaccounts.txt | Lockdown-UserAccount
    .PARAMETER SamAccountName
    One or more user sam account names seperated by comma.
    #>


[CmdletBinding()]
    param(
            [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
            [string]$SamAccountName
        )

    #enter seed string to 
    $seed1 = "enter seed string here"
    #MustContain Lowercase and symbols to meet complexity requirements 
    $seed2 = "seed2!"
    
    $date = Get-Date -Format ddMMyyyhhmmss
    $prehash = "$date$seed1$SamAccountName$seed2" 
    $mystream = [IO.MemoryStream]::new([byte[]][char[]]$prehash)
    $hash = (Get-FileHash -InputStream $mystream -Algorithm SHA256).hash
    $pd = $hash + $seed2
    
    
    if (($pd | measure-object –character) -gt 256)
    
    {
        Write-Error "Password longer than 256 Characters, reduce size of $seed2"
        Break
    } 
    
    else
    
    {
        $userget = Get-ADUser -identity "$SamAccountName"
        $userupn = $userget.UserPrincipalName
        Disable-AdAccount -Identity $SamAccountName
        Set-ADAccountPassword -Identity $SamAccountName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $pd -Force)
        Set-MsolUser -UserPrincipalName $userupn  -BlockCredential $true
    }
}