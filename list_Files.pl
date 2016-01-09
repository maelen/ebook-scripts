#!C:\Perl\bin\perl.exe

use File::Path;
use File::Copy::Recursive qw(dircopy);

#Get list of folders
my @currentFolder = <*>;

open FILE, ">", "log.txt" or die $!;

#Find classified folders
foreach my $folder (@currentFolder)
{
   @files = <"$folder/*">;
   foreach my $file (@files)
   {
      $file =~ /^.+\/(.+)$/;
      print FILE "$1\n";
   }
}
