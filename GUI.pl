# created by Austin Dixon
#
# script controls arduino by sending a 5 bit packet to arduino via serial.
#
# $command "1" tells arduino that $data controls on/off function. 1 for on, 2 for off.
# $command "2" tells arduino that $data controls power level, which is derrived from scale value.
# the "Send" button sends the Power Level packet to arduino.


#! usr/local/bin/perl
use Tkx;
use LWP::Simple;

#SETUP

$hex55 = "0x55";
$address = "9999"; 	# arduino address
$seq = "0";			# start sequence at 0
$file = 'output.txt'; # output txt file for testing

#-------------------------------------------------
# sub routine 1

sub runSubRoutine1 {

$command = "1";
$data = "1";
$checksum = $seq + $command + $data;

$output = $hex55 . $address . $command . $data . $seq . $checksum; # build the packet

open(FILE, ">>$file") || die("Cannot open file"); # now lets print to file
print FILE $output . "\n";
close FILE;

$seq = $seq + 1; # increment sequence

}

#-------------------------------------------------
# sub routine 2

sub runSubRoutine2 {

$command = "1";
$data = "2";
$checksum = $seq + $command + $data;

$output = $hex55 . $address . $command . $data . $seq . $checksum; # build the packet

open(FILE, ">>$file") || die("Cannot open file"); # now lets print to file
print FILE $output . "\n";
close FILE;

$seq = $seq + 1; # increment sequence

}

#-------------------------------------------------
# sub routine 3

sub runSubRoutine3 {

$get_scale = $bb->get(); # assign scale value to variable
$data = int($get_scale); # make an int version of scale value

$command = "2";
$checksum = $seq + $command + $data;

$output = $hex55 . $address . $command . $data . $seq . $checksum; # build the packet

open(FILE, ">>$file") || die("Cannot open file"); # now lets print to file
print FILE $output . "\n";
close FILE;

$seq = $seq + 1; # increment sequence

}

#-------------------------------------------------
# GUI elements

# main window
my $mw = Tkx::widget->new(".");
$mw->g_wm_title("Arduino Serial Controller");
$mw->g_wm_minsize(100, 10);


# frame a
$fa = $mw->new_frame(
-relief => 'solid',
-borderwidth => 1,
-background => 'light gray',
);
$fa->g_pack( -side => 'left', -fill => 'both' );

# frame b
$fb = $mw->new_frame(
-relief => 'solid',
-borderwidth => 1,
-background => 'light gray',
);
$fb->g_pack( -side => 'right', -fill => 'both' );

#---------------------------------------------------
# make buttons

$la = $fa->new_label( 				# just for spacing
-text => '                             ',
-font => 'bold',
-bg => 'light gray',
-foreground => 'black',
);
$la->g_pack( -side => 'bottom' );

$ba = $fa->new_button(
-text => 'Turn On',
-font => 'bold',
-command => \&runSubRoutine1,
-height => 1,
-width => 8,
);
$ba->g_pack( -side => 'top', -pady => 10 );

$bc = $fa->new_button(
-text => 'Turn Off',
-font => 'bold',
-command => \&runSubRoutine2,
-height => 1,
-width => 8,
);
$bc->g_pack( -side => 'top', -pady => 10 );

$bd = $fa->new_button(
-text => 'Send',
-font => 'bold',
-command => \&runSubRoutine3,
-height => 1,
-width => 8,
);
$bd->g_pack( -side => 'top', -pady => 10 );

#------------------------------------------------
# make scale

$lb = $fb->new_label(			# scale label
-text => 'Power Level',
-font => 'bold',
-bg => 'light gray',
-height => 2,
-width => 15,
);
$lb->g_pack( -side => 'top', -pady => 5 );

$scale_val = 0;					# global variable on start-up

$bb = $fb->new_ttk__scale(      # make scale
-variable => $scale_val,
-orient => 'horizontal', 
-length => 120,
-from => 1, -to => 9,
);
$bb->g_pack( -side => 'bottom', -pady => 10 );

$lb = $fb->new_label( 			# display scale variable
-textvariable => $scale_val,
-relief => 'solid',
-borderwidth => 1,
-bg => 'white',
-foreground => 'black',
-width => 20,
-height => 2,
);
$lb->g_pack( -side => 'top' );

#------------------------------------------------

Tkx::MainLoop();
