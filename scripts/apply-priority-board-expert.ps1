# Pack experto Priority board: muestra comandos y enlaces (Project 11).
# Ejecutar datos sin preguntas:
#   cd erp-satelite
#   python scripts/priority_board_hygiene.py --fill-size --bump-active-priority
#
# Param -Run ejecuta higiene sin dry-run (cuidado: escribe en GitHub).

param([switch]$Run)

Set-Location (Join-Path $PSScriptRoot "..")

Write-Host "=== Priority board — pack experto ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "1) Higiene de datos (Size en Ready/In progress/In review; No Priority -> P2 ahi):"
if ($Run) {
  python scripts/priority_board_hygiene.py --fill-size --bump-active-priority --sleep 0.15
} else {
  python scripts/priority_board_hygiene.py --dry-run --fill-size --bump-active-priority
  Write-Host "   Para aplicar: .\scripts\apply-priority-board-expert.ps1 -Run"
}
Write-Host ""
Write-Host "2) Vista 'Foco semana' (filtro activo): https://github.com/users/Abraha33/projects/11/views/10"
Write-Host "   Crear otra si hace falta: gh api -X POST users/Abraha33/projectsV2/11/views --input scripts/view-priority-foco-semana.json"
Write-Host ""
Write-Host "3) UI (replicar en views/2 y en Foco semana):" -ForegroundColor Yellow
Write-Host "   View -> Group by: Priority | Column field: Status | Field sum: Size"
Write-Host "   View -> Slice by: Priority"
Write-Host "   Sort (opcional): por Size desc en columnas de ejecucion"
Write-Host "   Column ... -> Column limit: Backlog 5, In progress 2, In review 5 (ajusta a tu gusto)"
Write-Host "   View -> Fields en tarjetas: Assignees, Labels, Milestone, Size, Priority, Status update"
Write-Host ""
