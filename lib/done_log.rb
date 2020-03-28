# frozen_string_literal: true

require 'date'
require 'fileutils'
require 'json'
require_relative 'done_log/git_repo'
require_relative 'done_log/options'
require_relative 'done_log/ansi_colors'

class DoneLog
  attr_reader :date, :dir, :git, :log_file

  def initialize date, dir = DoneLog.default_log_dir
    @date = date
    @dir = dir
    year = date.year.to_s
    month = date.month.to_s.rjust(2, "0")
    @log_file = File.join(dir, year, month, date_string)

    config = DoneLog.config
    @git = GitRepo.new(config[:git_repo], dir, log_file)
    @color = config[:date_color]
  end

  def log
    ensure_directory
    git.pull
    create_log
    vim_edit
    strip_log
    git.add
    git.commit
    git.push
  end

  def show pull = true
    ensure_directory
    git.pull if pull

    if File.exist? log_file
      log = File.read(log_file)
      if $stdout.tty?
        puts log.sub(/^(\d{4}-\d{2}-\d{2})$/) { |date| ANSIColors.colorize(date, @color) }
      else
        puts log
      end

      puts
    else
      puts <<~LOG
      #{ANSIColors.colorize(date_string, @color)}

      [No log]

      LOG
    end
  end

  def ensure_directory
    FileUtils.mkdir_p(File.dirname(log_file))
    git.init
  end

  def create_log
    unless File.exist? log_file
      File.open(log_file, "w") do |f|
        f.puts <<~LOG
          #{date_string}
          
        LOG
      end

      git.add
    end
  end

  def strip_log
    log = File.read(log_file).strip

    if log.empty?
      File.delete(log_file)
    else
      File.open(log_file, "w") do |f|
        f.puts log
      end
    end
  end

  def vim_edit
    system 'vim',
      '+ normal Go', # Move to end of file, start new line
      '+startinsert', # Switch to insert mode
      log_file
  end

  def date_string
    date.iso8601.freeze
  end

  class << DoneLog
    def default_dir
      File.join(Dir.home, ".done").freeze
    end

    def default_log_dir
      File.join(Dir.home, ".done", "log").freeze
    end

    def logs
      Dir[self.default_dir].sort
    end

    def config config_file = default_config_file
      if File.exist? config_file
        begin
          JSON.parse(File.read(config_file), symbolize_names: true)
        rescue JSON::ParserError => e
          warn "Unable to parse config file: #{e.inspect}"
          {}
        end
      else
        FileUtils.mkdir_p(default_dir)

        config = default_config
        puts "What Git URL (e.g. git@github.com:user_name/example_log.git) should we use?\nLeave blank to skip."
        print "? "
        url = gets.strip

        unless url.empty?
          config[:git_repo] = url
        end

        File.open(config_file, "w") do |f|
          f.puts(JSON.pretty_generate(config))
        end

        config
      end
    end

    def default_config
      {
        git_repo: nil,
        date_color: :cyan
      }
    end

    def default_config_file
      File.join(default_dir, "config")
    end

    def edit_logs time_period
      if time_period.is_a? Date
        DoneLog.new(time_period).log
      else
        time_period.each do |d|
          DoneLog.new(d).log
        end
      end
    end

    def show_logs time_period
      if time_period.is_a? Date
        DoneLog.new(time_period).show
      else
        pull = true
        time_period.each do |d|
          DoneLog.new(d).show(pull)
          pull = false
        end
      end
    end
  end
end
