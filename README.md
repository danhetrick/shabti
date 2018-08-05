![Shabti IRC Bot](https://github.com/danhetrick/shabti/blob/master/shabti_logo.png?raw=true)

# Summary

**Shabti** is an IRC bot, powered by Perl and Javascript.  More specifically, it's an IRC bot written in pure Perl, which can have all its behavior programmed with Javascript.  **Shabti** uses [**JE**](https://metacpan.org/pod/JE), a pure Perl Javascript engine by [Father Chrysostomos](https://metacpan.org/author/SPROUT).  Without any modification, **Shabti** doesn't really do anything.  It can connect to an IRC server, join channels, and...well, that's about it.  What **Shabti** does is up to *you*.

# Name

"The ushabti (also called shabti or shawabti, with a number of variant spellings, Ancient Egyptian plural: ushabtiu) was a funerary figurine used in Ancient Egypt. Ushabtis were placed in tombs among the grave goods and were intended to act as servants or minions for the deceased, should they be called upon to do manual labor in the afterlife....Called “answerers,” they carried inscriptions asserting their readiness to answer the gods' summons to work." - [Wikipedia](https://en.wikipedia.org/wiki/Ushabti)

# Installation

* README.md
* shabti.pl
	* lib
		* *modules necessary for Shabti to run properly*
	* config
		* default.js
		* default.xml

# Usage

	perl shabti.pl [OPTIONS]

	Options:
	--(h)elp			Displays this text
	--(s)server HOST		Sets the IRC server to connect to
	--(p)ort PORT_NUMBER		Sets the IRC server port to connect to
	--(n)ick NICK			Sets the bot's nick
	--(u)sername USERNAME		Sets the bot's username
	--(i)rcname IRCNAME		Sets the bot's IRCname
	--(c)onfig FILENAME		Sets the configuration file to load
	--(j)avascript FILENAME		Sets the bot's JavaScript code
	--(d)ebug			Print all incoming IRC server messages
	--no(b)anner			Prevent banner display at startup
	--no(P)rint			Prevent JavaScript from printing to the console
	--(q)uiet			Prevent all console printing
	--no(C)onfig			Don't load settings from 'default.xml'		

# Configuration

There are two ways to configure **Shabti**: using `default.xml` (or another configuration file), or from the command-line.

## Command-line Configuration

Simply put, this is using **Shabti**'s command-line options for configuration. It should be fairly straight forward if you have experience with using console or command-line programs.  If not, read the rest of this document, and hopefully, it'll become clearer.

Let's say that you have the code that you want **Shabti** to use in a file named `/home/bob/mybot.js`.  You don't want to load any configuration files, using only the command-line options you supply to configure the bot.  You want **Shabti** to connect to *Chicago.IL.US.Undernet.org*, on port 6667, and use "ShabtiBot" as its nickname. Once **Shabti** is running, you don't want the bot to print anything to the console. Here's the command-line you'd use:

```bash
perl shabti.pl --noconfig --quiet --javascript /home/bob/mybot.js --server Chicago.IL.US.Undernet.org --port 6667 --nick ShabtiBot
```

Or, more cryptically:

```bash
perl shabti.pl -Cq -j /home/bob/mybot.js -s Chicago.IL.US.Undernet.org -p 6667 -n ShabtiBot
```

## Configuration Files

**Shabti** uses an XML format for configuration files;  they contain one root element, `configuration`, and seven child elements: `server`, `port`, `nick`, `username`, `ircname`, `channel`, and `script`.  The root element and five of the child elements (`server`, `port`, `nick`, `username`, and `ircname`) can appear only once per configuration file.  The other two child elements (`channel` and `script`) can appear multiple times.  Here's an example configuration file:

```xml
<?xml version="1.0"?>
<configuration>
	<server>localhost</server>
	<port>6667</port>
	<nick>Shabti</nick>
	<username>shabti</username>
	<ircname>Shabti IRC bot</ircname>
	<channel>#foo</channel>
	<channel>#bar</channel>
	<channel>#shabti</channel>
	<script>mybot.js</script>
	<script>chanserv.js</script>
</configuration>
```

Any filename passed to **Shabti** is looked for first in the same directory `shabti.pl` resides; second, in the `config` directory.  If the file isn't found, **Shabti** exits with an error.  To make *sure* that **Shabti** loads the right file, you can pass it a complete file path. The default configuration files and script files are `defalt.xml` and `default.js`, located in the `config` directory.

### Configuration File Elements

* `configuration`
	* `server`
		* Sets the server the bot will connect to.
	* `port`
		* Sets the port the bot will connect to.
	* `nick`
		* Sets the nick the bot will use.
	* `username`
		* Sets the username the bot will use.
	* `ircname`
		* Sets the IRCname the bot will use.
	* `channel`
		* Sets a channel the bot will join.
		* The `channel` child element can appear multiple times; set multiple `channel` elements to have the bot join more than one channel.
	* `script`
		* Sets a Javascript file the bot will load.
		* The `script` child element can appear multiple times; set multiple `script` elements to have the bot load more than one file.

## Shabti Javascript

**Shabti** uses Javascript to determine how the bot will behave, using three methods: built-in **variables**, built-in **functions**, and **events**.  **Built-in variables** and **built-in functions** work just like normal Javascript.

**Events** are functions that are executed by the bot when a certain type of message is received from the server.

The order in which scripts are loaded is important.  This is because functions can overload (replace) each other.  For example, let's say you have two **Shabti** scripts, one named `mybot.js`:

```javascript
// mybot.js
function connect_event(server) {
	print("*** Connected to "+server);
}
```

and the other named `otherbot.js`:

```javascript
// otherbot.js
function connect_event(server) {
	print("WE ARE HERE:"+server);
}

function ping_event() {
	print("I hate ping pong.");
}
```

`mybot.js` prints a message when the bot connects to a server, as does `otherbot.js`.  If `mybot.js` is loaded before `otherbot.js`, `otherbot.js`'s `connect_event()` function overloads `mybot.js`'s `connect_event()`;  that is, when the bot connects to a server, the `connect_event()` function in `otherbot.js` is executed, not the one in `mybot.js`.

### Built-In Variables.

* `SERVER`
	* The name/host of the IRC server connected to.
* `PORT`
	* The port that the bot connected to.
* `NICK`
	* The bot's nick.
* `USER`
	* The username the bot is using.
* `IRCNAME`
	* The bot's IRCname.
* `TIME`
	* Server time.
* `DATE`
	* Server date..
* `BOT`
	* The name of the bot's software.
* `VERSION`
	* The version of the bot's software.
* `LOCAL_DIRECTORY`
	* The directory where **Shabti** is installed.
* `CONFIG_DIRECTORY`
	* The configuration directory **Shabti** is using.
* `WHITE`
	* White color (for use with the `color` built-in function)
* `BLACK`
	* Black color (for use with the `color` built-in function)
* `BLUE`
	* Blue color (for use with the `color` built-in function)
* `GREEN`
	* Green color (for use with the `color` built-in function)
* `RED`
	* Red color (for use with the `color` built-in function)
* `BROWN`
	* Brown color (for use with the `color` built-in function)
* `PURPLE`
	* Purple color (for use with the `color` built-in function)
* `ORANGE`
	* Orange color (for use with the `color` built-in function)
* `YELLOW`
	* Yellow color (for use with the `color` built-in function)
* `LIGHT_GREEN`
	* Light green color (for use with the `color` built-in function)
* `TEAL`
	* Teal color (for use with the `color` built-in function)
* `CYAN`
	* Cyan color (for use with the `color` built-in function)
* `LIGHT_BLUE`
	* Light blue color (for use with the `color` built-in function)
* `PINK`
	* Pink color (for use with the `color` built-in function)
* `GREY`
	* Grey color (for use with the `color` built-in function)
* `LIGHT_GREY`
	* Light grey color (for use with the `color` built-in function)

All variable are static, except for `TIME`  and `DATE`.  These two variables change to whatever the current server time or date is; it is not necessarily accurate, as the bot resets `TIME` and `DATE` only when the bot receives a `RPL_TIME` message.  `NICK` will only change if the bot changes its nick.

### Built-In Functions

There are 28 built-in functions for use in your **Shabti** script.

* [IRC Functions](#irc-functions)
	* [`server`](#server)
	* [`set`](#set)
	* [`login`](#login)
	* [`nick`](#nick)
	* [`rnick`](#rnick)
	* [`join`](#join)
	* [`part`](#part)
	* [`topic`](#topic)
	* [`quit`](#quit)
	* [`msg`](#msg)
	* [`notice`](#notice)
	* [`action`](#action)
* [Text Functions](#text-functions)
	* [`print`](#print)
	* [`sprint`](#sprint)
	* [`color`](#color)
	* [`bold`](#bold)
	* [`italic`](#italic)
	* [`underline`](#underline)
* [File I/O Functions](#file-io-functions)
	* [`read`](#read)
	* [`write`](#write)
	* [`swrite`](#swrite)
	* [`append`](#append)
	* [`sappend`](#sappend)
	* [`fileexists`](#fileexists)
	* [`direxists`](#direxists)
	* [`mkdir`](#mkdir)
	* [`rmdir`](#rmdir)
	* [`delete`](#delete)

---

#### IRC Functions

##### `server`
* *Arguments*: 1 (text to send)
* *Returns*: nothing
* Sends "raw" text to the IRC server; that is, the bot will send the server this text without any modification.  This can be used to send IRC commands that don't have **Shabti** built-in functions to perform.  For example, to send a private message to Bob, you could use `server("PRIVMSG Bob :Hello world!")`.

##### `set`
* *Arguments*: 2+ (target,flags,arguments)
* *Returns*: nothing
* Sets a mode on the server.  For example, to give channel operator status to Bob in channel "#foo", you could use `set("#foo", "+o", "Bob")`.

##### `login`
* *Arguments*: 2 (username, password)
* *Returns*: nothing
* Logs into an IRCop account.

##### `nick`
* *Arguments*: 1 (new nick)
* *Returns*: nothing
* Changes the bot's nick.

##### `rnick`
* *Arguments*: 1 (new nick)
* *Returns*: nothing
* Changes the bot's nick, adding two randomly selected numbers to the end of the nick.

##### `join`
* *Arguments*: 1+ (channel to join, password)
* *Returns*: nothing
* Joins a channel.

##### `part`
* *Arguments*: 1+ (channel to part, parting message)
* *Returns*: nothing
* Parts a channel.

##### `topic`
* *Arguments*: 2 (channel, new topic)
* *Returns*: nothing
* Sets a channel's topic.

##### `quit`
* *Arguments*: 0+ (optional quit message)
* *Returns*: nothing
* Quits the IRC server.

##### `msg`
* *Arguments*: 2 (target user or channel, message)
* *Returns*: nothing
* Sends a message to the target user or channel.

##### `notice`
* *Arguments*: 2 (target user or channel, message)
* *Returns*: nothing
* Sends a notice to the target user or channel.

##### `action`
* *Arguments*: 2 (channel, message)
* *Returns*: nothing
* Sends an action message to a channel.

---

#### Text Functions

##### `print`
* *Arguments*: 1+ (text to print)
* *Returns*: nothing
* Prints text to the console, followed by a carriage return.

##### `sprint`
* *Arguments*: 1+ (text to print)
* *Returns*: nothing
* Prints text to the console; a trailing carriage return is *not* printed.

##### `color`
* *Arguments*: 3 (foreground color, background color, text)
* *Returns*: string
* Formats text using IRC color codes, and returns it.

##### `bold`
* *Arguments*: 1 (text)
* *Returns*: string
* Formats text using IRC bold code, and returns it.

##### `italic`
* *Arguments*: 1 (text)
* *Returns*: string
* Formats text using IRC italic code, and returns it.

##### `underline`
* *Arguments*: 1 (text)
* *Returns*: string
* Formats text using IRC underline code, and returns it.

---

#### File I/O Functions

##### `read`
* *Arguments*: 1 (file to read)
* *Returns*: file contents as string
* Reads data from a file and returns it.

##### `write`
* *Arguments*: 2 (file to write to, contents to write)
* *Returns*: nothing
* Writes data to a file, followed by a carriage return.

##### `swrite`
* *Arguments*: 2 (file to write to, contents to write)
* *Returns*: nothing
* Writes data to a file; a trailing carriage return is *not* written.

##### `append`
* *Arguments*: 2 (file to append to, contents to append)
* *Returns*: nothing
* Appends data to a file, followed by a carriage return.

##### `sappend`
* *Arguments*: 2 (file to append to, contents to append)
* *Returns*: nothing
* Appends data to a file; a trailing carriage return is *not* written.

##### `fileexists`
* *Arguments*: 1 (filename)
* *Returns*: 1 if file exists, 0 if not
* Tests if a file exists or not.

##### `direxists`
* *Arguments*: 1 (directory name)
* *Returns*: 1 if directory exists, 0 if not
* Tests if a directory exists or not.

##### `mkdir`
* *Arguments*: 1 (directory name)
* *Returns*: nothing
* Creates a directory.

##### `rmdir`
* *Arguments*: 1 (directory name)
* *Returns*: nothing
* Deletes a directory

##### `delete`
* *Arguments*: 1 (filename)
* *Returns*: nothing
* Deletes a file.

---

### Events

Events are functions that are automatically executed when **Shabti** receives certain types of communication from the IRC server.  For example, there's an event that is executed whenever **Shabti** receives a public message, another when receiving a private message, and so on. This is where the bot's desired behavior is implemented.  There are 12 events which cover every type of message an IRC server can send to a client.  Each event is called with a variable number of arguments, passing pertinent information about the event to the function.

* `startup`
* `connect_event`
* `nick_taken_event`
* `ping_event`
* `time_event`
* `public_message_event`
* `private_message_event`
* `action_event`
* `mode_event`
* `join_event`
* `part_event`
* `other_event`

---

#### `startup()`
* *Arguments*: none

This event is called when the script is first loaded.

#### `connect_event(host)`
* *Arguments*: `host` (the name of the server connected to)

Called when the bot connects to the IRC server.

#### `nick_taken_event()`
* *Arguments*: none

Called when the bot is notified by the server that their requested nick is taken. By default, this is *not* handled automatically, and must be handled by the script.  The script that comes with a default **Shabti** installation calls the built-in function `rnick` to handle this problem.

#### `ping_event()`
* *Arguments*: none

Called when the bot receives a "PING?" request from the server. The necessary response ("PONG!") is handled automatically.

#### `time_event(weekday,month,day,year,hour,minute,second,zone)`
* *Arguments*: `weekday` (day of the week), `month` (month of the year), `day` (numeric day of the month), `year` (numeric year), `hour` (hour of the day), `minute` (minute of the hour), `second` (second of the minute), `zone` (time zone)

Called when the bot receives a `RPL_TIME` message from the server. **Shabti** can ask the server to send a `RPL_TIME` message by using the built-in function `raw` with the argument "TIME" (`raw("TIME");`).

#### `public_message_event(nick,username,channel,message)`
* *Arguments*: `nick` (the nick of the user sending the message), `username` (the username of the sender), `channel` (the channel the message is sent to), and `message` (the message sent)

Called when the bot receives a public message.

#### `private_message_event(nick,username,message)`
* *Arguments*: `nick` (the nick of the user sending the message), `username` (the username of the sender), `message` (the message sent)

Called when the bot receives a private message.

#### `action_event(nick,username,channel,action)`
* *Arguments*: `nick` (the nick of the user sending the action), `username` (the username of the sender), `action` (the action sent)

Called when the bot receives a CTCP action message.

#### `mode_event(nick,username,target,mode)`
* *Arguments*: `nick` (the nick of the user setting the mode), `username` (the username of the setter), `target` (the mode's target), `mode` (the mode set)

Called when the bot receives a mode notification. If the server is the one setting the mode, the `username` argument will be an empty string.

#### `join_event(nick,username,channel)`
* *Arguments*: `nick` (the nick joining the channel), `username` (the username of the joiner), `channel` (the channel joined)

Called when the bot receives a channel join notification.

#### `part_event(nick,username,channel,message)`
* *Arguments*: `nick` (the nick parting the channel). `username` (the username of parter), `channel` (the channel parted), `message` (optional parting message)

Called when the bot receives a channel part notification. If the parting user has set a parting message, it will be reflected in the `message` argument, which is set to a blank string otherwise.

#### `other_event(raw,type,host,nick,content)`
* *Arguments*: `raw` (the unchanged text of the server message sent), `type` (the numeric message type, from RFCs), `host` (the name of the sending server), `nick` (the nick of the client the message is sent to), `content` (the message content)

Called when the bot receives a notification that is not handled by any other event.  `raw` contains the "raw", unchanged notification.

---

