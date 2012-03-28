require "mkmf"

# Name your extension
extension_name = 'event_dispatcher'

# Set your target name
dir_config(extension_name)

$LDFLAGS += ' -framework ApplicationServices'

have_header(extension_name)

# Do the work
create_makefile(extension_name)
