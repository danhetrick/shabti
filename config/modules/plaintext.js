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

var color = function(){
	if(ExitOnColor){
		exit("'color' has been disabled",1);
	}
	if(WarnOnColor){
		print("'color' has been disabled");
	}
}

var bold = function(){
	if(ExitOnColor){
		exit("'bold' has been disabled",1);
	}
	if(WarnOnColor){
		print("'bold' has been disabled");
	}
}

var italic = function(){
	if(ExitOnColor){
		exit("'italic' has been disabled",1);
	}
	if(WarnOnColor){
		print("'italic' has been disabled");
	}
}

var underline = function(){
	if(ExitOnColor){
		exit("'underline' has been disabled",1);
	}
	if(WarnOnColor){
		print("'underline' has been disabled");
	}
}
