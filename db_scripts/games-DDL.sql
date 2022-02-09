DROP TABLE IF EXISTS `gamemechanic`;
DROP TABLE IF EXISTS `gamedesigner`;
DROP TABLE IF EXISTS `gamephoto`;
DROP TABLE IF EXISTS `gamevideo`;
DROP TABLE IF EXISTS `designer`;
DROP TABLE IF EXISTS `mechanic`;
DROP TABLE IF EXISTS `video`;
DROP TABLE IF EXISTS `game`;
DROP TABLE IF EXISTS `publisher`;

CREATE TABLE `publisher` (
  `id` int(11) AUTO_INCREMENT NOT NULL,  
  `name` varchar(100) NOT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  PRIMARY KEY(id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO publisher (id, name, city, state, country)
VALUES
(1, 'Days of Wonder', '', '', ''),
(2, 'Alea', '', '', ''),
(3, 'Ravensburger', '', '', 'Germany'),
(4, '2F-Spiele', '', '', 'Germany'),
(5, 'Rio Grande Games', '', '', 'USA'),
(6, 'CGE (Czech Games Edition)', '', '', 'Czech Republic'),
(7, 'Hans im Gluck', '', '', 'Germany'),
(8, 'Plan B Games', '', '', 'Germany'),
(9, 'Next Move Games', '', '', ''),
(10, 'Truant Spiele', '', '', 'Germany'),
(11, 'Fantasy Flight', '', '', 'USA'),
(12, 'Z-Man Game, Inc', '', '', 'USA'),
(14, 'Asmodeen Games', '', '', 'New Jersey');

CREATE TABLE `game` (
  `id` int(11) AUTO_INCREMENT NOT NULL,
  `title` varchar(255) NOT NULL,
  `year` int(4) DEFAULT NULL,
  `publisherid` int(11) DEFAULT NULL,
  `minplayers` tinyint DEFAULT NULL,
  `maxplayers` tinyint DEFAULT NULL,
  `minage` tinyint  DEFAULT NULL,
  `playtime` int(4) DEFAULT NULL,
  `rating` double DEFAULT NULL,
  `timesplayed` int(11) DEFAULT 0,
  `bggid` int(11) DEFAULT NULL,
  PRIMARY KEY(id),
  CONSTRAINT `publisher_fk1` FOREIGN KEY (`publisherid`) REFERENCES `publisher` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO game(id, title, year, minplayers, maxplayers, minage, playtime, rating, timesplayed, bggid, publisherid)
VALUES
(1, 'Ticket to Ride', 1998, 2, 4, 8, 60, 8.3, 2, 9209, 1),
(2, 'Chinatown', 2002, 3, 5, 10, 90, 10, 7, 47, 12),
(3, 'Power Grid', 2005, 2, 6, 12, 120, 8, 2, 2651, 5),
(4, 'Codenames', 2015, 4, 12, 10, 20, 10, 29, 178900, 6),
(5, 'Stone Age', 2007, 2, 4, 10, 60, 7, 3, 34635, 8),
(6, 'Azul', 2018, 2, 4, 8, 30, 7.5, 12, 230802, 4),
(7, 'Kingsburg', 2011, 2, 5, 12, 90, 9.5, 6, 27162, 11),
(13, 'Monopoly', 1935, 2, 5, 12, 90, 9.5, 6, 1406, 11),
(14, 'Small World', 2010, 2, 5, 12, 90, 9.5, 6, 27162, 11),
(15, 'Around the World in 80 Days', 2001, 2, 5, 12, 90, 9.5, 6, 204599, 11),
(18, 'Glory to Rome', 2003, 2, 5, 12, 90, 9.5, 6, 19857, 11);

CREATE TABLE `designer` (
  `id` int(11) AUTO_INCREMENT NOT NULL,
  `firstname` varchar(100) DEFAULT NULL,
  `lastname` varchar(100) NOT NULL,
  `country` varchar(100) DEFAULT NULL,
  PRIMARY KEY(id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO designer (id, firstname, lastname, country)
VALUES
(1, 'Alan', 'Moon', 'USA'),
(2, 'Karsten', 'Hartwig', 'Germany'),
(3, 'Friedemann', 'Friese', 'Germany'),
(4, 'Vlaada', 'Chvatil', 'Czech Republic'),
(5, 'Bernd', 'Brunnhofer', 'Germany'),
(6, 'Michael', 'Kiesling', 'Germany'),
(7, 'Andrea', 'Chiarvesio', 'Italy'),
(8, 'Luca', 'Lennaco', 'Italy'),
(13, 'Reiner', 'Knizia', 'Germany'),
(14, 'Chris', 'Quilliams', 'USA');

CREATE TABLE `mechanic` (
  `id` int(11) AUTO_INCREMENT NOT NULL,
  `mechanic` varchar(100) NOT NULL,
  PRIMARY KEY(id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO mechanic (id, mechanic)
VALUES
(1, 'Card Drafting'),
(2, 'Set Collection'),
(3, 'Negotiation'),
(4, 'Trading'),
(5, 'Auction'),
(6, 'Route Building'),
(7, 'Memory'),
(8, 'Press Your Luck'),
(9, 'Worker Placement'),
(10, 'Dice Rolling'),
(11, 'Pattern Building'),
(12, 'Tile Placement'),
(13, 'Partnerships');

CREATE TABLE `video` (
  `id` int(11) AUTO_INCREMENT NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `url` varchar(255) NOT NULL,
  `type` varchar(25) NOT NULL,
  PRIMARY KEY(id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO video (id, title, url, type)
VALUES
(1, 'Learn How (Not) to play 2004 Ticket to Ride', 'xRDITzcDGbo', 'tutorial'),
(2, 'Chinatown: How to Play', 'CnSndNTUmgM', 'tutorial'),
(3, '', 'P3FzuZ3rltA', 'review'),
(4, 'Codenames - How To Play', 'SWw08g1CtPA', 'tutorial'),
(5, 'Chairman of the Board - Stone Age Review', 'M1fifqmHfzc', 'review'),
(6, 'Azul overview', 'zqamuWcOWyc', 'tutorial'),
(7, 'Board Game Opinions', 'HvCujGifUMs', 'review');

CREATE TABLE `gamedesigner` (
  `gameid` int(11) NOT NULL,
  `designerid` int(11) NOT NULL,
  PRIMARY KEY(gameid, designerid),
  CONSTRAINT `designer_fk1` FOREIGN KEY (`gameid`) REFERENCES `game` (`id`),
  CONSTRAINT `designer_fk2` FOREIGN KEY (`designerid`) REFERENCES `designer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO gamedesigner (gameid, designerid) VALUES(1,1), (2,2), (3,3), (4,4), (5,5), (6,6), (7,7), (7,8);

CREATE TABLE `gamemechanic` (
  `gameid` int(11) NOT NULL,
  `mechanicid` int(11) NOT NULL,
  PRIMARY KEY(gameid, mechanicid),
  CONSTRAINT `mechanic_fk1` FOREIGN KEY (`gameid`) REFERENCES `game` (`id`),
  CONSTRAINT `mechanic_fk2` FOREIGN KEY (`mechanicid`) REFERENCES `mechanic` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO gamemechanic (gameid, mechanicid)
VALUES
(1, 1), (1, 2), (1, 6),
(2, 2), (2, 4), (2, 12),
(3, 5), (3, 6),
(4, 7), (4, 8), (4,13),
(5, 10), (5, 2), (5, 9),
(6, 2), (6, 11), (6, 12),
(7, 9), (7, 10);

CREATE TABLE `gamevideo` (
  `gameid` int(11) NOT NULL,
  `videoid` int(11) NOT NULL,
  PRIMARY KEY(gameid, videoid),
  CONSTRAINT `video_fk1` FOREIGN KEY (`gameid`) REFERENCES `game` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO gamevideo (gameid, videoid)
VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7);

CREATE TABLE `gamephoto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gameid` int(11) NOT NULL,
  `image` varchar(255) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  PRIMARY KEY(id),
  CONSTRAINT `photo_fk1` FOREIGN KEY (`gameid`) REFERENCES `game` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO gamephoto (gameid, image, description) VALUES
(6, 'https://cf.geekdo-images.com/imagepage/img/mswTFqJsQ_omcKa_y1yNfFMJP6M=/fit-in/900x600/filters:no_upscale()/pic3718275.jpg', 'Box cover'),
(6, 'https://cf.geekdo-images.com/imagepage/img/0Cg2iHpRSxlsdXO8XwpirBYZ40g=/fit-in/900x600/filters:no_upscale()/pic3720015.jpg', 'Game setup'),
(6, 'https://cf.geekdo-images.com/imagepage/img/ZrXuqA0dpARPNQ3SGFFm5LSro6s=/fit-in/900x600/filters:no_upscale()/pic3721303.png', 'Tile bag');

