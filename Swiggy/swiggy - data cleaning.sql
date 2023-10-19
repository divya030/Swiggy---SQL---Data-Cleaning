SELECT * FROM Swiggy.swiggy_50;


-- To display null values 

SELECT * FROm Swiggy.swiggy_50
WHERE "Restaurent Name" is null 
OR `category` is null 
OR `Rating` is null  
OR `cost for two` is null 
OR `veg` is null 
OR `city` is null 
OR `Area` is null  
OR `Locality` is null 
OR `Address` is null 
OR `Long Distance delivery` is null; 


-- Replace the null values in locality with the area address. Both are almost similar

SELECT Area , Locality
FROM Swiggy.swiggy_50
WHERE `Locality` is null;

UPDATE  Swiggy.swiggy_50
SET Locality = Area
WHERE Locality is Null;

-- Replace the null values in Address with the area and city

SELECT * FROm Swiggy.swiggy_50
WHERE Address is null;

UPDATE Swiggy.swiggy_50
SET Address = concat(Area," ",city)
WHERE Address is null;

-- Split the category into 2 columns category, sub category

Select 
Substring(Category, 1 , LOCATE(',', Category)-1) as Main_category, 
substring(category, Locate(',',category)+1, LENGTH(category)) AS subcategory
from Swiggy.swiggy_50;

ALTER TABLE Swiggy.swiggy_50
ADD COLUMN Main_category char(250),
ADD COLUMN Sub_category char(250);

UPDATE Swiggy.swiggy_50
SET  Main_category = Substring(Category, 1 , LOCATE(',', Category)-1);


UPDATE Swiggy.swiggy_50
SET Sub_category = substring(category, Locate(',',category)+1, LENGTH(category));

-- The above query gave few null in main category so do the below
-- Have to replace the null in main category with value in sub category

select Category, sub_category
from Swiggy.swiggy_50 
where Main_category = "";

UPDATE Swiggy.swiggy_50
SET  Main_category = sub_category
where Main_category = "";

-- Change long distance delievry to yes / no

ALTER TABLE Swiggy.swiggy_50 
MODIFY `Long Distance Delivery` char(250);

Update Swiggy.swiggy_50  
set `Long Distance Delivery` = CASE `Long Distance Delivery`
WHEN "Long Distance Delivery"  = 0 then "NO"
WHEN "Long Distance Delivery" = 1 then "Yes"
else "NA"
end;

-- Change the Ratings to words like poor, avg, very good, excellent

-- Change the NA to median in Rating
-- The 'rating' column seems to have 50% of the data as NaN. 
-- Since, 'rating' might is a crucial role in the analysis,
-- NaN can be imputed with mean values

Select avg(Rating)
from Swiggy.swiggy_50;

-- The average of Rating is 1.73 which will Replace NaN values.

UPDATE Swiggy.swiggy_50
SET Rating = 1.73
WHERE Rating = 0 ;

ALTER TABLE Swiggy.swiggy_50
ADD COLUMN Ratings_categroy char(250);

update Swiggy.swiggy_50
set Ratings_categroy = case
when Rating >= 0  and Rating <= 2 then "Poor"
when Rating > 2 and Rating <= 3.5 then "Average"
when Rating > 3.5 and Rating <= 4.5 then "Very good"
when Rating > 4.5 and Rating <= 5 then "Excellent"
else "Not_Available"
end;


-- Change cost for two to cheap,Affordable,Budget friendly,High price,Very expensive

ALTER TABLE Swiggy.swiggy_50
ADD COLUMN Budget_type char(250);

SELECT MIN(`cost for two`)
FROM Swiggy.swiggy_50;

SELECT Max(`cost for two`)
FROM Swiggy.swiggy_50;

SELECT avg(`cost for two`)
FROM Swiggy.swiggy_50;

select distinct(`cost for two`), count(`cost for two`) as C
-- row_number() over (partition by `cost for two`) as `Rank`
from Swiggy.swiggy_50
group by 1
order by C;

select `Restaurant Name`, `cost for two`
from Swiggy.swiggy_50
where `cost for two` <= 620;


Update Swiggy.swiggy_50
set Budget_type =
case
when `cost for two` <= 620 then "cheap"
when `cost for two` <= 1240 then "Affordable"
when `cost for two` <= 1860 then "Budget friendly"
when `cost for two` <= 2480 then "High price"
when `cost for two` > 2481 then "very expensive"
else `cost for two`
end;

-- Drop unnecessary columns

Alter table Swiggy.swiggy_50
drop column Category;









