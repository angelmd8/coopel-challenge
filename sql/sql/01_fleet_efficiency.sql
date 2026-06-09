CREATE OR REPLACE VIEW `coppel-challenge.star_wars.v_fleet_efficiency` AS

WITH cleaned AS (
  SELECT
    name,
    starship_class,
    CASE 
      WHEN cost_in_credits IN ('unknown','n/a','none','') THEN NULL
      ELSE CAST(REPLACE(cost_in_credits, ',', '') AS FLOAT64)
    END AS cost,
    CASE 
      WHEN passengers IN ('unknown','n/a','none','','0') THEN NULL
      WHEN REGEXP_CONTAINS(passengers, r'-')
        THEN CAST(REPLACE(SPLIT(passengers, '-')[OFFSET(0)], ',', '') AS FLOAT64)
      ELSE CAST(REPLACE(passengers, ',', '') AS FLOAT64)
    END AS passengers,
    CASE 
      WHEN crew IN ('unknown','n/a','none','') THEN NULL
      WHEN REGEXP_CONTAINS(crew, r'-')
        THEN CAST(REPLACE(SPLIT(crew, '-')[OFFSET(0)], ',', '') AS FLOAT64)
      ELSE CAST(REPLACE(crew, ',', '') AS FLOAT64)
    END AS crew
  FROM `coppel-challenge.star_wars.starships`
)

SELECT
  name,
  starship_class,
  cost,
  passengers,
  crew,
  SAFE_DIVIDE(passengers, cost) AS passengers_per_credit
FROM cleaned
WHERE cost IS NOT NULL
  AND passengers IS NOT NULL
ORDER BY passengers_per_credit DESC
LIMIT 10;
