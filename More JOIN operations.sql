--1
--List the films where the yr is 1962 [Show id, title]

SELECT id, title
 FROM movie
 WHERE yr=1962

--2
--Give year of 'Citizen Kane'.

select yr 
from movie
where title = 'citizen kane'

--3
--List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.

select id,title,yr
from movie
where title like  '%star trek%'
order by yr

--4
--What id number does the actor 'Glenn Close' have?

select distinct id
from  actor
where name = 'glenn close'

--5
--What is the id of the film 'Casablanca'

select id
from movie
where title = 'casablanca'

--6
--Obtain the cast list for 'Casablanca'.

select name 
from actor

inner join casting
on actor.id = casting.actorid

where movieid = all(select movieid from casting where movieid = 11768)

--7
--Obtain the cast list for the film 'Alien'

select name
from actor

inner join casting 
on actor.id = casting.actorid
inner join movie 
on casting.movieid = movie.id

where movie.title ='alien' 

--8
--List the films in which 'Harrison Ford' has appeared

select movie.title
from movie

join casting 
on movie.id = casting.movieid
join actor 
on casting.actorid = actor.id

where actor.name = 'harrison ford'

--9
--List the films where 'Harrison Ford' has appeared - but not in the starring role.
--[Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]

select movie.title
from movie

join casting 
on movie.id = casting.movieid
join actor
on casting.actorid = actor.id

where actor.name = 'harrison ford' and casting.ord <> 1

--10
--List the films together with the leading star for all 1962 films.

select movie.title , actor.name
from movie

join casting
on movie.id = casting.movieid
join actor
on casting.actorid = actor.id

where casting.ord = 1 and movie.yr = 1962

--11
--Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=casting.movieid
        JOIN actor   ON casting.actorid=actor.id
WHERE name='rock hudson'
GROUP BY yr
HAVING COUNT(title) > 2

--12
--List the film title and the leading actor for all of the films 'Julie Andrews' played in.

SELECT movie.title, actor.name
FROM movie

join casting
on movie.id = casting.movieid and ord = 1
join actor
on casting.actorid = actor.id

WHERE movie.id in( select movieid from casting 
                   where actorid in(select id from actor 
                    where name='Julie Andrews' ))

--13
--Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.

select distinct actor.name
from actor

join casting 
on actor.id = casting.actorid

where casting.ord = 1 
group by actor.name
having count(*) >14
order by actor.name

--14
--List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

select movie.title, count(actorid)
from movie

join casting
on movie.id = casting.movieid

where movie.yr = 1978
group by movie.id, movie.title
order by count(*) desc, title

--15
--List all the people who have worked with 'Art Garfunkel'.

SELECT a.name
  FROM (SELECT movie.*
          FROM movie
          JOIN casting
            ON casting.movieid = movie.id
          JOIN actor
            ON actor.id = casting.actorid
         WHERE actor.name = 'Art Garfunkel') AS m
  JOIN (SELECT actor.*, casting.movieid
          FROM actor
          JOIN casting
            ON casting.actorid = actor.id
         WHERE actor.name != 'Art Garfunkel') as a
    ON m.id = a.movieid;
