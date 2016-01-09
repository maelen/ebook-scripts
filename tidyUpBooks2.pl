#!C:\Perl\bin\perl.exe

use File::Path;
use File::Copy;
use Cwd;
use URI::File;

# Iterate through A to Z folders
# Go in letter folder
# go in each author folder
# Remember author folder
# Extract archives in subfolder
# Rename files that have the same name
# Merge subfolder with author folder
# Process pdfs
#    Run through spelling checker  and give a quality number
# Process lit files
#   Convert, run through spelling checker and give a quality number
# Process rtf files
#    Run through spelling checker and give a quality number
# Process fb2 files
#    Run through spelling checker and give a quality number
# Process htm files
#    Run through spelling checker and give a quality number

$sevenZip="\"C:\\Program Files (x86)\\7-Zip\\7z.exe\"";
$openoffice="\"C:\\Program Files (x86)\\OpenOffice.org 3\\program\\soffice.exe\"";
$convertLIT="\"C:\\Program Files (x86)\\ConvertLIT GUI\\clit.exe"";

print "TidyUp books \n";

#Get list of folders
my @currentFolder = <*>;
my @letterFolder;
my @authorFolder;

# #Unzip letter archives 
# foreach my $file (@currentFolder)
# {
   # print "FILE: $file\n";
   # if($file =~ /^.+\.rar$/ )
   # {
      # unCompressFile($file)
   # } 
# }

@currentFolder = <*>;

#Find letter and author folders 
foreach my $letterFolder (@currentFolder)
{
   if( -d $letterFolder )
   {
   print "letterFolder $letterFolder\n";
   my @fileList = <$letterFolder/*>;
   
   foreach my $authorFolder (@fileList)
   {
      if( -d $authorFolder )
      {
         processFolder("$authorFolder");
      }
   }
   } 
}

sub processFolder()
{
   my $folder = "@_";

   my @fileList = <"$folder/*">;

   print "Process folder: $folder\n";
   
   foreach my $file (@fileList)
   {
      if( -d "$file" )
      {
         print "Processing folder: $file\n";
         processFolder("$authorFolder/$file");
      }
	  #elsif( -f "$file" )
	  else
	  {
         print "Processing file: $file\n";
         processFile("$authorFolder/$file");	  
	  }
   }
}

sub processFile()
{
   my $file = "@_";

   # If pdf file
   if($file =~ /^.+\.rtf/        ||
         $file =~ /^.+\.doc/)
   {
      # Convert file
      convertFileWithOO(($file))
      # Spell check
      # Rename
      # Move to author folder
   }
   else
   {
      # Process lit files
      print "Converting $file with Calibre\n";
      print `$convertLIT $file explodeFolder\n`;      
      # Run through spelling checker  and give a quality number
   }
}

# Remember to include full path with 
# filename for $1 and to omit extension
sub convertFileWithOO()
{
   my $filename = "%22" . getcwd() . "@_" . "%22";
   $filename =~ s/\//\\/g;
   #$filename =~ s/,/\\,/g;
   print "Converting $filename with OpenOffice\n";
   print `$openoffice -invisible  \"macro:///Standard.MyConversions.SaveAsPDF($filename)\"`;
}

sub unCompressFile()
{
   my $file = "@_";
   print "uncompress $file\n";
   print `$sevenZip x -y \"$file\"\n` . "\n";
}

#------------------------------------------------------------------
# Old code
#------------------------------------------------------------------

# # Get List of files
# foreach my $folder(@updateFolder)
# {
   # #Get list of files
   # my @fileList = <"$folder/*">;
   # foreach my $file (@fileList)
   # {
      # if($file =~ /^.+\.pdf$/)
      # {
         # #Remove path
         # $filename = $file;
         # $filename =~ s/.*\///;
         # #Extract author
         # ($author) = split (/\s*-\s*/,$filename);
         # #Find first letter of author
         # my $letter = substr ($author,0,1);
         # if($letter =~ /[A-Za-z]/)
         # {
            # #Create author folder if necessary
            # my $authorFolder = $classifiedFoldersLookup{$letter} . "/$author";
            # if(! -e $authorFolder )
            # {
               # mkdir $authorFolder or die "Can't create folder$!\n";
            # }
            # #Move file in folder
            # print "Moved to $authorFolder/$filename\n";
            # rename($file,"$authorFolder/$filename") or die "Failed to move $file: $!\n";
         # }   

      # }   
   # }
# }
