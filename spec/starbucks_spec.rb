require 'yaml'

accounts = YAML.load_file('secrets.yml')

username = accounts['starbucks']['username']
password = accounts['starbucks']['password']

puts username
puts password