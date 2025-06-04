CREATE TABLE `users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `cat_name` VARCHAR(100),
  `cat_age` INT,
  `cat_breed` VARCHAR(100),
  `cat_color` VARCHAR(100),
  `cat_weight` FLOAT,
  PRIMARY KEY (`id`)
);

INSERT INTO `users` (`id`, `username`, `email`, `password`, `cat_name`, `cat_age`, `cat_breed`, `cat_color`, `cat_weight`) VALUES
(1, 'JohnDoe', 'user1@email.com', '1234', 'Whiskers', 3, 'Persian', 'White', 2.5),
(2, 'JaneSmith', 'user2@email.com', 'abcd', 'Mittens', 3, 'British Shorthair', 'Gray', 3);
