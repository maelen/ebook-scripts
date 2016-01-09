#!C:\Perl\bin\perl.exe

use File::Path;
use File::Copy;
use File::Copy::Recursive qw(dircopy);

$pdfTk_bin="\"C:\\util\\pdftk\\bin\\pdftk.exe\"";

#open FILE, ">", "log.txt" or die $!;

sub processFolder
{
   my $folder = "@_";
 
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
            processFolder("$folder/$file");
         }
      }
	   else
	   {
         print "Processing file: $folder/$file\n";
         processFile("$folder/$file");	  
	   }
   }
}

sub processFile
{
   my $file = "@_";
   open META, ">metadata.txt";
   
   # If pdf file
   if($file =~ /^.+\.pdf/)
   {
      # Split filename
      $file =~ /^.+\/(.+?)(\s-\s)(.+)\.pdf$/;
      my $fileNameNoExt = $1 . $2 . $3;
      my $authorName = $1;
      my $title = $3;
      print META  "InfoKey: Author\n" . 
                  "InfoValue: $authorName\n" .
                  "InfoKey: Title\n" .
                  "InfoValue: $title\n" .
                  "InfoKey: Subject\n" .
                  "InfoValue: \n" .
                  "InfoKey: Creator\n" .
                  "InfoValue: \n" .
                  "InfoKey: Producer\n" .
                  "InfoValue: \n" .
                  "InfoKey: Keywords\n" .
                  "InfoValue: \n";
      
      #print "Filename: $fileNameNoExt ";
      print "authorName: $authorName\n";
      print "title: $title\n";
      copy($file,"$file\.bak");
      print `$pdfTk_bin \"$file\.bak\" update_info \"metadata.txt\" output \"$file\"\n` . "\n";
      unlink "$file\.bak";
      print "---------------------\n";
   }
   close META;
   unlink "metadata.txt"
}

# Go through all folders
processFolder();
