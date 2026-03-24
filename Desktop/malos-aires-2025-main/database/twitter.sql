CREATE TABLE IF NOT EXISTS `twitter` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `pID`        INT UNSIGNED NOT NULL,
    `pName`      VARCHAR(24)  NOT NULL DEFAULT '',
    `username`   VARCHAR(20)  NOT NULL,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_pID`      (`pID`),
    UNIQUE KEY `uq_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
