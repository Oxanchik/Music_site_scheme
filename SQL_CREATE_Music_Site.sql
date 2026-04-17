-- Таблица музыкальных жанров
CREATE TABLE IF NOT EXISTS styles (
    PRIMARY KEY (style_id),
    style_id            SERIAL,
    style               VARCHAR(100) NOT NULL UNIQUE,
                        CONSTRAINT style_not_empty
                            CHECK (style <> '')
);

-- Таблица исполнителей
CREATE TABLE IF NOT EXISTS artists (
    PRIMARY KEY (artist_id),
    artist_id           SERIAL,
    artist              VARCHAR(100) NOT NULL UNIQUE,
                        CONSTRAINT artist_not_empty
                            CHECK (artist <> '')
);

-- Таблица альбомов
CREATE TABLE IF NOT EXISTS albums (
    PRIMARY KEY (album_id),
    album_id            SERIAL,
    album_name          VARCHAR(200) NOT NULL,
                        CONSTRAINT album_name_not_empty
                            CHECK (album_name <> ''),
    album_year          INTEGER,
                        CONSTRAINT album_year_range
                            CHECK (album_year BETWEEN 1900 AND EXTRACT(YEAR FROM CURRENT_DATE))
);

-- Таблица треков
CREATE TABLE IF NOT EXISTS tracks (
    PRIMARY KEY (track_id),
    track_id            SERIAL,
    album_id            INTEGER      NOT NULL,
                        CONSTRAINT fk_track_album
                            FOREIGN KEY (album_id) REFERENCES albums(album_id),
    track_name          VARCHAR(200) NOT NULL,
                        CONSTRAINT track_name_not_empty
                            CHECK (track_name <> ''),
                        CONSTRAINT uq_album_track_name
                            UNIQUE (album_id, track_name),
    duration            INTEGER      NOT NULL,
                        CONSTRAINT track_duration_valid
                            CHECK (duration > 0 AND duration <= 36000)
);

-- Связь многие ко многим между жанрами и исполнителями
CREATE TABLE IF NOT EXISTS styles_artists (
    CONSTRAINT pk_styles_artists
        PRIMARY KEY (style_id, artist_id),
    style_id            INTEGER      NOT NULL,
                        CONSTRAINT fk_styl_art_style
                             FOREIGN KEY (style_id) REFERENCES styles(style_id)
                             ON DELETE CASCADE,
    artist_id           INTEGER      NOT NULL,
                        CONSTRAINT fk_styl_art_artist
                             FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
                             ON DELETE CASCADE
);

-- Связь многие ко многим между исполнителями и альбомами
CREATE TABLE IF NOT EXISTS artists_albums (
    CONSTRAINT pk_artists_albums
        PRIMARY KEY (artist_id, album_id),
    artist_id           INTEGER      NOT NULL,
                        CONSTRAINT fk_arts_alb_artist
                             FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
                             ON DELETE CASCADE,
    album_id            INTEGER      NOT NULL,
                        CONSTRAINT fk_arts_alb_album
                             FOREIGN KEY (album_id) REFERENCES albums(album_id)
                             ON DELETE CASCADE
);

-- Таблица сборников
CREATE TABLE IF NOT EXISTS collections (
    PRIMARY KEY (collection_id),
    collection_id       SERIAL,
    collection_name     VARCHAR(200) NOT NULL,
                        CONSTRAINT collection_name_not_empty
                             CHECK (collection_name <> ''),
    collection_year     INTEGER,
                        CONSTRAINT collection_year_valid
                             CHECK (collection_year BETWEEN 1900 AND EXTRACT(YEAR FROM CURRENT_DATE))
);

-- Связь многие ко многим между сборниками и треками
CREATE TABLE IF NOT EXISTS collections_tracks (
    CONSTRAINT pk_collections_tracks
        PRIMARY KEY (collection_id, track_id),
    collection_id       INTEGER      NOT NULL,
                        CONSTRAINT fk_collect_track_collection
                             FOREIGN KEY (collection_id) REFERENCES collections(collection_id)
                             ON DELETE CASCADE,
    track_id            INTEGER      NOT NULL,
                        CONSTRAINT fk_collect_track_track
                             FOREIGN KEY (track_id) REFERENCES tracks(track_id)
                             ON DELETE CASCADE
);