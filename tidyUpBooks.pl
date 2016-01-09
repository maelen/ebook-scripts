#!C:\Perl\bin\perl.exe

use File::Path;
use File::Copy;

#Get list of folders
my @currentFolder = <*>;
my @updateFolder;
my %classifiedFoldersLookup;

#Find update folders 
foreach my $folder (@currentFolder)
{
   if($folder =~ /^Science Fiction and Fantasy 13130 update \d+$/)
   {
      push(@updateFolder, $folder);
   } 
}

#Find classified folders
foreach my $folder (@currentFolder)
{
   if($folder =~ /^Science Fiction and Fantasy (([A-Z]-?)+)$/)
   {
      my $letters = $1;
      my @letterList = split(/-/,$letters);
      #Keep letter to folder lookup in hash
      foreach my $letter (@letterList)
      {
         $classifiedFoldersLookup{$letter} = $folder;
      }
   } 
}

# Get List of files
foreach my $folder(@updateFolder)
{
   #Get list of files
   my @fileList = <"$folder/*">;
   foreach my $file (@fileList)
   {
      if($file =~ /^.+\.pdf$/)
      {
         #Remove path
         $filename = $file;
         $filename =~ s/.*\///;
         #Extract author
         ($author) = split (/\s*-\s*/,$filename);
         #Find first letter of author
         my $letter = substr ($author,0,1);
         if($letter =~ /[A-Za-z]/)
         {
            #Create author folder if necessary
            my $authorFolder = $classifiedFoldersLookup{$letter} . "/$author";
            if(! -e $authorFolder )
            {
               mkdir $authorFolder or die "Can't create folder$!\n";
            }
            #Move file in folder
            print "Moved to $authorFolder/$filename\n";
            rename($file,"$authorFolder/$filename") or die "Failed to move $file: $!\n";
         }   

      }   
   }
}
