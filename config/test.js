

function public(ARGS){
	print("<"+ARGS.Nick+"> "+ARGS.Message);
}
hook("public","public");

function private(ARGS){
	print(">"+ARGS.Nick+"< "+ARGS.Message);
	print(uptime());
	print(approximate_uptime());
}
hook("private","private");

function notice(ARGS){
	print("*"+ARGS.Nick+"* "+ARGS.Message);
}
hook("notice","notice");
