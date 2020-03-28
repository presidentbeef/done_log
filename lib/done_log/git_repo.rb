# frozen_string_literal: true

require 'fileutils'

module Done
  class GitRepo
    attr_reader :git_url, :log_dir, :log_file

    def initialize git_url, log_dir, log_file
      @git_url = git_url
      @log_dir = log_dir
      @log_file = log_file
    end

    def add
      unless File.empty? log_file
        run "git add #{log_file}"
      end
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
      if git_url and not Dir.exist? log_dir
        run "git clone -q #{git_url} #{log_dir}"
      else
        run "git init -q #{log_dir}"
      end
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
end
