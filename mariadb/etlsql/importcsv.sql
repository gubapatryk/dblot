LOAD DATA INFILE '/path/to/your_data.csv'
INTO TABLE your_table
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- if your CSV file has a header row