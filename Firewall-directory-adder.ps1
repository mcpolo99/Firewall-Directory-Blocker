#Requires -RunAsAdministrator


    $scriptPath = (Resolve-Path .\).Path

    $FWRName = get-childitem -Path $scriptPath -Recurse -Include *.exe | where {! $_.PSIsContainer}
        foreach ($FWRName1 in $FWRName)
    {
       $FWRName1.Name 
    }


function Main-Menu
{


    param (
        [string]$Title = 'My Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    write-host "Current Working Dir $pwd"
    $variable = Get-Variable FCW -ValueOnly
    Write-Host "FCW $variable"
    Write-Host "1: Just a Menu that does nothing"
    Write-Host "2: FirewallCheck."
    Write-Host "3: FirewallRemove"
    Write-Host "4: FirewallAdd"
    Write-Host "Q: Press 'Q' to quit."
}


Function FirewallCheck 
{

    $scriptPath = (Resolve-Path .\).Path

    $FWRName = get-childitem -Path $scriptPath -Recurse -Include *.exe| where {! $_.PSIsContainer}
        foreach ($FWRName1 in $FWRName)
    {
       $FWRName1.Name 
    }


    if($(Get-NetFirewallRule –DisplayName $FWRName.Name -ErrorAction SilentlyContinue))
        {
            write-host "-------------------------------"  
            write-host "ALL RULES EXIST"
            write-host "-------------------------------"
            pause  
            return
        }
        
    else
        {
            write-host "-------------------------------"
            write-host "Firewall rule does not already exist"
            write-host "-------------------------------"
            pause
            return
        }

}


Function FirewallAdd
{
    $scriptPath = (Resolve-Path .\).Path

    $FWRName = get-childitem -Path $scriptPath -Recurse -Include *.exe| where {! $_.PSIsContainer}
        foreach ($FWRName1 in $FWRName)
    {
       $FWRName1.Name 
    }

    if($(Get-NetFirewallRule –DisplayName $FWRName.Name -ErrorAction SilentlyContinue))
        {
            write-host "-------------------------------"
            write-host "All Rules Exist, No Rules To Add"
            write-host "-------------------------------"
            pause
            return

        }     
    else
        {
                $FWRName = get-childitem -Path $scriptPath -Recurse -Include *.exe| where {! $_.PSIsContainer}
                foreach ( $FWRName1 in $FWRName)
                {
                    New-NetFirewallRule -DisplayName $FWRName1.Name -Action Block -Direction Outbound -Program $FWRName1 -ErrorAction SilentlyContinue -InformationAction SilentlyContinue
                    New-NetFirewallRule -DisplayName $FWRName1.Name -Action Block -Direction Inbound -Program $FWRName1 -ErrorAction SilentlyContinue -InformationAction SilentlyContinue
                    write-host "...."
                }
            write-host "-------------------------------"  
            write-host "ALL RULES Added"
            write-host "-------------------------------"
            pause
            return
        }
}





Function FirewallRemove
{
    if($(Get-NetFirewallRule –DisplayName $FWRName.Name -ErrorAction SilentlyContinue))
        {
            
            write-host "-------------------------------"
            write-host "ALL RULES EXIST, REMOVING....."
            write-host "-------------------------------"
                $FWRName = get-childitem -Path $scriptPath -Recurse -Include *.exe| where {! $_.PSIsContainer}
                foreach ( $FWRName1 in $FWRName)
                {
                    Remove-NetFirewallRule -DisplayName $FWRName1.Name
                    write-host "...."

                }
            write-host "-------------------------------"
            write-host "ALL RULES REMOVED"
            write-host "-------------------------------"
            pause
            return
        }

        
    else
        {
            write-host "-------------------------------"
            write-host "Nothing To Remove"
            write-host "-------------------------------"
            pause
            return
        }
}

Function End
{
clear
write-host "Done! all EXE´s Added To firewall.!"
Read-Host -Prompt "Press any key to continue"
}



do
 {
     Main-Menu
     $selection = Read-Host "Please make a selection"
     switch ($selection)
     {
         '1' 
         {
            '1Menu'
         } 
         '2' 
         {
            FirewallCheck
         } 
         '3' 
         {
            FirewallRemove
         }
         '4' 
         {
            FirewallAdd
         }
         'q'
         {
         }
     }
 }
 until ($selection -eq 'q')

