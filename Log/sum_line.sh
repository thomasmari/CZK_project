PATH = '/home/Foo/Documents/Programs/ShellScripts/Butler'
SUBPATH = ''
awk '{s+=$1}NR%nb_line==0{print s;s=0}' file
