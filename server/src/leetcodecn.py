import json
import requests
from bottle import route


@route('/leetcodecn/<uid>')
def leetcodecn(uid):
    url = 'https://leetcode-cn.com/graphql/'
    user_url = 'https://leetcode-cn.com/u/' + uid
    headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36',
            # 'Cookie' : cookie
            'referer':user_url,
            'content-type':'application/json',
            'origin':'https://leetcode-cn.com',
            }
    # csrftoken = 'oA9vW33cLugBIoKfZGgMxMtHHUAhuDbjgTcrVS156lP5GWnsUUAHp3UYqyeXnMQt'
    data =  {"operationName":"userPublicProfile","variables":{"userSlug":uid},"query":"query userPublicProfile($userSlug: String!) {\n  userProfilePublicProfile(userSlug: $userSlug) {\n    username\n    haveFollowed\n    siteRanking\n    profile {\n      userSlug\n      realName\n      aboutMe\n      userAvatar\n      location\n      gender\n      websites\n      skillTags\n      contestCount\n      asciiCode\n      medals {\n        name\n        year\n        month\n        category\n        __typename\n      }\n      ranking {\n        rating\n        ranking\n        currentLocalRanking\n        currentGlobalRanking\n        currentRating\n        ratingProgress\n        totalLocalUsers\n        totalGlobalUsers\n        __typename\n      }\n      skillSet {\n        langLevels {\n          langName\n          langVerboseName\n          level\n          __typename\n        }\n        topics {\n          slug\n          name\n          translatedName\n          __typename\n        }\n        topicAreaScores {\n          score\n          topicArea {\n            name\n            slug\n            __typename\n          }\n          __typename\n        }\n        __typename\n      }\n      socialAccounts {\n        provider\n        profileUrl\n        __typename\n      }\n      __typename\n    }\n    educationRecordList {\n      unverifiedOrganizationName\n      __typename\n    }\n    occupationRecordList {\n      unverifiedOrganizationName\n      jobTitle\n      __typename\n    }\n    submissionProgress {\n      totalSubmissions\n      waSubmissions\n      acSubmissions\n      reSubmissions\n      otherSubmissions\n      acTotal\n      questionTotal\n      __typename\n    }\n    __typename\n  }\n}\n"}

    # cookies = {'__cfduid':'d9ce37537c705e759f6bea15fffc9c58b1525271602',
    #               '_ga':'GA1.2.5783653.1525271604',
    #               '_gid':'GA1.2.344320119.1533189808',
    #               'csrftoken':'oA9vW33cLugBIoKfZGgMxMtHHUAhuDbjgTcrVS156lP5GWnsUUAHp3UYqyeXnMQt',
    #               ' _gat':'1'}
            
    html = requests.post(url=url, headers = headers, data=json.dumps(data))
    res = json.loads(html.text)
    # print(res)
    rate_num = res['data']['userProfilePublicProfile']['siteRanking']
    access_num = res['data']['userProfilePublicProfile']['submissionProgress']['acTotal']
    dic = {
        'acs' : access_num,
        'rate' : rate_num
    }

    return json.dumps(dic)
