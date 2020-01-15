## Done

This is a dumb Ruby script to help manage daily work logs.

Keeps each day in a separate file.

Keeps the files in a Git repository.

Edits the logs via `vim`.

Trailing newlines stripped automatically from logs.

Optionally pushes to a remote Git repository.

### Installing

    gem build done_log.gemspec
    gem install done_log*.gem

### Configuration 

Logs are kept in `~/.done/log/`.

This directory is created automatically.

Configuration is read from JSON file `~/.done/config`.

A default configuration file is created automatically.

The only option right now is `git_repo` which can be set to a remote Git repository.

### Running

`done_log` edits the log for the current day.

`done_log -[N]` edits the log for the previous `N` day. `-1` is yesterday, etc.

`done_log YYYY-MM-DD` edits the log for that date.

_That's it for now._

### License

MIT
