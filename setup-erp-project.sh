#!/bin/bash
# ERP SATELITE - SETUP COMPLETO IGUAL QUE API-DIAN
# Ejecutar en Git Bash: bash setup-erp-project.sh

USERNAME="Abraha33"
REPO="erp-satelite"
PROJECT_NUMBER=11

echo "======================================"
echo " ERP SATELITE - SETUP (estilo API-Dian)"
echo "======================================"

# 0. CONFIGURAR REPO (descripcion, topics)
echo ""
echo "Configurando repo..."
gh repo edit "$USERNAME/$REPO" \
  --description "ERP + CRM integrado. App Satelite, catalogos, compras, ventas, inventario. 14 meses. Stack por definir." \
  --add-topic "erp" \
  --add-topic "crm" \
  --add-topic "supabase" \
  --add-topic "saas" \
  --add-topic "inventario" \
  --add-topic "facturacion" 2>/dev/null || true
echo "  Repo configurado."

# 1. PROJECT ID
PROJECT_ID=$(gh api graphql -f query='
query($owner: String!, $number: Int!) {
  user(login: $owner) {
    projectV2(number: $number) { id }
  }
}' -f owner="$USERNAME" -F number=$PROJECT_NUMBER \
   --jq '.data.user.projectV2.id')
echo "PROJECT_ID: $PROJECT_ID"

# 1b. CAMPO "Status update" (texto: bloqueo, % listo, nota corta por tarjeta)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATUS_UPDATE_JSON="$SCRIPT_DIR/erp-satelite/scripts/field-status-update.json"
echo ""
echo "Campo Status update..."
if gh api "users/$USERNAME/projectsV2/$PROJECT_NUMBER/fields" 2>/dev/null | jq -e '.[] | select(.name == "Status update")' >/dev/null 2>&1; then
  echo "  Ya existe: Status update"
else
  if [ -f "$STATUS_UPDATE_JSON" ]; then
    if gh api -X POST "users/$USERNAME/projectsV2/$PROJECT_NUMBER/fields" --input "$STATUS_UPDATE_JSON" 2>/dev/null; then
      echo "  OK: Status update creado"
    else
      echo "  Error al crear Status update (¿campo duplicado o sin permiso project?)"
    fi
  else
    echo "  Aviso: no se encontro $STATUS_UPDATE_JSON — anade el campo en GitHub: Project -> ... -> Fields -> New field -> Text"
  fi
fi

# 2. LEER STATUS FIELD
STATUS_JSON=$(gh api graphql -f query='
query($id: ID!) {
  node(id: $id) {
    ... on ProjectV2 {
      fields(first: 20) {
        nodes {
          ... on ProjectV2SingleSelectField {
            id name
            options { id name }
          }
        }
      }
    }
  }
}' -f id="$PROJECT_ID" --jq '.data.node.fields.nodes[] | select(.name=="Status")')

STATUS_FIELD_ID=$(echo "$STATUS_JSON" | jq -r '.id')
echo "STATUS_FIELD_ID: $STATUS_FIELD_ID"

# 3. OPCIONES STATUS — el esquema canónico (Icebox + 5 columnas) está en erp-satelite/scripts/graphql/replace-status-priority-board.graphql
#    y se aplica con: python scripts/migrate_status_to_priority_board.py
#    El bucle siguiente es legacy; puede ser destructivo si solo pasa una opción al API.
for NAME in "Icebox" "Backlog" "Ready" "In progress" "In review" "Done"; do
  EXISTS=$(echo "$STATUS_JSON" | jq -r --arg n "$NAME" '.options[] | select(.name==$n) | .name')
  if [ -z "$EXISTS" ]; then
    echo "Creando opcion: $NAME"
    gh api graphql -f query='
    mutation($p: ID!, $f: ID!, $n: String!) {
      updateProjectV2Field(input:{
        projectId: $p, fieldId: $f
        singleSelectOptions: [{name: $n, color: GRAY, description: ""}]
      }) { projectV2Field { ... on ProjectV2SingleSelectField { id } } }
    }' -f p="$PROJECT_ID" -f f="$STATUS_FIELD_ID" -f n="$NAME" >/dev/null 2>&1
    echo "  OK: $NAME creado"
  else
    echo "  Ya existe: $NAME"
  fi
done

# 4. RE-LEER OPCIONES ACTUALIZADAS
STATUS_JSON=$(gh api graphql -f query='
query($id: ID!) {
  node(id: $id) {
    ... on ProjectV2 {
      fields(first: 20) {
        nodes {
          ... on ProjectV2SingleSelectField {
            id name
            options { id name }
          }
        }
      }
    }
  }
}' -f id="$PROJECT_ID" --jq '.data.node.fields.nodes[] | select(.name=="Status")')

BACKLOG_ID=$(echo "$STATUS_JSON" | jq -r '.options[] | select(.name=="Backlog") | .id')
echo "BACKLOG_ID: $BACKLOG_ID"

echo "Opciones Status:"
echo "$STATUS_JSON" | jq -r '.options[] | "  - " + .name'

# 5. VINCULAR 42 ISSUES AL PROJECT
echo ""
echo "Vinculando issues..."
gh api graphql -f query='
query($owner: String!, $repo: String!) {
  repository(owner: $owner, name: $repo) {
    issues(first: 100, states: OPEN) {
      nodes { id number }
    }
  }
}' -f owner="$USERNAME" -f repo="$REPO" \
   --jq '.data.repository.issues.nodes[]' | jq -c '.' | while read -r issue; do
  ID=$(echo "$issue" | jq -r '.id')
  NUM=$(echo "$issue" | jq -r '.number')
  echo -n "  #$NUM ... "
  gh api graphql -f query='
  mutation($p: ID!, $c: ID!) {
    addProjectV2ItemById(input:{projectId:$p, contentId:$c}) {
      item { id }
    }
  }' -f p="$PROJECT_ID" -f c="$ID" >/dev/null 2>&1 && echo "OK" || echo "ya existe"
done

# 6. SETEAR STATUS=BACKLOG EN TODOS LOS ITEMS
echo ""
echo "Seteando Status=Backlog en todos los items..."
gh api graphql -f query='
query($id: ID!) {
  node(id: $id) {
    ... on ProjectV2 {
      items(first: 100) {
        nodes { id }
      }
    }
  }
}' -f id="$PROJECT_ID" --jq '.data.node.items.nodes[].id' | while read -r ITEM_ID; do
  echo -n "  $ITEM_ID ... "
  gh api graphql -f query='
  mutation($p: ID!, $i: ID!, $f: ID!, $o: String!) {
    updateProjectV2ItemFieldValue(input:{
      projectId:$p, itemId:$i, fieldId:$f
      value:{ singleSelectOptionId:$o }
    }) { projectV2Item { id } }
  }' -f p="$PROJECT_ID" -f i="$ITEM_ID" \
     -f f="$STATUS_FIELD_ID" -f o="$BACKLOG_ID" \
     >/dev/null 2>&1 && echo "OK" || echo "error"
done

echo ""
echo "======================================"
echo " SCRIPT LISTO"
echo "======================================"
echo ""
echo "PASO FINAL - 2 minutos en el navegador:"
echo ""
echo "STATUS UPDATE (columna opcional en tablas):"
echo "  En vistas Equipo / Mis items: View -> Fields -> activa 'Status update'"
echo ""
echo "BOARD:"
echo "  https://github.com/users/$USERNAME/projects/$PROJECT_NUMBER"
echo "  View 1 -> ... -> Layout -> Board -> renombra a 'Backlog'"
echo ""
echo "WORKFLOWS (7) — ver erp-satelite/docs/GITHUB_PROJECT_WORKFLOWS.md"
echo "  https://github.com/users/$USERNAME/projects/$PROJECT_NUMBER/workflows"
echo "  1) Item added to project     -> Status: Backlog     -> Save and turn on"
echo "  2) Issue/PR closed           -> Status: Done        -> ON (suele estar ya)"
echo "  3) Pull request merged       -> Status: Done        -> ON (suele estar ya)"
echo "  4) Issue reopened            -> Status: Backlog     -> Save and turn on"
echo "  5) Auto-close issue (Done) -> close issue en repo -> Save and turn on"
echo "  6) Auto-add to project       -> repo: $USERNAME/$REPO  filtro: is:issue (o assignee:$USERNAME)"
echo "  7) Auto-archive (opcional)   -> filtro conservador o OFF — ver doc"
echo "======================================"
