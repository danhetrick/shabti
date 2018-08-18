/*

███████╗██╗  ██╗ █████╗ ██████╗ ████████╗██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗╚══██╔══╝██║
███████╗███████║███████║██████╔╝   ██║   ██║
╚════██║██╔══██║██╔══██║██╔══██╗   ██║   ██║
███████║██║  ██║██║  ██║██████╔╝   ██║   ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝

nofileio.js

Shabti No File IO Module

Example usage:

require("nofileio.js");
WarnOnFileIO = true;
ExitOnFileIO = true;

*/

var WarnOnFileIO = false;
var ExitOnFileIO = false;

var read = function(ARG) {
	// do nothing
	if(ExitOnFileIO){
		exit("'read' function disabled",1);
	}
	if(WarnOnFileIO){
		print("'read' function disabled");
	}
}

var write = function(ARG,ARG1){
	// do nothing
	if(ExitOnFileIO){
		exit("'write' function disabled",1);
	}
	if(WarnOnFileIO){
		print("'write' function disabled");
	}
}

var swrite = function(ARG,ARG1){
	// do nothing
	if(ExitOnFileIO){
		exit("'swrite' function disabled",1);
	}
	if(WarnOnFileIO){
		print("'swrite' function disabled");
	}
}

var append = function(ARG,ARG1){
	// do nothing
	if(ExitOnFileIO){
		exit("'append' function disabled",1);
	}
	if(WarnOnFileIO){
		print("'append' function disabled");
	}
}

var sappend = function(ARG,ARG1){
	// do nothing
	if(ExitOnFileIO){
		exit("'sappend' function disabled",1);
	}
	if(WarnOnFileIO){
		print("'sappend' function disabled");
	}
}

var fileexists = function(ARG,ARG1){
	// do nothing
	if(ExitOnFileIO){
		exit("'fileexists' function disabled",1);
	}
	if(WarnOnFileIO){
		print("'fileexists' function disabled");
	}
}

var direxists = function(ARG,ARG1){
	// do nothing
	if(ExitOnFileIO){
		exit("'direxists' function disabled",1);
	}
	if(WarnOnFileIO){
		print("'direxists' function disabled");
	}
}

var mkdir = function(ARG,ARG1){
	// do nothing
	if(ExitOnFileIO){
		exit("'mkdir' function disabled",1);
	}
	if(WarnOnFileIO){
		print("'mkdir' function disabled");
	}
}

var rmdir = function(ARG,ARG1){
	// do nothing
	if(ExitOnFileIO){
		exit("'rmdir' function disabled",1);
	}
	if(WarnOnFileIO){
		print("'rmdir' function disabled");
	}
}

var delete = function(ARG,ARG1){
	// do nothing
	if(ExitOnFileIO){
		exit("'delete' function disabled",1);
	}
	if(WarnOnFileIO){
		print("'delete' function disabled");
	}
}
