# developed by Neifmann 
# https://github.com/neifmann
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force

# Set input log file full path
$InputFile = "E:\pstemp\Loot - 2021.04.20 20.30.32.txt"

# Set output file 
$OutputFile = "E:\pstemp\Loot - 2021.04.20 20.30.32 - recounted.txt"

$data = @()

Write-Host "-----------------------------"

(Get-Content $InputFile) | ? {$_.trim() -ne "" } | set-content $InputFile
(Get-Content $InputFile) -notmatch "Time	Character	Item Type	Quantity	Item Group" | Out-File $InputFile

$text = Get-Content -path $InputFile

#list of pilots
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

    if ( !($properties.name -in $data) ) {

        $data += $properties.name

    }

}

Start-Transcript -path $OutputFile -append 

#iterate over the list of pilots
foreach ($name in $data) {

    $Veldspar = 0
    $ConcentratedVeldspar = 0
    $DenseVeldspar = 0

    $Scordite = 0
    $CondensedScordite = 0
    $MassiveScordite = 0

    $Pyroxeres = 0
    $SolidPyroxeres = 0
    $ViscousPyroxeres = 0

    $Plagioclase = 0
    $AzurePlagioclase = 0
    $RichPlagioclase = 0

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
                Veldspar { $Veldspar += $properties.Quantity }
                ConcentratedVeldspar { $ConcentratedVeldspar += $properties.Quantity }
                DenseVeldspar { $DenseVeldspar += $properties.Quantity }
                
                Scordite { $Scordite += $properties.Quantity }
                CondensedScordite { $CondensedScordite += $properties.Quantity }
                MassiveScordite { $MassiveScordite += $properties.Quantity }
                
                Pyroxeres { $Pyroxeres += $properties.Quantity }
                SolidPyroxeres { $SolidPyroxeres += $properties.Quantity }
                ViscousPyroxeres { $ViscousPyroxeres += $properties.Quantity }
                
                Plagioclase { $Plagioclase += $properties.Quantity }
                AzurePlagioclase { $AzurePlagioclase += $properties.Quantity }
                RichPlagioclase { $RichPlagioclase += $properties.Quantity }
            }

        }
    }

    #volimes
    $VolumeOfVeldspar = $Veldspar*0.10
    $VolumeOfConcentratedVeldspar = $ConcentratedVeldspar*0.10
    $VolumeOfDenseVeldspar = $DenseVeldspar*0.10

    $VolumeOfScordite = $Scordite*0.15
    $VolumeOfCondensedScordite = $CondensedScordite*0.15
    $VolumeOfMassiveScordite = $MassiveScordite*0.15

    $VolumeOfPyroxeres = $Pyroxeres*0.3
    $VolumeOfSolidSolidPyroxeres = $SolidSolidPyroxeres*0.3
    $VolumeOfViscousPyroxeres = $ViscousPyroxeres*0.3

    $VolumeOfPlagioclase = $Plagioclase*0.35
    $VolumeOfAzurePlagioclase = $AzurePlagioclase*0.35
    $VolumeOfRichPlagioclase = $RichPlagioclase*0.35

    $sumVolume = $VolumeOfVeldspar + $VolumeOfConcentratedVeldspar + $VolumeOfDenseVeldspar + $VolumeOfScordite + $VolumeOfCondensedScordite + $VolumeOfMassiveScordite + $VolumeOfPyroxeres + $VolumeOfSolidSolidPyroxeres + $VolumeOfViscousPyroxeres + $VolumeOfPlagioclase + $VolumeOfAzurePlagioclase + $VolumeOfRichPlagioclase

    #final output
    Write-Host "
    --------------$name---------------
    
    Veldspar: $Veldspar
    Concentrated Veldspar: $ConcentratedVeldspar
    Dense Veldspar: $DenseVeldspar
    
    Scordite: $Scordite
    Condensed Scordite: $CondensedScordite
    Massive Scordite: $MassiveScordite
    
    Pyroxeres: $Pyroxeres
    Solid Pyroxeres: $SolidPyroxeres
    Viscous Pyroxeres: $ViscousPyroxeres
    
    Plagioclase: $Plagioclase
    Azure Plagioclase: $AzurePlagioclase
    Rich Plagioclase: $RichPlagioclase

    SumVolume: $sumVolume
    "
}

Stop-Transcript