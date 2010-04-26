::input parameters
::prod, test, dev, sites

@echo off
cls

:: SET BUILD PARAMETERS!!!!!
set version=0.8.5
set release=81
set comment=Prod Release 0.8.5


:: 32 bit machine
:set pathVisualStudio=C:\Programmer\Microsoft Visual Studio 9.0\Common7\Tools
:set pathAdvancedInstaller=C:\Programmer\Caphyon\Advanced Installer 7.2.1

:: 64 bit machine
set pathVisualStudio=C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\Tools
set pathAdvancedInstaller=C:\Program Files (x86)\Caphyon\Advanced Installer 7.2.1

:: Write version to config files
::echo #define IEPLUGIN_VERSION "%version%" > ..\source\Shared\Version.h

echo BUILD %version%

if %1 == setvar  (
  echo SET path to visual studio
  echo ******************
  "%pathVisualStudio%\vsvars32.bat"
  goto end
)

if %1 == prod  (
  echo CREATE PRODUCTION RELEASE
  echo ******************
  goto prod_build
)

if %1 == test  (
  echo CREATE TEST RELEASE
  echo ******************
  goto test_build
)

if %1 == dev  (
  echo CREATE DEV RELEASE
  echo ******************
  goto dev_build
)

if %1 == sites  (
  echo CREATE SITES INSTALLERS
  echo ******************
  goto prod_build_sites
)

:invalid
echo ******************
echo Please enter valid input
echo Input parameters are: prod, test, dev or setvar
goto end
        

:prod_build

@echo on
echo #define DOWNLOAD_SOURCE "home" > ..\..\Shared\DownloadSource.h
devenv ..\..\AdPlugin.sln /rebuild "Release Production"
"%pathAdvancedInstaller%\AdvancedInstaller.com" /edit adblock.aip /SetVersion %version%
"%pathAdvancedInstaller%\AdvancedInstaller.com" /rebuild adblock.aip
copy adblock.msi downloadfiles\simpleadblock.msi
copy adblock.msi installers\simpleadblock%version%.msi

echo #define DOWNLOAD_SOURCE "update" > ..\..\Shared\DownloadSource.h
"%pathAdvancedInstaller%\AdvancedInstaller.com" /edit adblockupdate.aip /SetVersion %version%
"%pathAdvancedInstaller%\AdvancedInstaller.com" /rebuild adblockupdate.aip
copy adblockupdate.msi downloadfiles\simpleadblockupdate.msi
copy adblockupdate.msi installers\simpleadblockupdate%version%.msi

echo %version%;%release%;%date%;%1;%comment% >> installers\simpleadblock_buildlog.dat
@echo off
goto end

:test_build

@echo on
echo #define DOWNLOAD_SOURCE "test" > ..\..\Shared\DownloadSource.h
devenv ..\..\AdPlugin.sln /rebuild "Release Test"
"%pathAdvancedInstaller%\AdvancedInstaller.com" /edit adblock.aip /SetVersion %version%
"%pathAdvancedInstaller%\AdvancedInstaller.com" /rebuild adblock.aip
copy adblock.msi downloadfiles\simpleadblocktest.msi

echo #define DOWNLOAD_SOURCE "update" > ..\..\Shared\DownloadSource.h
"%pathAdvancedInstaller%\AdvancedInstaller.com" /edit adblockupdate.aip /SetVersion %version%
"%pathAdvancedInstaller%\AdvancedInstaller.com" /rebuild adblockupdate.aip
copy adblockupdate.msi downloadfiles\simpleadblocktestupdate.msi

echo %version%;%release%;%date%;%1;%comment% >> installers\simpleadblock_buildlog.dat
@echo off
goto end

:dev_build
@echo on
echo #define DOWNLOAD_SOURCE "dev" > ..\..\Shared\DownloadSource.h
devenv ..\..\AdPlugin.sln /rebuild "Release Development"
"%pathAdvancedInstaller%\AdvancedInstaller.com" /edit adblock.aip /SetVersion %version%
"%pathAdvancedInstaller%\AdvancedInstaller.com" /rebuild adblock.aip
copy adblock.msi downloadfiles\simpleadblockdevelopment.msi

echo #define DOWNLOAD_SOURCE "update" > ..\..\Shared\DownloadSource.h
"%pathAdvancedInstaller%\AdvancedInstaller.com" /edit adblockupdate.aip /SetVersion %version%
"%pathAdvancedInstaller%\AdvancedInstaller.com" /rebuild adblockupdate.aip
copy adblockupdate.msi downloadfiles\simpleadblockdevelopmentupdate.msi

echo %version%;%release%;%date%;%1;%comment% >> installers\simpleadblock_buildlog.dat
@echo off
goto end

:prod_build_sites
:: LOOP SITE INSTALLERS
@echo on
FOR /L %%i IN (1 1 10) DO (
     echo #define DOWNLOAD_SOURCE "%%i" > ..\..\Shared\DownloadSource.h
     devenv ..\..\AdPlugin.sln /rebuild "Release Production"
     "%pathAdvancedInstaller%\AdvancedInstaller.com" /edit adblock.aip /SetVersion %version%
     "%pathAdvancedInstaller%\AdvancedInstaller.com" /rebuild adblock.aip
     copy adblock.msi downloadfiles\simpleadblock-%%i.msi
)            
@echo off
goto end

:end
echo #define DOWNLOAD_SOURCE "test" > ..\..\Shared\DownloadSource.h
@echo on