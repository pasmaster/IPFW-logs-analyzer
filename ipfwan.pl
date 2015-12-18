
# IPFW log analizer
# Version 2015-12-17-10-55

print "IPFW log analizer\n"; 
print "Version 2015-12-18-11-25\n"; 

$sNameFileIn=$ARGV[0];
$sNameFileOutCounts=$ARGV[1];
$sNameFileOutRecords=$ARGV[2];

%hashCounts = ();
 
open(FIN, $sNameFileIn);
open(my $FOUTCOUNTS, '>', $sNameFileOutCounts);
open(my $FOUTRECORDS, '>', $sNameFileOutRecords);

while(<FIN>)
{

	$str=$_;
	$sIPAdress="";
	$iVolume=0;
	
	print $str;
	
	$iPositionCount1 = index($str, "count ip from not");
	$iPositionCount2 = index($str, "count ip from any to");
	
	if ($iPositionCount1+$iPositionCount2>0) {
		@Fields=split(" ", $str);
		if ($iPositionCount1>0) {
			$sIPAdress=@Fields[9];
		}
		else {
			$sIPAdress=@Fields[8];
		}
		$iVolume=int(@Fields[2]);

		if ($iVolume > 0) {
			print $FOUTRECORDS "$sIPAdress;$iVolume\n"; 
			if(exists($hashCounts{$sIPAdress})){
				$hashCounts {$sIPAdress} = $hashCounts {$sIPAdress} + $iVolume;
			}
			else{			
				$hashCounts {$sIPAdress} = $iVolume;				
			}
		}	
	}
}

foreach $key(sort keys %hashCounts){
	print $FOUTCOUNTS "$key;$hashCounts{$key}\n"; 
}

close FIN;
close FOUTCOUNTS;
close FOUTRECORDS;

