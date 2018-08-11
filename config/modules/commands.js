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

function CommandList(BOT_NAME,BOT_VERSION,HELP_COMMAND);
	CommandList.help()
		Generates and returns help text.
	CommandList.add(COMMAND,DESCRIPTION,USAGE_TEXT,MINIMUM_ARGUMENT_COUNT,FUNCTION_NAME)
		Adds a command to the list
	CommandList.execute(COMMAND,ARGUMENT_ARRAY,CALLER_NICK,CALLER_CHANNEL)
		Executes a command
	CommandList.exists(COMMAND)
		Tests if a command exists or not
	CommandList.uhelp(COMMAND)
		Returns command usage text
	CommandList.description(COMMAND)
		Returns command description text
	CommandList.numargs(COMMAND)
		Returns the minimum number of arguments a command requires

Functions:

CommandHandler(CMD_LIST,CMD_MESSAGE,CMD_CALLER,CMD_CHANNEL);
	Takes chat input, scans for command triggers, and executes them.

*/

function CommandHandler(CMD_LIST,CMD_MESSAGE,CMD_CALLER,CMD_CHANNEL){
	if(CMD_LIST instanceof CommandList){}else{
		exit("CommandList not passed to CommandHandler",1);
	}

	var c = new CommandParse(CMD_MESSAGE);

	if(c.command.toLowerCase()==CMD_LIST.cmdHelp.toLowerCase()){
		var h = CMD_LIST.help();
		for(var i=0, len=h.length; i < len; i++){
			message(CMD_CHANNEL,h[i]);
		}
		return;
	}

	if(CMD_LIST.exists(c.command)){
		if(CMD_LIST.numargs(c.command)<=c.numargs){
			CMD_LIST.execute(c.command,c.args,CMD_CALLER,CMD_CHANNEL);
		} else {
			message(CMD_CALLER,bold(CMD_LIST.uhelp(c.command)));
		}
	}

}

function CommandList(BOT_NAME,BOT_VERSION,CMD_HELP){
	this.commands = new Array();
	this.descriptions = new Array();
	this.argCount = new Array();
	this.functionality = new Array();
	this.usage = new Array();
	this.cmdHelp = CMD_HELP;

	this.help = function(){
		var helptext = new Array;
		helptext.push(BOT_NAME+" "+BOT_VERSION);
		for(var i=0, len=this.commands.length; i < len; i++){
			if(this.argCount[i]==0){
				helptext.push(underline(bold(this.commands[i]))+"\t(no arguments) -\t"+italic(this.descriptions[i]));
			} else if(this.argCount[i]==1){
				helptext.push(underline(bold(this.commands[i]))+"\t(1 argument) -\t"+italic(this.descriptions[i]));
			} else {
				helptext.push(underline(bold(this.commands[i]))+"\t("+this.argCount[i]+" arguments) -\t"+italic(this.descriptions[i]));
			}
		}
		return helptext;
	}

	this.add = function(cmd,desc,cusage,argc,func){
		for(var i=0, len=this.commands.length; i < len; i++){
			if(this.commands[i]==cmd){
				return false;
			}
		}
		this.commands.push(cmd);
		this.descriptions.push(desc);
		this.argCount.push(argc);
		this.functionality.push(func);
		this.usage.push(cusage);
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

	this.uhelp = function(cmd){
		for(var i=0, len=this.commands.length; i < len; i++){
			if(this.commands[i]==cmd){
				return this.usage[i];
			}
		}
		return "none";
	}

	this.description = function(cmd){
		for(var i=0, len=this.commands.length; i < len; i++){
			if(this.commands[i]==cmd){
				return this.descriptions[i];
			}
		}
		return "none";
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

	var tokens = SHABTI_TEXT.split(" ");
	this.command = tokens.shift();
	this.numargs = tokens.length;
	this.args = tokens;

}
