BEGIN{
	ftpsize=0;
	telnetsize=0;
	totalsize=0;
	}
{
if($1=="r" && $5=="tcp" && $4=="4")
	telnetsize+=$6;
if($1=="r" && $5=="tcp" && $4=="5")
	ftpsize+=$6;
totalsize=ftpsize+telnetsize;
}
END{
printf("Throughput in MBPS= %d\n",(totalsize*8)/1000000);
}
 
