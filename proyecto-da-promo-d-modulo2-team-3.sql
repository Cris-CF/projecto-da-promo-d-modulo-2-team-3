USE bd_music;
SELECT * FROM last_fm;
SELECT * FROM results_spotipy; 

-- 1. Número de artistas por año y género
SELECT 
genre Género,
year ano,
COUNT(name_artist) Número_artistas
from results_spotipy
group by ano, género
order by ano;

-- 2. TOP 5 Artistas con más oyentes de los últimos 5 años
SELECT 
rs.name_artist AS Nombre_artista,
SUM(lf.listeners) AS número_oyentes
from results_spotipy rs
INNER JOIN last_fm lf
ON rs.name_artist = lf.name_artist
group by Nombre_artista
order by número_oyentes DESC
LIMIt 5;

-- 3. TOP 5 Artistas con menos oyentes de los últimos 5 años
SELECT 
lf.name_artist AS Nombre_artista,
SUM(lf.listeners) AS número_oyentes
from results_spotipy rs
INNER JOIN last_fm lf
ON rs.name_artist = lf.name_artist
group by Nombre_artista
order by número_oyentes ASC
LIMIt 5;

-- 4. Ranking por género con más reproducciones en los últimos 5 años
SELECT 
rs.year as ANO,
rs.genre AS género,
SUM(lf.playcount) AS número_reproducciones,
ROW_NUMBER() OVER (PARTITION BY rs.year ORDER BY SUM(lf.playcount) DESC) AS ranking 
from results_spotipy rs
INNER JOIN last_fm lf
ON rs.name_artist = lf.name_artist
WHERE rs.year IN(2019, 2020, 2021, 2022, 2023, 2024) 
group by género, ano
order by ano ASC;

-- 5. Top 10 artista con más reproducciones en los últimos 5 años

WITH RankedArtists AS (
    SELECT 
        rs.year AS ANO, 
        rs.name_artist AS nombre_artista, 
        SUM(lf.playcount) AS número_reproducciones, 
        ROW_NUMBER() OVER (PARTITION BY rs.year ORDER BY SUM(lf.playcount) DESC) AS ranking 
    FROM 
        results_spotipy rs 
    INNER JOIN 
        last_fm lf ON rs.name_artist = lf.name_artist 
    WHERE 
        rs.year IN (2019, 2020, 2021, 2022, 2023, 2024) 
    GROUP BY 
        nombre_artista, ANO

)

SELECT 
    ANO, 
    nombre_artista, 
    número_reproducciones, 
    ranking 
FROM 
    RankedArtists 
WHERE 
    ranking <= 10 
ORDER BY 
    ANO ASC, ranking ASC;


-- 6. Top 5 canciones con más reproducciones en los últimos 5 años
WITH RankedNameTrack AS (
		SELECT 
			rs.year as ANO,
			rs.name_artist AS nombre_artista,
			rs.name_track AS canción,
			SUM(lf.playcount) AS número_reproducciones,
			ROW_NUMBER() OVER (PARTITION BY rs.year ORDER BY SUM(lf.playcount) DESC) AS ranking 
		from results_spotipy rs
		INNER JOIN last_fm lf
		ON rs.name_artist = lf.name_artist
		WHERE rs.year IN(2019, 2020, 2021, 2022, 2023, 2024) 
		group by canción, ano, nombre_artista
)
SELECT 
    ANO, 
    nombre_artista, 
    canción,
    número_reproducciones, 
    ranking 
FROM 
    RankedNameTrack
WHERE 
    ranking <= 5
ORDER BY 
    ANO ASC, ranking ASC;

-- 7. Artista más escuchado
SELECT * FROM last_fm;
SELECT * FROM results_spotipy; 

SELECT 
rs.year as ANO,
rs.name_artist AS nombre_artista,
rs.name_track AS canción,
lf.similar_artist as artistas_similares,
SUM(lf.playcount) AS número_reproducciones,
ROW_NUMBER() OVER (PARTITION BY rs.year ORDER BY SUM(lf.playcount) DESC) AS ranking 
from results_spotipy rs
INNER JOIN last_fm lf
ON rs.name_artist = lf.name_artist
group by canción, ano, nombre_artista, biografía;




