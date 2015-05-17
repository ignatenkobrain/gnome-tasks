srcs = [
  'config.vapi',
  'gnome-tasks.vala',
]

executable(
  'gnome-tasks',
  sources : srcs,
  dependencies : deps,
  c_args : '-DDATA_DIRECTORY="@0@/@1@/gnome-tasks/"'.format(
    get_option('prefix'),
    get_option('datadir')
  ),
  install : true
)
