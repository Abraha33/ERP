# Crea vistas en GitHub Project 11 (usuario Abraha33).
# Requiere: gh auth login con scope project
# Si la vista ya existe, la API puede devolver error 422.

$Header = "X-GitHub-Api-Version: 2026-03-10"
$Base = "users/Abraha33/projectsV2/11/views"

function New-ProjectView($name, $layout) {
    $tmp = [System.IO.Path]::GetTempFileName()
    @{ name = $name; layout = $layout } | ConvertTo-Json -Compress | Set-Content -Path $tmp -Encoding UTF8
    gh api -X POST -H $Header $Base --input $tmp
    Remove-Item $tmp
}

# Descomenta solo si necesitas recrearlas:
# New-ProjectView "Priority board" "board"
# New-ProjectView "Team items" "board"
# gh api ... --input view-team-table.json      # Equipo · inventario (tabla)
# .\apply-team-view-fields.ps1                 # Actualizar columnas de Team items (views/3) sin nueva pestaña
# gh api ... --input view-my-items-table.json  # Mis ítems · foco (tabla + assignee:@me)
# gh api -X POST .../fields --input field-size.json   # campo Size (number)
# New-ProjectView "Roadmap" "roadmap"
# gh api ... --input view-roadmap.json           # Roadmap · 14 meses (filtro -status:Done)
# gh api ... --input view-priority-foco-semana.json   # Foco semana (Ready | In progress | In review)
# gh api -X POST .../fields --input field-roadmap-inicio.json
# gh api -X POST .../fields --input field-roadmap-fin.json
# gh api -X POST .../fields --input field-status-update.json
# gh api graphql ... replace-priority-palette.graphql + python migrate_priority_palette.py
# gh api ... --input view-my-items.json   # ver JSON con filter assignee:@me

Write-Host "Vistas documentadas. Edita este script y descomenta las lineas New-ProjectView para ejecutar."
