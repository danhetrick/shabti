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
use Digest::SHA::PurePerl;
use Text::ParseWords;

use Data::Dumper;

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
use constant CONFIG_ERROR			=> 4;
use constant REQUIRE_ERROR          => 5;

# ~~~~~~~~~~~~~~~~~
# | CONSTANTS END |
# ~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~
# | ARRAYS BEGIN |
# ~~~~~~~~~~~~~~~~

my @CHANNELS						= ();
my @SCRIPTS							= ();
my @CHANNEL_USERS                   = ();

# ~~~~~~~~~~~~~~
# | ARRAYS END |
# ~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~
# | SCALARS BEGIN |
# ~~~~~~~~~~~~~~~~~

my $APPLICATION                     = 'Shabti';
my $APPLICATION_FILE_NAME           = 'shabti.pl';
my $VERSION                         = '0.313';
my $DESCRIPTION                     = 'A Perl/Javascript IRC Bot';

# ----------------
# | BANNER BEGIN |
# ----------------

my $LOGO_WIDTH                      = 44;
my $BANNER                          = "\n".('-' x $LOGO_WIDTH)."\n";
$BANNER .= SHABTI_logo().(' ' x ($LOGO_WIDTH - length("$DESCRIPTION - Version $VERSION")))."$DESCRIPTION - Version $VERSION\n";
$BANNER .= ('-' x $LOGO_WIDTH)."\n\n";

# --------------
# | BANNER END |
# --------------

my $CONFIGURATION_DIRECTORY_NAME    = 'config';
my $JAVASCRIPT_MODULES_DIRECTORY    = "modules";
my $BOT_SOURCE                  	= 'default.js';
my $DEFAULT_BOT_SOURCE              = $BOT_SOURCE;
my $CONFIG							= 'default.xml';
my $CONFIG_DIRECTORY				= File::Spec->catfile( $RealBin, $CONFIGURATION_DIRECTORY_NAME );

my $DEBUG                           = undef;
my $USAGE							= undef;
my $NOBANNER						= undef;
my $NOJSPRINT						= undef;
my $QUIET							= undef;
my $NOCONFIG						= undef;
my $DISPLAY_VERSION                 = undef;

my $JOIN_EVENT                      = 'JOIN_EVENT';
my $CONNECT_EVENT                   = 'CONNECT_EVENT';
my $PING_EVENT                      = 'PING_EVENT';
my $PUBLIC_MESSAGE_EVENT            = 'PUBLIC_MESSAGE_EVENT';
my $PRIVATE_MESSAGE_EVENT           = 'PRIVATE_MESSAGE_EVENT';
my $NICK_TAKEN_EVENT                = 'NICK_TAKEN_EVENT';
my $TIME_EVENT                      = 'TIME_EVENT';
my $PART_EVENT                      = 'PART_EVENT';
my $IRC_EVENT						= 'IRC_EVENT';
my $MODE_EVENT						= 'MODE_EVENT';
my $ACTION_EVENT                    = 'ACTION_EVENT';

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

my $MAX_EXTRA_EVENT_FUNCTIONS       = 10;

my $BUILT_IN_VARIABLES = <<"EOA";
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
    "C|noconfig"		=> \$NOCONFIG,
    "v|version"         => \$DISPLAY_VERSION,
    "x|extra"           => \$MAX_EXTRA_EVENT_FUNCTIONS
);

# Display usage information
if($USAGE){
	SHABTI_usage();
	exit 0;
}

# Display version information
if($DISPLAY_VERSION){
    print "$VERSION\n";
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
    'mode'    => \&irc_mode,
    '353'     => \&irc_users,
);

# Load in configuration file

if($NOCONFIG){
		# Don't load configuration files
	}else {
		# Find configuration file
		$CONFIG = SHABTI_find_file($CONFIG);
		if($CONFIG){}else{
			SHABTI_error(CONFIG_ERROR,"Configuration file not found");
		}

		# Load configuration file
		SHABTI_load_configuration_file($CONFIG);
}

# Print the banner
if($NOBANNER){} else {
	print $BANNER;
}

# Create JavaScript object and add new functions
my $js = new JE;
$js = SHABTI_add_built_in_functions($js);

# Load built-in variables to the Javascript object
if ( $js->eval($BUILT_IN_VARIABLES) ) { }
    else {
        if ( $@ ne '' ) {
            SHABTI_error(JAVASCRIPT_ERROR,$@);
        }
}

# Inject built-in variables
$js->eval("SV_SERVER=\"$SERVER\";");
$js->eval("SV_PORT=\"$PORT\";");
$js->eval("SV_NICK=\"$NICK\";");
$js->eval("SV_USER=\"$USERNAME\";");
$js->eval("SV_IRCNAME=\"$IRCNAME\";");

# If we've been passed a script from the
# command line, make sure it's added.
if($BOT_SOURCE ne $DEFAULT_BOT_SOURCE){
    push(@SCRIPTS,$BOT_SOURCE);
}

# See if any scripts are configured; if not, make sure
# the default script is added
if(scalar @SCRIPTS>=1){}else{
	push(@SCRIPTS,$BOT_SOURCE);
}

# Load in scripts
foreach my $s (@SCRIPTS){
	# Load in our bot code
	my $script_name = SHABTI_find_file($s);
	open( FH, '<', $script_name ) or SHABTI_error(FILE_ERROR,$!);
	my $SCRIPT = "";
	while (<FH>) {
	    $SCRIPT .= $_;
	}
	close(FH);

	# Execute bot code
	if ( $js->eval($SCRIPT) ) { }
	else {
	    if ( $@ ne '' ) {
	        SHABTI_error(JAVASCRIPT_ERROR,$@);
	    }
	}
}

# Create IRC message parser object
my $parser = Parse::IRC->new();

# Connect to the IRC server.
my $sock = new IO::Socket::INET(
    PeerAddr => $SERVER,
    PeerPort => $PORT,
    Proto    => 'tcp'
) or SHABTI_error(NETWORK_ERROR,"Can't connect to IRC server");

# Log on to the server.
print $sock "NICK $NICK\r\n";
print $sock "USER $USERNAME 8 * :$IRCNAME\r\n";

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
        my $raw = "$type ".join(' ',@args); $raw = quotemeta($raw);
        my $server = shift @args;
        my $nick = shift @args || "";
        my $msg = join(' ',@args); $msg = quotemeta($msg);

		if ( $js->eval("if (typeof $IRC_EVENT === \"function\") { $IRC_EVENT(\"$raw\",\"$type\",\"$server\",\"$nick\",\"$msg\"); }\n") ) { }
		else {
		    if ( $@ ne '' ) {
		        SHABTI_error(JAVASCRIPT_ERROR,$@);
		    }
		}
        # Done
        # Extra events
        my $i = 1;

        while($i<=$MAX_EXTRA_EVENT_FUNCTIONS){
            my $cmd = "if (typeof $IRC_EVENT"."_".$i."=== \"function\") { $IRC_EVENT"."_".$i."(\"$raw\",\"$type\",\"$server\",\"$nick\",\"$msg\"); }\n";

            if ( $js->eval($cmd) ) { }
            else {
                if ( $@ ne '' ) {
                    SHABTI_error(JAVASCRIPT_ERROR,$@);
                }
            }

            $i++;
        }



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
# irc_users()

# irc_users()
# Triggered when the bot gets a channel user list from the server
sub irc_users {
    my $server = shift;
    my $nick = shift;
    shift; # =
    my $channel = shift;
    my $users = shift;

    $users=~s/\@//g;
    $users=~s/\+//g;
    SHABTI_add_users($channel,$users);
}

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

    if ( $js->eval($code) ) { }
    else {
        if ( $@ ne '' ) {
            SHABTI_error(JAVASCRIPT_ERROR,$@);
        }
    }

    return 1;
}


# irc_part()
# Triggered with the bot receives a JOIN response.
sub irc_part {
    my ( $who, $where, $message ) = @_;

    my($nick,$username) = split('!',$who);

    if($nick eq $NICK) {
        SHABTI_remove_channel($where);
    } else {
        SHABTI_remove_user($where,$nick);
    }

    $message = quotemeta($message);

    if ( $js->eval("if (typeof $PART_EVENT === \"function\") { $PART_EVENT(\"$nick\",\"$username\",\"$where\",\"$message\"); }\n") ) { }
    else {
        if ( $@ ne '' ) {
            SHABTI_error(JAVASCRIPT_ERROR,$@);
        }
    }

    my $i = 1;

    while($i<=$MAX_EXTRA_EVENT_FUNCTIONS){
        my $cmd = "if (typeof $PART_EVENT"."_".$i."=== \"function\") { $PART_EVENT"."_".$i."(\"$nick\",\"$username\",\"$where\",\"$message\"); }\n";

        if ( $js->eval($cmd) ) { }
        else {
            if ( $@ ne '' ) {
                SHABTI_error(JAVASCRIPT_ERROR,$@);
            }
        }

        $i++;
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
            SHABTI_error(JAVASCRIPT_ERROR,$@);
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

    SHABTI_add_users($where,$nick);

    # If the bot is the one joining, don't do join event
    #if($nick eq $NICK){ return; }

    if ( $js->eval("if (typeof $JOIN_EVENT === \"function\") { $JOIN_EVENT(\"$nick\",\"$username\",\"$where\"); }\n") ) { }
    else {
        if ( $@ ne '' ) {
            SHABTI_error(JAVASCRIPT_ERROR,$@);
        }
    }

    my $i = 1;

    while($i<=$MAX_EXTRA_EVENT_FUNCTIONS){
        my $cmd = "if (typeof $JOIN_EVENT"."_".$i."=== \"function\") { $JOIN_EVENT"."_".$i."(\"$nick\",\"$username\",\"$where\"); }\n";

        if ( $js->eval($cmd) ) { }
        else {
            if ( $@ ne '' ) {
                SHABTI_error(JAVASCRIPT_ERROR,$@);
            }
        }

        $i++;
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

    if ( $js->eval("if (typeof $CONNECT_EVENT === \"function\") { $CONNECT_EVENT(\"$_[0]\"); }\n") ) { }
    else {
        if ( $@ ne '' ) {
            SHABTI_error(JAVASCRIPT_ERROR,$@);
        }
    }

    my $i = 1;

    while($i<=$MAX_EXTRA_EVENT_FUNCTIONS){
        my $cmd = "if (typeof $CONNECT_EVENT"."_".$i."=== \"function\") { $CONNECT_EVENT"."_".$i."(\"$_[0]\"); }\n";

        if ( $js->eval($cmd) ) { }
        else {
            if ( $@ ne '' ) {
                SHABTI_error(JAVASCRIPT_ERROR,$@);
            }
        }

        $i++;
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
            SHABTI_error(JAVASCRIPT_ERROR,$@);
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

    $what = quotemeta($what);

    my $act = chr(1)."ACTION";
    if($what=~/^$act/){
        # it's an action message
        $what=~s/^$act //;
        $act=chr(1);
        $what=~s/$act//;

        if ( $js->eval("if (typeof $ACTION_EVENT === \"function\") { $ACTION_EVENT(\"$nick\",\"$username\",\"$where\",\"$what\"); }\n") ) { }
        else {
            if ( $@ ne '' ) {
                SHABTI_error(JAVASCRIPT_ERROR,$@);
            }
        }

        return 1;
    }

    if ( $js->eval("if (typeof $PUBLIC_MESSAGE_EVENT === \"function\") { $PUBLIC_MESSAGE_EVENT(\"$nick\",\"$username\",\"$where\",\"$what\"); }\n") ) { }
    else {
        if ( $@ ne '' ) {
            SHABTI_error(JAVASCRIPT_ERROR,$@);
        }
    }

    # Extra PUBLIC_MESSAGE_EVENT functions
    my $i = 1;

    while($i<=$MAX_EXTRA_EVENT_FUNCTIONS){
        my $cmd = "if (typeof $PUBLIC_MESSAGE_EVENT"."_".$i."=== \"function\") { $PUBLIC_MESSAGE_EVENT"."_".$i."(\"$nick\",\"$username\",\"$where\",\"$what\"); }\n";

        if ( $js->eval($cmd) ) { }
        else {
            if ( $@ ne '' ) {
                SHABTI_error(JAVASCRIPT_ERROR,$@);
            }
        }

        $i++;
    }

    return 1;
}

# irc_private()
# Triggered when the bot receives a private message.
sub irc_private {
    my ( $who, $where, $what ) = @_;
    #print "$who -> $where -> $what\n";
    my($nick,$username) = split('!',$who);

    $what = quotemeta($what);

    if ( $js->eval("if (typeof $PRIVATE_MESSAGE_EVENT === \"function\") { $PRIVATE_MESSAGE_EVENT(\"$nick\",\"$username\",\"$what\"); }\n") ) { }
    else {
        if ( $@ ne '' ) {
            SHABTI_error(JAVASCRIPT_ERROR,$@);
        }
    }

    my $i = 1;

    while($i<=$MAX_EXTRA_EVENT_FUNCTIONS){
        my $cmd = "if (typeof $PRIVATE_MESSAGE_EVENT"."_".$i."=== \"function\") { $PRIVATE_MESSAGE_EVENT"."_".$i."(\"$nick\",\"$username\",\"$what\"); }\n";

        if ( $js->eval($cmd) ) { }
        else {
            if ( $@ ne '' ) {
                SHABTI_error(JAVASCRIPT_ERROR,$@);
            }
        }

        $i++;
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
            SHABTI_error(JAVASCRIPT_ERROR,$@);
        }
    }
}

# ~~~~~~~~~~~~~~~~~~
# | IRC EVENTS END |
# ~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# | MISCELLANEOUS SUBROUTINES BEGIN |
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# SHABTI_add_users()
# SHABTI_get_users()
# SHABTI_remove_user()
# SHABTI_remove_channel()
# SHABTI_usage()
# SHABTI_load_configuration_file()
# SHABTI_logo()
# SHABTI_error()
# SHABTI_find_file()
# SHABTI_require_file()
# SHABTI_add_built_in_functions()

# SHABTI_remove_channel()
# Arguments: 1 (channel name)
# Returns: nothing
# Description: Removes a channel from the channel user list
sub SHABTI_remove_channel {
    my $channel = shift;

    my @copy = shift;
    foreach my $e (@CHANNEL_USERS){
        my @entry = @{$e};
        if($entry[CHANNEL] eq $channel){}else{
            push(@copy,\@entry);
        }
    }
    @CHANNEL_USERS = @copy;
}

# SHABTI_remove_user()
# Arguments: 2 (channel name, user nick)
# Returns: nothing
# Description: Removes a user from the channel user list
sub SHABTI_remove_user {
    my $channel = shift;
    my $user = shift;

    my @copy = shift;
    foreach my $e (@CHANNEL_USERS){
        my @entry = @{$e};
        my @ul = @{$entry[CHANNEL_USERS]};
        if($entry[CHANNEL] eq $channel){
            @ul = grep { $_ ne $user } @ul;
        }
        my @n = ($entry[CHANNEL],\@ul);
        push(@copy,\@n);
    }
    @CHANNEL_USERS = @copy;
}

# SHABTI_get_users()
# Arguments: 1 (channel name)
# Returns: array
# Description: Gets a list of users in a channel
sub SHABTI_get_users {
    my $channel = shift;

    foreach my $e (@CHANNEL_USERS){
        my @entry = @{$e};
        if($entry[CHANNEL] eq $channel){
            return @{$entry[CHANNEL_USERS]};
        }
    }
    return ();
}

# SHABTI_add_users()
# Arguments: 2 (channel name,user name)
# Returns: nothing
# Description: Adds a user to the channel/user list
sub SHABTI_add_users {
    my $channel = shift;
    my $users = shift;

    my @c = split(' ',$users);
    my @copy = ();
    my $found = 0;
    foreach my $e (@CHANNEL_USERS){
        my @entry = @{$e};
        my @cu = @{$entry[CHANNEL_USERS]};
        if($entry[CHANNEL] eq $channel){
            $found = 1;
            foreach my $us (@c){
                if ( grep( /^$us$/, @cu ) ) {}else{
                    push(@cu,$us);
                }
            }
        }
        my @n = ($entry[CHANNEL],\@cu);
        push(@copy,\@n);
    }
    @CHANNEL_USERS = @copy;

    if($found==0){
        my @entry;
        push(@entry,$channel);
        push(@entry,\@c);
        push(@CHANNEL_USERS,\@entry);
    }
}

# SHABTI_usage()
# Arguments: none
# Returns: nothing
# Description: Displays usage text.
sub SHABTI_usage {
	print "$APPLICATION $VERSION - $DESCRIPTION\n\n";

	print "\tperl $APPLICATION_FILE_NAME [OPTIONS]\n\n";

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
    print "--(v)ersion         Display version\n";
    print "--e(x)tra            How many extra chat event functions to call (default: 10)\n";
}

# SHABTI_load_configuration_file()
# Arguments: filename
# Returns: nothing
# Description: Loads settings from an XML configuration file into memory.
sub SHABTI_load_configuration_file {
	my $filename = shift;
    my $content = shift;

	# Load and parse XML
	my $tpp = XML::TreePP->new();

    my $tree;
    if($content){
        $tree = $tpp->parse( $content );
    } else {
        $tree = $tpp->parsefile( $filename );
    }
	#my $tree = $tpp->parsefile( $filename );

	# If the parsed tree is empty, there's nothing to parse; exit
	if($tree eq '') { SHABTI_error(CONFIG_ERROR,"Configuration file is empty"); }

	# Check for un-allowed multiple elements
	if(ref($tree->{configuration}) eq 'ARRAY'){
		SHABTI_error(CONFIG_ERROR,"Configuration file contains more than one 'configuration' element");
	}
	if(ref($tree->{configuration}->{server}) eq 'ARRAY'){
		SHABTI_error(CONFIG_ERROR,"Configuration file contains more than one 'configuration'->'server' child element");
	}
	if(ref($tree->{configuration}->{port}) eq 'ARRAY'){
		SHABTI_error(CONFIG_ERROR,"Configuration file contains more than one 'configuration'->'port' child element");
	}
	if(ref($tree->{configuration}->{nick}) eq 'ARRAY'){
		SHABTI_error(CONFIG_ERROR,"Configuration file contains more than one 'configuration'->'nick' child element");
	}
	if(ref($tree->{configuration}->{username}) eq 'ARRAY'){
		SHABTI_error(CONFIG_ERROR,"Configuration file contains more than one 'configuration'->'username' child element");
	}
	if(ref($tree->{configuration}->{ircname}) eq 'ARRAY'){
		SHABTI_error(CONFIG_ERROR,"Configuration file contains more than one 'configuration'->'ircname' child element");
	}
    if(ref($tree->{configuration}->{extra}) eq 'ARRAY'){
        SHABTI_error(CONFIG_ERROR,"Configuration file contains more than one 'configuration'->'extra' child element");
    }

	# Load in single element settings
	if($tree->{configuration}->{server}){ $SERVER = $tree->{configuration}->{server}; }
	if($tree->{configuration}->{port}){ $PORT = $tree->{configuration}->{port}; }
	if($tree->{configuration}->{nick}){ $NICK = $tree->{configuration}->{nick}; }
	if($tree->{configuration}->{username}){ $USERNAME = $tree->{configuration}->{username}; }
	if($tree->{configuration}->{ircname}){ $IRCNAME = $tree->{configuration}->{ircname}; }
    if($tree->{configuration}->{extra}){ $MAX_EXTRA_EVENT_FUNCTIONS = $tree->{configuration}->{extra}; }

    if ($PORT =~ /^\d+?$/) {}else{
        SHABTI_error(CONFIG_ERROR,"'configuration'->'port' value \"$PORT\" is not a number");
    }

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

# SHABTI_logo()
# Arguments: none
# Returns: scalar
# Description: Returns the ASCII logo for the bot.
sub SHABTI_logo {
    return <<'EOL';
███████╗██╗  ██╗ █████╗ ██████╗ ████████╗██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗╚══██╔══╝██║
███████╗███████║███████║██████╔╝   ██║   ██║
╚════██║██╔══██║██╔══██║██╔══██╗   ██║   ██║
███████║██║  ██║██║  ██║██████╔╝   ██║   ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝
EOL
}

# SHABTI_error()
# Arguments: 2 (constant,text)
# Returns: nothing
# Description: Displays an error message and exits.
sub SHABTI_error {
    my $type = shift;
    my $error = shift;

    if($type==JAVASCRIPT_ERROR){
        print "Javascript: $error";
    }

    if($type==REQUIRE_ERROR){
        print "Javascript Require: $error";
    }

    if($type==NETWORK_ERROR){
        print "Network error: $error\n";
    }

    if($type==FILE_ERROR){
        print "File I/O error: $error\n";
    }

    if($type==CONFIG_ERROR){
        print "Configuration error: $error\n";
    }

    exit 1;
}


# SHABTI_find_file()
# Arguments: 1 (filename)
# Returns: Scalar (filename)
# Description: Looks for a given configuration file in the several directories.
#              This subroutine was written with cross-platform compatability in
#              mind; in theory, this should work on any platform that can run
#              Perl (so, OSX, *NIX, Linux, Windows, etc). Not "expensive" to
#              run, as it doesn't do directory searches.
sub SHABTI_find_file {
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

# SHABTI_require_file()
# Arguments: 1 (filename)
# Returns: Scalar (filename)
# Description: Looks for a given JS module file in the module directory.
sub SHABTI_require_file {
    my $filename = shift;

    # If the filename is found, return it
    if((-e $filename)&&(-f $filename)){ return $filename; }

    # Look for the file in $CONFIGURATION_DIRECTORY_NAME/$JAVASCRIPT_MODULES_DIRECTORY/filename
    my $f = File::Spec->catfile($CONFIGURATION_DIRECTORY_NAME,$JAVASCRIPT_MODULES_DIRECTORY,$filename);
    if((-e $f)&&(-f $f)){ return $f; }

    # Look for the file in $Realbin/$CONFIGURATION_DIRECTORY_NAME/$JAVASCRIPT_MODULES_DIRECTORY/filename
    $f = File::Spec->catfile($RealBin,$CONFIGURATION_DIRECTORY_NAME,$JAVASCRIPT_MODULES_DIRECTORY,$filename);
    if((-e $f)&&(-f $f)){ return $f; }

    # Add ".js" to the end of the filename, if that's been left off
    $filename = "$filename.js";

    # Only look for files with the added ".js" in the modules directory

    # Look for the file in $CONFIGURATION_DIRECTORY_NAME/$JAVASCRIPT_MODULES_DIRECTORY/filename
    $f = File::Spec->catfile($CONFIGURATION_DIRECTORY_NAME,$JAVASCRIPT_MODULES_DIRECTORY,$filename);
    if((-e $f)&&(-f $f)){ return $f; }

    # Look for the file in $Realbin/$CONFIGURATION_DIRECTORY_NAME/$JAVASCRIPT_MODULES_DIRECTORY/filename
    $f = File::Spec->catfile($RealBin,$CONFIGURATION_DIRECTORY_NAME,$JAVASCRIPT_MODULES_DIRECTORY,$filename);
    if((-e $f)&&(-f $f)){ return $f; }

    return undef;
}

# SHABTI_add_built_in_functions()
# Arguments: 1 (JE object)
# Returns: JE Object
# Description: Adds new JavaScript commands to the JE object.
sub SHABTI_add_built_in_functions {
    my $j = shift;

    # users
    # Returns an array of users in a channel
    $j->new_function(
        users => sub {
            if ( scalar @_ == 1 ) {
                my @q = SHABTI_get_users($_[0]);
                my $qa = JE::Object::Array->new($j,@q);
                return $qa;
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'users'\n";
            }
        }
    );

    # tokens
    # Tokenize a string (spaces as delimiter, with quotes)
    $j->new_function(
        tokens => sub {
            if ( scalar @_ == 1 ) {
                my @q = shellwords($_[0]);
                my $qa = JE::Object::Array->new($j,@q);
                return $qa;
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'tokens'\n";
            }
        }
    );

    # sha1
    # Calculates a sha1 hash
    $j->new_function(
        sha1 => sub {
            if ( scalar @_ == 1 ) {
                return Digest::SHA::PurePerl::sha1_hex($_[0]);
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'sha1'\n";
            }
        }
    );

    # sha256
    # Calculates a sha256 hash
    $j->new_function(
        sha256 => sub {
            if ( scalar @_ == 1 ) {
                return Digest::SHA::PurePerl::sha256_hex($_[0]);
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'sha256'\n";
            }
        }
    );

    # require
    # Loads a Javascript library
    $j->new_function(
        require => sub {
            if ( scalar @_ == 1 ) {
                my $rcf = SHABTI_require_file($_[0]);
                open(FILE,"<$rcf") or SHABTI_error(FILE_ERROR, "Error reading 'require'-ed file '$_[0]'");
                my $rc = join('',<FILE>);
                close FILE;

                if ( $j->eval($rc) ) { }
                else {
                    if ( $@ ne '' ) {
                        SHABTI_error(REQUIRE_ERROR,$@);
                    }
                }
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'require'\n";
            }
        }
    );

    # raw
    # Sends a raw command to the IRC server
    $j->new_function(
        raw => sub {
            if ( scalar @_ == 1 ) {
                print $sock "$_[0]\r\n";
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'raw'\n";
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

    # message
    $j->new_function(
        message => sub {
            if ( scalar @_ == 2 ) {
                print $sock "PRIVMSG $_[0] :$_[1]\r\n";
            }
            else {
                die new JE::Object::Error::SyntaxError $j,
                  "Wrong number of arguments to 'message'\n";
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
                open(FILE,">$_[0]") or SHABTI_error(FILE_ERROR,"Error writing to '$_[0]'");
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
                open(FILE,">>$_[0]") or SHABTI_error(FILE_ERROR,"Error appending to '$_[0]'");
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
                open(FILE,"<$_[0]") or SHABTI_error(FILE_ERROR,"Error reading from '$_[0]'");
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
                open(FILE,">$_[0]") or SHABTI_error(FILE_ERROR,"Error writing to '$_[0]'");
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
                open(FILE,">>$_[0]") or SHABTI_error(FILE_ERROR,"Error appending to '$_[0]'");
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
                mkdir($_[0]) or SHABTI_error(FILE_ERROR,"Error creating directory '$_[0]'");
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
                rmdir($_[0]) or SHABTI_error(FILE_ERROR,"Error deleting directory '$_[0]'");
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
                unlink($_[0]) or SHABTI_error(FILE_ERROR,"Error deleting file '$_[0]'");
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
                    SHABTI_error(JAVASCRIPT_ERROR,"Third argument to exit() must be 0 or 1");
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
