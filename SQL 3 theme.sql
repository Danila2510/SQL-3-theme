-- 1 
CREATE PROCEDURE GetBooksByCriteria
    @FirstName NVARCHAR(50) = NULL,
    @LastName NVARCHAR(50) = NULL,
    @ThemeID INT = NULL,
    @CategoryID INT = NULL,
    @Field NVARCHAR(50),
    @Direction NVARCHAR(4)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX)
    SET @sql = N'SELECT b.id, b.name, b.year_press, b.id_theme, b.id_category, b.id_author, b.id_publishment, b.comment, b.quantity
                FROM Book b
                WHERE 1 = 1'

    IF @FirstName IS NOT NULL
        SET @sql = @sql + N' AND EXISTS (SELECT 1 FROM Author a WHERE a.id = b.id_author AND a.first_name = @AuthorFirstName)'

    IF @LastName IS NOT NULL
        SET @sql = @sql + N' AND EXISTS (SELECT 1 FROM Author a WHERE a.id = b.id_author AND a.last_name = @AuthorLastName)'

    IF @ThemeID IS NOT NULL
        SET @sql = @sql + N' AND b.id_theme = @ThemeID'

    IF @CategoryID IS NOT NULL
        SET @sql = @sql + N' AND b.id_category = @CategoryID'

    SET @sql = @sql + N' ORDER BY ' + QUOTENAME(@Field) + ' ' + @Direction
	EXEC sp_executesql @sql, N'@AuthorFirstName NVARCHAR(50), @AuthorLastName NVARCHAR(50), @ThemeID INT, @CategoryID INT', @AuthorFirstName, @AuthorLastName, @ThemeID, @CategoryID
    
END


EXEC GetBooksByCriteria @FirstName = 'Сергей', @LastName = 'Никольский', @ThemeID = 4, @CategoryID = 2, @Field = 'name', @Direction = 'ASC'

--2

CREATE PROCEDURE GetStudentWithMostBooks
AS
BEGIN
    SELECT TOP 1 s.first_name, s.last_name
    FROM Student s
    JOIN S_Cards sc ON s.id = sc.id_student
    GROUP BY s.id, s.first_name, s.last_name
    ORDER BY COUNT(sc.id_book) DESC
END




-- 3 
CREATE PROCEDURE GetTotalBooksBorrowed
AS
BEGIN
    DECLARE @TotalBooks INT

    SELECT @TotalBooks = COUNT(*) FROM (
        SELECT id_book FROM S_Cards
        UNION ALL
        SELECT id_book FROM T_Cards
    ) AS CombinedCards

    SELECT @TotalBooks AS TotalBooksBorrowed
END