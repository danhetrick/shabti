/*

███████╗██╗  ██╗ █████╗ ██████╗ ████████╗██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗╚══██╔══╝██║
███████╗███████║███████║██████╔╝   ██║   ██║
╚════██║██╔══██║██╔══██║██╔══██╗   ██║   ██║
███████║██║  ██║██║  ██║██████╔╝   ██║   ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝

commands.js

Shabti Channels Module

Example usage:

require("channels.js");

var topic = GetTopic("#foo");
var users = AllUsersList();
var channels = AllChannelsList();

Functions:

	GetTopic(CH_NAME)
		Returns a channels topic, if it's known.

	AllUsersList()
		Returns an array containing all user nick in all channels
		the bot is in.

	AllChannelsList()
		Returns an array containing all channels the bot is in.

*/

require("common");

var ChannelList = new Array();

function GetTopic(CH_NAME){
	for(var i=0, len=ChannelList.length; i < len; i++){
		if(ChannelList[i].name==CH_NAME){
			return ChannelList[i].topic;
		}
	}
}

function AllUsersList(){
	var ret = new Array();
	for(var i=0, len=ChannelList.length; i < len; i++){
		var u = ChannelList[i].users();
		for(var i=0, len=u.length; i < len; i++){
			ret.push(u[i]);
		}
	}
	return removeDuplicatesFromArray(ret);
}

function AllChannelsList(){
	var ret = new Array();
	for(var i=0, len=ChannelList.length; i < len; i++){
		ret.push(ChannelList[i].name);
	}
	return removeDuplicatesFromArray(ret);
}

function JOIN_EVENT_2(EV_NICK,EV_USERNAME,EV_CHANNEL) {
	if(EV_NICK == SV_NICK){
		var chan = new Channel(EV_CHANNEL);
		ChannelList.push(chan);
	}
}

function PART_EVENT_2(EV_NICK,EV_USERNAME,EV_CHANNEL) {
	if(EV_NICK == SV_NICK){
		var clean = new Array();
		for(var i=0, len=ChannelList.length; i < len; i++){
			if(ChannelList[i].name==EV_CHANNEL){}else{
				clean.push(ChannelList[i]);
			}
		}
		ChannelList = clean;
	}
}

function IRC_EVENT_2(EV_RAW,EV_TYPE,EV_HOST,EV_NICK,EV_MESSAGE) {
	if(EV_TYPE=="topic"){
		for(var i=0, len=ChannelList.length; i < len; i++){
			if(ChannelList[i].name==EV_NICK){
				ChannelList[i].topic = EV_MESSAGE;
			}
		}
	}
}

function Channel(CH_NAME){
	this.name = CH_NAME;
	this.users = function(){
		return users(this.name);
	}
	this.topic = "";
}
