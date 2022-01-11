#
# developed by Neifmann 
# https://github.com/neifmann
#
# https://github.com/DmitryShevkun/OreRecountPS
#
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force

# Set input log file full path
$InputFile = $args[0]

# Set output file 
$OutputFile = "$InputFile - out.txt"

# Set debug file
$debugFile = "$InputFile - debug.txt"

# Set FleetCom pilot
$fleetCom = @(
            'John Doe'
            )

# Set trucks pilots Names
$trucks = @(
            'Jane Doe'
            )

# Set pilots who did not storing ore in Orca
$noOrka = @(
            'Jim Doe'
            )

#initialize variables
$excludedPersons = $trucks + $noOrka
$sumOreVolume = 0
$pilotList = @()



#operate data and write debug output
Start-Transcript -path $debugFile -Force

Write-Host "-----------------------------"

#trim input file to remove unnecessary lines
(((Get-Content $InputFile) | ? {$_.trim() -ne "" }) -notmatch "Time	Character	Item Type	Quantity	Item Group") -match "moon" | Out-File $InputFile

$text = Get-Content -path $InputFile

#get list of pilots
foreach($line in $text){
    $nline = $line.Split("	")

    $properties = @{
        'time'      = $nline[0]
        'name'      = $nline[1]
        'ItemType'  = $nline[2] -replace ">.*<","" -replace "localized","" -replace "hint","" -replace "\W",""
        'Quantity'  = $nline[3]
        'ItemGroup' = $nline[4] -replace ">.*<","" -replace "localized","" -replace "hint","" -replace "\W",""
    }
    
    $properties

    Write-Host "-----------------------------"

    if ( !($properties.name -in $pilotList) -and !( $properties.name -in $excludedPersons ) ) {

        $pilotList += $properties.name

    }

}



Stop-Transcript

Write-Host "-----------------------------"

Start-Transcript -path $OutputFile -Force



#iterate over pilots in spades list
foreach ($name in $pilotList) {

    $Zeolites = 0
    $BrimfulZeolites = 0
    $GlisteningZeolites = 0

    $Sylvite = 0
    $BrimfulSylvite = 0
    $GlisteningSylvite = 0

    $Coesite = 0
    $BrimfulCoesite = 0
    $GlisteningCoesite = 0

    $Bitumens = 0
    $BrimfulBitumens = 0
    $GlisteningBitumens = 0

    $oreVolume = 0

    foreach($line in $text){
        $nline = $line.Split("	")

        $properties = @{
            'time'  = $nline[0]
            'name'   = $nline[1]
            'ItemType' = $nline[2] -replace ">.*<","" -replace "localized","" -replace "hint","" -replace "\W",""
            'Quantity' = $nline[3]
            'ItemGroup' = $nline[4] -replace ">.*<","" -replace "localized","" -replace "hint","" -replace "\W",""
        }

        if ( $properties.name -eq $name ) {

            switch ($properties.ItemType) {
                Zeolites { $Zeolites += $properties.Quantity }
                BrimfulZeolites { $BrimfulZeolites += $properties.Quantity }
                GlisteningZeolites { $GlisteningZeolites += $properties.Quantity }
                
                Sylvite { $Sylvite += $properties.Quantity }
                BrimfulSylvite { $BrimfulSylvite += $properties.Quantity }
                GlisteningSylvite { $GlisteningSylvite += $properties.Quantity }
                
                Coesite { $Coesite += $properties.Quantity }
                BrimfulCoesite { $BrimfulCoesite += $properties.Quantity }
                GlisteningCoesite { $GlisteningCoesite += $properties.Quantity }
                
                Bitumens { $Bitumens += $properties.Quantity }
                BrimfulBitumens { $BrimfulBitumens += $properties.Quantity }
                GlisteningBitumens { $GlisteningBitumens += $properties.Quantity }
            }

        }

    }

    #volimes
    $oreVolume = 10 * ( $Zeolites + $BrimfulZeolites + $GlisteningZeolites + $Sylvite + $BrimfulSylvite + $GlisteningSylvite + $Coesite + $BrimfulCoesite + $GlisteningCoesite + $Bitumens + $BrimfulBitumens + $GlisteningBitumens )
    $sumOreVolume += $oreVolume

    #final output
    Write-Host "
    --------------$name---------------
    
    Zeolites: $Zeolites
    Brimful Zeolites: $BrimfulZeolites
    Glistening Zeolites: $GlisteningZeolites
    
    Sylvite: $Sylvite
    Brimful Sylvite: $BrimfulSylvite
    Glistening Sylvite: $GlisteningSylvite
    
    Coesite: $Coesite
    Brimful Coesite: $BrimfulCoesite
    Glistening Coesite: $GlisteningCoesite
    
    Bitumens: $Bitumens
    Brimful Bitumens: $BrimfulBitumens
    Glistening Bitumens: $GlisteningBitumens

    Ore Volume: $oreVolume
    "
}

Write-Host "Summary

Fleet Com:"
$fleetCom

Write-Host "
Trucks:"
$trucks

Write-Host "
Privat diggers:"
$noOrka

Write-Host "
Sum Ore Volume:"
$sumOreVolume



Write-Host " "
Stop-Transcript