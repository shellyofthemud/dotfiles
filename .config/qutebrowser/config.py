''' some default stuff '''
config.load_autoconfig()
c.backend = 'webengine'

# adding some search engines
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "g": "https://google.com/search?q={}",
    "aw": "https://wiki.archlinux.org/index.php?search={}"
    }

# setting some extra keys to functions
config.bind(',d', 'config-cycle --temp content.user_stylesheets ./solarized-dark-all-sites.css ""')
config.bind(',f', 'spawn --userscript qute-bitwarden')


''' load pywal configuration qutewal.py '''
config.source('qutewal.py')
