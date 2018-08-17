/*

███████╗██╗  ██╗ █████╗ ██████╗ ████████╗██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗╚══██╔══╝██║
███████╗███████║███████║██████╔╝   ██║   ██║
╚════██║██╔══██║██╔══██║██╔══██╗   ██║   ██║
███████║██║  ██║██║  ██║██████╔╝   ██║   ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝

commands.js

Shabti Command Module

Example usage:

require("commands.js");
var Commands = new CommandList("shabti","1.0","!help");

function cmd_hello(args,caller,channel){
	message(caller,"Hello!");
}
Commands.add("!hello","Says hello","Usage: !hello",0,cmd_hello);

function PUBLIC_MESSAGE_EVENT(EV_NICK,EV_USERNAME,EV_CHANNEL,EV_MESSAGE) {
	CommandHandler(Commands,EV_MESSAGE,EV_NICK,EV_CHANNEL);
}

Objects:

function CommandList();
	CommandList.add(COMMAND,USAGE_TEXT,MINIMUM_ARGUMENT_COUNT,FUNCTION_NAME)
		Adds a command to the list
	CommandList.execute(COMMAND,ARGUMENT_ARRAY,CALLER_NICK,CALLER_CHANNEL)
		Executes a command
	CommandList.exists(COMMAND)
		Tests if a command exists or not
	CommandList.usage(COMMAND)
		Returns command usage text
	CommandList.numargs(COMMAND)
		Returns the number of arguments a command requires
	CommandList.help(TEXT_REPLACE)
		Returns an array of all usage text. If TEXT_REPLACE is passed
		as a parameter, any instance of TEXT_REPLACE will be removed
		from usage text.

Functions:

CommandHandler(CMD_LIST,CMD_MESSAGE,CMD_CALLER,CMD_CHANNEL);
	Takes chat input, scans for command triggers, and executes them.

*/

function CommandHandler(CMD_LIST,CMD_MESSAGE,CMD_CALLER,CMD_CHANNEL){
	if(CMD_LIST instanceof CommandList){}else{
		exit("CommandList not passed to CommandHandler",1);
	}

	var c = new CommandParse(CMD_MESSAGE);

	if(CMD_LIST.exists(c.command)){
		if(CMD_LIST.numargs(c.command)==c.numargs){
			CMD_LIST.execute(c.command,c.args,CMD_CALLER,CMD_CHANNEL);
		} else {
			message(CMD_CALLER,bold(CMD_LIST.usage(c.command)));
		}
	}

}

function CommandList(){
	this.commands = new Array();
	this.argCount = new Array();
	this.functionality = new Array();
	this.usageText = new Array();

	this.add = function(cmd,cusage,argc,func){
		for(var i=0, len=this.commands.length; i < len; i++){
			if(this.commands[i]==cmd){
				return false;
			}
		}
		this.commands.push(cmd);
		this.argCount.push(argc);
		this.functionality.push(func);
		this.usageText.push(cusage);
		return true;
	}

	this.execute = function(cmd,args,scmd_caller,scmd_channel){
		for(var i=0, len=this.commands.length; i < len; i++){
			if(this.commands[i]==cmd){
				var func = this.functionality[i];
				func(args,scmd_caller,scmd_channel);
			}
		}
	}

	this.exists = function(cmd){
		for(var i=0, len=this.commands.length; i < len; i++){
			if(this.commands[i]==cmd){
				return true;
			}
		}
		return false;
	}

	this.usage = function(cmd){
		for(var i=0, len=this.commands.length; i < len; i++){
			if(this.commands[i]==cmd){
				return this.usageText[i];
			}
		}
		return "none";
	}

	this.help = function(textReplace){
		var dusage = new Array();
		for(var i=0, len=this.commands.length; i < len; i++){
			if(typeof(textReplace)!="undefined"){
				var clean = this.usageText[i].replace(new RegExp(textReplace,"g"), '');
				dusage.push(clean);
			} else {
				dusage.push(this.usageText[i]);
			}
		}
		return dusage;
	}

	this.numargs = function(cmd){
		for(var i=0, len=this.commands.length; i < len; i++){
			if(this.commands[i]==cmd){
				return this.argCount[i];
			}
		}
		return "none";
	}
}

function CommandParse(SHABTI_TEXT){
	this.raw = SHABTI_TEXT;

	var t = tokens(SHABTI_TEXT);
	this.command = t.shift();
	this.numargs = t.length;
	this.args = t;

}
