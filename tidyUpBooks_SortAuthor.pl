#!C:\Perl\bin\perl.exe

use File::Path;
use File::Copy::Recursive qw(dircopy);

#Get list of folders
my @currentFolder = <*>;

#Find classified folders
foreach my $folder (@currentFolder)
{
   if($folder =~ /^Science Fiction and Fantasy (([A-Z]-?)+)$/)
   {
      @files = <"$folder/*">;
         foreach my $file (@files)
         {
            print "$file \n";
            if (-d $file)
            {
               #Split name
               # 
               my @names = split("& ",$file);
               $names[$i] =~ /\/(.+)\s+(\w+)\s*\W*\s*$/x;
               my $firstname = $1;
               my $lastname = $2;
               my $newFolderName = "$lastname, $firstname";
               for(my $i=1; $i<scalar(@names);$i++)
               {
                   $newFolderName =  $newFolderName . " & $names[$i]";
               }
               $newFolderName =~ s/\.+$//;
               print "$newFolderName \n";
               
               dircopy($file,"../authors/$newFolderName")
            }
         }
   } 
}
