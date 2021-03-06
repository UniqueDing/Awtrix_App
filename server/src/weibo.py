import json
import requests
from bottle import route
from pyquery import PyQuery as pq

@route('/weibo/<uid>')
def weibo(uid):
    LOGIN_COOKIES = 'SINAGLOBAL=522519899039.0867.1574345484645; UM_distinctid=16f5c2b0fd5388-06657092a336d8-6701b35-1fa400-16f5c2b0fd621e; SUHB=02Meot-9jOoPJy; ALF=1621327072; SUB=_2AkMploOff8NxqwJRmP4Qzm3ja4p3zA_EieKfynJEJRMxHRl-yT9kqhAJtRB6AhatcJAakTfQ4KKZBahMLkPKCqGmy6qa; SUBP=0033WrSXqPxfM72-Ws9jqgMF55529P9D9WhZH_vEymdzQfyYRooMOfCs; UOR=,,news.ifeng.com; YF-Page-G0=913e50d6fa3a3406e80cc7f737d4352f|1590646466|1590646466; _s_tentry=-; Apache=7843672000587.247.1590646468304; ULV=1590646468380:10:6:3:7843672000587.247.1590646468304:1590636352909; YF-V5-G0=4e19e5a0c5563f06026c6591dbc8029f'
    cookies2 = dict(map(lambda x: x.split('='), LOGIN_COOKIES.split(";")))
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36'}
    url='https://weibo.com/u/' + uid
    html = requests.get(url, headers = headers, cookies = cookies2)
    # print(html.text)
    fans = 0
    weibos = 0
    res_str = html.text
    try:
        pos_ = res_str.find('粉丝(')
        num_str = res_str[pos_:pos_+15]
        pos_left = num_str.find('(')
        pos_right = num_str.find(')')
        fans = num_str[pos_left+1:pos_right] #获取粉丝数

        pos2_right = res_str.find('<\\/strong><span class=\\"S_txt2\\">微博<\\/span>')
        weibos_str = res_str[pos2_right-10:pos2_right]
        pos2_left = weibos_str.find('>')+1
        weibos = weibos_str[pos2_left:]

    except Exception as e:
        pass
    dic = {
        'fans' : fans,
        'pubs' : weibos
    }

    return json.dumps(dic)
