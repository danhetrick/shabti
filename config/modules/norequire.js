/*

███████╗██╗  ██╗ █████╗ ██████╗ ████████╗██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗╚══██╔══╝██║
███████╗███████║███████║██████╔╝   ██║   ██║
╚════██║██╔══██║██╔══██║██╔══██╗   ██║   ██║
███████║██║  ██║██║  ██║██████╔╝   ██║   ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝

norequire.js

Shabti No Require Module

Example usage:

require("norequire.js");

*/

var WarnOnRequire = false;
var ExitOnRequire = false;

var require = function(){
	if(ExitOnRequire){
		exit("'require' function disabled",1);
	}
	if(WarnOnRequire){
		print("'require' function disabled");
	}
}
