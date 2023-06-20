-- 1) Tüm blog yazılarını başlıkları, yazarları ve kategorileriyle birlikte getirin.

SELECT title, users.username, categories.name AS category_name FROM posts
JOIN users ON users.user_id = posts.user_id
JOIN categories ON categories.category_id = posts.category_id;


-- 2. En son yayınlanan 5 blog yazısını başlıkları, yazarları ve yayın tarihleriyle birlikte alın.

SELECT title, users.username, posts.creation_date FROM posts
JOIN users ON users.user_id = posts.user_id
ORDER BY posts.creation_date DESC
LIMIT 5;

-- 3. Her blog yazısı için yorum sayısını gösterin.

SELECT title, (
	SELECT COUNT(*) FROM comments WHERE posts.post_id = comments.post_id
) 
FROM posts
INNER JOIN comments ON posts.post_id = comments.post_id;


-- 4. Tüm kayıtlı kullanıcıların kullanıcı adlarını ve e-posta adreslerini gösterin.

SELECT username, email FROM users;


-- 5. En son 10 yorumu, ilgili gönderi başlıklarıyla birlikte alın.

SELECT comments.comment, posts.title FROM comments
JOIN posts ON comments.post_id = posts.post_id
ORDER BY comments.creation_date DESC
LIMIT 10;


-- 6. Belirli bir kullanıcı tarafından yazılan tüm blog yazılarını bulun.

SELECT posts.content FROM users
JOIN posts ON users.user_id = posts.user_id
WHERE user_id = 1;


-- 7. Her kullanıcının yazdığı toplam gönderi sayısını alın.

SELECT username,
(
	SELECT COUNT(*) FROM posts WHERE users.user_id = posts.user_id
) AS post_count
FROM users;


-- 8. Her kategoriyi, kategorideki gönderi sayısıyla birlikte gösterin.

SELECT name,
(
	SELECT COUNT(*) FROM posts WHERE posts.category_id = categories.category_id
) FROM categories;


-- 9. Gönderi sayısına göre en popüler kategoriyi bulun.

SELECT name,
(
	SELECT COUNT(*) FROM posts 
	WHERE posts.category_id = categories.category_id
) AS post_count
FROM categories
ORDER BY post_count DESC
LIMIT 1;


-- 10. Gönderilerindeki toplam görüntülenme sayısına göre en popüler kategoriyi bulun.

SELECT name, SUM(view_count) AS view_count FROM posts
JOIN categories ON posts.category_id = categories.category_id
GROUP BY name
ORDER BY view_count DESC
LIMIT 1;


-- 11. En fazla yoruma sahip gönderiyi alın.

SELECT posts.post_id, posts.title, posts.content, COUNT(comment) AS comment_count FROM posts
INNER JOIN comments ON posts.post_id = comments.post_id
GROUP BY posts.post_id
ORDER BY comment_count DESC
LIMIT 1;


-- 12. Belirli bir gönderinin yazarının kullanıcı adını ve e-posta adresini gösterin.

SELECT posts.post_id, posts.title, users.username, users.email FROM users
INNER JOIN posts ON posts.user_id = users.user_id
WHERE posts.post_id = 2;


-- 13. Başlık veya içeriklerinde belirli bir anahtar kelime bulunan tüm gönderileri bulun.

SELECT title, content FROM posts 
WHERE posts.title ILIKE '%Lorem%' 
OR posts.content ILIKE '%Lorem%';


-- 14. Belirli bir kullanıcının en son yorumunu gösterin.

SELECT users.username, comments.comment, comments.creation_date
FROM users 
JOIN comments ON users.user_id = comments.user_id
WHERE users.user_id = 1 
ORDER BY comments.creation_date DESC
LIMIT 1;

-- 15. Gönderi başına ortalama yorum sayısını bulun.

SELECT ROUND(AVG(COUNT))
FROM (
    SELECT COUNT(*)
    FROM comments
    GROUP BY post_id
) AS temp_table;


-- 16. Son 30 günde yayınlanan gönderileri gösterin.

SELECT * FROM posts
WHERE creation_date > '2023-05-17';


-- 17. Belirli bir kullanıcının yaptığı yorumları alın.

SELECT comment FROM comments
JOIN users ON users.user_id = comments.user_id
WHERE users.user_id = 1;


-- 18. Belirli bir kategoriye ait tüm gönderileri bulun.

SELECT posts.category_id, categories.name, posts.title, posts.content 
FROM posts
JOIN categories ON categories.category_id = posts.category_id
WHERE posts.category_id = 2;


-- 19. 5'ten az yazıya sahip kategorileri bulun.

SELECT * FROM 
(SELECT categories.name, COUNT(*) AS count FROM posts
 JOIN categories ON categories.category_id = posts.category_id
 GROUP BY name
) AS temp_table
WHERE count < 5;


-- 20. Hem bir yazı hem de bir yoruma sahip olan kullanıcıları gösterin.

SELECT users.user_id, users.username FROM users
JOIN posts ON users.user_id = posts.user_id
JOIN comments ON comments.user_id = posts.user_id
GROUP BY users.user_id;


-- 21. En az 2 farklı yazıya yorum yapmış kullanıcıları alın.

SELECT users.user_id, users.username FROM users
WHERE
(
	SELECT DISTINCT COUNT(post_id) FROM comments
	WHERE users.user_id = comments.user_id
) >= 2;


-- 22. En az 3 yazıya sahip kategorileri görüntüleyin.

SELECT categories.name FROM categories
WHERE
(
	SELECT DISTINCT COUNT(category_id) FROM posts
	WHERE categories.category_id = posts.category_id
) >= 3;


-- 23. 5'ten fazla blog yazısı yazan yazarları bulun.

SELECT users.user_id, users.username FROM users
WHERE
(
	SELECT DISTINCT COUNT(post_id) FROM posts
	WHERE users.user_id = posts.user_id
) >= 5;


-- 24. Bir blog yazısı yazmış veya bir yorum yapmış kullanıcıların e-posta adreslerini
-- görüntüleyin. (UNION kullanarak)

(
	SELECT users.email
	FROM users
	WHERE (SELECT COUNT(*) FROM posts WHERE posts.user_id = users.user_id) = 1
)
UNION
(	
	SELECT users.email
	FROM users
	WHERE (SELECT COUNT(*) FROM comments WHERE comments.user_id = users.user_id) = 1
);


-- 25. Bir blog yazısı yazmış ancak hiç yorum yapmamış yazarları bulun.

SELECT users.user_id, users.username FROM users
WHERE
(
	SELECT COUNT(*) FROM posts WHERE users.user_id = posts.user_id
) > 0
AND
(
	SELECT COUNT(*) FROM comments WHERE users.user_id = comments.user_id
) = 0