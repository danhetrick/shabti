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
=====================
=
SERVER = The name/host of the IRC server connected to
PORT = The port that the bot connected to
NICK = Bot's nick
USER = Bot's username
IRCNAME = Bot's IRC name
TIME = Server time
DATE = Server date
BOT = The name of the bot's software
VERSION = The version of the bot's software
LOCAL_DIRECTORY = The directory Shabti is installed to
CONFIG_DIRECTORY = The configuration directory Shabti is using
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

// startup()
// Executed when the bot is first loaded, before everything else
// is loaded or executed.
function startup() {
	print("=========================");
	print("| shabti default script |");
	print("=========================");
	print("");
}

// connect_event()
// Executed when the bot first connects to the IRC server.
// host = name of the server connected to
function connect_event(host) {
	print("*** Connected to "+host);
}

// nick_taken_event()
// Executed if the bot's chosen nick is in use. The code below
// will change the bot's nick to "shabti" followed by a couple of
// randomly selected numbers.
function nick_taken_event() {
	print("*** Nick taken. Changing to new nick");
	rnick(NICK);
}

// ping_event()
// Executed every time the client receives a "PING?" from the server.
// Responding to the server with "PONG" is not necessary, and is
// handled automatically by the bot.
function ping_event() {
	print("*** PING? PONG!");
}

// time_event()
// Executed every time the bot receives time information from the server.
// weekday = day of the week
// month = name of month
// day = day of month
// year = what year the server is operating in
// hour = hour of the day (24 hour clock)
// minute = minute of the hour
// second = second of the minute
// zone = time zone
function time_event(weekday,month,day,year,hour,minute,second,zone) {
	// print("Server Time: "+weekday+ " "+month+" "+day+", "+year+" - "+hour+":"+minute+":"+second+" ("+zone+")");
}

// public_message_event()
// Executed whenever the bot receives a public message.
// nick = the user who sent the message
// username = the sender's username
// channel = the channel the message was sent to
// message = the contents of the message
function public_message_event(nick,username,channel,message) {
	print(channel+" <"+nick+"> "+message);
}

// action_event()
// Executed whenever the bot receives an action message.
// nick = the user who sent the message
// username = the sender's username
// channel = the channel the message was sent to
// action = the contents of the action message
function action_event(nick,username,channel,action) {
	print(channel+" *"+nick+" "+action+"*");
}

// private_message_event()
// Executed whenever the bot receives a private message.
// nick = the user who sent the message
// username = the sender's username
// message = the contents of the message
function private_message_event(nick,username,message) {
	print("PRIVATE >"+nick+"< "+message);
}

// mode_event()
// Executed every time the bot receives mode information from the server.
// nick = the user who set the mode; if server set the mode, the server's name
// username = the username of the user; if server set the mode, this will be an empty string
// target = the target of the mode settings
// mode = the mode set
function mode_event(nick,username,target,mode) {
	if(username==""){
		print("*** "+nick+" sets mode "+mode+" on "+target);
	} else {
		print("*** "+nick+" ("+username+") sets mode "+mode+" on "+target);
	}
}

// part_event()
// Executed every time a user leaves a channel the bot is present in.
// nick = the user who left
// username = the username of the user who left
// channel = the channel left
// message = the part message, if there is one; blank if not
function part_event(nick,username,channel,message) {
	if(message==""){
		print("*** "+nick+" ("+username+") left "+channel);
	} else {
		print("*** "+nick+" ("+username+") left "+channel+": "+message);
	}
}

// join_event()
// Executed every time a user joins a channel the bot is present in.
// nick = the user who joined
// username = the username of the user who joined
// channel = the channel joined
function join_event(nick,username,channel) {
	print("*** "+nick+" ("+username+") joined "+channel);
}

// other_event()
// Executed every time *any other event* not covered by other functions is
// received by the bot.
// raw = the "raw" message sent by the server
// type = the message type, as defined by RFCs
// host = the name of the server sending the message
// nick = the nick of the bot
// content = the content of the message
function other_event(raw,type,host,nick,content) {
	//print("*** "+raw);
}

