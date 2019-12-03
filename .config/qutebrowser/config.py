''' some default stuff '''
config.load_autoconfig()
c.backend = 'webengine'

''' load stylesheet solarized dark '''
config.bind(',d', 'config-cycle --temp content.user_stylesheets ./solarized-dark-all-sites.css ""')

''' load pywal configuration qutewal.py '''
config.source('qutewal.py')
