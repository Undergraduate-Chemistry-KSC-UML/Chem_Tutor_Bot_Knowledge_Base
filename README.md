# Chemistry I & II Tutor Bot Instructional Material Host

This repository contains the chemistry instructional content used by the Chemistry I & II Tutor Bot developed by the Kennedy College of Sciences at The University of Massachusetts Lowell.

This repository hosts structured chemistry instructional material used as an open-source knowledge source for a Microsoft 365 Copilot agent retrieval system, but it can also be used by any LLM system that supports web-based retrieval or RAG pipelines.

All material is structured in Markdown and rendered into a documentation website using **MkDocs**.

---

##  Repository Structure

```
docs/      # Source Markdown files (lessons, chapters, study guides)
site/      # Generated static website (auto-built by MkDocs)
mkdocs.yml # MkDocs configuration
.venv/     # Local Python environment for documentation tools
```

- **`docs/` is the source of truth.**
- **`site/` is generated output** created by MkDocs and should not be edited manually.

---

## Content Organization

The `docs/` directory is organized to support **AI retrieval and chunking**:

- Each **course (CHEM1 and CHEM2)** has its own top-level folder.
- Each **chapter has its own directory**, containing multiple Markdown files.
- Each **Markdown file represents a single section/topic**, allowing retrieval systems to chunk content at the section level.
- Additional pages include:
    - a **Periodic Table reference page**
    - **course learning objectives and expectations (per course) provided by the instructor**

The instructional material is primarily derived from the OpenStax textbook: https://openstax.org/books/chemistry-atoms-first-2e/pages/1-introduction

*Extra practice problems to be added in the future, provided by the instructor

---

## Running Locally

### 1. Activate the virtual environment

```
source .venv/bin/activate
```

If the environment does not exist, create one:

```
python-m venv .venv
source .venv/bin/activate
pip install mkdocs mkdocs-material mkdocs-awesome-pages-plugin
```

---

### 2. Start the local site

```
mkdocs serve
```

Then open:

```
http://127.0.0.1:8000
```

This launches a live preview of the documentation site.

---

### 3. Build the static site

```
mkdocs build
```

The generated website will be written to:

```
site/
```

---

## Editing Content

1. Add or edit Markdown files inside `docs/`
2. Preview changes with:

```
mkdocs serve
```

1. Build the final site with:

```
mkdocs build
```

---

## Deployment

The documentation site is deployed using **GitHub Pages** so the instructional material can be accessed publicly and used as an open-source knowledge base.

When the final site is built, the static HTML output in the `site/` directory is published through GitHub Pages. This allows the content to be:

- browsed by humans as a documentation website
- accessed by AI systems that support **web-based retrieval or RAG pipelines**

Because the site is static, it can be easily indexed and retrieved by tools such as Microsoft 365 Copilot agents or other LLM-based systems.