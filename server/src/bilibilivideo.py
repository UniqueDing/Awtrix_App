import json
import requests
from bottle import route
from pyquery import PyQuery as pq

@route('/bilibilivideo/<uid>')
def bilibilivideo(uid):
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36'}
    html = requests.get('https://www.bilibili.com/video/' + uid, headers = headers)
    query = pq(html.text)
    play_count = 0
    coin_count = 0
    like_count = 0
    collect_count = 0
    try:
        play_count = query('.video-data')('.view').text()[0:-4]
        coin_count = query('.coin').text()
        like_count = query('.like').text()
        collect_count = query('.collect').text()

        def change(str):
            if str[-1] == '万': 
                str = str[:-1] + 'w'
            return str

        play_count = change(play_count)
        coin_count = change(coin_count)
        like_count = change(like_count)
        collect_count = change(collect_count)

    except Exception as e:
        pass
    dic = {
        'play' : play_count,
        'like' : like_count,
        'coin' : coin_count,
        'collect' : collect_count
    }

    return json.dumps(dic)
    
