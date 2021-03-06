import json
import requests
from bottle import route
from pyquery import PyQuery as pq

@route('/zhihu/<uid>')
def zhihu(uid):
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36'}
    html = requests.get('https://www.zhihu.com/people/' + uid, headers = headers)
    query = pq(html.text)
    # print(html.text)
    answers = 0
    fans = 0
    try:
        answers = query('.ProfileMain-tabs')('li').eq(1)('.Tabs-meta').text()
        fans = query('.NumberBoard-itemValue').eq(1).attr('title')
    except Exception as e:
        pass
    dic = {
        'fans' : fans,
        'answers' : answers
    }

    return json.dumps(dic)
