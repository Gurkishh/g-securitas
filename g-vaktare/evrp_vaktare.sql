INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_vaktare','Väktare',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_vaktare','Väktare',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_vaktare', 'Väktare', 1)
;

INSERT INTO `jobs` (name, label) VALUES 
	('vaktare','Väktare')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('vaktare',0,'vularling','VU-Lärling',120,'{}','{}'),
  ('vaktare',1,'vaktare2','Väktare',140,'{}','{}'),
  ('vaktare',3,'erfaren','Erfaren Väktare',160,'{}','{}'),
  ('vaktare',4,'sakerhetsansvarig','Säkerhetsansvarig',160,'{}','{}'),
  ('vaktare',5,'vice','Vicechef',160,'{}','{}'),
  ('vaktare',6,'boss','Chef',280,'{}','{}'),

;