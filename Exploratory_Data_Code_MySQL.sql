-- Exploratory Data Analysis

Select *
from layoffs_staging2;


Select MAX(total_laid_off),MAX(percentage_laid_off)
from layoffs_staging2;

Select *
from layoffs_staging2
Where percentage_laid_off = 1
Order by funds_raised_millions DESC;

Select company ,SUM(total_laid_off)
from layoffs_staging2
Group by company
Order by 2 DESC;

Select MIN(`date`) min_date, MAX(`date`) max_date
from layoffs_staging2;

Select industry ,SUM(total_laid_off)
from layoffs_staging2
Group by industry
Order by 2 DESC;

Select *
from layoffs_staging2;

Select country ,SUM(total_laid_off) tloff
from layoffs_staging2
Group by country
Order by 2 DESC;

Select Year(`date`) ,SUM(total_laid_off) tloff
from layoffs_staging2
Group by Year(`date`)
Order by 1 DESC;

Select stage ,SUM(total_laid_off) tloff
from layoffs_staging2
Group by stage
Order by 2 DESC;

Select company ,AVG(percentage_laid_off)
from layoffs_staging2
Group by company
Order by 2 DESC;

Select SUBSTRING(`date`,1,7) as `Month`, SUM(total_laid_off)
From layoffs_staging2
Where SUBSTRING(`date`,1,7) IS NOT NULL
Group by `Month`
Order by 1 ASC;


With Rolling_Total AS 
(
Select SUBSTRING(`date`,1,7) as `Month`, SUM(total_laid_off) as Total_off
From layoffs_staging2
Where SUBSTRING(`date`,1,7) IS NOT NULL
Group by `Month`
Order by 1 ASC
)
Select `Month`, Total_off, SUM(Total_off) Over(Order by `Month` ) as rolling_total
from  Rolling_Total;


Select company ,SUM(total_laid_off)
from layoffs_staging2
Group by company
Order by 2 DESC;

Select company ,Year(`date`), SUM(total_laid_off)
from layoffs_staging2 
Group by company,Year(`date`)
Order by 3 desc;

With Company_Year (company,years,Total_laid_off) AS
(
Select company ,Year(`date`), SUM(total_laid_off)
from layoffs_staging2 
Group by company,Year(`date`)
), Company_Year_Rank AS
(
Select *, Dense_rank () Over (PARTITION BY years Order by total_laid_off DESC) Ranking
From Company_Year
Where years is not null
)

Select *
from Company_Year_Rank
Where Ranking <=5 
;
