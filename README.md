# Bioequivalence Study – SAS Programming Repository

## Overview
This repository contains **SAS programs developed for academic training and methodological understanding** of **Bioequivalence (BE) studies**.  
The codebase is designed to simulate, analyze, and report BE study data in alignment with **regulatory expectations and statistical best practices**.

The primary objective is to demonstrate **end-to-end analytical capability**, from dataset preparation to statistical evaluation of bioequivalence.

---

## Scope of Work
The programs in this repository cover the following functional areas:

- BE study data structuring and validation
- Crossover study design handling (2×2 and extended designs)
- Pharmacokinetic (PK) parameter analysis
- Statistical assessment of bioequivalence using SAS procedures
- Generation of analysis-ready outputs for review

---

## Study Design Coverage
- 2×2 Crossover Design  
- Fully Replicate Crossover Design  
- Partial Replicate Designs (where applicable)

Key study components addressed:
- Sequence
- Period
- Treatment
- Subject-level data

---

## SAS Procedures Utilized
- `PROC MEANS` – Descriptive PK statistics
- `PROC GLM` – Preliminary ANOVA models
- `PROC MIXED` – Mixed-effects modeling for replicate designs

---

## Bioequivalence Methodology
The analysis framework follows standard BE principles, including:

- Log-transformation of PK parameters (e.g., Cmax, AUC)
- Estimation of geometric mean ratios (T/R)
- Construction of 90% confidence intervals
- Evaluation against regulatory acceptance limits (80.00% – 125.00%)

*Note: All datasets used are simulated or anonymized for academic purposes.*
