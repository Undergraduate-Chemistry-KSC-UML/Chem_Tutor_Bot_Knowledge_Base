# Chemistry Tutor Bot Knowledge Base

This repository contains the approved Chemistry I and Chemistry II instructional material used by the University of Massachusetts Lowell Chemistry Tutor Bot.

The project is designed for a Microsoft 365 Copilot agent or another retrieval-based tutoring system. The bot should answer only from this knowledge base, guide students through chemistry work without solving for them, and reject anything outside the approved course scope.

## What This Repository Does

This repo is the source of truth for the tutor bot's chemistry knowledge base.

It provides:

- Markdown course material for Chemistry I and Chemistry II
- high-priority reference sheets for formulas, constants, conversions, solubility rules, particle masses, and periodic-table values
- molecular geometry reference files for each course
- course learning objectives for study planning and practice selection
- a MkDocs site that publishes the material for human reading and retrieval workflows
- the Copilot agent prompt in `copilotagent.md`

## Repository Structure

```text
.
|-- README.md
|-- copilotagent.md
|-- mkdocs.yml
|-- docs/
|   |-- index.md
|   |-- CHEM1 /
|   |   |-- CHEM1_SHEET.md
|   |   |-- CHEM1_Learning_Objectives.md
|   |   |-- Periodic_Table.md
|   |   |-- Molecular_Geometry.md
|   |   |-- CH1 through CH8 chapter folders
|   |-- CHEM2/
|   |   |-- CHEM2_SHEET.md
|   |   |-- CHEM2_Learning_Objectives.md
|   |   |-- Periodic_Table.md
|   |   |-- Molecular_Geometry.md
|   |   |-- CH9 through CH17 chapter folders
|   |   |-- CH20 Nuclear_Chemistry
|-- site/
|-- scripts/
```

`docs/` is the source of truth. Edit Markdown content there.

`site/` is generated MkDocs output. Do not edit generated site files by hand unless you are intentionally working with built static output.

Note: the current Chemistry I directory is named `docs/CHEM1 /` with a trailing space. Keep this in mind when linking to files or working from a terminal.

## How The Bot Uses The Knowledge Base

The prompt in `copilotagent.md` controls the Copilot agent behavior.

The agent should:

1. classify the student request first
2. reject non-chemistry requests before asking for a course
3. ask only `Are you in Chemistry I or Chemistry II?` when the request is chemistry-related and the course is unknown
4. use only Chemistry I material for Chemistry I students
5. use the available knowledge base for Chemistry II students, preferring Chemistry II versions of course-specific references
6. retrieve cheat-sheet and periodic-table facts directly
7. guide problem solving without giving final answers
8. validate student-provided answers as correct or incorrect
9. run consistency checks before accepting student answers

## Microsoft 365 Copilot Studio and RAG

The Chemistry Tutor Bot is intended to run as a Microsoft 365 Copilot Studio agent that uses retrieval-augmented generation, or RAG.

At a high level, the system has two parts:

- `copilotagent.md` is the behavior layer. It tells the agent how to act, what to refuse, when to ask for the course, how to route lookup questions, and how to tutor without giving final answers.
- This repository's Markdown files are the knowledge layer. They provide the approved Chemistry I and Chemistry II content that Copilot Studio retrieves from when a student asks a chemistry question.

In Copilot Studio, the published knowledge base is connected as a knowledge source. When a student asks a question, Copilot Studio searches the indexed course material, retrieves the most relevant passages, and supplies those passages to the model along with the agent instructions. The prompt then controls how the model may use the retrieved content.

The prompt is deliberately strict because RAG alone does not guarantee correct tutoring behavior. The retrieved content can provide facts, formulas, and explanations, but the prompt enforces the operating rules:

- reject non-chemistry requests before course gating
- ask the exact course gate when the course is unknown
- keep Chemistry I students inside Chemistry I material
- prefer Chemistry II references when a Chemistry II student asks a course-specific question
- answer direct lookup questions from cheat sheets and periodic tables
- guide multi-step problem solving without giving final answers
- validate student-provided answers and run sanity checks
- avoid outside knowledge, outside links, calculators, diagrams, and unsupported claims

The prompt and the knowledge base should be treated as a pair. If the prompt is changed without testing against the knowledge base, the bot may retrieve the right material but use it in the wrong way. If the knowledge base changes without updating the prompt or README, future maintainers may not know how the bot is expected to route or constrain that material.

## Prompt Development and Testing

The prompt in `copilotagent.md` was built through multiple rounds of real bot testing, not as a one-shot instruction block.

The repeatable process is:

1. Write a working prompt with clear scope, course routing, lookup behavior, answer-giving limits, and validation rules.
2. Test the bot in Microsoft 365 Copilot Studio with realistic student questions.
3. Have a chemistry TA or professor review the bot's behavior because they can identify chemistry mistakes, tutoring-quality issues, and cases where the model sounds plausible but is wrong.
4. Record failures as prompt or knowledge-base issues. Examples include using outside knowledge, giving final answers, missing course gating, mishandling particle masses, drawing molecular geometry, or accepting inconsistent answers.
5. Revise the prompt or knowledge-base files from the computer-science side.
6. Retest with domain reviewers until the bot behaves consistently across the major scenarios.

Microsoft 365 Copilot Studio's testing suite was also used for bulk evaluation. Large test batches, often around 100 scenarios per run, helped show how the agent scored across repeated cases and which prompt rules were still weak. Bulk tests are useful for coverage, but they do not replace expert review. The best results came from combining automated scenario scoring with TA and professor feedback.

For future reproduction, test at least these categories:

- non-chemistry requests
- chemistry requests before course identification
- Chemistry I versus Chemistry II routing
- cheat-sheet lookups
- periodic-table lookups
- particle-mass questions
- molecular-geometry questions
- multi-step problem tutoring
- student answer validation
- sanity-check failures such as inconsistent related values

## High-Priority Reference Routing

Use these files directly for formulas, constants, SI prefixes, conversion factors, temperature conversions, solubility rules, particle masses, periodic-table values, and other listed reference items.

Chemistry I:

- `docs/CHEM1 /CHEM1_SHEET.md`
- `docs/CHEM1 /Periodic_Table.md`

Chemistry II:

- `docs/CHEM2/CHEM2_SHEET.md`
- `docs/CHEM2/Periodic_Table.md`

Molecular geometry questions must route to the confirmed course folder:

- `docs/CHEM1 /Molecular_Geometry.md`
- `docs/CHEM2/Molecular_Geometry.md`

Learning objectives are used only for study plans, practice-topic selection, quiz preparation, test preparation, and chapter priorities:

- `docs/CHEM1 /CHEM1_Learning_Objectives.md`
- `docs/CHEM2/CHEM2_Learning_Objectives.md`

Do not use learning objectives as the source for definitions, formulas, constants, laws, rules, mechanisms, or worked steps.

## Scope Rules

Chemistry I may use only the Chemistry I folder.

Chemistry II may use all available knowledge-base information, but should use the Chemistry II version when available for course-specific cheat sheets, particle masses, periodic-table questions, and molecular geometry.

If a needed definition, formula, law, rule, trend, mechanism, constant, or concept is not explicit in the approved files, treat it as unavailable.

The bot must not use general knowledge, pretrained knowledge, common knowledge, outside knowledge, web browsing, calculators, apps, outside links, or external redirects.

## MkDocs Site

The repository is rendered as a static documentation site using MkDocs.

Local preview:

```bash
source .venv/bin/activate
mkdocs serve
```

Then open:

```text
http://127.0.0.1:8000
```

Build the static site:

```bash
mkdocs build
```

The generated output is written to `site/`.

If the virtual environment does not exist:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install mkdocs mkdocs-material mkdocs-awesome-pages-plugin
```

## Update Workflow

When changing course material or bot behavior:

1. Edit course content inside `docs/`.
2. Keep direct lookup facts in the appropriate course sheet, periodic table, or molecular geometry file.
3. Use learning objectives only for planning and practice selection.
4. Update `copilotagent.md` only when the deployed Copilot prompt changes.
5. Preview with `mkdocs serve`.
6. Build with `mkdocs build` before publishing site output.
7. Retest the agent in Copilot Studio after prompt or knowledge-base changes.

## Prompt

`copilotagent.md` contains the exact Microsoft 365 Copilot agent prompt for the Chemistry Tutor Bot. Keep it copy-paste faithful to the deployed prompt.
