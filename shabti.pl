#!/usr/bin/perl
#
# ███████╗██╗  ██╗ █████╗ ██████╗ ████████╗██╗
# ██╔════╝██║  ██║██╔══██╗██╔══██╗╚══██╔══╝██║
# ███████╗███████║███████║██████╔╝   ██║   ██║
# ╚════██║██╔══██║██╔══██║██╔══██╗   ██║   ██║
# ███████║██║  ██║██║  ██║██████╔╝   ██║   ██║
# ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝
#
# A Perl/JavaScript IRC Bot

# =================
# | MODULES BEGIN |
# =================

use strict;
use warnings;

use IO::Socket;
use FindBin qw($Bin $RealBin);
use File::Spec;
use Getopt::Long;

# Load local modules from "/lib" directory
use lib File::Spec->catfile( $RealBin, 'lib' );

use JE;
use Parse::IRC;
use XML::TreePP;

# ===============
# | MODULES END |
# ===============

# =================
# | GLOBALS BEGIN |
# =================

# ~~~~~~~~~~~~~~~~~~~
# | CONSTANTS BEGIN |
# ~~~~~~~~~~~~~~~~~~~

use constant CHANNEL                => 0;
use constant CHANNEL_USERS          => 1;
use constant JAVASCRIPT_ERROR       => 1;
use constant NETWORK_ERROR          => 2;
use constant FILE_ERROR             => 3;
use constant API_ERROR              => 4;
use constant CONFIG_ERROR			=> 5;

# ~~~~~~~~~~~~~~~~~
# | CONSTANTS END |
# ~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~
# | ARRAYS BEGIN |
# ~~~~~~~~~~~~~~~~

my @CHANNELS						= ();
my @SCRIPTS							= ();

# ~~~~~~~~~~~~~~
# | ARRAYS END |
# ~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~
# | SCALARS BEGIN |
# ~~~~~~~~~~~~~~~~~

my $APPLICATION                     = 'Shabti';
my $VERSION                         = '0.023';
my $DESCRIPTION                     = 'A Perl/Javascript IRC Bot';

# ----------------
# | BANNER BEGIN |
# ----------------

my $LOGO_WIDTH                      = 44;
my $BANNER                          = "\n".('-' x $LOGO_WIDTH)."\n";
$BANNER .= logo().(' ' x ($LOGO_WIDTH - length("$DESCRIPTION - Version $VERSION")))."$DESCRIPTION - Version $VERSION\n";
$BANNER .= ('-' x $LOGO_WIDTH)."\n\n";

# --------------
# | BANNER END |
# --------------

my $CONFIGURATION_DIRECTORY_NAME    = 'config';
my $BOT_SOURCE                  	= 'default.js';
my $CONFIG							= 'default.xml';
my $CONFIG_DIRECTORY				= File::Spec->catfile( $RealBin, $CONFIGURATION_DIRECTORY_NAME );

my $DEBUG                           = undef;
my $USAGE							= undef;
my $NOBANNER						= undef;
my $NOJSPRINT						= undef;
my $QUIET							= undef;
my $NOCONFIG						= undef;

my $STARTUP_EVENT                   = "STARTUP";
my $JOIN_EVENT                      = "JOIN_EVENT";
my $CONNECT_EVENT                   = "CONNECT_EVENT";
my $PING_EVENT                      = "PING_EVENT";
my $PUBLIC_MESSAGE_EVENT            = "PUBLIC_MESSAGE_EVENT";
my $PRIVATE_MESSAGE_EVENT           = "PRIVATE_MESSAGE_EVENT";
my $NICK_TAKEN_EVENT                = "NICK_TAKEN_EVENT";
my $TIME_EVENT                      = "TIME_EVENT";
my $PART_EVENT                      = 'PART_EVENT';
my $IRC_EVENT						= 'IRC_EVENT';
my $MODE_EVENT						= "MODE_EVENT";
my $ACTION_EVENT                    = "ACTION_EVENT";

my $DEFAULT_NICK                    = "shabti";
my $DEFAULT_USERNAME                = "shabti";
my $DEFAULT_IRCNAME                 = "Shabti - An IRC bot";
my $DEFAULT_PORT                    = "6667";
my $DEFAULT_SERVER                  = "localhost";


my $NICK                            = $DEFAULT_NICK;
my $USERNAME                        = $DEFAULT_USERNAME;
my $IRCNAME                         = $DEFAULT_IRCNAME;
my $PORT                            = $DEFAULT_PORT;
my $SERVER                          = $DEFAULT_SERVER;

my $COLOR_TEXT						= chr(3);
my $BOLD_TEXT						= chr(2);
my $ITALIC_TEXT						= chr(hex("1D"));
my $UNDERLINE_TEXT					= chr(hex("1F"));

my $API = <<"EOA";
var SV_SERVER = \"$SERVER\";
var SV_PORT = \"$PORT\";
var SV_NICK = \"$NICK\";
var SV_USER = \"$USERNAME\";
var SV_IRCNAME = \"$IRCNAME\";
var SV_TIME = \"unknown\";
var SV_DATE = \"unknown\";
var SV_BOT = \"$DEFAULT_NICK\";
var SV_VERSION = \"$VERSION\";
var SV_LOCAL_DIRECTORY = \"$RealBin\";
var SV_CONFIG_DIRECTORY = \"$CONFIG_DIRECTORY\";
var WHITE = \"00\";
var BLACK = \"01\";
var BLUE = \"02\";
var GREEN = \"03\";
var RED = \"04\";
var BROWN = \"05\";
var PURPLE = \"06\";
var ORANGE = \"07\";
var YELLOW = \"08\";
var LIGHT_GREEN = \"09\";
var TEAL = \"10\";
var CYAN = \"11\";
var LIGHT_BLUE = \"12\";
var PINK = \"13\";
var GREY = \"14\";
var LIGHT_GREY = \"15\";
EOA

my $clear_variables = 'EV_NICK=""; EV_USERNAME=""; EV_CHANNEL=""; EV_ACTION=""; EV_MESSAGE=""; EV_TARGET=""; EV_MODE=""; EV_RAW=""; EV_TYPE=""; EV_CONTENT=""; EV_HOST="";'."\n";

# ~~~~~~~~~~~~~~~
# | SCALARS END |
# ~~~~~~~~~~~~~~~

# ===============
# | GLOBALS END |
# ===============

# =====================
# | MAIN PROGAM BEGIN |
# =====================

# Handle commandline options
Getopt::Long::Configure ("bundling");
GetOptions(
    "s|server=s"		=> \$SERVER,
    "n|nick=s"			=> \$NICK,
    "u|username=s"		=> \$USERNAME,
    "p|port=i"			=> \$PORT,
    "d|debug"			=> \$DEBUG,
    "c|config=s"		=> \$CONFIG,
    "j|javascript=s"	=> \$BOT_SOURCE,
    "h|help"			=> \$USAGE,
    "b|nobanner"		=> \$NOBANNER,
    "P|noprint"			=> \$NOJSPRINT,
    "q|quiet"			=> \$QUIET,
    "C|noconfig"		=> \$NOCONFIG
);

if($USAGE){
	usage();
	exit 0;
}

# If quiet mode is on, suppress all console prints
if($QUIET){
	$NOBANNER = 1;
	$NOJSPRINT = 1;
}

# Create event dispatch table
my %dispatch = (
    'ping'    => \&irc_ping,
    '001'     => \&irc_001,
    'public'  => \&irc_public,
    'privmsg' => \&irc_private,
    '433'     => \&irc_nick_taken,
    'join'    => \&irc_join,
    '391'     => \&irc_time,
    'part'    => \&irc_part,
    'mode'    => \&irc_mode
);

# Load in configuration file

if($NOCONFIG){
		# Don't load configuration files
	}else {
		# Find configuration file
		$CONFIG = find_file_in_home_or_settings_directory($CONFIG);
		if($CONFIG){}else{
			error_and_exit(CONFIG_ERROR,"Configuration file not found");
		}

		# Load configuration file
		load_configuration_file($CONFIG);
}

# Create IRC message parser object
my $parser = Parse::IRC->new();

# Connect to the IRC server.
my $sock = new IO::Socket::INET(
    PeerAddr => $SERVER,
    PeerPort => $PORT,
    Proto    => 'tcp'
) or error_and_exit(NETWORK_ERROR,"Can't connect to IRC server");

# Print the banner
if($NOBANNER){} else {
	print $BANNER;
}

# Log on to the server.
print $sock "NICK $NICK\r\n";
print $sock "USER $USERNAME 8 * :$IRCNAME\r\n";

# Create JavaScript object and add new functions
my $js = new JE;
$js = new_javascript_functions($js);

# Create API and load it into the JavaScript object
if ( $js->eval($API) ) { }
    else {
        if ( $@ ne '' ) {
            error_and_exit(API_ERROR,$@);
        }
}

# Inject built-in variables
$js->eval("SV_SERVER=\"$SERVER\";");
$js->eval("SV_PORT=\"$PORT\";");
$js->eval("SV_NICK=\"$NICK\";");
$js->eval("SV_USER=\"$USERNAME\";");
$js->eval("SV_IRCNAME=\"$IRCNAME\";");

# See if any scripts are configured; if not, make sure
# the default script is added
if(scalar @SCRIPTS>=1){}else{
	push(@SCRIPTS,$BOT_SOURCE);
}

# Load in scripts
foreach my $s (@SCRIPTS){
	# Load in our bot code
	my $script_name = find_file_in_home_or_settings_directory($s);
	open( FH, '<', $script_name ) or error_and_exit(FILE_ERROR,$!);
	my $SCRIPT = "";
	while (<FH>) {
	    $SCRIPT .= $_;
	}
	close(FH);

	# Execute bot code
	if ( $js->eval($SCRIPT) ) { }
	else {
	    if ( $@ ne '' ) {
	        error_and_exit(JAVASCRIPT_ERROR,$@);
	    }
	}
}

# Execute on_init() JS function
if ( $js->eval("if (typeof $STARTUP_EVENT === \"function\") { $STARTUP_EVENT(); }\n") ) { }
else {
    if ( $@ ne '' ) {
        error_and_exit(JAVASCRIPT_ERROR,$@);
    }
}


# Handle TCP client functionality
while ( my $input = <$sock> ) {
    $input =~ s/\r\n//g;
    my $hashref = $parser->parse($input);
  SWITCH: {
        my $type = lc $hashref->{command};
        $type = 'public'
          if $type eq 'privmsg' and $hashref->{params}->[0] =~ /^#/;
        my @args;
        push @args, $hashref->{prefix} if $hashref->{prefix};
        push @args, @{ $hashref->{params} };
        if ( defined $dispatch{$type} ) {
            $dispatch{$type}->(@args);
            last SWITCH;
        }
        if($DEBUG){
            print STDOUT join( ' ', "irc_$type:", @args ), "\n";
        }
        # Catch all other IRC events and execute JS function
        my $raw = "$type ".join(' ',@args);
        my $server = shift @args;
        my $nick = shift @args;
        my $msg = join(' ',@args);

		if ( $js->eval($clear_variables."if (typeof $IRC_EVENT === \"function\") { $IRC_EVENT(\"$raw\",\"$type\",\"$server\",\"$nick\",\"$msg\"); }\n") ) { }
		else {
		    if ( $@ ne '' ) {
		        error_and_exit(JAVASCRIPT_ERROR,$@);
		    }
		}
        # Done
    }
}

# ===================
# | MAIN PROGAM END |
# ===================

# =============================
# | SUPPORT SUBROUTINES BEGIN |
# =============================

# ~~~~~~~~~~~~~~~~~~~~
# | IRC EVENTS BEGIN |
# ~~~~~~~~~~~~~~~~~~~~

# irc_time()
# irc_join()
# irc_001()
# irc_ping()
# irc_public()
# irc_private()
# irc_nick_taken()
# irc_channel_users()

# irc_mode()
# Triggered when the bot receives a mode message.
sub irc_mode {
    my ( $actor,$target,$mode ) = @_;

    my($nick,$username)=split('!',$actor);
    my $code = "";
    if($username){
    	$code = "if (typeof $MODE_EVENT === \"function\") { $MODE_EVENT(\"$nick\",\"$username\",\"$target\",\"$mode\"); }\n";
	} else {
		$code = "if (typeof $MODE_EVENT === \"function\") { $MODE_EVENT(\"$nick\",\"\",\"$target\",\"$mode\"); }\n";
	}

    if ( $js->eval($clear_variables.$code) ) { }
    else {
        if ( $@ ne '' ) {
            error_and_exit(JAVASCRIPT_ERROR,$@);
        }
    }

    return 1;
}


# irc_part()
# Triggered with the bot receives a JOIN response.
sub irc_part {
    my ( $who, $where, $message ) = @_;

    my($nick,$username) = split('!',$who);

    if ( $js->eval($clear_variables."if (typeof $PART_EVENT === \"function\") { $PART_EVENT(\"$nick\",\"$username\",\"$where\",\"$message\"); }\n") ) { }
    else {
        if ( $@ ne '' ) {
            error_and_exit(JAVASCRIPT_ERROR,$@);
        }
    }

    # refresh user list
    print $sock "NAMES :$where\r\n";
    # get server time/date
    print $sock "TIME\r\n";

    return 1;
}

# irc_time()
# Triggered when the bot receives a response to a TIME command.
sub irc_time {
    my ($time) = $_[3];

    my @response = split(' ',$time);
    my $weekday = shift @response;
    my $month = shift @response;
    my $day = shift @response;
    my $year = shift @response;
    shift @response;
    my $rtime = shift @response;
    my ($hour,$minute,$second) = split(':',$rtime);
    my $zone = shift @response;

    if ( $js->eval("if (typeof $TIME_EVENT === \"function\") { $TIME_EVENT(\"$weekday\",\"$month\",\"$day\",\"$year\",\"$hour\",\"$minute\",\"$second\",\"$zone\"); }\n") ) { }
    else {
        if ( $@ ne '' ) {
            error_and_exit(JAVASCRIPT_ERROR,$@);
        }
    }

    # Inject built-in variables
    $js->eval("SV_TIME=\"$hour:$minute:$second\";");
    $js->eval("SV_DATE=\"$month $day,$year\";");

}

# irc_join()
# Triggered with the bot receives a JOIN response.
sub irc_join {
    my ( $who, $where ) = @_;

    my($nick,$username) = split('!',$who);

    if ( $js->eval($clear_variables."if (typeof $JOIN_EVENT === \"function\") { $JOIN_EVENT(\"$nick\",\"$username\",\"$where\"); }\n") ) { }
    else {
        if ( $@ ne '' ) {
            error_and_exit(JAVASCRIPT_ERROR,$@);
        }
    }

    # refresh user list
    print $sock "NAMES :$where\r\n";
    # get server time/date
    print $sock "TIME\r\n";

    return 1;
}

# irc_001()
# Triggerec when the bot connects to an IRC server.
sub irc_001 {

    if ( $js->eval($clear_variables."if (typeof $CONNECT_EVENT === \"function\") { $CONNECT_EVENT(\"$_[0]\"); }\n") ) { }
    else {
        if ( $@ ne '' ) {
            error_and_exit(JAVASCRIPT_ERROR,$@);
        }
    }

    print $sock "TIME\r\n";

    # Join channels
    foreach my $c (@CHANNELS){
    	print $sock "JOIN $c\r\n";
    }

    return 1;
}

# irc_ping()
# Triggered when the bot gets a PING message.
sub irc_ping {
    my $server = shift;
    print $sock "PONG :$server\r\n";

    if ( $js->eval("if (typeof $PING_EVENT === \"function\") { $PING_EVENT(); }\n") ) { }
    else {
        if ( $@ ne '' ) {
            error_and_exit(JAVASCRIPT_ERROR,$@);
        }
    }

    # get server time
    print $sock "TIME\r\n";

    return 1;
}

# irc_public()
# Triggered when the bot receives a public message.
sub irc_public {
    my ( $who, $where, $what ) = @_;
    #print "$who -> $where -> $what\n";
    my($nick,$username) = split('!',$who);

    my $act = chr(1)."ACTION";
    if($what=~/^$act/){
        # it's an action message
        $what=~s/^$act //;
        $act=chr(1);
        $what=~s/$act//;

        if ( $js->eval($clear_variables."if (typeof $ACTION_EVENT === \"function\") { $ACTION_EVENT(\"$nick\",\"$username\",\"$where\",\"$what\"); }\n") ) { }
        else {
            if ( $@ ne '' ) {
                error_and_exit(JAVASCRIPT_ERROR,$@);
            }
        }

        return 1;
    }

    if ( $js->eval($clear_variables."if (typeof $PUBLIC_MESSAGE_EVENT === \"function\") { $PUBLIC_MESSAGE_EVENT(\"$nick\",\"$username\",\"$where\",\"$what\"); }\n") ) { }
    else {
        if ( $@ ne '' ) {
            error_and_exit(JAVASCRIPT_ERROR,$@);
        }
    }

    return 1;
}

# irc_private()
# Triggered when the bot receives a private message.
sub irc_private {
    my ( $who, $where, $what ) = @_;
    #print "$who -> $where -> $what\n";
    my($nick,$username) = split('!',$who);

    if ( $js->eval($clear_variables."if (typeof $PRIVATE_MESSAGE_EVENT === \"function\") { $PRIVATE_MESSAGE_EVENT(\"$nick\",\"$username\",\"$what\"); }\n") ) { }
    else {
        if ( $@ ne '' ) {
            error_and_exit(JAVASCRIPT_ERROR,$@);
        }
    }

    return 1;
}

# irc_nick_taken()
# Triggered when the bot is told by the server that their nick is taken.
sub irc_nick_taken {
    my ( $who, $what ) = @_;

    if ( $js->eval("if (typeof $NICK_TAKEN_EVENT === \"function\") { $NICK_TAKEN_EVENT(); }\n") ) { }
    else {
        if ( $@ ne '' ) {
            error_and_exit(JAVASCRIPT_ERROR,$@);
        }
    }
}

# ~~~~~~~~~~~~~~~~~~
# | IRC EVENTS END |
# ~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# | MISCELLANEOUS SUBROUTINES BEGIN |
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# usage()
# load_configuration_file()
# logo()
# error_and_exit()
# find_file_in_home_or_settings_directory()
# new_javascript_functions()

# usage()
# Arguments: none
# Returns: nothing
# Description: Displays usage text.
sub usage {
	print "$APPLICATION $VERSION - $DESCRIPTION\n\n";

	print "\tperl shabti.pl [OPTIONS]\n\n";

	print "Options:\n\n";
	print "--(h)elp			Displays this text\n";
	print "--(s)server HOST		Sets the IRC server to connect to\n";
	print "--(p)ort PORT_NUMBER		Sets the IRC server port to connect to\n";
	print "--(n)ick NICK			Sets the bot's nick\n";
	print "--(u)sername USERNAME		Sets the bot's username\n";
	print "--(i)rcname IRCNAME		Sets the bot's IRCname\n";
	print "--(c)onfig FILENAME		Sets the configuration file to load\n";
	print "--(j)avascript FILENAME		Sets the bot's JavaScript code\n";
	print "--(d)ebug			Print all incoming IRC server messages\n";
	print "--no(b)anner			Prevent banner display at startup\n";
	print "--no(P)rint			Prevent JavaScript from printing to the console\n";
	print "--(q)uiet			Prevent all console printing\n";
	print "--no(C)onfig			Don't load settings from 'default.xml'\n";
}

# load_configuration_file()
# Arguments: filename
# Returns: nothing
# Description: Loads settings from an XML configuration file into memory.
sub load_configuration_file {
	my $filename = shift;

	# Load and parse XML
	my $tpp = XML::TreePP->new();
	my $tree = $tpp->parsefile( $filename );

	# If the parsed tree is empty, there's nothing to parse; exit
	if($tree eq '') { error_and_exit(CONFIG_ERROR,"Configuration file is empty"); }

	# Check for un-allowed multiple elements
	if(ref($tree->{configuration}) eq 'ARRAY'){
		error_and_exit(CONFIG_ERROR,"Configuration file contains more than one 'configuration' element");
	}
	if(ref($tree->{configuration}->{server}) eq 'ARRAY'){
		error_and_exit(CONFIG_ERROR,"Configuration file contains more than one 'configuration'->'server' child element");
	}
	if(ref($tree->{configuration}->{port}) eq 'ARRAY'){
		error_and_exit(CONFIG_ERROR,"Configuration file contains more than one 'configuration'->'port' child element");
	}
	if(ref($tree->{configuration}->{nick}) eq 'ARRAY'){
		error_and_exit(CONFIG_ERROR,"Configuration file contains more than one 'configuration'->'nick' child element");
	}
	if(ref($tree->{configuration}->{username}) eq 'ARRAY'){
		error_and_exit(CONFIG_ERROR,"Configuration file contains more than one 'configuration'->'username' child element");
	}
	if(ref($tree->{configuration}->{ircname}) eq 'ARRAY'){
		error_and_exit(CONFIG_ERROR,"Configuration file contains more than one 'configuration'->'ircname' child element");
	}

	# Load in single element settings
	if($tree->{configuration}->{server}){ $SERVER = $tree->{configuration}->{server}; }
	if($tree->{configuration}->{port}){ $PORT = $tree->{configuration}->{port}; }
	if($tree->{configuration}->{nick}){ $NICK = $tree->{configuration}->{nick}; }
	if($tree->{configuration}->{username}){ $USERNAME = $tree->{configuration}->{username}; }
	if($tree->{configuration}->{ircname}){ $IRCNAME = $tree->{configuration}->{ircname}; }

	# Load in channels
	if(ref($tree->{configuration}->{channel}) eq 'ARRAY'){
		foreach my $c (@{$tree->{configuration}->{channel}}) {
			push(@CHANNELS,$c);
		}
	} elsif($tree->{configuration}->{channel}) {
		push(@CHANNELS,$tree->{configuration}->{channel});
	}

	# Load in scripts
	if(ref($tree->{configuration}->{script}) eq 'ARRAY'){
		foreach my $c (@{$tree->{configuration}->{script}}) {
			push(@SCRIPTS,$c);
		}
	} elsif($tree->{configuration}->{script}) {
		push(@SCRIPTS,$tree->{configuration}->{script});
	}
}

# logo()
# Arguments: none
# Returns: scalar
# Description: Returns the ASCII logo for the bot.
sub logo {
    return <<'EOL';
███████╗██╗  ██╗ █████╗ ██████╗ ████████╗██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗╚══██╔══╝██║
███████╗███████║███████║██████╔╝   ██║   ██║
╚════██║██╔══██║██╔══██║██╔══██╗   ██║   ██║
███████║██║  ██║██║  ██║██████╔╝   ██║   ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝
EOL
}

# error_and_exit()
# Arguments: 2 (constant,text)
# Returns: nothing
# Description: Displays an error message and exits.
sub error_and_exit {
    my $type = shift;
    my $error = shift;

    if($type==JAVASCRIPT_ERROR){
        print "JavaScript ERROR: $error\n";
    }

    if($type==NETWORK_ERROR){
        print "Network ERROR: $error\n";
    }

    if($type==FILE_ERROR){
        print "File ERROR: $error\n";
    }

    if($type==API_ERROR){
        print "API ERROR: $error\n";
    }

    if($type==CONFIG_ERROR){
        print "Configuration ERROR: $error\n";
    }

    exit 1;
}


# find_file_in_home_or_settings_directory()
# Arguments: 1 (filename)
# Returns: Scalar (filename)
# Description: Looks for a given configuration file in the several directories.
#              This subroutine was written with cross-platform compatability in
#              mind; in theory, this should work on any platform that can run
#              Perl (so, OSX, *NIX, Linux, Windows, etc). Not "expensive" to
#              run, as it doesn't do directory searches.
sub find_file_in_home_or_settings_directory {
    my $filename = shift;

    # If the filename is found, return it
    if((-e $filename)&&(-f $filename)){ return $filename; }

    # Look for the file in $RealBin/filename
    my $f = File::Spec->catfile($RealBin,$filename);
    if((-e $f)&&(-f $f)){ return $f; }

    # Look for the file in $CONFIGURATION_DIRECTORY_NAME/filename
    $f = File::Spec->catfile($CONFIGURATION_DIRECTORY_NAME,$filename);
    if((-e $f)&&(-f $f)){ return $f; }

    # Look for the file in $Realbin/$CONFIGURATION_DIRECTORY_NAME/filename
    $f = File::Spec->catfile($RealBin,$CONFIGURATION_DIRECTORY_NAME,$filename);
    if((-e $f)&&(-f $f)){ return $f; }

    return undef;
}

# new_javascript_functions()
# Arguments: 1 (JE object)
# Returns: JE Object
# Description: Adds new JavaScript commands to the JE object.
sub new_javascript_functions {
    my $j = shift;

    # server
    # Sends a raw command to the IRC server
    $j->new_function(
        server => sub {
            if ( scalar @_ == 1 ) {
                print $sock "$_[0]\r\n";
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'server'\n";
            }
        }
    );

    # set
    # Set a user/channel mode
    $j->new_function(
        set => sub {
            if ( scalar @_ >= 2 ) {
                my $target = shift @_;
                my $flags = shift @_;
                my $args = join(' ',@_);
                print $sock "MODE $target $flags $args\r\n";
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'set'\n";
            }
        }
    );

    # login
    # Logs in as an IRCOP
    $j->new_function(
        login => sub {
            if ( scalar @_ == 2 ) {
                print $sock "OPER $_[0] $_[1]\r\n";
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'login'\n";
            }
        }
    );

    # nick
    $j->new_function(
        nick => sub {
            if ( scalar @_ == 1 ) {
                print $sock "NICK $_[0]\r\n";
                $j->eval("SV_NICK=\"$_[0]\";");
                $NICK = $_[0];
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'nick'\n";
            }
        }
    );

    # rnick
    $j->new_function(
        rnick => sub {
            if ( scalar @_ == 1 ) {
                my $new = "$_[0]$$";
                $NICK = "$new";
                $j->eval("SV_NICK=\"$new\";");
                print $sock "NICK $new\r\n";
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'rnick'\n";
            }
        }
    );

    # print
    $j->new_function(
        print => sub {
            if ( scalar @_ >= 1 ) {
                foreach my $p (@_) {
                	if($NOJSPRINT){} else {
                    	print "$p\n";
                	}
                }
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'print'\n";
            }
        }
    );

    # sprint
    $j->new_function(
        sprint => sub {
            if ( scalar @_ >= 1 ) {
                foreach my $p (@_) {
                    if($NOJSPRINT){} else {
                    	print "$p";
                	}
                }
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'sprint'\n";
            }
        }
    );

    # topic
    $j->new_function(
        topic => sub {
            if ( scalar @_ == 2 ) {
                print $sock "TOPIC $_[0] :$_[1]\r\n";
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'topic'\n";
            }
        }
    );

    # join
    $j->new_function(
        join => sub {
            if ( scalar @_ == 1 ) {
                print $sock "JOIN $_[0]\r\n";
            } elsif ( scalar @_ == 2 ) {
            	print $sock "JOIN $_[0] $_[1]\r\n";
            } else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'join'\n";
            }
        }
    );

    # part
    $j->new_function(
        part => sub {
            if ( scalar @_ == 1 ) {
                print $sock "PART $_[0]\r\n";
            }
            elsif ( scalar @_ == 2 ) {
                print $sock "PART $_[0] :$_[1]\r\n";
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'part'\n";
            }
        }
    );

    # quit
    $j->new_function(
        quit => sub {
            if ( scalar @_ == 0 ) {
                print $sock "QUIT\r\n";
            }
            elsif ( scalar @_ == 1 ) {
                print $sock "QUIT :$_[0]\r\n";
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'quit'\n";
            }
        }
    );

    # msg
    $j->new_function(
        msg => sub {
            if ( scalar @_ == 2 ) {
                print $sock "PRIVMSG $_[0] :$_[1]\r\n";
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'msg'\n";
            }
        }
    );

    # notice
    $j->new_function(
        notice => sub {
            if ( scalar @_ == 2 ) {
                print $sock "NOTICE $_[0] :$_[1]\r\n";
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'notice'\n";
            }
        }
    );

    # action
    $j->new_function(
        action => sub {
            if ( scalar @_ == 2 ) {
                print $sock "PRIVMSG $_[0] :".chr(1)."ACTION $_[1]".chr(1)."\r\n";
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'action'\n";
            }
        }
    );

    # write
    $j->new_function(
        write => sub {
            if ( scalar @_ == 2 ) {
                open(FILE,">$_[0]") or error_and_exit(FILE_ERROR,"Error writing to '$_[0]'");
                print FILE "$_[1]\n";
                close FILE;
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'write'\n";
            }
        }
    );

    # append
    $j->new_function(
        append => sub {
            if ( scalar @_ == 2 ) {
                open(FILE,">>$_[0]") or error_and_exit(FILE_ERROR,"Error appending to '$_[0]'");
                print FILE "$_[1]\n";
                close FILE;
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'append'\n";
            }
        }
    );

    # read
    $j->new_function(
        read => sub {
            if ( scalar @_ == 1 ) {
                open(FILE,"<$_[0]") or error_and_exit(FILE_ERROR,"Error reading from '$_[0]'");
                my $c = join('',<FILE>);
                close FILE;
                return $c;
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'read'\n";
            }
        }
    );

    # fileexists
    $j->new_function(
        fileexists => sub {
            if ( scalar @_ == 1 ) {
                if(-e $_[0] && -f $_[0]){
                	return 1;
                } else {
                	return 0;
                }
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'fileexists'\n";
            }
        }
    );

    # direxists
    $j->new_function(
        direxists => sub {
            if ( scalar @_ == 1 ) {
                if(-e $_[0] && -d $_[0]){
                	return 1;
                } else {
                	return 0;
                }
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'direxists'\n";
            }
        }
    );

    # swrite
    $j->new_function(
        swrite => sub {
            if ( scalar @_ == 2 ) {
                open(FILE,">$_[0]") or error_and_exit(FILE_ERROR,"Error writing to '$_[0]'");
                print FILE $_[1];
                close FILE;
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'swrite'\n";
            }
        }
    );

    # sappend
    $j->new_function(
        sappend => sub {
            if ( scalar @_ == 2 ) {
                open(FILE,">>$_[0]") or error_and_exit(FILE_ERROR,"Error appending to '$_[0]'");
                print FILE $_[1];
                close FILE;
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'sappend'\n";
            }
        }
    );

    # mkdir
    $j->new_function(
        mkdir => sub {
            if ( scalar @_ == 1 ) {
                mkdir($_[0]) or error_and_exit(FILE_ERROR,"Error creating directory '$_[0]'");
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'mkdir'\n";
            }
        }
    );

    # rmdir
    $j->new_function(
        rmdir => sub {
            if ( scalar @_ == 1 ) {
                rmdir($_[0]) or error_and_exit(FILE_ERROR,"Error deleting directory '$_[0]'");
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'rmdir'\n";
            }
        }
    );

    # delete
    $j->new_function(
        delete => sub {
            if ( scalar @_ == 1 ) {
                unlink($_[0]) or error_and_exit(FILE_ERROR,"Error deleting file '$_[0]'");
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'delete'\n";
            }
        }
    );

    # color
    $j->new_function(
        color => sub {
            if ( scalar @_ == 3 ) {
                my $t = $COLOR_TEXT.$_[0].",".$_[1].$_[2].$COLOR_TEXT;
                return $t;
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'color'\n";
            }
        }
    );

    # italic
    $j->new_function(
        italic => sub {
            if ( scalar @_ == 1 ) {
                my $t = $ITALIC_TEXT.$_[0].$ITALIC_TEXT;
                return $t;
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'italic'\n";
            }
        }
    );

    # bold
    $j->new_function(
        bold => sub {
            if ( scalar @_ == 1 ) {
                my $t = $BOLD_TEXT.$_[0].$BOLD_TEXT;
                return $t;
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'bold'\n";
            }
        }
    );

    # underline
    $j->new_function(
        underline => sub {
            if ( scalar @_ == 1 ) {
                my $t = $UNDERLINE_TEXT.$_[0].$UNDERLINE_TEXT;
                return $t;
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'underline'\n";
            }
        }
    );

    # exit
    $j->new_function(
        exit => sub {
            if ( scalar @_ == 0 ) {
                exit;
            }
            elsif ( scalar @_ == 1 ) {
                print "$_[0]\n";
                exit;
            }
            elsif ( scalar @_ == 2 ) {
                if($_[1]=="0"||$_[1]==1){}else{
                    error_and_exit(JAVASCRIPT_ERROR,"Third argument to exit() must be 0 or 1");
                }
                print "$_[0]\n";
                exit $_[1];
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'exit'\n";
            }
        }
    );

    return $j;

}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# | MISCELLANEOUS SUBROUTINES BEGIN |
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ===========================
# | SUPPORT SUBROUTINES END |
# ===========================
