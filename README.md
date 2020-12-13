# Lockdown-UserAccount
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
