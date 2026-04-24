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

sheet_sources=(
  "docs/CHEM1 /CHEM1_SHEET.md"
  "docs/CHEM2/CHEM2_SHEET.md"
)

sheet_pages=(
  "site/CHEM1 /CHEM1_SHEET/index.html"
  "site/CHEM2/CHEM2_SHEET/index.html"
)

raw_site_sheets=(
  "site/CHEM1 /CHEM1_SHEET.md"
  "site/CHEM2/CHEM2_SHEET.md"
)

for sheet_source in "${sheet_sources[@]}"; do
  if [[ ! -f "$sheet_source" ]]; then
    echo "Missing source sheet: $sheet_source" >&2
    exit 1
  fi
done

for sheet_page in "${sheet_pages[@]}"; do
  if [[ ! -f "$sheet_page" ]]; then
    echo "MkDocs did not generate expected page: $sheet_page" >&2
    exit 1
  fi
done

for raw_site_sheet in "${raw_site_sheets[@]}"; do
  if [[ -e "$raw_site_sheet" ]]; then
    echo "Unexpected raw Markdown remained in site output: $raw_site_sheet" >&2
    exit 1
  fi
done

echo "Staging source, generated site output, and deploy script..."
git add mkdocs.yml docs/index.md "${sheet_sources[@]}" site scripts/deploy_chem1_sheet.sh

if git diff --cached --quiet; then
  echo "No staged changes to commit."
else
  echo "Creating commit..."
  git commit -m "Render chemistry sheet pages"
fi

echo "Pushing to origin/main..."
git push origin main

echo "Deploying rendered site to GitHub Pages..."
mkdocs gh-deploy --clean --remote-name origin --remote-branch gh-pages --force

echo "Done. GitHub Pages may take a minute or two to refresh:"
echo "https://undergraduate-chemistry-ksc-uml.github.io/Chem_Tutor_Bot_Knowledge_Base/"
