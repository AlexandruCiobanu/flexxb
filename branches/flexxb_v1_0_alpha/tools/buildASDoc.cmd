@echo off

setlocal

SET ASDOC_PATH="C:\Program Files\Adobe\Flex Builder 3\sdks\3.0.0\bin"

REM SET PROJECT_PATH="D:\Projects\workspace\XmlSerializer"

REM SET PROJECT_SRC=%PROJECT_PATH%\src\main\flex

REM SET PROJECT_DOC=%PROJECT_PATH%\doc

REM SET DOC_TITLE="XMLSerializer API Documentation"

echo Building project documentation...

%ASDOC_PATH%\asdoc -source-path %PROJECT_SRC% -doc-sources %PROJECT_SRC% -output %PROJECT_DOC% -main-title %DOC_TITLE% -window-title %DOC_TITLE%
