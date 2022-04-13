DBS PROJECT - LITEGROWW - README

1. Ensure Java, MySQL server, and JDBC connector are installed.
2. Extract the contents of the zip file to a separate folder.
3. Run the database.sql file to initialize the MySQL database
4. In all Java files, replace the PASS String with the password of your MySQL server instance.

For Linux Terminal
5. Execute command 'javac *.java' on the command line to compile all files in the folder.
6. To run the program, execute command 'java -cp .:mysql-connector-java-8.0.28.jar Login'

For VS Code
5. Add the jar file included in the folder to "Refernced Libraries" in Settings option in bottom left corner.
6. Click "Run without Debugging" on Login file.
