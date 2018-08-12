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
var mydb = new SimpleDB();

mydb.set("name","bob");
print(mydb.get("name"));
mydb.write("/home/user/mydb.txt");

Objects:

function SimpleDB();
	SimpleDB.read(FILENAME)
		Loads a database from disk.
	SimpleDB.write(FILENAME)
		Writes the database to disk.
	SimpleDB.set(ENTRY,VALUE)
		Sets an entry/value pair.
	SimpleDB.get(ENTRY)
		Gets an entry's value, or 'undefined' if the entry doesn't exist.
	SimpleDB.exists(ENTRY)
		Returns true if the entry exists, false if not.

*/

function SimpleDB(){
	this.contents = new Array();

	this.read = function(DB_FILENAME){
		if(fileexists(DB_FILENAME)){
			var f = read(DB_FILENAME);
			this.contents = new Array();
			this.contents = f.split("\n");
			return true;
		} else {
			this.contents = new Array();
			return false;
		}
	}

	this.write = function(DB_FILENAME){
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
