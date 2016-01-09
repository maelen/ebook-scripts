#!C:\Perl\bin\perl.exe

use File::Path;
use File::Copy;

#Get list of folders
my @currentFolder = <*>;
my @updateFolder;
my %classifiedFoldersLookup;
my $combinedFolder;

#Find update folders 
foreach my $folder (@currentFolder)
{
   if($folder =~ /^SFF Update \d+[A-Z]*$/)
   {
      push(@updateFolder, $folder);
   } 
}

$combinedFolder = "Science Fiction and Fantasy in PDF format";

# Get List of files
foreach my $folder(@updateFolder)
{
   print "\nCurrent Folder: $folder\n";
   #Get list of files
   my @fileList = <"$folder/*">;
   foreach my $file (@fileList)
   {
      if($file =~ /^.+(\.pdf|\.epub|\.pdf$|\.mobi|\.txt|\.rtf|\.lit|\.doc|\.htm|\.lrf|\.odt)/)
      {
        #Remove path
        $filename = $file;
        $filename =~ s/.*\///;
        #Extract author
        ($author) = split (/\s*-\s*/,$filename);
        #Create author folder if necessary
        my $authorFolder = $combinedFolder . "/$author";
        if(! -e $authorFolder )
        {
           print "mkdir $authorFolder\n";
           mkdir $authorFolder or die "Can't create folder$!\n";
        }
        #Move file in folder
        print "Moved to $authorFolder/$filename\n";
        rename($file,"$authorFolder/$filename") or die "Failed to move $file: $!\n";
      }   
   }
}
