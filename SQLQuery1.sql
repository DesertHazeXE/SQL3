 --Database Yaradin Adi Ne Olursa Olsun
Create DataBase SpaceXModul
Use SpaceXModul

--Brands Adinda Table Yaradin 2 dene colum Id ve Name
	Create Table Brands
	(
		Id int primary key identity,
		Name nvarchar(50)
	)

--Notebooks Adinda Table Yaradin Id,Name, Price Columlari Olsun.
	Create Table Notebooks
	(
		Id int Primary Key identity,
		Name nvarchar(50),
		Price money
	)
--Phones Adinda Table Yaradin Id, Name, Price Columlari Olsun.
	Create Table Phones
	(
		Id int Primary Key identity,
		Name nvarchar(50),
		Price money
	)
--1) Notebook ve Brand Arasinda Mentiqe Uygun Relation Qurun.
    Alter Table Notebooks 
	Add BrandID int Constraint FK_NoteBook_Brands references Brands(Id)

--2) Phones ve Brand Arasinda Mentiqe Uygun Relation Qurun.
	Alter Table Phones
	Add BrandID int Constraint FK_Phones_Brands references Brands(Id)

--3) Notebooks Adini, Brandin Adini BrandName kimi ve Qiymetini Cixardan Query.
	Select n.Name 'Product Name',b.Name 'BrandName',n.Price from Notebooks n
	join Brands b
	on n.BrandID=b.Id
	

--4) Phones Adini, Brandin Adini BrandName kimi ve Qiymetini Cixardan Query.
	Select p.Name 'Product Name',b.Name 'BrandName',p.Price from Phones p
	join Brands b
	on p.BrandID=b.Id
--5) Brand Adinin Terkibinde s Olan Butun Notebooklari Cixardan Query.
	Select n.Name 'Product Name',b.Name 'BrandName',n.Price from Notebooks n
	join Brands b
	on n.BrandID=b.Id
	Where b.Name like '%s%'
--6) Qiymeti 2000 ve 5000 arasi ve ya 5000 den yuksek Notebooklari Cixardan Query.
	Select n.Name 'Product Name',b.Name 'BrandName',n.Price from Notebooks n
	join Brands b
	on n.BrandID=b.Id
	Where (n.Price between 2000 and 5000) or (n.Price>5000) 

--7) Qiymeti 1000 ve 1500 arasi ve ya 1500 den yuksek Phonelari Cixardan Query.
     Select p.Name 'Product Name',b.Name 'BrandName',p.Price from Phones p
	join Brands b
	on p.BrandID=b.Id
	Where (p.Price between 1000 and 1500) or (p.Price>1500) 

--8) Her Branda Aid Nece dene Notebook Varsa Brandin Adini Ve Yaninda Sayini Cixardan Query.
   Select b.Name 'Brand Name', Count(b.Name) 'Products Count' from Brands b
   join Notebooks n
   on b.Id=n.BrandID
   group by b.Name
  
--9) Her Branda Aid Nece dene Phone Varsa Brandin Adini Ve Yaninda Sayini Cixardan Query.
	Select b.Name 'Phone Brand Name', Count(b.Name) 'Products Count' from Brands b
	join Phones p
    on b.Id=p.BrandID
    group by b.Name

--10) Hem Phone Hem de Notebookda Ortaq Olan Name ve BrandId Datalarni Bir Cedvelde Cixardan Query.
	select Name,BrandID from Phones
	intersect
	select Name,BrandID from Notebooks

--11) Phone ve Notebook da Id, Name, Price, ve BrandId Olan Butun Datalari Cixardan Query.
	Select p.Id 'ID',P.Name 'Product Name',p.BrandID 'Brand Id' from Phones p
	union
	Select n.Id 'ID',n.Name 'Product Name',n.BrandID 'Brand Id' from Notebooks n
	order by BrandID

--12) Phone ve Notebook da Id, Name, Price, ve Brandin Adini BrandName kimi Olan Butun Datalari Cixardan Query.
	
	Select p.Id,p.Name 'Product Name',b.Name 'BrandName',p.Price from Phones p
	join Brands b
	on p.BrandID=b.Id
	union
	Select n.Id, n.Name 'Product Name',b.Name 'BrandName',n.Price from Notebooks n
	join Brands b
	on n.BrandID=b.Id
	order by BrandName
	

--13) Phone ve Notebook da Id, Name, Price, ve Brandin Adini BrandName kimi Olan Butun Datalarin Icinden Price 1000-den Boyuk Olan Datalari Cixardan Query.
	Select tbl.Id,tbl.Name,tbl.Price,b.Name 'BrandName' From
	(
	    Select p.Id, p.Name, p.Price,p.BrandID from Phones p
		Union 
		Select n.Id,n.Name,n.Price,n.BrandID From Notebooks n
    )	as tbl
	join Brands b
	on tbl.BrandID=b.Id
	where tbl.Price>1000
	order by BrandID

--14) Phones Tabelenden Data Cixardacaqsiniz Amma Nece Olacaq 
	--Brandin Adi (BrandName kimi), Hemin Brandda Olan Telefonlarin Pricenin Cemi 
	--(TotalPrice Kimi) ve Hemin Branda Nece dene Telefon Varsa Sayini (ProductCount Kimi) 
	--Olan Datalari Cixardan Query.Misal
	--BrandName:        TotalPrice:        ProductCount:
	--Apple              6750                3
	--Samsung            3500                4
	--Redmi               800                1
	
	Select b.Name 'BrandName',Sum(p.Price) 'TotalPrice', Count(b.Name) 'ProductCount' from Brands b
	join Phones p
    on b.Id=p.BrandID
	Group by b.Name

--15) Notebooks Tabelenden Data Cixardacaqsiniz Amma Nece Olacaq Brandin Adi 
	--(BrandName kimi), Hemin Brandda Olan Notebookslarin Pricenin Cemi 
	--(TotalPrice Kimi) , Hemin Branda Nece dene Notebooks Varsa Sayini (ProductCount Kimi)
	--Olacaq ve Sayi 3-ve 3-den Cox Olan Datalari Cixardan Query.Misal
	--BrandName:        TotalPrice:        ProductCount:
	--Apple                6750                3
	--Samsung              3500                4
    
	Select b.Name 'BrandName',Sum(p.Price) 'TotalPrice', Count(b.Name) 'ProductCount' from Brands b
	inner join Notebooks p
    on b.Id=p.BrandID
	Group by b.Name
	Having COUNT(b.Name)>3