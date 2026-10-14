SELECT * FROM ab_nyc;
ALTER TABLE ab_nyc RENAME TO nyc;
SELECT * FROM nyc;
ALTER TABLE nyc
ALTER COLUMN last_review TYPE DATE
USING last_review::DATE;

--1 Вывести первые 10 строк датасета
SELECT * FROM nyc ORDER BY ctid LIMIT 10;

--2 Вывести последние 5 строк датасета.
SELECT * FROM nyc ORDER BY ctid DESC LIMIT 5;

--3 Выбрать только столбцы name и price.
SELECT name, price FROM nyc;

--4 Выбрать столбцы host_name, neighbourhood_group, room_type.
SELECT host_name, neighbourhood_group, room_type FROM nyc;

--5 Найти все объявления с ценой (price) больше 500
SELECT * FROM nyc WHERE price > 500;

--6 Найти все объявления с ценой меньше 100.
SELECT * FROM nyc WHERE price < 100;

--7 Найти все объявления, у которых minimum_nights равно 1.
SELECT  * FROM nyc WHERE minimum_nights = 1;

--8 Найти все объявления, у которых room_type равен 'Private room'.
SELECT * FROM nyc WHERE room_type='Private room';

--9 Найти все объявления, у которых room_type равен 'Entire home/apt'.
SELECT DISTINCT(room_type) FROM nyc;
SELECT * FROM nyc WHERE room_type = 'Entire home/apt';

--10 Найти все объявления в районе (neighbourhood_group) 'Brooklyn'.
SELECT * FROM nyc WHERE neighbourhood_group = 'Brooklyn';

--11 Найти все объявления в районе 'Manhattan'
SELECT * FROM nyc WHERE neighbourhood_group = 'Manhattan';

--12 Найти все объявления в районе 'Queens'.
SELECT * FROM nyc WHERE neighbourhood_group = 'Queens';

--13 Найти все объявления в районе 'Bronx'.
SELECT * FROM nyc WHERE neighbourhood_group = 'Bronx';

--14 Найти все объявления в районе 'Staten Island'.
SELECT * FROM nyc WHERE neighbourhood_group = 'Staten Island';

--31 Посчитать общее количество объявлений в датасете
SELECT COUNT(*) FROM nyc;

--32 Посчитать общее количество уникальных host_id.
SELECT COUNT(DISTINCT host_id) FROM nyc;

--33 Посчитать общее количество уникальных районов (neighbourhood)
SELECT COUNT(DISTINCT(neighbourhood)) FROM nyc;

--34 Найти среднюю цену (price) по всем объявлениям.
SELECT * FROM nyc;
SELECT AVG(price) FROM nyc;

--35 Найти минимальную цену (price).
SELECT MIN(price) FROM nyc;

--36 Найти максимальную цену (price).
SELECT MAX(price) FROM nyc;

--37 Найти среднее количество отзывов (number_of_reviews).
SELECT AVG(number_of_reviews) FROM nyc;

--38 Посчитать количество объявлений для каждого neighbourhood_group
SELECT neighbourhood_group, COUNT (*) FROM nyc GROUP BY neighbourhood_group;

--39 Посчитать количество объявлений для каждого room_type.
SELECT room_type, COUNT (*) FROM nyc GROUP BY room_type;

--40 Найти среднюю цену (price) для каждого neighbourhood_group.
SELECT neighbourhood_group, AVG(price) FROM nyc GROUP BY neighbourhood_group;

--41 Найти среднюю цену (price) для каждого room_type.
SELECT room_type, AVG(price) FROM nyc GROUP BY room_type;

--42 Найти максимальную цену (price) в каждом neighbourhood_group.
SELECT neighbourhood_group, MAX(price) FROM nyc GROUP BY neighbourhood_group;

--51 Посчитать количество объявлений для каждого хоста (host_id) и вывести тех, у кого больше 5 объявлений.
SELECT host_id, COUNT(*) FROM nyc GROUP BY host_id HAVING COUNT(*) > 5;

--57 Найти neighbourhood_group, в которых общее количество объявлений больше 1000
SELECT neighbourhood_group FROM nyc GROUP BY neighbourhood_group HAVING COUNT (*) > 1000;

--58 Найти host_id, у которых средняя цена их объявлений выше 300.
SELECT host_id FROM nyc GROUP BY host_id HAVING AVG(price) > 300;

--59 Найти room_type, у которых среднее количество отзывов больше 20.
SELECT room_type, AVG(number_of_reviews) FROM nyc GROUP BY room_type HAVING AVG(number_of_reviews) > 20;

--60 Найти neighbourhood_group, у которых максимальная цена превышает 5000.
SELECT neighbourhood_group, MAX(price) FROM nyc GROUP BY neighbourhood_group HAVING MAX(price) > 5000;

--61 Найти host_id, у которых больше 10 объявлений и средняя цена которых меньше 150.
SELECT host_id FROM nyc GROUP BY host_id HAVING COUNT(*) > 10 AND AVG(price) < 150;

--62 Найти районы (neighbourhood), где количество объявлений типа 'Entire home/apt' больше 100.
SELECT * FROM nyc;
SELECT neighbourhood, COUNT(*) FROM nyc WHERE room_type = 'Entire home/apt' GROUP BY neighbourhood HAVING COUNT(*) > 100;

--68 Найти все объявления, цена которых выше средней цены в их neighbourhood_group.
SELECT * FROM ( SELECT *, AVG(price) OVER (PARTITION BY neighbourhood_group) AS avg_price FROM nyc )
WHERE price > avg_price;

--70 Найти хостов, которые имеют объявления в более чем 3 разных районах (neighbourhood).
SELECT host_id FROM nyc GROUP BY host_id HAVING COUNT(distinct (neighbourhood)) > 3;

--71 Найти объявления, у которых price выше, чем у любого объявления хоста 'John'.
SELECT * FROM nyc WHERE host_name = 'John';
SELECT * FROM nyc WHERE price > ( SELECT MAX(price) FROM nyc WHERE host_name = 'John');

--72 Вывести neighbourhood_group, у которых средняя цена объявлений выше, чем средняя цена по всем объявлениям типа 'Private room'.
SELECT neighbourhood_group, AVG(price) FROM nyc GROUP BY neighbourhood_group HAVING AVG(price) > (SELECT AVG(price) FROM nyc WHERE room_type = 'Private room');

--73 Найти все объявления, которые находятся в тех же neighbourhood, что и объявление с id = 2539.
SELECT * FROM nyc WHERE id = '2539';
SELECT * FROM nyc WHERE neighbourhood IN (SELECT DISTINCT(neighbourhood) FROM nyc WHERE id = 2539);

--75 Для каждого neighbourhood_group пронумеровать объявления по убыванию цены.
SELECT neighbourhood_group, price, DENSE_RANK() OVER (PARTITION BY neighbourhood_group ORDER BY price DESC)  FROM nyc;

--76 Найти разницу между ценой текущего объявления и средней ценой по его neighbourhood_group.
SELECT host_id, price, AVG(price) OVER(PARTITION BY neighbourhood_group) AS avg_price, price-AVG(price) OVER(PARTITION BY neighbourhood_group) AS difference FROM nyc;

--77 Для каждого хоста (host_id) найти его самое дорогое объявление.
SELECT * FROM (SELECT host_id, price, DENSE_RANK () OVER (PARTITION BY host_id ORDER BY price DESC) AS rnkd FROM nyc) WHERE rnkd = 1;

--80 Разделить все объявления на 4 квартиля в зависимости от цены.
SELECT id, price, NTILE(4) OVER (ORDER BY price) FROM nyc;

--81 Найти объявления, цена которых отличается от средней по room_type более чем на 2 стандартных отклонения.
SELECT * FROM (SELECT *, AVG(price) OVER (PARTITION BY room_type) AS avg_price, STDDEV(price) OVER (PARTITION BY room_type) AS std_price FROM nyc)
WHERE ABS(price - avg_price) > 2 * std_price;

--85 Найти объявления, у которых last_review был больше года назад (относительно максимальной даты в датасете)
SELECT * FROM nyc WHERE last_review < (SELECT MAX(last_review) - INTERVAL '1 year' FROM nyc);

--86 Вывести длину названия (name) для каждого объявления.
SELECT name, LENGth(name) FROM nyc;

--89 Найти все объявления, где name содержит более 50 символов.
SELECT name, LENGTH (name) FROM nyc GROUP BY name HAVING LENGTH (name) > 50;

--93 Найти самый популярный room_type в каждом neighbourhood_group.
SELECT * FROM(
SELECT neighbourhood_group, room_type, COUNT (room_type), DENSE_RANK() OVER(PARTITION BY neighbourhood_group ORDER BY COUNT (room_type) DESC) FROM nyc GROUP BY neighbourhood_group, room_type)
WHERE dense_rank = 1;

--94 Найти среднюю цену за ночь для каждого neighbourhood_group и room_type, но только для тех, где средняя цена > 100.
SELECT neighbourhood_group, room_type, AVG (price) FROM nyc GROUP BY neighbourhood_group, room_type HAVING AVG (price) > 100;

--95 Для каждого neighbourhood_group найти хост-рекордсмена по количеству объявлений.
SELECT * FROM (SELECT neighbourhood_group, host_id, COUNT (host_id), DENSE_RANK() OVER(PARTITION BY neighbourhood_group ORDER BY COUNT (host_id) DESC) FROM nyc GROUP BY neighbourhood_group, host_id)
WHERE dense_rank = 1;

--96 Вывести топ-3 neighbourhood по средней цене в 'Manhattan'.
SELECT neighbourhood, AVG(price) FROM nyc WHERE neighbourhood_group = 'Manhattan' GROUP BY neighbourhood ORDER BY avg desc LIMIT 3;

--97 Посчитать, какой процент от всех объявлений составляют объявления с availability_365 > 300.
SELECT ROUND ((SELECT COUNT(*) FROM nyc WHERE availability_365 > 300) * 100) / (SELECT (COUNT (availability_365)) FROM nyc);

--98 Найти объявления, которые имеют 0 отзывов, но availability_365 > 200.
SELECT * FROM nyc WHERE number_of_reviews = 0 AND availability_365 > 200;

--99 Для каждого хоста найти разницу между его максимальной и минимальной ценой.
SELECT host_id, MAX(price)-MIN(price) FROM nyc GROUP BY host_id;

--100 Найти neighbourhood_group, где самый высокий процент объявлений типа 'Shared room'.
SELECT neighbourhood_group, COUNT(*) AS total, SUM(CASE WHEN room_type = 'Shared room' THEN 1 ELSE 0 END) AS shared,
ROUND(SUM(CASE WHEN room_type = 'Shared room' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS shared_pct FROM nyc GROUP BY neighbourhood_group ORDER BY shared_pct DESC LIMIT 1;

--106 Вывести host_id, которые сдают в аренду и 'Entire home/apt', и 'Private room'.
SELECT host_id, COUNT(DISTINCT(room_type)) FROM nyc WHERE room_type = 'Private room' OR room_type = 'Entire home/apt' GROUP BY host_id HAVING COUNT(DISTINCT(room_type)) = 2;

--107 Найти среднее количество объявлений на одного хоста в каждом neighbourhood_group.
WITH virok AS (SELECT neighbourhood_group, host_id, COUNT (*) FROM nyc GROup BY neighbourhood_group, host_id)
SELECT neighbourhood_group, AVG(count) FROM virok GROUP BY neighbourhood_group;

--116 Найти объявления, добавленные хостом, у которого есть объявления в 3 и более разных neighbourhood_group.
SELECT * FROM nyc WHERE host_id in (SELECT host_id FROM nyc group by host_id HAVING COUNT(DISTINCT(neighbourhood_group)) >= 3);

--118 Найти объявления, у которых цена выше, чем у 90% всех остальных объявлений.
SELECT * FROM (SELECT *, NTILE(10) OVER(ORDER BY price) FROM nyc) WHERE ntile = 10;

--119 Для каждого neighbourhood_group найти медианную цену (в SQL может потребоваться специфическая функция).
SELECT neighbourhood_group, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) AS median_price FROM nyc GROUP BY neighbourhood_group ORDER BY median_price DESC;

--120 Каково распределение объявлений по ценовым диапазонам (например, 0-100, 101-200, 201-300 и т.д.)?
SELECT CASE WHEN price <= 100 THEN 'Между 0 и 100'
 WHEN price <= 200 THEN 'Между 101 и 200'
 WHEN price <= 300 THEN 'Между 201 и 300'
 WHEN price <= 400 THEN 'Между 301 и 400'
 WHEN price <= 500 THEN 'Между 401 и 500'
 WHEN price <= 600 THEN 'Между 501 и 600'
 WHEN price <= 700 THEN 'Между 601 и 700'
 WHEN price <= 800 THEN 'Между 701 и 800'
 WHEN price <= 900 THEN 'Между 801 и 900'
 WHEN price <= 1000 THEN 'Между 901 и 1000'
 WHEN price <= 1100 THEN 'Между 1001 и 1100'
 WHEN price <= 1200 THEN 'Между 1101 и 1200'
 WHEN price <= 1300 THEN 'Между 1201 и 1300'
 WHEN price <= 1400 THEN 'Между 1301 и 1400' ELSE 'более 1400' END AS Диапазон, COUNT(*) FROM nyc GROUP BY Диапазон ORDER BY count DESC;

 --123 Есть ли связь между calculated_host_listings_count и средней ценой объявления?
SELECT calculated_host_listings_count, AVG(price) FROM nyc GROUP BY calculated_host_listings_count ORDER BY avg DESC;
SELECT CORR (calculated_host_listings_count, price) FROM nyc;
SELECT * FROM nyc;

--124 Какие 5 хостов имеют наибольшее суммарное количество отзывов на все свои объявления?
SELECT host_id, SUM(number_of_reviews) FROM nyc GROUP BY host_id ORDER BY sum DESC LIMIT 5;

--125 В каком месяце 2019 года было оставлено больше всего отзывов?
SELECT TO_CHAR (last_review, 'Month') AS Month, SUM(number_of_reviews) FROM nyc WHERE EXTRACT('Year' FROM last_review) = '2019' GROUP BY Month ORDER BY sum DESC limit 1;

--129 Посчитайте, сколько хостов имеют объявления и в 'Manhattan', и в 'Brooklyn'.
SELECT COUNT (*) FROM (SELECT host_id FROM nyc WHERE neighbourhood_group IN ('Manhattan', 'Brooklyn') GROUP BY host_id
HAVING COUNT(DISTINCT neighbourhood_group) = 2);

--131 Каково среднее количество объявлений на одного уникального хоста для каждого neighbourhood_group?
SELECT neighbourhood_group, AVG(count) FROM (SELECT neighbourhood_group, host_id, COUNT (*) FROM nyc GROUP BY neighbourhood_group, host_id) GROUP BY neighbourhood_group;

--132 Найдите объявления, которые не сдавались в аренду (last_review is NULL) и имеют availability_365 = 0.
SELECT * FROM nyc WHERE last_review IS NULL AND availability_365 = 0;

--134 Найдите хостов, у которых есть объявления с одинаковым названием (name)
SELECT host_name, COUNT(DISTINCT host_id) FROM nyc GROUP BY host_name HAVING COUNT(DISTINCT host_id) > 1;

--136 Определите 10 самых "популярных" объявлений (по number_of_reviews) и выведите их name, host_name, neighbourhood.
SELECT name, host_name, neighbourhood FROM nyc ORDER BY number_of_reviews DESC LIMIT 10;

--141 Какой хост (host_id) имеет самый широкий разброс цен на свои объявления (max-min)?
SELECT host_id, MAX(price), MIN(price), MAX(price)-MIN(price) AS "diapazon" FROM nyc GROUP BY host_id ORDER BY "diapazon" DESC LIMIT 1;

--143 Посчитайте, какой процент хостов имеют только 1 объявление.
SELECT (SELECT COUNT(*) FROM (SELECT COUNT (*) FROM nyc GROUP BY host_id HAVING COUNT (*) = 1))  * 100 / (SELECT COUNT(DISTINCT(host_id)) FROM nyc);

--145 Для каждого хоста (host_id) выведите количество уникальных neighbourhood, в которых он сдает жилье.
SELECT host_id, COUNT(DISTINCT(neighbourhood)), STRING_AGG (neighbourhood, ',') FROM nyc GROUP BY host_id ORDER BY count;

--147 Выведите neighbourhood_group, где самый высокий процент объявлений с availability_365 = 365.
SELECT neighbourhood_group, SUM(CASE WHEN availability_365 = 365 THEN 1 ELSE 0 end) * 100.0 /  COUNT(*) AS prcnt FROM nyc 
GROUP BY neighbourhood_group ORDER BY prcnt DESC limit 1;

--148 Найдите хостов, у которых есть объявления с price > 500 и price < 100.
SELECT host_id FROM nyc GROUP BY host_id HAVING sum(CASE WHEN price > 500 THEN  1 ELSE 0 END) > 0 AND 
sum(CASE WHEN price < 100 THEN  1 ELSE 0 END) > 0;

--150 Найдите объявления, которые имеют отзывы (last_review is not null), но reviews_per_month is null.
SELECT * FROM nyc WHERE last_review is not null AND reviews_per_month IS NULL;

--152 Найдите 5 хостов с наибольшим количеством объявлений, но у которых среднее количество отзывов на объявление меньше 5.
SELECT host_id, COUNT (*) FROM nyc GROUP BY host_id HAVING AVG(number_of_reviews) < 5 ORDER BY count DESC LIMIT 5;

--153 Посчитайте среднюю цену для объявлений, у которых last_review был в последний месяц датасета.
SELECT AVG(price) FROM nyc WHERE last_review >= (SELECT MAX(last_review) - INTERVAL '1 month' FROM nyc);

--155 Выведите room_type, у которых медианная цена выше средней.
SELECT room_type, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price), AVG(price) FROM nyc 
GROUP BY room_type HAVING PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) > AVG(price);

--158 Выведите объявления, у которых price выше, чем у среднего объявления того же room_type в том же neighbourhood.
SELECT * FROM (SELECT *, AVG(price) OVER(PARTITION BY neighbourhood_group, room_type) AS avg_p FROM nyc) WHERE price > avg_p;

--162 Выведите neighbourhood, где количество объявлений типа 'Private room' больше, чем 'Entire home/apt'.
SELECT neighbourhood, SUM(CASE WHEN room_type = 'Private room' THEN 1 ELSE 0 END) AS pr_room,
SUM(CASE WHEN room_type = 'Entire home/apt' THEN 1 ELSE 0 END) AS entire FROM nyc GROUP BY neighbourhood 
HAVING SUM(CASE WHEN room_type = 'Private room' THEN 1 ELSE 0 END) > SUM(CASE WHEN room_type = 'Entire home/apt' THEN 1 ELSE 0 END);

--164 Найдите объявления, у которых цена выше, чем у 95% объявлений в их neighbourhood_group.
SELECT * FROM (SELECT *, NTILE(20) OVER(PARTITION BY neighbourhood_group ORDER BY price) FROM nyc) WHERE ntile = 20;

--167 Найдите хостов, у которых есть объявления в neighbourhood_group = 'Bronx' и 'Staten Island'.
SELECT host_id FROM nyc WHERE neighbourhood_group IN ('Bronx', 'Staten Island')
GROUP BY host_id HAVING COUNT(DISTINCT(neighbourhood_group)) = 2;

--170 Найдите объявления, у которых name содержит '!' или '?'.
SELECT * FROM nyc WHERE name LIKE '%!%' OR name LIKE '%?%';

--173 Выведите neighbourhood, у которых нет объявлений типа 'Entire home/apt'.
SELECT DISTINCT neighbourhood FROM nyc WHERE neighbourhood NOT IN
(SELECT DISTINCT neighbourhood FROM nyc WHERE room_type = 'Entire home/apt');

--176 Посчитайте среднюю цену для объявлений, у которых host_id имеет более 10 объявлений.
SELECT (AVG(price)) FROM nyc WHERE host_id IN (SELECT host_id FROM nyc GROUP BY host_id HAVING COUNT(*) > 10);

--177 Выведите neighbourhood_group, где самый высокий процент хостов с calculated_host_listings_count > 5.
SELECT neighbourhood_group, (COUNT(DISTINCT CASE WHEN calculated_host_listings_count > 5 THEN host_id ELSE 0 END) * 100 
/ COUNT (DISTINCT host_id)) AS prcnt  FROM nyc
GROUP BY neighbourhood_group ORDER BY prcnt DESC LIMIT 1;

--183 Найдите хостов, у которых все объявления имеют availability_365 > 200
SELECT host_id FROM nyc GROUP BY host_id HAVING MIN(availability_365) = 200;

--185 Найдите объявления, у которых last_review был в тот же день, что и другой отзыв.
SELECT * FROM nyc WHERE last_review IN (SELECT last_review FROM nyc GROUP BY last_review HAVING COUNT (*) > 1);

--187 Найдите хостов, у которых есть объявления с одинаковым price и neighbourhood.
SELECT host_id FROM nyc GROUP BY host_id, price, neighbourhood HAVING COUNT (*) > 1;

--188 Выведите neighbourhood, где самый высокий процент объявлений с reviews_per_month > 1.
SELECT neighbourhood, (SUM (CASE WHEN reviews_per_month > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS prcnt FROM nyc 
GROUP BY neighbourhood ORDER BY prcnt DESC;

--191 Посчитайте среднее количество объявлений на одного хоста для каждого room_type.
SELECT room_type, AVG(count) FROM (SELECT room_type, host_id, COUNT (*) FROM nyc GROUP BY room_type, host_id) group by room_type;

--192 Выведите neighbourhood_group, где самый высокий процент объявлений с 0 отзывов.
SELECT neighbourhood_group, (COUNT (*) FILTER (WHERE number_of_reviews = 0) * 100.0 / COUNT (*)) AS prcnt
FROM nyc GROUP BY neighbourhood_group ORDER BY prcnt DESC LIMIT 1;

--196 Выведите room_type, у которых минимальная цена равна 0.
SELECT room_type FROM nyc GROUP BY room_type HAVING MIN(price) = 0;

--199 Выведите neighbourhood, где количество объявлений с minimum_nights = 1 максимально.
SELECT neighbourhood FROM nyc GROUP BY neighbourhood HAVING MAX(minimum_nights) = 1; 

--201 Найдите объявления, у которых name содержит и 'Cozy', и 'Quiet'.
SELECT * FROM nyc WHERE name LIKE '%Cozy%' AND name LIKE '%Quiet%';

--206 Найдите хостов, у которых есть объявления с minimum_nights = 1 и minimum_nights > 30.
SELECT host_id FROM nyc GROUP BY host_id HAVING SUM(CASE WHEN minimum_nights = 1 THEN 1 ELSE 0 END) > 0 
AND SUM(CASE WHEN minimum_nights > 30 THEN 1 ELSE 0 END) > 0;

--208 Найдите объявления, у которых last_review был более 5 лет назад.
SELECT * FROM nyc WHERE last_review < (SELECT MAX(last_review)-INTERVAL'5 years' FROM nyc);

--211 Выведите neighbourhood, где самый высокий процент объявлений с availability_365 = 0.
SELECT neighbourhood, (AVG(CASE WHEN availability_365 = 0 THEN 1 ELSE 0 END) * 100) AS prcnt FROM nyc GROUP BY neighbourhood
ORDER BY prcnt DESC limit 1;

--215 Выведите neighbourhood_group, где самый высокий процент объявлений с minimum_nights > 30.
SELECT neighbourhood_group, (AVG (CASE WHEN minimum_nights > 30 THEN 1 ELSE 0 END ) * 100) AS prcnt FROM nyc 
GROUP BY neighbourhood_group ORDER BY prcnt DESC LIMIT 1;
