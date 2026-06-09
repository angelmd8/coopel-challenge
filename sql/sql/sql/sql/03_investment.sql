CREATE OR REPLACE VIEW `coppel-challenge.star_wars.v_investment` AS
WITH cleaned AS (
  SELECT
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
      WHEN max_atmosphering_speed IN ('unknown','n/a','none','') THEN NULL
      WHEN REGEXP_CONTAINS(max_atmosphering_speed, r'-')
        THEN SAFE_CAST(REGEXP_REPLACE(SPLIT(max_atmosphering_speed, '-')[OFFSET(0)], r'[^0-9.]', '') AS FLOAT64)
      ELSE SAFE_CAST(REGEXP_REPLACE(max_atmosphering_speed, r'[^0-9.]', '') AS FLOAT64)
    END AS speed,
    pilots_count,
    films_count
  FROM `coppel-challenge.star_wars.starships`
)
SELECT
  starship_class,
  COUNT(*) AS total_ships,
  ROUND(AVG(cost), 0) AS avg_cost,
  ROUND(SUM(passengers), 0) AS total_passengers,
  ROUND(AVG(speed), 0) AS avg_speed,
  SUM(pilots_count) AS total_pilots,
  SUM(films_count) AS total_film_appearances,
  ROUND(SAFE_DIVIDE(SUM(passengers), AVG(cost)), 6) AS roi_score
FROM cleaned
GROUP BY starship_class
ORDER BY roi_score DESC;