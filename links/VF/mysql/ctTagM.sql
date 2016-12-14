CREATE TABLE tTagM (
	`TagCD` INT NOT NULL AUTO_INCREMENT,
	`SiteCD` int,
	`TagIndex` int2,
	`Tag` blob,
	`HeadFlag` int2 DEFAULT 1,
	`Disabled` int2 DEFAULT 0,
	`CreateDate` datetime ,
	`UpdateDate` datetime ,
	primary key (TagCD)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE INDEX tTagM_SITE ON tTagM (SiteCD, Disabled, TagIndex);
