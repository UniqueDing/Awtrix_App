import json
import requests
from bottle import route
from pyquery import PyQuery as pq

@route('/githubtrend')
def githubtrend():
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36'}
    html = requests.get('https://github.com/trending', headers = headers)
    query = pq(html.text)
    top = ''
    try:
        top = query('.Box-row').eq(0)('h1')('a').text()
    except Exception:
        pass
    dic = {
        'top' : top,
    }

    return json.dumps(dic)
