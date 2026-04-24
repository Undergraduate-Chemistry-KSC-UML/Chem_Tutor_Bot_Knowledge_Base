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

sheet_source="docs/CHEM1 /CHEM1_SHEET.md"
sheet_page="site/CHEM1 /CHEM1_SHEET/index.html"
raw_site_sheet="site/CHEM1 /CHEM1_SHEET.md"

if [[ ! -f "$sheet_source" ]]; then
  echo "Missing source sheet: $sheet_source" >&2
  exit 1
fi

if [[ ! -f "$sheet_page" ]]; then
  echo "MkDocs did not generate expected page: $sheet_page" >&2
  exit 1
fi

if [[ -e "$raw_site_sheet" ]]; then
  echo "Unexpected raw Markdown remained in site output: $raw_site_sheet" >&2
  exit 1
fi

echo "Staging source, generated site output, and deploy script..."
git add mkdocs.yml docs/index.md "$sheet_source" site scripts/deploy_chem1_sheet.sh

if git diff --cached --quiet; then
  echo "No staged changes to commit."
else
  echo "Creating commit..."
  git commit -m "Render CHEM1 sheet page"
fi

echo "Pushing to origin/main..."
git push origin main

echo "Deploying rendered site to GitHub Pages..."
mkdocs gh-deploy --clean --remote-name origin --remote-branch gh-pages --force

echo "Done. GitHub Pages may take a minute or two to refresh:"
echo "https://undergraduate-chemistry-ksc-uml.github.io/Chem_Tutor_Bot_Knowledge_Base/"
