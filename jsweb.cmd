@echo off
set classpath=out\artifacts\NXLG_war_exploded\WEB-INF\classes
set libpath=out\artifacts\NXLG_war_exploded\WEB-INF\lib
java -Dfile.encoding=UTF-8 -classpath "%libpath%\*;%classpath%" com.liuzg.jsweb.cli.Main "web" %1 "%2"