CREATE OR REPLACE VIEW `coppel-challenge.star_wars.v_talent_analysis` AS
SELECT
  p.name AS planet_name,
  pe.gender,
  pe.films_count,
  CASE 
    WHEN pe.films_count >= 4 THEN 'Alto potencial'
    WHEN pe.films_count >= 2 THEN 'Potencial medio'
    ELSE 'Bajo potencial'
  END AS pilot_potential
FROM `coppel-challenge.star_wars.people` pe
LEFT JOIN `coppel-challenge.star_wars.planets` p
  ON pe.homeworld_url = p.url;

-- SELECT 
--   planet_name,
--   gender,
--   COUNT(*) AS total_personas,
--   ROUND(AVG(films_count), 2) AS avg_apariciones,
--   COUNTIF(pilot_potential = 'Alto potencial') AS alto_potencial
-- FROM `coppel-challenge.star_wars.v_talent_analysis`
-- WHERE planet_name IS NOT NULL
-- GROUP BY planet_name, gender
-- HAVING total_personas >= 2
-- ORDER BY alto_potencial DESC, avg_apariciones DESC
-- LIMIT 15;