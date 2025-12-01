mariadb -u root -p${MYSQL_ROOT_PASSWORD}
ALTER USER 'root'@'localhost' IDENTIFIED BY '';
ALTER USER 'root'@'%' IDENTIFIED BY '';
ALTER USER 'domjudge'localhost'%' IDENTIFIED BY '';
ALTER USER 'domjudge'@'%' IDENTIFIED BY '';
FLUSH PRIVILEGES;
