/*

███████╗██╗  ██╗ █████╗ ██████╗ ████████╗██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗╚══██╔══╝██║
███████╗███████║███████║██████╔╝   ██║   ██║
╚════██║██╔══██║██╔══██║██╔══██╗   ██║   ██║
███████║██║  ██║██║  ██║██████╔╝   ██║   ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝

default.js

======================
| Built-in variables |
======================
SV_SERVER = The name/host of the IRC server connected to
SV_PORT = The port that the bot connected to
SV_NICK = Bot's nick
SV_USER = Bot's username
SV_IRCNAME = Bot's IRC name
SV_TIME = Server time
SV_DATE = Server date
SV_BOT = The name of the bot's software
SV_VERSION = The version of the bot's software
SV_LOCAL_DIRECTORY = The directory Shabti is installed to
SV_CONFIG_DIRECTORY = The configuration directory Shabti is using
WHITE = Color white, for use with the color() function
BLACK = Color black, for use with the color() function
BLUE = Color blue, for use with the color() function
GREEN = Color green, for use with the color() function
RED = Color red, for use with the color() function
BROWN = Color brown, for use with the color() function
PURPLE = Color purple, for use with the color() function
ORANGE = Color orange, for use with the color() function
YELLOW = Color yellow, for use with the color() function
LIGHT_GREEN = Color light green, for use with the color() function
TEAL = Color teal, for use with the color() function
CYAN = Color cyan, for use with the color() function
LIGHT_BLUE = Color light blue, for use with the color() function
PINK = Color pink, for use with the color() function
GREY = Color grey, for use with the color() function
LIGHT_GREY = Color light grey, for use with the color() function

*/

// CONNECT_EVENT()
// Executed when the bot first connects to the IRC server.
// EV_HOST = name of the server connected to
function CONNECT_EVENT(EV_HOST) {
	print("*** Connected to "+EV_HOST);
}

// NICK_TAKEN_EVENT()
// Executed if the bot's chosen nick is in use. The code below
// will change the bot's nick to "shabti" followed by a couple of
// randomly selected numbers.
function NICK_TAKEN_EVENT() {
	print("*** Nick taken. Changing to new nick");
	rnick(SV_NICK);
}

// PING_EVENT()
// Executed every time the client receives a "PING?" from the server.
// Responding to the server with "PONG" is not necessary, and is
// handled automatically by the bot.
function PING_EVENT() {
	print("*** PING? PONG!");
}

// TIME_EVENT()
// Executed every time the bot receives time information from the server.
// EV_WEEKDAY = day of the week
// EV_MONTH = name of month
// EV_DAY = day of month
// EV_YEAR = what year the server is operating in
// EV_HOUR = hour of the day (24 hour clock)
// EV_MINUTE = minute of the hour
// EV_SECOND = second of the minute
// EV_ZONE = time zone
function TIME_EVENT(EV_WEEKDAY,EV_MONTH,EV_DAY,EV_YEAR,EV_HOUR,EV_MINUTE,EV_SECOND,EV_ZONE) {
	// print("Server Time: "+EV_WEEKDAY+ " "+EV_MONTH+" "+EV_DAY+", "+EV_YEAR+" - "+EV_HOUR+":"+EV_MINUTE+":"+EV_ECOND+" ("+EV_ZONE+")");
}

// PUBLIC_MESSAGE_EVENT()
// Executed whenever the bot receives a public message.
// EV_NICK = the user who sent the message
// EV_USERNAME = the sender's username
// EV_CHANNEL = the channel the message was sent to
// EV_MESSAGE = the contents of the message
function PUBLIC_MESSAGE_EVENT(EV_NICK,EV_USERNAME,EV_CHANNEL,EV_MESSAGE) {
	print(EV_CHANNEL+" <"+EV_NICK+"> "+EV_MESSAGE);
}

// ACTION_EVENT()
// Executed whenever the bot receives an action message.
// EV_NICK = the user who sent the message
// EV_USERNAME = the sender's username
// EV_CHANNEL = the channel the message was sent to
// EV_ACTION = the contents of the action message
function ACTION_EVENT(EV_NICK,EV_USERNAME,EV_CHANNEL,EV_ACTION) {
	print(EV_CHANNEL+" *"+EV_NICK+" "+EV_ACTION+"*");
}

// PRIVATE_MESSAGE_EVENT()
// Executed whenever the bot receives a private message.
// EV_NICK = the user who sent the message
// EV_USERNAME = the sender's username
// EV_MESSAGE = the contents of the message
function PRIVATE_MESSAGE_EVENT(EV_NICK,EV_USERNAME,EV_MESSAGE) {
	print("PRIVATE >"+EV_NICK+"< "+EV_MESSAGE);
}

// MODE_EVENT()
// Executed every time the bot receives mode information from the server.
// EV_NICK = the user who set the mode; if server set the mode, the server's name
// EV_USERNAME = the username of the user; if server set the mode, this will be an empty string
// EV_TARGET = the target of the mode settings
// EV_MODE = the mode set
function MODE_EVENT(EV_NICK,EV_USERNAME,EV_TARGET,EV_MODE) {
	if(EV_USERNAME==""){
		print("*** "+EV_NICK+" sets mode "+EV_MODE+" on "+EV_TARGET);
	} else {
		print("*** "+EV_NICK+" ("+EV_USERNAME+") sets mode "+EV_MODE+" on "+EV_TARGET);
	}
}

// PART_EVENT()
// Executed every time a user leaves a channel the bot is present in.
// EV_NICK = the user who left
// EV_USERNAME = the username of the user who left
// EV_CHANNEL = the channel left
// EV_MESSAGE = the part message, if there is one; blank if not
function PART_EVENT(EV_NICK,EV_USERNAME,EV_CHANNEL,EV_MESSAGE) {
	if(EV_MESSAGE==""){
		print("*** "+EV_NICK+" ("+EV_USERNAME+") left "+EV_CHANNEL);
	} else {
		print("*** "+EV_NICK+" ("+EV_USERNAME+") left "+EV_CHANNEL+": "+EV_MESSAGE);
	}
}

// JOIN_EVENT()
// Executed every time a user joins a channel the bot is present in.
// EV_NICK = the user who joined
// EV_USERNAME = the username of the user who joined
// EV_CHANNEL = the channel joined
function JOIN_EVENT(EV_NICK,EV_USERNAME,EV_CHANNEL) {
	print("*** "+EV_NICK+" ("+EV_USERNAME+") joined "+EV_CHANNEL);
}

// IRC_EVENT()
// Executed every time *any other event* not covered by other functions is
// received by the bot.
// EV_RAW = the "raw" message sent by the server
// EV_TYPE = the message type, as defined by RFCs
// EV_HOST = the name of the server sending the message
// EV_NICK = the nick of the bot
// EV_MESSAGE = the content of the message
function IRC_EVENT(EV_RAW,EV_TYPE,EV_HOST,EV_NICK,EV_MESSAGE) {
	//print("*** "+EV_RAW);
}

