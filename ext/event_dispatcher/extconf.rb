if RUBY_VERSION < '1.9.0'
  $LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
end

require "mkmf"

# Name your extension
extension_name = 'event_dispatcher.h'

# Set your target name
dir_config(extension_name)

$LDFLAGS += ' -framework ApplicationServices'

begin
  MACRUBY_VERSION # Only MacRuby has this constant.
  $CFLAGS += ' -fobjc-gc' # Enable MacOSX's GC for MacRuby
rescue
end

have_header(extension_name)

# Do the work
create_makefile(extension_name)
