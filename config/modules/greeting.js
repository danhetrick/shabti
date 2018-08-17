/*

███████╗██╗  ██╗ █████╗ ██████╗ ████████╗██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗╚══██╔══╝██║
███████╗███████║███████║██████╔╝   ██║   ██║
╚════██║██╔══██║██╔══██║██╔══██╗   ██║   ██║
███████║██║  ██║██║  ██║██████╔╝   ██║   ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝

greeting.js

Shabti Greeting Module

Example usage:

require("greeting.js");

Greeting("Hello, and welcome to our channel!");
ChannelGreeting("Everybody say hello to %NICK%!");

Functions:

In all greeting messages:
	%NICK% will be replaced with the nick of the joiner.
	%USERNAME% will be replaced with the username of the joiner.
	%CHANNEL% will be replaced with the name of the channel joined.

Greet(GREETING_MESSAGE)
	Sends a private message greeting to anyone joining a channel the bot is in.

ChannelGreet(GREETING_MESSAGE)
	Sends a greeting to the channel when someone joins the channel.

*/

var MODULE_GREET = false;
var MODULE_CHANNEL_GREET = false;
var MODULE_GREETING_MESSAGE = new Array();
var MODULE_CHANNEL_GREETING_MESSAGE = new Array();

function Greet(GREETING_MESSAGE){
	if(GREETING_MESSAGE instanceof Array){
		MODULE_GREETING_MESSAGE = GREETING_MESSAGE;
	} else {
		MODULE_GREETING_MESSAGE.push(GREETING_MESSAGE);
	}
	MODULE_GREET = true;
}

function ChannelGreet(GREETING_MESSAGE){
	if(GREETING_MESSAGE instanceof Array){
		MODULE_CHANNEL_GREETING_MESSAGE = GREETING_MESSAGE;
	} else {
		MODULE_CHANNEL_GREETING_MESSAGE.push(GREETING_MESSAGE);
	}
	MODULE_CHANNEL_GREET = true;
}

function JOIN_EVENT_1(EV_NICK,EV_USERNAME,EV_CHANNEL) {
	if(MODULE_GREET){
		for(var i=0, len=MODULE_GREETING_MESSAGE.length; i < len; i++){
			var p = InjectIntoGreeting(MODULE_GREETING_MESSAGE[i],EV_NICK,EV_USERNAME,EV_CHANNEL);
			message(EV_NICK,p);
		}
	}
	if(MODULE_CHANNEL_GREET){
		for(var i=0, len=MODULE_CHANNEL_GREETING_MESSAGE.length; i < len; i++){
			var p = InjectIntoGreeting(MODULE_CHANNEL_GREETING_MESSAGE[i],EV_NICK,EV_USERNAME,EV_CHANNEL);
			message(EV_CHANNEL,p);
		}
	}
}

function InjectIntoGreeting(GREETING,G_NICK,G_USERNAME,G_CHANNEL){
	var p = GREETING.replace(new RegExp("$NICK","g"), G_NICK);
	p = p.replace(new RegExp("$CHANNEL","g"), G_CHANNEL);
	p = p.replace(new RegExp("$USERNAME","g"), G_USERNAME);
	return p;
}
