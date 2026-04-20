-- Название и продолжительность самого длительного трека
SELECT track_name, duration
  FROM tracks
 ORDER BY duration DESC
 LIMIT 1;

-- Название треков, продолжительность которых не менее 3,5 минут
SELECT track_name
  FROM tracks
 WHERE duration >= 210;

-- Названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT collection_name
  FROM collections
 WHERE collection_year BETWEEN 2018 AND 2020;

-- Исполнители, чьё имя состоит из одного слова
SELECT artist
  FROM artists
 WHERE artist NOT LIKE '% %';

-- Название треков, которые содержат слово «мой» или «my»
/*SELECT track_name
  FROM tracks
 WHERE track_name ILIKE 'my %'
 	OR track_name ILIKE '% my'
 	OR track_name ILIKE '% my %'
 	OR track_name ILIKE 'my'
 	OR track_name ILIKE 'мой %'
    OR track_name ILIKE '% мой'
	OR track_name ILIKE '% мой %'
	OR track_name ILIKE 'мой';*/

SELECT track_name
  FROM tracks
 WHERE string_to_array(lower(track_name), ' ') && ARRAY['my', 'мой'];

SELECT track_name
  FROM tracks
 WHERE track_name ~* '\m(my|мой)\M';

-- Количество исполнителей в каждом жанре
SELECT s.style,
       COUNT(sa.artist_id) AS artist_count
  FROM styles AS s
  LEFT JOIN styles_artists AS sa ON s.style_id = sa.style_id
 GROUP BY s.style_id, s.style
 ORDER BY s.style;

-- Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT COUNT(t.track_id) AS track_count
  FROM albums AS a
  JOIN tracks AS t ON a.album_id = t.album_id
 WHERE a.album_year BETWEEN 2019 AND 2020;

-- Средняя продолжительность треков по каждому альбому
SELECT a.album_name,
       ROUND(AVG(t.duration), 1) AS avg_duration
  FROM albums AS a
  JOIN tracks AS t ON a.album_id = t.album_id
 GROUP BY a.album_id, a.album_name
 ORDER BY a.album_name;

-- Все исполнители, которые не выпустили альбомы в 2020 году
SELECT a.artist
  FROM artists AS a
 WHERE a.artist NOT IN (
  	SELECT ar.artist
      FROM artists AS ar
      JOIN artists_albums AS aa ON ar.artist_id = aa.artist_id
      JOIN albums AS alb ON aa.album_id = alb.album_id
     WHERE alb.album_year = 2020
	);

-- Названия сборников, в которых присутствует конкретный исполнитель
SELECT DISTINCT c.collection_name
  FROM collections AS c
  JOIN collections_tracks AS ct  ON c.collection_id = ct.collection_id
  JOIN tracks AS t               ON ct.track_id = t.track_id
  JOIN albums AS a               ON t.album_id = a.album_id
  JOIN artists_albums AS aa      ON a.album_id = aa.album_id
  JOIN artists AS ar             ON aa.artist_id = ar.artist_id
 WHERE ar.artist = 'The Beatles';

-- Названия альбомов, в которых присутствуют исполнители более чем одного жанра
SELECT DISTINCT a.album_name
  FROM albums AS a
  JOIN artists_albums AS aa      ON a.album_id = aa.album_id
  JOIN artists AS art            ON aa.artist_id = art.artist_id
  JOIN styles_artists AS sa      ON art.artist_id = sa.artist_id
 GROUP BY art.artist_id, a.album_id, a.album_name
HAVING COUNT(DISTINCT sa.style_id) > 1;

-- Наименования треков, которые не входят в сборники
SELECT t.track_name
  FROM tracks AS t
  LEFT JOIN collections_tracks AS ct ON t.track_id = ct.track_id
 WHERE ct.track_id IS NULL;

-- Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько
SELECT DISTINCT ar.artist
  FROM artists AS ar
  JOIN artists_albums AS aa   ON ar.artist_id = aa.artist_id
  JOIN albums AS a            ON aa.album_id = a.album_id
  JOIN tracks AS t            ON a.album_id = t.album_id
 WHERE t.duration = (
           SELECT MIN(duration)
             FROM tracks
       );

-- Названия альбомов, содержащих наименьшее количество треков
SELECT a.album_name
  FROM albums AS a
  JOIN tracks AS t ON a.album_id = t.album_id
 GROUP BY a.album_id, a.album_name
HAVING COUNT(t.track_id) = (
           SELECT COUNT(tr.track_id)
             FROM albums AS al
             JOIN tracks AS tr ON al.album_id = tr.album_id
            GROUP BY al.album_id
            ORDER BY COUNT(tr.track_id)
            LIMIT 1
       );