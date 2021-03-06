import json
import requests
from bottle import route
from pyquery import PyQuery as pq

@route('/neteasemusic/<uid>')
def neteasemusic(uid):
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36'}
    html = requests.get('https://music.163.com/user/home?id=' + uid, headers = headers)
    query = pq(html.text)
    fans = 0
    music_num = 0
    try:
        fans = query('#fan_count').text()
        music_num = query('.m-record-title')('h4').text()[4:-1]
    except Exception as e:
        pass
    dic = {
        'fans' : fans,
        'music_num' : music_num
    }

    return json.dumps(dic)
