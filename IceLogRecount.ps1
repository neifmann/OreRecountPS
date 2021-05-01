# developed by Neifmann 
# https://github.com/neifmann
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force

# Set input log file full path
$InputFile = "E:\pstemp\Loot - 2021.04.23 20.47.25.txt"

# Set debug file
$debugFile = "E:\pstemp\debug.txt"

# Set output file 
$OutputFile = "E:\pstemp\Loot - 2021.04.23 20.47.25 - out.txt"

# Set FleetCom pilot
$fleetCom = @(
            'Natalie Moreau'
            )

# Set trucks pilots Names
$trucks = @(
            'Arife Frostbreeze'
            )

# Set pilots who did not storing ore in Orca
$noOrka = @(
            'Gentle Locksmith',
            'BoB Pu4inski',
            'Boaten4 Boatz',
            'Dazutlek UnDead'
            )



#initialize variables
$excludedPersons = $trucks + $noOrka
$sumIceVolume = 0
$sumIce = 0
$pilotsList = @()

Start-Transcript -path $debugFile -Force

Write-Host "-----------------------------"

$text = (((Get-Content $InputFile) | ? {$_.trim() -ne "" }) -notmatch "Time	Character	Item Type	Quantity	Item Group") -match "Ice"

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

        $pilotsList += $properties.name

    }

}

Stop-Transcript

Write-Host "-----------------------------"

Start-Transcript -path $OutputFile -Force

#iterate over pilots in spades list
foreach ($name in $pilotsList) {

    $ClearIcicle = 0
    $WhiteGlaze = 0
    $BlueIce = 0
    $GlacialMass = 0

    $EnrichedClearIcicle = 0
    $PristineWhiteGlaze = 0
    $ThickBlueIce = 0
    $SmoothGlacialMass = 0

    $GlareCrust = 0
    $DarkGlitter = 0
    $Gelidus = 0
    $Krystallos = 0

    $Ice = 0
    $iceVolume = 0

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
                ClearIcicle { $ClearIcicle += $properties.Quantity }
                WhiteGlaze { $WhiteGlaze += $properties.Quantity }
                BlueIce { $BlueIce += $properties.Quantity }
                GlacialMass { $GlacialMass += $properties.Quantity }

                EnrichedClearIcicle { $EnrichedClearIcicle += $properties.Quantity }
                PristineWhiteGlaze { $PristineWhiteGlaze += $properties.Quantity }
                ThickBlueIce { $ThickBlueIce += $properties.Quantity }
                SmoothGlacialMass { $SmoothGlacialMass += $properties.Quantity }

                GlareCrust { $GlareCrust += $properties.Quantity }
                DarkGlitter { $DarkGlitter += $properties.Quantity }
                Gelidus { $Gelidus += $properties.Quantity }
                Krystallos { $Krystallos += $properties.Quantity }
            }
        }
    }

    #Ice
    $Ice = $ClearIcicle + $WhiteGlaze + $BlueIce + $GlacialMass + $GlacialMass + $EnrichedClearIcicle + $PristineWhiteGlaze + $ThickBlueIce + $SmoothGlacialMass + $GlareCrust + $DarkGlitter + $Gelidus + $Krystallos
    $iceVolume = $Ice*1000

    $sumIce += $Ice
    $sumIceVolume += $iceVolume

    #final output
    Write-Host "
    --------------$name---------------
    
    ClearIcicle: $ClearIcicle
    White Glaze: $WhiteGlaze
    BlueIce: $BlueIce
    GlacialMass: $GlacialMass

    EnrichedClearIcicle: $EnrichedClearIcicle
    PristineWhiteGlaze: $PristineWhiteGlaze
    ThickBlueIce: $ThickBlueIce
    SmoothGlacialMass: $SmoothGlacialMass

    GlareCrust: $GlareCrust
    DarkGlitter: $DarkGlitter
    Gelidus: $Gelidus
    Krystallos: $Krystallos

    Ice Number: $Ice
    Ice Volume: $iceVolume
    "
}

Write-Host "
    ---------------------------------------------

    Summary

    Fleet Com:"
"    " + $fleetCom

Write-Host "
    Trucks:"
"    " + $trucks

Write-Host "
    Privat diggers:"
$noOrka

Write-Host "
    Sum Ice:"
"    " + $sumIce

Write-Host "
    Sum Ice Value:"
"    " + $sumIceVolume

Write-Host " "
Stop-Transcript