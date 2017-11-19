require 'yaml'

Dir.glob('lib/*.rake').each { |r| load r}
Dir.glob("lib/mailing/*.rb").each {|file| require_relative file }

@@config = YAML.load_file('config/base_config.yml')