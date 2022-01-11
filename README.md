# EVE online / OreRecountPS

Simple PowerShell Script for mining fleet booty calculation.

Usage. Execute script in powershell or windows termenal enveronment with fleet log file passed as argument

Example   .\HsMoonLogRecount.ps1 .\loot_moon.txt

Pay attention!

Fleet log file will be trimed to remove unnecessary lines.
There is an option to add () -match "Ice" or () -match "moon" function at trim step to get really nice state of fleet log file for that tipes of booty.

It is strongly recomended to use english fleet log output because of others languages can be affected by text coding difficulties of powershell. It will not affect the calculation, but trimed fleet log file will have a bunch of crazy symbols.

You can also set options like FleetCom, Cargoers and "noOrca" miners in script itself.
