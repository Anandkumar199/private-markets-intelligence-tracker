# Private Markets Intelligence Tracker

A SQL + Power BI dashboard tracking private-market companies, investors, funding rounds, and M&A activity — modeled on a Preqin-style research analyst workflow.

## Overview

This project simulates a research analyst's tool for tracking company funding history, investor activity, and ownership changes across the private markets. It's built around a normalized data model connecting companies, funding rounds, and investors through relationship tables, with a separate layer for tracking M&A events and ownership changes over time.

## Dashboard Pages

- **Overview** — landing page with key stats (total companies, funding rounds, investors, and funding tracked) and page navigation buttons
- **Funding Overview** — funding trends by sector and year, with KPI cards summarizing total activity
- **Investor Leaderboard** — top investors ranked by total capital deployed and number of deals participated in
- **M&A / Ownership** — acquisition and ownership-change tracking, with a data quality confidence slicer (Verified / Unverified / Conflicting)

## Data Model

- `companies`, `funding_rounds`, `investors` — core dimension and fact tables
- `Funding-Investor-Bridge` — many-to-many bridge table linking investors to the funding rounds they participated in
- `deal_events` — M&A and acquisition records, tagged by deal type and data quality
- `ownership_notes` — timestamped ownership-change log per company

## Technical Notes

- **Bridge table filtering fix**: resolved a bidirectional filter propagation issue where investor selections weren't correctly filtering funding totals — traced to a single-direction relationship between the bridge table and the funding rounds table, fixed by enabling bidirectional cross-filtering
- **Data quality tagging**: M&A records include a confidence tag (Verified / Unverified / Conflicting) to reflect the kind of source-reliability judgment calls real research analysts have to make
- **DAX measures**: distinct-count measures for deal/investor counts, currency-formatted sum measures for funding totals

## Tools

SQL · Power BI · DAX

## Screenshots

<img width="1920" height="1200" alt="Screenshot 2026-08-20 013025" src="https://github.com/user-attachments/assets/c5642c9a-8208-4cdc-873e-e3e2124cbd94" />




