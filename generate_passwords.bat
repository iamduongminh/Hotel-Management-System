@echo off
echo Generating passwords...
javac -encoding UTF-8 -cp ".;C:\Users\huydi\.m2\repository\org\springframework\security\spring-security-crypto\6.5.7\spring-security-crypto-6.5.7.jar;C:\Users\huydi\.m2\repository\org\springframework\spring-core\6.2.15\spring-core-6.2.15.jar;C:\Users\huydi\.m2\repository\org\springframework\spring-jcl\6.2.15\spring-jcl-6.2.15.jar" PasswordGenerator.java
if %errorlevel% neq 0 (
    echo Compilation failed.
    pause
    exit /b %errorlevel%
)
java -Dfile.encoding=UTF-8 -cp ".;C:\Users\huydi\.m2\repository\org\springframework\security\spring-security-crypto\6.5.7\spring-security-crypto-6.5.7.jar;C:\Users\huydi\.m2\repository\org\springframework\spring-core\6.2.15\spring-core-6.2.15.jar;C:\Users\huydi\.m2\repository\org\springframework\spring-jcl\6.2.15\spring-jcl-6.2.15.jar" PasswordGenerator
del PasswordGenerator.class
echo.
echo Copy the lines between SQL_START and SQL_END (the VALUES tuples).
pause
