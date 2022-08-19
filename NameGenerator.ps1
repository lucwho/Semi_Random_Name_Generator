$Vorname=Get-Content -path "Vornamen.txt"
$Nachname=Get-Content -path "Nachnamen.txt"
$Used=Get-Content -Path "used.txt"
$UsedFull=Get-Content -Path "usedFull.txt"
Clear-Content -Path "possibleFull.txt"
foreach ($v in $Vorname){foreach ($n in $Nachname){Add-Content -path "possibleFull.txt" "$v $n"}}
$PossibleFull=Get-Content -Path "possibleFull.txt"
function diffV {
    $diffV= $Vorname | Where {$Used -notcontains $_}
    return $diffV
}

function diffF{
    $diffF= $PossibleFull | Where {$UsedFull -notcontains $_}
    return $diffF
}
function Surname{
    $diffVorname = diffV
    if ($diffVorname.length -eq 0){
            Write-Host "`nAlle Namen bereits verwendet!`n" -ForegroundColor "Red"
            return
        }
        else {
            $genName = Get-Random -InputObject $diffVorname
        }
    Add-Content -Path "used.txt" "$genName"
    write-Host "`n$genName`n" -ForegroundColor "DarkYellow"
}

function Fullname{
    $diffFull= diffF
    if ($diffFull.length -eq 0){            
        Write-Host "`nAlle Namen bereits verwendet!`n" -ForegroundColor "Red" 
        return
    }

    else{
        $genName = Get-Random -InputObject $diffFull
    }
    Add-Content -Path "usedFull.txt" "$genName"
    write-Host "`n$genName`n"  -ForegroundColor "DarkYellow"
}

Write-Host "Semi-Random Name Generator"
function Auswahl{
    $Auswahl=Read-Host -Prompt "Bitte Waehle eine Option`n1) Vorname`n2) Vor- & Nachname`n0) Ende"
    
    switch ($Auswahl){
        1 {Surname}
        2 {Fullname}
        0 {exit}
        default {"Ungueltig"}
     }
    }
    
    while ($true){
        Auswahl
        $Used=Get-Content -Path "used.txt"
        $UsedFull=Get-Content -Path "usedFull.txt"
    }
