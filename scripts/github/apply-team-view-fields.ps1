# Intenta actualizar la vista TABLA existente (Team items = views/3 en Project 11) sin crear otra.
# Requiere: gh auth con alcance que permita escribir en Projects.
# Si obtienes 404, GitHub aun no expone PATCH para tu tipo de proyecto: aplica los campos a mano (ver docs/GITHUB_PROJECTS.md → Equipo · inventario).

$Header = "X-GitHub-Api-Version: 2026-03-10"
$UserId = gh api users/Abraha33 --jq .id
$Path = "users/$UserId/projectsV2/11/views/3"
$Input = Join-Path $PSScriptRoot "patch-view-team-visible-fields.json"

if (-not (Test-Path $Input)) {
    Write-Error "No existe $Input"
    exit 1
}

gh api -X PATCH -H $Header $Path --input $Input
