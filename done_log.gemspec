Gem::Specification.new do |s|
  s.name = "done_log"
  s.version = "1.0.1"
  s.authors = ["Justin Collins"]

  s.summary = "Extremely simple daily log."
  s.description = "Manage very simple daily work logs in text files."
  s.homepage = "https://github.com/presidentbeef/done_log"

  s.files = ["bin/done_log", "README.md"] + Dir["lib/**/*"]
  s.executables = ["done_log"]
  s.license = "MIT"
  s.required_ruby_version = '>= 2.3.0'

  s.metadata = {
    "source_code_uri"   => "https://github.com/presidentbeef/done_log"
  }
end
