![Shabti IRC Bot](https://github.com/danhetrick/shabti/blob/master/shabti_logo.png?raw=true)

<details>

<summary>Usage and Configuration</summary>

* [Usage](#usage)
* [Configuration](#configuration)
	* [Command-line Configuration](#command-line-configuration)
	* [Configuration Files](#configuration-files)
		* [Configuration File Elements](#configuration-file-elements)
* [Default Configuration File](#default-configuration-file)

</details>

<details>

<summary>Scripting Documentation</summary>

* [Shabti Javascript](#shabti-javascript)
* [Built-In Variables](#built-in-variables)
* [Built-In Functions](#built-in-functions)

	<details>

	<summary>IRC Functions</summary>

	* [`raw`](#raw)
	* [`set`](#set)
	* [`login`](#login)
	* [`nick`](#nick)
	* [`rnick`](#nick)
	* [`join`](#join)
	* [`part`](#part)
	* [`topic`](#topic)
	* [`quit`](#quit)
	* [`message`](#message)
	* [`notice`](#notice)
	* [`action`](#action)

	</details>

	<details>

	<summary>Text Functions</summary>

	* [`print`](#print)
	* [`sprint`](#sprint)
	* [`color`](#color)
	* [`bold`](#bold)
	* [`italic`](#italic)
	* [`underline`](#underline)

	</details>

	<details>

	<summary>File I/O Functions</summary>

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

	</details>

	<details>

	<summary>Miscellaneous Functions</summary>

	* [`sha1`](#sha1)
	* [`sha256`](#sha256)
	* [`require`](#require)
	* [`exit`](#exit)

	</details>

* [Events](#events)
* ["Extra" Events](#extra-events)

	<details>

	<summary>All events</summary>

	* [`CONNECT_EVENT`](#connect_eventev_host)
	* [`NICK_TAKEN_EVENT`](#nick_taken_event)
	* [`PING_EVENT`](#ping_event)
	* [`TIME_EVENT`](#time_eventev_weekdayev_monthev_dayev_yearev_hourev_minuteev_secondev_zone)
	* [`PUBLIC_MESSAGE_EVENT`](#public_message_eventev_nickev_usernameev_channelev_message)
	* [`PRIVATE_MESSAGE_EVENT`](#private_message_eventev_nickev_usernameev_message)
	* [`ACTION_EVENT`](#action_eventev_nickev_usernameev_channelev_action)
	* [`MODE_EVENT`](#mode_eventev_nickev_usernameev_targetev_mode)
	* [`JOIN_EVENT`](#join_eventev_nickev_usernameev_channel)
	* [`PART_EVENT`](#part_eventev_nickev_usernameev_channelev_message)
	* [`IRC_EVENT`](#irc_eventev_rawev_typeev_hostev_nickev_message)

	</details>

* [Modules](#modules)

	<details>

	<summary>All modules</summary>

	* [`commands.js`](#commandsjs)
		* [`CommandList`](#commandlist)
		* [`CommandHandler`](#commandhandler)
		* [`!colormsg` command](#colormsg-command)

	* [`simpledb.js`](#simpledbjs)
		* [`SimpleDB`](#simpledb)
			* [`SimpleDB.read(FILENAME)`](#simpledbreadfilename)
			* [`SimpleDB.write(FILENAME)`](#simpledbwritefilename)
			* [`SimpleDB.get(ENTRY)`](#simpledbgetentry)
			* [`SimpleDB.set(ENTRY,VALUE)`](#simpledbsetentryvalue)
			* [`SimpleDB.exists(ENTRY)`](#simpledbexistsentry)

	* [`nofileio.js`](#nofileiojs)
		* [`WarnFileIO`](#warnfileio)
		* [`ExitOnFileIO`](#exitonfileio)

	* [`norequire.js`](#norequirejs)
		* [`WarnOnRequire`](#warnonrequire)
		* [`ExitOnRequire`](#exitonrequire)

	* [`plaintext.js`](#plaintextjs)
		* [`WarnOnFancy`](#warnonfancy)
		* [`ExitOnFancy`](#exitonfancy)

	</details>

* [Default Script File](#default-script-file)

</details>

<details>

<summary>Example Shabti Scripts</summary>

* [OpBot](#opbot)
* [RainbowBot](#rainbowbot)

</details>

# Summary

**Shabti** is an IRC bot, powered by Perl and Javascript.  More specifically, it's an IRC bot written in pure Perl, which can have all its behavior programmed with Javascript.  **Shabti** uses [**JE**](https://metacpan.org/pod/JE), a pure Perl Javascript engine by [Father Chrysostomos](https://metacpan.org/author/SPROUT).  Without any modification, **Shabti** doesn't really do anything.  It can connect to an IRC server, join channels, and...well, that's about it.  What **Shabti** does is up to *you*.  The latest version of **Shabti** is 0.157.

# Name

"The ushabti (also called shabti or shawabti, with a number of variant spellings, Ancient Egyptian plural: ushabtiu) was a funerary figurine used in Ancient Egypt. Ushabtis were placed in tombs among the grave goods and were intended to act as servants or minions for the deceased, should they be called upon to do manual labor in the afterlife....Called “answerers,” they carried inscriptions asserting their readiness to answer the gods' summons to work." - [Wikipedia](https://en.wikipedia.org/wiki/Ushabti)

# Installation

* :page_facing_up: LICENSE
* :page_facing_up: README.md
* :page_facing_up: shabti.pl
* :page_facing_up: shabti_logo.png
	* :file_folder: lib
		* *libraries necessary for Shabti to run properly*
	* :file_folder: config
		* :file_folder: modules
			* :page_facing_up: commands.js
			* :page_facing_up: simpledb.js
			* :page_facing_up: nofileio.js
			* :page_facing_up: norequire.js
			* :page_facing_up: plaintext.js
		* :page_facing_up: default.js
		* :page_facing_up: default.xml

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
	--(v)ersion			Display version
	--e(x)tra            How many extra chat event functions (default: 10)		

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

Command line options can be bundled.

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
	<extra>10</extra>
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
	* `extra`
		* How many "extra" events the bot will attempt to execute (see ["Extra" Events](#extra-events)).
	* `channel`
		* Sets a channel the bot will join.
		* The `channel` child element can appear multiple times; set multiple `channel` elements to have the bot join more than one channel.
	* `script`
		* Sets a Javascript file the bot will load.
		* The `script` child element can appear multiple times; set multiple `script` elements to have the bot load more than one file.

# Shabti Javascript

**Shabti** uses Javascript to determine how the bot will behave, using three methods: built-in **variables**, built-in **functions**, and **events**.  **Built-in variables** and **built-in functions** work just like normal Javascript.

**Events** are functions that are executed by the bot when a certain type of message is received from the server.

The order in which scripts are loaded is important.  This is because functions can overload (replace) each other.  For example, let's say you have two **Shabti** scripts, one named `mybot.js`:

```javascript
// mybot.js
function CONNECT_EVENT(EV_SERVER) {
	print("*** Connected to "+EV_SERVER);
}
```

and the other named `otherbot.js`:

```javascript
// otherbot.js
function CONNECT_EVENT(EV_SERVER) {
	print("WE ARE HERE:"+EV_SERVER);
}

function PING_EVENT() {
	print("I hate ping pong.");
}
```

`mybot.js` prints a message when the bot connects to a server, as does `otherbot.js`.  If `mybot.js` is loaded before `otherbot.js`, `otherbot.js`'s `CONNECT_EVENT()` function overloads `mybot.js`'s `CONNECT_EVENT()`;  that is, when the bot connects to a server, the `CONNECT_EVENT()` function in `otherbot.js` is executed, not the one in `mybot.js`.  To make sure this doesn't occur, consider using "extra" event functions in your scripts, if you're going to load more than one at a time (see ["Extra" Events](#extra-events) for more information).

A **Shabti** script doesn't need to contain all of the events provided, only the ones necessary for whatever you're trying to do with your script.  If a specific event is not present, it will simply never be called.

## Built-In Variables

Built-in variables are always in uppercase; with the exception of the miscellaneous variables for use with the `color` function, they all start with `SV_`.

* `SV_SERVER`
	* The name/host of the IRC server connected to.
* `SV_PORT`
	* The port that the bot connected to.
* `SV_NICK`
	* The bot's nick.
* `SV_USER`
	* The username the bot is using.
* `SV_IRCNAME`
	* The bot's IRCname.
* `SV_TIME`
	* Server time.
* `SV_DATE`
	* Server date..
* `SV_BOT`
	* The name of the bot's software.
* `SV_VERSION`
	* The version of the bot's software.
* `SV_LOCAL_DIRECTORY`
	* The directory where **Shabti** is installed.
* `SV_CONFIG_DIRECTORY`
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

All variable are static, except for `SV_TIME`  and `SV_DATE`.  These two variables change to whatever the current server time or date is; it is not necessarily accurate, as the bot resets `SV_TIME` and `SV_DATE` only when the bot receives a `RPL_TIME` message.  `SV_NICK` will only change if the bot changes its nick.

## Built-In Functions

There are 32 built-in functions for use in your **Shabti** scripts.

* [IRC Functions](#irc-functions)
	<details>

	<summary>Click for a list of IRC functions</summary>

	* [`raw`](#raw)
	* [`set`](#set)
	* [`login`](#login)
	* [`nick`](#nick)
	* [`rnick`](#rnick)
	* [`join`](#join)
	* [`part`](#part)
	* [`topic`](#topic)
	* [`quit`](#quit)
	* [`message`](#message)
	* [`notice`](#notice)
	* [`action`](#action)

	</details>

* [Text Functions](#text-functions)
	<details>

	<summary>Click for a list of Text functions</summary>

	* [`print`](#print)
	* [`sprint`](#sprint)
	* [`color`](#color)
	* [`bold`](#bold)
	* [`italic`](#italic)
	* [`underline`](#underline)

	</details>

* [File I/O Functions](#file-io-functions)
	<details>

	<summary>Click for a list of File I/O functions</summary>

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

	</details>

* [Miscellaneous Functions](#miscellaneous-functions)
	<details>

	<summary>Click for a list of Miscellaneous functions</summary>

	* [`sha1`](#sha1)
	* [`sha256`](#sha256)
	* [`require`](#require)
	* [`exit`](#exit)

	</details>

---

### IRC Functions

#### `raw`
* *Arguments*: 1 (text to send)
* *Returns*: nothing
* Sends "raw" text to the IRC server; that is, the bot will send the server this text without any modification.  This can be used to send IRC commands that don't have **Shabti** built-in functions to perform.  For example, to send a private message to Bob, you could use `raw("PRIVMSG Bob :Hello world!")`.

#### `set`
* *Arguments*: 2+ (target,flags,arguments)
* *Returns*: nothing
* Sets a mode on the server.  For example, to give channel operator status to Bob in channel "#foo", you could use `set("#foo", "+o", "Bob")`.

#### `login`
* *Arguments*: 2 (username, password)
* *Returns*: nothing
* Logs into an IRCop account.

#### `nick`
* *Arguments*: 1 (new nick)
* *Returns*: nothing
* Changes the bot's nick.

#### `rnick`
* *Arguments*: 1 (new nick)
* *Returns*: nothing
* Changes the bot's nick, adding two randomly selected numbers to the end of the nick.

#### `join`
* *Arguments*: 1+ (channel to join, password)
* *Returns*: nothing
* Joins a channel.

#### `part`
* *Arguments*: 1+ (channel to part, parting message)
* *Returns*: nothing
* Parts a channel.

#### `topic`
* *Arguments*: 2 (channel, new topic)
* *Returns*: nothing
* Sets a channel's topic.

#### `quit`
* *Arguments*: 0+ (optional quit message)
* *Returns*: nothing
* Quits the IRC server.

#### `message`
* *Arguments*: 2 (target user or channel, message)
* *Returns*: nothing
* Sends a message to the target user or channel. An identical version of this command named `msg` can alternately used.

#### `notice`
* *Arguments*: 2 (target user or channel, message)
* *Returns*: nothing
* Sends a notice to the target user or channel.

#### `action`
* *Arguments*: 2 (channel, message)
* *Returns*: nothing
* Sends an action message to a channel.

---

### Text Functions

`color`, `bold`, `italic`, and `underline` work much like the equivalent HTML tags.  For example, to display the words "Hello world!" in blue text with a grey background, in italics, bolded, and underlined:

```javascript
var example = bold(italic(underline(color(BLUE,GREY,"Hello world!"))));
msg("#foo",example);
```

These colors and text enhancements will *only* be seen in IRC clients; they will not display properly in the console or written to file.  **Shabti** does not have any functionality to display colors or other text enhancements to the console or text files.

#### `print`
* *Arguments*: 1+ (text to print)
* *Returns*: nothing
* Prints text to the console, followed by a carriage return.

#### `sprint`
* *Arguments*: 1+ (text to print)
* *Returns*: nothing
* Prints text to the console; a trailing carriage return is *not* printed.

#### `color`
* *Arguments*: 3 (foreground color, background color, text)
* *Returns*: string
* Formats text using IRC color codes, and returns it.

#### `bold`
* *Arguments*: 1 (text)
* *Returns*: string
* Formats text using IRC bold code, and returns it.

#### `italic`
* *Arguments*: 1 (text)
* *Returns*: string
* Formats text using IRC italic code, and returns it.

#### `underline`
* *Arguments*: 1 (text)
* *Returns*: string
* Formats text using IRC underline code, and returns it.

---

### File I/O Functions

#### `read`
* *Arguments*: 1 (file to read)
* *Returns*: file contents as string
* Reads data from a file and returns it.

#### `write`
* *Arguments*: 2 (file to write to, contents to write)
* *Returns*: nothing
* Writes data to a file, followed by a carriage return.

#### `swrite`
* *Arguments*: 2 (file to write to, contents to write)
* *Returns*: nothing
* Writes data to a file; a trailing carriage return is *not* written.

#### `append`
* *Arguments*: 2 (file to append to, contents to append)
* *Returns*: nothing
* Appends data to a file, followed by a carriage return.

#### `sappend`
* *Arguments*: 2 (file to append to, contents to append)
* *Returns*: nothing
* Appends data to a file; a trailing carriage return is *not* written.

#### `fileexists`
* *Arguments*: 1 (filename)
* *Returns*: 1 if file exists, 0 if not
* Tests if a file exists or not.

#### `direxists`
* *Arguments*: 1 (directory name)
* *Returns*: 1 if directory exists, 0 if not
* Tests if a directory exists or not.

#### `mkdir`
* *Arguments*: 1 (directory name)
* *Returns*: nothing
* Creates a directory.

#### `rmdir`
* *Arguments*: 1 (directory name)
* *Returns*: nothing
* Deletes a directory

#### `delete`
* *Arguments*: 1 (filename)
* *Returns*: nothing
* Deletes a file.

---

### Miscellaneous Functions

#### `sha1`
* *Arguments*: 1 (data)
* *Returns*: string
* Calculates a [SHA1](https://en.wikipedia.org/wiki/SHA-1) hash and returns it.

#### `sha256`
* *Arguments*: 1 (data)
* *Returns*: string
* Calculates a [SHA256](https://en.wikipedia.org/wiki/SHA-2) hash and returns it.

#### `require`
* *Arguments*: 1 (filename)
* *Returns*: nothing
* Loads a **Shabti** module (see [Modules](#modules)) into memory.

#### `exit`
* *Arguments*: 0, 1 (message), or 2 (message, exit code)
* *Returns*: nothing
* Exits out of **Shabti**. Optionally, can display a message on exit, or an exit code (which *must* be 0 or 1).

---

## Events

* [`CONNECT_EVENT`](#connect_eventev_host)
* [`NICK_TAKEN_EVENT`](#nick_taken_event)
* [`PING_EVENT`](#ping_event)
* [`TIME_EVENT`](#time_eventev_weekdayev_monthev_dayev_yearev_hourev_minuteev_secondev_zone)
* [`PUBLIC_MESSAGE_EVENT`](#public_message_eventev_nickev_usernameev_channelev_message)
* [`PRIVATE_MESSAGE_EVENT`](#private_message_eventev_nickev_usernameev_message)
* [`ACTION_EVENT`](#action_eventev_nickev_usernameev_channelev_action)
* [`MODE_EVENT`](#mode_eventev_nickev_usernameev_targetev_mode)
* [`JOIN_EVENT`](#join_eventev_nickev_usernameev_channel)
* [`PART_EVENT`](#part_eventev_nickev_usernameev_channelev_message)
* [`IRC_EVENT`](#irc_eventev_rawev_typeev_hostev_nickev_message)

Events are functions that are automatically executed when **Shabti** receives certain types of communication from the IRC server.  For example, there's an event that is executed whenever **Shabti** receives a public message, another when receiving a private message, and so on. This is where the bot's desired behavior is implemented.  There are 12 events which cover every type of message an IRC server can send to a client.  Each event is called with a variable number of arguments, passing pertinent information about the event to the function; event arguments in a function declaration should be uppercase, with each argument beginning with `EV_`.  All event function names are in uppercase.

If you want to execute code as soon as the script is loaded, simply place your code at the top of the file, or outside of event declarations. Any code not in a function or event declaration is executed as soon as the script is loaded.

### "Extra" Events

Some events will call "extra" functions; that is, the event triggers multiple function calls.  The names of these "extra" functions follow the format "EVENT_FUNCTION_x", where "x" is a number.  By default, "x" will be a number from 1-10; so, when an event with "extra" functions is triggered, the bot will attempt to execute `EVENT_FUNCTION_1`, `EVENT_FUNCTION_2`, `EVENT_FUNCTION_3`, and so on. To change how many "extra" event functions are called, use the `--extra` command line option, or set the `extra` child element in the configuration file. The events that support this feature are [`CONNECT_EVENT`](#connect_eventev_host), [`PUBLIC_MESSAGE_EVENT`](#public_message_eventev_nickev_usernameev_channelev_message), [`PRIVATE_MESSAGE_EVENT`](#private_message_eventev_nickev_usernameev_message), [`JOIN_EVENT`](#join_eventev_nickev_usernameev_channel), and [`PART_EVENT`](#part_eventev_nickev_usernameev_channelev_message).

---

#### `CONNECT_EVENT(EV_HOST)`
* *Arguments*: `EV_HOST` (the name of the server connected to)
* *Note:* **Shabti** will call "extra" connect event functions.  Their names follow the format `CONNECT_EVENT_x`, with "x" equal to a number; with default settings, **Shabti** will call `CONNECT_EVENT_1` to `CONNECT_EVENT_10`.  How many "extra" functions are called can be set with the command line option `--extra`; for example, if you started **Shabti** with `perl shabti.pl --extra 50`, it would then call event functions `CONNECT_EVENT_1` to `CONNECT_EVENT_50` whenever it receives a connect message.

Called when the bot connects to the IRC server.

#### `NICK_TAKEN_EVENT()`
* *Arguments*: none

Called when the bot is notified by the server that their requested nick is taken. By default, this is *not* handled automatically, and must be handled by the script.  The script that comes with a default **Shabti** installation calls the built-in function `rnick` to handle this problem.

#### `PING_EVENT()`
* *Arguments*: none

Called when the bot receives a "PING?" request from the server. The necessary response ("PONG!") is handled automatically.

#### `TIME_EVENT(EV_WEEKDAY,EV_MONTH,EV_DAY,EV_YEAR,EV_HOUR,EV_MINUTE,EV_SECOND,EV_ZONE)`
* *Arguments*: `EV_WEEKDAY` (day of the week), `EV_MONTH` (month of the year), `EV_DAY` (numeric day of the month), `EV_YEAR` (numeric year), `EV_HOUR` (hour of the day), `EV_MINUTE` (minute of the hour), `EV_SECOND` (second of the minute), `EV_ZONE` (time zone)

Called when the bot receives a `RPL_TIME` message from the server. **Shabti** can ask the server to send a `RPL_TIME` message by using the built-in function `raw` with the argument "TIME" (`raw("TIME");`).

#### `PUBLIC_MESSAGE_EVENT(EV_NICK,EV_USERNAME,EV_CHANNEL,EV_MESSAGE)`
* *Arguments*: `EV_NICK` (the nick of the user sending the message), `EV_USERNAME` (the username of the sender), `EV_CHANNEL` (the channel the message is sent to), and `EV_MESSAGE` (the message sent)
* *Note:* **Shabti** will call "extra" public chat event functions.  Their names follow the format `PUBLIC_MESSAGE_EVENT_x`, with "x" equal to a number; with default settings, **Shabti** will call `PUBLIC_MESSAGE_EVENT_1` to `PUBLIC_MESSAGE_EVENT_10`.  How many "extra" functions are called can be set with the command line option `--extra`; for example, if you started **Shabti** with `perl shabti.pl --extra 50`, it would then call event functions `PUBLIC_MESSAGE_EVENT_1` to `PUBLIC_MESSAGE_EVENT_50` whenever it receives a public message.

Called when the bot receives a public message.

#### `PRIVATE_MESSAGE_EVENT(EV_NICK,EV_USERNAME,EV_MESSAGE)`
* *Arguments*: `EV_NICK` (the nick of the user sending the message), `EV_USERNAME` (the username of the sender), `EV_MESSAGE` (the message sent)
* *Note:* **Shabti** will call "extra" private chat event functions.  Their names follow the format `PRIVATE_MESSAGE_EVENT_x`, with "x" equal to a number; with default settings, **Shabti** will call `PRIVATE_MESSAGE_EVENT_1` to `PRIVATE_MESSAGE_EVENT_10`.  How many "extra" functions are called can be set with the command line option `--extra`; for example, if you started **Shabti** with `perl shabti.pl --extra 50`, it would then call event functions `PRIVATE_MESSAGE_EVENT_1` to `PRIVATE_MESSAGE_EVENT_50` whenever it receives a private message.

Called when the bot receives a private message.

#### `ACTION_EVENT(EV_NICK,EV_USERNAME,EV_CHANNEL,EV_ACTION)`
* *Arguments*: `EV_NICK` (the nick of the user sending the action), `EV_USERNAME` (the username of the sender), `EV_CHANNEL` (the channel the action is sent to), `EV_ACTION` (the action sent)

Called when the bot receives a CTCP action message.

#### `MODE_EVENT(EV_NICK,EV_USERNAME,EV_TARGET,EV_MODE)`
* *Arguments*: `EV_NICK` (the nick of the user setting the mode), `EV_USERNAME` (the username of the setter), `EV_TARGET` (the mode's target), `EV_MODE` (the mode set)

Called when the bot receives a mode notification. If the server is the one setting the mode, the `EV_USERNAME` argument will be an empty string.

#### `JOIN_EVENT(EV_NICK,EV_USERNAME,EV_CHANNEL)`
* *Arguments*: `EV_NICK` (the nick joining the channel), `EV_USERNAME` (the username of the joiner), `EV_CHANNEL` (the channel joined)
* *Note:* **Shabti** will call "extra" join event functions.  Their names follow the format `JOIN_EVENT_x`, with "x" equal to a number; with default settings, **Shabti** will call `JOIN_EVENT_1` to `JOIN_EVENT_10`.  How many "extra" functions are called can be set with the command line option `--extra`; for example, if you started **Shabti** with `perl shabti.pl --extra 50`, it would then call event functions `JOIN_EVENT_1` to `JOIN_EVENT_50` whenever it receives a join message.

Called when the bot receives a channel join notification.

#### `PART_EVENT(EV_NICK,EV_USERNAME,EV_CHANNEL,EV_MESSAGE)`
* *Arguments*: `EV_NICK` (the nick parting the channel). `EV_USERNAME` (the username of parter), `EV_CHANNEL` (the channel parted), `EV_MESSAGE` (optional parting message)
* *Note:* **Shabti** will call "extra" part event functions.  Their names follow the format `PART_EVENT_x`, with "x" equal to a number; with default settings, **Shabti** will call `PART_EVENT_1` to `PART_EVENT_10`.  How many "extra" functions are called can be set with the command line option `--extra`; for example, if you started **Shabti** with `perl shabti.pl --extra 50`, it would then call event functions `PART_EVENT_1` to `PART_EVENT_50` whenever it receives a part message.

Called when the bot receives a channel part notification. If the parting user has set a parting message, it will be reflected in the `EV_MESSAGE` argument, which is set to a blank string otherwise.

#### `IRC_EVENT(EV_RAW,EV_TYPE,EV_HOST,EV_NICK,EV_MESSAGE)`
* *Arguments*: `EV_RAW` (the unchanged text of the server message sent), `EV_TYPE` (the numeric message type, from RFCs), `EV_HOST` (the name of the sending server), `EV_NICK` (the nick of the client the message is sent to), `EV_MESSAGE` (the message content)

Called when the bot receives a notification that is not handled by any other event.  `EV_RAW` contains the "raw", unchanged notification.

---

# Modules

**Shabti** provides a way to write general purpose code that can be used in multiple scripts:  **modules**.  A **Shabti** module is a Javascript file that contains Javascript code, variables, objects, and functions; they must be placed in the `config/modules` folder, and are loaded with the function [`require`](#require).  Modules can contain any kind of code for any purpose, but it's supposed to be used for code libraries that you can use in your **Shabti** scripts.  Several modules are included with the default install.

When loading a module with `require`, you can leave off the ".js" file extension, if you wish.

## `commands.js`

This module is for automating command functionality for your **Shabti** bot.  It contains two objects (`CommandList` and `CommandParse`) and one function (`CommandHandler`). `CommandParse` is used internally for the module's functionality, and will not be explained here.  We're going to focus on `CommandList` and `CommandHandler`.  To use `commands.js`, you have to use the `require` function to load it into memory:

```javascript
require("commands.js");
```

You can leave off the ".js" file extension, if you want:

```javascript
require("commands");
```

### `CommandList`

This object is where you define commands, set usage text, and set the "help" command (which will be used to send users usage information).  `CommandList` is initialized with your bot's name, version, and the help command you want the bot to respond to.

First, create a new variable of the type `CommandList`:

```javascript
var Commands = new CommandList();
```

With that out of the way, lets create a simple command!  Our bot will send a greeting to any channel or user.  We'll call this command "!hello".  First, we need to program the command's functionality. We're going to create a new Javascript function that takes three parameters: an array, followed by two strings. The array will be populated with any arguments given to the command by the user;  the first string will be the nick of the user that issued the command, and the second string will be the channel that the user issued the command from:

```javascript
function cmd_hello(args,caller,channel){
	// Say hello to the whole channel!
	message(channel,"Hello!");
}
```

Our new command doesn't take *any* arguments; simply calling "!hello" tells the bot to execute the command. Now that we've got our command functionality, let's add it to the command list:

```javascript
Commands.add("!hello","Usage: !hello",0,cmd_hello);
                  ^     ^             ^     ^
                  |     |             |     |
                ---  Usage            |     -------
Command trigger-|    information      |           |
                                 Minimum number   Command function
                                 of required
                                 arguments
```

This adds a command to the command list.  The parameters to `.add` are:

* **Command trigger**. The text that will tell the bot you want to execute a command. This will be the first word in any message sent to the bot.
* **Usage information**. If a user triggers a command, but doesn't provide enough arguments to actually execute it, this text will be sent to the user.
* **Minimum number of required arguments**. Commands don't have to require arguments (set this value to "0"), but can require any number of them. Set this to the minimum number of arguments that your command requires; you can ignore any extra arguments (if you want to).
* **Command function**. This is the name of the Javascript function that powers your command.  Three parameters will be passed to it: an array followed by two strings. The array will contain any arguments passed to your command, the first string will contain the nick of the user that triggered the command, and the second will contain the channel the command was triggered in.

### `CommandHandler`

Now, to get the bot to use your command!  We want the bot to look for command input in a channel's public chat; that means we need to write a new `PUBLIC_MESSAGE_EVENT` function.  We'll use the `CommandHandler` to handle the command you created:

```javascript
function PUBLIC_MESSAGE_EVENT(EV_NICK,EV_USERNAME,EV_CHANNEL,EV_MESSAGE) {
	CommandHandler(Commands,EV_MESSAGE,EV_NICK,EV_CHANNEL);
}                      ^          ^        ^            ^
                       |          |        |            |---The channel the
                       |          |     The user            the chat occured in
  CommandList object---|          |     chatting
                                  |
                             Chat message   
```

This function scans incoming chat for any commands your bot is programmed to respond to, and executes them (or displays help or usage text).

Now, the only thing left to do is run your bot!  Run **Shabti** , join a channel that your **Shabti** bot joined (in this example, the bot is in `#foo`), and try out some commands!

```
<dhetrick>  Let's try out the !hello command
<dhetrick>  !hello
<pharaoh>   Hello!
```

If we want to use our commands over private messages to the bot, that's fairly easy to do. Instead of inserting our `CommandHandler` function in `PUBLIC_MESSAGE_EVENT`, we insert it in `PRIVATE_MESSAGE_EVENT`:

```javascript
function PRIVATE_MESSAGE_EVENT(EV_NICK,EV_USERNAME,EV_MESSAGE) {
	CommandHandler(Commands,EV_MESSAGE,EV_NICK,EV_NICK);
}
```

The only difference is the fourth parameter, which, in our "public chat" example, was set to the channel name; now, it's set to the nick of the user sending the private message.  But nothing's limiting you to only one `CommandList` object! Create one for public chat, and another for private chat, giving users access to different commands depending on how they're chatting with the bot!

### `!colormsg` command

Our "!hello" is pretty cool, but we're going to add another command that makes the bot message a more colorful greeting.  Let's scroll back up to the beginning of the file, where we created our `CommandList` object.  Place this code right under the `CommandList.add` statement for our "!hello" command:

```javascript
function cmd_color(args,caller,channel){
	// First argument is who to send the message to
	var target = args.shift();

	// The rest of the arguments are our message
	var m = args.join(" ");

	// Now, let's color each letter of the message
	var colored = "";
	var tokens = m.split("");
	for(var i=0, len=tokens.length; i < len; i++){

		// Select random foreground and background colors
		var foreground = Math.floor((Math.random() * 15) + 1);
		var background = Math.floor((Math.random() * 15) + 1);

		// Make sure that the forebround and background colors are different
		while (foreground==background) {
		    foreground = Math.floor((Math.random() * 15) + 1);
			background = Math.floor((Math.random() * 15) + 1);
		}
		colored = colored+color(foreground,background,tokens[i]);
	}

	// Now, send our message!
	message(target,colored);
}

Commands.add("!colormsg","Usage: !colormsg TARGET MESSAGE",2,cmd_color);
```

This creates a new command "!colormsg" which sends a randomly colored message to a user or channel. Let's try out our new command:

```
<dhetrick>  !colormsg
<pharaoh>   Usage: !colormsg TARGET MESSAGE
<dhetrick>  !colormsg dhetrick Hello, world!
<pharaoh>   [COLORED TEXT GOES HERE...C'MON, GITHUB! GIVE US MORE FORMATTING OPTIONS!]
```

---

## `simpledb.js`

This module implements a very simple flat-file database.  Entries are stored in an "entry=value" format;  for example, you could assign the value "bob" to the entry "name" ("name=bob").  To start, `require` the module, and create a new `SimpleDB` object:

```javascript
require("simpledb");
var database = new SimpleDB();
```

### `SimpleDB`

The `SimpleDB` object has five methods:  `read`, `write`, `get`, `set`, and `exists`.

#### `SimpleDB.read(FILENAME)`

Loads a database from disk.  Returns `true` if the read operation was successful, and `false` if the read operation failed.

#### `SimpleDB.write(FILENAME)`

Writes the contents of the database to disk.

#### `SimpleDB.get(ENTRY)`

Looks for an entry in the database; it returns the value if found, and `undefined` if not.

```javascript
var entry = SimpleDB.get("myentry");
if(entry==undefined){
	print("Value not found.");
} else {
	print(entry);
}
```

#### `SimpleDB.set(ENTRY,VALUE)`

Sets an entry/value pair in the database.  If the entry exists, the value is changed to the value passed as a parameter.  If the entry doesn't exist, it is created.

```javascript
// Set "name" to value "bob"
SimpleDB.set("name","bob");

// Prints "bob"
print(SimpleDB.get("name"));

// Set "name" to value "joe"
SimpleDB.set("name","joe");

// Prints "joe"
print(SimpleDB.get("name"));
```

#### `SimpleDB.exists(ENTRY)`

Returns `true` if an entry exists in the database, and `false` if it doesn't.

---

## `nofileio.js`

This module disables file I/O functions.

### `WarnFileIO`

By defaulst, `WarnFileIO` is set to `false`.  If set to `true`, and a script attempts to use file I/O functions, a warning stating that the file I/O function in question has been disabled is printed to the console.

### `ExitOnFileIO`

By default, `ExitOnFileIO` is set to `false`. If set to `true`, **Shabti** will exit when a script tries to call a file I/O function.

---

## `norequire.js`

This module disables the `require` function.

### `WarnOnRequire`

By defaulst, `WarnOnRequire` is set to `false`.  If set to `true`, and a script attempts to use the `require` function, a warning stating that `require` has been disabled is printed to the console.

### `ExitOnRequire`

By default, `ExitOnRequire` is set to `false`. If set to `true`, **Shabti** will exit when a script tries to execute `require`.

---

## `plaintext.js`

This module disables the `color`, `bold`, `italic`, and `underline` functions; these functions will simply return their input, unchanged.

---

# Example Scripts

## OpBot

This is a simple bot that performs one function: granting channel operator status to any user that has the appropriate password.  The bot must have channel operator status in the desired channel.  To get ops from the bot, send a private message to it with `op CHANNEL PASSWORD`; so, if the password is "changeme", and the desired channel is "#foo", send `op #foo changeme`.

```javascript
/*
	opbot.js
*/

var OPBOT_PASSWORD = "changeme";

function PRIVATE_MESSAGE_EVENT(EV_NICK,EV_USERNAME,EV_MESSAGE) {

	// Usage information
	if(EV_MESSAGE.toLowerCase()=="help"){
		msg(EV_NICK,"OpBot v1.0");
		msg(EV_NICK,"op CHANNEL PASSWORD  -  Gives channel op status with the correct password");
		return;
	}

	var tokens = EV_MESSAGE.split(" ");
	if(tokens.length >= 3){
		var cmd = tokens[0];
		var chan = tokens[1];
		var pass = tokens[2];
		if(cmd.toLowerCase()=="op"){
			if(pass==OPBOT_PASSWORD){
				set(chan,"+o",EV_NICK);
				return;
			}
		}
	}
}
```

## RainbowBot

Here's a fun bot that you can use to send a channel a rainbow message! Send a private message to the bot with a channel name followed by the message you want to send, and it'll make your message rainbow colored and send it to that channel!

```javascript
/*
	rainbowbot.js
*/

function PRIVATE_MESSAGE_EVENT(EV_NICK,EV_USERNAME,EV_MESSAGE) {

	// Usage information
	if(EV_MESSAGE.toLowerCase()=="help"){
		msg(EV_NICK,"RainbowBot v1.0");
		msg(EV_NICK,"Message me with a channel and a phrase, and I'll send a rainbow message!");
		return;
	}

	// Tokenize input
	var tokens = EV_MESSAGE.split(" ");

	// Make sure that the message has *at least* two words
	if(tokens.length >= 2){

		// Shift the first token, which should be the channel
		var channel = tokens.shift();

		// Concatonate the token array, so it's one string again
		var tosend = tokens.join(" ");

		// Tokenize the string again so it's an array of characters
		tokens = tosend.split("");

		// Make the message a rainbow!
		var rainbow = "";
		for(var i=0, len=tokens.length; i < len; i++){

			// Select random foreground and background colors
			var foreground = Math.floor((Math.random() * 15) + 1);
			var background = Math.floor((Math.random() * 15) + 1);

			// Make sure that the forebround and background colors are different
			while (foreground==background) {
			    foreground = Math.floor((Math.random() * 15) + 1);
				background = Math.floor((Math.random() * 15) + 1);
			}
			rainbow = rainbow+color(foreground,background,tokens[i]);
		}

		// Send our rainbow message!
		message(channel,bold(rainbow));
	}

}
```

# Default Configuration File

<details>

<summary>Click to view</summary>

```xml
<?xml version="1.0"?>
<!--

███████╗██╗  ██╗ █████╗ ██████╗ ████████╗██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗╚══██╔══╝██║
███████╗███████║███████║██████╔╝   ██║   ██║
╚════██║██╔══██║██╔══██║██╔══██╗   ██║   ██║
███████║██║  ██║██║  ██║██████╔╝   ██║   ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝

default.xml

This is the default configuration file for the Shabti IRC bot.

-->
<configuration>

	<!-- The IRC server to connect to. -->
	<server>localhost</server>
	<!-- The port on the IRC server to connect to. -->
	<port>6667</port>

	<!--
		The nick the IRC bot will use. Please note that there is
		 no "alternate nick" that the bot will use if the chosen nick
		 is already in use. To change the bot's nick, place code in
		 the "nick_taken_event()" to change it.
	-->
	<nick>shabti</nick>
	<!-- The username the bot will use. -->
	<username>shabti</username>
	<!-- The IRCname the bot will use. -->
	<ircname>Shabti IRC bot</ircname>

	<!-- How many "extra" events the bot will attempt to execute. -->
	<extra>10</extra>

	<!--
		For each channel the bot should join, add a "channel" child
		element with the channel name as its content. With the default
		settings, the bot will join three channels: "#foo", "#bar", and "#shabti".
	-->
	<channel>#foo</channel>
	<channel>#bar</channel>
	<channel>#shabti</channel>

	<!--
		The bot's "source code". This file should contain JavaScript, with a
		number of functions that will be executed when IRC events are
		received. Multiple script files can be loaded here; for each file to
		load, add a "script" child element with the file name as its content.
		Each loaded script will overload (replace) any function or event
		declared in previously loaded scripts.
	-->
	<script>default.js</script>

</configuration>
```

</details>

# Default Script File

<details>

<summary>Click to view</summary>

```javascript
/*

███████╗██╗  ██╗ █████╗ ██████╗ ████████╗██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗╚══██╔══╝██║
███████╗███████║███████║██████╔╝   ██║   ██║
╚════██║██╔══██║██╔══██║██╔══██╗   ██║   ██║
███████║██║  ██║██║  ██║██████╔╝   ██║   ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝

default.js

======================
| Built-in variables |
======================
SV_SERVER = The name/host of the IRC server connected to
SV_PORT = The port that the bot connected to
SV_NICK = Bot's nick
SV_USER = Bot's username
SV_IRCNAME = Bot's IRC name
SV_TIME = Server time
SV_DATE = Server date
SV_BOT = The name of the bot's software
SV_VERSION = The version of the bot's software
SV_LOCAL_DIRECTORY = The directory Shabti is installed to
SV_CONFIG_DIRECTORY = The configuration directory Shabti is using
WHITE = Color white, for use with the color() function
BLACK = Color black, for use with the color() function
BLUE = Color blue, for use with the color() function
GREEN = Color green, for use with the color() function
RED = Color red, for use with the color() function
BROWN = Color brown, for use with the color() function
PURPLE = Color purple, for use with the color() function
ORANGE = Color orange, for use with the color() function
YELLOW = Color yellow, for use with the color() function
LIGHT_GREEN = Color light green, for use with the color() function
TEAL = Color teal, for use with the color() function
CYAN = Color cyan, for use with the color() function
LIGHT_BLUE = Color light blue, for use with the color() function
PINK = Color pink, for use with the color() function
GREY = Color grey, for use with the color() function
LIGHT_GREY = Color light grey, for use with the color() function

*/

// CONNECT_EVENT()
// Executed when the bot first connects to the IRC server.
// EV_HOST = name of the server connected to
function CONNECT_EVENT(EV_HOST) {
	print("*** Connected to "+EV_HOST);
}

// NICK_TAKEN_EVENT()
// Executed if the bot's chosen nick is in use. The code below
// will change the bot's nick to "shabti" followed by a couple of
// randomly selected numbers.
function NICK_TAKEN_EVENT() {
	print("*** Nick taken. Changing to new nick");
	rnick(SV_NICK);
}

// PING_EVENT()
// Executed every time the client receives a "PING?" from the server.
// Responding to the server with "PONG" is not necessary, and is
// handled automatically by the bot.
function PING_EVENT() {
	print("*** PING? PONG!");
}

// TIME_EVENT()
// Executed every time the bot receives time information from the server.
// EV_WEEKDAY = day of the week
// EV_MONTH = name of month
// EV_DAY = day of month
// EV_YEAR = what year the server is operating in
// EV_HOUR = hour of the day (24 hour clock)
// EV_MINUTE = minute of the hour
// EV_SECOND = second of the minute
// EV_ZONE = time zone
function TIME_EVENT(EV_WEEKDAY,EV_MONTH,EV_DAY,EV_YEAR,EV_HOUR,EV_MINUTE,EV_SECOND,EV_ZONE) {
	// print("Server Time: "+EV_WEEKDAY+ " "+EV_MONTH+" "+EV_DAY+", "+EV_YEAR+" - "+EV_HOUR+":"+EV_MINUTE+":"+EV_ECOND+" ("+EV_ZONE+")");
}

// PUBLIC_MESSAGE_EVENT()
// Executed whenever the bot receives a public message.
// EV_NICK = the user who sent the message
// EV_USERNAME = the sender's username
// EV_CHANNEL = the channel the message was sent to
// EV_MESSAGE = the contents of the message
function PUBLIC_MESSAGE_EVENT(EV_NICK,EV_USERNAME,EV_CHANNEL,EV_MESSAGE) {
	print(EV_CHANNEL+" <"+EV_NICK+"> "+EV_MESSAGE);
}

// ACTION_EVENT()
// Executed whenever the bot receives an action message.
// EV_NICK = the user who sent the message
// EV_USERNAME = the sender's username
// EV_CHANNEL = the channel the message was sent to
// EV_ACTION = the contents of the action message
function ACTION_EVENT(EV_NICK,EV_USERNAME,EV_CHANNEL,EV_ACTION) {
	print(EV_CHANNEL+" *"+EV_NICK+" "+EV_ACTION+"*");
}

// PRIVATE_MESSAGE_EVENT()
// Executed whenever the bot receives a private message.
// EV_NICK = the user who sent the message
// EV_USERNAME = the sender's username
// EV_MESSAGE = the contents of the message
function PRIVATE_MESSAGE_EVENT(EV_NICK,EV_USERNAME,EV_MESSAGE) {
	print("PRIVATE >"+EV_NICK+"< "+EV_MESSAGE);
}

// MODE_EVENT()
// Executed every time the bot receives mode information from the server.
// EV_NICK = the user who set the mode; if server set the mode, the server's name
// EV_USERNAME = the username of the user; if server set the mode, this will be an empty string
// EV_TARGET = the target of the mode settings
// EV_MODE = the mode set
function MODE_EVENT(EV_NICK,EV_USERNAME,EV_TARGET,EV_MODE) {
	if(EV_USERNAME==""){
		print("*** "+EV_NICK+" sets mode "+EV_MODE+" on "+EV_TARGET);
	} else {
		print("*** "+EV_NICK+" ("+EV_USERNAME+") sets mode "+EV_MODE+" on "+EV_TARGET);
	}
}

// PART_EVENT()
// Executed every time a user leaves a channel the bot is present in.
// EV_NICK = the user who left
// EV_USERNAME = the username of the user who left
// EV_CHANNEL = the channel left
// EV_MESSAGE = the part message, if there is one; blank if not
function PART_EVENT(EV_NICK,EV_USERNAME,EV_CHANNEL,EV_MESSAGE) {
	if(EV_MESSAGE==""){
		print("*** "+EV_NICK+" ("+EV_USERNAME+") left "+EV_CHANNEL);
	} else {
		print("*** "+EV_NICK+" ("+EV_USERNAME+") left "+EV_CHANNEL+": "+EV_MESSAGE);
	}
}

// JOIN_EVENT()
// Executed every time a user joins a channel the bot is present in.
// EV_NICK = the user who joined
// EV_USERNAME = the username of the user who joined
// EV_CHANNEL = the channel joined
function JOIN_EVENT(EV_NICK,EV_USERNAME,EV_CHANNEL) {
	print("*** "+EV_NICK+" ("+EV_USERNAME+") joined "+EV_CHANNEL);
}

// IRC_EVENT()
// Executed every time *any other event* not covered by other functions is
// received by the bot.
// EV_RAW = the "raw" message sent by the server
// EV_TYPE = the message type, as defined by RFCs
// EV_HOST = the name of the server sending the message
// EV_NICK = the nick of the bot
// EV_MESSAGE = the content of the message
function IRC_EVENT(EV_RAW,EV_TYPE,EV_HOST,EV_NICK,EV_MESSAGE) {
	//print("*** "+EV_RAW);
}
```

</details>