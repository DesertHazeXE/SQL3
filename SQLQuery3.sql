--Kitabxana database-i qurursunuz
	Create DataBase Library
	Use Library

--Books (Id, Name, PageCount)
--Books-un Name columu minimum 2 simvol maksimum 100 simvol deyer ala bileceyi serti olsun.
--Books-un PageCount columu minimum 10 deyerini ala bileceyi serti olsun.
	
	Create Table Books
	(
		Id int primary key identity, 
		Name  nvarchar(100) CONSTRAINT CK_BookName check(LEN(Name)>=2 and LEN(Name)<=100),
		PageCount int CONSTRAINT CK_BookPageCount check(PageCount>=10)
	)

--Authors (Id, Name, Surname)
	Create Table Authors
	(
		Id int primary key identity,
		Name nvarchar(50), 
		Surname nvarchar(50)
	)
	
	
--Books ve Authors table-larinizin mentiqi uygun elaqesi olsun.
	Alter Table Books
	Add AuthorsID int REFERENCES Authors(Id)

--Yazar Elave et
  Insert Into Authors(Name,Surname)
  values ('Ferid','Mentorovic'),
		 ('Eli', 'Eliyev' ),
		 ('Ismail', 'Hormetliyev'),
		 ('Ismet', 'Agayev'),
		 ('Natavan', 'Xursudbani')
		 select * from Authors

--Kitab Elave et
	Insert Into Books(Name,PageCount,AuthorsID)
	values ('2000 lyo su alti ile',560,1),
		   ('Bassiz atli',530,2),
		   ('Herakl',940,1),
		   ('Esseyin sirri',119,2),
		   ('Heyat bagi',242,3),
		   ('8 mocuze',340,4)
		
		   



--Id, Name, PageCount ve AuthorFullName columnlarinin valuelarini qaytaran bir view yaradin
	Create View usv_GetBooks_With_AuthorFullName
	As
	Select b.Id,b.Name,b.PageCount,(a.Name+' '+a.Surname) 'AuthorFullName' from Books b
	join Authors a
	on b.AuthorsID=a.Id

	Select * from usv_GetBooks_With_AuthorFullName

--Gonderilmis axtaris deyirene gore hemin axtaris deyeri 
--name ve ya authorFullNamelerinde olan Book-lari 
--Id, Name, PageCount, AuthorFullName columnlari seklinde gostern procedure yazin

	Create Procedure usp_SearchBooksByString (@BooksString nvarchar(30))
	As
	Begin
	Select b.Id,b.Name,b.PageCount,(a.Name+' '+a.Surname) 'AuthorFullName' from Books b
	join Authors a
	on b.AuthorsID=a.Id
	Where b.Name like '%'+@BooksString+'%'or a.Name like '%'+@BooksString+'%' or a.Surname like '%'+@BooksString+'%'
	End

	EXEC usp_SearchBooksByString 'He'

--Authors tableinin insert, update ve deleti ucun (her biri ucun ayrica) procedure yaradin

--Insert
	Create Procedure usp_InsertAuthorsData(@Name nvarchar(100),@Surname nvarchar(100))
	AS
	Begin
	insert into Authors(Name,Surname)
	Values (@Name,@Surname)
	End

	 --Test Procedure
	Exec usp_InsertAuthorsData 'Sexavet','Eliyev'
	

--Update
	 Create Procedure usp_UpdateAuthorsDataById
	 (@AuthorsID int,@NewName nvarchar(100),@NewSurname nvarchar(100))
	 As
	 begin
	 Update Authors
	 set Name=@NewName,Surname=@NewSurname
	 where Id=@AuthorsID
	 END

		--Test Procedure
	 EXEC usp_UpdateAuthorsDataById'10','Samir','Qurbanov'

--Delete
	 Create Procedure usp_DeleteAuthorsDataByID (@AuthorsID int)
	 As
	 begin
	 Delete Authors
	 where Id=@AuthorsID
	 END

	    --Test Procedure
	 Exec usp_DeleteAuthorsDataByID '9'


--Authors-lari Id,FullName,BooksCount,MaxPageCount seklinde qaytaran view yaradirsiniz 
--Id-author id-si, FullName - Name ve Surname birlesmesi, BooksCount - 
--Hemin authorun elaqeli oldugu kitablarin sayi, MaxPageCount -
--hemin authorun elaqeli oldugu kitablarin icerisindeki max pagecount deyeri
	
	
	Create View usv_GetBooks_Id_FullName_BooksCount_MaxPageCount
	As
    Select a.Id,(a.Name+' '+a.Surname) 'FullName',
		Count((a.Name+' '+a.Surname)) 'BooksCount' ,
		MAX(b.PageCount) 'MaxPageCount' 
		from Authors a
   join Books b
		on a.Id=b.AuthorsID
		group by (a.Name+' '+a.Surname),a.Id

	--Test View
	Select * from usv_GetBooks_Id_FullName_BooksCount_MaxPageCount