#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
cd "$repo_root"

branch="$(git branch --show-current)"
if [[ "$branch" != "main" ]]; then
  echo "Expected to be on branch main, but found: $branch" >&2
  exit 1
fi

echo "Building MkDocs site..."
mkdocs build

required_files=(
  "docs/CHEM1 /Molecular_Geometry.md"
  "docs/CHEM1 /Periodic_Table.md"
  "docs/CHEM2/Molecular_Geometry.md"
  "docs/CHEM2/Periodic_Table.md"
  "docs/molecular_geometry_vsepr_table.png"
  "docs/CHEM1 /CHEM1_SHEET.md"
  "docs/CHEM2/CHEM2_SHEET.md"
)

required_pages=(
  "site/CHEM1 /Molecular_Geometry/index.html"
  "site/CHEM1 /Periodic_Table/index.html"
  "site/CHEM2/Molecular_Geometry/index.html"
  "site/CHEM2/Periodic_Table/index.html"
  "site/CHEM1 /CHEM1_SHEET/index.html"
  "site/CHEM2/CHEM2_SHEET/index.html"
)

raw_site_markdown=(
  "site/CHEM1 /Molecular_Geometry.md"
  "site/CHEM1 /Periodic_Table.md"
  "site/CHEM2/Molecular_Geometry.md"
  "site/CHEM2/Periodic_Table.md"
  "site/CHEM1 /CHEM1_SHEET.md"
  "site/CHEM2/CHEM2_SHEET.md"
)

obsolete_pages=(
  "site/Molecular_Geometry/index.html"
  "site/Periodic_Table/index.html"
)

for required_file in "${required_files[@]}"; do
  if [[ ! -f "$required_file" ]]; then
    echo "Missing required file: $required_file" >&2
    exit 1
  fi
done

for required_page in "${required_pages[@]}"; do
  if [[ ! -f "$required_page" ]]; then
    echo "MkDocs did not generate expected page: $required_page" >&2
    exit 1
  fi
done

for raw_site_file in "${raw_site_markdown[@]}"; do
  if [[ -e "$raw_site_file" ]]; then
    echo "Unexpected raw Markdown remained in site output: $raw_site_file" >&2
    exit 1
  fi
done

for obsolete_page in "${obsolete_pages[@]}"; do
  if [[ -e "$obsolete_page" ]]; then
    echo "Obsolete generated page still exists: $obsolete_page" >&2
    exit 1
  fi
done

echo "Staging source, generated site output, and deploy script..."
git add mkdocs.yml docs/index.md "${required_files[@]}" site scripts/deploy_chem1_sheet.sh

if git diff --cached --quiet; then
  echo "No staged changes to commit."
else
  echo "Creating commit..."
  git commit -m "Render instructional material pages"
fi

echo "Pushing to origin/main..."
git push origin main

echo "Deploying rendered site to GitHub Pages..."
mkdocs gh-deploy --clean --remote-name origin --remote-branch gh-pages --force

echo "Done. GitHub Pages may take a minute or two to refresh:"
echo "https://undergraduate-chemistry-ksc-uml.github.io/Chem_Tutor_Bot_Knowledge_Base/"
