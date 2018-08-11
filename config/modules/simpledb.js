/*

███████╗██╗  ██╗ █████╗ ██████╗ ████████╗██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗╚══██╔══╝██║
███████╗███████║███████║██████╔╝   ██║   ██║
╚════██║██╔══██║██╔══██║██╔══██╗   ██║   ██║
███████║██║  ██║██║  ██║██████╔╝   ██║   ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝

simpledb.js

Shabti Simple Database Module

Example usage:

require("simpledb.js");
var mydb = new SimpleDB("/home/user/mydb.txt");

mydb.set("name","bob");
print(mydb.get("name"));
mydb.write();

Objects:

function SimpleDB(DB_FILENAME);
	SimpleDB.read()
		Reloads the database from disk.
	SimpleDB.write()
		Writes the databse to disk.
	SimpleDB.set(ENTRY,VALUE)
		Sets an entry/value pair.
	SimpleDB.get(ENTRY)
		Gets an entry's value, or 'undefined' if the entry doesn't exist.
	SimpleDB.exists(ENTRY)
		Returns true if the entry exists, false if not.

*/

function SimpleDB(DB_FILENAME){
	this.filename = DB_FILENAME;
	this.contents = new Array();

	if(fileexists(this.filename)){
		var f = read(this.filename);
		this.contents = f.split("\n");
	}

	this.read = function(){
		if(fileexists(this.filename)){
			var f = read(this.filename);
			this.contents = new Array();
			this.contents = f.split("\n");
		} else {
			this.contents = new Array();
		}
	}

	this.write = function(){
		var f = this.contents.join("\n");
		write(this.filename,f);
	}

	this.copy = function(DB_FILENAME){
		var f = this.contents.join("\n");
		write(DB_FILENAME,f);
	}

	this.exists = function(db_entry){
		for(var i=0, len=this.contents.length; i < len; i++){
			var dbe = this.contents[i].split("=");
			if(db_entry==dbe[0]){
				return true;
			}
		}
		return false;
	}

	this.get = function(db_entry){
		for(var i=0, len=this.contents.length; i < len; i++){
			var dbe = this.contents[i].split("=");
			if(db_entry==dbe[0]){
				return dbe[1];
			}
		}
		return undefined;
	}

	this.set = function(db_entry,db_value){
		var new_db = new Array();
		var ent_found = false;
		for(var i=0, len=this.contents.length; i < len; i++){
			var dbe = this.contents[i].split("=");
			var ent = "";
			if(db_entry==dbe[0]){
				ent = db_entry+"="+db_value;
				ent_found = true;
			} else {
				ent = this.contents[i];
			}
			new_db.push(ent);
		}
		if(ent_found==false){
			new_db.push(db_entry+"="+db_value);
		}
		this.contents = new_db;
	}
}
