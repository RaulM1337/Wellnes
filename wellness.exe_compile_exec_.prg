CLOSE ALL
CLEAR ALL
CLEAR
WAIT WINDOW 'COMPILING - please wait' NOWAIT
DO "C:\Users\Developer\Desktop\wellness_src\3\wellness.exe_compile_data_.prg"
SET BELL TO ('C:\Windows\Media\tada.wav')
?? CHR(7)
WAIT WINDOW 'FINISHED'
QUIT
