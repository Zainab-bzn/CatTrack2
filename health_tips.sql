CREATE TABLE `health_tips` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `breed` VARCHAR(100) NOT NULL,
  `tip` TEXT NOT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `health_tips` (`id`, `breed`, `tip`) VALUES
(1, 'Persian', 'Brush daily to prevent matting and hairballs.'),
(2, 'Persian', 'Wipe eyes gently to avoid tear staining.'),
(3, 'Persian', 'Use a dust-free litter to protect respiratory health.'),
(4, 'British Shorthair', 'Monitor weight to avoid obesity.'),
(5, 'British Shorthair', 'Schedule yearly vet checks for dental health.'),
(6, 'British Shorthair', 'Encourage regular play to prevent joint stiffness.');
