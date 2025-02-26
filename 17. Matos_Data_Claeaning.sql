-- Data Cleaning

Select *
from layoffs;


-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null Values or Blank Spaces
-- 4. Remove Any Columns and Rows


-- 1. Remove Duplicates

CREATE TABLE layoffs_staging
Like layoffs;


Select *
from layoffs_staging;

Insert layoffs_staging
Select *
from layoffs;


Select *,
ROW_NUMBER() OVER(
PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`) AS row_num
from layoffs_staging;

WITH duplicate_cte AS
(
Select *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,
country,funds_raised_millions) AS row_num
from layoffs_staging
)
Select *
from duplicate_cte
where row_num > 1;

Select *
from layoffs_staging
where company = "Casper";




WITH duplicate_cte AS
(
Select *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,
country,funds_raised_millions) AS row_num
from layoffs_staging
)
Delete
from duplicate_cte
where row_num > 1;



CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select *
from layoffs_staging2;

INSERT INTO layoffs_staging2
Select *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,
country,funds_raised_millions) AS row_num
from layoffs_staging;

Delete
from layoffs_staging2
where row_num > 1;

Select *
from layoffs_staging2;


-- 2. Standardize the data

Select company, TRIM(company)
from layoffs_staging2;

Update layoffs_staging2
Set company = TRIM(company);


Select Distinct industry
from layoffs_staging2;


Select *
from layoffs_staging2
Where industry Like 'Crypto%';


Update layoffs_staging2
Set industry = 'Crypto'
Where industry Like 'Crypto%';


Select *
from layoffs_staging2
Where country LIKE 'United States%'
order by 1;

Select Distinct country , TRIM(TRAILING '.' FROM country)
from layoffs_staging2
Order by 1;

Update layoffs_staging2
Set country = TRIM(TRAILING '.' FROM country)
Where country Like 'United States%';

Select *
from layoffs_staging2;

Select `date`
from layoffs_staging2;


Update layoffs_staging2
Set `date` = STR_TO_DATE(`date`,'%m/%d/%Y') ;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- 3. Null Values or Blank Spaces

Select *
from layoffs_staging2
Where total_laid_off is null AND
percentage_laid_off is null 
;

Update layoffs_staging2
Set industry = null
where industry = '' ;


Select *
from layoffs_staging2
Where industry is null 
OR industry = "";

 
Select * 
from layoffs_staging2
Where  company = 'Airbnb';


Select t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
Where (t1.industry IS NULL Or t1.industry = "")  
AND t2.industry IS NOT NULL  ; 


Update layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
Set t1.industry = t2.industry
Where t1.industry IS NULL  
AND t2.industry IS NOT NULL  ; 


-- 4. Remove Any Columns and Rows

Select *
from layoffs_staging2
Where total_laid_off is null AND
percentage_laid_off is null ;

Delete
from layoffs_staging2
Where total_laid_off is null AND
percentage_laid_off is null ;


Select *
from layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
