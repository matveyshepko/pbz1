
CREATE TABLE teacher(
PersonalNumber VARCHAR(4) PRIMARY KEY,
 LastName VARCHAR(45),
 Position VARCHAR(45),
 Сathedra VARCHAR(45),
 Specialty VARCHAR(45),
 HomePhon INT);

INSERT INTO teacher(PersonalNumber,LastName, Position,
Сathedra,Specialty,HomePhon)
VALUES 
('221Л', 'Фролов', 'Доцент', 'ЭВМ', 'АСОИ, ЭВМ', 487),
('222Л', 'Костин', 'Доцент', 'ЭВМ', 'ЭВМ', 543),
('225Л', 'Бойко', 'Профессор', 'АСУ', 'АСОИ, ЭВМ', 112),
('430Л', 'Глазов', 'Ассистент', 'ТФ', 'СД', 421),
('110Л', 'Петров', 'Ассистент', 'Экономики', 'Международная экономика', 324);

CREATE TABLE lesson(
CodeNumber VARCHAR(3) PRIMARY KEY,
SubjectName VARCHAR(35),
HoursCount INT CHECK(HoursCount>0),
Specialty VARCHAR(45),
Semester INT CHECK(Semester>0));

INSERT INTO lesson(CodeNumber, SubjectName,
 HoursCount, Specialty, Semester)
VALUES 
('12П', 'Мини ЭВМ', 36, 'ЭВМ', 1),
('14П', 'ПЭВМ', 72, 'ЭВМ', 2),
('17П', 'СУБД ПК', 48, 'АСОИ', 4),
('18П', 'ВКСС', 52, 'АСОИ', 6),
('34П', 'Физика', 30, 'СД', 6),
('22П', 'Аудит', 24, 'Бухучета', 3);

CREATE TABLE studentGroup(
 CodeNumber VARCHAR(7) PRIMARY KEY,
 GroupName VARCHAR(10),
 PeopleCount INT CHECK(PeopleCount>0),
 Specialty VARCHAR(45),
 HeadmanLastName VARCHAR(45));

INSERT INTO studentGroup(CodeNumber, GroupName,
 PeopleCount, Specialty, HeadmanLastName)
VALUES 
('8Г', 'Э-12', 18, 'ЭВМ', 'Иванова'),
('7Г', 'Э-15', 22, 'ЭВМ', 'Сеткин'),
('4Г', 'АС-9', 24, 'АСОИ', 'Балабанов'),
('3Г', 'АС-8', 20, 'АСОИ', 'Чижов'),
('17Г', 'С-14', 29, 'СД', 'Амросов'),
('12Г', 'М-6', 16, 'Международная экономика', 'Трубин'),
('10Г', 'Б-4', 21, 'Бухучет', 'Зязюткин')

CREATE TABLE teacherLessonsGroup(
 CodeNumberGroup VARCHAR(7) REFERENCES studentGroup(CodeNumber),
 CodeNumberSubject  VARCHAR(3) REFERENCES lesson(CodeNumber),
 PersonalNumber VARCHAR(4) REFERENCES teacher(PersonalNumber),
 AudienceNumber INT CHECK(AudienceNumber>0),
 PRIMARY KEY (CodeNumberGroup,CodeNumberSubject,PersonalNumber,AudienceNumber) );

INSERT INTO teacherLessonsGroup(
CodeNumberGroup, CodeNumberSubject,
PersonalNumber, AudienceNumber)
VALUES 
('8Г', '12П', '222Л', 112),('8Г', '14П', '221Л', 220),
('8Г', '17П', '222Л', 112),('7Г', '14П', '221Л', 220),
('7Г', '17П', '222Л', 241),('7Г', '18П', '225Л', 210),
('4Г', '12П', '222Л', 112),('4Г', '18П', '225Л', 210),
('3Г', '12П', '222Л', 112),('3Г', '17П', '221Л', 241),
('3Г', '18П', '225Л', 210),('17Г', '12П', '222Л', 112),
('17Г', '22П', '110Л', 220),('17Г', '34П', '430Л', 118),
('12Г', '12П', '222Л', 112),('12Г', '22П', '110Л', 210),
('10Г', '12П', '222Л', 210),('10Г', '22П', '110Л', 210);


1) SELECT * FROM teacher;

2)SELECT * FROM studentgroup WHERE Specialty = 'ЭВМ';

3)SELECT DISTINCT PersonalNumber, AudienceNumber FROM teacherLessonsGroup 
WHERE CodeNumberSubject = '18П'

4)SELECT DISTINCT CodeNumber, SubjectName FROM lesson 
JOIN teacherLessonsGroup ON teacherLessonsGroup.CodeNumberSubject  = lesson.CodeNumber   
JOIN teacher ON teacherLessonsGroup.PersonalNumber = teacher.PersonalNumber 
WHERE teacher.LastName = 'Костин';

5)SELECT DISTINCT CodeNumberGroup FROM teacherLessonsGroup 
JOIN teacher ON teacherLessonsGroup.PersonalNumber = teacher.PersonalNumber 
WHERE teacher.LastName = 'Фролов';

6)SELECT * FROM lesson WHERE Specialty = 'АСОИ';

7)SELECT DISTINCT * FROM teacher WHERE Specialty LIKE '%АСОИ%';

8)SELECT DISTINCT LastName FROM teacher JOIN teacherLessonsGroup 
ON teacher.PersonalNumber = teacherLessonsGroup.PersonalNumber 
WHERE AudienceNumber = 210;

9)SELECT DISTINCT lesson.SubjectName, studentGroup.GroupName 
FROM teacherLessonsGroup JOIN lesson
ON (teacherLessonsGroup.CodeNumberSubject = lesson.CodeNumber)
JOIN studentGroup
ON (teacherLessonsGroup.CodeNumberGroup  = studentGroup.CodeNumber)
WHERE teacherLessonsGroup.AudienceNumber BETWEEN 100 AND 200;

10)SELECT DISTINCT s1.CodeNumber AS '1' , s2.CodeNumber AS '2'
FROM studentGroup AS s1 JOIN studentGroup AS s2 
ON s1.CodeNumber != s2.CodeNumber WHERE
 (s1.Specialty  = s2.Specialty AND s1.CodeNumber  < s2.CodeNumber);

11)SELECT SUM(PeopleCount) AS CountOfStudents FROM studentGroup
WHERE Specialty = 'ЭВМ';

12)SELECT PersonalNumber FROM teacher 
WHERE Specialty LIKE ('%ЭВМ%');

13)WITH subject_number_count AS (SELECT COUNT(lesson.CodeNumber) AS count, lesson.CodeNumber
FROM lesson JOIN teacherLessonsGroup ON lesson.CodeNumber = teacherLessonsGroup.CodeNumberSubject
GROUP BY lesson.CodeNumber)
SELECT CodeNumber
FROM subject_number_count
WHERE subject_number_count.count = (SELECT COUNT(*) AS count
FROM studentGroup);

14)SELECT DISTINCT LastName FROM teacher
JOIN teacherLessonsGroup ON teacher.PersonalNumber = teacherLessonsGroup.PersonalNumber
WHERE   teacherLessonsGroup.CodeNumberSubject IN (SELECT DISTINCT CodeNumber FROM lesson
JOIN teacherLessonsGroup ON lesson.CodeNumber  = teacherLessonsGroup.CodeNumberSubject  
WHERE teacherLessonsGroup.PersonalNumber = (SELECT DISTINCT PersonalNumber FROM teacherLessonsGroup
WHERE teacherLessonsGroup.CodeNumberSubject = '14П'));

15)SELECT DISTINCT * FROM lesson
WHERE lesson.CodeNumber NOT IN (SELECT DISTINCT teacherLessonsGroup.CodeNumberSubject
FROM teacherLessonsGroup WHERE teacherLessonsGroup.PersonalNumber = '221Л');

16)SELECT DISTINCT * FROM lesson
WHERE lesson.CodeNumber NOT IN (SELECT DISTINCT teacherLessonsGroup.CodeNumberSubject
FROM teacherLessonsGroup 
JOIN studentGroup ON studentGroup.CodeNumber = teacherLessonsGroup.CodeNumberGroup 
WHERE studentGroup.GroupName  = 'М-6');

17)SELECT DISTINCT teacher.* FROM teacher
JOIN teacherLessonsGroup 
ON teacher.PersonalNumber  = teacherLessonsGroup.PersonalNumber 
WHERE  (teacher.Position = 'Доцент' AND 
teacherLessonsGroup.CodeNumberGroup IN('3Г','8Г'));

18)SELECT DISTINCT teacherLessonsGroup.PersonalNumber,
teacherLessonsGroup.CodeNumberGroup,teacherLessonsGroup.CodeNumberSubject 
FROM teacherLessonsGroup JOIN teacher 
ON teacher.PersonalNumber  = teacherLessonsGroup.PersonalNumber 
WHERE  (teacher.Сathedra = 'ЭВМ' AND 
teacher.Specialty LIKE('%АСОИ%'));

19)SELECT DISTINCT CodeNumberGroup
FROM teacherLessonsGroup
 JOIN teacher ON teacher.PersonalNumber  = teacherLessonsGroup.PersonalNumber 
 JOIN studentGroup  ON studentGroup.CodeNumber = teacherLessonsGroup.CodeNumberGroup
WHERE studentGroup.Specialty = ANY(SELECT teacher.Specialty FROM teacher);

20)SELECT DISTINCT CodeNumberGroup
FROM teacherLessonsGroup
JOIN teacher ON teacher.PersonalNumber  = teacherLessonsGroup.PersonalNumber 
JOIN studentGroup  ON studentGroup.CodeNumber = teacherLessonsGroup.CodeNumberGroup
WHERE studentGroup.Specialty = ANY(SELECT teacher.Specialty FROM teacher) AND teacher.Сathedra = 'ЭВМ';

21)SELECT DISTINCT studentGroup.Specialty
FROM studentGroup JOIN teacherLessonsGroup 
ON studentGroup.CodeNumber  = teacherLessonsGroup.CodeNumberGroup  
JOIN teacher ON teacher.PersonalNumber = teacherLessonsGroup.PersonalNumber  
WHERE teacher.Сathedra  = 'АСУ';

22)SELECT DISTINCT CodeNumberSubject 
FROM teacherLessonsGroup JOIN studentGroup 
ON studentGroup.CodeNumber = teacherLessonsGroup.CodeNumberGroup  
WHERE studentGroup.GroupName = 'АС-8';

23)SELECT DISTINCT CodeNumberGroup 
FROM teacherLessonsGroup WHERE CodeNumberSubject IN(SELECT DISTINCT CodeNumberSubject
FROM teacherLessonsGroup JOIN studentGroup 
ON studentGroup.CodeNumber = teacherLessonsGroup.CodeNumberGroup  
WHERE studentGroup.GroupName = 'АС-8');

24)SELECT DISTINCT CodeNumberGroup 
FROM teacherLessonsGroup WHERE CodeNumberGroup NOT IN(SELECT DISTINCT CodeNumberGroup 
FROM teacherLessonsGroup WHERE CodeNumberSubject IN(SELECT DISTINCT CodeNumberSubject
FROM teacherLessonsGroup JOIN studentGroup 
ON studentGroup.CodeNumber = teacherLessonsGroup.CodeNumberGroup  
WHERE studentGroup.GroupName = 'АС-8'));

25)SELECT DISTINCT CodeNumberGroup 
FROM teacherLessonsGroup WHERE CodeNumberGroup NOT IN(SELECT DISTINCT CodeNumberGroup
FROM teacherLessonsGroup WHERE PersonalNumber = '430Л');

26)SELECT DISTINCT PersonalNumber  
FROM teacherLessonsGroup WHERE CodeNumberSubject != '12П' AND
CodeNumberGroup = (SELECT DISTINCT CodeNumber FROM studentGroup
WHERE GroupName  = 'Э-15');

///////////////////////////////////////ЗАДАНИЕ 2

CREATE TABLE S(
id VARCHAR(3) PRIMARY KEY,
name VARCHAR(25),
status INT CHECK(status > 0),
city VARCHAR(25));


INSERT INTO S( id, name , status, city)
VALUES
('П1', 'Петров', 20, 'Москва'), ('П2', 'Синицин', 10, 'Таллин'),
('П3', 'Федеров', 30, 'Таллин'), ('П4', 'Чаянов', 20, 'Минск'),
('П5', 'Крюков', 30, 'Киев');


CREATE TABLE P(
id VARCHAR(3) PRIMARY KEY,
name VARCHAR(25),
color VARCHAR(25),
size INT CHECK(size > 0),
city VARCHAR(25));


INSERT INTO P( id, name , color, size, city)
VALUES
('Д1', 'Болт', 'Красный', 12, 'Москва'), ('Д2', 'Гайка', 'Зеленая', 17 , 'Минск'),
('Д3', 'Диск', 'Черный', 17, 'Вильнюс'),('Д4', 'Диск', 'Черный', 14, 'Москва'),
('Д5', 'Корпус', 'Красный', 12, 'Минск'), ('Д6', 'Крышки', 'Красный', 19, 'Москва');

CREATE TABLE J(
id VARCHAR(3) PRIMARY KEY,
name VARCHAR(25),
city VARCHAR(25));

INSERT INTO J( id, name , city)
VALUES
('ПР1', 'ИПР1', 'Минск'), ('ПР2', 'ИПР2', 'Таллин'), ('ПР3', 'ИПР3', 'Псков'),
('ПР4', 'ИПР4', 'Псков'), ('ПР5', 'ИПР5', 'Москва'), ('ПР6', 'ИПР6', 'Саратов'),
('ПР7', 'ИПР7', 'Москва');


CREATE TABLE SPG(
 suppliersId VARCHAR(3) REFERENCES S(id),
 detailId VARCHAR(3) REFERENCES P(id),
 projectId VARCHAR(3) REFERENCES J(id),
 s INT CHECK (s >0),
 PRIMARY KEY (suppliersId,detailId,projectId,s));

INSERT INTO SPG( suppliersId, detailId, projectId, s)
VALUES 
('П1', 'Д1', 'ПР1', 200 ),('П1', 'Д1', 'ПР2', 700), ('П2', 'Д3', 'ПР1', 400), 
('П2', 'Д2', 'ПР2', 200), ('П2', 'Д3', 'ПР3', 200), ('П2', 'Д3', 'ПР4', 500),
('П2', 'Д3', 'ПР5', 600), ('П2', 'Д3', 'ПР6', 400), ('П2', 'Д3', 'ПР7', 800), 
('П2', 'Д5', 'ПР2', 100), ('П3', 'Д3', 'ПР1', 200), ('П3', 'Д4', 'ПР2', 500),
('П4', 'Д6', 'ПР3', 300), ('П4', 'Д6', 'ПР7', 300), ('П5', 'Д2', 'ПР2', 200), 
('П5', 'Д2', 'ПР4', 100), ('П5', 'Д5', 'ПР5', 500), ('П5', 'Д5', 'ПР7', 100), 
('П5', 'Д6', 'ПР2', 200), ('П5', 'Д1', 'ПР2', 100), ('П5', 'Д3', 'ПР4', 200),
('П5', 'Д4', 'ПР4', 800), ('П5', 'Д5', 'ПР4', 400), ('П5', 'Д6', 'ПР4', 500);



-- 4.	Получить все отправки, где количество находится в диапазоне от 300 до 750 включительно.
4) SELECT suppliersId FROM spg where s BETWEEN 300 AND 750;

--11.	Получить все пары названий городов, для которых поставщик из первого города обеспечивает проект во втором городе.
11)SELECT DISTINCT s.city, j.city FROM s, j, spg
WHERE spg.suppliersId  = s.id
AND spg.projectId   = j.id
AND s.id IN (SELECT suppliersId  FROM spg)
AND j.id IN (SELECT projectId  FROM spg);

--29.	Получить номера проектов, полностью обеспечиваемых поставщиком П1.
29) SELECT DISTINCT j.id FROM j 
WHERE NOT j.id IN (
SELECT DISTINCT spg.projectId FROM spg
WHERE spg.suppliersId IN (
SELECT s.id  FROM s
WHERE s.id !='П1') );	

--36.	Получить все пары номеров поставщиков, такие, что оба эти поставщика поставляют в точности одно и то же множество деталей.
36)SELECT DISTINCT s1.suppliersId, s2.suppliersId
FROM SPG AS s1 JOIN SPG AS s2 
ON s1.suppliersId != s2.suppliersId WHERE
 (s1.detailId  = s2.detailId AND s1.s  = s2.s AND s1.suppliersId < s2.suppliersId);

--21.	Получить номера деталей, поставляемых для какого-либо проекта в Лондоне.
21)  SELECT DISTINCT detailId FROM spg 
JOIN j ON j.id=spg.detailId 
WHERE j.city = 'Лондон';

-- 25.	Получить номера проектов, город которых стоит первым в алфавитном списке городов.
25)SELECT id FROM s 
WHERE status > ( SELECT status FROM s WHERE id = 'П1');

--29.	Получить номера проектов, полностью обеспечиваемых поставщиком П1.
29)SELECT projectId FROM spg 
JOIN j ON j.id = spg.projectId
JOIN p ON p.id = spg.detailId
JOIN s ON s.id = spg.suppliersId
WHERE j.city = 'Лондон' AND p.color != 'Красный';	

--16.	Получить общее количество деталей Д1, поставляемых поставщиком П1.
16)SELECT SUM(s) FROM spg
WHERE suppliersId = 'П1'  AND detailId = 'Д1';

--14.	Получить все такие пары номеров деталей, которые обе поставляются одновременно одним поставщиком.
14)SELECT  DISTINCT projectId FROM spg
JOIN s ON s.id = spg.suppliersId
JOIN j ON j.id = spg.projectId
WHERE s.city != j.city;

--35.	Получить пары "номер поставщика-номер детали", такие, что данный поставщик не поставляет данную деталь.
35)SELECT  DISTINCT detailId FROM spg
JOIN s ON s.id = spg.suppliersId
JOIN j ON j.id = spg.projectId
WHERE s.city = 'Лондон' | j.city = 'Лондон';
