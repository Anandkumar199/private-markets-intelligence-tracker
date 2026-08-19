-- 1. Total disclosed funding by sector
SELECT c.sector,
       COUNT(*) AS rounds,
       SUM(f.amount_usd) AS total_disclosed_usd
FROM funding_rounds f
JOIN companies c ON f.company_id = c.company_id
WHERE f.amount_usd IS NOT NULL
GROUP BY c.sector
ORDER BY total_disclosed_usd DESC;


-- 2. Investor leaderboard -- who shows up most across lead + other investors
SELECT i.investor_name,
       COUNT(*) AS rounds_mentioned_in
FROM investors i
JOIN funding_rounds f
  ON f.lead_investors LIKE CONCAT('%', i.investor_name, '%')
  OR f.other_investors LIKE CONCAT('%', i.investor_name, '%')
GROUP BY i.investor_name
ORDER BY rounds_mentioned_in DESC;


-- 3. Data quality scorecard -- % Confirmed vs Reported vs Conflicting
SELECT data_quality,
       COUNT(*) AS rows_,
       ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM funding_rounds), 1) AS pct_of_rounds
FROM funding_rounds
GROUP BY data_quality
ORDER BY rows_ DESC;


-- 4. Every row flagged for review (Conflicting or Reported) across
--    both funding rounds and deals -- your "needs verification" queue
SELECT 'funding_round' AS record_type, company_name AS entity, round_type AS detail,
       data_quality, source_url
FROM funding_rounds
WHERE data_quality IN ('Reported', 'Conflicting')
UNION ALL
SELECT 'deal_event' AS record_type, acquirer AS entity, target_label AS detail,
       data_quality, source_url
FROM deal_events
WHERE data_quality IN ('Reported', 'Conflicting')
ORDER BY data_quality DESC;


-- 5. M&A roll-up: acquirer, target, deal value, and who exited
SELECT acquirer,
       target_label,
       deal_value_raw,
       status,
       target_prior_investors_exiting
FROM deal_events
ORDER BY announced_date DESC;


-- 6. Companies with no funding round on file yet (coverage gap check --
--    the kind of query a CI team runs to spot what's missing, not just
--    what's there)
SELECT c.company_id, c.company_name, c.status
FROM companies c
LEFT JOIN funding_rounds f ON c.company_id = f.company_id
WHERE f.round_id IS NULL
  AND c.status NOT LIKE 'Acquired%';


-- 7. Ownership-change events per company (deals + ownership notes
--    combined into one timeline)
SELECT company_id, 'Deal' AS event_type, announced_date AS event_date,
       CONCAT(acquirer, ' acquired ', target_label) AS description
FROM deal_events
WHERE target_company_id IS NOT NULL
UNION ALL
SELECT company_id, 'Ownership Note' AS event_type, as_of_date AS event_date,
       ownership_note AS description
FROM ownership_notes
ORDER BY company_id, event_date;