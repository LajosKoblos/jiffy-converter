PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE android_metadata (locale TEXT);
INSERT INTO "android_metadata" VALUES('en_GB');
CREATE TABLE jiffy_users (userid integer primary key, username VARCHAR(250) NOT NULL, password varchar(256), locale VARCHAR(30) NULL, rowState INT, serverTimeStamp BIGINT, lastChanged BIGINT);
INSERT INTO "jiffy_users" VALUES(1,'LocalUser','','US_en_',NULL,NULL,NULL);
CREATE TABLE jiffy_commit_counter (counter BIGINT, lastChanged BIGINT);
INSERT INTO "jiffy_commit_counter" VALUES(10,1500669524140);
CREATE TABLE jiffy_base_worktimes (userid INT, groupId INT, uuidM BIGINT, uuidL BIGINT, weekday INT, worktime BIGINT, rowState INT, lastChanged BIGINT, local INT, serverTimeStamp BIGINT, primary key(uuidM, uuidL));
INSERT INTO "jiffy_base_worktimes" VALUES(1,0,2007321251440315853,-6541733117189455950,2,28800000,0,-2,'true',NULL);
INSERT INTO "jiffy_base_worktimes" VALUES(1,0,1999409191301107629,-6986709044308321916,3,28800000,0,-2,'true',NULL);
INSERT INTO "jiffy_base_worktimes" VALUES(1,0,-6166799704882394064,-4936237892093968226,4,28800000,0,-2,'true',NULL);
INSERT INTO "jiffy_base_worktimes" VALUES(1,0,-8208820772540690645,-7361618563916095020,5,28800000,0,-2,'true',NULL);
INSERT INTO "jiffy_base_worktimes" VALUES(1,0,5764844217232738145,-7015381225572999808,6,28800000,0,-2,'true',NULL);
CREATE TABLE jiffy_override_worktimes (userid INT, UTC BIGINT, zoneOffset INT, worktime BIGINT, timeLocal BIGINT, rowState INT, uuidM BIGINT, uuidL BIGINT, zoneName TEXT, local int, serverTimeStamp BIGINT, lastChanged BIGINT, primary key(uuidM, uuidL));
CREATE TABLE jiffy_time_tree(userId integer, name VARCHAR(200), color int, archived boolean, worktime boolean, rowState Int, uuidM BIGINT, uuidL BIGINT, parentUuidM BIGINT, parentUuidL BIGINT, local boolean, expanded BOOLEAN, serverTimeStamp BIGINT, lastChanged BIGINT, sharedFromUuidM BIGINT default 0, sharedFromUuidL BIGINT default 0, primary key(uuidM, uuidL));
INSERT INTO "jiffy_time_tree" VALUES(1,'Test customer',-19743,'false',1,0,8075007287455990285,-5780650376697106420,0,0,'true','false',NULL,1500669501512,0,0);
INSERT INTO "jiffy_time_tree" VALUES(1,'Test project',-65382,'false',1,0,-2357030494303992982,-4662434338574123850,8075007287455990285,-5780650376697106420,'true','true',NULL,1500669503525,0,0);
INSERT INTO "jiffy_time_tree" VALUES(1,'Test task',-19743,'false',1,0,-1664336228750376071,-7032393427993102924,-2357030494303992982,-4662434338574123850,'true','false',NULL,1500669517625,0,0);
CREATE TABLE jiffy_compensation(userid INT, type INT, adjustment INT, dayInUTC BIGINT, zoneOffset INT, note TEXT, rowState INT, uuidM BIGINT, uuidL BIGINT, zoneName TEXT, local int, lastChanged BIGINT,  primary key(uuidM, uuidL));
CREATE TABLE jiffy_compensation_cache(userid INT, dayInUTC BIGINT, zoneOffset INT, current INT, rowState INT, lastChanged BIGINT,  primary key(userid, dayInUTC, zoneOffset, rowState));
INSERT INTO "jiffy_compensation_cache" VALUES(1,1500581942600,7200000,0,0,-1);
CREATE TABLE jiffy_compensation_reset(userid INT, dayInUTC BIGINT, zoneOffset INT, currentcompensation BIGINT, manual BOOLEAN, rowState INT, serverTimeStamp BIGINT, lastChanged BIGINT, primary key(userid, DayInUTC));
CREATE TABLE jiffy_times (userid BIGINT NOT NULL, starttime BIGINT, stoptime BIGINT, rowState INT, note TEXT, startzone TEXT, stopzone TEXT, uuidM BIGINT, uuidL BIGINT, ownerUuidM BIGINT, ownerUuidL BIGINT, local int, serverTimeStamp BIGINT, lastChanged BIGINT, worktime BOOLEAN, locked BIGINT, primary key(uuidM, uuidL));
INSERT INTO "jiffy_times" VALUES(1,1500669520562,1500669531308,1,NULL,'Europe/Budapest','Europe/Budapest',-7535219002173603561,-4901816133208197583,-1664336228750376071,-7032393427993102924,'true',-1,1500669531267,NULL,NULL);
INSERT INTO "jiffy_times" VALUES(1,1500669532178,1500669536887,1,NULL,'Europe/Budapest','Europe/Budapest',-3769355179010405890,-8623565603891787064,-2357030494303992982,-4662434338574123850,'true',-1,1500669536876,NULL,NULL);
CREATE TABLE jiffy_surroundings (uuidM BIGINT, uuidL BIGINT, rowState INT, local INT, lastChanged BIGINT, serverTimeStamp BIGINT, entryUuidM BIGINT, entryUuidL BIGINT, type INT, longitude DOUBLE, latitude DOUBLE, accuracy FLOAT, primary key(uuidM, uuidL));
CREATE TABLE jiffy_purchases (userid INT , itemid VARCHAR(250) NOT NULL, status VARCHAR(10), orderid VARCHAR(200), purchasetime BIGINT, lastChanged BIGINT, rowState INT, local int, purchaseToken TEXT, serverTimeStamp BIGINT, primary key(userid, itemid));
INSERT INTO "jiffy_purchases" VALUES(1,'extended_history','PURCHASED','GPA.1345-1749-2501-03405',1482483620969,1500669476124,0,'true','',NULL);
CREATE TABLE jiffy_preferences(userid INT, name varchar(50), value varchar(60), rowState INT, serverTimeStamp BIGINT, lastChanged BIGINT, primary key(userid, name));
CREATE TABLE jiffy_nfc_badge (userId INT, uuidM BIGINT, uuidL BIGINT, name TEXT, local TEXT, rowState INT, lastChanged BIGINT, serverTimeStamp BIGINT, primary key(uuidM, uuidL));
CREATE TABLE jiffy_nfc_link (userId INT, badgeUuidM BIGINT, badgeUuidL BIGINT, ownerUuidM BIGINT, ownerUuidL BIGINT, local TEXT, rowState INT, lastChanged BIGINT, serverTimeStamp BIGINT, primary key(badgeUuidM, badgeUuidL, ownerUuidM, ownerUuidL));
CREATE TABLE log(_id INTEGER PRIMARY KEY, timeStamp BIGINT, type TEXT, note TEXT);
CREATE INDEX jiffy_start_time on jiffy_times (starttime desc);
CREATE UNIQUE INDEX id_index_override_work_times on jiffy_override_worktimes (userid, UTC, zoneOffset);
CREATE INDEX last_utc_jiffy_compensation_cache on jiffy_compensation_cache (userId, dayInUTC);
CREATE UNIQUE INDEX id_index_compensation on jiffy_compensation (uuidM, uuidL);
CREATE INDEX active_jiffy_time_tree on jiffy_time_tree (rowState, archived);
CREATE INDEX last_start_time_per_owner on jiffy_times (ownerUuidM, ownerUuIdL, startTime);
COMMIT;
