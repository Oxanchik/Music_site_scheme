-- Жанры (не менее 3)
INSERT INTO styles (style)
VALUES
    ('Рок'),
    ('Поп'),
    ('Фолк-Рок'),
    ('Рок-н-Ролл');

-- Исполнители (не менее 4)
INSERT INTO artists (artist)
VALUES
    ('The Beatles'),
    ('Ed Sheeran'),
    ('Queen'),
    ('Мельница'),
    ('Elvis Presley');

-- Связь исполнителей с жанрами (многие ко многим)
WITH
    rock AS (
        SELECT style_id
          FROM styles
         WHERE style = 'Рок'
    ),
    pop AS (
        SELECT style_id
          FROM styles
         WHERE style = 'Поп'
    ),
    folk AS (
        SELECT style_id
          FROM styles
         WHERE style = 'Фолк-Рок'
    ),
    rocknroll AS (
        SELECT style_id
          FROM styles
         WHERE style = 'Рок-н-Ролл'
    ),
    beatles AS (
        SELECT artist_id
          FROM artists
         WHERE artist = 'The Beatles'
    ),
    ed AS (
        SELECT artist_id
          FROM artists
         WHERE artist = 'Ed Sheeran'
    ),
    queen AS (
        SELECT artist_id
          FROM artists
         WHERE artist = 'Queen'
    ),
    melnitsa AS (
        SELECT artist_id
          FROM artists
         WHERE artist = 'Мельница'
    ),
    elvis AS (
        SELECT artist_id
          FROM artists
         WHERE artist = 'Elvis Presley'
    )
INSERT INTO styles_artists (style_id, artist_id)
VALUES
    ((SELECT style_id FROM rock),       (SELECT artist_id FROM beatles)),
    ((SELECT style_id FROM rock),       (SELECT artist_id FROM queen)),
    ((SELECT style_id FROM rock),       (SELECT artist_id FROM melnitsa)),
    ((SELECT style_id FROM pop),        (SELECT artist_id FROM ed)),
    ((SELECT style_id FROM pop),        (SELECT artist_id FROM elvis)),
    ((SELECT style_id FROM folk),       (SELECT artist_id FROM ed)),
    ((SELECT style_id FROM folk),       (SELECT artist_id FROM melnitsa)),
    ((SELECT style_id FROM rocknroll),  (SELECT artist_id FROM beatles)),
    ((SELECT style_id FROM rocknroll),  (SELECT artist_id FROM elvis));

-- Альбомы (не менее 3)
INSERT INTO albums (album_name, album_year)
VALUES
    ('Abbey Road',                      1969),
    ('No.6 Collaborations Project',     2019),
    ('A Night at the Opera',            1975),
    ('Перевал',                         2005),
    ('Elvis Presley',                   1956);

-- Связь исполнителей с альбомами (многие ко многим)
WITH
    beatles AS (
        SELECT artist_id
          FROM artists
         WHERE artist = 'The Beatles'
    ),
    ed AS (
        SELECT artist_id
          FROM artists
         WHERE artist = 'Ed Sheeran'
    ),
    queen AS (
        SELECT artist_id
          FROM artists
         WHERE artist = 'Queen'
    ),
    melnitsa AS (
        SELECT artist_id
          FROM artists
         WHERE artist = 'Мельница'
    ),
    elvis AS (
        SELECT artist_id
          FROM artists
         WHERE artist = 'Elvis Presley'
    ),
    abbey AS (
        SELECT album_id
          FROM albums
         WHERE album_name = 'Abbey Road'
    ),
    project AS (
        SELECT album_id
          FROM albums
         WHERE album_name = 'No.6 Collaborations Project'
    ),
    night AS (
        SELECT album_id
          FROM albums
         WHERE album_name = 'A Night at the Opera'
    ),
    pereval AS (
        SELECT album_id
          FROM albums
         WHERE album_name = 'Перевал'
    ),
    elvis_album AS (
        SELECT album_id
          FROM albums
         WHERE album_name = 'Elvis Presley'
    )
INSERT INTO artists_albums (artist_id, album_id)
VALUES
    ((SELECT artist_id FROM beatles),   (SELECT album_id FROM abbey)),
    ((SELECT artist_id FROM ed),        (SELECT album_id FROM project)),
    ((SELECT artist_id FROM queen),     (SELECT album_id FROM night)),
    ((SELECT artist_id FROM melnitsa),  (SELECT album_id FROM pereval)),
    ((SELECT artist_id FROM elvis),     (SELECT album_id FROM elvis_album));


-- Треки (не менее 6)
WITH
    abbey AS (
        SELECT album_id
          FROM albums
         WHERE album_name = 'Abbey Road'
    ),
    project AS (
        SELECT album_id
          FROM albums
         WHERE album_name = 'No.6 Collaborations Project'
    ),
    night AS (
        SELECT album_id
          FROM albums
         WHERE album_name = 'A Night at the Opera'
    ),
    pereval AS (
        SELECT album_id
          FROM albums
         WHERE album_name = 'Перевал'
    ),
    elvis_album AS (
        SELECT album_id
          FROM albums
         WHERE album_name = 'Elvis Presley'
    )
INSERT INTO tracks (album_id, track_name, duration)
VALUES
    ((SELECT album_id FROM abbey),          'Come Together',            260),
    ((SELECT album_id FROM abbey),          'Something',                183),
    ((SELECT album_id FROM project),        'Beautiful People',         197),
    ((SELECT album_id FROM project),        'Cross Me',                 206),
    ((SELECT album_id FROM night),          'Bohemian Rhapsody',        355),
    ((SELECT album_id FROM night),          'Love of My Life',          219),
    ((SELECT album_id FROM pereval),        'Господин горных дорог',    318),
    ((SELECT album_id FROM pereval),        'Ночная кобыла',            244),
    ((SELECT album_id FROM elvis_album),    'Blue Suede Shoes',         118),
    ((SELECT album_id FROM elvis_album),    'Tutti Frutti',             119);

-- Сборники (не менее 4)
INSERT INTO collections (collection_name, collection_year)
VALUES
    ('Легенды рока',            1995),
    ('Поп-хиты XXI века',       2020),
    ('Короли рок-н-ролла',      2002),
    ('Британское вторжение',    2020),
    ('Русский фолк-рок',        2019);

-- Связь сборников с треками (многие ко многим)
WITH
    -- Сборники
    legends AS (
        SELECT collection_id
          FROM collections
         WHERE collection_name = 'Легенды рока'
    ),
    pop_hits AS (
        SELECT collection_id
          FROM collections
         WHERE collection_name = 'Поп-хиты XXI века'
    ),
    rocknroll_kings AS (
        SELECT collection_id
          FROM collections
         WHERE collection_name = 'Короли рок-н-ролла'
    ),
    british AS (
        SELECT collection_id
          FROM collections
         WHERE collection_name = 'Британское вторжение'
    ),
    russian_folk AS (
        SELECT collection_id
          FROM collections
         WHERE collection_name = 'Русский фолк-рок'
    ),

    -- Треки
    come_together AS (
        SELECT track_id
          FROM tracks
         WHERE track_name = 'Come Together'
    ),
    bohemian AS (
        SELECT track_id
          FROM tracks
         WHERE track_name = 'Bohemian Rhapsody'
    ),
    love_of_my_life AS (
        SELECT track_id
          FROM tracks
         WHERE track_name = 'Love of My Life'
    ),
    people AS (
        SELECT track_id
          FROM tracks
         WHERE track_name = 'Beautiful People'
    ),
    cross_me AS (
        SELECT track_id
          FROM tracks
         WHERE track_name = 'Cross Me'
    ),
    master AS (
        SELECT track_id
          FROM tracks
         WHERE track_name = 'Господин горных дорог'
    ),
    horse AS (
        SELECT track_id
          FROM tracks
         WHERE track_name = 'Ночная кобыла'
    ),
    blue_suede AS (
        SELECT track_id
          FROM tracks
         WHERE track_name = 'Blue Suede Shoes'
    ),
    tutti_frutti AS (
        SELECT track_id
          FROM tracks
         WHERE track_name = 'Tutti Frutti'
    )
INSERT INTO collections_tracks (collection_id, track_id)
VALUES
    -- Легенды рока
    ((SELECT collection_id FROM legends),           (SELECT track_id FROM come_together)),
    ((SELECT collection_id FROM legends),           (SELECT track_id FROM bohemian)),
    ((SELECT collection_id FROM legends),           (SELECT track_id FROM love_of_my_life)),

    -- Поп-хиты XXI века
    ((SELECT collection_id FROM pop_hits),          (SELECT track_id FROM people)),
    ((SELECT collection_id FROM pop_hits),          (SELECT track_id FROM cross_me)),

    -- Короли рок-н-ролла
    ((SELECT collection_id FROM rocknroll_kings),   (SELECT track_id FROM blue_suede)),
    ((SELECT collection_id FROM rocknroll_kings),   (SELECT track_id FROM tutti_frutti)),
    ((SELECT collection_id FROM rocknroll_kings),   (SELECT track_id FROM come_together)),

    -- Британское вторжение
    ((SELECT collection_id FROM british),           (SELECT track_id FROM come_together)),
    ((SELECT collection_id FROM british),           (SELECT track_id FROM bohemian)),
    ((SELECT collection_id FROM british),           (SELECT track_id FROM people)),

    -- Русский фолк-рок
    ((SELECT collection_id FROM russian_folk),      (SELECT track_id FROM master)),
    ((SELECT collection_id FROM russian_folk),      (SELECT track_id FROM horse));