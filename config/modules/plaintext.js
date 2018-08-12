/*

███████╗██╗  ██╗ █████╗ ██████╗ ████████╗██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗╚══██╔══╝██║
███████╗███████║███████║██████╔╝   ██║   ██║
╚════██║██╔══██║██╔══██║██╔══██╗   ██║   ██║
███████║██║  ██║██║  ██║██████╔╝   ██║   ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝

plaintext.js

Shabti No File IO Module

Example usage:

require("plaintext.js");
WarnOnFancy = true;
ExitOnFancy = true;

*/

var WarnOnColor = false;
var ExitOnColor = false;
var SilentColorDisable = false;

var color = function(C_TEXT){
	if(ExitOnColor){
		exit("'color' has been disabled",1);
	}
	if(WarnOnColor){
		print("'color' has been disabled");
	}
	return C_TEXT;
}

var bold = function(C_TEXT){
	if(ExitOnColor){
		exit("'bold' has been disabled",1);
	}
	if(WarnOnColor){
		print("'bold' has been disabled");
	}
	return C_TEXT;
}

var italic = function(C_TEXT){
	if(ExitOnColor){
		exit("'italic' has been disabled",1);
	}
	if(WarnOnColor){
		print("'italic' has been disabled");
	}
	return C_TEXT;
}

var underline = function(C_TEXT){
	if(ExitOnColor){
		exit("'underline' has been disabled",1);
	}
	if(WarnOnColor){
		print("'underline' has been disabled");
	}
	return C_TEXT;
}
