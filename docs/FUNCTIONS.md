# Shabti Javascript Functions
* [IRC Functions](#ircfunctions)
* [Text Functions](#textfunctions)
* [File I/O Functions](#fileiofunctions)
* [Miscellaneous Functions](#miscellaneousfunctions)
    
## IRC Functions
| raw         |                  |
|-------------|------------------|
| *Arguments*   | 1 (text to send) |
| *Returns*     | Nothing          |
| *Description* |Sends "raw" text to the IRC server; that is, the bot will send the server this text without any modification.  This can be used to send IRC commands that don't have **Shabti** built-in functions to perform.  For example, to send a private message to Bob, you could use `raw("PRIVMSG Bob :Hello world!")`.  |

| set         |                  |
|-------------|------------------|
| Arguments   | 2+ (targets, flags, optional arguments) |
| Returns     | Nothing          |
| Description | * Sets a mode on the server.  For example, to give channel operator status to Bob in channel "#foo", you could use `set("#foo", "+o", "Bob")`.   |

| login         |                  |
|-------------|------------------|
| Arguments   | 2 (username, password) |
| Returns     | Nothing          |
| Description | Logs into an IRCop account.   |

| nick         |                  |
|-------------|------------------|
| Arguments   | 1 (new nick) |
| Returns     | Nothing          |
| Description | Changes the bot's nick.   |

| rnick         |                  |
|-------------|------------------|
| Arguments   | 1 (new nick) |
| Returns     | Nothing          |
| Description | Changes the bot's nick, adding two numbers to the end of the nick.   |

| join         |                  |
|-------------|------------------|
| Arguments   | 1+ (channel to join, optional password) |
| Returns     | Nothing          |
| Description | Joins a channel.   |

| part         |                  |
|-------------|------------------|
| Arguments   | 1+ (channel to part, optional parting message) |
| Returns     | Nothing          |
| Description | Parts a channel.   |

| topic         |                  |
|-------------|------------------|
| Arguments   | 2 (channel, new topic) |
| Returns     | Nothing          |
| Description | Sets a channel's topic.   |

| quit         |                  |
|-------------|------------------|
| Arguments   | 0+ (optional quit message) |
| Returns     | Nothing          |
| Description | Quits the IRC server.   |

| message         |                  |
|-------------|------------------|
| Arguments   | 2 (target user or channel, message) |
| Returns     | Nothing          |
| Description | Sends a message to the target user or channel. An identical version of this command named `msg` can alternately used.   |

| notice         |                  |
|-------------|------------------|
| Arguments   | 2 (target user or channel, message) |
| Returns     | Nothing          |
| Description | Sends a notice to the target user or channel.   |

| action         |                  |
|-------------|------------------|
| Arguments   | 12 (channel, action) |
| Returns     | Nothing          |
| Description | * Sends an action message to a channel.   |

## Text Functions
| print         |                  |
|-------------|------------------|
| Arguments   | 1+ (text to print) |
| Returns     | Nothing          |
| Description | Prints text to the console, followed by a carriage return.   |

| sprint         |                  |
|-------------|------------------|
| Arguments   | 1+ (text to print) |
| Returns     | Nothing          |
| Description | Prints text to the console; a trailing carriage return is *not* printed.   |

| color         |                  |
|-------------|------------------|
| Arguments   | 3 (foreground color, background color, text) |
| Returns     | string          |
| Description | Formats text using IRC color codes, and returns it.   |

| bold         |                  |
|-------------|------------------|
| Arguments   | 1 (text) |
| Returns     | string          |
| Description | Formats text using IRC bold code, and returns it.   |

| italic         |                  |
|-------------|------------------|
| Arguments   | 1 (text) |
| Returns     | string          |
| Description | Formats text using IRC italic code, and returns it.   |

| underline         |                  |
|-------------|------------------|
| Arguments   | 1 (text) |
| Returns     | string          |
| Description | Formats text using IRC underline code, and returns it.   |

## File I/O Functions
| read         |                  |
|-------------|------------------|
| Arguments   | 1 (file to read) |
| Returns     | string          |
| Description | Reads data from a file and returns it.   |

| write         |                  |
|-------------|------------------|
| Arguments   | 2 (filename, contents) |
| Returns     | Nothing          |
| Description | Writes data to a file, followed by a carriage return.   |

| swrite         |                  |
|-------------|------------------|
| Arguments   | 2 (filename, contents) |
| Returns     | Nothing          |
| Description | Writes data to a file; a trailing carriage return is *not* written.   |

| append         |                  |
|-------------|------------------|
| Arguments   | 2 (filename, contents) |
| Returns     | Nothing          |
| Description | Appends data to a file, followed by a carriage return.   |

| sappend         |                  |
|-------------|------------------|
| Arguments   | 2 (filename, contents) |
| Returns     | Nothing          |
| Description | Appends data to a file; a trailing carriage return is *not* written.   |

| fileexists         |                  |
|-------------|------------------|
| Arguments   | 1 (filename) |
| Returns     | boolean          |
| Description | Tests if a file exists or not.   |

| direxists         |                  |
|-------------|------------------|
| Arguments   | 1 (directory) |
| Returns     | boolean          |
| Description | Tests if a directory exists or not.   |

| mkdir         |                  |
|-------------|------------------|
| Arguments   | 1 (directory name) |
| Returns     | Nothing          |
| Description | Creates a directory.   |

| rmdir         |                  |
|-------------|------------------|
| Arguments   | 1 (directory name) |
| Returns     | Nothing          |
| Description | Deletes a directory.   |

| delete         |                  |
|-------------|------------------|
| Arguments   | 1 (filename) |
| Returns     | Nothing          |
| Description | Deletes a file.   |

## Miscellaneous Functions
| sha1         |                  |
|-------------|------------------|
| Arguments   | 1 (data) |
| Returns     | string          |
| Description | Calculates a [SHA1](https://en.wikipedia.org/wiki/SHA-1) hash and returns it.   |

| sha256         |                  |
|-------------|------------------|
| Arguments   | 1 (data) |
| Returns     | string          |
| Description | Calculates a [SHA256](https://en.wikipedia.org/wiki/SHA-2) hash and returns it.   |

| require         |                  |
|-------------|------------------|
| Arguments   | 1 (module name) |
| Returns     | Nothing          |
| Description | Loads a **Shabti** module into memory.   |

| exit         |                  |
|-------------|------------------|
| Arguments   | 0, 1 (message), or 2 (message, exit code) |
| Returns     | Nothing          |
| Description | Exits out of **Shabti**. Optionally, can display a message on exit, or an exit code (which *must* be 0 or 1).   |
