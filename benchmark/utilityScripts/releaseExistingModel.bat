@ECHO OFF
REM Asks the user for the name of the model to release, and then creates new a release subdirectory of that model if it wasnt released before (excluding the .png preview).
REM Otherwise, if release/modelName already exists, just updates the directory (excluding the .png preview).
ECHO What is the name of the model in devel directory that you wish to release?
SET /P modelName=
IF "%modelName%" == "" (
ECHO Cannot release a model without a name.
PAUSE
EXIT
)
CD ..
IF NOT EXIST "devel/%modelName%" (
 ECHO Model %modelName% not found in the devel directory!
 PAUSE
 EXIT
)
IF EXIST "release/%modelName%" (
 DEL "release\%modelName%\%modelName%.zip"
 MKDIR "release/%modelName%/%modelName%"
 XCOPY /S "devel/%modelName%" "release/%modelName%/%modelName%"
 XCOPY "devel\%modelName%\%modelName%README.txt" "release\%modelName%\%modelName%README.txt" /Y
 CD "release/%modelName%"
 JAR -cMf "%modelName%.zip" "%modelName%"
 RD /s /q "%modelName%"
 ECHO Updated folder release/%modelName% , excluding the .png preview.
 ECHO Please update the .png preview picture if needed.
 PAUSE
 EXIT
)
IF NOT EXIST "release/%modelName%" (
 MKDIR "release/%modelName%"
 XCOPY /S "devel/%modelName%" "release/%modelName%"
 CD "release"
 JAR -cMf "%modelName%/%modelName%.zip" "%modelName%"
 DEL "%modelName%\%modelName%.xpn"
 DEL "%modelName%\%modelName%.pm"
 TYPE NUL >%modelName%/%modelName%.html
 (
 ECHO ^<html^>
 ECHO ^<head^>
 ECHO ^</head^>
 ECHO ^<body^>
 ECHO ^<strong^>%modelName%^</strong^> :^&nbsp;download ^<a href="https://www.fi.muni.cz/~xuhrik/release/%modelName%/%modelName%.zip" target="_blank"^>here^</a^>^<br^>
 ECHO ^<br^>
 ECHO ^<iframe align="left" frameborder=0 height=700 scrolling="no" src="https://www.fi.muni.cz/~xuhrik/release/%modelName%/%modelName%README.txt" width=700^> ^</iframe^>
 ECHO ^<br^>
 ECHO ^<br^>
 ECHO ^<iframe align="left" frameborder=0 height=1000 scrolling="no" src="https://www.fi.muni.cz/~xuhrik/release/%modelName%/%modelName%PIC.png" width=1000^> ^</iframe^>
 ECHO ^</body^>
 ECHO ^</html^>
 ) >%modelName%/%modelName%.html
 ECHO Created a folder release\%modelName% , excluding the .png preview.
 ECHO Please add the .png preview picture. It must be named %modelName%PIC.png
 PAUSE
 EXIT
)