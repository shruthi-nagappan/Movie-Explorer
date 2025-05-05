-- Create Movies table (Shruthi)
CREATE TABLE Movies (
   MovieID VARCHAR(10) NOT NULL PRIMARY KEY,
   Title VARCHAR(100) NOT NULL,
   ReleaseDate DATE NOT NULL,
   Runtime INT CHECK (Runtime > 0),
   Budget DECIMAL(15,2) DEFAULT 0,
   Revenue DECIMAL(15,2) DEFAULT 0,
   Plot TEXT,
   PosterURL VARCHAR(255)
);
 
-- Create Persons table (Uthra)
CREATE TABLE Persons (
   PersonID VARCHAR(10) NOT NULL PRIMARY KEY,
   Name VARCHAR(100) NOT NULL,
   DateOfBirth DATE,
   Biography TEXT,
   Nationality VARCHAR(50),
   PhotoURL VARCHAR(255)
);
 
-- Create Genres table (Rishi)
CREATE TABLE Genres (
   GenreID VARCHAR(10) NOT NULL PRIMARY KEY,
   GenreName VARCHAR(30) NOT NULL UNIQUE
);
 
-- Create Studios table (Shruthi)
CREATE TABLE Studios (
   StudioID VARCHAR(10) NOT NULL PRIMARY KEY,
   StudioName VARCHAR(100) NOT NULL,
   FoundedYear INT,
   Headquarters VARCHAR(100)
);
 
-- Create Users table (Uthra)
CREATE TABLE Users (
   UserID VARCHAR(10) NOT NULL PRIMARY KEY,
   Username VARCHAR(50) NOT NULL UNIQUE,
   Email VARCHAR(100) NOT NULL UNIQUE,
   Password VARCHAR(255) NOT NULL,
   JoinDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
 
-- Create junction tables (Rishi)
CREATE TABLE Movie_Genres (
   MovieID VARCHAR(10) NOT NULL,
   GenreID VARCHAR(10) NOT NULL,
   PRIMARY KEY (MovieID, GenreID),
   FOREIGN KEY (MovieID) REFERENCES Movies(MovieID) ON DELETE CASCADE,
   FOREIGN KEY (GenreID) REFERENCES Genres(GenreID) ON DELETE CASCADE
);

-- Create movie_cast tables (Shruthi)
CREATE TABLE Movie_Cast (
   MovieID VARCHAR(10) NOT NULL,
   PersonID VARCHAR(10) NOT NULL,
   CharacterName VARCHAR(100) NOT NULL,
   PRIMARY KEY (MovieID, PersonID, CharacterName),
   FOREIGN KEY (MovieID) REFERENCES Movies(MovieID) ON DELETE CASCADE,
   FOREIGN KEY (PersonID) REFERENCES Persons(PersonID) ON DELETE CASCADE
);

-- Create movie_crew tables (Uthra)
CREATE TABLE Movie_Crew (
   MovieID VARCHAR(10) NOT NULL,
   PersonID VARCHAR(10) NOT NULL,
   Role VARCHAR(50) NOT NULL,
   PRIMARY KEY (MovieID, PersonID, Role),
   FOREIGN KEY (MovieID) REFERENCES Movies(MovieID) ON DELETE CASCADE,
   FOREIGN KEY (PersonID) REFERENCES Persons(PersonID) ON DELETE CASCADE
);

-- Create movie_studios tables (Rishi)
CREATE TABLE Movie_Studios (
   MovieID VARCHAR(10) NOT NULL,
   StudioID VARCHAR(10) NOT NULL,
   PRIMARY KEY (MovieID, StudioID),
   FOREIGN KEY (MovieID) REFERENCES Movies(MovieID) ON DELETE CASCADE,
   FOREIGN KEY (StudioID) REFERENCES Studios(StudioID) ON DELETE CASCADE
);
 
CREATE TABLE Ratings (
   RatingID VARCHAR(10) NOT NULL PRIMARY KEY,
   MovieID VARCHAR(10) NOT NULL,
   UserID VARCHAR(10) NOT NULL,
   Score DECIMAL(3,1) NOT NULL CHECK (Score BETWEEN 1 AND 10),
   Review TEXT,
   Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   FOREIGN KEY (MovieID) REFERENCES Movies(MovieID) ON DELETE CASCADE,
   FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
   UNIQUE (MovieID, UserID)
);

-- Create watchlists tables (Shruthi)
CREATE TABLE Watchlists (
   WatchlistID VARCHAR(10) NOT NULL PRIMARY KEY,
   UserID VARCHAR(10) NOT NULL,
   Name VARCHAR(50) NOT NULL,
   CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Create watchlist_movies tables (Uthra)
CREATE TABLE Watchlist_Movies (
   WatchlistID VARCHAR(10) NOT NULL,
   MovieID VARCHAR(10) NOT NULL,
   AddedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (WatchlistID, MovieID),
   FOREIGN KEY (WatchlistID) REFERENCES Watchlists(WatchlistID) ON DELETE CASCADE,
   FOREIGN KEY (MovieID) REFERENCES Movies(MovieID) ON DELETE CASCADE
);


-- Insert data into Movies table (Rishi)
INSERT INTO Movies VALUES
('M001', 'Inception', '2010-07-16', 148, 160000000, 836800000, 'A thief who steals corporate secrets through dream-sharing technology is given the task of planting an idea into the mind of a C.E.O.', '/posters/inception.jpg'),
('M002', 'The Dark Knight', '2008-07-18', 152, 185000000, 1006000000, 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.', '/posters/dark_knight.jpg'),
('M003', 'Forrest Gump', '1994-07-06', 142, 55000000, 678200000, 'The presidencies of Kennedy and Johnson, the Vietnam War, the Watergate scandal and other historical events unfold from the perspective of an Alabama man with an IQ of 75.', '/posters/forrest_gump.jpg'),
('M004', 'The Godfather', '1972-03-24', 175, 6000000, 245066411, 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.', '/posters/godfather.jpg'),
('M005', 'Pulp Fiction', '1994-10-14', 154, 8000000, 213928762, 'The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.', '/posters/pulp_fiction.jpg'),
('M006', 'The Shawshank Redemption', '1994-09-23', 142, 25000000, 28341469, 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.', '/posters/shawshank.jpg'),
('M007', 'The Matrix', '1999-03-31', 136, 63000000, 465300000, 'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.', '/posters/matrix.jpg'),
('M008', 'Goodfellas', '1990-09-19', 146, 25000000, 46836394, 'The story of Henry Hill and his life in the mob, covering his relationship with his wife Karen Hill and his mob partners Jimmy Conway and Tommy DeVito.', '/posters/goodfellas.jpg'),
('M009', 'Fight Club', '1999-10-15', 139, 63000000, 101200000, 'An insomniac office worker and a devil-may-care soapmaker form an underground fight club that evolves into something much, much more.', '/posters/fight_club.jpg'),
('M010', 'The Lord of the Rings: The Fellowship of the Ring', '2001-12-19', 178, 93000000, 871530324, 'A meek Hobbit from the Shire and eight companions set out on a journey to destroy the powerful One Ring and save Middle-earth from the Dark Lord Sauron.', '/posters/lotr_fellowship.jpg'),
('M011', 'Interstellar', '2014-11-07', 169, 165000000, 677463813, 'A team of explorers travel through a wormhole in space in an attempt to ensure humanitys survival.', '/posters/interstellar.jpg'),
('M012', 'The Silence of the Lambs', '1991-02-14', 118, 19000000, 272742922, 'A young F.B.I. cadet must receive the help of an incarcerated and manipulative cannibal killer to help catch another serial killer.', '/posters/silence_lambs.jpg'),
('M013', 'Schindlers List', '1993-12-15', 195, 22000000, 322100000, 'In German-occupied Poland during World War II, industrialist Oskar Schindler gradually becomes concerned for his Jewish workforce after witnessing their persecution by the Nazis.', '/posters/schindlers_list.jpg'),
('M014', 'Titanic', '1997-12-19', 194, 200000000, 2187463944, 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.', '/posters/titanic.jpg'),
('M015', 'The Departed', '2006-10-06', 151, 90000000, 291465373, 'An undercover cop and a mole in the police attempt to identify each other while infiltrating an Irish gang in South Boston.', '/posters/departed.jpg'),
('M016', 'Gladiator', '2000-05-05', 155, 103000000, 457640427, 'A former Roman General sets out to exact vengeance against the corrupt emperor who murdered his family and sent him into slavery.', '/posters/gladiator.jpg'),
('M017', 'The Green Mile', '1999-12-10', 189, 60000000, 286801374, 'The lives of guards on Death Row are affected by one of their charges: a black man accused of child murder and rape, yet who has a mysterious gift.', '/posters/green_mile.jpg'),
('M018', 'Saving Private Ryan', '1998-07-24', 169, 70000000, 481840909, 'Following the Normandy Landings, a group of U.S. soldiers go behind enemy lines to retrieve a paratrooper whose brothers have been killed in action.', '/posters/saving_private_ryan.jpg'),
('M019', 'Jurassic Park', '1993-06-11', 127, 63000000, 1029939903, 'A pragmatic paleontologist visiting an almost complete theme park is tasked with protecting a couple of kids after a power failure causes the parks cloned dinosaurs to run loose.', '/posters/jurassic_park.jpg'),
('M020', 'The Lion King', '1994-06-24', 88, 45000000, 968483777, 'Lion prince Simba and his father are targeted by his bitter uncle, who wants to ascend the throne himself.', '/posters/lion_king.jpg'),
('M021', 'Avatar', '2009-12-18', 162, 237000000, 2847246203, 'A paraplegic Marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.', '/posters/avatar.jpg'),
('M022', 'The Avengers', '2012-05-04', 143, 220000000, 1518812988, 'Earths mightiest heroes must come together and learn to fight as a team if they are going to stop the mischievous Loki and his alien army from enslaving humanity.', '/posters/avengers.jpg'),
('M023', 'The Dark Knight Rises', '2012-07-20', 165, 250000000, 1081041287, 'Eight years after the Jokers reign of anarchy, Batman, with the help of the enigmatic Catwoman, is forced from his exile to save Gotham City from the brutal guerrilla terrorist Bane.', '/posters/dark_knight_rises.jpg'),
('M024', 'The Godfather: Part II', '1974-12-20', 202, 13000000, 57300000, 'The early life and career of Vito Corleone in 1920s New York City is portrayed, while his son, Michael, expands and tightens his grip on the family crime syndicate.', '/posters/godfather2.jpg'),
('M025', 'The Shining', '1980-05-23', 146, 19000000, 46200000, 'A family heads to an isolated hotel for the winter where a sinister presence influences the father into violence, while his psychic son sees horrific forebodings from both past and future.', '/posters/shining.jpg'),
('M026', 'Alien', '1979-05-25', 117, 11000000, 104931801, 'After a space merchant vessel receives an unknown transmission as a distress call, one of the crew is attacked by a mysterious life form and they soon realize that its life cycle has merely begun.', '/posters/alien.jpg'),
('M027', 'Back to the Future', '1985-07-03', 116, 19000000, 388800000, 'Marty McFly, a 17-year-old high school student, is accidentally sent thirty years into the past in a time-traveling DeLorean invented by his close friend, the eccentric scientist Doc Brown.', '/posters/back_to_future.jpg'),
('M028', 'Raiders of the Lost Ark', '1981-06-12', 115, 18000000, 389925971, 'In 1936, archaeologist and adventurer Indiana Jones is hired by the U.S. government to find the Ark of the Covenant before Adolf Hitlers Nazis can obtain its awesome powers.', '/posters/raiders.jpg'),
('M029', 'The Terminator', '1984-10-26', 107, 6400000, 78371200, 'A human soldier is sent from 2029 to 1984 to stop an almost indestructible cyborg killing machine, sent from the same year, which has been programmed to execute a young woman whose unborn son is the key to humanitys future salvation.', '/posters/terminator.jpg'),
('M030', 'Die Hard', '1988-07-15', 132, 28000000, 141500000, 'An NYPD officer tries to save his wife and several others taken hostage by German terrorists during a Christmas party at the Nakatomi Plaza in Los Angeles.', '/posters/die_hard.jpg'),
('M031', 'Jaws', '1975-06-20', 124, 7000000, 471200000, 'When a killer shark unleashes chaos on a beach community, its up to a local sheriff, a marine biologist, and an old seafarer to hunt the beast down.', '/posters/jaws.jpg'),
('M032', 'Star Wars: Episode IV - A New Hope', '1977-05-25', 121, 11000000, 775398007, 'Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a Wookiee and two droids to save the galaxy from the Empires world-destroying battle station, while also attempting to rescue Princess Leia from the mysterious Darth Vader.', '/posters/star_wars.jpg'),
('M033', 'E.T. the Extra-Terrestrial', '1982-06-11', 115, 10500000, 792910554, 'A troubled child summons the courage to help a friendly alien escape Earth and return to his home world.', '/posters/et.jpg'),
('M034', 'Casablanca', '1942-11-26', 102, 878000, 3700000, 'A cynical American expatriate struggles to decide whether or not he should help his former lover and her fugitive husband escape French Morocco.', '/posters/casablanca.jpg'),
('M035', 'Psycho', '1960-06-16', 109, 806947, 50000000, 'A Phoenix secretary embezzles forty thousand dollars from her employers client, goes on the run, and checks into a remote motel run by a young man under the domination of his mother.', '/posters/psycho.jpg'),
('M036', 'Gone with the Wind', '1939-12-15', 238, 3900000, 390525192, 'A manipulative woman and a roguish man conduct a turbulent romance during the American Civil War and Reconstruction periods.', '/posters/gone_with_wind.jpg'),
('M037', 'Citizen Kane', '1941-05-01', 119, 839727, 1594107, 'Following the death of publishing tycoon Charles Foster Kane, reporters scramble to uncover the meaning of his final utterance.', '/posters/citizen_kane.jpg'),
('M038', 'The Wizard of Oz', '1939-08-25', 102, 2777000, 33753925, 'Dorothy Gale is swept away from a farm in Kansas to a magical land of Oz in a tornado and embarks on a quest with her new friends to see the Wizard who can help her return home to Kansas and help her friends as well.', '/posters/wizard_of_oz.jpg'),
('M039', '2001: A Space Odyssey', '1968-04-03', 149, 10500000, 146000000, 'After discovering a mysterious artifact buried beneath the Lunar surface, mankind sets off on a quest to find its origins with help from intelligent supercomputer H.A.L. 9000.', '/posters/2001.jpg'),
('M040', 'Blade Runner', '1982-06-25', 117, 28000000, 41600000, 'A blade runner must pursue and terminate four replicants who stole a ship in space and have returned to Earth to find their creator.', '/posters/blade_runner.jpg'),
('M041', 'The Exorcist', '1973-12-26', 122, 12000000, 441071011, 'When a 12-year-old girl is possessed by a mysterious entity, her mother seeks the help of two priests to save her.', '/posters/exorcist.jpg'),
('M042', 'One Flew Over the Cuckoos Nest', '1975-11-19', 133, 3000000, 163250000, 'A criminal pleads insanity and is admitted to a mental institution, where he rebels against the oppressive nurse and rallies up the scared patients.', '/posters/cuckoos_nest.jpg'),
('M043', 'Apocalypse Now', '1979-08-15', 147, 31500000, 83471511, 'A U.S. Army officer serving in Vietnam is tasked with assassinating a renegade Special Forces Colonel who sees himself as a god.', '/posters/apocalypse_now.jpg'),
('M044', 'Lawrence of Arabia', '1962-12-11', 228, 15000000, 70000000, 'The story of T.E. Lawrence, the English officer who successfully united and led the diverse, often warring, Arab tribes during World War I in order to fight the Turks.', '/posters/lawrence_arabia.jpg'),
('M045', 'Vertigo', '1958-05-28', 128, 2479000, 7300000, 'A former police detective juggles wrestling with his personal demons and becoming obsessed with a hauntingly beautiful woman.', '/posters/vertigo.jpg'),
('M046', 'Taxi Driver', '1976-02-08', 114, 1300000, 28262574, 'A mentally unstable veteran works as a nighttime taxi driver in New York City, where the perceived decadence and sleaze fuels his urge for violent action.', '/posters/taxi_driver.jpg');
 
-- Insert data into Persons table (Rishi)
INSERT INTO Persons (PersonID, Name, DateOfBirth, Biography, Nationality, PhotoURL) VALUES
('P001', 'Christopher Nolan', '1970-07-30', 'British-American filmmaker known for cerebral, often nonlinear storytelling. Began making short films at age 7 with his father''s Super-8 camera.', 'British-American', '/photos/nolan.jpg'),
('P002', 'Leonardo DiCaprio', '1974-11-11', 'American actor known for intense dramatic performances and environmental activism. Began as a child actor and rose to international fame with Titanic.', 'American', '/photos/dicaprio.jpg'),
('P003', 'Tom Hanks', '1956-07-09', 'American actor and filmmaker known for both comedic and dramatic roles. Considered an American cultural icon.', 'American', '/photos/hanks.jpg'),
('P004', 'Steven Spielberg', '1946-12-18', 'One of the most influential personalities in cinema history. Launched the summer blockbuster with Jaws and has defined popular filmmaking since the mid-1970s.', 'American', '/photos/spielberg.jpg'),
('P005', 'Martin Scorsese', '1942-11-17', 'American film director, producer, screenwriter, and actor. One of the major figures of the New Hollywood era.', 'American', '/photos/scorsese.jpg'),
('P006', 'Meryl Streep', '1949-06-22', 'American actress often described as the "best actress of her generation". Known for her versatility and accent adaptation.', 'American', '/photos/streep.jpg'),
('P007', 'Robert De Niro', '1943-08-17', 'American actor, producer, and director. Known for his collaborations with Martin Scorsese and his method acting approach.', 'American', '/photos/deniro.jpg'),
('P008', 'Brad Pitt', '1963-12-18', 'American actor and film producer. Recipient of multiple accolades, including Academy Awards for acting and producing.', 'American', '/photos/pitt.jpg'),
('P009', 'Quentin Tarantino', '1963-03-27', 'American filmmaker and actor known for nonlinear storylines, aestheticization of violence, and references to pop culture.', 'American', '/photos/tarantino.jpg'),
('P010', 'Kate Winslet', '1975-10-05', 'English actress known for her work in independent films, particularly period dramas, and for portraying headstrong and complicated women.', 'British', '/photos/winslet.jpg'),
('P011', 'Denzel Washington', '1954-12-28', 'American actor, director, and producer. Known for his intense performances and commanding screen presence.', 'American', '/photos/washington.jpg'),
('P012', 'Cate Blanchett', '1969-05-14', 'Australian actress known for her versatility and roles in blockbusters and independent films alike.', 'Australian', '/photos/blanchett.jpg'),
('P013', 'Tom Cruise', '1962-07-03', 'American actor and producer. One of the world''s highest-paid actors, known for action roles and performing his own stunts.', 'American', '/photos/cruise.jpg'),
('P014', 'Francis Ford Coppola', '1939-04-07', 'American film director, producer, and screenwriter. A central figure of the New Hollywood filmmaking movement.', 'American', '/photos/coppola.jpg'),
('P015', 'Al Pacino', '1940-04-25', 'American actor and filmmaker. Considered one of the most influential actors of the 20th century.', 'American', '/photos/pacino.jpg'),
('P016', 'Scarlett Johansson', '1984-11-22', 'American actress and singer. The world''s highest-paid actress in 2018 and 2019, has appeared multiple times on the Forbes Celebrity 100 list.', 'American', '/photos/johansson.jpg'),
('P017', 'Jennifer Lawrence', '1990-08-15', 'American actress. The world''s highest-paid actress in 2015 and 2016, her films have grossed over $6 billion worldwide.', 'American', '/photos/lawrence.jpg'),
('P018', 'Robert Downey Jr.', '1965-04-04', 'American actor and producer. Known for his role as Iron Man in the Marvel Cinematic Universe.', 'American', '/photos/downey.jpg'),
('P019', 'Matt Damon', '1970-10-08', 'American actor, film producer, and screenwriter. Ranked among Forbes'' most bankable stars.', 'American', '/photos/damon.jpg'),
('P020', 'Christian Bale', '1974-01-30', 'English actor known for his intense method acting style and physical transformations for roles.', 'British', '/photos/bale.jpg'),
('P021', 'Joaquin Phoenix', '1974-10-28', 'American actor, producer, and animal rights activist. Known for playing dark and unconventional characters.', 'American', '/photos/phoenix.jpg'),
('P022', 'Emma Stone', '1988-11-06', 'American actress. Recipient of various accolades, including an Academy Award and a Golden Globe Award.', 'American', '/photos/stone.jpg'),
('P023', 'Viola Davis', '1965-08-11', 'American actress and producer. The first African-American actress to achieve the "Triple Crown of Acting".', 'American', '/photos/davis.jpg'),
('P024', 'Samuel L. Jackson', '1948-12-21', 'American actor and producer. One of the most widely recognized actors of his generation.', 'American', '/photos/jackson.jpg'),
('P025', 'Natalie Portman', '1981-06-09', 'Israeli-American actress, director, and producer. Known for her roles in both blockbusters and independent films.', 'Israeli-American', '/photos/portman.jpg'),
('P026', 'Jack Nicholson', '1937-04-22', 'American actor and filmmaker. One of the most celebrated actors of his generation.', 'American', '/photos/nicholson.jpg'),
('P027', 'Anthony Hopkins', '1937-12-31', 'Welsh actor, director, and producer. Known for his intense performances and versatility.', 'British', '/photos/hopkins.jpg'),
('P028', 'Daniel Day-Lewis', '1957-04-29', 'Retired English actor. Known for his method acting and selectiveness of roles.', 'British', '/photos/day-lewis.jpg'),
('P029', 'Judi Dench', '1934-12-09', 'English actress. One of Britain''s most significant theatre performers.', 'British', '/photos/dench.jpg'),
('P030', 'Morgan Freeman', '1937-06-01', 'American actor, director, and narrator. Known for his distinctive deep voice and calm demeanor.', 'American', '/photos/freeman.jpg'),
('P031', 'Charlize Theron', '1975-08-07', 'South African and American actress and producer. One of the world''s highest-paid actresses.', 'South African-American', '/photos/theron.jpg'),
('P032', 'Gary Oldman', '1958-03-21', 'English actor and filmmaker. Known for his versatility and intense acting style.', 'British', '/photos/oldman.jpg'),
('P033', 'Julia Roberts', '1967-10-28', 'American actress. One of Hollywood''s most bankable stars.', 'American', '/photos/roberts.jpg'),
('P034', 'Tom Hardy', '1977-09-15', 'English actor, producer, and former model. Known for his transformative performances.', 'British', '/photos/hardy.jpg'),
('P035', 'Angelina Jolie', '1975-06-04', 'American actress, filmmaker, and humanitarian. Recipient of numerous accolades.', 'American', '/photos/jolie.jpg'),
('P036', 'Russell Crowe', '1964-04-07', 'New Zealand actor, film producer, and musician. Known for his commanding screen presence.', 'New Zealand', '/photos/crowe.jpg'),
('P037', 'Nicole Kidman', '1967-06-20', 'American-Australian actress and producer. Known for her versatility and dedication to her craft.', 'Australian-American', '/photos/kidman.jpg'),
('P038', 'Hugh Jackman', '1968-10-12', 'Australian actor. Known for playing Wolverine in the X-Men film series.', 'Australian', '/photos/jackman.jpg'),
('P039', 'Jake Gyllenhaal', '1980-12-19', 'American actor. Born into the Gyllenhaal family, he is the son of director Stephen Gyllenhaal.', 'American', '/photos/gyllenhaal.jpg'),
('P040', 'Amy Adams', '1974-08-20', 'American actress. Known for both comedic and dramatic roles.', 'American', '/photos/adams.jpg'),
('P041', 'Keanu Reeves', '1964-09-02', 'Canadian actor. Known for his roles in The Matrix and John Wick franchises.', 'Canadian', '/photos/reeves.jpg'),
('P042', 'Saoirse Ronan', '1994-04-12', 'Irish and American actress. Known for her roles in period dramas since adolescence.', 'Irish-American', '/photos/ronan.jpg'),
('P043', 'Timothée Chalamet', '1995-12-27', 'American actor. Known for his leading roles in independent films and blockbusters.', 'American', '/photos/chalamet.jpg'),
('P044', 'Florence Pugh', '1996-01-03', 'English actress. Known for her performances in independent films and blockbusters.', 'British', '/photos/pugh.jpg'),
('P045', 'Margot Robbie', '1990-07-02', 'Australian actress and producer. Known for her roles in both blockbusters and independent films.', 'Australian', '/photos/robbie.jpg'),
('P046', 'Robert Pattinson', '1986-05-13', 'English actor. Known for his versatile roles in both big-budget and independent films.', 'British', '/photos/pattinson.jpg'),
('P047', 'Zendaya', '1996-09-01', 'American actress and singer. Recipient of numerous accolades, including a Primetime Emmy Award.', 'American', '/photos/zendaya.jpg'),
('P048', 'Ryan Gosling', '1980-11-12', 'Canadian actor. Known for his roles in independent films and blockbusters.', 'Canadian', '/photos/gosling.jpg'),
('P049', 'Brie Larson', '1989-10-01', 'American actress and filmmaker. Known for her supporting work in comedies as a teenager.', 'American', '/photos/larson.jpg'),
('P050', 'John David Washington', '1984-07-28', 'American actor and former football running back. Son of actor Denzel Washington.', 'American', '/photos/washington_jd.jpg'),
('P051', 'Austin Butler', '1991-08-17', 'American actor. Known for his role as Elvis Presley in the biographical film Elvis.', 'American', '/photos/butler.jpg'),
('P052', 'Sebastian Stan', '1982-08-13', 'Romanian-American actor. Known for his role as Bucky Barnes / Winter Soldier in the Marvel Cinematic Universe.', 'Romanian-American', '/photos/stan.jpg'),
('P053', 'Zac Efron', '1987-10-18', 'American actor. Began acting professionally in the early 2000s and rose to prominence with High School Musical.', 'American', '/photos/efron.jpg'),
('P054', 'Stephanie Koenig', '1990-05-15', 'American actress known for her roles in television and film.', 'American', '/photos/koenig.jpg'),
('P055', 'Phoebe Dynevor', '1995-04-17', 'English actress. Known for her role in the Netflix series Bridgerton.', 'British', '/photos/dynevor.jpg'),
('P056', 'Bill Pullman', '1953-12-17', 'American actor. Known for his roles in While You Were Sleeping, Independence Day, and Lost Highway.', 'American', '/photos/pullman.jpg'),
('P057', 'Gwyneth Paltrow', '1972-09-27', 'American actress and businesswoman. Known for her roles in Seven, Shakespeare in Love, and as Pepper Potts in the Marvel Cinematic Universe.', 'American', '/photos/paltrow.jpg'),
('P058', 'Cameron Diaz', '1972-08-30', 'American former actress and model. One of the highest-grossing actresses of all time.', 'American', '/photos/diaz.jpg'),
('P059', 'Jody Hill', '1976-10-15', 'American director, screenwriter, producer, and actor. Known for creating the HBO series Eastbound & Down.', 'American', '/photos/hill.jpg'),
('P060', 'George Clooney', '1961-05-06', 'American actor and filmmaker. Recipient of numerous accolades, including an Academy Award and three Golden Globe Awards.', 'American', '/photos/clooney.jpg');
 
-- Insert data into Genres table (Rishi)
INSERT INTO Genres (GenreID, GenreName) VALUES
('G001', 'Action'),
('G002', 'Adventure'),
('G003', 'Comedy'),
('G004', 'Crime'),
('G005', 'Drama'),
('G006', 'Fantasy'),
('G007', 'Historical'),
('G008', 'Horror'),
('G009', 'Mystery'),
('G010', 'Romance'),
('G011', 'Science Fiction'),
('G012', 'Thriller'),
('G013', 'Western'),
('G014', 'Animation'),
('G015', 'Musical'),
('G016', 'Documentary'),
('G017', 'War'),
('G018', 'Biographical'),
('G019', 'Family'),
('G020', 'Sport'),
('G021', 'Superhero'),
('G022', 'Film Noir'),
('G023', 'Gangster'),
('G024', 'Heist'),
('G025', 'Spy'),
('G026', 'Martial Arts'),
('G027', 'Disaster'),
('G028', 'Psychological'),
('G029', 'Supernatural'),
('G030', 'Found Footage'),
('G031', 'Slasher'),
('G032', 'Gothic'),
('G033', 'Folk Horror'),
('G034', 'Body Horror'),
('G035', 'Space Opera'),
('G036', 'Cyberpunk'),
('G037', 'Post-Apocalyptic'),
('G038', 'Time Travel'),
('G039', 'Biopunk'),
('G040', 'Hard Science Fiction'),
('G041', 'Alternate History'),
('G042', 'High Fantasy'),
('G043', 'Urban Fantasy'),
('G044', 'Dark Fantasy'),
('G045', 'Sword and Sorcery'),
('G046', 'Contemporary Fantasy'),
('G047', 'Mythological Fantasy'),
('G048', 'Classical Western'),
('G049', 'Spaghetti Western'),
('G050', 'Contemporary Western'),
('G051', 'Revisionist Western'),
('G052', 'Classic Noir'),
('G053', 'Neo-Noir'),
('G054', 'Tech-Noir'),
('G055', 'Psychological Thriller'),
('G056', 'Crime Thriller'),
('G057', 'Political Thriller'),
('G058', 'Erotic Thriller'),
('G059', 'Medical Thriller'),
('G060', 'Police Procedural'),
('G061', 'Prison Film'),
('G062', 'Anti-War'),
('G063', 'Combat Film'),
('G064', 'Resistance Film'),
('G065', 'Home Front');

-- Insert data into Studios table (Rishi)
INSERT INTO Studios (StudioID, StudioName, FoundedYear, Headquarters) VALUES
('S001', 'Warner Bros.', 1923, 'Burbank, California'),
('S002', 'Universal Pictures', 1912, 'Universal City, California'),
('S003', 'Paramount Pictures', 1912, 'Hollywood, California'),
('S004', 'Walt Disney Pictures', 1923, 'Burbank, California'),
('S005', 'Columbia Pictures', 1924, 'Culver City, California'),
('S006', '20th Century Studios', 1935, 'Los Angeles, California'),
('S007', 'Metro-Goldwyn-Mayer', 1924, 'Beverly Hills, California'),
('S008', 'Lionsgate Films', 1997, 'Santa Monica, California'),
('S009', 'New Line Cinema', 1967, 'Burbank, California'),
('S010', 'DreamWorks Pictures', 1994, 'Universal City, California'),
('S011', 'Focus Features', 2002, 'Universal City, California'),
('S012', 'Sony Pictures Classics', 1992, 'Culver City, California'),
('S013', 'A24', 2012, 'New York City, New York'),
('S014', 'Miramax', 1979, 'Los Angeles, California'),
('S015', 'Pixar Animation Studios', 1986, 'Emeryville, California'),
('S016', 'Marvel Studios', 1993, 'Burbank, California'),
('S017', 'Lucasfilm', 1971, 'San Francisco, California'),
('S018', 'Amazon MGM Studios', 2022, 'Culver City, California'),
('S019', 'STX Entertainment', 2014, 'Burbank, California'),
('S020', 'Amblin Entertainment', 1981, 'Universal City, California'),
('S021', 'Blumhouse Productions', 2000, 'Los Angeles, California'),
('S022', 'Legendary Pictures', 2000, 'Burbank, California'),
('S023', 'Village Roadshow Pictures', 1986, 'Melbourne, Australia'),
('S024', 'Castle Rock Entertainment', 1987, 'Beverly Hills, California'),
('S025', 'Regency Enterprises', 1982, 'Los Angeles, California'),
('S026', 'Working Title Films', 1983, 'London, United Kingdom'),
('S027', 'Participant', 2004, 'Los Angeles, California'),
('S028', 'Plan B Entertainment', 2001, 'Los Angeles, California'),
('S029', 'Bad Robot Productions', 2001, 'Santa Monica, California'),
('S030', 'Annapurna Pictures', 2011, 'Los Angeles, California'),
('S031', 'Studio Ghibli', 1985, 'Koganei, Tokyo, Japan'),
('S032', 'BBC Films', 1990, 'London, United Kingdom'),
('S033', 'StudioCanal', 1988, 'Paris, France'),
('S034', 'Gaumont Film Company', 1895, 'Neuilly-sur-Seine');

-- Insert data into Movie_Genres table (Shruthi)
INSERT INTO Movie_Genres (MovieID, GenreID) VALUES
-- Inception: Sci-Fi, Thriller, Action
('M001', 'G011'),
('M001', 'G012'),
('M001', 'G001'),
-- The Dark Knight: Action, Crime, Drama
('M002', 'G001'),
('M002', 'G004'),
('M002', 'G005'),
-- Forrest Gump: Drama, Romance, Comedy
('M003', 'G005'),
('M003', 'G010'),
('M003', 'G003'),
-- The Godfather: Crime, Drama
('M004', 'G004'),
('M004', 'G005'),
-- Pulp Fiction: Crime, Drama, Thriller
('M005', 'G004'),
('M005', 'G005'),
('M005', 'G012'),
-- The Shawshank Redemption: Drama, Prison Film
('M006', 'G005'),
('M006', 'G061'),
-- The Matrix: Sci-Fi, Action
('M007', 'G011'),
('M007', 'G001'),
-- Goodfellas: Crime, Drama, Gangster
('M008', 'G004'),
('M008', 'G005'),
('M008', 'G023'),
-- Fight Club: Drama, Thriller
('M009', 'G005'),
('M009', 'G012'),
-- The Lord of the Rings: Fantasy, Adventure
('M010', 'G006'),
('M010', 'G002'),
-- Interstellar: Sci-Fi, Drama, Adventure
('M011', 'G011'),
('M011', 'G005'),
('M011', 'G002'),
-- The Silence of the Lambs: Thriller, Crime, Horror
('M012', 'G012'),
('M012', 'G004'),
('M012', 'G008'),
-- Schindler's List: Drama, History, War
('M013', 'G005'),
('M013', 'G007'),
('M013', 'G017'),
-- Titanic: Romance, Drama, Disaster
('M014', 'G010'),
('M014', 'G005'),
('M014', 'G027'),
-- The Departed: Crime, Drama, Thriller
('M015', 'G004'),
('M015', 'G005'),
('M015', 'G012'),
-- Gladiator: Action, Drama, Adventure
('M016', 'G001'),
('M016', 'G005'),
('M016', 'G002'),
-- The Green Mile: Drama, Fantasy, Prison Film
('M017', 'G005'),
('M017', 'G006'),
('M017', 'G061'),
-- Saving Private Ryan: War, Drama, Action
('M018', 'G017'),
('M018', 'G005'),
('M018', 'G001'),
-- Jurassic Park: Adventure, Sci-Fi
('M019', 'G002'),
('M019', 'G011'),
-- The Lion King: Animation, Drama, Family
('M020', 'G014'),
('M020', 'G005'),
('M020', 'G019'),
-- Avatar: Sci-Fi, Action, Adventure
('M021', 'G011'),
('M021', 'G001'),
('M021', 'G002'),
-- The Avengers: Action, Superhero, Sci-Fi
('M022', 'G001'),
('M022', 'G021'),
('M022', 'G011'),
-- The Dark Knight Rises: Action, Crime, Drama
('M023', 'G001'),
('M023', 'G004'),
('M023', 'G005'),
-- The Godfather: Part II: Crime, Drama
('M024', 'G004'),
('M024', 'G005');

-- Insert data into Movie_Cast table (Shruthi)
INSERT INTO Movie_Cast (MovieID, PersonID, CharacterName) VALUES
-- Inception
('M001', 'P002', 'Dom Cobb'),
('M001', 'P020', 'Arthur'),
('M001', 'P034', 'Eames'),
-- The Dark Knight
('M002', 'P020', 'Bruce Wayne/Batman'),
('M002', 'P026', 'The Joker'),
('M002', 'P032', 'Jim Gordon'),
-- Forrest Gump
('M003', 'P003', 'Forrest Gump'),
('M003', 'P057', 'Jenny Curran'),
('M003', 'P032', 'Lieutenant Dan Taylor'),
-- The Godfather
('M004', 'P015', 'Michael Corleone'),
('M004', 'P007', 'Vito Corleone'),
('M004', 'P026', 'Sonny Corleone'),
-- Pulp Fiction
('M005', 'P008', 'Vincent Vega'),
('M005', 'P024', 'Jules Winnfield'),
('M005', 'P033', 'Mia Wallace'),
-- The Shawshank Redemption
('M006', 'P030', 'Ellis Boyd "Red" Redding'),
('M006', 'P003', 'Andy Dufresne'),
-- The Matrix
('M007', 'P041', 'Neo'),
('M007', 'P030', 'Morpheus'),
('M007', 'P058', 'Trinity'),
-- Goodfellas
('M008', 'P007', 'Jimmy Conway'),
('M008', 'P015', 'Tommy DeVito'),
('M008', 'P032', 'Henry Hill'),
-- Fight Club
('M009', 'P008', 'Tyler Durden'),
('M009', 'P039', 'The Narrator'),
('M009', 'P031', 'Marla Singer'),
-- The Lord of the Rings
('M010', 'P038', 'Frodo Baggins'),
('M010', 'P027', 'Gandalf'),
('M010', 'P034', 'Aragorn'),
-- Interstellar
('M011', 'P002', 'Cooper'),
('M011', 'P040', 'Dr. Amelia Brand'),
('M011', 'P027', 'Professor Brand'),
-- The Silence of the Lambs
('M012', 'P027', 'Hannibal Lecter'),
('M012', 'P025', 'Clarice Starling'),
-- Schindler's List
('M013', 'P002', 'Oskar Schindler'),
('M013', 'P032', 'Amon Göth'),
-- Titanic
('M014', 'P002', 'Jack Dawson'),
('M014', 'P010', 'Rose DeWitt Bukater'),
-- The Departed
('M015', 'P002', 'Billy Costigan'),
('M015', 'P026', 'Frank Costello'),
('M015', 'P019', 'Colin Sullivan'),
-- Gladiator
('M016', 'P036', 'Maximus'),
('M016', 'P027', 'Marcus Aurelius'),
('M016', 'P035', 'Commodus'),
-- The Green Mile
('M017', 'P003', 'Paul Edgecomb'),
('M017', 'P024', 'John Coffey'),
-- Saving Private Ryan
('M018', 'P003', 'Captain Miller'),
('M018', 'P019', 'Private Ryan'),
-- Jurassic Park
('M019', 'P024', 'Dr. Alan Grant'),
('M019', 'P033', 'Dr. Ellie Sattler'),
-- The Lion King
('M020', 'P024', 'Mufasa (voice)'),
('M020', 'P030', 'Simba (voice)'),
-- Avatar
('M021', 'P041', 'Jake Sully'),
('M021', 'P045', 'Neytiri'),
-- The Avengers
('M022', 'P018', 'Tony Stark/Iron Man'),
('M022', 'P016', 'Natasha Romanoff/Black Widow'),
('M022', 'P024', 'Nick Fury');
 
-- Insert data into Movie_crew table (Uthra)
INSERT INTO Movie_Crew (MovieID, PersonID, Role) VALUES
-- Inception
('M001', 'P001', 'Director'),
('M001', 'P001', 'Writer'),
('M001', 'P001', 'Producer'),
-- The Dark Knight
('M002', 'P001', 'Director'),
('M002', 'P001', 'Writer'),
('M002', 'P001', 'Producer'),
-- Forrest Gump
('M003', 'P004', 'Director'),
('M003', 'P060', 'Producer'),
-- The Godfather
('M004', 'P014', 'Director'),
('M004', 'P014', 'Writer'),
-- Pulp Fiction
('M005', 'P009', 'Director'),
('M005', 'P009', 'Writer'),
-- The Shawshank Redemption
('M006', 'P004', 'Director'),
('M006', 'P004', 'Writer'),
-- The Matrix
('M007', 'P001', 'Director'),
('M007', 'P001', 'Writer'),
-- Goodfellas
('M008', 'P005', 'Director'),
('M008', 'P005', 'Writer'),
-- Fight Club
('M009', 'P004', 'Director'),
-- The Lord of the Rings
('M010', 'P004', 'Director'),
('M010', 'P004', 'Writer'),
('M010', 'P004', 'Producer'),
-- Interstellar
('M011', 'P001', 'Director'),
('M011', 'P001', 'Writer'),
('M011', 'P001', 'Producer'),
-- The Silence of the Lambs
('M012', 'P005', 'Director'),
-- Schindler's List
('M013', 'P004', 'Director'),
('M013', 'P004', 'Producer'),
-- Titanic
('M014', 'P004', 'Director'),
('M014', 'P004', 'Writer'),
('M014', 'P004', 'Producer'),
-- The Departed
('M015', 'P005', 'Director'),
('M015', 'P005', 'Producer'),
-- Gladiator
('M016', 'P004', 'Director'),
-- The Green Mile
('M017', 'P004', 'Director'),
('M017', 'P004', 'Writer'),
-- Saving Private Ryan
('M018', 'P004', 'Director'),
('M018', 'P004', 'Producer'),
-- Jurassic Park
('M019', 'P004', 'Director'),
('M019', 'P004', 'Producer'),
-- The Lion King
('M020', 'P004', 'Producer'),
-- Avatar
('M021', 'P004', 'Director'),
('M021', 'P004', 'Writer'),
('M021', 'P004', 'Producer'),
-- The Avengers
('M022', 'P004', 'Director'),
('M022', 'P004', 'Writer'),
-- The Dark Knight Rises
('M023', 'P001', 'Director'),
('M023', 'P001', 'Writer'),
('M023', 'P001', 'Producer'),
-- The Godfather: Part II
('M024', 'P014', 'Director'),
('M024', 'P014', 'Writer'),
-- The Shining
('M025', 'P004', 'Director'),
('M025', 'P004', 'Writer'),
-- Alien
('M026', 'P004', 'Director'),
-- Back to the Future
('M027', 'P004', 'Director'),
('M027', 'P004', 'Writer'),
-- Raiders of the Lost Ark
('M028', 'P004', 'Director'),
('M028', 'P004', 'Writer'),
-- The Terminator
('M029', 'P004', 'Director'),
('M029', 'P004', 'Writer');
 

-- Insert data into Movie_studios table (Shruthi)
INSERT INTO Movie_Studios (MovieID, StudioID) VALUES
('M001', 'S001'), -- Inception - Warner Bros.
('M002', 'S001'), -- The Dark Knight - Warner Bros.
('M003', 'S003'), -- Forrest Gump - Paramount Pictures
('M004', 'S003'), -- The Godfather - Paramount Pictures
('M005', 'S014'), -- Pulp Fiction - Miramax
('M006', 'S001'), -- The Shawshank Redemption - Warner Bros.
('M007', 'S001'), -- The Matrix - Warner Bros.
('M008', 'S001'), -- Goodfellas - Warner Bros.
('M009', 'S006'), -- Fight Club - 20th Century Studios
('M010', 'S009'), -- The Lord of the Rings - New Line Cinema
('M011', 'S003'), -- Interstellar - Paramount Pictures
('M012', 'S005'), -- The Silence of the Lambs - Columbia Pictures
('M013', 'S002'), -- Schindler's List - Universal Pictures
('M014', 'S003'), -- Titanic - Paramount Pictures
('M015', 'S001'), -- The Departed - Warner Bros.
('M016', 'S010'), -- Gladiator - DreamWorks Pictures
('M017', 'S001'), -- The Green Mile - Warner Bros.
('M018', 'S010'), -- Saving Private Ryan - DreamWorks Pictures
('M019', 'S002'), -- Jurassic Park - Universal Pictures
('M020', 'S004'), -- The Lion King - Walt Disney Pictures
('M021', 'S006'), -- Avatar - 20th Century Studios
('M022', 'S016'), -- The Avengers - Marvel Studios
('M023', 'S001'), -- The Dark Knight Rises - Warner Bros.
('M024', 'S003'), -- The Godfather: Part II - Paramount Pictures
('M025', 'S001'), -- The Shining - Warner Bros.
('M026', 'S006'), -- Alien - 20th Century Studios
('M027', 'S002'), -- Back to the Future - Universal Pictures
('M028', 'S003'), -- Raiders of the Lost Ark - Paramount Pictures
('M029', 'S005'), -- The Terminator - Columbia Pictures
('M030', 'S006'), -- Die Hard - 20th Century Studios
('M031', 'S002'), -- Jaws - Universal Pictures
('M032', 'S017'), -- Star Wars: Episode IV - Lucasfilm
('M033', 'S002'), -- E.T. the Extra-Terrestrial - Universal Pictures
('M034', 'S001'), -- Casablanca - Warner Bros.
('M035', 'S003'), -- Psycho - Paramount Pictures
('M036', 'S007'), -- Gone with the Wind - MGM
('M037', 'S007'), -- Citizen Kane - MGM
('M038', 'S007'), -- The Wizard of Oz - MGM
('M039', 'S007'), -- 2001: A Space Odyssey - MGM
('M040', 'S001'), -- Blade Runner - Warner Bros.
('M041', 'S001'), -- The Exorcist - Warner Bros.
('M042', 'S002'), -- One Flew Over the Cuckoo's Nest - Universal Pictures
('M043', 'S002'), -- Apocalypse Now - Universal Pictures
('M044', 'S005'), -- Lawrence of Arabia - Columbia Pictures
('M045', 'S003'), -- Vertigo - Paramount Pictures
('M046', 'S005'), -- Taxi Driver - Columbia Pictures
('M047', 'S003'), -- Chinatown - Paramount Pictures
('M048', 'S002'), -- The Blues Brothers - Universal Pictures
('M049', 'S007'), -- Legally Blonde - MGM
('M050', 'S002'), -- Erin Brockovich - Universal Pictures
('M051', 'S007'), -- Rocky - MGM
('M052', 'S002'), -- Scarface - Universal Pictures
('M053', 'S007'), -- The Silence of the Lambs (re-release) - MGM
('M054', 'S003'), -- Braveheart - Paramount Pictures
('M055', 'S014'), -- Amélie - Miramax
('M056', 'S006'), -- Edward Scissorhands - 20th Century Studios
('M057', 'S014'), -- Kill Bill - Miramax
('M058', 'S010'), -- Shrek - DreamWorks Pictures
('M059', 'S015'), -- WALL-E - Pixar Animation Studios
('M060', 'S001') ; -- Harry Potter - Warner Bros.
 

-- Insert data into Ratings table (Uthra) 
INSERT INTO Ratings (RatingID, MovieID, UserID, Score, Review, Timestamp) VALUES
('R001', 'M002', 'U002', 5.5, 'Review for movie M002 by user U002', '2025-04-12 11:09:00'),
('R002', 'M003', 'U003', 6.0, 'Review for movie M003 by user U003', '2025-04-11 11:09:00'),
('R003', 'M004', 'U004', 6.5, 'Review for movie M004 by user U004', '2025-04-10 11:09:00'),
('R004', 'M005', 'U005', 7.0, 'Review for movie M005 by user U005', '2025-04-09 11:09:00'),
('R005', 'M006', 'U006', 7.5, 'Review for movie M006 by user U006', '2025-04-08 11:09:00'),
('R006', 'M007', 'U007', 5.0, 'Review for movie M007 by user U007', '2025-04-07 11:09:00'),
('R007', 'M008', 'U008', 5.5, 'Review for movie M008 by user U008', '2025-04-06 11:09:00'),
('R008', 'M009', 'U009', 6.0, 'Review for movie M009 by user U009', '2025-04-05 11:09:00'),
('R009', 'M010', 'U010', 6.5, 'Review for movie M010 by user U010', '2025-04-04 11:09:00'),
('R010', 'M011', 'U011', 7.0, 'Review for movie M011 by user U011', '2025-04-03 11:09:00'),
('R011', 'M012', 'U012', 7.5, 'Review for movie M012 by user U012', '2025-04-02 11:09:00'),
('R012', 'M013', 'U013', 5.0, 'Review for movie M013 by user U013', '2025-04-01 11:09:00'),
('R013', 'M014', 'U014', 5.5, 'Review for movie M014 by user U014', '2025-03-31 11:09:00'),
('R014', 'M015', 'U015', 6.0, 'Review for movie M015 by user U015', '2025-03-30 11:09:00'),
('R015', 'M016', 'U016', 6.5, 'Review for movie M016 by user U016', '2025-03-29 11:09:00'),
('R016', 'M017', 'U017', 7.0, 'Review for movie M017 by user U017', '2025-03-28 11:09:00'),
('R017', 'M018', 'U018', 7.5, 'Review for movie M018 by user U018', '2025-03-27 11:09:00'),
('R018', 'M019', 'U019', 5.0, 'Review for movie M019 by user U019', '2025-03-26 11:09:00'),
('R019', 'M020', 'U020', 5.5, 'Review for movie M020 by user U020', '2025-03-25 11:09:00'),
('R020', 'M021', 'U021', 6.0, 'Review for movie M021 by user U021', '2025-03-24 11:09:00'),
('R021', 'M022', 'U022', 6.5, 'Review for movie M022 by user U022', '2025-03-23 11:09:00'),
('R022', 'M023', 'U023', 7.0, 'Review for movie M023 by user U023', '2025-03-22 11:09:00'),
('R023', 'M024', 'U024', 7.5, 'Review for movie M024 by user U024', '2025-03-21 11:09:00'),
('R024', 'M025', 'U025', 5.0, 'Review for movie M025 by user U025', '2025-03-20 11:09:00'),
('R025', 'M026', 'U026', 5.5, 'Review for movie M026 by user U026', '2025-03-19 11:09:00'),
('R026', 'M027', 'U027', 6.0, 'Review for movie M027 by user U027', '2025-03-18 11:09:00'),
('R027', 'M028', 'U028', 6.5, 'Review for movie M028 by user U028', '2025-03-17 11:09:00'),
('R028', 'M029', 'U029', 7.0, 'Review for movie M029 by user U029', '2025-03-16 11:09:00'),
('R029', 'M030', 'U030', 7.5, 'Review for movie M030 by user U030', '2025-03-15 11:09:00'),
('R030', 'M001', 'U031', 5.0, 'Review for movie M001 by user U031', '2025-03-14 11:09:00'),
('R031', 'M002', 'U032', 5.5, 'Review for movie M002 by user U032', '2025-03-13 11:09:00'),
('R032', 'M003', 'U033', 6.0, 'Review for movie M003 by user U033', '2025-03-12 11:09:00'),
('R033', 'M004', 'U034', 6.5, 'Review for movie M004 by user U034', '2025-03-11 11:09:00'),
('R034', 'M005', 'U035', 7.0, 'Review for movie M005 by user U035', '2025-03-10 11:09:00'),
('R035', 'M006', 'U036', 7.5, 'Review for movie M006 by user U036', '2025-03-09 11:09:00'),
('R036', 'M007', 'U037', 5.0, 'Review for movie M007 by user U037', '2025-03-08 11:09:00'),
('R037', 'M008', 'U038', 5.5, 'Review for movie M008 by user U038', '2025-03-07 11:09:00'),
('R038', 'M009', 'U039', 6.0, 'Review for movie M009 by user U039', '2025-03-06 11:09:00'),
('R039', 'M010', 'U040', 6.5, 'Review for movie M010 by user U040', '2025-03-05 11:09:00'),
('R040', 'M011', 'U041', 7.0, 'Review for movie M011 by user U041', '2025-03-04 11:09:00'),
('R041', 'M012', 'U042', 7.5, 'Review for movie M012 by user U042', '2025-03-03 11:09:00'),
('R042', 'M013', 'U043', 5.0, 'Review for movie M013 by user U043', '2025-03-02 11:09:00'),
('R043', 'M014', 'U044', 5.5, 'Review for movie M014 by user U044', '2025-03-01 11:09:00'),
('R044', 'M015', 'U045', 6.0, 'Review for movie M015 by user U045', '2025-02-28 11:09:00'),
('R045', 'M016', 'U046', 6.5, 'Review for movie M016 by user U046', '2025-02-27 11:09:00'),
('R046', 'M017', 'U047', 7.0, 'Review for movie M017 by user U047', '2025-02-26 11:09:00'),
('R047', 'M018', 'U048', 7.5, 'Review for movie M018 by user U048', '2025-02-25 11:09:00'),
('R048', 'M019', 'U049', 5.0, 'Review for movie M019 by user U049', '2025-02-24 11:09:00'),
('R049', 'M020', 'U050', 5.5, 'Review for movie M020 by user U050', '2025-02-23 11:09:00'),
('R050', 'M021', 'U051', 6.0, 'Review for movie M021 by user U051', '2025-02-22 11:09:00'),
('R051', 'M022', 'U052', 6.5, 'Review for movie M022 by user U052', '2025-02-21 11:09:00'),
('R052', 'M023', 'U053', 7.0, 'Review for movie M023 by user U053', '2025-02-20 11:09:00'),
('R053', 'M024', 'U054', 7.5, 'Review for movie M024 by user U054', '2025-02-19 11:09:00'),
('R054', 'M025', 'U055', 5.0, 'Review for movie M025 by user U055', '2025-02-18 11:09:00'),
('R055', 'M026', 'U056', 5.5, 'Review for movie M026 by user U056', '2025-02-17 11:09:00'),
('R056', 'M027', 'U057', 6.0, 'Review for movie M027 by user U057', '2025-02-16 11:09:00'),
('R057', 'M028', 'U058', 6.5, 'Review for movie M028 by user U058', '2025-02-15 11:09:00'),
('R058', 'M029', 'U059', 7.0, 'Review for movie M029 by user U059', '2025-02-14 11:09:00'),
('R059', 'M030', 'U060', 7.5, 'Review for movie M030 by user U060', '2025-02-13 11:09:00'),
('R060', 'M001', 'U001', 5.0, 'Review for movie M001 by user U001', '2025-02-12 11:09:00');
 

-- Insert data into Users table (Uthra)
INSERT INTO Users (UserID, Username, Email, Password, JoinDate) VALUES
('U001', 'moviebuff42', 'moviebuff42@example.com', 'securePass123!', '2024-01-15 14:23:17'),
('U002', 'cinephile_jane', 'jane.smith@example.com', 'Film$L0ver2024', '2024-01-18 09:45:32'),
('U003', 'director_dreams', 'future.director@example.com', 'H0llyw00d#Star', '2024-01-20 17:12:05'),
('U004', 'scifi_guy', 'space.movies@example.com', 'Interstellar2049!', '2024-01-22 21:34:19'),
('U005', 'horror_queen', 'scarymovies@example.com', 'Fr1ghtN1ght!', '2024-01-25 13:27:41'),
('U006', 'comedy_king', 'laughs4days@example.com', 'HaHaHa2024$', '2024-01-27 10:18:53'),
('U007', 'indie_lover', 'artfilms@example.com', 'Sundance#Fest', '2024-01-30 15:42:08'),
('U008', 'blockbuster_fan', 'action.packed@example.com', 'Expl0si0ns!', '2024-02-02 19:05:27'),
('U009', 'classic_cinema', 'oldmovies@example.com', 'Casablanca1942', '2024-02-05 11:37:14'),
('U010', 'documentary_buff', 'realstories@example.com', 'TrueStory2024!', '2024-02-08 14:29:36'),
('U011', 'animation_addict', 'cartoons@example.com', 'P1xarDr3ams!', '2024-02-10 16:53:22'),
('U012', 'thriller_seeker', 'suspense@example.com', 'Wh0dun1t?', '2024-02-12 20:15:47'),
('U013', 'oscar_tracker', 'awardseason@example.com', 'G0ldStatue!', '2024-02-15 09:41:33'),
('U014', 'foreign_film_fan', 'worldcinema@example.com', 'SubT1tles#2024', '2024-02-18 12:24:59'),
('U015', 'weekend_watcher', 'casual.viewer@example.com', 'P0pc0rnTime!', '2024-02-20 18:07:12'),
('U016', 'film_student', 'cinema.studies@example.com', 'F1lmThe0ry#', '2024-02-23 14:39:28'),
('U017', 'marathon_master', 'bingewatcher@example.com', 'AllN1ghter2024!', '2024-02-25 21:52:04'),
('U018', 'critic_wannabe', 'movie.reviews@example.com', 'TwoThumbsUp!', '2024-02-28 11:14:37'),
('U019', 'superhero_stan', 'comicmovies@example.com', 'Capt41nMarv3l!', '2024-03-02 15:26:53'),
('U020', 'rom_com_fan', 'romantic.comedies@example.com', 'L0veStory#', '2024-03-05 10:48:19'),
('U021', 'film_noir_lover', 'blackandwhite@example.com', 'Sh4d0ws&Light', '2024-03-07 17:33:42'),
('U022', 'musical_maven', 'singingdancing@example.com', 'Br0adway#2024', '2024-03-10 13:05:27'),
('U023', 'cult_classics', 'midnight.movies@example.com', 'R0ckyH0rror!', '2024-03-12 19:22:14'),
('U024', 'family_viewer', 'kidsfriendly@example.com', 'G-Rated2024!', '2024-03-15 09:57:36'),
('U025', 'history_buff', 'period.pieces@example.com', 'T1meTrav3ler#', '2024-03-17 14:19:52'),
('U026', 'festival_goer', 'independent.films@example.com', 'C4nnes2024!', '2024-03-20 11:42:08'),
('U027', 'streaming_addict', 'ondemand@example.com', 'N3tflixChill!', '2024-03-22 16:35:27'),
('U028', 'movie_collector', 'bluray.collector@example.com', 'Phys1calM3dia#', '2024-03-25 20:14:39'),
('U029', 'film_theorist', 'movie.analysis@example.com', 'D33pMean1ng!', '2024-03-28 12:47:53'),
('U030', 'popcorn_muncher', 'casual.movies@example.com', 'Th3aterExp!', '2024-03-30 15:29:16'),
('U031', 'director_fanboy', 'auteur.theory@example.com', 'Kubr1ck2024!', '2024-04-01 09:12:34'),
('U032', 'screenplay_writer', 'future.writer@example.com', 'Scr1ptDoct0r#', '2024-04-03 14:25:47'),
('U033', 'cinematography_fan', 'visual.storytelling@example.com', 'Fr4ming&Light!', '2024-04-05 17:38:21'),
('U034', 'dialogue_lover', 'great.lines@example.com', 'Qu0table2024!', '2024-04-07 11:52:09'),
('U035', 'plot_twist_addict', 'surprise.endings@example.com', 'D1dntSeeItComing!', '2024-04-09 19:07:43'),
('U036', 'character_study', 'deep.characters@example.com', 'Psych0l0gical#', '2024-04-11 13:24:56'),
('U037', 'visual_effects_fan', 'cgi.lover@example.com', 'Sp3cialFX2024!', '2024-04-13 16:41:32'),
('U038', 'sound_design_buff', 'audio.appreciation@example.com', 'F0leyArt1st#', '2024-04-15 10:15:48'),
('U039', 'editing_enthusiast', 'cut.together@example.com', 'M0ntage2024!', '2024-04-17 14:37:29'),
('U040', 'costume_design_fan', 'movie.fashion@example.com', 'P3ri0dDress#', '2024-04-19 18:59:12'),
('U041', 'production_design', 'movie.sets@example.com', 'Sc3nery2024!', '2024-04-21 12:22:45'),
('U042', 'makeup_effects', 'special.makeup@example.com', 'Pr0sthetics#', '2024-04-23 15:44:27'),
('U043', 'stunt_appreciator', 'action.scenes@example.com', 'N0Doubl3s!', '2024-04-25 09:07:53'),
('U044', 'composer_fan', 'movie.scores@example.com', 'Soundtr4ck2024#', '2024-04-27 13:29:16'),
('U045', 'practical_effects', 'no.cgi@example.com', 'OldSch00lFX!', '2024-04-29 17:51:42'),
('U046', 'method_acting_fan', 'deep.immersion@example.com', 'St4yInChar4cter#', '2024-05-01 11:13:25'),
('U047', 'franchise_follower', 'movie.series@example.com', 'Sequ3lPrequel!', '2024-05-03 15:36:48'),
('U048', 'opening_weekend', 'first.showing@example.com', 'M1dnight#Premier', '2024-05-05 19:58:21'),
('U049', 'credits_watcher', 'stay.till.end@example.com', 'P0stCred1tScene!', '2024-05-07 13:21:37'),
('U050', 'behind_scenes', 'making.of@example.com', 'DVD#Extras2024', '2024-05-09 16:44:52'),
('U051', 'movie_quotes', 'famous.lines@example.com', 'Say#HelloToMyLittleFriend', '2024-05-11 10:07:19'),
('U052', 'movie_locations', 'filming.spots@example.com', 'OnL0cation2024!', '2024-05-13 14:29:43'),
('U053', 'movie_mistakes', 'continuity.errors@example.com', 'G00fSpotter#', '2024-05-15 18:52:07'),
('U054', 'movie_trivia', 'film.facts@example.com', 'D1dY0uKnow!', '2024-05-17 12:14:35'),
('U055', 'movie_easter_eggs', 'hidden.references@example.com', 'Sp0tTheClue#', '2024-05-19 15:37:58'),
('U056', 'movie_memorabilia', 'props.collector@example.com', 'Auth3nticItem!', '2024-05-21 09:59:24'),
('U057', 'movie_premieres', 'red.carpet@example.com', 'C3lebrity#Selfie', '2024-05-23 13:22:47'),
('U058', 'movie_adaptations', 'book.to.film@example.com', 'B3tterThanB00k!', '2024-05-25 17:45:13'),
('U059', 'movie_remakes', 'reimagined.classics@example.com', 'N3wTake2024#', '2024-05-27 11:07:36'),
('U060', 'movie_marathons', 'all.day.viewing@example.com', 'N0Sleep4Movies!', '2024-05-29 15:30:52');
 
-- Insert data into Watchlists table (Uthra) 
INSERT INTO Watchlists (WatchlistID, UserID, Name, CreatedDate) VALUES
('WL001', 'U001', 'Oscar Winners', '2024-01-16 10:30:45'),
('WL002', 'U001', 'Sci-Fi Favorites', '2024-01-17 14:22:37'),
('WL003', 'U002', 'Must-See Classics', '2024-01-19 09:15:28'),
('WL004', 'U002', 'Date Night Movies', '2024-01-20 16:45:12'),
('WL005', 'U003', 'Directorial Masterpieces', '2024-01-21 13:27:39'),
('WL006', 'U003', 'Film School Essentials', '2024-01-22 18:05:54'),
('WL007', 'U004', 'Space Adventures', '2024-01-23 11:42:18'),
('WL008', 'U004', 'Time Travel Movies', '2024-01-24 15:33:47'),
('WL009', 'U005', 'Psychological Horror', '2024-01-26 09:19:23'),
('WL010', 'U005', 'Slasher Classics', '2024-01-27 14:51:36'),
('WL011', 'U006', 'Laugh-Out-Loud Comedies', '2024-01-28 12:24:58'),
('WL012', 'U006', 'Satirical Films', '2024-01-29 17:07:32'),
('WL013', 'U007', 'Sundance Winners', '2024-01-31 10:45:19'),
('WL014', 'U007', 'Arthouse Cinema', '2024-02-01 15:18:43'),
('WL015', 'U008', 'Summer Blockbusters', '2024-02-03 13:29:57'),
('WL016', 'U008', 'Action Franchises', '2024-02-04 18:12:34'),
('WL017', 'U009', 'Golden Age Hollywood', '2024-02-06 11:36:48'),
('WL018', 'U009', 'Film Noir Collection', '2024-02-07 16:09:22'),
('WL019', 'U010', 'Award-Winning Documentaries', '2024-02-09 14:23:45'),
('WL020', 'U010', 'True Crime Stories', '2024-02-10 19:57:13'),
('WL021', 'U011', 'Pixar Collection', '2024-02-11 12:34:56'),
('WL022', 'U011', 'Studio Ghibli Films', '2024-02-12 17:18:29'),
('WL023', 'U012', 'Mystery Thrillers', '2024-02-13 10:45:37'),
('WL024', 'U012', 'Psychological Suspense', '2024-02-14 15:22:48'),
('WL025', 'U013', 'Best Picture Winners', '2024-02-16 13:09:27'),
('WL026', 'U013', 'Acting Masterclasses', '2024-02-17 18:41:53'),
('WL027', 'U014', 'International Film Festival Hits', '2024-02-19 11:27:34'),
('WL028', 'U014', 'World Cinema Classics', '2024-02-20 16:59:12'),
('WL029', 'U015', 'Easy Weekend Watches', '2024-02-21 14:12:45'),
('WL030', 'U015', 'Family Movie Night', '2024-02-22 19:36:28'),
('WL031', 'U016', 'Film Theory Examples', '2024-02-24 12:48:37'),
('WL032', 'U016', 'Cinematography Showcases', '2024-02-25 17:23:51'),
('WL033', 'U017', 'Trilogy Marathons', '2024-02-26 10:39:24'),
('WL034', 'U017', '24-Hour Movie Challenge', '2024-02-27 15:14:47'),
('WL035', 'U018', 'Critically Acclaimed', '2024-02-29 13:27:58'),
('WL036', 'U018', 'Underrated Gems', '2024-03-01 18:53:16'),
('WL037', 'U019', 'Marvel Cinematic Universe', '2024-03-03 11:42:29'),
('WL038', 'U019', 'DC Extended Universe', '2024-03-04 16:17:43'),
('WL039', 'U020', 'Classic Rom-Coms', '2024-03-06 14:35:26'),
('WL040', 'U020', 'Modern Love Stories', '2024-03-07 19:08:52'),
('WL041', 'U021', 'Classic Noir Films', '2024-03-08 12:24:37'),
('WL042', 'U021', 'Neo-Noir Collection', '2024-03-09 17:59:14'),
('WL043', 'U022', 'Broadway Adaptations', '2024-03-11 10:47:23'),
('WL044', 'U022', 'Dance Movies', '2024-03-12 15:31:48'),
('WL045', 'U023', 'Midnight Movie Madness', '2024-03-13 13:14:29'),
('WL046', 'U023', 'So Bad Theyre Good', '2024-03-14 18:42:57'),
('WL047', 'U024', 'Kids Movies', '2024-03-16 11:29:38'),
('WL048', 'U024', 'Educational Films', '2024-03-17 16:53:12'),
('WL049', 'U025', 'Historical Epics', '2024-03-18 14:07:45'),
('WL050', 'U025', 'Period Dramas', '2024-03-19 19:34:28'),
('WL051', 'U026', 'Cannes Winners', '2024-03-21 12:19:37'),
('WL052', 'U026', 'Venice Film Festival Selections', '2024-03-22 17:45:53'),
('WL053', 'U027', 'Netflix Originals', '2024-03-23 10:32:14'),
('WL054', 'U027', 'Prime Video Exclusives', '2024-03-24 15:58:47'),
('WL055', 'U028', 'Criterion Collection', '2024-03-26 13:21:36'),
('WL056', 'U028', '4K Restorations', '2024-03-27 18:47:52'),
('WL057', 'U029', 'Films With Hidden Meanings', '2024-03-29 11:34:19'),
('WL058', 'U029', 'Philosophical Movies', '2024-03-30 16:09:43'),
('WL059', 'U030', 'Summer Watchlist', '2024-03-31 14:23:27'),
('WL060', 'U030', 'Holiday Season Movies', '2024-04-01 19:48:54');
 
-- Insert data into Watchlist_Movies table (Uthra)
INSERT INTO Watchlist_Movies (WatchlistID, MovieID, AddedDate) VALUES
('WL014', 'M055', '2025-01-18 11:42:00'),
('WL012', 'M043', '2024-07-26 11:42:00'),
('WL036', 'M038', '2024-09-28 11:42:00'),
('WL012', 'M032', '2024-08-01 11:42:00'),
('WL031', 'M029', '2025-03-11 11:42:00'),
('WL016', 'M036', '2024-12-20 11:42:00'),
('WL033', 'M049', '2025-01-02 11:42:00'),
('WL019', 'M017', '2024-11-20 11:42:00'),
('WL019', 'M037', '2025-01-13 11:42:00'),
('WL001', 'M038', '2024-12-28 11:42:00'),
('WL034', 'M060', '2024-09-14 11:42:00'),
('WL005', 'M019', '2024-06-11 11:42:00'),
('WL001', 'M010', '2024-11-01 11:42:00'),
('WL016', 'M019', '2024-11-23 11:42:00'),
('WL034', 'M029', '2025-01-20 11:42:00'),
('WL020', 'M056', '2024-07-13 11:42:00'),
('WL014', 'M053', '2024-07-06 11:42:00'),
('WL007', 'M025', '2024-05-03 11:42:00'),
('WL001', 'M014', '2024-12-05 11:42:00'),
('WL046', 'M052', '2024-12-24 11:42:00'),
('WL053', 'M024', '2025-02-15 11:42:00'),
('WL030', 'M022', '2024-12-27 11:42:00'),
('WL030', 'M008', '2024-10-23 11:42:00'),
('WL057', 'M047', '2024-10-05 11:42:00'),
('WL002', 'M001', '2024-08-31 11:42:00'),
('WL032', 'M009', '2024-12-03 11:42:00'),
('WL040', 'M022', '2024-10-26 11:42:00'),
('WL003', 'M029', '2024-09-30 11:42:00'),
('WL001', 'M058', '2025-03-13 11:42:00'),
('WL031', 'M051', '2024-07-08 11:42:00'),
('WL041', 'M014', '2024-09-13 11:42:00'),
('WL021', 'M041', '2024-12-30 11:42:00'),
('WL008', 'M023', '2025-01-29 11:42:00'),
('WL035', 'M060', '2025-04-06 11:42:00'),
('WL023', 'M043', '2025-01-16 11:42:00'),
('WL005', 'M004', '2025-01-08 11:42:00'),
('WL057', 'M020', '2024-12-31 11:42:00'),
('WL039', 'M028', '2024-10-14 11:42:00'),
('WL059', 'M013', '2025-03-30 11:42:00'),
('WL042', 'M024', '2024-05-27 11:42:00'),
('WL050', 'M020', '2024-08-15 11:42:00'),
('WL018', 'M006', '2025-03-18 11:42:00'),
('WL012', 'M019', '2024-05-20 11:42:00'),
('WL007', 'M057', '2024-04-17 11:42:00'),
('WL022', 'M036', '2024-09-06 11:42:00'),
('WL017', 'M004', '2024-11-08 11:42:00'),
('WL018', 'M060', '2025-02-22 11:42:00'),
('WL044', 'M045', '2024-05-21 11:42:00'),
('WL028', 'M045', '2025-01-06 11:42:00'),
('WL056', 'M030', '2024-04-13 11:42:00'),
('WL037', 'M043', '2025-03-10 11:42:00'),
('WL008', 'M035', '2024-12-26 11:42:00'),
('WL054', 'M002', '2025-02-12 11:42:00'),
('WL001', 'M057', '2025-03-05 11:42:00'),
('WL025', 'M011', '2025-02-27 11:42:00'),
('WL028', 'M029', '2024-05-18 11:42:00'),
('WL057', 'M049', '2024-08-09 11:42:00'),
('WL053', 'M029', '2024-07-06 11:42:00'),
('WL026', 'M024', '2025-01-14 11:42:00'),
('WL057', 'M027', '2024-08-11 11:42:00'),
('WL043', 'M007', '2025-04-13 11:42:00'),
('WL026', 'M019', '2024-06-27 11:42:00'),
('WL038', 'M056', '2025-02-07 11:42:00'),
('WL058', 'M030', '2025-01-01 11:42:00'),
('WL016', 'M013', '2024-12-12 11:42:00'),
('WL024', 'M048', '2024-05-08 11:42:00'),
('WL001', 'M013', '2025-03-20 11:42:00'),
('WL001', 'M054', '2024-10-14 11:42:00'),
('WL053', 'M037', '2024-10-24 11:42:00'),
('WL020', 'M013', '2024-11-17 11:42:00'),
('WL005', 'M012', '2024-06-10 11:42:00'),
('WL059', 'M008', '2024-04-17 11:42:00'),
('WL002', 'M012', '2025-04-11 11:42:00'),
('WL015', 'M026', '2024-07-06 11:42:00'),
('WL018', 'M050', '2024-11-01 11:42:00'),
('WL002', 'M014', '2024-12-14 11:42:00'),
('WL035', 'M042', '2024-09-03 11:42:00'),
('WL049', 'M033', '2024-05-31 11:42:00'),
('WL041', 'M052', '2024-10-14 11:42:00'),
('WL039', 'M049', '2024-06-01 11:42:00'),
('WL023', 'M051', '2024-09-13 11:42:00'),
('WL001', 'M037', '2024-10-30 11:42:00'),
('WL056', 'M050', '2024-06-04 11:42:00'),
('WL009', 'M020', '2024-10-05 11:42:00'),
('WL043', 'M006', '2025-03-15 11:42:00'),
('WL015', 'M021', '2024-04-23 11:42:00'),
('WL016', 'M015', '2024-06-28 11:42:00'),
('WL042', 'M056', '2025-03-25 11:42:00'),
('WL053', 'M014', '2024-12-29 11:42:00'),
('WL030', 'M026', '2025-01-01 11:42:00'),
('WL028', 'M003', '2024-10-09 11:42:00'),
('WL038', 'M041', '2024-12-15 11:42:00'),
('WL022', 'M002', '2024-07-17 11:42:00'),
('WL015', 'M040', '2025-02-18 11:42:00'),
('WL003', 'M001', '2024-08-10 11:42:00'),
('WL032', 'M040', '2024-07-20 11:42:00'),
('WL052', 'M043', '2025-02-12 11:42:00'),
('WL046', 'M026', '2024-09-04 11:42:00'),
('WL042', 'M007', '2024-12-18 11:42:00'),
('WL033', 'M033', '2024-07-21 11:42:00'),
('WL018', 'M017', '2024-06-20 11:42:00'),
('WL024', 'M040', '2025-01-11 11:42:00'),
('WL051', 'M028', '2024-09-17 11:42:00'),
('WL060', 'M052', '2025-01-13 11:42:00'),
('WL033', 'M029', '2024-04-24 11:42:00'),
('WL039', 'M027', '2025-02-24 11:42:00'),
('WL026', 'M017', '2024-12-03 11:42:00'),
('WL043', 'M024', '2024-08-09 11:42:00'),
('WL038', 'M023', '2024-10-30 11:42:00'),
('WL052', 'M041', '2024-09-22 11:42:00'),
('WL011', 'M033', '2024-09-04 11:42:00'),
('WL016', 'M058', '2024-04-16 11:42:00'),
('WL004', 'M026', '2025-01-18 11:42:00'),
('WL008', 'M049', '2025-03-09 11:42:00'),
('WL036', 'M042', '2025-02-14 11:42:00'),
('WL059', 'M004', '2024-06-21 11:42:00'),
('WL011', 'M013', '2024-07-30 11:42:00'),
('WL013', 'M049', '2024-11-21 11:42:00'),
('WL014', 'M054', '2024-06-08 11:42:00'),
('WL041', 'M020', '2025-02-04 11:42:00');

