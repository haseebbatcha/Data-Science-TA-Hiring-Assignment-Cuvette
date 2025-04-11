--1)List the top 5 customers by total purchase amount.
SELECT 
    c.FirstName || ' ' || c.LastName AS CustomerName,
    SUM(i.Total) AS TotalSpent
FROM 
    Invoice i
JOIN 
    Customer c ON i.CustomerId = c.CustomerId
GROUP BY 
    i.CustomerId
ORDER BY 
    TotalSpent DESC
LIMIT 5;



--2)Find the most popular genre in terms of total tracks sold.
SELECT 
    g.Name AS Genre,
    COUNT(il.TrackId) AS TotalTracksSold
FROM 
    InvoiceLine il
JOIN 
    Track t ON il.TrackId = t.TrackId
JOIN 
    Genre g ON t.GenreId = g.GenreId
GROUP BY 
    g.GenreId
ORDER BY 
    TotalTracksSold DESC
LIMIT 1;




--3)Retrieve all employees who are managers along with their subordinates.
SELECT 
    m.EmployeeId AS ManagerID,
    m.FirstName || m.LastName AS ManagerName,
    e.EmployeeId AS SubordinateID,
    e.FirstName || e.LastName AS SubordinateName
FROM 
    Employee e
JOIN 
    Employee m ON e.ReportsTo = m.EmployeeId
ORDER BY 
    ManagerID;
    



--4)For each artist, find their most sold album.
WITH AlbumSales AS (
    SELECT 
        ar.Name AS Artist,
        al.Title AS Album,
        al.AlbumId,
        COUNT(il.TrackId) AS TotalTracksSold
    FROM 
        InvoiceLine il
    JOIN 
        Track t ON il.TrackId = t.TrackId
    JOIN 
        Album al ON t.AlbumId = al.AlbumId
    JOIN 
        Artist ar ON al.ArtistId = ar.ArtistId
    GROUP BY 
        al.AlbumId
),
RankedAlbums AS (
    SELECT *,
           RANK() OVER (PARTITION BY Artist ORDER BY TotalTracksSold DESC) AS Rank
    FROM AlbumSales
)
SELECT 
    Artist,
    Album,
    TotalTracksSold
FROM 
    RankedAlbums
WHERE 
    Rank = 1;




--5)Write a query to get monthly sales trends in the year 2013.
SELECT 
    STRFTIME('%Y-%m', InvoiceDate) AS Month,
    ROUND(SUM(Total), 2) AS MonthlySales
FROM  Invoice
WHERE 
    STRFTIME('%Y', InvoiceDate) = '2013'
GROUP BY Month
ORDER BY Month;




