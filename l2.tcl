set ns [new Simulator]
set tf [open l2.tr w]
$ns trace-all $tf

set nf [open l2.nam w]
$ns namtrace-all $nf
set cwind [open win2.tr w]

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n2 15Mb 5ms DropTail
$ns duplex-link $n1 $n2 15Mb 5ms DropTail
$ns duplex-link $n2 $n3 15Mb 5ms DropTail
$ns duplex-link $n3 $n4 15Mb 5ms DropTail
$ns duplex-link $n3 $n5 15Mb 5ms DropTail

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link-op $n3 $n5 orient right-down

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set tcp1 [new Agent/TCPSink]
$ns attach-agent $n5 $tcp1
$ns connect $tcp0 $tcp1

set tcp2 [new Agent/TCP]
$ns attach-agent $n1 $tcp2

set tcp3 [new Agent/TCPSink]
$ns attach-agent $n4 $tcp3
$ns connect $tcp2 $tcp3

set ftp [new Application/FTP]
set teln [new Application/Telnet]

$ftp attach-agent $tcp0
$teln attach-agent $tcp2

$ns at 0.2 "$ftp start"
$ns at 0.4 "$teln start"
$ns at 2.0 "$ftp stop"
$ns at 2.2 "$teln stop"

proc plotWindow {tcpSource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "plotWindow $tcpSource $file"}
$ns at 1.0 "plotWindow $tcp0 $cwind"
$ns at 1.0 "plotWindow $tcp2 $cwind"

proc finish {} {
global ns tf nf
$ns flush-trace
close $tf 
close $nf
exec nam l2.nam &
exit 0
}


$ns at 6.0 "finish"
$ns run

