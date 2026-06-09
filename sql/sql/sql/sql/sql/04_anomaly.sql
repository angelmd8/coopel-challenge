CREATE OR REPLACE VIEW `coppel-challenge.star_wars.v_anomaly` AS
SELECT
  name,
  climate,
  terrain,
  CASE 
    WHEN population = 'unknown' THEN 'Sin censo poblacional'
    ELSE population 
  END AS population,
  residents_count,
  films_count,
  CASE 
    WHEN population = 'unknown' AND films_count >= 2 
      THEN '🚨 Planeta estratégico sin datos de población'
    WHEN SAFE_CAST(population AS FLOAT64) > 1000000000 AND residents_count = 0 
      THEN '⚠️ Superpoblado sin residentes registrados'
    WHEN SAFE_CAST(population AS FLOAT64) < 1000 AND films_count >= 2 
      THEN '🔍 Planeta pequeño con alta relevancia estratégica'
    WHEN population = 'unknown' AND residents_count > 0 
      THEN '📊 Residentes conocidos pero población no censada'
    ELSE 'Normal'
  END AS anomaly_type
FROM `coppel-challenge.star_wars.planets`
ORDER BY films_count DESC, residents_count DESC;

-- SELECT 
--   anomaly_type,
--   COUNT(*) AS total_planetas,
--   STRING_AGG(name, ', ' ORDER BY films_count DESC LIMIT 5) AS ejemplos
-- FROM `coppel-challenge.star_wars.v_anomaly`
-- GROUP BY anomaly_type
-- ORDER BY total_planetas DESC;