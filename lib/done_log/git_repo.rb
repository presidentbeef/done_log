# frozen_string_literal: true

require 'fileutils'

class GitRepo
  attr_reader :git_url, :log_dir, :log_file

  def initialize git_url, log_dir, log_file
    @git_url = git_url
    @log_dir = log_dir
    @log_file = log_file
  end

  def add
    run "git add #{log_file}"
  end

  def add_remote
    return unless git_url
    return if has_remote?

    run "git remote add origin #{git_url.inspect}"
    run "git push --set-upstream origin master"
  end

  def commit
    unless run "git diff --no-patch --cached --exit-code" # Check if there are any changes
      unless run "git commit #{log_file} -m 'Update #{File.basename log_file}'"
        raise 'Could not commit update to git'
      end
    end
  end

  def has_remote?
    run "git remote -v | grep -q -F #{git_url.inspect}"
  end

  def init
    run "git init #{log_dir} -q"
  end

  def pull
    return unless git_url
    return unless has_remote?

    unless run 'git pull -q'
      raise 'Could not pull from git'
    end
  end

  def push
    return unless git_url
    add_remote
    return unless has_remote?

    unless run 'git push'
      raise 'Could not push to git'
    end
  end

  def run cmd
    FileUtils.cd(log_dir) do
      system cmd
    end
  end
end
