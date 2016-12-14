CREATE TABLE tSiteM (
	`SiteCD` INT NOT NULL AUTO_INCREMENT,
	`AccountCD` int,
	`SiteIndex` int,
	`RedirectUrl` text,
	`RedirectDepth` int2,
	`UID` text,
	`Disabled` int2 DEFAULT 0,
	`CreateDate` datetime ,
	`UpdateDate` datetime ,
	primary key (SiteCD)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE INDEX tSiteM_ACCOUNT ON tSiteM (AccountCD, Disabled, SiteIndex);
