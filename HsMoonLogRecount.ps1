# developed by Neifmann 
# https://github.com/neifmann
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force

# Set input log file full path
$InputFile = "E:\pstemp\Loot_-_2021.03.06_14.53.32.txt"

# Set output file 
$OutputFile = "E:\pstemp\out.txt"

# Set FleetCom pilot
$fleetCom = @()

# Set trucks pilots Names
$trucks = @()

# Set pilots who did not storing ore in Orca
$noOrka = @()



#initialize variables
$excludedPersons = $trucks + $noOrka
$sumOreVolume = 0
$data = @()

Write-Host "-----------------------------"

(Get-Content $InputFile) | ? {$_.trim() -ne "" } | set-content $InputFile
(Get-Content $InputFile) -notmatch "Time	Character	Item Type	Quantity	Item Group" | Out-File $InputFile

$text = Get-Content -path $InputFile

#get list of pilots
foreach($line in $text){
    $nline = $line.Split("	")

    $properties = @{
        'time'  = $nline[0]
        'name'   = $nline[1]
        'ItemType' = $nline[2] -replace ">.*<","" -replace "localized","" -replace "hint","" -replace "\W",""
        'Quantity' = $nline[3]
        'ItemGroup' = $nline[4] -replace ">.*<","" -replace "localized","" -replace "hint","" -replace "\W",""
    }
    
    $properties

    Write-Host "-----------------------------"

    if ( !($properties.name -in $data) -and !( $properties.name -in $excludedPersons ) ) {

        $data += $properties.name

    }

}

Start-Transcript -path $OutputFile -Force

#iterate over pilots in spades list
foreach ($name in $data) {

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