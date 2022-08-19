#Installer

foreach ($txt in "Firstname.txt","Surname.txt","used.txt","usedFull.txt","possibleFull.txt"){
    if (!(Test-Path -Path $txt)){
        New-Item -Path $txt -ErrorAction SilentlyContinue | Out-Null
        Write-Host "$txt created" -ForegroundColor Green
    }
}

# Global Variables 
$Firstname=Get-Content -path "Firstname.txt"
$Surname=Get-Content -path "Surname.txt"
$Used=Get-Content -Path "used.txt"
$UsedFull=Get-Content -Path "usedFull.txt"

#Create all possible Name combinations
Clear-Content -Path "possibleFull.txt"
foreach ($v in $Firstname){foreach ($n in $Surname){Add-Content -path "possibleFull.txt" "$v $n"}}
$PossibleFull=Get-Content -Path "possibleFull.txt"

#Create a list of items, which differ from the already used firstname list
function diffV {
    $diffV= $Firstname | Where {$Used -notcontains $_}
    return $diffV
}

#Create a list of items, which differ from the already used Fullname list
function diffF{
    $diffF= $PossibleFull | Where {$UsedFull -notcontains $_}
    return $diffF
}

#Get Random not used firstname
function Firstname{
    $diffFirstname = diffV
    if ($diffFirstname.length -eq 0){
            Write-Host "`nAll Names already used!`n" -ForegroundColor "Red"
            return
        }
        else {
            $genName = Get-Random -InputObject $diffFirstname
        }
    Add-Content -Path "used.txt" "$genName"
    write-Host "`n$genName`n" -ForegroundColor "DarkYellow"
}

#Get Random not used full name
function Fullname{
    $diffFull= diffF
    if ($diffFull.length -eq 0){            
        Write-Host "`nAll Names already used!`n" -ForegroundColor "Red" 
        return
    }

    else{
        $genName = Get-Random -InputObject $diffFull
    }
    Add-Content -Path "usedFull.txt" "$genName"
    write-Host "`n$genName`n"  -ForegroundColor "DarkYellow"
}

#Option picker 
Write-Host "Semi-Random Name Generator"
function Choose{
    $Choose=Read-Host -Prompt "Please pick an option`n1) Firstname`n2) First- & Surname`n0) Ende"
    
    switch ($Choose){
        1 {Firstname}
        2 {Fullname}
        0 {exit}
        default {"Ungueltig"}
     }
}

while ($true){
    Choose
    $Used=Get-Content -Path "used.txt"
    $UsedFull=Get-Content -Path "usedFull.txt"
}
