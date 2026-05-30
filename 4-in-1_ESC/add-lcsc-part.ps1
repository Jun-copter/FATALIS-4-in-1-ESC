param(
    [Parameter(Mandatory)]
    [string]$LcscId
)

$ErrorActionPreference = "Stop"
$ProjectDir  = $PSScriptRoot
$LibsDir     = Join-Path $ProjectDir "libs"
$OutputBase  = Join-Path $LibsDir "easyeda_import"
$LibsDirFwd  = $LibsDir.Replace('\', '/')
$Utf8NoBom   = [System.Text.UTF8Encoding]::new($false)

# Download symbol, footprint, and 3D model
Write-Host "Downloading $LcscId from EasyEDA/LCSC..."
python -m easyeda2kicad --full --lcsc_id $LcscId --output $OutputBase

# Fix absolute 3D model paths -> ${KIPRJMOD} relative; write back without BOM
$fpDir = "$OutputBase.pretty"
if (Test-Path $fpDir) {
    Get-ChildItem $fpDir -Filter "*.kicad_mod" | ForEach-Object {
        $content = [System.IO.File]::ReadAllText($_.FullName)
        $fixed   = $content.Replace(
            "$LibsDirFwd/easyeda_import.3dshapes",
            '${KIPRJMOD}/libs/easyeda_import.3dshapes'
        )
        if ($fixed -ne $content) {
            [System.IO.File]::WriteAllText($_.FullName, $fixed, $Utf8NoBom)
            Write-Host "  Fixed 3D model path in $($_.Name)"
        }
    }
}

# Ensure sym-lib-table exists (no BOM — KiCad rejects files with BOM)
$symTable = Join-Path $ProjectDir "sym-lib-table"
if (-not (Test-Path $symTable)) {
    $symContent = "(sym_lib_table`n  (lib (name `"easyeda_import`")(type `"KiCad`")(uri `"`${KIPRJMOD}/libs/easyeda_import.kicad_sym`")(options `"`")(descr `"LCSC/EasyEDA imports`")))`n"
    [System.IO.File]::WriteAllText($symTable, $symContent, $Utf8NoBom)
    Write-Host "  Created sym-lib-table"
}

# Ensure fp-lib-table exists (no BOM)
$fpTable = Join-Path $ProjectDir "fp-lib-table"
if (-not (Test-Path $fpTable)) {
    $fpContent = "(fp_lib_table`n  (lib (name `"easyeda_import`")(type `"KiCad`")(uri `"`${KIPRJMOD}/libs/easyeda_import.pretty`")(options `"`")(descr `"LCSC/EasyEDA imports`")))`n"
    [System.IO.File]::WriteAllText($fpTable, $fpContent, $Utf8NoBom)
    Write-Host "  Created fp-lib-table"
}

Write-Host ""
Write-Host "Done. $LcscId is in the easyeda_import library."
Write-Host "Open KiCad schematic and press A to place the symbol."
