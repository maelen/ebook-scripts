#!C:\Perl\bin\perl.exe

use File::Path;
use File::Copy;
use Cwd;
use URI::File;

my $sevenZip="\"C:\\Program Files (x86)\\7-Zip\\7z.exe\"";
my $openoffice="\"C:\\Program Files (x86)\\OpenOffice.org 3\\program\\soffice.exe\"";
#$convertLIT="\"C:\\Program Files (x86)\\ConvertLIT GUI\\clit.exe\"";
my $convertEbook="\"C:\\Program Files (x86)\\Calibre2\\ebook-convert.exe\"";
my $metaEbook="\"C:\\Program Files (x86)\\Calibre2\\ebook-meta.exe\"";
my $tempFolder="C:/Temp/Extract";
my $newFolder="C:/Temp/New";
my $currentFolder;
my $authorName;

sub processFolder
{
   my ($folder,$level) = @_;
   
   $level++;
   print "Level: $level\n";
   if($folder eq "")
   {
      $folder = ".";
   }
   opendir(DIR, $folder);
   my @fileList= readdir(DIR);
   closedir(DIR);
   
   #print "Process folder: $folder\n";
   #print "Process folder: @fileList\n";
   foreach my $file (@fileList)
   {
      #print "$file\n";
      if( -d "$folder/$file" )
      {
         if( $file !~ /\.$/ && $file !~ /\.\.$/ )
         {
            print "Processing folder: $folder/$file\n";
            if($level==1 || $level==2)
            {
               if( ! -d "$newFolder/$folder/$file")
               {
                  mkdir "$newFolder/$folder/$file" or die "Can't create $newFolder/$folder/$file\n";
               }
               if($level==2)
               {
                  $currentFolder = "$newFolder/$folder/$file";
                  $authorName = $file;
               }
            }
            processFolder("$folder/$file",$level);
            print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
         }
      }
	   else
	   {
         print "Processing file: $folder/$file\n";

         # if($level==3)
         # {
            # $currentFolder = "$newFolder/$folder";
            # $authorName = $folder;
            # $authorName =~ s/^.+\///;;
            # #print "Current Folder: $currentFolder\n";
         # }
         processFile("$folder/$file");	  
	   }
   }
}

sub processFile
{
   my $file = "@_";
   
   # If zip file
   if($file =~ /^.+\.zip/ || $file =~ /^.+\.rar/)
   {
      # Decompress file
      unCompressFile($file);
      processFolder($tempFolder,4);
      rmtree( $tempFolder ) || die "Can't empty $tempFolder\n";
      mkdir($tempFolder);
   }
   elsif($file =~ /^.+\.lit/ || $file =~ /^.+\.fb2/ || $file =~ /^.+\.pdb/ ||
         $file =~ /^.+\.pdf/ || $file =~ /^.+\.rtf/ || $file =~ /^.+\.txt/ ||
         $file =~ /^.+\.htm/ || $file =~ /^.+\.html/ )
   {
      #copy($file,"$currentFolder") || die "Can't copy to $currentFolder\n";
      my $fileNoPath = $file;
      $fileNoPath =~ s/^.+\///; # Keep only filename
      my $author = $authorName;
      $author =~ s/_/ /g; # Remove underline
      $author =~ s/(.+?)\s*,\s*(.+)(\s+&+)*/$2 $1/g; # Flip Lastname and first name
      my $title = $fileNoPath;
      $title =~ s/_/ /g; # Remove underline
      $title =~ s/^.+?\s+-\s+//; # Remove everything before the dash
      $title =~ s/\..+$//; # Remove extension
      my $fileExt = $fileNoPath;
      $fileExt =~ s/^.*(\..+)$/$1/;
      #print "FileExtension: $fileExt\n";
      #my $authorLastName = $authorName;
      #$authorLastName =~ s/(^.+?),* .+$/$1/;
      
      print "$convertEbook \"$file\" \"$currentFolder/$author - $title$fileExt.epub\" --preserve-cover-aspect-ratio\n";
      print `$convertEbook \"$file\" \"$currentFolder/$author - $title$fileExt.epub\" --preserve-cover-aspect-ratio\n` . "\n";
      
      # if there is no medadata generate it
      print "$metaEbook \"$currentFolder/$author - $title$fileExt.epub\"\n" . "\n";
      my $meta = `$metaEbook \"$currentFolder/$author - $title$fileExt.epub\"`;
      print "$meta\n";
      #print "Meta Search: $author\n";
      if ( $meta !~ /Author\(s\).+$author/mi)
      {
         print "$metaEbook \"$currentFolder/$author - $title$fileExt.epub\" -a \"$author\" -t \"$title\" \n";
         print `$metaEbook \"$currentFolder/$author - $title$fileExt.epub\" -a \"$author\" -t \"$title\" \n` . "\n";
      }      
      print "---------------------\n";
   }
}

# Remember to include full path with 
# filename for $1 and to omit extension
# sub convertFileWithOO()
# {
   # my $filename = "%22" . getcwd() . "@_" . "%22";
   # $filename =~ s/\//\\/g;
   # #$filename =~ s/,/\\,/g;
   # print "Converting $filename with OpenOffice\n";
   # print `$openoffice -invisible  \"macro:///Standard.MyConversions.SaveAsPDF($filename)\"`;
# }

sub unCompressFile
{
   my $file = "@_";
   print "Uncompress $file\n";
   print `$sevenZip x -y \"$file\" -o$tempFolder\n` . "\n";
}

mkdir($tempFolder);
mkdir($newFolder);
# Go through all folders
processFolder(".",0);