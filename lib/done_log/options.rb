# frozen_string_literal: true

require 'optparse'
require 'optparse/date'
require_relative 'ansi_colors'

module Done
  class Options
    def self.parse!(args)
      options = {}

      days = args.grep(/^-\d+$/)

      unless days.empty?
        if days.length > 1
          raise "Expected only one day, got #{days.inspect}"
        end

        days = days.first
        args.delete days
        options[:time_period] = Date.today - days.to_i.abs
        options[:action] ||= :edit
      end

      OptionParser.new do |opts|
        opts.banner = "Usage: done_log [options]"

        opts.on "-NUM", OptionParser::DecimalInteger, "Go back NUM days"

        opts.on "-e", "--edit", "Edit log(s)" do
          options[:action] = :edit
        end

        opts.on "-s", "--show", "Display log(s)" do
          options[:action] = :show
        end

        opts.on "-d", "--date [DATE]", Date, "Select date" do |date|
          options[:time_period] = date
        end

        opts.on "--sprint", "Last 14 days" do
          options[:time_period] = (Date.today - 14)..Date.today
          options[:action] ||= :show
        end

        opts.on "-c", "--color-date COLOR", Done::ANSIColors.colors, "Set color for dates" do |color|
          options[:date_color] = color.to_sym
        end

        opts.on_tail "-h", "--help", "Show this message" do
          puts opts
          exit
        end
      end.parse(args)

      default_options.merge(options)
    end

    def self.default_options
      {
        action: :edit,
        time_period: Date.today
      }
    end
  end
end
