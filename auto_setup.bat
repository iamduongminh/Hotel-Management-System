@echo off
cls
echo ================================================
echo   AUTO SETUP - Import Users and Verify
echo ================================================
echo.

echo [STEP 1] Importing test users to database...
mysql -u root -pMinhsql04102005 hotel_db < quick_import.sql 2>nul

if %errorlevel% neq 0 (
    echo [ERROR] Failed to import users!
    echo Please check MySQL connection.
    pause
    exit /b 1
)

echo [OK] Users imported successfully!
echo.

echo [STEP 2] Verifying users in database...
mysql -u root -pMinhsql04102005 -e "USE hotel_db; SELECT username, role, full_name FROM users;" 2>nul

echo.
echo ================================================
echo   Setup Complete! You can now:
echo   1. Start server: mvnw.cmd spring-boot:run
echo   2. Login at: http://localhost:8080/pages/auth/login.html
echo ================================================
echo.
echo Test Accounts:
echo   - admin / AADM120392
echo   - MinhRM / MinhRM150585
echo   - staff / TuanREC150695
echo.
pause
