#
# developed by Neifmann 
# https://github.com/neifmann
# https://github.com/DmitryShevkun
#
# https://github.com/neifmann/OreRecountPS
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
$sumIceVolume = 0
$sumIce = 0
$pilotList = @()



#operate data and write debug output
Start-Transcript -path $debugFile -Force

Write-Host "-----------------------------"

#trim input file to remove unnecessary lines
((Get-Content $InputFile) | ? {$_.trim() -ne "" }) -notmatch "Time	Character	Item Type	Quantity	Item Group" | Out-File $InputFile

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

    if ( !($properties.name -in $data) -and !( $properties.name -in $excludedPersons ) ) {

        $pilotList += $properties.name

    }

}



Stop-Transcript

Write-Host "-----------------------------"

Start-Transcript -path $OutputFile -Force



#iterate over pilots in spades list
foreach ($name in $pilotList) {

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
    
    Clear Icicle: $ClearIcicle
    White Glaze: $WhiteGlaze
    Blue Ice: $BlueIce
    Glacial Mass: $GlacialMass

    Enriched Clear Icicle: $EnrichedClearIcicle
    Pristine White Glaze: $PristineWhiteGlaze
    Thick Blue Ice: $ThickBlueIce
    Smooth Glacial Mass: $SmoothGlacialMass

    Glare Crust: $GlareCrust
    Dark Glitter: $DarkGlitter
    Gelidus: $Gelidus
    Krystallos: $Krystallos

    Ice Number: $Ice
    Ice Volume: $iceVolume
    "
}

Write-Host "
    ---------------Summary---------------

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
