#####################
https://www.geeksforgeeks.org/file-handling-in-r-programming/
  library(dplyr)  


1 
Use getwd() function to check filepath to your 
current working directory, what type of data
function getwd() returns? Can you store its output to variable? Notice
that "/" is used as a directory separator


getwd()
typeof(getwd())
Output is character which can be assigned to variable.


#####################
2 
setwd() function sets new working directory.
If you perform operations over files located in
working directory , there is no need to specify absolute path.
To set working directory , use absolute path.
First, specify argument as character, ex. setwd("dirname").
For second task,assign directory name to variable and
use it as input for setwd()

setwd("C:\Users\LENOVO\Desktop\Code_Horoso\R_practice")
Remember that R uses linux like forward slashes
,while windows uses backslashes or double backslashes
That why you may encounter error.

text "C:\Users\LENOVO\Desktop\Code_Horoso\R_practice" 
is not possible due to presence of escape character ""\""

It is also impossible to assign it to variabe
file_path_1<-"C:\Users\LENOVO\Desktop\Code_Horoso\R_practice"

Solution is the following, manually change backslashes
to forward slashes

setwd("C:/Users/LENOVO/Desktop/Code_Horoso/R_practice")

We can try to use gsub() to format Windows path, if
it was directly copied from Windows Address bar:
  gsub("\\","/","C:\Users\LENOVO\Desktop\Code_Horoso\R_practice",fixed=TRUE )
Unfortunately, it is not appropriate as backslashes 
in file path string are treated as escape symbols.

To transform it into named vector, we require to 
double backslashes them all
setwd("C:\\Users\\LENOVO\\Desktop\\Code_Horoso\\R_practice")
but again, here we manually switch to double backlashes.

Please note that if directory undicated as argument
of setwd() does not exist, "cannot change working directory"
message appears.

We need to solve the following , how to use
copied file path from Windows as input
for setwd() ,threfore, we need to specify
raw e string , which is possible
with later 4.0 R version with "r" keyword
r"(C:\Users\LENOVO\Desktop\Code_Horoso\R_practice)"
Expression will add double backslashes and it means we can 
combine "r" and setwd()

setwd(r"(C:\Users\LENOVO\Desktop\Code_Horoso\R_practice)")


#3 
Run list.files() to generate vector of files names in your 
current working directory, what type of data 
list.files() generates?
  
  setwd( r"(C:\Users\LENOVO\Desktop\R_Input)" )
typeof( list.files() )


#4 
Run list.files() with path argument
diferent from working directory.
You can use any folder for which
you have access.

list.files(r"(D:\Sample_Templates\ML_Code_Python)") #or
list.files("D:/Sample_Templates/ML_Code_Python")


#5 
USe file.create() function to create
15 files running the following code:
  
  file.create( paste("File",sample(c("regression_log"),15,replace=TRUE),
                     sample(1:15,15,replace=TRUE),sep="_") )
Code should randomly generate
15 files with diffetent names.
Why we creted less that 15 files?
  
  Notice,  sample(1:15,15,replace=TRUE) means that
ocassionally same numbers would be generated,because
we sample with replacement, therefore, we would
ocassionally generate files with the same name in 
same directory

paste("File",sample(c("regression_log"),15,replace=TRUE),
      sample(1:15,15,replace=TRUE),sep="_") 

paste("File",sample(c("regression_log"),15,replace=TRUE),
      sample(1:15,15,replace=TRUE),sep="_") %>% duplicated() %>% any()

But Windows cant keep files of same name and extention in
same directory, consequently,
only files with unique names would be displayed, 
and we would create less that 15 files.

Therefore, sample(1:15,15,replace=FALSE)
is used to make all files names unique, because non out of 15
numbers are repeated



#6
USe file.create() function to create
15 files replicating the following example:
  
  file.create( paste("File",sample(c("delete","keep","modify"),15,replace=TRUE),
                     sample(1:15,15,replace=FALSE),sep="_") )
Why we manages to create all 15 files?
  
  All names we generate are unique due to 
sample(1:15,15,replace=FALSE), we consequently generate
files and designate unique names.


#7 
Modify list.files() function to return absolute paths
of files located in working directory
by adjusting full.names argument

list.files(path=r"(C:\Users\LENOVO\Desktop\Code_Horoso\R_practice)",
           full.names=TRUE)  


#8
list.files() function offers pattern argument
which allows to specify pattern used to select files
for output vector.
Only files names which match the pattern will be returned.

list.files(path=r"(C:\Users\LENOVO\Desktop\Code_Horoso\R_practice)",
           pattern="delete|[2,4,6]")

If we are referring to files in working directory,
full path is not required

list.files(pattern="delete|[2,4,6]")



#9 
Run following 2 commands
file.create( paste("File","DELETE",10) )

list.files(path=r"(C:\Users\LENOVO\Desktop\Code_Horoso\R_practice)",
           pattern="delete|[2,4,6]")

Last Expression Will not return File_DELETE_4.csv as by default,
list.files() is case sensitive, modify 
ignore.case argument to return all names ingoring case
which fit our pattern

list.files(path=r"(C:\Users\LENOVO\Desktop\Code_Horoso\R_practice)",
           pattern="delete|[2,4,6]",ignore.case = TRUE)


#10
file.choose() allows to choose file name interactively
Run file.choose(), which directory is initiated to 
select file?
  
  Next, change working directory
to the one you prefer and 
run file.choose again 
setwd(r"(D:\Sample_Templates\ML_Code_Python)")
getwd()
file.choose()

file.choose() commands now opens another directory
which we previously marked as working. 



#10
After file is interactively selected with file.choose()
,R return its full name, which can be assigned to
variable and later used in code to specify which file to call for
f1_name<-file.choose()
read.csv(f1_name) # can be used to upload data

use file.choose() to select file you prefer and store its 
name in variable_1

variable_1<-file.choose()
read.csv(f1_name)


#11
use file.create() to create 3 files 
named Dummy_file with extensions csv,xlsx,txt
in working directory

setwd(r"(C:\Users\LENOVO\Desktop\Code_Horoso\R_practice)")
file.create("Dummy_file.csv")
file.create("Dummy_file.xlsx")
file.create("Dummy_file.txt")


#12

setwd(r"(C:\Users\LENOVO\Desktop\Code_Horoso\R_practice)")
In single expression with
file.create(), create 2 files in working dorectory of
different type, use comma to separate 
files names

file.create("Dummy_file.csv","Dummy_file.xlsx")



##13
Run the following command to create
directory in working directory
dir.create("Dummy_Dir")
Modify  example from  ex. 5 to create 20
files which randomly define names and file extentions
[txt, csv, xlsx]
Files should be created in Dummy_Dir

file.create( paste("Dummy_Dir/","File",sample(c("delete","keep","modify"),
                                              20,replace=TRUE),
                   sample(1:20,20,replace=FALSE),
                   sample(c(".txt",".csv",".xlsx"),20,replace=TRUE),
                   sep="_")   )

##14
Use paste() function to 
concatenate file path and file name to specify location 
of directory in which file should be created

setwd(r"(C:\Users\LENOVO\Desktop\Code_Horoso\R_practice)")
paste(r"(C:\Users\UACecetoAl\Desktop\R_Input\1_Code Sample)","Dummy_file.csv",
      sep="\\")
file.create( paste(r"(C:\Users\LENOVO\Desktop\Code_Horoso\R_practice)","Dummy_file.csv",
                   sep="\\")  ) 

#15
Use file.create() function to create 2 files of any extention you prefer in 
2 directories , except workig direcitry

file.create( paste(r"(D:\Sample_Templates\ML_Code_Python)","Dummy_file.csv",sep="\\"),
             paste(r"(D:\Sample_Templates\Music_Collection)","Dummy_file.csv",sep="\\") ) 

#Notice that if directory does not exist 'No such file or directory'
message appears


#16

file.exists()
returns a logical vector indicating whether the file exists.
Answer can be given only for files for which access is granted 
getwd()
file.exists("C:\\Users\\LENOVO\\Desktop\\Code_Horoso\\R_practice\\Dummy_File_Empty.csv")

##17
Write code which check if 2 specific files exists in working directory
file.exists("Sample_File_1.csv","Code_Obsolete_Delete.txt")


##18
Check if 2 files exist in 2 different directories, non of which is working
directory

file.exists(r"(C:\Users\CodeHoroso\Desktop\Phone_Data\Calendar\8E6B3063.jpg)",
            r"(C:\Users\CodeHoroso\Desktop\cv\Keywords.docx)" )
# now manually write wrong name for any file and check how output changes
file.exists(r"(C:\Users\CodeHoroso\Desktop\Phone_Data\Calendar\QQE6B3063.jpg)",
            r"(C:\Users\CodeHoroso\Desktop\cv\Keywords.docx)" )



#19
file.create() and file.exist  will produce 
warning message is we apply action to 
directory we dont have access to

file.create( r"(U:\Projects\Confidential\Dummy.csv)" ) #returns reason 'Permission denied'
file.exists( r"(U:\Projects\Confidential\Dummy.csv)" )  # returns False


#20
file.remove() fucntion attempts to remove files indocated as arguments,
to  perform removal, access to files should be granted,
by default file is checked in working directory
file.create("DUMMY.csv")

Use file.remove() to remove DUMMY.csv from working directory
file.remove("DUMMY.csv")
be aware that file is deleted permanently, 
trash bin wont contain respective file


#21
Run the command 

file.create( paste("Dummy_Dir/","File",sample(c("delete","keep","modify"),20,replace=TRUE),
                   sample(1:20,20,replace=FALSE),
                   sample(c(".txt",".csv",".xlsx"),20,replace=TRUE),
                   sep="_")   )
Use list.files() with patterm
argument to define expression which deletes files whose names mathes 
pattern _File_delete_

setwd( r"(C:\Users\LENOVO\Desktop\Code_Horoso\R_Practice\Dummy_Dir)" )
getwd()
list.files( pattern="_File_delete_" )
file.remove(   list.files( pattern="_File_delete_" )      )


#22
Use file.remove() to delete files in 2 complately different directories
,except working directory
file.remove(r"(C:\Users\CodeHoroso\Desktop\Phone_Data\Calendar\8E6B3063.jpg)",
            r"(C:\Users\CodeHoroso\Desktop\cv\Keywords.docx)" )




#23
setwd( r"(C:\Users\LENOVO\Desktop\Code_Horoso\R_Practice\Dummy_Dir)" )
getwd()

Run the code to perform the following actions, if DUMMY.csv
is present in workig directory, 
delete it, otherwise, create it

if ( file.exists("Dummy.csv")==TRUE ) {
  file.remove("Dummy.csv")
}  else { file.create("Dummy.csv") }



#24
Let us check if file.create( ) is case sensetive

file.create("DuMmY.csv")
file.create("Dummy.csv")
file.create("dummy.csv")
Only single file is created, 
name is the same as for first file.create("DuMmY.csv"),
names generated later by 
file.create("Dummy.csv")
file.create("dummy.csv") are all treated 
as identical to DuMmY.csv are are ignored.

Therefore, I recommend to 
distinguish files by different names, not different cases



#25
file.exists() is not case sensetive, we need to adjust 
ingore.case argument
file.exists("Dummy.csv",ignore.case =TRUE)
file.exists("DUMMY.csv",ignore.case=TRUE)

DummY.csv and ignore.case = FALSE are both considered as files names,
we cant supply ignore.case argument, it is available only for list.files().
Case-insensitive file systems are common on Windows and macOS.

sample(   c( file.create("DuMmY.csv"), 
             file.create("Dummy.csv"),
             file.create("dummy.csv") ),1)
We create random files with names different by cases
We need to check , what name was designated.

Solution is to call for list.files
c("Dummy.csv","DuMmY.csv","dummy.csv") %in% list.files(ignore.case = FALSE)
Generally, file.remove(), file.create(), file.exists()
behave like case insensetive system.


#26
Run series of commands
getwd()
file.create("I_Dont_like_my_name.csv")
file.create("Dummy_file_2.csv")
Use file.rename() function to rename
file I_Dont_like_my_name.csv to his_name_is_Better.csv, 2 arguments are required, 
first full path to the file with original name,
same path to the file with new name
file.rename(r"(C:\Users\LENOVO\Desktop\Code_Horoso\R_Practice\Dummy_Dir\I_Dont_like_my_name.csv)",
            r"(C:\Users\LENOVO\Desktop\Code_Horoso\R_Practice\Dummy_Dir\This_name_is_Better.csv)")

file.rename("I_Dont_like_my_name.csv",
            "This_name_is_much_Better.csv")
second expression works if we are dealing with files in working directory,
otherwise , full name specification is required as R does not in advance other
directories except working



#27
Run following commands

file.create( paste("File",sample(c("delete","keep","modify"),20,replace=TRUE),
                   sample(1:20,20,replace=FALSE),
                   sample(c(".txt",".csv",".xlsx"),20,replace=TRUE),
                   sep="_")   )

Now rename files which contain "delete" to "Pending_Status",
list.files() would be helpfull,
Dont forget that files with same names and
extentions are not possible in same directory

getwd()
list.files(pattern="delete")
file.rename( list.files(pattern="delete"),"Pending_Status.csv"   )
# will not work as we get multiple values for list.files(pattern="delete"),
and single value for "to" argument, recycling rule does not applies here


While loop would be a better choice
n<-length( list.files(pattern="delete") )
i<-1
names_list<-list.files(pattern="delete")
while (i<=n)  {
  file.rename( names_list[i], paste("Pending_Status",i,sep="_")     )
  i<-i+1
}


#28
file.create("mtcars.csv")
write.csv(mtcars,"mtcars.csv")

Now use file.rename() function to change the extention of file 
from csv to txt, and check how transformation affected 
data in mtcars

file.rename("mtcars.csv","mtcars.txt")


# 29
Asume path name
path_1<-r"(C:\Users\CodeHoroso\Desktop\R_Input\Dummy_Dir\File_keep_19_.csv)"

Now use gregexpr function to extract name of file

loc<-tail( gregexpr("\\\\",path_1)[[1]] ,1)+1
substr( path_1,loc,nchar(path_1) )


# 30
Asume path name
path_1<-r"(C:\Users\UACecetoAl\Desktop\R_Input\Dummy_Dir\File_keep_19_.csv)"

Use
basename() to extract file name

basename(path_1)


#31
Use file.copy() to copy file from working directory to folder located in 
working directory 
setwd("C:/Users/LENOVO/Desktop/Code_Horoso/R_Practice")

file.copy("Dummy_Copy.xlsx","Dymmy_Dir/Dummy_Copy.xlsx")


#32
USe file.copy() to copy file from working directory to folder outside working 
directory, rememberworking directory
file.copy("Dummy_Copy.xlsx",
          "D:/Sample_Templates/ML_Code_Python/Dummy_Copy.xlsx")

#33
Use file.copy() to copy file from non working directory to 
another working directory

file.copy("D:/Sample_Templates/ML_Code_Python/Dummy_Copy.xlsx",
          "D:/Sample_Templates/Music_Collection/Dummy_Copy.xlsx")


#34
Now assume destination directory already contains file with
name Dummy_Copy.xlsx, now check if the file is replaced if anothe file with 
same name is copied to destination directory.


file.copy("Dummy_Copy.xlsx","Dummy_Dir/Dummy_Copy.xlsx")

You can see by modification date that after we run
command nothng changes, file with the same name is not overwritten

#35
Now modify file.copy() with overwrite = TRUE, to replace 
file with the same name
file.copy("Dummy_Copy.xlsx","Dummy_Dir/Dummy_Copy.xlsx",overwrite = TRUE)

Now we overwrite file in destination directory




