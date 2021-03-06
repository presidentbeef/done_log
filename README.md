## Done

This is a dumb Ruby script to help manage daily work logs.

Keeps each day in a separate file.

Keeps the files in a Git repository.

Edits the logs via `vim`.

Trailing newlines stripped automatically from logs.

Optionally pushes to a remote Git repository.

### Installing

This is a Ruby program, so you'll need [a Ruby](https://www.ruby-lang.org/) first.

Via RubyGems:

    gem install done_log

From source:

    git clone https://github.com/presidentbeef/done_log.git
    gem build done_log.gemspec
    gem install done_log*.gem

### Configuration 

Logs are kept in `~/.done/log/`.

This directory is created automatically.

Configuration is read from JSON file `~/.done/config`.

A default configuration file is created automatically.

Options are:

* `git_repo` which can be set to a remote Git repository.
* `date_color` which sets the color used for dates when viewing logs.

[Possible colors listed here](https://github.com/presidentbeef/done_log/blob/master/lib/done_log/ansi_colors.rb#L4-L12),
plus they can be prefixed by `bright_`.

### Running

`done_log` edits the log for the current day.

`done_log -[N]` edits the log for the previous `N` day. `-1` is yesterday, `-2` is two days ago, etc.

`done_log -d DATE` edits the log for the specified date.

`done_log -s -d DATE` shows the specified log.

`done_log --sprint` shows the last 14 days of logs.

### Logging

#### Start a Log

To enter a log for today, run `done_log`.

To enter a log for yesterday, run `done_log -1`

To enter a log for a specific date, run `done_log -d DATE`.

#### Edit a Log

When editing, `vim` is opened to a new/existing document. When `vim` exits, the log is committed and pushed to the Git repo.

To cancel a new log, delete _everything_ in the file and save.

To cancel edits to an existing log, close `vim` without saving.

#### Review a Log

To view an existing log, use `-s` or `--show`.

Examples:

* `done_log --show --date DATE`
* `done_log -s -d DATE`
* `done_log -s -1` (Show yesterday's log)

### License

MIT
