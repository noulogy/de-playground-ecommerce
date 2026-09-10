# Analytics Engineering Pipeline with dbt Core and PostgreSQL

This repository contains an end-to-end data transformation project built using dbt Core and PostgreSQL running in a Docker container. The project demonstrates industry-standard data modeling practices, including custom macro development, incremental loading strategies, and Slowly Changing Dimension (SCD Type 2) tracking.

---

## Tech Stack & Core Dependencies

* **Transformation Tool:** dbt Core (v1.12.3)
* **Database Engine:** PostgreSQL
* **Infrastructure:** Docker & Docker Compose
* **Language & Templating:** SQL, Jinja2, Python

---

## Data Architecture & Schema Design

To enforce least-privilege security principles and prevent accidental schema mutations in production:

* **`public` (Raw Source / Read-Only):** Ingests raw data from upstream applications. The transformation tool maintains strictly read-only access to this schema.
* **`dbt_dev` (Development / Write):** Dedicated workspace where dbt materializes models, staging tables, data marts, and snapshots.

---

## Key Features & Modeling Techniques

### 1. Custom Macros (`clean_money`)
* Encapsulates string cleaning and regular expression handling to strip currency formatting, special characters, and non-numeric artifacts.
* Implements explicit casting (`::text` and `NUMERIC`) to ensure type safety across mixed inputs.

### 2. Incremental Data Processing (`fct_sales_incremental`)
* Utilizes `materialized='incremental'` with a defined `unique_key` to avoid expensive full-table scans on large datasets.
* Implements a state-aware filter using `updated_at` timestamps to capture mutated rows (such as updates or refunds) alongside new records.
* Incorporates a lookback window strategy (`MAX(updated_at) - INTERVAL '3 days'`) to safely process late-arriving data without creating duplicate records.

### 3. Change Data Capture & SCD Type 2 (`snap_users`)
* Leverages dbt Snapshots with `strategy='timestamp'` mapped to `effective_date`.
* Tracks historical state changes (e.g., user tier updates, location migration) without overwriting historical records.
* Automatically generates system columns (`dbt_valid_from`, `dbt_valid_to`, `dbt_scd_id`) for precise point-in-time analysis.

---

## Local Setup & Execution Workflow

### 1. Infrastructure Setup
Start the local PostgreSQL container:
```powershell
docker-compose up -d