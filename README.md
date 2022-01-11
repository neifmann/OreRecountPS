# EVE online / OreRecountPS

Simple PowerShell Script for mining fleet booty calculation.

Usage. Execute script in powershell or windows termenal enveronment with fleet log file passed as argument

Example   .\HsMoonLogRecount.ps1 .\loot_moon.txt

Pay attention that fleet log file will be trimed to remove unnecessary lines.
There is an option to add () -match "Ice" or () -match "moon" function at trim step to get really nice state of fleet log file for that tipes of booty.

You can also set options like FleetCom, Cargoers and "noOrca" miners in script itself.
