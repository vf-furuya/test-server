CREATE TABLE tAccessLogF (
	`LogCD` INT NOT NULL AUTO_INCREMENT,
	`RemoteIP` text,
	`RequestUri` text,
	`AccessDate` datetime NOT NULL,
	primary key (LogCD)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

