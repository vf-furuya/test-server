CREATE TABLE tAccountM (
	`AccountCD` INT NOT NULL AUTO_INCREMENT,
	`AccountName` text,
	`EMail` text,
	`AccountID` text,
	`AccountPW` text,
	`AccountKey` text,
	`Authority` int DEFAULT 1,
	`Disabled` int2 DEFAULT 0,
	`DelFlag` int2 DEFAULT 0,
	`DelDate` datetime,
	`CreateDate` datetime ,
	`UpdateDate` datetime ,
	primary key (AccountCD)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE INDEX tAccountM_AUTH ON tAccountM (AccountID(10), AccountPW(8), Disabled, DelFlag);
CREATE INDEX tAccountM_KEY ON tAccountM (AccountKey(32));
CREATE INDEX tAccountM_EMAIL ON tAccountM (EMail(64));

