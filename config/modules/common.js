/*

███████╗██╗  ██╗ █████╗ ██████╗ ████████╗██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗╚══██╔══╝██║
███████╗███████║███████║██████╔╝   ██║   ██║
╚════██║██╔══██║██╔══██║██╔══██╗   ██║   ██║
███████║██║  ██║██║  ██║██████╔╝   ██║   ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝

common.js

Shabti Common Module

Example usage:

require("common.js");

array = removeDuplicatesFromArray(array);
dumpArray(array);
var entry = randomArrayValue(array);
var num = randomNumberFromRange(1,100);
array = shuffleArray(array);
mystring = trim(mystring);

Functions:

	removeDuplicatesFromArray(ARRAY)
		Removes duplicates from an array, and returns the cleaned array.

	dumpArray(ARRAY)
		Prints all values in an array.

	randomArrayValue(ARRAY)
		Returns a randomly selected array value.

	randomNumberFromRange(MINIMUM,MAXIMUM)
		Returns a random number from a range.

	shuffleArray(ARRAY)
		Returns a shuffled array.

	trim(STRING)
		Returns string with leading and ending whitespace removed.

*/

function removeDuplicatesFromArray(a) {
    var seen = {};
    var out = [];
    var len = a.length;
    var j = 0;
    for(var i = 0; i < len; i++) {
         var item = a[i];
         if(seen[item] !== 1) {
               seen[item] = 1;
               out[j++] = item;
         }
    }
    return out;
}

function dumpArray(MYARRAY){
	for(var i=0, len=MYARRAY.length; i < len; i++){
		print(MYARRAY[i]);
	}
}

function randomArrayValue(MYARRAY){
	return MYARRAY[Math.floor(Math.random() * MYARRAY.length)];
}

function randomNumberFromRange(MINIMUM,MAXIMUM){
	return Math.floor(Math.random() * (MAXIMUM - MINIMUM + 1)) + MINIMUM;
}

function shuffleArray(MYARRAY) {
    var tmp, current, top = MYARRAY.length;
    if(top) while(--top) {
        current = Math.floor(Math.random() * (top + 1));
        tmp = MYARRAY[current];
        MYARRAY[current] = MYARRAY[top];
        MYARRAY[top] = tmp;
    }
    return MYARRAY;
}

function trim(MYSTRING){
	return MYSTRING.replace(new RegExp("^\\s+|s+$","g"), '');
}
